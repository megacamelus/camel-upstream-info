# Dhis2

**Since Camel 4.0**

**Both producer and consumer are supported**

The Camel DHIS2 component leverages the [DHIS2 Java
SDK](https://github.com/dhis2/dhis2-java-sdk) to integrate Apache Camel
with [DHIS2](https://dhis2.org/). DHIS2 is a free, open-source, fully
customizable platform for collecting, analyzing, visualizing, and
sharing aggregate and individual-data for district-level, national,
regional, and international system and program management in health,
education, and other domains.

Maven users will need to add the following dependency to their
`+pom.xml+`.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-dhis2</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

    dhis2://operation/method[?options]

# Examples

-   Fetch an organisation unit by ID:
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.builder.RouteBuilder;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                from("direct:getResource")
                    .to("dhis2://get/resource?path=organisationUnits/O6uvpzGd5pu&username=admin&password=district&baseApiUrl=https://play.dhis2.org/40.2.2/api")
                    .unmarshal()
                    .json(org.hisp.dhis.api.model.v40_2_2.OrganisationUnit.class);
            }
        }

-   Fetch an organisation unit code by ID:
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.builder.RouteBuilder;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                from("direct:getResource")
                    .to("dhis2://get/resource?path=organisationUnits/O6uvpzGd5pu&fields=code&username=admin&password=district&baseApiUrl=https://play.dhis2.org/40.2.2/api")
                    .unmarshal()
                    .json(org.hisp.dhis.api.model.v40_2_2.OrganisationUnit.class);
            }
        }

-   Fetch all organisation units:
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.builder.RouteBuilder;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                from("direct:getCollection")
                    .to("dhis2://get/collection?path=organisationUnits&arrayName=organisationUnits&username=admin&password=district&baseApiUrl=https://play.dhis2.org/40.2.2/api")
                    .split().body()
                    .convertBodyTo(org.hisp.dhis.api.model.v40_2_2.OrganisationUnit.class).log("${body}");
            }
        }

-   Fetch all organisation unit codes:
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.builder.RouteBuilder;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                from("direct:getCollection")
                    .to("dhis2://get/collection?path=organisationUnits&fields=code&arrayName=organisationUnits&username=admin&password=district&baseApiUrl=https://play.dhis2.org/40.2.2/api")
                    .split().body()
                    .convertBodyTo(org.hisp.dhis.api.model.v40_2_2.OrganisationUnit.class)
                    .log("${body}");
            }
        }

-   Fetch users with a phone number:
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.builder.RouteBuilder;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                from("direct:getCollection")
                    .to("dhis2://get/collection?path=users&filter=phoneNumber:!null:&arrayName=users&username=admin&password=district&baseApiUrl=https://play.dhis2.org/40.2.2/api")
                    .split().body()
                    .convertBodyTo(org.hisp.dhis.api.model.v40_2_2.User.class)
                    .log("${body}");
            }
        }

-   Save a data value set
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.LoggingLevel;
        import org.apache.camel.builder.RouteBuilder;
        import org.hisp.dhis.api.model.v40_2_2.DataValueSet;
        import org.hisp.dhis.api.model.v40_2_2.DataValue;
        import org.hisp.dhis.api.model.v40_2_2.WebMessage;
        import org.hisp.dhis.integration.sdk.support.period.PeriodBuilder;
        
        import java.time.ZoneOffset;
        import java.time.ZonedDateTime;
        import java.time.format.DateTimeFormatter;
        import java.util.Date;
        import java.util.List;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                from("direct:postResource")
                    .setBody(exchange -> new DataValueSet().withCompleteDate(
                            ZonedDateTime.now(ZoneOffset.UTC).format(DateTimeFormatter.ISO_INSTANT))
                                                                           .withOrgUnit("O6uvpzGd5pu")
                                                                           .withDataSet("lyLU2wR22tC").withPeriod(PeriodBuilder.monthOf(new Date(), -1))
                                                                           .withDataValues(
                                                                               List.of(new DataValue().withDataElement("aIJZ2d2QgVV").withValue("20"))))
                    .to("dhis2://post/resource?path=dataValueSets&username=admin&password=district&baseApiUrl=https://play.dhis2.org/40.2.2/api")
                    .unmarshal().json(WebMessage.class)
                    .choice()
                    .when(exchange -> !exchange.getMessage().getBody(WebMessage.class).getStatus().equals(WebMessage.StatusRef.OK))
                        .log(LoggingLevel.ERROR, "Import error from DHIS2 while saving data value set => ${body}")
                    .end();
            }
        }

