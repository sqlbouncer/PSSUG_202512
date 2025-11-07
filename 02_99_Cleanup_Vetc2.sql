USE AdventureWorks
GO

-- Clean Demo 2

DROP INDEX [vec_idx] ON [vectors].[product_vectors]
GO

DROP TABLE IF EXISTS [vectors].[product_vectors];
GO

DROP SCHEMA [vectors]
GO

DROP EXTERNAL MODEL MyOllamaModel
GO

EXEC sp_configure 'external AI runtimes enabled', 0;
RECONFIGURE WITH OVERRIDE;
GO

EXEC sp_configure 'external rest endpoint enabled', 0;
RECONFIGURE WITH OVERRIDE;
GO

ALTER DATABASE SCOPED CONFIGURATION
SET PREVIEW_FEATURES = OFF;
GO
