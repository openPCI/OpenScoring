-- phpMyAdmin SQL Dump
-- version 4.9.7deb1
-- https://www.phpmyadmin.net/
--
-- Vært: localhost:3306
-- Genereringstid: 16. 07 2021 kl. 00:40:42
-- Serverversion: 8.0.25
-- PHP-version: 7.4.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `opencoding`
--

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `assign_task`
--

CREATE TABLE `assign_task` (
  `task_id` int UNSIGNED NOT NULL,
  `coder_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `assign_test`
--

CREATE TABLE `assign_test` (
  `test_id` int UNSIGNED NOT NULL,
  `coder_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `coded`
--

CREATE TABLE `coded` (
  `response_id` int UNSIGNED NOT NULL,
  `codes` json NOT NULL,
  `coder_id` int NOT NULL,
  `coding_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `isdoublecode` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `flags`
--

CREATE TABLE `flags` (
  `flag_id` int UNSIGNED NOT NULL,
  `response_id` int UNSIGNED NOT NULL,
  `flagstatus` enum('flagged','resolved') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `coder_id` int UNSIGNED NOT NULL,
  `comments` json NOT NULL,
  `manager_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `projects`
--

CREATE TABLE `projects` (
  `project_id` int UNSIGNED NOT NULL,
  `project_name` varchar(256) NOT NULL,
  `unit_id` int UNSIGNED NOT NULL,
  `doublecodingpct` tinyint UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `responses`
--

CREATE TABLE `responses` (
  `response_id` int UNSIGNED NOT NULL,
  `task_id` int UNSIGNED NOT NULL,
  `testtaker` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `response` mediumtext NOT NULL,
  `response_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `tasks`
--

CREATE TABLE `tasks` (
  `task_id` int UNSIGNED NOT NULL,
  `task_name` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `task_description` varchar(256) NOT NULL,
  `task_image` mediumblob NOT NULL,
  `tasktype_id` mediumint UNSIGNED NOT NULL,
  `tasktype_variables` json NOT NULL,
  `items` json NOT NULL,
  `scoring_rubrics` text NOT NULL,
  `group_id` int UNSIGNED NOT NULL DEFAULT '0',
  `test_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `tasktypes`
--

CREATE TABLE `tasktypes` (
  `tasktype_id` int UNSIGNED NOT NULL,
  `tasktype_name` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `tasktype_description` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `playareatemplate` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `responseareatemplate` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `insert_script` text NOT NULL,
  `variables` json NOT NULL,
  `styles` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Data dump for tabellen `tasktypes`
--

INSERT INTO `tasktypes` (`tasktype_id`, `tasktype_name`, `tasktype_description`, `playareatemplate`, `responseareatemplate`, `insert_script`, `variables`, `styles`) VALUES
(1, 'shorttext', 'Short text answers', '<img src=\"{{task_image}}\">', '{% for subtask_name in subtasks %}    <div class=\"alert alert-secondary\"><span><em>{{subtask_name}}:</em></span> <span data-task_name=\"{{subtask_name}}\"></span></div>{% endfor %}\r\n<div class=\"alert alert-primary\" data-task_name=\"{{task_name}}\"></div>', 'for(r of json.responses) {	$(\'[data-task_name=\"\'+r.task_name+\'\"]\').html(r.response) }', '{}', ''),
(2, 'brainstorm', 'Brainstorm', '<div id=\"brainstorm\"></div>', '', '	$(\"#brainstorm\").html(\"\");\r\n	json.responses[0].response.split(/[|\\n]/g).forEach(function(str) {\r\n		var row = str.split(\';\');\r\n		if(row.length !== 3) return;\r\n		var div = $(\'<div class=\"\'+(row[1] != \"{{testtakername}}\"?\"text-muted\":\"\")+\'\"><strong class=\"brainstorm-name\">\'+row[1]+\'</strong><span>\'+row[2]+\'</span></div>\');\r\n		$(\"#brainstorm\").append(div);   \r\n	})', '{\"testtakername\": \"You\"}', '#brainstorm {     height:600px;    overflow:scroll;}'),
(3, 'voxelcraft', 'Building 3D figures with square blocks', '<iframe width=\"800\" height=\"600\" src=\"{{gameurl}}\"></iframe>', '', 'var scene=(json.responses[0].response?JSON.parse(json.responses[0].response).data:[]);if(typeof firstdone==\"undefined\") {	onceMessage(\'ready\', function(){		sendMessage(\'setScene\',scene);		firstdone=true;	}) } else sendMessage(\'setScene\',scene);', '{\"gameurl\": \"../openPCIs/voxelcraft/game/\"}', ''),
(4, '3Droom', 'Interior design of 3D rooms', '<iframe width=\"800\" height=\"600\" src=\"{{gameurl}}\"></iframe>', '', 'var d=(json.responses[0].response?JSON.parse(json.responses[0].response):[]);if(typeof firstdone==\"undefined\") {	onceMessage(\'ready\', function(){		sendMessage(\'loadExercise\',d);		firstdone=true;	}) } else sendMessage(\'loadExercise\',d);', '{\"gameurl\": \"../openPCIs/theroom/game/\"}', '');

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `tests`
--

CREATE TABLE `tests` (
  `test_id` int UNSIGNED NOT NULL,
  `test_name` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `project_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `trainingresponses`
--

CREATE TABLE `trainingresponses` (
  `response_id` int UNSIGNED NOT NULL,
  `difficulty` tinyint UNSIGNED NOT NULL,
  `manager_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `units`
--

CREATE TABLE `units` (
  `unit_id` int UNSIGNED NOT NULL,
  `unittype` enum('organisation','project','test','module') NOT NULL,
  `unitname` varchar(255) NOT NULL,
  `ownerunit_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `users`
--

CREATE TABLE `users` (
  `user_id` int UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(256) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `user_permissions`
--

CREATE TABLE `user_permissions` (
  `user_id` int UNSIGNED NOT NULL,
  `unittype` set('projectadmin','codingadmin','test','task') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `unit_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Begrænsninger for dumpede tabeller
--

--
-- Indeks for tabel `assign_task`
--
ALTER TABLE `assign_task`
  ADD UNIQUE KEY `test_id` (`task_id`,`coder_id`),
  ADD KEY `coder_id` (`coder_id`);

--
-- Indeks for tabel `assign_test`
--
ALTER TABLE `assign_test`
  ADD UNIQUE KEY `test_id` (`test_id`,`coder_id`),
  ADD KEY `coder_id` (`coder_id`);

--
-- Indeks for tabel `coded`
--
ALTER TABLE `coded`
  ADD UNIQUE KEY `response_id_2` (`response_id`,`coder_id`);

--
-- Indeks for tabel `flags`
--
ALTER TABLE `flags`
  ADD PRIMARY KEY (`flag_id`),
  ADD UNIQUE KEY `response_id` (`response_id`,`coder_id`) USING BTREE;

--
-- Indeks for tabel `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`project_id`);

--
-- Indeks for tabel `responses`
--
ALTER TABLE `responses`
  ADD PRIMARY KEY (`response_id`),
  ADD UNIQUE KEY `task_id` (`task_id`,`testtaker`,`response_time`) USING BTREE;

--
-- Indeks for tabel `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`task_id`),
  ADD KEY `test_id` (`test_id`),
  ADD KEY `group_id` (`group_id`);

--
-- Indeks for tabel `tasktypes`
--
ALTER TABLE `tasktypes`
  ADD PRIMARY KEY (`tasktype_id`);

--
-- Indeks for tabel `tests`
--
ALTER TABLE `tests`
  ADD PRIMARY KEY (`test_id`),
  ADD UNIQUE KEY `test_name` (`test_name`,`project_id`) USING BTREE,
  ADD KEY `project_id` (`project_id`);

--
-- Indeks for tabel `trainingresponses`
--
ALTER TABLE `trainingresponses`
  ADD UNIQUE KEY `response` (`response_id`);

--
-- Indeks for tabel `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`unit_id`);

--
-- Indeks for tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indeks for tabel `user_permissions`
--
ALTER TABLE `user_permissions`
  ADD UNIQUE KEY `unique` (`user_id`,`unittype`,`unit_id`);

--
-- Brug ikke AUTO_INCREMENT for slettede tabeller
--

--
-- Tilføj AUTO_INCREMENT i tabel `flags`
--
ALTER TABLE `flags`
  MODIFY `flag_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tilføj AUTO_INCREMENT i tabel `projects`
--
ALTER TABLE `projects`
  MODIFY `project_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tilføj AUTO_INCREMENT i tabel `responses`
--
ALTER TABLE `responses`
  MODIFY `response_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tilføj AUTO_INCREMENT i tabel `tasks`
--
ALTER TABLE `tasks`
  MODIFY `task_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tilføj AUTO_INCREMENT i tabel `tasktypes`
--
ALTER TABLE `tasktypes`
  MODIFY `tasktype_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tilføj AUTO_INCREMENT i tabel `tests`
--
ALTER TABLE `tests`
  MODIFY `test_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tilføj AUTO_INCREMENT i tabel `units`
--
ALTER TABLE `units`
  MODIFY `unit_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tilføj AUTO_INCREMENT i tabel `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Begrænsninger for dumpede tabeller
--

--
-- Begrænsninger for tabel `assign_task`
--
ALTER TABLE `assign_task`
  ADD CONSTRAINT `assign_task_ibfk_1` FOREIGN KEY (`coder_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `assign_task_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Begrænsninger for tabel `assign_test`
--
ALTER TABLE `assign_test`
  ADD CONSTRAINT `assign_test_ibfk_1` FOREIGN KEY (`coder_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `assign_test_ibfk_2` FOREIGN KEY (`test_id`) REFERENCES `tests` (`test_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Begrænsninger for tabel `coded`
--
ALTER TABLE `coded`
  ADD CONSTRAINT `coded_ibfk_1` FOREIGN KEY (`response_id`) REFERENCES `responses` (`response_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Begrænsninger for tabel `flags`
--
ALTER TABLE `flags`
  ADD CONSTRAINT `flags_ibfk_1` FOREIGN KEY (`response_id`) REFERENCES `responses` (`response_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Begrænsninger for tabel `responses`
--
ALTER TABLE `responses`
  ADD CONSTRAINT `responses_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Begrænsninger for tabel `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`test_id`) REFERENCES `tests` (`test_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Begrænsninger for tabel `tests`
--
ALTER TABLE `tests`
  ADD CONSTRAINT `tests_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Begrænsninger for tabel `trainingresponses`
--
ALTER TABLE `trainingresponses`
  ADD CONSTRAINT `trainingresponses_ibfk_1` FOREIGN KEY (`response_id`) REFERENCES `responses` (`response_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
