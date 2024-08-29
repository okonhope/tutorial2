 USE DATABASE homedb;

USE schema homedb.public;

CREATE OR REPLACE TEMPORARY TABLE cities (
    continent varchar default null,
    country varchar default null,
    city variant default null
);

CREATE OR REPLACE WAREHOUSE mywarehouse with
warehouse_size = 'X-SMALL'
auto_suspend = 120
auto_resume = true
initially_suspended = true;

use warehouse mywarehouse;

CREATE OR REPLACE  FILE FORMAT sP_tut_parquet_format
   TYPE = parquet;



CREATE OR REPLACE TEMPORARY STAGE sp_tut_stage
 FILE_FORMAT = sP_tut_parquet_format;

 PUT file:///workspaces/tutorial2/json  @sf_tut_stage AUTO_COMPRESS =TRUE;

 COPY INTO home_sales(city, state, zip, sale_date, price)
    FROM (SELECT SUBSTR($1:location.state_city,4),
                 SUBSTR($1:location.state_city,1,2),
                 $1:location.zip,
                 to_timestamp_ntz($1:sale_date),
                 $1:price
        FROM @sf_tut_stage/sales.json.gz t)
      ON_ERROR = 'continue';  

      SELECT * FROM home_sales;