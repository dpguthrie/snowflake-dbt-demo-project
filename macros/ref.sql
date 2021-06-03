{% macro ref(model_name) %}
 
  {% if unit_test_mode() %}
    {% set rel = var(model_name, 'invalid_test_model_reference') %}
  {% else %}
    {% set rel = builtins.ref(model_name) %}
  {% endif %}
  {% do return(rel) %}

{% endmacro %}