{% macro create_demo_model() %}

{% for i in range(10) %}

  select {{ i }} as number {% if not loop.last %} union all {% endif %}

{% endfor %}

{% endmacro %}