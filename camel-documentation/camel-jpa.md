# Jpa

**Since Camel 1.0**

**Both producer and consumer are supported**

The JPA component enables you to store and retrieve Java objects from
persistent storage using EJB 3’s Java Persistence Architecture (JPA).
JPA is a standard interface layer that wraps Object/Relational Mapping
(ORM) products such as OpenJPA, Hibernate, TopLink, and so on.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jpa</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    jpa:entityClassName[?options]

For sending to the endpoint, the *entityClassName* is optional. If
specified, it helps the [Type
Converter](http://camel.apache.org/type-converter.html) to ensure the
body is of the correct type.

For consuming, the *entityClassName* is mandatory.

# Usage

## Sending to the endpoint

You can store a Java entity bean in a database by sending it to a JPA
producer endpoint. The body of the *In* message is assumed to be an
entity bean (that is a POJO with an
[@Entity](https://jakarta.ee/specifications/persistence/2.2/apidocs/javax/persistence/entity)
annotation on it) or a collection or array of entity beans.

If the body is a List of entities, make sure to use
**entityType=java.util.List** as a configuration passed to the producer
endpoint.

If the body does not contain one of the previous listed types, put a
Message Translator in front of the endpoint to perform the necessary
conversion first.

You can use `query`, `namedQuery` or `nativeQuery` for the producer as
well. Also in the value of the `parameters`, you can use Simple
expression which allows you to retrieve parameter values from Message
body, header, etc. Those query can be used for retrieving a set of data
with using `SELECT` JPQL/SQL statement as well as executing bulk
update/delete with using `UPDATE`/`DELETE` JPQL/SQL statement. Please
note that you need to specify `useExecuteUpdate` to `true` if you
execute `UPDATE`/`DELETE` with `namedQuery` as Camel doesn’t look into
the named query unlike `query` and `nativeQuery`.

## Consuming from the endpoint

Consuming messages from a JPA consumer endpoint removes (or updates)
entity beans in the database. This allows you to use a database table as
a logical queue: consumers take messages from the queue and then
delete/update them to logically remove them from the queue.

If you do not wish to delete the entity bean when it has been processed
(and when routing is done), you can specify `consumeDelete=false` on the
URI. This will result in the entity being processed in each poll.

If you would rather perform some update on the entity to mark it as
processed (such as to exclude it from a future query), then you can
annotate a method with
[@Consumed](https://www.javadoc.io/doc/org.apache.camel/camel-jpa/current/org/apache/camel/component/jpa/Consumed.html).
It will be invoked on your entity bean when the entity bean has been
processed (and when routing is done).

You can use
[@PreConsumed](https://www.javadoc.io/doc/org.apache.camel/camel-jpa/current/org/apache/camel/component/jpa/PreConsumed.html)
which will be invoked on your entity bean before it has been processed
(before routing).

If you are consuming a lot of rows (100K+) and experience `OutOfMemory`
problems, you should set the `maximumResults` to a sensible value.

## Configuring EntityManagerFactory

It’s strongly advised to configure the JPA component to use a specific
`EntityManagerFactory` instance. If failed to do so each `JpaEndpoint`
will auto create their own instance of `EntityManagerFactory` which most
often is not what you want.

For example, you can instantiate a JPA component that references the
`myEMFactory` entity manager factory, as follows:

    <bean id="jpa" class="org.apache.camel.component.jpa.JpaComponent">
       <property name="entityManagerFactory" ref="myEMFactory"/>
    </bean>

The `JpaComponent` looks up automatically the `EntityManagerFactory`
from the Registry which means you do not need to configure this on the
`JpaComponent` as shown above. You only need to do so if there is
ambiguity, in which case Camel will log a WARN.

## Configuring TransactionStrategy

The `TransactionStrategy` is a vendor neutral abstraction that allows
`camel-jpa` to easily plug in and work with Spring `TransactionManager`
or Quarkus Transaction API.

The `JpaComponent` looks up automatically the `TransactionStrategy` from
the Registry. If Camel cannot find any `TransactionStrategy` instance
registered, it will also look up for the `TransactionTemplate` and try
to extract `TransactionStrategy` from it.

If none `TransactionTemplate` is available in the registry,
`JpaEndpoint` will auto create a default instance
(`org.apache.camel.component.jpa.DefaultTransactionStrategy`) of
`TransactionStrategy` which most often is not what you want.

If more than single instance of the `TransactionStrategy` is found,
Camel will log a WARN. In such cases you might want to instantiate and
explicitly configure a JPA component that references the
`myTransactionManager` transaction manager, as follows:

    <bean id="jpa" class="org.apache.camel.component.jpa.JpaComponent">
       <property name="entityManagerFactory" ref="myEMFactory"/>
       <property name="transactionStrategy" ref="myTransactionStrategy"/>
    </bean>

## Using a consumer with a named query

For consuming only selected entities, you can use the `namedQuery` URI
query option. First, you have to define the named query in the JPA
Entity class:

    @Entity
    @NamedQuery(name = "step1", query = "select x from MultiSteps x where x.step = 1")
    public class MultiSteps {
       ...
    }

After that, you can define a consumer uri like this one:

    from("jpa://org.apache.camel.examples.MultiSteps?namedQuery=step1")
    .to("bean:myBusinessLogic");

## Using a consumer with a query

For consuming only selected entities, you can use the `query` URI query
option. You only have to define the query option:

    from("jpa://org.apache.camel.examples.MultiSteps?query=select o from org.apache.camel.examples.MultiSteps o where o.step = 1")
    .to("bean:myBusinessLogic");

## Using a consumer with a native query

For consuming only selected entities, you can use the `nativeQuery` URI
query option. You only have to define the native query option:

    from("jpa://org.apache.camel.examples.MultiSteps?nativeQuery=select * from MultiSteps where step = 1")
    .to("bean:myBusinessLogic");

If you use the native query option, you will receive an object array in
the message body.

## Using a producer with a named query

For retrieving selected entities or execute bulk update/delete, you can
use the `namedQuery` URI query option. First, you have to define the
named query in the JPA Entity class:

    @Entity
    @NamedQuery(name = "step1", query = "select x from MultiSteps x where x.step = 1")
    public class MultiSteps {
       ...
    }

After that, you can define a producer uri like this one:

    from("direct:namedQuery")
    .to("jpa://org.apache.camel.examples.MultiSteps?namedQuery=step1");

Note that you need to specify `useExecuteUpdate` option to `true` to
execute `UPDATE`/`DELETE` statement as a named query.

## Using a producer with a query

For retrieving selected entities or execute bulk update/delete, you can
use the `query` URI query option. You only have to define the query
option:

    from("direct:query")
    .to("jpa://org.apache.camel.examples.MultiSteps?query=select o from org.apache.camel.examples.MultiSteps o where o.step = 1");

## Using a producer with a native query

For retrieving selected entities or execute bulk update/delete, you can
use the `nativeQuery` URI query option. You only have to define the
native query option:

    from("direct:nativeQuery")
    .to("jpa://org.apache.camel.examples.MultiSteps?resultClass=org.apache.camel.examples.MultiSteps&nativeQuery=select * from MultiSteps where step = 1");

If you use the native query option without specifying `resultClass`, you
will receive an object array in the message body.

## Using the JPA-Based Idempotent Repository

The Idempotent Consumer from the [EIP
patterns](http://camel.apache.org/enterprise-integration-patterns.html)
is used to filter out duplicate messages. A JPA-based idempotent
repository is provided.

To use the JPA based idempotent repository.

1.  Set up a `persistence-unit` in the persistence.xml file:

2.  Set up a `org.springframework.orm.jpa.JpaTemplate` which is used by
    the
    `org.apache.camel.processor.idempotent.jpa.JpaMessageIdRepository`:

3.  Configure the error formatting macro: snippet:
    java.lang.IndexOutOfBoundsException: Index: 20, Size: 20

4.  Configure the idempotent repository:
    `org.apache.camel.processor.idempotent.jpa.JpaMessageIdRepository`:

5.  Create the JPA idempotent repository in the Spring XML file:

<!-- -->

    <camelContext xmlns="http://camel.apache.org/schema/spring">
        <route id="JpaMessageIdRepositoryTest">
            <from uri="direct:start" />
            <idempotentConsumer idempotentRepository="jpaStore">
                <header>messageId</header>
                <to uri="mock:result" />
            </idempotentConsumer>
        </route>
    </camelContext>

# Important Development Notes

If you run the [tests of this
component](https://github.com/apache/camel/tree/main/components/camel-jpa/src/test)
directly inside your IDE, and not through Maven, then you could see
exceptions like these:

    org.springframework.transaction.CannotCreateTransactionException: Could not open JPA EntityManager for transaction; nested exception is
    <openjpa-2.2.1-r422266:1396819 nonfatal user error> org.apache.openjpa.persistence.ArgumentException: This configuration disallows runtime optimization,
    but the following listed types were not enhanced at build time or at class load time with a javaagent: "org.apache.camel.examples.SendEmail".
        at org.springframework.orm.jpa.JpaTransactionManager.doBegin(JpaTransactionManager.java:427)
        at org.springframework.transaction.support.AbstractPlatformTransactionManager.getTransaction(AbstractPlatformTransactionManager.java:371)
        at org.springframework.transaction.support.TransactionTemplate.execute(TransactionTemplate.java:127)
        at org.apache.camel.processor.jpa.JpaRouteTest.cleanupRepository(JpaRouteTest.java:96)
        at org.apache.camel.processor.jpa.JpaRouteTest.createCamelContext(JpaRouteTest.java:67)
        at org.apache.camel.test.junit5.CamelTestSupport.doSetUp(CamelTestSupport.java:238)
        at org.apache.camel.test.junit5.CamelTestSupport.setUp(CamelTestSupport.java:208)

The problem here is that the source has been compiled or recompiled
through your IDE and not through Maven, which would [enhance the
byte-code at build
time](https://github.com/apache/camel/blob/main/components/camel-jpa/pom.xml).
To overcome this, you need to enable [dynamic byte-code enhancement of
OpenJPA](http://openjpa.apache.org/entity-enhancement.html#dynamic-enhancement).
For example, assuming the current OpenJPA version being used in Camel is
2\.2.1, to run the tests inside your IDE, you would need to pass the
following argument to the JVM:

    -javaagent:<path_to_your_local_m2_cache>/org/apache/openjpa/openjpa/2.2.1/openjpa-2.2.1.jar

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|aliases|Maps an alias to a JPA entity class. The alias can then be used in the endpoint URI (instead of the fully qualified class name).||object|
|entityManagerFactory|To use the EntityManagerFactory. This is strongly recommended to configure.||object|
|joinTransaction|The camel-jpa component will join transaction by default. You can use this option to turn this off, for example if you use LOCAL\_RESOURCE and join transaction doesn't work with your JPA provider. This option can also be set globally on the JpaComponent, instead of having to set it on all endpoints.|true|boolean|
|sharedEntityManager|Whether to use Spring's SharedEntityManager for the consumer/producer. Note in most cases joinTransaction should be set to false as this is not an EXTENDED EntityManager.|false|boolean|
|transactionStrategy|To use the TransactionStrategy for running the operations in a transaction.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|entityType|Entity class name||string|
|joinTransaction|The camel-jpa component will join transaction by default. You can use this option to turn this off, for example, if you use LOCAL\_RESOURCE and join transaction doesn't work with your JPA provider. This option can also be set globally on the JpaComponent, instead of having to set it on all endpoints.|true|boolean|
|maximumResults|Set the maximum number of results to retrieve on the Query.|-1|integer|
|namedQuery|To use a named query.||string|
|nativeQuery|To use a custom native query. You may want to use the option resultClass also when using native queries.||string|
|persistenceUnit|The JPA persistence unit used by default.|camel|string|
|query|To use a custom query.||string|
|resultClass|Defines the type of the returned payload (we will call entityManager.createNativeQuery(nativeQuery, resultClass) instead of entityManager.createNativeQuery(nativeQuery)). Without this option, we will return an object array. Only has an effect when using in conjunction with a native query when consuming data.||string|
|consumeDelete|If true, the entity is deleted after it is consumed; if false, the entity is not deleted.|true|boolean|
|consumeLockEntity|Specifies whether to set an exclusive lock on each entity bean while processing the results from polling.|true|boolean|
|deleteHandler|To use a custom DeleteHandler to delete the row after the consumer is done processing the exchange||object|
|lockModeType|To configure the lock mode on the consumer.|PESSIMISTIC\_WRITE|object|
|maxMessagesPerPoll|An integer value to define the maximum number of messages to gather per poll. By default, no maximum is set. It can be used to avoid polling many thousands of messages when starting up the server. Set a value of 0 or negative to disable.||integer|
|preDeleteHandler|To use a custom Pre-DeleteHandler to delete the row after the consumer has read the entity.||object|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|skipLockedEntity|To configure whether to use NOWAIT on lock and silently skip the entity.|false|boolean|
|transacted|Whether to run the consumer in transacted mode, by which all messages will either commit or rollback, when the entire batch has been processed. The default behavior (false) is to commit all the previously successfully processed messages, and only roll back the last failed message.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|parameters|This key/value mapping is used for building the query parameters. It is expected to be of the generic type java.util.Map where the keys are the named parameters of a given JPA query and the values are their corresponding effective values you want to select for. When it's used for producer, Simple expression can be used as a parameter value. It allows you to retrieve parameter values from the message body, header and etc.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|findEntity|If enabled, then the producer will find a single entity by using the message body as a key and entityType as the class type. This can be used instead of a query to find a single entity.|false|boolean|
|firstResult|Set the position of the first result to retrieve.|-1|integer|
|flushOnSend|Flushes the EntityManager after the entity bean has been persisted.|true|boolean|
|outputTarget|To put the query (or find) result in a header or property instead of the body. If the value starts with the prefix property:, put the result into the so named property, otherwise into the header.||string|
|remove|Indicates to use entityManager.remove(entity).|false|boolean|
|singleResult|If enabled, a query or a find which would return no results or more than one result, will throw an exception instead.|false|boolean|
|useExecuteUpdate|To configure whether to use executeUpdate() when producer executes a query. When you use INSERT, UPDATE or a DELETE statement as a named query, you need to specify this option to 'true'.||boolean|
|usePersist|Indicates to use entityManager.persist(entity) instead of entityManager.merge(entity). Note: entityManager.persist(entity) doesn't work for detached entities (where the EntityManager has to execute an UPDATE instead of an INSERT query)!|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|usePassedInEntityManager|If set to true, then Camel will use the EntityManager from the header JpaConstants.ENTITY\_MANAGER instead of the configured entity manager on the component/endpoint. This allows end users to control which entity manager will be in use.|false|boolean|
|entityManagerProperties|Additional properties for the entity manager to use.||object|
|sharedEntityManager|Whether to use Spring's SharedEntityManager for the consumer/producer. Note in most cases, joinTransaction should be set to false as this is not an EXTENDED EntityManager.|false|boolean|
|backoffErrorThreshold|The number of subsequent error polls (failed due some error) that should happen before the backoffMultipler should kick-in.||integer|
|backoffIdleThreshold|The number of subsequent idle polls that should happen before the backoffMultipler should kick-in.||integer|
|backoffMultiplier|To let the scheduled polling consumer backoff if there has been a number of subsequent idles/errors in a row. The multiplier is then the number of polls that will be skipped before the next actual attempt is happening again. When this option is in use then backoffIdleThreshold and/or backoffErrorThreshold must also be configured.||integer|
|delay|Milliseconds before the next poll.|500|integer|
|greedy|If greedy is enabled, then the ScheduledPollConsumer will run immediately again, if the previous run polled 1 or more messages.|false|boolean|
|initialDelay|Milliseconds before the first poll starts.|1000|integer|
|repeatCount|Specifies a maximum limit of number of fires. So if you set it to 1, the scheduler will only fire once. If you set it to 5, it will only fire five times. A value of zero or negative means fire forever.|0|integer|
|runLoggingLevel|The consumer logs a start/complete log line when it polls. This option allows you to configure the logging level for that.|TRACE|object|
|scheduledExecutorService|Allows for configuring a custom/shared thread pool to use for the consumer. By default each consumer has its own single threaded thread pool.||object|
|scheduler|To use a cron scheduler from either camel-spring or camel-quartz component. Use value spring or quartz for built in scheduler|none|object|
|schedulerProperties|To configure additional properties when using a custom scheduler or any of the Quartz, Spring based scheduler.||object|
|startScheduler|Whether the scheduler should be auto started.|true|boolean|
|timeUnit|Time unit for initialDelay and delay options.|MILLISECONDS|object|
|useFixedDelay|Controls if fixed delay or fixed rate is used. See ScheduledExecutorService in JDK for details.|true|boolean|
