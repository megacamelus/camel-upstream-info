# Cron

**Since Camel 3.1**

**Only consumer is supported**

The Cron component is a generic interface component that allows
triggering events at a specific time interval specified using the Unix
cron syntax (e.g. `0/2 * * * * ?` to trigger an event every two
seconds).

As an interface component, the Cron component does not contain a default
implementation. Instead, it requires that the users plug the
implementation of their choice.

The following standard Camel components support the Cron endpoints:

-   [Camel Quartz](#components::quartz-component.adoc)

-   [Camel Spring](#components::spring-summary.adoc)

The Cron component is also supported in **Camel K**, which can use the
Kubernetes scheduler to trigger the routes when required by the cron
expression. Camel K does not require additional libraries to be plugged
when using cron expressions compatible with Kubernetes cron syntax.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-cron</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

Additional libraries may be needed to plug a specific implementation.

# Usage

The component can be used to trigger events at specified times, as in
the following example:

Java  
from("cron:tab?schedule=0/1+*+*+*+*+?")
.setBody().constant("event")
.log("${body}");

XML  
<route>  
<from uri="cron:tab?schedule=0/1+*+*+*+*+?"/>  
<setBody>  
<constant>event</constant>  
</setBody>  
<to uri="log:info"/>  
</route>

The schedule expression `0/3{plus}10{plus}*{plus}*{plus}*{plus}?` can be
also written as `0/3 10 * * * ?` and triggers an event every three
seconds only in the tenth minute of each hour.

Breaking down the parts in the schedule expression(in order):

-   Seconds (optional)

-   Minutes

-   Hours

-   Day of month

-   Month

-   Day of the week

-   Year (optional)

Schedule expressions can be made of five to seven parts. When
expressions are composed of six parts, the first items is the *Seconds*
part (and year is considered missing).

Other valid examples of schedule expressions are:

-   `0/2 * * * ?` (Five parts, an event every two minutes)

-   `0 0/2 * * * MON-FRI 2030` (Seven parts, an event every two minutes
    only in the year 2030)

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|cronService|The id of the CamelCronService to use when multiple implementations are provided||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|The name of the cron trigger||string|
|schedule|A cron expression that will be used to generate events||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
