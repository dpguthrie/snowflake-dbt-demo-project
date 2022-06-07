# stdlib
import os

# third party
from eralchemy import render_er
from snowflake_sqlalchemy import URL


SCHEMAS = ['TPCH']


if __name__ == '__main__':
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
        render_er(url.__str__(), f'assets/{schema.lower()}_erd.png')
