-- 01-schema-1536.sql
-- Schema for a realistic embedding dimension (1536)
IF OBJECT_ID('dbo.Documents', 'U') IS NOT NULL
  DROP TABLE dbo.Documents;
GO

CREATE TABLE dbo.Documents
(
    DocumentId INT IDENTITY(1,1) PRIMARY KEY,
    Title      NVARCHAR(200) NOT NULL,
    Body       NVARCHAR(MAX) NULL,
    Embedding  VECTOR(1536)  NULL,
    CreatedAt  DATETIME2      DEFAULT SYSUTCDATETIME()
);
GO

ALTER TABLE dbo.Documents
ADD EmbeddingJson AS JSON_QUERY(CONVERT(NVARCHAR(MAX), Embedding));
GO
