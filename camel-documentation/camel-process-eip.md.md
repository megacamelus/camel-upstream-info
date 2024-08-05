# Process-eip.md

The
[Processor](http://javadoc.io/doc/org.apache.camel/camel-api/latest/org/apache/camel/Processor.html)
is used for processing message [Exchanges](#manual::exchange.adoc).

The processor is a core Camel concept that represents a node capable of
using, creating, or modifying an incoming exchange. During routing,
exchanges flow from one processor to another; as such, you can think of
a route as a graph having specialized processors as the nodes, and lines
that connect the output of one processor to the input of another.
Processors could be implementations of EIPs, producers for specific
components, or your own custom creation. The figure below shows the flow
between processors.

<figure>
<img src="eip/message_flow_in_route.png" alt="image" />
</figure>

A route first starts with a consumer (think `from` in the DSL) that
populates the initial exchange. At each processor step, the out message
from the previous step is the in message of the next. In many cases,
processors don’t set an out message, so in this case the in message is
reused. At the end of a route, the [Message Exchange
Pattern](#manual::exchange-pattern.adoc) (MEP) of the exchange
determines whether a reply needs to be sent back to the caller of the
route. If the MEP is `InOnly`, no reply will be sent back. If it’s
`InOut`, Camel will take the out message from the last step and return
it.

# Processor API

The `Processor` interface is a central API in Camel. Its API is
purposely designed to be both straightforward and flexible in the form
of a single functional method:

    @FunctionalInterface
    public interface Processor {
    
        /**
         * Processes the message exchange
         *
         * @param  exchange  the message exchange
         * @throws Exception if an internal processing error has occurred.
         */
        void process(Exchange exchange) throws Exception;
    }

The `Processor` is used heavily internally in Camel, such as the base
for all implementations of the [EIP
patterns](#enterprise-integration-patterns.adoc).

## Using a processor in a route

Once you have written a class which implements `Processor` like this:

    public class MyProcessor implements Processor {
      public void process(Exchange exchange) throws Exception {
        // do something...
      }
    }

Then in Camel you can call this processor:

    from("activemq:myQueue")
      .process(new MyProcessor());

You can also call a processor by its bean id, if the processor has been
enlisted in the [Registry](#manual::registry.adoc), such as with the id
`myProcessor`:

Java  
from("activemq:myQueue")
.process("myProcessor");

XML  
And in XML you can refer to the fully qualified class name via `#class:`  
syntax:

    <route>
      <from uri="activemq:myQueue"/>
      <process ref="#class:com.foo.MyProcessor"/>
    </route>

Spring XML  
Or if you use Spring XML you can create the processor via `<bean>`:

    <beans>
    
        <bean id="myProcessor" class="com.foo.MyProcessor"/>
    
        <camelContext>
            <routes>
                <route>
                  <from uri="activemq:myQueue"/>
                  <process ref="myProcessor"/>
                </route>
            </routes>
        </camelContext>
    
    </beans>

## Why use `process` when you can use `to` instead?

The process can be used in routes as an anonymous inner class such:

        from("activemq:myQueue").process(new Processor() {
            public void process(Exchange exchange) throws Exception {
                String payload = exchange.getMessage().getBody(String.class);
                // do something with the payload and/or exchange here
               exchange.getMessage().setBody("Changed body");
           }
        }).to("activemq:myOtherQueue");

This is usable for quickly whirling up some code. If the code in the
inner class gets a bit more complicated, it is advised to refactor it
into a separate class.
