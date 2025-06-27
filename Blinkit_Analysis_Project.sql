--Print table
SELECT * FROM blinkit_data

--Print the number of rows
SELECT COUNT(*) FROM blinkit_data

--DATA CLEANING- Making distint unique values
UPDATE blinkit_data
SET Item_Fat_Content = 
CASE 
WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

--Print table to see changes
SELECT * FROM blinkit_data

--Print all the disctint values of a column in the table
SELECT DISTINCT (Item_Fat_Content) FROM blinkit_data

/*

BUSINESS REQUIREMENT - KPI'S REQUIREMENTS

1. TOTAL SALES: The overall revenue generated from all the items sold.
2 AVERAGE SALES: The average revenue per sale.
3. NUMBER OF ITEMS: The total count of different items sold.
4. AVERAGE RATING: The average customer rating for items sold.

*/

-- Finding total sales - First KPI
SELECT SUM (Sales) AS Total_Sales
FROM blinkit_data

--Total Sales in millions
SELECT CAST(SUM (Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions
FROM blinkit_data

-- Finding average sales - Second KPI
SELECT AVG (Sales) AS Average_Sales
FROM blinkit_data

--Average Sales rounded off
SELECT CAST(AVG (Sales) AS DECIMAL(10,0)) AS Average_Sales_roundedOff
FROM blinkit_data

-- Finding the total number of items - Third KPI
SELECT COUNT(*) AS No_Of_Items
FROM blinkit_data

-- Finding average ratings - Fourth KPI
SELECT AVG (Rating) AS Average_Ratings
FROM blinkit_data

--Average ratings upto 2 decimal points
SELECT CAST(AVG (Rating) AS DECIMAL(10,2)) AS Average_Ratings
FROM blinkit_data

/*

BUSINESS REQUIREMENT - GRANULAR REQUIREMENTS

1. TOTAL SALES BY FAT CONTENT: 
		OBJECTIVE: Analyse the impact of fat content on total sales.
		ADDITIONAL KPI METRICS: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

2. TOTAL SALES BY ITEM TYPE:
		OBJECTIVE: Identify the performance of different item types in terms of total sales.
		ADDITIONAL KPI METRICS: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

3. FAT CONTENT BY OUTLET FOR TOTAL SALES: 
		OBJECTIVE: Compare total sales across different outlets segmented by fat content.
		ADDITIONAL KPI METRICS: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

4. TOTAL SALES BY OUTLET ESTABLISHMENT:
		OBJECTIVE: Evaluate how the age or type of outlet establishment influences total sales.

*/

-- Finding total sales by Fat content
SELECT Item_Fat_Content, SUM(Sales) AS Total_Sales










