# Json-validator

**Since Camel 2.20**

**Only producer is supported**

The JSON Schema Validator component performs bean validation of the
message body against JSON Schemas v4, v6, v7, v2019-09 draft and
v2020-12(partial) using the NetworkNT JSON Schema library
([https://github.com/networknt/json-schema-validator](https://github.com/networknt/json-schema-validator)).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-json-validator</artifactId>
        <version>x.y.z</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    json-validator:resourceUri[?options]

Where **resourceUri** is some URL to a local resource on the classpath
or a full URL to a remote resource or resource on the file system which
contains the JSON Schema to validate against.

# Example

Assuming we have the following JSON Schema:

**myschema.json**

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "definitions": {},
      "id": "my-schema",
      "properties": {
        "id": {
          "default": 1,
          "description": "An explanation about the purpose of this instance.",
          "id": "/properties/id",
          "title": "The id schema",
          "type": "integer"
        },
        "name": {
          "default": "A green door",
          "description": "An explanation about the purpose of this instance.",
          "id": "/properties/name",
          "title": "The name schema",
          "type": "string"
        },
        "price": {
          "default": 12.5,
          "description": "An explanation about the purpose of this instance.",
          "id": "/properties/price",
          "title": "The price schema",
          "type": "number"
        }
      },
      "required": [
        "name",
        "id",
        "price"
      ],
      "type": "object"
    }

We can validate incoming JSON with the following Camel route, where
`myschema.json` is loaded from the classpath.

    from("direct:start")
      .to("json-validator:myschema.json")
      .to("mock:end")

If you use the default schema loader, it will try to determine the
schema version from the $schema property and instruct the
[validator](https://github.com/networknt) appropriately. If it can’t
find (or doesn’t recognize) the $schema property, it will assume your
schema is version
[2019-09](https://json-schema.org/specification-links.html#draft-2019-09-formerly-known-as-draft-8).

If your schema is local to your application (e.g. a classpath location
as opposed to URL), your schema can also contain `$ref` links to a
relative subschema in the classpath. Per the JSON schema spec, your
schema must not have an $id identifier property for this to work
properly. See the [unit
test](https://github.com/apache/camel/blob/main/components/camel-json-validator/src/test/java/org/apache/camel/component/jsonvalidator/LocalRefSchemaTest.java)
and
[schema](https://github.com/apache/camel/blob/main/components/camel-json-validator/src/test/resources/org/apache/camel/component/jsonvalidator/Order.json)
for an example.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|objectMapper|To use a custom ObjectMapper||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the resource. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod.||string|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|contentCache|Sets whether to use resource content cache or not|false|boolean|
|failOnNullBody|Whether to fail if no body exists.|true|boolean|
|failOnNullHeader|Whether to fail if no header exists when validating against a header.|true|boolean|
|headerName|To validate against a header instead of the message body.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|disabledDeserializationFeatures|Comma-separated list of Jackson DeserializationFeature enum values which will be disabled for parsing exchange body||string|
|enabledDeserializationFeatures|Comma-separated list of Jackson DeserializationFeature enum values which will be enabled for parsing exchange body||string|
|errorHandler|To use a custom ValidatorErrorHandler. The default error handler captures the errors and throws an exception.||object|
|objectMapper|The used Jackson object mapper||object|
|uriSchemaLoader|To use a custom schema loader allowing for adding custom format validation. The default implementation will create a schema loader that tries to determine the schema version from the $schema property of the specified schema.||object|
