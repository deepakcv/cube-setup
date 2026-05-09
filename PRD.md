Set up postgres and cube using docker compose file. 

Create database schema for managing retail store with products, departments, sales, salesman and cost. 
It should also capture daily sales which later can be aggregated by different parameters like time duration, salesman, department, etc. 

put all DDL script under 'migrations/ddl' and create script which will be executed when container is up to setup database. 

Also create sample data for all tables in a way so we can try different queries mentioned above. Put all sql script in 'migrations/seed' and create script which will be executed after database instance is up from docker compose. 

Setup cube which will be connected to this database. Create semantic model on top of it so we can use cube APIs to get this data using graphql interface. 