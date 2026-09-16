# Product Management Database System (MySQL)

A relational database project for organizing products, categories, suppliers, customers, inventory and sales orders. The design separates each business area into a dedicated table and connects related records using primary and foreign keys.

It can be used to maintain product information, monitor stock levels, record customer orders, analyze product and supplier performance, and generate business reports. The project demonstrates SQL skills from basic `SELECT` statements through joins, grouping, subqueries, window functions, CTEs and conditional reporting.

## Requirements

- Create and manage product categories
- Store supplier and contact information
- Store customer registration and contact details
- Maintain product price, unit, category and supplier
- Track stock quantity and reorder levels
- Record customer orders and their status
- Store individual order items and unit prices
- Generate basic, intermediate and advanced SQL reports

## Entities / Tables

| Entity | Key / Main columns | Purpose |
|---|---|---|
| `categories` | category_id (PK), category_name, description | Product categories |
| `suppliers` | supplier_id (PK), supplier_name, contact_person, phone, email, address | Supplier information |
| `customers` | customer_id (PK), first_name, last_name, email, phone, city, registered_on | Customer information |
| `products` | product_id (PK), product_name, category_id (FK), supplier_id (FK), price, unit | Product master data |
| `inventory` | inventory_id (PK), product_id (FK/UNIQUE), quantity_in_stock, reorder_level | Stock tracking |
| `orders` | order_id (PK), customer_id (FK), order_date, status | Customer orders |
| `order_items` | order_item_id (PK), order_id (FK), product_id (FK), quantity, unit_price | Order line items |

## Relationships

| Relationship | Cardinality | Description |
|---|---|---|
| categories → products | 1:N | One category can have many products |
| suppliers → products | 1:N | One supplier can supply many products |
| products → inventory | 1:1 | One product has one inventory row |
| customers → orders | 1:N | One customer can place many orders |
| orders → order_items | 1:N | One order can contain many line items |
| products → order_items | 1:N | A product can appear in many order items |
| orders ↔ products | M:N | Resolved using `order_items` |

## Project files

| File | Description |
|---|---|
| `schema.sql` | Table definitions (`CREATE TABLE` statements) |
| `sample_data.sql` | Demo data to populate the tables |
| `queries.sql` | 30 SQL reports: basic filters, joins, aggregations, subqueries, window functions and CTEs |

## Getting started

```sql
-- 1. Create the schema
SOURCE schema.sql;

-- 2. Load sample data
SOURCE sample_data.sql;

-- 3. Run the reports
SOURCE queries.sql;
```

## Example reports included

- Products above/below the average price
- Customer who spent the most
- Products ranked by revenue (`RANK() OVER`)
- Running revenue total by date (window function)
- Month-over-month revenue growth (`LAG()`)
- Top 3 products per category (CTE + `RANK()`)
- Full order summary with a value segment (`CASE`)

## Conclusion

The project provides a clean relational structure for product and order management. It demonstrates how connected tables can support inventory control, customer order tracking and useful business analysis through SQL.

---
**Author:** Moon Sao
