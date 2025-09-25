-- 01-schema.sql
-- Create schema for vector search demo

IF DB_ID('VectorDemo') IS NULL
BEGIN
  PRINT 'TIP: Create a database first: CREATE DATABASE VectorDemo;';
END
GO

IF OBJECT_ID('dbo.Documents', 'U') IS NOT NULL
  DROP TABLE dbo.Documents;
GO

-- Adjust the VECTOR(<dimension>) size to match your embedding model
-- For the toy demo below, we use small vectors (dimension = 3)
CREATE TABLE dbo.Documents
(
    DocumentId     INT IDENTITY(1,1) PRIMARY KEY,
    Title          NVARCHAR(200) NOT NULL,
    Body           NVARCHAR(MAX) NULL,
    Embedding      VECTOR(3)     NULL, -- Use real dimension (e.g., 1536) for real models
    CreatedAt      DATETIME2      DEFAULT SYSUTCDATETIME()
);
GO

-- Optional: computed JSON exposure for debugging/teaching
ALTER TABLE dbo.Documents
ADD EmbeddingJson AS JSON_QUERY(CONVERT(NVARCHAR(MAX), Embedding));
GO
