create database blinkit;
go

use blinkit
go

--Count total rows
select count(*) from BlinkIT_Grocery_Data;
go

--clean data 

UPDATE BlinkIT_Grocery_Data
SET Item_Fat_Content = 
    CASE 
        WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;


SELECT DISTINCT Item_Fat_Content FROM BlinkIT_Grocery_Data;
----------------------------------------
-- Total sales
SELECT CAST(SUM(total_sales) / 1000000 AS DECIMAL(10,2)) as Total_sales 
from BlinkIT_Grocery_Data;

--Average Sales
SELECT cast(AVG(total_sales) as decimal(10, 2) ) as Avg_sales 
from BlinkIT_Grocery_Data;

--
SELECT COUNT(*) AS No_of_Orders
FROM BlinkIT_Grocery_Data;

--Average Rattings
SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM BlinkIT_Grocery_Data;

-- Total Sales by Fat Content:
SELECT Item_Fat_Content, 
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST(AVG(Total_Sales) AS DECIMAL(10,2)) AS AVG_Sales,
	count(*) as No_of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM BlinkIT_Grocery_Data
GROUP BY Item_Fat_Content;

-- Total Sales by Item Type
SELECT top 5
	Item_Type, 
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST(AVG(Total_Sales) AS DECIMAL(10,2)) AS AVG_Sales,
	count(*) as No_of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM BlinkIT_Grocery_Data
GROUP BY Item_Type
ORDER BY Total_Sales DESC

-- Fat Content by Outlet for Total Sales
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM BlinkIT_Grocery_Data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

-- Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM BlinkIT_Grocery_Data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year


--F. Percentage of Sales by Outlet Size
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM BlinkIT_Grocery_Data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

--G. Sales by Outlet Location
SELECT Outlet_Location_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM  BlinkIT_Grocery_Data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC

--H. All Metrics by Outlet Type:
SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM BlinkIT_Grocery_Data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC


