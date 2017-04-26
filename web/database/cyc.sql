-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 26, 2017 at 09:24 AM
-- Server version: 10.1.19-MariaDB
-- PHP Version: 5.6.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cyc`
--

-- --------------------------------------------------------

--
-- Table structure for table `achievement`
--

CREATE TABLE `achievement` (
  `achievementID` int(11) NOT NULL,
  `moduleID` int(11) NOT NULL,
  `achievementName` varchar(100) NOT NULL,
  `achievementDescription` text NOT NULL,
  `imagePath` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `achievement`
--

INSERT INTO `achievement` (`achievementID`, `moduleID`, `achievementName`, `achievementDescription`, `imagePath`) VALUES
(1, 1, 'Part 1', 'Begin Part One.', 'resource/placeholder1.png'),
(2, 1, 'Part 2', 'Begin Part Two.', 'resource/placeholder1.png'),
(3, 1, '*Beephole*', 'Complete Ransome''s Flashback.', 'resource/placeholder1.png'),
(4, 1, 'Out Of The Will', 'Complete Delores''s Flashback.', 'resource/placeholder1.png'),
(5, 1, 'Great Escape', 'Escape from the sewers.', 'resource/placeholder1.png'),
(6, 1, 'Part 3', 'Begin Part Three.', 'resource/placeholder1.png'),
(7, 1, 'Secret Meeting', 'Complete Franklin''s Flashback.', 'resource/placeholder1.png'),
(8, 1, 'Dust Appreciator', 'Collect 25 specks of dust.', 'resource/placeholder1.png'),
(9, 1, 'Part 4', 'Begin Part Four.', 'resource/placeholder1.png'),
(10, 1, 'Justice', 'Catch the killer.', 'resource/placeholder1.png'),
(11, 1, 'Hotel Tourist', 'Visited every floor in the hotel.', 'resource/placeholder1.png'),
(12, 1, 'Dust Collector', 'Collect 50 specks of dust.', 'resource/placeholder1.png'),
(13, 1, 'Sky High', 'Get an alive character into the Hotel penthouse.', 'resource/placeholder1.png'),
(14, 1, 'Hard Won', 'Complete the game in hard mode.', 'resource/placeholder1.png'),
(15, 1, 'Well Informed', 'Read all the Thimbleweed Nickel newspapers.', 'resource/placeholder1.png'),
(16, 1, 'Dust Hoarder', 'Collected 75 specks of dust.', 'resource/placeholder1.png'),
(17, 1, 'Easy Win', 'Complete the game in casual mode.', 'resource/placeholder1.png'),
(18, 1, 'Book WOrm', 'Read 100 books in the library', 'resource/placeholder1.png'),
(19, 1, 'No One is Home', 'Listen to 100 voicemail messages.', 'resource/placeholder1.png'),
(20, 2, 'Supporter', 'Support a young start-up. Buy the game.', 'resource/placeholder1.png'),
(21, 2, 'Good Judgement', 'Create a game with a good topic/genre combination.', 'resource/placeholder1.png'),
(22, 2, '100k Engine', 'Invest over 100K in a new game engine.', 'resource/placeholder1.png'),
(23, 2, 'Famous', 'Hire someone famous.', 'resource/placeholder1.png'),
(24, 2, 'Cult Status', 'Set a new standard for the early gaming industry.', 'resource/placeholder1.png'),
(25, 2, 'Professional', 'Reach level 5 with a character.', 'resource/placeholder1.png'),
(26, 2, 'Gold', 'Sell half a million copies of a game without the help of a publisher.', 'resource/placeholder1.png'),
(27, 2, 'Diversity', 'Have male and female staff.', 'resource/placeholder1.png'),
(28, 2, '500K Engine', 'Invest over 500K in a new game engine.', 'resource/placeholder1.png'),
(29, 2, 'Platinum', 'Sell one million copies of a game without the help of a publisher.', 'resource/placeholder1.png'),
(30, 2, '1M', 'Invest over one million in a new game engine.', 'resource/placeholder1.png'),
(31, 2, 'Full House', 'Have the maximum number of employees.', 'resource/placeholder1.png'),
(32, 2, 'Versatile', 'Release a successful game in each of the five main genres.', 'resource/placeholder1.png'),
(33, 2, 'Game Dev Tycoon', 'Finish Game Dev Tycoon.', 'resource/placeholder1.png'),
(34, 2, 'Diamond', 'Sell ten million copies of a game without the help of a publisher.', 'resource/placeholder1.png'),
(35, 2, 'Perfect Game', 'Release a game with a clean score of 10.', 'resource/placeholder1.png'),
(36, 3, 'Obristan Token', 'Collect the hidden Obristan Token.', 'resource/placeholder1.png'),
(37, 3, 'Antegria Token', 'Collect the hidden Antegria Token.', 'resource/placeholder1.png'),
(38, 3, 'Arstotzka Token', 'Collect the hidden Arstotzka Token.', 'resource/placeholder1.png'),
(39, 3, 'Impor Token', 'Collect the hidden Impor Token.', 'resource/placeholder1.png'),
(40, 3, 'Kolechia Token', 'Collect the hidden Kolechia Token.', 'resource/placeholder1.png'),
(41, 3, 'United Federation Token', 'Collect the hidden United Federation Token.', 'resource/placeholder1.png'),
(42, 3, 'Republia Token', 'Collect the hidden Republia Token.', 'resource/placeholder1.png'),
(43, 4, 'Peaceful Nap', 'Take a Nap.', 'resource/placeholder1.png'),
(44, 4, 'Victim', 'Dead.', 'resource/placeholder1.png'),
(45, 4, 'Game Modder', 'Mod the Game.', 'resource/placeholder1.png'),
(46, 4, 'Upper Floor', 'Visit upper floor.', 'resource/placeholder1.png'),
(47, 4, 'Grim Reaper', 'Dead.', 'resource/placeholder1.png'),
(48, 4, 'Secret Room', 'Found the secret room.', 'resource/placeholder1.png'),
(49, 4, 'Special Treat', 'Found the secret food.', 'resource/placeholder1.png'),
(50, 4, 'Fishing Master', 'Caught HUGE fish.', 'resource/placeholder1.png'),
(51, 4, 'Full of Life', 'Finish the game without losing any HP.', 'resource/placeholder1.png'),
(52, 4, 'Camera', 'Take a picture.', 'resource/placeholder1.png'),
(53, 5, 'Carve it into your soul, kid! LOVE BLASTER!', 'Complete Torimi cafe story.', 'resource/placeholder1.png'),
(54, 5, 'It''s a sad thing...', 'Get Bad Ending.', 'resource/placeholder1.png'),
(55, 5, 'What May Come', 'Get Kazuaki ending.', 'resource/placeholder1.png'),
(56, 5, 'Dream''s End', 'Get Nageki ending.', 'resource/placeholder1.png'),
(57, 5, 'While it lasts', 'Get Ryouta ending.', 'resource/placeholder1.png'),
(58, 5, 'Into the Night', 'Get Sakuya ending.', 'resource/placeholder1.png'),
(59, 5, 'Yuuya Only Lives Twice', 'Get Yuuya Ending.', 'resource/placeholder1.png'),
(60, 5, 'Song of the Foolish Bird', 'Get Sakuya full ending.', 'resource/placeholder1.png'),
(61, 5, 'The Happy Couple', 'Get Shuu ending.', 'resource/placeholder1.png'),
(62, 5, 'A Pudding Odyssey', 'Get Okosan full ending.', 'resource/placeholder1.png'),
(63, 5, 'Until next time!', 'Get Okosan ending.', 'resource/placeholder1.png'),
(64, 5, 'To the End of Emptiness', 'Get Anghel ending.', 'resource/placeholder1.png'),
(65, 5, 'To be the True Java Sparrow', 'Get Azami ending.', 'resource/placeholder1.png'),
(66, 5, 'Such Beautiful Eyes You Have', 'Get Shuu ending.', 'resource/placeholder1.png'),
(67, 5, 'I''ll be waiting...', 'Get BBL ending.', 'resource/placeholder1.png'),
(68, 5, '...at the Dawn', 'Get the BBL epilogue.', 'resource/placeholder1.png');

-- --------------------------------------------------------

--
-- Table structure for table `genre`
--

CREATE TABLE `genre` (
  `moduleID` int(11) NOT NULL,
  `genre` varchar(100) NOT NULL
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

CREATE TABLE `module` (
  `moduleID` int(11) NOT NULL,
  `moduleVersion` varchar(100) NOT NULL,
  `moduleName` varchar(100) NOT NULL,
  `moduleDescription` text NOT NULL,
  `thumbnailPath` varchar(500) NOT NULL,
  `releaseTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastEdited` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `module`
--

INSERT INTO `module` (`moduleID`, `moduleVersion`, `moduleName`, `moduleDescription`, `thumbnailPath`, `releaseTime`, `lastEdited`) VALUES
(1, '1.1', 'Thimbleweed Park', 'In Thimbleweed Park, a dead body is the least of your problems. Switch between five playable characters to uncover the surreal secrets of this strange town in a modern mystery adventure game from the creators of Monkey Island and Maniac Mansion. The deeper you go, the weirder it gets.', 'module/1/thumbnail.jpg', '2017-04-04 08:00:00', '2017-04-04 13:33:02'),
(2, '1.0', 'Game Dev Tycoon', 'In Game Dev Tycoon you replay the history of the gaming industry by starting your own video game development company in the 80s. Create best selling games. Research new technologies and invent new game types. Become the leader of the market and gain worldwide fans.', 'module/2/thumbnail.jpg', '2017-04-04 09:48:14', '2017-04-04 13:33:10'),
(3, '1.2', 'Papers, Please', 'Congratulations. The October labor lottery is complete. Your name was pulled. For immediate placement, report to the Ministry of Admission at Grestin Border Checkpoint. An apartment will be provided for you and your family in East Grestin. Expect a Class-8 dwelling.', 'module/3/thumbnail.jpg', '2017-04-04 08:10:00', '2017-04-04 13:33:18'),
(4, '1.0', 'Bad Dream: Coma', 'Welcome in Bad Dream: Coma. A point&click game where unique minimalistic art style creates an unforgettable and atmospheric experience. Travel through the surreal and disturbing dreamland where everything depends on your actions. You can''t die but you can suffer greatly...', 'module/4/thumbnail.jpg', '2017-04-04 09:55:20', '2017-04-04 13:33:25'),
(5, '1.0', 'Hatoful Boyfriend', 'Congratulations! You’ve been accepted as the only human student at the prestigious St. PigeoNation’s Institute, a school for talented birds! Roam the halls and find love in between classes as a sophomore student at the world’s greatest pigeon high school.', 'module/5/thumbnail.jpg', '2017-04-04 09:57:36', '2017-04-04 09:57:36');

-- --------------------------------------------------------

--
-- Table structure for table `moduleimages`
--

CREATE TABLE `moduleimages` (
  `moduleID` int(11) NOT NULL,
  `imagePath` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `modulerequirement`
--

CREATE TABLE `modulerequirement` (
  `requirementID` int(11) NOT NULL,
  `moduleID` int(11) NOT NULL,
  `requirement` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `moduleshareddata`
--

CREATE TABLE `moduleshareddata` (
  `moduleID` int(11) NOT NULL,
  `mKey` varchar(100) NOT NULL,
  `mValue` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `moduleuserdata`
--

CREATE TABLE `moduleuserdata` (
  `moduleID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `mKey` varchar(100) NOT NULL,
  `mValue` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `moduleuserdata`
