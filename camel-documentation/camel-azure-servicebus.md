# Azure-servicebus

**Since Camel 3.12**

**Both producer and consumer are supported**

The azure-servicebus component that integrates [Azure
ServiceBus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview).
Azure ServiceBus is a fully managed enterprise integration message
broker. Service Bus can decouple applications and services. Service Bus
offers a reliable and secure platform for asynchronous transfer of data
and state. Data is transferred between different applications and
services using messages.

Prerequisites

You must have a valid Windows Azure Storage account. More information is
available at [Azure Documentation
Portal](https://docs.microsoft.com/azure/).

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-azure-servicebus</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Consumer and Producer

This component implements the Consumer and Producer.

# Usage

## Authentication Information

You have three different Credential Types: AZURE\_IDENTITY,
TOKEN\_CREDENTIAL and CONNECTION\_STRING. You can also provide a client
instance yourself. To use this component, you have three options to
provide the required Azure authentication information:

**CONNECTION\_STRING**:

-   Provide `connectionString` string it is the simplest option to get
    started.

**TOKEN\_CREDENTIAL**:

-   Provide an implementation of
    `com.azure.core.credential.TokenCredential` into the Camel’s
    Registry, e.g., using the
    `com.azure.identity.DefaultAzureCredentialBuilder().build();` API.
    See the documentation [here about Azure-AD
    authentication](https://docs.microsoft.com/en-us/azure/active-directory/authentication/overview-authentication).

**AZURE\_IDENTITY**:

-   This will use
    `com.azure.identity.DefaultAzureCredentialBuilder().build();`
    instance. This will follow the Default Azure Credential Chain. See
    the documentation [here about Azure-AD
    authentication](https://docs.microsoft.com/en-us/azure/active-directory/authentication/overview-authentication).

**Client instance**:

-   You can provide a
    `com.azure.messaging.servicebus.ServiceBusSenderClient` for sending
    message and/or
    `com.azure.messaging.servicebus.ServiceBusReceiverClient` to receive
    messages. If you provide the instances, they will be autowired.

## Message Body

In the producer, this component accepts message body of `String`,
`byte[]` and `BinaryData` types or `List<String>`, `List<byte[]>` and
`List<BinaryData>` to send batch messages.

In the consumer, the returned message body will be of type \`String.

## Azure ServiceBus Producer operations

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>sendMessages</code></p></td>
<td style="text-align: left;"><p>Sends a set of messages to a Service
Bus queue or topic using a batched approach.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>scheduleMessages</code></p></td>
<td style="text-align: left;"><p>Sends a scheduled message to the Azure
Service Bus entity this sender is connected to. A scheduled message is
enqueued and made available to receivers only at the scheduled enqueue
time.</p></td>
</tr>
</tbody>
</table>

## Azure ServiceBus Consumer operations

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>receiveMessages</code></p></td>
<td style="text-align: left;"><p>Receives an &lt;b&gt;infinite&lt;/b&gt;
stream of messages from the Service Bus entity.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>peekMessages</code></p></td>
<td style="text-align: left;"><p>Reads the next batch of active messages
without changing the state of the receiver or the message
source.</p></td>
</tr>
</tbody>
</table>

### Examples

-   `sendMessages`

<!-- -->

    from("direct:start")
      .process(exchange -> {
             final List<Object> inputBatch = new LinkedList<>();
                inputBatch.add("test batch 1");
                inputBatch.add("test batch 2");
                inputBatch.add("test batch 3");
                inputBatch.add(123456);
    
                exchange.getIn().setBody(inputBatch);
           })
      .to("azure-servicebus:test//?connectionString=test")
      .to("mock:result");

-   `scheduleMessages`

<!-- -->

    from("direct:start")
      .process(exchange -> {
             final List<Object> inputBatch = new LinkedList<>();
                inputBatch.add("test batch 1");
                inputBatch.add("test batch 2");
                inputBatch.add("test batch 3");
                inputBatch.add(123456);
    
                exchange.getIn().setHeader(ServiceBusConstants.SCHEDULED_ENQUEUE_TIME, OffsetDateTime.now());
                exchange.getIn().setBody(inputBatch);
           })
      .to("azure-servicebus:test//?connectionString=test&producerOperation=scheduleMessages")
      .to("mock:result");

-   `receiveMessages`

<!-- -->

    from("azure-servicebus:test//?connectionString=test")
      .log("${body}")
      .to("mock:result");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|amqpRetryOptions|Sets the retry options for Service Bus clients. If not specified, the default retry options are used.||object|
|amqpTransportType|Sets the transport type by which all the communication with Azure Service Bus occurs. Default value is AMQP.|AMQP|object|
|clientOptions|Sets the ClientOptions to be sent from the client built from this builder, enabling customization of certain properties, as well as support the addition of custom header information.||object|
|configuration|The component configurations||object|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter Service Bus application properties to and from Camel message headers.||object|
|proxyOptions|Sets the proxy configuration to use for ServiceBusSenderClient. When a proxy is configured, AMQP\_WEB\_SOCKETS must be used for the transport type.||object|
|serviceBusType|The service bus type of connection to execute. Queue is for typical queue option and topic for subscription based model.|queue|object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|enableDeadLettering|Enable application level deadlettering to the subscription deadletter subqueue if deadletter related headers are set.|false|boolean|
|maxAutoLockRenewDuration|Sets the amount of time to continue auto-renewing the lock. Setting ZERO disables auto-renewal. For ServiceBus receive mode (RECEIVE\_AND\_DELETE RECEIVE\_AND\_DELETE), auto-renewal is disabled.|5m|object|
|maxConcurrentCalls|Sets maximum number of concurrent calls|1|integer|
|prefetchCount|Sets the prefetch count of the receiver. For both PEEK\_LOCK PEEK\_LOCK and RECEIVE\_AND\_DELETE RECEIVE\_AND\_DELETE receive modes the default value is 1. Prefetch speeds up the message flow by aiming to have a message readily available for local retrieval when and before the application asks for one using receive message. Setting a non-zero value will prefetch that number of messages. Setting the value to zero turns prefetch off.||integer|
|processorClient|Sets the processorClient in order to consume messages by the consumer||object|
|serviceBusReceiveMode|Sets the receive mode for the receiver.|PEEK\_LOCK|object|
|subQueue|Sets the type of the SubQueue to connect to.||object|
|subscriptionName|Sets the name of the subscription in the topic to listen to. topicOrQueueName and serviceBusType=topic must also be set. This property is required if serviceBusType=topic and the consumer is in use.||string|
|binary|Set binary mode. If true, message body will be sent as byte. By default, it is false.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|producerOperation|Sets the desired operation to be used in the producer|sendMessages|object|
|scheduledEnqueueTime|Sets OffsetDateTime at which the message should appear in the Service Bus queue or topic.||object|
|senderClient|Sets senderClient to be used in the producer.||object|
|serviceBusTransactionContext|Represents transaction in service. This object just contains transaction id.||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|connectionString|Sets the connection string for a Service Bus namespace or a specific Service Bus resource.||string|
|credentialType|Determines the credential strategy to adopt|CONNECTION\_STRING|object|
|fullyQualifiedNamespace|Fully Qualified Namespace of the service bus||string|
|tokenCredential|A TokenCredential for Azure AD authentication.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|topicOrQueueName|Selected topic name or the queue name, that is depending on serviceBusType config. For example if serviceBusType=queue, then this will be the queue name and if serviceBusType=topic, this will be the topic name.||string|
|amqpRetryOptions|Sets the retry options for Service Bus clients. If not specified, the default retry options are used.||object|
|amqpTransportType|Sets the transport type by which all the communication with Azure Service Bus occurs. Default value is AMQP.|AMQP|object|
|clientOptions|Sets the ClientOptions to be sent from the client built from this builder, enabling customization of certain properties, as well as support the addition of custom header information.||object|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter Service Bus application properties to and from Camel message headers.||object|
|proxyOptions|Sets the proxy configuration to use for ServiceBusSenderClient. When a proxy is configured, AMQP\_WEB\_SOCKETS must be used for the transport type.||object|
|serviceBusType|The service bus type of connection to execute. Queue is for typical queue option and topic for subscription based model.|queue|object|
|enableDeadLettering|Enable application level deadlettering to the subscription deadletter subqueue if deadletter related headers are set.|false|boolean|
|maxAutoLockRenewDuration|Sets the amount of time to continue auto-renewing the lock. Setting ZERO disables auto-renewal. For ServiceBus receive mode (RECEIVE\_AND\_DELETE RECEIVE\_AND\_DELETE), auto-renewal is disabled.|5m|object|
|maxConcurrentCalls|Sets maximum number of concurrent calls|1|integer|
|prefetchCount|Sets the prefetch count of the receiver. For both PEEK\_LOCK PEEK\_LOCK and RECEIVE\_AND\_DELETE RECEIVE\_AND\_DELETE receive modes the default value is 1. Prefetch speeds up the message flow by aiming to have a message readily available for local retrieval when and before the application asks for one using receive message. Setting a non-zero value will prefetch that number of messages. Setting the value to zero turns prefetch off.||integer|
|processorClient|Sets the processorClient in order to consume messages by the consumer||object|
|serviceBusReceiveMode|Sets the receive mode for the receiver.|PEEK\_LOCK|object|
|subQueue|Sets the type of the SubQueue to connect to.||object|
|subscriptionName|Sets the name of the subscription in the topic to listen to. topicOrQueueName and serviceBusType=topic must also be set. This property is required if serviceBusType=topic and the consumer is in use.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|binary|Set binary mode. If true, message body will be sent as byte. By default, it is false.|false|boolean|
|producerOperation|Sets the desired operation to be used in the producer|sendMessages|object|
|scheduledEnqueueTime|Sets OffsetDateTime at which the message should appear in the Service Bus queue or topic.||object|
|senderClient|Sets senderClient to be used in the producer.||object|
|serviceBusTransactionContext|Represents transaction in service. This object just contains transaction id.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|connectionString|Sets the connection string for a Service Bus namespace or a specific Service Bus resource.||string|
|credentialType|Determines the credential strategy to adopt|CONNECTION\_STRING|object|
|fullyQualifiedNamespace|Fully Qualified Namespace of the service bus||string|
|tokenCredential|A TokenCredential for Azure AD authentication.||object|
