# 🛒 E-Commerce Data Analysis with Oracle SQL

## 📌 Project Overview

This project is an end-to-end **E-Commerce Data Analysis project built with Oracle SQL**.

The main goal of the project is to analyze an e-commerce business from different perspectives such as:

- 💰 Sales & Revenue
- 👥 Customer Behavior
- 📦 Product Performance
- 🚚 Shipping & Operations
- 📢 Marketing Campaigns
- 🔄 Returns
- 🎧 Customer Support
- ⭐ Reviews & Product Quality
- 🧹 Data Cleaning

Instead of only writing SQL queries, I tried to connect the analysis with **real business problems and possible business decisions**.

---

# 🎯 Project Goal

The main question behind this project is:

> **"What can an e-commerce company learn from its data, and how can SQL analysis help the business make better decisions?"**

The project uses Oracle SQL to transform raw e-commerce data into useful business insights.

The analysis contains **49 business questions** covering sales, customers, products, marketing, operations, returns, support and quality.

---

# 🛠️ Tools & Technologies

- 🗄️ Oracle Database 21c
- 💻 Oracle SQL Developer
- 🔎 SQL
- 📊 Aggregations
- 🔗 JOINs
- 🧮 Subqueries & CTEs
- 🪟 Window Functions
- 📅 Date Functions
- 🧹 Data Cleaning
- 📈 Business Analysis

---

# 🗂️ Database Structure

The database contains **14 related tables**.

| Table | Description |
|---|---|
| `categories` | Product categories and departments |
| `suppliers` | Supplier information |
| `products` | Product details, prices, stock and ratings |
| `customers` | Customer information |
| `addresses` | Customer addresses |
| `orders` | Customer orders |
| `order_items` | Products included in each order |
| `payments` | Payment information |
| `shipments` | Shipping and delivery information |
| `reviews` | Customer reviews |
| `returns` | Returned orders and refund information |
| `discounts` | Product discount information |
| `marketing_campaigns` | Marketing campaign information |
| `support_tickets` | Customer support requests |

---

# 🔗 Table Relationships

The database is designed around the main e-commerce process:

**Customer → Order → Order Items → Product**

This is the most important relationship in the database.

```text
categories ───────< products >─────── suppliers
                       |
                       |
                       v
customers ───────< orders ───────< order_items
    |                 |
    |                 |
    |                 ├──────< payments
    |                 |
    |                 └──────< shipments
    |
    ├────────< addresses
    |
    ├────────< reviews
    |
    ├────────< returns
    |
    └────────< support_tickets

products ───────< discounts

marketing_campaigns
        |
        └── target_segment
             ↓
       customers.customer_segment
```

## 🔍 How the relationships work

### 👥 Customers → Orders

One customer can make many orders.

```text
customers.customer_id
        ↓
orders.customer_id
```

This relationship allows us to analyze:

- Customer spending
- Number of orders
- Repeat purchases
- Customer segments
- Customer lifetime behavior

---

### 🛍️ Orders → Order Items

One order can contain multiple products.

```text
orders.order_id
        ↓
order_items.order_id
```

`order_items` is the bridge between **orders and products**.

For example:

```text
Order #1001
   ├── Product A × 2
   ├── Product B × 1
   └── Product C × 3
```

---

### 📦 Products → Order Items

One product can appear in many different orders.

```text
products.product_id
        ↓
order_items.product_id
```

This allows us to calculate:

- Units sold
- Product revenue
- Product popularity
- Product performance

---

### 🏷️ Categories → Products

Each product belongs to a category.

```text
categories.category_id
        ↓
products.category_id
```

This allows category-level analysis such as:

- Category revenue
- Category sales
- Category performance
- Category return analysis

---

### 🏭 Suppliers → Products

Each product is associated with a supplier.

```text
suppliers.supplier_id
        ↓
products.supplier_id
```

This helps analyze:

- Supplier performance
- Supplier ratings
- Product margins
- Supplier contribution to sales

---

### 💳 Orders → Payments

An order can have payment information.

```text
orders.order_id
        ↓
payments.order_id
```

This allows analysis of:

- Payment methods
- Payment revenue
- Payment status
- Payment behavior

---

### 🚚 Orders → Shipments

Orders can be connected to shipment records.

```text
orders.order_id
        ↓
shipments.order_id
```

This relationship is useful for:

