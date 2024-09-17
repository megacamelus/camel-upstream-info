# Message-translator.md

Camel supports the [Message
Translator](http://www.enterpriseintegrationpatterns.com/MessageTranslator.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

<figure>
<img src="eip/MessageTranslator.gif" alt="image" />
</figure>

The Message Translator can be done in different ways in Camel:

-   Using [Transform](#transform-eip.adoc) or [Set
    Body](#setBody-eip.adoc) in the DSL

-   Calling a [Processor](#manual::processor.adoc) or
    [bean](#manual::bean-integration.adoc) to perform the transformation

-   Using template-based [Components](#ROOT:index.adoc), with the
    template being the source for how the message is translated

-   Messages can also be transformed using [Data
    Format](#manual::data-format.adoc) to marshal and unmarshal messages
    in different encodings.

# Example

Each of the approaches above is documented in the following examples:

## Message Translator with Transform EIP

You can use a [Transform](#transform-eip.adoc) which uses an
[Expression](#manual::expression.adoc) to do the transformation:

In the example below, we prepend Hello to the message body using the
[Simple](#components:languages:simple-language.adoc) language:

Java  
from("direct:cheese")
.setBody(simple("Hello ${body}"))
.to("log:hello");

XML  
<route>  
<from uri="activemq:cheese"/>  
<transform>  
<simple>Hello ${body}</simple>  
</transform>  
<to uri="activemq:wine"/>  
</route>

## Message Translator with Bean

You can transform a message using Camel’s [Bean
Integration](#manual::bean-integration.adoc) to call any method on a
bean that performs the message translation:

Java  
from("activemq:cheese")
.bean("myTransformerBean", "doTransform")
.to("activemq:wine");

XML  
<route>  
<from uri="activemq:cheese"/>  
<bean ref="myTransformerBean" method="doTransform"/>  
<to uri="activemq:wine"/>  
</route>

## Message Translator with Processor

You can also use a [Processor](#manual::processor.adoc) to do the
transformation:

Java  
from("activemq:cheese")
.process(new MyTransformerProcessor())
.to("activemq:wine");

XML  
<route>  
<from uri="activemq:cheese"/>  
<process ref="myTransformerProcessor"/>  
<to uri="activemq:wine"/>  
</route>

## Message Translator using Templating Components

You can also consume a message from one destination, transform it with
something like [Velocity](#ROOT:velocity-component.adoc) or
[XQuery](#ROOT:xquery-component.adoc), and then send it on to another
destination.

Java  
from("activemq:cheese")
.to("velocity:com/acme/MyResponse.vm")
.to("activemq:wine");

XML  
<route>  
<from uri="activemq:cheese"/>  
<to uri="velocity:com/acme/MyResponse.vm"/>  
<to uri="activemq:wine"/>  
</route>

## Message Translator using Data Format

See [Marshal](#marshal-eip.adoc) EIP for more details and examples.
