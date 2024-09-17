# Kamelet-eip.md

Kamelets (Kamel route snippets) allow users to connect to external
systems via a simplified interface, hiding all the low-level details
about how those connections are implemented.

By default, calling kamelets should be done as
[endpoints](#message-endpoint.adoc) with the
[kamelet](#components::kamelet-component.adoc) component, such as
`to("kamelet:mykamelet")`.

The Kamelet EIP allows calling Kamelets (i.e., [Route
Template](#manual::route-template.adoc)), **for special use-cases**.

When a Kamelet is designed for a special use-case such as aggregating
messages, and returning a response message only when a group of
aggregated messages is completed. In other words, kamelet does not
return a response message for every incoming message. In special
situations like these, then you **must** use this Kamelet EIP instead of
using the [kamelet](#components::kamelet-component.adoc) component.

Given the following Kamelet (as a route template):

    routeTemplate("my-aggregate")
            .templateParameter("count")
            .from("kamelet:source")
            .aggregate(constant(true))
                .completionSize("{{count}}")
                .aggregationStrategy(AggregationStrategies.string(","))
                .to("log:aggregate")
                .to("kamelet:sink")
            .end();

Note how the route template above uses *kamelet:sink* as a special
endpoint to send out a result message. This is only done when the
[Aggregate EIP](#aggregate-eip.adoc) has completed a group of messages.

And the following route using the kamelet:

    from("direct:start")
        // this is not possible, you must use Kamelet EIP instead
        .to("kamelet:my-aggregate?count=5")
        .to("log:info")
        .to("mock:result");

Then this does not work, instead you **must** use Kamelet EIP instead:

    from("direct:start")
        .kamelet("my-aggregate?count=5")
        .to("log:info")
        .to("mock:result");

When calling a Kamelet, you may refer to the name (template id) of the
Kamelet in the EIP as shown below:

# Options

# Exchange properties

# Using Kamelet EIP

Java  
from("direct:start")
.kamelet("foo")
.to("mock:result");

XML  
<route>  
<from uri="direct:start"/>  
<kamelet name="foo"/>  
<to uri="mock:result"/>  
</route>

Camel will then, when starting:

-   Lookup the [Route Template](#manual::route-template.adoc) with the
    given id (in the example above its foo) from the `CamelContext`

-   Create a new route based on the [Route
    Template](#manual::route-template.adoc)

# Dependency

The implementation of the Kamelet EIP is located in the `camel-kamelet`
JAR, so you should add the following dependency:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-kamelet</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.y.z</version>
    </dependency>

# See Also

See the example
[camel-example-kamelet](https://github.com/apache/camel-examples/tree/main/kamelet).
