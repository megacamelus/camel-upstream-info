# Jackson-dataformat.md

**Since Camel 2.0**

Jackson is a Data Format that uses the [Jackson
Library](https://github.com/FasterXML/jackson-core)

    from("activemq:My.Queue").
      marshal().json(JsonLibrary.Jackson).
      to("mqseries:Another.Queue");

# Jackson Options

# Usage

## 2 and 4 bytes characters

Jackson will default work with UTF-8 using an optimized JSon generator
that only supports UTF-8. For users that need 2-bytes or 4-bytes (such
as Japanese) would need to turn on `useWriter=true` in the Camel
dataformat, to use another JSon generator that lets `java.io.Writer`
handle character encodings.

## Using custom ObjectMapper

You can configure `JacksonDataFormat` to use a custom `ObjectMapper` in
case you need more control of the mapping configuration.

If you set up a single `ObjectMapper` in the registry, then Camel will
automatic lookup and use this `ObjectMapper`. For example, if you use
Spring Boot, then Spring Boot can provide a default `ObjectMapper` for
you if you have Spring MVC enabled. And this would allow Camel to detect
that there is one bean of `ObjectMapper` class type in the Spring Boot
bean registry and then use it. When this happens you should set a `INFO`
logging from Camel.

## Using Jackson for automatic type conversion

The `camel-jackson` module allows integrating Jackson as a [Type
Converter](#manual::type-converter.adoc).

This gives a set of out-of-the-box converters to/from the Jackson type
`JSonNode`, such as converting from `JSonNode` to `String` or vice
versa.

### Enabling more type converters and support for POJOs

To enable POJO conversion support for `camel-jackson` then this must be
enabled, which is done by setting the following options on the
`CamelContext` global options, as shown:

    // Enable Jackson JSON type converter for more types.
    camelContext.getGlobalOptions().put("CamelJacksonEnableTypeConverter", "true");
    // Allow Jackson JSON to convert to pojo types also
    // (by default, Jackson only converts to String and other simple types)
    getContext().getGlobalOptions().put("CamelJacksonTypeConverterToPojo", "true");

The `camel-jackson` type converter integrates with
[JAXB](#dataformats:jaxb-dataformat.adoc) which means you can annotate
POJO class with `JAXB` annotations that Jackson can use. You can also
use Jackson’s own annotations in your POJO classes.

# Dependencies

To use Jackson in your Camel routes, you need to add the dependency on
**camel-jackson**, which implements this data format.

If you use Maven, you could add the following to your `pom.xml`,
substituting the version number for the latest \& greatest release:

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-jackson</artifactId>
      <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>
