import pandas as pd

from prophet import Prophet
from prophet.serialize import model_from_json


def model(dbt, session):

    # dbt configuration
    dbt.config(packages=['pandas', 'prophet'], snowflake_warehouse='SNOWPARK_WH')

    # get trained ML models
    # TODO: filter by trained_at to last X days or something
    models = dbt.ref('forecast_train_py').to_pandas()

    # get most recent trained_at
    most_recent_trained_at = models['trained_at'].max()

    # filter models by most recent trained_at
    models = models[models['trained_at'] == most_recent_trained_at]

    # get list of unique locations dynamically
    locations = sorted(list(models['location'].unique()))

    # hydrate models as Prophet objects
    models = {
        location: model_from_json(
            models[models['location'] == location]['model'].iloc[0]
        )
        for location in locations
    }

    # create future dataframe to forecast on
    future = models[locations[0]].make_future_dataframe(periods=52 * 3, freq='W')

    # score model per location
    forecasts = {location: models[location].predict(future) for location in locations}

    # dataframe magic (use location to filter forecasts from single table)
    for location, forecast in forecasts.items():
        forecast['location'] = location

    # create a single dataframe to return
    df = pd.concat(forecasts.values())

    return df