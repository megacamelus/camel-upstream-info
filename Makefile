fetch-docs:
	huggingface-cli download --repo-type dataset --local-dir camel-documentation megacamelus/camel-documentation

fetch-components:
	huggingface-cli download --repo-type dataset --local-dir camel-components megacamelus/camel-components