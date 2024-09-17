# Braintree

**Since Camel 2.17**

**Only producer is supported**

The Braintree component provides access to [Braintree
Payments](https://www.braintreepayments.com/) through their [Java
SDK](https://developers.braintreepayments.com/start/hello-server/java).

All client applications need API credential to process payments. To use
camel-braintree with your account, you’ll need to create a new
[Sandbox](https://www.braintreepayments.com/get-started) or
[Production](https://www.braintreepayments.com/signup) account.

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-braintree</artifactId>
        <version>${camel-version}</version>
    </dependency>

# Examples

    from("direct://GENERATE")
        .to("braintree://sclientToken/generate");

# More Information

For more information on the endpoints and options see Braintree
references at
[https://developers.braintreepayments.com/reference/overview](https://developers.braintreepayments.com/reference/overview)

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|Component configuration||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiName|What kind of operation to perform||object|
|methodName|What sub operation to use for the selected operation||string|
|environment|The environment Either SANDBOX or PRODUCTION||string|
|inBody|Sets the name of a parameter to be passed in the exchange In Body||string|
|merchantId|The merchant id provided by Braintree.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|httpReadTimeout|Set read timeout for http calls.||integer|
|httpLogLevel|Set logging level for http calls, see java.util.logging.Level||string|
|httpLogName|Set log category to use to log http calls.|Braintree|string|
|logHandlerEnabled|Sets whether to enable the BraintreeLogHandler. It may be desirable to set this to 'false' where an existing JUL - SLF4J logger bridge is on the classpath. This option can also be configured globally on the BraintreeComponent.|true|boolean|
|proxyHost|The proxy host||string|
|proxyPort|The proxy port||integer|
|accessToken|The access token granted by a merchant to another in order to process transactions on their behalf. Used in place of environment, merchant id, public key and private key fields.||string|
|privateKey|The private key provided by Braintree.||string|
|publicKey|The public key provided by Braintree.||string|
