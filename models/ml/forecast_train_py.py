import pandas as pd

from datetime import datetime

from prophet import Prophet
from prophet.serialize import model_to_json


def model(dbt, session):

    # dbt configuration
    dbt.config(
        materialized='incremental',
        packages=['pandas', 'prophet'],
        snowflake_warehouse='SNOWPARK_WH',
    )

    # get upstream data
    revenue = dbt.ref('revenue_weekly_by_ship_mode').to_pandas()

    # rename to match Prophet's expected column names
    renames = {
        'date_week'.upper(): 'ds',
        'ship_mode'.upper(): 'location',
        'total_revenue'.upper(): 'y',
    }
    revenue = revenue.rename(columns=renames)

    # get list of unique locations dynamically
    locations = sorted(list(revenue['location'].unique()))

    # train the ML models per location
    models = [
        Prophet().fit(revenue[revenue['location'] == location])
        for location in locations
    ]

    # use current time to 'version' models
    trained_at = datetime.now()

    # persist models -- serialize Prophet as JSON via provided method
    df = pd.DataFrame(
        {
            'trained_at': [trained_at] * len(locations),
            'location': locations,
            'model': [model_to_json(model) for model in models],
        }
    )

    return df