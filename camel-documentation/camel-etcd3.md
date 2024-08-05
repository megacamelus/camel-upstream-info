# Etcd3

**Since Camel 3.19**

**Both producer and consumer are supported**

The Etcd v3 component allows you to work with Etcd, a distributed
reliable key-value store.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-etcd3</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

    etcd3:path[?options]

# Producer Operations (Since 3.20)

Apache Camel supports different etcd operations.

To define the operation, set the exchange header with a key of
`CamelEtcdAction` and a value set to one of the following:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">input message body</th>
<th style="text-align: left;">output message body</th>
<th style="text-align: left;">description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>set</p></td>
<td style="text-align: left;"><p><strong>String</strong> value of the
key-value pair to put</p></td>
<td style="text-align: left;"><p><code>PutResponse</code> result of a
put operation</p></td>
<td style="text-align: left;"><p>Puts a new key-value pair into etcd
where the option <code>path</code> or the exchange header
<code>CamelEtcdPath</code> is the key. You can set the key charset by
setting the exchange header with the key
<code>CamelEtcdKeyCharset</code>. You can set the value charset by
setting the exchange header with the key
<code>CamelEtcdValueCharset</code>.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>get</p></td>
<td style="text-align: left;"><p>None</p></td>
<td style="text-align: left;"><p><code>GetResponse</code> result of the
get operation</p></td>
<td style="text-align: left;"><p>Retrieve the key-value pair(s) that
match with the key corresponding to the option <code>path</code> or the
exchange header <code>CamelEtcdPath</code>. You can set the key charset
by setting the exchange header with the key
<code>CamelEtcdKeyCharset</code>. You indicate if the key is a prefix by
setting the exchange header with the key <code>CamelEtcdIsPrefix</code>
to <code>true</code>.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>delete</p></td>
<td style="text-align: left;"><p>None</p></td>
<td style="text-align: left;"><p><code>DeleteResponse</code> result of
the delete operation</p></td>
<td style="text-align: left;"><p>Delete the key-value pair(s) that match
with the key corresponding to the option <code>path</code> or the
exchange header <code>CamelEtcdPath</code>. You can set the key charset
by setting the exchange header with the key
<code>CamelEtcdKeyCharset</code>. You indicate if the key is a prefix by
setting the exchange header with the key <code>CamelEtcdIsPrefix</code>
to <code>true</code>.</p>
<p>== Consumer (Since 3.20)</p>
<p>The consumer of the etcd components allows watching changes on the
matching key-value pair(s). One exchange is created per event with the
header <code>CamelEtcdPath</code> set to the path of the corresponding
key-value pair and the body of type <code>WatchEvent</code>.</p>
<p>You can set the key charset by setting the exchange header with the
key <code>CamelEtcdKeyCharset</code>. You indicate if the key is a
prefix by setting the exchange header with the key
<code>CamelEtcdIsPrefix</code> to <code>true</code>.</p>
<p>By default, the consumer receives only the latest changes, but it is
also possible to start watching events from a specific revision by
setting the option <code>fromIndex</code> to the expected starting
index.</p>
<p>== AggregationRepository</p>
<p>The Etcd v3 component provides an <code>AggregationStrategy</code> to
use etcd as the backend datastore.</p>
<p>== RoutePolicy (Since 3.20)</p>
<p>The Etcd v3 component provides a <code>RoutePolicy</code> to use etcd
as clustered lock.</p></td>
</tr>
</tbody>
</table>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|Component configuration.||object|
|endpoints|Configure etcd server endpoints using the IPNameResolver. Multiple endpoints can be separated by comma.|http://localhost:2379|string|
|keyCharset|Configure the charset to use for the keys.|UTF-8|string|
|namespace|Configure the namespace of keys used. / will be treated as no namespace.||string|
|prefix|To apply an action on all the key-value pairs whose key that starts with the target path.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|fromIndex|The index to watch from|0|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|valueCharset|Configure the charset to use for the values.|UTF-8|string|
|authHeaders|Configure the headers to be added to auth request headers.||object|
|authority|Configure the authority used to authenticate connections to servers.||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|connectionTimeout|Configure the connection timeout.||object|
|headers|Configure the headers to be added to http request headers.||object|
|keepAliveTime|Configure the interval for gRPC keepalives. The current minimum allowed by gRPC is 10 seconds.|30 seconds|object|
|keepAliveTimeout|Configure the timeout for gRPC keepalives.|10 seconds|object|
|loadBalancerPolicy|Configure etcd load balancer policy.||string|
|maxInboundMessageSize|Configure the maximum message size allowed for a single gRPC frame.||integer|
|retryDelay|Configure the delay between retries in milliseconds.|500|integer|
|retryMaxDelay|Configure the max backing off delay between retries in milliseconds.|2500|integer|
|retryMaxDuration|Configure the retries max duration.||object|
|servicePath|The path to look for service discovery.|/services/|string|
|password|Configure etcd auth password.||string|
|sslContext|Configure SSL/TLS context to use instead of the system default.||object|
|userName|Configure etcd auth user.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|path|The path the endpoint refers to||string|
|endpoints|Configure etcd server endpoints using the IPNameResolver. Multiple endpoints can be separated by comma.|http://localhost:2379|string|
|keyCharset|Configure the charset to use for the keys.|UTF-8|string|
|namespace|Configure the namespace of keys used. / will be treated as no namespace.||string|
|prefix|To apply an action on all the key-value pairs whose key that starts with the target path.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|fromIndex|The index to watch from|0|integer|
|valueCharset|Configure the charset to use for the values.|UTF-8|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|authHeaders|Configure the headers to be added to auth request headers.||object|
|authority|Configure the authority used to authenticate connections to servers.||string|
|connectionTimeout|Configure the connection timeout.||object|
|headers|Configure the headers to be added to http request headers.||object|
|keepAliveTime|Configure the interval for gRPC keepalives. The current minimum allowed by gRPC is 10 seconds.|30 seconds|object|
|keepAliveTimeout|Configure the timeout for gRPC keepalives.|10 seconds|object|
|loadBalancerPolicy|Configure etcd load balancer policy.||string|
|maxInboundMessageSize|Configure the maximum message size allowed for a single gRPC frame.||integer|
|retryDelay|Configure the delay between retries in milliseconds.|500|integer|
|retryMaxDelay|Configure the max backing off delay between retries in milliseconds.|2500|integer|
|retryMaxDuration|Configure the retries max duration.||object|
|servicePath|The path to look for service discovery.|/services/|string|
|password|Configure etcd auth password.||string|
|sslContext|Configure SSL/TLS context to use instead of the system default.||object|
|userName|Configure etcd auth user.||string|
