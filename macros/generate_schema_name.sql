{% macro generate_schema_name(custom_schema_name, node) %}

    {% set default_schema = target.schema %}
    
    {# targetが「prod」かつ対象のオブジェクトが「seed」かつcustom_schemaの定義ありの場合、seed向けの「custom_schema」に #}
    {% if target.name == 'prod' and node.resource_type == 'seed' and custom_schema_name is not none %}
        {{ custom_schema_name | trim }}

    {# targetが「prod」でないかつ対象のオブジェクトが「seed」かつcustom_schemaの定義ありの場合、「default_schema」を先頭に付けたseed向けの「custom_schema」に #}
    {% elif target.name != 'prod' and node.resource_type == 'seed' and custom_schema_name is not none %}
        {{ default_schema }}_{{ custom_schema_name | trim }}

    {# targetが「prod」かつcustom_schemaの定義ありの場合、「custom_schema」に #}
    {% elif target.name == 'prod' and custom_schema_name is not none %}
        {{ custom_schema_name | trim }}

    {# custom_schemaの定義なしの場合、「default_schema」に #}
    {% elif custom_schema_name is none %}
        {{ default_schema }}

    {# 上述の条件に合致しない（targetが「prod」でないがcustom_schemaの定義あり、など）の場合、「default_schema」に #}
    {% else %}
        {{ default_schema }}
    {% endif %}

{% endmacro %}