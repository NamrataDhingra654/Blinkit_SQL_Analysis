# Blinkit_SQL_Analysis
This project analyzes Blinkit's retail sales data using SQL Server to uncover trends in item and outlet performance, stock planning, and customer behavior. It uses KPIs, aggregation, and normalization to simulate real-world retail analytics for better business decisions.




---

## 🔍 Project Objectives

- Analyze item and outlet performance using transactional sales data
- Generate business insights for stock planning and outlet benchmarking
- Build a normalized schema to simulate a real-world retail database
- Use SQL for end-to-end BI reporting and decision support

---

## 🧮 KPIs and Metrics Tracked

| Metric                  | Description                                           |
|------------------------|-------------------------------------------------------|
| ✅ Total Sales          | Total revenue from all transactions                   |
| ✅ Average Sales        | Average revenue per transaction                       |
| ✅ Number of Items      | Total count of sold items                             |
| ✅ Average Ratings      | Mean customer satisfaction score                      |

---

## 📌 Business Use Cases Solved

### 1. **Performance Categorization**
- Categorized items into: Top Performers, Hidden Gems, Low-rated Bestsellers
- Helps identify which products to promote, improve, or phase out

### 2. **Stock Planning**
- Identifies low-performing items by outlet
- Suggests actions like discounting or removal to improve inventory management

### 3. **Consistent High Performers by Outlet**
- Uses CTEs and filtering to find outlets consistently selling high-rated items

### 4. **Outlet Benchmarking**
- Compares each outlet's total sales against the global average
- Classifies outlets as "Top Performer", "Mid Performer", or "Needs Improvement"

### 5. **Sales Trends Over Time**
- Tracks sales performance by outlet type and establishment year
- Useful for time-series analysis and business growth evaluation

### 6. **Data Normalization**
- Splits flat table into:
  - `Item_Master`: Item metadata
  - `Outlet_Master`: Outlet metadata
- Simulates real-world relational schema using `JOINs` for KPI calculation

### 7. **Charts & Granular Analysis**
- Sales breakdown by:
  - Fat content
  - Outlet size
  - Outlet type
  - Outlet location

---

## 🛠️ Technologies Used

- SQL Server / SSMS
- T-SQL (Joins, CTEs, Window functions, CASE, GROUP BY, HAVING)
- Git + GitHub for version control

---

## 📈 Key Insights

- Items with high ratings but low sales can be promoted (Hidden Gems)
- Some outlets consistently outperform others regardless of item
- Older outlets may not always guarantee better performance
- Fat content and product category significantly affect sales

---

## 💡 Real-World Applications

- Helps retail operations optimize **stock planning**
- Assists marketing in **targeted promotions**
- Aids regional managers in **benchmarking outlets**
- Useful in **dashboards (e.g., Power BI/Tableau)** for visual reporting

---

## 🚀 Getting Started

To run the project:
1. Import `blinkit_data` into your SQL Server database
2. Run the queries in `Blinkit_KPIs.sql` and `Blinkit_Advanced_Queries.sql`
3. Customize thresholds, dates, or filters for specific use cases

---

## 🙌 Author

**Namrata**  
B.Tech CSE Student

