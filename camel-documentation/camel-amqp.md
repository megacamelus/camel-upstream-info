# Amqp

**Since Camel 1.2**

**Both producer and consumer are supported**

The AMQP component supports the [AMQP 1.0
protocol](http://www.amqp.org/) using the JMS Client API of the
[Qpid](http://qpid.apache.org/) project.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-amqp</artifactId>
        <version>${camel.version}</version> <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    amqp:[queue:|topic:]destinationName[?options]

# Usage

As AMQP component is inherited from JMS component, the usage of the
former is almost identical to the latter:

**Using AMQP component**

    // Consuming from AMQP queue
    from("amqp:queue:incoming").
      to(...);
    
    // Sending messages to the AMQP topic
    from(...).
      to("amqp:topic:notify");

# Configuring AMQP component

**Creating AMQP 1.0 component**

    AMQPComponent amqp = AMQPComponent.amqpComponent("amqp://localhost:5672");
    
    AMQPComponent authorizedAmqp = AMQPComponent.amqpComponent("amqp://localhost:5672", "user", "password");

You can also add an instance of
`org.apache.camel.component.amqp.AMQPConnectionDetails` to the registry
to automatically configure the AMQP component. For example, for Spring
Boot, you have to define bean:

**AMQP connection details auto-configuration**

    @Bean
    AMQPConnectionDetails amqpConnection() {
      return new AMQPConnectionDetails("amqp://localhost:5672");
    }
    
    @Bean
    AMQPConnectionDetails securedAmqpConnection() {
      return new AMQPConnectionDetails("amqp://localhost:5672", "username", "password");
    }

Likewise, you can also use CDI producer methods when using Camel-CDI

**AMQP connection details auto-configuration for CDI**

    @Produces
    AMQPConnectionDetails amqpConnection() {
      return new AMQPConnectionDetails("amqp://localhost:5672");
    }

You can also rely on the [Camel properties](#properties-component.adoc)
to read the AMQP connection details. Factory method
`AMQPConnectionDetails.discoverAMQP()` attempts to read Camel properties
in a Kubernetes-like convention, just as demonstrated on the snippet
below:

**AMQP connection details auto-configuration**

    export AMQP_SERVICE_HOST = "mybroker.com"
    export AMQP_SERVICE_PORT = "6666"
    export AMQP_SERVICE_USERNAME = "username"
    export AMQP_SERVICE_PASSWORD = "password"
    
    ...
    
    @Bean
    AMQPConnectionDetails amqpConnection() {
      return AMQPConnectionDetails.discoverAMQP();
    }

**Enabling AMQP specific options**

If you, for example, need to enable `amqp.traceFrames` you can do that
by appending the option to your URI, like the following example:

    AMQPComponent amqp = AMQPComponent.amqpComponent("amqp://localhost:5672?amqp.traceFrames=true");

For reference, take a look at the [QPID JMS client
configuration](https://qpid.apache.org/releases/qpid-jms-1.7.0/docs/index.html)

# Using topics

To have using topics working with `camel-amqp` you need to configure the
component to use `topic://` as topic prefix, as shown below:

     <bean id="amqp" class="org.apache.camel.component.amqp.AmqpComponent">
       <property name="connectionFactory">
         <bean class="org.apache.qpid.jms.JmsConnectionFactory" factory-method="createFromURL">
           <property name="remoteURI" value="amqp://localhost:5672" />
           <property name="topicPrefix" value="topic://" />  <!-- only necessary when connecting to ActiveMQ over AMQP 1.0 -->
         </bean>
       </property>
     </bean>

Keep in mind that both `AMQPComponent#amqpComponent()` methods and
`AMQPConnectionDetails` pre-configure the component with the topic
prefix, so you don’t have to configure it explicitly.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|clientId|Sets the JMS client ID to use. Note that this value, if specified, must be unique and can only be used by a single JMS connection instance. It is typically only required for durable topic subscriptions with JMS 1.1.||string|
|connectionFactory|The connection factory to be use. A connection factory must be configured either on the component or endpoint.||object|
|disableReplyTo|Specifies whether Camel ignores the JMSReplyTo header in messages. If true, Camel does not send a reply back to the destination specified in the JMSReplyTo header. You can use this option if you want Camel to consume from a route and you do not want Camel to automatically send back a reply message because another component in your code handles the reply message. You can also use this option if you want to use Camel as a proxy between different message brokers and you want to route message from one system to another.|false|boolean|
|durableSubscriptionName|The durable subscriber name for specifying durable topic subscriptions. The clientId option must be configured as well.||string|
|includeAmqpAnnotations|Whether to include AMQP annotations when mapping from AMQP to Camel Message. Setting this to true maps AMQP message annotations that contain a JMS\_AMQP\_MA\_ prefix to message headers. Due to limitations in Apache Qpid JMS API, currently delivery annotations are ignored.|false|boolean|
|jmsMessageType|Allows you to force the use of a specific jakarta.jms.Message implementation for sending JMS messages. Possible values are: Bytes, Map, Object, Stream, Text. By default, Camel would determine which JMS message type to use from the In body type. This option allows you to specify it.||object|
|replyTo|Provides an explicit ReplyTo destination (overrides any incoming value of Message.getJMSReplyTo() in consumer).||string|
|testConnectionOnStartup|Specifies whether to test the connection on startup. This ensures that when Camel starts that all the JMS consumers have a valid connection to the JMS broker. If a connection cannot be granted then Camel throws an exception on startup. This ensures that Camel is not started with failed connections. The JMS producers is tested as well.|false|boolean|
|acknowledgementModeName|The JMS acknowledgement name, which is one of: SESSION\_TRANSACTED, CLIENT\_ACKNOWLEDGE, AUTO\_ACKNOWLEDGE, DUPS\_OK\_ACKNOWLEDGE|AUTO\_ACKNOWLEDGE|string|
|artemisConsumerPriority|Consumer priorities allow you to ensure that high priority consumers receive messages while they are active. Normally, active consumers connected to a queue receive messages from it in a round-robin fashion. When consumer priorities are in use, messages are delivered round-robin if multiple active consumers exist with the same high priority. Messages will only going to lower priority consumers when the high priority consumers do not have credit available to consume the message, or those high priority consumers have declined to accept the message (for instance because it does not meet the criteria of any selectors associated with the consumer).||integer|
|asyncConsumer|Whether the JmsConsumer processes the Exchange asynchronously. If enabled then the JmsConsumer may pickup the next message from the JMS queue, while the previous message is being processed asynchronously (by the Asynchronous Routing Engine). This means that messages may be processed not 100% strictly in order. If disabled (as default) then the Exchange is fully processed before the JmsConsumer will pickup the next message from the JMS queue. Note if transacted has been enabled, then asyncConsumer=true does not run asynchronously, as transaction must be executed synchronously (Camel 3.0 may support async transactions).|false|boolean|
|autoStartup|Specifies whether the consumer container should auto-startup.|true|boolean|
|cacheLevel|Sets the cache level by ID for the underlying JMS resources. See cacheLevelName option for more details.||integer|
|cacheLevelName|Sets the cache level by name for the underlying JMS resources. Possible values are: CACHE\_AUTO, CACHE\_CONNECTION, CACHE\_CONSUMER, CACHE\_NONE, and CACHE\_SESSION. The default setting is CACHE\_AUTO. See the Spring documentation and Transactions Cache Levels for more information.|CACHE\_AUTO|string|
|concurrentConsumers|Specifies the default number of concurrent consumers when consuming from JMS (not for request/reply over JMS). See also the maxMessagesPerTask option to control dynamic scaling up/down of threads. When doing request/reply over JMS then the option replyToConcurrentConsumers is used to control number of concurrent consumers on the reply message listener.|1|integer|
|maxConcurrentConsumers|Specifies the maximum number of concurrent consumers when consuming from JMS (not for request/reply over JMS). See also the maxMessagesPerTask option to control dynamic scaling up/down of threads. When doing request/reply over JMS then the option replyToMaxConcurrentConsumers is used to control number of concurrent consumers on the reply message listener.||integer|
|replyToDeliveryPersistent|Specifies whether to use persistent delivery by default for replies.|true|boolean|
|selector|Sets the JMS selector to use||string|
|subscriptionDurable|Set whether to make the subscription durable. The durable subscription name to be used can be specified through the subscriptionName property. Default is false. Set this to true to register a durable subscription, typically in combination with a subscriptionName value (unless your message listener class name is good enough as subscription name). Only makes sense when listening to a topic (pub-sub domain), therefore this method switches the pubSubDomain flag as well.|false|boolean|
|subscriptionName|Set the name of a subscription to create. To be applied in case of a topic (pub-sub domain) with a shared or durable subscription. The subscription name needs to be unique within this client's JMS client id. Default is the class name of the specified message listener. Note: Only 1 concurrent consumer (which is the default of this message listener container) is allowed for each subscription, except for a shared subscription (which requires JMS 2.0).||string|
|subscriptionShared|Set whether to make the subscription shared. The shared subscription name to be used can be specified through the subscriptionName property. Default is false. Set this to true to register a shared subscription, typically in combination with a subscriptionName value (unless your message listener class name is good enough as subscription name). Note that shared subscriptions may also be durable, so this flag can (and often will) be combined with subscriptionDurable as well. Only makes sense when listening to a topic (pub-sub domain), therefore this method switches the pubSubDomain flag as well. Requires a JMS 2.0 compatible message broker.|false|boolean|
|acceptMessagesWhileStopping|Specifies whether the consumer accept messages while it is stopping. You may consider enabling this option, if you start and stop JMS routes at runtime, while there are still messages enqueued on the queue. If this option is false, and you stop the JMS route, then messages may be rejected, and the JMS broker would have to attempt redeliveries, which yet again may be rejected, and eventually the message may be moved at a dead letter queue on the JMS broker. To avoid this its recommended to enable this option.|false|boolean|
|allowReplyManagerQuickStop|Whether the DefaultMessageListenerContainer used in the reply managers for request-reply messaging allow the DefaultMessageListenerContainer.runningAllowed flag to quick stop in case JmsConfiguration#isAcceptMessagesWhileStopping is enabled, and org.apache.camel.CamelContext is currently being stopped. This quick stop ability is enabled by default in the regular JMS consumers but to enable for reply managers you must enable this flag.|false|boolean|
|consumerType|The consumer type to use, which can be one of: Simple, Default, or Custom. The consumer type determines which Spring JMS listener to use. Default will use org.springframework.jms.listener.DefaultMessageListenerContainer, Simple will use org.springframework.jms.listener.SimpleMessageListenerContainer. When Custom is specified, the MessageListenerContainerFactory defined by the messageListenerContainerFactory option will determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use.|Default|object|
|defaultTaskExecutorType|Specifies what default TaskExecutor type to use in the DefaultMessageListenerContainer, for both consumer endpoints and the ReplyTo consumer of producer endpoints. Possible values: SimpleAsync (uses Spring's SimpleAsyncTaskExecutor) or ThreadPool (uses Spring's ThreadPoolTaskExecutor with optimal values - cached thread-pool-like). If not set, it defaults to the previous behaviour, which uses a cached thread pool for consumer endpoints and SimpleAsync for reply consumers. The use of ThreadPool is recommended to reduce thread trash in elastic configurations with dynamically increasing and decreasing concurrent consumers.||object|
|eagerLoadingOfProperties|Enables eager loading of JMS properties and payload as soon as a message is loaded which generally is inefficient as the JMS properties may not be required but sometimes can catch early any issues with the underlying JMS provider and the use of JMS properties. See also the option eagerPoisonBody.|false|boolean|
|eagerPoisonBody|If eagerLoadingOfProperties is enabled and the JMS message payload (JMS body or JMS properties) is poison (cannot be read/mapped), then set this text as the message body instead so the message can be processed (the cause of the poison are already stored as exception on the Exchange). This can be turned off by setting eagerPoisonBody=false. See also the option eagerLoadingOfProperties.|Poison JMS message due to ${exception.message}|string|
|exposeListenerSession|Specifies whether the listener session should be exposed when consuming messages.|false|boolean|
|replyToConsumerType|The consumer type of the reply consumer (when doing request/reply), which can be one of: Simple, Default, or Custom. The consumer type determines which Spring JMS listener to use. Default will use org.springframework.jms.listener.DefaultMessageListenerContainer, Simple will use org.springframework.jms.listener.SimpleMessageListenerContainer. When Custom is specified, the MessageListenerContainerFactory defined by the messageListenerContainerFactory option will determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use.|Default|object|
|replyToSameDestinationAllowed|Whether a JMS consumer is allowed to send a reply message to the same destination that the consumer is using to consume from. This prevents an endless loop by consuming and sending back the same message to itself.|false|boolean|
|taskExecutor|Allows you to specify a custom task executor for consuming messages.||object|
|deliveryDelay|Sets delivery delay to use for send calls for JMS. This option requires JMS 2.0 compliant broker.|-1|integer|
|deliveryMode|Specifies the delivery mode to be used. Possible values are those defined by jakarta.jms.DeliveryMode. NON\_PERSISTENT = 1 and PERSISTENT = 2.||integer|
|deliveryPersistent|Specifies whether persistent delivery is used by default.|true|boolean|
|explicitQosEnabled|Set if the deliveryMode, priority or timeToLive qualities of service should be used when sending messages. This option is based on Spring's JmsTemplate. The deliveryMode, priority and timeToLive options are applied to the current endpoint. This contrasts with the preserveMessageQos option, which operates at message granularity, reading QoS properties exclusively from the Camel In message headers.|false|boolean|
|formatDateHeadersToIso8601|Sets whether JMS date properties should be formatted according to the ISO 8601 standard.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|preserveMessageQos|Set to true, if you want to send message using the QoS settings specified on the message, instead of the QoS settings on the JMS endpoint. The following three headers are considered JMSPriority, JMSDeliveryMode, and JMSExpiration. You can provide all or only some of them. If not provided, Camel will fall back to use the values from the endpoint instead. So, when using this option, the headers override the values from the endpoint. The explicitQosEnabled option, by contrast, will only use options set on the endpoint, and not values from the message header.|false|boolean|
|priority|Values greater than 1 specify the message priority when sending (where 1 is the lowest priority and 9 is the highest). The explicitQosEnabled option must also be enabled in order for this option to have any effect.|4|integer|
|replyToConcurrentConsumers|Specifies the default number of concurrent consumers when doing request/reply over JMS. See also the maxMessagesPerTask option to control dynamic scaling up/down of threads.|1|integer|
|replyToMaxConcurrentConsumers|Specifies the maximum number of concurrent consumers when using request/reply over JMS. See also the maxMessagesPerTask option to control dynamic scaling up/down of threads.||integer|
|replyToOnTimeoutMaxConcurrentConsumers|Specifies the maximum number of concurrent consumers for continue routing when timeout occurred when using request/reply over JMS.|1|integer|
|replyToOverride|Provides an explicit ReplyTo destination in the JMS message, which overrides the setting of replyTo. It is useful if you want to forward the message to a remote Queue and receive the reply message from the ReplyTo destination.||string|
|replyToType|Allows for explicitly specifying which kind of strategy to use for replyTo queues when doing request/reply over JMS. Possible values are: Temporary, Shared, or Exclusive. By default Camel will use temporary queues. However if replyTo has been configured, then Shared is used by default. This option allows you to use exclusive queues instead of shared ones. See Camel JMS documentation for more details, and especially the notes about the implications if running in a clustered environment, and the fact that Shared reply queues has lower performance than its alternatives Temporary and Exclusive.||object|
|requestTimeout|The timeout for waiting for a reply when using the InOut Exchange Pattern (in milliseconds). The default is 20 seconds. You can include the header CamelJmsRequestTimeout to override this endpoint configured timeout value, and thus have per message individual timeout values. See also the requestTimeoutCheckerInterval option.|20000|duration|
|timeToLive|When sending messages, specifies the time-to-live of the message (in milliseconds).|-1|integer|
|allowAdditionalHeaders|This option is used to allow additional headers which may have values that are invalid according to JMS specification. For example, some message systems, such as WMQ, do this with header names using prefix JMS\_IBM\_MQMD\_ containing values with byte array or other invalid types. You can specify multiple header names separated by comma, and use as suffix for wildcard matching.||string|
|allowNullBody|Whether to allow sending messages with no body. If this option is false and the message body is null, then an JMSException is thrown.|true|boolean|
|alwaysCopyMessage|If true, Camel will always make a JMS message copy of the message when it is passed to the producer for sending. Copying the message is needed in some situations, such as when a replyToDestinationSelectorName is set (incidentally, Camel will set the alwaysCopyMessage option to true, if a replyToDestinationSelectorName is set)|false|boolean|
|correlationProperty|When using InOut exchange pattern use this JMS property instead of JMSCorrelationID JMS property to correlate messages. If set messages will be correlated solely on the value of this property JMSCorrelationID property will be ignored and not set by Camel.||string|
|disableTimeToLive|Use this option to force disabling time to live. For example when you do request/reply over JMS, then Camel will by default use the requestTimeout value as time to live on the message being sent. The problem is that the sender and receiver systems have to have their clocks synchronized, so they are in sync. This is not always so easy to archive. So you can use disableTimeToLive=true to not set a time to live value on the sent message. Then the message will not expire on the receiver system. See below in section About time to live for more details.|false|boolean|
|forceSendOriginalMessage|When using mapJmsMessage=false Camel will create a new JMS message to send to a new JMS destination if you touch the headers (get or set) during the route. Set this option to true to force Camel to send the original JMS message that was received.|false|boolean|
|includeSentJMSMessageID|Only applicable when sending to JMS destination using InOnly (eg fire and forget). Enabling this option will enrich the Camel Exchange with the actual JMSMessageID that was used by the JMS client when the message was sent to the JMS destination.|false|boolean|
|replyToCacheLevelName|Sets the cache level by name for the reply consumer when doing request/reply over JMS. This option only applies when using fixed reply queues (not temporary). Camel will by default use: CACHE\_CONSUMER for exclusive or shared w/ replyToSelectorName. And CACHE\_SESSION for shared without replyToSelectorName. Some JMS brokers such as IBM WebSphere may require to set the replyToCacheLevelName=CACHE\_NONE to work. Note: If using temporary queues then CACHE\_NONE is not allowed, and you must use a higher value such as CACHE\_CONSUMER or CACHE\_SESSION.||string|
|replyToDestinationSelectorName|Sets the JMS Selector using the fixed name to be used so you can filter out your own replies from the others when using a shared queue (that is, if you are not using a temporary reply queue).||string|
|streamMessageTypeEnabled|Sets whether StreamMessage type is enabled or not. Message payloads of streaming kind such as files, InputStream, etc will either by sent as BytesMessage or StreamMessage. This option controls which kind will be used. By default BytesMessage is used which enforces the entire message payload to be read into memory. By enabling this option the message payload is read into memory in chunks and each chunk is then written to the StreamMessage until no more data.|false|boolean|
|allowAutoWiredConnectionFactory|Whether to auto-discover ConnectionFactory from the registry, if no connection factory has been configured. If only one instance of ConnectionFactory is found then it will be used. This is enabled by default.|true|boolean|
|allowAutoWiredDestinationResolver|Whether to auto-discover DestinationResolver from the registry, if no destination resolver has been configured. If only one instance of DestinationResolver is found then it will be used. This is enabled by default.|true|boolean|
|allowSerializedHeaders|Controls whether or not to include serialized headers. Applies only when transferExchange is true. This requires that the objects are serializable. Camel will exclude any non-serializable objects and log it at WARN level.|false|boolean|
|artemisStreamingEnabled|Whether optimizing for Apache Artemis streaming mode. This can reduce memory overhead when using Artemis with JMS StreamMessage types. This option must only be enabled if Apache Artemis is being used.|false|boolean|
|asyncStartListener|Whether to startup the JmsConsumer message listener asynchronously, when starting a route. For example if a JmsConsumer cannot get a connection to a remote JMS broker, then it may block while retrying and/or fail-over. This will cause Camel to block while starting routes. By setting this option to true, you will let routes startup, while the JmsConsumer connects to the JMS broker using a dedicated thread in asynchronous mode. If this option is used, then beware that if the connection could not be established, then an exception is logged at WARN level, and the consumer will not be able to receive messages; You can then restart the route to retry.|false|boolean|
|asyncStopListener|Whether to stop the JmsConsumer message listener asynchronously, when stopping a route.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|To use a shared JMS configuration||object|
|destinationResolver|A pluggable org.springframework.jms.support.destination.DestinationResolver that allows you to use your own resolver (for example, to lookup the real destination in a JNDI registry).||object|
|errorHandler|Specifies a org.springframework.util.ErrorHandler to be invoked in case of any uncaught exceptions thrown while processing a Message. By default these exceptions will be logged at the WARN level, if no errorHandler has been configured. You can configure logging level and whether stack traces should be logged using errorHandlerLoggingLevel and errorHandlerLogStackTrace options. This makes it much easier to configure, than having to code a custom errorHandler.||object|
|exceptionListener|Specifies the JMS Exception Listener that is to be notified of any underlying JMS exceptions.||object|
|idleConsumerLimit|Specify the limit for the number of consumers that are allowed to be idle at any given time.|1|integer|
|idleTaskExecutionLimit|Specifies the limit for idle executions of a receive task, not having received any message within its execution. If this limit is reached, the task will shut down and leave receiving to other executing tasks (in the case of dynamic scheduling; see the maxConcurrentConsumers setting). There is additional doc available from Spring.|1|integer|
|includeAllJMSXProperties|Whether to include all JMSX prefixed properties when mapping from JMS to Camel Message. Setting this to true will include properties such as JMSXAppID, and JMSXUserID etc. Note: If you are using a custom headerFilterStrategy then this option does not apply.|false|boolean|
|includeCorrelationIDAsBytes|Whether the JMS consumer should include JMSCorrelationIDAsBytes as a header on the Camel Message.|true|boolean|
|jmsKeyFormatStrategy|Pluggable strategy for encoding and decoding JMS keys so they can be compliant with the JMS specification. Camel provides two implementations out of the box: default and passthrough. The default strategy will safely marshal dots and hyphens (. and -). The passthrough strategy leaves the key as is. Can be used for JMS brokers which do not care whether JMS header keys contain illegal characters. You can provide your own implementation of the org.apache.camel.component.jms.JmsKeyFormatStrategy and refer to it using the # notation.||object|
|mapJmsMessage|Specifies whether Camel should auto map the received JMS message to a suited payload type, such as jakarta.jms.TextMessage to a String etc.|true|boolean|
|maxMessagesPerTask|The number of messages per task. -1 is unlimited. If you use a range for concurrent consumers (eg min max), then this option can be used to set a value to eg 100 to control how fast the consumers will shrink when less work is required.|-1|integer|
|messageConverter|To use a custom Spring org.springframework.jms.support.converter.MessageConverter so you can be in control how to map to/from a jakarta.jms.Message.||object|
|messageCreatedStrategy|To use the given MessageCreatedStrategy which are invoked when Camel creates new instances of jakarta.jms.Message objects when Camel is sending a JMS message.||object|
|messageIdEnabled|When sending, specifies whether message IDs should be added. This is just an hint to the JMS broker. If the JMS provider accepts this hint, these messages must have the message ID set to null; if the provider ignores the hint, the message ID must be set to its normal unique value.|true|boolean|
|messageListenerContainerFactory|Registry ID of the MessageListenerContainerFactory used to determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use to consume messages. Setting this will automatically set consumerType to Custom.||object|
|messageTimestampEnabled|Specifies whether timestamps should be enabled by default on sending messages. This is just an hint to the JMS broker. If the JMS provider accepts this hint, these messages must have the timestamp set to zero; if the provider ignores the hint the timestamp must be set to its normal value.|true|boolean|
|pubSubNoLocal|Specifies whether to inhibit the delivery of messages published by its own connection.|false|boolean|
|queueBrowseStrategy|To use a custom QueueBrowseStrategy when browsing queues||object|
|receiveTimeout|The timeout for receiving messages (in milliseconds).|1000|duration|
|recoveryInterval|Specifies the interval between recovery attempts, i.e. when a connection is being refreshed, in milliseconds. The default is 5000 ms, that is, 5 seconds.|5000|duration|
|requestTimeoutCheckerInterval|Configures how often Camel should check for timed out Exchanges when doing request/reply over JMS. By default Camel checks once per second. But if you must react faster when a timeout occurs, then you can lower this interval, to check more frequently. The timeout is determined by the option requestTimeout.|1000|duration|
|serviceLocationEnabled|Whether to detect the network address location of the JMS broker on startup. This information is gathered via reflection on the ConnectionFactory, and is vendor specific. This option can be used to turn this off.|true|boolean|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|temporaryQueueResolver|A pluggable TemporaryQueueResolver that allows you to use your own resolver for creating temporary queues (some messaging systems has special requirements for creating temporary queues).||object|
|transferException|If enabled and you are using Request Reply messaging (InOut) and an Exchange failed on the consumer side, then the caused Exception will be send back in response as a jakarta.jms.ObjectMessage. If the client is Camel, the returned Exception is rethrown. This allows you to use Camel JMS as a bridge in your routing - for example, using persistent queues to enable robust routing. Notice that if you also have transferExchange enabled, this option takes precedence. The caught exception is required to be serializable. The original Exception on the consumer side can be wrapped in an outer exception such as org.apache.camel.RuntimeCamelException when returned to the producer. Use this with caution as the data is using Java Object serialization and requires the received to be able to deserialize the data at Class level, which forces a strong coupling between the producers and consumer!|false|boolean|
|transferExchange|You can transfer the exchange over the wire instead of just the body and headers. The following fields are transferred: In body, Out body, Fault body, In headers, Out headers, Fault headers, exchange properties, exchange exception. This requires that the objects are serializable. Camel will exclude any non-serializable objects and log it at WARN level. You must enable this option on both the producer and consumer side, so Camel knows the payloads is an Exchange and not a regular payload. Use this with caution as the data is using Java Object serialization and requires the receiver to be able to deserialize the data at Class level, which forces a strong coupling between the producers and consumers having to use compatible Camel versions!|false|boolean|
|useMessageIDAsCorrelationID|Specifies whether JMSMessageID should always be used as JMSCorrelationID for InOut messages.|false|boolean|
|waitForProvisionCorrelationToBeUpdatedCounter|Number of times to wait for provisional correlation id to be updated to the actual correlation id when doing request/reply over JMS and when the option useMessageIDAsCorrelationID is enabled.|50|integer|
|waitForProvisionCorrelationToBeUpdatedThreadSleepingTime|Interval in millis to sleep each time while waiting for provisional correlation id to be updated.|100|duration|
|waitForTemporaryReplyToToBeUpdatedCounter|Number of times to wait for temporary replyTo queue to be created and ready when doing request/reply over JMS.|200|integer|
|waitForTemporaryReplyToToBeUpdatedThreadSleepingTime|Interval in millis to sleep each time while waiting for temporary replyTo queue to be ready.|100|duration|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|
|errorHandlerLoggingLevel|Allows to configure the default errorHandler logging level for logging uncaught exceptions.|WARN|object|
|errorHandlerLogStackTrace|Allows to control whether stack-traces should be logged or not, by the default errorHandler.|true|boolean|
|password|Password to use with the ConnectionFactory. You can also configure username/password directly on the ConnectionFactory.||string|
|username|Username to use with the ConnectionFactory. You can also configure username/password directly on the ConnectionFactory.||string|
|transacted|Specifies whether to use transacted mode|false|boolean|
|transactedInOut|Specifies whether InOut operations (request reply) default to using transacted mode If this flag is set to true, then Spring JmsTemplate will have sessionTransacted set to true, and the acknowledgeMode as transacted on the JmsTemplate used for InOut operations. Note from Spring JMS: that within a JTA transaction, the parameters passed to createQueue, createTopic methods are not taken into account. Depending on the Java EE transaction context, the container makes its own decisions on these values. Analogously, these parameters are not taken into account within a locally managed transaction either, since Spring JMS operates on an existing JMS Session in this case. Setting this flag to true will use a short local JMS transaction when running outside of a managed transaction, and a synchronized local JMS transaction in case of a managed transaction (other than an XA transaction) being present. This has the effect of a local JMS transaction being managed alongside the main transaction (which might be a native JDBC transaction), with the JMS transaction committing right after the main transaction.|false|boolean|
|lazyCreateTransactionManager|If true, Camel will create a JmsTransactionManager, if there is no transactionManager injected when option transacted=true.|true|boolean|
|transactionManager|The Spring transaction manager to use.||object|
|transactionName|The name of the transaction to use.||string|
|transactionTimeout|The timeout value of the transaction (in seconds), if using transacted mode.|-1|integer|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|destinationType|The kind of destination to use|queue|string|
|destinationName|Name of the queue or topic to use as destination||string|
|clientId|Sets the JMS client ID to use. Note that this value, if specified, must be unique and can only be used by a single JMS connection instance. It is typically only required for durable topic subscriptions with JMS 1.1.||string|
|connectionFactory|The connection factory to be use. A connection factory must be configured either on the component or endpoint.||object|
|disableReplyTo|Specifies whether Camel ignores the JMSReplyTo header in messages. If true, Camel does not send a reply back to the destination specified in the JMSReplyTo header. You can use this option if you want Camel to consume from a route and you do not want Camel to automatically send back a reply message because another component in your code handles the reply message. You can also use this option if you want to use Camel as a proxy between different message brokers and you want to route message from one system to another.|false|boolean|
|durableSubscriptionName|The durable subscriber name for specifying durable topic subscriptions. The clientId option must be configured as well.||string|
|jmsMessageType|Allows you to force the use of a specific jakarta.jms.Message implementation for sending JMS messages. Possible values are: Bytes, Map, Object, Stream, Text. By default, Camel would determine which JMS message type to use from the In body type. This option allows you to specify it.||object|
|replyTo|Provides an explicit ReplyTo destination (overrides any incoming value of Message.getJMSReplyTo() in consumer).||string|
|testConnectionOnStartup|Specifies whether to test the connection on startup. This ensures that when Camel starts that all the JMS consumers have a valid connection to the JMS broker. If a connection cannot be granted then Camel throws an exception on startup. This ensures that Camel is not started with failed connections. The JMS producers is tested as well.|false|boolean|
|acknowledgementModeName|The JMS acknowledgement name, which is one of: SESSION\_TRANSACTED, CLIENT\_ACKNOWLEDGE, AUTO\_ACKNOWLEDGE, DUPS\_OK\_ACKNOWLEDGE|AUTO\_ACKNOWLEDGE|string|
|artemisConsumerPriority|Consumer priorities allow you to ensure that high priority consumers receive messages while they are active. Normally, active consumers connected to a queue receive messages from it in a round-robin fashion. When consumer priorities are in use, messages are delivered round-robin if multiple active consumers exist with the same high priority. Messages will only going to lower priority consumers when the high priority consumers do not have credit available to consume the message, or those high priority consumers have declined to accept the message (for instance because it does not meet the criteria of any selectors associated with the consumer).||integer|
|asyncConsumer|Whether the JmsConsumer processes the Exchange asynchronously. If enabled then the JmsConsumer may pickup the next message from the JMS queue, while the previous message is being processed asynchronously (by the Asynchronous Routing Engine). This means that messages may be processed not 100% strictly in order. If disabled (as default) then the Exchange is fully processed before the JmsConsumer will pickup the next message from the JMS queue. Note if transacted has been enabled, then asyncConsumer=true does not run asynchronously, as transaction must be executed synchronously (Camel 3.0 may support async transactions).|false|boolean|
|autoStartup|Specifies whether the consumer container should auto-startup.|true|boolean|
|cacheLevel|Sets the cache level by ID for the underlying JMS resources. See cacheLevelName option for more details.||integer|
|cacheLevelName|Sets the cache level by name for the underlying JMS resources. Possible values are: CACHE\_AUTO, CACHE\_CONNECTION, CACHE\_CONSUMER, CACHE\_NONE, and CACHE\_SESSION. The default setting is CACHE\_AUTO. See the Spring documentation and Transactions Cache Levels for more information.|CACHE\_AUTO|string|
|concurrentConsumers|Specifies the default number of concurrent consumers when consuming from JMS (not for request/reply over JMS). See also the maxMessagesPerTask option to control dynamic scaling up/down of threads. When doing request/reply over JMS then the option replyToConcurrentConsumers is used to control number of concurrent consumers on the reply message listener.|1|integer|
|maxConcurrentConsumers|Specifies the maximum number of concurrent consumers when consuming from JMS (not for request/reply over JMS). See also the maxMessagesPerTask option to control dynamic scaling up/down of threads. When doing request/reply over JMS then the option replyToMaxConcurrentConsumers is used to control number of concurrent consumers on the reply message listener.||integer|
|replyToDeliveryPersistent|Specifies whether to use persistent delivery by default for replies.|true|boolean|
|selector|Sets the JMS selector to use||string|
|subscriptionDurable|Set whether to make the subscription durable. The durable subscription name to be used can be specified through the subscriptionName property. Default is false. Set this to true to register a durable subscription, typically in combination with a subscriptionName value (unless your message listener class name is good enough as subscription name). Only makes sense when listening to a topic (pub-sub domain), therefore this method switches the pubSubDomain flag as well.|false|boolean|
|subscriptionName|Set the name of a subscription to create. To be applied in case of a topic (pub-sub domain) with a shared or durable subscription. The subscription name needs to be unique within this client's JMS client id. Default is the class name of the specified message listener. Note: Only 1 concurrent consumer (which is the default of this message listener container) is allowed for each subscription, except for a shared subscription (which requires JMS 2.0).||string|
|subscriptionShared|Set whether to make the subscription shared. The shared subscription name to be used can be specified through the subscriptionName property. Default is false. Set this to true to register a shared subscription, typically in combination with a subscriptionName value (unless your message listener class name is good enough as subscription name). Note that shared subscriptions may also be durable, so this flag can (and often will) be combined with subscriptionDurable as well. Only makes sense when listening to a topic (pub-sub domain), therefore this method switches the pubSubDomain flag as well. Requires a JMS 2.0 compatible message broker.|false|boolean|
|acceptMessagesWhileStopping|Specifies whether the consumer accept messages while it is stopping. You may consider enabling this option, if you start and stop JMS routes at runtime, while there are still messages enqueued on the queue. If this option is false, and you stop the JMS route, then messages may be rejected, and the JMS broker would have to attempt redeliveries, which yet again may be rejected, and eventually the message may be moved at a dead letter queue on the JMS broker. To avoid this its recommended to enable this option.|false|boolean|
|allowReplyManagerQuickStop|Whether the DefaultMessageListenerContainer used in the reply managers for request-reply messaging allow the DefaultMessageListenerContainer.runningAllowed flag to quick stop in case JmsConfiguration#isAcceptMessagesWhileStopping is enabled, and org.apache.camel.CamelContext is currently being stopped. This quick stop ability is enabled by default in the regular JMS consumers but to enable for reply managers you must enable this flag.|false|boolean|
|consumerType|The consumer type to use, which can be one of: Simple, Default, or Custom. The consumer type determines which Spring JMS listener to use. Default will use org.springframework.jms.listener.DefaultMessageListenerContainer, Simple will use org.springframework.jms.listener.SimpleMessageListenerContainer. When Custom is specified, the MessageListenerContainerFactory defined by the messageListenerContainerFactory option will determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use.|Default|object|
|defaultTaskExecutorType|Specifies what default TaskExecutor type to use in the DefaultMessageListenerContainer, for both consumer endpoints and the ReplyTo consumer of producer endpoints. Possible values: SimpleAsync (uses Spring's SimpleAsyncTaskExecutor) or ThreadPool (uses Spring's ThreadPoolTaskExecutor with optimal values - cached thread-pool-like). If not set, it defaults to the previous behaviour, which uses a cached thread pool for consumer endpoints and SimpleAsync for reply consumers. The use of ThreadPool is recommended to reduce thread trash in elastic configurations with dynamically increasing and decreasing concurrent consumers.||object|
|eagerLoadingOfProperties|Enables eager loading of JMS properties and payload as soon as a message is loaded which generally is inefficient as the JMS properties may not be required but sometimes can catch early any issues with the underlying JMS provider and the use of JMS properties. See also the option eagerPoisonBody.|false|boolean|
|eagerPoisonBody|If eagerLoadingOfProperties is enabled and the JMS message payload (JMS body or JMS properties) is poison (cannot be read/mapped), then set this text as the message body instead so the message can be processed (the cause of the poison are already stored as exception on the Exchange). This can be turned off by setting eagerPoisonBody=false. See also the option eagerLoadingOfProperties.|Poison JMS message due to ${exception.message}|string|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|exposeListenerSession|Specifies whether the listener session should be exposed when consuming messages.|false|boolean|
|replyToConsumerType|The consumer type of the reply consumer (when doing request/reply), which can be one of: Simple, Default, or Custom. The consumer type determines which Spring JMS listener to use. Default will use org.springframework.jms.listener.DefaultMessageListenerContainer, Simple will use org.springframework.jms.listener.SimpleMessageListenerContainer. When Custom is specified, the MessageListenerContainerFactory defined by the messageListenerContainerFactory option will determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use.|Default|object|
|replyToSameDestinationAllowed|Whether a JMS consumer is allowed to send a reply message to the same destination that the consumer is using to consume from. This prevents an endless loop by consuming and sending back the same message to itself.|false|boolean|
|taskExecutor|Allows you to specify a custom task executor for consuming messages.||object|
|deliveryDelay|Sets delivery delay to use for send calls for JMS. This option requires JMS 2.0 compliant broker.|-1|integer|
|deliveryMode|Specifies the delivery mode to be used. Possible values are those defined by jakarta.jms.DeliveryMode. NON\_PERSISTENT = 1 and PERSISTENT = 2.||integer|
|deliveryPersistent|Specifies whether persistent delivery is used by default.|true|boolean|
|explicitQosEnabled|Set if the deliveryMode, priority or timeToLive qualities of service should be used when sending messages. This option is based on Spring's JmsTemplate. The deliveryMode, priority and timeToLive options are applied to the current endpoint. This contrasts with the preserveMessageQos option, which operates at message granularity, reading QoS properties exclusively from the Camel In message headers.|false|boolean|
|formatDateHeadersToIso8601|Sets whether JMS date properties should be formatted according to the ISO 8601 standard.|false|boolean|
|preserveMessageQos|Set to true, if you want to send message using the QoS settings specified on the message, instead of the QoS settings on the JMS endpoint. The following three headers are considered JMSPriority, JMSDeliveryMode, and JMSExpiration. You can provide all or only some of them. If not provided, Camel will fall back to use the values from the endpoint instead. So, when using this option, the headers override the values from the endpoint. The explicitQosEnabled option, by contrast, will only use options set on the endpoint, and not values from the message header.|false|boolean|
|priority|Values greater than 1 specify the message priority when sending (where 1 is the lowest priority and 9 is the highest). The explicitQosEnabled option must also be enabled in order for this option to have any effect.|4|integer|
|replyToConcurrentConsumers|Specifies the default number of concurrent consumers when doing request/reply over JMS. See also the maxMessagesPerTask option to control dynamic scaling up/down of threads.|1|integer|
|replyToMaxConcurrentConsumers|Specifies the maximum number of concurrent consumers when using request/reply over JMS. See also the maxMessagesPerTask option to control dynamic scaling up/down of threads.||integer|
|replyToOnTimeoutMaxConcurrentConsumers|Specifies the maximum number of concurrent consumers for continue routing when timeout occurred when using request/reply over JMS.|1|integer|
|replyToOverride|Provides an explicit ReplyTo destination in the JMS message, which overrides the setting of replyTo. It is useful if you want to forward the message to a remote Queue and receive the reply message from the ReplyTo destination.||string|
|replyToType|Allows for explicitly specifying which kind of strategy to use for replyTo queues when doing request/reply over JMS. Possible values are: Temporary, Shared, or Exclusive. By default Camel will use temporary queues. However if replyTo has been configured, then Shared is used by default. This option allows you to use exclusive queues instead of shared ones. See Camel JMS documentation for more details, and especially the notes about the implications if running in a clustered environment, and the fact that Shared reply queues has lower performance than its alternatives Temporary and Exclusive.||object|
|requestTimeout|The timeout for waiting for a reply when using the InOut Exchange Pattern (in milliseconds). The default is 20 seconds. You can include the header CamelJmsRequestTimeout to override this endpoint configured timeout value, and thus have per message individual timeout values. See also the requestTimeoutCheckerInterval option.|20000|duration|
|timeToLive|When sending messages, specifies the time-to-live of the message (in milliseconds).|-1|integer|
|allowAdditionalHeaders|This option is used to allow additional headers which may have values that are invalid according to JMS specification. For example, some message systems, such as WMQ, do this with header names using prefix JMS\_IBM\_MQMD\_ containing values with byte array or other invalid types. You can specify multiple header names separated by comma, and use as suffix for wildcard matching.||string|
|allowNullBody|Whether to allow sending messages with no body. If this option is false and the message body is null, then an JMSException is thrown.|true|boolean|
|alwaysCopyMessage|If true, Camel will always make a JMS message copy of the message when it is passed to the producer for sending. Copying the message is needed in some situations, such as when a replyToDestinationSelectorName is set (incidentally, Camel will set the alwaysCopyMessage option to true, if a replyToDestinationSelectorName is set)|false|boolean|
|correlationProperty|When using InOut exchange pattern use this JMS property instead of JMSCorrelationID JMS property to correlate messages. If set messages will be correlated solely on the value of this property JMSCorrelationID property will be ignored and not set by Camel.||string|
|disableTimeToLive|Use this option to force disabling time to live. For example when you do request/reply over JMS, then Camel will by default use the requestTimeout value as time to live on the message being sent. The problem is that the sender and receiver systems have to have their clocks synchronized, so they are in sync. This is not always so easy to archive. So you can use disableTimeToLive=true to not set a time to live value on the sent message. Then the message will not expire on the receiver system. See below in section About time to live for more details.|false|boolean|
|forceSendOriginalMessage|When using mapJmsMessage=false Camel will create a new JMS message to send to a new JMS destination if you touch the headers (get or set) during the route. Set this option to true to force Camel to send the original JMS message that was received.|false|boolean|
|includeSentJMSMessageID|Only applicable when sending to JMS destination using InOnly (eg fire and forget). Enabling this option will enrich the Camel Exchange with the actual JMSMessageID that was used by the JMS client when the message was sent to the JMS destination.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|replyToCacheLevelName|Sets the cache level by name for the reply consumer when doing request/reply over JMS. This option only applies when using fixed reply queues (not temporary). Camel will by default use: CACHE\_CONSUMER for exclusive or shared w/ replyToSelectorName. And CACHE\_SESSION for shared without replyToSelectorName. Some JMS brokers such as IBM WebSphere may require to set the replyToCacheLevelName=CACHE\_NONE to work. Note: If using temporary queues then CACHE\_NONE is not allowed, and you must use a higher value such as CACHE\_CONSUMER or CACHE\_SESSION.||string|
|replyToDestinationSelectorName|Sets the JMS Selector using the fixed name to be used so you can filter out your own replies from the others when using a shared queue (that is, if you are not using a temporary reply queue).||string|
|streamMessageTypeEnabled|Sets whether StreamMessage type is enabled or not. Message payloads of streaming kind such as files, InputStream, etc will either by sent as BytesMessage or StreamMessage. This option controls which kind will be used. By default BytesMessage is used which enforces the entire message payload to be read into memory. By enabling this option the message payload is read into memory in chunks and each chunk is then written to the StreamMessage until no more data.|false|boolean|
|allowSerializedHeaders|Controls whether or not to include serialized headers. Applies only when transferExchange is true. This requires that the objects are serializable. Camel will exclude any non-serializable objects and log it at WARN level.|false|boolean|
|artemisStreamingEnabled|Whether optimizing for Apache Artemis streaming mode. This can reduce memory overhead when using Artemis with JMS StreamMessage types. This option must only be enabled if Apache Artemis is being used.|false|boolean|
|asyncStartListener|Whether to startup the JmsConsumer message listener asynchronously, when starting a route. For example if a JmsConsumer cannot get a connection to a remote JMS broker, then it may block while retrying and/or fail-over. This will cause Camel to block while starting routes. By setting this option to true, you will let routes startup, while the JmsConsumer connects to the JMS broker using a dedicated thread in asynchronous mode. If this option is used, then beware that if the connection could not be established, then an exception is logged at WARN level, and the consumer will not be able to receive messages; You can then restart the route to retry.|false|boolean|
|asyncStopListener|Whether to stop the JmsConsumer message listener asynchronously, when stopping a route.|false|boolean|
|destinationResolver|A pluggable org.springframework.jms.support.destination.DestinationResolver that allows you to use your own resolver (for example, to lookup the real destination in a JNDI registry).||object|
|errorHandler|Specifies a org.springframework.util.ErrorHandler to be invoked in case of any uncaught exceptions thrown while processing a Message. By default these exceptions will be logged at the WARN level, if no errorHandler has been configured. You can configure logging level and whether stack traces should be logged using errorHandlerLoggingLevel and errorHandlerLogStackTrace options. This makes it much easier to configure, than having to code a custom errorHandler.||object|
|exceptionListener|Specifies the JMS Exception Listener that is to be notified of any underlying JMS exceptions.||object|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter header to and from Camel message.||object|
|idleConsumerLimit|Specify the limit for the number of consumers that are allowed to be idle at any given time.|1|integer|
|idleTaskExecutionLimit|Specifies the limit for idle executions of a receive task, not having received any message within its execution. If this limit is reached, the task will shut down and leave receiving to other executing tasks (in the case of dynamic scheduling; see the maxConcurrentConsumers setting). There is additional doc available from Spring.|1|integer|
|includeAllJMSXProperties|Whether to include all JMSX prefixed properties when mapping from JMS to Camel Message. Setting this to true will include properties such as JMSXAppID, and JMSXUserID etc. Note: If you are using a custom headerFilterStrategy then this option does not apply.|false|boolean|
|jmsKeyFormatStrategy|Pluggable strategy for encoding and decoding JMS keys so they can be compliant with the JMS specification. Camel provides two implementations out of the box: default and passthrough. The default strategy will safely marshal dots and hyphens (. and -). The passthrough strategy leaves the key as is. Can be used for JMS brokers which do not care whether JMS header keys contain illegal characters. You can provide your own implementation of the org.apache.camel.component.jms.JmsKeyFormatStrategy and refer to it using the # notation.||object|
|mapJmsMessage|Specifies whether Camel should auto map the received JMS message to a suited payload type, such as jakarta.jms.TextMessage to a String etc.|true|boolean|
|maxMessagesPerTask|The number of messages per task. -1 is unlimited. If you use a range for concurrent consumers (eg min max), then this option can be used to set a value to eg 100 to control how fast the consumers will shrink when less work is required.|-1|integer|
|messageConverter|To use a custom Spring org.springframework.jms.support.converter.MessageConverter so you can be in control how to map to/from a jakarta.jms.Message.||object|
|messageCreatedStrategy|To use the given MessageCreatedStrategy which are invoked when Camel creates new instances of jakarta.jms.Message objects when Camel is sending a JMS message.||object|
|messageIdEnabled|When sending, specifies whether message IDs should be added. This is just an hint to the JMS broker. If the JMS provider accepts this hint, these messages must have the message ID set to null; if the provider ignores the hint, the message ID must be set to its normal unique value.|true|boolean|
|messageListenerContainerFactory|Registry ID of the MessageListenerContainerFactory used to determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use to consume messages. Setting this will automatically set consumerType to Custom.||object|
|messageTimestampEnabled|Specifies whether timestamps should be enabled by default on sending messages. This is just an hint to the JMS broker. If the JMS provider accepts this hint, these messages must have the timestamp set to zero; if the provider ignores the hint the timestamp must be set to its normal value.|true|boolean|
|pubSubNoLocal|Specifies whether to inhibit the delivery of messages published by its own connection.|false|boolean|
|receiveTimeout|The timeout for receiving messages (in milliseconds).|1000|duration|
|recoveryInterval|Specifies the interval between recovery attempts, i.e. when a connection is being refreshed, in milliseconds. The default is 5000 ms, that is, 5 seconds.|5000|duration|
|requestTimeoutCheckerInterval|Configures how often Camel should check for timed out Exchanges when doing request/reply over JMS. By default Camel checks once per second. But if you must react faster when a timeout occurs, then you can lower this interval, to check more frequently. The timeout is determined by the option requestTimeout.|1000|duration|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|temporaryQueueResolver|A pluggable TemporaryQueueResolver that allows you to use your own resolver for creating temporary queues (some messaging systems has special requirements for creating temporary queues).||object|
|transferException|If enabled and you are using Request Reply messaging (InOut) and an Exchange failed on the consumer side, then the caused Exception will be send back in response as a jakarta.jms.ObjectMessage. If the client is Camel, the returned Exception is rethrown. This allows you to use Camel JMS as a bridge in your routing - for example, using persistent queues to enable robust routing. Notice that if you also have transferExchange enabled, this option takes precedence. The caught exception is required to be serializable. The original Exception on the consumer side can be wrapped in an outer exception such as org.apache.camel.RuntimeCamelException when returned to the producer. Use this with caution as the data is using Java Object serialization and requires the received to be able to deserialize the data at Class level, which forces a strong coupling between the producers and consumer!|false|boolean|
|transferExchange|You can transfer the exchange over the wire instead of just the body and headers. The following fields are transferred: In body, Out body, Fault body, In headers, Out headers, Fault headers, exchange properties, exchange exception. This requires that the objects are serializable. Camel will exclude any non-serializable objects and log it at WARN level. You must enable this option on both the producer and consumer side, so Camel knows the payloads is an Exchange and not a regular payload. Use this with caution as the data is using Java Object serialization and requires the receiver to be able to deserialize the data at Class level, which forces a strong coupling between the producers and consumers having to use compatible Camel versions!|false|boolean|
|useMessageIDAsCorrelationID|Specifies whether JMSMessageID should always be used as JMSCorrelationID for InOut messages.|false|boolean|
|waitForProvisionCorrelationToBeUpdatedCounter|Number of times to wait for provisional correlation id to be updated to the actual correlation id when doing request/reply over JMS and when the option useMessageIDAsCorrelationID is enabled.|50|integer|
|waitForProvisionCorrelationToBeUpdatedThreadSleepingTime|Interval in millis to sleep each time while waiting for provisional correlation id to be updated.|100|duration|
|waitForTemporaryReplyToToBeUpdatedCounter|Number of times to wait for temporary replyTo queue to be created and ready when doing request/reply over JMS.|200|integer|
|waitForTemporaryReplyToToBeUpdatedThreadSleepingTime|Interval in millis to sleep each time while waiting for temporary replyTo queue to be ready.|100|duration|
|errorHandlerLoggingLevel|Allows to configure the default errorHandler logging level for logging uncaught exceptions.|WARN|object|
|errorHandlerLogStackTrace|Allows to control whether stack-traces should be logged or not, by the default errorHandler.|true|boolean|
|password|Password to use with the ConnectionFactory. You can also configure username/password directly on the ConnectionFactory.||string|
|username|Username to use with the ConnectionFactory. You can also configure username/password directly on the ConnectionFactory.||string|
|transacted|Specifies whether to use transacted mode|false|boolean|
|transactedInOut|Specifies whether InOut operations (request reply) default to using transacted mode If this flag is set to true, then Spring JmsTemplate will have sessionTransacted set to true, and the acknowledgeMode as transacted on the JmsTemplate used for InOut operations. Note from Spring JMS: that within a JTA transaction, the parameters passed to createQueue, createTopic methods are not taken into account. Depending on the Java EE transaction context, the container makes its own decisions on these values. Analogously, these parameters are not taken into account within a locally managed transaction either, since Spring JMS operates on an existing JMS Session in this case. Setting this flag to true will use a short local JMS transaction when running outside of a managed transaction, and a synchronized local JMS transaction in case of a managed transaction (other than an XA transaction) being present. This has the effect of a local JMS transaction being managed alongside the main transaction (which might be a native JDBC transaction), with the JMS transaction committing right after the main transaction.|false|boolean|
|lazyCreateTransactionManager|If true, Camel will create a JmsTransactionManager, if there is no transactionManager injected when option transacted=true.|true|boolean|
|transactionManager|The Spring transaction manager to use.||object|
|transactionName|The name of the transaction to use.||string|
|transactionTimeout|The timeout value of the transaction (in seconds), if using transacted mode.|-1|integer|
