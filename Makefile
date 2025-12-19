test:
	find . -iname "test" -type d -maxdepth 2 -mindepth 2 -print0 | \
	  xargs -0 codeql test run --threads=0

format:
	find . \( -iname '*.ql' -o -iname '*.qll' \) -print0 | \
	  xargs -0 codeql query format --in-place

format-check:
	find . \( -iname '*.ql' -o -iname '*.qll' \) -print0 | \
	  xargs -0 codeql query format --check-only

pack-install:
	find . -iname "qlpack.yml" -exec \
	  sh -c 'codeql pack install $$(dirname "$$1")' sh {} \;

pack-upgrade:
	find . -iname "qlpack.yml" -exec \
	  sh -c 'codeql pack upgrade $$(dirname "$$1")' sh {} \;

.PHONY: test format format-check pack-install pack-upgrade
