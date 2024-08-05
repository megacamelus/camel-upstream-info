# Weather

**Since Camel 2.12**

**Both producer and consumer are supported**

The Weather component is used for polling weather information from [Open
Weather Map](http://openweathermap.org) - a site that provides free
global weather and forecast information. The information is returned as
a json String object.

Camel will poll for updates to the current weather and forecasts once
per hour by default. It can also be used to query the weather api based
on the parameters defined on the endpoint which is used as producer.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-weather</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    weather://<unused name>[?options]

# Exchange data format

Camel will deliver the body as a json formatted `java.lang.String` (see
the `mode` option above).

# Samples

In this sample we find the 7-day weather forecast for Madrid, Spain:

    from("weather:foo?location=Madrid,Spain&period=7 days&appid=APIKEY&geolocationAccessKey=IPSTACK_ACCESS_KEY&geolocationRequestHostIP=LOCAL_IP").to("jms:queue:weather");

To just find the current weather for your current location, you can use
this:

    from("weather:foo?appid=APIKEY&geolocationAccessKey=IPSTACK_ACCESS_KEY&geolocationRequestHostIP=LOCAL_IP").to("jms:queue:weather");

And to find the weather using the producer, we do:

    from("direct:start")
      .to("weather:foo?location=Madrid,Spain&appid=APIKEY&geolocationAccessKey=IPSTACK_ACCESS_KEY&geolocationRequestHostIP=LOCAL_IP");

And we can send in a message with a header to get the weather for any
location as shown:

    String json = template.requestBodyAndHeader("direct:start", "", "CamelWeatherLocation", "Paris,France&appid=APIKEY", String.class);

And to get the weather at the current location, then:

    String json = template.requestBodyAndHeader("direct:start", "", "CamelWeatherLocation", "current&appid=APIKEY", String.class);

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|The name value is not used.||string|
|appid|APPID ID used to authenticate the user connected to the API Server||string|
|headerName|To store the weather result in this header instead of the message body. This is useable if you want to keep current message body as-is.||string|
|language|Language of the response.|en|object|
|mode|The output format of the weather data.|JSON|object|
|period|If null, the current weather will be returned, else use values of 5, 7, 14 days. Only the numeric value for the forecast period is actually parsed, so spelling, capitalisation of the time period is up to you (its ignored)||string|
|units|The units for temperature measurement.||object|
|weatherApi|The API to use (current, forecast/3 hour, forecast daily, station)||object|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|geoLocationProvider|A custum geolocation provider to determine the longitude and latitude to use when no location information is set. The default implementaion uses the ipstack API and requires geolocationAccessKey and geolocationRequestHostIP||object|
|httpClient|To use an existing configured http client (for example with http proxy)||object|
|cnt|Number of results to be found||integer|
|ids|List of id's of city/stations. You can separate multiple ids by comma.||string|
|lat|Latitude of location. You can use lat and lon options instead of location. For boxed queries this is the bottom latitude.||string|
|location|If null Camel will try and determine your current location using the geolocation of your ip address, else specify the city,country. For well known city names, Open Weather Map will determine the best fit, but multiple results may be returned. Hence specifying and country as well will return more accurate data. If you specify current as the location then the component will try to get the current latitude and longitude and use that to get the weather details. You can use lat and lon options instead of location.||string|
|lon|Longitude of location. You can use lat and lon options instead of location. For boxed queries this is the left longtitude.||string|
|rightLon|For boxed queries this is the right longtitude. Needs to be used in combination with topLat and zoom.||string|
|topLat|For boxed queries this is the top latitude. Needs to be used in combination with rightLon and zoom.||string|
|zip|Zip-code, e.g. 94040,us||string|
|zoom|For boxed queries this is the zoom. Needs to be used in combination with rightLon and topLat.||integer|
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
|geolocationAccessKey|The geolocation service now needs an accessKey to be used||string|
|geolocationRequestHostIP|The geolocation service now needs to specify the IP associated to the accessKey you're using||string|
