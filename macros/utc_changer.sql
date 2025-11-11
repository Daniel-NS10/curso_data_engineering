{% macro utc_changer(column) %}
{{ return(CONVERT_TIMEZONE('UTC',column)) }}
{% endmacro %}