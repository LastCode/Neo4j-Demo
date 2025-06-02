// Backward Trace (Consumer → Producer):
MATCH path = (consumer:Source {type: 'CONSUMER'})<-[:OUTPUT_FROM*..5]-(fields:Field)
               -[:MAPS_TO*..10]->(producerFields:Field)
               <-[:CONTAINS]-(producer:Source {type: 'PRODUCER'})
RETURN path



// Forward Trace (Producer → Consumer):
MATCH path = (producer:Source {type: 'PRODUCER'})-[:CONTAINS]->(startField)
               -[:MAPS_TO|INPUT_TO|OUTPUT_FROM*1..10]->(endField)
               <-[:CONTAINS]-(consumer:Source {type: 'CONSUMER'})
RETURN path


