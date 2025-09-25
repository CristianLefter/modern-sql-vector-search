-- 02-insert-sample.sql
-- Insert a few demo rows with tiny 3D vectors for illustration

INSERT INTO dbo.Documents (Title, Body, Embedding)
VALUES
('Tips for improving database performance', N'Indexing strategies, query tuning, and statistics updates.',
 VECTOR::Parse('[0.012, 0.452, 0.332]')),
('How to troubleshoot slow queries', N'Identify bottlenecks using execution plans and wait stats.',
 VECTOR::Parse('[0.015, 0.449, 0.330]')),
('Banana bread recipe', N'Ripe bananas, flour, sugar, butter; bake until golden.',
 VECTOR::Parse('[0.820, -0.110, -0.540]'));
GO
