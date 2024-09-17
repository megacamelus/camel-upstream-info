# Fastjson-dataformat.md

**Since Camel 2.20**

Fastjson is a Data Format that uses the [Fastjson
Library](https://github.com/alibaba/fastjson)

    from("activemq:My.Queue").
      marshal().json(JsonLibrary.Fastjson).
      to("mqseries:Another.Queue");

# Fastjson Options

# Dependencies

To use Fastjson in your camel routes, you need to add the dependency on
**camel-fastjson** which implements this data format.

If you use maven, you could add the following to your `pom.xml`,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-fastjson</artifactId>
      <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>
