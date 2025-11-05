-- Step 0: Enable Preview Feature
ALTER DATABASE SCOPED CONFIGURATION
SET PREVIEW_FEATURES = ON;
GO

EXEC sp_configure 'external AI runtimes enabled', 1;
RECONFIGURE WITH OVERRIDE;

EXEC sp_configure 'external rest endpoint enabled', 1;
RECONFIGURE WITH OVERRIDE;

CREATE EXTERNAL MODEL MyOllamaModel
WITH (
      LOCATION = 'https://localhost:11435/api/embed',
      API_FORMAT = 'Ollama',
      MODEL_TYPE = EMBEDDINGS,
      MODEL = 'nomic-embed-text'
);
GO

select AI_GENERATE_EMBEDDINGS(N'test text' USE MODEL MyOllamaModel);