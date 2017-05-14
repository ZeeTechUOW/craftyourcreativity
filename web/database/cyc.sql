-- phpMyAdmin SQL Dump
-- version 4.1.12
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: May 14, 2017 at 06:07 AM
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
(1, 1, 'Part 1', 'Begin Part One. 2'),
(2, 1, 'Part 2', 'Begin Part Two.'),
(3, 1, '*Beephole*', 'Complete Ransome''s Flashback.'),
(4, 1, 'Out Of The Will', 'Complete Delores''s Flashback.'),
(5, 1, 'Great Escape', 'Escape from the sewers.'),
(6, 1, 'Part 3', 'Begin Part Three.'),
(7, 1, 'Secret Meeting', 'Complete Franklin''s Flashback.'),
(8, 1, 'Dust Appreciator', 'Collect 25 specks of dust.'),
(9, 1, 'Part 4', 'Begin Part Four.'),
(10, 1, 'Justice', 'Catch the killer.'),
(11, 1, 'Hotel Tourist', 'Visited every floor in the hotel.'),
(12, 1, 'Dust Collector', 'Collect 50 specks of dust.'),
(13, 1, 'Sky High', 'Get an alive character into the Hotel penthouse.'),
(14, 1, 'Hard Won', 'Complete the game in hard mode.'),
(15, 1, 'Well Informed', 'Read all the Thimbleweed Nickel newspapers.'),
(16, 1, 'Dust Hoarder', 'Collected 75 specks of dust.'),
(17, 1, 'Easy Win', 'Complete the game in casual mode.'),
(18, 1, 'Book WOrm', 'Read 100 books in the library'),
(19, 1, 'No One is Home', 'Listen to 100 voicemail messages.'),
(20, 2, 'Supporter', 'Support a young start-up. Buy the game.'),
(21, 2, 'Good Judgement', 'Create a game with a good topic/genre combination.'),
(22, 2, '100k Engine', 'Invest over 100K in a new game engine.'),
(23, 2, 'Famous', 'Hire someone famous.'),
(24, 2, 'Cult Status', 'Set a new standard for the early gaming industry.'),
(25, 2, 'Professional', 'Reach level 5 with a character.'),
(26, 2, 'Gold', 'Sell half a million copies of a game without the help of a publisher.'),
(27, 2, 'Diversity', 'Have male and female staff.'),
(28, 2, '500K Engine', 'Invest over 500K in a new game engine.'),
(29, 2, 'Platinum', 'Sell one million copies of a game without the help of a publisher.'),
(30, 2, '1M', 'Invest over one million in a new game engine.'),
(31, 2, 'Full House', 'Have the maximum number of employees.'),
(32, 2, 'Versatile', 'Release a successful game in each of the five main genres.'),
(33, 2, 'Game Dev Tycoon', 'Finish Game Dev Tycoon.'),
(34, 2, 'Diamond', 'Sell ten million copies of a game without the help of a publisher.'),
(35, 2, 'Perfect Game', 'Release a game with a clean score of 10.'),
(37, 3, 'Antegria Token 1111', 'Collect the hidden Antegria Token.'),
(38, 3, 'Arstotzka Token', 'Collect the hidden Arstotzka Token.'),
(39, 3, 'Impor Token', 'Collect the hidden Impor Token.'),
(40, 3, 'Kolechia Token', 'Collect the hidden Kolechia Token.'),
(41, 3, 'United Federation Token', 'Collect the hidden United Federation Token.'),
(42, 3, 'Republia Token', 'Collect the hidden Republia Token.'),
(43, 4, 'Peaceful Nap', 'Take a Nap.'),
(44, 4, 'Victim', 'Dead.'),
(45, 4, 'Game Modder', 'Mod the Game.'),
(46, 4, 'Upper Floor', 'Visit upper floor.'),
(47, 4, 'Grim Reaper', 'Dead.'),
(48, 4, 'Secret Room', 'Found the secret room.'),
(49, 4, 'Special Treat', 'Found the secret food.'),
(50, 4, 'Fishing Master', 'Caught HUGE fish.'),
(51, 4, 'Full of Life', 'Finish the game without losing any HP.'),
(52, 4, 'Camera', 'Take a picture.'),
(53, 5, 'Carve it into your soul, kid! LOVE BLASTER!', 'Complete Torimi cafe story xD.'),
(54, 5, 'It''s a sad thing...', 'Get Bad Ending.'),
(55, 5, 'What May Come', 'Get Kazuaki ending.'),
(56, 5, 'Dream''s End', 'Get Nageki ending.'),
(57, 5, 'While it lasts', 'Get Ryouta ending.'),
(58, 5, 'Into the Night', 'Get Sakuya ending.'),
(59, 5, 'Yuuya Only Lives Twice', 'Get Yuuya Ending.'),
(60, 5, 'Song of the Foolish Bird', 'Get Sakuya full ending.'),
(61, 5, 'The Happy Couple', 'Get Shuu ending.'),
(62, 5, 'A Pudding Odyssey', 'Get Okosan full ending.'),
(63, 5, 'Until next time!', 'Get Okosan ending.'),
(64, 5, 'To the End of Emptiness', 'Get Anghel ending.'),
(65, 5, 'To be the True Java Sparrow', 'Get Azami ending.'),
(66, 5, 'Such Beautiful Eyes You Have', 'Get Shuu ending.'),
(67, 5, 'I''ll be waiting...', 'Get BBL ending.'),
(68, 5, '...at the Dawn', 'Get the BBL epilogue.'),
(82, 21, 'You Smort', 'Went through the Investigation phase.'),
(83, 21, 'awdawdaw', 'afaffa\r\n'),
(84, 21, 'awdawdaw', 'afaffa\r\n');

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

