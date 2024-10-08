# Robotframework

**Since Camel 3.0**

**Both producer and consumer are supported**

The **robotframework:** component allows for processing camel exchanges
in acceptance test suites which are already implemented with its own
DSL. The depending keyword libraries that can be used inside test suites
implemented in Robot DSL, could have been implemented either via Java or
Pyhton.

This component will let you execute business logic of acceptance test
cases in Robot language on which you can pass parameters to feed data
via power of Camel Routes. However, there is no reverse binding of
parameters back where you can pass values back into Camel exchange.
Therefore, for that reason, it actually acts like a template language
passing camel exchanges by binding data into the test cases implemented.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-robotframework</artifactId>
        <version>x.x.x</version> <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    robotframework:templateName[?options]

Where **templateName** is the classpath-local URI of the template to
invoke; or the complete URL of the remote template (eg:
file://folder/myfile.robot).

# Examples

For example, you could use something like:

    from("direct:setVariableCamelBody")
        .to("robotframework:src/test/resources/org/apache/camel/component/robotframework/set_variable_camel_body.robot")

To use a robot test case to execute and collect the results and pass
them to generate a custom report if such need happens

It’s possible to specify what template the component should use
dynamically via a header, so for example:

    from("direct:in")
        .setHeader(RobotFrameworkCamelConstants.CAMEL_ROBOT_RESOURCE_URI).constant("path/to/my/template.robot")
        .to("robotframework:dummy?allowTemplateFromHeader=true");

Robotframework component helps you pass values into robot test cases
with the similar approach how you would be able to pass values using
Camel Simple Language. Components support passing values in three
different ways. Exchange body, headers, and properties.

    from("direct:in")
        .setBody(constant("Hello Robot"))
        .setHeader(RobotFrameworkCamelConstants.CAMEL_ROBOT_RESOURCE_URI).constant("path/to/my/template.robot")
        .to("robotframework:dummy?allowTemplateFromHeader=true");

And the `template.robot` file:

        *** Test Cases ***
        Set Variable Camel Body Test Case
        ${myvar} =    Set Variable    ${body}
        Should Be True    ${myvar} == ${body}
    
    from("direct:in")
        .setHeader("testHeader", constant("testHeaderValue"))
        .setHeader(RobotFrameworkCamelConstants.CAMEL_ROBOT_RESOURCE_URI).constant("path/to/my/template.robot")
        .to("robotframework:dummy?allowTemplateFromHeader=true");

And the `template.robot` file:

        *** Test Cases ***
        Set Variable Camel Header Test Case
        ${myvar} =    Set Variable    ${headers.testHeader}
        Should Be True    ${myvar} == ${headers.testHeader}
    
    from("direct:in")
        .setProperty"testProperty", constant("testPropertyValue"))
        .setHeader(RobotFrameworkCamelConstants.CAMEL_ROBOT_RESOURCE_URI).constant("path/to/my/template.robot")
        .to("robotframework:dummy?allowTemplateFromHeader=true");

And the `template.robot` file:

        *** Test Cases ***
        Set Variable Camel Header Test Case
        ${myvar} =    Set Variable    ${properties.testProperty}
        Should Be True    ${myvar} == ${properties.testProperty}

