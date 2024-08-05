# Xchange

**Since Camel 2.21**

**Only producer is supported**

The XChange component uses the
[XChange](https://knowm.org/open-source/xchange/) Java library to
provide access to 60+ Bitcoin and Altcoin exchanges. It comes with a
consistent interface for trading and accessing market data.

Camel can get crypto currency market data, query historical data, place
market orders and much more.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-xchange</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    xchange://exchange?options

# Authentication

This component communicates with supported crypto currency exchanges via
REST API. Some API requests use simple unauthenticated GET request. For
most of the interesting stuff however, you’d need an account with the
exchange and have API access keys enabled.

These API access keys need to be guarded tightly, especially so when
they also allow for the withdraw functionality. In which case, anyone
who can get hold of your API keys can easily transfer funds from your
account to some other address i.e. steal your money.

Your API access keys can be strored in an exchange specific properties
file in your SSH directory. For Binance for example this would be:
`~/.ssh/binance-secret.keys`

    ##
    # This file MUST NEVER be commited to source control.
    # It is therefore added to .gitignore.
    #
    apiKey = GuRW0*********
    secretKey = nKLki************

# Samples

In this sample we find the current Bitcoin market price in USDT:

    from("direct:ticker").to("xchange:binance?service=marketdata&method=ticker&currencyPair=BTC/USDT")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|The exchange to connect to||string|
|currency|The currency||object|
|currencyPair|The currency pair||string|
|method|The method to execute||object|
|service|The service to call||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
