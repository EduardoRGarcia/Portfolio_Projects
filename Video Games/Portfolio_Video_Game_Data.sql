
--Test
Select *
From game_sales_data

--How many Total Sales (Per Million) were there each Year
Select
Year, SUM(Total_Shipped) as Yearly_Sales_Millions
From game_sales_data
Group By Year 
Order By Year desc

--Total Sales for Each Console
Select  Platform, SUM(Total_Shipped) as Total_Sales_Per_Million
From game_sales_data
group by Platform
Order By Total_Sales_Per_Million desc

--Best Video Game Sales For each Platform
Select  
	Platform,
	Name,
	Max(Total_Shipped) as BestSeller
From game_sales_data 
group by Platform, Name
Having Count(*) =1
Order By BestSeller desc;

select distinct(Platform) from game_sales_data


