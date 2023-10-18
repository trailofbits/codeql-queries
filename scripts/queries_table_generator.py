#!/usr/bin/env python

import sys
import json
import yaml
import subprocess
from typing import List, Optional
from pathlib import Path
from functools import total_ordering


'''
Generate markdown tables for all queries

Queries are listed from all Qlpacks' "full" suites.

Queries are grouped by the custom "group" metadata and
ordered by name (experimental queries at the end)
'''

@total_ordering
class QlQuery:
    def __init__(self, path, lang, name, _id, description, kind, tags, group, problem_severity, precision, security_severity):
        self.lang = lang
        
        qlpack_base = Path(path).parent
        while "qlpack.yml" not in [x.name for x in qlpack_base.glob("*")]:
            qlpack_base = qlpack_base.parent
            if qlpack_base.parent == qlpack_base:
                raise ValueError(f"Unable to find qlpack in path: {path}")
        self.path = Path(path)
        self.rel_path = Path(path).relative_to(qlpack_base)

        self.name: str = name
        self.id: str = _id
        self.description: str = description
        self.kind: str = kind
        self.tags: List[str] = sorted(tags.split(' '))
        self.group: str = group

        self.problem_severity: Optional[str] = problem_severity
        self.precision: Optional[str] = precision
        self.security_severity: Optional[float] = float(security_severity) if security_severity is not None else None

    def __hash__(self):
        return hash(self.id)

    def __eq__(self, other):
        return self.id == other.id

    def __gt__(self, other: "QlQuery"):
        if self.group != other.group:
            return self.group < other.group

        if 'experimental' in self.tags:
            if 'experimental' not in other.tags:
                return False
        if 'experimental' in other.tags:
                return True

        return self.name < other.name

    def md_table_line(self):
        qhelp_markdown_path = (Path(self.lang)/'src'/'docs'/self.rel_path).with_suffix('.md')
        cells = [
            # f"{self.id}",
            f'[{self.name}](./{qhelp_markdown_path} "{", ".join(self.tags)}")',
            f"{self.description}",
            f"{self.problem_severity}",
            f"{self.precision}",
        ]

        cells = [c.replace("|", "\\|") for c in cells]
        return "|" + "|".join(cells) + "|"

    @staticmethod
    def parse_from_file(path: Path, lang: str) -> "QlQuery":
        metadata = subprocess.check_output([
            'codeql',
            'resolve',
            'metadata',
            str(path),
        ], stderr=subprocess.DEVNULL).decode("utf-8")

        metadata = json.loads(metadata)

        return QlQuery(
            path,
            lang,
            metadata["name"],
            metadata["id"],
            metadata["description"],
            metadata["kind"],
            metadata["tags"],
            metadata.get("group", "security"),
            metadata.get("problem.severity"),
            metadata.get("precision"),
            metadata.get("security-severity"),
        )


class Qls:
    def __init__(self, path: Path, queries: List[QlQuery], lang: str):
        self.path: Path = path
        self.lang = lang

        self.queries: dict[str, List[QlQuery]] = {}
        for query in queries:
            self.queries.setdefault(query.group, []).append(query)
        for group, query_list in self.queries.items():
            self.queries[group] = sorted(query_list, reverse=True)

    def md_tables(self) -> str:
        tables = ""
        for group, query_list in self.queries.items():
            tables += f"#### {group.capitalize()}\n\n"

            table = ""
            table += "| Name | Description | Severity | Precision  |\n"
            table += "| ---  | ----------- | :----:   | :--------: |\n"

            for q in query_list:
                table += q.md_table_line() + "\n"

            tables += table + "\n\n"

        return tables

    @staticmethod
    def get_qls_from_path(qls_path: Path, lang: str) -> "Qls":
        queries_paths = subprocess.check_output([
            'codeql',
            'resolve',
            'queries',
            '--search-path=.',
            str(qls_path),
        ], stderr=subprocess.DEVNULL).decode("utf-8").split("\n")

        queries = []
        for path in queries_paths:
            if not path:
                continue
            new = QlQuery.parse_from_file(path, lang)
            queries.append(new)

        print(f"INFO: Parsed {len(queries)} from {qls_path}.", file=sys.stderr)
        return Qls(qls_path, queries, lang)

def main():
    # get ToB qlpacks that are not tests nor libraries
    tob_qlpacks = {}
    qlpack_paths = json.loads(
        subprocess.check_output([
            'codeql',
            'resolve',
            'qlpacks',
            '--search-path=.',
            '--format=json',
        ]).decode("utf-8")
    )
    
    for k, v in qlpack_paths.items():
        if k.startswith('trailofbits/') and not k.endswith('-tests') and not k.endswith('-all'):
            tob_qlpacks[k] = Path(v[0])

    # for every pack finds the "full" suit
    tob_suits = {}
    for qlpack_name, qlpack_path in tob_qlpacks.items():
        with open(qlpack_path / 'qlpack.yml') as f: 
            qlpack = yaml.safe_load(f)

        # skip libraries
        if qlpack.get('library') is True:
            continue
        # skip tests
        if qlpack.get('version') is None:
            continue

        suites_dir = qlpack.get('suites', 'codeql-suites')
        suites = list((qlpack_path / suites_dir).glob('*-full.qls'))
        if len(suites) > 1:
            print(f'Error: Found more than 1 "full" suite for qlpack {qlpack_name}', file=sys.stderr)
        if len(suites)  == 0:
            print(f'Error: No "full" suite for qlpack {qlpack_name}', file=sys.stderr)
            continue

        # generate and print markdown
        lang = qlpack["extractor"]
        suit = Qls.get_qls_from_path(suites[0], lang)
        lang = lang.capitalize()
        if lang == 'Cpp':
            lang = 'C and C++'
        print(f'### {lang}\n')
        print(suit.md_tables())

    print("Copy-paste tables to the README.md file")


if __name__ == "__main__":
    main()
