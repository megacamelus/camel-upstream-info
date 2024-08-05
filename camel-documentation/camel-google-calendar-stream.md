# Google-calendar-stream

**Since Camel 2.23**

**Only consumer is supported**

The Google Calendar Stream component provides access to
[Calendar](https://calendar.google.com) via the [Google Calendar Web
APIs](https://developers.google.com/calendar/overview). This component
provides the streaming feature for Calendar events.

Google Calendar uses the [OAuth 2.0
protocol](https://developers.google.com/accounts/docs/OAuth2) for
authenticating a Google account and authorizing access to user data.
Before you can use this component, you will need to [create an account
and generate OAuth
credentials](https://developers.google.com/calendar/auth). Credentials
consist of a `clientId`, `clientSecret`, and a `refreshToken`. A handy
resource for generating a long-lived `refreshToken` is the [OAuth
playground](https://developers.google.com/oauthplayground).

In the case of a [service
account](https://developers.google.com/identity/protocols/oauth2#serviceaccount),
credentials consist of a JSON-file (serviceAccountKey). You can also use
[delegation domain-wide
authority](https://developers.google.com/identity/protocols/oauth2/service-account#delegatingauthority)
(delegate) and one, several, or all possible [Calendar API Auth
Scopes](https://developers.google.com/calendar/api/guides/auth).

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
            <groupId>org.apache.camel</groupId>
            <artifactId>camel-google-calendar</artifactId>
            <!-- use the same version as your Camel core version -->
            <version>x.x.x</version>
    </dependency>

# URI Format

The Google Calendar Component uses the following URI format:

    google-calendar-stream://index?[options]

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|applicationName|Google Calendar application name. Example would be camel-google-calendar/1.0||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|calendarId|The calendarId to be used|primary|string|
|clientId|Client ID of the calendar application||string|
|configuration|The configuration||object|
|considerLastUpdate|Take into account the lastUpdate of the last event polled as start date for the next poll|false|boolean|
|consumeFromNow|Consume events in the selected calendar from now on|true|boolean|
|delegate|Delegate for wide-domain service account||string|
|maxResults|Max results to be returned|10|integer|
|query|The query to execute on calendar||string|
|scopes|Specifies the level of permissions you want a calendar application to have to a user account. See https://developers.google.com/calendar/auth for more info.||array|
|syncFlow|Sync events, see https://developers.google.com/calendar/v3/sync Note: not compatible with: 'query' and 'considerLastUpdate' parameters|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|clientFactory|The client Factory||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|accessToken|OAuth 2 access token. This typically expires after an hour so refreshToken is recommended for long term usage.||string|
|clientSecret|Client secret of the calendar application||string|
|emailAddress|The emailAddress of the Google Service Account.||string|
|p12FileName|The name of the p12 file which has the private key to use with the Google Service Account.||string|
|refreshToken|OAuth 2 refresh token. Using this, the Google Calendar component can obtain a new accessToken whenever the current one expires - a necessity if the application is long-lived.||string|
|serviceAccountKey|Service account key in json format to authenticate an application as a service account. Accept base64 adding the prefix base64:||string|
|user|The email address of the user the application is trying to impersonate in the service account flow.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|index|Specifies an index for the endpoint||string|
|applicationName|Google Calendar application name. Example would be camel-google-calendar/1.0||string|
|calendarId|The calendarId to be used|primary|string|
|clientId|Client ID of the calendar application||string|
|considerLastUpdate|Take into account the lastUpdate of the last event polled as start date for the next poll|false|boolean|
|consumeFromNow|Consume events in the selected calendar from now on|true|boolean|
|delegate|Delegate for wide-domain service account||string|
|maxResults|Max results to be returned|10|integer|
|query|The query to execute on calendar||string|
|scopes|Specifies the level of permissions you want a calendar application to have to a user account. See https://developers.google.com/calendar/auth for more info.||array|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|syncFlow|Sync events, see https://developers.google.com/calendar/v3/sync Note: not compatible with: 'query' and 'considerLastUpdate' parameters|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
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
|clientSecret|Client secret of the calendar application||string|
|emailAddress|The emailAddress of the Google Service Account.||string|
|p12FileName|The name of the p12 file which has the private key to use with the Google Service Account.||string|
|refreshToken|OAuth 2 refresh token. Using this, the Google Calendar component can obtain a new accessToken whenever the current one expires - a necessity if the application is long-lived.||string|
|serviceAccountKey|Service account key in json format to authenticate an application as a service account. Accept base64 adding the prefix base64:||string|
|user|The email address of the user the application is trying to impersonate in the service account flow.||string|
