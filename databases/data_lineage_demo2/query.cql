// 血緣追蹤查詢

// a. 反向追蹤 (Backward Trace)
MATCH path = (start:Field {name:'total_sales'})<-[:INPUT|OUTPUT|MAPS_TO*]-(origin)
RETURN nodes(path) AS DataFlowPath, relationships(path) AS Relationships;


// b. 正向追蹤 (Forward Trace)
MATCH path = (origin:Source {name:'CRM_DB'})-[:CONTAINS]->(f:Field)-[:MAPS_TO|INPUT|OUTPUT*]->(end:Report)
RETURN nodes(path) AS DataFlowPath, relationships(path) AS Relationships;