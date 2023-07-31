{% macro create_query_stats_table() %}

    {% if execute %}

        -- Create the table if it doesn't exist
        {% set create_table_sql %}

            create table if not exists {{ target.database }}.{{ target.schema }}.query_operator_stats as
            select
                1::integer as dbt_cloud_project_id,
                1::integer as dbt_cloud_run_id,
                1::integer as dbt_cloud_job_id,
                ''::string as dbt_cloud_run_reason,
                ''::string as dbt_version,
                ''::string as invocation_id,
                ''::string as status,
                ''::string as thread_id,
                1.0::float as execution_time,
                ''::string as unique_id,
                *
            from table(get_query_operator_stats(last_query_id()))
            limit 0;

        {% endset %}

        {% do run_query(create_table_sql) %}

    {% endif %}

{% endmacro %}