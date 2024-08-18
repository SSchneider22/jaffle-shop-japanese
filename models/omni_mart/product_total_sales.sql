SELECT "prod__order_items"."PRODUCT_ID",
    "prod__order_items"."PRODUCT_NAME",
    "prod__order_items"."PRODUCT_PRICE",
    "prod__order_items"."SUPPLY_COST",
    COALESCE(SUM("prod__orders"."ORDER_TOTAL"), 0) AS "order_total_sum",
    COALESCE(SUM("prod__orders"."TAX_PAID"), 0) AS "tax_paid_sum",
    COALESCE(SUM("prod__orders"."ORDER_TOTAL"), 0) - COALESCE(SUM("prod__orders"."TAX_PAID"), 0) AS "order_total_sum_without_tax_2"
FROM {{ref('orders')}} AS "prod__orders"
    LEFT JOIN {{ref('order_items')}} AS "prod__order_items" ON "prod__orders"."ORDER_ID" = "prod__order_items"."ORDER_ID"
GROUP BY 1, 2, 3, 4
