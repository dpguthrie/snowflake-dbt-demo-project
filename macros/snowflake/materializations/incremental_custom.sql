
{% macro dbt_snowflake_validate_get_incremental_strategy(config) %}
  {#-- Find and validate the incremental strategy #}
  {%- set strategy = config.get("incremental_strategy", default="merge") -%}

  {% set invalid_strategy_msg -%}
    Invalid incremental strategy provided: {{ strategy }}
    Expected one of: 'merge', 'delete+insert', 'insert_overwrite'
  {%- endset %}
  {% if strategy not in ['merge', 'delete+insert', 'insert_overwrite'] %}
    {% do exceptions.raise_compiler_error(invalid_strategy_msg) %}
  {% endif %}

  {% do return(strategy) %}
{% endmacro %}

{% macro dbt_snowflake_get_incremental_sql(strategy, tmp_relation, target_relation, unique_key, dest_columns) %}
  {% if strategy == 'merge' %}
    {% do return(get_merge_sql(target_relation, tmp_relation, unique_key, dest_columns)) %}
  {% elif strategy == 'delete+insert' %}
    {% do return(get_delete_insert_merge_sql(target_relation, tmp_relation, unique_key, dest_columns)) %}
  {% elif strategy == 'insert_overwrite' %}
    {% do return(get_insert_overwrite_sql(target_relation, tmp_relation, unique_key, dest_columns)) %}
  {% else %}
    {% do exceptions.raise_compiler_error('invalid strategy: ' ~ strategy) %}
  {% endif %}
{% endmacro %}

{% macro incremental_validate_delete_target_not_in_source(delete_target_not_in_source, strategy, unique_key, default) %}
   
   {% if not delete_target_not_in_source %}
      {{ return(False) }}
   {% elif delete_target_not_in_source and strategy not in ['merge', 'delete+insert'] %}
      {% do exceptions.raise_compiler_error('invalid strategy for delete_target_not_in_source, must be one of: [merge, delete+insert]') %}
   {% elif delete_target_not_in_source and not unique_key %}
      {% do exceptions.raise_compiler_error('invalid configuration, must specify a unique_key to when delete_target_not_in_source is set to True') %}
   {% else %}
      {{ return(True) }}
   {% endif %}

{% endmacro %}

{% macro delete_from_target_not_in_source(tmp_relation, target_relation, unique_key) %}
   
    delete from {{ target_relation }} where {{ unique_key }} not in (select {{ unique_key }} from {{ tmp_relation }} );

{% endmacro %}

{% materialization incremental_custom, adapter='snowflake' -%}

  {% set original_query_tag = set_query_tag() %}

  {%- set unique_key = config.get('unique_key') -%}
  {%- set full_refresh_mode = (should_full_refresh()) -%}

  {% set target_relation = this %}
  {% set existing_relation = load_relation(this) %}
  {% set tmp_relation = make_temp_relation(this) %}

  {#-- Validate early so we don't run SQL if the strategy is invalid --#}
  {% set strategy = dbt_snowflake_validate_get_incremental_strategy(config) -%}
  {% set on_schema_change = incremental_validate_on_schema_change(config.get('on_schema_change'), default='ignore') %}
  {% set delete_target_not_in_source = incremental_validate_delete_target_not_in_source(
       delete_target_not_in_source = config.get('delete_target_not_in_source'), 
       strategy=strategy,
       unique_key=unique_key,
       default=False
    )
  %}

  {{ run_hooks(pre_hooks) }}

  {% if existing_relation is none %}
    {% set build_sql = create_table_as(False, target_relation, sql) %}

  {% elif existing_relation.is_view %}
    {#-- Can't overwrite a view with a table - we must drop --#}
    {{ log("Dropping relation " ~ target_relation ~ " because it is a view and this model is a table.") }}
    {% do adapter.drop_relation(existing_relation) %}
    {% set build_sql = create_table_as(False, target_relation, sql) %}

  {% elif full_refresh_mode %}
    {% set build_sql = create_table_as(False, target_relation, sql) %}

  {% else %}
    {% do run_query(create_table_as(True, tmp_relation, sql)) %}
    {% do adapter.expand_target_column_types(
           from_relation=tmp_relation,
           to_relation=target_relation) %}
    {#-- Process schema changes. Returns dict of changes if successful. Use source columns for upserting/merging --#}
    {% set dest_columns = process_schema_changes(on_schema_change, tmp_relation, existing_relation) %}
    {% if not dest_columns %}
      {% set dest_columns = adapter.get_columns_in_relation(existing_relation) %}
    {% endif %}
    {% set build_sql = dbt_snowflake_get_incremental_sql(strategy, tmp_relation, target_relation, unique_key, dest_columns) %}
    {% set delete_sql = delete_from_target_not_in_source(tmp_relation, target_relation, unique_key) %}
  {% endif %}

  {%- call statement('main') -%}
    {{ build_sql }}
    {% if delete_target_not_in_source %}
      {{ delete_sql }}
    {% endif %}
  {%- endcall -%}

  {{ run_hooks(post_hooks) }}

  {% set target_relation = target_relation.incorporate(type='table') %}
  {% do persist_docs(target_relation, model) %}

  {% do unset_query_tag(original_query_tag) %}

  {{ return({'relations': [target_relation]}) }}

{%- endmaterialization %}
