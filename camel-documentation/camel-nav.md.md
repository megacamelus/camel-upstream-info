# Nav.md

-   [Enterprise Integration
    Patterns](#eips:enterprise-integration-patterns.adoc)
    
    -   [Aggregate](#aggregate-eip.adoc)
    
    -   [BatchConfig](#batchConfig-eip.adoc)
    
    -   [Bean](#bean-eip.adoc)
    
    -   [Change Data Capture](#change-data-capture.adoc)
    
    -   [Channel Adapter](#channel-adapter.adoc)
    
    -   [Choice](#choice-eip.adoc)
    
    -   [Circuit Breaker](#circuitBreaker-eip.adoc)
    
    -   [Claim Check](#claimCheck-eip.adoc)
    
    -   [Competing Consumers](#competing-consumers.adoc)
    
    -   [Composed Message Processor](#composed-message-processor.adoc)
    
    -   [Content Enricher](#content-enricher.adoc)
    
    -   [Content Filter](#content-filter-eip.adoc)
    
    -   [Convert Body To](#convertBodyTo-eip.adoc)
    
    -   [Convert Header To](#convertHeaderTo-eip.adoc)
    
    -   [Convert Variable To](#convertVariableTo-eip.adoc)
    
    -   [Correlation Identifier](#correlation-identifier.adoc)
    
    -   [Custom Load Balancer](#customLoadBalancer-eip.adoc)
    
    -   [Dead Letter Channel](#dead-letter-channel.adoc)
    
    -   [Delay](#delay-eip.adoc)
    
    -   [Durable Subscriber](#durable-subscriber.adoc)
    
    -   [Dynamic Router](#dynamicRouter-eip.adoc)
    
    -   [Enrich](#enrich-eip.adoc)
    
    -   [Event Driven Consumer](#eventDrivenConsumer-eip.adoc)
    
    -   [Event Message](#event-message.adoc)
    
    -   [Failover Load Balancer](#failoverLoadBalancer-eip.adoc)
    
    -   [Fault Tolerance
        Configuration](#faultToleranceConfiguration-eip.adoc)
    
    -   [Fault Tolerance EIP](#fault-tolerance-eip.adoc)
    
    -   [Filter](#filter-eip.adoc)
    
    -   [From](#from-eip.adoc)
    
    -   [Guaranteed Delivery](#guaranteed-delivery.adoc)
    
    -   [Idempotent Consumer](#idempotentConsumer-eip.adoc)
    
    -   [Intercept](#intercept.adoc)
    
    -   [Kamelet](#kamelet-eip.adoc)
    
    -   [Load Balance](#loadBalance-eip.adoc)
    
    -   [Logger](#log-eip.adoc)
    
    -   [Loop](#loop-eip.adoc)
    
    -   [Marshal EIP](#marshal-eip.adoc)
    
    -   [Message](#message.adoc)
    
    -   [Message Broker](#message-broker.adoc)
    
    -   [Message Bus](#message-bus.adoc)
    
    -   [Message Channel](#message-channel.adoc)
    
    -   [Message Dispatcher](#message-dispatcher.adoc)
    
    -   [Message Endpoint](#message-endpoint.adoc)
    
    -   [Message Expiration](#message-expiration.adoc)
    
    -   [Message History](#message-history.adoc)
    
    -   [Message Router](#message-router.adoc)
    
    -   [Message Translator](#message-translator.adoc)
    
    -   [Messaging Bridge](#messaging-bridge.adoc)
    
    -   [Messaging Gateway](#messaging-gateway.adoc)
    
    -   [Messaging Mapper](#messaging-mapper.adoc)
    
    -   [Multicast](#multicast-eip.adoc)
    
    -   [Normalizer](#normalizer.adoc)
    
    -   [On Fallback](#onFallback-eip.adoc)
    
    -   [Pipeline](#pipeline-eip.adoc)
    
    -   [Point to Point Channel](#point-to-point-channel.adoc)
    
    -   [Poll Enrich](#pollEnrich-eip.adoc)
    
    -   [Polling Consumer](#polling-consumer.adoc)
    
    -   [Process](#process-eip.adoc)
    
    -   [Process Manager](#process-manager.adoc)
    
    -   [Publish Subscribe Channel](#publish-subscribe-channel.adoc)
    
    -   [Random Load Balancer](#randomLoadBalancer-eip.adoc)
    
    -   [Recipient List](#recipientList-eip.adoc)
    
    -   [Remove Header](#removeHeader-eip.adoc)
    
    -   [Remove Headers](#removeHeaders-eip.adoc)
    
    -   [Remove Properties](#removeProperties-eip.adoc)
    
    -   [Remove Property](#removeProperty-eip.adoc)
    
    -   [Remove Variable](#removeVariable-eip.adoc)
    
    -   [Request Reply](#requestReply-eip.adoc)
    
    -   [Resequence](#resequence-eip.adoc)
    
    -   [Resilience4j
        Configuration](#resilience4jConfiguration-eip.adoc)
    
    -   [Resilience4j EIP](#resilience4j-eip.adoc)
    
    -   [Resume Strategies](#resume-strategies.adoc)
    
    -   [Return Address](#return-address.adoc)
    
    -   [Rollback](#rollback-eip.adoc)
    
    -   [Round Robin Load Balancer](#roundRobinLoadBalancer-eip.adoc)
    
    -   [Routing Slip](#routingSlip-eip.adoc)
    
    -   [Saga](#saga-eip.adoc)
    
    -   [Sample](#sample-eip.adoc)
    
    -   [Scatter-Gather](#scatter-gather.adoc)
    
    -   [Script](#script-eip.adoc)
    
    -   [Selective Consumer](#selective-consumer.adoc)
    
    -   [Service Activator](#service-activator.adoc)
    
    -   [Service Call](#serviceCall-eip.adoc)
    
    -   [Set Body](#setBody-eip.adoc)
    
    -   [Set Header](#setHeader-eip.adoc)
    
    -   [Set Headers](#setHeaders-eip.adoc)
    
    -   [Set Property](#setProperty-eip.adoc)
    
    -   [Set Variable](#setVariable-eip.adoc)
    
    -   [Set Variables](#setVariables-eip.adoc)
    
    -   [Sort](#sort-eip.adoc)
    
    -   [Split](#split-eip.adoc)
    
    -   [Step](#step-eip.adoc)
    
    -   [Sticky Load Balancer](#stickyLoadBalancer-eip.adoc)
    
    -   [Stop](#stop-eip.adoc)
    
    -   [StreamConfig](#streamConfig-eip.adoc)
    
    -   [Threads](#threads-eip.adoc)
    
    -   [Throttle](#throttle-eip.adoc)
    
    -   [To](#to-eip.adoc)
    
    -   [To D](#toD-eip.adoc)
    
    -   [Topic Load Balancer](#topicLoadBalancer-eip.adoc)
    
    -   [Transactional Client](#transactional-client.adoc)
    
    -   [Transform](#transform-eip.adoc)
    
    -   [Unmarshal EIP](#unmarshal-eip.adoc)
    
    -   [Validate](#validate-eip.adoc)
    
    -   [Weighted Load Balancer](#weightedLoadBalancer-eip.adoc)
    
    -   [Wire Tap](#wireTap-eip.adoc)
