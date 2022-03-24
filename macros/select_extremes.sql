/*

Use Case:
- Predictions made at least on a daily cadence for various different objects
- We wanted to see how predictions changed for a particular grain (first -> last)
- This macro allows us to return earliest and latest predictions for multiple objects
  by writing this simple code.

  invoice_predictions.sql
    {{ select_earliest(source('ds_source', 'invoice_predictions_weekly_all'), ['invoice_id', 'as_of_date']) }}

  bill_predictions.sql
    {{ select_latest(source('ds_source', 'invoice_predictions_weekly_all'), ['bill_id', 'as_of_date']) }}

- We had 8 models that referenced these macros.
    - Reduce amount of code writing, copy/pasting
    - If logic does change, we're updating in one place

*/

{% macro _select_extremes(fn, table_name, key_columns, timestamp_column='loaded_at') %}
select a.* from {{ table_name }} as a
inner join (
    select {{ ','.join(key_columns) }}, {{ fn }}({{ timestamp_column }}) as last_update
    from {{ table_name }}
    group by {{ ','.join(key_columns) }}
) as b on (
    {% for key_column in key_columns %}
        a.{{ key_column }} = b.{{ key_column }}
        and
    {% endfor %}
    a.{{ timestamp_column }} = b.last_update
)
{% endmacro %}

{% macro select_latest(table_name, key_columns, timestamp_column='loaded_at') %}
{{ _select_extremes('max', table_name, key_columns, timestamp_column) }}
{% endmacro %}

{% macro select_earliest(table_name, key_columns, timestamp_column='loaded_at') %}
{{ _select_extremes('min', table_name, key_columns, timestamp_column) }}
{% endmacro %}