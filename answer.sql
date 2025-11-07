WITH per_sector AS (
  SELECT
    it.investor_id,
    s.sector_name,
    SUM(it.no_of_shares) AS shares 
  FROM investor_transactions it 
  JOIN sectors s
    ON s.sector_id = it.sector_id
  GROUP BY it.investor_id, s.sector_name
),

totals AS (
  SELECT investor_id, SUM(shares) AS total_shares
  FROM per_sector
  GROUP BY investor_id
)

SELECT
  p.investor_id,
  p.sector_name,
  ROUND(100.0 * p.shares / t.total_shares, 2) AS percentage 
FROM per_sector p
JOIN totals t USING (investor_id)
ORDER BY 
  p.investor_id, 
  percentage DESC,
  p.sector_name;
