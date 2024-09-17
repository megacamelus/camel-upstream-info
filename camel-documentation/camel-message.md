# Message.md

Camel supports the
[Message](http://www.enterpriseintegrationpatterns.com/Message.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) using the
[Message](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Message.html)
interface.

<figure>
<img src="eip/MessageSolution.gif" alt="image" />
</figure>

The `org.apache.camel.Message` is the *data record* that represents the
message part of the [Exchange](#manual::exchange.adoc).

The message contains the following information:

-   `_body_`: the message body (i.e., payload)

-   `_headers_`: headers with additional information

-   `_messageId_`: Unique id of the message. By default, the message
    uses the same id as `Exchange.getExchangeId` as messages are
    associated with the `Exchange` and using different IDs offers little
    value. Another reason is to optimize for performance to avoid
    generating new IDs. A few Camel components do provide their own
    message IDs such as the JMS components.

-   `_timestamp_`: the timestamp the message originates from. Some
    systems like JMS, Kafka, AWS have a timestamp on the event/message
    that Camel receives. This method returns the timestamp if a
    timestamp exists.
