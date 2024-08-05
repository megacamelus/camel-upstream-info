# Normalizer.md

Camel supports the
[Normalizer](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Normalizer.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) book.

The normalizer pattern is used to process messages that are semantically
equivalent, but arrive in different formats. The normalizer transforms
the incoming messages into a common format.

<figure>
<img src="eip/NormalizerDetail.gif" alt="image" />
</figure>

In Apache Camel, you can implement the normalizer pattern by combining a
[Content-Based Router](#choice-eip.adoc), which detects the incoming
message’s format, with a collection of different [Message
Translators](#message-translator.adoc), which transform the different
incoming formats into a common format.

# Example

This example shows a Message Normalizer that converts two types of XML
messages into a common format. Messages in this common format are then
routed.

Java  
// we need to normalize two types of incoming messages
from("direct:start")
.choice()
.when().xpath("/employee").to("bean:normalizer?method=employeeToPerson")
.when().xpath("/customer").to("bean:normalizer?method=customerToPerson")
.end()
.to("mock:result");

XML  
<camelContext xmlns="http://camel.apache.org/schema/spring">  
<route>  
<from uri="direct:start"/>  
<choice>  
<when>  
<xpath>/employee</xpath>  
<to uri="bean:normalizer?method=employeeToPerson"/>  
</when>  
<when>  
<xpath>/customer</xpath>  
<to uri="bean:normalizer?method=customerToPerson"/>  
</when>  
</choice>  
<to uri="mock:result"/>  
</route>  
</camelContext>

    <bean id="normalizer" class="org.apache.camel.processor.MyNormalizer"/>

In this case, we’re using a Java [Bean](#ROOT:bean-component.adoc) as
the normalizer.

The class looks like this:

    // Java
    public class MyNormalizer {
    
        public void employeeToPerson(Exchange exchange, @XPath("/employee/name/text()") String name) {
            exchange.getMessage().setBody(createPerson(name));
        }
    
        public void customerToPerson(Exchange exchange, @XPath("/customer/@name") String name) {
            exchange.getMessage().setBody(createPerson(name));
        }
    
        private String createPerson(String name) {
            return "<person name=\" + name + \"/>";
        }
    }

In case there are many incoming formats, then the [Content Based
Router](#choice-eip.adoc) may end up with too many choices. In this
situation, then an alternative is to use [Dynamic to](#toD-eip.adoc)
that computes a [Bean](#ROOT:bean-component.adoc) endpoint, to be called
that acts as [Message Translator](#message-translator.adoc).
