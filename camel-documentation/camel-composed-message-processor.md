# Composed-message-processor.md

Camel supports the [Composed Message
Processor](https://www.enterpriseintegrationpatterns.com/patterns/messaging/DistributionAggregate.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) book.

How can you maintain the overall message flow when processing a message
consisting of multiple elements, each of which may require different
processing?

<figure>
<img src="eip/DistributionAggregate.gif" alt="image" />
</figure>

Use Composed Message Processor to process a composite message. The
Composed Message Processor splits the message up, routes the
sub-messages to the appropriate destinations and re-aggregates the
responses back into a single message.

With Camel, this pattern is implemented by the
[Splitter](#split-eip.adoc) which has built-in aggregation to
re-aggregate the responses back into a single message.

# Example

This example uses the [Split](#split-eip.adoc) EIP as composed message
processor to process each split message, aggregate and return a single
combined response.

The route and the code comments below explain how you can use the
[Split](#split-eip.adoc) EIP to split each message to sub-message which
are processed individually and then combined back into a single response
message via the custom `AggregationStrategy` (`MyOrderStrategy`), as the
output from the Split EIP.

    // this routes starts from the direct:start endpoint
    // the body is then split based on @ separator
    // the splitter in Camel supports InOut as well, and for that we need
    // to be able to aggregate what response we need to send back, so we provide our
    // own strategy with the class MyOrderStrategy.
    from("direct:start")
        .split(body().tokenize("@"), new MyOrderStrategy())
            // each split message is then send to this bean where we can process it
            .to("bean:MyOrderService?method=handleOrder")
            // this is important to end the splitter route as we do not want to do more routing
            // on each split message
        .end()
        // after we have split and handled each message, we want to send a single combined
        // response back to the original caller, so we let this bean build it for us
        // this bean will receive the result of the aggregate strategy: MyOrderStrategy
        .to("bean:MyOrderService?method=buildCombinedResponse")

# More details

See the [Splitter](#split-eip.adoc) EIP.
