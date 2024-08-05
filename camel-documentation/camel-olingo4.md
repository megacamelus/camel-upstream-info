# Olingo4

**Since Camel 2.19**

**Both producer and consumer are supported**

The Olingo4 component uses [Apache Olingo](http://olingo.apache.org/)
version 4.0 APIs to interact with OData 4.0 compliant service. Since
version 4.0, OData is an OASIS standard and a number of popular open
source and commercial vendors and products support this protocol. A
sample list of supporting products can be found on the OData
[website](http://www.odata.org/ecosystem/).

The Olingo4 component supports reading entity sets, entities, simple and
complex properties, counts, using custom and OData system query
parameters. It supports updating entities and properties. It also
supports submitting queries and change requests as a single OData batch
operation.

The component supports configuring HTTP connection parameters and
headers for OData service connection. This allows configuring use of
SSL, OAuth2.0, etc. as required by the target OData service.

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-olingo4</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    olingo4://endpoint/<resource-path>?[options]

# Endpoint HTTP Headers

The component level configuration property **httpHeaders** supplies
static HTTP header information. However, some systems require dynamic
header information to be passed to and received from the endpoint. A
sample use case would be systems that require dynamic security tokens.
The **endpointHttpHeaders** and **responseHttpHeaders** endpoint
properties provide this capability. Set headers that need to be passed
to the endpoint in the **`CamelOlingo4.endpointHttpHeaders`** property
and the response headers will be returned in a
**`CamelOlingo4.responseHttpHeaders`** property. Both properties are of
the type **`java.util.Map<String, String>`**.

# OData Resource Type Mapping

The result of **read** endpoint and data type of **data** option depends
on the OData resource being queried, created or modified.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">OData Resource Type</th>
<th style="text-align: left;">Resource URI from resourcePath and
keyPredicate</th>
<th style="text-align: left;">In or Out Body Type</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>Entity data model</p></td>
<td style="text-align: left;"><p>$metadata</p></td>
<td
style="text-align: left;"><p><code>org.apache.olingo.commons.api.edm.Edm</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Service document</p></td>
<td style="text-align: left;"><p>/</p></td>
<td
style="text-align: left;"><p><code>org.apache.olingo.client.api.domain.ClientServiceDocument</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p>OData entity set</p></td>
<td style="text-align: left;"><p>&lt;entity-set&gt;</p></td>
<td
style="text-align: left;"><p><code>org.apache.olingo.client.api.domain.ClientEntitySet</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p>OData entity</p></td>
<td
style="text-align: left;"><p>&lt;entity-set&gt;(&lt;key-predicate&gt;)</p></td>
<td
style="text-align: left;"><p><code>org.apache.olingo.client.api.domain.ClientEntity</code>
for Out body (response) <code>java.util.Map&lt;String, Object&gt;</code>
for In body (request)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Simple property</p></td>
<td
style="text-align: left;"><p>&lt;entity-set&gt;(&lt;key-predicate&gt;)/&lt;simple-property&gt;</p></td>
<td
style="text-align: left;"><p><code>org.apache.olingo.client.api.domain.ClientPrimitiveValue</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Simple property value</p></td>
<td
style="text-align: left;"><p>&lt;entity-set&gt;(&lt;key-predicate&gt;)/&lt;simple-property&gt;/$value</p></td>
<td
style="text-align: left;"><p><code>org.apache.olingo.client.api.domain.ClientPrimitiveValue</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Complex property</p></td>
<td
style="text-align: left;"><p>&lt;entity-set&gt;(&lt;key-predicate&gt;)/&lt;complex-property&gt;</p></td>
<td
style="text-align: left;"><p><code>org.apache.olingo.client.api.domain.ClientComplexValue</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Count</p></td>
<td style="text-align: left;"><p>&lt;resource-uri&gt;/$count</p></td>
<td style="text-align: left;"><p><code>java.lang.Long</code></p></td>
</tr>
</tbody>
</table>

# Samples

The following route reads top 5 entries from the People entity ordered
by ascending FirstName property.

    from("direct:...")
        .setHeader("CamelOlingo4.$top", "5");
        .to("olingo4://read/People?orderBy=FirstName%20asc");

The following route reads Airports entity using the key property value
in incoming **id** header.

    from("direct:...")
        .setHeader("CamelOlingo4.keyPredicate", header("id"))
        .to("olingo4://read/Airports");

The following route creates People entity using the **ClientEntity** in
body message.

    from("direct:...")
        .to("olingo4://create/People");

The following route calls an odata action using the **ClientEntity** in
the body message. The body message may be null for actions that don’t
expect an input.

    from("direct:...")
        .to("olingo4://action/People");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|To use the shared configuration||object|
|connectTimeout|HTTP connection creation timeout in milliseconds, defaults to 30,000 (30 seconds)|30000|integer|
|contentType|Content-Type header value can be used to specify JSON or XML message format, defaults to application/json;charset=utf-8|application/json;charset=utf-8|string|
|filterAlreadySeen|Set this to true to filter out results that have already been communicated by this component.|false|boolean|
|httpHeaders|Custom HTTP headers to inject into every request, this could include OAuth tokens, etc.||object|
|proxy|HTTP proxy server configuration||object|
|serviceUri|Target OData service base URI, e.g. http://services.odata.org/OData/OData.svc||string|
|socketTimeout|HTTP request timeout in milliseconds, defaults to 30,000 (30 seconds)|30000|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|splitResult|For endpoints that return an array or collection, a consumer endpoint will map every element to distinct messages, unless splitResult is set to false.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|httpAsyncClientBuilder|Custom HTTP async client builder for more complex HTTP client configuration, overrides connectionTimeout, socketTimeout, proxy and sslContext. Note that a socketTimeout MUST be specified in the builder, otherwise OData requests could block indefinitely||object|
|httpClientBuilder|Custom HTTP client builder for more complex HTTP client configuration, overrides connectionTimeout, socketTimeout, proxy and sslContext. Note that a socketTimeout MUST be specified in the builder, otherwise OData requests could block indefinitely||object|
|sslContextParameters|To configure security using SSLContextParameters||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiName|What kind of operation to perform||object|
|methodName|What sub operation to use for the selected operation||string|
|connectTimeout|HTTP connection creation timeout in milliseconds, defaults to 30,000 (30 seconds)|30000|integer|
|contentType|Content-Type header value can be used to specify JSON or XML message format, defaults to application/json;charset=utf-8|application/json;charset=utf-8|string|
|filterAlreadySeen|Set this to true to filter out results that have already been communicated by this component.|false|boolean|
|httpHeaders|Custom HTTP headers to inject into every request, this could include OAuth tokens, etc.||object|
|inBody|Sets the name of a parameter to be passed in the exchange In Body||string|
|proxy|HTTP proxy server configuration||object|
|serviceUri|Target OData service base URI, e.g. http://services.odata.org/OData/OData.svc||string|
|socketTimeout|HTTP request timeout in milliseconds, defaults to 30,000 (30 seconds)|30000|integer|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|splitResult|For endpoints that return an array or collection, a consumer endpoint will map every element to distinct messages, unless splitResult is set to false.|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|httpAsyncClientBuilder|Custom HTTP async client builder for more complex HTTP client configuration, overrides connectionTimeout, socketTimeout, proxy and sslContext. Note that a socketTimeout MUST be specified in the builder, otherwise OData requests could block indefinitely||object|
|httpClientBuilder|Custom HTTP client builder for more complex HTTP client configuration, overrides connectionTimeout, socketTimeout, proxy and sslContext. Note that a socketTimeout MUST be specified in the builder, otherwise OData requests could block indefinitely||object|
|backoffErrorThreshold|The number of subsequent error polls (failed due some error) that should happen before the backoffMultipler should kick-in.||integer|
|backoffIdleThreshold|The number of subsequent idle polls that should happen before the backoffMultipler should kick-in.||integer|
|backoffMultiplier|To let the scheduled polling consumer backoff if there has been a number of subsequent idles/errors in a row. The multiplier is then the number of polls that will be skipped before the next actual attempt is happening again. When this option is in use then backoffIdleThreshold and/or backoffErrorThreshold must also be configured.||integer|
|delay|Milliseconds before the next poll.|500|integer|
|greedy|If greedy is enabled, then the ScheduledPollConsumer will run immediately again, if the previous run polled 1 or more messages.|false|boolean|
|initialDelay|Milliseconds before the first poll starts.|1000|integer|
|repeatCount|Specifies a maximum limit of number of fires. So if you set it to 1, the scheduler will only fire once. If you set it to 5, it will only fire five times. A value of zero or negative means fire forever.|0|integer|
|runLoggingLevel|The consumer logs a start/complete log line when it polls. This option allows you to configure the logging level for that.|TRACE|object|
|scheduledExecutorService|Allows for configuring a custom/shared thread pool to use for the consumer. By default each consumer has its own single threaded thread pool.||object|
|scheduler|To use a cron scheduler from either camel-spring or camel-quartz component. Use value spring or quartz for built in scheduler|none|object|
|schedulerProperties|To configure additional properties when using a custom scheduler or any of the Quartz, Spring based scheduler.||object|
|startScheduler|Whether the scheduler should be auto started.|true|boolean|
|timeUnit|Time unit for initialDelay and delay options.|MILLISECONDS|object|
|useFixedDelay|Controls if fixed delay or fixed rate is used. See ScheduledExecutorService in JDK for details.|true|boolean|
|sslContextParameters|To configure security using SSLContextParameters||object|
