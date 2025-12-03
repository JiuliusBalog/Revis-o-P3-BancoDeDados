

CREATE DATABASE ex05
GO
USE ex05
GO
CREATE TABLE fornecedor (
codigo INT NOT NULL,
nome VARCHAR(50) NOT NULL,
atividade VARCHAR(80) NOT NULL,
telefone CHAR(8) NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE cliente (
codigo INT NOT NULL,
nome VARCHAR(50) NOT NULL,
logradouro VARCHAR(80) NOT NULL,
numero INT NOT NULL,
telefone CHAR(8) NOT NULL,
data_nasc DATE NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE produto (
codigo INT NOT NULL,
nome VARCHAR(50) NOT NULL,
valor_unitario DECIMAL(7,2) NOT NULL,
qtd_estoque INT NOT NULL,
descricao VARCHAR(80) NOT NULL,
cod_forn INT NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(cod_forn) REFERENCES fornecedor(codigo)
)
GO
CREATE TABLE pedido (
codigo INT NOT NULL,
cod_cli INT NOT NULL,
cod_prod INT NOT NULL,
quantidade INT NOT NULL,
previsao_ent DATE NOT NULL
PRIMARY KEY(codigo, cod_cli, cod_prod, previsao_ent)
FOREIGN KEY(cod_cli) REFERENCES cliente(codigo),
FOREIGN KEY(cod_prod) REFERENCES produto(codigo)
)
GO
INSERT INTO fornecedor VALUES (1001,'Estrela','Brinquedo','41525898')
INSERT INTO fornecedor VALUES (1002,'Lacta','Chocolate','42698596')
INSERT INTO fornecedor VALUES (1003,'Asus','Informática','52014596')
INSERT INTO fornecedor VALUES (1004,'Tramontina','Utensílios Domésticos','50563985')
INSERT INTO fornecedor VALUES (1005,'Grow','Brinquedos','47896325')
INSERT INTO fornecedor VALUES (1006,'Mattel','Bonecos','59865898')
INSERT INTO cliente VALUES (33601,'Maria Clara','R. 1° de Abril',870,'96325874','15/08/2000')
INSERT INTO cliente VALUES (33602,'Alberto Souza','R. XV de
Novembro',987,'95873625','02/02/1985')
INSERT INTO cliente VALUES (33603,'Sonia Silva','R. Voluntários da
Pátria',1151,'75418596','23/08/1957')
INSERT INTO cliente VALUES (33604,'José Sobrinho','Av. Paulista',250,'85236547','09/12/1986')
GO
INSERT INTO cliente VALUES (33605,'Carlos Camargo','Av.
Tiquatira',9652,'75896325','25/03/1971')
INSERT INTO produto VALUES (1,'Banco Imobiliário',65.00,15,'Versão Super Luxo',1001)
INSERT INTO produto VALUES (2,'Puzzle 5000 peças',50.00,5,'Mapas Mundo',1005)
INSERT INTO produto VALUES (3,'Faqueiro',350.00,0,'120 peças',1004)
INSERT INTO produto VALUES (4,'Jogo para churrasco',75.00,3,'7 peças',1004)
INSERT INTO produto VALUES (5,'Tablet',750.00,29,'Tablet',1003)
INSERT INTO produto VALUES (6,'Detetive',49.00,0,'Nova Versão do Jogo',1001)
INSERT INTO produto VALUES (7,'Chocolate com Paçoquinha',6.00,0,'Barra',1002)
INSERT INTO produto VALUES (8,'Galak',5.00,65,'Barra',1002)
INSERT INTO pedido VALUES (99001,33601,1,1,'07/03/2023')
INSERT INTO pedido VALUES (99001,33601,2,1,'07/03/2023')
INSERT INTO pedido VALUES (99001,33601,8,3,'07/03/2023')
INSERT INTO pedido VALUES (99002,33602,2,1,'09/03/2023')
INSERT INTO pedido VALUES (99002,33602,4,3,'09/03/2023')
INSERT INTO pedido VALUES (99003,33605,5,1,'15/03/2023')
GO
SELECT * FROM fornecedor
SELECT * FROM produto
SELECT * FROM cliente
SELECT * FROM pedido

-- Exercícios

-- 1) Consultar a quantidade, valor total e valor total com desconto (25%) dos itens
-- comprados para Maria Clara.

SELECT 
	pedido.quantidade,
	produto.valor_unitario * pedido.quantidade AS ValorTotal,
	(produto.valor_unitario * pedido.quantidade) * 0.25 + (produto.valor_unitario * pedido.quantidade) AS ValorTotalDescontado
FROM
	produto
INNER JOIN
	pedido ON produto.codigo = pedido.cod_prod
INNER JOIN
	cliente ON pedido.cod_cli = cliente.codigo
WHERE
	cliente.nome LIKE '%Maria Clara%'

-- 2) Consultar quais brinquedos não tem itens em estoque.

SELECT 
	produto.nome
FROM
	produto
INNER JOIN
	fornecedor ON produto.cod_forn = fornecedor.codigo
WHERE
	fornecedor.atividade LIKE '%Brinquedo%' and
	produto.qtd_estoque <= 0

-- 3) Consultar quais nome e descrições de produtos que não estão em pedidos

SELECT
	produto.nome,
	produto.descricao,
	produto.codigo
FROM
	produto
LEFT JOIN
	pedido ON produto.codigo = pedido.cod_prod
WHERE
	pedido.cod_prod IS NULL

-- 4) Alterar a quantidade do faqueiro pra 10 peças

UPDATE produto
SET qtd_estoque = 10
WHERE nome = 'Faqueiro'

-- 5) Consultar quantos clientes tem mais de 40 anos

