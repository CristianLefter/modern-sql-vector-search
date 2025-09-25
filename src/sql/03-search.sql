-- 03-search.sql
-- Query by semantic similarity using VECTOR_DISTANCE (cosine)

DECLARE @query VECTOR(3) = VECTOR::Parse('[0.013, 0.441, 0.329]'); -- "optimize SQL queries" (toy)

SELECT TOP (5)
    d.DocumentId,
    d.Title,
    VECTOR_DISTANCE(d.Embedding, @query, 'cosine') AS CosineDistance
FROM dbo.Documents AS d
ORDER BY CosineDistance ASC;
GO

-- Try Euclidean as an alternative
DECLARE @query2 VECTOR(3) = VECTOR::Parse('[0.013, 0.441, 0.329]');

SELECT TOP (5)
    d.DocumentId,
    d.Title,
    VECTOR_DISTANCE(d.Embedding, @query2, 'euclidean') AS L2Distance
FROM dbo.Documents AS d
ORDER BY L2Distance ASC;
GO
