WITH sku_shrinkage AS (
    SELECT
        sku_id,
        SUM(
            CASE 
                WHEN physical_qty < system_qty
                THEN (system_qty - physical_qty) * unit_cost
                ELSE 0
            END
        ) AS shrinkage_value_usd
    FROM inventory_snapshot
    GROUP BY sku_id
),
ranked_skus AS (
    SELECT
        sku_id,
        shrinkage_value_usd,
        SUM(shrinkage_value_usd) OVER (ORDER BY shrinkage_value_usd DESC) AS cumulative_shrinkage,
        SUM(shrinkage_value_usd) OVER () AS total_shrinkage
    FROM sku_shrinkage
)
SELECT
    sku_id,
    shrinkage_value_usd,
    ROUND((cumulative_shrinkage * 100.0) / total_shrinkage, 2) AS cumulative_shrinkage_pct
FROM ranked_skus
ORDER BY shrinkage_value_usd DESC;
