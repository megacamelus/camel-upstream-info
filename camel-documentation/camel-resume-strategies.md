# Resume-strategies.md

The resume strategies allow users to implement strategies that point the
consumer part of the routes to the last point of consumption. This
allows Camel to skip reading and processing data that has already been
consumed.

The resume strategies can be used to allow quicker stop and resume
operations when consuming large data sources. For instance, imagine a
scenario where the file consumer is reading a large file. Without a
resume strategy, stopping and starting Camel would cause the consumer in
the File component to read all the bytes of the given file at the
initial offset (that is, offset 0). The resume strategy allows
integrations can point the consumer to the exact offset to resume the
operations.

Support for resume varies according to the component. Initially, the
support is available for the following components:

-   [camel-atom](#components::atom-component.adoc)

-   [camel-aws2-kinesis](#components::aws2-kinesis-component.adoc)

-   [camel-cassandracql](#components::cql-component.adoc)

-   [camel-couchbase](#components::couchbase-component.adoc)

-   [camel-couchdb](#components::couchdb-component.adoc)

-   [camel-file](#components::file-component.adoc)

-   [camel-kafka](#components::kafka-component.adoc)

-   [camel-rss](#components::rss-component.adoc)

The resume strategies comes in three parts:

-   A DSL method that marks the route as supporting resume operations
    and points to an instance of a strategy implementation.

-   A set of core infrastructure that allows integrations to implement
    different types of strategies

-   Basic strategies implementations that can be extended to implement
    the specific resume strategies required by the integrations

# The DSL method

The route needs to use the `resumable()` method followed by passing a
strategy configuration using `configuration`. It is also possible to use
the `resumableStrategy` to point to an instance of the resume strategy
in use, although this is much more complex. The vast majority of the
cases should use a `configuration`, in which case Camel will do the
heavy-lifting for you.

Using the resume API with the configuration should look like this:

    KafkaResumeStrategyConfigurationBuilder kafkaConfigurationBuilder = KafkaResumeStrategyConfigurationBuilder.newBuilder()
        .withBootstrapServers("kafka-address:9092")
        .withTopic("offset")
        .withProducerProperty("max.block.ms", "10000")
        .withMaxInitializationDuration(Duration.ofSeconds(5))
        .withResumeCache(new MyChoiceOfResumeCache<>(100));
    
    from("some:component")
        .resumable().configuration(kafkaConfigurationBuilder)
        .process(this::process);

## Configuring via beans

This instance can be bound in the Context registry as follows:

    getCamelContext().getRegistry().bind("testResumeStrategy", new MyTestResumeStrategy());
    getCamelContext().getRegistry().bind("resumeCache", new MyChoiceOfResumeCache<>(100));
    
    from("some:component")
        .resumable("testResumeStrategy")
        .process(this::process);

Or the instance can be constructed as follows:

    getCamelContext().getRegistry().bind("resumeCache", new MyChoiceOfResumeCache<>(100));
    
    from("some:component")
        .resumable(new MyTestResumeStrategy())
        .process(this::process)

In some circumstances, such as when dealing with File I/O, it may be
necessary to set the offset manually. There are **supporting classes**
that can help work with resumables:

-   `org.apache.camel.support.Resumables` - resumables handling support

-   `org.apache.camel.support.Offsets` - offset handling support

## Intermittent Mode

In some cases, it may be necessary to avoid updating the offset for
every exchange. You can enable the intermittent mode to modify the route
behavior so that missing offsets will not cause an exception:

    from("some:component")
    .resumable(new MyTestResumeStrategy()).intermittent(true)
    .process(this::process)

# Builtin Resume Strategies

Camel comes with a few builtin strategies that can be used to store,
retrieve and update the offsets. The following strategies are available:

-   `SingleNodeKafkaResumeStrategy`: a resume strategy from the
    `camel-kafka` component that uses Kafka as the store for the offsets
    and is suitable for single node integrations.

-   `MultiNodeKafkaResumeStrategy`: a resume strategy from the
    `camel-kafka` component that uses Kafka as the store for the offsets
    and is suitable for multi node integrations (i.e.: integrations
    running on clusters using the
    [camel-master](#components::master-component.adoc) component.

## Configuring the Strategies

Some of the builtin strategies may need additional configuration. This
can be done using the configuration builders available for each
strategy. For instance, to configure either one of the Kafka strategies
mentioned earlier, the `KafkaResumeStrategyConfiguration` needs to be
used. It can be created using a code similar to the following:

        KafkaResumeStrategyConfiguration resumeStrategyConfiguration = KafkaResumeStrategyConfigurationBuilder.newBuilder()
                .withBootstrapServers(bootStrapAddress)
                .withTopic(kafkaTopic)
                .build();

## Implementing New Builtin Resume Strategies

New builtin resume strategies can be created by implementing the
`ResumeStrategy` interface. Check the code for
`SingleNodeKafkaResumeStrategy` for implementation details.

# Local Cache Support

A sample local cache implemented using
[Caffeine](https://github.com/ben-manes/caffeine).

-   `org.apache.camel.component.caffeine.resume.CaffeineCache`

# Known Limitations

When using the converters with the file component, beware of the
differences in the behavior from `Reader` and `InputStream`:

For instance, the behavior of:

    from("file:{{input.dir}}?noop=true&fileName={{input.file}}")
        .resumable("testResumeStrategy")
        .convertBodyTo(Reader.class)
        .process(this::process);

It is different from the behavior of:

    from("file:{{input.dir}}?noop=true&fileName={{input.file}}")
        .resumable("testResumeStrategy")
        .convertBodyTo(InputStream.class)
        .process(this::process);

**Reason**: the `skip` method in the Reader will skip characters,
whereas the same method on the InputStream will skip bytes.

# Pausable Consumers API

The Pausable consumers API is a subset of the resume API that provides
pause and resume features for supported components. With this API, it is
possible to implement logic that controls the behavior of the consumer
based on conditions that are external to the component. For instance, it
makes it possible to pause the consumer if an external system becomes
unavailable.

Currently, support for pausable consumers is available for the following
components:

-   [camel-kafka](#components::kafka-component.adoc)

To use the API, it needs an instance of a Consumer listener along with a
predicate that tests whether to continue.

-   `org.apache.camel.resume.ConsumerListener`: the consumer listener
    interface. Camel already comes with pre-built consumer listeners,
    but users in need of more complex behaviors can create their own
    listeners.

-   a predicate that returns true if data consumption should resume or
    false if consumption should be put on pause

Usage example:

    from(from)
        .pausable(new KafkaConsumerListener(), o -> canContinue())
        .process(exchange -> LOG.info("Received an exchange: {}", exchange.getMessage().getBody()))
        .to(destination);

You can also integrate the pausable API and the consumer listener with
the circuit breaker EIP. For instance, it’s possible to configure the
circuit breaker so that it can manipulate the state of the listener
based on success or on error conditions on the circuit.

One example would be to create an event watcher that checks for a
downstream system availability. It watches for error events and, when
they happen, it triggers a scheduled check. On success, it shuts down
the scheduled check.

An example implementation of this approach would be similar to this:

    CircuitBreaker circuitBreaker = CircuitBreaker.ofDefaults("pausable");
    
    circuitBreaker.getEventPublisher()
        .onSuccess(event -> {
            LOG.info("Downstream call succeeded");
            if (executorService != null) {
                executorService.shutdownNow();
                executorService = null;
            }
        })
        .onError(event -> {
            LOG.info(
                    "Downstream call error. Starting a thread to simulate checking for the downstream availability");
    
            if (executorService == null) {
                executorService = Executors.newSingleThreadScheduledExecutor();
                // In a real world scenario, instead of incrementing, it could be pinging a remote system or
                // running a similar check to determine whether it's available. That
                executorService.scheduleAtFixedRate(() -> someCheckMethod(), 1, 1, TimeUnit.SECONDS);
            }
        });
    
    // Binds the configuration to the registry
     getCamelContext().getRegistry().bind("pausableCircuit", circuitBreaker);
    
    from(from)
        .pausable(new KafkaConsumerListener(), o -> canContinue())
        .routeId("pausable-it")
        .process(exchange -> LOG.info("Got record from Kafka: {}", exchange.getMessage().getBody()))
        .circuitBreaker()
            .resilience4jConfiguration().circuitBreaker("pausableCircuit").end()
            .to(to)
        .end();
