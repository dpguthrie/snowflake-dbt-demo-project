{% macro ref(model_name) %}

    {% set rel = builtins.ref(model_name) %}

    {% set rel_exists = adapter.get_relation(
        database=rel.database,
        schema='analytics',
        identifier=rel.name
    ) is not none %}

    {% if rel_exists %}

        -- Assuming analytics is the production schema
        {% set newrel = rel.replace_path(schema='analytics') %}

    {% else %}

        {% set newrel = rel %}

    {% endif %}

    {% do return(newrel) %}

{% endmacro %}