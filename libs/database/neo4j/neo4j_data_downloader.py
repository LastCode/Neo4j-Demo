import os
import json
import pandas as pd
from neo4j import GraphDatabase
from dotenv import load_dotenv

# 讀取 .env 檔案
load_dotenv()

class Neo4jDataDownloader:
    def __init__(self):
        self.uri = os.getenv("NEO4J_URI")
        self.user = os.getenv("NEO4J_USERNAME")
        self.password = os.getenv("NEO4J_PASSWORD")
        self.database = os.getenv("NEO4J_DATABASE")
        self.driver = GraphDatabase.driver(self.uri, auth=(self.user, self.password))

    def close(self):
        self.driver.close()

    def fetch_data(self, query):
        with self.driver.session(database=self.database) as session:
            result = session.run(query)
            return [record.data() for record in result]

    def get_all_data(self):
        queries = {
            'schools': 'MATCH (s:School) RETURN s.name AS name',
            'teachers': 'MATCH (t:Teacher) RETURN t.name AS name',
            'students': 'MATCH (st:Student) RETURN st.name AS name',
            'courses': 'MATCH (c:Course) RETURN c.title AS title',
            'employs': 'MATCH (s:School)-[r:EMPLOYS]->(t:Teacher) RETURN s.name AS school, t.name AS teacher',
            'has_course': 'MATCH (s:School)-[r:HAS_COURSE]->(c:Course) RETURN s.name AS school, c.title AS course',
            'teaches': 'MATCH (t:Teacher)-[r:TEACHES]->(c:Course) RETURN t.name AS teacher, c.title AS course',
            'attends': 'MATCH (st:Student)-[r:ATTENDS]->(s:School) RETURN st.name AS student, s.name AS school',
            'enrolled_in': 'MATCH (st:Student)-[r:ENROLLED_IN]->(c:Course) RETURN st.name AS student, c.title AS course'
        }
        data = {}
        for key, query in queries.items():
            data[key] = self.fetch_data(query)
        return data

    def save_csv(self, data):
        os.makedirs('output/school/csv', exist_ok=True)
        for key, records in data.items():
            df = pd.DataFrame(records)
            df.to_csv(f'output/school/csv/{key}.csv', index=False)

    def save_json(self, data):
        os.makedirs('output/school/json', exist_ok=True)
        for key, records in data.items():
            with open(f'output/school/json/{key}.json', 'w', encoding='utf-8') as f:
                json.dump(records, f, ensure_ascii=False, indent=4)

# 使用範例（可放在 main.py 或其他執行檔）
if __name__ == "__main__":
    downloader = Neo4jDataDownloader()
    data = downloader.get_all_data()
    downloader.save_csv(data)
    downloader.save_json(data)
    downloader.close()
