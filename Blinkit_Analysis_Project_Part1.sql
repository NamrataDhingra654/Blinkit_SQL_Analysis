-- ================================================
-- 🌐 Blinkit Retail Sales Analytics Project
-- 📊 Objective: Derive meaningful business insights from Blinkit sales data
-- 🎓 Scope: Data cleaning, KPIs, granular breakdowns, pivoting, and sales analysis
-- ================================================

-- ✅ Step 1: View Raw Data
USE BlinkitDB;
GO
SELECT * FROM blinkit_data;

-- ✅ Step 2: Count Total Records
SELECT COUNT(*) AS Total_Records FROM blinkit_data;

-- ✅ Step 3: Data Cleaning - Standardize Fat Content values
UPDATE blinkit_data
SET Item_Fat_Content = 
CASE 
    WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
    WHEN Item_Fat_Content = 'reg' THEN 'Regular'
    ELSE Item_Fat_Content
END;

-- Verify unique fat content values
SELECT DISTINCT Item_Fat_Content FROM blinkit_data;

-- ================================================
-- 📈 BUSINESS REQUIREMENT: KPI ANALYSIS
-- ================================================
-- 1. Total Sales
SELECT SUM(Sales) AS Total_Sales FROM blinkit_data;
-- As Millions
SELECT CAST(SUM(Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions FROM blinkit_data;

-- 2. Average Sales
SELECT CAST(AVG(Sales) AS DECIMAL(10,1)) AS Average_Sales FROM blinkit_data;
-- For a specific year (2022)
SELECT CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales_2022 FROM blinkit_data WHERE Outlet_Establishment_Year = 2022;

-- 3. Number of Items
SELECT COUNT(*) AS No_Of_Items_2022 FROM blinkit_data WHERE Outlet_Establishment_Year = 2022;

-- 4. Average Rating
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Ratings FROM blinkit_data;

-- ================================================
-- 🔍 GRANULAR REQUIREMENTS
-- ================================================
-- 1. Total Sales by Fat Content
SELECT Item_Fat_Content, 
       CAST(SUM(Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
       CAST(AVG(Sales) AS DECIMAL(10,0)) AS Average_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Ratings
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC;

-- 2. Total Sales by Item Type
SELECT Item_Type, 
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(AVG(Sales) AS DECIMAL(10,1)) AS Average_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Ratings
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- 3. Top & Bottom 5 Item Types
SELECT TOP 5 Item_Type, SUM(Sales) AS Total_Sales FROM blinkit_data GROUP BY Item_Type ORDER BY Total_Sales DESC;
SELECT TOP 5 Item_Type, SUM(Sales) AS Total_Sales FROM blinkit_data GROUP BY Item_Type ORDER BY Total_Sales ASC;

-- 4. Fat Content Sales by Outlet Location (Pivot)
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat_Sales,
       ISNULL([Regular], 0) AS Regular_Sales
FROM (
    SELECT Outlet_Location_Type, Item_Fat_Content, SUM(Sales) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS Source
PIVOT (
    SUM(Total_Sales) FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotResult
ORDER BY Outlet_Location_Type;

-- 5. Total Sales by Outlet Establishment Year
SELECT Outlet_Establishment_Year,
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(AVG(Sales) AS DECIMAL(10,1)) AS Average_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Ratings
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales DESC;

-- ================================================
-- 📊 CHART REQUIREMENTS
-- ================================================
-- 1. Percentage of Sales by Outlet Size
SELECT Outlet_Size,
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-- 2. Sales by Outlet Location (2020)
SELECT Outlet_Location_Type,
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
       CAST(AVG(Sales) AS DECIMAL(10,1)) AS Average_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Ratings
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

-- 3. All Metrics by Outlet Type
SELECT Outlet_Type,
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
       CAST(AVG(Sales) AS DECIMAL(10,1)) AS Average_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Average_Ratings
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;
