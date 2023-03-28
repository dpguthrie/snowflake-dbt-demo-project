{% set ref_orders = ref('fct_orders') %}

with 

orders as (

    select * from {{ ref_orders }}

),

described as (

    {% set columns = adapter.get_columns_in_relation(ref_orders) %}
    {% set numeric_cols = [] %}
    {% for col in columns %}
        {% if col.dtype in ('NUMBER', 'FLOAT') %}
            {% do numeric_cols.append(col) %}
        {% endif %}
    {% endfor %}
    
    {% set stats = {
        'stddev': 'stddev(...)',
        'min': 'min(...)',
        'mean': 'avg(...)',
        'count': 'count(...)',
        'max': 'max(...)',
    } %}
    
    {% for stat_name, stat_calc in stats.items() %}
    
    select
    '{{ stat_name }}' as metric,
    {% for col in numeric_cols %}
        {{ stat_calc | replace('...', col.name) }} as {{ col.name }}{{ ',' if not loop.last }}
    {% endfor %}
    
    from {{ ref_orders }}
      
    {{ 'union all' if not loop.last }}
    
    {% endfor %}
  
)

select * from described
