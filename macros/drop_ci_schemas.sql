-- Drop schemas created during cloud CI runs
{% macro drop_ci_schemas(databases, dryrun=True) %}

    {% set all_schemas_to_drop = [] %}

    {% set drop_schema_sql %}

    {% for db in databases %}

        {% set find_schemas_sql %}
            SELECT SCHEMA_NAME
            FROM {{ db | upper }}.INFORMATION_SCHEMA.SCHEMATA
            WHERE SCHEMA_NAME LIKE 'DBT_CLOUD_PR_%';
        {% endset %}

        {% set schemas_to_drop = run_query(find_schemas_sql) %}

        {% for row in schemas_to_drop %}
            DROP SCHEMA {{ db | upper }}.{{ row[0] | upper }};
            {% do all_schemas_to_drop.append('{}.{}'.format(db.upper(), row[0].upper())) %}
        {% endfor %}

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