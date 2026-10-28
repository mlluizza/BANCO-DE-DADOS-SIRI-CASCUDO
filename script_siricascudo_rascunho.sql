-- ========================================================
-- BANCO DE DADOS: SiriCascudoDB
-- ========================================================
create database SiriCascudoDB;
use SiriCascudoDB;

-- --------------------------------------------------------
-- 1. TABELA DE FUNCIONÁRIOS
-- --------------------------------------------------------
CREATE TABLE funcionarios (
	empregado_id INT, 
    primeiro_nome VARCHAR(50),
    ultimo_nome VARCHAR(50),
    salario_por_hora DECIMAL(5, 2),
    data_contratacao DATE
);

INSERT INTO funcionarios 
VALUES (1, "Eugene", "Sirigueijo", 128.50, "2026-01-02"),
	   (2, "Lula Molusco", "Tentáculos", 6.50, "2026-01-03"),
       (3, "Bob Esponja", "Calça Quadrada", 4.25,  "2026-01-04"),
       (4, "Patrick", "Estrela", 4.25, "2026-01-05"),
       (5, "Sandy", "Bochechas", 12.00, "2026-01-06");

-- Se caso o Sr. Sirigueijo não tiver valor definido ainda 
INSERT INTO funcionarios (empregado_id, primeiro_nome, ultimo_nome) -- Lista as colunas que precisa colocar
VALUES (6, "Gary", "Caracol");

-- Definir o Id como chave primária
ALTER TABLE funcionarios 
MODIFY COLUMN empregado_id INT PRIMARY KEY;

-- Atualizar as informações do Gary 
UPDATE funcionarios  
SET data_contratacao = "2026-01-07"
WHERE empregado_id = 6;

SELECT * FROM funcionarios;

-- Remover duplicados onde há masi de 1 registro
DELETE FROM funcionarios
WHERE empregado_id = 7 
LIMIT 1;

SELECT * FROM funcionarios;

-- Tabela de Produtos
CREATE TABLE produtos (
	produto_id INT,
    nome_produto VARCHAR(25) UNIQUE,
    preco DECIMAL (4,2)
);

ALTER TABLE produtos
ADD CONSTRAINT
UNIQUE (nome_produto);

SELECT * FROM produtos;

INSERT INTO produtos
VALUES (100, "Hambúrguer de Siri", 12.99),
	   (101, "Batata Frita Marinha", 6.50),
       (102, "Refrigerante de Alga", 4.00),
       (103, "Sorvete de Coral", 5.50);
       
-- Colocar restrição NOT NULL 
ALTER TABLE produtos
MODIFY preco DECIMAL (4, 2) NOT NULL;

-- Teste 
INSERT INTO produtos 
VALUES (104, "Cookie", 0);

-- Default 
SELECT * FROM produtos;
DESCRIBE produtos;
INSERT INTO produtos (produto_id, nome_produto, preco)
VALUES (104, 'Canudo', 0.00),
       (105, 'Guardanapo', 0.00),
       (106, 'Garfo', 0.00),
       (107, 'Colher', 0.00);

DELETE FROM produtos 
WHERE produto_id >= 104;
SELECT * FROM produtos;

CREATE TABLE produtos (
	produto_id INT,
    nome_produto VARCHAR(25),
    preco DECIMAL(4, 2)   -- Colocar uma retrição para colocar o valor padrão de 0.00 reias 
);

ALTER TABLE produtos
ALTER preco SET DEFAULT 0;

SELECT * FROM produtos;
INSERT INTO produtos (produto_id, nome_produto)
VALUES (104, 'Canudo'),
       (105, 'Guardanapo'),
       (106, 'Garfo'),
       (107, 'Colher');
	
-- Todos os preços definidos por zero e não precisar declarar isso explicitamente. Se não especificar um valor
-- usará o valor padrão. Tabel de transações após inserir uma nova transação inserir data e hora quando essa transação sendo padrão


