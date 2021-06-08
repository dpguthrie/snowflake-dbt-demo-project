{% macro create_udfs() %}

create schema if not exists {{target.schema}};

{{create_f_future_date()}}

{% endmacro %}