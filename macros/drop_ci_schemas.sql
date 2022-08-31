{# drop_ci_schemas

This macro drops all the schemas within a database beginning with "DBT_CLOUD_PR_". Use the dry_run param to see the schemas that will be dropped before dropping them.

Args:
    - database: string        -- the name of the database to clean. By default the target.database is used
    - dry_run: bool           -- dry run flag. When dry_run is true, the cleanup commands are printed to stdout rather than executed. This is true by default

Example 1 - dry run of current database
    dbt run-operation drop_ci_schemas
    
Example 2 - actual run of current database
    dbt run-operation drop_ci_schemas --args '{dry_run: False}'

Example 3 - drop CI schemas from a different database
    dbt run-operation drop_ci_schemas --args '{database: my_database, dry_run: False}'

#}
{% macro drop_ci_schemas(database=target.database, dryrun=True) %}

    {% set all_schemas_to_drop = [] %}

    {% set drop_schema_sql %}

    {% set find_schemas_sql %}
        SELECT SCHEMA_NAME
        FROM {{ database | upper }}.INFORMATION_SCHEMA.SCHEMATA
        WHERE SCHEMA_NAME LIKE 'DBT_CLOUD_PR_%';
    {% endset %}

    {% set schemas_to_drop = run_query(find_schemas_sql) %}

    {% for row in schemas_to_drop %}
        DROP SCHEMA {{ database | upper }}.{{ row[0] | upper }};
        {% do all_schemas_to_drop.append('{}.{}'.format(database.upper(), row[0].upper())) %}
    {% endfor %}

    {% endset %}

    {% if all_schemas_to_drop %}
        {% if dryrun %}
            {% do log('*NOT* dropping {}'.format(all_schemas_to_drop), info=True) %}
        {% else %}
            {% do log('Dropping: {} ...'.format(all_schemas_to_drop), info=True) %}
            {% do run_query(drop_schema_sql) %}
            {% do log('Done.', info=True) %}
        {% endif %}
    {% else %}
        {% do log('No schemas to drop!', info=True) %}
    {% endif %}

{% endmacro %}