-- AUTO_INCREMENT - Coluna deficnida como chave 
CREATE TABLE transacoes (
	transacao_id INT PRIMARY KEY AUTO_INCREMENT,
    valor DECIMAL(5, 2)
);

ALTER TABLE transacoes 
AUTO_INCREMENT = 1000;

SELECT * FROM transacoes;

INSERT INTO transacoes (valor)
VALUES (4.99),
       (2.89),
       (3.38),
       (4.99);
 -- Teste de transação não esquecer de dropar para colcoar a restrição 
 -- Criar clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    primeiro_nome VARCHAR(50),
    ultimo_nome VARCHAR(50)
);

SELECT * FROM clientes;

INSERT INTO clientes (primeiro_nome, ultimo_nome)
VALUES ('Fred', 'Peixe'),
       ('Larry', 'Lagosta'),
       ('Robalo', 'Bolha');

SELECT * FROM clientes;

-- Recriação da tabela aplicando a restrição e criar uma terceira coluna para armazenar o ID do cliente 
DROP TABLE transacoes;

CREATE TABLE transacoes (
    id_transacao INT PRIMARY KEY AUTO_INCREMENT,
    valor DECIMAL(5, 2),
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

SELECT * FROM transacoes; 

-- A foreign key transactions_ibfk_1 foi criada automaticamente pelo MySQL com um nome padrão 
-- quando a tabela foi definida inicialmente fal=cilitar a identificação e o gerenciamento da chave estrangeia do futuro 
-- Precisa remover a chave antiga para poder adiocionar uma nova regra que definem o que acontececom os dados relacionados quando um registro pai é excluído
ALTER TABLE transacoes
DROP FOREIGN KEY transacoes_ibfk_1;

ALTER TABLE transacoes
ADD CONSTRAINT fk_id_cliente -- Adicionar um arestrição já existente
FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente);

-- Adicionar um valor a cada chave estrangeira apagano a tabela de transações 
-- O objetivo não é seletar os dados, mas sim limpar s tabela e reconfigurá-la com regras de integridade
DELETE FROM transacoes;
SELECT * FROM transacoes;

ALTER TABLE transacoes
AUTO_INCREMENT = 1000;

INSERT INTO transacoes (valor, id_cliente)
VALUES (4.99, 3), -- Cada um desses ID de cliente referencia de ID do cliente da tabela além de uma resrição de chave estrangeira 
       (2.89, 2),
       (3.38, 3),
       (4.99, 1);

SELECT * FROM transacoes;

DELETE FROM clientes
WHERE id_cliente = 3; -- Tenta deletar o cliente quando há uma chave estrangeira 

-- JOINS 
--  Cliente que paga com cartão: Quando um cliente usa um cartão de crédito ou débito, o sistema geralmente exige que ele esteja cadastrado. Assim, o banco de dados registra o customer_id (ID do cliente) na transação, criando um vínculo entre quem comprou e o que foi comprado.
--  Cliente que paga com dinheiro: Se alguém entra no estabelecimento e paga apenas com dinheiro em espécie, o sistema pode não registrar quem é o cliente (já que ele não precisa estar cadastrado). Nesse caso, o campo customer_id na transação fica vazio (NULL), indicando que não há um cliente específico vinculado àquela venda.

INSERT INTO transacoes (valor, id_cliente)
VALUES (5.00, NULL);

SELECT * FROM transacoes;

INSERT INTO clientes (primeiro_nome, ultimo_nome)
VALUES ('Poppy', 'Puff');

SELECT * FROM clientes;

SELECT *
FROM transacoes INNER JOIN clientes
ON transacoes.id_cliente = clientes.id_cliente;

SELECT id_transacao, valor, primeiro_nome, ultimo_nome
FROM transacoes INNER JOIN clientes
ON transacoes.id_cliente = clientes.id_cliente;

SELECT *
FROM transacoes RIGHT JOIN clientes
ON transacoes.id_cliente = clientes.id_cliente;

-- FUNCTIONS
SELECT COUNT(valor) AS "transacoes_de_hoje"
FROM transacoes;

