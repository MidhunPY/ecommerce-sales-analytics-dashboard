# 🛒 E-Commerce Sales Analytics Dashboard


## 📌 Project Overview
This project analyzes an e-commerce dataset using **SQL for data modeling & analysis** and **Power BI for visualization & business insights**.

The objective was to transform raw transactional data into a structured data model, perform advanced SQL analysis, and build an interactive executive-level dashboard to drive business decisions.

---
## 📊 Dataset

The dataset used in this project is the **Olist E-Commerce Dataset**.

Source:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

---

## 🏗️ Tech Stack

- **MySQL** – Data cleaning, transformation & analytical queries  
- **SQL** – Fact & Dimension modeling, KPIs, Business logic  
- **Power BI** – Data visualization & dashboard design  
- **DAX** – Advanced KPI calculations (Repeat Rate, Late Delivery %, AOV)  

---

## 📊 Dashboard Pages

### 1️⃣ Executive Overview
- Total Orders
- Total Revenue
- Average Order Value
- Late Delivery %
- Monthly Revenue Trend
- Top 10 Product Categories
- Revenue by State

---

### 2️⃣ Customer Loyalty & Behavioral Insights
- Repeat Customer %
- Repeat vs One-Time Revenue
- Revenue Contribution Analysis
- Average Review Score
- Average Delivery Days
- Top Categories by Rating
- Payment Method Distribution

---

### 3️⃣ Operations & Delivery Performance
- Delivered Orders
- Late Delivery %
- Avg Delivery Days
- Avg Shipping Days
- Late Delivery Rate by State
- Monthly Delivery Trend
- Top 10 Sellers by Late Delivery %

---

## 📐 Data Modeling Approach

A **star schema** was implemented:

- **Fact Table:** `fact_sales_order`
- **Dimension Tables:**
  - customers
  - products
  - sellers
  - payments
  - reviews

Key business logic implemented:
- Repeat customer identification using `customer_unique_id`
- Late delivery calculation using `delivered_ts > estimated_delivery_ts`
- AOV using `SUM(price + freight_value) / DISTINCTCOUNT(order_id)`

---

## 📈 Key Business Insights

- Revenue is primarily driven by one-time customers.
- Late delivery rate is ~8%.
- Certain states contribute significantly higher revenue.
- Credit card is the dominant payment method.
- A small percentage of customers generate repeat revenue.

---


