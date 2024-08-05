# Intercept.md

The intercept feature in Camel supports intercepting
[Exchange](#manual::exchange.adoc)*s* while they are being routed.

# Kinds of interceptors

Camel supports three kinds of interceptors:

-   [`intercept`](#Intercept-Intercept) that intercepts every processing
    step as they happen during routing

-   [`interceptFrom`](#Intercept-InterceptFrom) that intercepts only the
    incoming step (i.e., [from](#from-eip.adoc))

-   [`interceptSendToEndpoint`](#Intercept-InterceptSendToEndpoint) that
    intercepts only when an [Exchange](#manual::exchange.adoc) is about
    to be sent to the given [endpoint](#message-endpoint.adoc).

The `interceptSendToEndpoint` is dynamic hence it will also trigger if a
dynamic URI is constructed that Camel was not aware of at startup time.

The `interceptFrom` is not dynamic, and will only intercept all the
known routes when Camel is starting. So if you construct a `Consumer`
using the Camel Java API and consumes messages from this endpoint, then
the `interceptFrom` is not triggered.

## Interceptor scopes

All the interceptors can be configured on global, or with [Route
Configuration](#manual::route-configuration.adoc).

## Common features of the interceptors

All these interceptors support the following features:

-   [Predicate](#manual::predicate.adoc) using `when` to only trigger
    the interceptor in certain conditions

-   `stop` forces stopping continue routing the Exchange and mark it as
    completed successful (it’s actually the [Stop](#stop-eip.adoc) EIP).

-   `skip` when used with `interceptSendToEndpoint` will **skip**
    sending the message to the original intended endpoint.

-   `afterUri` when used with `interceptSendToEndpoint` allows to send
    the message to an [endpoint](#message-endpoint.adoc) afterward.

-   `interceptFrom` and `interceptSendToEndpoint` support endpoint URI
    pattern matching by exact uri, wildcard and regular expression. See
    further below for more details.

-   The intercepted endpoint uri is stored as exchange property with the
    key `Exchange.INTERCEPTED_ENDPOINT`.

# Using `intercept`

The `Intercept` is intercepting the [Exchange](#manual::exchange.adoc)
on every processing step during routing.

Given the following example:

Java  
// global interceptor for all routes
intercept().to("log:hello");

    from("jms:queue:order")
      .to("bean:validateOrder")
      .to("bean:processOrder");

XML  
<camelContext>

      <!-- global interceptor for all routes -->
      <intercept>
        <to uri="log:hello"/>
      </intercept>
    
      <route>
        <from uri="jms:queue:order"/>
        <to uri="bean:validateOrder"/>
        <to uri="bean:processOrder"/>
      </route>
    
    </camelContext>

What happens is that the `Exchange` is intercepted before each
processing step, that means that it will be intercepted before

-   `.to("bean:validateOrder")`

-   `.to("bean:processOrder")`

So in this example we intercept the `Exchange` twice.

## Controlling when to intercept using a predicate

If you only want to intercept "sometimes", then you can use a
[predicate](#manual::predicate.adoc).

For instance, in the sample below, we only intercept if the message body
contains the string word Hello:

Java  
intercept().when(body().contains("Hello")).to("mock:intercepted");

    from("jms:queue:order")
      .to("bean:validateOrder")
      .to("bean:processOrder");

XML  
<camelContext>

      <intercept>
          <when>
              <simple>${in.body} contains 'Hello'</simple>
          </when>
          <to uri="mock:intercepted"/>
      </intercept>
    
      <route>
        <from uri="jms:queue:order"/>
        <to uri="bean:validateOrder"/>
        <to uri="bean:processOrder"/>
      </route>
    
    </camelContext>

## Stop routing after being intercepted

It is also possible to stop routing after being intercepted. Now suppose
that if the message body contains the word Hello we want to log and
stop, then we can do:

Java  
intercept().when(body().contains("Hello"))
.to("log:test")
.stop(); // stop continue routing

    from("jms:queue:order")
      .to("bean:validateOrder")
      .to("bean:processOrder");

XML  
<camelContext>

      <intercept>
          <when>
            <simple>${body} contains 'Hello'</simple>
            <to uri="log:test"/>
            <stop/> <!-- stop continue routing -->
          </when>
      </intercept>
    
      <route>
        <from uri="jms:queue:order"/>
        <to uri="bean:validateOrder"/>
        <to uri="bean:processOrder"/>
      </route>
    
    </camelContext>

# Using `interceptFrom`

The `interceptFrom` is for intercepting any incoming Exchange, in any
route (it intercepts all the [`from`](#from-eip.adoc) EIPs)

This allows you to do some custom behavior for received Exchanges. You
can provide a specific uri for a given Endpoint then it only applies for
that particular route.

So let’s start with the logging example. We want to log all the incoming
messages, so we use `interceptFrom` to route to the
[Log](#ROOT:log-component.adoc) component.

Java  
interceptFrom()
.to("log:incoming");

    from("jms:queue:order")
      .to("bean:validateOrder")
      .to("bean:processOrder");

XML  
<camelContext>

      <intercept>
        <to uri="log:incoming"/>
      </intercept>
    
      <route>
        <from uri="jms:queue:order"/>
        <to uri="bean:validateOrder"/>
        <to uri="bean:processOrder"/>
      </route>
    
    </camelContext>

If you want to only apply a specific endpoint, such as all jms
endpoints, you can do:

Java  
interceptFrom("jms\*")
.to("log:incoming");

    from("jms:queue:order")
      .to("bean:validateOrder")
      .to("bean:processOrder");
    
    from("file:inbox")
      .to("ftp:someserver/backup")

XML  
<camelContext>

      <interceptFrom uri="jms*">
        <to uri="log:incoming"/>
      </intercept>
    
      <route>
        <from uri="jms:queue:order"/>
        <to uri="bean:validateOrder"/>
        <to uri="bean:processOrder"/>
      </route>
      <route>
        <from uri="file:inbox"/>
        <to uri="ftp:someserver/backup"/>
      </route>
    
    </camelContext>

In this example then only messages from the JMS route are intercepted,
because we specified a pattern in the `interceptFrom` as `jms*` (uses a
wildcard).

The pattern syntax is documented in more details later.

# Using `interceptSendToEndpoint`

You can also intercept when Apache Camel is sending a message to an
[endpoint](#message-endpoint.adoc).

This can be used to do some custom processing before the message is sent
to the intended destination.

The interceptor can also be configured to not send to the destination
(`skip`) which means the message is detoured instead.

A [Predicate](#manual::predicate.adoc) can also be used to control when
to intercept, which has been previously covered.

The `afterUri` option, is used when you need to process the response
message from the intended destination. This functionality was added
later to the interceptor, in a way of sending to yet another
[endpoint](#message-endpoint.adoc).

Let’s start with a basic example, where we want to intercept when a
message is being sent to [kafka](#ROOT:kafka-component.adoc):

Java  
interceptSendToEndpoint("kafka\*")
.to("bean:beforeKafka");

    from("jms:queue:order")
      .to("bean:validateOrder")
      .to("bean:processOrder")
      .to("kafka:order");

XML  
<camelContext>

      <interceptSendToEndpoint uri="kafka*">
        <to uri="bean:beforeKafka"/>
      </interceptSendToEndpoint>
    
      <route>
        <from uri="jms:queue:order"/>
        <to uri="bean:validateOrder"/>
        <to uri="bean:processOrder"/>
        <to uri="kafka:order"/>
      </route>
    
    </camelContext>

When you also want to process the message after it has been sent to the
intended destination, then the example is slightly *odd* because you
have to use the `afterUri` as shown:

Java  
interceptSendToEndpoint("kafka\*")
.to("bean:beforeKafka")
.afterUri("bean:afterKafka");

    from("jms:queue:order")
      .to("bean:validateOrder")
      .to("bean:processOrder")
      .to("kafka:order");

XML  
<camelContext>

      <interceptSendToEndpoint uri="kafka*" afterUri="bean:afterKafka">
        <to uri="bean:beforeKafka"/>
      </interceptSendToEndpoint>
    
      <route>
        <from uri="jms:queue:order"/>
        <to uri="bean:validateOrder"/>
        <to uri="bean:processOrder"/>
        <to uri="kafka:order"/>
      </route>
    
    </camelContext>

## Skip sending to original endpoint

Sometimes you want to **intercept and skip** sending messages to a
specific endpoint.

For example, to avoid sending any message to kafka, but detour them to a
[mock](#ROOT:mock-component.adoc) endpoint, it can be done as follows:

Java  
interceptSendToEndpoint("kafka\*").skipSendToOriginalEndpoint()
.to("mock:kafka");

    from("jms:queue:order")
      .to("bean:validateOrder")
      .to("bean:processOrder")
      .to("kafka:order");

XML  
<camelContext>

      <interceptSendToEndpoint uri="kafka*" skipSendToOriginalEndpoint="true">
        <to uri="mock:kafka"/>
      </interceptSendToEndpoint>
    
      <route>
        <from uri="jms:queue:order"/>
        <to uri="bean:validateOrder"/>
        <to uri="bean:processOrder"/>
        <to uri="kafka:order"/>
      </route>
    
    </camelContext>

## Conditional skipping sending to endpoint

You can combine both a [predicate](#manual::predicate.adoc) and skip
sending to the original endpoint. For example, suppose you have some
"test" messages that sometimes occur, and that you want to avoid sending
these messages to a downstream kafka system, then this can be done as
shown:

Java  
interceptSendToEndpoint("kafka\*").skipSendToOriginalEndpoint()
.when(simple("${header.biztype} == 'TEST'")
.log("TEST message detected - is NOT send to kafka");

    from("jms:queue:order")
      .to("bean:validateOrder")
      .to("bean:processOrder")
      .to("kafka:order");

XML  
<camelContext>

      <interceptSendToEndpoint uri="kafka*" skipSendToOriginalEndpoint="true">
        <when><simple>${header.biztype} == 'TEST'</simple></when>
        <log message="TEST message detected - is NOT send to kafka"/>
      </interceptSendToEndpoint>
    
      <route>
        <from uri="jms:queue:order"/>
        <to uri="bean:validateOrder"/>
        <to uri="bean:processOrder"/>
        <to uri="kafka:order"/>
      </route>
    
    </camelContext>

# Intercepting endpoints using pattern matching

The `interceptFrom` and `interceptSendToEndpoint` support endpoint
pattern matching by the following rules in the given order:

-   match by exact URI name

-   match by wildcard

-   match by regular expression

## Intercepting when matching by exact URI

This matches only a specific endpoint with exactly the same URI.

For example, to intercept messages being sent to a specific JMS queue,
you can do:

    interceptSendToEndpoint("jms:queue:cheese").to("log:smelly");

## Intercepting when matching endpoints by wildcard

Match by wildcard allows you to match a range of endpoints or all of a
given type. For instance use `file:*` will match all
[file-based](#ROOT:file-component.adoc) endpoints.

    interceptFrom("file:*").to("log:from-file");

Match by wildcard works so that the pattern ends with a `\*` and that
the uri matches if it starts with the same pattern.

For example, you can be more specific, to only match for files from
specific folders like:

    interceptFrom("file:order/inbox/*").to("log:new-file-orders");

## Intercepting when matching endpoints by regular expression

Match by regular expression is just like match by wildcard but using
regex instead. So if we want to intercept incoming messages from gold
and silver JMS queues, we can do:

    interceptFrom("jms:queue:(gold|silver)").to("seda:handleFast");
