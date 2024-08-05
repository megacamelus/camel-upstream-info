# Bonita

**Since Camel 2.19**

**Only producer is supported**

Used for communicating with a remote Bonita BPM process engine.

# URI format

    bonita://[operation]?[options]

Where **operation** is the specific action to perform on Bonita.

# Body content

For the startCase operation, the input variables are retrieved from the
body message. This one has to contain a `Map<String,Serializable>`.

# Examples

The following example starts a new case in Bonita:

    from("direct:start").to("bonita:startCase?hostname=localhost&amp;port=8080&amp;processName=TestProcess&amp;username=install&amp;password=install");

# Dependencies

To use Bonita in your Camel routes, you need to add a dependency on
**camel-bonita**, which implements the component.

If you use Maven, you can add the following to your pom.xml,
substituting the version number for the latest and greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-bonita</artifactId>
      <version>x.x.x</version>
    </dependency>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|Operation to use||object|
|hostname|Hostname where Bonita engine runs|localhost|string|
|port|Port of the server hosting Bonita engine|8080|string|
|processName|Name of the process involved in the operation||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|password|Password to authenticate to Bonita engine.||string|
|username|Username to authenticate to Bonita engine.||string|