--

INSERT INTO `moduleuserdata` (`moduleID`, `userID`, `mKey`, `mValue`) VALUES
(1, 1, 'progress', '25'),
(2, 1, 'progress', '10'),
(1, 1, 'score', '1000'),
(1, 2, 'score', '500'),
(1, 3, 'score', '750'),
(1, 4, 'score', '1250'),
(1, 5, 'score', '1750');

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `postID` int(11) NOT NULL,
  `threadID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `openingPost` tinyint(1) DEFAULT NULL,
  `message` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`postID`, `threadID`, `userID`, `openingPost`, `message`, `timestamp`) VALUES
(1, 1, 1, 1, 'Welcome to CYC Forum!<br><br>\nForum rules:<br>\n1. No Spam, keep you posts clean as possible.<br>\n2. No Porn, warez, or other illegal content.<br>\n3. Forums categorized by topics, create your thread in appropriate forum.<br><br>\nI will keep adding rules later on.', '2017-04-04 05:47:54'),
(2, 1, 2, 0, 'Hi! trainer1 here, nice to meet you guys.', '2017-04-04 05:48:36'),
(3, 1, 3, 0, 'hello, trainer2 here', '2017-04-04 05:49:21'),
(4, 1, 4, 0, 'trainer3 was here', '2017-04-04 05:49:48'),
(5, 1, 10, 0, 'hi there!', '2017-04-04 05:59:44'),
(6, 2, 1, 1, 'What you guys think?', '2017-04-04 06:03:39'),
(7, 2, 2, 1, 'Can you post tutorial how to make it?', '2017-04-04 06:04:16'),
(8, 2, 1, 1, 'Soon™', '2017-04-04 06:04:53'),
(9, 3, 6, 1, 'can''t progress, some button unclickable, need help!', '2017-04-04 06:10:31'),
(10, 3, 1, 0, 'some button still placeholder, just ignore it', '2017-04-04 06:11:25'),
(11, 4, 10, 1, 'my progress is gone, need help!', '2017-04-04 06:30:32'),
(12, 4, 1, 0, 'I will look at it later', '2017-04-04 06:31:03'),
(13, 5, 2, 1, 'some kind of mystery murder thingie', '2017-04-04 06:42:17'),
(14, 5, 10, 0, 'with decent storyline, perhaps?', '2017-04-04 06:42:49'),
(15, 6, 8, 1, 'title', '2017-04-04 07:39:04'),
(16, 6, 3, 0, 'this thread and your life is', '2017-04-04 07:40:20'),
(17, 6, 9, 0, 'ooooooooooooooooooooo', '2017-04-04 07:40:50'),
(18, 7, 3, 1, 'planning to buy one, how do they feel? are they last long?', '2017-04-04 07:50:41'),
(19, 7, 1, 0, 'depends on the switch type, try find one with cherry/gateron/topre switch', '2017-04-04 07:47:51'),
(20, 7, 10, 0, 'I bought vortex pok3r a year ago and still works like charm. Mechanical keyboards is quite durable as long you give it maintenance properly.', '2017-04-04 07:50:01'),
(21, 8, 9, 1, 'just wondering', '2017-04-05 04:30:58'),
(22, 5, 1, 0, 'Hello', '2017-04-26 04:32:39'),
(23, 5, 1, 0, '<p>asdasdasdasd</p>', '2017-04-26 04:37:21'),
(24, 5, 1, 0, '<p>btw anime was a mistake</p><p><img src="http://i3.kym-cdn.com/photos/images/facebook/000/916/071/aa6.jpg" style="width: 600px;"><br></p>', '2017-04-26 04:38:25'),
(25, 5, 1, 0, '<blockquote><p>btw anime was a mistake</p><p><img src="http://i3.kym-cdn.com/photos/images/facebook/000/916/071/aa6.jpg" style="width: 600px;"></p></blockquote><p>Fight me bro</p>', '2017-04-26 04:39:19');

-- --------------------------------------------------------

--
-- Table structure for table `thread`
--

CREATE TABLE `thread` (
  `threadID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `threadTitle` varchar(100) NOT NULL,
  `threadType` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `thread`
