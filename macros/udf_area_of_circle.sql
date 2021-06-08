{% macro create_area_of_circle() %}

use database {{target.database}};

drop function if exists {{target.schema}}.area_of_circle(float);

create function {{target.schema}}.area_of_circle(radius float)
  returns float
  as
  $$
    pi() * radius * radius
  $$
  ;

{% endmacro %}