- Delivery time
- Shipping methods
- Delayed shipments
- Shipment status

---

### ⭐ Customers / Orders → Reviews

Reviews are connected to both the customer and order.

```text
customers.customer_id
        ↓
reviews.customer_id

orders.order_id
        ↓
reviews.order_id
```

This allows us to analyze customer feedback and ratings.

---

### 🔄 Customers / Orders → Returns

Returns are connected to both customers and orders.

```text
customers.customer_id
        ↓
returns.customer_id

orders.order_id
        ↓
returns.order_id
```

This allows us to analyze:

- Return rate
- Return reasons
- Refund amounts
- Customer return behavior

---

### 🎧 Customers → Support Tickets

A customer can create multiple support tickets.

```text
customers.customer_id
        ↓
support_tickets.customer_id
```

This helps analyze:

- Support volume
- Ticket categories
- Priority
- Resolution time
- Customers with repeated issues

---

### 🏷️ Products → Discounts

Discounts are connected to products.

```text
products.product_id
        ↓
discounts.product_id
```

This allows analysis of:

- Discount levels
- Product promotions
- Discount periods

---

### 📢 Marketing Campaigns

Marketing campaigns currently use:

```text
marketing_campaigns.target_segment
        ↓
customers.customer_segment
```

This is a **logical business relationship**, rather than a direct foreign-key relationship.

The current database does not contain a customer-campaign attribution table.

---

# 🧹 Data Cleaning

Before performing business analysis, several data-quality checks were performed.

### C1 — Customer City Standardization

Customer city names may have inconsistent capitalization or spaces.

Example:

```text
baku
BAKU
Baku
```

These values can be standardized using:

```sql
INITCAP(TRIM(city))
```

---

### C2 — Missing Product Ratings

Missing product ratings are handled using the **average rating of the product's category**.

This avoids simply replacing every missing rating with a global average.

---

### C3 — Missing Payment Methods

Missing payment methods are replaced with:

```text
UNKNOWN
```

This keeps the records available for analysis while clearly identifying missing information.

---

### C4 — Payment / Priority Formatting

Text values such as support ticket priorities are standardized using:

```sql
UPPER(TRIM(priority))
```

---

### C5 — Data Quality Checks

The project also checks for:

- Duplicate customer emails
- Non-positive product prices
- Products where cost price is higher than unit price
- Invalid delivery dates
- Missing or inconsistent values

---

# 💰 Sales & Revenue Analysis

The project answers questions such as:

1. What is the yearly revenue?
2. How does revenue change month by month?
3. Which categories generate the most revenue?
4. What are the top 10 products by revenue?
5. What is the Average Order Value (AOV)?
6. Which countries generate the most revenue?
7. Which payment methods generate the most revenue?
8. What is the distribution of order statuses?
9. How does discounting affect revenue?
10. Is there a seasonal pattern in sales?

### 📊 Business Problems

Possible problems identified through this analysis include:

- Revenue may be concentrated in a small number of products.
- Some categories may generate very little revenue.
- Sales may depend heavily on specific seasons.
- Excessive discounts may reduce profitability.
- Some countries may contribute very little revenue.

### 💡 Recommendations

If revenue is highly concentrated:

- Introduce more products in underperforming categories.
- Create bundles and cross-selling opportunities.
- Reduce dependency on a small number of products.

If strong seasonality exists:

- Increase inventory before peak periods.
- Launch marketing campaigns before demand increases.
- Prepare logistics capacity in advance.

If discounts significantly increase sales but reduce margins:

- Avoid unnecessary blanket discounts.
- Use targeted discounts for specific customer segments.
- Promote high-margin products instead.

---

# 👥 Customer Analysis

The project analyzes:

11. Monthly new customer growth  
12. Customer segment performance  
13. Top customers by spending  
14. Repeat purchase rate  
15. Average orders per customer  
16. RFM-style customer segmentation  
17. Churn candidates  
18. Gender-based customer analysis  
19. Age groups  
20. Average customer lifetime value by country  

### 🔍 Business Problems

Potential problems include:

- Low repeat purchase rate
- Customers becoming inactive
- High-value customers not receiving special treatment
- Some customer segments generating very little revenue
- Weak customer retention

### 💡 Recommendations

### 🔄 Improve Customer Retention

For customers who have not purchased for a long time:

- Create win-back campaigns.
- Send personalized offers.
- Recommend products based on previous purchases.
- Offer limited-time incentives.

