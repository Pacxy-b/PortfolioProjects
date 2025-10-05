# COVID-19 Data Exploration Project (My Version)

This project is my personal take on the **COVID-19 Data Exploration** project originally inspired by [Alex the Analyst](https://www.youtube.com/c/AlexTheAnalyst).  
Using SQL, I analysed global COVID-19 data to gain insights into infection trends, mortality rates, and vaccination progress. The goal was to strengthen my SQL skills while applying them to a real-world dataset.


## Project Link
You can view the full project here:  
  [**COVID-19 Data Exploration**](https://github.com/Pacxy-b/PortfolioProjects/blob/main/COVID-19_Data_Exploration.sql)  


## Project Overview
In this project, I used SQL to analyse global COVID-19 statistics and answer key questions such as:
- Which countries had the highest infection and death rates?
- What was the probability of dying from COVID-19 once infected per country?
- How did vaccination rates progress over time?
- What percentage of each country’s population was infected?

This project highlights how data exploration can reveal valuable patterns and help transform raw data into actionable insights.


## Dataset
The dataset originates from [Our World in Data (OWID)](https://ourworldindata.org/covid-deaths), which provides global COVID-19 metrics updated daily.

**Key Columns:**
- `location`
- `date`
- `total_cases`
- `new_cases`
- `total_deaths`
- `population`
- `new_vaccinations`


## SQL Skills Demonstrated
Throughout this project, I practised and implemented several SQL techniques:

- **Data Filtering & Cleaning** using `WHERE`, `IS NULL`, `CAST`, `CONVERT`
- **Aggregations** (`SUM`, `MIN`)
- **Joins** to merge COVID case and vaccination data
- **Common Table Expressions (CTEs)** for cleaner queries
- **Window Functions** (`OVER()`) for rolling totals and percentages
- **Views** to save and reuse queries


## Example Insights
- Top 10 countries with the highest infection and death rates
- Percentage of the population per country that got infected and died from COVID-19 
- Global vaccination progress over time  
- Countries with the largest percentage of population vaccinated  
- Rolling sum of people vaccinated per country


## Tools & Technologies
- **SQL:** Microsoft SQL Server  
- **Dataset:** [Our World in Data - COVID-19](https://ourworldindata.org/covid-deaths)  
- **Visualisation (optional):** Tableau  


## How to Reproduce
1. Download the COVID-19 dataset from *Our World in Data*.  
2. Import it into your SQL environment (SQL Server, MySQL, etc.).  
3. Run the provided SQL scripts to replicate the analysis.  
4. Optionally, visualise your results using Tableau or Power BI.


## License
This project is for educational and portfolio purposes only.  
Data sourced from [Our World in Data](https://ourworldindata.org), licensed under [Creative Commons BY 4.0](https://creativecommons.org/licenses/by/4.0/).


### Author
**Benedict Onyekpe**  
Data Enthusiast | Data Analyst  
*Inspired by Alex the Analyst’s SQL Portfolio Project Series*  
*[Connect on LinkedIn](https://www.linkedin.com/in/benedict-onyekpe-0a5718217/)*
