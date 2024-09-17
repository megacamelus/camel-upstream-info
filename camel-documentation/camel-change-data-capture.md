# Change-data-capture.md

Camel supports the [Change Data
Capture](https://en.wikipedia.org/wiki/Change_data_capture) pattern.

This pattern allows tracking changes in databases, and then let
applications listen to change events, and react accordingly. For
example, this can be used as a [Messaging
Bridge](#messaging-bridge.adoc) to bridge two systems.

<figure>
<img src="eip/CDC-Debezium.png" alt="image" />
</figure>

Camel integrates with [Debezium](https://debezium.io/), which is a CDC
system. There are a number of Camel Debezium components that work with
different databases such as MySQL, Postgres, and MongoDB.

# Example

See the [Camel Debezium
Example](https://github.com/apache/camel-examples/tree/main/debezium)
for more details.
