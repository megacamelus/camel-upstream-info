# Quartz

**Since Camel 2.12**

**Only consumer is supported**

The Quartz component provides a scheduled delivery of messages using the
[Quartz Scheduler 2.x](http://www.quartz-scheduler.org/).  
Each endpoint represents a different timer (in Quartz terms, a Trigger
and JobDetail).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-quartz</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    quartz://timerName?options
    quartz://groupName/timerName?options
    quartz://groupName/timerName?cron=expression
    quartz://timerName?cron=expression

The component uses either a `CronTrigger` or a `SimpleTrigger`. If no
cron expression is provided, the component uses a simple trigger. If no
`groupName` is provided, the quartz component uses the `Camel` group
name.

# Configuring quartz.properties file

By default, Quartz will look for a `quartz.properties` file in the
`org/quartz` directory of the classpath. If you are using WAR
deployments, this means just drop the quartz.properties in
`WEB-INF/classes/org/quartz`.

However, the Camel [Quartz](#quartz-component.adoc) component also
allows you to configure properties:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Parameter</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>properties</code></p></td>
<td style="text-align: left;"><p><code>null</code></p></td>
<td style="text-align: left;"><p><code>Properties</code></p></td>
<td style="text-align: left;"><p>You can configure a
<code>java.util.Properties</code> instance.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>propertiesFile</code></p></td>
<td style="text-align: left;"><p><code>null</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>File name of the properties to load
from the classpath</p></td>
</tr>
</tbody>
</table>

To do this, you can configure this in Spring XML as follows

    <bean id="quartz" class="org.apache.camel.component.quartz.QuartzComponent">
        <property name="propertiesFile" value="com/mycompany/myquartz.properties"/>
    </bean>

# Enabling Quartz scheduler in JMX

You need to configure the quartz scheduler properties to enable JMX.  
That is typically setting the option `"org.quartz.scheduler.jmx.export"`  
to a `true` value in the configuration file.

This option is set to true by default, unless explicitly disabled.

# Clustering

If you use Quartz in clustered mode, e.g., the `JobStore` is clustered.
Then the [Quartz](#quartz-component.adoc) component will **not**
pause/remove triggers when a node is being stopped/shutdown. This allows
the trigger to keep running on the other nodes in the cluster.

When running in clustered node, no checking is done to ensure unique job
name/group for endpoints.

# Message Headers

Camel adds the getters from the Quartz Execution Context as header
values. The following headers are added:  
`calendar`, `fireTime`, `jobDetail`, `jobInstance`, `jobRuntTime`,
`mergedJobDataMap`, `nextFireTime`, `previousFireTime`, `refireCount`,
`result`, `scheduledFireTime`, `scheduler`, `trigger`, `triggerName`,
`triggerGroup`.

The `fireTime` header contains the `java.util.Date` of when the exchange
was fired.

# Using Cron Triggers

Quartz supports [Cron-like
expressions](http://www.quartz-scheduler.org/documentation/quartz-2.3.0/tutorials/crontrigger.html)
for specifying timers in a handy format. You can use these expressions
in the `cron` URI parameter; though, to preserve valid URI encoding, we
allow `+` to be used instead of spaces.

For example, the following will fire a message every five minutes
starting at 12pm (noon) to 6pm on weekdays:

    from("quartz://myGroup/myTimerName?cron=0+0/5+12-18+?+*+MON-FRI")
        .to("activemq:Totally.Rocks");

which is equivalent to using the cron expression

    0 0/5 12-18 ? * MON-FRI

The following table shows the URI character encodings we use to preserve
valid URI syntax:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">URI Character</th>
<th style="text-align: left;">Cron character</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>+</code></p></td>
<td style="text-align: left;"><p><em>Space</em></p></td>
</tr>
</tbody>
</table>

# Specifying time zone

The Quartz Scheduler allows you to configure time zone per trigger. For
example, to use a time zone of your country, then you can do as follows:

    quartz://groupName/timerName?cron=0+0/5+12-18+?+*+MON-FRI&trigger.timeZone=Europe/Stockholm

The timeZone value is the values accepted by `java.util.TimeZone`.

# Specifying start date

The Quartz Scheduler allows you to configure start date per trigger. You
can provide the start date in the date format yyyy-MM-dd’T'HH:mm:ssz.

    quartz://groupName/timerName?cron=0+0/5+12-18+?+*+MON-FRI&trigger.startAt=2023-11-22T14:32:36UTC

# Specifying end date

The Quartz Scheduler allows you to configure end date per trigger. You
can provide the end date in the date format yyyy-MM-dd’T'HH:mm:ssz.

    quartz://groupName/timerName?cron=0+0/5+12-18+?+*+MON-FRI&trigger.endAt=2023-11-22T14:32:36UTC

Note: Start and end dates may be affected by time drifts and
unpredictable behavior during daylight-saving time changes. Exercise
caution, especially in environments where precise timing is critical.

# Configuring misfire instructions

The quartz scheduler can be configured with a misfire instruction to
handle misfire situations for the trigger. The concrete trigger type
that you are using will have defined a set of additional
`MISFIRE_INSTRUCTION_XXX` constants that may be set as this property’s
value.

For example, to configure the simple trigger to use misfire instruction
4:

    quartz://myGroup/myTimerName?trigger.repeatInterval=2000&trigger.misfireInstruction=4

And likewise, you can configure the cron trigger with one of its misfire
instructions as well:

    quartz://myGroup/myTimerName?cron=0/2+*+*+*+*+?&trigger.misfireInstruction=2

The simple and cron triggers have the following misfire instructions
representative:

## SimpleTrigger.MISFIRE\_INSTRUCTION\_FIRE\_NOW = 1 (default)

Instructs the Scheduler that upon a mis-fire situation, the
SimpleTrigger wants to be fired now by Scheduler.

This instruction should typically only be used for *one-shot*
(non-repeating) Triggers. If it is used on a trigger with a repeat count
\> 0, then it is equivalent to the instruction
`MISFIRE_INSTRUCTION_RESCHEDULE_NOW_WITH_REMAINING_REPEAT_COUNT`.

## SimpleTrigger.MISFIRE\_INSTRUCTION\_RESCHEDULE\_NOW\_WITH\_EXISTING\_REPEAT\_COUNT = 2

Instructs the Scheduler that upon a mis-fire situation, the
SimpleTrigger wants to be re-scheduled to `now` (even if the associated
Calendar excludes `now`) with the repeat count left as-is. This does
obey the Trigger end-time, however, so if `now` is after the end-time
the Trigger will not fire again.

Use of this instruction causes the trigger to *forget* the start-time
and repeat-count that it was originally setup with. This is only an
issue if you for some reason wanted to be able to tell what the original
values were at some later time.

## SimpleTrigger.MISFIRE\_INSTRUCTION\_RESCHEDULE\_NOW\_WITH\_REMAINING\_REPEAT\_COUNT = 3

Instructs the Scheduler that upon a mis-fire situation, the
SimpleTrigger wants to be re-scheduled to `now` (even if the associated
Calendar excludes `now`) with the repeat count set to what it would be,
if it had not missed any firings. This does obey the Trigger end-time,
however, so if `now` is after the end-time the Trigger will not fire
again.

Use of this instruction causes the trigger to *forget* the start-time
and repeat-count that it was originally setup with. Instead, the repeat
count on the trigger will be changed to whatever the remaining repeat
count is. This is only an issue if you for some reason wanted to be able
to tell what the original values were at some later time.

This instruction could cause the Trigger to go to the *COMPLETE* state
after firing `now`, if all the repeat-fire-times where missed.

## SimpleTrigger.MISFIRE\_INSTRUCTION\_RESCHEDULE\_NEXT\_WITH\_REMAINING\_COUNT = 4

Instructs the Scheduler that upon a mis-fire situation, the
SimpleTrigger wants to be re-scheduled to the next scheduled time after
`now` - taking into account any associated Calendar and with the repeat
count set to what it would be, if it had not missed any firings.

This instruction could cause the Trigger to go directly to the
*COMPLETE* state if all fire-times where missed.

## SimpleTrigger.MISFIRE\_INSTRUCTION\_RESCHEDULE\_NEXT\_WITH\_EXISTING\_COUNT = 5

Instructs the Scheduler that upon a mis-fire situation, the
SimpleTrigger wants to be re-scheduled to the next scheduled time after
`now` - taking into account any associated Calendar, and with the repeat
count left unchanged.

This instruction could cause the Trigger to go directly to the
*COMPLETE* state if the end-time of the trigger has arrived.

## CronTrigger.MISFIRE\_INSTRUCTION\_FIRE\_ONCE\_NOW = 1 (default)

Instructs the Scheduler that upon a mis-fire situation, the CronTrigger
wants to be fired now by Scheduler.

## CronTrigger.MISFIRE\_INSTRUCTION\_DO\_NOTHING = 2

Instructs the Scheduler that upon a mis-fire situation, the CronTrigger
wants to have its next-fire-time updated to the next time in the
schedule after the current time (taking into account any associated
Calendar. However, it does not want to be fired now.

# Using QuartzScheduledPollConsumerScheduler

The [Quartz](#quartz-component.adoc) component provides a Polling
Consumer scheduler which allows to use cron based scheduling for
[Polling Consumers](#eips:polling-consumer.adoc) such as the File and
FTP consumers.

For example, to use a cron based expression to poll for files every
second second, then a Camel route can be defined simply as:

        from("file:inbox?scheduler=quartz&scheduler.cron=0/2+*+*+*+*+?")
           .to("bean:process");

Notice we define the `scheduler=quartz` to instruct Camel to use the
[Quartz-based](#quartz-component.adoc) scheduler. Then we use
`scheduler.xxx` options to configure the scheduler. The
[Quartz](#quartz-component.adoc) scheduler requires the cron option to
be set.

The following options are supported:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Parameter</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>quartzScheduler</code></p></td>
<td style="text-align: left;"><p><code>null</code></p></td>
<td
style="text-align: left;"><p><code>org.quartz.Scheduler</code></p></td>
<td style="text-align: left;"><p>To use a custom Quartz scheduler. If
none is configured, then the shared scheduler from the <a
href="#quartz-component.adoc">Quartz</a> component is used.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>cron</code></p></td>
<td style="text-align: left;"><p><code>null</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p><strong>Mandatory</strong>: To define
the cron expression for triggering the polls.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>triggerId</code></p></td>
<td style="text-align: left;"><p><code>null</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>To specify the trigger id. If none is
provided, then a UUID is generated and used.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>triggerGroup</code></p></td>
<td
style="text-align: left;"><p><code>QuartzScheduledPollConsumerScheduler</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>To specify the trigger group.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>timeZone</code></p></td>
<td style="text-align: left;"><p><code>Default</code></p></td>
<td style="text-align: left;"><p><code>TimeZone</code></p></td>
<td style="text-align: left;"><p>The time zone to use for the CRON
trigger.</p></td>
</tr>
</tbody>
</table>

**Important:** Remember configuring these options from the endpoint URIs
must be prefixed with `scheduler.`. For example, to configure the
trigger id and group:

        from("file:inbox?scheduler=quartz&scheduler.cron=0/2+*+*+*+*+?&scheduler.triggerId=myId&scheduler.triggerGroup=myGroup")
           .to("bean:process");

There is also a CRON scheduler in Spring, so you can use the following
as well:

        from("file:inbox?scheduler=spring&scheduler.cron=0/2+*+*+*+*+?")
           .to("bean:process");

# Cron Component Support

The Quartz component can be used as implementation of the Camel Cron
component.

Maven users will need to add the following additional dependency to
their `pom.xml`:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-cron</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

Users can then use the cron component instead of the quartz component,
as in the following route:

        from("cron://name?schedule=0+0/5+12-18+?+*+MON-FRI")
        .to("activemq:Totally.Rocks");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|enableJmx|Whether to enable Quartz JMX which allows to manage the Quartz scheduler from JMX. This options is default true|true|boolean|
|prefixInstanceName|Whether to prefix the Quartz Scheduler instance name with the CamelContext name. This is enabled by default, to let each CamelContext use its own Quartz scheduler instance by default. You can set this option to false to reuse Quartz scheduler instances between multiple CamelContext's.|true|boolean|
|prefixJobNameWithEndpointId|Whether to prefix the quartz job with the endpoint id. This option is default false.|false|boolean|
|properties|Properties to configure the Quartz scheduler.||object|
|propertiesFile|File name of the properties to load from the classpath||string|
|propertiesRef|References to an existing Properties or Map to lookup in the registry to use for configuring quartz.||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|scheduler|To use the custom configured Quartz scheduler, instead of creating a new Scheduler.||object|
|schedulerFactory|To use the custom SchedulerFactory which is used to create the Scheduler.||object|
|autoStartScheduler|Whether the scheduler should be auto started. This option is default true|true|boolean|
|interruptJobsOnShutdown|Whether to interrupt jobs on shutdown which forces the scheduler to shutdown quicker and attempt to interrupt any running jobs. If this is enabled then any running jobs can fail due to being interrupted. When a job is interrupted then Camel will mark the exchange to stop continue routing and set java.util.concurrent.RejectedExecutionException as caused exception. Therefore use this with care, as its often better to allow Camel jobs to complete and shutdown gracefully.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|groupName|The quartz group name to use. The combination of group name and trigger name should be unique.|Camel|string|
|triggerName|The quartz trigger name to use. The combination of group name and trigger name should be unique.||string|
|cron|Specifies a cron expression to define when to trigger.||string|
|deleteJob|If set to true, then the trigger automatically delete when route stop. Else if set to false, it will remain in scheduler. When set to false, it will also mean user may reuse pre-configured trigger with camel Uri. Just ensure the names match. Notice you cannot have both deleteJob and pauseJob set to true.|true|boolean|
|durableJob|Whether or not the job should remain stored after it is orphaned (no triggers point to it).|false|boolean|
|pauseJob|If set to true, then the trigger automatically pauses when route stop. Else if set to false, it will remain in scheduler. When set to false, it will also mean user may reuse pre-configured trigger with camel Uri. Just ensure the names match. Notice you cannot have both deleteJob and pauseJob set to true.|false|boolean|
|recoverableJob|Instructs the scheduler whether or not the job should be re-executed if a 'recovery' or 'fail-over' situation is encountered.|false|boolean|
|stateful|Uses a Quartz PersistJobDataAfterExecution and DisallowConcurrentExecution instead of the default job.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|customCalendar|Specifies a custom calendar to avoid specific range of date||object|
|ignoreExpiredNextFireTime|Whether to ignore quartz cannot schedule a trigger because the trigger will never fire in the future. This can happen when using a cron trigger that are configured to only run in the past. By default, Quartz will fail to schedule the trigger and therefore fail to start the Camel route. You can set this to true which then logs a WARN and then ignore the problem, meaning that the route will never fire in the future.|false|boolean|
|jobParameters|To configure additional options on the job.||object|
|prefixJobNameWithEndpointId|Whether the job name should be prefixed with endpoint id|false|boolean|
|triggerParameters|To configure additional options on the trigger. The parameter timeZone is supported if the cron option is present. Otherwise the parameters repeatInterval and repeatCount are supported. Note: When using repeatInterval values of 1000 or less, the first few events after starting the camel context may be fired more rapidly than expected.||object|
|usingFixedCamelContextName|If it is true, JobDataMap uses the CamelContext name directly to reference the CamelContext, if it is false, JobDataMap uses use the CamelContext management name which could be changed during the deploy time.|false|boolean|
|autoStartScheduler|Whether or not the scheduler should be auto started.|true|boolean|
|triggerStartDelay|In case of scheduler has already started, we want the trigger start slightly after current time to ensure endpoint is fully started before the job kicks in. Negative value shifts trigger start time in the past.|500|duration|
