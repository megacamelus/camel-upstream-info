# Spring-batch

**Since Camel 2.10**

**Only producer is supported**

The Spring Batch component and support classes provide integration
bridge between Camel and [Spring
Batch](http://www.springsource.org/spring-batch) infrastructure.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-spring-batch</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    spring-batch:jobName[?options]

Where **jobName** represents the name of the Spring Batch job located in
the Camel registry. Alternatively, if a JobRegistry is provided, it will
be used to locate the job instead.

This component can only be used to define producer endpoints, which
means that you cannot use the Spring Batch component in a `from()`
statement.

# Usage

When the Spring Batch component receives the message, it triggers the
job execution. The job will be executed using the
`org.springframework.batch.core.launch.JobLaucher` instance resolved
according to the following algorithm:

-   if `JobLauncher` is manually set on the component, then use it.

-   if `jobLauncherRef` option is set on the component, then search
    Camel Registry for the `JobLauncher` with the given name.
    **Deprecated and will be removed in Camel 3.0!**

-   if there is `JobLauncher` registered in the Camel Registry under
    **jobLauncher** name, then use it.

-   if none of the steps above allow resolving the `JobLauncher` and
    there is exactly one `JobLauncher` instance in the Camel Registry,
    then use it.

All headers found in the message are passed to the `JobLauncher` as job
parameters. `String`, `Long`, `Double` and `java.util.Date` values are
copied to the `org.springframework.batch.core.JobParametersBuilder` -
other data types are converted to Strings.

# Examples

Triggering the Spring Batch job execution:

    from("direct:startBatch").to("spring-batch:myJob");

Triggering the Spring Batch job execution with the `JobLauncher` set
explicitly.

    from("direct:startBatch").to("spring-batch:myJob?jobLauncherRef=myJobLauncher");

A `JobExecution` instance returned by the `JobLauncher` is forwarded by
the `SpringBatchProducer` as the output message. You can use the
`JobExecution` instance to perform some operations using the Spring
Batch API directly.

    from("direct:startBatch").to("spring-batch:myJob").to("mock:JobExecutions");
    ...
    MockEndpoint mockEndpoint = ...;
    JobExecution jobExecution = mockEndpoint.getExchanges().get(0).getIn().getBody(JobExecution.class);
    BatchStatus currentJobStatus = jobExecution.getStatus();

## Support classes

Apart from the Component, Camel Spring Batch provides also support
classes, which can be used to hook into Spring Batch infrastructure.

### CamelItemReader

`CamelItemReader` can be used to read batch data directly from the Camel
infrastructure.

For example, the snippet below is configuring Spring Batch to read data
from JMS queue.

    <bean id="camelReader" class="org.apache.camel.component.spring.batch.support.CamelItemReader">
      <constructor-arg ref="consumerTemplate"/>
      <constructor-arg value="jms:dataQueue"/>
    </bean>
    
    <batch:job id="myJob">
      <batch:step id="step">
        <batch:tasklet>
          <batch:chunk reader="camelReader" writer="someWriter" commit-interval="100"/>
        </batch:tasklet>
      </batch:step>
    </batch:job>

### CamelItemWriter

`CamelItemWriter` has similar purpose as `CamelItemReader`, but it is
dedicated to write chunk of the processed data.

For example, the snippet below is configuring Spring Batch to read data
from JMS queue.

    <bean id="camelwriter" class="org.apache.camel.component.spring.batch.support.CamelItemWriter">
      <constructor-arg ref="producerTemplate"/>
      <constructor-arg value="jms:dataQueue"/>
    </bean>
    
    <batch:job id="myJob">
      <batch:step id="step">
        <batch:tasklet>
          <batch:chunk reader="someReader" writer="camelwriter" commit-interval="100"/>
        </batch:tasklet>
      </batch:step>
    </batch:job>

### CamelItemProcessor

`CamelItemProcessor` is the implementation of Spring Batch
`org.springframework.batch.item.ItemProcessor` interface. The latter
implementation relays on the [Request Reply
pattern](http://camel.apache.org/request-reply.html) to delegate the
processing of the batch item to the Camel infrastructure. The item to
process is sent to the Camel endpoint as the body of the message.

For example, the snippet below performs simple processing of the batch
item using the [Direct endpoint](http://camel.apache.org/direct.html)
and the [Simple expression
language](http://camel.apache.org/simple.html).

    <camel:camelContext>
      <camel:route>
        <camel:from uri="direct:processor"/>
        <camel:setExchangePattern pattern="InOut"/>
        <camel:setBody>
          <camel:simple>Processed ${body}</camel:simple>
        </camel:setBody>
      </camel:route>
    </camel:camelContext>
    
    <bean id="camelProcessor" class="org.apache.camel.component.spring.batch.support.CamelItemProcessor">
      <constructor-arg ref="producerTemplate"/>
      <constructor-arg value="direct:processor"/>
    </bean>
    
    <batch:job id="myJob">
      <batch:step id="step">
        <batch:tasklet>
          <batch:chunk reader="someReader" writer="someWriter" processor="camelProcessor" commit-interval="100"/>
        </batch:tasklet>
      </batch:step>
    </batch:job>

### CamelJobExecutionListener

`CamelJobExecutionListener` is the implementation of the
`org.springframework.batch.core.JobExecutionListener` interface sending
job execution events to the Camel endpoint.

The `org.springframework.batch.core.JobExecution` instance produced by
the Spring Batch is sent as a body of the message. To distinguish
between before- and after-callbacks `SPRING_BATCH_JOB_EVENT_TYPE` header
is set to the `BEFORE` or `AFTER` value.

The example snippet below sends Spring Batch job execution events to the
JMS queue.

    <bean id="camelJobExecutionListener" class="org.apache.camel.component.spring.batch.support.CamelJobExecutionListener">
      <constructor-arg ref="producerTemplate"/>
      <constructor-arg value="jms:batchEventsBus"/>
    </bean>
    
    <batch:job id="myJob">
      <batch:step id="step">
        <batch:tasklet>
          <batch:chunk reader="someReader" writer="someWriter" commit-interval="100"/>
        </batch:tasklet>
      </batch:step>
      <batch:listeners>
        <batch:listener ref="camelJobExecutionListener"/>
      </batch:listeners>
    </batch:job>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|jobLauncher|Explicitly specifies a JobLauncher to be used.||object|
|jobRegistry|Explicitly specifies a JobRegistry to be used.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|jobName|The name of the Spring Batch job located in the registry.||string|
|jobFromHeader|Explicitly defines if the jobName should be taken from the headers instead of the URI.|false|boolean|
|jobLauncher|Explicitly specifies a JobLauncher to be used.||object|
|jobRegistry|Explicitly specifies a JobRegistry to be used.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
