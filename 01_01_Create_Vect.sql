/****** Object:  Table [dbo].[Products]    Script Date: 10/26/2025 4:21:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Products]') AND type in (N'U'))
DROP TABLE [dbo].[Products]
GO


CREATE TABLE Products (
    ProductId INT PRIMARY KEY,
    ProductName NVARCHAR(120),
    Embedding VECTOR(3) -- Example: a 3-dimensional vector
);