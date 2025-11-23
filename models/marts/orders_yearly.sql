with source_data as (

    -- 元のモデルを参照
    select * from {{ ref('orders') }}

),

yearly_summary as (

    select
        -- 年単位に切り捨て
        date_trunc('year', purchased_at) as order_year,

        -- 金額の集計
        sum(order_total) as total_revenue,
        sum(order_cost) as total_cost,
        sum(order_items_subtotal) as total_subtotal,
        sum(tax_paid) as total_tax,
        
        -- 利益
        sum(order_total) - sum(order_cost) as total_profit,

        -- 数量の集計
        count(*) as total_orders,
        sum(count_order_items) as total_items_sold,
        sum(count_food_items) as total_food_items,
        sum(count_drink_items) as total_drink_items,

        -- フラグの集計
        sum(case when is_food_order then 1 else 0 end) as count_orders_with_food,
        sum(case when is_drink_order then 1 else 0 end) as count_orders_with_drink

    from source_data
    
    group by 1

)

select * from yearly_summary
order by order_year desc