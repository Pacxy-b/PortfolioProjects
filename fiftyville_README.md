# CS50 Fiftyville SQL Investigation

This project is part of **Harvard’s CS50: Introduction to Computer Science** course.  
It involves solving a fictional mystery set in the town of **Fiftyville** using SQL.  
The goal is to analyze a SQLite database to uncover **who committed the crime, who assisted them, and where they escaped to**, entirely through structured queries and logical deduction.


## Project Objective

The **Fiftyville** project challenges you to:
- Strengthen SQL skills by writing complex queries.  
- Use data relationships to investigate and solve a mystery.  
- Apply analytical thinking to extract meaningful insights from structured data.


## Dataset Overview

The provided SQLite database (`fiftyville.db`) contains multiple tables that simulate real-world city data. Each table offers different types of information that help piece together the mystery.

| Table | Description |
|--------|--------------|
| `crime_scene_reports` | Contains details about reported crimes (date, location, and description). |
| `interviews` | Includes witness interviews and clues related to the case. |
| `bank_accounts` | Links individuals to their bank accounts. |
| `atm_transactions` | Records of all ATM withdrawals and deposits. |
| `phone_calls` | Lists phone calls between individuals, including timestamps and duration. |
| `flights`, `airports`, `passengers` | Contain data about flights, airports, and passenger manifests. |

By exploring and connecting data across these tables, you can reconstruct the sequence of events and solve the case.


## Files Included

| File | Description |
|------|--------------|
| **`log.sql`** | A record of all SQL queries written during the investigation process. |
| **`fiftyville.db`** | The SQLite database file containing all project data. |
| **`answers.txt`** | A summary of the findings — the thief, the accomplice, and where they escaped to. |


## Links to files

### 1. [View SQL log](https://github.com/Pacxy-b/PortfolioProjects/blob/main/fiftyville_log.sql)
### 2. [Download database](https://github.com/Pacxy-b/PortfolioProjects/blob/main/fiftyville_database.db)
### 3. [Read findings](https://github.com/Pacxy-b/PortfolioProjects/blob/main/fiftyville_answers.txt)


## Skills Demonstrated

- SQL query writing and optimization
- Filtering, and subqueries
- Logical reasoning through relational data
- Data analysis and investigative problem-solving
- Understanding database relationships and schema design

  
## License
This project is for educational and portfolio purposes only.  
All original materials, including the database and instructions, were provided by [CS50: Introduction to Computer Science](https://cs50.harvard.edu/x/psets/7/fiftyville/), licensed under [CC BY 4.0 License](https://creativecommons.org/licenses/by/4.0/).


### Author
**Benedict Onyekpe**  
Data Enthusiast | Aspiring Data Analyst
 [Connect on LinkedIn](https://www.linkedin.com/in/benedict-onyekpe-0a5718217/)
