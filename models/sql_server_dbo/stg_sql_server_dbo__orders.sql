{{
  config(
    materialized='incremental'
  )
}}

WITH src_sqlserver AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        -- se crea un id para cada shipping service que hace referencia al de la nueva tabla shippin_service
        md5(shipping_service) AS shipping_service_id,
        shipping_cost,
        address_id,
        {{utc_changer( created_at ) }} AS created_at_UTC,
        



        
        
        status,
        _fivetran_deleted AS deleted_data,
        -- se cambia a UTC la fecha de carga
        CONVERT_TIMEZONE('UTC',_fivetran_synced) AS data_load
        
    FROM src_sqlserver
    
    )

SELECT * FROM renamed_casted