--

INSERT INTO `thread` (`threadID`, `userID`, `threadTitle`, `threadType`) VALUES
(1, 1, 'Welcome to CYC, read the forum rules', 'other'),
(2, 1, 'First module launched, let''s discuss it here!', 'discussion'),
(3, 6, '[game1] Can''t progress need help!', 'bug'),
(4, 10, '[game1] my progress is gone help plz', 'bug'),
(5, 2, 'got new idea for module, what you guys think?', 'discussion'),
(6, 8, 'Post your awful one line joke here', 'funny'),
(7, 3, 'mechanical keyboard, good or nah?', 'other'),
(8, 9, 'has science gone too far', 'funny');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userID` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` char(64) NOT NULL,
  `email` varchar(100) NOT NULL,
  `userType` varchar(100) NOT NULL,
  `receiveUpdates` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userID`, `username`, `password`, `email`, `userType`, `receiveUpdates`) VALUES
(1, 'admin', '02c828262fc9a955df850b99d5983c4f2356b8d1', 'andree.yosua@gmail.com', 'admin', 0),
(2, 'trainer1', 'b2e98ad6f6eb8508dd6a14cfa704bad7f05f6fb1', 'trainer1@email.com', 'trainer', 0),
(3, 'trainer2', 'b2e98ad6f6eb8508dd6a14cfa704bad7f05f6fb1', 'trainer2@email.com', 'trainer', 0),
(4, 'trainer3', 'b2e98ad6f6eb8508dd6a14cfa704bad7f05f6fb1', 'trainer3@email.com', 'trainer', 0),
(5, 'trainer4', 'b2e98ad6f6eb8508dd6a14cfa704bad7f05f6fb1', 'trainer4@email.com', 'trainer', 0),
(6, 'player1', 'b2e98ad6f6eb8508dd6a14cfa704bad7f05f6fb1', 'player1@email.com', 'player', 0),
(7, 'player2', 'b2e98ad6f6eb8508dd6a14cfa704bad7f05f6fb1', 'player2@email.com', 'player', 0),
(8, 'player3', 'b2e98ad6f6eb8508dd6a14cfa704bad7f05f6fb1', 'player3@email.com', 'player', 0),
(9, 'player4', 'b2e98ad6f6eb8508dd6a14cfa704bad7f05f6fb1', 'player4@email.com', 'player', 0),
(10, 'player5', 'b2e98ad6f6eb8508dd6a14cfa704bad7f05f6fb1', 'player5@email.com', 'player', 0),
(11, 'asdf123', '02c828262fc9a955df850b99d5983c4f2356b8d1', 'user@domain.com', 'player', 0);

-- --------------------------------------------------------

--
-- Table structure for table `userachievement`
--

CREATE TABLE `userachievement` (
  `userID` int(11) NOT NULL,
  `achievementID` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userachievement`
