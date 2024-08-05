# Jsonb-dataformat.md

**Since Camel 3.7**

JSON-B is a Data Format that uses the standard (javax) JSON-B library.

    from("activemq:My.Queue").
      marshal().json(JsonLibrary.Jsonb).
      to("mqseries:Another.Queue");

# JSON-B Options

# Dependencies

To use JSON-B in your Camel routes, you need to add the dependency on
**camel-jsonb** that implements this data format.

If you use Maven, you could add the following to your pom.xml,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-jsonb</artifactId>
      <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>

You have to add a dependency on the **implementation** of a jsonb
specification.

If you want to add the Johnzon implementation, and you are using maven,
add following to your `pom.xml`:

    <dependency>
      <groupId>org.apache.johnzon</groupId>
      <artifactId>johnzon-jsonb</artifactId>
      <version>x.x.x</version>
    </dependency>
