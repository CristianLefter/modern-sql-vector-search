-- 02-bulk-load-from-csv.sql
/*
This script expects a CSV with headers: title,text,embedding
where "embedding" is a JSON array string (e.g., "[0.01, -0.23, ...]")

1) Adjust @CsvPath to your local path.
2) Run after creating the target table (01-schema-1536.sql or 01-schema.sql).
*/

DECLARE @CsvPath NVARCHAR(4000) = N'C:\data\sample_with_embeddings.csv'; -- TODO: change to your path

IF OBJECT_ID('dbo.Documents_Staging', 'U') IS NOT NULL
  DROP TABLE dbo.Documents_Staging;
GO

CREATE TABLE dbo.Documents_Staging
(
    title      NVARCHAR(4000) NULL,
    [text]     NVARCHAR(MAX)  NULL,
    embedding  NVARCHAR(MAX)  NULL -- JSON array as text
);
GO

-- BULK INSERT (requires file to be accessible by SQL Server service account)
BULK INSERT dbo.Documents_Staging
FROM @CsvPath
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,        -- skip headers
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR   = '\n',
    CODEPAGE = '65001',  -- UTF-8
    TABLOCK
);

-- Insert into final table converting JSON array text into VECTOR via VECTOR::Parse
INSERT INTO dbo.Documents (Title, Body, Embedding)
SELECT
    s.title,
    s.[text],
    CASE 
        WHEN s.embedding IS NOT NULL AND ISJSON(s.embedding) = 1 
        THEN VECTOR::Parse(s.embedding)
        ELSE NULL
    END
FROM dbo.Documents_Staging AS s;

-- Cleanup
DROP TABLE dbo.Documents_Staging;
GO
