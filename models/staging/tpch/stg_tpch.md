# the intent of this .md is to remove redundancy in the documentation

# used in the tpch source docs page

{% docs tpch_source %}
Welcome to the dbt Labs demo dbt project! We use the [TPCH dataset](https://docs.snowflake.com/en/user-guide/sample-data-tpch.html) to create a sample project to emulate what a production project might look like!

![ERD](https://raw.githubusercontent.com/dpguthrie/snowflake-dbt-demo-project/main/assets/tpch_erd.png)
{% enddocs %}


# the below are descriptions from stg_tpch_line_items

{% docs order_item_key %} surrogate key for the model -- combo of order_key + line_number {% enddocs %}

{% docs line_number %} sequence of the order items within the order {% enddocs %}

{% docs return_flag %} letter determining the status of the return {% enddocs %}

{% docs ship_date %} the date the order item is being shipped {% enddocs %}

{% docs commit_date %} the date the order item is being commited {% enddocs %}

{% docs receipt_date %} the receipt date of the order item {% enddocs %}

{% docs ship_mode %} method of shipping {% enddocs %}

{% docs comment %} additional commentary {% enddocs %}

{% docs extended_price %} line item price {% enddocs %}

{% docs discount_percentage %} percentage of the discount {% enddocs %}


# the below are descriptions from stg_tpch_supppliers

{% docs supplier_name %} id of the supplier {% enddocs %}

{% docs supplier_address %} address of the supplier {% enddocs %}

{% docs phone_number %} phone number of the supplier {% enddocs %}

{% docs account_balance %} raw account balance {% enddocs %}

# the below are descriptions from stg_tpch_parts

{% docs retail_price %} raw retail price {% enddocs %}

# the below are descriptions from stg_tpch_part_suppliers

{% docs available_quantity %} raw available quantity {% enddocs %}

{% docs cost %} raw cost {% enddocs %}
