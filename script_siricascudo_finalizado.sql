-- ========================================================
-- BANCO DE DADOS: SiriCascudoDB
-- ========================================================
DROP DATABASE IF EXISTS SiriCascudoDB;
CREATE DATABASE SiriCascudoDB;
USE SiriCascudoDB;

-- --------------------------------------------------------
-- 1. TABELA DE FUNCIONÁRIOS
-- --------------------------------------------------------
CREATE TABLE funcionarios (
    empregado_id INT PRIMARY KEY,
    primeiro_nome VARCHAR(50),
    ultimo_nome VARCHAR(50),
    salario_por_hora DECIMAL(5, 2),
    cargo VARCHAR(25),
    salario DECIMAL(10, 2),
    supervisor_id INT,
    data_contratacao DATE
);

INSERT INTO funcionarios (empregado_id, primeiro_nome, ultimo_nome, salario_por_hora, data_contratacao) 
VALUES 
(1, 'Eugene', 'Sirigueijo', 128.50, '2026-01-02'),
(2, 'Lula Molusco', 'Tentáculos', 6.50, '2026-01-03'),
(3, 'Bob Esponja', 'Calça Quadrada', 4.25, '2026-01-04'),
(4, 'Patrick', 'Estrela', 4.25, '2026-01-05'),
(5, 'Sandy', 'Bochechas', 12.00, '2026-01-06'),
(6, 'Gary', 'Caracol', 0.00, '2026-01-07');

-- Nomeando Cargos e Supervisores
UPDATE funcionarios SET cargo = 'Gerente' WHERE empregado_id = 1;
UPDATE funcionarios SET cargo = 'Caixa' WHERE empregado_id = 6;
UPDATE funcionarios SET cargo = 'Gerente Assistente' WHERE empregado_id = 5;
UPDATE funcionarios SET supervisor_id = 5 WHERE empregado_id = 3;

-- Self Join Funcionários / Supervisores
SELECT 
    a.primeiro_nome, 
    a.ultimo_nome,
    CONCAT(b.primeiro_nome, ' ', b.ultimo_nome) AS reporta_a
FROM funcionarios AS a
INNER JOIN funcionarios AS b ON a.supervisor_id = b.empregado_id;


-- --------------------------------------------------------
-- 2. TABELA DE PRODUTOS
-- --------------------------------------------------------
CREATE TABLE produtos (
    produto_id INT PRIMARY KEY,
    nome_produto VARCHAR(25) UNIQUE,
    preco DECIMAL(4, 2) NOT NULL DEFAULT 0.00
);

INSERT INTO produtos VALUES 
(100, 'Hambúrguer de Siri', 12.99),
(101, 'Batata Frita Marinha', 6.50),
(102, 'Refrigerante de Alga', 4.00),
(103, 'Sorvete de Coral', 5.50);

INSERT INTO produtos (produto_id, nome_produto) VALUES 
(104, 'Canudo'),
(105, 'Guardanapo'),
(106, 'Garfo'),
(107, 'Colher');


-- --------------------------------------------------------
-- 3. TABELA DE CLIENTES
-- --------------------------------------------------------
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    primeiro_nome VARCHAR(50),
    ultimo_nome VARCHAR(50),
    email VARCHAR(50),
    id_indicacao INT
);

INSERT INTO clientes (primeiro_nome, ultimo_nome, email) VALUES 
('Fred', 'Peixe', 'fpeixe@bikini.com'),
('Larry', 'Lagosta', 'llagosta@bikini.com'),
('Robalo', 'Bolha', 'BBass@gmail.com'),
('Poppy', 'Puff', 'PPuff@gmail.com'),
('Pérola', 'Sirigueijo', 'PKrabs@gmail.com');

UPDATE clientes SET id_indicacao = 2 WHERE id_cliente = 4;

-- Self Join Clientes / Indicações
SELECT 
    a.id_cliente, 
    a.primeiro_nome, 
    a.ultimo_nome,
    CONCAT(b.primeiro_nome, ' ', b.ultimo_nome) AS indicado_por
FROM clientes AS a
INNER JOIN clientes AS b ON a.id_indicacao = b.id_cliente;


-- --------------------------------------------------------
-- 4. TABELA DE TRANSAÇÕES
-- --------------------------------------------------------
CREATE TABLE transacoes (
    id_transacao INT PRIMARY KEY AUTO_INCREMENT,
    valor DECIMAL(5, 2),
    id_cliente INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_id_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
) AUTO_INCREMENT = 1000;

INSERT INTO transacoes (valor, id_cliente) VALUES 
(4.99, 3),
(2.89, 2),
(3.38, 3),
(4.99, 1),
(5.00, NULL);


-- --------------------------------------------------------
-- 5. VIEWS, ÍNDICES E SUBQUERIES
-- --------------------------------------------------------
CREATE VIEW emails_clientes AS
SELECT email FROM clientes;

CREATE INDEX idx_ultimo_primeiro_nome ON clientes(ultimo_nome, primeiro_nome);

SELECT primeiro_nome, ultimo_nome, salario_por_hora
FROM funcionarios
WHERE salario_por_hora > (SELECT AVG(salario_por_hora) FROM funcionarios);


-- --------------------------------------------------------
-- 6. AGREGAÇÕES E ROLLUP
-- --------------------------------------------------------
SELECT 
    id_cliente,
    COUNT(id_transacao) AS n_de_pedidos
FROM transacoes
GROUP BY id_cliente WITH ROLLUP;

SELECT 
    empregado_id,
    SUM(salario_por_hora) AS total_salario_hora
FROM funcionarios
GROUP BY empregado_id WITH ROLLUP;


-- --------------------------------------------------------
-- 7. STORED PROCEDURES
-- --------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obter_clientes()
BEGIN
    SELECT * FROM clientes;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE encontrar_cliente(
    IN p_primeiro_nome VARCHAR(50),
    IN p_ultimo_nome VARCHAR(50)
)
BEGIN
    SELECT * 
    FROM clientes
    WHERE primeiro_nome = p_primeiro_nome 
      AND ultimo_nome = p_ultimo_nome;
END $$
DELIMITER ;

CALL encontrar_cliente('Fred', 'Peixe');


-- --------------------------------------------------------
-- 8. TRIGGERS E TABELA DE DESPESAS
-- --------------------------------------------------------
-- Trigger para atualizar o salário anual ao alterar o salário_por_hora
DELIMITER $$
CREATE TRIGGER antes_atualizar_salario_por_hora
BEFORE UPDATE ON funcionarios
FOR EACH ROW
BEGIN
    SET NEW.salario = (NEW.salario_por_hora * 2080);
END $$
DELIMITER ;

-- Calcular salários iniciais (2080 horas / ano)
UPDATE funcionarios
SET salario = salario_por_hora * 2080
WHERE empregado_id > 0;

-- Testando a Trigger ao alterar o salário por hora do Sr. Sirigueijo
UPDATE funcionarios
SET salario_por_hora = 50.00
WHERE empregado_id = 1;

-- Tabela de Despesas
CREATE TABLE despesas (
    id_despesa INT PRIMARY KEY,
    nome_despesa VARCHAR(50),
    total_despesa DECIMAL(10, 2)
);

INSERT INTO despesas VALUES 
(1, 'salarios', 0),
(2, 'suprimentos', 0),
(3, 'impostos', 0);

-- Atualizando as despesas de salários com a soma total dos salários da folha
UPDATE despesas
SET total_despesa = (SELECT SUM(salario) FROM funcionarios)
WHERE id_despesa = 1;

-- Resultado final das despesas
SELECT * FROM despesas;
SELECT * FROM funcionarios;