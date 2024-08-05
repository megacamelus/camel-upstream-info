# Transform-eip.md

Camel supports the [Message
Translator](http://www.enterpriseintegrationpatterns.com/MessageTranslator.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

How can systems using different data formats communicate with each other
using messaging?

<figure>
<img src="eip/MessageTranslator.gif" alt="image" />
</figure>

Use a special filter, a Message Translator, between other filters or
applications to translate one data format into another.

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

This page is documenting the first approach by using Transform EIP.

# Options

# Exchange properties

# Using Transform EIP

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
<from uri="direct:cheese"/>  
<transform>  
<simple>Hello ${body}</simple>  
</transform>  
<to uri="log:hello"/>  
</route>

YAML  
\- from:
uri: direct:cheese
steps:
\- transform:
expression:
simple: Hello ${body}
\- to:
uri: log:hello

The [Transform](#transform-eip.adoc) may also reference a given from/to
data type (`org.apache.camel.spi.DataType`).

Java  
from("direct:cheese")
.transform(new DataType("myDataType"))
.to("log:hello");

XML  
<route>  
<from uri="direct:cheese"/>  
<transform toType="myDataType"/>  
<to uri="log:hello"/>  
</route>

YAML  
\- from:
uri: direct:cheese
steps:
\- transform:
to-type: myDataType
\- to:
uri: log:hello

The example above defines the [Transform](#transform-eip.adoc) EIP that
uses a target data type `myDataType`. The given data type may reference
a [Transformer](#manual::transformer.adoc) that is able to handle the
data type transformation.

Users may also specify `fromType` in order to reference a very specific
transformation from a given data type to a given data type.

# What is the difference between Transform and Set Body?

The Transform EIP always sets the result on the OUT message body.

Set Body sets the result accordingly to the [Exchange
Pattern](#manual::exchange-pattern.adoc) on the `Exchange`.