-   Update an organisation unit
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.LoggingLevel;
        import org.apache.camel.builder.RouteBuilder;
        import org.hisp.dhis.api.model.v40_2_2.OrganisationUnit;
        import org.hisp.dhis.api.model.v40_2_2.WebMessage;
        import org.hisp.dhis.integration.sdk.support.period.PeriodBuilder;
        
        import java.time.ZoneOffset;
        import java.time.ZonedDateTime;
        import java.time.format.DateTimeFormatter;
        import java.util.Date;
        import java.util.List;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                from("direct:putResource")
                    .setBody(exchange -> new OrganisationUnit().withName("Acme").withShortName("Acme").withOpeningDate(new Date()))
                    .to("dhis2://put/resource?path=organisationUnits/jUb8gELQApl&username=admin&password=district&baseApiUrl=https://play.dhis2.org/40.2.2/api")
                    .unmarshal().json(WebMessage.class)
                    .choice()
                    .when(exchange -> !exchange.getMessage().getBody(WebMessage.class).getStatus().equals(WebMessage.StatusRef.OK))
                        .log(LoggingLevel.ERROR, "Import error from DHIS2 while updating org unit => ${body}")
                    .end();
            }
        }

-   Delete an organisation unit
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.LoggingLevel;
        import org.apache.camel.builder.RouteBuilder;
        import org.hisp.dhis.api.model.v40_2_2.WebMessage;
        import org.hisp.dhis.integration.sdk.support.period.PeriodBuilder;
        
        import java.time.ZoneOffset;
        import java.time.ZonedDateTime;
        import java.time.format.DateTimeFormatter;
        import java.util.Date;
        import java.util.List;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                from("direct:deleteResource")
                    .to("dhis2://delete/resource?path=organisationUnits/jUb8gELQApl&username=admin&password=district&baseApiUrl=https://play.dhis2.org/40.2.2/api")
                    .unmarshal().json(WebMessage.class)
                    .choice()
                    .when(exchange -> !exchange.getMessage().getBody(WebMessage.class).getStatus().equals(WebMessage.StatusRef.OK))
                        .log(LoggingLevel.ERROR, "Import error from DHIS2 while deleting org unit => ${body}")
                    .end();
            }
        }

-   Run analytics
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.builder.RouteBuilder;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                from("direct:resourceTablesAnalytics")
                    .to("dhis2://resourceTables/analytics?skipAggregate=false&skipEvents=true&lastYears=1&username=admin&password=district&baseApiUrl=https://play.dhis2.org/40.2.2/api");
            }
        }

-   Reference DHIS2 client
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.builder.RouteBuilder;
        import org.hisp.dhis.integration.sdk.Dhis2ClientBuilder;
        import org.hisp.dhis.integration.sdk.api.Dhis2Client;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                Dhis2Client dhis2Client = Dhis2ClientBuilder.newClient("https://play.dhis2.org/40.2.2/api", "admin", "district").build();
                getCamelContext().getRegistry().bind("dhis2Client", dhis2Client);
        
                from("direct:resourceTablesAnalytics")
                    .to("dhis2://resourceTables/analytics?skipAggregate=true&skipEvents=true&lastYears=1&client=#dhis2Client");
            }
        }

-   Set custom query parameters
    
        package org.camel.dhis2.example;
        
        import org.apache.camel.builder.RouteBuilder;
        
        import java.util.List;
        import java.util.Map;
        
        public class MyRouteBuilder extends RouteBuilder {
        
            public void configure() {
                from("direct:postResource")
                    .setHeader("CamelDhis2.queryParams", constant(Map.of("cacheClear", List.of("true"))))
                    .to("dhis2://post/resource?path=maintenance&client=#dhis2Client");
            }
        }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|baseApiUrl|DHIS2 server base API URL (e.g., https://play.dhis2.org/2.39.1.1/api)||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|client|References a user-defined org.hisp.dhis.integration.sdk.api.Dhis2Client. This option is mutually exclusive to the baseApiUrl, username, password, and personalAccessToken options||object|
|configuration|To use the shared configuration||object|
|password|Password of the DHIS2 username||string|
|personalAccessToken|Personal access token to authenticate with DHIS2. This option is mutually exclusive to username and password||string|
|username|Username of the DHIS2 user to operate as||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiName|API operation (e.g., get)||object|
|methodName|Subject of the API operation (e.g., resource)||string|
|baseApiUrl|DHIS2 server base API URL (e.g., https://play.dhis2.org/2.39.1.1/api)||string|
|inBody|Sets the name of a parameter to be passed in the exchange In Body||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|client|References a user-defined org.hisp.dhis.integration.sdk.api.Dhis2Client. This option is mutually exclusive to the baseApiUrl, username, password, and personalAccessToken options||object|
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
|password|Password of the DHIS2 username||string|
|personalAccessToken|Personal access token to authenticate with DHIS2. This option is mutually exclusive to username and password||string|
|username|Username of the DHIS2 user to operate as||string|
