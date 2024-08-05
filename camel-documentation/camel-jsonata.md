# Jsonata

**Since Camel 3.5**

**Only producer is supported**

The Jsonata component allows you to process JSON messages using the
[JSONATA](https://jsonata.org/) specification. This can be ideal when
doing JSON to JSON transformation and other transformations from JSON.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jsonata</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    jsonata:specName[?options]

Where **specName** is the classpath-local URI of the specification to
invoke; or the complete URL of the remote specification (e.g.:
`\file://folder/myfile.vm`).

# Samples

For example, you could use something like:

    from("activemq:My.Queue").
      to("jsonata:com/acme/MyResponse.json");

And a file-based resource:

    from("activemq:My.Queue").
      to("jsonata:file://myfolder/MyResponse.json?contentCache=true").
      to("activemq:Another.Queue");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the resource. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod.||string|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|contentCache|Sets whether to use resource content cache or not|false|boolean|
|inputType|Specifies if the input should be Jackson JsonNode or a JSON String.|Jackson|object|
|outputType|Specifies if the output should be Jackson JsonNode or a JSON String.|Jackson|object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
