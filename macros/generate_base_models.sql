{% macro generate_base_models(source_name, exclude=[], include=[], leading_commas=False, case_sensitive_cols=False) %}

    {%- if include | length > 0 and exclude | length > 0 -%}
        -- You cannot use both include and exclude arguments
    {%- elif execute -%}

        {% set sources = graph.sources.values() | selectattr('source_name', '==', source_name) %}

        {%- if exclude | length > 0 -%}
            {%- set sources = sources | rejectattr('name', 'in', exclude) -%}
        {%- endif -%}

        {%- if include | length > 0 -%}
            {%- set sources = sources | selectattr('name', 'in', include) -%}
        {%- endif -%}

        {%- for source in sources -%}

            -- ______________________ stg_{{ source_name }}__{{ source.name }}.sql ______________________

            {{ codegen.generate_base_model(source_name, source.name, leading_commas, case_sensitive_cols) }}

        {%- endfor -%}

        -- ______________________ END ______________________

    {%- endif -%}

{% endmacro %}
