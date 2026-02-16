-- TOTAL REVENUE

select round(SUM(price+freight_value),2) as Total_Revenue
from fact_sales_order where order_status = 'delivered';

-- -----------------------------------------------------------------
-- TOTAL PRODUCTS_CATEGORY

select count(distinct product_category) as Total_Product_Category 
from fact_sales_order;

-- --------------------------------------------------------------------
-- Revenue by status

select order_status as Order_Status,
count(distinct order_id) as Total_Orders,
round(sum(price+freight_value)) as Revenue
from fact_sales_order
group by order_status order by Revenue desc;

-- -----------------------------------------------------------------
-- REVENUE TREND MONTH

SELECT
  DATE_FORMAT(order_purchase_ts, '%Y-%m') AS month,
  round(SUM(price + freight_value),2) AS total_revenue
FROM fact_sales_order
WHERE order_status = 'delivered'
GROUP BY month
ORDER BY month;
-- -----------------------------------------------------------------
-- TOP 10 PRODUCTS CATEGORY

select product_category, round(sum(price),2)as revenue
from fact_sales_order
group by product_category order by revenue desc limit 10;

-- ----------------------------------------------------------------
-- Payment Method Distribution

select payment_type,count(distinct order_id) as orders 
from fact_sales_order
WHERE order_status="delivered" and payment_type is not null
group by payment_type order by orders desc;


-- -------------------------------------------------------------------
-- LEAST 20 PRODUCTS CATEGORY

select product_category, round(sum(price),2)as revenue
from fact_sales_order
group by product_category order by revenue asc limit 20;

-- --------------------------------------------------------------------
-- REVENUE BY CUSTOMER STATES

select customer_state ,
round(sum(price+freight_value),2) as Revenue
from fact_sales_order
where order_status = 'delivered'
group by customer_state
order by Revenue desc;

-- ------------------------------------------------------------------------
-- AVERAGE ORDER VALUE

select 
round(sum(price+freight_value)/count(distinct order_id),2) as Average_Order_Value
from fact_sales_order
where order_status = 'delivered';

-- -------------------------------------------------------------------------------
-- REPEATED CUSTOMER RATE

select 
round(
100*count(*)/(select count(distinct customer_unique_id)
from fact_sales_order where order_status="delivered"),2) as repeat_customer_percentage
from(
select customer_unique_id
from fact_sales_order 
where order_status="delivered"
group by customer_unique_id
having count(distinct order_id)>1) as t;


-- -------------------------------------------------------
-- Average_Delivered_Order

select round(avg(Delivered_Order),2) as Average_Delivered_Orders
from(
select datediff(delivered_ts,order_purchase_ts) as Delivered_Order
from fact_sales_order where order_status="delivered" GROUP BY order_id) as t;

-- ----------------------------------------------------------------------------
-- Top 10 Product Categories by Average Customer Rating

select 
product_category as Product_Category,
round(avg(review_score),2) as Average_Review_Score,
count(distinct order_id) as Total_Orders
from fact_sales_order
where order_status="delivered" and review_score is not null
group by product_category
order by Average_Review_Score desc limit 10;

-- -------------------------------------------------------------
-- Late_Delivery_Rate

select 
round(
100 * sum(case when delivered_ts > estimated_delivery_ts then 1 else 0 end)
/count(distinct order_id),2) as Late_Delivery_Rate
from fact_sales_order
where order_status="delivered";

-- --------------------------------------------------------------------------------
-- Repeat vs One-Time Revenue

with customer_summary as (
    select 
        customer_unique_id,
        count(distinct order_id) as total_orders,
        sum(price + freight_value) as revenue
    from fact_sales_order 
    where order_status = 'delivered'
    group by customer_unique_id
)

select 
    case when total_orders > 1 then 'Repeat' else 'One-Time' end as customer_type,
    round(sum(revenue),2) as total_revenue
from customer_summary
group by customer_type;


