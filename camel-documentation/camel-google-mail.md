# Google-mail

**Since Camel 2.15**

**Both producer and consumer are supported**

The Google Mail component provides access to [Gmail](http://gmail.com/)
via the [Google Mail Web
APIs](https://developers.google.com/gmail/api/v1/reference/).

Google Mail uses the [OAuth 2.0
protocol](https://developers.google.com/accounts/docs/OAuth2) for
authenticating a Google account and authorizing access to user data.
Before you can use this component, you will need to [create an account
and generate OAuth
credentials](https://developers.google.com/gmail/api/auth/web-server).
Credentials consist of a `clientId`, `clientSecret`, and a
`refreshToken`. A handy resource for generating a long-lived
`refreshToken` is the [OAuth
playground](https://developers.google.com/oauthplayground).

In the case of a [service
account](https://developers.google.com/identity/protocols/oauth2#serviceaccount),
credentials consist of a JSON-file (serviceAccountKey). You can also use
[delegation domain-wide
authority](https://developers.google.com/identity/protocols/oauth2/service-account#delegatingauthority)
(delegate) and one, several, or all possible [GMail API Auth
Scopes](https://developers.google.com/gmail/api/auth/scopes).

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-google-mail</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.y.z</version>
    </dependency>

# URI Format

The GoogleMail Component uses the following URI format:

    google-mail://endpoint-prefix/endpoint?[options]

# More Information

For more information on the endpoints and options see API documentation
at: [https://developers.google.com/gmail/api/v1/reference/](https://developers.google.com/gmail/api/v1/reference/)

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|applicationName|Google mail application name. Example would be camel-google-mail/1.0||string|
|clientId|Client ID of the mail application||string|
|configuration|To use the shared configuration||object|
|delegate|Delegate for wide-domain service account||string|
|scopes|GMail scopes||array|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|clientFactory|To use the GoogleCalendarClientFactory as factory for creating the client. Will by default use BatchGoogleMailClientFactory||object|
|accessToken|OAuth 2 access token. This typically expires after an hour so refreshToken is recommended for long term usage.||string|
|clientSecret|Client secret of the mail application||string|
|refreshToken|OAuth 2 refresh token. Using this, the Google Calendar component can obtain a new accessToken whenever the current one expires - a necessity if the application is long-lived.||string|
|serviceAccountKey|Service account key in json format to authenticate an application as a service account. Accept base64 adding the prefix base64:||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiName|What kind of operation to perform||object|
|methodName|What sub operation to use for the selected operation||string|
|applicationName|Google mail application name. Example would be camel-google-mail/1.0||string|
|clientId|Client ID of the mail application||string|
|delegate|Delegate for wide-domain service account||string|
|inBody|Sets the name of a parameter to be passed in the exchange In Body||string|
|scopes|GMail scopes||array|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
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
|accessToken|OAuth 2 access token. This typically expires after an hour so refreshToken is recommended for long term usage.||string|
|clientSecret|Client secret of the mail application||string|
|refreshToken|OAuth 2 refresh token. Using this, the Google Calendar component can obtain a new accessToken whenever the current one expires - a necessity if the application is long-lived.||string|
|serviceAccountKey|Service account key in json format to authenticate an application as a service account. Accept base64 adding the prefix base64:||string|
