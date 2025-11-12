{% macro utc_changer(column) %}
CONVERT_TIMEZONE('UTC',column)
{% endmacro %}