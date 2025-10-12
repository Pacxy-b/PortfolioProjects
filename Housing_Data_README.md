# Data Housing Cleaning Project


## Overview
The goal of this project is to clean and transform raw housing data into a format ready for analysis. 
The dataset contains housing records including property and owner's address, sale dates, property value, location details and others.
 The cleaning process ensures consistency, removes duplicates, formats date fields and splits combined fields for better usability.


 ## Objectives
 - Import raw housing dataset.
 - Handle NULL and missing values.
 - Split combined address field into separate columns
 - Remove duplicate records using `ROW_NUMBER`, `RANK`, or `DENSE_RANK`.


  ## Tool
  - **SQL Server**


## Key SQL Techniques Used
| Technique | Purpose |
|----------|--------|
| `ALTER TABLE ADD` | To create new columns |
| `UPDATE SET` | Populate new fields from existing address column |
| `ROW_NUMBER / RANK / DENSE_RANK` | Detect and remove duplicates |
| `BEGIN TRANSACTION` & `ROLLBACK` | Safely test changes before committing |
| `DROP COLUMN` | Remove redundant fields |



## Links

### 1. [Download Dataset](https://github.com/Pacxy-b/PortfolioProjects/blob/main/Housing_Dataset.xlsx)
### 2. [Data Cleaning in SQL](https://github.com/Pacxy-b/PortfolioProjects/blob/main/Housing_Data_Cleaning_Project.sql)


### Author
**Benedict Onyekpe**  
Data Enthusiast | Data Analyst  
*[Connect on LinkedIn](https://www.linkedin.com/in/benedict-onyekpe-0a5718217/)*
