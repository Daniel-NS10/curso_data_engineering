{{
  config(
    materialized='view'
  )
}}

WITH src_sqlserver AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        -- se crea la clave subrogada con el md5 que asigna un hash, siendo un id de promocion real
        md5 (promo_id) AS promo_id,
        -- se cambia el promo id que proviene de la tabla al nombre de cada promo
        promo_id AS promo_name,
        discount,
        status,
        _fivetran_deleted AS deleted_data,
        -- se cambia a UTC la fecha de carga
        CONVERT_TIMEZONE('UTC',_fivetran_synced) AS data_load
        
    FROM src_sqlserver

    UNION
    -- anadir registro no_promo para que se puede garantizar la integridad referencial
    SELECT md5 ('no_promo') AS promo_id, 'no_promo', 0 , 'active', null,   CONVERT_TIMEZONE('UTC',GETDATE()) AS data_load 
    )

SELECT * FROM renamed_casted