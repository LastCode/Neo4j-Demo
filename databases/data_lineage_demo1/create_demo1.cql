// Create enumerated types as node properties
CREATE (:SourceType {name: 'PRODUCER'}),
       (:SourceType {name: 'INBOUND'}),
       (:SourceType {name: 'STAGING'}),
       (:SourceType {name: 'INTERMEDIATE'}),
       (:SourceType {name: 'OUTBOUND'}),
       (:SourceType {name: 'CONSUMER'});

CREATE (:FieldType {name: 'DB_COLUMN'}),
       (:FieldType {name: 'FILE_FIELD'});

// Create sample sources with lineage path
CREATE (producer:Source {
        name: 'CRM_DB',
        type: 'PRODUCER',
        description: 'Customer database'
     }),
     (inbound:Source {
        name: 'INBOUND_FILES',
        type: 'INBOUND',
        format: 'CSV'
     }),
     (staging:Source {
        name: 'DATA_WAREHOUSE',
        type: 'STAGING',
        schema: 'STG_SCHEMA'
     });

// Create transformation nodes
CREATE (etl1:Transformation {
        name: 'CRM_Extract',
        type: 'ETL',
        tool: 'Informatica'
     }),
     (etl2:Transformation {
        name: 'Cleanse_PII',
        type: 'Spark Job',
        version: '2.4.0'
     });

// Create fields with relationships
CREATE (prodField:Field {
        name: 'CUSTOMER_ID',
        type: 'DB_COLUMN',
        datatype: 'NUMBER'
     }),
     (stageField:Field {
        name: 'CLIENT_ID',
        type: 'DB_COLUMN',
        datatype: 'VARCHAR(20)'
     });

// Build lineage relationships
CREATE (producer)-[:CONTAINS]->(prodField),
       (prodField)-[:MAPS_TO {transformation: 'ID Conversion'}]->(stageField),
       (stageField)<-[:PRODUCES]-(etl1),
       (prodField)-[:INPUT_TO]->(etl1),
       (etl1)-[:NEXT_STEP]->(etl2);


// create consumer nodes
CREATE (consumer:Source {
  name: 'ANALYTICS_DB',
  type: 'CONSUMER',
  description: '分析報表資料庫'
});

// 將 STAGING 的欄位連接到 CONSUMER
MATCH (stageField:Field {name: 'CLIENT_ID'}),
      (consumer:Source {type: 'CONSUMER'})
CREATE (consumer)-[:CONTAINS]->(stageField);


//
MATCH (stageField:Field {name: 'CLIENT_ID'}),
      (prodField:Field {name: 'CUSTOMER_ID'})
CREATE (stageField)-[:REVERSE_MAPS_TO]->(prodField);
