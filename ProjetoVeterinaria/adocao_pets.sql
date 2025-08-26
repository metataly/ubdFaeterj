-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 26/08/2025 às 16:08
-- Versão do servidor: 10.4.28-MariaDB
-- Versão do PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `adocao_pets`
--

-- --------------------------------------------------------

--

CREATE TABLE `Administrador` (
  `idAdministrador` int(11) NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Senha` varchar(100) DEFAULT NULL,
  `Telefone` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--

CREATE TABLE `Adm_Pet` (
  `idPet` int(11) NOT NULL,
  `idAdministrador` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--

CREATE TABLE `Funcao` (
  `idFuncao` int(11) NOT NULL,
  `Descricao` varchar(200) DEFAULT NULL,
  `idVoluntario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--

CREATE TABLE `Pet` (
  `idPet` int(11) NOT NULL,
  `Especie` varchar(100) DEFAULT NULL,
  `Idade` int(11) DEFAULT NULL,
  `Raca` varchar(100) DEFAULT NULL,
  `Historico` text DEFAULT NULL,
  `Genero` enum('Macho','Fêmea') DEFAULT NULL,
  `StatusAdocao` enum('Disponível','Adotado','Em processo') DEFAULT NULL,
  `idVoluntario` int(11) DEFAULT NULL,
  `idUsuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--

CREATE TABLE `Solicitacao` (
  `idSolicitacao` int(11) NOT NULL,
  `idPet` int(11) DEFAULT NULL,
  `idUsuario` int(11) DEFAULT NULL,
  `Status` enum('Pendente','Aprovado','Rejeitado') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--

CREATE TABLE `Usuario` (
  `idUsuario` int(11) NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Senha` varchar(100) DEFAULT NULL,
  `CPF` varchar(14) DEFAULT NULL,
  `Telefone` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--

CREATE TABLE `Voluntario` (
  `idVoluntario` int(11) NOT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Senha` varchar(100) DEFAULT NULL,
  `CPF` varchar(14) DEFAULT NULL,
  `Telefone` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--

ALTER TABLE `Administrador`
  ADD PRIMARY KEY (`idAdministrador`);

--

ALTER TABLE `Adm_Pet`
  ADD PRIMARY KEY (`idPet`,`idAdministrador`),
  ADD KEY `idAdministrador` (`idAdministrador`);

--

ALTER TABLE `Funcao`
  ADD PRIMARY KEY (`idFuncao`),
  ADD KEY `idVoluntario` (`idVoluntario`);

--

ALTER TABLE `Pet`
  ADD PRIMARY KEY (`idPet`),
  ADD KEY `idVoluntario` (`idVoluntario`),
  ADD KEY `idUsuario` (`idUsuario`);

--

ALTER TABLE `Solicitacao`
  ADD PRIMARY KEY (`idSolicitacao`),
  ADD KEY `idPet` (`idPet`),
  ADD KEY `idUsuario` (`idUsuario`);

--

ALTER TABLE `Usuario`
  ADD PRIMARY KEY (`idUsuario`);

--

ALTER TABLE `Voluntario`
  ADD PRIMARY KEY (`idVoluntario`);

--

ALTER TABLE `Administrador`
  MODIFY `idAdministrador` int(11) NOT NULL AUTO_INCREMENT;

--

ALTER TABLE `Funcao`
  MODIFY `idFuncao` int(11) NOT NULL AUTO_INCREMENT;

--

ALTER TABLE `Pet`
  MODIFY `idPet` int(11) NOT NULL AUTO_INCREMENT;

--

ALTER TABLE `Solicitacao`
  MODIFY `idSolicitacao` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `Usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT;

--

ALTER TABLE `Voluntario`
  MODIFY `idVoluntario` int(11) NOT NULL AUTO_INCREMENT;

--

ALTER TABLE `Adm_Pet`
  ADD CONSTRAINT `Adm_Pet_ibfk_1` FOREIGN KEY (`idPet`) REFERENCES `Pet` (`idPet`),
  ADD CONSTRAINT `Adm_Pet_ibfk_2` FOREIGN KEY (`idAdministrador`) REFERENCES `Administrador` (`idAdministrador`);

--
ALTER TABLE `Funcao`
  ADD CONSTRAINT `Funcao_ibfk_1` FOREIGN KEY (`idVoluntario`) REFERENCES `Voluntario` (`idVoluntario`);

--

ALTER TABLE `Pet`
  ADD CONSTRAINT `Pet_ibfk_1` FOREIGN KEY (`idVoluntario`) REFERENCES `Voluntario` (`idVoluntario`),
  ADD CONSTRAINT `Pet_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `Usuario` (`idUsuario`);

--

ALTER TABLE `Solicitacao`
  ADD CONSTRAINT `Solicitacao_ibfk_1` FOREIGN KEY (`idPet`) REFERENCES `Pet` (`idPet`),
  ADD CONSTRAINT `Solicitacao_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `Usuario` (`idUsuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
