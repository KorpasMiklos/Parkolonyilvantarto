-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Nov 20. 18:06
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
-- Adatbázis: `proba`
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
(1, 4, 1, '2025-11-20', '2025-11-21', 1000.00),
(2, 6, 2, '2025-11-20', '2025-11-22', 5000.00);

--
-- Eseményindítók `berles`
--
DELIMITER $$
CREATE TRIGGER `berles_uj` AFTER INSERT ON `berles` FOR EACH ROW BEGIN
    UPDATE Parkolo
    SET allapot = 1
    WHERE id = NEW.parkolo_id;
END
$$
DELIMITER ;

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
(1, 'ABC-123', 'fekete', 'Audi', 'Kiss Pista'),
(2, 'AAA-111', 'szürke', 'Mazda', 'Nagy Béla'),
(3, 'ILP-222', 'piros', 'Nissan', 'Lakatos Jóska'),
(4, 'XYZ-456', 'kék', 'BMW', 'Szabó Péter'),
(5, 'LMN-789', 'piros', 'Toyota', 'Kovács László'),
(6, 'PQR-234', 'zöld', 'Ford', 'Tóth János'),
(7, 'STU-567', 'fekete', 'Mercedes', 'Varga Ádám'),
(8, 'VWX-890', 'fehér', 'Volkswagen', 'Kiss Imre'),
(9, 'YZA-123', 'szürke', 'Fiat', 'Nagy Zoltán'),
(10, 'BCD-456', 'sárga', 'Renault', 'Lakatos István');

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
(1, 1, 2, '2025-11-20 17:24:30', '2025-11-20 17:30:30'),
(2, 2, 1, '2025-11-20 16:20:30', '2025-11-20 20:30:30'),
(3, 3, 3, '2025-11-20 16:30:30', '2025-11-20 21:30:30'),
(4, 5, 10, '2025-11-20 17:30:30', '2025-11-20 17:42:30'),
(5, 10, 5, '2025-11-20 17:45:10', '2025-11-20 22:45:10');

--
-- Eseményindítók `parkolas`
--
DELIMITER $$
CREATE TRIGGER `parkolas_uj` AFTER INSERT ON `parkolas` FOR EACH ROW BEGIN
    UPDATE Parkolo
    SET allapot = 1
    WHERE id = NEW.parkolo_id;
END
$$
DELIMITER ;

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
(1, 1),
(2, 0),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 0),
(8, 0),
(9, 0),
(10, 0);

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
(1, 'Kiss Béla', '06202345678', 'bela@gmail.com'),
(2, 'Nagy István', '06304561234', 'istvan.nagy@example.com'),
(3, 'Kovács Anna', '06705553322', 'anna.kovacs@example.com');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `parkolas`
--
ALTER TABLE `parkolas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT a táblához `parkolo`
--
ALTER TABLE `parkolo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `parkolotulaj`
--
ALTER TABLE `parkolotulaj`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
CREATE DEFINER=`root`@`localhost` EVENT `FrissitParkoloRendszer` ON SCHEDULE EVERY 1 MINUTE STARTS '2025-10-05 12:07:25' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
UPDATE Parkolo p
LEFT JOIN Parkolas pa ON p.id = pa.parkolo_id
SET p.allapot = 0
WHERE pa.parkolas_vege IS NOT NULL
  AND pa.parkolas_vege < NOW();

-- 2️⃣ Lejárt bérlések törlése
DELETE FROM Berles
WHERE berles_vege < NOW();

-- 3️⃣ Lejárt parkolások törlése (már vége van és régebbi mint 1 nap)
DELETE FROM Parkolas
WHERE parkolas_vege IS NOT NULL
  AND parkolas_vege < NOW() - INTERVAL 1 DAY;

-- 4️⃣ Aktív parkolások/bérlések foglaltra állítása
UPDATE Parkolo p
SET p.allapot = 1
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
