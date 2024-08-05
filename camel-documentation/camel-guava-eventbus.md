# Guava-eventbus

**Since Camel 2.10**

**Both producer and consumer are supported**

The [Google Guava
EventBus](https://google.github.io/guava/releases/19.0/api/docs/com/google/common/eventbus/EventBus.html)
allows publish-subscribe-style communication between components without
requiring the components to explicitly register with one another (and
thus be aware of each other). The **guava-eventbus:** component provides
integration bridge between Camel and [Google Guava
EventBus](https://google.github.io/guava/releases/19.0/api/docs/com/google/common/eventbus/EventBus.html)
infrastructure. With the latter component, messages exchanged with the
Guava `EventBus` can be transparently forwarded to the Camel routes.
EventBus component allows also routing the body of Camel exchanges to
the Guava `EventBus`.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-guava-eventbus</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    guava-eventbus:busName[?options]

Where **busName** represents the name of the
`com.google.common.eventbus.EventBus` instance located in the Camel
registry.

# Usage

Using `guava-eventbus` component on the consumer side of the route will
capture messages sent to the Guava `EventBus` and forward them to the
Camel route. Guava EventBus consumer processes incoming messages
[asynchronously](http://camel.apache.org/asynchronous-routing-engine.html).

    SimpleRegistry registry = new SimpleRegistry();
    EventBus eventBus = new EventBus();
    registry.put("busName", eventBus);
    CamelContext camel = new DefaultCamelContext(registry);
    
    from("guava-eventbus:busName").to("seda:queue");
    
    eventBus.post("Send me to the SEDA queue.");

Using `guava-eventbus` component on the producer side of the route will
forward body of the Camel exchanges to the Guava `EventBus` instance.

    SimpleRegistry registry = new SimpleRegistry();
    EventBus eventBus = new EventBus();
    registry.put("busName", eventBus);
    CamelContext camel = new DefaultCamelContext(registry);
    
    from("direct:start").to("guava-eventbus:busName");
    
    ProducerTemplate producerTemplate = camel.createProducerTemplate();
    producer.sendBody("direct:start", "Send me to the Guava EventBus.");
    
    eventBus.register(new Object(){
      @Subscribe
      public void messageHander(String message) {
        System.out.println("Message received from the Camel: " + message);
      }
    });

# DeadEvent considerations

Keep in mind that due to the limitations caused by the design of the
Guava EventBus, you cannot specify event class to be received by the
listener without creating class annotated with `@Subscribe` method. This
limitation implies that endpoint with `eventClass` option specified
actually listens to all possible events (`java.lang.Object`) and filter
appropriate messages programmatically at runtime. The snipped below
demonstrates an appropriate excerpt from the Camel code base.

    @Subscribe
    public void eventReceived(Object event) {
      if (eventClass == null || eventClass.isAssignableFrom(event.getClass())) {
        doEventReceived(event);
    ...

This drawback of this approach is that `EventBus` instance used by Camel
will never generate `com.google.common.eventbus.DeadEvent`
notifications. If you want Camel to listen only to the precisely
specified event (and therefore enable `DeadEvent` support), use
`listenerInterface` endpoint option. Camel will create a dynamic proxy
over the interface you specify with the latter option and listen only to
messages specified by the interface handler methods. The example of the
listener interface with single method handling only `SpecificEvent`
instances is demonstrated below.

    package com.example;
    
    public interface CustomListener {
    
      @Subscribe
      void eventReceived(SpecificEvent event);
    
    }

The listener presented above could be used in the endpoint definition as
follows.

    from("guava-eventbus:busName?listenerInterface=com.example.CustomListener").to("seda:queue");

# Consuming multiple types of events

To define multiple types of events to be consumed by Guava EventBus
consumer use `listenerInterface` endpoint option, as listener interface
could provide multiple methods marked with the `@Subscribe` annotation.

    package com.example;
    
    public interface MultipleEventsListener {
    
      @Subscribe
      void someEventReceived(SomeEvent event);
    
      @Subscribe
      void anotherEventReceived(AnotherEvent event);
    
    }

The listener presented above could be used in the endpoint definition as
follows.

    from("guava-eventbus:busName?listenerInterface=com.example.MultipleEventsListener").to("seda:queue");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|eventBus|To use the given Guava EventBus instance||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|listenerInterface|The interface with method(s) marked with the Subscribe annotation. Dynamic proxy will be created over the interface so it could be registered as the EventBus listener. Particularly useful when creating multi-event listeners and for handling DeadEvent properly. This option cannot be used together with eventClass option.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|eventBusRef|To lookup the Guava EventBus from the registry with the given name||string|
|eventClass|If used on the consumer side of the route, will filter events received from the EventBus to the instances of the class and superclasses of eventClass. Null value of this option is equal to setting it to the java.lang.Object i.e. the consumer will capture all messages incoming to the event bus. This option cannot be used together with listenerInterface option.||string|
|listenerInterface|The interface with method(s) marked with the Subscribe annotation. Dynamic proxy will be created over the interface so it could be registered as the EventBus listener. Particularly useful when creating multi-event listeners and for handling DeadEvent properly. This option cannot be used together with eventClass option.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
