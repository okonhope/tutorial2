USE ROLE accountadmin;
USE WAREHOUSE compute_wh;

CREATE OR REPLACE DATABASE cloud_data_db
   COMMENT = 'Database for loading cloud data';

 CREATE OR REPLACE SCHEMA cloud_data_db.s3_data
    COMMENT = 'Schema for tables loaded from S3';

CREATE OR REPLACE TABLE cloud_data_db.s3_data.calendar
(
full_date DATE,
day_name VARCHAR(10),
month_name VARChar(10),
day_number VARCHAR(2),
full_year VARCHAR(4),
holiday BOOLEAN
)
COMMENT = 'Table to be loaded from S3 calender data file';

SELECT * FROM cloud_data_db.s3_data.calendar;

SHOW TABLES;

CREATE OR REPLACE STORAGE INTEGRATION s3_data_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::631373164455:role/tutorial_role'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://snow-tutorial-bucket/s3data/');

  DESCRIBE INTEGRATION s3_data_integration;

  SHOW INTEGRATIONS;

  CREATE OR REPLACE STAGE cloud_data_db.s3_data.s3data_stage
    STORAGE_INTEGRATION = s3_data_integration
    URL = 's3://snow-tutorial-bucket/s3data/'
    FILE_FORMAT = (TYPE = CSV);

    SHOW STAGES;

    COPY INTO cloud_data_db.s3_data.calendar
      FROM @cloud_data_db.s3_data.s3data_stage
        FILES = ('calendar.txt');