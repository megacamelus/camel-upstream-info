# Kamelet

**Since Camel 3.8**

**Both producer and consumer are supported**

The Kamelet Component provides support for interacting with the [Camel
Route Template](#manual::route-template.adoc) engine using Endpoint
semantic.

# URI format

    kamelet:templateId/routeId[?options]

The **kamelet** endpoint is **lenient**, which means that the endpoint
accepts additional parameters that are passed to the [Route
Template](#manual::route-template.adoc) engine and consumed upon route
materialization.

# Usage

## Discovery

If a [Route Template](#manual::route-template.adoc) is not found, the
**kamelet** endpoint tries to load the related **kamelet** definition
from the file system (by default `classpath:kamelets`). The default
resolution mechanism expects *Kamelets* files to have the extension
`.kamelet.yaml`.

# Examples

*Kamelets* can be used as if they were standard Camel components. For
example, suppose that we have created a Route Template as follows:

    routeTemplate("setMyBody")
        .templateParameter("bodyValue")
        .from("kamelet:source")
            .setBody().constant("{{bodyValue}}");

To let the **Kamelet** component wiring the materialized route to the
caller processor, we need to be able to identify the input and output
endpoint of the route and this is done by using `kamelet:source` to mark
the input endpoint and `kamelet:sink` for the output endpoint.

Then the template can be instantiated and invoked as shown below:

    from("direct:setMyBody")
        .to("kamelet:setMyBody?bodyValue=myKamelet");

Behind the scenes, the **Kamelet** component does the following things:

1.  it instantiates a route out of the Route Template identified by the
    given `templateId` path parameter (in this case `setMyBody`)

2.  it will act like the `direct` component and connect the current
    route to the materialized one.

If you had to do it programmatically, it would have been something like:

    routeTemplate("setMyBody")
        .templateParameter("bodyValue")
        .from("direct:{{foo}}")
            .setBody().constant("{{bodyValue}}");
    
    TemplatedRouteBuilder.builder(context, "setMyBody")
        .parameter("foo", "bar")
        .parameter("bodyValue", "myKamelet")
        .add();
    
    from("direct:template")
        .to("direct:bar");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|location|The location(s) of the Kamelets on the file system. Multiple locations can be set separated by comma.|classpath:kamelets|string|
|routeProperties|Set route local parameters.||object|
|templateProperties|Set template local parameters.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|block|If sending a message to a kamelet endpoint which has no active consumer, then we can tell the producer to block and wait for the consumer to become active.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|timeout|The timeout value to use if block is enabled.|30000|integer|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|noErrorHandler|Kamelets, by default, will not do fine-grained error handling, but works in no-error-handler mode. This can be turned off, to use old behaviour in earlier versions of Camel.|true|boolean|
|routeTemplateLoaderListener|To plugin a custom listener for when the Kamelet component is loading Kamelets from external resources.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|templateId|The Route Template ID||string|
|routeId|The Route ID. Default value notice: The ID will be auto-generated if not provided||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|block|If sending a message to a direct endpoint which has no active consumer, then we can tell the producer to block and wait for the consumer to become active.|true|boolean|
|failIfNoConsumers|Whether the producer should fail by throwing an exception, when sending to a kamelet endpoint with no active consumers.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|timeout|The timeout value to use if block is enabled.|30000|integer|
|location|Location of the Kamelet to use which can be specified as a resource from file system, classpath etc. The location cannot use wildcards, and must refer to a file including extension, for example file:/etc/foo-kamelet.xml||string|
|noErrorHandler|Kamelets, by default, will not do fine-grained error handling, but works in no-error-handler mode. This can be turned off, to use old behaviour in earlier versions of Camel.|true|boolean|
