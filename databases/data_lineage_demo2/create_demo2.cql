// 建立來源節點
CREATE
  (db1:Source {name:'CRM_DB', type:'Database'}),
  (file1:Source {name:'Sales_File', type:'File'}),
  (ext1:Source {name:'External_API', type:'External'}),
  (rpt1:Report {name:'Monthly_Report', system:'BI_System'});

// 建立欄位節點
CREATE
  (f1:Field {name:'customer_id', dtype:'STRING'}),
  (f2:Field {name:'sales_amount', dtype:'DECIMAL'}),
  (f3:Field {name:'api_response', dtype:'JSON'}),
  (f4:Field {name:'report_id', dtype:'UUID'}),
  (f5:Field {name:'total_sales', dtype:'DECIMAL'});

// 建立轉換流程節點
CREATE
  (etl1:Transformation {name:'ETL_Process', type:'Cleaning'}),
  (calc1:Transformation {name:'Sales_Calc', type:'Aggregation'});

// 建立來源包含關係
MATCH (s:Source), (f:Field)
WHERE s.name IN ['CRM_DB','Sales_File','External_API']
  AND f.name IN ['customer_id','sales_amount','api_response']
CREATE (s)-[:CONTAINS]->(f);

// 建立欄位映射關係
MATCH (f1:Field {name:'customer_id'}), (f4:Field {name:'report_id'})
CREATE (f1)-[:MAPS_TO {mapping_rule:'UUID conversion'}]->(f4);

// 建立轉換流程關係
MATCH
  (in1:Field {name:'sales_amount'}),
  (out1:Field {name:'total_sales'}),
  (t:Transformation {name:'Sales_Calc'})
CREATE
  (in1)-[:INPUT {stage:'Raw'}]->(t),
  (t)-[:OUTPUT {stage:'Aggregated'}]->(out1);

// 建立報表生成關係
MATCH (r:Report {name:'Monthly_Report'}), (f:Field)
WHERE f.name IN ['report_id','total_sales']
CREATE (f)-[:GENERATES]->(r);
