with source_data as (

    -- 元のモデルを参照します。
    -- まだモデル化していない場合は、ここに元のクエリ全体を記述してください。
    select * from {{ ref('orders') }}

),

monthly_summary as (

    select
        -- 月単位に切り捨て (Snowflake/BigQuery/Postgres等で一般的)
        date_trunc('month', purchased_at) as order_month,

        -- 金額の集計
        sum(order_total) as total_revenue,
        sum(order_cost) as total_cost,
        sum(order_items_subtotal) as total_subtotal,
        sum(tax_paid) as total_tax,
        
        -- 利益（売上 - コスト）の計算
        sum(order_total) - sum(order_cost) as total_profit,

        -- 数量の集計
        count(*) as total_orders, -- 注文回数
        sum(count_order_items) as total_items_sold, -- 商品点数合計
        sum(count_food_items) as total_food_items,
        sum(count_drink_items) as total_drink_items,

        -- フラグの集計（Trueのものをカウント）
        sum(case when is_food_order then 1 else 0 end) as count_orders_with_food,
        sum(case when is_drink_order then 1 else 0 end) as count_orders_with_drink

    from source_data
    
    group by 1

)

select * from monthly_summary
order by order_month desc