--
-- Dumping data for table `genre`
--

INSERT INTO `genre` (`moduleID`, `genre`) VALUES
(1, 'Adventure'),
(1, 'Mystery'),
(1, 'Puzzle'),
(2, 'Difficult'),
(2, 'Economy'),
(2, 'Management'),
(2, 'Simulation'),
(3, 'Difficult'),
(3, 'Political'),
(3, 'Puzzle'),
(3, 'Simulation'),
(4, 'Adventure'),
(4, 'Horror'),
(4, 'Puzzle'),
(5, 'Comedy'),
(5, 'Dating Sim'),
(5, 'Romance'),
(5, 'Story Rich'),
(5, 'Visual Novel');

-- --------------------------------------------------------

--
-- Table structure for table `module`
--

CREATE TABLE IF NOT EXISTS `module` (
  `moduleID` int(11) NOT NULL AUTO_INCREMENT,
  `moduleVersion` varchar(100) NOT NULL,
  `userID` int(11) NOT NULL,
  `moduleName` varchar(100) NOT NULL,
  `moduleDescription` text NOT NULL,
  `releaseTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `lastEdited` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`moduleID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Dumping data for table `module`
--

INSERT INTO `module` (`moduleID`, `moduleVersion`, `userID`, `moduleName`, `moduleDescription`, `releaseTime`, `lastEdited`) VALUES
(1, '', 1, 'Thimbleweed Park', 'In Thimbleweed Park, a dead body is the least of your problems. Switch between five playable characters to uncover the surreal secrets of this strange town in a modern mystery adventure game from the creators of Monkey Island and Maniac Mansion. The deeper you go, the weirder it gets.', '2017-04-04 08:00:00', '2017-04-30 06:10:20'),
(2, '', 1, 'Game Dev Tycoon', 'In Game Dev Tycoon you replay the history of the gaming industry by starting your own video game development company in the 80s. Create best selling games. Research new technologies and invent new game types. Become the leader of the market and gain worldwide fans.', '2017-04-04 09:48:14', '2017-05-01 08:13:54'),
(3, '', 1, 'Papers, Please', 'Congratulations. The October labor lottery is complete. Your name was pulled. For immediate placement, report to the Ministry of Admission at Grestin Border Checkpoint. An apartment will be provided for you and your family in East Grestin. Expect a Class-8 dwelling.', NULL, '2017-04-30 06:12:19'),
(4, '', 1, 'Bad Dream: Coma', 'Welcome in Bad Dream: Coma. A point&click game where unique minimalistic art style creates an unforgettable and atmospheric experience. Travel through the surreal and disturbing dreamland where everything depends on your actions. You can''t die but you can suffer greatly...', '2017-04-04 09:55:20', '2017-05-01 08:13:57'),
(5, '', 1, 'Hatoful Boyfriend', 'Congratulations! You’ve been accepted as the only human student at the prestigious St. PigeoNation’s Institute, a school for talented birds! Roam the halls and find love in between classes as a sophomore student at the world’s greatest pigeon high school.', '2017-05-02 02:03:19', '2017-05-02 06:43:13'),
(21, '', 17, 'Final Twist Off', 'Take control of 3 different characters and discover the truth of the mysterious murder, your decisions will shape the ending of the story.', '2017-05-02 06:51:02', '2017-05-02 08:15:14');

-- --------------------------------------------------------

--
-- Table structure for table `moduleenddata`
--

CREATE TABLE IF NOT EXISTS `moduleenddata` (
  `moduleID` int(11) NOT NULL,
  `endData` varchar(100) NOT NULL,
  PRIMARY KEY (`moduleID`,`endData`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `moduleenddata`
--

INSERT INTO `moduleenddata` (`moduleID`, `endData`) VALUES
(1, 'counter'),
(1, 'timeLimit');

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

--
-- Dumping data for table `moduleuserdata`
--

INSERT INTO `moduleuserdata` (`moduleID`, `userID`, `mKey`, `mValue`, `timestamp`) VALUES
(1, 1, 'lstate', 'like', '0000-00-00 00:00:00'),
(21, 1, 'lstate', 'like', '2017-05-13 18:37:36'),
(1, 1, 'score', '1000', '2017-05-13 18:37:36'),
(21, 17, 'score', '20', '2017-05-13 18:37:36'),
(21, 21, 'score', '20', '2017-05-13 18:37:36');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=39 ;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`postID`, `threadID`, `userID`, `openingPost`, `message`, `timestamp`) VALUES
(1, 1, 1, 1, 'Welcome to CYC Forum!<br><br>\nForum rules:<br>\n1. No Spam, keep you posts clean as possible.<br>\n2. No Porn, warez, or other illegal content.<br>\n3. Forums categorized by topics, create your thread in appropriate forum.<br><br>\nI will keep adding rules later on.', '2017-04-04 05:47:54'),
(6, 2, 1, 1, 'What you guys think?', '2017-04-04 06:03:39'),
(8, 2, 1, 1, 'Soon™', '2017-04-04 06:04:53'),
(27, 11, 1, 1, 'just something', '2017-04-29 05:22:05'),
(28, 12, 1, 1, '<p>wwwwww</p>', '2017-05-01 01:47:42'),
(29, 12, 1, 0, '<p>awdad</p>', '2017-05-01 01:47:58'),
(30, 13, 1, 1, '<p>ajaocnocnoawc</p>', '2017-05-01 02:20:10'),
(31, 14, 1, 1, '<p>acccccs</p>', '2017-05-01 02:23:35'),
(34, 16, 17, 1, '<p>This is NOT your property. Why is this on this website is beyond me.</p><p><br></p><p>We are currently speaking to our lawyer and we''ll see if we can take this to court.</p><p>See you when we see you!</p>', '2017-05-01 14:28:37'),
(35, 2, 17, 0, '<p><font face="Arial">cool but have you seen </font><font face="Comic Sans MS">Chef</font><font face="Arial"> tho?</font></p>', '2017-05-01 14:30:47'),
(36, 16, 1, 0, '<p>Please don''t sir. I have wife and kids.</p>', '2017-05-01 23:16:39'),
(37, 16, 19, 0, '<blockquote><p style="color: rgb(51, 51, 51); font-size: 14px; background-color: rgb(184, 202, 181);">This is NOT your property. Why is this on this website is beyond me.</p><p style="color: rgb(51, 51, 51); font-size: 14px; background-color: rgb(184, 202, 181);"><br></p><p style="color: rgb(51, 51, 51); font-size: 14px; background-color: rgb(184, 202, 181);">We are currently speaking to our lawyer and we''ll see if we can take this to court.</p><p style="margin-bottom: 10px; color: rgb(51, 51, 51); font-size: 14px; background-color: rgb(184, 202, 181);">See you when we see you!</p></blockquote><p style="margin-bottom: 10px; color: rgb(51, 51, 51); font-size: 14px; background-color: rgb(184, 202, 181);">Just a prank bro, chill.</p>', '2017-05-02 04:16:01'),
(38, 17, 22, 1, '<p>thoughts?</p>', '2017-05-02 08:13:22');

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

--
-- Dumping data for table `postuserdata`
--

INSERT INTO `postuserdata` (`postID`, `userID`, `mKey`, `mValue`) VALUES
(27, 1, 'lstate', 'like'),
(29, 1, 'lstate', 'dislike'),
(34, 1, 'lstate', 'dislike'),
(34, 20, 'lstate', 'like'),
(34, 21, 'lstate', 'like'),
(36, 1, 'lstate', 'dislike'),
(37, 19, 'lstate', 'like');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `thread`
--

INSERT INTO `thread` (`threadID`, `userID`, `threadTitle`, `threadType`) VALUES
(1, 1, 'Welcome to CYC, read the forum rules', 'general'),
(2, 1, 'First module launched, let''s discuss it here!', 'discussion'),
(9, 1, 'Asd', 'general'),
(10, 1, 'asdasasda', 'general'),
(11, 1, 'Add like and dislike in module', 'discussion'),
(12, 1, 'awdadwad', 'general'),
(13, 1, 'plz help', 'module_Game Dev Tycoon'),
(14, 1, 'acacacac', 'module_Thimbleweed Park'),
(16, 17, 'Copyright infringement', 'module_Game Dev Tycoon'),
(17, 22, 'is this a demo?', 'general');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userID`, `username`, `password`, `email`, `userType`, `fullname`, `organization`) VALUES
(-1, 'Anonymous', 'nopassword', 'no@email.here', 'player', 'No Name', 'Null'),
(1, 'admin', '459ff8ddc3d877b86573aa391746824c9c1d5c9a', 'andree.yosua@gmail.com', 'admin', 'The Admin', 'cyc'),
(17, 'Metakaku', 'f58cf5e7e10f195e21b553096d092c763ed18b0e', 'mharitsa@gmail.com', 'trainer', 'Met Akaku', 'James Ketjap Tomat'),
(18, 'maniman', 'f58cf5e7e10f195e21b553096d092c763ed18b0e', 'JeanneDucx@gmail.com', 'player', 'M Animan', 'James Ketjap Tomat'),
(19, 'superpenguin', '02c828262fc9a955df850b99d5983c4f2356b8d1', 'andree.yosua@gmail.com', 'player', 'Sup Erp. Enguin', 'James Ketjap Tomat'),
(20, 'Bijukaku', 'f58cf5e7e10f195e21b553096d092c763ed18b0e', 'asdf@gmail.com', 'player', 'Bi Jukaku', 'James Ketjap Tomat'),
(21, 'TzarMoraei', 'f58cf5e7e10f195e21b553096d092c763ed18b0e', 'mharitsa@gmail.com', 'player', 'Tzar Moraei', 'James Ketjap Tomat'),
(22, 'john', 'f58cf5e7e10f195e21b553096d092c763ed18b0e', 'john@gmail.com', 'player', 'Jonjon', 'James Ketjap Tomat');

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

--
-- Dumping data for table `userachievement`
--

INSERT INTO `userachievement` (`userID`, `achievementID`, `time`) VALUES
(1, 1, '2017-04-14 11:25:41'),
(1, 2, '2017-04-14 11:25:41'),
(1, 53, '2017-05-02 02:00:35'),
(17, 82, '2017-05-02 05:04:44'),
(21, 82, '2017-05-02 05:29:13');

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
  `twitterID` int(11) NOT NULL,
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
-- Dumping data for table `views`
--

INSERT INTO `views` (`userID`, `moduleID`, `time`) VALUES
(-1, 1, '2017-05-11 08:04:40'),
(1, 1, '2017-04-04 10:44:18'),
(1, 1, '2017-05-01 14:55:08'),
(1, 1, '2017-05-11 09:07:38'),
(1, 1, '2017-05-12 01:27:11'),
(1, 1, '2017-05-12 01:37:46'),
(1, 1, '2017-05-14 03:41:55'),
(1, 1, '2017-05-14 03:42:26'),
(-1, 2, '2017-05-11 08:04:46'),
(-1, 2, '2017-05-11 09:25:10'),
(-1, 2, '2017-05-11 09:25:11'),
(-1, 2, '2017-05-11 09:25:32'),
(-1, 2, '2017-05-11 09:26:04'),
(-1, 2, '2017-05-11 09:26:21'),
(-1, 2, '2017-05-11 09:26:32'),
(-1, 2, '2017-05-11 09:26:55'),
(-1, 2, '2017-05-11 09:26:58'),
(-1, 2, '2017-05-11 09:27:41'),
(-1, 2, '2017-05-11 09:27:45'),
(-1, 2, '2017-05-11 09:28:04'),
(-1, 2, '2017-05-11 09:29:05'),
(-1, 2, '2017-05-11 09:29:23'),
(-1, 2, '2017-05-11 09:29:36'),
(-1, 2, '2017-05-11 09:30:00'),
(-1, 2, '2017-05-11 09:30:25'),
(-1, 2, '2017-05-11 09:30:49'),
(-1, 2, '2017-05-11 09:31:23'),
(-1, 2, '2017-05-11 09:31:33'),
(-1, 2, '2017-05-11 09:31:37'),
(-1, 2, '2017-05-11 09:31:54'),
(-1, 2, '2017-05-11 09:32:16'),
(-1, 2, '2017-05-11 09:32:34'),
(-1, 2, '2017-05-12 01:26:58'),
(1, 2, '2017-04-04 10:44:18'),
(1, 2, '2017-05-01 09:42:01'),
(1, 2, '2017-05-11 08:04:24'),
(1, 3, '2017-04-04 10:44:18'),
(1, 3, '2017-04-30 09:00:43'),
(1, 4, '2017-04-04 10:44:18'),
(1, 4, '2017-04-30 10:17:46'),
(17, 4, '2017-05-01 14:31:23'),
(-1, 5, '2017-05-11 05:57:15'),
(1, 5, '2017-04-04 10:44:18'),
(1, 5, '2017-05-02 01:59:14'),
(1, 5, '2017-05-02 02:07:16'),
(1, 5, '2017-05-11 09:44:16'),
(20, 5, '2017-05-02 05:26:23'),
(21, 5, '2017-05-02 05:42:29'),
(-1, 21, '2017-05-11 05:56:06'),
(-1, 21, '2017-05-11 06:07:01'),
(-1, 21, '2017-05-11 06:07:53'),
(-1, 21, '2017-05-11 06:08:01'),
(-1, 21, '2017-05-11 06:08:11'),
(-1, 21, '2017-05-11 06:08:27'),
(-1, 21, '2017-05-11 06:08:51'),
(-1, 21, '2017-05-11 06:08:59'),
(-1, 21, '2017-05-11 06:26:12'),
(-1, 21, '2017-05-11 06:26:28'),
(1, 21, '2017-05-02 05:34:14'),
(1, 21, '2017-05-11 09:40:49'),
(1, 21, '2017-05-11 09:40:51'),
(1, 21, '2017-05-11 09:40:55'),
(1, 21, '2017-05-11 09:40:58'),
(1, 21, '2017-05-11 09:41:52'),
(1, 21, '2017-05-11 09:41:55'),
(1, 21, '2017-05-11 09:42:47'),
(1, 21, '2017-05-11 09:42:51'),
(1, 21, '2017-05-11 09:43:33'),
(1, 21, '2017-05-11 09:43:46'),
(1, 21, '2017-05-11 09:43:58'),
(17, 21, '2017-05-02 01:58:01'),
(17, 21, '2017-05-02 05:03:05'),
(17, 21, '2017-05-02 05:48:08'),
(17, 21, '2017-05-02 06:06:05'),
(17, 21, '2017-05-02 06:17:22'),
(17, 21, '2017-05-02 08:18:34'),
(17, 21, '2017-05-03 09:55:34'),
(21, 21, '2017-05-02 05:27:53'),
(21, 21, '2017-05-02 05:41:18');

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
  ADD CONSTRAINT `fk_views_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_views_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
