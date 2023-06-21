{% set reporting_facts = var('reporting_facts') %}

with cte_stage as (
    select
          a.memberid
        , a.metric
        , a.paid_offer
        , m.active
        , m.statusid
        , nvl(bd.brand_name, 'Outside Sample') as brand_name
        , case
            when cd.campaigntype in ('Coreg', 'CPA Incentive', 'CPA Non-Incentive', 'CPC') then 1
            else 0
        end as paid_traffic
        , m.countrycode
        , date_trunc(year, m.registereddate) as reg_year
        , date_trunc(quarter, m.registereddate) as reg_quarter
        , date_trunc(month, m.registereddate) as reg_month
        , a.transdate
        , b.first_date as first_day
        , b.first_week
        , b.first_month
        , b.first_quarter
        , b.first_year
    from bizintel.temp.dw_member_reporting_fact_stage as a {# {{ ref('dw_member_reporting_fact_stage') }} #}
    join bizintel.temp.dw_member_reporting_fact_first as b on
        a.memberid = b.memberid
        and a.metric = b.metric
    join stage.prodege.member_a as m on
        a.memberid = m.meberid
    join stage.dwstage.dw_brand_dim as bd on
        m.regclientid = bd.regclientid
    left join prodege.public.cpacampaigns as c on
        m.memberid = c.memberid
    left join prodege.public.cpacampaigndef as cd on
        c.campaign = cd.campaignid
)
{% for id, metric in reporting_facts['metrics'].items() -%}

    {%- set outer_loop = loop -%}

    {% for label, date_part in reporting_facts['grains'].items() -%}

        {%- set inner_loop = loop -%}

        select
              '{{ label }}' as period
            , '{{ metric["name"] }}' as metric
            , brand_name
            , paid_traffic
            , countrycode
            , reg_year
            , reg_quarter
            , reg_month
            , date_trunc({{ date_part }}, transdate) as trans_period
            , case
                when first_{{ date_part }} = trans_period then 1
                else 0
            end as first_activity
            , count(distinct memberid) as measure
            , count(distinct case
                when active = 1 or statusid = 5 then memberid
                else null
            end) as active_measure
        from cte_stage
        where metric = {{ id }}{% if metric.get('where', none) %} and {{ metric['where'] | join(' and ') }}{% endif %}
        group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
        {% if not outer_loop.last or not inner_loop.last -%}
        union all
        {% endif -%}
    {% endfor -%}

{% endfor -%}