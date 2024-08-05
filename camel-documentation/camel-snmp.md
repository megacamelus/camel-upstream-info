# Snmp

**Since Camel 2.1**

**Both producer and consumer are supported**

The SNMP component gives you the ability to poll SNMP capable devices or
receiving traps

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-snmp</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    snmp://hostname[:port][?Options]

The component supports polling OID values from an SNMP enabled device
and receiving traps.

# Snmp Producer

It can also be used to request information using GET method.

The response body type is `org.apache.camel.component.snmp.SnmpMessage`.

# The result of a poll

Given the situation, that I poll for the following OIDs:

**OIDs**

    1.3.6.1.2.1.1.3.0
    1.3.6.1.2.1.25.3.2.1.5.1
    1.3.6.1.2.1.25.3.5.1.1.1
    1.3.6.1.2.1.43.5.1.1.11.1

The result will be the following:

**Result of toString conversion**

    <?xml version="1.0" encoding="UTF-8"?>
    <snmp>
      <entry>
        <oid>1.3.6.1.2.1.1.3.0</oid>
        <value>6 days, 21:14:28.00</value>
      </entry>
      <entry>
        <oid>1.3.6.1.2.1.25.3.2.1.5.1</oid>
        <value>2</value>
      </entry>
      <entry>
        <oid>1.3.6.1.2.1.25.3.5.1.1.1</oid>
        <value>3</value>
      </entry>
      <entry>
        <oid>1.3.6.1.2.1.43.5.1.1.11.1</oid>
        <value>6</value>
      </entry>
      <entry>
        <oid>1.3.6.1.2.1.1.1.0</oid>
        <value>My Very Special Printer Of Brand Unknown</value>
      </entry>
    </snmp>

As you maybe recognized, there is one more result than requested:
`....1.3.6.1.2.1.1.1.0`. The device fills in this one automatically in
this special case. So it may absolutely happen that you receive more
than you requested. Be prepared.

**OID starting with dot representation**

    .1.3.6.1.4.1.6527.3.1.2.21.2.1.50

As you may notice, default `snmpVersion` is 0, which means `version1` in
the endpoint if it is not set explicitly. Make sure you explicitly set
`snmpVersion` which is not default value, in a case of where you are
able to query SNMP tables with different versions. Other possible values
are `version2c` and `version3`.

# Examples

Polling a remote device:

    snmp:192.168.178.23:161?protocol=udp&type=POLL&oids=1.3.6.1.2.1.1.5.0

Setting up a trap receiver (**Note that no OID info is needed here!**):

    snmp:127.0.0.1:162?protocol=udp&type=TRAP

You can get the community of SNMP TRAP with message header
`securityName`, peer address of the SNMP TRAP with message header
`peerAddress`.

Routing example in Java: (converts the SNMP PDU to XML String)

    from("snmp:192.168.178.23:161?protocol=udp&type=POLL&oids=1.3.6.1.2.1.1.5.0").
    convertBodyTo(String.class).
    to("activemq:snmp.states");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Hostname of the SNMP enabled device||string|
|port|Port number of the SNMP enabled device||integer|
|oids|Defines which values you are interested in. Please have a look at the Wikipedia to get a better understanding. You may provide a single OID or a coma separated list of OIDs. Example: oids=1.3.6.1.2.1.1.3.0,1.3.6.1.2.1.25.3.2.1.5.1,1.3.6.1.2.1.25.3.5.1.1.1,1.3.6.1.2.1.43.5.1.1.11.1||object|
|protocol|Here you can select which protocol to use. You can use either udp or tcp.|udp|string|
|retries|Defines how often a retry is made before canceling the request.|2|integer|
|snmpCommunity|Sets the community octet string for the snmp request.|public|string|
|snmpContextEngineId|Sets the context engine ID field of the scoped PDU.||string|
|snmpContextName|Sets the context name field of this scoped PDU.||string|
|snmpVersion|Sets the snmp version for the request. The value 0 means SNMPv1, 1 means SNMPv2c, and the value 3 means SNMPv3|0|integer|
|timeout|Sets the timeout value for the request in millis.|1500|integer|
|type|Which operation to perform such as poll, trap, etc.||object|
|delay|Milliseconds before the next poll.|60000|duration|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|treeList|Sets the flag whether the scoped PDU will be displayed as the list if it has child elements in its tree|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|backoffErrorThreshold|The number of subsequent error polls (failed due some error) that should happen before the backoffMultipler should kick-in.||integer|
|backoffIdleThreshold|The number of subsequent idle polls that should happen before the backoffMultipler should kick-in.||integer|
|backoffMultiplier|To let the scheduled polling consumer backoff if there has been a number of subsequent idles/errors in a row. The multiplier is then the number of polls that will be skipped before the next actual attempt is happening again. When this option is in use then backoffIdleThreshold and/or backoffErrorThreshold must also be configured.||integer|
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
|authenticationPassphrase|The authentication passphrase. If not null, authenticationProtocol must also be not null. RFC3414 11.2 requires passphrases to have a minimum length of 8 bytes. If the length of authenticationPassphrase is less than 8 bytes an IllegalArgumentException is thrown.||string|
|authenticationProtocol|Authentication protocol to use if security level is set to enable authentication The possible values are: MD5, SHA1||string|
|privacyPassphrase|The privacy passphrase. If not null, privacyProtocol must also be not null. RFC3414 11.2 requires passphrases to have a minimum length of 8 bytes. If the length of authenticationPassphrase is less than 8 bytes an IllegalArgumentException is thrown.||string|
|privacyProtocol|The privacy protocol ID to be associated with this user. If set to null, this user only supports unencrypted messages.||string|
|securityLevel|Sets the security level for this target. The supplied security level must be supported by the security model dependent information associated with the security name set for this target. The value 1 means: No authentication and no encryption. Anyone can create and read messages with this security level The value 2 means: Authentication and no encryption. Only the one with the right authentication key can create messages with this security level, but anyone can read the contents of the message. The value 3 means: Authentication and encryption. Only the one with the right authentication key can create messages with this security level, and only the one with the right encryption/decryption key can read the contents of the message.|3|integer|
|securityName|Sets the security name to be used with this target.||string|
