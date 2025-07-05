{% macro set_column_descriptions(columns) %}
  {% if target.type != 'bigquery' %}
    {{ return('') }}
  {% endif %}

  -- Safely resolve full table path: project.dataset.table
  {% set full_table_ref = this.database + '.' + this.schema + '.' + this.identifier %}
  {% set statements = [] %}

  {% for col_name, col_meta in columns.items() %}
    {% if col_meta.description %}
      {% set statement %}
        ALTER TABLE `{{ full_table_ref }}`
        ALTER COLUMN {{ col_name }}
        SET OPTIONS (description = '{{ col_meta.description | replace("'", "\\'") }}');
      {% endset %}
      {% do statements.append(statement) %}
    {% endif %}
  {% endfor %}

  {% if execute %}
    {% for stmt in statements %}
      {% do run_query(stmt) %}
    {% endfor %}
  {% endif %}

  {{ return('') }}  {# nothing needs to be returned #}
{% endmacro %}
