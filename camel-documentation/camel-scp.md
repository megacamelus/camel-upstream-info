# Scp

**Since Camel 2.10**

**Only producer is supported**

The Camel Jsch component supports the [SCP
protocol](http://en.wikipedia.org/wiki/Secure_copy) using the Client API
of the [Jsch](http://www.jcraft.com/jsch/) project. Jsch is already used
in camel by the [FTP](#ftp-component.adoc) component for the **sftp:**
protocol.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jsch</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    scp://host[:port]/destination[?options]

The file name can be specified either in the \<path\> part of the
URI or as a "CamelFileName" header on the message (`Exchange.FILE_NAME`
if used in code).

# Limitations

Currently, camel-jsch only supports a
[Producer](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Producer.html)
(i.e., copy files to another host).

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|verboseLogging|JSCH is verbose logging out of the box. Therefore we turn the logging down to DEBUG logging by default. But setting this option to true turns on the verbose logging again.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Hostname of the FTP server||string|
|port|Port of the FTP server||integer|
|directoryName|The starting directory||string|
|chmod|Allows you to set chmod on the stored file. For example chmod=664.|664|string|
|disconnect|Whether or not to disconnect from remote FTP server right after use. Disconnect will only disconnect the current connection to the FTP server. If you have a consumer which you want to stop, then you need to stop the consumer/route instead.|false|boolean|
|checksumFileAlgorithm|If provided, then Camel will write a checksum file when the original file has been written. The checksum file will contain the checksum created with the provided algorithm for the original file. The checksum file will always be written in the same folder as the original file.||string|
|fileName|Use Expression such as File Language to dynamically set the filename. For consumers, it's used as a filename filter. For producers, it's used to evaluate the filename to write. If an expression is set, it take precedence over the CamelFileName header. (Note: The header itself can also be an Expression). The expression options support both String and Expression types. If the expression is a String type, it is always evaluated using the File Language. If the expression is an Expression type, the specified Expression type is used - this allows you, for instance, to use OGNL expressions. For the consumer, you can use it to filter filenames, so you can for instance consume today's file using the File Language syntax: mydata-${date:now:yyyyMMdd}.txt. The producers support the CamelOverruleFileName header which takes precedence over any existing CamelFileName header; the CamelOverruleFileName is a header that is used only once, and makes it easier as this avoids to temporary store CamelFileName and have to restore it afterwards.||string|
|flatten|Flatten is used to flatten the file name path to strip any leading paths, so it's just the file name. This allows you to consume recursively into sub-directories, but when you eg write the files to another directory they will be written in a single directory. Setting this to true on the producer enforces that any file name in CamelFileName header will be stripped for any leading paths.|false|boolean|
|jailStartingDirectory|Used for jailing (restricting) writing files to the starting directory (and sub) only. This is enabled by default to not allow Camel to write files to outside directories (to be more secured out of the box). You can turn this off to allow writing files to directories outside the starting directory, such as parent or root folders.|true|boolean|
|strictHostKeyChecking|Sets whether to use strict host key checking. Possible values are: no, yes|no|string|
|allowNullBody|Used to specify if a null body is allowed during file writing. If set to true then an empty file will be created, when set to false, and attempting to send a null body to the file component, a GenericFileWriteException of 'Cannot write null body to file.' will be thrown. If the fileExist option is set to 'Override', then the file will be truncated, and if set to append the file will remain unchanged.|false|boolean|
|disconnectOnBatchComplete|Whether or not to disconnect from remote FTP server right after a Batch upload is complete. disconnectOnBatchComplete will only disconnect the current connection to the FTP server.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|moveExistingFileStrategy|Strategy (Custom Strategy) used to move file with special naming token to use when fileExist=Move is configured. By default, there is an implementation used if no custom strategy is provided||object|
|connectTimeout|Sets the connect timeout for waiting for a connection to be established Used by both FTPClient and JSCH|10000|duration|
|soTimeout|Sets the so timeout FTP and FTPS Is the SocketOptions.SO\_TIMEOUT value in millis. Recommended option is to set this to 300000 so as not have a hanged connection. On SFTP this option is set as timeout on the JSCH Session instance.|300000|duration|
|timeout|Sets the data timeout for waiting for reply Used only by FTPClient|30000|duration|
|knownHostsFile|Sets the known\_hosts file, so that the jsch endpoint can do host key verification. You can prefix with classpath: to load the file from classpath instead of file system.||string|
|password|Password to use for login||string|
|preferredAuthentications|Set a comma separated list of authentications that will be used in order of preference. Possible authentication methods are defined by JCraft JSCH. Some examples include: gssapi-with-mic,publickey,keyboard-interactive,password If not specified the JSCH and/or system defaults will be used.||string|
|privateKeyBytes|Set the private key bytes to that the endpoint can do private key verification. This must be used only if privateKeyFile wasn't set. Otherwise the file will have the priority.||string|
|privateKeyFile|Set the private key file to that the endpoint can do private key verification. You can prefix with classpath: to load the file from classpath instead of file system.||string|
|privateKeyFilePassphrase|Set the private key file passphrase to that the endpoint can do private key verification.||string|
|username|Username to use for login||string|
|useUserKnownHostsFile|If knownHostFile has not been explicit configured, then use the host file from System.getProperty(user.home) /.ssh/known\_hosts|true|boolean|
|ciphers|Set a comma separated list of ciphers that will be used in order of preference. Possible cipher names are defined by JCraft JSCH. Some examples include: aes128-ctr,aes128-cbc,3des-ctr,3des-cbc,blowfish-cbc,aes192-cbc,aes256-cbc. If not specified the default list from JSCH will be used.||string|
