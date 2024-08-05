# Fhir

**Since Camel 2.23**

**Both producer and consumer are supported**

The FHIR component integrates with the [HAPI-FHIR](http://hapifhir.io/)
library, which is an open-source implementation of the
[FHIR](http://hl7.org/implement/standards/fhir/) (Fast Healthcare
Interoperability Resources) specification in Java.

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-fhir</artifactId>
        <version>${camel-version}</version>
    </dependency>

# URI Format

The FHIR Component uses the following URI format:

    fhir://endpoint-prefix/endpoint?[options]

Endpoint prefix can be one of:

-   capabilities

-   create

-   delete

-   history

-   load-page

-   meta

-   operation

-   patch

-   read

-   search

-   transaction

-   update

-   validate

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|encoding|Encoding to use for all request||string|
|fhirVersion|The FHIR Version to use|R4|string|
|log|Will log every requests and responses|false|boolean|
|prettyPrint|Pretty print all request|false|boolean|
|serverUrl|The FHIR server base URL||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|client|To use the custom client||object|
|clientFactory|To use the custom client factory||object|
|compress|Compresses outgoing (POST/PUT) contents to the GZIP format|false|boolean|
|configuration|To use the shared configuration||object|
|connectionTimeout|How long to try and establish the initial TCP connection (in ms)|10000|integer|
|deferModelScanning|When this option is set, model classes will not be scanned for children until the child list for the given type is actually accessed.|false|boolean|
|fhirContext|FhirContext is an expensive object to create. To avoid creating multiple instances, it can be set directly.||object|
|forceConformanceCheck|Force conformance check|false|boolean|
|sessionCookie|HTTP session cookie to add to every request||string|
|socketTimeout|How long to block for individual read/write operations (in ms)|10000|integer|
|summary|Request that the server modify the response using the \_summary param||string|
|validationMode|When should Camel validate the FHIR Server's conformance statement|ONCE|string|
|proxyHost|The proxy host||string|
|proxyPassword|The proxy password||string|
|proxyPort|The proxy port||integer|
|proxyUser|The proxy username||string|
|accessToken|OAuth access token||string|
|password|Password to use for basic authentication||string|
|username|Username to use for basic authentication||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiName|What kind of operation to perform||object|
|methodName|What sub operation to use for the selected operation||string|
|encoding|Encoding to use for all request||string|
|fhirVersion|The FHIR Version to use|R4|string|
|inBody|Sets the name of a parameter to be passed in the exchange In Body||string|
|log|Will log every requests and responses|false|boolean|
|prettyPrint|Pretty print all request|false|boolean|
|serverUrl|The FHIR server base URL||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|client|To use the custom client||object|
|clientFactory|To use the custom client factory||object|
|compress|Compresses outgoing (POST/PUT) contents to the GZIP format|false|boolean|
|connectionTimeout|How long to try and establish the initial TCP connection (in ms)|10000|integer|
|deferModelScanning|When this option is set, model classes will not be scanned for children until the child list for the given type is actually accessed.|false|boolean|
|fhirContext|FhirContext is an expensive object to create. To avoid creating multiple instances, it can be set directly.||object|
|forceConformanceCheck|Force conformance check|false|boolean|
|sessionCookie|HTTP session cookie to add to every request||string|
|socketTimeout|How long to block for individual read/write operations (in ms)|10000|integer|
|summary|Request that the server modify the response using the \_summary param||string|
|validationMode|When should Camel validate the FHIR Server's conformance statement|ONCE|string|
|proxyHost|The proxy host||string|
|proxyPassword|The proxy password||string|
|proxyPort|The proxy port||integer|
|proxyUser|The proxy username||string|
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
|accessToken|OAuth access token||string|
|password|Password to use for basic authentication||string|
|username|Username to use for basic authentication||string|
