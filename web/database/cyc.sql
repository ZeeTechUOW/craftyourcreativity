-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: 01 Mei 2017 pada 04.38
-- Versi Server: 5.6.35
-- PHP Version: 5.6.29

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
-- Struktur dari tabel `achievement`
--

CREATE TABLE `achievement` (
  `achievementID` int(11) NOT NULL,
  `moduleID` int(11) NOT NULL,
  `achievementName` varchar(100) NOT NULL,
  `achievementDescription` text NOT NULL,
  `imagePath` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `achievement`
--

INSERT INTO `achievement` (`achievementID`, `moduleID`, `achievementName`, `achievementDescription`, `imagePath`) VALUES
(1, 1, 'Part 1', 'Begin Part One. 2', 'resource/placeholder1.png'),
(2, 1, 'Part 2', 'Begin Part Two.', 'resource/placeholder1.png'),
(3, 1, '*Beephole*', 'Complete Ransome\'s Flashback.', 'resource/placeholder1.png'),
(4, 1, 'Out Of The Will', 'Complete Delores\'s Flashback.', 'resource/placeholder1.png'),
(5, 1, 'Great Escape', 'Escape from the sewers.', 'resource/placeholder1.png'),
(6, 1, 'Part 3', 'Begin Part Three.', 'resource/placeholder1.png'),
(7, 1, 'Secret Meeting', 'Complete Franklin\'s Flashback.', 'resource/placeholder1.png'),
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
(37, 3, 'Antegria Token 1111', 'Collect the hidden Antegria Token.', 'resource/placeholder1.png'),
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
(54, 5, 'It\'s a sad thing...', 'Get Bad Ending.', 'resource/placeholder1.png'),
(55, 5, 'What May Come', 'Get Kazuaki ending.', 'resource/placeholder1.png'),
(56, 5, 'Dream\'s End', 'Get Nageki ending.', 'resource/placeholder1.png'),
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
(67, 5, 'I\'ll be waiting...', 'Get BBL ending.', 'resource/placeholder1.png'),
(68, 5, '...at the Dawn', 'Get the BBL epilogue.', 'resource/placeholder1.png');

-- --------------------------------------------------------

--
-- Struktur dari tabel `genre`
--

CREATE TABLE `genre` (
  `moduleID` int(11) NOT NULL,
  `genre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `genre`
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
-- Struktur dari tabel `module`
--

CREATE TABLE `module` (
  `moduleID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `moduleVersion` varchar(100) NOT NULL,
  `moduleName` varchar(100) NOT NULL,
  `moduleDescription` text NOT NULL,
  `releaseTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `lastEdited` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `module`
--

INSERT INTO `module` (`moduleID`, `userID`, `moduleVersion`, `moduleName`, `moduleDescription`, `releaseTime`, `lastEdited`) VALUES
(1, 1, '1.1', 'Thimbleweed Park', 'In Thimbleweed Park, a dead body is the least of your problems. Switch between five playable characters to uncover the surreal secrets of this strange town in a modern mystery adventure game from the creators of Monkey Island and Maniac Mansion. The deeper you go, the weirder it gets.', '2017-04-04 08:00:00', '2017-04-30 06:10:20'),
(2, 1, '1.0', 'Game Dev Tycoon', 'In Game Dev Tycoon you replay the history of the gaming industry by starting your own video game development company in the 80s. Create best selling games. Research new technologies and invent new game types. Become the leader of the market and gain worldwide fans.', '2017-04-04 09:48:14', '2017-05-01 08:13:54'),
(3, 1, '1.2', 'Papers, Please', 'Congratulations. The October labor lottery is complete. Your name was pulled. For immediate placement, report to the Ministry of Admission at Grestin Border Checkpoint. An apartment will be provided for you and your family in East Grestin. Expect a Class-8 dwelling.', NULL, '2017-04-30 06:12:19'),
(4, 1, '1.0', 'Bad Dream: Coma', 'Welcome in Bad Dream: Coma. A point&click game where unique minimalistic art style creates an unforgettable and atmospheric experience. Travel through the surreal and disturbing dreamland where everything depends on your actions. You can\'t die but you can suffer greatly...', '2017-04-04 09:55:20', '2017-05-01 08:13:57'),
(5, 1, '1.0', 'Hatoful Boyfriend', 'Congratulations! You’ve been accepted as the only human student at the prestigious St. PigeoNation’s Institute, a school for talented birds! Roam the halls and find love in between classes as a sophomore student at the world’s greatest pigeon high school.', '2017-04-04 09:57:36', '2017-05-01 08:14:00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `moduleimages`
--

CREATE TABLE `moduleimages` (
  `moduleID` int(11) NOT NULL,
  `imagePath` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `moduleimages`
--

INSERT INTO `moduleimages` (`moduleID`, `imagePath`) VALUES
(1, 'resource/avates.png'),
(1, 'resource/avates1.png'),
(1, 'resource/avates2.png'),
(2, 'resource/avates.png'),
(2, 'resource/avates1.png'),
(3, 'resource/avates.png'),
(3, 'resource/avates2.png'),
(4, 'resource/avates1.png'),
(4, 'resource/avates2.png'),
(5, 'resource/avates.png');

-- --------------------------------------------------------

--
-- Struktur dari tabel `modulerequirement`
--

CREATE TABLE `modulerequirement` (
  `requirementID` int(11) NOT NULL,
  `moduleID` int(11) NOT NULL,
  `requirement` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `moduleshareddata`
--

CREATE TABLE `moduleshareddata` (
  `moduleID` int(11) NOT NULL,
  `mKey` varchar(100) NOT NULL,
  `mValue` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `moduleuserdata`
--

CREATE TABLE `moduleuserdata` (
  `moduleID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `mKey` varchar(100) NOT NULL,
  `mValue` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `moduleuserdata`
--

INSERT INTO `moduleuserdata` (`moduleID`, `userID`, `mKey`, `mValue`) VALUES
(1, 1, 'progress', '25'),
(2, 1, 'progress', '10'),
(1, 1, 'score', '1000');

-- --------------------------------------------------------

--
-- Struktur dari tabel `post`
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
-- Dumping data untuk tabel `post`
--

INSERT INTO `post` (`postID`, `threadID`, `userID`, `openingPost`, `message`, `timestamp`) VALUES
(1, 1, 1, 1, 'Welcome to CYC Forum!<br><br>\nForum rules:<br>\n1. No Spam, keep you posts clean as possible.<br>\n2. No Porn, warez, or other illegal content.<br>\n3. Forums categorized by topics, create your thread in appropriate forum.<br><br>\nI will keep adding rules later on.', '2017-04-04 05:47:54'),
(6, 2, 1, 1, 'What you guys think?', '2017-04-04 06:03:39'),
(8, 2, 1, 1, 'Soon™', '2017-04-04 06:04:53'),
(27, 11, 1, 1, 'just something', '2017-04-29 05:22:05'),
(28, 12, 1, 1, '<p>wwwwww</p>', '2017-05-01 01:47:42'),
(29, 12, 1, 0, '<p>awdad</p>', '2017-05-01 01:47:58'),
(30, 13, 1, 1, '<p>ajaocnocnoawc</p>', '2017-05-01 02:20:10'),
(31, 14, 1, 1, '<p>acccccs</p>', '2017-05-01 02:23:35');

-- --------------------------------------------------------

--
-- Struktur dari tabel `thread`
--

CREATE TABLE `thread` (
  `threadID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `threadTitle` varchar(100) NOT NULL,
  `threadType` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `thread`
--

INSERT INTO `thread` (`threadID`, `userID`, `threadTitle`, `threadType`) VALUES
(1, 1, 'Welcome to CYC, read the forum rules', 'general'),
(2, 1, 'First module launched, let\'s discuss it here!', 'module'),
(9, 1, 'Asd', 'general'),
(10, 1, 'asdasasda', 'general'),
(11, 1, 'Add like and dislike in module', 'module'),
(12, 1, 'awdadwad', 'General'),
(13, 1, 'plz help', 'discussion_Game Dev Tycoon'),
(14, 1, 'acacacac', 'discussion_Thimbleweed Park');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
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
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`userID`, `username`, `password`, `email`, `userType`, `receiveUpdates`) VALUES
(1, 'admin', '323b95680b62f4a75e7fcf06e4d9036a63a1d418', 'andree.yosua@gmail.com', 'admin', 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `userachievement`
--

CREATE TABLE `userachievement` (
  `userID` int(11) NOT NULL,
  `achievementID` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `userachievement`
--

INSERT INTO `userachievement` (`userID`, `achievementID`, `time`) VALUES
(1, 1, '2017-04-14 11:25:41'),
(1, 2, '2017-04-14 11:25:41');

-- --------------------------------------------------------

--
-- Struktur dari tabel `usermodulerequirement`
--

CREATE TABLE `usermodulerequirement` (
  `requirementID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `message` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `usertransaction`
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
-- Struktur dari tabel `views`
--

CREATE TABLE `views` (
  `userID` int(11) NOT NULL DEFAULT '0',
  `moduleID` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `views`
--

INSERT INTO `views` (`userID`, `moduleID`, `time`) VALUES
(1, 1, '2017-04-04 10:44:18'),
(1, 2, '2017-04-04 10:44:18'),
(1, 2, '2017-05-01 09:42:01'),
(1, 3, '2017-04-04 10:44:18'),
(1, 3, '2017-04-30 09:00:43'),
(1, 4, '2017-04-04 10:44:18'),
(1, 4, '2017-04-30 10:17:46'),
(1, 5, '2017-04-04 10:44:18');

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
  ADD PRIMARY KEY (`moduleID`,`mKey`),
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
  MODIFY `achievementID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;
--
-- AUTO_INCREMENT for table `module`
--
ALTER TABLE `module`
  MODIFY `moduleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `modulerequirement`
--
ALTER TABLE `modulerequirement`
  MODIFY `requirementID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `postID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;
--
-- AUTO_INCREMENT for table `thread`
--
ALTER TABLE `thread`
  MODIFY `threadID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `usertransaction`
--
ALTER TABLE `usertransaction`
  MODIFY `transactionID` int(11) NOT NULL AUTO_INCREMENT;
--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `achievement`
--
ALTER TABLE `achievement`
  ADD CONSTRAINT `fk_achievement_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `genre`
--
ALTER TABLE `genre`
  ADD CONSTRAINT `fk_genre_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `moduleimages`
--
ALTER TABLE `moduleimages`
  ADD CONSTRAINT `fk_moduleimages_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `modulerequirement`
--
ALTER TABLE `modulerequirement`
  ADD CONSTRAINT `fk_modulerequirement_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `moduleshareddata`
--
ALTER TABLE `moduleshareddata`
  ADD CONSTRAINT `fk_moduleshareddata_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `moduleuserdata`
--
ALTER TABLE `moduleuserdata`
  ADD CONSTRAINT `fk_moduleuserdata_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_moduleuserdata_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `fk_post_thread1` FOREIGN KEY (`threadID`) REFERENCES `thread` (`threadID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_post_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `thread`
--
ALTER TABLE `thread`
  ADD CONSTRAINT `fk_thread_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `userachievement`
--
ALTER TABLE `userachievement`
  ADD CONSTRAINT `fk_userachievement_achievement1` FOREIGN KEY (`achievementID`) REFERENCES `achievement` (`achievementID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_userachievement_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `usermodulerequirement`
--
ALTER TABLE `usermodulerequirement`
  ADD CONSTRAINT `fk_usermodulerequirement_modulerequirement1` FOREIGN KEY (`requirementID`) REFERENCES `modulerequirement` (`requirementID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usermodulerequirement_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `usertransaction`
--
ALTER TABLE `usertransaction`
  ADD CONSTRAINT `fk_usertransaction_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `views`
--
ALTER TABLE `views`
  ADD CONSTRAINT `fk_views_module1` FOREIGN KEY (`moduleID`) REFERENCES `module` (`moduleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_views_user1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
