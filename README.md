# PostgreSQL Scripts 

## Overview

A collection of query scripts used to support jobs that use the PostgreSQL database. Some scripts are sourced from the internet with modifications and queries that I created myself.

### Focus of This Project:

In this scripts, I dive into practical applications of PostgreSQL, and demonstrate its versatility through the following examples:

1. **Querying Data**
2. **PostgreSQL PL/pgSQL**
3. **Store Procedure and Function**
4. **Backup and Restore**

## Requirements

Before running this scripts, ensure you have the following installed and configured:

1. **PostgreSQL**:
   - Version: PostgreSQL 16 or later
   - Installation Guide: [PostgreSQL Documentation](https://www.postgresql.org/docs/current/tutorial-install.html)

2. **pgAdmin** (optional, for GUI-based database management):
   - Version: pgAdmin 4 or later
   - Download and Installation: [pgAdmin Download](https://www.pgadmin.org/download/)

## Start/Stop PostgreSQL Database on Mac
```
$ brew services start postgresql@16
$ brew services stop postgresql@16
```

## List Scripts 
1. [**Common Table Expression (CTE) with JSON**](01_cte_with_json.sql): 
Displays a list of data with aggregates (summaries) of some of its columns. Query results are displayed in JSON format

2. [**Block prcedure**](02_block_procedure_cursor.sql): 
This sample cursor, update data

3. [**Procedure with JSON parameter**](03_procedure_json_param.sql):
Save data to multiple table from json paramater.
- read JSON
- read array JSON 
- convert row to json with row_to_json