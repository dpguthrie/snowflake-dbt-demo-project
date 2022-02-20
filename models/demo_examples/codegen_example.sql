/*

The codegen package can be run via the IDE or in the command line.

You can use the "Compile" button below or simply copy and paste the
dbt command below into the dbt command bar


dbt run-operation generate_source --args '{"schema_name": "tpch_sf001", "database_name": "raw", "generate_columns": "true", "include_descriptions": "true"}'

*/

-- codegen.generate_source:  generates lightweight YAML for a Source
{{
    codegen.generate_source(
        schema_name='tpch_sf001',
        database_name='raw',
        generate_columns='true',
        include_descriptions='true',
    )
}}

-- codegen.generate_base_model:  generates SQL for a staging model
{{
    codegen.generate_base_model(
        source_name='tpch',
        table_name='orders',
    )
}}

-- codegen.generate_model_yaml:  generates the YAML for a model

-- Single model
{{ 
    codegen.generate_model_yaml(
        model_name='stg_tpch_orders'
    )
}}

-- Multiple models
{{ 
    generate_models_yaml(
        model_names=[
            'stg_tpch_orders',
            'stg_tpch_parts',
            'stg_tpch_regions',
        ]
    )
}}