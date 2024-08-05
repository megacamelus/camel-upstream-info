# Validate-eip.md

The Validate EIP uses an [Expression](#manual::expression.adoc) or a
[Predicate](#manual::predicate.adoc) to validate the contents of a
message.

<figure>
<img src="eip/MessageSelectorIcon.gif" alt="image" />
</figure>

This is useful for ensuring that messages are valid before attempting to
process them.

When a message is **not** valid then a `PredicateValidationException` is
thrown.

# Options

# Exchange properties

# Using Validate EIP

The route below will read the file contents and validate the message
body against a regular expression.

Java  
from("file:inbox")
.validate(body(String.class).regex("^\\w{10}\\,\\d{2}\\,\\w{24}$"))
.to("bean:myServiceBean.processLine");

XML  
<route>  
<from uri="file:inbox"/>  
<validate>  
<simple>${body} regex ^\\w{10}\\,\\d{2}\\,\\w{24}$</simple>  
</validate>  
<to uri="bean:myServiceBean" method="processLine"/>  
</route>

YAML  
\- from:
uri: file:inbox
steps:
\- validate:
expression:
simple: ${body} regex "^\\w{10}\\,\\d{2}\\,\\w{24}$"
\- to:
uri: bean:myServiceBean
parameters:
method: processLine

Validate EIP is not limited to the message body. You can also validate
the message header.

Java  
from("file:inbox")
.validate(header("bar").isGreaterThan(100))
.to("bean:myServiceBean.processLine");

You can also use `validate` together with the
[Simple](#components:languages:simple-language.adoc) language.

    from("file:inbox")
      .validate(simple("${header.bar} > 100"))
      .to("bean:myServiceBean.processLine");

XML  
<route>  
<from uri="file:inbox"/>  
<validate>  
<simple>${header.bar} \> 100</simple>  
</validate>  
<to uri="bean:myServiceBean" method="processLine"/>  
</route>

YAML  
\- from:
uri: file:inbox
steps:
\- validate:
expression:
simple: ${header.bar} \> 100
\- to:
uri: bean:myServiceBean
parameters:
method: processLine
