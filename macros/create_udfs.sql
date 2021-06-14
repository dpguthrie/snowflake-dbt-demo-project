{% macro create_udfs() %}

{% do run_query(create_area_of_circle()) %}

{% endmacro %}