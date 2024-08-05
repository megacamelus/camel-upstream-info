# Class

**Since Camel 2.4**

**Only producer is supported**

The Class component binds beans to Camel message exchanges. It works in
the same way as the [Bean](#bean-component.adoc) component, but instead
of looking up beans from a Registry, it creates the bean based on the
class name.

# URI format

    class:className[?options]

Where `className` is the fully qualified class name to create and use as
bean.

# Using

You simply use the **class** component just as the
[Bean](#bean-component.adoc) component but by specifying the fully
qualified class name instead. For example to use the `MyFooBean` you
have to do as follows:

    from("direct:start")
        .to("class:org.apache.camel.component.bean.MyFooBean")
        .to("mock:result");

You can also specify which method to invoke on the `MyFooBean`, for
example `hello`:

    from("direct:start")
        .to("class:org.apache.camel.component.bean.MyFooBean?method=hello")
        .to("mock:result");

# Setting properties on the created instance

In the endpoint uri you can specify properties to set on the created
instance, for example, if it has a `setPrefix` method:

    from("direct:start")
        .to("class:org.apache.camel.component.bean.MyPrefixBean?bean.prefix=Bye")
        .to("mock:result");

And you can also use the `#` syntax to refer to properties to be looked
up in the Registry.

    from("direct:start")
        .to("class:org.apache.camel.component.bean.MyPrefixBean?bean.cool=#foo")
        .to("mock:result");

Which will look up a bean from the Registry with the id `foo` and invoke
the `setCool` method on the created instance of the `MyPrefixBean`
class.

See more details on the [Bean](#bean-component.adoc) component as the
**class** component works in much the same way.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|scope|Scope of bean. When using singleton scope (default) the bean is created or looked up only once and reused for the lifetime of the endpoint. The bean should be thread-safe in case concurrent threads is calling the bean at the same time. When using request scope the bean is created or looked up once per request (exchange). This can be used if you want to store state on a bean while processing a request and you want to call the same bean instance multiple times while processing the request. The bean does not have to be thread-safe as the instance is only called from the same request. When using delegate scope, then the bean will be looked up or created per call. However in case of lookup then this is delegated to the bean registry such as Spring or CDI (if in use), which depends on their configuration can act as either singleton or prototype scope. so when using prototype then this depends on the delegated registry.|Singleton|object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|beanInfoCacheSize|Maximum cache size of internal cache for bean introspection. Setting a value of 0 or negative will disable the cache.|1000|integer|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|beanName|Sets the name of the bean to invoke||string|
|method|Sets the name of the method to invoke on the bean||string|
|scope|Scope of bean. When using singleton scope (default) the bean is created or looked up only once and reused for the lifetime of the endpoint. The bean should be thread-safe in case concurrent threads is calling the bean at the same time. When using request scope the bean is created or looked up once per request (exchange). This can be used if you want to store state on a bean while processing a request and you want to call the same bean instance multiple times while processing the request. The bean does not have to be thread-safe as the instance is only called from the same request. When using prototype scope, then the bean will be looked up or created per call. However in case of lookup then this is delegated to the bean registry such as Spring or CDI (if in use), which depends on their configuration can act as either singleton or prototype scope. so when using prototype then this depends on the delegated registry.|Singleton|object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|parameters|Used for configuring additional properties on the bean||object|
