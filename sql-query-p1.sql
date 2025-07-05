-- SQL Retail Sales Analysis

-- Criação da Tabela

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transactions_id INT PRIMARY KEY,
                sale_date DATE,
                sale_time TIME,
                customer_id INT,
                gender VARCHAR(15),
                age INT,
                category VARCHAR(15),
                quantiy INT,
                price_per_unit FLOAT,
                cogs FLOAT,
                total_sale FLOAT
            );


SELECT * FROM retail_sales;
SELECT  
COUNT(*) 
FROM retail_sales


-- Limpeza de Dados
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Exploração de Dados

-- Quantas vendas nós temos?
SELECT COUNT(*) as total_sale FROM retail_sales

-- Quantos clientes únicos nós temos?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

-- Análise de Dados & Principais Problemas de Negócios & Perguntas













--Q.1 Escreva uma consulta SQL para recuperar todas as colunas de vendas feitas em '2022-11-05'.
 
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';



--Q.2 Escreva uma consulta SQL para recuperar todas as transações onde a categoria é 'Clothing' (Roupas) e a quantidade vendida é maior que 4 no mês de novembro de 2022.

SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4



--Q.3 Escreva uma consulta SQL para calcular as vendas totais (total_sale) para cada categoria.

SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1



--Q.4 Escreva uma consulta SQL para encontrar a idade média dos clientes que compraram itens da categoria 'Beauty' (Beleza).

SELECT
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'



--Q.5 Escreva uma consulta SQL para encontrar todas as transações onde total_sale é maior que 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000



--Q.6 Escreva uma consulta SQL para encontrar o número total de transações (transaction_id) feitas por cada gênero em cada categoria.

SELECT
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP 
	BY
	category,
	gender
ORDER BY 1



--Q.7 Escreva uma consulta SQL para calcular a venda média de cada mês. Descubra o mês com maior venda em cada ano.

SELECT
	year,
	month
	avg_sale
FROM
(
SELECT
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 3 DESC
) as t1
WHERE rank = 1


--Q.8 Escreva uma consulta SQL para encontrar os 5 principais clientes com base nas maiores vendas totais.

SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5



--Q.9 Escreva uma consulta SQL para encontrar o número de clientes únicos que compraram itens de cada categoria.

SELECT
	category,
	COUNT(DISTINCT customer_id) AS cunt_unique_cs
FROM retail_sales
GROUP BY category



--Q.10 Escreva uma consulta SQL para criar cada turno e o número de pedidos (Exemplo: Manhã <12, Tarde entre 12 e 17, Noite >17).

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift


-- Fim do Projeto