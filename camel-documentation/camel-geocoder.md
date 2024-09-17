# Geocoder

**Since Camel 2.12**

**Only producer is supported**

The Geocoder component is used for looking up geocodes (latitude and
longitude) for a given address, or reverse lookup.

The component uses either a hosted [Nominatim
server](https://github.com/openstreetmap/Nominatim) or the [Java API for
Google Geocoder](https://code.google.com/p/geocoder-java/) library.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-geocoder</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    geocoder:address:name[?options]
    geocoder:latlng:latitude,longitude[?options]

# Exchange data format

Notice not all headers may be provided depending on available data and
mode in use (`address` vs. `latlng`).

## Body using a Nominatim Server

Camel will deliver the body as a JSONv2 type.

## Body using a Google Server

Camel will deliver the body as a
`com.google.code.geocoder.model.GeocodeResponse` type.  
And if the address is `"current"` then the response is a String type
with a JSON representation of the current location.

If the option `headersOnly` is set to `true` then the message body is
left as-is, and only headers will be added to the Exchange.

# Examples

In the example below, we get the latitude and longitude for Paris,
France

    from("direct:start")
        .to("geocoder:address:Paris, France?type=NOMINATIM&serverUrl=https://nominatim.openstreetmap.org")

If you provide a header with the `CamelGeoCoderAddress` then that
overrides the endpoint configuration, so to get the location of
Copenhagen, Denmark we can send a message with a headers as shown:

    template.sendBodyAndHeader("direct:start", "Hello", GeoCoderConstants.ADDRESS, "Copenhagen, Denmark");

To get the address for a latitude and longitude we can do:

    from("direct:start")
        .to("geocoder:latlng:40.714224,-73.961452")
        .log("Location ${header.CamelGeocoderAddress} is at lat/lng: ${header.CamelGeocoderLatlng} and in country ${header.CamelGeoCoderCountryShort}")

Which will log

    Location 285 Bedford Avenue, Brooklyn, NY 11211, USA is at lat/lng: 40.71412890,-73.96140740 and in country US

To get the current location using the Google GeoCoder, you can use
"current" as the address as shown:

    from("direct:start")
        .to("geocoder:address:current")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|geoApiContext|Configuration for Google maps API||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|address|The geo address which should be prefixed with address:||string|
|latlng|The geo latitude and longitude which should be prefixed with latlng:||string|
|headersOnly|Whether to only enrich the Exchange with headers, and leave the body as-is.|false|boolean|
|language|The language to use.|en|string|
|serverUrl|URL to the geocoder server. Mandatory for Nominatim server.||string|
|type|Type of GeoCoding server. Supported Nominatim and Google.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|proxyAuthDomain|Proxy Authentication Domain to access Google GeoCoding server.||string|
|proxyAuthHost|Proxy Authentication Host to access Google GeoCoding server.||string|
|proxyAuthMethod|Authentication Method to Google GeoCoding server.||string|
|proxyAuthPassword|Proxy Password to access GeoCoding server.||string|
|proxyAuthUsername|Proxy Username to access GeoCoding server.||string|
|proxyHost|Proxy Host to access GeoCoding server.||string|
|proxyPort|Proxy Port to access GeoCoding server.||integer|
|apiKey|API Key to access Google. Mandatory for Google GeoCoding server.||string|
|clientId|Client ID to access Google GeoCoding server.||string|
|clientKey|Client Key to access Google GeoCoding server.||string|
