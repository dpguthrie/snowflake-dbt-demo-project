#!/usr/bin/env python
import os
import yaml


if __name__ == '__main__':
    
    warehouse_config = {
        'type': 'snowflake',
        'account': os.getenv('SF_ACCOUNT', None),
        'user': os.getenv('SF_USER', None),
        'password': os.getenv('SF_PASSWORD', None),
        'role': os.getenv('SF_ROLE', 'TRANSFORMER'),
        'database': os.getenv('SF_DATABASE', 'DOUG_DEMO_V2'),
        'schema': os.getenv('SF_SCHEMA', 'dbt_dguthrie'),
        'warehouse': os.getenv('SF_WAREHOUSE', 'TRANSFORMING'),
    }
    
    target_name = 'prod'
    
    profile_config = {
        'tpch': {
            'outputs': {
                target_name: warehouse_config,
            },
            'target': target_name,
        },
    }

    print(yaml.dump(profile_config))
