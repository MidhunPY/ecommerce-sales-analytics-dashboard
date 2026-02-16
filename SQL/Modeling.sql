alter table olist_customers_dataset add primary key(customer_id);
alter table olist_products_dataset add primary key(product_id);
alter table olist_sellers_dataset add primary key(seller_id);
alter table olist_orders_dataset add primary key(order_id);

ALTER TABLE olist_order_reviews_Copy
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id);   


describe olist_customers_dataset;
describe olist_products_dataset;
describe olist_sellers_dataset;
describe olist_orders_dataset;
describe olist_order_items_dataset;
describe olist_order_payments_dataset;
describe olist_order_reviews_Copy;

alter table olist_customers_dataset modify customer_id varchar(50);
alter table olist_products_dataset modify product_id varchar(50);
alter table olist_sellers_dataset modify seller_id varchar(50);
alter table olist_orders_dataset modify customer_id varchar(50);
alter table olist_order_items_dataset modify order_id varchar(50);
alter table olist_order_items_dataset modify seller_id varchar(50);
alter table olist_order_payments_dataset modify order_id varchar(50);
alter table olist_order_reviews_Copy modify order_id varchar(50);
-- --------------------------------------------------------------------------------------
-- Table Creations

-- olist_customers_dataset

create view customers_data as
SELECT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM olist_customers_dataset;
-- ------------------------------------------------------------
-- olist_products_dataset
CREATE VIEW products_data AS
SELECT
    p.product_id,
    COALESCE(t.product_category_name_english, 'Unknown') AS product_category,
    p.product_name_lenght AS product_name_length,
    p.product_description_lenght AS product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.ï»¿product_category_name;
-- -------------------------------------------------------------------------------
-- olist_sellers_dataset

create view seller_data as
select     
	seller_id,
    seller_city,
    seller_state
FROM olist_sellers_dataset;

-- -------------------------------------------------------------------
-- olist_order_reviews_Copy

create view review_data as
select 
order_id,review_score
from olist_order_reviews_Copy;

-- -----------------------------------------------------------------------
-- olist_order_items_dataset

create view order_items as
select 
order_id,order_item_id,product_id,seller_id,price,freight_value
from olist_order_items_dataset;

-- ------------------------------------------------------------------------
-- olist_order_payments_dataset

create view order_payments as
select
order_id,payment_type,
payment_installments,
payment_value
from olist_order_payments_dataset;

-- ------------------------------------------------------------------
-- olist_orders_dataset
create view orders_data as
SELECT
    order_id,
    customer_id,
    order_status,

    STR_TO_DATE(
        NULLIF(TRIM(order_purchase_timestamp), ''),
        '%d-%m-%Y %H:%i'
    ) AS order_purchase_ts,

    STR_TO_DATE(
        NULLIF(TRIM(order_approved_at), ''),
        '%d-%m-%Y %H:%i'
    ) AS order_approved_ts,

    STR_TO_DATE(
        NULLIF(TRIM(order_delivered_customer_date), ''),
        '%d-%m-%Y %H:%i'
    ) AS delivered_ts,

    STR_TO_DATE(
        NULLIF(TRIM(order_estimated_delivery_date), ''),
        '%d-%m-%Y %H:%i'
    ) AS estimated_delivery_ts

FROM olist_orders_dataset;


SELECT
  order_purchase_ts,
  delivered_ts
FROM orders_data
WHERE order_status = 'delivered'
LIMIT 5;

-- -------------------------------------------------------------------------
CREATE VIEW fact_sales_order AS
SELECT 
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_ts,
    o.delivered_ts,
    o.estimated_delivery_ts,

    c.customer_city,
    c.customer_state,
    c.customer_unique_id,
    r.review_score,

    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,

    s.seller_state,
    p.product_category,

    op.payment_type,
    op.payment_installments,
    op.payment_value

FROM order_items oi  
JOIN orders_data o
    ON o.order_id = oi.order_id
LEFT JOIN customers_data c
    ON o.customer_id = c.customer_id
LEFT JOIN review_data r
    ON r.order_id = o.order_id
LEFT JOIN products_data p
    ON p.product_id = oi.product_id
LEFT JOIN seller_data s
    ON s.seller_id = oi.seller_id
LEFT JOIN order_payments op
    ON o.order_id = op.order_id;


