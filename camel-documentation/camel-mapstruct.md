# Mapstruct

**Since Camel 3.19**

**Only producer is supported**

The camel-mapstruct component is used for converting POJOs using
[MapStruct](https://mapstruct.org/).

# URI format

    mapstruct:className[?options]

Where `className` is the fully qualified class name of the POJO to
convert to.

# Setting up MapStruct

The camel-mapstruct component must be configured with one or more
package names for classpath scanning MapStruct *Mapper* classes. This is
needed because the *Mapper* classes are to be used for converting POJOs
with MapStruct.

For example, to set up two packages, you can do the following:

    MapstructComponent mc = context.getComponent("mapstruct", MapstructComponent.class);
    mc.setMapperPackageName("com.foo.mapper,com.bar.mapper");

This can also be configured in `application.properties`:

    camel.component.mapstruct.mapper-package-name = com.foo.mapper,com.bar.mapper

Camel will on startup scan these packages for classes which names ends
with *Mapper*. These classes are then introspected to discover the
mapping methods. These mapping methods are then registered into the
Camel [Type Converter](#manual::type-converter.adoc) registry. This
means that you can also use type converter to convert the POJOs with
MapStruct, such as:

    from("direct:foo")
      .convertBodyTo(MyFooDto.class);

Where `MyFooDto` is a POJO that MapStruct is able to convert to/from.

Camel does not support mapper methods defined with a `void` return type
such as those used with `@MappingTarget`.

If you define multiple mapping methods for the same from / to types,
then the implementation chosen by Camel to do its type conversion is
potentially non-deterministic.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|mapperPackageName|Package name(s) where Camel should discover Mapstruct mapping classes. Multiple package names can be separated by comma.||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|mapStructConverter|To use a custom MapStructConverter such as adapting to a special runtime.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|className|The fully qualified class name of the POJO that mapstruct should convert to (target)||string|
|mandatory|Whether there must exist a mapstruct converter to convert to the POJO.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
