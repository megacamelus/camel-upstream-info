# Main.md

**Since Camel 3.0**

This module is used for running Camel standalone via a main class
extended from `camel-main`.

# Configuration options

When running Camel via `camel-main` you can configure Camel in the
`application.properties` file.

The following tables lists all the options:

## Camel Main configurations

The camel.main supports 122 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.allowUseOriginal​Message</strong></p></td>
<td style="text-align: left;"><p>Sets whether to allow access to the
original message from Camel’s error handler, or from
org.apache.camel.spi.UnitOfWork.getOriginalInMessage(). Turning this off
can optimize performance, as defensive copy of the original message is
not needed. Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.autoConfiguration​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether auto configuration of
components, dataformats, languages is enabled or not. When enabled the
configuration parameters are loaded from the properties component. You
can prefix the parameters in the properties file with: -
camel.component.name.option1=value1 -
camel.component.name.option2=value2 -
camel.dataformat.name.option1=value1 -
camel.dataformat.name.option2=value2 -
camel.language.name.option1=value1 - camel.language.name.option2=value2
Where name is the name of the component, dataformat or language such as
seda,direct,jaxb. The auto configuration also works for any options on
components that is a complex type (not standard Java type) and there has
been an explicit single bean instance registered to the Camel registry
via the org.apache.camel.spi.Registry#bind(String,Object) method or by
using the org.apache.camel.BindToRegistry annotation style. This option
is default enabled.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.autoConfiguration​EnvironmentVariablesEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether auto configuration should
include OS environment variables as well. When enabled this allows to
overrule any configuration using an OS environment variable. For example
to set a shutdown timeout of 5 seconds: CAMEL_MAIN_SHUTDOWNTIMEOUT=5.
This option is default enabled.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.autoConfiguration​FailFast</strong></p></td>
<td style="text-align: left;"><p>Whether auto configuration should fail
fast when configuring one ore more properties fails for whatever reason
such as a invalid property name, etc. This option is default
enabled.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.autoConfiguration​LogSummary</strong></p></td>
<td style="text-align: left;"><p>Whether auto configuration should log a
summary with the configured properties. This option is default
enabled.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.autoConfiguration​SystemPropertiesEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether auto configuration should
include JVM system properties as well. When enabled this allows to
overrule any configuration using a JVM system property. For example to
set a shutdown timeout of 5 seconds: -D camel.main.shutdown-timeout=5.
Note that JVM system properties take precedence over OS environment
variables. This option is default enabled.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.autoStartup</strong></p></td>
<td style="text-align: left;"><p>Sets whether the object should
automatically start when Camel starts. Important: Currently only routes
can be disabled, as CamelContext’s are always started. Note: When
setting auto startup false on CamelContext then that takes precedence
and no routes are started. You would need to start CamelContext explicit
using the org.apache.camel.CamelContext.start() method, to start the
context, and then you would need to start the routes manually using
CamelContext.getRouteController().startRoute(String). Default is true to
always start up.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.autowiredEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether autowiring is enabled. This is
used for automatic autowiring options (the option must be marked as
autowired) by looking up in the registry to find if there is a single
instance of matching type, which then gets configured on the component.
This can be used for automatic configuring JDBC data sources, JMS
connection factories, AWS Clients, etc. Default is true.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.basePackageScan</strong></p></td>
<td style="text-align: left;"><p>Package name to use as base (offset)
for classpath scanning of RouteBuilder , org.apache.camel.TypeConverter
, CamelConfiguration classes, and also classes annotated with
org.apache.camel.Converter , or org.apache.camel.BindToRegistry . If you
are using Spring Boot then it is instead recommended to use Spring Boots
component scanning and annotate your route builder classes with
Component. In other words only use this for Camel Main in standalone
mode.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.basePackageScan​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether base package scan is
enabled.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.beanIntrospection​ExtendedStatistics</strong></p></td>
<td style="text-align: left;"><p>Sets whether bean introspection uses
extended statistics. The default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.beanIntrospection​LoggingLevel</strong></p></td>
<td style="text-align: left;"><p>Sets the logging level used by bean
introspection, logging activity of its usage. The default is
TRACE.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>LoggingLevel</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.beanPostProcessor​Enabled</strong></p></td>
<td style="text-align: left;"><p>Can be used to turn off bean post
processing. Be careful to turn this off, as this means that beans that
use Camel annotations such as org.apache.camel.EndpointInject ,
org.apache.camel.ProducerTemplate , org.apache.camel.Produce ,
org.apache.camel.Consume etc will not be injected and in use. Turning
this off should only be done if you are sure you do not use any of these
Camel features. Not all runtimes allow turning this off. The default
value is true (enabled).</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.camelEvents​TimestampEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to include timestamps for all
emitted Camel Events. Enabling this allows to know fine-grained at what
time each event was emitted, which can be used for reporting to report
exactly the time of the events. This is by default false to avoid the
overhead of including this information.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.caseInsensitive​Headers</strong></p></td>
<td style="text-align: left;"><p>Whether to use case sensitive or
insensitive headers. Important: When using case sensitive (this is set
to false). Then the map is case sensitive which means headers such as
content-type and Content-Type are two different keys which can be a
problem for some protocols such as HTTP based, which rely on case
insensitive headers. However case sensitive implementations can yield
faster performance. Therefore use case sensitive implementation with
care. Default is true.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.cloudProperties​Location</strong></p></td>
<td style="text-align: left;"><p>Sets the locations (comma separated
values) where to find properties configuration as defined for cloud
native environments such as Kubernetes. You should only scan text based
mounted configuration.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.compileWorkDir</strong></p></td>
<td style="text-align: left;"><p>Work directory for compiler. Can be
used to write compiled classes or other resources.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.configuration​Classes</strong></p></td>
<td style="text-align: left;"><p>Sets classes names that will be used to
configure the camel context as example by providing custom beans through
org.apache.camel.BindToRegistry annotation.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.configurations</strong></p></td>
<td style="text-align: left;"><p>Sets the configuration objects used to
configure the camel context.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>List</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.consumerTemplate​CacheSize</strong></p></td>
<td style="text-align: left;"><p>Consumer template endpoints cache
size.</p></td>
<td style="text-align: center;"><p>1000</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.contextReload​Enabled</strong></p></td>
<td style="text-align: left;"><p>Used for enabling context reloading. If
enabled then Camel allow external systems such as security vaults (AWS
secrets manager, etc.) to trigger refreshing Camel by updating property
placeholders and reload all existing routes to take changes into
effect.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.description</strong></p></td>
<td style="text-align: left;"><p>Sets the description (intended for
humans) of the Camel application.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.devConsoleEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to enable developer console
(requires camel-console on classpath). The developer console is only for
assisting during development. This is NOT for production usage.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.dumpRoutes</strong></p></td>
<td style="text-align: left;"><p>If dumping is enabled then Camel will
during startup dump all loaded routes (incl rests and route templates)
represented as XML/YAML DSL into the log. This is intended for trouble
shooting or to assist during development. Sensitive information that may
be configured in the route endpoints could potentially be included in
the dump output and is therefore not recommended being used for
production usage. This requires to have camel-xml-io/camel-yaml-io on
the classpath to be able to dump the routes as XML/YAML.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.dumpRoutesGenerated​Ids</strong></p></td>
<td style="text-align: left;"><p>Whether to include auto generated IDs
in the dumped output. Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.dumpRoutesInclude</strong></p></td>
<td style="text-align: left;"><p>Controls what to include in output for
route dumping. Possible values: all, routes, rests, routeConfigurations,
routeTemplates, beans. Multiple values can be separated by comma.
Default is routes.</p></td>
<td style="text-align: center;"><p>routes</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.dumpRoutesLog</strong></p></td>
<td style="text-align: left;"><p>Whether to log route dumps to
Logger</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.dumpRoutesOutput</strong></p></td>
<td style="text-align: left;"><p>Whether to save route dumps to an
output file. If the output is a filename, then all content is saved to
this file. If the output is a directory name, then one or more files are
saved to the directory, where the names are based on the original source
file names, or auto generated names.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.dumpRoutesResolve​Placeholders</strong></p></td>
<td style="text-align: left;"><p>Whether to resolve property
placeholders in the dumped output. Default is true.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.dumpRoutesUriAs​Parameters</strong></p></td>
<td style="text-align: left;"><p>When dumping routes to YAML format,
then this option controls whether endpoint URIs should be expanded into
a key/value parameters.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.durationHitExitCode</strong></p></td>
<td style="text-align: left;"><p>Sets the exit code for the application
if duration was hit</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.durationMaxAction</strong></p></td>
<td style="text-align: left;"><p>Controls whether the Camel application
should shutdown the JVM, or stop all routes, when duration max is
triggered.</p></td>
<td style="text-align: center;"><p>shutdown</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.durationMaxIdle​Seconds</strong></p></td>
<td style="text-align: left;"><p>To specify for how long time in seconds
Camel can be idle before automatic terminating the JVM. You can use this
to run Camel for a short while.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.durationMaxMessages</strong></p></td>
<td style="text-align: left;"><p>To specify how many messages to process
by Camel before automatic terminating the JVM. You can use this to run
Camel for a short while.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.durationMaxSeconds</strong></p></td>
<td style="text-align: left;"><p>To specify for how long time in seconds
to keep running the JVM before automatic terminating the JVM. You can
use this to run Camel for a short while.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.endpointBridgeError​Handler</strong></p></td>
<td style="text-align: left;"><p>Allows for bridging the consumer to the
Camel routing Error Handler, which mean any exceptions occurred while
the consumer is trying to pickup incoming messages, or the likes, will
now be processed as a message and handled by the routing Error Handler.
By default the consumer will use the
org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will
be logged at WARN/ERROR level and ignored. The default value is
false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.endpointLazyStart​Producer</strong></p></td>
<td style="text-align: left;"><p>Whether the producer should be started
lazy (on the first message). By starting lazy you can use this to allow
CamelContext and routes to startup in situations where a producer may
otherwise fail during starting and cause the route to fail being
started. By deferring this startup to be lazy then the startup failure
can be handled during routing messages via Camel’s routing error
handlers. Beware that when the first message is processed then creating
and starting the producer may take a little time and prolong the total
processing time of the processing. The default value is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.endpointRuntime​StatisticsEnabled</strong></p></td>
<td style="text-align: left;"><p>Sets whether endpoint runtime
statistics is enabled (gathers runtime usage of each incoming and
outgoing endpoints). The default value is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.exchangeFactory</strong></p></td>
<td style="text-align: left;"><p>Controls whether to pool (reuse)
exchanges or create new exchanges (prototype). Using pooled will reduce
JVM garbage collection overhead by avoiding to re-create Exchange
instances per message each consumer receives. The default is prototype
mode.</p></td>
<td style="text-align: center;"><p>default</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.exchangeFactory​Capacity</strong></p></td>
<td style="text-align: left;"><p>The capacity the pool (for each
consumer) uses for storing exchanges. The default capacity is
100.</p></td>
<td style="text-align: center;"><p>100</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.exchangeFactory​StatisticsEnabled</strong></p></td>
<td style="text-align: left;"><p>Configures whether statistics is
enabled on exchange factory.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.extraShutdown​Timeout</strong></p></td>
<td style="text-align: left;"><p>Extra timeout in seconds to graceful
shutdown Camel. When Camel is shutting down then Camel first shutdown
all the routes (shutdownTimeout). Then additional services is shutdown
(extraShutdownTimeout).</p></td>
<td style="text-align: center;"><p>15</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.fileConfigurations</strong></p></td>
<td style="text-align: left;"><p>Directory to load additional
configuration files that contains configuration values that takes
precedence over any other configuration. This can be used to refer to
files that may have secret configuration that has been mounted on the
file system for containers. You can specify a pattern to load from sub
directories and a name pattern such as /var/app/secret/.properties,
multiple directories can be separated by comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.globalOptions</strong></p></td>
<td style="text-align: left;"><p>Sets global options that can be
referenced in the camel context Important: This has nothing to do with
property placeholders, and is just a plain set of key/value pairs which
are used to configure global options on CamelContext, such as a maximum
debug logging length etc.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Map</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.inflightRepository​BrowseEnabled</strong></p></td>
<td style="text-align: left;"><p>Sets whether the inflight repository
should allow browsing each inflight exchange. This is by default
disabled as there is a very slight performance overhead when
enabled.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.javaRoutesExclude​Pattern</strong></p></td>
<td style="text-align: left;"><p>Used for exclusive filtering
RouteBuilder classes which are collected from the registry or via
classpath scanning. The exclusive filtering takes precedence over
inclusive filtering. The pattern is using Ant-path style pattern.
Multiple patterns can be specified separated by comma. For example to
exclude all classes starting with Bar use: **/Bar* To exclude all routes
form a specific package use: com/mycompany/bar/* To exclude all routes
form a specific package and its sub-packages use double wildcards:
com/mycompany/bar/** And to exclude all routes from two specific
packages use: com/mycompany/bar/*,com/mycompany/stuff/*</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.javaRoutesInclude​Pattern</strong></p></td>
<td style="text-align: left;"><p>Used for inclusive filtering
RouteBuilder classes which are collected from the registry or via
classpath scanning. The exclusive filtering takes precedence over
inclusive filtering. The pattern is using Ant-path style pattern.
Multiple patterns can be specified separated by comma. Multiple patterns
can be specified separated by comma. For example to include all classes
starting with Foo use: **/Foo To include all routes form a specific
package use: com/mycompany/foo/* To include all routes form a specific
package and its sub-packages use double wildcards: com/mycompany/foo/**
And to include all routes from two specific packages use:
com/mycompany/foo/*,com/mycompany/stuff/*</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.jmxEnabled</strong></p></td>
<td style="text-align: left;"><p>Enable JMX in your Camel
application.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.jmxManagementMBeans​Level</strong></p></td>
<td style="text-align: left;"><p>Sets the mbeans registration level. The
default value is Default.</p></td>
<td style="text-align: center;"><p>Default</p></td>
<td style="text-align: left;"><p>ManagementMBeansLevel</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.jmxManagementName​Pattern</strong></p></td>
<td style="text-align: left;"><p>The naming pattern for creating the
CamelContext JMX management name. The default pattern is name</p></td>
<td style="text-align: center;"><p>name</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.jmxManagement​RegisterRoutesCreateByKamelet</strong></p></td>
<td style="text-align: left;"><p>Whether routes created by Kamelets
should be registered for JMX management. Enabling this allows to have
fine-grained monitoring and management of every route created via
Kamelets. This is default disabled as a Kamelet is intended as a
component (black-box) and its implementation details as Camel route
makes the overall management and monitoring of Camel applications more
verbose. During development of Kamelets then enabling this will make it
possible for developers to do fine-grained performance inspection and
identify potential bottlenecks in the Kamelet routes. However, for
production usage then keeping this disabled is recommended.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.jmxManagement​RegisterRoutesCreateByTemplate</strong></p></td>
<td style="text-align: left;"><p>Whether routes created by route
templates (not Kamelets) should be registered for JMX management.
Enabling this allows to have fine-grained monitoring and management of
every route created via route templates. This is default enabled (unlike
Kamelets) as routes created via templates is regarded as standard
routes, and should be available for management and monitoring.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.jmxManagement​StatisticsLevel</strong></p></td>
<td style="text-align: left;"><p>Sets the JMX statistics level, the
level can be set to Extended to gather additional information The
default value is Default.</p></td>
<td style="text-align: center;"><p>Default</p></td>
<td style="text-align: left;"><p>ManagementStatisticsLevel</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.jmxUpdateRoute​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether to allow updating routes at
runtime via JMX using the ManagedRouteMBean. This is disabled by
default, but can be enabled for development and troubleshooting
purposes, such as updating routes in an existing running Camel via JMX
and other tools.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.lightweight</strong></p></td>
<td style="text-align: left;"><p>Configure the context to be
lightweight. This will trigger some optimizations and memory reduction
options. Lightweight context have some limitations. At this moment,
dynamic endpoint destinations are not supported.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.loadHealthChecks</strong></p></td>
<td style="text-align: left;"><p>Whether to load custom health checks by
scanning classpath.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.loadStatistics​Enabled</strong></p></td>
<td style="text-align: left;"><p>Sets whether context load statistics is
enabled (something like the unix load average). The statistics requires
to have camel-management on the classpath as JMX is required. The
default value is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.loadTypeConverters</strong></p></td>
<td style="text-align: left;"><p>Whether to load custom type converters
by scanning classpath. This is used for backwards compatibility with
Camel 2.x. Its recommended to migrate to use fast type converter loading
by setting Converter(loader = true) on your custom type converter
classes.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.logDebugMaxChars</strong></p></td>
<td style="text-align: left;"><p>Is used to limit the maximum length of
the logging Camel message bodies. If the message body is longer than the
limit, the log message is clipped. Use -1 to have unlimited length. Use
for example 1000 to log at most 1000 characters.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.logExhaustedMessage​Body</strong></p></td>
<td style="text-align: left;"><p>Sets whether to log exhausted message
body with message history. Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.logLanguage</strong></p></td>
<td style="text-align: left;"><p>To configure the language to use for
Log EIP. By default, the simple language is used. However, Camel also
supports other languages such as groovy.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.logMask</strong></p></td>
<td style="text-align: left;"><p>Sets whether log mask is enabled or
not. Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.logName</strong></p></td>
<td style="text-align: left;"><p>The global name to use for Log EIP The
name is default the routeId or the source:line if source location is
enabled. You can also specify the name using tokens: ${class} - the
logger class name (org.apache.camel.processor.LogProcessor) ${contextId}
- the camel context id ${routeId} - the route id ${groupId} - the route
group id ${nodeId} - the node id ${nodePrefixId} - the node prefix id
${source} - the source:line (source location must be enabled)
${source.name} - the source filename (source location must be enabled)
${source.line} - the source line number (source location must be
enabled) For example to use the route and node id you can specify the
name as: ${routeId}/${nodeId}</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.mainListenerClasses</strong></p></td>
<td style="text-align: left;"><p>Sets classes names that will be used
for MainListener that makes it possible to do custom logic during
starting and stopping camel-main.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.mainListeners</strong></p></td>
<td style="text-align: left;"><p>Sets main listener objects that will be
used for MainListener that makes it possible to do custom logic during
starting and stopping camel-main.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>List</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.mdcLoggingKeys​Pattern</strong></p></td>
<td style="text-align: left;"><p>Sets the pattern used for determine
which custom MDC keys to propagate during message routing when the
routing engine continues routing asynchronously for the given message.
Setting this pattern to will propagate all custom keys. Or setting the
pattern to foo,bar will propagate any keys starting with either foo or
bar. Notice that a set of standard Camel MDC keys are always propagated
which starts with camel. as key name. The match rules are applied in
this order (case insensitive): 1. exact match, returns true 2. wildcard
match (pattern ends with a and the name starts with the pattern),
returns true 3. regular expression match, returns true 4. otherwise
returns false</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.messageHistory</strong></p></td>
<td style="text-align: left;"><p>Sets whether message history is enabled
or not. Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.modeline</strong></p></td>
<td style="text-align: left;"><p>Whether camel-k style modeline is also
enabled when not using camel-k. Enabling this allows to use a camel-k
like experience by being able to configure various settings using
modeline directly in your route source code.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.name</strong></p></td>
<td style="text-align: left;"><p>Sets the name of the
CamelContext.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.producerTemplate​CacheSize</strong></p></td>
<td style="text-align: left;"><p>Producer template endpoints cache
size.</p></td>
<td style="text-align: center;"><p>1000</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.profile</strong></p></td>
<td style="text-align: left;"><p>Camel profile to use when running. The
dev profile is for development, which enables a set of additional
developer focus functionality, tracing, debugging, and gathering
additional runtime statistics that are useful during development.
However, those additional features has a slight overhead cost, and are
not enabled for production profile. The default profile is
prod.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.routeFilterExclude​Pattern</strong></p></td>
<td style="text-align: left;"><p>Used for filtering routes routes
matching the given pattern, which follows the following rules: - Match
by route id - Match by route input endpoint uri The matching is using
exact match, by wildcard and regular expression as documented by
PatternHelper#matchPattern(String,String) . For example to only include
routes which starts with foo in their route id’s, use: include=foo* And
to exclude routes which starts from JMS endpoints, use: exclude=jms:*
Multiple patterns can be separated by comma, for example to exclude both
foo and bar routes, use: exclude=foo*,bar* Exclude takes precedence over
include.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.routeFilterInclude​Pattern</strong></p></td>
<td style="text-align: left;"><p>Used for filtering routes matching the
given pattern, which follows the following rules: - Match by route id -
Match by route input endpoint uri The matching is using exact match, by
wildcard and regular expression as documented by
PatternHelper#matchPattern(String,String) . For example to only include
routes which starts with foo in their route id’s, use: include=foo* And
to exclude routes which starts from JMS endpoints, use: exclude=jms:*
Multiple patterns can be separated by comma, for example to exclude both
foo and bar routes, use: exclude=foo*,bar* Exclude takes precedence over
include.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.routesBuilder​Classes</strong></p></td>
<td style="text-align: left;"><p>Sets classes names that implement
RoutesBuilder .</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.routesBuilders</strong></p></td>
<td style="text-align: left;"><p>Sets the RoutesBuilder
instances.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>List</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.routesCollector​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether the routes collector is enabled
or not. When enabled Camel will auto-discover routes (RouteBuilder
instances from the registry and also load additional routes from the
file system). The routes collector is default enabled.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.routesCollector​IgnoreLoadingError</strong></p></td>
<td style="text-align: left;"><p>Whether the routes collector should
ignore any errors during loading and compiling routes. This is only
intended for development or tooling.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.routesExclude​Pattern</strong></p></td>
<td style="text-align: left;"><p>Used for exclusive filtering of routes
from directories. The exclusive filtering takes precedence over
inclusive filtering. The pattern is using Ant-path style pattern.
Multiple patterns can be specified separated by comma, as example, to
exclude all the routes from a directory whose name contains foo use:
**/foo.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.routesInclude​Pattern</strong></p></td>
<td style="text-align: left;"><p>Used for inclusive filtering of routes
from directories. The exclusive filtering takes precedence over
inclusive filtering. The pattern is using Ant-path style pattern.
Multiple patterns can be specified separated by comma, as example, to
include all the routes from a directory whose name contains foo use:
**/foo.</p></td>
<td
style="text-align: center;"><p>classpath:camel/<strong>,classpath:camel-template/</strong>,classpath:camel-rest/*</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.routesReload​Directory</strong></p></td>
<td style="text-align: left;"><p>Directory to scan for route changes.
Camel cannot scan the classpath, so this must be configured to a file
directory. Development with Maven as build tool, you can configure the
directory to be src/main/resources to scan for Camel routes in XML or
YAML files.</p></td>
<td style="text-align: center;"><p>src/main/resources/camel</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.routesReload​DirectoryRecursive</strong></p></td>
<td style="text-align: left;"><p>Whether the directory to scan should
include sub directories. Depending on the number of sub directories,
then this can cause the JVM to startup slower as Camel uses the JDK
file-watch service to scan for file changes.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.routesReloadEnabled</strong></p></td>
<td style="text-align: left;"><p>Used for enabling automatic routes
reloading. If enabled then Camel will watch for file changes in the
given reload directory, and trigger reloading routes if files are
changed.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.routesReloadPattern</strong></p></td>
<td style="text-align: left;"><p>Used for inclusive filtering of routes
from directories. Typical used for specifying to accept routes in XML or
YAML files, such as .yaml,.xml. Multiple patterns can be specified
separated by comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.routesReloadRemove​AllRoutes</strong></p></td>
<td style="text-align: left;"><p>When reloading routes should all
existing routes be stopped and removed. By default, Camel will stop and
remove all existing routes before reloading routes. This ensures that
only the reloaded routes will be active. If disabled then only routes
with the same route id is updated, and any existing routes are continued
to run.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.routesReloadRestart​Duration</strong></p></td>
<td style="text-align: left;"><p>Whether to restart max duration when
routes are reloaded. For example if max duration is 60 seconds, and a
route is reloaded after 25 seconds, then this will restart the count and
wait 60 seconds again.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.shutdownLogInflight​ExchangesOnTimeout</strong></p></td>
<td style="text-align: left;"><p>Sets whether to log information about
the inflight Exchanges which are still running during a shutdown which
didn’t complete without the given timeout. This requires to enable the
option inflightRepositoryBrowseEnabled.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.shutdownNowOn​Timeout</strong></p></td>
<td style="text-align: left;"><p>Sets whether to force shutdown of all
consumers when a timeout occurred and thus not all consumers was
shutdown within that period. You should have good reasons to set this
option to false as it means that the routes keep running and is halted
abruptly when CamelContext has been shutdown.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.shutdownRoutesIn​ReverseOrder</strong></p></td>
<td style="text-align: left;"><p>Sets whether routes should be shutdown
in reverse or the same order as they were started.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.shutdownSuppress​LoggingOnTimeout</strong></p></td>
<td style="text-align: left;"><p>Whether Camel should try to suppress
logging during shutdown and timeout was triggered, meaning forced
shutdown is happening. And during forced shutdown we want to avoid
logging errors/warnings et all in the logs as a side-effect of the
forced timeout. Notice the suppress is a best effort as there may still
be some logs coming from 3rd party libraries and whatnot, which Camel
cannot control. This option is default false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.shutdownTimeout</strong></p></td>
<td style="text-align: left;"><p>Timeout in seconds to graceful shutdown
all the Camel routes.</p></td>
<td style="text-align: center;"><p>45</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.sourceLocation​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether to capture precise source
location:line-number for all EIPs in Camel routes. Enabling this will
impact parsing Java based routes (also Groovy etc.) on startup as this
uses JDK StackTraceElement to calculate the location from the Camel
route, which comes with a performance cost. This only impact startup,
not the performance of the routes at runtime.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.startupRecorder</strong></p></td>
<td style="text-align: left;"><p>To use startup recorder for capturing
execution time during starting Camel. The recorder can be one of: false
(or off), logging, backlog, java-flight-recorder (or jfr).</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.startupRecorderDir</strong></p></td>
<td style="text-align: left;"><p>Directory to store the recording. By
default the current directory will be used. Use false to turn off saving
recording to disk.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.startupRecorder​Duration</strong></p></td>
<td style="text-align: left;"><p>How long time to run the startup
recorder. Use 0 (default) to keep the recorder running until the JVM is
exited. Use -1 to stop the recorder right after Camel has been started
(to only focus on potential Camel startup performance bottlenecks) Use a
positive value to keep recording for N seconds. When the recorder is
stopped then the recording is auto saved to disk (note: save to disk can
be disabled by setting startupRecorderDir to false)</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.startupRecorderMax​Depth</strong></p></td>
<td style="text-align: left;"><p>To filter our sub steps at a maximum
depth. Use -1 for no maximum. Use 0 for no sub steps. Use 1 for max 1
sub step, and so forth. The default is -1.</p></td>
<td style="text-align: center;"><p>-1</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.startupRecorder​Profile</strong></p></td>
<td style="text-align: left;"><p>To use a specific Java Flight Recorder
profile configuration, such as default or profile. The default is
default.</p></td>
<td style="text-align: center;"><p>default</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.startupRecorder​Recording</strong></p></td>
<td style="text-align: left;"><p>To enable Java Flight Recorder to start
a recording and automatic dump the recording to disk after startup is
complete. This requires that camel-jfr is on the classpath, and to
enable this option.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.startupSummaryLevel</strong></p></td>
<td style="text-align: left;"><p>Controls the level of information
logged during startup (and shutdown) of CamelContext.</p></td>
<td style="text-align: center;"><p>Default</p></td>
<td style="text-align: left;"><p>StartupSummaryLevel</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingAllow​Classes</strong></p></td>
<td style="text-align: left;"><p>To filter stream caching of a given set
of allowed/denied classes. By default, all classes that are
java.io.InputStream is allowed. Multiple class names can be separated by
comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingAny​SpoolRules</strong></p></td>
<td style="text-align: left;"><p>Sets whether if just any of the
org.apache.camel.spi.StreamCachingStrategy.SpoolRule rules returns true
then shouldSpoolCache(long) returns true, to allow spooling to disk. If
this option is false, then all the
org.apache.camel.spi.StreamCachingStrategy.SpoolRule must return true.
The default value is false which means that all the rules must return
true.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingBuffer​Size</strong></p></td>
<td style="text-align: left;"><p>Sets the stream caching buffer size to
use when allocating in-memory buffers used for in-memory stream caches.
The default size is 4096.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingDeny​Classes</strong></p></td>
<td style="text-align: left;"><p>To filter stream caching of a given set
of allowed/denied classes. By default, all classes that are
java.io.InputStream is allowed. Multiple class names can be separated by
comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.streamCaching​Enabled</strong></p></td>
<td style="text-align: left;"><p>Sets whether stream caching is enabled
or not. While stream types (like StreamSource, InputStream and Reader)
are commonly used in messaging for performance reasons, they also have
an important drawback: they can only be read once. In order to be able
to work with message content multiple times, the stream needs to be
cached. Streams are cached in memory only (by default). If
streamCachingSpoolEnabled=true, then, for large stream messages (over
128 KB by default) will be cached in a temporary file instead, and Camel
will handle deleting the temporary file once the cached stream is no
longer necessary. Default is true.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingRemove​SpoolDirectoryWhenStopping</strong></p></td>
<td style="text-align: left;"><p>Whether to remove stream caching
temporary directory when stopping. This option is default true.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingSpool​Cipher</strong></p></td>
<td style="text-align: left;"><p>Sets a stream caching cipher name to
use when spooling to disk to write with encryption. By default the data
is not encrypted.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingSpool​Directory</strong></p></td>
<td style="text-align: left;"><p>Sets the stream caching spool
(temporary) directory to use for overflow and spooling to disk. If no
spool directory has been explicit configured, then a temporary directory
is created in the java.io.tmpdir directory.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingSpool​Enabled</strong></p></td>
<td style="text-align: left;"><p>To enable stream caching spooling to
disk. This means, for large stream messages (over 128 KB by default)
will be cached in a temporary file instead, and Camel will handle
deleting the temporary file once the cached stream is no longer
necessary. Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingSpool​Threshold</strong></p></td>
<td style="text-align: left;"><p>Stream caching threshold in bytes when
overflow to disk is activated. The default threshold is 128kb. Use -1 to
disable overflow to disk.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingSpool​UsedHeapMemoryLimit</strong></p></td>
<td style="text-align: left;"><p>Sets what the upper bounds should be
when streamCachingSpoolUsedHeapMemoryThreshold is in use.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.streamCachingSpool​UsedHeapMemoryThreshold</strong></p></td>
<td style="text-align: left;"><p>Sets a percentage (1-99) of used heap
memory threshold to activate stream caching spooling to disk.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.streamCaching​StatisticsEnabled</strong></p></td>
<td style="text-align: left;"><p>Sets whether stream caching statistics
is enabled.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.threadNamePattern</strong></p></td>
<td style="text-align: left;"><p>Sets the thread name pattern used for
creating the full thread name. The default pattern is: Camel (camelId)
thread #counter - name Where camelId is the name of the CamelContext.
and counter is a unique incrementing counter. and name is the regular
thread name. You can also use longName which is the long thread name
which can includes endpoint parameters etc.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.tracing</strong></p></td>
<td style="text-align: left;"><p>Sets whether tracing is enabled or not.
Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.tracingLogging​Format</strong></p></td>
<td style="text-align: left;"><p>To use a custom tracing logging format.
The default format (arrow, routeId, label) is: %-4.4s %-12.12s
%-33.33s</p></td>
<td style="text-align: center;"><p>%-4.4s [%-12.12s] [%-33.33s]</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.tracingPattern</strong></p></td>
<td style="text-align: left;"><p>Tracing pattern to match which node
EIPs to trace. For example to match all To EIP nodes, use to. The
pattern matches by node and route id’s Multiple patterns can be
separated by comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.tracingStandby</strong></p></td>
<td style="text-align: left;"><p>Whether to set tracing on standby. If
on standby then the tracer is installed and made available. Then the
tracer can be enabled later at runtime via JMX or via
Tracer#setEnabled(boolean) .</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.tracingTemplates</strong></p></td>
<td style="text-align: left;"><p>Whether tracing should trace inner
details from route templates (or kamelets). Turning this on increases
the verbosity of tracing by including events from internal routes in the
templates or kamelets. Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.typeConverter​StatisticsEnabled</strong></p></td>
<td style="text-align: left;"><p>Sets whether type converter statistics
is enabled. By default the type converter utilization statistics is
disabled. Notice: If enabled then there is a slight performance impact
under very heavy load.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.useBreadcrumb</strong></p></td>
<td style="text-align: left;"><p>Set whether breadcrumb is enabled. The
default value is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.useDataType</strong></p></td>
<td style="text-align: left;"><p>Whether to enable using data type on
Camel messages. Data type are automatic turned on if one ore more routes
has been explicit configured with input and output types. Otherwise data
type is default off.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.main.useMdcLogging</strong></p></td>
<td style="text-align: left;"><p>To turn on MDC logging</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.main.uuidGenerator</strong></p></td>
<td style="text-align: left;"><p>UUID generator to use. default (32
bytes), short (16 bytes), classic (32 bytes or longer), simple (long
incrementing counter), off (turned off for exchanges - only intended for
performance profiling)</p></td>
<td style="text-align: center;"><p>default</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

## Camel Route Controller configurations

The camel.routecontroller supports 12 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.routecontroller.backOff​Delay</strong></p></td>
<td style="text-align: left;"><p>Backoff delay in millis when restarting
a route that failed to startup.</p></td>
<td style="text-align: center;"><p>2000</p></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.routecontroller.backOff​MaxAttempts</strong></p></td>
<td style="text-align: left;"><p>Backoff maximum number of attempts to
restart a route that failed to startup. When this threshold has been
exceeded then the controller will give up attempting to restart the
route, and the route will remain as stopped.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.routecontroller.backOff​MaxDelay</strong></p></td>
<td style="text-align: left;"><p>Backoff maximum delay in millis when
restarting a route that failed to startup.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.routecontroller.backOff​MaxElapsedTime</strong></p></td>
<td style="text-align: left;"><p>Backoff maximum elapsed time in millis,
after which the backoff should be considered exhausted and no more
attempts should be made.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.routecontroller.backOff​Multiplier</strong></p></td>
<td style="text-align: left;"><p>Backoff multiplier to use for
exponential backoff. This is used to extend the delay between restart
attempts.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>double</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.routecontroller.enabled</strong></p></td>
<td style="text-align: left;"><p>To enable using supervising route
controller which allows Camel to start up and then, the controller takes
care of starting the routes in a safe manner. This can be used when you
want to start up Camel despite a route may otherwise fail fast during
startup and cause Camel to fail to start up as well. By delegating the
route startup to the supervising route controller, then it manages the
startup using a background thread. The controller allows to be
configured with various settings to attempt to restart failing
routes.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.routecontroller.exclude​Routes</strong></p></td>
<td style="text-align: left;"><p>Pattern for filtering routes to be
excluded as supervised. The pattern is matching on route id, and
endpoint uri for the route. Multiple patterns can be separated by comma.
For example to exclude all JMS routes, you can say jms:. And to exclude
routes with specific route ids mySpecialRoute,myOtherSpecialRoute. The
pattern supports wildcards and uses the matcher from
org.apache.camel.support.PatternHelper#matchPattern.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.routecontroller.include​Routes</strong></p></td>
<td style="text-align: left;"><p>Pattern for filtering routes to be
included as supervised. The pattern is matching on route id, and
endpoint uri for the route. Multiple patterns can be separated by comma.
For example to include all kafka routes, you can say kafka:. And to
include routes with specific route ids myRoute,myOtherRoute. The pattern
supports wildcards and uses the matcher from
org.apache.camel.support.PatternHelper#matchPattern.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.routecontroller.initial​Delay</strong></p></td>
<td style="text-align: left;"><p>Initial delay in milli seconds before
the route controller starts, after CamelContext has been
started.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.routecontroller.thread​PoolSize</strong></p></td>
<td style="text-align: left;"><p>The number of threads used by the route
controller scheduled thread pool that are used for restarting routes.
The pool uses 1 thread by default, but you can increase this to allow
the controller to concurrently attempt to restart multiple routes in
case more than one route has problems starting.</p></td>
<td style="text-align: center;"><p>1</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.routecontroller.unhealthy​OnExhausted</strong></p></td>
<td style="text-align: left;"><p>Whether to mark the route as unhealthy
(down) when all restarting attempts (backoff) have failed and the route
is not successfully started and the route manager is giving up. If
setting this to false will make health checks ignore this problem and
allow to report the Camel application as UP.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.routecontroller.unhealthy​OnRestarting</strong></p></td>
<td style="text-align: left;"><p>Whether to mark the route as unhealthy
(down) when the route failed to initially start, and is being controlled
for restarting (backoff). If setting this to false will make health
checks ignore this problem and allow to report the Camel application as
UP.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
</tbody>
</table>

## Camel Embedded HTTP Server (only for standalone; not Spring Boot or Quarkus) configurations

The camel.server supports 23 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.authentication​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether to enable HTTP authentication
for embedded server (for standalone applications; not Spring Boot or
Quarkus).</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.authentication​Path</strong></p></td>
<td style="text-align: left;"><p>Set HTTP url path of embedded server
that is protected by authentication configuration.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.basicProperties​File</strong></p></td>
<td style="text-align: left;"><p>Name of the file that contains basic
authentication info for Vert.x file auth provider.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.devConsoleEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to enable developer console
(not intended for production use). Dev console must also be enabled on
CamelContext. For example by setting camel.context.dev-console=true in
application.properties, or via code camelContext.setDevConsole(true); If
enabled then you can access a basic developer console on context-path:
/q/dev.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.downloadEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to enable file download via
HTTP. This makes it possible to browse and download resource source
files such as Camel XML or YAML routes. Only enable this for
development, troubleshooting or special situations for management and
monitoring.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.enabled</strong></p></td>
<td style="text-align: left;"><p>Whether embedded HTTP server is
enabled. By default, the server is not enabled.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.healthCheck​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether to enable health-check console.
If enabled then you can access health-check status on context-path:
/q/health</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.host</strong></p></td>
<td style="text-align: left;"><p>Hostname to use for binding embedded
HTTP server</p></td>
<td style="text-align: center;"><p>0.0.0.0</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.infoEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to enable info console. If
enabled then you can see some basic Camel information at
/q/info</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.jolokiaEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to enable jolokia. If enabled
then you can access jolokia api on context-path: /q/jolokia</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.jwtKeystore​Password</strong></p></td>
<td style="text-align: left;"><p>Password from the keystore used for JWT
tokens validation.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.jwtKeystorePath</strong></p></td>
<td style="text-align: left;"><p>Path to the keystore file used for JWT
tokens validation.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.jwtKeystoreType</strong></p></td>
<td style="text-align: left;"><p>Type of the keystore used for JWT
tokens validation (jks, pkcs12, etc.).</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.maxBodySize</strong></p></td>
<td style="text-align: left;"><p>Maximum HTTP body size the embedded
HTTP server can accept.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.metricsEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to enable metrics. If enabled
then you can access metrics on context-path: /q/metrics</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.path</strong></p></td>
<td style="text-align: left;"><p>Context-path to use for embedded HTTP
server</p></td>
<td style="text-align: center;"><p>/</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.port</strong></p></td>
<td style="text-align: left;"><p>Port to use for binding embedded HTTP
server</p></td>
<td style="text-align: center;"><p>8080</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.sendEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to enable sending messages to
Camel via HTTP. This makes it possible to use Camel to send messages to
Camel endpoint URIs via HTTP.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.staticContextPath</strong></p></td>
<td style="text-align: left;"><p>The context-path to use for serving
static content. By default, the root path is used. And if there is an
index.html page then this is automatically loaded.</p></td>
<td style="text-align: center;"><p>/</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.staticEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether serving static files is
enabled. If enabled then Camel can host html/js and other web files that
makes it possible to include small web applications.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.uploadEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to enable file upload via HTTP
(not intended for production use). This functionality is for development
to be able to reload Camel routes and code with source changes (if
reload is enabled). If enabled then you can upload/delete files via HTTP
PUT/DELETE on context-path: /q/upload/{name}. You must also configure
the uploadSourceDir option.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.server.uploadSourceDir</strong></p></td>
<td style="text-align: left;"><p>Source directory when upload is
enabled.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.server.useGlobalSsl​ContextParameters</strong></p></td>
<td style="text-align: left;"><p>Whether to use global SSL configuration
for securing the embedded HTTP server.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
</tbody>
</table>

## Camel Debugger configurations

The camel.debug supports 15 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.debug.bodyIncludeFiles</strong></p></td>
<td style="text-align: left;"><p>Whether to include the message body of
file based messages. The overhead is that the file content has to be
read from the file.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.debug.bodyIncludeStreams</strong></p></td>
<td style="text-align: left;"><p>Whether to include the message body of
stream based messages. If enabled then beware the stream may not be
re-readable later. See more about Stream Caching.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.debug.bodyMaxChars</strong></p></td>
<td style="text-align: left;"><p>To limit the message body to a maximum
size in the traced message. Use 0 or negative value to use unlimited
size.</p></td>
<td style="text-align: center;"><p>32768</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.debug.breakpoints</strong></p></td>
<td style="text-align: left;"><p>Allows to pre-configure breakpoints
(node ids) to use with debugger on startup. Multiple ids can be
separated by comma. Use special value <em>all_routes</em> to add a
breakpoint for the first node for every route, in other words this makes
it easy to debug from the beginning of every route without knowing the
exact node ids.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.debug.enabled</strong></p></td>
<td style="text-align: left;"><p>Enables Debugger in your Camel
application.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.debug.fallbackTimeout</strong></p></td>
<td style="text-align: left;"><p>Fallback Timeout in seconds (300
seconds as default) when block the message processing in Camel. A
timeout used for waiting for a message to arrive at a given
breakpoint.</p></td>
<td style="text-align: center;"><p>300</p></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.debug.includeException</strong></p></td>
<td style="text-align: left;"><p>Trace messages to include exception if
the message failed</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.debug.includeExchange​Properties</strong></p></td>
<td style="text-align: left;"><p>Whether to include the exchange
properties in the traced message</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.debug.includeExchange​Variables</strong></p></td>
<td style="text-align: left;"><p>Whether to include the exchange
variables in the traced message</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.debug.jmxConnector​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether to create JMX connector that
allows tooling to control the Camel debugger. This is what the IDEA and
VSCode tooling is using.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.debug.jmxConnectorPort</strong></p></td>
<td style="text-align: left;"><p>Port number to expose a JMX RMI
connector for tooling that needs to control the debugger.</p></td>
<td style="text-align: center;"><p>1099</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.debug.loggingLevel</strong></p></td>
<td style="text-align: left;"><p>The debugger logging level to use when
logging activity.</p></td>
<td style="text-align: center;"><p>INFO</p></td>
<td style="text-align: left;"><p>LoggingLevel</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.debug.singleStepInclude​StartEnd</strong></p></td>
<td style="text-align: left;"><p>In single step mode, then when the
exchange is created and completed, then simulate a breakpoint at start
and end, that allows to suspend and watch the incoming/complete exchange
at the route (you can see message body as response, failed exception
etc).</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.debug.standby</strong></p></td>
<td style="text-align: left;"><p>To set the debugger in standby mode,
where the debugger will be installed by not automatic enabled. The
debugger can then later be enabled explicit from Java, JMX or
tooling.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.debug.waitForAttach</strong></p></td>
<td style="text-align: left;"><p>Whether the debugger should suspend on
startup, and wait for a remote debugger to attach. This is what the IDEA
and VSCode tooling is using.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
</tbody>
</table>

## Camel Tracer configurations

The camel.trace supports 14 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.trace.backlogSize</strong></p></td>
<td style="text-align: left;"><p>Defines how many of the last messages
to keep in the tracer (should be between 1 - 1000).</p></td>
<td style="text-align: center;"><p>100</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.trace.bodyIncludeFiles</strong></p></td>
<td style="text-align: left;"><p>Whether to include the message body of
file based messages. The overhead is that the file content has to be
read from the file.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.trace.bodyIncludeStreams</strong></p></td>
<td style="text-align: left;"><p>Whether to include the message body of
stream based messages. If enabled then beware the stream may not be
re-readable later. See more about Stream Caching.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.trace.bodyMaxChars</strong></p></td>
<td style="text-align: left;"><p>To limit the message body to a maximum
size in the traced message. Use 0 or negative value to use unlimited
size.</p></td>
<td style="text-align: center;"><p>32768</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.trace.enabled</strong></p></td>
<td style="text-align: left;"><p>Enables tracer in your Camel
application.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.trace.includeException</strong></p></td>
<td style="text-align: left;"><p>Trace messages to include exception if
the message failed</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.trace.includeExchange​Properties</strong></p></td>
<td style="text-align: left;"><p>Whether to include the exchange
properties in the traced message</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.trace.includeExchange​Variables</strong></p></td>
<td style="text-align: left;"><p>Whether to include the exchange
variables in the traced message</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.trace.removeOnDump</strong></p></td>
<td style="text-align: left;"><p>Whether all traced messages should be
removed when the tracer is dumping. By default, the messages are
removed, which means that dumping will not contain previous dumped
messages.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.trace.standby</strong></p></td>
<td style="text-align: left;"><p>To set the tracer in standby mode,
where the tracer will be installed by not automatic enabled. The tracer
can then later be enabled explicit from Java, JMX or tooling.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.trace.traceFilter</strong></p></td>
<td style="text-align: left;"><p>Filter for tracing messages</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.trace.tracePattern</strong></p></td>
<td style="text-align: left;"><p>Filter for tracing by route or node
id</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.trace.traceRests</strong></p></td>
<td style="text-align: left;"><p>Whether to trace routes that is created
from Rest DSL.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.trace.traceTemplates</strong></p></td>
<td style="text-align: left;"><p>Whether to trace routes that is created
from route templates or kamelets.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
</tbody>
</table>

## Camel SSL configurations

The camel.ssl supports 19 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.ssl.certAlias</strong></p></td>
<td style="text-align: left;"><p>An optional certificate alias to use.
This is useful when the keystore has multiple certificates.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.ssl.cipherSuites</strong></p></td>
<td style="text-align: left;"><p>List of TLS/SSL cipher suite algorithm
names. Multiple names can be separated by comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.ssl.cipherSuitesExclude</strong></p></td>
<td style="text-align: left;"><p>Filters TLS/SSL cipher suites
algorithms names. This filter is used for excluding algorithms that
matches the naming pattern. Multiple names can be separated by comma.
Notice that if the cipherSuites option has been configured then the
include/exclude filters are not in use.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.ssl.cipherSuitesInclude</strong></p></td>
<td style="text-align: left;"><p>Filters TLS/SSL cipher suites
algorithms names. This filter is used for including algorithms that
matches the naming pattern. Multiple names can be separated by comma.
Notice that if the cipherSuites option has been configured then the
include/exclude filters are not in use.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.ssl.clientAuthentication</strong></p></td>
<td style="text-align: left;"><p>Sets the configuration for server-side
client-authentication requirements</p></td>
<td style="text-align: center;"><p>NONE</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.ssl.enabled</strong></p></td>
<td style="text-align: left;"><p>Enables SSL in your Camel
application.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.ssl.keyManagerAlgorithm</strong></p></td>
<td style="text-align: left;"><p>Algorithm name used for creating the
KeyManagerFactory. See
https://docs.oracle.com/en/java/javase/17/docs/specs/security/standard-names.html</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.ssl.keyManagerProvider</strong></p></td>
<td style="text-align: left;"><p>To use a specific provider for creating
KeyManagerFactory. The list of available providers returned by
java.security.Security.getProviders() or null to use the highest
priority provider implementing the secure socket protocol.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.ssl.keyStore</strong></p></td>
<td style="text-align: left;"><p>The key store to load. The key store is
by default loaded from classpath. If you must load from file system,
then use file: as prefix. file:nameOfFile (to refer to the file system)
classpath:nameOfFile (to refer to the classpath; default) http:uri (to
load the resource using HTTP) ref:nameOfBean (to lookup an existing
KeyStore instance from the registry, for example for testing and
development).</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.ssl.keystorePassword</strong></p></td>
<td style="text-align: left;"><p>Sets the SSL Keystore
password.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.ssl.keyStoreProvider</strong></p></td>
<td style="text-align: left;"><p>To use a specific provider for creating
KeyStore. The list of available providers returned by
java.security.Security.getProviders() or null to use the highest
priority provider implementing the secure socket protocol.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.ssl.keyStoreType</strong></p></td>
<td style="text-align: left;"><p>The type of the key store to load. See
https://docs.oracle.com/en/java/javase/17/docs/specs/security/standard-names.html</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.ssl.provider</strong></p></td>
<td style="text-align: left;"><p>To use a specific provider for creating
SSLContext. The list of available providers returned by
java.security.Security.getProviders() or null to use the highest
priority provider implementing the secure socket protocol.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.ssl.secureRandom​Algorithm</strong></p></td>
<td style="text-align: left;"><p>Algorithm name used for creating the
SecureRandom. See
https://docs.oracle.com/en/java/javase/17/docs/specs/security/standard-names.html</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.ssl.secureRandomProvider</strong></p></td>
<td style="text-align: left;"><p>To use a specific provider for creating
SecureRandom. The list of available providers returned by
java.security.Security.getProviders() or null to use the highest
priority provider implementing the secure socket protocol.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.ssl.secureSocketProtocol</strong></p></td>
<td style="text-align: left;"><p>The protocol for the secure sockets
created by the SSLContext. See
https://docs.oracle.com/en/java/javase/17/docs/specs/security/standard-names.html</p></td>
<td style="text-align: center;"><p>TLSv1.3</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.ssl.sessionTimeout</strong></p></td>
<td style="text-align: left;"><p>Timeout in seconds to use for
SSLContext. The default is 24 hours.</p></td>
<td style="text-align: center;"><p>86400</p></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.ssl.trustStore</strong></p></td>
<td style="text-align: left;"><p>The trust store to load. The trust
store is by default loaded from classpath. If you must load from file
system, then use file: as prefix. file:nameOfFile (to refer to the file
system) classpath:nameOfFile (to refer to the classpath; default)
http:uri (to load the resource using HTTP) ref:nameOfBean (to lookup an
existing KeyStore instance from the registry, for example for testing
and development).</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.ssl.trustStorePassword</strong></p></td>
<td style="text-align: left;"><p>Sets the SSL Truststore
password.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

## Camel Thread Pool configurations

The camel.threadpool supports 8 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.threadpool.allowCore​ThreadTimeOut</strong></p></td>
<td style="text-align: left;"><p>Sets default whether to allow core
threads to timeout</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.threadpool.config</strong></p></td>
<td style="text-align: left;"><p>Adds a configuration for a specific
thread pool profile (inherits default values)</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Map</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.threadpool.keepAliveTime</strong></p></td>
<td style="text-align: left;"><p>Sets the default keep alive time for
inactive threads</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.threadpool.maxPoolSize</strong></p></td>
<td style="text-align: left;"><p>Sets the default maximum pool
size</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.threadpool.maxQueueSize</strong></p></td>
<td style="text-align: left;"><p>Sets the default maximum number of
tasks in the work queue. Use -1 or an unbounded queue</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.threadpool.poolSize</strong></p></td>
<td style="text-align: left;"><p>Sets the default core pool size
(threads to keep minimum in pool)</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.threadpool.rejected​Policy</strong></p></td>
<td style="text-align: left;"><p>Sets the default handler for tasks
which cannot be executed by the thread pool.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>ThreadPoolRejectedPolicy</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.threadpool.timeUnit</strong></p></td>
<td style="text-align: left;"><p>Sets the default time unit used for
keep alive time</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>TimeUnit</p></td>
</tr>
</tbody>
</table>

## Camel Health Check configurations

The camel.health supports 8 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.health.consumersEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether consumers health check is
enabled</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.health.enabled</strong></p></td>
<td style="text-align: left;"><p>Whether health check is enabled
globally</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.health.excludePattern</strong></p></td>
<td style="text-align: left;"><p>Pattern to exclude health checks from
being invoked by Camel when checking healths. Multiple patterns can be
separated by comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.health.exposureLevel</strong></p></td>
<td style="text-align: left;"><p>Sets the level of details to exposure
as result of invoking health checks. There are the following levels:
full, default, oneline The full level will include all details and
status from all the invoked health checks. The default level will report
UP if everything is okay, and only include detailed information for
health checks that was DOWN. The oneline level will only report either
UP or DOWN.</p></td>
<td style="text-align: center;"><p>default</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.health.initialState</strong></p></td>
<td style="text-align: left;"><p>The initial state of health-checks
(readiness). There are the following states: UP, DOWN, UNKNOWN. By
default, the state is DOWN, is regarded as being pessimistic/careful.
This means that the overall health checks may report as DOWN during
startup and then only if everything is up and running flip to being UP.
Setting the initial state to UP, is regarded as being optimistic. This
means that the overall health checks may report as UP during startup and
then if a consumer or other service is in fact un-healthy, then the
health-checks can flip being DOWN. Setting the state to UNKNOWN means
that some health-check would be reported in unknown state, especially
during early bootstrap where a consumer may not be fully initialized or
validated a connection to a remote system. This option allows to
pre-configure the state for different modes.</p></td>
<td style="text-align: center;"><p>down</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.health.producersEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether producers health check is
enabled</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.health.registryEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether registry health check is
enabled</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.health.routesEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether routes health check is
enabled</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
</tbody>
</table>

## Camel Rest-DSL configurations

The camel.rest supports 29 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.apiComponent</strong></p></td>
<td style="text-align: left;"><p>Sets the name of the Camel component to
use as the REST API (such as swagger or openapi)</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.apiContextPath</strong></p></td>
<td style="text-align: left;"><p>Sets a leading API context-path the
REST API services will be using. This can be used when using components
such as camel-servlet where the deployed web application is deployed
using a context-path.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.apiContextRouteId</strong></p></td>
<td style="text-align: left;"><p>Sets the route id to use for the route
that services the REST API. The route will by default use an auto
assigned route id.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.apiHost</strong></p></td>
<td style="text-align: left;"><p>To use a specific hostname for the API
documentation (such as swagger or openapi) This can be used to override
the generated host with this configured hostname</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.apiProperties</strong></p></td>
<td style="text-align: left;"><p>Sets additional options on api
level</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Map</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.apiVendorExtension</strong></p></td>
<td style="text-align: left;"><p>Whether vendor extension is enabled in
the Rest APIs. If enabled then Camel will include additional information
as vendor extension (eg keys starting with x-) such as route ids, class
names etc. Not all 3rd party API gateways and tools supports
vendor-extensions when importing your API docs.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.bindingMode</strong></p></td>
<td style="text-align: left;"><p>Sets the binding mode to be used by the
REST consumer</p></td>
<td style="text-align: center;"><p>RestBindingMode.off</p></td>
<td style="text-align: left;"><p>RestBindingMode</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.bindingPackageScan</strong></p></td>
<td style="text-align: left;"><p>Package name to use as base (offset)
for classpath scanning of POJO classes are located when using binding
mode is enabled for JSon or XML. Multiple package names can be separated
by comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.clientRequest​Validation</strong></p></td>
<td style="text-align: left;"><p>Whether to enable validation of the
client request to check: 1) Content-Type header matches what the Rest
DSL consumes; returns HTTP Status 415 if validation error. 2) Accept
header matches what the Rest DSL produces; returns HTTP Status 406 if
validation error. 3) Missing required data (query parameters, HTTP
headers, body); returns HTTP Status 400 if validation error. 4) Parsing
error of the message body (JSon, XML or Auto binding mode must be
enabled); returns HTTP Status 400 if validation error.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.component</strong></p></td>
<td style="text-align: left;"><p>Sets the name of the Camel component to
use as the REST consumer</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.componentProperties</strong></p></td>
<td style="text-align: left;"><p>Sets additional options on component
level</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Map</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.consumerProperties</strong></p></td>
<td style="text-align: left;"><p>Sets additional options on consumer
level</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Map</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.contextPath</strong></p></td>
<td style="text-align: left;"><p>Sets a leading context-path the REST
services will be using. This can be used when using components such as
camel-servlet where the deployed web application is deployed using a
context-path. Or for components such as camel-jetty or camel-netty-http
that includes a HTTP server.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.corsHeaders</strong></p></td>
<td style="text-align: left;"><p>Sets the CORS headers to use if CORS
has been enabled.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Map</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.dataFormat​Properties</strong></p></td>
<td style="text-align: left;"><p>Sets additional options on data format
level</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Map</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.enableCORS</strong></p></td>
<td style="text-align: left;"><p>To specify whether to enable CORS which
means Camel will automatic include CORS in the HTTP headers in the
response. This option is default false</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.enableNoContent​Response</strong></p></td>
<td style="text-align: left;"><p>Whether to return HTTP 204 with an
empty body when a response contains an empty JSON object or XML root
object. The default value is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.endpointProperties</strong></p></td>
<td style="text-align: left;"><p>Sets additional options on endpoint
level</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Map</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.host</strong></p></td>
<td style="text-align: left;"><p>Sets the hostname to use by the REST
consumer</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.hostNameResolver</strong></p></td>
<td style="text-align: left;"><p>Sets the resolver to use for resolving
hostname</p></td>
<td
style="text-align: center;"><p>RestHostNameResolver.allLocalIp</p></td>
<td style="text-align: left;"><p>RestHostNameResolver</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.inlineRoutes</strong></p></td>
<td style="text-align: left;"><p>Inline routes in rest-dsl which are
linked using direct endpoints. Each service in Rest DSL is an individual
route, meaning that you would have at least two routes per service
(rest-dsl, and the route linked from rest-dsl). By inlining (default)
allows Camel to optimize and inline this as a single route, however this
requires to use direct endpoints, which must be unique per service. If a
route is not using direct endpoint then the rest-dsl is not inlined, and
will become an individual route. This option is default true.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.jsonDataFormat</strong></p></td>
<td style="text-align: left;"><p>Sets a custom json data format to be
used Important: This option is only for setting a custom name of the
data format, not to refer to an existing data format instance.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.port</strong></p></td>
<td style="text-align: left;"><p>Sets the port to use by the REST
consumer</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>int</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.producerApiDoc</strong></p></td>
<td style="text-align: left;"><p>Sets the location of the api document
(swagger api) the REST producer will use to validate the REST uri and
query parameters are valid accordingly to the api document. This
requires adding camel-openapi-java to the classpath, and any miss
configuration will let Camel fail on startup and report the error(s).
The location of the api document is loaded from classpath by default,
but you can use file: or http: to refer to resources to load from file
or http url.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.producerComponent</strong></p></td>
<td style="text-align: left;"><p>Sets the name of the Camel component to
use as the REST producer</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.scheme</strong></p></td>
<td style="text-align: left;"><p>Sets the scheme to use by the REST
consumer</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.skipBindingOnError​Code</strong></p></td>
<td style="text-align: left;"><p>Whether to skip binding output if there
is a custom HTTP error code, and instead use the response body as-is.
This option is default true.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.rest.useXForwardHeaders</strong></p></td>
<td style="text-align: left;"><p>Whether to use X-Forward headers to set
host etc. for OpenApi. This may be needed in special cases involving
reverse-proxy and networking going from HTTP to HTTPS etc. Then the
proxy can send X-Forward headers (X-Forwarded-Proto) that influences the
host names in the OpenAPI schema that camel-openapi-java generates from
Rest DSL routes.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.rest.xmlDataFormat</strong></p></td>
<td style="text-align: left;"><p>Sets a custom xml data format to be
used. Important: This option is only for setting a custom name of the
data format, not to refer to an existing data format instance.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

## Camel AWS Vault configurations

The camel.vault.aws supports 11 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.aws.accessKey</strong></p></td>
<td style="text-align: left;"><p>The AWS access key</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.aws.default​CredentialsProvider</strong></p></td>
<td style="text-align: left;"><p>Define if we want to use the AWS
Default Credentials Provider or not</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.aws.profile​CredentialsProvider</strong></p></td>
<td style="text-align: left;"><p>Define if we want to use the AWS
Profile Credentials Provider or not</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.aws.profileName</strong></p></td>
<td style="text-align: left;"><p>Define the profile name to use if
Profile Credentials Provider is selected</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.aws.refreshEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to automatically reload Camel
upon secrets being updated in AWS.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.aws.refreshPeriod</strong></p></td>
<td style="text-align: left;"><p>The period (millis) between checking
AWS for updated secrets.</p></td>
<td style="text-align: center;"><p>30000</p></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.aws.region</strong></p></td>
<td style="text-align: left;"><p>The AWS region</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.aws.secretKey</strong></p></td>
<td style="text-align: left;"><p>The AWS secret key</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.aws.secrets</strong></p></td>
<td style="text-align: left;"><p>Specify the secret names (or pattern)
to check for updates. Multiple secrets can be separated by
comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.aws.sqsQueueUrl</strong></p></td>
<td style="text-align: left;"><p>In case of usage of SQS notification
this field will specified the Queue URL to use</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.aws.useSqs​Notification</strong></p></td>
<td style="text-align: left;"><p>Whether to use AWS SQS for secrets
updates notification, this will require setting up
Eventbridge/Cloudtrail/SQS communication</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
</tbody>
</table>

## Camel GCP Vault configurations

The camel.vault.gcp supports 7 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.gcp.projectId</strong></p></td>
<td style="text-align: left;"><p>The GCP Project ID</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.gcp.refreshEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether to automatically reload Camel
upon secrets being updated in AWS.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.gcp.refreshPeriod</strong></p></td>
<td style="text-align: left;"><p>The period (millis) between checking
Google for updated secrets.</p></td>
<td style="text-align: center;"><p>30000</p></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.gcp.secrets</strong></p></td>
<td style="text-align: left;"><p>Specify the secret names (or pattern)
to check for updates. Multiple secrets can be separated by
comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.gcp.serviceAccount​Key</strong></p></td>
<td style="text-align: left;"><p>The Service Account Key
location</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.gcp.subscription​Name</strong></p></td>
<td style="text-align: left;"><p>Define the Google Pubsub subscription
Name to be used when checking for updates</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.gcp.useDefault​Instance</strong></p></td>
<td style="text-align: left;"><p>Define if we want to use the GCP Client
Default Instance or not</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
</tbody>
</table>

## Camel Azure Key Vault configurations

The camel.vault.azure supports 12 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.azure.azure​IdentityEnabled</strong></p></td>
<td style="text-align: left;"><p>Whether the Azure Identity
Authentication should be used or not.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.azure.blobAccess​Key</strong></p></td>
<td style="text-align: left;"><p>The Eventhubs Blob Access Key for
CheckpointStore purpose</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.azure.blobAccount​Name</strong></p></td>
<td style="text-align: left;"><p>The Eventhubs Blob Account Name for
CheckpointStore purpose</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.azure.blob​ContainerName</strong></p></td>
<td style="text-align: left;"><p>The Eventhubs Blob Container Name for
CheckpointStore purpose</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.azure.clientId</strong></p></td>
<td style="text-align: left;"><p>The client Id for accessing Azure Key
Vault</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.azure.clientSecret</strong></p></td>
<td style="text-align: left;"><p>The client Secret for accessing Azure
Key Vault</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.azure.eventhub​ConnectionString</strong></p></td>
<td style="text-align: left;"><p>The Eventhubs connection String for Key
Vault Secret events notifications</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.azure.refresh​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether to automatically reload Camel
upon secrets being updated in Azure.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.azure.refresh​Period</strong></p></td>
<td style="text-align: left;"><p>The period (millis) between checking
Azure for updated secrets.</p></td>
<td style="text-align: center;"><p>30000</p></td>
<td style="text-align: left;"><p>long</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.azure.secrets</strong></p></td>
<td style="text-align: left;"><p>Specify the secret names (or pattern)
to check for updates. Multiple secrets can be separated by
comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.azure.tenantId</strong></p></td>
<td style="text-align: left;"><p>The Tenant Id for accessing Azure Key
Vault</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.azure.vaultName</strong></p></td>
<td style="text-align: left;"><p>The vault Name in Azure Key
Vault</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

## Camel Kubernetes Vault configurations

The camel.vault.kubernetes supports 2 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.kubernetes.refresh​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether to automatically reload Camel
upon secrets being updated in Kubernetes Cluster.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.kubernetes.secrets</strong></p></td>
<td style="text-align: left;"><p>Specify the secret names (or pattern)
to check for updates. Multiple secrets can be separated by
comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

## Camel Hashicorp Vault configurations

The camel.vault.hashicorp supports 4 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.hashicorp.host</strong></p></td>
<td style="text-align: left;"><p>Host to access hashicorp vault</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.hashicorp.port</strong></p></td>
<td style="text-align: left;"><p>Port to access hashicorp vault</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.vault.hashicorp.scheme</strong></p></td>
<td style="text-align: left;"><p>Scheme to access hashicorp
vault</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.vault.hashicorp.token</strong></p></td>
<td style="text-align: left;"><p>Token to access hashicorp
vault</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

## Camel OpenTelemetry configurations

The camel.opentelemetry supports 5 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.opentelemetry.enabled</strong></p></td>
<td style="text-align: left;"><p>To enable OpenTelemetry</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.opentelemetry.encoding</strong></p></td>
<td style="text-align: left;"><p>Sets whether the header keys need to be
encoded (connector specific) or not. The value is a boolean. Dashes need
for instances to be encoded for JMS property keys.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.opentelemetry.exclude​Patterns</strong></p></td>
<td style="text-align: left;"><p>Adds an exclude pattern that will
disable tracing for Camel messages that matches the pattern. Multiple
patterns can be separated by comma.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.opentelemetry.instrumentation​Name</strong></p></td>
<td style="text-align: left;"><p>A name uniquely identifying the
instrumentation scope, such as the instrumentation library, package, or
fully qualified class name. Must not be null.</p></td>
<td style="text-align: center;"><p>camel</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.opentelemetry.trace​Processors</strong></p></td>
<td style="text-align: left;"><p>Setting this to true will create new
OpenTelemetry Spans for each Camel Processors. Use the excludePattern
property to filter out Processors.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
</tbody>
</table>

## Camel Micrometer Metrics configurations

The camel.metrics supports 10 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.metrics.binders</strong></p></td>
<td style="text-align: left;"><p>Additional Micrometer binders to
include such as jvm-memory, processor, jvm-thread, and so forth.
Multiple binders can be separated by comma. The following binders
currently is available from Micrometer: class-loader,
commons-object-pool2, file-descriptor, hystrix-metrics-binder,
jvm-compilation, jvm-gc, jvm-heap-pressure, jvm-info, jvm-memory,
jvm-thread, log4j2, logback, processor, uptime</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.metrics.clearOnReload</strong></p></td>
<td style="text-align: left;"><p>Clear the captured metrics data when
Camel is reloading routes such as when using Camel JBang.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.metrics.enabled</strong></p></td>
<td style="text-align: left;"><p>To enable Micrometer metrics.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.metrics.enableExchange​EventNotifier</strong></p></td>
<td style="text-align: left;"><p>Set whether to enable the
MicrometerExchangeEventNotifier for capturing metrics on exchange
processing times.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.metrics.enableMessage​History</strong></p></td>
<td style="text-align: left;"><p>Set whether to enable the
MicrometerMessageHistoryFactory for capturing metrics on individual
route node processing times. Depending on the number of configured route
nodes, there is the potential to create a large volume of metrics.
Therefore, this option is disabled by default.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.metrics.enableRouteEvent​Notifier</strong></p></td>
<td style="text-align: left;"><p>Set whether to enable the
MicrometerRouteEventNotifier for capturing metrics on the total number
of routes and total number of routes running.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.metrics.enableRoute​Policy</strong></p></td>
<td style="text-align: left;"><p>Set whether to enable the
MicrometerRoutePolicyFactory for capturing metrics on route processing
times.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.metrics.namingStrategy</strong></p></td>
<td style="text-align: left;"><p>Controls the name style to use for
metrics. Default = uses micrometer naming convention. Legacy = uses the
classic naming style (camelCase)</p></td>
<td style="text-align: center;"><p>default</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.metrics.routePolicyLevel</strong></p></td>
<td style="text-align: left;"><p>Sets the level of information to
capture. all = both context and routes.</p></td>
<td style="text-align: center;"><p>all</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.metrics.textFormat​Version</strong></p></td>
<td style="text-align: left;"><p>The text-format version to use with
Prometheus scraping. 0.0.4 = text/plain; version=0.0.4; charset=utf-8
1.0.0 = application/openmetrics-text; version=1.0.0;
charset=utf-8</p></td>
<td style="text-align: center;"><p>0.0.4</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

## Fault Tolerance EIP Circuit Breaker configurations

The camel.faulttolerance supports 13 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.bulkhead​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether bulkhead is enabled or not on
the circuit breaker. Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.bulkhead​ExecutorService</strong></p></td>
<td style="text-align: left;"><p>References to a custom thread pool to
use when bulkhead is enabled.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.bulkhead​MaxConcurrentCalls</strong></p></td>
<td style="text-align: left;"><p>Configures the max amount of concurrent
calls the bulkhead will support. Default value is 10.</p></td>
<td style="text-align: center;"><p>10</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.bulkhead​WaitingTaskQueue</strong></p></td>
<td style="text-align: left;"><p>Configures the task queue size for
holding waiting tasks to be processed by the bulkhead. Default value is
10.</p></td>
<td style="text-align: center;"><p>10</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.circuit​Breaker</strong></p></td>
<td style="text-align: left;"><p>Refers to an existing
io.smallrye.faulttolerance.core.circuit.breaker.CircuitBreaker instance
to lookup and use from the registry. When using this, then any other
circuit breaker options are not in use.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.delay</strong></p></td>
<td style="text-align: left;"><p>Control how long the circuit breaker
stays open. The value are in seconds and the default is 5
seconds.</p></td>
<td style="text-align: center;"><p>5</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.failure​Ratio</strong></p></td>
<td style="text-align: left;"><p>Configures the failure rate threshold
in percentage. If the failure rate is equal or greater than the
threshold the CircuitBreaker transitions to open and starts
short-circuiting calls. The threshold must be greater than 0 and not
greater than 100. Default value is 50 percentage.</p></td>
<td style="text-align: center;"><p>50</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.request​VolumeThreshold</strong></p></td>
<td style="text-align: left;"><p>Controls the size of the rolling window
used when the circuit breaker is closed Default value is 20.</p></td>
<td style="text-align: center;"><p>20</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.success​Threshold</strong></p></td>
<td style="text-align: left;"><p>Controls the number of trial calls
which are allowed when the circuit breaker is half-open Default value is
1.</p></td>
<td style="text-align: center;"><p>1</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.timeout​Duration</strong></p></td>
<td style="text-align: left;"><p>Configures the thread execution
timeout. Default value is 1000 milliseconds.</p></td>
<td style="text-align: center;"><p>1000</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.timeout​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether timeout is enabled or not on
the circuit breaker. Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.timeout​PoolSize</strong></p></td>
<td style="text-align: left;"><p>Configures the pool size of the thread
pool when timeout is enabled. Default value is 10.</p></td>
<td style="text-align: center;"><p>10</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.faulttolerance.timeout​ScheduledExecutorService</strong></p></td>
<td style="text-align: left;"><p>References to a custom thread pool to
use when timeout is enabled</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

## Resilience4j EIP Circuit Breaker configurations

The camel.resilience4j supports 20 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.resilience4j.automatic​TransitionFromOpenToHalfOpen​Enabled</strong></p></td>
<td style="text-align: left;"><p>Enables automatic transition from OPEN
to HALF_OPEN state once the waitDurationInOpenState has passed.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.resilience4j.bulkhead​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether bulkhead is enabled or not on
the circuit breaker.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.resilience4j.bulkheadMax​ConcurrentCalls</strong></p></td>
<td style="text-align: left;"><p>Configures the max amount of concurrent
calls the bulkhead will support.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.resilience4j.bulkheadMax​WaitDuration</strong></p></td>
<td style="text-align: left;"><p>Configures a maximum amount of time
which the calling thread will wait to enter the bulkhead. If bulkhead
has space available, entry is guaranteed and immediate. If bulkhead is
full, calling threads will contest for space, if it becomes available.
maxWaitDuration can be set to 0. Note: for threads running on an
event-loop or equivalent (rx computation pool, etc), setting
maxWaitDuration to 0 is highly recommended. Blocking an event-loop
thread will most likely have a negative effect on application
throughput.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.resilience4j.circuit​Breaker</strong></p></td>
<td style="text-align: left;"><p>Refers to an existing
io.github.resilience4j.circuitbreaker.CircuitBreaker instance to lookup
and use from the registry. When using this, then any other circuit
breaker options are not in use.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.resilience4j.config</strong></p></td>
<td style="text-align: left;"><p>Refers to an existing
io.github.resilience4j.circuitbreaker.CircuitBreakerConfig instance to
lookup and use from the registry.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.resilience4j.failureRate​Threshold</strong></p></td>
<td style="text-align: left;"><p>Configures the failure rate threshold
in percentage. If the failure rate is equal or greater than the
threshold the CircuitBreaker transitions to open and starts
short-circuiting calls. The threshold must be greater than 0 and not
greater than 100. Default value is 50 percentage.</p></td>
<td style="text-align: center;"><p>50</p></td>
<td style="text-align: left;"><p>Float</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.resilience4j.minimum​NumberOfCalls</strong></p></td>
<td style="text-align: left;"><p>Configures configures the minimum
number of calls which are required (per sliding window period) before
the CircuitBreaker can calculate the error rate. For example, if
minimumNumberOfCalls is 10, then at least 10 calls must be recorded,
before the failure rate can be calculated. If only 9 calls have been
recorded the CircuitBreaker will not transition to open even if all 9
calls have failed. Default minimumNumberOfCalls is 100</p></td>
<td style="text-align: center;"><p>100</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.resilience4j.permitted​NumberOfCallsInHalfOpenState</strong></p></td>
<td style="text-align: left;"><p>Configures the number of permitted
calls when the CircuitBreaker is half open. The size must be greater
than 0. Default size is 10.</p></td>
<td style="text-align: center;"><p>10</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.resilience4j.sliding​WindowSize</strong></p></td>
<td style="text-align: left;"><p>Configures the size of the sliding
window which is used to record the outcome of calls when the
CircuitBreaker is closed. slidingWindowSize configures the size of the
sliding window. Sliding window can either be count-based or time-based.
If slidingWindowType is COUNT_BASED, the last slidingWindowSize calls
are recorded and aggregated. If slidingWindowType is TIME_BASED, the
calls of the last slidingWindowSize seconds are recorded and aggregated.
The slidingWindowSize must be greater than 0. The minimumNumberOfCalls
must be greater than 0. If the slidingWindowType is COUNT_BASED, the
minimumNumberOfCalls cannot be greater than slidingWindowSize . If the
slidingWindowType is TIME_BASED, you can pick whatever you want. Default
slidingWindowSize is 100.</p></td>
<td style="text-align: center;"><p>100</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.resilience4j.sliding​WindowType</strong></p></td>
<td style="text-align: left;"><p>Configures the type of the sliding
window which is used to record the outcome of calls when the
CircuitBreaker is closed. Sliding window can either be count-based or
time-based. If slidingWindowType is COUNT_BASED, the last
slidingWindowSize calls are recorded and aggregated. If
slidingWindowType is TIME_BASED, the calls of the last slidingWindowSize
seconds are recorded and aggregated. Default slidingWindowType is
COUNT_BASED.</p></td>
<td style="text-align: center;"><p>COUNT_BASED</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.resilience4j.slowCall​DurationThreshold</strong></p></td>
<td style="text-align: left;"><p>Configures the duration threshold
(seconds) above which calls are considered as slow and increase the slow
calls percentage. Default value is 60 seconds.</p></td>
<td style="text-align: center;"><p>60</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.resilience4j.slowCall​RateThreshold</strong></p></td>
<td style="text-align: left;"><p>Configures a threshold in percentage.
The CircuitBreaker considers a call as slow when the call duration is
greater than slowCallDurationThreshold(Duration. When the percentage of
slow calls is equal or greater the threshold, the CircuitBreaker
transitions to open and starts short-circuiting calls. The threshold
must be greater than 0 and not greater than 100. Default value is 100
percentage which means that all recorded calls must be slower than
slowCallDurationThreshold.</p></td>
<td style="text-align: center;"><p>100</p></td>
<td style="text-align: left;"><p>Float</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.resilience4j.throw​ExceptionWhenHalfOpenOrOpen​State</strong></p></td>
<td style="text-align: left;"><p>Whether to throw
io.github.resilience4j.circuitbreaker.CallNotPermittedException when the
call is rejected due circuit breaker is half open or open.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.resilience4j.timeout​CancelRunningFuture</strong></p></td>
<td style="text-align: left;"><p>Configures whether cancel is called on
the running future. Defaults to true.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.resilience4j.timeout​Duration</strong></p></td>
<td style="text-align: left;"><p>Configures the thread execution timeout
(millis). Default value is 1000 millis (1 second).</p></td>
<td style="text-align: center;"><p>1000</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.resilience4j.timeout​Enabled</strong></p></td>
<td style="text-align: left;"><p>Whether timeout is enabled or not on
the circuit breaker. Default is false.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.resilience4j.timeout​ExecutorService</strong></p></td>
<td style="text-align: left;"><p>References to a custom thread pool to
use when timeout is enabled (uses ForkJoinPool#commonPool() by
default)</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.resilience4j.wait​DurationInOpenState</strong></p></td>
<td style="text-align: left;"><p>Configures the wait duration (in
seconds) which specifies how long the CircuitBreaker should stay open,
before it switches to half open. Default value is 60 seconds.</p></td>
<td style="text-align: center;"><p>60</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.resilience4j.writable​StackTraceEnabled</strong></p></td>
<td style="text-align: left;"><p>Enables writable stack traces. When set
to false, Exception.getStackTrace returns a zero length array. This may
be used to reduce log spam when the circuit breaker is open as the cause
of the exceptions is already known (the circuit breaker is
short-circuiting calls).</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
</tbody>
</table>

## Camel Saga EIP (Long Running Actions) configurations

The camel.lra supports 5 options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.lra.coordinatorContext​Path</strong></p></td>
<td style="text-align: left;"><p>The context-path for the LRA
coordinator. Is default /lra-coordinator</p></td>
<td style="text-align: center;"><p>/lra-coordinator</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.lra.coordinatorUrl</strong></p></td>
<td style="text-align: left;"><p>The URL for the LRA coordinator service
that orchestrates the transactions</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.lra.enabled</strong></p></td>
<td style="text-align: left;"><p>To enable Saga LRA</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.lra.localParticipant​ContextPath</strong></p></td>
<td style="text-align: left;"><p>The context-path for the local
participant. Is default /lra-participant</p></td>
<td style="text-align: center;"><p>/lra-participant</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.lra.localParticipantUrl</strong></p></td>
<td style="text-align: left;"><p>The URL for the local
participant</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

# Package Scanning

**Available since Camel 3.16**

When running Camel standalone via `camel-main` JAR, then Camel will use
package scanning to discover:

-   Camel routes by discovering `RouteBuilder` classes

-   Camel configuration classes by discovering `CamelConfiguration`
    classes or classes annotated with `@Configuration`.

-   Camel type converters by discovering classes annotated with
    `@Converter`

To use package scanning then Camel needs to know the base package to use
as *offset*. This can be specified either with the
`camel.main.basePackage` option or via `Main` class as shown below:

    package com.foo.acme;
    
    public class MyCoolApplication {
    
        public static void main(String[] args) {
            Main main = new Main(MyCoolApplication.class);
            main.run();
        }
    
    }

In the example above, then we use `com.foo.acme` as the base package,
which is done by passing in the class in the `Main` constructor. This is
similar with how Spring Boot does this.

Camel will then scan from the base package and the sub packages.

## Disabling Package Scanning

Package scanning can be turned off by setting
`camel.main.basePackageScanEnabled=false`.

There is a little overhead when using package scanning as Camel performs
this scan during startup.

# Configuring Camel Main applications

You can use *configuration* classes to configure Camel Main applications
from Java.

In **Camel 3.16** onwards the configuration classes must either
implement the interface `org.apache.camel.CamelConfiguration`, or be
annotated with `@Configuration` (or both). In previous versions this was
not required.

For example to configure a Camel application by creating custom beans
you can do:

    public class MyConfiguration implements CamelConfiguration {
    
        @BindToRegistry
        public MyBean myAwesomeBean() {
            MyBean bean = new MyBean();
            // do something on bean
            return bean;
        }
    
        public void configure(CamelContext camelContext) throws Exception {
            // this method is optional and can be omitted
            // do any kind of configuration here if needed
        }
    
    }

In the configuration class you can also have custom methods that creates
beans, such as the `myAwesomeBean` method that creates the `MyBean` and
registers it with the name `myAwesomeBean` (defaults to method name).

This is similar to Spring Boot where you can also do this with the
Spring Boot `@Bean` annotations, or in Quarkus/CDI with the `@Produces`
annotation.

## Using annotation based configuration classes

Instead of configuration classes that implements `CamelConfiguration`,
you can annotate the class with `org.apache.camel.@Configuration` as
shown:

    @Configuration
    public class MyConfiguration {
    
        @BindToRegistry
        public MyBean myAwesomeBean() {
            MyBean bean = new MyBean();
            // do something on bean
            return bean;
        }
    }

# Specifying custom beans

Custom beans can be configured in `camel-main` via properties (such as
in the `application.properties` file).

For example to create a `DataSource` for a Postgress database, you can
create a new bean instance via `#class:` with the class name (fully
qualified). Properties on the data source can then additional configured
such as the server and database name, etc.

    camel.beans.myDS = #class:org.postgresql.jdbc3.Jdbc3PoolingDataSource
    camel.beans.myDS.dataSourceName = myDS
    camel.beans.myDS.serverName = mypostrgress
    camel.beans.myDS.databaseName = test
    camel.beans.myDS.user = testuser
    camel.beans.myDS.password = testpassword
    camel.beans.myDS.maxConnections = 10

The bean is registered in the Camel Registry with the name `myDS`.

If you use the SQL component then the datasource can be configured on
the SQL component:

    camel.component.sql.dataSource = #myDS

To refer to a custom bean you may want to favour using `#bean:` style,
as this states the intention more clearly that its referring to a bean,
and not just a text value that happens to start with a `+#+` sign:

    camel.component.sql.dataSource = #bean:myDS

## Creating a custom map bean

When creating a bean as a `java.util.Map` type, then you can use the
`[]` syntax as shown below:

    camel.beans.myApp[id] = 123
    camel.beans.myApp[name] = Demo App
    camel.beans.myApp[version] = 1.0.1
    camel.beans.myApp[username] = goofy

Camel will then create this as a `LinkedHashMap` type with the name
`myApp` which is bound to the Camel
[Registry](#manual:ROOT:registry.adoc), with the data defined in the
properties.

If you desire a different `java.util.Map` implementation, then you can
use `#class` style as shown:

    camel.beans.myApp = #class:com.foo.MyMapImplementation
    camel.beans.myApp[id] = 123
    camel.beans.myApp[name] = Demo App
    camel.beans.myApp[version] = 1.0.1
    camel.beans.myApp[username] = goofy

## Creating a custom bean with constructor parameters

When creating a bean then parameters to the constructor can be provided.
Suppose we have a class `MyFoo` with a constructor:

    public class MyFoo {
        private String name;
        private boolean important;
        private int id;
    
        public MyFoo(String name, boolean important, int id) {
            this.name = name;
            this.important = important;
            this.id = id;
        }
    }

Then we can create a bean instance with name `foo` and provide
parameters to the constructor as shown:

    camel.beans.foo = #class:com.foo.MyBean("Hello World", true, 123)

## Creating custom beans with factory method

When creating a bean then parameters to a factorty method can be
provided. Suppose we have a class `MyFoo` with a static factory method:

    public class MyFoo {
        private String name;
        private boolean important;
        private int id;
    
        private MyFoo() {
            // use factory method
        }
    
        public static MyFoo buildFoo(String name, boolean important, int id) {
            MyFoo foo = new MyFoo();
            foo.name = name;
            foo.important = important;
            foo.id = id;
            return foo;
        }
    }

Then we can create a bean instance with name `foo` and provide
parameters to the static factory method as shown:

    camel.beans.foo = #class:com.foo.MyBean#buildFoo("Hello World", true, 123)

The syntax must use `#factoryMethodName` to tell Camel that the bean
should be created from a factory method.

## Optional parameters on beans

If a parameter on a bean is not mandatory then the parameter can be
marked as optional using `?` syntax, as shown:

    camel.beans.foo = #class:com.foo.MyBean("Hello World", true, 123)
    camel.beans.foo.?company = Acme

Then the company parameter is only set if `MyBean` has this option
(silent ignore if no option present). Otherwise, if a parameter is set,
and the bean does not have such a parameter, then an exception is thrown
by Camel.

## Optional parameter values on beans

If a parameter value on a bean is configured using [Property
Placeholder](#manual:ROOT:using-propertyplaceholder.adoc) and the
placeholder is optional, then the placeholder can be marked as optional
using `?` syntax, as shown:

    camel.beans.foo = #class:com.foo.MyBean("Hello World", true, 123)
    camel.beans.foo.company = {{?companyName}}

Then the company parameter is only set if there is a property
placeholder with the key *companyName* (silent ignore if no option
present).

### Default parameter values on beans

It is possible to supply a default value (using `:defaultValue`) if the
placeholder does not exist as shown:

    camel.beans.foo = #class:com.foo.MyBean("Hello World", true, 123)
    camel.beans.foo.company = {{?companyName:Acme}}

Here the default value is *Acme* that will be used if there is no
property placeholder with the key *companyName*.

## Nested parameters on beans

You can configure nested parameters separating them via `.` (dot).

For example given this `Country` class:

    public class Country {
        private String iso;
        private String name;
    
        public void setIso(String iso) {
            this.iso = iso;
        }
    
        public void setName(String name) {
            this.name = name;
        }
    }

Which is an option on the `MyBean` class. Then we can then configure its
iso and name parameter as shown below:

    camel.beans.foo = #class:com.foo.MyBean("Hello World", true, 123)
    camel.beans.foo.country.iso = USA
    camel.beans.foo.country.name = United States of America

Camel will automatically create an instance of `Country` if `MyBean` has
a getter/setter for this option, and that the `Country` bean has a
default no-arg constructor.

## Configuring singleton beans by their type

In the example above the SQL component was configured with the name of
the `DataSource`. There can be situations where you know there is only a
single instance of a data source in the Camel registry. In such a
situation you can instead refer to the class or interface type via the
`#type:` prefix as shown below:

    camel.component.sql.dataSource = #type:javax.sql.DataSource

If there is no bean in the registry with the type `javax.sql.DataSource`
then the option isn’t configured.

## Autowiring beans

The example above can be taken one step further by letting `camel-main`
try to autowire the beans.

    camel.component.sql.dataSource = #autowired

In this situation then `#autowrired` will make Camel detect the type of
the `dataSource` option on the `SQL` component. Because type is a
`javax.sql.DataSource` instance, then Camel will lookup in the registry
if there is a single instance of the same type. If there is no such bean
then the option isn’t configured.

# Defining a Map bean

You can specify `java.util.Map` beans in `camel-main` via properties
(such as in the `application.properties` file).

Maps have a special syntax with brackets as shown below:

    camel.beans.mymap[table] = 12
    camel.beans.mymap[food] = Big Burger
    camel.beans.mymap[cheese] = yes
    camel.beans.mymap[quantity] = 1

The Map is registered in the Camel Registry with the name `mymap`.

## Using dots in Map keys

If the Map should contain keys with dots then the key must be quoted, as
shown below using single quoted keys:

    camel.beans.myldapserver['java.naming.provider.url'] = ldaps://ldap.local:636
    camel.beans.myldapserver['java.naming.security.principal'] = scott
    camel.beans.myldapserver['java.naming.security.credentials'] = tiger

# Defining a List bean

This is similar to Map bean where the key is the index, eg 0, 1, 2, etc:

    camel.beans.myprojects[0] = Camel
    camel.beans.myprojects[1] = Kafka
    camel.beans.myprojects[2] = Quarkus

The List is registered in the Camel Registry with the name `myprojects`.

# Examples

You can find a set of examples using `camel-main` in [Camel
Examples](https://github.com/apache/camel-examples) which demonstrate
running Camel in standalone with `camel-main`.
