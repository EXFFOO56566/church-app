-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 07, 2020 at 01:46 PM
-- Server version: 5.7.31-0ubuntu0.16.04.1
-- PHP Version: 7.0.33-0ubuntu0.16.04.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mychurchapp_db`
--


--
-- Table structure for table `tbl_bible_versions`
--

CREATE TABLE `tbl_bible_versions` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `shortcode` varchar(20) NOT NULL,
  `description` varchar(500) NOT NULL,
  `source` varchar(1000) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

--
-- Dumping data for table `tbl_bible_versions`
--

INSERT INTO `tbl_bible_versions` (`id`, `name`, `shortcode`, `description`, `source`, `date`) VALUES
(2, 'King James Version', 'KJV', 'An English translation of the Christian Bible for the Church of England.', 'tbl_KJV.json', '2020-09-01 16:52:12'),
(3, 'The Message Bible', 'MSG', 'Bible in Contemporary Language is a highly idiomatic translation by Eugene H.', 'tbl_MSG.json', '2020-09-01 16:53:10'),
(4, 'New International Version', 'NIV', 'First published in 1978 by Bible scholars using the earliest, highest quality manuscripts available.', 'tbl_NIV.json', '2020-09-01 16:54:33'),
(5, 'New King James Version', 'NKJV', 'English translation of the Bible first published in 1982 by Thomas Nelson.', 'tbl_NKJV.json', '2020-09-01 16:55:51'),
(6, 'Amplified Bible', 'AMP', 'English language translation of the Bible produced jointly by Zondervan and The Lockman Foundation.', 'tbl_AMP.json', '2020-09-01 16:57:33'),
(7, 'New Living Translation', 'NLT', 'A revision of The Living Bible, the project evolved into a new English translation from Hebrew and Greek texts.', 'tbl_NLT.json', '2020-09-01 16:58:23'),
(8, 'New Revised Standard Version', 'NRSV', 'Published in 1989 by the National Council of Churches. It is a revision of the Revised Standard Version.', 'tbl_NRSV.json', '2020-09-01 16:59:08');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_blocked_users`
--

CREATE TABLE `tbl_blocked_users` (
  `id` bigint(20) NOT NULL,
  `blocked_user` varchar(1000) NOT NULL,
  `blocked_by` varchar(1000) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

--
-- Table structure for table `tbl_chat`
--

CREATE TABLE `tbl_chat` (
  `id` bigint(20) NOT NULL,
  `email1` varchar(500) NOT NULL,
  `email2` varchar(500) NOT NULL,
  `last_message_time` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_chat_messages`
--

CREATE TABLE `tbl_chat_messages` (
  `id` int(11) NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  `message` text,
  `attachment` varchar(1000) DEFAULT NULL,
  `sender` varchar(500) NOT NULL,
  `msg_reciept` bigint(20) NOT NULL COMMENT 'use to delete messages',
  `msg_owner` varchar(500) NOT NULL COMMENT 'who sees this message',
  `seen` int(11) NOT NULL DEFAULT '1',
  `date` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

--
-- Table structure for table `tbl_donation_settings`
--

CREATE TABLE `tbl_donation_settings` (
  `id` int(11) NOT NULL,
  `paystack_key` varchar(1000) NOT NULL,
  `flutterwaves_key` varchar(1000) NOT NULL,
  `flutterwaves_currency_code` varchar(20) NOT NULL,
  `paypal_link` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

--
-- Indexes for table `tbl_bible_versions`
--
ALTER TABLE `tbl_bible_versions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_blocked_users`
--
ALTER TABLE `tbl_blocked_users`
  ADD PRIMARY KEY (`id`);


--
-- Indexes for table `tbl_chat`
--
ALTER TABLE `tbl_chat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_chat_messages`
--
ALTER TABLE `tbl_chat_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_donation_settings`
--
ALTER TABLE `tbl_donation_settings`
  ADD PRIMARY KEY (`id`);


--
-- AUTO_INCREMENT for table `tbl_bible_versions`
--
ALTER TABLE `tbl_bible_versions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `tbl_blocked_users`
--
ALTER TABLE `tbl_blocked_users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

ALTER TABLE `tbl_chat`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
--
-- AUTO_INCREMENT for table `tbl_chat_messages`
--
ALTER TABLE `tbl_chat_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=581;


ALTER TABLE `tbl_user_profile` ADD `online_status` int(11) NOT NULL DEFAULT '1',
 ADD `last_seen_date` bigint(20) NOT NULL DEFAULT '0';
