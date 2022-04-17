Welcome to the dbt Labs demo dbt project! We use the [TPCH dataset](https://docs.snowflake.com/en/user-guide/sample-data-tpch.html) to create a sample project to emulate what a production project might look like!

# Storing Failures

Documentation can be viewed here:  https://docs.getdbt.com/reference/resource-configs/store_failures

## What is this?

Optionally set a test to always or never store its failures in the database

It can be configured to store for a specific test, singular test, generic block, or at the project level.

## Show Me

This project is configured to store failures at the project level.  Additional modeling is done to union together all failures in a single model that we can analyze and even snapshot to show trends over time.

## Differences from Main

- The `stg_tpch_orders_assert_positive_price` test has been modified to return failures (total_price < 1000 instead of 0)
- `unique` and `not_null` tests were added to the `l_orderkey` column on the tpch.lineitem source (this will also fail)
