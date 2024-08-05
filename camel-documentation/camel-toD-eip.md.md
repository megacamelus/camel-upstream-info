# ToD-eip.md

Camel supports the [Message
Endpoint](http://www.enterpriseintegrationpatterns.com/MessageEndpoint.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) using the
[Endpoint](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Endpoint.html)
interface.

How does an application connect to a messaging channel to send and
receive messages?

<figure>
<img src="eip/MessageEndpointSolution.gif" alt="image" />
</figure>

Connect an application to a messaging channel using a Message Endpoint,
a client of the messaging system that the application can then use to
send or receive messages.

In Camel the ToD EIP is used for sending [messages](#message.adoc) to
dynamic [endpoints](#message-endpoint.adoc).

The [To](#to-eip.adoc) and ToD EIPs are the most common patterns to use
in Camel [routes](#manual::routes.adoc).

# Options

# Exchange properties

# Different between To and ToD

The `to` is used for sending messages to a static
[endpoint](#message-endpoint.adoc). In other words `to` sends messages
only to the **same** endpoint.

The `toD` is used for sending messages to a dynamic
[endpoint](#message-endpoint.adoc). The dynamic endpoint is evaluated
*on-demand* by an [Expression](#manual::expression.adoc). By default,
the [Simple](#languages:simple-language.adoc) expression is used to
compute the dynamic endpoint URI.

# Using ToD

For example, to send a message to an endpoint which is dynamically
determined by a [message header](#message.adoc), you can do as shown
below:

Java  
from("direct:start")
.toD("${header.foo}");

XML  
<route>  
<from uri="direct:start"/>  
<toD uri="${header.foo}"/>  
</route>

You can also prefix the uri with a value because the endpoint
[URI](#manual::uris.adoc) is evaluated using the
[Simple](#languages:simple-language.adoc) language:

Java  
from("direct:start")
.toD("mock:${header.foo}");

XML  
<route>  
<from uri="direct:start"/>  
<toD uri="mock:${header.foo}"/>  
</route>

In the example above, we compute the dynamic endpoint with a prefix
"mock:" and then the header foo is appended. So, for example, if the
header foo has value order, then the endpoint is computed as
"mock:order".

## Using other languages with toD

You can also use other languages such as
[XPath](#languages:xpath-language.adoc). Doing this requires starting
with `language:` as shown below. If you do not specify `language:` then
the endpoint is a component name. And in some cases, there is both a
component and language with the same name such as xquery.

Java  
from("direct:start")
.toD("language:xpath:/order/@uri");

XML  
<route>  
<from uri="direct:start"/>  
<toD uri="language:xpath:/order/@uri"/>  
</route>

## Avoid creating endless dynamic endpoints that take up resources

When using dynamic computed endpoints with `toD` then you may compute a
lot of dynamic endpoints, which results in an overhead of resources in
use, by each dynamic endpoint uri, and its associated producer.

For example, HTTP-based endpoints where you may have dynamic values in
URI parameters when calling the HTTP service, such as:

    from("direct:login")
      .toD("http:myloginserver:8080/login?userid=${header.userName}");

In the example above then the parameter `userid` is dynamically
computed, and would result in one instance of endpoint and producer for
each different userid. To avoid having too many dynamic endpoints you
can configure `toD` to reduce its cache size, for example, to use a
cache size of 10:

Java  
from("direct:login")
.toD("http:myloginserver:8080/login?userid=${header.userName}", 10);

XML  
<route>  
<from uri="direct:login"/>  
<toD uri="http:myloginserver:8080/login?userid=${header.userName}" cacheSize="10"/>  
</route>

this will only reduce the endpoint cache of the `toD` that has a chance
of being reused in case a message is routed with the same `userName`
header. Therefore, reducing the cache size will not solve the *endless
dynamic endpoint* problem. Instead, you should use static endpoints with
`to` and provide the dynamic parts in Camel message headers (if
possible).

### Using static endpoints to avoid endless dynamic endpoints

In the example above then the parameter `userid` is dynamically
computed, and would result in one instance of endpoint and producer for
each different userid. To avoid having too dynamic endpoints, you use a
single static endpoint and use headers to provide the dynamic parts:

    from("direct:login")
      .setHeader(Exchange.HTTP_PATH, constant("/login"))
      .setHeader(Exchange.HTTP_QUERY, simple("userid=${header.userName}"))
      .toD("http:myloginserver:8080");

However, you can use optimized components for `toD` that can *solve*
this out of the box, as documented next.

## Using optimized components with toD

A better solution would be if the HTTP component could be optimized to
handle the variations of dynamic computed endpoint uris. This is with
among the following components, which have been optimized for `toD`:

-   camel-http

-   camel-jetty

-   camel-netty-http

-   camel-undertow

-   camel-vertx-http

A number of non-HTTP components has been optimized as well:

-   camel-amqp

-   camel-file

-   camel-ftp

-   camel-jms

-   camel-kafka

-   camel-paho-mqtt5

-   camel-paho

-   camel-sjms

-   camel-sjms2

-   camel-spring-rabbitmq

For the optimisation to work, then:

1.  The optimization is detected and activated during startup of the
    Camel routes with `toD`.

2.  The dynamic uri in `toD` must provide the component name as either
    static or resolved via [property
    placeholders](#manual::using-propertyplaceholder.adoc).

3.  The supported components must be on the classpath.

The HTTP based components will be optimized to use the same
hostname:port for each endpoint, and the dynamic values for context-path
and query parameters will be provided as headers:

For example, this route:

    from("direct:login")
      .toD("http:myloginserver:8080/login?userid=${header.userName}");

It Will essentially be optimized to (pseudo route):

    from("direct:login")
      .setHeader(Exchange.HTTP_PATH, expression("/login"))
      .setHeader(Exchange.HTTP_QUERY, expression("userid=${header.userName}"))
      .toD("http:myloginserver:8080")
      .removeHeader(Exchange.HTTP_PATH)
      .removeHeader(Exchange.HTTP_QUERY);

Where *expression* will be evaluated dynamically. Notice how the uri in
`toD` is now static (`http:myloginserver:8080`). This optimization
allows Camel to reuse the same endpoint and its associated producer for
all dynamic variations. This yields much lower resource overhead as the
same http producer will be used for all the different variations of
`userids`.

When the optimized component is in use, then you cannot use the headers
`Exchange.HTTP_PATH` and `Exchange.HTTP_QUERY` to provide dynamic values
to override the uri in `toD`. If you want to use these headers, then use
the plain `to` DSL instead. In other words these headers are used
internally by `toD` to carry the dynamic details of the endpoint.

In case of problems then you can turn on DEBUG logging level on
`org.apache.camel.processor.SendDynamicProcessor` which will log during
startup if `toD` was optimized, or if there was a failure loading the
optimized component, with a stacktrace logged.

    Detected SendDynamicAware component: http optimising toD: http:myloginserver:8080/login?userid=${header.userName}
