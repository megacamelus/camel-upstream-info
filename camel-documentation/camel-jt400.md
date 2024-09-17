# Jt400

**Since Camel 1.5**

**Both producer and consumer are supported**

The JT400 component allows you to exchange messages with an IBM i system
using data queues, message queues, or program call. IBM i is the
replacement for AS/400 and iSeries servers.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jt400</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

To send or receive data from a data queue

    jt400://user:password/system/QSYS.LIB/library.LIB/queue.DTAQ[?options]

To send or receive messages from a message queue

    jt400://user:password/system/QSYS.LIB/library.LIB/queue.MSGQ[?options]

To call program

    jt400://user:password/system/QSYS.LIB/library.LIB/program.PGM[?options]

# Usage

When configured as a data queue consumer endpoint, the endpoint will
poll a data queue on an IBM i system. For every entry on the data queue,
a new `Exchange` is sent with the entry’s data in the *In* message’s
body, formatted either as a `String` or a `byte[]`, depending on the
format.

For a data queue provider endpoint, the *In* message body contents will
be put on the data queue as either raw bytes or text.

When configured as a message queue consumer endpoint, the endpoint will
poll a message queue on an IBM i system. For every entry on the queue, a
new `Exchange` is sent with the entry’s data in the *In* message’s body.
The data is always formatted as a `String`. Note that only new messages
will be processed. That is, this endpoint will not process any existing
messages on the queue that have already been handled by another program.

For a message queue provider endpoint, the *In* message body contents
are presumed to be text and sent to the queue as an informational
message. Inquiry messages or messages requiring a message ID are not
supported.

## Connection pool

You can explicitly configure a connection pool on the Jt400Component, or
as an uri option on the endpoint.

## Program call

This endpoint expects the input to be an `Object[]`, whose object types
are `int`, `long`, `CharSequence` (such as `String`), or `byte[]`. All
other data types in the input array will be converted to `String`. For
character inputs, CCSID handling is performed through the native jt400
library mechanisms. A parameter can be *omitted* by passing null as the
value in its position (the program has to support it). After the program
execution, the endpoint returns an `Object[]` in the message body.
Depending on *format*, the returned array will be populated with
`byte[]` or `String` objects representing the values as they were
returned by the program. Input-only parameters will contain the same
data as the beginning of the invocation. This endpoint does not
implement a provider endpoint!

# Example

In the snippet below, the data for an exchange sent to the
`direct:george` endpoint will be put in the data queue `PENNYLANE` in
library `BEATLES` on a system named `LIVERPOOL`.  
Another user connects to the same data queue to receive the information
from the data queue and forward it to the `mock:ringo` endpoint.

    public class Jt400RouteBuilder extends RouteBuilder {
        @Override
        public void configure() throws Exception {
           from("direct:george").to("jt400://GEORGE:EGROEG@LIVERPOOL/QSYS.LIB/BEATLES.LIB/PENNYLANE.DTAQ");
           from("jt400://RINGO:OGNIR@LIVERPOOL/QSYS.LIB/BEATLES.LIB/PENNYLANE.DTAQ").to("mock:ringo");
        }
    }

## Program call examples

In the snippet below, the data Exchange sent to the direct:work endpoint
will contain three strings that will be used as the arguments for the
program “compute” in the library “assets”. This program will write the
output values in the second and third parameters. All the parameters
will be sent to the direct:play endpoint.

    public class Jt400RouteBuilder extends RouteBuilder {
        @Override
        public void configure() throws Exception {
           from("direct:work").to("jt400://GRUPO:ATWORK@server/QSYS.LIB/assets.LIB/compute.PGM?fieldsLength=10,10,512&ouputFieldsIdx=2,3").to("direct:play");
        }
    }

In this example, the camel route will call the QUSRTVUS API to retrieve
16 bytes from data area "MYUSRSPACE" in the "MYLIB" library.

    public class Jt400RouteBuilder extends RouteBuilder {
        @Override
        public void configure() throws Exception {
            from("timer://foo?period=60000")
            .process( exchange -> {
                String usrSpc = "MYUSRSPACEMYLIB     ";
                Object[] parms = new Object[] {
                    usrSpc, // Qualified user space name
                    1,      // starting position
                    16,     // length of data
                    "" // output
                };
                exchange.getIn().setBody(parms);
            })
            .to("jt400://*CURRENT:*CURRENt@localhost/qsys.lib/QUSRTVUS.PGM?fieldsLength=20,4,4,16&outputFieldsIdx=3")
            .setBody(simple("${body[3]}"))
            .to("direct:foo");
        }
    }

## Writing to keyed data queues

    from("jms:queue:input")
    .to("jt400://username:password@system/lib.lib/MSGINDQ.DTAQ?keyed=true");

## Reading from keyed data queues

    from("jt400://username:password@system/lib.lib/MSGOUTDQ.DTAQ?keyed=true&searchKey=MYKEY&searchType=GE")
    .to("jms:queue:output");

## Writing to message queues

    from("jms:queue:input")
    .to("jt400://username:password@system/lib.lib/MSGINQ.MSGQ");

## Reading from a message queue

    from("jt400://username:password@system/lib.lib/MSGOUTQ.MSGQ")
    .to("jms:queue:output");

## Replying to an inquiry message on a message queue

    from("jt400://username:password@localhost/qsys.lib/qusrsys.lib/myq.msgq?sendingReply=true")
    .choice()
        .when(header(Jt400Constants.MESSAGE_TYPE).isEqualTo(AS400Message.INQUIRY))
            .process((exchange) -> {
                String reply = // insert reply logic here
                exchange.getIn().setBody(reply);
            })
            .to("jt400://username:password@localhost/qsys.lib/qusrsys.lib/myq.msgq");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|connectionPool|Default connection pool used by the component. Note that this pool is lazily initialized. This is because in a scenario where the user always provides a pool, it would be wasteful for Camel to initialize and keep an idle pool.||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|userID|Returns the ID of the IBM i user.||string|
|password|Returns the password of the IBM i user.||string|
|systemName|Returns the name of the IBM i system.||string|
|objectPath|Returns the fully qualified integrated file system path name of the target object of this endpoint.||string|
|type|Whether to work with data queues or remote program call||object|
|ccsid|Sets the CCSID to use for the connection with the IBM i system.||integer|
|format|Sets the data format for sending messages.|text|object|
|guiAvailable|Sets whether IBM i prompting is enabled in the environment running Camel.|false|boolean|
|keyed|Whether to use keyed or non-keyed data queues.|false|boolean|
|searchKey|Search key for keyed data queues.||string|
|messageAction|Action to be taken on messages when read from a message queue. Messages can be marked as old (OLD), removed from the queue (REMOVE), or neither (SAME).|OLD|object|
|readTimeout|Timeout in millis the consumer will wait while trying to read a new message of the data queue.|30000|integer|
|searchType|Search type such as EQ for equal etc.|EQ|object|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|sendingReply|If true, the consumer endpoint will set the Jt400Constants.MESSAGE\_REPLYTO\_KEY header of the camel message for any IBM i inquiry messages received. If that message is then routed to a producer endpoint, the action will not be processed as sending a message to the queue, but rather a reply to the specific inquiry message.|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|outputFieldsIdxArray|Specifies which fields (program parameters) are output parameters.||object|
|outputFieldsLengthArray|Specifies the fields (program parameters) length as in the IBM i program definition.||object|
|procedureName|Procedure name from a service program to call||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
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
|secured|Whether connections to IBM i are secured with SSL.|false|boolean|
