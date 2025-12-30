SELECT
    store_id,
    COUNT(DISTINCT sku_id) AS total_skus,
    SUM(ABS(physical_qty - system_qty)) AS total_unit_variance,
    ROUND(
        1 - (
            SUM(ABS(physical_qty - system_qty)) * 1.0
            / NULLIF(SUM(system_qty), 0)
        ),
        3
    ) AS inventory_accuracy_pct
FROM inventory_snapshot
GROUP BY store_id
ORDER BY inventory_accuracy_pct ASC;