Please note that when you pass values through Camel Exchange to test
cases, they will be available as case-sensitive \`\`body\`\`,
\`\`headers.\[yourHeaderName\]\`\` and
\`\`properties.\[yourPropertyName\]\`\`

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|argumentFiles|A text String to read more arguments from.||string|
|combinedTagStats|Creates combined statistics based on tags. Use the format tags:title List||string|
|criticalTags|Tests that have the given tags are considered critical. List||string|
|debugFile|A debug String that is written during execution.||string|
|document|Sets the documentation of the top-level tests suites.||string|
|dryrun|Sets dryrun mode on use. In the dry run mode tests are run without executing keywords originating from test libraries. Useful for validating test data syntax.|false|boolean|
|excludes|Selects the tests cases by tags. List||string|
|exitOnFailure|Sets robot to stop execution immediately if a critical test fails.|false|boolean|
|includes|Selects the tests cases by tags. List||string|
|listener|Sets a single listener for monitoring tests execution||string|
|listeners|Sets multiple listeners for monitoring tests execution. Use the format ListenerWithArgs:arg1:arg2 or simply ListenerWithoutArgs List||string|
|log|Sets the path to the generated log String.||string|
|logLevel|Sets the threshold level for logging.||string|
|logTitle|Sets a title for the generated tests log.||string|
|metadata|Sets free metadata for the top level tests suites. comma seperated list of string resulting as List||string|
|monitorColors|Using ANSI colors in console. Normally colors work in unixes but not in Windows. Default is 'on'. 'on' - use colors in unixes but not in Windows 'off' - never use colors 'force' - always use colors (also in Windows)||string|
|monitorWidth|Width of the monitor output. Default is 78.|78|string|
|name|Sets the name of the top-level tests suites.||string|
|nonCriticalTags|Tests that have the given tags are not critical. List||string|
|noStatusReturnCode|If true, sets the return code to zero regardless of failures in test cases. Error codes are returned normally.|false|boolean|
|output|Sets the path to the generated output String.||string|
|outputDirectory|Configures where generated reports are to be placed.||string|
|randomize|Sets the test execution order to be randomized. Valid values are all, suite, and test||string|
|report|Sets the path to the generated report String.||string|
|reportBackground|Sets background colors for the generated report and summary.||string|
|reportTitle|Sets a title for the generated tests report.||string|
|runEmptySuite|Executes tests also if the top level test suite is empty. Useful e.g. with --include/--exclude when it is not an error that no test matches the condition.|false|boolean|
|runFailed|Re-run failed tests, based on output.xml String.||string|
|runMode|Sets the execution mode for this tests run. Note that this setting has been deprecated in Robot Framework 2.8. Use separate dryryn, skipTeardownOnExit, exitOnFailure, and randomize settings instead.||string|
|skipTeardownOnExit|Sets whether the teardowns are skipped if the test execution is prematurely stopped.|false|boolean|
|splitOutputs|Splits output and log files.||string|
|suites|Selects the tests suites by name. List||string|
|suiteStatLevel|Defines how many levels to show in the Statistics by Suite table in outputs.||string|
|summaryTitle|Sets a title for the generated summary report.||string|
|tagDocs|Adds documentation to the specified tags. List||string|
|tags|Sets the tags(s) to all executed tests cases. List||string|
|tagStatExcludes|Excludes these tags from the Statistics by Tag and Test Details by Tag tables in outputs. List||string|
|tagStatIncludes|Includes only these tags in the Statistics by Tag and Test Details by Tag tables in outputs. List||string|
|tagStatLinks|Adds external links to the Statistics by Tag table in outputs. Use the format pattern:link:title List||string|
|tests|Selects the tests cases by name. List||string|
|timestampOutputs|Adds a timestamp to all output files.|false|boolean|
|variableFiles|Sets variables using variables files. Use the format path:args List||string|
|variables|Sets individual variables. Use the format name:value List||string|
|warnOnSkippedFiles|Show a warning when an invalid String is skipped.|false|boolean|
|xunitFile|Sets the path to the generated XUnit compatible result String, relative to outputDirectory. The String is in xml format. By default, the String name is derived from the testCasesDirectory parameter, replacing blanks in the directory name by underscores.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|The configuration||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the resource. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod.||string|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|argumentFiles|A text String to read more arguments from.||string|
|combinedTagStats|Creates combined statistics based on tags. Use the format tags:title List||string|
|contentCache|Sets whether to use resource content cache or not|false|boolean|
|criticalTags|Tests that have the given tags are considered critical. List||string|
|debugFile|A debug String that is written during execution.||string|
|document|Sets the documentation of the top-level tests suites.||string|
|dryrun|Sets dryrun mode on use. In the dry run mode tests are run without executing keywords originating from test libraries. Useful for validating test data syntax.|false|boolean|
|excludes|Selects the tests cases by tags. List||string|
|exitOnFailure|Sets robot to stop execution immediately if a critical test fails.|false|boolean|
|includes|Selects the tests cases by tags. List||string|
|listener|Sets a single listener for monitoring tests execution||string|
|listeners|Sets multiple listeners for monitoring tests execution. Use the format ListenerWithArgs:arg1:arg2 or simply ListenerWithoutArgs List||string|
|log|Sets the path to the generated log String.||string|
|logLevel|Sets the threshold level for logging.||string|
|logTitle|Sets a title for the generated tests log.||string|
|metadata|Sets free metadata for the top level tests suites. comma seperated list of string resulting as List||string|
|monitorColors|Using ANSI colors in console. Normally colors work in unixes but not in Windows. Default is 'on'. 'on' - use colors in unixes but not in Windows 'off' - never use colors 'force' - always use colors (also in Windows)||string|
|monitorWidth|Width of the monitor output. Default is 78.|78|string|
|name|Sets the name of the top-level tests suites.||string|
|nonCriticalTags|Tests that have the given tags are not critical. List||string|
|noStatusReturnCode|If true, sets the return code to zero regardless of failures in test cases. Error codes are returned normally.|false|boolean|
|output|Sets the path to the generated output String.||string|
|outputDirectory|Configures where generated reports are to be placed.||string|
|randomize|Sets the test execution order to be randomized. Valid values are all, suite, and test||string|
|report|Sets the path to the generated report String.||string|
|reportBackground|Sets background colors for the generated report and summary.||string|
|reportTitle|Sets a title for the generated tests report.||string|
|runEmptySuite|Executes tests also if the top level test suite is empty. Useful e.g. with --include/--exclude when it is not an error that no test matches the condition.|false|boolean|
|runFailed|Re-run failed tests, based on output.xml String.||string|
|runMode|Sets the execution mode for this tests run. Note that this setting has been deprecated in Robot Framework 2.8. Use separate dryryn, skipTeardownOnExit, exitOnFailure, and randomize settings instead.||string|
|skipTeardownOnExit|Sets whether the teardowns are skipped if the test execution is prematurely stopped.|false|boolean|
|splitOutputs|Splits output and log files.||string|
|suites|Selects the tests suites by name. List||string|
|suiteStatLevel|Defines how many levels to show in the Statistics by Suite table in outputs.||string|
|summaryTitle|Sets a title for the generated summary report.||string|
|tagDocs|Adds documentation to the specified tags. List||string|
|tags|Sets the tags(s) to all executed tests cases. List||string|
|tagStatExcludes|Excludes these tags from the Statistics by Tag and Test Details by Tag tables in outputs. List||string|
|tagStatIncludes|Includes only these tags in the Statistics by Tag and Test Details by Tag tables in outputs. List||string|
|tagStatLinks|Adds external links to the Statistics by Tag table in outputs. Use the format pattern:link:title List||string|
|tests|Selects the tests cases by name. List||string|
|timestampOutputs|Adds a timestamp to all output files.|false|boolean|
|variableFiles|Sets variables using variables files. Use the format path:args List||string|
|variables|Sets individual variables. Use the format name:value List||string|
|warnOnSkippedFiles|Show a warning when an invalid String is skipped.|false|boolean|
|xunitFile|Sets the path to the generated XUnit compatible result String, relative to outputDirectory. The String is in xml format. By default, the String name is derived from the testCasesDirectory parameter, replacing blanks in the directory name by underscores.||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
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