-- Calculo de salário
ALTER TABLE funcionarios
ADD COLUMN cargo VARCHAR(25) AFTER salario_por_hora;

SELECT * FROM funcionarios;

-- Nomeando Cargos
UPDATE funcionarios
SET cargo = 'Gerente'
WHERE empregado_id = 1;

UPDATE funcionarios
SET cargo = 'Caixa'
WHERE empregado_id = 6;

UPDATE funcionarios
SET cargo = 'Gerente Assistente '
WHERE empregado_id = 5;

SELECT * FROM funcionarios;

-- SELF JOIN
-- Junta uma cópia de uma tabela a ela própria
-- Usado para comparar linhas da mesma tabela
-- Ajuda a mostrar a hierarquia dos dados

SELECT * FROM clientes;

-- Criar uma coluna chamada indicações tipo ganhar uma refeição gratis 
ALTER TABLE clientes
ADD COLUMN id_indicacao INT;

SELECT * FROM clientes;

UPDATE clientes
SET id_indicacao = 2 -- Parece esquema de pirâmide kkk não esquecer de corrigir!  
WHERE id_cliente = 4;

SELECT * FROM clientes;

SELECT 
    a.id_cliente, 
    a.primeiro_nome, 
    a.ultimo_nome,
    CONCAT(b.primeiro_nome, ' ', b.ultimo_nome) AS "indicado_por"
FROM clientes AS a
INNER JOIN clientes AS b
ON a.id_indicacao = b.id_cliente;

ALTER TABLE funcionarios
ADD supervisor_id INT;

-- Colocar um supervisor de um funcionário especifico 
SELECT * FROM funcionarios;

UPDATE funcionarios
SET supervisor_id = 5
WHERE empregado_id = 3;

SELECT 
    a.primeiro_nome, 
    a.ultimo_nome,
    CONCAT(b.primeiro_nome, ' ', b.ultimo_nome) AS "reporta_a"
FROM funcionarios AS a
INNER JOIN funcionarios AS b
ON a.supervisor_id = b.empregado_id;


-- Views
-- Uma tabela virtual baseada no resultado de uma instrução SQL
-- Os campos em uma view vêm de uma ou mais tabelas reais do banco de dados
-- Não são tabelas reais, mas podem ser consultadas como se fossem

-- Criação de visualização de e-mail de clientes
SELECT * FROM funcionarios;

ALTER TABLE clientes
ADD COLUMN email VARCHAR(50);

UPDATE clientes
SET email = 'BBass@gmail.com'
WHERE id_cliente = 3;

UPDATE clientes
SET email = 'PPuff@gmail.com'
WHERE id_cliente = 4;

SELECT * FROM clientes;

CREATE VIEW emails_clientes AS
SELECT email
FROM clientes;

INSERT INTO clientes
VALUES (5, 'Pérola', 'Siriguejo', NULL, 'PKrabs@gmail.com');

INSERT INTO clientes
VALUES (5, 'Pérola', 'Siriguejo', NULL, 'PKrabs@gmail.com');

SELECT * FROM clientes;

-- INDEX (Estrutura de dados B-Tree)
-- Índices são usados para encontrar valores em uma coluna específica mais rapidamente
-- O MySQL normalmente pesquisa sequencialmente linha por linha em uma coluna
-- Quanto maior a tabela, mais custosa/lenta é a operação de busca
-- UPDATE/INSERT demoram mais tempo, mas o SELECT fica muito mais rápido

CREATE INDEX idx_ultimo_nome
ON clientes(ultimo_nome);

SHOW INDEXES FROM clientes;

SELECT * FROM clientes
WHERE ultimo_nome = "Puff";

-- Index de multiplas colunas 
CREATE INDEX idx_ultimo_primeiro_nome
ON clientes(ultimo_nome, primeiro_nome);

ALTER TABLE clientes
DROP INDEX idx_ultimo_nome;

SELECT * FROM clientes
WHERE ultimo_nome = 'Puff' AND primeiro_nome = 'Poppy';

