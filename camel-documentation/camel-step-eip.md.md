# Step-eip.md

Camel supports the [Pipes and
Filters](http://www.enterpriseintegrationpatterns.com/PipesAndFilters.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) in
various ways.

<figure>
<img src="eip/PipesAndFilters.gif" alt="image" />
</figure>

With Camel, you can group your processing across multiple independent
EIPs which can then be chained together in a logical unit, called a
*step*.

A step groups together the child processors into a single composite
unit. This allows capturing metrics at a group level which can make
management and monitoring of Camel routes easier by using higher-level
abstractions. You can also think this as a middle-level between the
route and each processor in the routes.

You may want to do this when you have large routes and want to break up
the routes into logical steps.

This means you can monitor your Camel applications and gather statistics
at 4-tiers:

-   context level
    
    -   route(s) level
        
        -   step(s) level
            
            -   processor(s) level

# Options

# Exchange properties

# Using Step EIP

In Java, you use `step` to group together sub nodes as shown:

    from("activemq:SomeQueue")
        .step("foo")
          .bean("foo")
          .to("activemq:OutputQueue")
        .end()
        .to("direct:bar");

As you can see this groups together `.bean("foo")` and
`.to("activemq:OutputQueue")` into a logical unit with the name foo.

In XML, you use the `<step>` tag:

    <route>
      <from uri="activemq:SomeQueue"/>
      <step id="foo">
        <bean ref="foo"/>
        <to uri="activemq:OutputQueue"/>
      </step>
      <to uri="direct:bar"/>
    </route>

You can have multiple steps:

Java  
from("activemq:SomeQueue")
.step("foo")
.bean("foo")
.to("activemq:OutputQueue")
.end()
.step("bar")
.bean("something")
.to("log:Something")
.end()

XML  
<route>  
<from uri="activemq:SomeQueue"/>  
<step id="foo">  
<bean ref="foo"/>  
<to uri="activemq:OutputQueue"/>  
</step>  
<step id="bar">  
<bean ref="something"/>  
<to uri="log:Something"/>  
</step>  
</route>

YAML  
\- route:
from:
uri: activemq:SomeQueue
steps:
\- step:
id: foo
steps:
\- bean:
ref: foo
\- to:
uri: activemq:OutputQueue
\- step:
id: bar
steps:
\- bean:
ref: something
\- to:
uri: log:Something

## JMX Management of Step EIP

Each Step EIP is registered in JMX under the `type=steps` tree, which
allows monitoring all the steps in the CamelContext. It is also possible
to dump statistics in XML format by the `dumpStepStatsAsXml` operations
on the `CamelContext` or `Route` mbeans.
