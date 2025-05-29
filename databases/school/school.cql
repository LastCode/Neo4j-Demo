// Delete all existing data (optional, for a clean start)
MATCH (n) DETACH DELETE n;

// Create Schools
CREATE (s1:School {name: "Greenwood High"});
CREATE (s2:School {name: "Lakeside Academy"});

// Create Teachers
CREATE (t1:Teacher {name: "Alice Smith"});
CREATE (t2:Teacher {name: "Bob Johnson"});

// Create Students
CREATE (st1:Student {name: "Emily"});
CREATE (st2:Student {name: "David"});
CREATE (st3:Student {name: "Sophia"});

// Create Courses
CREATE (c1:Course {title: "Mathematics"});
CREATE (c2:Course {title: "History"});

// Create Relationships

// Schools employ teachers
MATCH (s:School {name: "Greenwood High"}), (t:Teacher {name: "Alice Smith"})
CREATE (s)-[:EMPLOYS]->(t);

MATCH (s:School {name: "Lakeside Academy"}), (t:Teacher {name: "Bob Johnson"})
CREATE (s)-[:EMPLOYS]->(t);

// Schools have courses
MATCH (s:School {name: "Greenwood High"}), (c:Course {title: "Mathematics"})
CREATE (s)-[:HAS_COURSE]->(c);

MATCH (s:School {name: "Lakeside Academy"}), (c:Course {title: "History"})
CREATE (s)-[:HAS_COURSE]->(c);

// Teachers teach courses
MATCH (t:Teacher {name: "Alice Smith"}), (c:Course {title: "Mathematics"})
CREATE (t)-[:TEACHES]->(c);

MATCH (t:Teacher {name: "Bob Johnson"}), (c:Course {title: "History"})
CREATE (t)-[:TEACHES]->(c);

// Students attend schools
MATCH (st:Student {name: "Emily"}), (s:School {name: "Greenwood High"})
CREATE (st)-[:ATTENDS]->(s);

MATCH (st:Student {name: "David"}), (s:School {name: "Greenwood High"})
CREATE (st)-[:ATTENDS]->(s);

MATCH (st:Student {name: "Sophia"}), (s:School {name: "Lakeside Academy"})
CREATE (st)-[:ATTENDS]->(s);

// Students enroll in courses
MATCH (st:Student {name: "Emily"}), (c:Course {title: "Mathematics"})
CREATE (st)-[:ENROLLED_IN]->(c);

MATCH (st:Student {name: "David"}), (c:Course {title: "Mathematics"})
CREATE (st)-[:ENROLLED_IN]->(c);

MATCH (st:Student {name: "Sophia"}), (c:Course {title: "History"})
CREATE (st)-[:ENROLLED_IN]->(c);
