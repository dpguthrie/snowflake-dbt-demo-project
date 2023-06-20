def model(dbt, session):

    # Access to config block
    dbt.config(
        materialized='table',
        snowflake_warehouse='SNOWPARK_WH',
        enabled=False,
    )

    # Get upstream data
    df = dbt.ref('fct_orders')

    # Describe the data
    df = df.describe()

    return df
