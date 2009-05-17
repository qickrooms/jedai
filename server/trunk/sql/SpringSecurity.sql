CREATE DATABASE IF NOT EXISTS SpringSecurity;
USE SpringSecurity;

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `acl`
--

-- --------------------------------------------------------

--
-- Table structure for table `ACL_CLASS`
--

CREATE TABLE IF NOT EXISTS `ACL_CLASS` (
  `ID` bigint(20) NOT NULL auto_increment,
  `CLASS` varchar(100) NOT NULL,
  PRIMARY KEY  (`ID`),
  UNIQUE KEY `UNIQUE_UK_2` (`CLASS`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ACL_CLASS`
--


-- --------------------------------------------------------

--
-- Table structure for table `ACL_ENTRY`
--

CREATE TABLE IF NOT EXISTS `ACL_ENTRY` (
  `ID` bigint(20) NOT NULL auto_increment,
  `ACL_OBJECT_IDENTITY` bigint(20) NOT NULL,
  `ACE_ORDER` int(11) NOT NULL,
  `SID` bigint(20) NOT NULL,
  `MASK` int(11) NOT NULL,
  `GRANTING` tinyint(1) NOT NULL,
  `AUDIT_SUCCESS` tinyint(1) NOT NULL,
  `AUDIT_FAILURE` tinyint(1) NOT NULL,
  PRIMARY KEY  (`ID`),
  UNIQUE KEY `UNIQUE_UK_4` (`ACL_OBJECT_IDENTITY`,`ACE_ORDER`),
  KEY `SID` (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ACL_ENTRY`
--


-- --------------------------------------------------------

--
-- Table structure for table `ACL_OBJECT_IDENTITY`
--

CREATE TABLE IF NOT EXISTS `ACL_OBJECT_IDENTITY` (
  `ID` bigint(20) NOT NULL auto_increment,
  `OBJECT_ID_CLASS` bigint(20) NOT NULL,
  `OBJECT_ID_IDENTITY` bigint(20) NOT NULL,
  `PARENT_OBJECT` bigint(20) default NULL,
  `OWNER_SID` bigint(20) default NULL,
  `ENTRIES_INHERITING` tinyint(1) NOT NULL,
  PRIMARY KEY  (`ID`),
  UNIQUE KEY `UNIQUE_UK_3` (`OBJECT_ID_CLASS`,`OBJECT_ID_IDENTITY`),
  KEY `OWNER_SID` (`OWNER_SID`),
  KEY `PARENT_OBJECT` (`PARENT_OBJECT`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ACL_OBJECT_IDENTITY`
--


-- --------------------------------------------------------

--
-- Table structure for table `ACL_SID`
--

CREATE TABLE IF NOT EXISTS `ACL_SID` (
  `ID` bigint(20) NOT NULL,
  `PRINCIPAL` tinyint(1) NOT NULL,
  `SID` varchar(100) NOT NULL,
  PRIMARY KEY  (`ID`),
  UNIQUE KEY `UNIQUE_UK_1` (`PRINCIPAL`,`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ACL_SID`
--


-- --------------------------------------------------------

--
-- Table structure for table `AUTHORITIES`
--

CREATE TABLE IF NOT EXISTS `AUTHORITIES` (
  `USERNAME` varchar(50) NOT NULL,
  `AUTHORITY` varchar(50) NOT NULL,
  UNIQUE KEY `IX_AUTH_USERNAME` (`USERNAME`,`AUTHORITY`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `AUTHORITIES`
--

INSERT INTO `AUTHORITIES` (`USERNAME`, `AUTHORITY`) VALUES
('bill', 'ROLE_USER'),
('bob', 'ROLE_USER'),
('dianne', 'ROLE_USER'),
('jane', 'ROLE_USER'),
('peter', 'ROLE_USER'),
('rod', 'ROLE_SUPERVISOR'),
('rod', 'ROLE_USER'),
('scott', 'ROLE_USER');

-- --------------------------------------------------------

--
-- Table structure for table `CONTACTS`
--

CREATE TABLE IF NOT EXISTS `CONTACTS` (
  `ID` bigint(20) NOT NULL,
  `CONTACT_NAME` varchar(50) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `CONTACTS`
--

INSERT INTO `CONTACTS` (`ID`, `CONTACT_NAME`, `EMAIL`) VALUES
(1, 'John Smith', 'john@somewhere.com'),
(2, 'Michael Citizen', 'michael@xyz.com'),
(3, 'Joe Bloggs', 'joe@demo.com'),
(4, 'Karen Sutherland', 'karen@sutherland.com'),
(5, 'Mitchell Howard', 'mitchell@abcdef.com'),
(6, 'Rose Costas', 'rose@xyz.com'),
(7, 'Amanda Smith', 'amanda@abcdef.com'),
(8, 'Cindy Smith', 'cindy@smith.com'),
(9, 'Jonathan Citizen', 'jonathan@xyz.com');

-- --------------------------------------------------------

--
-- Table structure for table `USERS`
--

CREATE TABLE IF NOT EXISTS `USERS` (
  `USERNAME` varchar(50) NOT NULL,
  `PASSWORD` varchar(50) NOT NULL,
  `ENABLED` bit(1) NOT NULL,
  PRIMARY KEY  (`USERNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `USERS`
--

INSERT INTO `USERS` (`USERNAME`, `PASSWORD`, `ENABLED`) VALUES
('bill', 'password', ''),
('bob', 'password1', ''),
('dianne', '65d15fe9156f9c4bbffd98085992a44e', ''),
('jane', '2b58af6dddbd072ed27ffc86725d7d3a', ''),
('peter', '22b5c9accc6e1ba628cedc63a72d57f8', '\0'),
('rod', 'a564de63c2d0da68cf47586ee05984d7', ''),
('scott', '2b58af6dddbd072ed27ffc86725d7d3a', '');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ACL_ENTRY`
--
ALTER TABLE `ACL_ENTRY`
  ADD CONSTRAINT `ACL_ENTRY_ibfk_1` FOREIGN KEY (`SID`) REFERENCES `ACL_SID` (`ID`),
  ADD CONSTRAINT `ACL_ENTRY_ibfk_2` FOREIGN KEY (`ACL_OBJECT_IDENTITY`) REFERENCES `ACL_OBJECT_IDENTITY` (`ID`);

--
-- Constraints for table `ACL_OBJECT_IDENTITY`
--
ALTER TABLE `ACL_OBJECT_IDENTITY`
  ADD CONSTRAINT `ACL_OBJECT_IDENTITY_ibfk_1` FOREIGN KEY (`OWNER_SID`) REFERENCES `ACL_SID` (`ID`),
  ADD CONSTRAINT `ACL_OBJECT_IDENTITY_ibfk_2` FOREIGN KEY (`OBJECT_ID_CLASS`) REFERENCES `ACL_CLASS` (`ID`),
  ADD CONSTRAINT `ACL_OBJECT_IDENTITY_ibfk_3` FOREIGN KEY (`PARENT_OBJECT`) REFERENCES `ACL_OBJECT_IDENTITY` (`ID`);