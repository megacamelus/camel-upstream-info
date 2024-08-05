# Jmx

**Since Camel 2.6**

**Only consumer is supported**

Apache Camel has extensive support for JMX to allow you to monitor and
control the Camel managed objects with a JMX client.

Camel also provides a [JMX](#jmx-component.adoc) component that allows
you to subscribe to MBean notifications. This page is about how to
manage and monitor Camel using JMX.

If you run Camel standalone with just `camel-core` as a dependency, and
you want JMX to enable out of the box, then you need to add
`camel-management` as a dependency.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|serverURL|Server url comes from the remaining endpoint. Use platform to connect to local JVM.||string|
|format|Format for the message body. Either xml or raw. If xml, the notification is serialized to xml. If raw, then the raw java object is set as the body.|xml|string|
|granularityPeriod|The frequency to poll the bean to check the monitor (monitor types only).|10000|duration|
|monitorType|The type of monitor to create. One of string, gauge, counter (monitor types only).||string|
|objectDomain|The domain for the mbean you're connecting to||string|
|objectName|The name key for the mbean you're connecting to. This value is mutually exclusive with the object properties that get passed.||string|
|observedAttribute|The attribute to observe for the monitor bean or consumer.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|executorService|To use a custom shared thread pool for the consumers. By default each consume has their own thread-pool to process and route notifications.||object|
|handback|Value to handback to the listener when a notification is received. This value will be put in the message header with the key JMXConstants#JMX\_HANDBACK.||object|
|notificationFilter|Reference to a bean that implements the NotificationFilter.||object|
|objectProperties|Properties for the object name. These values will be used if the objectName param is not set||object|
|reconnectDelay|The number of seconds to wait before attempting to retry establishment of the initial connection or attempt to reconnect a lost connection|10|integer|
|reconnectOnConnectionFailure|If true the consumer will attempt to reconnect to the JMX server when any connection failure occurs. The consumer will attempt to re-establish the JMX connection every 'x' seconds until the connection is made-- where 'x' is the configured reconnectionDelay|false|boolean|
|testConnectionOnStartup|If true the consumer will throw an exception if unable to establish the JMX connection upon startup. If false, the consumer will attempt to establish the JMX connection every 'x' seconds until the connection is made -- where 'x' is the configured reconnectionDelay|true|boolean|
|initThreshold|Initial threshold for the monitor. The value must exceed this before notifications are fired (counter monitor only).||integer|
|modulus|The value at which the counter is reset to zero (counter monitor only).||integer|
|offset|The amount to increment the threshold after it's been exceeded (counter monitor only).||integer|
|differenceMode|If true, then the value reported in the notification is the difference from the threshold as opposed to the value itself (counter and gauge monitor only).|false|boolean|
|notifyHigh|If true, the gauge will fire a notification when the high threshold is exceeded (gauge monitor only).|false|boolean|
|notifyLow|If true, the gauge will fire a notification when the low threshold is exceeded (gauge monitor only).|false|boolean|
|thresholdHigh|Value for the gauge's high threshold (gauge monitor only).||number|
|thresholdLow|Value for the gauge's low threshold (gauge monitor only).||number|
|password|Credentials for making a remote connection||string|
|user|Credentials for making a remote connection||string|
|notifyDiffer|If true, will fire a notification when the string attribute differs from the string to compare (string monitor or consumer). By default the consumer will notify match if observed attribute and string to compare has been configured.|false|boolean|
|notifyMatch|If true, will fire a notification when the string attribute matches the string to compare (string monitor or consumer). By default the consumer will notify match if observed attribute and string to compare has been configured.|false|boolean|
|stringToCompare|Value for attribute to compare (string monitor or consumer). By default the consumer will notify match if observed attribute and string to compare has been configured.||string|
