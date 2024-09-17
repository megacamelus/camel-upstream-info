# Openapi-validator.md

**Since Camel 4.7**

Camel comes with a default client request validator for the Camel Rest
DSL.

The `camel-openapi-validator` uses the third party [Atlassian Swagger
Request
Validator](https://bitbucket.org/atlassian/swagger-request-validator/src/master/)
library instead for client request validator. This library is a more
extensive validator than the default validator from `camel-core`.

This library does not work with running in `camel-jbang`.

# Auto-detection from classpath

To use this implementation all you need to do is to add the
`camel-openapi-validator` dependency to the classpath.
