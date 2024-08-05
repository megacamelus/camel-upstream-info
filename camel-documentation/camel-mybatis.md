# Mybatis

**Since Camel 2.7**

**Both producer and consumer are supported**

The MyBatis component allows you to query, poll, insert, update and
delete data in a relational database using
[MyBatis](http://mybatis.org/).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-mybatis</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    mybatis:statementName[?options]

Where **statementName** is the statement name in the MyBatis XML mapping
file which maps to the query, insert, update or delete operation you
wish to evaluate.

You can append query options to the URI in the following format,
`?option=value&option=value&...`

This component will by default load the MyBatis SqlMapConfig file from
the root of the classpath with the expected name of
`SqlMapConfig.xml`.  
If the file is located in another location, you will need to configure
the `configurationUri` option on the `MyBatisComponent` component.

# Message Body

The response from MyBatis will only be set as the body if it’s a
`SELECT` statement. That means, for example, for `INSERT` statements
Camel will not replace the body. This allows you to continue routing and
keep the original body. The response from MyBatis is always stored in
the header with the key `CamelMyBatisResult`.

# Samples

For example, if you wish to consume beans from a JMS queue and insert
them into a database, you could do the following:

    from("activemq:queue:newAccount")
      .to("mybatis:insertAccount?statementType=Insert");

Notice we have to specify the `statementType`, as we need to instruct
Camel which kind of operation to invoke.

Where **insertAccount** is the MyBatis ID in the SQL mapping file:

      <!-- Insert example, using the Account parameter class -->
      <insert id="insertAccount" parameterType="Account">
        insert into ACCOUNT (
          ACC_ID,
          ACC_FIRST_NAME,
          ACC_LAST_NAME,
          ACC_EMAIL
        )
        values (
          #{id}, #{firstName}, #{lastName}, #{emailAddress}
        )
      </insert>

# Using StatementType for better control of MyBatis

When routing to an MyBatis endpoint, you will want more fine-grained
control so you can control whether the SQL statement to be executed is a
`SELECT`, `UPDATE`, `DELETE` or `INSERT` etc. So for instance if we want
to route to an MyBatis endpoint in which the IN body contains parameters
to a `SELECT` statement we can do:

    from("direct:start")
            .to("mybatis:selectAccountById?statementType=SelectOne")
            .to("mock:result");

In the code above we can invoke the MyBatis statement
`selectAccountById` and the IN body should contain the account id we
want to retrieve, such as an `Integer` type.

We can do the same for some of the other operations, such as
`SelectList`:

    from("direct:start")
            .to("mybatis:selectAllAccounts?statementType=SelectList")
            .to("mock:result");

And the same for `UPDATE`, where we can send an `Account` object as the
IN body to MyBatis:

    from("direct:start")
            .to("mybatis:updateAccount?statementType=Update")
            .to("mock:result");

## Using InsertList StatementType

MyBatis allows you to insert multiple rows using its for-each batch
driver. To use this, you need to use the \<foreach\> in the mapper
XML file. For example, as shown below:

    <!-- Batch Insert example, using the Account parameter class -->
    <insert id="batchInsertAccount" parameterType="java.util.List">
        insert into ACCOUNT (
        ACC_ID,
        ACC_FIRST_NAME,
        ACC_LAST_NAME,
        ACC_EMAIL
        )
        values (
        <foreach item="Account" collection="list" open="" close="" separator="),(">
            #{Account.id}, #{Account.firstName}, #{Account.lastName}, #{Account.emailAddress}
        </foreach>
        )
    </insert>

Then you can insert multiple rows, by sending a Camel message to the
`mybatis` endpoint which uses the `InsertList` statement type, as shown
below:

    from("direct:start")
            .to("mybatis:batchInsertAccount?statementType=InsertList")
            .to("mock:result");

## Using UpdateList StatementType

MyBatis allows you to update multiple rows using its for-each batch
driver. To use this, you need to use the \<foreach\> in the mapper
XML file. For example, as shown below:

    <update id="batchUpdateAccount" parameterType="java.util.Map">
        update ACCOUNT set
        ACC_EMAIL = #{emailAddress}
        where
        ACC_ID in
        <foreach item="Account" collection="list" open="(" close=")" separator=",">
            #{Account.id}
        </foreach>
    </update>

Then you can update multiple rows, by sending a Camel message to the
mybatis endpoint which uses the UpdateList statement type, as shown
below:

    from("direct:start")
        .to("mybatis:batchUpdateAccount?statementType=UpdateList")
        .to("mock:result");

## Using DeleteList StatementType

MyBatis allows you to delete multiple rows using its for-each batch
driver. To use this, you need to use the \<foreach\> in the mapper
XML file. For example, as shown below:

    <delete id="batchDeleteAccountById" parameterType="java.util.List">
        delete from ACCOUNT
        where
        ACC_ID in
        <foreach item="AccountID" collection="list" open="(" close=")" separator=",">
            #{AccountID}
        </foreach>
    </delete>

Then you can delete multiple rows, by sending a Camel message to the
mybatis endpoint which uses the DeleteList statement type, as shown
below:

    from("direct:start")
        .to("mybatis:batchDeleteAccount?statementType=DeleteList")
        .to("mock:result");

## Notice on InsertList, UpdateList and DeleteList StatementTypes

Parameter of any type (List, Map, etc.) can be passed to mybatis, and an
end user is responsible for handling it as required with the help of
[mybatis dynamic
queries](http://www.mybatis.org/mybatis-3/dynamic-sql.html)
capabilities.

## Scheduled polling example

This component supports scheduled polling and can therefore be used as a
Polling Consumer. For example, to poll the database every minute:

    from("mybatis:selectAllAccounts?delay=60000")
      .to("activemq:queue:allAccounts");

Alternatively you can use another mechanism for triggering the scheduled
polls, such as the [Timer](#timer-component.adoc) or
[Quartz](#timer-component.adoc) components. In the sample below we poll
the database, every 30 seconds using the [Timer](#timer-component.adoc)
component and send the data to the JMS queue:

    from("timer://pollTheDatabase?delay=30000")
      .to("mybatis:selectAllAccounts")
      .to("activemq:queue:allAccounts");

And the MyBatis SQL mapping file used:

      <!-- Select with no parameters using the result map for Account class. -->
      <select id="selectAllAccounts" resultMap="AccountResult">
        select * from ACCOUNT
      </select>

## Using onConsume

This component supports executing statements **after** data have been
consumed and processed by Camel. This allows you to do post updates in
the database. Notice all statements must be `UPDATE` statements. Camel
supports executing multiple statements whose names should be separated
by commas.

The route below illustrates we execute the **consumeAccount** statement
data is processed. This allows us to change the status of the row in the
database to process, so we avoid consuming it twice or more.

    from("mybatis:selectUnprocessedAccounts?onConsume=consumeAccount")
        .to("mock:results");

And the statements in the sqlmap file:

    <update id="consumeAccount" parameterType="Account">
        update ACCOUNT set PROCESSED = true where ACC_ID = #{id}
    </update>

## Participating in transactions

Setting up a transaction manager under camel-mybatis can be a little bit
fiddly, as it involves externalising the database configuration outside
the standard MyBatis `SqlMapConfig.xml` file.

The first part requires the setup of a `DataSource`. This is typically a
pool (either DBCP, or c3p0), which needs to be wrapped in a Spring
proxy. This proxy enables non-Spring use of the `DataSource` to
participate in Spring transactions (the MyBatis `SqlSessionFactory` does
just this).

    <bean id="dataSource" class="org.springframework.jdbc.datasource.TransactionAwareDataSourceProxy">
        <constructor-arg>
            <bean class="com.mchange.v2.c3p0.ComboPooledDataSource">
                <property name="driverClass" value="org.postgresql.Driver"/>
                <property name="jdbcUrl" value="jdbc:postgresql://localhost:5432/myDatabase"/>
                <property name="user" value="myUser"/>
                <property name="password" value="myPassword"/>
            </bean>
        </constructor-arg>
    </bean>

This has the additional benefit of enabling the database configuration
to be externalised using property placeholders.

A transaction manager is then configured to manage the outermost
`DataSource`:

    <bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>

A [mybatis-spring](http://www.mybatis.org/spring/index.html)
[`SqlSessionFactoryBean`](http://www.mybatis.org/spring/factorybean.html)
then wraps that same `DataSource`:

    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="dataSource"/>
        <!-- standard mybatis config file -->
        <property name="configLocation" value="/META-INF/SqlMapConfig.xml"/>
        <!-- externalised mappers -->
        <property name="mapperLocations" value="classpath*:META-INF/mappers/**/*.xml"/>
    </bean>

The camel-mybatis component is then configured with that factory:

    <bean id="mybatis" class="org.apache.camel.component.mybatis.MyBatisComponent">
        <property name="sqlSessionFactory" ref="sqlSessionFactory"/>
    </bean>

Finally, a transaction policy is defined over the top of the transaction
manager, which can then be used as usual:

    <bean id="PROPAGATION_REQUIRED" class="org.apache.camel.spring.spi.SpringTransactionPolicy">
        <property name="transactionManager" ref="txManager"/>
        <property name="propagationBehaviorName" value="PROPAGATION_REQUIRED"/>
    </bean>
    
    <camelContext id="my-model-context" xmlns="http://camel.apache.org/schema/spring">
        <route id="insertModel">
            <from uri="direct:insert"/>
            <transacted ref="PROPAGATION_REQUIRED"/>
            <to uri="mybatis:myModel.insert?statementType=Insert"/>
        </route>
    </camelContext>

# MyBatis Spring Boot Starter integration

Spring Boot users can use
[mybatis-spring-boot-starter](https://mybatis.org/spring-boot-starter/mybatis-spring-boot-autoconfigure/)
artifact provided by the mybatis team

    <dependency>
      <groupId>org.mybatis.spring.boot</groupId>
      <artifactId>mybatis-spring-boot-starter</artifactId>
      <version>3.0.3</version>
    </dependency>

in particular, autoconfigured beans from mybatis-spring-boot-starter can
be used as follows:

    #application.properties
    camel.component.mybatis.sql-session-factory = #sqlSessionFactory

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configurationUri|Location of MyBatis xml configuration file. The default value is: SqlMapConfig.xml loaded from the classpath|SqlMapConfig.xml|string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|sqlSessionFactory|To use the SqlSessionFactory||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|statement|The statement name in the MyBatis XML mapping file which maps to the query, insert, update or delete operation you wish to evaluate.||string|
|maxMessagesPerPoll|This option is intended to split results returned by the database pool into the batches and deliver them in multiple exchanges. This integer defines the maximum messages to deliver in single exchange. By default, no maximum is set. Can be used to set a limit of e.g. 1000 to avoid when starting up the server that there are thousands of files. Set a value of 0 or negative to disable it.|0|integer|
|onConsume|Statement to run after data has been processed in the route||string|
|routeEmptyResultSet|Whether allow empty resultset to be routed to the next hop|false|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|transacted|Enables or disables transaction. If enabled then if processing an exchange failed then the consumer breaks out processing any further exchanges to cause a rollback eager.|false|boolean|
|useIterator|Process resultset individually or as a list|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|processingStrategy|To use a custom MyBatisProcessingStrategy||object|
|executorType|The executor type to be used while executing statements. simple - executor does nothing special. reuse - executor reuses prepared statements. batch - executor reuses statements and batches updates.|SIMPLE|object|
|inputHeader|User the header value for input parameters instead of the message body. By default, inputHeader == null and the input parameters are taken from the message body. If outputHeader is set, the value is used and query parameters will be taken from the header instead of the body.||string|
|outputHeader|Store the query result in a header instead of the message body. By default, outputHeader == null and the query result is stored in the message body, any existing content in the message body is discarded. If outputHeader is set, the value is used as the name of the header to store the query result and the original message body is preserved. Setting outputHeader will also omit populating the default CamelMyBatisResult header since it would be the same as outputHeader all the time.||string|
|statementType|Mandatory to specify for the producer to control which kind of operation to invoke.||object|
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
