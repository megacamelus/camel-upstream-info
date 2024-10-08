# Log

**Since Camel 1.1**

**Only producer is supported**

The Log component logs message exchanges to the underlying logging
mechanism.

Camel uses [SLF4J](http://www.slf4j.org/), which allows you to configure
logging via, among others:

-   Log4j

-   Logback

-   Java Util Logging

# URI format

    log:loggingCategory[?options]

Where **loggingCategory** is the name of the logging category to use.
You can append query options to the URI in the following format,
`?option=value&option=value&...`

**Using Logger instance from the Registry**

If there’s single instance of `org.slf4j.Logger` found in the Registry,
the **loggingCategory** is no longer used to create logger instance. The
registered instance is used instead. Also, it is possible to reference
particular `Logger` instance using `?logger=#myLogger` URI parameter.
Eventually, if there’s no registered and URI `logger` parameter, the
logger instance is created using **loggingCategory**.

For example, a log endpoint typically specifies the logging level using
the `level` option, as follows:

    log:org.apache.camel.example?level=DEBUG

The default logger logs every exchange (*regular logging*). But Camel
also ships with the `Throughput` logger, which is used whenever the
`groupSize` option is specified.

There is also a `log` directly in the DSL, but it has a different
purpose. It’s meant for lightweight and human logs. See more details at
[LogEIP](#eips:log-eip.adoc).

# Examples

## Regular logger example

In the route below we log the incoming orders at `DEBUG` level before
the order is processed:

    from("activemq:orders").to("log:com.mycompany.order?level=DEBUG").to("bean:processOrder");

Or using Spring XML to define the route:

    <route>
      <from uri="activemq:orders"/>
      <to uri="log:com.mycompany.order?level=DEBUG"/>
      <to uri="bean:processOrder"/>
    </route>

## Regular logger with formatter example

In the route below we log the incoming orders at `INFO` level before the
order is processed.

    from("activemq:orders").
        to("log:com.mycompany.order?showAll=true&multiline=true").to("bean:processOrder");

## Throughput logger with groupSize example

In the route below we log the throughput of the incoming orders at
`DEBUG` level grouped by 10 messages.

    from("activemq:orders").
        to("log:com.mycompany.order?level=DEBUG&groupSize=10").to("bean:processOrder");

## Throughput logger with groupInterval example

This route will result in message stats logged every 10s, with an
initial 60s delay, and stats should be displayed even if there isn’t any
message traffic.

    from("activemq:orders").
        to("log:com.mycompany.order?level=DEBUG&groupInterval=10000&groupDelay=60000&groupActiveOnly=false").to("bean:processOrder");

The following will be logged:

    "Received: 1000 new messages, with total 2000 so far. Last group took: 10000 millis which is: 100 messages per second. average: 100"

## Masking sensitive information like password

You can enable security masking for logging by setting `logMask` flag to
`true`. Note that this option also affects Log EIP.

To enable mask in Java DSL at CamelContext level:

    camelContext.setLogMask(true);

And in XML:

    <camelContext logMask="true">

You can also turn it on\|off at endpoint level. To enable mask in Java
DSL at endpoint level, add logMask=true option in the URI for the log
endpoint:

    from("direct:start").to("log:foo?logMask=true");

And in XML:

    <route>
      <from uri="direct:foo"/>
      <to uri="log:foo?logMask=true"/>
    </route>

`org.apache.camel.support.processor.DefaultMaskingFormatter` is used for
the masking by default. If you want to use a custom masking formatter,
put it into registry with the name `CamelCustomLogMask`. Note that the
masking formatter must implement
`org.apache.camel.spi.MaskingFormatter`.

## Full customization of the logging output

With the options outlined in the [#Formatting](#log-component.adoc)
section, you can control much of the output of the logger. However, log
lines will always follow this structure:

    Exchange[Id:ID-machine-local-50656-1234567901234-1-2, ExchangePattern:InOut,
    Properties:{CamelToEndpoint=log://org.apache.camel.component.log.TEST?showAll=true,
    CamelCreatedTimestamp=Thu Mar 28 00:00:00 WET 2013},
    Headers:{breadcrumbId=ID-machine-local-50656-1234567901234-1-1}, BodyType:String, Body:Hello World, Out: null]

This format is unsuitable in some cases, perhaps because you need to…

-   … filter the headers and properties that are printed, to strike a
    balance between insight and verbosity.

-   … adjust the log message to whatever you deem most readable.

-   … tailor log messages for digestion by log mining systems, e.g.
    Splunk.

-   … print specific body types differently.

-   … etc.

Whenever you require absolute customization, you can create a class that
implements the
[`ExchangeFormatter`](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/spi/ExchangeFormatter.html)
interface. Within the `format(Exchange)` method you have access to the
full Exchange, so you can select and extract the precise information you
need, format it in a custom manner and return it. The return value will
become the final log message.

You can have the Log component pick up your custom `ExchangeFormatter`
in either of two ways:

**Explicitly instantiating the LogComponent in your Registry:**

    <bean name="log" class="org.apache.camel.component.log.LogComponent">
       <property name="exchangeFormatter" ref="myCustomFormatter" />
    </bean>

### Convention over configuration:\*

Simply by registering a bean with the name `logFormatter`; the Log
Component is intelligent enough to pick it up automatically.

    <bean name="logFormatter" class="com.xyz.MyCustomExchangeFormatter" />

The `ExchangeFormatter` gets applied to **all Log endpoints within that
Camel Context**. If you need different ExchangeFormatters for different
endpoints, instantiate the LogComponent as many times as needed, and use
the relevant bean name as the endpoint prefix.

When using a custom log formatter, you can specify parameters in the log
uri, which gets configured on the custom log formatter. Though when you
do that, you should define the "logFormatter" as prototype scoped, so
it’s not shared if you have different parameters, e.g.:

    <bean name="logFormatter" class="com.xyz.MyCustomExchangeFormatter" scope="prototype"/>

And then we can have Camel routes using the log uri with different
options:

    <to uri="log:foo?param1=foo&amp;param2=100"/>
    
    <to uri="log:bar?param1=bar&amp;param2=200"/>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|sourceLocationLoggerName|If enabled then the source location of where the log endpoint is used in Camel routes, would be used as logger name, instead of the given name. However, if the source location is disabled or not possible to resolve then the existing logger name will be used.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|exchangeFormatter|Sets a custom ExchangeFormatter to convert the Exchange to a String suitable for logging. If not specified, we default to DefaultExchangeFormatter.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|loggerName|Name of the logging category to use||string|
|groupActiveOnly|If true, will hide stats when no new messages have been received for a time interval, if false, show stats regardless of message traffic.|true|boolean|
|groupDelay|Set the initial delay for stats (in millis)||integer|
|groupInterval|If specified will group message stats by this time interval (in millis)||integer|
|groupSize|An integer that specifies a group size for throughput logging.||integer|
|level|Logging level to use. The default value is INFO.|INFO|string|
|logMask|If true, mask sensitive information like password or passphrase in the log.||boolean|
|marker|An optional Marker name to use.||string|
|plain|If enabled only the body will be printed out|false|boolean|
|sourceLocationLoggerName|If enabled then the source location of where the log endpoint is used in Camel routes, would be used as logger name, instead of the given name. However, if the source location is disabled or not possible to resolve then the existing logger name will be used.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|exchangeFormatter|To use a custom exchange formatter||object|
|maxChars|Limits the number of characters logged per line.|10000|integer|
|multiline|If enabled then each information is outputted on a newline.|false|boolean|
|showAll|Quick option for turning all options on. (multiline, maxChars has to be manually set if to be used)|false|boolean|
|showAllProperties|Show all of the exchange properties (both internal and custom).|false|boolean|
|showBody|Show the message body.|true|boolean|
|showBodyType|Show the body Java type.|true|boolean|
|showCachedStreams|Whether Camel should show cached stream bodies or not (org.apache.camel.StreamCache).|true|boolean|
|showCaughtException|If the exchange has a caught exception, show the exception message (no stack trace). A caught exception is stored as a property on the exchange (using the key org.apache.camel.Exchange#EXCEPTION\_CAUGHT) and for instance a doCatch can catch exceptions.|false|boolean|
|showException|If the exchange has an exception, show the exception message (no stacktrace)|false|boolean|
|showExchangeId|Show the unique exchange ID.|false|boolean|
|showExchangePattern|Shows the Message Exchange Pattern (or MEP for short).|false|boolean|
|showFiles|If enabled Camel will output files|false|boolean|
|showFuture|If enabled Camel will on Future objects wait for it to complete to obtain the payload to be logged.|false|boolean|
|showHeaders|Show the message headers.|false|boolean|
|showProperties|Show the exchange properties (only custom). Use showAllProperties to show both internal and custom properties.|false|boolean|
|showRouteGroup|Show route Group.|false|boolean|
|showRouteId|Show route ID.|false|boolean|
|showStackTrace|Show the stack trace, if an exchange has an exception. Only effective if one of showAll, showException or showCaughtException are enabled.|false|boolean|
|showStreams|Whether Camel should show stream bodies or not (eg such as java.io.InputStream). Beware if you enable this option then you may not be able later to access the message body as the stream have already been read by this logger. To remedy this you will have to use Stream Caching.|false|boolean|
|showVariables|Show the variables.|false|boolean|
|skipBodyLineSeparator|Whether to skip line separators when logging the message body. This allows to log the message body in one line, setting this option to false will preserve any line separators from the body, which then will log the body as is.|true|boolean|
|style|Sets the outputs style to use.|Default|object|
