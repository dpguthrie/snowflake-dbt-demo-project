{# This macro controls schema naming logic based on the build target #}

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set dev_targets = var('dev_targets') -%}
    {%- set prod_targets = var('prod_targets') -%}
    {%- set default_schema = target.schema -%}
    {%- set target_name = target.name -%}
    {%- if target_name in prod_targets -%}
    {% do log('default schema: ' ~ default_schema, True) %}
    {% do log('target name: ' ~ target_name, True) %}
    
        {%- if custom_schema_name is not none -%}

                {{ custom_schema_name.lower() | trim }}

        {%- endif -%}

    {%- else -%}

        {%- if custom_schema_name is not none -%}

            {{ default_schema }}_{{ custom_schema_name.lower() | trim }}
        
        {%- else -%}

            {{ default_schema }}

        {% endif %}

    {%- endif -%}

{%- endmacro %}
