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

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `fcm_server_key` text NOT NULL,
  `mail_username` varchar(200) NOT NULL,
  `mail_password` varchar(200) NOT NULL,
  `mail_smtp_host` varchar(100) NOT NULL,
  `mail_protocol` varchar(50) NOT NULL,
  `mail_port` int(11) NOT NULL,
  `facebook_page` varchar(1000) NOT NULL,
  `youtube_page` varchar(1000) NOT NULL,
  `twitter_page` varchar(1000) NOT NULL,
  `instagram_page` varchar(1000) NOT NULL,
  `ads_interval` int(11) NOT NULL,
  `website_url` varchar(500) NOT NULL,
  `image_one` varchar(500) NOT NULL,
  `image_two` varchar(500) NOT NULL,
  `image_three` varchar(500) NOT NULL,
  `image_four` varchar(500) NOT NULL,
  `image_five` varchar(500) NOT NULL,
  `image_six` varchar(500) NOT NULL,
  `image_seven` varchar(500) NOT NULL,
  `image_eight` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `fcm_server_key`, `mail_username`, `mail_password`, `mail_smtp_host`, `mail_protocol`, `mail_port`, `facebook_page`, `youtube_page`, `twitter_page`, `instagram_page`, `ads_interval`, `website_url`, `image_one`, `image_two`, `image_three`, `image_four`, `image_five`, `image_six`, `image_seven`, `image_eight`) VALUES
