# Reactive-executor-vertx.md

**Since Camel 3.0**

The camel-reactive-executor-vertx is a VertX based implementation of the
`ReactiveExecutor` SPI.

By default, Camel uses its own reactive engine for routing messages, but
you can plug in different engines via an SPI interface. This is a VertX
based plugin that uses the VertX event loop for processing messages
during routing.

At this time, this component is an experiment so use it with care.

# VertX instance

This implementation will first look up in the registry for an existing
`io.vertx.core.Vertx` to be used. However, you can configure an existing
instance using the getter/setter on the `VertXReactiveExecutor` class.

# Auto-detection from classpath

To use this implementation all you need to do is to add the
`camel-reactive-executor-vertx` dependency to the classpath, and Camel
should auto-detect this on startup and log as follows:

    Using ReactiveExecutor: camel-reactive-executor-vertx
