SELECT
    order_id
    , customer_id
    , amount
FROM {{ ref('stg_stripe_payment') }}