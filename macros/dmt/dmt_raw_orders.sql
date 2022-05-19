{% macro dmt_raw_orders() %}

(
    {% set records = [
        [1, 1, 'A', 5, '2021-02-01', 'P0', 'a', 1, 'hello'],
        [2, 2, 'A', 5, '2021-02-01', 'P0', 'a', 1, 'hello']
    ] %}

    {% for record in records %}
        select
            {{ record[0] }} as o_orderkey,
            {{ record[1] }} as o_custkey,
            '{{ record[2] }}' as o_orderstatus,
            {{ record[3] }} as o_totalprice,
            '{{ record[4] }}' as o_orderdate,
            '{{ record[5] }}' as o_orderpriority,
            '{{ record[6] }}' as o_clerk,
            {{ record[7] }} as o_shippriority,
            '{{ record[8] }}' as o_comment
        {% if not loop.last %}
        union all
        {% endif %}
    {% endfor %}
) raw_orders

{% endmacro %}