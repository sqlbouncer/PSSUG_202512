USE [WideWorldImporters];
SELECT JSON_PATH_EXISTS(ReturnedDeliveryData,'$.Events.EventTime'),* 
FROM [Sales].[Invoices]
WHERE JSON_PATH_EXISTS(ReturnedDeliveryData,'$.DeliveredWhen') = 0


--"table": {
--  "pagingType": "full_numbers",
--  "pageLength": 25
--{"Events": [{ "Event":"Ready for collection","EventTime":"2013-01-01T12:00:00","ConNote":"EAN-125-1051"},{ "Event":"DeliveryAttempt","EventTime":"2013-01-02T07:05:00","ConNote":"EAN-125-1051","DriverID":15,"Latitude":41.3617214,"Longitude":-81.4695602,"Status":"Delivered"}],
--"DeliveredWhen":"2013-01-02T07:05:00","ReceivedBy":"Aakriti Byrraju"}


--SELECT [UserPreferences],* FROM [Application].[People]
/*
DECLARE @jsonInfo NVARCHAR(MAX)
SET @jsonInfo=N'{"info":{"address":[{"town":"Paris"},{"town":"London"}]}}';
SELECT JSON_PATH_EXISTS(@jsonInfo,'$.info.address'); -- 1
*/
declare @d varchar(max) = '{
    "book":{
            "isbn":"9781593279509",
            "title":"Eloquent JavaScript, Third Edition",
            "author":"Marijn Haverbeke",
            "website":"http://eloquentjavascript.net/"
        },
      "magazines": [ 
                {
                     "title":"SQL Server Pro",
                     "publisher":"Zinio"
},
                {
                     "title":"SQL Server Geeks",
                     "publisher":"DPS"
}
   ],
"websites": [ {
              "title":"SQL Server Central",
  "url":"https://www.sqlservercentral.com"
  },
  {
              "title":"SQL Blog",
  "URL":"https://sqlblog.org/"
  }
]
}'
select @d, JSON_PATH_EXISTS(@d, '$.book')
-- returns 1

select JSON_PATH_EXISTS(@d, '$.websites')
-- returns 1

select JSON_PATH_EXISTS(@d, '$.book.isbn')
-- returns 1

-- both return 0
select JSON_PATH_EXISTS(@d, '$.book.isnb')
select JSON_PATH_EXISTS(@d, '$.book.ISBN')

select JSON_PATH_EXISTS(@d, '$.websites.title')
-- returns 0

select JSON_PATH_EXISTS(@d, '$.websites.title')
-- returns 1

select JSON_PATH_EXISTS(@d, '$.websites[0].url'),
       JSON_PATH_EXISTS(@d, '$.websites[1].url')
-- returns 1 and 0

select JSON_PATH_EXISTS(@d, '$.websites[0].URL'),
       JSON_PATH_EXISTS(@d, '$.websites[1].URL')
-- returns 0 and 1

--ISJSON(jsonText [, json_type_constraint]) - VALUE, ARRAY, OBJECT, SCALAR


--JSON_OBJECT(Key, Value … ) Constructs JSON object text from the expressions
USE AdventureWorks2025
GO
SELECT [BusinessEntityID],
    JSON_OBJECT('Title'      :Title
                ,'FirstName' :FirstName
                ,'MiddleName':MiddleName 
                ,'LastName'  :LastName ABSENT ON NULL
    ) AS EmployeeInfo
FROM [Person].[Person];

SELECT SpecialOfferID,
JSON_OBJECT('Description':Description
           ,'DiscountPct':DiscountPct
           ,'Category'   :Category
           ,'StartDate'  :CAST(StartDate as date)
           ,'EndDate'    :CAST(EndDate   as date)
           ,'MinQty'     :MinQty
           ,'MaxQty'     :MaxQty
           ) AS SpecialOfferDetails
FROM AdventureWorks2025.Sales.SpecialOffer

SELECT s.session_id, JSON_OBJECT('security_id':s.security_id, 'login':s.login_name, 'status':s.status) as info
FROM sys.dm_exec_sessions AS s
WHERE s.is_user_process = 1;

