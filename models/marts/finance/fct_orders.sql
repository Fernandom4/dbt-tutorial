SELECT
    orderid
    , id as customer_id
    , amount
FROM {{ ref('stg_stripe_payment') }}