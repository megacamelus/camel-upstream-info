# Threadpoolfactory-vertx.md

**Since Camel 3.5**

The Camel ThreadPoolFactory Vert.x component is a VertX based
implementation of the `ThreadPoolFactory` SPI.

By default, Camel will use its own thread pool for EIPs that can use
parallel processing (such as splitter, aggregator). You can plug in
different engines via an SPI interface. This is a VertX based plugin
that uses the VertX worker thread pool (executeBlocking).

# Restrictions

This implementation has been designed to use VertX worker threads for
EIPs where concurrency has been enabled (using default settings).
However, this is limited to only apply when the EIP is not configured
with a specific thread pool. For example, the first example below will
use VertX worker threads, and the 2nd below will not:

    from("direct:start")
        .to("log:foo")
        .split(body()).parallelProcessing()
            .to("mock:split")
        .end()
        .to("mock:result");

The following Split EIP will refer to a custom thread pool, and
therefore VertX is not in use, and Camel will use the custom thread
pool:

    // register a custom thread pool profile with id myLowPool
    context.getExecutorServiceManager().registerThreadPoolProfile(
        new ThreadPoolProfileBuilder("myLowPool").poolSize(2).maxPoolSize(10).build()
    );
    
    from("direct:start")
        .to("log:foo")
        .split(body()).executorService("myLowPool")
            .to("mock:split")
        .end()
        .to("mock:result");

# VertX instance

This implementation will first look up in the registry for an existing
`io.vertx.core.Vertx` to be used. However, you can configure an existing
instance using the getter/setter on the `VertXThreadPoolFactory` class.

# Auto-detection from classpath

To use this implementation all you need to do is to add the
`camel-threadpoolfactory-vertx` dependency to the classpath, and Camel
should auto-detect this on startup and log as follows:

    Using ThreadPoolFactory: camel-threadpoolfactory-vertx