--JSON_ARRAY(Key, Value … ) Constructs JSON array text from the expressions
SELECT JSON_OBJECT('Person' : 
			JSON_ARRAY(Title
					,FirstName
					,MiddleName
					,LastName ABSENT ON NULL),
			'JobTitle':JobTitle, 
			'Phone':JSON_ARRAY(PhoneNumberType
				,PhoneNumber)) as Person
FROM AdventureWorks2025.Sales.vSalesPerson

--ISJSON(jsonText [, json_type_constraint]) - VALUE, ARRAY, OBJECT, SCALAR
/*
Value	Description
ISJSON ( expression [, json_type_constraint] )
OBJECT Checks if the input is a valid JSON object.
ARRAY  Checks if the input is a valid JSON array.
VALUE  Checks if the input is a valid JSON scalar (string, number, boolean, or null).
SCALAR Checks if the input is a valid scalar – number or string.

Return Values:
1 → Valid JSON (or valid JSON of the specified type).
0 → Invalid JSON.
NULL → Expression is NULL.

*/
--JSON_OBJECT(Key, Value … ) Constructs JSON object text from the expressions

--1. Basic Validation 
SELECT ISJSON('{"name":"Copilot","version":2022}') AS Result;  
-- Returns 1 (valid JSON object)
SELECT ISJSON('Not JSON at all') AS Result;  
-- Returns 0 (invalid JSON)

--2. VALUE Constraint
SELECT ISJSON('"Hello World"', VALUE) AS Result;  
-- Returns 1 (valid JSON string value)
SELECT ISJSON('123', VALUE) AS Result;  
-- Returns 1 (valid JSON number value)
SELECT ISJSON('"["SQL","Pyhton","Copilot"]"', VALUE) AS Result;  
-- Returns 0 (object, not a single value)

--3. ARRAY Constraint
SELECT ISJSON('[10,20,30]', ARRAY) AS Result;  
-- Returns 1 (valid JSON array)
SELECT ISJSON('"Hello"', ARRAY) AS Result;  
-- Returns 0 (string, not an array)

--4. OBJECT Constraint
SELECT ISJSON('{"id":1,"name":"Copilot"}', OBJECT) AS Result;  
-- Returns 1 (valid JSON object)
SELECT ISJSON('[1,2,3]', OBJECT) AS Result;  
-- Returns 0 (array, not an object)

--5. SCALAR Constraint
SELECT ISJSON('42', SCALAR) AS Result;  
-- Returns 1 (valid scalar number)
SELECT ISJSON('true', SCALAR) AS Result;  
-- Returns 0 (valid scalar boolean)
SELECT ISJSON('[1,2,3]', SCALAR) AS Result;  
-- Returns 0 (array, not scalar)


/**************************** SQL Server 2025 *************************************/

--JSON_ARRAYAGG

SELECT db_name() as [Database],
        sys.schemas.name as SchemaName,
        sys.objects.name as TableName,
        JSON_ARRAYAGG(sys.columns.name) [Column]
FROM sys.objects 
JOIN sys.schemas on sys.objects.schema_id = sys.schemas.schema_id
JOIN sys.columns ON sys.columns.object_id = sys.objects.object_id
WHERE type = 'u'
GROUP BY sys.schemas.name, sys.objects.name

--JSON_OBJECTAGG

