-- ==========================================================
-- 📌 Retail Analytics SQL Project - Blinkit Sales Dashboard
-- ==========================================================
-- 🧠 Objective: Transform flat retail sales data into a structured,
-- insightful analytics-ready format using only SQL.
-- Highlights include:
-- ✅ Item-level performance
-- ✅ Outlet-level benchmarking
-- ✅ Time-based sales trends
-- ✅ Inventory suggestions
-- ✅ Normalized schema using joins
-- ==========================================================


-- ==========================================================
-- 🔹 PART 1: ITEM-LEVEL PERFORMANCE ANALYSIS
-- ==========================================================

-- Step 1: Drop and recreate view to store average performance by item
DROP VIEW IF EXISTS ItemPerformance;
GO

CREATE VIEW ItemPerformance AS
SELECT 
    Item_Identifier,
    Item_Type,
    AVG(Sales) AS Avg_Sales,
    AVG(Rating) AS Avg_Rating
FROM blinkit_data
GROUP BY Item_Identifier, Item_Type;
GO

-- Step 2: Top Performers - High Sales and High Ratings
SELECT * FROM ItemPerformance
WHERE Avg_Sales > 150 AND Avg_Rating >= 4.5;

-- Step 3: Hidden Gems - Low Sales but High Ratings
SELECT * FROM ItemPerformance
WHERE Avg_Sales < 100 AND Avg_Rating >= 4.5;

-- Step 4: Quality Risk - High Sales but Low Ratings
SELECT * FROM ItemPerformance
WHERE Avg_Sales > 150 AND Avg_Rating < 3;

