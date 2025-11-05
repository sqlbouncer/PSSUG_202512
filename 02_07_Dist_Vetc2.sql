DECLARE @querytext NVARCHAR (3000) ='I want products blue bikes' 
DECLARE @search_vector vector(768) =  AI_GENERATE_EMBEDDINGS(@querytext USE MODEL MyOllamaModel);

SELECT top (10) VECTOR_DISTANCE('cosine', @search_vector, [embeddings]) AS distance,
    v.Name + ' ' + ISNULL(p.Color, 'No Color') + ' ' + pc.Name + ' ' + v.ProductModel + ' '
       + ISNULL('Category: '+ pc.name+ '-' +ps.name,'')+' '
       + ISNULL(v.Description, '') + ' ' + 'price:' + CAST(p.ListPrice AS VARCHAR(20)) + ' '
       + ISNULL('size:' + p.Size + ' ' + p.SizeUnitMeasureCode + ' ', '')
       + ISNULL('weight:' + CAST(p.Weight AS VARCHAR(10)) + ' ' + p.WeightUnitMeasureCode, '') AS FullProductDescription 
FROM Production.vProductAndDescription v
    INNER JOIN Production.Product p
        ON v.ProductID = p.ProductID
    INNER JOIN Production.ProductSubcategory ps
        ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    INNER JOIN Production.ProductCategory pc
        ON ps.ProductCategoryID = pc.ProductCategoryID
    INNER JOIN [vectors].[product_vectors] vc on v.ProductID = vc.[ProductID]
WHERE v.CultureID = 'en' 
ORDER BY distance


