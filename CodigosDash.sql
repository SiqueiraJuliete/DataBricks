Queries:

--Total de clientes
SELECT 
  CONCAT(ROUND(COUNT(*)/1000.0, 0), 'k') AS total_clientes
FROM workspace.sales.churn_geo;

--Taxa de Churn:
SELECT 
  ROUND(SUM(Exited) * 1.0 / COUNT(*), 4) AS taxa_churn
FROM workspace.sales.churn_geo;

--Receita perdida:
SELECT 
  SUM(CASE WHEN Exited = 1 THEN EstimatedSalary ELSE 0 END) / 1000 AS valor_perdido_k
FROM workspace.sales.churn_geo;

--Percentual de cLientes Ativos
SELECT 
  ROUND(SUM(IsActiveMember) * 1.0 / COUNT(*), 4) AS pct_clientes_ativos
FROM workspace.sales.churn_geo;

--Taxa de Churn por Faixa Etária
SELECT faixa_idade, churn_pct
FROM (
  SELECT 
    CASE 
      WHEN Age < 30 THEN '<30'
      WHEN Age BETWEEN 30 AND 40 THEN '30-40'
      WHEN Age BETWEEN 41 AND 50 THEN '41-50'
      ELSE '50+'
    END AS faixa_idade,
    CASE 
      WHEN Age < 30 THEN 1
      WHEN Age BETWEEN 30 AND 40 THEN 2
      WHEN Age BETWEEN 41 AND 50 THEN 3
      ELSE 4
    END AS ordem,
    ROUND(SUM(Exited) * 1.0 / COUNT(*), 4) AS churn_pct
  FROM workspace.sales.churn_geo
  GROUP BY 1,2
) t
ORDER BY ordem;

--Distribuição do Salário Estimado
SELECT 
  CASE 
    WHEN Exited = 1 THEN 'Saiu'
    ELSE 'Ficou'
  END AS status_cliente,
  AVG(EstimatedSalary) AS salario_medio
FROM workspace.sales.churn_geo
GROUP BY 1;