-- Step 5: Summary Category Report
SELECT 
    CASE 
        WHEN Avg_Sales > 150 AND Avg_Rating >= 4.5 THEN 'Top Performer'
        WHEN Avg_Sales < 100 AND Avg_Rating >= 4.5 THEN 'Hidden Gem'
        WHEN Avg_Sales > 150 AND Avg_Rating < 3 THEN 'High Sales, Poor Ratings'
        ELSE 'Regular Performer'
    END AS Performance_Category,
    COUNT(*) AS No_of_Items,
    CAST(AVG(Avg_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    CAST(AVG(Avg_Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM ItemPerformance
GROUP BY
    CASE 
        WHEN Avg_Sales > 150 AND Avg_Rating >= 4.5 THEN 'Top Performer'
        WHEN Avg_Sales < 100 AND Avg_Rating >= 4.5 THEN 'Hidden Gem'
        WHEN Avg_Sales > 150 AND Avg_Rating < 3 THEN 'High Sales, Poor Ratings'
        ELSE 'Regular Performer'
    END;



-- ==========================================================
-- 🔹 PART 2: OUTLET-LEVEL ITEM PERFORMANCE & SUGGESTIONS
-- ==========================================================

SELECT 
    Outlet_Identifier,
    Item_Type,
    COUNT(*) AS Total_Transactions,
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS Avg_Sales,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CASE 
        WHEN AVG(Sales) < 50 THEN 'Critical - Overstock Risk'
        WHEN AVG(Sales) BETWEEN 50 AND 99.99 THEN 'Low Performance'
        WHEN AVG(Sales) >= 100 AND AVG(Sales) < 200 THEN 'Moderate'
        ELSE 'Strong Performer'
    END AS Outlet_Item_Performance,
    CASE 
        WHEN AVG(Sales) < 50 THEN 'Consider Removal'
        WHEN AVG(Sales) BETWEEN 50 AND 99.99 THEN 'Discount or Promote'
        ELSE 'Keep in Stock'
    END AS Suggested_Action
FROM blinkit_data
GROUP BY Outlet_Identifier, Item_Type
ORDER BY Avg_Sales ASC;


-- ==========================================================
-- 🔹 PART 3: OUTLETS WITH CONSISTENT HIGH PERFORMERS
-- ==========================================================

WITH RankedItems AS (
    SELECT 
        Outlet_Identifier,
        Item_Identifier,
        AVG(Sales) AS Avg_Sales,
        AVG(Rating) AS Avg_Rating
    FROM blinkit_data
    GROUP BY Outlet_Identifier, Item_Identifier
)
SELECT 
    Outlet_Identifier,
    COUNT(*) AS High_Performing_Items,
    CAST(AVG(Avg_Sales) AS DECIMAL(10,2)) AS Avg_Sales_Of_Top_Items,
    CAST(AVG(Avg_Rating) AS DECIMAL(10,2)) AS Avg_Rating_Of_Top_Items
FROM RankedItems
WHERE Avg_Sales > 150 AND Avg_Rating > 4.5
GROUP BY Outlet_Identifier
ORDER BY High_Performing_Items DESC;


-- ==========================================================
-- 🔹 PART 4: OUTLET BENCHMARKING VS GLOBAL AVERAGE
-- ==========================================================

SELECT 
    Outlet_Identifier,
    COUNT(*) AS Total_Transactions,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS Avg_Sale_Per_Transaction,
    CASE 
        WHEN SUM(Sales) > (SELECT AVG(Sales) FROM blinkit_data) THEN 'Above Average'
        ELSE 'Below Average'
    END AS Performance_Status,
    CASE 
        WHEN SUM(Sales) > 30000 THEN 'Top Outlet'
        WHEN SUM(Sales) BETWEEN 20000 AND 30000 THEN 'Mid Performer'
        ELSE 'Needs Improvement'
    END AS Outlet_Tier_Category
FROM blinkit_data
GROUP BY Outlet_Identifier
ORDER BY Total_Sales DESC;


-- ==========================================================
-- 🔹 PART 5: OUTLET TYPE PERFORMANCE OVER YEARS
-- ==========================================================

SELECT 
    Outlet_Establishment_Year,
    Outlet_Type,
    COUNT(DISTINCT Outlet_Identifier) AS No_Of_Outlets,
    COUNT(*) AS Total_Transactions,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS Avg_Sale_Per_Transaction,
    CASE 
        WHEN SUM(Sales) > 30000 THEN 'Strong Sales Year'
        WHEN SUM(Sales) BETWEEN 20000 AND 30000 THEN 'Moderate Year'
        ELSE 'Weak Performance'
    END AS Yearly_Performance_Tier
FROM blinkit_data
GROUP BY Outlet_Establishment_Year, Outlet_Type
ORDER BY Outlet_Establishment_Year, Outlet_Type;


-- ==========================================================
-- 🔹 PART 6: NORMALIZATION & JOINING FOR KPI DASHBOARDS
-- ==========================================================

-- Step 1: Create Item Master Table
IF OBJECT_ID('Item_Master', 'U') IS NOT NULL
    DROP TABLE Item_Master;

SELECT DISTINCT 
    Item_Identifier,
    Item_Type,
    Item_Fat_Content
INTO Item_Master
FROM blinkit_data;

-- Step 2: Create Outlet Master Table
IF OBJECT_ID('Outlet_Master', 'U') IS NOT NULL
    DROP TABLE Outlet_Master;

SELECT DISTINCT 
    Outlet_Identifier,
    Outlet_Type,
    Outlet_Location_Type,
    Outlet_Size,
    Outlet_Establishment_Year
INTO Outlet_Master
FROM blinkit_data;

-- Step 3: Join Both Masters to Transaction Table and Analyze
SELECT 
    i.Item_Type,
    o.Outlet_Type,
    COUNT(*) AS Total_Transactions,
    CAST(SUM(b.Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(b.Sales) AS DECIMAL(10,2)) AS Avg_Sale_Per_Transaction,
    CAST(AVG(b.Rating) AS DECIMAL(10,2)) AS Avg_Rating,
    CASE 
        WHEN SUM(b.Sales) > 30000 THEN 'High Performer'
        WHEN SUM(b.Sales) BETWEEN 20000 AND 30000 THEN 'Moderate'
        ELSE 'Low Performer'
    END AS Outlet_Item_Category
FROM blinkit_data b
JOIN Item_Master i ON b.Item_Identifier = i.Item_Identifier
JOIN Outlet_Master o ON b.Outlet_Identifier = o.Outlet_Identifier
GROUP BY i.Item_Type, o.Outlet_Type
ORDER BY Total_Sales DESC;
