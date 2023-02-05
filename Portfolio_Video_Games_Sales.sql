Select
*
From Video_Games_Sales;

--Which Year N. America had higheset Video Game Sales 
Select Year_of_Release,
	SUM(NA_Sales) as Total_NA_Sales_Millions
From Video_Games_Sales
Where Year_of_Release is not NULL and
	NA_Sales is not NULL
Group By Year_of_Release
Order By Total_NA_Sales_Millions desc;

--Which Year Global had higheset Video Game Sales 

Select Year_of_Release,
	SUM(NA_Sales) as Total_NA_Sales_Millions,
	SUM(EU_Sales) as Total_EU_Sales_Millions,
	SUM(JP_Sales) as Total_JP_Sales_Millions,
	SUM(Global_Sales) as Total_Global_Sales_Millions
From Video_Games_Sales
Where Year_of_Release is not NULL and
	Global_Sales is not NULL
Group By Year_of_Release
Order By Total_Global_Sales_Millions desc;

--Which platform sold the most games in N. America
Select
Platform, SUM(NA_Sales) as Total_NA_Sales_Millions
From Video_Games_Sales
where NA_Sales is not NULL
Group By Platform
Order By SUM(NA_Sales) desc;


--Which platform sold the most games in Europe
Select
Platform, SUM(EU_Sales) as Total_EU_Sales_Millions
From Video_Games_Sales
where EU_Sales is not NULL
Group By Platform
Order By SUM(EU_Sales) desc;

--Which platform sold the most games in Japan
Select
Platform, SUM(JP_Sales) as Total_JP_Sales_Millions
From Video_Games_Sales
where JP_Sales is not NULL
Group By Platform
Order By SUM(JP_Sales) desc;

--Which platform sold the most games in Other Regions
Select
Platform, SUM(Other_Sales) as Total_Other_Sales_Millions
From Video_Games_Sales
where Other_Sales is not NULL
Group By Platform
Order By SUM(Other_Sales) desc;

--Most Popular Video Game Globally
Select
Name, Platform, MAX(Global_Sales) as Global_sales_in_Millions
From Video_Games_Sales
where Global_Sales is not NULL
Group BY Name, Platform
Order By Global_sales_in_Millions desc

--Most Popular Genre 
Select
Genre,
SUM(Global_Sales) as Global_sales_in_Millions
From Video_Games_Sales
where Global_Sales is not NULL
Group By Genre
Order By Global_sales_in_Millions desc 
