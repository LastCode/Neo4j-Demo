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

    def get_all_labels(self):
        """取得所有節點標籤"""
        query = "CALL db.labels()"
        return [record['label'] for record in self.fetch_data(query)]

    def get_all_relationship_types(self):
        """取得所有關係類型"""
        query = "CALL db.relationshipTypes()"
        return [record['relationshipType'] for record in self.fetch_data(query)]

    def generate_queries(self):
        """動態生成查詢指令"""
        queries = {}

        # 節點查詢（取得所有屬性）
        for label in self.get_all_labels():
            queries[f"nodes_{label}"] = f"MATCH (n:`{label}`) RETURN properties(n) AS node_properties"

        # 關係查詢（取得起點、終點、關係所有屬性）
        for rel_type in self.get_all_relationship_types():
            queries[f"relationships_{rel_type}"] = (
                f"MATCH (a)-[r:`{rel_type}`]->(b) "
                f"RETURN properties(a) AS from_node, type(r) AS rel_type, properties(r) AS rel_properties, properties(b) AS to_node"
            )

        return queries

    def get_all_data(self):
        """動態查詢所有節點和關係資料"""
        data = {}
        queries = self.generate_queries()
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

# 使用範例
if __name__ == "__main__":
    downloader = Neo4jDataDownloader()
    data = downloader.get_all_data()
    downloader.save_csv(data)
    downloader.save_json(data)
    downloader.close()
