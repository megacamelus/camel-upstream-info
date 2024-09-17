# Lpr

**Since Camel 2.1**

**Only producer is supported**

The Printer component provides a way to direct payloads on a route to a
printer. The payload has to be a formatted piece of payload in order for
the component to appropriately print it. The goal is to be able to
direct specific payloads as jobs to a line printer in a camel flow.

The functionality allows for the payload to be printed on a default
printer, named local, remote or wireless linked printer using the javax
printing API under the covers.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-printer</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

Since the URI scheme for a printer has not been standardized (the
nearest thing to a standard being the IETF print standard), and
therefore not uniformly applied by vendors, we have chosen **"lpr"** as
the scheme.

    lpr://localhost/default[?options]
    lpr://remotehost:port/path/to/printer[?options]

# Usage

## Sending Messages to a Printer

### Printer Producer

Sending data to the printer is very straightforward and involves
creating a producer endpoint that can be sent message exchanges on in
route.

# Examples

Usage samples.

## Printing text-based payloads

**Printing text-based payloads on a Default printer using letter
stationary and one-sided mode**

    RouteBuilder builder = new RouteBuilder() {
        public void configure() {
           from("file://inputdir/?delete=true")
           .to("lpr://localhost/default?copies=2" +
               "&flavor=DocFlavor.INPUT_STREAM&" +
               "&mimeType=AUTOSENSE" +
               "&mediaSize=NA_LETTER" +
               "&sides=one-sided");
        }};

## Printing GIF-based payloads

**Printing GIF-based payloads on a remote printer using A4 stationary
and one-sided mode**

    RouteBuilder builder = new RouteBuilder() {
        public void configure() {
           from("file://inputdir/?delete=true")
           .to("lpr://remotehost/sales/salesprinter" +
               "?copies=2&sides=one-sided" +
               "&mimeType=GIF&mediaSize=ISO_A4" +
               "&flavor=DocFlavor.INPUT_STREAM");
       }};

## Printing JPEG-based payloads

**Printing JPEG-based payloads on a remote printer using Japanese
Postcard stationary and one-sided mode**

    RouteBuilder builder = new RouteBuilder() {
        public void configure() {
           from("file://inputdir/?delete=true")
           .to("lpr://remotehost/sales/salesprinter" +
               "?copies=2&sides=one-sided" +
               "&mimeType=JPEG" +
               "&mediaSize=JAPANESE_POSTCARD" +
               "&flavor=DocFlavor.INPUT_STREAM");
        }};

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|hostname|Hostname of the printer||string|
|port|Port number of the printer||integer|
|printername|Name of the printer||string|
|copies|Number of copies to print|1|integer|
|docFlavor|Sets DocFlavor to use.||object|
|flavor|Sets DocFlavor to use.||string|
|mediaSize|Sets the stationary as defined by enumeration names in the javax.print.attribute.standard.MediaSizeName API. The default setting is to use North American Letter sized stationary. The value's case is ignored, e.g. values of iso\_a4 and ISO\_A4 may be used.|na-letter|string|
|mediaTray|Sets MediaTray supported by the javax.print.DocFlavor API, for example upper,middle etc.||string|
|mimeType|Sets mimeTypes supported by the javax.print.DocFlavor API||string|
|orientation|Sets the page orientation.|portrait|string|
|printerPrefix|Sets the prefix name of the printer, it is useful when the printer name does not start with //hostname/printer||string|
|sendToPrinter|etting this option to false prevents sending of the print data to the printer|true|boolean|
|sides|Sets one sided or two sided printing based on the javax.print.attribute.standard.Sides API|one-sided|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
