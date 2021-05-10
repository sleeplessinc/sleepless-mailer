/*

Copyright 2016 Sleepless Software Inc. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE. 

*/

var nodemailer = require('nodemailer'),
    fs = require("fs"),
    pathlib = require("path"),
	util = require("util");

var log = require("log5").mkLog("mailer:")
log(5)
log(2, "Starting");


function p10(v) { return parseInt(v, 10) || 0 }

var dump = function(o) { log(5, util.inspect(o)); }

var exit = process.exit;

process.on('SIGINT', function () {
	log(4, 'SIGINT received');
	exit(1);
});



// set up mysql connection
var mysql      = require('mysql');
var db = mysql.createConnection({
	host     : 'localhost',
	user     : 'mailer',
	password : 'password',
	database : 'mailer',
});


var chunkSize = 100;	// number of addresses processed at a time.
var throttle = 5000;	// delay between sending each email in milliseconds


// Create Amazon SES transport object
var transport = nodemailer.createTransport("SES", {
	AWSAccessKeyID: "replace_with_your_access_key",	
	AWSSecretKey: "replace_with_your_secret_key",
});

/*
// optional DKIM signing
transport.useDKIM({
	domainName: "do-not-trust.node.ee", // signing domain
	keySelector: "dkim", // selector name (in this case there's a dkim._domainkey.do-not-trust.node.ee TXT record set up)
	privateKey: fs.readFileSync(pathlib.join(__dirname,"test_private.pem"))
});
*/


// send the mailing to one "chunk" of addresses
function sendChunk(mailing) {
	log(5, "sendChunk()");

	var sql = "select email, first, last from list where status='' limit "+chunkSize
	db.query(sql, function(err, addrs) {
		if(err) throw err;

		var numToSend = addrs.length;
		log(5, "numToSend="+numToSend);

		function send1() {

			if(addrs.length == 0) {
				log(4, "chunk complete");

				if(numToSend == chunkSize) {
					// it was a full chunk.  There are likely more, so just
					// exit and when we're restarted we'll do another chunk.
					exit(0);
				}

				// we've completed the final chunk.
				// there are no more addresses in db that haven't been sent
				// set the timestamp of when we finished and disable the mailing.
				log(3, "Mailing complete");
				sql = "update mailings set finished=now(), enabled=0 where id="+mailing.id;
				db.query(sql, function(err) {
					if(err) throw err;
					exit(0);
				});

				return;
			}

			// actually send the the email via SES
			var recip = addrs.shift();
			var email = recip.email
			mailing.to = '"'+recip.first+" "+recip.last+'" <'+email+'>'
			transport.sendMail(mailing, function(err) {

				sql = "update list set sent=now() where email='"+email+"'";
				db.query(sql);

				sql = "update mailings set num_processed=num_processed+1 where id="+mailing.id;
				db.query(sql);

				if(err) {
					sql = "update list set status='fail' where email='"+email+"'";
					db.query(sql);

					sql = "update mailings set num_fails=num_fails+1 where id="+mailing.id;
					db.query(sql);

					log(3, "FAIL "+email+": "+err.message);
					return;
				}

				sql = "update list set status='ok' where email='"+email+"'";
				db.query(sql);

				sql = "update mailings set num_ok=num_ok+1 where id="+mailing.id;
				db.query(sql);

				log(3, "OK "+email);
			});

			setTimeout(send1, throttle);		// send another in "throttle" millis
		}

		send1();

	})
}


function resetMailing(mailing) {
	log(3, "reset mailing: "+mailing.name);

	// make all addresses "unsent"
	db.query("update list set status=''", function(err, addrs) {
		if(err) throw err;

		// reset stats and settings in mailing
		db.query("update mailings set started=now(), finished=0, num_processed=0, num_ok=0, num_fails=0 where id="+mailing.id+" limit 1", function(err) {
			if(err) throw err;
			sendChunk(mailing);
		})
	})

}


// select one mailing from db
function getMailing() {
	var sql = "select *, unix_timestamp(finished) as uts_fin from mailings where enabled = 1 limit 1";
	db.query(sql, function(err, mailings) {
		if(err) { throw err };

		if(mailings.length < 1) {
			log(3, "No active mailings.");
			exit(0);
			return;
		}

		var mailing = mailings[0]
		log(3, "chose to work on mailing: "+mailing.name);

		if(mailing.uts_fin == 0) {
			sendChunk(mailing);
		}
		else {
			resetMailing(mailing);
		}

	});
}


// Send CTRL-C to any currently running versions of myself
db.query("select value from config where setting='pid' limit 1", function(err, rec) {
	if(err) throw err;

	var opid = p10(rec[0].value);
	if(opid > 1) {
		try {
			log(5, "Sending CTRL-C to PID "+opid);
			process.kill(opid, "SIGINT");
		} catch(e) { log(5, "no old process "+opid); }
	}

	// put my own PID into the db so subsequent runs can kill me in turn
	db.query("update config set value="+process.pid+" where setting='pid' limit 1", function(err) {
		if(err) throw err;

		getMailing();
	});
});




