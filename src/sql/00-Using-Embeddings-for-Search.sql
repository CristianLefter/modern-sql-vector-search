-- Step 1: Create the table
CREATE TABLE Documents (
    Id INT PRIMARY KEY,
    Content NVARCHAR(MAX),
    Embedding VECTOR(6)   
);
GO

-- Step 2: Insert sample documents with short embeddings
INSERT INTO Documents (Id, Content, Embedding)
VALUES
(1, 'Tips for improving database performance',
 '[0.0123, 0.4512, 0.3321, 0.0876, 0.2244, 0.1199]'),

(2, 'How to troubleshoot slow queries',
 '[0.0118, 0.4622, 0.3104, 0.0931, 0.2307, 0.1255]'),

(3, 'Beginner guide to SQL joins',
 '[0.8801, 0.1244, 0.0733, 0.4156, 0.2977, 0.2109]');
 GO

-- Step 3: Store the embedding of the search phrase 'optimize SQL queries' in a variable
DECLARE @QueryEmbedding VECTOR(6) = 
 CAST('[0.0130, 0.4409, 0.3288, 0.0895, 0.2291, 0.1233]' AS VECTOR(6));

-- Step 4: Run similarity search using VECTOR_DISTANCE
SELECT TOP 2
    Id,
    Content,
    VECTOR_DISTANCE('cosine', Embedding, @QueryEmbedding) AS Distance
FROM Documents
ORDER BY Distance;
GO