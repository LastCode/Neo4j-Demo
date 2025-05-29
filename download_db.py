from libs.database.neo4j.neo4j_data_downloader import Neo4jDataDownloader



# 使用範例
if __name__ == "__main__":
    downloader = Neo4jDataDownloader()
    data = downloader.get_all_data()
    downloader.save_csv(data)
    downloader.save_json(data)
    downloader.close()