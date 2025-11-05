--required vector index for the vector_search to work
CREATE VECTOR INDEX vec_idx ON [vectors].[product_vectors]([embeddings])
WITH (METRIC = 'cosine', TYPE = 'diskann', MAXDOP = 8);
GO