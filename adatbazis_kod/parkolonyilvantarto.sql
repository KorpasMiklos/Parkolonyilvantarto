-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Okt 30. 17:17
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `parkolonyilvantarto`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `berles`
--

CREATE TABLE `berles` (
  `id` int(11) NOT NULL,
  `parkolo_id` int(11) NOT NULL,
  `tulaj_id` int(11) NOT NULL,
  `berles_kezdete` date NOT NULL,
  `berles_vege` date DEFAULT NULL,
  `ar` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `berles`
--

INSERT INTO `berles` (`id`, `parkolo_id`, `tulaj_id`, `berles_kezdete`, `berles_vege`, `ar`) VALUES
(1, 1, 1, '2025-10-01', '2025-10-10', 5000.00),
(3, 3, 3, '2025-10-03', '2025-10-07', 4000.00);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `jarmu`
--

CREATE TABLE `jarmu` (
  `id` int(11) NOT NULL,
  `rendszam` varchar(20) NOT NULL,
  `szin` varchar(30) DEFAULT NULL,
  `tipus` varchar(50) DEFAULT NULL,
  `tulajdonos` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `jarmu`
--

INSERT INTO `jarmu` (`id`, `rendszam`, `szin`, `tipus`, `tulajdonos`) VALUES
(1, 'ABC-123', 'Piros', 'Sedan', 'Kiss Péter'),
(2, 'XYZ-789', 'Kék', 'SUV', 'Nagy Anna'),
(3, 'LMN-456', 'Fekete', 'Hatchback', 'Tóth Gábor');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `parkolas`
--

CREATE TABLE `parkolas` (
  `id` int(11) NOT NULL,
  `jarmu_id` int(11) NOT NULL,
  `parkolo_id` int(11) NOT NULL,
  `parkolas_kezdete` datetime NOT NULL,
  `parkolas_vege` datetime DEFAULT NULL,
  `parkolas_idotartama` int(11) GENERATED ALWAYS AS (timestampdiff(MINUTE,`parkolas_kezdete`,`parkolas_vege`)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `parkolas`
--

INSERT INTO `parkolas` (`id`, `jarmu_id`, `parkolo_id`, `parkolas_kezdete`, `parkolas_vege`) VALUES
(5, 1, 2, '2025-10-05 12:27:13', '2025-10-05 13:27:13');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `parkolo`
--

CREATE TABLE `parkolo` (
  `id` int(11) NOT NULL,
  `allapot` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `parkolo`
--

INSERT INTO `parkolo` (`id`, `allapot`) VALUES
(1, 0),
(2, 0),
(3, 0);

-- --------------------------------------------------------

--
-- A nézet helyettes szerkezete `parkolostat`
-- (Lásd alább az aktuális nézetet)
--
CREATE TABLE `parkolostat` (
`osszes_parkolohely` bigint(21)
,`szabad_db` bigint(21)
,`foglalt_db` bigint(21)
,`berelt_db` bigint(21)
);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `parkolotulaj`
--

CREATE TABLE `parkolotulaj` (
  `id` int(11) NOT NULL,
  `nev` varchar(100) NOT NULL,
  `telefonszam` varchar(20) DEFAULT NULL,
  `email_cim` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `parkolotulaj`
--

INSERT INTO `parkolotulaj` (`id`, `nev`, `telefonszam`, `email_cim`) VALUES
(1, 'Kiss Péter', '+3612345678', 'kiss.peter@example.com'),
(2, 'Nagy Anna', '+3620987654', 'nagy.anna@example.com'),
(3, 'Tóth Gábor', '+3611122233', 'toth.gabor@example.com');

-- --------------------------------------------------------

--
-- Nézet szerkezete `parkolostat`
--
DROP TABLE IF EXISTS `parkolostat`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `parkolostat`  AS SELECT count(`p`.`id`) AS `osszes_parkolohely`, count(distinct case when `ap`.`parkolo_id` is null and `ab`.`parkolo_id` is null then `p`.`id` end) AS `szabad_db`, count(distinct case when `ap`.`parkolo_id` is not null or `ab`.`parkolo_id` is not null then `p`.`id` end) AS `foglalt_db`, count(distinct `ab`.`parkolo_id`) AS `berelt_db` FROM ((`parkolo` `p` left join `parkolas` `ap` on(`ap`.`parkolo_id` = `p`.`id`)) left join `berles` `ab` on(`ab`.`parkolo_id` = `p`.`id`)) ;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `berles`
--
ALTER TABLE `berles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parkolo_id` (`parkolo_id`),
  ADD KEY `tulaj_id` (`tulaj_id`);

--
-- A tábla indexei `jarmu`
--
ALTER TABLE `jarmu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `rendszam` (`rendszam`);

--
-- A tábla indexei `parkolas`
--
ALTER TABLE `parkolas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jarmu_id` (`jarmu_id`),
  ADD KEY `parkolo_id` (`parkolo_id`);

--
-- A tábla indexei `parkolo`
--
ALTER TABLE `parkolo`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `parkolotulaj`
--
ALTER TABLE `parkolotulaj`
  ADD PRIMARY KEY (`id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `berles`
--
ALTER TABLE `berles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `jarmu`
--
ALTER TABLE `jarmu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `parkolas`
--
ALTER TABLE `parkolas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `parkolo`
--
ALTER TABLE `parkolo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `parkolotulaj`
--
ALTER TABLE `parkolotulaj`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `berles`
--
ALTER TABLE `berles`
  ADD CONSTRAINT `berles_ibfk_1` FOREIGN KEY (`parkolo_id`) REFERENCES `parkolo` (`id`),
  ADD CONSTRAINT `berles_ibfk_2` FOREIGN KEY (`tulaj_id`) REFERENCES `parkolotulaj` (`id`);

--
-- Megkötések a táblához `parkolas`
--
ALTER TABLE `parkolas`
  ADD CONSTRAINT `parkolas_ibfk_1` FOREIGN KEY (`jarmu_id`) REFERENCES `jarmu` (`id`),
  ADD CONSTRAINT `parkolas_ibfk_2` FOREIGN KEY (`parkolo_id`) REFERENCES `parkolo` (`id`);

DELIMITER $$
--
-- Események
--
CREATE DEFINER=`root`@`localhost` EVENT `FrissitParkoloRendszer` ON SCHEDULE EVERY 10 MINUTE STARTS '2025-10-05 12:07:25' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    -- Lejárt bérlések törlése
    DELETE FROM Berles
    WHERE berles_vege < NOW();

    -- Lejárt parkolások törlése (már vége van és régebbi mint 1 nap)
    DELETE FROM Parkolas
    WHERE parkolas_vege IS NOT NULL
      AND parkolas_vege < NOW() - INTERVAL 1 DAY;

    -- Minden parkolót alapértelmezetten szabadra állítunk
    UPDATE Parkolo SET allapot = FALSE;

    -- Azokat, amiknél van aktív parkolás vagy bérlés, foglaltra állítjuk
    UPDATE Parkolo p
    SET p.allapot = TRUE
    WHERE p.id IN (
        SELECT parkolo_id FROM AktivParkolasok
        UNION
        SELECT parkolo_id FROM AktivBerlesek
    );
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
