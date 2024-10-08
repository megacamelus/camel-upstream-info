# Ftp

**Since Camel 1.1**

**Both producer and consumer are supported**

This component provides access to remote file systems over the FTP and
SFTP protocols.

When consuming from remote FTP server, make sure you read the section
[Default when consuming files](#FTP-DefaultWhenConsumingFiles) further
below for details related to consuming files.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-ftp</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    ftp://[username@]hostname[:port]/directoryname[?options]
    sftp://[username@]hostname[:port]/directoryname[?options]
    ftps://[username@]hostname[:port]/directoryname[?options]

Where `directoryname` represents the underlying directory. The directory
name is a relative path. Absolute path is **not** supported. The
relative path can contain nested folders, such as /inbox/us.

Camel translates the absolute path to relative by trimming all leading
slashes from `directoryname`. There’ll be a warning (`WARN` level)
message printed in the logs.

The `autoCreate` option is supported. When consumer starts, before
polling is scheduled, there’s additional FTP operation performed to
create the directory configured for endpoint. The default value for
`autoCreate` is `true`.

If no **username** is provided, then `anonymous` login is attempted
using no password.  
If no **port** number is provided, Camel will provide default values
according to the protocol (ftp = 21, sftp = 22, ftps = 2222).

You can append query options to the URI in the following format,
`?option=value&option=value&...`

This component uses two different libraries for the actual FTP work. FTP
and FTPS use [Apache Commons Net](http://commons.apache.org/net/) while
SFTP uses [JCraft JSCH](http://www.jcraft.com/jsch/).

FTPS, also known as FTP Secure, is an extension to FTP that adds support
for the Transport Layer Security (TLS) and the Secure Sockets Layer
(SSL) cryptographic protocols.

# Usage

## FTPS component default trust store

When using the `ftpClient.` properties related to SSL with the FTPS
component, the trust store accepts all certificates. If you only want
trust selective certificates, you have to configure the trust store with
the `ftpClient.trustStore.xxx` options or by configuring a custom
`ftpClient`.

When using `sslContextParameters`, the trust store is managed by the
configuration of the provided SSLContextParameters instance.

You can configure additional options on the `ftpClient` and
`ftpClientConfig` from the URI directly by using the `ftpClient.` or
`ftpClientConfig.` prefix.

For example, to set the `setDataTimeout` on the `FTPClient` to 30
seconds you can do:

    from("ftp://foo@myserver?password=secret&ftpClient.dataTimeout=30000").to("bean:foo");

You can mix and match and use both prefixes, for example, to configure
date format or timezones.

    from("ftp://foo@myserver?password=secret&ftpClient.dataTimeout=30000&ftpClientConfig.serverLanguageCode=fr").to("bean:foo");

You can have as many of these options as you like.

See the documentation of the Apache Commons FTP FTPClientConfig for
possible options and more details. And as well for Apache Commons FTP
`FTPClient`.

If you do not like having many and long configurations in the url, you
can refer to the `ftpClient` or `ftpClientConfig` to use by letting
Camel lookup in the Registry for it.

For example:

       <bean id="myConfig" class="org.apache.commons.net.ftp.FTPClientConfig">
           <property name="lenientFutureDates" value="true"/>
           <property name="serverLanguageCode" value="fr"/>
       </bean>

And then let Camel look up this bean when you use the # notation in the
url.

    from("ftp://foo@myserver?password=secret&ftpClientConfig=#myConfig").to("bean:foo");

## Concurrency

The FTP consumer (with the same endpoint) does not support concurrency
(the backing FTP client is not thread safe). You can use multiple FTP
consumers to poll from different endpoints. It is only a single endpoint
that does not support concurrent consumers.

The FTP producer does **not** have this issue, it supports concurrency.

## Default when consuming files

The FTP consumer will by default leave the consumed files untouched on
the remote FTP server. You have to configure it explicitly if you want
it to delete the files or move them to another location. For example,
you can use `delete=true` to delete the files, or use `move=.done` to
move the files into a hidden done subdirectory.

The regular File consumer is different as it will by default move files
to a `.camel` sub directory. The reason Camel does **not** do this by
default for the FTP consumer is that it may lack permissions by default
to be able to move or delete files.

### limitations

The option `readLock` can be used to force Camel **not** to consume
files that are currently in the progress of being written. However, this
option is turned off by default, as it requires that the user has write
access. See the options table for more details about read locks. There
are other solutions to avoid consuming files that are currently being
written over FTP; for instance, you can write to a temporary destination
and move the file after it has been written.

When moving files using `move` or `preMove` option the files are
restricted to the FTP\_ROOT folder. That prevents you from moving files
outside the FTP area. If you want to move files to another area, you can
use soft links and move files into a soft linked folder.

## Exchange Properties

Camel sets the following exchange properties

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>CamelBatchIndex</code></p></td>
<td style="text-align: left;"><p>The current index out of total number
of files being consumed in this batch.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>CamelBatchSize</code></p></td>
<td style="text-align: left;"><p>The total number of files being
consumed in this batch.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelBatchComplete</code></p></td>
<td style="text-align: left;"><p><code>true</code> if there are no more
files in this batch.</p></td>
</tr>
</tbody>
</table>

## About timeouts

The two sets of libraries (see top) have different API for setting
timeout. You can use the `connectTimeout` option for both of them to set
a timeout in millis to establish a network connection. An individual
`soTimeout` can also be set on the FTP/FTPS, which corresponds to using
`ftpClient.soTimeout`. Notice SFTP will automatically use
`connectTimeout` as its `soTimeout`. The `timeout` option only applies
for FTP/FTPS as the data timeout, which corresponds to the
`ftpClient.dataTimeout` value. All timeout values are in millis.

## Using Local Work Directory

Camel supports consuming from remote FTP servers and downloading the
files directly into a local work directory. This avoids reading the
entire remote file content into memory as it is streamed directly into
the local file using `FileOutputStream`.

Camel will store to a local file with the same name as the remote file,
though with `.inprogress` as the extension while the file is being
downloaded. Afterward, the file is renamed to remove the `.inprogress`
suffix. And finally, when the Exchange is complete, the local file is
deleted.

So if you want to download files from a remote FTP server and store it
as files, then you need to route to a file endpoint such as:

    from("ftp://someone@someserver.com?password=secret&localWorkDirectory=/tmp").to("file://inbox");

The route above is ultra efficient as it avoids reading the entire file
content into memory. It will download the remote file directly to a
local file stream. The `java.io.File` handle is then used as the
Exchange body. The file producer leverages this fact and can work
directly on the work file `java.io.File` handle and perform a
`java.io.File.rename` to the target filename. As Camel knows it’s a
local work file, it can optimize and use a rename instead of a file
copy, as the work file is meant to be deleted anyway.

## Stepwise changing directories

Camel FTP can operate in two modes in terms of traversing directories
when consuming files (e.g., downloading) or producing files (e.g.,
uploading)

-   stepwise

-   not stepwise

You may want to pick either one depending on your situation and security
issues. Some Camel end users can only download files if they use
stepwise, while others can only download if they do not.

You can use the `stepwise` option to control the behavior.

Note that stepwise changing of directory will in most cases only work
when the user is confined to its home directory and when the home
directory is reported as `"/"`.

The difference between the two of them is best illustrated with an
example. Suppose we have the following directory structure on the remote
FTP server, we need to traverse and download files:

    /
    /one
    /one/two
    /one/two/sub-a
    /one/two/sub-b

And that we have a file in each of `sub-a` (`a.txt`) and `sub-b`
(`b.txt`) folder.

Default (Stepwise enabled)  
**Using `stepwise=true` (default mode)**

    TYPE A
    200 Type set to A
    PWD
    257 "/" is current directory.
    CWD one
    250 CWD successful. "/one" is current directory.
    CWD two
    250 CWD successful. "/one/two" is current directory.
    SYST
    215 UNIX emulated by FileZilla
    PORT 127,0,0,1,17,94
    200 Port command successful
    LIST
    150 Opening data channel for directory list.
    226 Transfer OK
    CWD sub-a
    250 CWD successful. "/one/two/sub-a" is current directory.
    PORT 127,0,0,1,17,95
    200 Port command successful
    LIST
    150 Opening data channel for directory list.
    226 Transfer OK
    CDUP
    200 CDUP successful. "/one/two" is current directory.
    CWD sub-b
    250 CWD successful. "/one/two/sub-b" is current directory.
    PORT 127,0,0,1,17,96
    200 Port command successful
    LIST
    150 Opening data channel for directory list.
    226 Transfer OK
    CDUP
    200 CDUP successful. "/one/two" is current directory.
    CWD /
    250 CWD successful. "/" is current directory.
    PWD
    257 "/" is current directory.
    CWD one
    250 CWD successful. "/one" is current directory.
    CWD two
    250 CWD successful. "/one/two" is current directory.
    PORT 127,0,0,1,17,97
    200 Port command successful
    RETR foo.txt
    150 Opening data channel for file transfer.
    226 Transfer OK
    CWD /
    250 CWD successful. "/" is current directory.
    PWD
    257 "/" is current directory.
    CWD one
    250 CWD successful. "/one" is current directory.
    CWD two
    250 CWD successful. "/one/two" is current directory.
    CWD sub-a
    250 CWD successful. "/one/two/sub-a" is current directory.
    PORT 127,0,0,1,17,98
    200 Port command successful
    RETR a.txt
    150 Opening data channel for file transfer.
    226 Transfer OK
    CWD /
    250 CWD successful. "/" is current directory.
    PWD
    257 "/" is current directory.
    CWD one
    250 CWD successful. "/one" is current directory.
    CWD two
    250 CWD successful. "/one/two" is current directory.
    CWD sub-b
    250 CWD successful. "/one/two/sub-b" is current directory.
    PORT 127,0,0,1,17,99
    200 Port command successful
    RETR b.txt
    150 Opening data channel for file transfer.
    226 Transfer OK
    CWD /
    250 CWD successful. "/" is current directory.
    QUIT
    221 Goodbye
    disconnected.

As you can see when stepwise is enabled, it will traverse the directory
structure using CD xxx.

Stepwise Disabled  
**Using `stepwise=false`**

    230 Logged on
    TYPE A
    200 Type set to A
    SYST
    215 UNIX emulated by FileZilla
    PORT 127,0,0,1,4,122
    200 Port command successful
    LIST one/two
    150 Opening data channel for directory list
    226 Transfer OK
    PORT 127,0,0,1,4,123
    200 Port command successful
    LIST one/two/sub-a
    150 Opening data channel for directory list
    226 Transfer OK
    PORT 127,0,0,1,4,124
    200 Port command successful
    LIST one/two/sub-b
    150 Opening data channel for directory list
    226 Transfer OK
    PORT 127,0,0,1,4,125
    200 Port command successful
    RETR one/two/foo.txt
    150 Opening data channel for file transfer.
    226 Transfer OK
    PORT 127,0,0,1,4,126
    200 Port command successful
    RETR one/two/sub-a/a.txt
    150 Opening data channel for file transfer.
    226 Transfer OK
    PORT 127,0,0,1,4,127
    200 Port command successful
    RETR one/two/sub-b/b.txt
    150 Opening data channel for file transfer.
    226 Transfer OK
    QUIT
    221 Goodbye
    disconnected.

As you can see when not using stepwise, there is no CD operation invoked
at all.

## Filtering Strategies

Camel supports pluggable filtering strategies. They are described below.

See also the documentation for filtering strategies on the [File
component](#file-component.adoc).

### Custom filtering

Camel supports pluggable filtering strategies. This strategy it to use
the build in `org.apache.camel.component.file.GenericFileFilter` in
Java. You can then configure the endpoint with such a filter to skip
certain filters before being processed.

In the sample, we have built our own filter that only accepts files
starting with `report` in the filename.

And then we can configure our route using the **filter** attribute to
reference our filter (using `#` notation) that we have defined in the
spring XML file:

       <!-- define our sorter as a plain spring bean -->
       <bean id="myFilter" class="com.mycompany.MyFileFilter"/>
    
      <route>
        <from uri="ftp://someuser@someftpserver.com?password=secret&amp;filter=#myFilter"/>
        <to uri="bean:processInbox"/>
      </route>

### Filtering using ANT path matcher

The ANT path matcher is a filter shipped out-of-the-box in the
**camel-spring** jar. So you need to depend on **camel-spring** if you
are using Maven. The reason is that we leverage Spring’s
[AntPathMatcher](http://static.springsource.org/spring/docs/3.0.x/api/org/springframework/util/AntPathMatcher.html)
to do the actual matching.

The file paths are matched with the following rules:

-   `?` matches one character

-   `*` matches zero or more characters

-   `**` matches zero or more directories in a path

The sample below demonstrates how to use it:

    from("ftp://admin@localhost:2222/public/camel?antInclude=**/*.txt").to("...");

## Using a proxy with SFTP

To use an HTTP proxy to connect to your remote host, you can configure
your route in the following way:

    <!-- define our sorter as a plain spring bean -->
    <bean id="proxy" class="com.jcraft.jsch.ProxyHTTP">
      <constructor-arg value="localhost"/>
      <constructor-arg value="7777"/>
    </bean>
    
    <route>
      <from uri="sftp://localhost:9999/root?username=admin&password=admin&proxy=#proxy"/>
      <to uri="bean:processFile"/>
    </route>

You can also assign a username and password to the proxy, if necessary.
Please consult the documentation for `com.jcraft.jsch.Proxy` to discover
all options.

## Setting preferred SFTP authentication method

If you want to explicitly specify the list of authentication methods
that should be used by `sftp` component, use `preferredAuthentications`
option. If, for example, you would like Camel to attempt to authenticate
with a private/public SSH key and fallback to user/password
authentication in the case when no public key is available, use the
following route configuration:

    from("sftp://localhost:9999/root?username=admin&password=admin&preferredAuthentications=publickey,password").
      to("bean:processFile");

## Consuming a single file using a fixed name

When you want to download a single file and knows the file name, you can
use `fileName=myFileName.txt` to tell Camel the name of the file to
download. By default, the consumer will still do an FTP LIST command to
do a directory listing and then filter these files based on the
`fileName` option. Though in this use-case it may be desirable to turn
off the directory listing by setting `useList=false`. For example, the
user account used to log in to the FTP server may not have permission to
do an FTP LIST command. So you can turn off this with `useList=false`,
and then provide the fixed name of the file to download with
`fileName=myFileName.txt`, then the FTP consumer can still download the
file. If the file for some reason does not exist, then Camel will by
default throw an exception, you can turn this off and ignore this by
setting `ignoreFileNotFoundOrPermissionError=true`.

For example, to have a Camel route that picks up a single file, and
delete it after use you can do

    from("ftp://admin@localhost:21/nolist/?password=admin&stepwise=false&useList=false&ignoreFileNotFoundOrPermissionError=true&fileName=report.txt&delete=true")
      .to("activemq:queue:report");

Notice that we have used all the options we talked above.

You can also use this with `ConsumerTemplate`. For example, to download
a single file (if it exists) and grab the file content as a String type:

    String data = template.retrieveBodyNoWait("ftp://admin@localhost:21/nolist/?password=admin&stepwise=false&useList=false&ignoreFileNotFoundOrPermissionError=true&fileName=report.txt&delete=true", String.class);

## Debug logging

This component has log level **TRACE** that can be helpful if you have
problems.

# Examples

In the sample below, we set up Camel to download all the reports from
the FTP server once every hour (60 min) as BINARY content and store it
as files on the local file system.

And the route using XML DSL:

      <route>
         <from uri="ftp://scott@localhost/public/reports?password=tiger&amp;binary=true&amp;delay=60000"/>
         <to uri="file://target/test-reports"/>
      </route>

## Consuming a remote FTPS server (implicit SSL) and client authentication

    from("ftps://admin@localhost:2222/public/camel?password=admin&securityProtocol=SSL&implicit=true
          &ftpClient.keyStore.file=./src/test/resources/server.jks
          &ftpClient.keyStore.password=password&ftpClient.keyStore.keyPassword=password")
      .to("bean:foo");

## Consuming a remote FTPS server (explicit TLS) and a custom trust store configuration

    from("ftps://admin@localhost:2222/public/camel?password=admin&ftpClient.trustStore.file=./src/test/resources/server.jks&ftpClient.trustStore.password=password")
      .to("bean:foo");

## Examples

    ftp://someone@someftpserver.com/public/upload/images/holiday2008?password=secret&binary=true
    
    ftp://someoneelse@someotherftpserver.co.uk:12049/reports/2008/password=secret&binary=false
    
    ftp://publicftpserver.com/download

# More information

This component is an extension of the [File
component](#file-component.adoc).

You can find additional samples and details on the File component page.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Hostname of the FTP server||string|
|port|Port of the FTP server||integer|
|directoryName|The starting directory||string|
|binary|Specifies the file transfer mode, BINARY or ASCII. Default is ASCII (false).|false|boolean|
|charset|This option is used to specify the encoding of the file. You can use this on the consumer, to specify the encodings of the files, which allow Camel to know the charset it should load the file content in case the file content is being accessed. Likewise when writing a file, you can use this option to specify which charset to write the file as well. Do mind that when writing the file Camel may have to read the message content into memory to be able to convert the data into the configured charset, so do not use this if you have big messages.||string|
|disconnect|Whether or not to disconnect from remote FTP server right after use. Disconnect will only disconnect the current connection to the FTP server. If you have a consumer which you want to stop, then you need to stop the consumer/route instead.|false|boolean|
|doneFileName|Producer: If provided, then Camel will write a 2nd done file when the original file has been written. The done file will be empty. This option configures what file name to use. Either you can specify a fixed name. Or you can use dynamic placeholders. The done file will always be written in the same folder as the original file. Consumer: If provided, Camel will only consume files if a done file exists. This option configures what file name to use. Either you can specify a fixed name. Or you can use dynamic placeholders.The done file is always expected in the same folder as the original file. Only ${file.name} and ${file.name.next} is supported as dynamic placeholders.||string|
|fileName|Use Expression such as File Language to dynamically set the filename. For consumers, it's used as a filename filter. For producers, it's used to evaluate the filename to write. If an expression is set, it take precedence over the CamelFileName header. (Note: The header itself can also be an Expression). The expression options support both String and Expression types. If the expression is a String type, it is always evaluated using the File Language. If the expression is an Expression type, the specified Expression type is used - this allows you, for instance, to use OGNL expressions. For the consumer, you can use it to filter filenames, so you can for instance consume today's file using the File Language syntax: mydata-${date:now:yyyyMMdd}.txt. The producers support the CamelOverruleFileName header which takes precedence over any existing CamelFileName header; the CamelOverruleFileName is a header that is used only once, and makes it easier as this avoids to temporary store CamelFileName and have to restore it afterwards.||string|
|passiveMode|Sets passive mode connections. Default is active mode connections.|false|boolean|
|separator|Sets the path separator to be used. UNIX = Uses unix style path separator Windows = Uses windows style path separator Auto = (is default) Use existing path separator in file name|UNIX|object|
|transferLoggingIntervalSeconds|Configures the interval in seconds to use when logging the progress of upload and download operations that are in-flight. This is used for logging progress when operations take a longer time.|5|integer|
|transferLoggingLevel|Configure the logging level to use when logging the progress of upload and download operations.|DEBUG|object|
|transferLoggingVerbose|Configures whether perform verbose (fine-grained) logging of the progress of upload and download operations.|false|boolean|
|fastExistsCheck|If set this option to be true, camel-ftp will use the list file directly to check if the file exists. Since some FTP server may not support to list the file directly, if the option is false, camel-ftp will use the old way to list the directory and check if the file exists. This option also influences readLock=changed to control whether it performs a fast check to update file information or not. This can be used to speed up the process if the FTP server has a lot of files.|false|boolean|
|delete|If true, the file will be deleted after it is processed successfully.|false|boolean|
|moveFailed|Sets the move failure expression based on Simple language. For example, to move files into a .error subdirectory use: .error. Note: When moving the files to the fail location Camel will handle the error and will not pick up the file again.||string|
|noop|If true, the file is not moved or deleted in any way. This option is good for readonly data, or for ETL type requirements. If noop=true, Camel will set idempotent=true as well, to avoid consuming the same files over and over again.|false|boolean|
|preMove|Expression (such as File Language) used to dynamically set the filename when moving it before processing. For example to move in-progress files into the order directory set this value to order.||string|
|preSort|When pre-sort is enabled then the consumer will sort the file and directory names during polling, that was retrieved from the file system. You may want to do this in case you need to operate on the files in a sorted order. The pre-sort is executed before the consumer starts to filter, and accept files to process by Camel. This option is default=false meaning disabled.|false|boolean|
|recursive|If a directory, will look for files in all the sub-directories as well.|false|boolean|
|resumeDownload|Configures whether resume download is enabled. This must be supported by the FTP server (almost all FTP servers support it). In addition, the options localWorkDirectory must be configured so downloaded files are stored in a local directory, and the option binary must be enabled, which is required to support resuming of downloads.|false|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|streamDownload|Sets the download method to use when not using a local working directory. If set to true, the remote files are streamed to the route as they are read. When set to false, the remote files are loaded into memory before being sent into the route. If enabling this option then you must set stepwise=false as both cannot be enabled at the same time.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|download|Whether the FTP consumer should download the file. If this option is set to false, then the message body will be null, but the consumer will still trigger a Camel Exchange that has details about the file such as file name, file size, etc. It's just that the file will not be downloaded.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|handleDirectoryParserAbsoluteResult|Allows you to set how the consumer will handle subfolders and files in the path if the directory parser results in with absolute paths. The reason for this is that some FTP servers may return file names with absolute paths, and if so, then the FTP component needs to handle this by converting the returned path into a relative path.|false|boolean|
|ignoreFileNotFoundOrPermissionError|Whether to ignore when (trying to list files in directories or when downloading a file), which does not exist or due to permission error. By default when a directory or file does not exist or insufficient permission, then an exception is thrown. Setting this option to true allows to ignore that instead.|false|boolean|
|inProgressRepository|A pluggable in-progress repository org.apache.camel.spi.IdempotentRepository. The in-progress repository is used to account the current in progress files being consumed. By default a memory based repository is used.||object|
|localWorkDirectory|When consuming, a local work directory can be used to store the remote file content directly in local files, to avoid loading the content into memory. This is beneficial, if you consume a very big remote file and thus can conserve memory.||string|
|onCompletionExceptionHandler|To use a custom org.apache.camel.spi.ExceptionHandler to handle any thrown exceptions that happens during the file on completion process where the consumer does either a commit or rollback. The default implementation will log any exception at WARN level and ignore.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|processStrategy|A pluggable org.apache.camel.component.file.GenericFileProcessStrategy allowing you to implement your own readLock option or similar. Can also be used when special conditions must be met before a file can be consumed, such as a special ready file exists. If this option is set then the readLock option does not apply.||object|
|useList|Whether to allow using LIST command when downloading a file. Default is true. In some use cases you may want to download a specific file and are not allowed to use the LIST command, and therefore you can set this option to false. Notice when using this option, then the specific file to download does not include meta-data information such as file size, timestamp, permissions etc, because those information is only possible to retrieve when LIST command is in use.|true|boolean|
|checksumFileAlgorithm|If provided, then Camel will write a checksum file when the original file has been written. The checksum file will contain the checksum created with the provided algorithm for the original file. The checksum file will always be written in the same folder as the original file.||string|
|fileExist|What to do if a file already exists with the same name. Override, which is the default, replaces the existing file. - Append - adds content to the existing file. - Fail - throws a GenericFileOperationException, indicating that there is already an existing file. - Ignore - silently ignores the problem and does not override the existing file, but assumes everything is okay. - Move - option requires to use the moveExisting option to be configured as well. The option eagerDeleteTargetFile can be used to control what to do if an moving the file, and there exists already an existing file, otherwise causing the move operation to fail. The Move option will move any existing files, before writing the target file. - TryRename is only applicable if tempFileName option is in use. This allows to try renaming the file from the temporary name to the actual name, without doing any exists check. This check may be faster on some file systems and especially FTP servers.|Override|object|
|flatten|Flatten is used to flatten the file name path to strip any leading paths, so it's just the file name. This allows you to consume recursively into sub-directories, but when you eg write the files to another directory they will be written in a single directory. Setting this to true on the producer enforces that any file name in CamelFileName header will be stripped for any leading paths.|false|boolean|
|jailStartingDirectory|Used for jailing (restricting) writing files to the starting directory (and sub) only. This is enabled by default to not allow Camel to write files to outside directories (to be more secured out of the box). You can turn this off to allow writing files to directories outside the starting directory, such as parent or root folders.|true|boolean|
|moveExisting|Expression (such as File Language) used to compute file name to use when fileExist=Move is configured. To move files into a backup subdirectory just enter backup. This option only supports the following File Language tokens: file:name, file:name.ext, file:name.noext, file:onlyname, file:onlyname.noext, file:ext, and file:parent. Notice the file:parent is not supported by the FTP component, as the FTP component can only move any existing files to a relative directory based on current dir as base.||string|
|tempFileName|The same as tempPrefix option but offering a more fine grained control on the naming of the temporary filename as it uses the File Language. The location for tempFilename is relative to the final file location in the option 'fileName', not the target directory in the base uri. For example if option fileName includes a directory prefix: dir/finalFilename then tempFileName is relative to that subdirectory dir.||string|
|tempPrefix|This option is used to write the file using a temporary name and then, after the write is complete, rename it to the real name. Can be used to identify files being written and also avoid consumers (not using exclusive read locks) reading in progress files. Is often used by FTP when uploading big files.||string|
|allowNullBody|Used to specify if a null body is allowed during file writing. If set to true then an empty file will be created, when set to false, and attempting to send a null body to the file component, a GenericFileWriteException of 'Cannot write null body to file.' will be thrown. If the fileExist option is set to 'Override', then the file will be truncated, and if set to append the file will remain unchanged.|false|boolean|
|chmod|Allows you to set chmod on the stored file. For example, chmod=640.||string|
|disconnectOnBatchComplete|Whether or not to disconnect from remote FTP server right after a Batch upload is complete. disconnectOnBatchComplete will only disconnect the current connection to the FTP server.|false|boolean|
|eagerDeleteTargetFile|Whether or not to eagerly delete any existing target file. This option only applies when you use fileExists=Override and the tempFileName option as well. You can use this to disable (set it to false) deleting the target file before the temp file is written. For example you may write big files and want the target file to exists during the temp file is being written. This ensure the target file is only deleted until the very last moment, just before the temp file is being renamed to the target filename. This option is also used to control whether to delete any existing files when fileExist=Move is enabled, and an existing file exists. If this option copyAndDeleteOnRenameFails false, then an exception will be thrown if an existing file existed, if its true, then the existing file is deleted before the move operation.|true|boolean|
|keepLastModified|Will keep the last modified timestamp from the source file (if any). Will use the FileConstants.FILE\_LAST\_MODIFIED header to located the timestamp. This header can contain either a java.util.Date or long with the timestamp. If the timestamp exists and the option is enabled it will set this timestamp on the written file. Note: This option only applies to the file producer. You cannot use this option with any of the ftp producers.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|moveExistingFileStrategy|Strategy (Custom Strategy) used to move file with special naming token to use when fileExist=Move is configured. By default, there is an implementation used if no custom strategy is provided||object|
|sendNoop|Whether to send a noop command as a pre-write check before uploading files to the FTP server. This is enabled by default as a validation of the connection is still valid, which allows to silently re-connect to be able to upload the file. However if this causes problems, you can turn this option off.|true|boolean|
|activePortRange|Set the client side port range in active mode. The syntax is: minPort-maxPort Both port numbers are inclusive, e.g., 10000-19999 to include all 1xxxx ports.||string|
|autoCreate|Automatically create missing directories in the file's pathname. For the file consumer, that means creating the starting directory. For the file producer, it means the directory the files should be written to.|true|boolean|
|bufferSize|Buffer size in bytes used for writing files (or in case of FTP for downloading and uploading files).|131072|integer|
|connectTimeout|Sets the connect timeout for waiting for a connection to be established Used by both FTPClient and JSCH|10000|duration|
|ftpClient|To use a custom instance of FTPClient||object|
|ftpClientConfig|To use a custom instance of FTPClientConfig to configure the FTP client the endpoint should use.||object|
|ftpClientConfigParameters|Used by FtpComponent to provide additional parameters for the FTPClientConfig||object|
|ftpClientParameters|Used by FtpComponent to provide additional parameters for the FTPClient||object|
|maximumReconnectAttempts|Specifies the maximum reconnect attempts Camel performs when it tries to connect to the remote FTP server. Use 0 to disable this behavior.||integer|
|reconnectDelay|Delay in millis Camel will wait before performing a reconnect attempt.|1000|duration|
|siteCommand|Sets optional site command(s) to be executed after successful login. Multiple site commands can be separated using a new line character.||string|
|soTimeout|Sets the so timeout FTP and FTPS Is the SocketOptions.SO\_TIMEOUT value in millis. Recommended option is to set this to 300000 so as not have a hanged connection. On SFTP this option is set as timeout on the JSCH Session instance.|300000|duration|
|stepwise|Sets whether we should stepwise change directories while traversing file structures when downloading files, or as well when uploading a file to a directory. You can disable this if you for example are in a situation where you cannot change directory on the FTP server due security reasons. Stepwise cannot be used together with streamDownload.|true|boolean|
|throwExceptionOnConnectFailed|Should an exception be thrown if connection failed (exhausted)By default exception is not thrown and a WARN is logged. You can use this to enable exception being thrown and handle the thrown exception from the org.apache.camel.spi.PollingConsumerPollStrategy rollback method.|false|boolean|
|timeout|Sets the data timeout for waiting for reply Used only by FTPClient|30000|duration|
|antExclude|Ant style filter exclusion. If both antInclude and antExclude are used, antExclude takes precedence over antInclude. Multiple exclusions may be specified in comma-delimited format.||string|
|antFilterCaseSensitive|Sets case sensitive flag on ant filter.|true|boolean|
|antInclude|Ant style filter inclusion. Multiple inclusions may be specified in comma-delimited format.||string|
|eagerMaxMessagesPerPoll|Allows for controlling whether the limit from maxMessagesPerPoll is eager or not. If eager then the limit is during the scanning of files. Where as false would scan all files, and then perform sorting. Setting this option to false allows for sorting all files first, and then limit the poll. Mind that this requires a higher memory usage as all file details are in memory to perform the sorting.|true|boolean|
|exclude|Is used to exclude files, if filename matches the regex pattern (matching is case in-sensitive). Notice if you use symbols such as plus sign and others you would need to configure this using the RAW() syntax if configuring this as an endpoint uri. See more details at configuring endpoint uris||string|
|excludeExt|Is used to exclude files matching file extension name (case insensitive). For example to exclude bak files, then use excludeExt=bak. Multiple extensions can be separated by comma, for example to exclude bak and dat files, use excludeExt=bak,dat. Note that the file extension includes all parts, for example having a file named mydata.tar.gz will have extension as tar.gz. For more flexibility then use the include/exclude options.||string|
|filter|Pluggable filter as a org.apache.camel.component.file.GenericFileFilter class. Will skip files if filter returns false in its accept() method.||object|
|filterDirectory|Filters the directory based on Simple language. For example to filter on current date, you can use a simple date pattern such as ${date:now:yyyMMdd}||string|
|filterFile|Filters the file based on Simple language. For example to filter on file size, you can use ${file:size} 5000||string|
|idempotent|Option to use the Idempotent Consumer EIP pattern to let Camel skip already processed files. Will by default use a memory based LRUCache that holds 1000 entries. If noop=true then idempotent will be enabled as well to avoid consuming the same files over and over again.|false|boolean|
|idempotentEager|Option to use the Idempotent Consumer EIP pattern to let Camel skip already processed files. Will by default use a memory based LRUCache that holds 1000 entries. If noop=true then idempotent will be enabled as well to avoid consuming the same files over and over again.|false|boolean|
|idempotentKey|To use a custom idempotent key. By default the absolute path of the file is used. You can use the File Language, for example to use the file name and file size, you can do: idempotentKey=${file:name}-${file:size}||string|
|idempotentRepository|A pluggable repository org.apache.camel.spi.IdempotentRepository which by default use MemoryIdempotentRepository if none is specified and idempotent is true.||object|
|include|Is used to include files, if filename matches the regex pattern (matching is case in-sensitive). Notice if you use symbols such as plus sign and others you would need to configure this using the RAW() syntax if configuring this as an endpoint uri. See more details at configuring endpoint uris||string|
|includeExt|Is used to include files matching file extension name (case insensitive). For example to include txt files, then use includeExt=txt. Multiple extensions can be separated by comma, for example to include txt and xml files, use includeExt=txt,xml. Note that the file extension includes all parts, for example having a file named mydata.tar.gz will have extension as tar.gz. For more flexibility then use the include/exclude options.||string|
|maxDepth|The maximum depth to traverse when recursively processing a directory.|2147483647|integer|
|maxMessagesPerPoll|To define a maximum messages to gather per poll. By default no maximum is set. Can be used to set a limit of e.g. 1000 to avoid when starting up the server that there are thousands of files. Set a value of 0 or negative to disabled it. Notice: If this option is in use then the File and FTP components will limit before any sorting. For example if you have 100000 files and use maxMessagesPerPoll=500, then only the first 500 files will be picked up, and then sorted. You can use the eagerMaxMessagesPerPoll option and set this to false to allow to scan all files first and then sort afterwards.||integer|
|minDepth|The minimum depth to start processing when recursively processing a directory. Using minDepth=1 means the base directory. Using minDepth=2 means the first sub directory.||integer|
|move|Expression (such as Simple Language) used to dynamically set the filename when moving it after processing. To move files into a .done subdirectory just enter .done.||string|
|exclusiveReadLockStrategy|Pluggable read-lock as a org.apache.camel.component.file.GenericFileExclusiveReadLockStrategy implementation.||object|
|readLock|Used by consumer, to only poll the files if it has exclusive read-lock on the file (i.e. the file is not in-progress or being written). Camel will wait until the file lock is granted. This option provides the build in strategies: - none - No read lock is in use - markerFile - Camel creates a marker file (fileName.camelLock) and then holds a lock on it. This option is not available for the FTP component - changed - Changed is using file length/modification timestamp to detect whether the file is currently being copied or not. Will at least use 1 sec to determine this, so this option cannot consume files as fast as the others, but can be more reliable as the JDK IO API cannot always determine whether a file is currently being used by another process. The option readLockCheckInterval can be used to set the check frequency. - fileLock - is for using java.nio.channels.FileLock. This option is not avail for Windows OS and the FTP component. This approach should be avoided when accessing a remote file system via a mount/share unless that file system supports distributed file locks. - rename - rename is for using a try to rename the file as a test if we can get exclusive read-lock. - idempotent - (only for file component) idempotent is for using a idempotentRepository as the read-lock. This allows to use read locks that supports clustering if the idempotent repository implementation supports that. - idempotent-changed - (only for file component) idempotent-changed is for using a idempotentRepository and changed as the combined read-lock. This allows to use read locks that supports clustering if the idempotent repository implementation supports that. - idempotent-rename - (only for file component) idempotent-rename is for using a idempotentRepository and rename as the combined read-lock. This allows to use read locks that supports clustering if the idempotent repository implementation supports that.Notice: The various read locks is not all suited to work in clustered mode, where concurrent consumers on different nodes is competing for the same files on a shared file system. The markerFile using a close to atomic operation to create the empty marker file, but its not guaranteed to work in a cluster. The fileLock may work better but then the file system need to support distributed file locks, and so on. Using the idempotent read lock can support clustering if the idempotent repository supports clustering, such as Hazelcast Component or Infinispan.|none|string|
|readLockCheckInterval|Interval in millis for the read-lock, if supported by the read lock. This interval is used for sleeping between attempts to acquire the read lock. For example when using the changed read lock, you can set a higher interval period to cater for slow writes. The default of 1 sec. may be too fast if the producer is very slow writing the file. Notice: For FTP the default readLockCheckInterval is 5000. The readLockTimeout value must be higher than readLockCheckInterval, but a rule of thumb is to have a timeout that is at least 2 or more times higher than the readLockCheckInterval. This is needed to ensure that ample time is allowed for the read lock process to try to grab the lock before the timeout was hit.|1000|integer|
|readLockDeleteOrphanLockFiles|Whether or not read lock with marker files should upon startup delete any orphan read lock files, which may have been left on the file system, if Camel was not properly shutdown (such as a JVM crash). If turning this option to false then any orphaned lock file will cause Camel to not attempt to pickup that file, this could also be due another node is concurrently reading files from the same shared directory.|true|boolean|
|readLockLoggingLevel|Logging level used when a read lock could not be acquired. By default a DEBUG is logged. You can change this level, for example to OFF to not have any logging. This option is only applicable for readLock of types: changed, fileLock, idempotent, idempotent-changed, idempotent-rename, rename.|DEBUG|object|
|readLockMarkerFile|Whether to use marker file with the changed, rename, or exclusive read lock types. By default a marker file is used as well to guard against other processes picking up the same files. This behavior can be turned off by setting this option to false. For example if you do not want to write marker files to the file systems by the Camel application.|true|boolean|
|readLockMinAge|This option is applied only for readLock=changed. It allows to specify a minimum age the file must be before attempting to acquire the read lock. For example use readLockMinAge=300s to require the file is at last 5 minutes old. This can speedup the changed read lock as it will only attempt to acquire files which are at least that given age.|0|integer|
|readLockMinLength|This option is applied only for readLock=changed. It allows you to configure a minimum file length. By default Camel expects the file to contain data, and thus the default value is 1. You can set this option to zero, to allow consuming zero-length files.|1|integer|
|readLockRemoveOnCommit|This option is applied only for readLock=idempotent. It allows to specify whether to remove the file name entry from the idempotent repository when processing the file is succeeded and a commit happens. By default the file is not removed which ensures that any race-condition do not occur so another active node may attempt to grab the file. Instead the idempotent repository may support eviction strategies that you can configure to evict the file name entry after X minutes - this ensures no problems with race conditions. See more details at the readLockIdempotentReleaseDelay option.|false|boolean|
|readLockRemoveOnRollback|This option is applied only for readLock=idempotent. It allows to specify whether to remove the file name entry from the idempotent repository when processing the file failed and a rollback happens. If this option is false, then the file name entry is confirmed (as if the file did a commit).|true|boolean|
|readLockTimeout|Optional timeout in millis for the read-lock, if supported by the read-lock. If the read-lock could not be granted and the timeout triggered, then Camel will skip the file. At next poll Camel, will try the file again, and this time maybe the read-lock could be granted. Use a value of 0 or lower to indicate forever. Currently fileLock, changed and rename support the timeout. Notice: For FTP the default readLockTimeout value is 20000 instead of 10000. The readLockTimeout value must be higher than readLockCheckInterval, but a rule of thumb is to have a timeout that is at least 2 or more times higher than the readLockCheckInterval. This is needed to ensure that ample time is allowed for the read lock process to try to grab the lock before the timeout was hit.|10000|integer|
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
|account|Account to use for login||string|
|password|Password to use for login||string|
|username|Username to use for login||string|
|shuffle|To shuffle the list of files (sort in random order)|false|boolean|
|sortBy|Built-in sort by using the File Language. Supports nested sorts, so you can have a sort by file name and as a 2nd group sort by modified date.||string|
|sorter|Pluggable sorter as a java.util.Comparator class.||object|
