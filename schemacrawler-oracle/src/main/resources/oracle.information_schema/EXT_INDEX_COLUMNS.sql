SELECT /*+ PARALLEL(AUTO) */
  NULL AS INDEX_CATALOG,
  INDEXES.OWNER AS INDEX_SCHEMA,
  INDEXES.INDEX_NAME AS INDEX_NAME,
  INDEXES.TABLE_NAME AS TABLE_NAME,
  INDEX_COLUMNS.COLUMN_NAME,
  INDEX_COLUMNS.COLUMN_POSITION AS ORDINAL_POSITION,
  'YES' AS IS_GENERATEDCOLUMN,
  INDEX_COLUMN_EXPRESSIONS.COLUMN_EXPRESSION AS INDEX_COLUMN_DEFINITION
FROM 
  ${catalogscope}_INDEXES INDEXES
  INNER JOIN ${catalogscope}_IND_COLUMNS INDEX_COLUMNS
  ON 
    INDEXES.INDEX_NAME = INDEX_COLUMNS.INDEX_NAME
    AND INDEXES.TABLE_OWNER = INDEX_COLUMNS.TABLE_OWNER
    AND INDEXES.TABLE_NAME = INDEX_COLUMNS.TABLE_NAME
    AND INDEXES.OWNER = INDEX_COLUMNS.INDEX_OWNER
  INNER JOIN ${catalogscope}_IND_EXPRESSIONS INDEX_COLUMN_EXPRESSIONS
  ON 
    INDEXES.INDEX_NAME = INDEX_COLUMN_EXPRESSIONS.INDEX_NAME
    AND INDEXES.TABLE_OWNER = INDEX_COLUMN_EXPRESSIONS.TABLE_OWNER
    AND INDEXES.TABLE_NAME = INDEX_COLUMN_EXPRESSIONS.TABLE_NAME
    AND INDEXES.OWNER = INDEX_COLUMN_EXPRESSIONS.INDEX_OWNER
    AND INDEX_COLUMNS.COLUMN_POSITION = INDEX_COLUMN_EXPRESSIONS.COLUMN_POSITION    
WHERE
  INDEXES.OWNER NOT IN 
    ('ANONYMOUS', 'APEX_PUBLIC_USER', 'APPQOSSYS', 'BI', 'CTXSYS', 'DBSNMP', 'DIP', 
    'EXFSYS', 'FLOWS_30000', 'FLOWS_FILES', 'GSMADMIN_INTERNAL', 'IX', 'LBACSYS', 
    'MDDATA', 'MDSYS', 'MGMT_VIEW', 'OE', 'OLAPSYS', 'ORACLE_OCM', 
    'ORDPLUGINS', 'ORDSYS', 'OUTLN', 'OWBSYS', 'PM', 'SCOTT', 'SH', 
    'SI_INFORMTN_SCHEMA', 'SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR', 
    'SYS', 'SYSMAN', 'SYSTEM', 'TSMSYS', 'WKPROXY', 'WKSYS', 'WK_TEST', 
    'WMSYS', 'XDB', 'XS$NULL', 'RDSADMIN')  
  AND NOT REGEXP_LIKE(INDEXES.OWNER, '^APEX_[0-9]{6}$')
  AND NOT REGEXP_LIKE(INDEXES.OWNER, '^FLOWS_[0-9]{5,6}$')
  AND REGEXP_LIKE(INDEXES.OWNER, '${schemas}')
  AND INDEXES.TABLE_NAME NOT LIKE 'BIN$%'
  AND NOT REGEXP_LIKE(INDEXES.TABLE_NAME, '^(SYS_IOT|MDOS|MDRS|MDRT|MDOT|MDXT)_.*$')
ORDER BY 
  INDEX_SCHEMA,
  TABLE_NAME,
  INDEX_NAME,
  ORDINAL_POSITION
