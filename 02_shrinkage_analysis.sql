SELECT
    store_id,
    category,
    SUM(ABS(physical_qty - system_qty) * unit_cost) AS shrinkage_value_usd
FROM inventory_snapshot
GROUP BY store_id, category
ORDER BY shrinkage_value_usd DESC;
