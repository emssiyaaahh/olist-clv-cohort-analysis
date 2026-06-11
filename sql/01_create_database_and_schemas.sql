/*
Phase 3 Script 01
Project: Olist D2C E-Commerce Cohort Analysis & CLV Engine
Purpose: Create SQL Server database and project schemas.
*/

USE master;
GO

IF DB_ID('OlistCLVAnalytics') IS NULL
BEGIN
    CREATE DATABASE OlistCLVAnalytics;
END;
GO

ALTER DATABASE OlistCLVAnalytics SET RECOVERY SIMPLE;
GO

USE OlistCLVAnalytics;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'raw')
    EXEC('CREATE SCHEMA raw AUTHORIZATION dbo;');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stg')
    EXEC('CREATE SCHEMA stg AUTHORIZATION dbo;');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'mart')
    EXEC('CREATE SCHEMA mart AUTHORIZATION dbo;');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'audit')
    EXEC('CREATE SCHEMA audit AUTHORIZATION dbo;');
GO

DROP TABLE IF EXISTS audit.ingestion_log;
GO

CREATE TABLE audit.ingestion_log (
    ingestion_log_id INT IDENTITY(1,1) PRIMARY KEY,
    table_schema SYSNAME NOT NULL,
    table_name SYSNAME NOT NULL,
    source_file NVARCHAR(255) NULL,
    expected_row_count INT NULL,
    actual_row_count INT NULL,
    status NVARCHAR(30) NULL,
    notes NVARCHAR(1000) NULL,
    logged_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

PRINT 'Database and schemas created successfully.';
