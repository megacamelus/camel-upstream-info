# Sap-netweaver

**Since Camel 2.12**

**Only producer is supported**

The SAP Netweaver integrates with the [SAP NetWeaver
Gateway](http://scn.sap.com/community/developer-center/netweaver-gateway)
using HTTP transports.

This camel component supports only producer endpoints.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-sap-netweaver</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

The URI scheme for a sap netweaver gateway component is as follows

    sap-netweaver:https://host:8080/path?username=foo&password=secret

# Prerequisites

You would need to have an account on the SAP NetWeaver system to be able
to leverage this component. SAP provides a [demo
setup](http://scn.sap.com/docs/DOC-31221#section6) where you can request
an account.

This component uses the basic authentication scheme for logging into SAP
NetWeaver.

# Examples

This example is using the flight demo example from SAP, which is
available online over the internet
[here](http://scn.sap.com/docs/DOC-31221).

In the route below we request the SAP NetWeaver demo server using the
following url

    https://sapes4.sapdevcenter.com/sap/opu/odata/IWFND/RMTSAMPLEFLIGHT

And we want to execute the following command

    FlightCollection(carrid='AA',connid='0017',fldate=datetime'2016-04-20T00%3A00%3A00')

To get flight details for the given flight. The command syntax is in [MS
ADO.Net Data
Service](http://msdn.microsoft.com/en-us/library/cc956153.aspx) format.

We have the following Camel route

    from("direct:start")
        .setHeader(NetWeaverConstants.COMMAND, constant(command))
        .toF("sap-netweaver:%s?username=%s&password=%s", url, username, password)
        .to("log:response")
        .to("velocity:flight-info.vm")

Where `url`, `username`, `password` and `command` are defined as:

        private String username = "P1909969254";
        private String password = "TODO";
        private String url = "https://sapes4.sapdevcenter.com/sap/opu/odata/IWFND/RMTSAMPLEFLIGHT";
        private String command = "FlightCollection(carrid='AA',connid='0017',fldate=datetime'2016-04-20T00%3A00%3A00')";

The password is invalid. You would need to create an account at SAP
first to run the demo.

The velocity template is used for formatting the response to a basic
HTML page

    <html>
      <body>
      Flight information:
    
      <p/>
      <br/>Airline ID: $body["AirLineID"]
      <br/>Aircraft Type: $body["AirCraftType"]
      <br/>Departure city: $body["FlightDetails"]["DepartureCity"]
      <br/>Departure airport: $body["FlightDetails"]["DepartureAirPort"]
      <br/>Destination city: $body["FlightDetails"]["DestinationCity"]
      <br/>Destination airport: $body["FlightDetails"]["DestinationAirPort"]
    
      </body>
    </html>

When running the application, you get sample output:

    Flight information:
    Airline ID: AA
    Aircraft Type: 747-400
    Departure city: new york
    Departure airport: JFK
    Destination city: SAN FRANCISCO
    Destination airport: SFO

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|url|Url to the SAP net-weaver gateway server.||string|
|flatternMap|If the JSON Map contains only a single entry, then flattern by storing that single entry value as the message body.|true|boolean|
|json|Whether to return data in JSON format. If this option is false, then XML is returned in Atom format.|true|boolean|
|jsonAsMap|To transform the JSON from a String to a Map in the message body.|true|boolean|
|password|Password for account.||string|
|username|Username for account.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
