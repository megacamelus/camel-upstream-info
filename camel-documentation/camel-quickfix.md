# Quickfix

**Since Camel 2.1**

**Both producer and consumer are supported**

The Quickfix component adapts the
[QuickFIX/J](http://www.quickfixj.org/) FIX engine for using in Camel.
This component uses the standard [Financial Interchange (FIX)
protocol](http://www.fixprotocol.org/) for message transport.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-quickfix</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    quickfix:configFile[?sessionID=sessionID&lazyCreateEngine=true|false]

The **configFile** is the name of the QuickFIX/J configuration to use
for the FIX engine (located as a resource found in your classpath). The
optional **sessionID** identifies a specific FIX session. The format of
the sessionID is:

    (BeginString):(SenderCompID)[/(SenderSubID)[/(SenderLocationID)]]->(TargetCompID)[/(TargetSubID)[/(TargetLocationID)]]

The optional **lazyCreateEngine** parameter allows creating QuickFIX/J
engine on demand. Value **true** means the engine is started when the
first message is sent or there’s consumer configured in route
definition. When **false** value is used, the engine is started at the
endpoint creation. When this parameter is missing, the value of
component’s property **lazyCreateEngines** is being used.

Example URIs:

    quickfix:config.cfg
    
    quickfix:config.cfg?sessionID=FIX.4.2:MyTradingCompany->SomeExchange
    
    quickfix:config.cfg?sessionID=FIX.4.2:MyTradingCompany->SomeExchange&lazyCreateEngine=true

# Endpoints

FIX sessions are endpoints for the **quickfix** component. An endpoint
URI may specify a single session or all sessions managed by a specific
QuickFIX/J engine. Typical applications will use only one FIX engine,
but advanced users may create multiple FIX engines by referencing
different configuration files in **quickfix** component endpoint URIs.

When a consumer does not include a session ID in the endpoint URI, it
will receive exchanges for all sessions managed by the FIX engine
associated with the configuration file specified in the URI. If a
producer does not specify a session in the endpoint URI, then it must
include the session-related fields in the FIX message being sent. If a
session is specified in the URI, then the component will automatically
inject the session-related fields into the FIX message.

The DataDictionary header is useful if string messages are being
received and need to be parsed in a route. QuickFIX/J requires a data
dictionary to parse certain types of messages (with repeating groups,
for example). By injecting a DataDictionary header in the route after
receiving a message string, the FIX engine can properly parse the data.

# QuickFIX/J Configuration Extensions

When using QuickFIX/J directly, one typically writes code to create
instances of logging adapters, message stores, and communication
connectors. The **quickfix** component will automatically create
instances of these classes based on information in the configuration
file. It also provides defaults for many of the commonly required
settings and adds additional capabilities (like the ability to activate
JMX support).

The following sections describe how the **quickfix** component processes
the QuickFIX/J configuration. For comprehensive information about
QuickFIX/J configuration, see the [QFJ user
manual](http://www.quickfixj.org/quickfixj/usermanual/usage/configuration.html).

## Communication Connectors

When the component detects an initiator or acceptor session setting in
the QuickFIX/J configuration file, it will automatically create the
corresponding initiator and/or acceptor connector. These settings can be
in the default or in a specific session section of the configuration
file.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Session Setting</th>
<th style="text-align: left;">Component Action</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>ConnectionType=initiator</code></p></td>
<td style="text-align: left;"><p>Create an initiator connector</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>ConnectionType=acceptor</code></p></td>
<td style="text-align: left;"><p>Create an acceptor connector</p></td>
</tr>
</tbody>
</table>

The threading model for the QuickFIX/J session connectors can also be
specified. These settings affect all sessions in the configuration file
and must be placed in the settings default section.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Default/Global Setting</th>
<th style="text-align: left;">Component Action</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>ThreadModel=ThreadPerConnector</code></p></td>
<td style="text-align: left;"><p>Use <code>SocketInitiator</code> or
<code>SocketAcceptor</code> (default)</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>ThreadModel=ThreadPerSession</code></p></td>
<td style="text-align: left;"><p>Use
<code>ThreadedSocketInitiator</code> or
<code>ThreadedSocketAcceptor</code></p></td>
</tr>
</tbody>
</table>

## Logging

The QuickFIX/J logger implementation can be specified by including the
following settings in the default section of the configuration file. The
`ScreenLog` is the default if none of the following settings are present
in the configuration. It’s an error to include settings that imply more
than one log implementation. The log factory implementation can also be
set directly on the Quickfix component. This will override any related
values in the QuickFIX/J settings file.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Default/Global Setting</th>
<th style="text-align: left;">Component Action</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>ScreenLogShowEvents</code></p></td>
<td style="text-align: left;"><p>Use a <code>ScreenLog</code></p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>ScreenLogShowIncoming</code></p></td>
<td style="text-align: left;"><p>Use a <code>ScreenLog</code></p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>ScreenLogShowOutgoing</code></p></td>
<td style="text-align: left;"><p>Use a <code>ScreenLog</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SLF4J*</code></p></td>
<td style="text-align: left;"><p>Use a <code>SLF4JLog</code>. Any of the
SLF4J settings will cause this log to be used.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>FileLogPath</code></p></td>
<td style="text-align: left;"><p>Use a <code>FileLog</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>JdbcDriver</code></p></td>
<td style="text-align: left;"><p>Use a <code>JdbcLog</code></p></td>
</tr>
</tbody>
</table>

## Message Store

The QuickFIX/J message store implementation can be specified by
including the following settings in the default section of the
configuration file. The `MemoryStore` is the default if none of the
following settings are present in the configuration. It’s an error to
include settings that imply more than one message store implementation.
The message store factory implementation can also be set directly on the
Quickfix component. This will override any related values in the
QuickFIX/J settings file.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Default/Global Setting</th>
<th style="text-align: left;">Component Action</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>JdbcDriver</code></p></td>
<td style="text-align: left;"><p>Use a <code>JdbcStore</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>FileStorePath</code></p></td>
<td style="text-align: left;"><p>Use a <code>FileStore</code></p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>SleepycatDatabaseDir</code></p></td>
<td style="text-align: left;"><p>Use a
<code>SleepcatStore</code></p></td>
</tr>
</tbody>
</table>

## Message Factory

A message factory is used to construct domain objects from raw FIX
messages. The default message factory is `DefaultMessageFactory`.
However, advanced applications may require a custom message factory.
This can be set on the QuickFIX/J component.

## JMX

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Default/Global Setting</th>
<th style="text-align: left;">Component Action</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>UseJmx</code></p></td>
<td style="text-align: left;"><p>if <code>Y</code>, then enable
QuickFIX/J JMX</p></td>
</tr>
</tbody>
</table>

## Other Defaults

The component provides some default settings for what are normally
required settings in QuickFIX/J configuration files. `SessionStartTime`
and `SessionEndTime` default to "00:00:00", meaning the session will not
be automatically started and stopped. The `HeartBtInt` (heartbeat
interval) defaults to 30 seconds.

## Minimal Initiator Configuration Example

    [SESSION]
    ConnectionType=initiator
    BeginString=FIX.4.4
    SenderCompID=YOUR_SENDER
    TargetCompID=YOUR_TARGET

# Using the InOut Message Exchange Pattern

Although the FIX protocol is event-driven and asynchronous, there are
specific pairs of messages that represent a request-reply message
exchange. To use an InOut exchange pattern, there should be a single
request message and single reply message to the request. Examples
include an OrderStatusRequest message and UserRequest.

## Implementing InOut Exchanges for Consumers

Add "exchangePattern=InOut" to the QuickFIX/J enpoint URI. The
`MessageOrderStatusService` in the example below is a bean with a
synchronous service method. The method returns the response to the
request (an ExecutionReport in this case) which is then sent back to the
requestor session.

        from("quickfix:examples/inprocess.qf.cfg?sessionID=FIX.4.2:MARKET->TRADER&exchangePattern=InOut")
            .filter(header(QuickfixjEndpoint.MESSAGE_TYPE_KEY).isEqualTo(MsgType.ORDER_STATUS_REQUEST))
            .bean(new MarketOrderStatusService());

## Implementing InOut Exchanges for Producers

For producers, sending a message will block until a reply is received or
a timeout occurs. There is no standard way to correlate reply messages
in FIX. Therefore, a correlation criteria must be defined for each type
of InOut exchange. The correlation criteria and timeout can be specified
using `Exchange` properties.

<table>
<colgroup>
<col style="width: 59%" />
<col style="width: 10%" />
<col style="width: 19%" />
<col style="width: 10%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Key String</th>
<th style="text-align: left;">Key Constant</th>
<th style="text-align: left;">Default</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>Correlation Criteria</p></td>
<td style="text-align: left;"><p>"CorrelationCriteria"</p></td>
<td
style="text-align: left;"><p>QuickfixjProducer.CORRELATION_CRITERIA_KEY</p></td>
<td style="text-align: left;"><p>None</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Correlation Timeout in
Milliseconds</p></td>
<td style="text-align: left;"><p>"CorrelationTimeout"</p></td>
<td
style="text-align: left;"><p>QuickfixjProducer.CORRELATION_TIMEOUT_KEY</p></td>
<td style="text-align: left;"><p>1000</p></td>
</tr>
</tbody>
</table>

The correlation criteria is defined with a `MessagePredicate` object.
The following example will treat a FIX ExecutionReport from the
specified session where the transaction type is STATUS and the Order ID
matches our request. The session ID should be for the *requestor*, the
sender and target CompID fields will be reversed when looking for the
reply.

    exchange.setProperty(QuickfixjProducer.CORRELATION_CRITERIA_KEY,
        new MessagePredicate(new SessionID(sessionID), MsgType.EXECUTION_REPORT)
            .withField(ExecTransType.FIELD, Integer.toString(ExecTransType.STATUS))
            .withField(OrderID.FIELD, request.getString(OrderID.FIELD)));

## Example

The source code contains an example called `RequestReplyExample` that
demonstrates the InOut exchanges for a consumer and producer. This
example creates a simple HTTP server endpoint that accepts order status
requests. The HTTP request is converted to a FIX
OrderStatusRequestMessage, is augmented with a correlation criteria, and
is then routed to a quickfix endpoint. The response is then converted to
a JSON-formatted string and sent back to the HTTP server endpoint to be
provided as the web response.

# Spring Configuration

The QuickFIX/J component includes a Spring `FactoryBean` for configuring
the session settings within a Spring context. A type converter for
QuickFIX/J session ID strings is also included. The following example
shows a simple configuration of an acceptor and initiator session with
default settings for both sessions.

    <!--  camel route  -->
    <camelContext xmlns="http://camel.apache.org/schema/spring" id="quickfixjContext">
        <route>
            <from uri="quickfix:example"/>
            <filter>
                <simple>${in.header.EventCategory} == 'AppMessageReceived'</simple>
                <to uri="log:test"/>
            </filter>
        </route>
    </camelContext>
            <!--  quickfix component  -->
    <bean id="quickfix" class="org.apache.camel.component.quickfixj.QuickfixjComponent">
    <property name="engineSettings">
        <util:map>
            <entry key="quickfix:example" value-ref="quickfixjSettings"/>
        </util:map>
    </property>
    <property name="messageFactory">
        <bean class="org.apache.camel.component.quickfixj.QuickfixjSpringTest.CustomMessageFactory"/>
    </property>
    </bean>
            <!--  quickfix settings  -->
    <bean id="quickfixjSettings" class="org.apache.camel.component.quickfixj.QuickfixjSettingsFactory">
    <property name="defaultSettings">
        <util:map>
            <entry key="SocketConnectProtocol" value="VM_PIPE"/>
            <entry key="SocketAcceptProtocol" value="VM_PIPE"/>
            <entry key="UseDataDictionary" value="N"/>
        </util:map>
    </property>
    <property name="sessionSettings">
        <util:map>
            <entry key="FIX.4.2:INITIATOR->ACCEPTOR">
                <util:map>
                    <entry key="ConnectionType" value="initiator"/>
                    <entry key="SocketConnectHost" value="localhost"/>
                    <entry key="SocketConnectPort" value="5000"/>
                </util:map>
            </entry>
            <entry key="FIX.4.2:ACCEPTOR->INITIATOR">
                <util:map>
                    <entry key="ConnectionType" value="acceptor"/>
                    <entry key="SocketAcceptPort" value="5000"/>
                </util:map>
            </entry>
        </util:map>
    </property>
    </bean>

The QuickFIX/J component includes a `QuickfixjConfiguration` class for
configuring the session settings. A type converter for QuickFIX/J
session ID strings is also included. The following example shows a
simple configuration of an acceptor and initiator session with default
settings for both sessions.

# Exception handling

QuickFIX/J behavior can be modified if certain exceptions are thrown
during processing of a message. If a `RejectLogon` exception is thrown
while processing an incoming logon administrative message, then the
logon will be rejected.

Normally, QuickFIX/J handles the logon process automatically. However,
sometimes an outgoing logon message must be modified to include
credentials required by a FIX counterparty. If the FIX logon message
body is modified when sending a logon message
(EventCategory=`AdminMessageSent` the modified message will be sent to
the counterparty. It is important that the outgoing logon message is
being processed *synchronously*. If it is processed asynchronously (on
another thread), the FIX engine will immediately send the unmodified
outgoing message when its callback method returns.

# FIX Sequence Number Management

If an application exception is thrown during *synchronous* exchange
processing, this will cause QuickFIX/J to not increment incoming FIX
message sequence numbers and will cause a resend of the counterparty
message. This FIX protocol behavior is primarily intended to handle
*transport* errors rather than application errors. There are risks
associated with using this mechanism to handle application errors. The
primary risk is that the message will repeatedly cause application
errors each time it’s re-received. A better solution is to persist the
incoming message (database, JMS queue) immediately before processing it.
This also allows the application to process messages asynchronously
without losing messages when errors occur.

Although it’s possible to send messages to a FIX session before it’s
logged on (the messages will be sent at logon time), it is usually a
better practice to wait until the session is logged on. This eliminates
the required sequence number resynchronization steps at logon. Waiting
for session logon can be done by setting up a route that processes the
`SessionLogon` event category and signals the application to start
sending messages.

See the FIX protocol specifications and the QuickFIX/J documentation for
more details about FIX sequence number management.

# Route Examples

Several examples are included in the QuickFIX/J component source code
(test subdirectories). One of these examples implements a trival trade
execution simulation. The example defines an application component that
uses the URI scheme "trade-executor".

The following route receives messages for the trade executor session and
passes application messages to the trade executor component.

    from("quickfix:examples/inprocess.qf.cfg?sessionID=FIX.4.2:MARKET->TRADER").
        filter(header(QuickfixjEndpoint.EVENT_CATEGORY_KEY).isEqualTo(QuickfixjEventCategory.AppMessageReceived)).
        to("trade-executor:market");

The trade executor component generates messages that are routed back to
the trade session. The session ID must be set in the FIX message itself
since no session ID is specified in the endpoint URI.

    from("trade-executor:market").to("quickfix:examples/inprocess.qf.cfg");

The trader session consumes execution report messages from the market
and processes them.

    from("quickfix:examples/inprocess.qf.cfg?sessionID=FIX.4.2:TRADER->MARKET").
        filter(header(QuickfixjEndpoint.MESSAGE_TYPE_KEY).isEqualTo(MsgType.EXECUTION_REPORT)).
        bean(new MyTradeExecutionProcessor());

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|eagerStopEngines|Whether to eager stop engines when there are no active consumer or producers using the engine. For example when stopping a route, then the engine can be stopped as well. And when the route is started, then the engine is started again. This can be turned off to only stop the engines when Camel is shutdown.|true|boolean|
|lazyCreateEngines|If set to true, the engines will be created and started when needed (when first message is send)|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|logFactory|To use the given LogFactory||object|
|messageFactory|To use the given MessageFactory||object|
|messageStoreFactory|To use the given MessageStoreFactory||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configurationName|Path to the quickfix configuration file. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the configuration file using these protocols (classpath is default). ref will lookup the configuration file in the registry. bean will call a method on a bean to be used as the configuration. For bean you can specify the method name after dot, eg bean:myBean.myMethod||string|
|lazyCreateEngine|This option allows creating QuickFIX/J engine on demand. Value true means the engine is started when first message is send or there's consumer configured in route definition. When false value is used, the engine is started at the endpoint creation. When this parameter is missing, the value of component's property lazyCreateEngines is being used.|false|boolean|
|sessionID|The optional sessionID identifies a specific FIX session. The format of the sessionID is: (BeginString):(SenderCompID)/(SenderSubID)/(SenderLocationID)-(TargetCompID)/(TargetSubID)/(TargetLocationID)||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
