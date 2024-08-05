# Validator

**Since Camel 1.1**

**Only producer is supported**

The Validation component performs XML validation of the message body
using the JAXP Validation API and based on any of the supported XML
schema languages, which defaults to [XML
Schema](http://www.w3.org/XML/Schema).

# URI format

    validator:someLocalOrRemoteResource

Where **someLocalOrRemoteResource** is some URL to a local resource on
the classpath or a full URL to a remote resource or resource on the file
system which contains the XSD to validate against. For example:

-   `validator:com/mypackage/myschema.xsd`

The Validation component is provided directly in the camel-core.

# Example

The following
[example](https://github.com/apache/camel/blob/main/components/camel-spring-xml/src/test/resources/org/apache/camel/component/validator/camelContext.xml)
shows how to configure a route from endpoint **direct:start** which then
goes to one of two endpoints, either **mock:valid** or **mock:invalid**
based on whether the XML matches the given schema (which is supplied on
the classpath).

# Advanced: JMX method `clearCachedSchema`

You can force that the cached schema in the validator endpoint is
cleared and reread with the next process call with the JMX operation
`clearCachedSchema`. You can also use this method to programmatically
clear the cache. This method is available on the `ValidatorEndpoint`
class.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|resourceResolverFactory|To use a custom LSResourceResolver which depends on a dynamic endpoint resource URI||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|URL to a local resource on the classpath, or a reference to lookup a bean in the Registry, or a full URL to a remote resource or resource on the file system which contains the XSD to validate against.||string|
|failOnNullBody|Whether to fail if no body exists.|true|boolean|
|failOnNullHeader|Whether to fail if no header exists when validating against a header.|true|boolean|
|headerName|To validate against a header instead of the message body.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|errorHandler|To use a custom org.apache.camel.processor.validation.ValidatorErrorHandler. The default error handler captures the errors and throws an exception.||object|
|resourceResolver|To use a custom LSResourceResolver. Do not use together with resourceResolverFactory||object|
|resourceResolverFactory|To use a custom LSResourceResolver which depends on a dynamic endpoint resource URI. The default resource resolver factory returns a resource resolver which can read files from the class path and file system. Do not use together with resourceResolver.||object|
|schemaFactory|To use a custom javax.xml.validation.SchemaFactory||object|
|schemaLanguage|Configures the W3C XML Schema Namespace URI.|http://www.w3.org/2001/XMLSchema|string|
|useSharedSchema|Whether the Schema instance should be shared or not. This option is introduced to work around a JDK 1.6.x bug. Xerces should not have this issue.|true|boolean|
