-- CLIENTE (id_cliente, nome)
--PRODUTO (id_produto, nome, preco)
--PEDIDO (id_pedido, id_cliente, data_pedido)
--ITEM_PEDIDO (id_item, id_pedido, id_produto, quantidade)
--AUDITORIA_PEDIDO (id_auditoria, id_pedido, acao, data_modificacao) 

CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR (100)
)

CREATE TABLE PRODUTO(
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL (10,2)
)

CREATE TABLE PEDIDO (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT, FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
    data_pedido DATE
)

CREATE TABLE ITEM_PEDIDO (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT, FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
    id_produto INT, FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto),
    quantidade INT
)

CREATE TABLE AUDITORIA_PEDIDO(
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT, FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
    acao VARCHAR (100),
    data_modificacao DATE
)

-- PROCEDURES
DELIMITER $$
    CREATE PROCEDURE InserirPedido (
        IN p_id_cliente INT,
        IN p_data_pedido DATE,
        IN p_id_produto1 INT,
        IN p_qtd1 INT,
        IN p_id_produto2 INT,
        IN p_qtd2 INT
    )
    BEGIN
        DECLARE novo_pedido_id INT;

        -- Inserir pedido
        INSERT INTO PEDIDO (id_cliente, data_pedido)
        VALUES (p_id_cliente, p_data_pedido);

        SET novo_pedido_id = LAST_INSERT_ID();

        -- Inserir itens
        INSERT INTO ITEM_PEDIDO (id_pedido, id_produto, quantidade)
        VALUES (novo_pedido_id, p_id_produto1, p_qtd1),
            (novo_pedido_id, p_id_produto2, p_qtd2);
    END $$
DELIMITER ;

DELIMITER $$
    CREATE FUNCTION CalcularTotalPedido(pedido_id INT)
    RETURNS DECIMAL(10, 2)
    DETERMINISTIC
    READS SQL DATA

    BEGIN
        DECLARE total DECIMAL(10,2);

        SELECT SUM(p.preco * ip.quantidade)
        INTO total
        FROM ITEM_PEDIDO ip
        JOIN PRODUTO p ON ip.id_produto = p.id_produto
        WHERE ip.id_pedido = pedido_id;

        RETURN IFNULL(total, 0);
    END $$
DELIMITER ;

--Não funcionou
--DELIMITER $$
    --CREATE TRIGGER trg_auditoria_pedido
       -- AFTER UPDATE ON PEDIDO
        --FOR EACH ROW

    --BEGIN
        --INSERT INTO AUDITORIA_PEDIDO (id_pedido, acao)
      --  VALUES (NEW.id_pedido, 'UPDATE');
   -- END $$
--DELIMITER ;


--

INSERT INTO cliente (nome)
VALUES
    ('Cliente1'),
    ('Cliente2'),
    ('Cliente3'),
    ('Cliente4')
;

INSERT INTO produto (nome, preco)
VALUES
    ('Produto1', 15.69),
    ('Produto2', 34.99),
    ('Produto3', 100.00),
    ('Produto4', 57.39),
    ('Produto5', 14.20)
;

CALL InserirPedido(10, CURDATE(), 11, 3, 14, 2); 
CALL InserirPedido(10, CURDATE(), 12, 1, 12, 3); 
CALL InserirPedido(13, CURDATE(), 11, 3, 14, 2); 
CALL InserirPedido(12, CURDATE(), 12, 1, 12, 3); 

SELECT * FROM pedido;

----
-- 1) Liste os pedidos, considerando a soma do valor dos produtos multiplicado pela quantidade em todos os pedidos. Traga:
--Nome do cliente
--Total comprado (como total_gasto)
--Quantidade total de itens comprados

SELECT 
    c.nome AS cliente,
    SUM(p.preco * ip.quantidade) AS total_gasto,
    SUM(ip.quantidade) AS total_itens
FROM cliente c
JOIN pedido pe ON c.id_cliente = pe.id_cliente
JOIN item_pedido ip ON pe.id_pedido = ip.id_pedido
JOIN produto p ON ip.id_produto = p.id_produto
GROUP BY c.id_cliente, c.nome
ORDER BY total_gasto DESC;

--2) Liste todos os pedidos que nos últimos 30 dias. Para cada pedido, exiba:
--ID do pedido
--Data do pedido
--Nome do cliente
--Data da última modificação

SELECT 
    pe.id_pedido, 
    pe.data_pedido, 
    c.nome AS cliente, 
    MAX(a.data_modificacao) AS ultima_modificacao
FROM pedido pe
JOIN cliente c ON pe.id_cliente = c.id_cliente
LEFT JOIN auditoria_pedido a ON pe.id_pedido = a.id_pedido
WHERE pe.data_pedido >= CURDATE() - INTERVAL 30 DAY
GROUP BY pe.id_pedido, pe.data_pedido, c.nome
ORDER BY pe.data_pedido DESC;

--Liste todos os produtos que já foram incluídos em algum pedido. Para cada produto, exiba:
--Nome do produto
--Quantidade total vendida
--Categoria fictícia:
--se a soma da quantidade for maior que 50
--se entre 10 e 50
--se menos que 10
--Utilize IF() no SELECT para fazer essa classificação.

SELECT 
    pr.nome AS produto,
    SUM(ip.quantidade) AS total_vendido,
    IF(SUM(ip.quantidade) > 50, 'mais de 50',
       IF(SUM(ip.quantidade) >= 10, 'entre 10 e 50', 'menos que 10')) AS categoria
FROM produto pr
JOIN item_pedido ip ON pr.id_produto = ip.id_produto
GROUP BY pr.id_produto, pr.nome
ORDER BY total_vendido DESC;


