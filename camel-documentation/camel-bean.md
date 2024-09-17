# Bean

**Since Camel 1.0**

**Only producer is supported**

The Bean component binds beans to Camel message exchanges.

# URI format

    bean:beanName[?options]

Where `beanName` can be any string used to look up the bean in the
Registry

# Examples

A **bean:** endpoint cannot be defined as the input to the route; i.e.,
you cannot consume from it, you can only route from some inbound message
Endpoint to the bean endpoint as output, such as the **direct** endpoint
as input.

Suppose you have the following POJO class to be used by Camel

    package com.foo;
    
    public class MyBean {
    
        public String saySomething(String input) {
            return "Hello " + input;
        }
    }

Then the bean can be called in a Camel route by the fully qualified
class name:

Java  
from("direct:hello")
.to("bean:com.foo.MyBean");

XML  
<route>  
<from uri="direct:hello"/>  
<to uri="bean:com.foo.MyBean"/>  
</route>

What happens is that when the exchange is routed to the MyBean, then
Camel will use the Bean Binding to invoke the bean, in this case the
*saySomething* method, by converting the `Exchange` in body to the
`String` type and storing the output of the method back to the Exchange
again.

The bean component can also call a bean by *bean id* by looking up the
bean in the [Registry](#manual::registry.adoc) instead of using the
class name.

## Java DSL specific bean syntax

Java DSL comes with syntactic sugar for the [Bean](#bean-component.adoc)
component. Instead of specifying the bean explicitly as the endpoint
(i.e., `to("bean:beanName")`) you can use the following syntax:

    // Send a message to the bean endpoint
    // and invoke method using Bean Binding.
    from("direct:start").bean("beanName");
    
    // Send a message to the bean endpoint
    // and invoke given method.
    from("direct:start").bean("beanName", "methodName");

Instead of passing the name of the reference to the bean (so that Camel
will look up for it in the [Registry](#manual::registry.adoc)), you can
specify the bean itself:

    // Send a message to the given bean instance.
    from("direct:start").bean(new ExampleBean());
    
    // Explicit selection of bean method to be invoked.
    from("direct:start").bean(new ExampleBean(), "methodName");
    
    // Camel will create the instance of bean and cache it for you.
    from("direct:start").bean(ExampleBean.class);

This bean could be a lambda if you cast the lambda to a
`@FunctionalInterface`

    @FunctionalInterface
    public interface ExampleInterface() {
        @Handler String methodName();
    }
    
    from("direct:start")
        .bean((ExampleInterface) () -> ""))

# Bean Binding

The [Bean Binding](#manual::bean-binding.adoc) mechanism defines how
methods to be invoked are chosen (if they are not specified explicitly
through the **method** parameter) and how parameter values are
constructed from the Message. These are used throughout all the various
[Bean Integration](#manual::bean-integration.adoc) mechanisms in Camel.

See also related [Bean Language](#languages:bean-language.adoc).

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