SELECT COUNT(codigo) AS qtd_cliente40
FROM cliente
WHERE CONVERT(INTEGER, DATEDIFF(DAY, data_nasc, GETDATE()) / 365) > 40

-- 6) Consultar Nome e Telefone formatado dos fornecedores de Brinquedos e Chocolate

SELECT nome AS nomeFornecedora, SUBSTRING(telefone, 1,4) + '-' + SUBSTRING(telefone, 5,4) AS telefoneFornecedora
FROM fornecedor
WHERE atividade LIKE '%Brinquedo%' OR atividade = 'Chocolate'

-- 7) Nome e desconto de 25% no preço dos produtos que custam menos do que R$50,00

SELECT nome, valor_unitario - (valor_unitario * 0.25) AS ValorDescontado
FROM produto
WHERE valor_unitario < 50.0

-- 8) Nome e aumento de 10% no preço dos produtos que custam mais do que R$100,00

SELECT * FROM produto

SELECT nome, valor_unitario + (valor_unitario * 0.10) AS ValorAdicionado
FROM produto
WHERE valor_unitario > 100.0

-- 9) Consultar desconto de 15% no valor total de cada produto da venda 99001

SELECT 
	 (produto.valor_unitario * pedido.quantidade) - (produto.valor_unitario * pedido.quantidade) * 0.25 AS ValorTotal
FROM
	produto
INNER JOIN
	pedido ON produto.codigo = pedido.cod_prod
WHERE 
	pedido.codigo = '99001'

-- 10) Consultar Código do pedido, nome do cliente e idade atual do cliente

SELECT
	pedido.codigo,
	cliente.nome,
	CONVERT(INTEGER, DATEDIFF(day, cliente.data_nasc, GETDATE()) / 365) AS IdadeAtualCli
FROM
	cliente
INNER JOIN
	pedido ON cliente.codigo = pedido.cod_cli

-- 11) Consultar o nome do fornecedor do produto mais caro

SELECT nome 
FROM fornecedor
WHERE codigo IN (
	SELECT cod_forn, MAX(valor_unitario)
	FROM produto
)

-- 12) Consultar a média dos valores cujos produtos ainda estão em estoque

SELECT AVG(valor_unitario) AS MédiaValores
FROM produto
WHERE qtd_estoque > 0

-- 13) Consultar o nome do cliente, endereço composto por logradouro e número, o valor
-- unitário do produto, o valor total (Quantidade * valor unitario) da compra do cliente
-- de nome Maria Clara

SELECT
	cliente.nome,
	cliente.logradouro + ', ' + CAST(cliente.numero AS VARCHAR) AS EndereçoComposto,
	produto.valor_unitario,
	(produto.valor_unitario * produto.qtd_estoque) AS ValorTotal
FROM
	cliente 
INNER JOIN
	pedido ON cliente.codigo = pedido.cod_cli
INNER JOIN
	produto ON pedido.cod_prod = produto.codigo
WHERE
	cliente.nome LIKE '%Maria Clara%'

-- 14) Considerando que o pedido de Maria Clara foi entregue 15/03/2023, consultar
-- quantos dias houve de atraso. A cláusula do WHERE deve ser o nome da cliente.

SELECT * FROM pedido

SELECT 
	CONVERT(INTEGER, DATEDIFF(DAY, pedido.previsao_ent, '2023-03-15'))
FROM
	cliente
INNER JOIN
	pedido ON cliente.codigo = pedido.cod_cli
WHERE 
	cliente.nome LIKE '%Maria Clara%'

-- 15) Consultar qual a nova data de entrega para o pedido de Alberto% sabendo que se
-- pediu 9 dias a mais. A cláusula do WHERE deve ser o nome do cliente. A data deve ser
-- exibida no formato dd/mm/aaaa.

SELECT
	CONVERT(VARCHAR, DATEADD(DAY, 9, pedido.previsao_ent), 103) AS NovaDataDeEntrega
FROM 
	pedido
INNER JOIN
	cliente ON pedido.cod_cli = cliente.codigo
WHERE
	cliente.nome LIKE 'Alberto%'
