# stdlib
import json
import os

# third party
from datadog_api_client.v2 import ApiClient, Configuration
from datadog_api_client.v2.api.logs_api import LogsApi
from datadog_api_client.v2.model.http_log import HTTPLog
from datadog_api_client.v2.model.http_log_item import HTTPLogItem
from dbtc_api import dbtCloudClient as dbtc

# Maximum array size from datadog docs
MAX_LIST_SIZE = 1000


def chunker(seq):
    """Ensure that the log array is <= to the MAX_LIST_SIZE)"""
    size = MAX_LIST_SIZE
    return (seq[pos:pos + size] for pos in range(0, len(seq), size))


def send_logs(body):
    body = HTTPLog(body)
    configuration = Configuration()
    with ApiClient(configuration) as api_client:
        api_instance = LogsApi(api_client)
        response = api_instance.submit_log(body=body, content_encoding='gzip')
        return response


# Saving some of what's returned from metadata API
fields_to_keep = [
    'runId',
    'accountId',
    'projectId',
    'environmentId',
    'jobId',
    'uniqueId',
    'resourceType',
    'database',
    'schema',
    'alias',
    'invoicationId',
    'error',
    'status',
    'skip',
    'compileStartedAt',
    'compileCompletedAt',
    'executeStartedAt',
    'executeCompletedAt',
    'executionTime',
    'runGeneratedAt',
    'runElapsedTime',
    'type',
]


if __name__ == '__main__':
    
    logs = []
    account_id = os.getenv('DBT_CLOUD_ACCOUNT_ID')
    job_id = os.getenv('DBT_CLOUD_JOB_ID')
    
    # Initialize client with an API key and service token
    client = dbtc(
        service_token=os.getenv('DBT_CLOUD_SERVICE_TOKEN'),
        api_key=os.getenv('DBT_CLOUD_API_KEY')
    )
    
    # Trigger Job and Poll until successful
    run_id = client.cloud.trigger_job_and_poll(
        account_id, job_id, {'cause': 'Triggered via GH actions'}
    )
    
    # Log run_results.json
    run_results = client.cloud.get_run_artifact(account_id, run_id, 'run_results.json')
    for chunk in chunker(run_results['results']):
        for result in chunk:
            logs.append(HTTPLogItem(
                ddsource='run_results.json',
                ddtags='daily_job',
                hostname='gh_actions',
                message=json.dumps(result),
                service='python'
            ))

    send_logs(logs)
    logs = []
    
    # Log models from metadata API
    models = client.metadata.get_models(job_id, run_id=run_id)
    for chunk in chunker(models['data']['models']):
        for model in chunk:
            logs.append(HTTPLogItem(
                ddsource='metadata_api',
                ddtags='daily_job,models',
                hostname='gh_actions',
                message=json.dumps({k: v for k, v in model.items() if k in fields_to_keep}),
                service='python',
            ))
        
    send_logs(logs)
