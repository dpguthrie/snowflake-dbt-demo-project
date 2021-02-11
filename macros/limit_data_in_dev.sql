{% macro limit_data_in_dev(filter_column_name, lookback_days=7) %}

{% if target.name == 'dev' %}


where {{ filter_column_name }} >= dateadd('day', -{{ lookback_days }}, current_timestamp)
{% endif %}


{% endmacro %}