DECLARE @querytext NVARCHAR (3000) ='I want products for my hands' 
DECLARE @search_vector vector(768) =  AI_GENERATE_EMBEDDINGS(@querytext USE MODEL MyOllamaModel);
 
SELECT 
    t.ProductID, s.distance, t.chunk
FROM
    VECTOR_SEARCH(
        TABLE = [vectors].[product_vectors] as t, 
        COLUMN = [embeddings], 
        SIMILAR_TO = @search_vector, 
        METRIC = 'cosine', 
        TOP_N = 20
    ) AS s
ORDER BY s.distance