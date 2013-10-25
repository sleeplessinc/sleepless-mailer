-- phpMyAdmin SQL Dump
-- version 3.5.3
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 10, 2013 at 01:17 AM
-- Server version: 5.5.24
-- PHP Version: 5.3.17

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mailer`
--

-- --------------------------------------------------------

--
-- Table structure for table `config`
--

CREATE TABLE IF NOT EXISTS `config` (
  `setting` char(20) NOT NULL DEFAULT '',
  `value` char(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `config`
--

INSERT INTO `config` (`setting`, `value`) VALUES
('throttle', '5000'),
('chunk_size', '100'),
('pid', '29508'),
('awsaccesskeyid', 'AKIAJRNL4OT33D6INIHQ'),
('awssecretkey', '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'),
('log_level', '4');

-- --------------------------------------------------------

--
-- Table structure for table `list`
--

CREATE TABLE IF NOT EXISTS `list` (
  `email` char(100) NOT NULL DEFAULT '',
  `first` char(30) NOT NULL DEFAULT '',
  `last` char(30) NOT NULL,
  `status` char(255) NOT NULL DEFAULT '',
  `sent` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `list`
--

INSERT INTO `list` (`email`, `first`, `last`, `status`, `sent`) VALUES
('a-aaron0382@gmail.com', 'Valued', 'Customer', 'ok', '2012-12-06 01:00:02'),
('bikerzedge@hotmail.com', 'Valued', 'Customer', 'ok', '2012-12-06 01:00:07'),
('erinlynn1@gmail.com', 'Erin', 'Brown', 'ok', '2012-12-06 01:00:12'),
('Frank@motorn.com', 'Frank', 'Upton', 'ok', '2012-12-06 01:00:17'),
('frank@motorntv.com', 'Frank', 'Upton', 'ok', '2012-12-06 01:00:22'),
('gidesign.mike@gmail.com', 'Mike', 'L', 'ok', '2012-12-06 01:00:27'),
('info@gidm.com', 'Mike', 'Luke', 'ok', '2012-12-06 01:00:32'),
('info@paintballr.com', 'Mike', 'Luke', 'ok', '2012-12-06 01:00:37'),
('j@burnnsteel.com', 'Valued', 'Customer', 'ok', '2012-12-06 01:00:42'),
('joe@sleepless.com', '', '', 'ok', '2012-12-06 01:00:47'),
('johnkfisher67042@yahoo.com', 'Valued', 'Customer', 'ok', '2012-12-06 01:00:52'),
('joseph@digitaljoseph.com', 'Joseph', 'Kelly', 'ok', '2012-12-06 01:00:57'),
('kandi_turner05@yahoo.com', 'Valued', 'Customer', 'ok', '2012-12-06 01:01:02'),
('kphinney2@cox.net', 'Valued', 'Customer', 'ok', '2012-12-06 01:01:07'),
('mike@gidm.com', 'Valued', 'Customer', 'ok', '2012-12-06 01:01:12'),
('mmcarparts@aol.com', 'Valued', 'Customer', 'ok', '2012-12-06 01:01:17'),
('sales@recklesspb.com', 'Mike', 'Luke', 'ok', '2012-12-06 01:01:22'),
('summercrook@gmail.com', 'Summer', 'Crook', 'ok', '2012-12-06 01:01:27'),
('vtwincycles@cox.net', 'Valued', 'Customer', 'ok', '2012-12-06 01:01:32');

-- --------------------------------------------------------

--
-- Table structure for table `mailings`
--

CREATE TABLE IF NOT EXISTS `mailings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(255) NOT NULL DEFAULT '',
  `enabled` int(1) NOT NULL DEFAULT '0',
  `subject` char(255) NOT NULL DEFAULT '',
  `from` char(255) NOT NULL DEFAULT '',
  `html` text NOT NULL,
  `text` text NOT NULL,
  `started` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `finished` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `num_processed` int(11) NOT NULL DEFAULT '0',
  `num_ok` int(11) NOT NULL DEFAULT '0',
  `num_fails` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `mailings`
--

INSERT INTO `mailings` (`id`, `name`, `enabled`, `subject`, `from`, `html`, `text`, `started`, `finished`, `num_processed`, `num_ok`, `num_fails`) VALUES
(1, 'test mailing', 0, 'This is ONLY a test!', 'Motorn.com <accounts@motorn.com>', '\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml">\n<head>\n<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />\n<title>Motorn Test email</title>\n<style>\n body{\n	 font-family:Calibri;\n	 }\n .container{\n	 margin:20px auto;\n	 width:800px;\n }\n p{\n	font-size:12px;\n	}\n h1{\n	 font-size:20px;\n }\n	h1 a{\n	 color:#cc0000;\n	 text-decoration:none;\n }\n h1 a:hover{\n	 text-decoration:underline;\n }\n</style>\n</head>\n\n<body>\n\n<div class="container">\n\n<h1>Hello from <font style="font-size:30px;"><a href="http://motorn.com">motorn.com</a></font></h1>\n<p>We are in the process or testing for our new website''s soft launch | currently scheduled for the end of December 2012. Please stop in and check us out at <a href="http://facebook.com/motorncom">Motorn.com</a>. Our site is a vast trading post for car enthusiasts, collectors and mechanics alike. Search over 500 cities across the US and soon all over the planet. Post or Search for anything and everything in over 70 categories ranging from Antique Collector Cars, RVs and Motorcycles to Crate Motors, Used Parts & Repair Services.</p>\n\n\n<a href="http://motorn.com"><img src="http://blog.motorn.com/mailer/dec/msl122012.jpg" /></a>\n<br  />\n\nContact us to learn about our advertising packages through <a href="mailto:advertising@motorn.com">advertising@motorn.com</a><br />\n<a href="http://facebook.com/motorncom"><img src="http://blog.motorn.com/mailer/dec/facebook.gif" /></a><a href="http://blog.motorn.com"><img src="http://blog.motorn.com/mailer/dec/motornblog.gif" /></a>\n<p>If you no longer wish to receive alert emails from us, please click here.</p>\n</div>\n\n\n\n\n\n</body>\n</html>\n', 'This is a plaintext version of the same email which can be set up separately.', '2012-12-06 01:00:01', '2012-12-06 01:01:36', 19, 19, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
