import argparse
import re
import graphlib
import graphviz
from dataclasses import dataclass
import pathlib
import os
from collections import ChainMap
import concurrent

from google.cloud import bigquery


@dataclass
class SQL:
    file_path: str
    project: str
    dataset: str
    table: str

    def __init__(self, file_path: str) -> None:
        path, file_name = os.path.split(file_path)
        self.project = project
        self.dataset = path.split('/')[-1]
        self.table = file_name.split('.')[0]

        self.file_path = file_path


    TABLE_REGEX = r'(?i)\b(?:FROM|JOIN)\s+`([a-zA-Z0-9_\-]+\.[a-zA-Z0-9_\-]+\.[a-zA-Z_][a-zA-Z0-9_]*)`'

    def get_dependencies(self) -> dict[str, list[str]]:
        query = self.read()
        return {
            f'{self.project}.{self.dataset}.{self.table}':
                sorted(list(set([table_name for table_name in re.findall(
                    self.TABLE_REGEX, query, re.IGNORECASE | re.MULTILINE)])))
        }

    def read(self) -> str:
        with open(self.file_path, 'r') as file:
            return file.read()


def sort_topologically(graph:  dict[str, list[str]]) -> list[list[str]]:
    sorted_nodes_list: list[list[str]] = []

    sorter = graphlib.TopologicalSorter(graph)

    sorter.prepare()
    while sorter.is_active():
        ready_nodes = sorter.get_ready()
        sorter.done(*ready_nodes)
        sorted_nodes_list.append(list(ready_nodes))

    return sorted_nodes_list


def execute_jobs(job_sequences: list[list[str]]) -> None:
    client = bigquery.Client(project=project)

    def run_query(table_name: str) -> None:
        _, dataset, table = table_name.split('.')

        sql = SQL(f'{sql_directory}/{dataset}/{table}.sql')
        query = sql.read()

        job_config = bigquery.QueryJobConfig(
            destination=f'{project}.{dataset}.{table}',
            write_disposition='WRITE_TRUNCATE'
        )
        job = client.query(query, job_config=job_config)
        job.result()

    for sequence in job_sequences:
        with concurrent.futures.ThreadPoolExecutor() as executor:
            futures = {
                executor.submit(run_query, table_name):
                table_name for table_name in sequence
            }

        for future in concurrent.futures.as_completed(futures):
            try:
                future.result()
            except Exception as e:
                print(f'Error executing job: {e}')


def render_digraph(graph: dict[str, list[str]]) -> None:
    client = graphviz.Digraph(
        'sql_graph',
        engine='dot',
        graph_attr={'rankdir': 'TB'},
        node_attr={
            'shape': 'box',
            'fontsize': '18',
            'ordering': 'out'
        }
    )

    [[client.node(node) for node in depencencies]
     for depencencies in graph.values()]
    [[client.edge(parent, child) for child in children]
     for parent, children in graph.items()]

    client.render(directory='output')


def main() -> None:
    # SQLファイルの取得
    directory_path = pathlib.Path(sql_directory)
    sqls = [SQL(path) for path in directory_path.rglob('**/*.sql')]

    # 依存関係のグラフへの変換
    dependencies = [sql.get_dependencies() for sql in sqls]
    sql_graph = dict(ChainMap(*dependencies))

    # ジョブのスケジューリングと実行
    job_sequences = sort_topologically(sql_graph)
    execute_jobs(job_sequences[1:])

    # グラフの描画
    render_digraph(sql_graph)


def command() -> None:
    parser = argparse.ArgumentParser(
        prog='BigQuery Job Scheduler',
        description='Execute jobs and generate depencency graph.')
    parser.add_argument('project', type=str, help='Google Cloud project')
    parser.add_argument('--sql-directory', type=str, required=False, default='sqls', help='sql directory')
    args = parser.parse_args()

    global project
    project = args.project

    global sql_directory
    sql_directory = args.sql_directory

    main()


command()
