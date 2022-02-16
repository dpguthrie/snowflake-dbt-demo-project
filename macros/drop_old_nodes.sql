-- Drop tables that are no longer used
{% macro drop_old_nodes(dryrun=True) %}

    {% set nodes = graph.nodes.values() | list %}

    {% set dbs = nodes | map(attribute='database') | unique %}

    {% set all_tables_to_drop = [] %}

    {% set drop_table_sql %}

    {% for db in dbs %}

        -- Database: {{ db }}

        {% set schemas = nodes | selectattr('database', '==', db) | map(attribute='schema') | unique %}

        {% for schema in schemas %}

            -- Schema: {{ schema }}

            {% set model_names = nodes | selectattr('database', '==', db) | selectattr('schema', '==', schema) | map(attribute='name') | map('upper') | join("', '") %}

            {% set find_tables_sql %}
                USE DATABASE {{ db }};
                SELECT DISTINCT TABLE_NAME, TABLE_TYPE
                FROM INFORMATION_SCHEMA.TABLES
                WHERE TABLE_SCHEMA = '{{ schema | upper }}'
                    AND TABLE_TYPE IN ('VIEW', 'BASE TABLE')
                    AND TABLE_NAME NOT IN ('{{ model_names }}');
            {% endset %}
            {% set tables_to_drop = run_query(find_tables_sql) %}

            {% for row in tables_to_drop %}
                DROP {% if row[1] == 'BASE TABLE' %}TABLE{% else %}VIEW{% endif %} {{ db | upper }}.{{ schema | upper }}.{{ row[0] }};
                {% do all_tables_to_drop.append('{}.{}.{}'.format(db.upper(), schema.upper(), row[0].upper())) %}
            {% endfor %}


        {% endfor %}
    {% endfor %}

    {% endset %}

    {% if all_tables_to_drop %}
        {% if dryrun %}
            {% do log('*NOT* dropping {}'.format(all_tables_to_drop), info=True) %}
        {% else %}
            {% do log('Dropping: {} ...'.format(all_tables_to_drop), info=True) %}
            {% do run_query(drop_table_sql) %}
            {% do log('Done.', info=True) %}
        {% endif %}
    {% else %}
        {% do log('No tables to drop!', info=True) %}
    {% endif %}
{% endmacro %}
