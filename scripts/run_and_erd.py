# stdlib
import os

# third party
from dbtc import dbtCloudClient as dbtc
from eralchemy import render_er


# Put all of the schemas here that you'd like to generate an ERD for
SCHEMAS = ['TPCH']


if __name__ == '__main__':

    account_id = os.getenv('DBT_CLOUD_ACCOUNT_ID')
    job_id = os.getenv('DBT_CLOUD_JOB_ID')
    
    # Initialize dbtCloudClient with appropriate token
    client = dbtc(
        service_token=os.getenv('DBT_CLOUD_SERVICE_TOKEN'),
    )
    
    # Trigger Job and Poll until successful
    run_id = client.cloud.trigger_job_and_poll(
        account_id, job_id, {'cause': 'Triggered via GH actions'}
    )
    
    print(f'View run here:  https://cloud.getdbt.com/#/accounts/{account_id}/projects/88168/runs/{run_id}/')
    
    # Retrieve the URI stored as a secret
    db_uri = os.getenv('DB_URI', None)
    
    # Ensure that it's set
    if db_uri is not None:

        for schema in SCHEMAS:
            uri = db_uri.format(**{'schema': schema})
            render_er(uri, f'assets/{schema.lower()}_erd.png')
        
        print(f'View docs here:  https://cloud.getdbt.com/#/accounts/{account_id}/jobs/{job_id}/#!/overview')
