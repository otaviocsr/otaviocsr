-- ============================================================
-- Sistema de Pedidos de Restaurante
-- Entidades: Cliente, Prato, Funcionario, Pedido
-- ============================================================


-- ============================================================
-- CREATE TABLES
-- ============================================================

CREATE TABLE Cliente (
    id_cliente   INT          PRIMARY KEY AUTO_INCREMENT,
    nome         VARCHAR(100) NOT NULL,
    telefone     VARCHAR(20),
    email        VARCHAR(100) UNIQUE,
    data_cadastro DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Prato (
    id_prato     INT          PRIMARY KEY AUTO_INCREMENT,
    nome         VARCHAR(100) NOT NULL,
    descricao    VARCHAR(255),
    categoria    VARCHAR(50)  NOT NULL,  -- ex: 'Entrada', 'Prato Principal', 'Sobremesa', 'Bebida'
    preco        DECIMAL(8,2) NOT NULL
);

CREATE TABLE Funcionario (
    id_funcionario INT          PRIMARY KEY AUTO_INCREMENT,
    nome           VARCHAR(100) NOT NULL,
    cargo          VARCHAR(50)  NOT NULL,  -- ex: 'Garcom', 'Cozinheiro', 'Gerente', 'Caixa'
    salario        DECIMAL(9,2) NOT NULL,
    data_admissao  DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Pedido (
    id_pedido      INT          PRIMARY KEY AUTO_INCREMENT,
    id_cliente     INT          NOT NULL,
    id_funcionario INT          NOT NULL,
    id_prato       INT          NOT NULL,
    quantidade     INT          NOT NULL DEFAULT 1,
    status         VARCHAR(30)  NOT NULL DEFAULT 'Aguardando',  -- 'Aguardando', 'Preparando', 'Entregue', 'Cancelado'
    data_pedido    DATETIME     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente)     REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
    FOREIGN KEY (id_prato)       REFERENCES Prato(id_prato)
);


-- ============================================================
-- INSERTS
-- ============================================================

INSERT INTO Cliente (nome, telefone, email, data_cadastro) VALUES
    ('Ana Paula Silva',    '(11) 91234-5678', 'ana.paula@email.com',   '2024-01-10'),
    ('Carlos Eduardo Lima','(21) 98765-4321', 'carlos.lima@email.com', '2024-02-15'),
    ('Beatriz Souza',      '(31) 99988-7766', 'bia.souza@email.com',   '2024-03-05'),
    ('Rafael Mendes',      '(41) 97654-3210', 'rafael.m@email.com',    '2024-04-20');

INSERT INTO Prato (nome, descricao, categoria, preco) VALUES
    ('Caldo Verde',         'Sopa de couve com linguiça',             'Entrada',        18.00),
    ('Filé à Parmegiana',   'Filé de frango empanado com molho',      'Prato Principal',52.50),
    ('Pudim de Leite',      'Pudim cremoso com calda de caramelo',    'Sobremesa',      15.00),
    ('Suco de Maracujá',    'Suco natural de maracujá 500 ml',        'Bebida',          9.00);

INSERT INTO Funcionario (nome, cargo, salario, data_admissao) VALUES
    ('Mariana Costa',  'Garcom',    2200.00, '2023-06-01'),
    ('José Ferreira',  'Cozinheiro',3500.00, '2022-03-15'),
    ('Fernanda Rocha', 'Gerente',   5800.00, '2021-11-20'),
    ('Lucas Alves',    'Caixa',     2100.00, '2024-01-08');

INSERT INTO Pedido (id_cliente, id_funcionario, id_prato, quantidade, status, data_pedido) VALUES
    (1, 1, 2, 1, 'Entregue',   '2024-04-17 12:30:00'),
    (2, 1, 4, 2, 'Entregue',   '2024-04-17 13:00:00'),
    (3, 2, 3, 1, 'Preparando', '2024-04-17 13:15:00'),
    (4, 2, 1, 1, 'Aguardando', '2024-04-17 13:45:00');


-- ============================================================
-- UPDATE
-- ============================================================

-- Atualiza o status do pedido 3 para 'Entregue'
UPDATE Pedido
SET status = 'Entregue'
WHERE id_pedido = 3;


-- ============================================================
-- DELETE
-- ============================================================

-- Remove o pedido com status 'Cancelado' (condição normal por status)
DELETE FROM Pedido
WHERE status = 'Cancelado';


-- ============================================================
-- SELECT ALL VALUES FROM A TABLE
-- ============================================================

-- Lista todos os clientes cadastrados
SELECT * FROM Cliente;


-- ============================================================
-- SELECT BY A CHOSEN ATTRIBUTE
-- ============================================================

-- Lista todos os pratos da categoria 'Prato Principal'
SELECT id_prato, nome, descricao, preco
FROM Prato
WHERE categoria = 'Prato Principal';


-- ============================================================
-- SUM QUERY
-- ============================================================

-- Soma o valor total gerado por todos os pedidos entregues
SELECT SUM(p.preco * pe.quantidade) AS total_faturado
FROM Pedido pe
JOIN Prato p ON pe.id_prato = p.id_prato
WHERE pe.status = 'Entregue';


-- ============================================================
-- GROUP BY WITH SUM (tipo de atributo + soma agrupada)
-- ============================================================

-- Categoria do prato e a soma do valor total de pedidos agrupada por categoria
SELECT p.categoria                          AS categoria_prato,
       SUM(p.preco * pe.quantidade)         AS total_por_categoria
FROM Pedido pe
JOIN Prato p ON pe.id_prato = p.id_prato
GROUP BY p.categoria
ORDER BY total_por_categoria DESC;
