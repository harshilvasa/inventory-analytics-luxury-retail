SELECT
    rfid_enabled,
    COUNT(DISTINCT sku_id) AS total_skus,
    SUM(system_qty) AS total_system_qty,
    SUM(ABS(physical_qty - system_qty)) AS total_unit_variance,
    ROUND(
        1 - (
            SUM(ABS(physical_qty - system_qty)) * 1.0
            / NULLIF(SUM(system_qty), 0)
        ),
        3
    ) AS inventory_accuracy_pct
FROM inventory_snapshot
GROUP BY rfid_enabled;


SELECT
    rfid_enabled,
    SUM(
        CASE
            WHEN physical_qty < system_qty
            THEN (system_qty - physical_qty) * unit_cost
            ELSE 0
        END
    ) AS shrinkage_value_usd
FROM inventory_snapshot
GROUP BY rfid_enabled;
