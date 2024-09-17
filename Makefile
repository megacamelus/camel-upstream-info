clean:

ITEMS=components eips beans languages documentation

$(ITEMS):
	@rm -f camel-$@/* || true
	@huggingface-cli download --repo-type dataset --include="*.json" --include="*.md" --local-dir camel-$@ megacamelus/camel-$@

fetch-all: $(ITEMS)

.PHONY: fetch $(ITEMS)