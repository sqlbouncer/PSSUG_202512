USE AdventureWorks
GO

DECLARE @queryProductEmbedding VECTOR(3);
SELECT @queryProductEmbedding = Embedding FROM Products WHERE ProductId = 103; -- Get embedding of 'Green Hat'

Select @queryProductEmbedding
select * from Products

SELECT
    ProductId,
    ProductName,
    VECTOR_DISTANCE('cosine',  Embedding, @queryProductEmbedding) AS CosineSimilarity
FROM Products
ORDER BY CosineSimilarity  -- Order by similarity (smaller cosine distance indicates higher similarity)