;WITH CTE AS
(
    SELECT TOP 1 sys.objects.name as TableName, 
            COUNT(sys.columns.name) ColumnCount 
    FROM sys.objects 
        JOIN sys.columns ON sys.columns.object_id = sys.objects.object_id
    WHERE type = 'u'
    GROUP BY sys.objects.name 
    ORDER BY ColumnCount desc
)
SELECT CAST((SELECT db_name() as [Database],
        sys.schemas.name as SchemaName,
        sys.objects.name as TableName,
        JSON_OBJECTAGG(sys.columns.name : sys.types.name +
CASE 
    WHEN sys.types.name IN ('varchar','nvarchar','char','nchar') 
        THEN '(' + CASE WHEN sys.columns.max_length = -1 THEN 'MAX' 
        ELSE CAST(sys.columns.max_length AS VARCHAR) END + ')'
    WHEN sys.types.name IN ('decimal','numeric') 
        THEN '(' + CAST(sys.columns.precision AS VARCHAR) + ',' 
                + CAST(sys.columns.scale AS VARCHAR) + ')'
    ELSE ''
END +
CASE WHEN sys.columns.is_nullable = 0 THEN ' NOT NULL' ELSE ' NULL' END) [Column]
FROM sys.objects 
JOIN sys.schemas on sys.objects.schema_id = sys.schemas.schema_id
JOIN sys.columns ON sys.columns.object_id = sys.objects.object_id
JOIN sys.types   ON sys.columns.user_type_id = sys.types.user_type_id
JOIN CTE         ON sys.objects.name = CTE.TableName
GROUP BY sys.schemas.name, sys.objects.name
FOR JSON PATH, ROOT('Objects')) AS JSON);


SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType,
    c.max_length AS MaxLength,
    c.precision AS Precision,
    c.scale AS Scale
FROM sys.tables t
INNER JOIN sys.columns c 
    ON t.object_id = c.object_id
INNER JOIN sys.types ty 
    ON c.user_type_id = ty.user_type_id
WHERE t.name = 'SalesOrderHeader'
ORDER BY c.column_id;


declare @j JSON = '{"Objects":[{"Database":"AdventureWorks2025","SchemaName":"Person","TableName":"ContactType","Column":{"ContactTypeID":"int","Name":"Name","ModifiedDate":"datetime"}}]}'
select @j


-- SQL Server JSON_CONTAINS
Syntax:
JSON_CONTAINS (
    target_expression,
    search_value_expression
    [ , path_expression ]
    [ , search_mode ]
)

--Basic Search
DECLARE @json NVARCHAR(MAX) = '{"name":"John","skills":["SQL","C#"]}';
SELECT JSON_CONTAINS(cast(@json as JSON), 'John', '$.name'); 
-- Returns 1 (JSON_CONTAINS works with JSON data type only)

--Searching an Array
DECLARE @json JSON = '{"skills":["SQL","Python","C#"]}';
SELECT JSON_CONTAINS(@json, 'SQL', '$.skills[*]'); 
-- Returns 1

--Value Not Found
SELECT JSON_CONTAINS(@json, 'Java', '$.skills'); 
-- Returns 0

GO

DECLARE @json JSON = '{"name":"Alice","city":"Seattle","role":"Developer"}';
-- Check if "Seattle" exists in any property
SELECT JSON_CONTAINS(@json, 'Seattle', '$.*');
-- Returns 1
--Explanation: The $. * wildcard searches all properties at the root level of the JSON object.
GO

--2. Search Across All Elements in an Array
DECLARE @json JSON = '{"skills":["SQL","Python","C#","Java"]}';

-- Check if "Python" exists in the skills array
SELECT JSON_CONTAINS(@json, 'Python', '$.skills[*]');
-- Returns 1
--Explanation: The [*] wildcard iterates through all elements of the array.

--3. Search Nested Arrays with Wildcards
DECLARE @json NVARCHAR(MAX) = '{
  "employees":[
    {"name":"John","skills":["SQL","C#"]},
    {"name":"Mary","skills":["Python","R"]},
    {"name":"Sam","skills":["Java","Go"]}
  ]
}';

-- Check if "Python" exists in any employee's skills
SELECT JSON_CONTAINS(@json, 'Python', '$.employees[*].skills[*]');
-- Returns 1
--Explanation: The path $.employees[*].skills[*] searches across all employees and all their skills arrays.
GO
--4. Search Any Property at Any Level
-- Check if "Active" exists anywhere in the JSON
DECLARE @myjson AS JSON = '{"a": ["Alice",1,2,3,4], "b":[5,6], "c": [7, 8, [9,10]]}';
SELECT @myjson, value_found = JSON_CONTAINS(@myjson, 'Alice','$.*[*]');
-- Returns 1
--Explanation: JSON_CONTAINS The recursive wildcard $.*[*] searches across all properties at all levels of the JSON document.
GO
--5. Search Multiple Values with Wildcards
DECLARE @json JSON = '{"tags":["sql","json","azure","cloud"]}';

