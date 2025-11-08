USE AdventureWorks
GO

Truncate table Products
INSERT INTO Products (ProductId, ProductName, Embedding)
VALUES
    (101, 'Blue T-Shirt', '[0.1, 0.5, 0.2]'),
    (102, 'Red Dress', '[0.8, 0.3, 0.7]'),
    (103, 'Green Hat', '[0.2, 0.8, 0.1]');