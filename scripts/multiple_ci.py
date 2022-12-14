# stdlib
import os
import sys

# third party
from dbtc import dbtCloudClient


CI_JOB_NAMING_CONVENTION = 'CI Job'
CAUSE = 'Multiple CI Trigger'
GITHUB_PULL_REQUEST_ID = os.getenv('GITHUB_PULL_REQUEST_ID', None)
GIT_SHA = os.getenv('GIT_SHA', None)
ACCOUNT_ID = os.getenv('DBT_CLOUD_ACCOUNT_ID', None)
POLLING_INTERVAL = 10
COMPLETED_STATUSES = ['success', 'error', 'cancelled']


if __name__ == '__main__':
    
    # Initialize client
    client = dbtCloudClient()
    account_id = os.environ['DBT_CLOUD_ACCOUNT_ID']
    
    # Get all the CI jobs across every project
    jobs = client.cloud.list_jobs(account_id)
    total_job_count = jobs['extra']['pagination']['total_count']
    all_jobs = jobs['data']
    
    for offset in range(100, total_job_count, 100):
        jobs = client.cloud.list_jobs(account_id, offset=offset)
        all_jobs.extend(jobs['data'])
        
    ci_jobs = [
        job for job in all_jobs if CI_JOB_NAMING_CONVENTION.lower() in job['name']
    ]
    
    # Create standard payload
    payload = {
        'cause': CAUSE,
        'git_sha': GIT_SHA,
        'github_pull_request_id': GITHUB_PULL_REQUEST_ID,
    }
    
    # Create list for all run IDs
    run_ids = []
    
    # Trigger all your CI jobs
    for ci_job in ci_jobs:
        schema_override = f'dbt_cloud_pr_{ci_job["id"]}_{GITHUB_PULL_REQUEST_ID}'
        payload.update({'schema_override': schema_override})
        run = client.cloud.trigger_job(account_id, ci_job['id'], payload)
        run_ids.append(run['id'])
        
    completed_dict = {s: [] for s in COMPLETED_STATUSES}

    # Poll until all runs are in a "completed" state (success, failure, cancelled)
    while True:
        completed_runs = client.cloud.list_runs(
            account_id, order_by='-id', status=COMPLETED_STATUSES
        )['data']
        completed_runs_dict = {r['id']: r for r in completed_runs}
        completed_runs_ids = completed_runs.keys()
        for run_id in run_ids:
            if run_id in completed_runs_ids:
                run = completed_runs_dict[run_id]
                completed_dict[run['status_humanized'].lower()].append(run)
                run_ids.remove(run['id'])
        if len(run_ids) == 0:
            break
    
    if completed_dict['error'] or completed_dict['cancelled']:
        sys.exit(1)
        
    else:
        sys.exit(0)
