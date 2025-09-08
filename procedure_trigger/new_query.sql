-- Adaptado para o Postgres

CREATE TABLE CLIENTE ( 
    id_cliente INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    nome VARCHAR(100), 
    email VARCHAR(100) 
); 

CREATE TABLE PRODUTO ( 
    id_produto INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    nome VARCHAR(100), preco DECIMAL(10, 2), 
    estoque INT 
); 

CREATE TABLE PEDIDO (
    id_pedido INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    id_cliente INT, 
    data_pedido TIMESTAMP DEFAULT NOW(), 
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente) 
);

 CREATE TABLE ITEM_PEDIDO ( 
    id_pedido INT, 
    id_produto INT, 
    quantidade INT, 
    preco_unitario DECIMAL(10, 2), 
    PRIMARY KEY (id_pedido, id_produto), 
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido), 
    FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto) 
); 

CREATE TYPE tipo_movimentacao_enum AS ENUM ('ENTRADA', 'SAÍDA');
CREATE TABLE LOG_ESTOQUE ( 
    id_log INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    id_produto INT, 
    quantidade_alterada INT, 
    data_log TIMESTAMP DEFAULT NOW(),
    tipo_movimentacao tipo_movimentacao_enum, 
    FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto) 
);


CREATE PROCEDURE realiza_pedido ( IN p_id_cliente INT, IN p_id_produto INT, IN p_quantidade INT ) 

AS $$

    DECLARE v_preco_unitario DECIMAL(10,2); 
    DECLARE v_estoque_atual INT; 
    DECLARE v_id_pedido INT; 

    BEGIN 
    
    SELECT estoque, preco 
    INTO v_estoque_atual, v_preco_unitario 
    FROM PRODUTO WHERE id_produto = p_id_produto; 
    
    IF v_estoque_atual < p_quantidade THEN RAISE EXCEPTION '45000 - Estoque insuficiente!'; 
        ELSE INSERT INTO PEDIDO (id_cliente) VALUES (p_id_cliente);

        INSERT INTO PEDIDO (id_cliente) VALUES (p_id_cliente)
        RETURNING id_pedido INTO v_id_pedido;

        INSERT INTO ITEM_PEDIDO (id_pedido, id_produto, quantidade, preco_unitario) 
        VALUES (v_id_pedido, p_id_produto, p_quantidade, v_preco_unitario); 
        
        UPDATE PRODUTO 
        SET estoque = estoque - p_quantidade 
        WHERE id_produto = p_id_produto; 
    
    END IF; 
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION trg_log_saida_estoque_func()
RETURNS trigger AS $$
    BEGIN
        IF NEW.estoque < OLD.estoque THEN
            INSERT INTO LOG_ESTOQUE (
                id_produto,
                quantidade_alterada,
                tipo_movimentacao
            ) VALUES (
                NEW.id_produto,
                OLD.estoque - NEW.estoque,
                'SAÍDA'::tipo_movimentacao_enum
            );
        END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_log_saida_estoque
AFTER UPDATE ON PRODUTO
FOR EACH ROW
EXECUTE FUNCTION trg_log_saida_estoque_func();


-- Inserindo dados nas tabelas
INSERT INTO CLIENTE (nome, email) VALUES
('Ana Silva', 'ana@email.com'),
('João Souza', 'joao@email.com'),
('Maria Lima', 'maria@email.com'),
('Pedro Alves', 'pedro@email.com'),
('Carla Santos', 'carla@email.com');

INSERT INTO PRODUTO (nome, preco, estoque) VALUES
('Produto A', 10.50, 100),
('Produto B', 25.00, 50),
('Produto C', 7.90, 200),
('Produto D', 15.75, 80),
('Produto E', 5.25, 150);

INSERT INTO PEDIDO (id_cliente, data_pedido) VALUES
(1, NOW()),
(2, NOW()),
(3, NOW()),
(1, NOW()),
(4, NOW());

INSERT INTO ITEM_PEDIDO (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 10.50),
(1, 3, 1, 7.90),
(2, 2, 3, 25.00),
(3, 5, 5, 5.25),
(4, 4, 2, 15.75),
(5, 1, 1, 10.50),
(5, 2, 1, 25.00);

INSERT INTO LOG_ESTOQUE (id_produto, quantidade_alterada, tipo_movimentacao) VALUES
(1, 2, 'SAÍDA'),
(3, 1, 'SAÍDA'),
(2, 3, 'SAÍDA'),
(5, 5, 'SAÍDA'),
(4, 2, 'SAÍDA'),
(1, 1, 'SAÍDA'),
(2, 1, 'SAÍDA');

-- Cliente 1 compra 3 unidades do Produto 2
CALL realiza_pedido(1, 2, 3);

-- Cliente 3 compra 1 unidade do Produto 1
CALL realiza_pedido(3, 1, 1);

-- Cliente 2 compra 5 unidades do Produto 5
CALL realiza_pedido(4, 2, 2);

SELECT * FROM produto;
SELECT * FROM cliente;
SELECT * FROM log_estoque;
