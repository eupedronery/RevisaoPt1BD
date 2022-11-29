CREATE DATABASE Exercicio5
GO

USE Exercicio5
GO

CREATE TABLE Fornecedor (
Codigo                 INT            NOT NULL,
Nome                   VARCHAR(30)    NOT NULL,
Atividade              VARCHAR(30)    NOT NULL,
Telefone               VARCHAR(8)     NOT NULL
PRIMARY KEY(Codigo)
)
GO

CREATE TABLE Produto (
Codigo            INT            NOT NULL,
Nome               VARCHAR(30)    NOT NULL,
valor_unitario         DECIMAL(7,2)   NOT NULL,
Quantidade_Estoque     INT            NOT NULL,
Descricao              VARCHAR(40)    NOT NULL,
Codigo_Fornecedor      INT            NOT NULL
PRIMARY KEY(Codigo)
FOREIGN KEY(Codigo_Fornecedor)  REFERENCES Fornecedor(Codigo)
)

GO

CREATE TABLE Cliente (
Codigo                 INT            NOT NULL,
Nome                   VARCHAR(30)    NOT NULL,
Logradouro             VARCHAR(50)    NOT NULL,
Numero                 INT            NOT NULL,
Telefone               VARCHAR(8)     NOT NULL,
Data_Nasc              DATE           NOT NULL
PRIMARY KEY(Codigo)
)
GO

CREATE TABLE Pedido (
Codigo                 INT            NOT NULL,
Codigo_Cliente         INT            NOT NULL,
Codigo_Produto         INT            NOT NULL,
Quantidade             INT            NOT NULL,
Valor_Total            DECIMAL(7, 2)  NOT NULL,
Previsao_Entrega       DATE           NOT NULL
PRIMARY KEY(Codigo, Codigo_Cliente, Codigo_Produto)
FOREIGN KEY(Codigo_Cliente)  REFERENCES  Cliente(Codigo),
FOREIGN KEY(Codigo_Produto)  REFERENCES  produto(Codigo)
)

GO
INSERT INTO Fornecedor VALUES
            (1001, 'Estrela', 'Brinquedo', '41525898' ),
			(1002, 'Lacta', 'Chocolate', '42698596'),
			(1003, 'Asus', 'Informática', '52014596'),
			(1004, 'Tramontina', 'Utensílios Domésticos', '50563985'),
			(1005, 'Grow', 'Brinquedos', '47896325'),
			(1006, 'Mattel', 'Bonecos', '59865898')
GO

INSERT INTO Produto VALUES
            (1, 'Banco Imobiliário', 65.00, 15, 'Versão Super Luxo', 1001 ),
			(2, 'Puzzle 5000 peças', 50.00, 5, 'Mapas Mundo', 1005),
			(3, 'Faqueiro', 350.00, 0, '120 peças', 1004),
			(4, 'Jogo para churrasco', 75.00, 3, '7 peças', 1004),
			(5, 'Tablet', 750.00, 29, 'Tablet', 1003),
			(6, 'Detetive', 49.00, 0, 'Nova Versão do Jogo', 1001),
			(7, 'Chocolate com Paçoquinha', 6.00, 0, 'Barra', 1002),
			(8, 'Galak', 5.00, 65, 'Barra', 1002)
GO


INSERT INTO Cliente VALUES 
            (33601, 'Maria Clara', 'R. 1° de Abril', 870, '96325874', '2000-08-15'),
			(33602, 'Alberto Souza', 'R. XV de Novembro', 987, '95873625', '1985-02-02'),
			(33603, 'Sonia Silva', 'R. Voluntários da Pátria', 1151, '75418596', '1957-08-23'),
			(33604, 'José Sobrinho', 'Av. Paulista', 250, '85236547', '1986-12-09'),
			(33605, 'Carlos Camargo', 'Av. Tiquatira', 9652, '75896325', '1971-03-25')
GO


INSERT INTO Pedido VALUES 
            (99001, 33601, 1, 1, 65.00, '07/06/2012'),
			(99001, 33601, 2, 1, 50.00, '07/06/2012'),
			(99001, 33601, 8, 3, 15.00, '07/06/2012'),
			(99002, 33602, 2, 1, 50.00, '09/06/2012'),
			(99002, 33602, 4, 3, 225.00, '09/06/2012'),
			(99003, 33605, 5, 1, 750.00, '15/06/2012')
GO


--Consultar a quantidade, valor total e valor total com desconto (25%) 
--dos itens comprados par Maria Clara. 

SELECT quantidade,
       valor_total,
	   CAST(valor_total - (valor_total * 0.25) AS DECIMAL(7, 2)) AS valor_total_desconto
FROM pedido
WHERE codigo_cliente IN (
                     SELECT codigo
					 FROM cliente
					 WHERE nome = 'Maria Clara'
                        )
GO


--Verificar quais brinquedos não tem itens em estoque.
SELECT *
FROM produto
WHERE quantidade_estoque = 0
		AND codigo_fornecedor IN (
		SELECT codigo
		FROM fornecedor
		WHERE atividade LIKE 'Brinqued%')



--Alterar para reduzir em 10% o valor das barras de chocolate.
UPDATE produto
SET valor_unitario = valor_unitario - (valor_unitario * 0.10)
WHERE Nome LIKE '%hocola%'

GO


--Alterar a quantidade em estoque do faqueiro para 10 peças.
UPDATE Produto
SET Quantidade_Estoque = Quantidade_Estoque + 10
WHERE Nome LIKE '%aqueiro'

GO


--Consultar quantos clientes tem mais de 40 anos.
SELECT COUNT(Codigo) AS Quantidade
FROM Cliente
WHERE DATEDIFF(YEAR, Data_Nasc, GETDATE()) > 40

GO


--Consultar Nome e telefone dos fornecedores de Brinquedos e Chocolate.
SELECT nome,
       telefone
FROM fornecedor
WHERE atividade LIKE '%rinquedo%' 
      OR atividade LIKE '%hocolate'

GO


--Consultar nome e desconto de 25% no preço dos produtos que custam menos de R$50,00
SELECT nome,
       CAST(valor_unitario - (valor_unitario * 0.25) AS DECIMAL(7, 2)) AS preço_com_desconto
FROM produto
WHERE valor_unitario < 50.00

GO


--Consultar nome e aumento de 10% no preço dos produtos que custam mais de R$100,00
SELECT nome,
       CAST(valor_unitario + (valor_unitario * 0.10) AS DECIMAL(7, 2)) AS preço_aumentado
FROM produto 
WHERE valor_unitario > 100.00
GO


--Consultar desconto de 15% no valor total de cada produto da venda 99001.
SELECT CAST(valor_total - (valor_total * 0.15) AS DECIMAL(7, 2)) AS valor_total_desconto
FROM pedido
WHERE codigo = 99001

GO


--Consultar Código do pedido, nome do cliente e idade atual do cliente
SELECT DISTINCT pd.codigo AS codigo_pedido, 
       c.nome,
		DATEDIFF(YEAR, c.data_nasc, GETDATE()) AS idade_atual  
FROM cliente c, pedido pd
WHERE c.codigo = pd.codigo_cliente 