
SELECT ORDINAL_POSITION AS column_position,tables.table_name
FROM information_schema.tables AS tables
JOIN information_schema.columns AS columns
ON columns.table_name = tables.table_name
AND columns.table_schema = tables.table_schema
WHERE columns.column_name = 'Patient_ID' 
ORDER BY tables.table_name;
 