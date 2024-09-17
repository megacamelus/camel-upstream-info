# Xquery

**Since Camel 1.0**

**Both producer and consumer are supported**

Camel supports [XQuery](http://www.w3.org/TR/xquery/) component for
message transformation

# Examples

    from("queue:foo")
      .filter().xquery("//foo")
        .to("queue:bar")

You can also use functions inside your query, in which case you need an
explicit type conversion (otherwise you will get a
`org.w3c.dom.DOMException: HIERARCHY_REQUEST_ERR`), by passing the Class
as a second argument to the **xquery()** method.

    from("direct:start")
      .recipientList().xquery("concat('mock:foo.', /person/@city)", String.class);

# Usage

## Variables

The IN message body will be set as the `contextItem`. Besides this,
these Variables are also added as parameters:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Variable</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>exchange</code></p></td>
<td style="text-align: left;"><p>Exchange</p></td>
<td style="text-align: left;"><p>The current Exchange</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>in.body</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>The In message’s body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>out.body</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>The OUT message’s body (if
any)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>in.headers.*</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>You can access the value of
exchange.in.headers with key <strong>foo</strong> by using the variable
which name is in.headers.foo</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>out.headers.*</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>You can access the value of
exchange.out.headers with key <strong>foo</strong> by using the variable
which name is out.headers.foo variable</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>*key name*</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Any exchange.properties and
exchange.in.headers and any additional parameters set using
<code>setParameters(Map)</code>. These parameters are added with their
own key name, for instance, if there is an IN header with the key name
<strong>foo</strong> then it is added as <strong>foo</strong>.</p></td>
</tr>
</tbody>
</table>

## Using XML configuration

If you prefer to configure your routes in your Spring XML file, then you
can use XPath expressions as follows

    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:foo="http://example.com/person"
           xsi:schemaLocation="
           http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
           http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd">
    
      <camelContext id="camel" xmlns="http://activemq.apache.org/camel/schema/spring">
        <route>
          <from uri="activemq:MyQueue"/>
          <filter>
            <xquery>/foo:person[@name='James']</xquery>
            <to uri="mqseries:SomeOtherQueue"/>
          </filter>
        </route>
      </camelContext>
    </beans>

Notice how we can reuse the namespace prefixes, **foo** in this case, in
the XPath expression for easier namespace-based XQuery expressions!

When you use functions in your XQuery expression, you need an explicit
type conversion which is done in the xml configuration via the **@type**
attribute:

    <xquery resultType="java.lang.String">concat('mock:foo.', /person/@city)</xquery>

## Using XQuery as an endpoint

Sometimes an XQuery expression can be quite large; it can essentally be
used for Templating. So you may want to use an XQuery Endpoint, so you
can route using XQuery templates.

The following example shows how to take a message of an ActiveMQ queue
(MyQueue) and transform it using XQuery and send it to MQSeries.

      <camelContext id="camel" xmlns="http://camel.apache.org/schema/spring">
        <route>
          <from uri="activemq:MyQueue"/>
          <to uri="xquery:com/acme/someTransform.xquery"/>
          <to uri="mqseries:SomeOtherQueue"/>
        </route>
      </camelContext>

## Loading script from external resource

You can externalize the script and have Apache Camel load it from a
resource such as `"classpath:"`, `"file:"`, or `"http:"`. This is done
using the following syntax: `"resource:scheme:location"`, e.g., to refer
to a file on the classpath you can do:

    .setHeader("myHeader").xquery("resource:classpath:myxquery.txt", String.class)

## Learning XQuery

XQuery is a very powerful language for querying, searching, sorting and
returning XML. For help learning XQuery, try these tutorials

-   Mike Kay’s [XQuery
    Primer](http://www.stylusstudio.com/xquery_primer.html)

-   The W3Schools [XQuery
    Tutorial](https://www.w3schools.com/xml/xquery_intro.asp)

# Dependencies

To use XQuery in your Camel routes, you need to add the dependency on
**camel-saxon**, which implements the XQuery language.

If you use Maven, you could add the following to your `pom.xml`,
substituting the version number for the latest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-saxon</artifactId>
      <version>x.x.x</version>
    </dependency>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|To use a custom Saxon configuration||object|
|configurationProperties|To set custom Saxon configuration properties||object|
|moduleURIResolver|To use the custom ModuleURIResolver||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|The name of the template to load from classpath or file system||string|
|allowStAX|Whether to allow using StAX mode|false|boolean|
|namespacePrefixes|Allows to control which namespace prefixes to use for a set of namespace mappings||object|
|resultsFormat|What output result to use|DOM|object|
|resultType|What output result to use defined as a class||string|
|source|Source to use, instead of message body. You can prefix with variable:, header:, or property: to specify kind of source. Otherwise, the source is assumed to be a variable. Use empty or null to use default source, which is the message body.||string|
|stripsAllWhiteSpace|Whether to strip all whitespaces|true|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|configuration|To use a custom Saxon configuration||object|
|configurationProperties|To set custom Saxon configuration properties||object|
|moduleURIResolver|To use the custom ModuleURIResolver||object|
|parameters|Additional parameters||object|
|properties|Properties to configure the serialization parameters||object|
|staticQueryContext|To use a custom Saxon StaticQueryContext||object|
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
