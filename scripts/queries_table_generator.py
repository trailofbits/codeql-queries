#!/usr/bin/env python

"""Generate markdown tables for all queries.

Queries are listed from all Qlpacks' "full" suites, grouped by the custom
"group" metadata, and ordered by name (experimental queries at the end).
"""

import json
import subprocess
import sys
from dataclasses import dataclass
from functools import total_ordering
from pathlib import Path
from typing import Optional

import yaml


@dataclass(frozen=True)
class QueryMetadata:
    """Metadata extracted from a single .ql query file."""

    name: str
    id: str
    description: str
    kind: str
    tags: str
    group: str
    problem_severity: Optional[str]
    precision: Optional[str]
    security_severity: Optional[str]


@total_ordering
class QlQuery:
    def __init__(self, path, doc_lang_dir: str, metadata: QueryMetadata):
        self.doc_lang_dir = doc_lang_dir

        qlpack_base = Path(path).parent
        while "qlpack.yml" not in [x.name for x in qlpack_base.glob("*")]:
            qlpack_base = qlpack_base.parent
            if qlpack_base.parent == qlpack_base:
                raise ValueError(f"Unable to find qlpack in path: {path}")
        self.path = Path(path)
        self.rel_path = Path(path).relative_to(qlpack_base)

        self.name: str = metadata.name
        self.id: str = metadata.id
        self.description: str = metadata.description
        self.kind: str = metadata.kind
        self.tags: list[str] = sorted(metadata.tags.split(' '))
        self.group: str = metadata.group

        self.problem_severity: Optional[str] = metadata.problem_severity
        self.precision: Optional[str] = metadata.precision
        self.security_severity: Optional[float] = (
            float(metadata.security_severity)
            if metadata.security_severity is not None
            else None
        )

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
        qhelp_markdown_path = (
            Path('..') / self.doc_lang_dir / 'src' / 'docs' / self.rel_path
        ).with_suffix('.md')
        cells = [
            f'[{self.name}]({qhelp_markdown_path})',
            f"{self.description}",
            f"{self.problem_severity}",
            f"{self.precision}",
        ]

        cells = [c.replace("|", "\\|") for c in cells]
        return "|" + "|".join(cells) + "|"

    @staticmethod
    def parse_from_file(path: Path, doc_lang_dir: str) -> "QlQuery":
        raw_metadata = subprocess.check_output(
            ['codeql', 'resolve', 'metadata', str(path)]
        ).decode("utf-8")

        parsed = json.loads(raw_metadata)
        if "group" not in parsed:
            sys.stderr.write(
                f'WARN: {path} has no "group" metadata, defaulting to "security".\n'
            )
        metadata = QueryMetadata(
            name=parsed["name"],
            id=parsed["id"],
            description=parsed["description"],
            kind=parsed["kind"],
            tags=parsed["tags"],
            group=parsed.get("group", "security"),
            problem_severity=parsed.get("problem.severity"),
            precision=parsed.get("precision"),
            security_severity=parsed.get("security-severity"),
        )

        return QlQuery(path, doc_lang_dir, metadata)


class Qls:
    def __init__(self, path: Path, queries: list[QlQuery], doc_lang_dir: str):
        self.path: Path = path
        self.doc_lang_dir = doc_lang_dir

        self.queries: dict[str, list[QlQuery]] = {}
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

            tables += table + "\n"

        return tables

    @staticmethod
    def get_qls_from_path(qls_path: Path, doc_lang_dir: str) -> "Qls":
        queries_paths = subprocess.check_output([
            'codeql',
            'resolve',
            'queries',
            '--search-path=.',
            str(qls_path),
        ]).decode("utf-8").split("\n")

        queries = []
        for path in queries_paths:
            if not path:
                continue
            new = QlQuery.parse_from_file(Path(path), doc_lang_dir)
            queries.append(new)

        sys.stderr.write(f"INFO: Parsed {len(queries)} from {qls_path}.\n")
        return Qls(qls_path, queries, doc_lang_dir)


def display_name(extractor: str) -> str:
    """Return the human-readable language heading for an extractor name."""
    if extractor == 'cpp':
        return 'C and C++'
    if extractor == 'java-kotlin':
        return 'Java and Kotlin'
    return extractor.capitalize()


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

    sys.stdout.write(
        "<!-- Generated by `make generate-table`. Do not edit manually. -->\n\n"
    )

    # for every pack finds the "full" suite
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
            sys.exit(
                f'Error: Found more than 1 "full" suite for qlpack {qlpack_name}'
            )
        if len(suites) == 0:
            sys.exit(f'Error: No "full" suite for qlpack {qlpack_name}')

        extractor = qlpack.get("extractor")
        if extractor is None:
            sys.exit(f'Error: qlpack {qlpack_name} has no "extractor" field')

        # The on-disk directory holding the docs (e.g., "java") may differ from
        # the extractor name (e.g., "java-kotlin"). Derive the doc dir from the
        # pack's filesystem location, which is <lang>/src.
        doc_lang_dir = qlpack_path.parent.name
        suite = Qls.get_qls_from_path(suites[0], doc_lang_dir)

        sys.stdout.write(f'### {display_name(extractor)}\n\n')
        sys.stdout.write(suite.md_tables())


if __name__ == "__main__":
    main()
