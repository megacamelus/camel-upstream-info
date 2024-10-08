# Grape

**Since Camel 2.16**

**Only producer is supported**

[Grape](http://docs.groovy-lang.org/latest/html/documentation/grape.html)
component allows you to fetch, load and manage additional jars when
`CamelContext` is running. In practice with the Camel Grape component
you can add new components, data formats and beans to your
`CamelContext` without the restart of the router.

# Grape options

# Setting up class loader

Grape requires using Groovy class loader with the `CamelContext`. You
can enable Groovy class loading on the existing Camel Context using the
`GrapeComponent#grapeCamelContext()` method:

    import static org.apache.camel.component.grape.GrapeComponent.grapeCamelContext;
    ...
    CamelContext camelContext = grapeCamelContext(new DefaultCamelContext());

You can also set up the Groovy class loader used by the Camel context by
yourself:

    camelContext.setApplicationContextClassLoader(new GroovyClassLoader(myClassLoader));

For example, the following snippet loads Camel FTP component:

    from("direct:loadCamelFTP").
      to("grape:org.apache.camel/camel-ftp/2.15.2");

You can also specify the Maven coordinates by sending them to the
endpoint as the exchange body:

    from("direct:loadCamelFTP").
      setBody().constant("org.apache.camel/camel-ftp/2.15.2").
      to("grape:defaultMavenCoordinates");

# Adding the Grape component to the project

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-grape</artifactId>
        <version>x.y.z</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Default payload type

By default, the Camel Grape component operates on the String payloads:

    producerTemplate.sendBody("grape:defaultMavenCoordinates", "org.apache.camel/camel-ftp/2.15.2");

Of course, Camel build-in [type conversion
API](#manual::type-converter.adoc) can perform the automatic data type
transformations for you. In the example below, Camel automatically
converts binary payload into the String:

    producerTemplate.sendBody("grape:defaultMavenCoordinates", "org.apache.camel/camel-ftp/2.15.2".getBytes());

# Loading components at runtime

To load the new component at the router runtime, just grab the jar
containing the given component:

    ProducerTemplate template = camelContext.createProducerTemplate();
    template.sendBody("grape:grape", "org.apache.camel/camel-stream/2.15.2");
    template.sendBody("stream:out", "msg");

# Loading processors bean at runtime

To load the new processor bean with your custom business login at the
router runtime, just grab the jar containing the required bean:

    ProducerTemplate template = camelContext.createProducerTemplate();
    template.sendBody("grape:grape", "com.example/my-business-processors/1.0");
    int productId = 1;
    int price = template.requestBody("bean:com.example.PricingBean?method=currentProductPrice", productId, int.class)

# Loading deployed jars after Camel context restart

After you download new jar, you usually would like to have it loaded by
the Camel again after the restart of the `CamelContext`. It is certainly
possible, as Grape component keeps track of the jar files you have
installed. To load again the installed jars on the context startup, use
the `GrapeEndpoint.loadPatches()` method in your route:

    import static org.apache.camel.component.grape.GrapeEndpoint.loadPatches;
    
    ...
    camelContext.addRoutes(
      new RouteBuilder() {
        @Override
        public void configure() throws Exception {
          loadPatches(camelContext);
    
          from("direct:loadCamelFTP").
            to("grape:org.apache.camel/camel-ftp/2.15.2");
        }
      });

# Managing the installed jars

If you would like to check what jars have been installed into the given
`CamelContext`, send a message to the grape endpoint with the
`CamelGrapeCommand` header set to `GrapeCommand.listPatches`:

    from("netty-http:http://0.0.0.0:80/patches").
        setHeader(GrapeConstats.GRAPE_COMMAND, constant(CamelGrapeCommand.listPatches)).
        to("grape:list");

Connecting to the route defined above using the HTTP client returns the
list of the jars installed by Grape component:

    $ curl http://my-router.com/patches
    grape:org.apache.camel/camel-ftp/2.15.2
    grape:org.apache.camel/camel-jms/2.15.2

If you would like to remove the installed jars, so these won’t be loaded
again after the context restart, use the
```GrapeCommand.``clearPatches``` command:

    from("netty-http:http://0.0.0.0:80/patches").
        setHeader(GrapeConstats.GRAPE_COMMAND, constant(CamelGrapeCommand.clearPatches)).
        setBody().constant("Installed patches have been deleted.");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|patchesRepository|Implementation of org.apache.camel.component.grape.PatchesRepository, by default: FilePatchesRepository||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|defaultCoordinates|Maven coordinates to use as default to grab if the message body is empty.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
