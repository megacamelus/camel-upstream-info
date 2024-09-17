# Dataformat

**Since Camel 2.12**

**Only producer is supported**

The Data Format component allows using [Data
Format](#manual::data-format.adoc) as a Camel Component.

# URI format

    dataformat:name:(marshal|unmarshal)[?options]

Where **name** is the name of the Data Format. And then followed by the
operation which must either be `marshal` or `unmarshal`. The options are
used for configuring the [Data Format](#manual::data-format.adoc) in
use. See the Data Format documentation for which options it supports.

# DataFormat Options

# Examples

For example, to use the [JAXB](#dataformats:jaxb-dataformat.adoc) [Data
Format](#manual::data-format.adoc), we can do as follows:

Java  
from("activemq:My.Queue").
to("dataformat:jaxb:unmarshal?contextPath=com.acme.model").
to("mqseries:Another.Queue");

XML  
<camelContext id="camel" xmlns="http://camel.apache.org/schema/spring">  
<route>  
<from uri="activemq:My.Queue"/>  
<to uri="dataformat:jaxb:unmarshal?contextPath=com.acme.model"/>  
<to uri="mqseries:Another.Queue"/>  
</route>  
</camelContext>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|Name of data format||string|
|operation|Operation to use either marshal or unmarshal||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
