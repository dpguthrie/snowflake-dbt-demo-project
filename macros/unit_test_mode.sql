{% macro unit_test_mode() %}
  
  {% if var is not defined %}
    {{ return(False) }}

  {% elif var('test') == 'true' %}
     {{ return(True) }}

  {% else %}
    {{ return(False) }}

  {% endif %}

{% endmacro %}