# Tika

**Since Camel 2.19**

**Only producer is supported**

The Tika component provides the ability to detect and parse documents
with Apache Tika. This component uses [Apache
Tika](https://tika.apache.org/) as the underlying library to work with
documents.

To use the Tika component, Maven users will need to add the following
dependency to their `pom.xml`:

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-tika</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# To Detect a file’s MIME Type

The file should be placed in the Body.

    from("direct:start")
            .to("tika:detect");

# To Parse a File

The file should be placed in the Body.

    from("direct:start")
            .to("tika:parse");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|Operation type||object|
|tikaParseOutputEncoding|Tika Parse Output Encoding||string|
|tikaParseOutputFormat|Tika Output Format. Supported output formats. xml: Returns Parsed Content as XML. html: Returns Parsed Content as HTML. text: Returns Parsed Content as Text. textMain: Uses the boilerpipe library to automatically extract the main content from a web page.|xml|object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|tikaConfig|Tika Config||object|
|tikaConfigUri|Tika Config Url||string|
