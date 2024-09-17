clean:

ITEMS=components eips beans languages

fetch-documentation:
	huggingface-cli download --repo-type dataset --include="*.md" --local-dir camel-documentation megacamelus/camel-documentation

$(ITEMS):
	@rm -f camel-$@/* || true
	@huggingface-cli download --repo-type dataset --include="*.json" --local-dir camel-$@ megacamelus/camel-$@

fetch-all: $(ITEMS)

.PHONY: fetch $(ITEMS)