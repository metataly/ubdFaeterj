-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 19/08/2025 às 16:52
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
-- Banco de dados: `UBD`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `vendas`
--

CREATE TABLE `vendas` (
  `id` int(11) NOT NULL,
  `produto` varchar(255) NOT NULL,
  `data_venda` date NOT NULL,
  `valor` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `vendas`
--

INSERT INTO `vendas` (`id`, `produto`, `data_venda`, `valor`) VALUES
(1, 'Maçã', '2025-01-03', 3.5),
(2, 'Banana', '2025-01-07', 2.8),
(3, 'Laranja', '2025-01-15', 4.2),
(4, 'Abacaxi', '2025-01-22', 6),
(5, 'Manga', '2025-02-01', 5.5),
(6, 'Melancia', '2025-02-05', 9.9),
(7, 'Uva', '2025-02-12', 7.3),
(8, 'Morango', '2025-02-20', 8.75),
(9, 'Kiwi', '2025-03-01', 6.8),
(10, 'Pêssego', '2025-03-09', 5.2),
(11, 'Limão', '2025-03-15', 3),
(12, 'Coco', '2025-03-25', 4.9),
(13, 'Goiaba', '2025-04-02', 3.75),
(14, 'Mamão', '2025-04-10', 6.4),
(15, 'Maracujá', '2025-04-18', 5.95),
(16, 'Ameixa', '2025-04-27', 4.6),
(17, 'Tangerina', '2025-05-05', 4.3),
(18, 'Framboesa', '2025-05-15', 9.2),
(19, 'Cereja', '2025-06-10', 12),
(20, 'Figo', '2025-06-25', 7.1);

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `vendas`
--
ALTER TABLE `vendas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_data_venda` (`data_venda`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `vendas`
--
ALTER TABLE `vendas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
