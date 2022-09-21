def model(dbt, session):
    dbt.config(materialized="table")

    df = dbt.ref('fct_orders')
    df = df.describe()
    return df