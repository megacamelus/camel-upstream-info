# Optaplanner

**Since Camel 2.13**

**Both producer and consumer are supported**

The Optaplanner component solves the planning problem contained in a
message with [OptaPlanner](http://www.optaplanner.org/).  
For example, feed it an unsolved Vehicle Routing problem and it solves
it.

The component supports consumer listening for SloverManager results and
producer for processing Solution and ProblemChange.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-optaplanner</artifactId>
        <version>x.x.x</version><!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    optaplanner:problemName[?options]

You can append query options to the URI in the following format,
`?option=value&option=value&...`

# Message Body

Camel takes the planning problem for the *IN* body, solves it and
returns it on the *OUT* body. The *IN* body object supports the
following use cases:

-   If the body contains the `PlanningSolution` annotation, then it will
    be solved using the solver identified by solverId and either
    synchronously or asynchronously.

-   If the body is an instance of `ProblemChange`, then it will trigger
    `addProblemFactChange`.

-   If the body is none of the above types, then the producer will
    return the best result from the solver identified by `solverId`.

## Samples

Solve a planning problem on the ActiveMQ queue with OptaPlanner, passing
the SolverManager:

    from("activemq:My.Queue").
      .to("optaplanner:problemName?solverManager=#solverManager");

Expose OptaPlanner as a REST service, passing the Solver configuration
file:

    from("cxfrs:bean:rsServer?bindingStyle=SimpleConsumer")
      .to("optaplanner:problemName?configFile=/org/foo/barSolverConfig.xml");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|problemName|Problem name||string|
|configFile|If SolverManager is absent from the header OptaPlannerConstants.SOLVER\_MANAGER then a SolverManager will be created using this Optaplanner config file.||string|
|problemId|In case of using SolverManager : the problem id|1L|integer|
|solverId|Specifies the solverId to user for the solver instance key|DEFAULT\_SOLVER|string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|async|Specifies to perform operations in async mode|false|boolean|
|threadPoolSize|Specifies the thread pool size to use when async is true|10|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|solverManager|SolverManager||object|
