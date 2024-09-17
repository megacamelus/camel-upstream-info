# Jolt

**Since Camel 2.16**

**Only producer is supported**

The Jolt component allows you to process a JSON messages using a
[JOLT](https://github.com/bazaarvoice/jolt) specification. This can be
ideal when doing JSON to JSON transformation.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jolt</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    jolt:specName[?options]

Where `specName` is the classpath-local URI of the specification to
invoke; or the complete URL of the remote specification (e.g.:
`\file://folder/myfile.vm`).

# Examples

For example, you could use something like

    from("activemq:My.Queue").
      to("jolt:com/acme/MyResponse.json");

And a file-based resource:

    from("activemq:My.Queue").
      to("jolt:file://myfolder/MyResponse.json?contentCache=true").
      to("activemq:Another.Queue");

You can also specify what specification the component should use
dynamically via a header, so, for example:

    from("direct:in").
      setHeader("CamelJoltResourceUri").constant("path/to/my/spec.json").
      to("jolt:dummy?allowTemplateFromHeader=true");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|transform|Explicitly sets the Transform to use. If not set a Transform specified by the transformDsl will be created||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the resource. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod.||string|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|contentCache|Sets whether to use resource content cache or not|false|boolean|
|inputType|Specifies if the input is hydrated JSON or a JSON String.|Hydrated|object|
|outputType|Specifies if the output should be hydrated JSON or a JSON String.|Hydrated|object|
|transformDsl|Specifies the Transform DSL of the endpoint resource. If none is specified Chainr will be used.|Chainr|object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
