# Jooq

**Since Camel 3.0**

**Both producer and consumer are supported**

The JOOQ component enables you to store and retrieve Java objects from
persistent storage using JOOQ library.

JOOQ provides DSL to create queries. There are two types of queries:

1.  org.jooq.Query - can be executed

2.  org.jooq.ResultQuery - can return results

For example:

    // Create a Query object and execute it:
    Query query = create.query("DELETE FROM BOOK");
    query.execute();
    
    // Create a ResultQuery object and execute it, fetching results:
    ResultQuery<Record> resultQuery = create.resultQuery("SELECT * FROM BOOK");
    Result<Record> result = resultQuery.fetch();

# Plain SQL

SQL could be executed using JOOQ’s objects "Query" or "ResultQuery".
Also, the SQL query could be specified inside URI:

    from("jooq://org.apache.camel.component.jooq.db.tables.records.BookStoreRecord?query=select * from book_store x where x.name = 'test'").to("bean:myBusinessLogic");

See the examples below.

# Consuming from endpoint

Consuming messages from a JOOQ consumer endpoint removes (or updates)
entity beans in the database. This allows you to use a database table as
a logical queue: consumers take messages from the queue and then
delete/update them to logically remove them from the queue. If you do
not wish to delete the entity bean when it has been processed, you can
specify consumeDelete=false on the URI.

## Operations

When using jooq as a producer you can use any of the following
`JooqOperation` operations:

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>none</p></td>
<td style="text-align: left;"><p>Execute a query (default)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>execute</p></td>
<td style="text-align: left;"><p>Execute a query with no expected
results</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>fetch</p></td>
<td style="text-align: left;"><p>Execute a query and the result of the
query is stored as the new message body</p></td>
</tr>
</tbody>
</table>

## Example:

JOOQ configuration:

    <?xml version="1.0" encoding="UTF-8"?>
    
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:context="http://www.springframework.org/schema/context"
           xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                               http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
    
        <context:property-placeholder location="classpath:config.properties"
                                      xmlns:context="http://www.springframework.org/schema/context"/>
    
        <bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
            <property name="url" value="${db.url}"/>
            <property name="driverClassName" value="${db.driver}"/>
            <property name="username" value="${db.username}"/>
            <property name="password" value="${db.password}"/>
        </bean>
    
        <bean id="transactionAwareDataSource"
              class="org.springframework.jdbc.datasource.TransactionAwareDataSourceProxy">
            <constructor-arg ref="dataSource"/>
        </bean>
    
        <bean class="org.jooq.impl.DataSourceConnectionProvider" name="connectionProvider">
            <constructor-arg ref="transactionAwareDataSource"/>
        </bean>
    
        <bean id="dsl" class="org.jooq.impl.DefaultDSLContext">
            <constructor-arg ref="config"/>
        </bean>
    
        <bean id="jooqConfig" class="org.jooq.impl.DefaultConfiguration" name="config">
            <property name="SQLDialect">
                <value type="org.jooq.SQLDialect">${jooq.sql.dialect}</value>
            </property>
            <property name="connectionProvider" ref="connectionProvider"/>
        </bean>
    
    </beans>

Camel context configuration:

    <?xml version="1.0" encoding="UTF-8"?>
    
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="
           http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
           http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd">
    
        <import resource="classpath:jooq-spring.xml"/>
    
        <!-- Configure component -->
        <bean id="jooq" class="org.apache.camel.component.jooq.JooqComponent">
            <property name="configuration">
                <bean id="jooqConfiguration" class="org.apache.camel.component.jooq.JooqConfiguration">
                    <property name="databaseConfiguration" ref="jooqConfig"/>
                </bean>
            </property>
        </bean>
    
        <camelContext xmlns="http://camel.apache.org/schema/spring">
            <!-- Create and store entity -->
            <route id="insert-route">
                <from uri="direct:insert"/>
                <transform>
                    <method ref="org.apache.camel.component.jooq.beans.BookStoreRecordBean" method="generate"/>
                </transform>
                <!-- Send entity to endpoint -->
                <to uri="jooq://org.apache.camel.component.jooq.db.tables.records.BookStoreRecord"/>
            </route>
    
            <!-- Create JOOQ ResultQuery and fetch -->
            <route id="execute-route">
                <from uri="direct:fetch"/>
                <transform>
                    <method ref="org.apache.camel.component.jooq.beans.BookStoreRecordBean" method="select"/>
                </transform>
                <to uri="jooq://org.apache.camel.component.jooq.db.tables.records.BookStoreRecord/fetch"/>
                <log message="Fetched ${body}"/>
            </route>
    
            <!-- Create JOOQ Query end execute -->
            <route id="query-route">
                <from uri="direct:execute"/>
                <transform>
                    <method ref="org.apache.camel.component.jooq.beans.BookStoreRecordBean" method="delete"/>
                </transform>
                <to uri="jooq://org.apache.camel.component.jooq.db.tables.records.BookStoreRecord/execute"/>
                <log message="Executed ${body}"/>
            </route>
    
            <!-- Consume entity -->
            <route id="queue-route">
                <from uri="jooq://org.apache.camel.component.jooq.db.tables.records.BookStoreRecord?consumeDelete=false"/>
                <log message="Consumed ${body}"/>
            </route>
    
            <!-- SQL: select -->
            <route id="sql-select">
                <from uri="direct:sql-select"/>
                <to uri="jooq://org.apache.camel.component.jooq.db.tables.records.BookStoreRecord/fetch?query=select * from book_store x where x.name = 'test'"/>
                <log message="Fetched ${body}"/>
            </route>
    
            <!-- SQL: delete -->
            <route id="sql-delete">
                <from uri="direct:sql-delete"/>
                <to uri="jooq://org.apache.camel.component.jooq.db.tables.records.BookStoreRecord/execute?query=delete from book_store x where x.name = 'test'"/>
                <log message="Fetched ${body}"/>
            </route>
    
            <!-- SQL: consume -->
            <route id="sql-consume">
                <from uri="jooq://org.apache.camel.component.jooq.db.tables.records.BookStoreRecord?query=select * from book_store x where x.name = 'test'"/>
                <log message="Fetched ${body}"/>
            </route>
        </camelContext>
    </beans>

Sample bean:

    @Component
    public class BookStoreRecordBean {
        private String name = "test";
    
        public BookStoreRecord generate() {
            return new BookStoreRecord(name);
        }
    
        public ResultQuery select() {
            return DSL.selectFrom(BOOK_STORE).where(BOOK_STORE.NAME.eq(name));
        }
    
        public Query delete() {
            return DSL.delete(BOOK_STORE).where(BOOK_STORE.NAME.eq(name));
        }
    }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|Component configuration (database connection, database entity type, etc.)||object|
|databaseConfiguration|To use a specific database configuration||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|consumeDelete|Delete entity after it is consumed|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|Type of operation to execute on query|NONE|object|
|query|To execute plain SQL query||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|entityType|JOOQ entity class||string|
|databaseConfiguration|To use a specific database configuration||object|
|consumeDelete|Delete entity after it is consumed|true|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|operation|Type of operation to execute on query|NONE|object|
|query|To execute plain SQL query||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
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
