{% macro create_area_of_circle() %}
create function area_of_circle(radius float)
  returns float
  as
  $$
    pi() * radius * radius
  $$
  ;
{% endmacro %}