/* 

This is a really good starting point on how to union together
identically-structured data sources

https://discourse.getdbt.com/t/unioning-identically-structured-data-sources/921

There are a few approaches in that article with a couple of them outlined below.
The main thing to consider is the trade-off between complexity vs. readability.
You can continue to find more "dynamic" solutions, but often times it could
come at the expense of readability.

*/

{% macro union_source_dynamic(schema_pattern, table_pattern) %}

    {% set relations = dbt_utils.get_relations_by_pattern(
        schema_pattern=schema_pattern,
        table_pattern=table_pattern
    ) %}

    {% set sources = [] %}

    {% for relation in relations %}

        {% do sources.append(source(schema_pattern, relation.table)) %}

    {% endfor %}

    {{ dbt_utils.union_relations(relations=sources) }}

{% endmacro %}

{% macro union_source_static(source_name, tables) %}

    {% set sources = [] %}

    {% for table in tables %}

        {% do sources.append(source(source_name, table)) %}

    {% endfor %}

    {{ dbt_utils.union_relations(relations=sources) }}

{% endmacro %}
