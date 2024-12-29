with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

lifetime as(
    select
        customer_id
        , SUM(SAFE_DIVIDE(amount,100)) amount
    from {{ ref('fct_orders') }}
    GROUP BY ALL
),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        lifetime.amount as lifetime_value

    from customers

    left join customer_orders using (customer_id)
    left join lifetime
        ON lifetime.customer_id=customers.customer_id

)

select * from final
