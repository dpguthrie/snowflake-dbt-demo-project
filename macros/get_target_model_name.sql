{% macro get_target_model_name(model_name) %}

  {% if test_run() %}
    {{ return( var(model_name, 'invalid_test_model_reference') ) }}

  {% else %}
    {{ return(model_name) }}

  {% endif %}

{% endmacro %}