(100, 'fcm_server_key', 'mail_username', 'mail_password', 'mail_smtp_host', 'smtp', 465, 'https://www.facebook.com', 'https://www.youtube.com', 'https://www.twitter.com', 'https://www.instagram.com', 30, '', '', '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_android_users`
--

CREATE TABLE `tbl_android_users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `password` text NOT NULL,
  `login_type` varchar(100) NOT NULL DEFAULT 'email' COMMENT 'email,facebook,or google',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `verified` int(1) NOT NULL DEFAULT '1' COMMENT '0 for true, 1 for false',
  `blocked` int(1) NOT NULL DEFAULT '1' COMMENT '0 for true, 1 for false',
  `isDeleted` int(1) NOT NULL DEFAULT '1' COMMENT '0 for true, 1 for false',
  `subscribed` int(1) NOT NULL DEFAULT '1' COMMENT '0 for true, 1 for false',
  `subscribe_expiry_date` bigint(20) NOT NULL,
  `subscribe_plan` varchar(100) NOT NULL,
  `subscribe_token` longtext NOT NULL,
  `sub_type` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_bible`
--

CREATE TABLE `tbl_bible` (
  `id` int(11) NOT NULL,
  `book` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `chapter` int(11) NOT NULL,
  `verse` int(11) NOT NULL,
  `AMP` text COLLATE utf8_unicode_ci NOT NULL,
  `KJV` text COLLATE utf8_unicode_ci NOT NULL,
  `MSG` text COLLATE utf8_unicode_ci NOT NULL,
  `NIV` text COLLATE utf8_unicode_ci NOT NULL,
  `NKJV` text COLLATE utf8_unicode_ci NOT NULL,
  `NLT` text COLLATE utf8_unicode_ci NOT NULL,
  `NRSV` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

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

-- --------------------------------------------------------

--
-- Table structure for table `tbl_branches`
--

CREATE TABLE `tbl_branches` (
  `id` bigint(20) NOT NULL,
  `name` varchar(1000) NOT NULL,
  `address` varchar(1000) NOT NULL,
  `pastor` varchar(1000) NOT NULL,
  `phone` varchar(1000) NOT NULL,
  `email` varchar(1000) NOT NULL,
  `latitude` varchar(1000) NOT NULL,
  `longitude` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_categories`
--

CREATE TABLE `tbl_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `thumbnail` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

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

-- --------------------------------------------------------

--
-- Table structure for table `tbl_comments`
--

CREATE TABLE `tbl_comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `media_id` bigint(20) NOT NULL DEFAULT '0',
  `comment_id` bigint(20) NOT NULL DEFAULT '0',
  `email` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `date` bigint(20) NOT NULL,
  `edited` int(11) NOT NULL DEFAULT '1',
  `deleted` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_coupons`
--

CREATE TABLE `tbl_coupons` (
  `id` bigint(20) NOT NULL,
  `amount` varchar(200) NOT NULL,
  `code` varchar(200) NOT NULL,
  `expiry` varchar(20) NOT NULL,
  `duration` varchar(200) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_devotionals`
--

CREATE TABLE `tbl_devotionals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `thumbnail` varchar(500) NOT NULL,
  `title` varchar(500) NOT NULL,
  `author` varchar(100) NOT NULL,
  `content` longtext NOT NULL,
  `bible_reading` varchar(500) NOT NULL,
  `confession` varchar(1000) NOT NULL,
  `studies` varchar(500) NOT NULL,
  `date` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `id` bigint(20) NOT NULL,
  `email` varchar(500) NOT NULL,
  `name` varchar(500) NOT NULL,
  `amount` bigint(20) NOT NULL,
  `reason` text NOT NULL,
  `method` varchar(100) NOT NULL,
  `reference` varchar(500) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

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

-- --------------------------------------------------------

--
-- Table structure for table `tbl_events`
--

CREATE TABLE `tbl_events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(500) NOT NULL,
  `details` longtext NOT NULL,
  `thumbnail` varchar(500) NOT NULL,
  `time` varchar(500) NOT NULL,
  `date` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_fcm_token`
--

CREATE TABLE `tbl_fcm_token` (
  `id` int(10) UNSIGNED NOT NULL,
  `token` text NOT NULL,
  `app_version` varchar(10) NOT NULL DEFAULT 'v1',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_hymns`
--

CREATE TABLE `tbl_hymns` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `thumbnail` varchar(500) NOT NULL,
  `title` varchar(500) NOT NULL,
  `content` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_inbox`
--

CREATE TABLE `tbl_inbox` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(100) NOT NULL,
  `message` varchar(1000) NOT NULL,
  `date` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_media`
--

CREATE TABLE `tbl_media` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category` bigint(20) NOT NULL,
  `title` varchar(300) NOT NULL,
  `description` text NOT NULL,
  `cover_photo` varchar(500) NOT NULL,
  `source` varchar(500) NOT NULL,
  `duration` bigint(20) NOT NULL,
  `can_preview` int(1) NOT NULL DEFAULT '1' COMMENT '0 for true, 1 for false',
  `preview_duration` bigint(20) NOT NULL DEFAULT '0' COMMENT 'in seconds',
  `can_download` int(1) NOT NULL DEFAULT '1' COMMENT '0 for true, 1 for false',
  `is_free` int(1) NOT NULL DEFAULT '1' COMMENT '0 for true, 1 for false',
  `type` varchar(10) NOT NULL,
  `likes_count` bigint(20) NOT NULL DEFAULT '0',
  `views_count` bigint(20) NOT NULL DEFAULT '0',
  `dateInserted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `sub_category` bigint(20) DEFAULT NULL,
  `video_type` varchar(100) NOT NULL DEFAULT 'mp4_video'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_media_likes`
--

CREATE TABLE `tbl_media_likes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `media_id` bigint(20) NOT NULL,
  `email` varchar(200) NOT NULL,
  `date` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_notifications`
--

CREATE TABLE `tbl_notifications` (
  `id` bigint(20) NOT NULL,
  `email` varchar(1000) NOT NULL,
  `user` varchar(1000) NOT NULL,
  `itm_id` bigint(20) NOT NULL,
  `type` varchar(100) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int(11) NOT NULL DEFAULT '1',
  `timestamp` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_post_comments`
--

CREATE TABLE `tbl_post_comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `post_id` bigint(20) NOT NULL DEFAULT '0',
  `comment_id` bigint(20) NOT NULL DEFAULT '0',
  `email` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `date` bigint(20) NOT NULL,
  `edited` int(11) NOT NULL DEFAULT '1',
  `deleted` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_post_likes`
--

CREATE TABLE `tbl_post_likes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `post_id` bigint(20) NOT NULL,
  `email` varchar(200) NOT NULL,
  `date` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_post_pins`
--

CREATE TABLE `tbl_post_pins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `post_id` bigint(20) NOT NULL,
  `email` varchar(200) NOT NULL,
  `date` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_radio`
--

CREATE TABLE `tbl_radio` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` text NOT NULL,
  `thumbnail` varchar(500) NOT NULL,
  `stream_url` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_reported_comments`
--

CREATE TABLE `tbl_reported_comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `comment_id` bigint(20) NOT NULL,
  `email` varchar(200) NOT NULL,
  `type` varchar(10) NOT NULL,
  `reason` varchar(100) NOT NULL,
  `date` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_social_fcm_tokens`
--

CREATE TABLE `tbl_social_fcm_tokens` (
  `id` int(11) NOT NULL,
  `email` varchar(1000) NOT NULL,
  `token` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_streaming`
--

CREATE TABLE `tbl_streaming` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` text NOT NULL,
  `stream_url` varchar(200) NOT NULL,
  `type` varchar(100) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '0 for true, 1 for false'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sub_categories`
--

CREATE TABLE `tbl_sub_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(200) NOT NULL,
  `fullname` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`id`, `email`, `password`, `fullname`) VALUES
(1, 'admin@admin.com', '$2y$10$jsR59FPCtYsvL9n8vXDxauborZjJkHj9t4xhIEsksBh7Msmi7ex6m', 'Test Admin User');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_following`
--

CREATE TABLE `tbl_user_following` (
  `id` bigint(20) NOT NULL,
  `user_email` varchar(1000) NOT NULL,
  `follower_email` varchar(1000) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `_ignore` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_posts`
--

CREATE TABLE `tbl_user_posts` (
  `id` bigint(20) NOT NULL,
  `email` varchar(500) NOT NULL,
  `content` longtext NOT NULL,
  `media` text NOT NULL,
  `comments_count` bigint(20) NOT NULL,
  `likes_count` bigint(20) NOT NULL,
  `visibility` varchar(200) NOT NULL DEFAULT 'public',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `edited` int(11) NOT NULL DEFAULT '1',
  `deleted` int(11) NOT NULL DEFAULT '1',
  `timestamp` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_profile`
--

CREATE TABLE `tbl_user_profile` (
  `id` bigint(20) NOT NULL,
  `email` varchar(500) NOT NULL,
  `avatar` varchar(1000) NOT NULL,
  `cover_photo` varchar(1000) NOT NULL,
  `gender` varchar(20) NOT NULL,
  `date_of_birth` date NOT NULL,
  `phone` varchar(200) NOT NULL,
  `about_me` text NOT NULL,
  `location` varchar(1000) NOT NULL,
  `qualification` varchar(1000) NOT NULL,
  `facebook` varchar(1000) NOT NULL,
  `twitter` varchar(1000) NOT NULL,
  `linkdln` varchar(1000) NOT NULL,
  `notify_token` text NOT NULL,
  `show_dateofbirth` int(11) NOT NULL DEFAULT '1',
  `show_phone` int(11) NOT NULL DEFAULT '1',
  `notify_follows` int(11) NOT NULL DEFAULT '0',
  `notify_comments` int(11) NOT NULL DEFAULT '0',
  `notify_likes` int(11) NOT NULL DEFAULT '0',
  `activated` int(11) NOT NULL DEFAULT '1',
  `online_status` int(11) NOT NULL DEFAULT '1',
  `last_seen_date` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_verification`
--

CREATE TABLE `tbl_verification` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(100) NOT NULL,
  `activation_id` varchar(32) NOT NULL,
  `agent` varchar(512) NOT NULL,
  `client_ip` varchar(50) NOT NULL,
  `createdDtm` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




INSERT INTO `tbl_streaming` (`id`, `title`, `stream_url`, `type`, `status`) VALUES
(100, 'Christian Broadcasting Network', 'https://bcliveunivsecure-lh.akamaihd.net/i/iptv1_1@500579/index_1200_av-p.m3u8', 'm3u8', 0);


  INSERT INTO `tbl_donation_settings` (`id`, `paystack_key`, `flutterwaves_key`, `flutterwaves_currency_code`, `paypal_link`) VALUES
  (100, 'pk_test_66a6c90eeb5796dd58c2ace93b211a54e8dfe45e', 'FLWPUBK_TEST-54196d8840fffa3ea5e8df9f5157311a-X', 'NGN', 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3G57JHYW9RNG6&source=url');


    --
    -- Dumping data for table `tbl_radio`
    --

    INSERT INTO `tbl_radio` (`id`, `title`, `thumbnail`, `stream_url`) VALUES
    (100, 'Christian Life Radio', 'https://i0.wp.com/www.robertrickman.net/wp-content/uploads/2015/05/stock-footage-audio-spectrum-loop.jpg', 'http://ice64.securenetsystems.net/CLR1MP3');


--
-- Indexes for dumped tables
--

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_android_users`
--
ALTER TABLE `tbl_android_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_bible`
--
ALTER TABLE `tbl_bible`
  ADD PRIMARY KEY (`book`,`chapter`,`verse`),
  ADD KEY `id` (`id`);

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
-- Indexes for table `tbl_branches`
--
ALTER TABLE `tbl_branches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_categories`
--
ALTER TABLE `tbl_categories`
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
-- Indexes for table `tbl_comments`
--
ALTER TABLE `tbl_comments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_coupons`
--
ALTER TABLE `tbl_coupons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_devotionals`
--
ALTER TABLE `tbl_devotionals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_donation_settings`
--
ALTER TABLE `tbl_donation_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_events`
--
ALTER TABLE `tbl_events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_fcm_token`
--
ALTER TABLE `tbl_fcm_token`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_hymns`
--
ALTER TABLE `tbl_hymns`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_inbox`
--
ALTER TABLE `tbl_inbox`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_media`
--
ALTER TABLE `tbl_media`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_media_likes`
--
ALTER TABLE `tbl_media_likes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_notifications`
--
ALTER TABLE `tbl_notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_post_comments`
--
ALTER TABLE `tbl_post_comments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_post_likes`
--
ALTER TABLE `tbl_post_likes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_post_pins`
--
ALTER TABLE `tbl_post_pins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_radio`
--
ALTER TABLE `tbl_radio`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_reported_comments`
--
ALTER TABLE `tbl_reported_comments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_social_fcm_tokens`
--
ALTER TABLE `tbl_social_fcm_tokens`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_streaming`
--
ALTER TABLE `tbl_streaming`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_sub_categories`
--
ALTER TABLE `tbl_sub_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_user_following`
--
ALTER TABLE `tbl_user_following`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_user_posts`
--
ALTER TABLE `tbl_user_posts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_user_profile`
--
ALTER TABLE `tbl_user_profile`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_verification`
--
ALTER TABLE `tbl_verification`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_android_users`
--
ALTER TABLE `tbl_android_users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=489;
--
-- AUTO_INCREMENT for table `tbl_bible`
--
ALTER TABLE `tbl_bible`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31103;
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
--
-- AUTO_INCREMENT for table `tbl_branches`
--
ALTER TABLE `tbl_branches`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `tbl_categories`
--
ALTER TABLE `tbl_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
--
-- AUTO_INCREMENT for table `tbl_chat`
--
ALTER TABLE `tbl_chat`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
--
-- AUTO_INCREMENT for table `tbl_chat_messages`
--
ALTER TABLE `tbl_chat_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=581;
--
-- AUTO_INCREMENT for table `tbl_comments`
--
ALTER TABLE `tbl_comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;
--
-- AUTO_INCREMENT for table `tbl_coupons`
--
ALTER TABLE `tbl_coupons`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=215;
--
-- AUTO_INCREMENT for table `tbl_devotionals`
--
ALTER TABLE `tbl_devotionals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `tbl_events`
--
ALTER TABLE `tbl_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `tbl_fcm_token`
--
ALTER TABLE `tbl_fcm_token`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1238;
--
-- AUTO_INCREMENT for table `tbl_hymns`
--
ALTER TABLE `tbl_hymns`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `tbl_inbox`
--
ALTER TABLE `tbl_inbox`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;
--
-- AUTO_INCREMENT for table `tbl_media`
--
ALTER TABLE `tbl_media`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=688;
--
-- AUTO_INCREMENT for table `tbl_media_likes`
--
ALTER TABLE `tbl_media_likes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;
--
-- AUTO_INCREMENT for table `tbl_notifications`
--
ALTER TABLE `tbl_notifications`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=664;
--
-- AUTO_INCREMENT for table `tbl_post_comments`
--
ALTER TABLE `tbl_post_comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;
--
-- AUTO_INCREMENT for table `tbl_post_likes`
--
ALTER TABLE `tbl_post_likes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=280;
--
-- AUTO_INCREMENT for table `tbl_post_pins`
--
ALTER TABLE `tbl_post_pins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;
--
-- AUTO_INCREMENT for table `tbl_radio`
--
ALTER TABLE `tbl_radio`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;
--
-- AUTO_INCREMENT for table `tbl_reported_comments`
--
ALTER TABLE `tbl_reported_comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_social_fcm_tokens`
--
ALTER TABLE `tbl_social_fcm_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1196;
--
-- AUTO_INCREMENT for table `tbl_streaming`
--
ALTER TABLE `tbl_streaming`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;
--
-- AUTO_INCREMENT for table `tbl_sub_categories`
--
ALTER TABLE `tbl_sub_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tbl_user_following`
--
ALTER TABLE `tbl_user_following`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=551;
--
-- AUTO_INCREMENT for table `tbl_user_posts`
--
ALTER TABLE `tbl_user_posts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=175;
--
-- AUTO_INCREMENT for table `tbl_user_profile`
--
ALTER TABLE `tbl_user_profile`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;
--
-- AUTO_INCREMENT for table `tbl_verification`
--
ALTER TABLE `tbl_verification`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=614;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
