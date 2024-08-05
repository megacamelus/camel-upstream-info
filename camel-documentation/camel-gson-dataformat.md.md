# Gson-dataformat.md

**Since Camel 2.10**

Gson is a Data Format that uses the [Gson
Library](https://github.com/google/gson)

    from("activemq:My.Queue").
      marshal().json(JsonLibrary.Gson).
      to("mqseries:Another.Queue");

# Gson Options

# Dependencies

To use Gson in your camel routes, you need to add the dependency on
**camel-gson** which implements this data format.

If you use maven, you could add the following to your `pom.xml`,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-gson</artifactId>
      <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>