-- Check if either "azure" or "aws" exists in tags
SELECT JSON_CONTAINS(@json, 'azure', '$.tags[*]'), 
       JSON_CONTAINS(@json, 'aws', '$.tags[*]');
-- First returns 1, second returns 0
--Native JSON Indexes






SELECT ProductID,
       JSON_ARRAY(Name, ProductNumber) AS ProductData
FROM [Production].[Product];

SELECT ProductID,
       JSON_ARRAYAGG(Name) AS ProductData
FROM [Production].[Product];


SELECT db_name() as [Database],
        sys.schemas.name as SchemaName,
        sys.objects.name as TableName,
        JSON_ARRAYAGG(sys.columns.name) [Column]
FROM sys.objects 
JOIN sys.schemas on sys.objects.schema_id = sys.schemas.schema_id
JOIN sys.columns ON sys.columns.object_id = sys.objects.object_id
--JOIN sys.types   ON sys.columns.system_type_id = sys.types.system_type_id
WHERE type = 'u'
GROUP BY sys.schemas.name, sys.objects.name
GO
/***********************************************************************************************************/
use [AdventureWorks2025]
GO

declare @j JSON = '{"Objects":[{"Database":"AdventureWorks2025","SchemaName":"Person","TableName":"ContactType","Column":{"ContactTypeID":"int","Name":"Name","ModifiedDate":"datetime"}}]}'
select @j

SELECT db_name() as [Database],
        sys.schemas.name as SchemaName,
        sys.objects.name as TableName,
        JSON_OBJECTAGG(sys.columns.name : sys.types.name +
CASE 
    WHEN sys.types.name IN ('varchar','nvarchar','char','nchar') 
        THEN '(' + CASE WHEN sys.columns.max_length = -1 THEN 'MAX' ELSE CAST(sys.columns.max_length AS VARCHAR) END + ')'
    WHEN sys.types.name IN ('decimal','numeric') 
        THEN '(' + CAST(sys.columns.precision AS VARCHAR) + ',' + CAST(sys.columns.scale AS VARCHAR) + ')'
    ELSE ''
END +
CASE WHEN sys.columns.is_nullable = 0 THEN ' NOT NULL' ELSE ' NULL' END) [Column]
FROM sys.objects 
JOIN sys.schemas on sys.objects.schema_id = sys.schemas.schema_id
JOIN sys.columns ON sys.columns.object_id = sys.objects.object_id
JOIN sys.types   ON sys.columns.user_type_id = sys.types.user_type_id
WHERE type = 'u' and sys.objects.name = 'ContactType'
GROUP BY sys.schemas.name, sys.objects.name
FOR JSON PATH, ROOT('Objects');

/***********************************************************************************************************/


select 'test' || ' concat'

/***********************************************************************************************************/

-- Truncate to the start of the month
DECLARE @d datetime2 = '2025-12-08 11:30:15.1234567';
SELECT datepart  = 'Year', DATETRUNC(year, @d);
SELECT datepart  = 'Quarter', DATETRUNC(quarter, @d);
SELECT datepart  = 'Month', DATETRUNC(month, @d);
SELECT datepart  = 'Week', DATETRUNC(week, @d); -- Using the default DATEFIRST setting value of 7 (U.S. English)
SELECT datepart  = 'Iso_week', DATETRUNC(iso_week, @d);
SELECT datepart  = 'DayOfYear', DATETRUNC(dayofyear, @d);
SELECT datepart  = 'Day', DATETRUNC(day, @d);
SELECT datepart  = 'Hour', DATETRUNC(hour, @d);
SELECT datepart  = 'Minute', DATETRUNC(minute, @d);
SELECT datepart  = 'Second', DATETRUNC(second, @d);
SELECT datepart  = 'Millisecond', DATETRUNC(millisecond, @d);
SELECT datepart  = 'Microsecond', DATETRUNC(microsecond, @d);