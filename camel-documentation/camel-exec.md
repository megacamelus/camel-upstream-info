# Exec

**Since Camel 2.3**

**Only producer is supported**

The Exec component can be used to execute system commands.

# Dependencies

Maven users need to add the following dependency to their `pom.xml`

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-exec</artifactId>
      <version>${camel-version}</version>
    </dependency>

Where `${camel-version`} must be replaced by the actual version of
Camel.

# URI format

    exec://executable[?options]

Where `executable` is the name, or file path, of the system command that
will be executed. If executable name is used (e.g. `exec:java`), the
executable must in the system path.

# Usage

## Message body

If the component receives an `in` message body that is convertible to
`java.io.InputStream`, it is used to feed input to the executable via
its standard input (`stdin`). After execution, [the message
body](http://camel.apache.org/exchange.html) is the result of the
execution. That is, an `org.apache.camel.components.exec.ExecResult`
instance containing the `stdout`, `stderr`, *exit value*, and the *out
file*.

This component supports the following `ExecResult` [type
converters](http://camel.apache.org/type-converter.html) for
convenience:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">From</th>
<th style="text-align: left;">To</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>ExecResult</code></p></td>
<td
style="text-align: left;"><p><code>java.io.InputStream</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>ExecResult</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>ExecResult</code></p></td>
<td style="text-align: left;"><p><code>byte []</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>ExecResult</code></p></td>
<td
style="text-align: left;"><p><code>org.w3c.dom.Document</code></p></td>
</tr>
</tbody>
</table>

If an *out file* is specified (in the endpoint via `outFile` or the
message headers via `ExecBinding.EXEC_COMMAND_OUT_FILE`), the converters
will return the content of the *out file*. If no *out file* is used,
then this component will convert the `stdout` of the process to the
target type. For more details, please refer to the [usage
examples](#exec-component.adoc) below.

# Examples

## Executing word count (Linux)

The example below executes `wc` (word count, Linux) to count the words
in file `/usr/share/dict/words`. The word count (*output*) is written to
the standard output stream of `wc`:

    from("direct:exec")
    .to("exec:wc?args=--words /usr/share/dict/words")
    .process(new Processor() {
         public void process(Exchange exchange) throws Exception {
           // By default, the body is ExecResult instance
           assertIsInstanceOf(ExecResult.class, exchange.getIn().getBody());
           // Use the Camel Exec String type converter to convert the ExecResult to String
           // In this case, the stdout is considered as output
           String wordCountOutput = exchange.getIn().getBody(String.class);
           // do something with the word count
         }
    });

## Executing `java`

The example below executes `java` with two arguments: `-server` and
`-version`, if `java` is in the system path.

    from("direct:exec")
    .to("exec:java?args=-server -version")

The example below executes `java` in `c:\temp` with three arguments:
`-server`, `-version` and the system property `user.name`.

    from("direct:exec")
    .to("exec:c:/program files/jdk/bin/java?args=-server -version -Duser.name=Camel&workingDir=c:/temp")

## Executing Ant scripts

The following example executes [Apache Ant](http://ant.apache.org/)
(Windows only) with the build file `CamelExecBuildFile.xml`, provided
that `ant.bat` is in the system path, and that `CamelExecBuildFile.xml`
is in the current directory.

    from("direct:exec")
    .to("exec:ant.bat?args=-f CamelExecBuildFile.xml")

In the next example, the `ant.bat` command redirects its output to
`CamelExecOutFile.txt` with `-l`. The file `CamelExecOutFile.txt` is
used as the *out file* with `outFile=CamelExecOutFile.txt`. The example
assumes that `ant.bat` is in the system path, and that
`CamelExecBuildFile.xml` is in the current directory.

    from("direct:exec")
    .to("exec:ant.bat?args=-f CamelExecBuildFile.xml -l CamelExecOutFile.txt&outFile=CamelExecOutFile.txt")
    .process(new Processor() {
         public void process(Exchange exchange) throws Exception {
            InputStream outFile = exchange.getIn().getBody(InputStream.class);
            assertIsInstanceOf(InputStream.class, outFile);
            // do something with the out file here
         }
      });

## Executing `echo` (Windows)

Commands such as `echo` and `dir` can be executed only with the command
interpreter of the operating system. This example shows how to execute
such a command - `echo` - in Windows.

    from("direct:exec").to("exec:cmd?args=/C echo echoString")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|executable|Sets the executable to be executed. The executable must not be empty or null.||string|
|args|The arguments may be one or many whitespace-separated tokens.||string|
|binding|A reference to a org.apache.commons.exec.ExecBinding in the Registry.||object|
|commandExecutor|A reference to a org.apache.commons.exec.ExecCommandExecutor in the Registry that customizes the command execution. The default command executor utilizes the commons-exec library, which adds a shutdown hook for every executed command.||object|
|commandLogLevel|Logging level to be used for commands during execution. The default value is DEBUG. Possible values are TRACE, DEBUG, INFO, WARN, ERROR or OFF. (Values of ExecCommandLogLevelType enum)|DEBUG|object|
|exitValues|The exit values of successful executions. If the process exits with another value, an exception is raised. Comma-separated list of exit values. And empty list (the default) sets no expected exit values and disables the check.||string|
|outFile|The name of a file, created by the executable, that should be considered as its output. If no outFile is set, the standard output (stdout) of the executable will be used instead.||string|
|timeout|The timeout, in milliseconds, after which the executable should be terminated. If execution has not completed within the timeout, the component will send a termination request.||duration|
|useStderrOnEmptyStdout|A boolean indicating that when stdout is empty, this component will populate the Camel Message Body with stderr. This behavior is disabled (false) by default.|false|boolean|
|workingDir|The directory in which the command should be executed. If null, the working directory of the current process will be used.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
