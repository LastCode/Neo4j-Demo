// performance: Create indexes on frequently queried properties
CREATE INDEX source_name_idx FOR (s:Source) ON s.name
CREATE INDEX field_name_idx FOR (f:Field) ON f.name
