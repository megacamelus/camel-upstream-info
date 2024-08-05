# Enterprise-integration-patterns.md

Camel supports most of the [Enterprise Integration
Patterns](http://www.eaipatterns.com/toc.html) from the excellent book
by Gregor Hohpe and Bobby Woolf.

# Messaging Systems

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ChannelIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#message-channel.adoc">Message
Channel</a></p></td>
<td style="text-align: left;"><p>How does one application communicate
with another using messaging?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#message.adoc">Message</a></p></td>
<td style="text-align: left;"><p>How can two applications be connected
by a message channel exchange a piece of information?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/PipesAndFiltersIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#pipeline-eip.adoc">Pipes and
Filters</a></p></td>
<td style="text-align: left;"><p>How can we perform complex processing
on a message while maintaining independence and flexibility?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ContentBasedRouterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#message-router.adoc">Message
Router</a></p></td>
<td style="text-align: left;"><p>How can you decouple individual
processing steps so that messages can be passed to different filters
depending on a set of conditions?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageTranslatorIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#message-translator.adoc">Message Translator</a></p></td>
<td style="text-align: left;"><p>How can systems using different data
formats communicate with each other using messaging?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageEndpointIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#message-endpoint.adoc">Message Endpoint</a></p></td>
<td style="text-align: left;"><p>How does an application connect to a
messaging channel to send and receive messages?</p></td>
</tr>
</tbody>
</table>

# Messaging Channels

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/PointToPointIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#point-to-point-channel.adoc">Point to Point Channel</a></p></td>
<td style="text-align: left;"><p>How can the caller be sure that exactly
one receiver will receive the document or perform the call?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/PublishSubscribeIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#publish-subscribe-channel.adoc">Publish Subscribe
Channel</a></p></td>
<td style="text-align: left;"><p>How can the sender broadcast an event
to all interested receivers?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/DeadLetterChannelIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#dead-letter-channel.adoc">Dead Letter Channel</a></p></td>
<td style="text-align: left;"><p>What will the messaging system do with
a message it cannot deliver?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/GuaranteedMessagingIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#guaranteed-delivery.adoc">Guaranteed Delivery</a></p></td>
<td style="text-align: left;"><p>How can the sender make sure that a
message will be delivered, even if the messaging system fails?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ChannelAdapterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#channel-adapter.adoc">Channel
Adapter</a></p></td>
<td style="text-align: left;"><p>How can you connect an application to
the messaging system so that it can send and receive messages?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessagingBridgeIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#messaging-bridge.adoc">Messaging Bridge</a></p></td>
<td style="text-align: left;"><p>How can multiple messaging systems be
connected so that messages available on one are also available on the
others??</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageBusIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#message-bus.adoc">Message
Bus</a></p></td>
<td style="text-align: left;"><p>What is an architecture that enables
separate applications to work together, but in a de-coupled fashion such
that applications can be easily added or removed without affecting the
others?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessagingBridgeIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#change-data-capture.adoc">Change Data Capture</a></p></td>
<td style="text-align: left;"><p>Data synchronization by capturing
changes made to a database, and apply those changes to another
system.</p></td>
</tr>
</tbody>
</table>

# Message Construction

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/EventMessageIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#event-message.adoc">Event
Message</a></p></td>
<td style="text-align: left;"><p>How can messaging be used to transmit
events from one application to another?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/RequestReplyIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#requestReply-eip.adoc">Request Reply</a></p></td>
<td style="text-align: left;"><p>When an application sends a message,
how can it get a response from the receiver?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ReturnAddressIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#return-address.adoc">Return
Address</a></p></td>
<td style="text-align: left;"><p>How does a replier know where to send
the reply?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/CorrelationIdentifierIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#correlation-identifier.adoc">Correlation Identifier</a></p></td>
<td style="text-align: left;"><p>How does a requestor that has received
a reply know which request this is the reply for?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageExpirationIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#message-expiration.adoc">Message Expiration</a></p></td>
<td style="text-align: left;"><p>How can a sender indicate when a
message should be considered stale and thus shouldn’t be
processed?</p></td>
</tr>
</tbody>
</table>

# Message Routing

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ContentBasedRouterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#choice-eip.adoc">Content-Based Router</a></p></td>
<td style="text-align: left;"><p>How do we handle a situation where the
implementation of a single logical function (e.g., inventory check) is
spread across multiple physical systems?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageFilterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#filter-eip.adoc">Message
Filter</a></p></td>
<td style="text-align: left;"><p>How can a component avoid receiving
uninteresting messages?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/DynamicRouterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#dynamicRouter-eip.adoc">Dynamic Router</a></p></td>
<td style="text-align: left;"><p>How can you avoid the dependency of the
router on all possible destinations while maintaining its
efficiency?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/RecipientListIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#recipientList-eip.adoc">Recipient List</a></p></td>
<td style="text-align: left;"><p>How do we route a message to a list of
(static or dynamically) specified recipients?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/SplitterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#split-eip.adoc">Splitter</a></p></td>
<td style="text-align: left;"><p>How can we process a message if it
contains multiple elements, each of which may have to be processed in a
different way?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/AggregatorIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#aggregate-eip.adoc">Aggregator</a></p></td>
<td style="text-align: left;"><p>How do we combine the results of
individual, but related, messages so that they can be processed as a
whole?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ResequencerIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#resequence-eip.adoc">Resequencer</a></p></td>
<td style="text-align: left;"><p>How can we get a stream of related but
out-of-sequence messages back into the correct order?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/DistributionAggregateIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#composed-message-processor.adoc">Composed Message
Processor</a></p></td>
<td style="text-align: left;"><p>How can you maintain the overall
message flow when processing a message consisting of multiple elements,
each of which may require different processing?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/DistributionAggregateIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#scatter-gather.adoc">Scatter-Gather</a></p></td>
<td style="text-align: left;"><p>How do you maintain the overall message
flow when a message needs to be sent to multiple recipients, each of
which may send a reply?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/RoutingTableIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#routingSlip-eip.adoc">Routing
Slip</a></p></td>
<td style="text-align: left;"><p>How do we route a message consecutively
through a series of processing steps when the sequence of steps is not
known at design-time and may vary for each message?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ProcessManagerIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#process-manager.adoc">Process
Manager</a></p></td>
<td style="text-align: left;"><p>How do we route a message through
multiple processing steps when the required steps may not be known at
design-time and may not be sequential?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageBrokerIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#message-broker.adoc">Message
Broker</a></p></td>
<td style="text-align: left;"><p>How can you decouple the destination of
a message from the sender and maintain central control over the flow of
messages?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessagingAdapterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#threads-eip.adoc">Threads</a></p></td>
<td style="text-align: left;"><p>How can I decouple the continued
routing of a message from the current thread?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessagingAdapterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#throttle-eip.adoc">Throttler</a></p></td>
<td style="text-align: left;"><p>How can I throttle messages to ensure
that a specific endpoint does not get overloaded, or we don’t exceed an
agreed SLA with some external service?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/WireTap.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#sample-eip.adoc">Sampling</a></p></td>
<td style="text-align: left;"><p>How can I sample one message out of
many in a given period to avoid downstream route does not get
overloaded?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessagingAdapterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#kamelet-eip.adoc">Kamelet</a></p></td>
<td style="text-align: left;"><p>How can I call Kamelets (route
templates)?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageExpirationIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#delay-eip.adoc">Delayer</a></p></td>
<td style="text-align: left;"><p>How can I delay the sending of a
message?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageDispatcherIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#loadBalance-eip.adoc">Load
Balancer</a></p></td>
<td style="text-align: left;"><p>How can I balance load across a number
of endpoints?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageDispatcherIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#circuitBreaker-eip.adoc">Circuit Breaker</a></p></td>
<td style="text-align: left;"><p>How can I stop calling an external
service if the service is broken?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageExpirationIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#stop-eip.adoc">Stop</a></p></td>
<td style="text-align: left;"><p>How can I stop to continue routing a
message?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessagingGatewayIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#serviceCall-eip.adoc">Service
Call</a></p></td>
<td style="text-align: left;"><p>How can I call a remote service in a
distributed system where the service is looked up from a service
registry of some sorts?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/TransactionalClientIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#saga-eip.adoc">Saga</a></p></td>
<td style="text-align: left;"><p>How can I define a series of related
actions in a Camel route that should be either completed successfully
(all of them) or not-executed/compensated?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageDispatcherIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#multicast-eip.adoc">Multicast</a></p></td>
<td style="text-align: left;"><p>How can I route a message to a number
of endpoints at the same time?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/PollingConsumerIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#loop-eip.adoc">Loop</a></p></td>
<td style="text-align: left;"><p>How can I repeat processing a message
in a loop?</p></td>
</tr>
</tbody>
</table>

# Message Transformation

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/DataEnricherIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#content-enricher.adoc">Content Enricher</a></p></td>
<td style="text-align: left;"><p>How do we communicate with another
system if the message originator does not have all the required data
items available?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ContentFilterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#content-filter-eip.adoc">Content Filter</a></p></td>
<td style="text-align: left;"><p>How do you simplify dealing with a
large message when you are interested only in a few data items?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/StoreInLibraryIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#claimCheck-eip.adoc">Claim
Check</a></p></td>
<td style="text-align: left;"><p>How can we reduce the data volume of a
message sent across the system without sacrificing information
content?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/NormalizerIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#normalizer.adoc">Normalizer</a></p></td>
<td style="text-align: left;"><p>How do you process messages that are
semantically equivalent, but arrive in a different format?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ResequencerIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#sort-eip.adoc">Sort</a></p></td>
<td style="text-align: left;"><p>How can I sort the body of a
message?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessagingGatewayIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#script-eip.adoc">Script</a></p></td>
<td style="text-align: left;"><p>How do I execute a script which may not
change the message?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageSelectorIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#validate-eip.adoc">Validate</a></p></td>
<td style="text-align: left;"><p>How can I validate a message?</p></td>
</tr>
</tbody>
</table>

# Messaging Endpoints

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageTranslatorIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#messaging-mapper.adoc">Messaging Mapper</a></p></td>
<td style="text-align: left;"><p>How do you move data between domain
objects and the messaging infrastructure while keeping the two
independent of each other?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/EventDrivenConsumerIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#eventDrivenConsumer-eip.adoc">Event Driven Consumer</a></p></td>
<td style="text-align: left;"><p>How can an application automatically
consume messages as they become available?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/PollingConsumerIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#polling-consumer.adoc">Polling Consumer</a></p></td>
<td style="text-align: left;"><p>How can an application consume a
message when the application is ready?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/CompetingConsumersIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#competing-consumers.adoc">Competing Consumers</a></p></td>
<td style="text-align: left;"><p>How can a messaging client process
multiple messages concurrently?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageDispatcherIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#message-dispatcher.adoc">Message Dispatcher</a></p></td>
<td style="text-align: left;"><p>How can multiple consumers on a single
channel coordinate their message processing?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageSelectorIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#selective-consumer.adoc">Selective Consumer</a></p></td>
<td style="text-align: left;"><p>How can a message consumer select which
messages it wishes to receive?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/DurableSubscriptionIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#durable-subscriber.adoc">Durable Subscriber</a></p></td>
<td style="text-align: left;"><p>How can a subscriber avoid missing
messages while it’s not listening for them?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageFilterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#idempotentConsumer-eip.adoc">Idempotent Consumer</a></p></td>
<td style="text-align: left;"><p>How can a message receiver deal with
duplicate messages?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessageFilterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#resume-strategies.adoc">Resumable Consumer</a></p></td>
<td style="text-align: left;"><p>How can a message receiver resume from
the last known offset?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/TransactionalClientIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#transactional-client.adoc">Transactional Client</a></p></td>
<td style="text-align: left;"><p>How can a client control its
transactions with the messaging system?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessagingGatewayIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#messaging-gateway.adoc">Messaging Gateway</a></p></td>
<td style="text-align: left;"><p>How do you encapsulate access to the
messaging system from the rest of the application?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/MessagingAdapterIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#service-activator.adoc">Service Activator</a></p></td>
<td style="text-align: left;"><p>How can an application design a service
to be invoked both via various messaging technologies and via
non-messaging techniques?</p></td>
</tr>
</tbody>
</table>

# System Management

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ControlBusIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#ROOT:controlbus-component.adoc">ControlBus</a></p></td>
<td style="text-align: left;"><p>How can we effectively administer a
messaging system distributed across multiple platforms and a wide
geographic area?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/DetourIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#intercept.adoc">Detour</a></p></td>
<td style="text-align: left;"><p>How can you route a message through
intermediate steps to perform validation, testing or debugging
functions?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/WireTapIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#wireTap-eip.adoc">Wire
Tap</a></p></td>
<td style="text-align: left;"><p>How do you inspect messages that travel
on a point-to-point channel?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ControlBusIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a href="#message-history.adoc">Message
History</a></p></td>
<td style="text-align: left;"><p>How can we effectively analyze and
debug the flow of messages in a loosely coupled system?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/ControlBusIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#log-eip.adoc">Log</a></p></td>
<td style="text-align: left;"><p>How can I log processing a
message?</p></td>
</tr>
<tr>
<td style="text-align: left;"><figure>
<img src="eip/RoutingTableIcon.gif" alt="image" />
</figure></td>
<td style="text-align: left;"><p><a
href="#step-eip.adoc">Step</a></p></td>
<td style="text-align: left;"><p>Groups together a set of EIPs into a
composite logical unit for metrics and monitoring.</p></td>
</tr>
</tbody>
</table>

# EIP Icons

The EIP icons library is available as a Visio stencil file adapted to
render the icons with the Camel color. Download it
[here](#attachment$Hohpe_EIP_camel_20150622.zip) for your presentation,
functional and technical analysis documents.

The original EIP stencil is also available in [OpenOffice 3.x
Draw](#attachment$Hohpe_EIP_camel_OpenOffice.zip), [Microsoft
Visio](http://www.eaipatterns.com/download/EIP_Visio_stencil.zip), or
[Omnigraffle](http://www.graffletopia.com/stencils/137).
