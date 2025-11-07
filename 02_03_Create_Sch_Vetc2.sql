USE AdventureWorks
GO

create schema [vectors];
GO
 
DROP TABLE IF EXISTS [vectors].[product_vectors];
 
CREATE TABLE [vectors].[product_vectors]
(
    [ProductID] [int] NOT NULL,
    embeddings VECTOR (768),
    chunk NVARCHAR (3000)
);
 
--REQUIRED FOR VECTOR SEARCH
--CREATE UNIQUE CLUSTERED INDEX CI_product_vectors ON [vectors].[product_vectors]([ProductID]);
ALTER TABLE [vectors].[product_vectors]
ADD CONSTRAINT PK_ProductID PRIMARY KEY ([ProductID]);