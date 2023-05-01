{% macro get_query_stats(results) %}

    {% if execute %}

        {% if results != [] %}

            {% for result in results %}

                {% if result.adapter_response %}

                    {% set query_id = result.adapter_response.query_id %}

                    {% do log('Uploading stats for query ' ~ query_id, true) %}

                    {% set insert_sql %}

                        insert into {{ target.database }}.{{ target.schema }}.query_operator_stats
                        select
                            {{ env_var('DBT_CLOUD_PROJECT_ID', 'null') }},
                            {{ env_var('DBT_CLOUD_RUN_ID', 'null') }},
                            {{ env_var('DBT_CLOUD_JOB_ID', 'null') }},
                            '{{ env_var('DBT_CLOUD_RUN_REASON', '') }}',
                            '{{ dbt_version }}',
                            '{{ invocation_id }}',
                            '{{ result.status }}',
                            '{{ result.thread_id }}',
                            {{ result.execution_time }},
                            '{{ result.unique_id }}',
                            *
                        from table(get_query_operator_stats('{{ query_id }}'));

                    {% endset %}

                    {% do run_query(insert_sql) %}

                {% endif %}

            {% endfor %}

        {% endif %}

    {% endif %}

{% endmacro %}