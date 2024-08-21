SELECT "prod__order_items.is_drink_item",
    "prod__orders.order_id",
    "prod__orders.location_id",
    "prod__orders.order_total_without_tax"
FROM (SELECT "prod__order_items"."IS_DRINK_ITEM" AS "prod__order_items.is_drink_item",
            "prod__orders"."LOCATION_ID" AS "prod__orders.location_id",
            "prod__orders"."ORDER_ID" AS "prod__orders.order_id",
            COALESCE(SUM("prod__orders"."ORDER_TOTAL"), 0) - COALESCE(SUM("prod__orders"."TAX_PAID"), 0) AS "prod__orders.order_total_without_tax"
        FROM {{ref('orders')}} AS "prod__orders"
            LEFT JOIN {{ref('order_items')}} AS "prod__order_items" ON "prod__orders"."ORDER_ID" = "prod__order_items"."ORDER_ID"
        GROUP BY 1, 2, 3) AS "t2"
