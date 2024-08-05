# Thrift

**Since Camel 2.20**

**Both producer and consumer are supported**

The Thrift component allows you to call or expose Remote Procedure Call
(RPC) services using [Apache Thrift](https://thrift.apache.org/) binary
communication protocol and serialization mechanism.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-thrift</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    thrift://service[?options]

# Thrift method parameters mapping

Parameters in the called procedure must be passed as a list of objects
inside the message body. The primitives are converted from the objects
on the fly. To correctly find the corresponding method, all types must
be transmitted regardless of the values. Please see an example below,
how to pass different parameters to the method with the Camel body:

    List requestBody = new ArrayList();
    
    requestBody.add((boolean)true);
    requestBody.add((byte)THRIFT_TEST_NUM1);
    requestBody.add((short)THRIFT_TEST_NUM1);
    requestBody.add((int)THRIFT_TEST_NUM1);
    requestBody.add((long)THRIFT_TEST_NUM1);
    requestBody.add((double)THRIFT_TEST_NUM1);
    requestBody.add("empty"); // String parameter
    requestBody.add(ByteBuffer.allocate(10)); // binary parameter
    requestBody.add(new Work(THRIFT_TEST_NUM1, THRIFT_TEST_NUM2, Operation.MULTIPLY)); // Struct parameter
    requestBody.add(new ArrayList<Integer>()); // list parameter
    requestBody.add(new HashSet<String>()); // set parameter
    requestBody.add(new HashMap<String, Long>()); // map parameter
    
    Object responseBody = template.requestBody("direct:thrift-alltypes", requestBody);

Incoming parameters in the service consumer will also be passed to the
message body as a list of objects.

# Examples

Below is a simple synchronous method invoke with host and port
parameters

    from("direct:thrift-calculate")
    .to("thrift://localhost:1101/org.apache.camel.component.thrift.generated.Calculator?method=calculate&synchronous=true");

Below is a simple synchronous method invoke for the XML DSL
configuration

    <route>
        <from uri="direct:thrift-add" />
        <to uri="thrift://localhost:1101/org.apache.camel.component.thrift.generated.Calculator?method=add&synchronous=true"/>
    </route>

Thrift service consumer with asynchronous communication

    from("thrift://localhost:1101/org.apache.camel.component.thrift.generated.Calculator")
    .to("direct:thrift-service");

It’s possible to automate Java code generation for .thrift files using
**thrift-maven-plugin**, but before start the thrift compiler binary
distribution for your operating system must be present on the running
host.

# For more information, see these resources

[Thrift project GitHub](https://github.com/apache/thrift/)
[https://thrift.apache.org/tutorial/java](https://thrift.apache.org/tutorial/java) \[Apache Thrift Java
tutorial\]

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|useGlobalSslContextParameters|Determine if the thrift component is using global SSL context parameters|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|The Thrift server host name. This is localhost or 0.0.0.0 (if not defined) when being a consumer or remote server host name when using producer.||string|
|port|The Thrift server port||integer|
|service|Fully qualified service name from the thrift descriptor file (package dot service definition name)||string|
|compressionType|Protocol compression mechanism type|NONE|object|
|exchangeProtocol|Exchange protocol serialization type|BINARY|object|
|clientTimeout|Client timeout for consumers||integer|
|maxPoolSize|The Thrift server consumer max thread pool size|10|integer|
|poolSize|The Thrift server consumer initial thread pool size|1|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|method|The Thrift invoked method name||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|negotiationType|Security negotiation type|PLAINTEXT|object|
|sslParameters|Configuration parameters for SSL/TLS security negotiation||object|
