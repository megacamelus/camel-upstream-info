# Smpp

**Since Camel 2.2**

**Both producer and consumer are supported**

This component provides access to an SMSC (Short Message Service Center)
over the [SMPP](http://smsforum.net/SMPP_v3_4_Issue1_2.zip) protocol to
send and receive SMS. The [JSMPP](http://jsmpp.org) library is used for
the protocol implementation.

The version of the SMPP protocol specification is 3.4 by default and can
be set using the component configuration options (field
"interfaceVersion").

The Camel component currently operates as an
[ESME](http://en.wikipedia.org/wiki/ESME) (External Short Messaging
Entity) and not as an SMSC itself.

You are also able to execute `ReplaceSm`, `QuerySm`, `SubmitMulti`,
`CancelSm`, and `DataSm`.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-smpp</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# SMS limitations

SMS is neither reliable nor secure. Users who require reliable and
secure delivery may want to consider using the XMPP or SIP components
instead, combined with a smartphone app supporting the chosen protocol.

-   Reliability: although the SMPP standard offers a range of feedback
    mechanisms to indicate errors, non-delivery and confirmation of
    delivery, it is not uncommon for mobile networks to hide or simulate
    these responses. For example, some networks automatically send a
    delivery confirmation for every message even if the destination
    number is invalid or not switched on. Some networks silently drop
    messages if they think they are spam. Spam detection rules in the
    network may be very crude, sometimes more than 100 messages per day
    from a single sender may be considered spam.

-   Security: there is basic encryption for the last hop from the radio
    tower down to the recipient handset. SMS messages are not encrypted
    or authenticated in any other part of the network. Some operators
    allow staff in retail outlets or call centres to browse through the
    SMS message histories of their customers. Message sender identity
    can be easily forged. Regulators and even the mobile telephone
    industry itself have cautioned against the use of SMS in two-factor
    authentication schemes and other purposes where security is
    important.

While the Camel component makes it as easy as possible to send messages
to the SMS network, it cannot offer an easy solution to these problems.

# Data coding, alphabet and international character sets

Data coding and alphabet can be specified on a per-message basis.
Default values can be specified for the endpoint. It is important to
understand the relationship between these options and the way the
component acts when more than one value is set.

Data coding is an 8 bit field in the SMPP wire format.

The alphabet corresponds to bits 0–3 of the data coding field. For some
types of message, where a message class is used (by setting bit 5 of the
data coding field), the lower two bits of the data coding field are not
interpreted as alphabet. Only bits 2 and 3 impact the alphabet.

Furthermore, the current version of the JSMPP library only seems to
support bits 2 and 3, assuming that bits 0 and 1 are used for message
class. This is why the Alphabet class in JSMPP doesn’t support the value
3 (binary 0011) which indicates ISO-8859-1.

Although JSMPP provides a representation of the message class parameter,
the Camel component doesn’t currently provide a way to set it other than
manually setting the corresponding bits in the data coding field.

When setting the data coding field in the outgoing message, the Camel
component considers the following values and uses the first one it can
find:

-   the data coding specified in a header

-   the alphabet specified in a header

-   the data coding specified in the endpoint configuration (URI
    parameter)

In addition to trying to send the data coding value to the SMSC, the
Camel component also tries to analyze the message body, converts it to a
Java String (Unicode) and converts that to a byte array in the
corresponding alphabet. When deciding which alphabet to use in the byte
array, the Camel SMPP component does not consider the data coding value
(header or configuration), it only considers the specified alphabet
(from either the header or endpoint parameter).

If some characters in the String cannot be represented in the chosen
alphabet, they may be replaced by the question mark (`?`) symbol. Users
of the API may want to consider checking if their message body can be
converted to ISO-8859-1 before passing it to the component and if not,
setting the alphabet header to request UCS-2 encoding. If the alphabet
and data coding options are not specified at all, then the component may
try to detect the required encoding and set the data coding for you.

The list of alphabet codes is specified in the SMPP specification v3.4,
section 5.2.19. One notable limitation of the SMPP specification is that
there is no alphabet code for explicitly requesting use of the GSM 3.38
(7-bit) character set. Choosing `0` for the alphabet selects the SMSC
*default* alphabet, this usually means GSM 3.38, but it is not
guaranteed. The SMPP gateway Nexmo [actually allows the default to be
mapped to any other character set with a control panel
option](https://help.nexmo.com/hc/en-us/articles/204015813-How-to-change-the-character-encoding-in-SMPP-).
It is suggested that users check with their SMSC operator to confirm
exactly which character set is being used as the default.

# Message splitting and throttling

After transforming a message body from a String to a byte array, the
Camel component is also responsible for splitting the message into parts
(within the 140 byte SMS size limit) before passing it to JSMPP. This is
completed automatically.

If the GSM 3.38 alphabet is used, the component will pack up to 160
characters into the 140-byte message body. If an 8-bit character set is
used (e.g., ISO-8859-1 for Western Europe), then 140 characters will be
allowed within the 140-byte message body. If 16 bit UCS-2 encoding is
used, then just 70 characters fit into each 140-byte message.

Some SMSC providers implement throttling rules. Each part of a message
that has been split may be counted separately by the provider’s
throttling mechanism. The Camel Throttler component can be useful for
throttling messages in the SMPP route before handing them to the SMSC.

# URI format

    smpp://[username@]hostname[:port][?options]
    smpps://[username@]hostname[:port][?options]

If no **username** is provided, then Camel will provide the default
value `smppclient`.  
If no **port** number is provided, then Camel will provide the default
value `2775`.  
If the protocol name is "smpps", camel-smpp with try to use SSLSocket to
init a connection to the server.

**JSMPP library**

See the documentation of the [JSMPP Library](http://jsmpp.org) for more
details about the underlying library.

# Exception handling

This component supports the general Camel exception handling
capabilities

When an error occurs sending a message with SubmitSm (the default
action), the org.apache.camel.component.smpp.SmppException is thrown
with a nested exception, org.jsmpp.extra.NegativeResponseException. Call
NegativeResponseException.getCommandStatus() to obtain the exact SMPP
negative response code, the values are explained in the SMPP
specification 3.4, section 5.1.3.  
When the SMPP consumer receives a `DeliverSm` or `DataSm` short message
and the processing of these messages fails, you can also throw a
`ProcessRequestException` instead of handle the failure. In this case,
this exception is forwarded to the underlying [JSMPP
library](http://jsmpp.org) which will return the included error code to
the SMSC. This feature is useful to e.g., instruct the SMSC to resend
the short message at a later time. This could be done with the following
lines of code:

    from("smpp://smppclient@localhost:2775?password=password&enquireLinkTimer=3000&transactionTimer=5000&systemType=consumer")
      .doTry()
        .to("bean:dao?method=updateSmsState")
      .doCatch(Exception.class)
        .throwException(new ProcessRequestException("update of sms state failed", 100))
      .end();

Please refer to the [SMPP
specification](http://smsforum.net/SMPP_v3_4_Issue1_2.zip) for the
complete list of error codes and their meanings.

# Samples

A route which sends an SMS using the Java DSL:

    from("direct:start")
      .to("smpp://smppclient@localhost:2775?
          password=password&enquireLinkTimer=3000&transactionTimer=5000&systemType=producer");

A route which sends an SMS using the Spring XML DSL:

    <route>
      <from uri="direct:start"/>
      <to uri="smpp://smppclient@localhost:2775?
               password=password&amp;enquireLinkTimer=3000&amp;transactionTimer=5000&amp;systemType=producer"/>
    </route>

A route which receives an SMS using the Java DSL:

    from("smpp://smppclient@localhost:2775?password=password&enquireLinkTimer=3000&transactionTimer=5000&systemType=consumer")
      .to("bean:foo");

A route which receives an SMS using the Spring XML DSL:

      <route>
         <from uri="smpp://smppclient@localhost:2775?
                    password=password&amp;enquireLinkTimer=3000&amp;transactionTimer=5000&amp;systemType=consumer"/>
         <to uri="bean:foo"/>
      </route>

An example of using transceiver (TRX) binding type:

    from("direct:start")
            .to("smpp://j@localhost:8056?password=jpwd&systemType=producer" +
                "&messageReceiverRouteId=sampleMessageReceiverRouteId");
    
    from("direct:messageReceiver").id("sampleMessageReceiverRouteId")
            .to("bean:foo");

Please note that with TRX binding type, you wouldn’t define a
corresponding redundant SMPP consumer. Camel will use the specified
route by `messageReceiverRouteId` as the corresponding consumer.
Internally, it uses one and same SmppSession as producer for the
provided consumer.

When the SMPP Server doesn’t support TRX, then you have to define
separate producer (TX by default) and consumer (RX by default).

**SMSC simulator**

If you need an SMSC simulator for your test, you can use the simulator
provided by
[JSMPP](https://github.com/opentelecoms-org/jsmpp/wiki/GettingStarted#running-smpp-server).

# Debug logging

This component has log level **DEBUG**, which can be helpful in
debugging problems. If you use log4j, you can add the following line to
your configuration:

    log4j.logger.org.apache.camel.component.smpp=DEBUG

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|initialReconnectDelay|Defines the initial delay in milliseconds after the consumer/producer tries to reconnect to the SMSC, after the connection was lost.|5000|integer|
|maxReconnect|Defines the maximum number of attempts to reconnect to the SMSC, if SMSC returns a negative bind response|2147483647|integer|
|reconnectDelay|Defines the interval in milliseconds between the reconnect attempts, if the connection to the SMSC was lost and the previous was not succeed.|5000|integer|
|splittingPolicy|You can specify a policy for handling long messages: ALLOW - the default, long messages are split to 140 bytes per message TRUNCATE - long messages are split and only the first fragment will be sent to the SMSC. Some carriers drop subsequent fragments so this reduces load on the SMPP connection sending parts of a message that will never be delivered. REJECT - if a message would need to be split, it is rejected with an SMPP NegativeResponseException and the reason code signifying the message is too long.|ALLOW|object|
|systemType|This parameter is used to categorize the type of ESME (External Short Message Entity) that is binding to the SMSC (max. 13 characters).||string|
|addressRange|You can specify the address range for the SmppConsumer as defined in section 5.2.7 of the SMPP 3.4 specification. The SmppConsumer will receive messages only from SMSC's which target an address (MSISDN or IP address) within this range.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|destAddr|Defines the destination SME address. For mobile terminated messages, this is the directory number of the recipient MS. Only for SubmitSm, SubmitMulti, CancelSm and DataSm.|1717|string|
|destAddrNpi|Defines the type of number (TON) to be used in the SME destination address parameters. Only for SubmitSm, SubmitMulti, CancelSm and DataSm. The following NPI values are defined: 0: Unknown 1: ISDN (E163/E164) 2: Data (X.121) 3: Telex (F.69) 6: Land Mobile (E.212) 8: National 9: Private 10: ERMES 13: Internet (IP) 18: WAP Client Id (to be defined by WAP Forum)||integer|
|destAddrTon|Defines the type of number (TON) to be used in the SME destination address parameters. Only for SubmitSm, SubmitMulti, CancelSm and DataSm. The following TON values are defined: 0: Unknown 1: International 2: National 3: Network Specific 4: Subscriber Number 5: Alphanumeric 6: Abbreviated||integer|
|lazySessionCreation|Sessions can be lazily created to avoid exceptions, if the SMSC is not available when the Camel producer is started. Camel will check the in message headers 'CamelSmppSystemId' and 'CamelSmppPassword' of the first exchange. If they are present, Camel will use these data to connect to the SMSC.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|messageReceiverRouteId|Set this on producer in order to benefit from transceiver (TRX) binding type. So once set, you don't need to define an 'SMTPP consumer' endpoint anymore. You would set this to a 'Direct consumer' endpoint instead. DISCALIMER: This feature is only tested with 'Direct consumer' endpoint. The behavior with any other consumer type is unknown and not tested.||string|
|numberingPlanIndicator|Defines the numeric plan indicator (NPI) to be used in the SME. The following NPI values are defined: 0: Unknown 1: ISDN (E163/E164) 2: Data (X.121) 3: Telex (F.69) 6: Land Mobile (E.212) 8: National 9: Private 10: ERMES 13: Internet (IP) 18: WAP Client Id (to be defined by WAP Forum)||integer|
|priorityFlag|Allows the originating SME to assign a priority level to the short message. Only for SubmitSm and SubmitMulti. Four Priority Levels are supported: 0: Level 0 (lowest) priority 1: Level 1 priority 2: Level 2 priority 3: Level 3 (highest) priority||integer|
|protocolId|The protocol id||integer|
|registeredDelivery|Is used to request an SMSC delivery receipt and/or SME originated acknowledgements. The following values are defined: 0: No SMSC delivery receipt requested. 1: SMSC delivery receipt requested where final delivery outcome is success or failure. 2: SMSC delivery receipt requested where the final delivery outcome is delivery failure.||integer|
|replaceIfPresentFlag|Used to request the SMSC to replace a previously submitted message, that is still pending delivery. The SMSC will replace an existing message provided that the source address, destination address and service type match the same fields in the new message. The following replace if present flag values are defined: 0: Don't replace 1: Replace||integer|
|serviceType|The service type parameter can be used to indicate the SMS Application service associated with the message. The following generic service\_types are defined: CMT: Cellular Messaging CPT: Cellular Paging VMN: Voice Mail Notification VMA: Voice Mail Alerting WAP: Wireless Application Protocol USSD: Unstructured Supplementary Services Data||string|
|sourceAddr|Defines the address of SME (Short Message Entity) which originated this message.|1616|string|
|sourceAddrNpi|Defines the numeric plan indicator (NPI) to be used in the SME originator address parameters. The following NPI values are defined: 0: Unknown 1: ISDN (E163/E164) 2: Data (X.121) 3: Telex (F.69) 6: Land Mobile (E.212) 8: National 9: Private 10: ERMES 13: Internet (IP) 18: WAP Client Id (to be defined by WAP Forum)||integer|
|sourceAddrTon|Defines the type of number (TON) to be used in the SME originator address parameters. The following TON values are defined: 0: Unknown 1: International 2: National 3: Network Specific 4: Subscriber Number 5: Alphanumeric 6: Abbreviated||integer|
|typeOfNumber|Defines the type of number (TON) to be used in the SME. The following TON values are defined: 0: Unknown 1: International 2: National 3: Network Specific 4: Subscriber Number 5: Alphanumeric 6: Abbreviated||integer|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|To use the shared SmppConfiguration as configuration.||object|
|enquireLinkTimer|Defines the interval in milliseconds between the confidence checks. The confidence check is used to test the communication path between an ESME and an SMSC.|60000|integer|
|interfaceVersion|Defines the interface version to be used in the binding request with the SMSC. The following values are allowed, as defined in the SMPP protocol (and the underlying implementation using the jSMPP library, respectively): legacy (0x00), 3.3 (0x33), 3.4 (0x34), and 5.0 (0x50). The default (fallback) value is version 3.4.|3.4|string|
|pduProcessorDegree|Sets the number of threads which can read PDU and process them in parallel.|3|integer|
|pduProcessorQueueCapacity|Sets the capacity of the working queue for PDU processing.|100|integer|
|sessionStateListener|You can refer to a org.jsmpp.session.SessionStateListener in the Registry to receive callbacks when the session state changed.||object|
|singleDLR|When true, the SMSC delivery receipt would be requested only for the last segment of a multi-segment (long) message. For short messages, with only 1 segment the behaviour is unchanged.|false|boolean|
|transactionTimer|Defines the maximum period of inactivity allowed after a transaction, after which an SMPP entity may assume that the session is no longer active. This timer may be active on either communicating SMPP entity (i.e. SMSC or ESME).|10000|integer|
|alphabet|Defines encoding of data according the SMPP 3.4 specification, section 5.2.19. 0: SMSC Default Alphabet 4: 8 bit Alphabet 8: UCS2 Alphabet||integer|
|dataCoding|Defines the data coding according the SMPP 3.4 specification, section 5.2.19. Example data encodings are: 0: SMSC Default Alphabet 3: Latin 1 (ISO-8859-1) 4: Octet unspecified (8-bit binary) 8: UCS2 (ISO/IEC-10646) 13: Extended Kanji JIS(X 0212-1990)||integer|
|encoding|Defines the encoding scheme of the short message user data. Only for SubmitSm, ReplaceSm and SubmitMulti.|ISO-8859-1|string|
|httpProxyHost|If you need to tunnel SMPP through a HTTP proxy, set this attribute to the hostname or ip address of your HTTP proxy.||string|
|httpProxyPassword|If your HTTP proxy requires basic authentication, set this attribute to the password required for your HTTP proxy.||string|
|httpProxyPort|If you need to tunnel SMPP through a HTTP proxy, set this attribute to the port of your HTTP proxy.|3128|integer|
|httpProxyUsername|If your HTTP proxy requires basic authentication, set this attribute to the username required for your HTTP proxy.||string|
|proxyHeaders|These headers will be passed to the proxy server while establishing the connection.||object|
|password|The password for connecting to SMSC server.||string|
|systemId|The system id (username) for connecting to SMSC server.|smppclient|string|
|usingSSL|Whether using SSL with the smpps protocol|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Hostname for the SMSC server to use.|localhost|string|
|port|Port number for the SMSC server to use.|2775|integer|
|initialReconnectDelay|Defines the initial delay in milliseconds after the consumer/producer tries to reconnect to the SMSC, after the connection was lost.|5000|integer|
|maxReconnect|Defines the maximum number of attempts to reconnect to the SMSC, if SMSC returns a negative bind response|2147483647|integer|
|reconnectDelay|Defines the interval in milliseconds between the reconnect attempts, if the connection to the SMSC was lost and the previous was not succeed.|5000|integer|
|splittingPolicy|You can specify a policy for handling long messages: ALLOW - the default, long messages are split to 140 bytes per message TRUNCATE - long messages are split and only the first fragment will be sent to the SMSC. Some carriers drop subsequent fragments so this reduces load on the SMPP connection sending parts of a message that will never be delivered. REJECT - if a message would need to be split, it is rejected with an SMPP NegativeResponseException and the reason code signifying the message is too long.|ALLOW|object|
|systemType|This parameter is used to categorize the type of ESME (External Short Message Entity) that is binding to the SMSC (max. 13 characters).||string|
|addressRange|You can specify the address range for the SmppConsumer as defined in section 5.2.7 of the SMPP 3.4 specification. The SmppConsumer will receive messages only from SMSC's which target an address (MSISDN or IP address) within this range.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|destAddr|Defines the destination SME address. For mobile terminated messages, this is the directory number of the recipient MS. Only for SubmitSm, SubmitMulti, CancelSm and DataSm.|1717|string|
|destAddrNpi|Defines the type of number (TON) to be used in the SME destination address parameters. Only for SubmitSm, SubmitMulti, CancelSm and DataSm. The following NPI values are defined: 0: Unknown 1: ISDN (E163/E164) 2: Data (X.121) 3: Telex (F.69) 6: Land Mobile (E.212) 8: National 9: Private 10: ERMES 13: Internet (IP) 18: WAP Client Id (to be defined by WAP Forum)||integer|
|destAddrTon|Defines the type of number (TON) to be used in the SME destination address parameters. Only for SubmitSm, SubmitMulti, CancelSm and DataSm. The following TON values are defined: 0: Unknown 1: International 2: National 3: Network Specific 4: Subscriber Number 5: Alphanumeric 6: Abbreviated||integer|
|lazySessionCreation|Sessions can be lazily created to avoid exceptions, if the SMSC is not available when the Camel producer is started. Camel will check the in message headers 'CamelSmppSystemId' and 'CamelSmppPassword' of the first exchange. If they are present, Camel will use these data to connect to the SMSC.|false|boolean|
|messageReceiverRouteId|Set this on producer in order to benefit from transceiver (TRX) binding type. So once set, you don't need to define an 'SMTPP consumer' endpoint anymore. You would set this to a 'Direct consumer' endpoint instead. DISCALIMER: This feature is only tested with 'Direct consumer' endpoint. The behavior with any other consumer type is unknown and not tested.||string|
|numberingPlanIndicator|Defines the numeric plan indicator (NPI) to be used in the SME. The following NPI values are defined: 0: Unknown 1: ISDN (E163/E164) 2: Data (X.121) 3: Telex (F.69) 6: Land Mobile (E.212) 8: National 9: Private 10: ERMES 13: Internet (IP) 18: WAP Client Id (to be defined by WAP Forum)||integer|
|priorityFlag|Allows the originating SME to assign a priority level to the short message. Only for SubmitSm and SubmitMulti. Four Priority Levels are supported: 0: Level 0 (lowest) priority 1: Level 1 priority 2: Level 2 priority 3: Level 3 (highest) priority||integer|
|protocolId|The protocol id||integer|
|registeredDelivery|Is used to request an SMSC delivery receipt and/or SME originated acknowledgements. The following values are defined: 0: No SMSC delivery receipt requested. 1: SMSC delivery receipt requested where final delivery outcome is success or failure. 2: SMSC delivery receipt requested where the final delivery outcome is delivery failure.||integer|
|replaceIfPresentFlag|Used to request the SMSC to replace a previously submitted message, that is still pending delivery. The SMSC will replace an existing message provided that the source address, destination address and service type match the same fields in the new message. The following replace if present flag values are defined: 0: Don't replace 1: Replace||integer|
|serviceType|The service type parameter can be used to indicate the SMS Application service associated with the message. The following generic service\_types are defined: CMT: Cellular Messaging CPT: Cellular Paging VMN: Voice Mail Notification VMA: Voice Mail Alerting WAP: Wireless Application Protocol USSD: Unstructured Supplementary Services Data||string|
|sourceAddr|Defines the address of SME (Short Message Entity) which originated this message.|1616|string|
|sourceAddrNpi|Defines the numeric plan indicator (NPI) to be used in the SME originator address parameters. The following NPI values are defined: 0: Unknown 1: ISDN (E163/E164) 2: Data (X.121) 3: Telex (F.69) 6: Land Mobile (E.212) 8: National 9: Private 10: ERMES 13: Internet (IP) 18: WAP Client Id (to be defined by WAP Forum)||integer|
|sourceAddrTon|Defines the type of number (TON) to be used in the SME originator address parameters. The following TON values are defined: 0: Unknown 1: International 2: National 3: Network Specific 4: Subscriber Number 5: Alphanumeric 6: Abbreviated||integer|
|typeOfNumber|Defines the type of number (TON) to be used in the SME. The following TON values are defined: 0: Unknown 1: International 2: National 3: Network Specific 4: Subscriber Number 5: Alphanumeric 6: Abbreviated||integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|enquireLinkTimer|Defines the interval in milliseconds between the confidence checks. The confidence check is used to test the communication path between an ESME and an SMSC.|60000|integer|
|interfaceVersion|Defines the interface version to be used in the binding request with the SMSC. The following values are allowed, as defined in the SMPP protocol (and the underlying implementation using the jSMPP library, respectively): legacy (0x00), 3.3 (0x33), 3.4 (0x34), and 5.0 (0x50). The default (fallback) value is version 3.4.|3.4|string|
|pduProcessorDegree|Sets the number of threads which can read PDU and process them in parallel.|3|integer|
|pduProcessorQueueCapacity|Sets the capacity of the working queue for PDU processing.|100|integer|
|sessionStateListener|You can refer to a org.jsmpp.session.SessionStateListener in the Registry to receive callbacks when the session state changed.||object|
|singleDLR|When true, the SMSC delivery receipt would be requested only for the last segment of a multi-segment (long) message. For short messages, with only 1 segment the behaviour is unchanged.|false|boolean|
|transactionTimer|Defines the maximum period of inactivity allowed after a transaction, after which an SMPP entity may assume that the session is no longer active. This timer may be active on either communicating SMPP entity (i.e. SMSC or ESME).|10000|integer|
|alphabet|Defines encoding of data according the SMPP 3.4 specification, section 5.2.19. 0: SMSC Default Alphabet 4: 8 bit Alphabet 8: UCS2 Alphabet||integer|
|dataCoding|Defines the data coding according the SMPP 3.4 specification, section 5.2.19. Example data encodings are: 0: SMSC Default Alphabet 3: Latin 1 (ISO-8859-1) 4: Octet unspecified (8-bit binary) 8: UCS2 (ISO/IEC-10646) 13: Extended Kanji JIS(X 0212-1990)||integer|
|encoding|Defines the encoding scheme of the short message user data. Only for SubmitSm, ReplaceSm and SubmitMulti.|ISO-8859-1|string|
|httpProxyHost|If you need to tunnel SMPP through a HTTP proxy, set this attribute to the hostname or ip address of your HTTP proxy.||string|
|httpProxyPassword|If your HTTP proxy requires basic authentication, set this attribute to the password required for your HTTP proxy.||string|
|httpProxyPort|If you need to tunnel SMPP through a HTTP proxy, set this attribute to the port of your HTTP proxy.|3128|integer|
|httpProxyUsername|If your HTTP proxy requires basic authentication, set this attribute to the username required for your HTTP proxy.||string|
|proxyHeaders|These headers will be passed to the proxy server while establishing the connection.||object|
|password|The password for connecting to SMSC server.||string|
|systemId|The system id (username) for connecting to SMSC server.|smppclient|string|
|usingSSL|Whether using SSL with the smpps protocol|false|boolean|
