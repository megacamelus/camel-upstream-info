# Consul

**Since Camel 2.18**

**Both producer and consumer are supported**

The Consul component is a component for integrating your application
with [Hashicorp Consul](https://www.consul.io/).

Maven users will need to add the following dependency to their pom.xml
for this component:

        <dependency>
            <groupId>org.apache.camel</groupId>
            <artifactId>camel-consul</artifactId>
            <version>${camel-version}</version>
        </dependency>

# URI format

    consul://domain?[options]

# Api Endpoint

The `apiEndpoint` denotes the type of [consul
api](https://www.consul.io/api-docs) which should be addressed.

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Domain</th>
<th style="text-align: left;">Producer</th>
<th style="text-align: left;">Consumer</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>kv</p></td>
<td style="text-align: left;"><p>ConsulKeyValueProducer</p></td>
<td style="text-align: left;"><p>ConsulKeyValueConsumer</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>event</p></td>
<td style="text-align: left;"><p>ConsulEventProducer</p></td>
<td style="text-align: left;"><p>ConsulEventConsumer</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>agent</p></td>
<td style="text-align: left;"><p>ConsulAgentProducer</p></td>
<td style="text-align: left;"><p>-</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>coordinates</p></td>
<td style="text-align: left;"><p>ConsulCoordinatesProducer</p></td>
<td style="text-align: left;"><p>-</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>health</p></td>
<td style="text-align: left;"><p>ConsulHealthProducer</p></td>
<td style="text-align: left;"><p>-</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>status</p></td>
<td style="text-align: left;"><p>ConsulStatusProducer</p></td>
<td style="text-align: left;"><p>-</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>preparedQuery</p></td>
<td style="text-align: left;"><p>ConsulPreparedQueryProducer</p></td>
<td style="text-align: left;"><p>-</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>catalog</p></td>
<td style="text-align: left;"><p>ConsulCatalogProducer</p></td>
<td style="text-align: left;"><p>-</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>session</p></td>
<td style="text-align: left;"><p>ConsulSessionProducer</p></td>
<td style="text-align: left;"><p>-</p></td>
</tr>
</tbody>
</table>

# Producer Examples

As an example, we will show how to use the `ConsulAgentProducer` to
register a service by means of the Consul agent api.

Registering and unregistering are examples for possible actions against
the Consul agent api.

The desired action can be defined by setting the header
`ConsulConstants.CONSUL_ACTION` to a value from the `ConsulXXXActions`
interface of the respective Consul api. E.g. `ConsulAgentActions`
contains the actions for the agent api.

If you set `CONSUL_ACTION` to `ConsulAgentActions.REGISTER`, the agent
action `REGISTER` will be executed.

Which producer action invoked by which consul api is defined by the
respective producer. E.g., the `ConsulAgentProducer` maps
`ConsulAgentActions.REGISTER` to an invocation of
`AgentClient.register`.

    from("direct:registerFooService")
        .setBody().constant(ImmutableRegistration.builder()
            .id("foo-1")
            .name("foo")
            .address("localhost")
            .port(80)
            .build())
        .setHeader(ConsulConstants.CONSUL_ACTION, constant(ConsulAgentActions.REGISTER))
        .to("consul:agent");

It is also possible to set a default action on the consul endpoint and
do without the header:

    consul:agent?action=REGISTER

# Registering Camel Routes with Consul

You can employ a `ServiceRegistrationRoutePolicy` to register Camel
routes as services with Consul automatically.

    from("jetty:http://0.0.0.0:8080/service/endpoint").routeId("foo-1")
        .routeProperty(ServiceDefinition.SERVICE_META_ID, "foo-1")
        .routeProperty(ServiceDefinition.SERVICE_META_NAME, "foo")
        .routePolicy(new ServiceRegistrationRoutePolicy())
    ...

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|connectTimeout|Connect timeout for OkHttpClient||object|
|consulClient|Reference to a org.kiwiproject.consul.Consul in the registry.||object|
|key|The default key. Can be overridden by CamelConsulKey||string|
|pingInstance|Configure if the AgentClient should attempt a ping before returning the Consul instance|true|boolean|
|readTimeout|Read timeout for OkHttpClient||object|
|tags|Set tags. You can separate multiple tags by comma.||string|
|url|The Consul agent URL||string|
|writeTimeout|Write timeout for OkHttpClient||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|action|The default action. Can be overridden by CamelConsulAction||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|valueAsString|Default to transform values retrieved from Consul i.e. on KV endpoint to string.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|Consul configuration||object|
|consistencyMode|The consistencyMode used for queries, default ConsistencyMode.DEFAULT|DEFAULT|object|
|datacenter|The data center||string|
|nearNode|The near node to use for queries.||string|
|nodeMeta|The note meta-data to use for queries.||array|
|aclToken|Sets the ACL token to be used with Consul||string|
|password|Sets the password to be used for basic authentication||string|
|sslContextParameters|SSL configuration using an org.apache.camel.support.jsse.SSLContextParameters instance.||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|
|userName|Sets the username to be used for basic authentication||string|
|blockSeconds|The second to wait for a watch event, default 10 seconds|10|integer|
|firstIndex|The first index for watch for, default 0|0|object|
|recursive|Recursively watch, default false|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiEndpoint|The API endpoint||string|
|connectTimeout|Connect timeout for OkHttpClient||object|
|consulClient|Reference to a org.kiwiproject.consul.Consul in the registry.||object|
|key|The default key. Can be overridden by CamelConsulKey||string|
|pingInstance|Configure if the AgentClient should attempt a ping before returning the Consul instance|true|boolean|
|readTimeout|Read timeout for OkHttpClient||object|
|tags|Set tags. You can separate multiple tags by comma.||string|
|url|The Consul agent URL||string|
|writeTimeout|Write timeout for OkHttpClient||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|action|The default action. Can be overridden by CamelConsulAction||string|
|valueAsString|Default to transform values retrieved from Consul i.e. on KV endpoint to string.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|consistencyMode|The consistencyMode used for queries, default ConsistencyMode.DEFAULT|DEFAULT|object|
|datacenter|The data center||string|
|nearNode|The near node to use for queries.||string|
|nodeMeta|The note meta-data to use for queries.||array|
|aclToken|Sets the ACL token to be used with Consul||string|
|password|Sets the password to be used for basic authentication||string|
|sslContextParameters|SSL configuration using an org.apache.camel.support.jsse.SSLContextParameters instance.||object|
|userName|Sets the username to be used for basic authentication||string|
|blockSeconds|The second to wait for a watch event, default 10 seconds|10|integer|
|firstIndex|The first index for watch for, default 0|0|object|
|recursive|Recursively watch, default false|false|boolean|