### ⭐ VIP Customer Strategy

For high-value customers:

- Create VIP customer tiers.
- Provide free shipping.
- Give early access to new products.
- Provide personalized offers.

### 🎯 Customer Segmentation

Different customers should receive different marketing strategies.

For example:

```text
High Value Customer
        ↓
VIP / Loyalty Program

Regular Customer
        ↓
Cross-selling / Product Recommendations

Inactive Customer
        ↓
Win-back Campaign
```

---

# 📦 Product Analysis

The project analyzes:

21. Top products by units sold  
22. Least-sold active products  
23. Category performance  
24. High-rated but low-selling products  
25. Low-rated products  
26. Low-stock products with high sales  
27. Product unit gross margin  
28. Supplier performance  
29. Products that have never been ordered  
30. Average rating by price band  

### 🔍 Business Problems

Possible problems include:

- Products with high demand but low inventory
- Products with poor ratings
- Products with good ratings but low sales
- Products with low margins
- Products that never receive orders

### 💡 Recommendations

### 📈 High-Rated but Low-Selling Products

A high rating combined with low sales may indicate a **visibility problem**, not necessarily a product-quality problem.

Possible actions:

- Improve product placement.
- Add the product to recommendations.
- Create bundles.
- Improve product-page content.
- Include the product in targeted campaigns.

---

### 📦 Low Stock + High Sales

These products should receive higher inventory priority.

Possible actions:

- Increase reorder frequency.
- Set minimum stock levels.
- Maintain safety stock.
- Monitor demand trends.

---

### ⭐ Low-Rated Products

Low-rated products should be investigated together with:

- Return reasons
- Customer reviews
- Support tickets
- Supplier performance

Possible actions:

- Investigate product quality.
- Improve product descriptions.
- Review supplier quality.
- Replace problematic products if necessary.

---

### 💰 Low-Margin Products

For products with low unit gross margin:

- Negotiate supplier costs.
- Review pricing.
- Reduce excessive discounts.
- Consider bundling with higher-margin products.

---

# 🏭 Supplier Analysis

Supplier performance is analyzed using product-level information.

A business should not evaluate suppliers only by revenue.

Other factors should also be considered:

- Supplier rating
- Product margin
- Product demand
- Product quality
- Return behavior

A supplier generating high sales but poor product quality could create long-term costs through returns and customer complaints.

---

# 📢 Marketing Analysis

The project analyzes:

31. Marketing budget by channel  
32. Campaign count and budget by target segment  
33. Revenue by customer segment  
34. Orders and revenue around campaign periods  
35. Monthly marketing budget by channel  

### 🔍 Business Problems

Possible problems include:

- Marketing budget concentrated in weak channels.
- Some campaigns targeting low-value segments.
- Difficulty measuring campaign effectiveness.
- Lack of direct customer-level attribution.

### 💡 Recommendations

Marketing performance should be compared using:

```text
Marketing Cost
       ↓
Orders
       ↓
Revenue
       ↓
Profit
```

The company should invest more in channels that generate strong business results.

For better analysis, the database could be improved by adding a table such as:

```text
campaign_customer
-----------------
campaign_id
customer_id
exposure_date
```

This would make customer-level campaign attribution possible.

---

# 🚚 Shipping & Operations Analysis

The project analyzes:

36. Average delivery time  
37. Shipping method performance  
38. Delayed shipments  
39. Orders without shipment records  
40. Shipment status distribution  

### 🔍 Business Problems

Possible problems include:

- Long delivery times
- Delayed shipments
- Poor-performing shipping methods
- Orders without shipment information

### 💡 Recommendations

If a shipping method consistently performs poorly:

- Review the logistics provider.
- Compare alternative shipping methods.
- Investigate delays by country or region.
- Improve delivery-time estimates.

For repeated delays:

```text
Delayed Shipment
       ↓
Find Cause
       ↓
Carrier / Route / Warehouse / Product
       ↓
Corrective Action
```

---

# 🔄 Returns Analysis

The project analyzes:

41. Overall return rate  
42. Most common return reasons  
43. Category return rate  
44. Monthly refund amounts  

### 🔍 Business Problems

High returns can increase:

- Refund costs
- Logistics costs
- Customer support workload
- Inventory complexity

### 💡 Recommendations

The company should not only ask:

> "How many products are being returned?"