--

INSERT INTO `userachievement` (`userID`, `achievementID`, `time`) VALUES
(1, 1, '2017-04-14 11:25:41'),
(1, 2, '2017-04-14 11:25:41');

-- --------------------------------------------------------

--
-- Table structure for table `usermodulerequirement`
--

CREATE TABLE `usermodulerequirement` (
  `requirementID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `message` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `usertransaction`
--

CREATE TABLE `usertransaction` (
  `transactionID` int(11) NOT NULL,
  `transactionType` varchar(100) NOT NULL,
  `userID` int(11) NOT NULL,
  `targetID` int(11) NOT NULL,
  `message` varchar(100) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `views`
--

CREATE TABLE `views` (
  `userID` int(11) NOT NULL,
  `moduleID` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `views`
--

INSERT INTO `views` (`userID`, `moduleID`, `time`) VALUES
(1, 1, '2017-04-04 10:44:18'),
(1, 2, '2017-04-04 10:44:18'),
(1, 3, '2017-04-04 10:44:18'),
(1, 4, '2017-04-04 10:44:18'),
(1, 5, '2017-04-04 10:44:18'),
(2, 1, '2017-04-04 10:44:18'),
(2, 2, '2017-04-04 10:44:18'),
(3, 1, '2017-04-04 10:44:18'),
(3, 5, '2017-04-04 10:44:18'),
(4, 1, '2017-04-04 10:44:18'),
(4, 2, '2017-04-04 10:44:18'),
(4, 3, '2017-04-04 10:44:18'),
(4, 5, '2017-04-04 10:44:18'),
(5, 3, '2017-04-04 10:44:18'),
(6, 2, '2017-04-04 10:44:18'),
(6, 3, '2017-04-04 10:44:18'),
(7, 1, '2017-04-04 10:44:18'),
(7, 3, '2017-04-04 10:44:18'),
(8, 5, '2017-04-04 10:44:18'),
(9, 1, '2017-04-04 10:44:18'),
(9, 2, '2017-04-04 10:44:18'),
(9, 5, '2017-04-04 10:44:18'),
(10, 2, '2017-04-04 10:44:18'),
(10, 5, '2017-04-04 10:44:18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `achievement`
--
ALTER TABLE `achievement`
  ADD PRIMARY KEY (`achievementID`,`moduleID`),
  ADD KEY `fk_achievement_module1_idx` (`moduleID`);

--
-- Indexes for table `genre`
--
ALTER TABLE `genre`
  ADD PRIMARY KEY (`moduleID`,`genre`),
  ADD KEY `fk_genre_module1_idx` (`moduleID`);

--
-- Indexes for table `module`
--
ALTER TABLE `module`
  ADD PRIMARY KEY (`moduleID`,`moduleVersion`);

--
-- Indexes for table `moduleimages`
--
ALTER TABLE `moduleimages`
  ADD PRIMARY KEY (`moduleID`,`imagePath`),
  ADD KEY `fk_moduleimages_module1_idx` (`moduleID`);

--
-- Indexes for table `modulerequirement`
--
ALTER TABLE `modulerequirement`
  ADD PRIMARY KEY (`requirementID`),
  ADD KEY `fk_modulerequirement_module1_idx` (`moduleID`);

--
-- Indexes for table `moduleshareddata`
--
ALTER TABLE `moduleshareddata`
  ADD PRIMARY KEY (`moduleID`),
  ADD KEY `fk_moduleshareddata_module1_idx` (`moduleID`);

--
-- Indexes for table `moduleuserdata`
--
ALTER TABLE `moduleuserdata`
  ADD PRIMARY KEY (`mKey`,`userID`,`moduleID`),
  ADD KEY `fk_moduleuserdata_module1_idx` (`moduleID`),
  ADD KEY `fk_moduleuserdata_user1_idx` (`userID`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`postID`),
  ADD KEY `fk_post_thread1_idx` (`threadID`),
  ADD KEY `fk_post_user1_idx` (`userID`);

--
-- Indexes for table `thread`
--
ALTER TABLE `thread`
  ADD PRIMARY KEY (`threadID`),
  ADD KEY `fk_thread_user1_idx` (`userID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userID`);

--
-- Indexes for table `userachievement`
--
ALTER TABLE `userachievement`
  ADD PRIMARY KEY (`userID`,`achievementID`),
  ADD KEY `fk_userachievement_user1_idx` (`userID`),
  ADD KEY `fk_userachievement_achievement1_idx` (`achievementID`);

--
-- Indexes for table `usermodulerequirement`
--
ALTER TABLE `usermodulerequirement`
  ADD PRIMARY KEY (`requirementID`,`userID`),
  ADD KEY `fk_usermodulerequirement_user1_idx` (`userID`),
  ADD KEY `fk_usermodulerequirement_modulerequirement1_idx` (`requirementID`);

--
-- Indexes for table `usertransaction`
--
ALTER TABLE `usertransaction`
  ADD PRIMARY KEY (`transactionID`),
  ADD KEY `fk_usertransaction_user1_idx` (`userID`);

--
-- Indexes for table `views`
--
ALTER TABLE `views`
  ADD PRIMARY KEY (`userID`,`moduleID`,`time`),
  ADD KEY `fk_views_module1_idx` (`moduleID`),
  ADD KEY `fk_views_user1_idx` (`userID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `achievement`
--
ALTER TABLE `achievement`
  MODIFY `achievementID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;
--
-- AUTO_INCREMENT for table `module`
--
ALTER TABLE `module`
  MODIFY `moduleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `modulerequirement`
--
ALTER TABLE `modulerequirement`
  MODIFY `requirementID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `postID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT for table `thread`
--
ALTER TABLE `thread`
  MODIFY `threadID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `usertransaction`
--
ALTER TABLE `usertransaction`
  MODIFY `transactionID` int(11) NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `achievement`
--
ALTER TABLE `achievement`
  ADD CONSTRAINT `fk_achievement_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `genre`
--
ALTER TABLE `genre`
  ADD CONSTRAINT `fk_genre_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `moduleimages`
--
ALTER TABLE `moduleimages`
  ADD CONSTRAINT `fk_moduleimages_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `modulerequirement`
--
ALTER TABLE `modulerequirement`
  ADD CONSTRAINT `fk_modulerequirement_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `moduleshareddata`
--
ALTER TABLE `moduleshareddata`
  ADD CONSTRAINT `fk_moduleshareddata_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `moduleuserdata`
--
ALTER TABLE `moduleuserdata`
  ADD CONSTRAINT `fk_moduleuserdata_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_moduleuserdata_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `fk_post_thread1` FOREIGN KEY (`threadID`) REFERENCES `thread` (`threadID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_post_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `thread`
--
ALTER TABLE `thread`
  ADD CONSTRAINT `fk_thread_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `userachievement`
--
ALTER TABLE `userachievement`
  ADD CONSTRAINT `fk_userachievement_achievement1` FOREIGN KEY (`achievementID`) REFERENCES `achievement` (`achievementID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_userachievement_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `usermodulerequirement`
--
ALTER TABLE `usermodulerequirement`
  ADD CONSTRAINT `fk_usermodulerequirement_modulerequirement1` FOREIGN KEY (`requirementID`) REFERENCES `modulerequirement` (`requirementID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usermodulerequirement_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `usertransaction`
--
ALTER TABLE `usertransaction`
  ADD CONSTRAINT `fk_usertransaction_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `views`
--
ALTER TABLE `views`
  ADD CONSTRAINT `fk_views_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_views_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
