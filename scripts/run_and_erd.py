# stdlib
import os

# third party
from dbtc import dbtCloudClient as dbtc
from eralchemy import render_er
from snowflake.sqlalchemy import URL


SCHEMAS = ['TPCH']


if __name__ == '__main__':

    account_id = os.getenv('DBT_CLOUD_ACCOUNT_ID')
    job_id = os.getenv('DBT_CLOUD_JOB_ID')
    
    # Initialize dbtCloudClient with appropriate tokens
    client = dbtc(
        service_token=os.getenv('DBT_CLOUD_SERVICE_TOKEN'),
        api_key=os.getenv('DBT_CLOUD_API_KEY')
    )
    
    # Trigger Job and Poll until successful
    run_id = client.cloud.trigger_job_and_poll(
        account_id, job_id, {'cause': 'Triggered via GH actions'}
    )
    
    print(f'View run here:  https://cloud.getdbt.com/#/accounts/{account_id}/projects/88168/runs/{run_id}/')
    
    for schema in SCHEMAS:
        url = URL(
            account=os.getenv('SF_ACCOUNT'),
            user=os.getenv('SF_USER'),
            password=os.getenv('SF_PASSWORD'),
            database='DOUG_DEMO_V2',
            schema=schema,
            warehouse='TRANSFORMING',
            role='TRANSFORMER',
        )
        render_er(str(url), f'assets/{schema.lower()}_erd.png')
        
    print(f'View docs here:  https://cloud.getdbt.com/#/accounts/{account_id}/jobs/{job_id}/#!/overview')
