# SetBody-eip.md

Camel supports the [Message
Translator](http://www.enterpriseintegrationpatterns.com/MessageTranslator.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

<figure>
<img src="eip/MessageTranslator.gif" alt="image" />
</figure>

The [Message Translator](#message-translator.adoc) can be done in
different ways in Camel:

-   Using [Transform](#transform-eip.adoc) or [Set
    Body](#setBody-eip.adoc) in the DSL

-   Calling a [Processor](#manual::processor.adoc) or
    [bean](#manual::bean-integration.adoc) to perform the transformation

-   Using template-based [Components](#ROOT:index.adoc), with the
    template being the source for how the message is translated

-   Messages can also be transformed using [Data
    Format](#manual::data-format.adoc) to marshal and unmarshal messages
    in different encodings.

This page is documenting the first approach by using Set Body EIP.

# Options

# Exchange properties

# Examples

You can use a [Set Body](#setBody-eip.adoc) which uses an
[Expression](#manual::expression.adoc) to do the transformation:

In the example below, we prepend Hello to the message body using the
[Simple](#components:languages:simple-language.adoc) language:

Java  
from("direct:cheese")
.setBody(simple("Hello ${body}"))
.to("log:hello");

XML  
<route>  
<from uri="direct:cheese"/>  
<setBody>  
<simple>Hello ${body}</simple>  
</setBody>  
<to uri="log:hello"/>  
</route>

# What is the difference between Transform and Set Body?

The Transform EIP always sets the result on the OUT message body.

Set Body sets the result accordingly to the [Exchange
Pattern](#manual::exchange-pattern.adoc) on the `Exchange`.
