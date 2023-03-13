# stdlib
import os
import sys
import time

# third party
import requests
from dbtc import dbtCloudClient


# Inputs
CI_JOB_NAMING_CONVENTION = 'CI Job'
CAUSE = 'Multiple CI Trigger'
POLLING_INTERVAL = 10

# Used in payload
GITHUB_PULL_REQUEST_ID = os.getenv('GITHUB_PULL_REQUEST_ID', None)
GIT_SHA = os.getenv('GIT_SHA', None)
ACCOUNT_ID = os.getenv('DBT_CLOUD_ACCOUNT_ID', None)

# Needed in list_runs endpoint
COMPLETED_STATUSES = ['success', 'error', 'cancelled']

# If an error is encountered
GITHUB_TOKEN = os.getenv('GITHUB_TOKEN')
PR_COMMENT_URL = os.getenv('PR_COMMENT_URL')


if __name__ == '__main__':
    
    # Initialize client
    client = dbtCloudClient()
    
    # Get all the CI jobs across every project
    jobs = client.cloud.list_jobs(ACCOUNT_ID)
    total_job_count = jobs['extra']['pagination']['total_count']
    all_jobs = jobs['data']
    
    for offset in range(100, total_job_count, 100):
        jobs = client.cloud.list_jobs(ACCOUNT_ID, offset=offset)
        all_jobs.extend(jobs['data'])
        
    ci_jobs = [
        job for job in all_jobs
        if CI_JOB_NAMING_CONVENTION.lower() in job['name'].lower()
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
        run = client.cloud.trigger_job(
            ACCOUNT_ID, ci_job['id'], payload, should_poll=False
        )
        run_ids.append(run['data']['id'])
        
    completed_dict = {s: [] for s in COMPLETED_STATUSES}

    # Poll until all runs are in a "completed" state (success, failure, cancelled)
    while True:
        time.sleep(POLLING_INTERVAL)
        completed_runs = client.cloud.list_runs(
            ACCOUNT_ID,
            order_by='-id',
            status=COMPLETED_STATUSES,
            include_related=['job'],
        )['data']
        completed_runs_dict = {r['id']: r for r in completed_runs}
        completed_runs_ids = completed_runs_dict.keys()
        for run_id in run_ids[:]:
            if run_id in completed_runs_ids:
                run = completed_runs_dict[run_id]
                completed_dict[run['status_humanized'].lower()].append(run)
                run_ids.remove(run['id'])
        if len(run_ids) == 0:
            break
    
    if completed_dict['error'] or completed_dict['cancelled']:
        message = '# dbt Cloud Run Failures\n'
        for status in ['error', 'cancelled']:
            message += f'### The following jobs completed with a status of {status}:\n'
            for run in completed_dict[status]:
                job_name = run['job']['name']
                href = run['href']
                id = run['id']
                message += f'- **{job_name}** failed for [Run #{id}]({href})\n'
        payload = {'body': message}
        headers = {'Authorization': f'Bearer {GITHUB_TOKEN}'}
        response = requests.post(PR_COMMENT_URL, json=payload, headers=headers)
        sys.exit(1)
        
    else:
        sys.exit(0)