-- Subquery (Subconsulta)
-- Uma consulta dentro de outra consulta
-- consulta_principal(subconsulta)

SELECT * FROM funcionarios;

SELECT 
    primeiro_nome, 
    ultimo_nome, 
    salario_por_hora,
    (SELECT AVG(salario_por_hora) FROM funcionarios) AS media_salaria
FROM funcionarios;

-- Filtrar registros com base em uma comparação com um valor calculado (a média)
SELECT primeiro_nome, ultimo_nome, salario_por_hora
FROM funcionarios
WHERE salario_por_hora > (SELECT AVG(salario_por_hora) FROM funcionarios);

-- Sr. Siriguihjo que somar todos os valores 
ALTER TABLE transacoes
ADD COLUMN data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP;

UPDATE transacoes
SET data_pedido = NOW()
WHERE id_transacao > 0 AND data_pedido IS NULL;

SELECT * FROM transacoes;

SELECT 
    data_pedido,
    SUM(valor) AS total_diario
FROM transacoes
GROUP BY data_pedido;

-- ROLLUP: extensão da cláusula GROUP BY
-- Produz uma linha adicional mostrando o TOTAL GERAL (valor super-agregado)


-- Realizar a contagem de transações 
SELECT 
    COUNT(id_transacao) AS "n_de_pedidos",
    id_cliente
FROM transacoes
GROUP BY id_cliente WITH ROLLUP;


SELECT 
    COUNT(id_transacao) AS total_pedidos,
    DATE(data_pedido) AS dia
FROM transacoes
GROUP BY DATE(data_pedido) WITH ROLLUP;

-- Quantoe estamos gastando com todos os nossos funcionários por hora?
SELECT 
    SUM(salario_por_hora) AS "salario_por_hora",
    empregado_id
FROM funcionarios
GROUP BY empregado_id WITH ROLLUP;

-- Stored procedure = é um código SQL preparado que você pode salvar
--                    se houver uma consulta que você escreve com frequência

SELECT DISTINCT primeiro_nome, ultimo_nome
FROM transacoes
INNER JOIN clientes
ON transacoes.id_cliente = clientes.id_cliente; 


DELIMITER $$

CREATE PROCEDURE obter_clientes()
BEGIN
    SELECT * FROM clientes;
END $$

DELIMITER ;


DROP PROCEDURE obter_clientes;

DELIMITER $$

CREATE PROCEDURE encontrar_cliente(IN id INT)
BEGIN
    SELECT *
    FROM clientes
    WHERE id_cliente = id;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS encontrar_cliente;

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

-- Trigger = Quando um evento acontece, faz alguma coisa
--           ex. (INSERT, UPDATE, DELETE)
--           verifica dados, trata erros, auditoria de tabelas

SELECT * FROM funcionarios;

ALTER TABLE funcionarios
ADD COLUMN salario DECIMAL(10, 2) AFTER salario_por_hora;


CREATE TRIGGER antes_atualizar_salario_por_hora
BEFORE UPDATE ON funcionarios
FOR EACH ROW
SET NEW.salario = (NEW.salario_por_hora * 2080);

UPDATE funcionarios
SET salario = salario_por_hora * 2080
WHERE empregado_id > 0;

UPDATE funcionarios
SET salario_por_hora = 50
WHERE empregado_id = 1;

 SHOW TRIGGERS;
 
 UPDATE funcionarios
SET salario_por_hora = 50
WHERE empregado_id = 1;


SELECT * FROM funcionarios;

-- Dispensa
CREATE TABLE despesas (
    id_despesa INT PRIMARY KEY,
    nome_despesa VARCHAR(50),
    total_despesa DECIMAL(10, 2)
);

INSERT INTO despesas
VALUES (1, "salarios", 0),
       (2, "suprimentos", 0),
       (3, "impostos", 0);

UPDATE despesas
SET total_despesa = (SELECT SUM(salario) FROM funcionarios)
WHERE id_despesa = 1;

SELECT * FROM despesas;