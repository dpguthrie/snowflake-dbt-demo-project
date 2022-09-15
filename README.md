Welcome to the dbt Labs demo dbt project! We use the [TPCH dataset](https://docs.snowflake.com/en/user-guide/sample-data-tpch.html) to create a sample project to emulate what a production project might look like!

                        _              __                   
       ____ ___  ____ _(_)___     ____/ /__  ____ ___  ____ 
      / __ `__ \/ __ `/ / __ \   / __  / _ \/ __ `__ \/ __ \
     / / / / / / /_/ / / / / /  / /_/ /  __/ / / / / / /_/ /
    /_/ /_/ /_/\__,_/_/_/ /_/   \__,_/\___/_/ /_/ /_/\____/ 

## Special demos

- **dbt-external-tables:** Manage database objects that read data external to the warehouse within dbt. See `models/demo_examples/external_sources.yml`.
- **Lifecycle Notifications:** See examples of dbt Cloud Job Lifecycle Notifications [here](https://gist.github.com/boxysean/3166b3ac55801685b6d275e9a9ddd5ee).
- **Pivot tables:** One example of creating a pivot table using Snowflake syntax, another example using Jinja. See `models/aggregates/agg_yearly_*.sql`.

## Codegen Examples

The codegen package can be run via the IDE, by clicking the "Compile" button, or in the command line.

### Command Line

The example below shows how we can generate yml for a particular source:

```bash
dbt run-operation generate_source --args '{"schema_name": "tpch_sf001", "database_name": "raw", "generate_columns": "true", "include_descriptions": "true"}'
```

### IDE

Paste in the snippets below in your IDE and click "Compile".

### codegen.generate_source

Generates lightweight YAML for a Source
```sql
{{
    codegen.generate_source(
        schema_name='tpch_sf001',
        database_name='raw',
        generate_columns='true',
        include_descriptions='true',
    )
}}
```

### codegen.generate_base_model

Generates SQL for a staging model
```sql
{{
    codegen.generate_base_model(
        source_name='tpch',
        table_name='orders',
    )
}}
```

### codegen.generate_model_yaml

Generates the YAML for a given model
```sql
{{ 
    codegen.generate_model_yaml(
        model_name='stg_tpch_orders'
    )
}}
```

Generates the YAML for multiple models
```sql
{{ 
    generate_models_yaml(
        model_names=[
            'stg_tpch_orders',
            'stg_tpch_parts',
            'stg_tpch_regions',
        ]
    )
}}
```
