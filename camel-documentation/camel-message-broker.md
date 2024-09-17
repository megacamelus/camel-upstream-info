# Message-broker.md

Camel supports the [Message
Broker](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageBroker.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) book.

How can you decouple the destination of a message from the sender and
maintain central control over the flow of messages?

<figure>
<img src="eip/MessageBroker.gif" alt="image" />
</figure>

Use a central Message Broker that can receive messages from multiple
destinations, determine the correct destination and route the message to
the correct channel.

Camel supports integration with existing message broker systems such as
[ActiveMQ](#ROOT:activemq-component.adoc),
[Kafka](#ROOT:kafka-component.adoc),
[RabbitMQ](#ROOT:spring-rabbitmq-component.adoc), and cloud queue
systems such as [AWS SQS](#ROOT:aws2-sqs-component.adoc), and others.

These Camel components allow to both send and receive data from message
brokers.