It should also ask:

> "Why are customers returning them?"

For example:

```text
High Returns
     ↓
Return Reason
     ↓
Product Quality?
Wrong Description?
Damaged Delivery?
Wrong Size?
     ↓
Root Cause Analysis
     ↓
Business Action
```

Possible actions:

- Improve product descriptions.
- Improve quality control.
- Improve packaging.
- Investigate suppliers.
- Improve sizing information.

---

# 🎧 Customer Support Analysis

The project analyzes:

45. Support ticket volume by category  
46. Priority distribution and resolution time  
47. Customers with multiple support tickets  
48. Relationship between returns and support tickets  

### 🔍 Business Problems

A high number of support tickets may indicate an underlying business problem.

For example:

```text
Many Support Tickets
        ↓
Find Category
        ↓
Find Root Cause
        ↓
Fix Business Process
```

Instead of only hiring more support agents, the company should try to reduce the reason behind repeated tickets.

### 💡 Recommendations

- Create FAQ/self-service resources.
- Automate common questions.
- Improve product information.
- Improve return instructions.
- Increase support capacity during peak periods.
- Investigate customers with repeated complaints.

---

# ⭐ Review & Quality Analysis

Customer ratings can be used together with sales and return information.

For example:

```text
High Sales + High Rating
        ↓
Strong Product
        ↓
Protect Inventory & Promote

High Sales + Low Rating
        ↓
Potential Quality Problem
        ↓
Investigate

Low Sales + High Rating
        ↓
Potential Visibility Problem
        ↓
Promote / Bundle

Low Sales + Low Rating
        ↓
Weak Product
        ↓
Review / Replace / Remove
```

This provides a more useful view than looking at ratings alone.

---

# 📊 Main Business KPIs

The most important KPIs from this project are:

| KPI | Business Purpose |
|---|---|
| 💰 Revenue | Measure total sales performance |
| 🛒 Orders | Measure transaction volume |
| 💵 Average Order Value | Measure average order size |
| 👥 Repeat Purchase Rate | Measure customer retention |
| ⭐ Customer Rating | Measure customer satisfaction |
| 🔄 Return Rate | Measure product/order issues |
| 💸 Refund Amount | Measure return-related costs |
| 🚚 Average Delivery Days | Measure logistics performance |
| 📦 Units Sold | Measure product demand |
| 💰 Unit Gross Margin | Measure product profitability |
| 🎧 Support Tickets | Measure customer service workload |

---

# 🧠 SQL Techniques Used

This project uses different SQL concepts to solve business questions.

### Basic SQL

- `SELECT`
- `WHERE`
- `ORDER BY`
- `GROUP BY`
- `HAVING`

### Joins

- `INNER JOIN`
- `LEFT JOIN`
- Multiple-table joins

### Aggregations

- `COUNT`
- `SUM`
- `AVG`
- `MIN`
- `MAX`

### Advanced SQL

- `CTE`
- Subqueries
- `CASE`
- `NULLIF`
- `ROUND`
- `TRUNC`
- Date functions
- Conditional aggregation

### Window Functions

- `ROW_NUMBER()`
- `RANK()`
- `NTILE()`
- `SUM() OVER()`
- `AVG() OVER()`

These techniques were used to move from simple queries to more realistic business analysis.

---

# 📁 Project Structure

```text
Ecommerce_oracle_project/
│
├── Business_questions/
│   └── Business Questions.docx
│
├── Queries/
│   ├── Customer_analysis.sql
│   ├── Data_cleaning.sql
│   ├── Marketing_Shipments_analysis.sql
│   ├── Product_analysis.sql
│   ├── Returns_support_quality_analysis.sql
│   ├── Sales_Revenue.sql
│   └── Tables_ecommerce.sql
│
├── Sources/
│   ├── addresses.csv
│   ├── categories.csv
│   ├── customers.csv
│   ├── discounts.csv
│   ├── marketing_campaigns.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── payments.csv
│   ├── products.csv
│   ├── returns.csv
│   ├── reviews.csv
│   ├── shipments.csv
│   ├── suppliers.csv
│   └── support_tickets.csv
│
└── README.md
```


# 👨‍💻 About

This project was created as a portfolio project to practice **Oracle SQL, relational database design, data cleaning and business-oriented data analysis**.

The project focuses on solving realistic e-commerce business questions using SQL and turning database information into actionable recommendations.
