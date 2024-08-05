# Webhook

**Since Camel 3.0**

**Only consumer is supported**

The Webhook meta-component allows other Camel components to configure
webhooks on a remote webhook provider and listen for them.

-   [Camel Telegram](#telegram-component.adoc)

-   [Camel WhatsApp](#whatsapp-component.adoc)

Maven users can add the following dependency to their `pom.xml` for this
component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-webhook</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

Typically, other components that support webhook will bring this
dependency transitively.

# URI Format

    webhook:endpoint[?options]

# Examples

Examples of the webhook component are provided in the documentation of
the delegate components that support it.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|webhookAutoRegister|Automatically register the webhook at startup and unregister it on shutdown.|true|boolean|
|webhookBasePath|The first (base) path element where the webhook will be exposed. It's a good practice to set it to a random string, so that it cannot be guessed by unauthorized parties.||string|
|webhookComponentName|The Camel Rest component to use for the REST transport, such as netty-http.||string|
|webhookExternalUrl|The URL of the current service as seen by the webhook provider||string|
|webhookPath|The path where the webhook endpoint will be exposed (relative to basePath, if any)||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|Set the default configuration for the webhook meta-component.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|endpointUri|The delegate uri. Must belong to a component that supports webhooks.||string|
|webhookAutoRegister|Automatically register the webhook at startup and unregister it on shutdown.|true|boolean|
|webhookBasePath|The first (base) path element where the webhook will be exposed. It's a good practice to set it to a random string, so that it cannot be guessed by unauthorized parties.||string|
|webhookComponentName|The Camel Rest component to use for the REST transport, such as netty-http.||string|
|webhookExternalUrl|The URL of the current service as seen by the webhook provider||string|
|webhookPath|The path where the webhook endpoint will be exposed (relative to basePath, if any)||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
