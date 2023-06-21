{% set model = ref('raw_json') %}

select *, {{ unpack_json(model, 'json') }}
from {{ model }}