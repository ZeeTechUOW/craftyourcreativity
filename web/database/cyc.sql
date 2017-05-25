-- phpMyAdmin SQL Dump
-- version 4.1.12
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: May 25, 2017 at 08:16 AM
-- Server version: 5.6.16
-- PHP Version: 5.5.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `cyc`
--

-- --------------------------------------------------------

--
-- Table structure for table `achievement`
--

CREATE TABLE IF NOT EXISTS `achievement` (
  `achievementID` int(11) NOT NULL AUTO_INCREMENT,
  `moduleID` int(11) NOT NULL,
  `achievementName` varchar(100) NOT NULL,
  `achievementDescription` text NOT NULL,
  PRIMARY KEY (`achievementID`,`moduleID`),
  KEY `fk_achievement_module1_idx` (`moduleID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=85 ;

--
-- Dumping data for table `achievement`
--

INSERT INTO `achievement` (`achievementID`, `moduleID`, `achievementName`, `achievementDescription`) VALUES
(1, 1, 'You Smort', 'Went through the Investigation phase.');

-- --------------------------------------------------------

--
-- Table structure for table `genre`
--

CREATE TABLE IF NOT EXISTS `genre` (
  `moduleID` int(11) NOT NULL,
  `genre` varchar(100) NOT NULL,
  PRIMARY KEY (`moduleID`,`genre`),
  KEY `fk_genre_module1_idx` (`moduleID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `module`
--

CREATE TABLE IF NOT EXISTS `module` (
  `moduleID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `moduleName` varchar(100) NOT NULL,
  `moduleDescription` text NOT NULL,
  `releaseTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `lastEdited` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`moduleID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Dumping data for table `module`
--

INSERT INTO `module` (`moduleID`, `userID`, `moduleName`, `moduleDescription`, `releaseTime`, `lastEdited`) VALUES
(1, 1, 'Final Twist Off', 'Take control of 3 different characters and discover the truth of the mysterious murder, your decisions will shape the ending of the story.', '2017-05-02 06:51:02', '2017-05-25 05:46:54');

-- --------------------------------------------------------

--
-- Table structure for table `moduleenddata`
--

CREATE TABLE IF NOT EXISTS `moduleenddata` (
  `moduleID` int(11) NOT NULL,
  `endData` varchar(100) NOT NULL,
  PRIMARY KEY (`moduleID`,`endData`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `moduleuserdata`
--

CREATE TABLE IF NOT EXISTS `moduleuserdata` (
  `moduleID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `mKey` varchar(100) NOT NULL,
  `mValue` varchar(100) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`mKey`,`userID`,`moduleID`,`timestamp`),
  KEY `fk_moduleuserdata_module1_idx` (`moduleID`),
  KEY `fk_moduleuserdata_user1_idx` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE IF NOT EXISTS `post` (
  `postID` int(11) NOT NULL AUTO_INCREMENT,
  `threadID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `openingPost` tinyint(1) DEFAULT NULL,
  `message` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`postID`),
  KEY `fk_post_thread1_idx` (`threadID`),
  KEY `fk_post_user1_idx` (`userID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=40 ;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`postID`, `threadID`, `userID`, `openingPost`, `message`, `timestamp`) VALUES
(1, 1, 1, 1, 'Welcome to CYC Forum!<br><br>\nForum rules:<br>\n1. No Spam, keep you posts clean as possible.<br>\n2. No Porn, warez, or other illegal content.<br>\n3. Forums categorized by topics, create your thread in appropriate forum.<br><br>\nI will keep adding rules later on.', '2017-04-04 05:47:54');

-- --------------------------------------------------------

--
-- Table structure for table `postuserdata`
--

CREATE TABLE IF NOT EXISTS `postuserdata` (
  `postID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `mKey` varchar(100) NOT NULL,
  `mValue` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`postID`,`userID`,`mKey`),
  KEY `userID` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `thread`
--

CREATE TABLE IF NOT EXISTS `thread` (
  `threadID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `threadTitle` varchar(100) NOT NULL,
  `threadType` varchar(100) NOT NULL,
  PRIMARY KEY (`threadID`),
  KEY `fk_thread_user1_idx` (`userID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Dumping data for table `thread`
--

INSERT INTO `thread` (`threadID`, `userID`, `threadTitle`, `threadType`) VALUES
(1, 1, 'Welcome to CYC, read the forum rules', 'general');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` char(64) NOT NULL,
  `email` varchar(100) NOT NULL,
  `userType` varchar(100) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `organization` varchar(100) NOT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=30 ;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userID`, `username`, `password`, `email`, `userType`, `fullname`, `organization`) VALUES
(-1, 'Anonymous', 'nopassword', 'no@email.here', 'player', 'No Name', 'Null'),
(1, 'admin', '459ff8ddc3d877b86573aa391746824c9c1d5c9a', 'andree.yosua@gmail.com', 'admin', 'The Admin', 'cyc');

-- --------------------------------------------------------

--
-- Table structure for table `userachievement`
--

CREATE TABLE IF NOT EXISTS `userachievement` (
  `userID` int(11) NOT NULL,
  `achievementID` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userID`,`achievementID`),
  KEY `fk_userachievement_user1_idx` (`userID`),
  KEY `fk_userachievement_achievement1_idx` (`achievementID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `userfacebook`
--

CREATE TABLE IF NOT EXISTS `userfacebook` (
  `userID` int(11) NOT NULL,
  `facebookID` varchar(100) NOT NULL,
  PRIMARY KEY (`userID`,`facebookID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `usertwitter`
--

CREATE TABLE IF NOT EXISTS `usertwitter` (
  `userID` int(11) NOT NULL,
  `twitterID` varchar(100) NOT NULL,
  PRIMARY KEY (`userID`,`twitterID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `views`
--

CREATE TABLE IF NOT EXISTS `views` (
  `userID` int(11) NOT NULL DEFAULT '0',
  `moduleID` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userID`,`moduleID`,`time`),
  KEY `fk_views_module1_idx` (`moduleID`),
  KEY `fk_views_user1_idx` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `achievement`
--
ALTER TABLE `achievement`
  ADD CONSTRAINT `fk_achievement_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `genre`
--
ALTER TABLE `genre`
  ADD CONSTRAINT `fk_genre_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `moduleenddata`
--
ALTER TABLE `moduleenddata`
  ADD CONSTRAINT `moduleenddata_ibfk_1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `moduleuserdata`
--
ALTER TABLE `moduleuserdata`
  ADD CONSTRAINT `fk_moduleuserdata_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_moduleuserdata_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `fk_post_thread1` FOREIGN KEY (`threadID`) REFERENCES `thread` (`threadID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_post_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `postuserdata`
--
ALTER TABLE `postuserdata`
  ADD CONSTRAINT `postuserdata_ibfk_1` FOREIGN KEY (`postID`) REFERENCES `post` (`postID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `postuserdata_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `thread`
--
ALTER TABLE `thread`
  ADD CONSTRAINT `fk_thread_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userachievement`
--
ALTER TABLE `userachievement`
  ADD CONSTRAINT `fk_userachievement_achievement1` FOREIGN KEY (`achievementID`) REFERENCES `achievement` (`achievementID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_userachievement_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userfacebook`
--
ALTER TABLE `userfacebook`
  ADD CONSTRAINT `userfacebook_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `usertwitter`
--
ALTER TABLE `usertwitter`
  ADD CONSTRAINT `usertwitter_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `views`
--
ALTER TABLE `views`
  ADD CONSTRAINT `fk_views_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
