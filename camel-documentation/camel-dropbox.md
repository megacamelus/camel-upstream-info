# Dropbox

**Since Camel 2.14**

**Both producer and consumer are supported**

The Dropbox component allows you to treat
[Dropbox](https://www.dropbox.com) remote folders as a producer or
consumer of messages. Using the [Dropbox Java Core
API](https://github.com/dropbox/dropbox-sdk-java), this camel component
has the following features:

-   As a consumer, download files and search files by queries

-   As a producer, download files, move files between remote
    directories, delete files/dir, upload files and search files by
    queries

To work with Dropbox API, you need to obtain an **accessToken**,
**expireIn**, **refreshToken**, **apiKey**, **apiSecret** and a
**clientIdentifier.**  
You can refer to the [Dropbox
documentation](https://dropbox.tech/developers/migrating-app-permissions-and-access-tokens)
that explains how to get them.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-dropbox</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    dropbox://[operation]?[options]

Where **operation** is the specific action (typically is a CRUD action)
to perform on Dropbox remote folder.

# Operations

<table>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>del</code></p></td>
<td style="text-align: left;"><p>deletes files or directories on
Dropbox</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>download files from Dropbox</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>move</code></p></td>
<td style="text-align: left;"><p>move files from folders on
Dropbox</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>put</code></p></td>
<td style="text-align: left;"><p>upload files on Dropbox</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>search</code></p></td>
<td style="text-align: left;"><p>search files on Dropbox based on string
queries</p></td>
</tr>
</tbody>
</table>

**Operations** require additional options to work. Some are mandatory
for the specific operation.

# Del operation

Delete files on Dropbox.

Works only as a Camel producer.

Below are listed the options for this operation:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Mandatory</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>remotePath</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>Folder or file to delete on
Dropbox</p></td>
</tr>
</tbody>
</table>

## Samples

    from("direct:start")
      .to("dropbox://del?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&remotePath=/root/folder1")
      .to("mock:result");
    
    from("direct:start")
      .to("dropbox://del?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&remotePath=/root/folder1/file1.tar.gz")
      .to("mock:result");

## Result Message Body

The following objects are set on message body result:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Object type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>name of the path deleted on
dropbox</p></td>
</tr>
</tbody>
</table>

# Get (download) operation

Download files from Dropbox.

Works as a Camel producer or Camel consumer.

Below are listed the options for this operation:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Mandatory</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>remotePath</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>Folder or file to download from
Dropbox</p></td>
</tr>
</tbody>
</table>

## Samples

    from("direct:start")
      .to("dropbox://get?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&remotePath=/root/folder1/file1.tar.gz")
      .to("file:///home/kermit/?fileName=file1.tar.gz");
    
    from("direct:start")
      .to("dropbox://get?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&remotePath=/root/folder1")
      .to("mock:result");
    
    from("dropbox://get?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&remotePath=/root/folder1")
      .to("file:///home/kermit/");

## Result Message Body

The following objects are set on message body result:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Object type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>byte[]</code> or
<code>CachedOutputStream</code> if stream caching is enabled</p></td>
<td style="text-align: left;"><p>in case of single file download, stream
represents the file downloaded</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>Map&lt;String, byte[]&gt;</code>
or <code>Map&lt;String, CachedOutputStream&gt;</code> if stream caching
is enabled</p></td>
<td style="text-align: left;"><p>in the case of multiple files
downloaded, a map with as a key the path of the remote file downloaded
and as value the stream representing the file downloaded</p></td>
</tr>
</tbody>
</table>

# Move operation

Move files on Dropbox between one folder to another.

Works only as a Camel producer.

Below are listed the options for this operation:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Mandatory</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>remotePath</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>Original file or folder to
move</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>newRemotePath</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>Destination file or folder</p></td>
</tr>
</tbody>
</table>

## Samples

    from("direct:start")
      .to("dropbox://move?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&remotePath=/root/folder1&newRemotePath=/root/folder2")
      .to("mock:result");

## Result Message Body

The following objects are set on message body result:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Object type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>name of the path moved on
dropbox</p></td>
</tr>
</tbody>
</table>

# Put (upload) operation

Upload files on Dropbox.

Works as a Camel producer.

Below are listed the options for this operation:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Mandatory</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>uploadMode</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>add or force this option specifies how
a file should be saved on dropbox: in the case of <code>add</code>, the
new file will be renamed if a file with the same name already exists on
dropbox. In the case of <code>force</code>, if a file with the same name
already exists on dropbox, this will be overwritten.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>localPath</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Folder or file to upload on Dropbox
from the local filesystem. If this option has been configured, then it
takes precedence over uploading as a single file with content from the
Camel message body (the message body is converted into a byte
array).</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>remotePath</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Folder destination on Dropbox. If the
property is not set, the component will upload the file on a remote path
equal to the local path. With Windows or without an absolute localPath
you may run into an exception like the following:</p>
<p>Caused by: java.lang.IllegalArgumentException: <em>path</em>: bad
path: must start with "/": "C:/My/File"<br />
OR<br />
Caused by: java.lang.IllegalArgumentException: <em>path</em>: bad path:
must start with "/": "MyFile"<br />
</p></td>
</tr>
</tbody>
</table>

## Samples

    from("direct:start").to("dropbox://put?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&uploadMode=add&localPath=/root/folder1")
      .to("mock:result");
    
    from("direct:start").to("dropbox://put?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&uploadMode=add&localPath=/root/folder1&remotePath=/root/folder2")
      .to("mock:result");

And to upload a single file with content from the message body

    from("direct:start")
       .setHeader(DropboxConstants.HEADER_PUT_FILE_NAME, constant("myfile.txt"))
       .to("dropbox://put?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&uploadMode=add&remotePath=/root/folder2")
       .to("mock:result");

The name of the file can be provided in the header
`DropboxConstants.HEADER_PUT_FILE_NAME` or `Exchange.FILE_NAME` in that
order of precedence. If no header has been provided then the message id
(uuid) is used as the file name.

## Result Message Body

The following objects are set on message body result:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Object type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>in case of single file upload, result
of the upload operation, OK or KO</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>Map&lt;String, DropboxResultCode&gt;</code></p></td>
<td style="text-align: left;"><p>in the case of multiple files upload, a
map with as a key the path of the remote file uploaded and as value the
result of the upload operation, OK or KO</p></td>
</tr>
</tbody>
</table>

# Search operation

Search inside a remote Dropbox folder including its subdirectories.

Works as Camel producer and as Camel consumer.

Below are listed the options for this operation:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Mandatory</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>remotePath</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>Folder on Dropbox where to search
in.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>query</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>A space-separated list of sub-strings
to search for. A file matches only if it contains all the sub-strings.
If this option is not set, all files will be matched. The query is
required to be provided in either the endpoint configuration or as a
header <code>CamelDropboxQuery</code> on the Camel message.</p></td>
</tr>
</tbody>
</table>

## Samples

    from("dropbox://search?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&remotePath=/XXX&query=XXX")
      .to("mock:result");
    
    from("direct:start")
      .setHeader("CamelDropboxQuery", constant("XXX"))
      .to("dropbox://search?accessToken=XXX&clientIdentifier=XXX&expireIn=1000&refreshToken=XXXX"
          +"&apiKey=XXXXX&apiSecret=XXXXXX&remotePath=/XXX")
      .to("mock:result");

## Result Message Body

The following objects are set on message body result:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Object type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>List&lt;com.dropbox.core.v2.files.SearchMatchV2&gt;</code></p></td>
<td style="text-align: left;"><p>list of the file path found. For more
information on this object, refer to <a
href="https://javadoc.io/doc/com.dropbox.core/dropbox-core-sdk/latest/com/dropbox/core/v2/files/SearchMatchV2.html">Dropbox
documentation</a>.</p></td>
</tr>
</tbody>
</table>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|The specific action (typically is a CRUD action) to perform on Dropbox remote folder.||object|
|clientIdentifier|Name of the app registered to make API requests||string|
|query|A space-separated list of sub-strings to search for. A file matches only if it contains all the sub-strings. If this option is not set, all files will be matched.||string|
|remotePath|Original file or folder to move||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|localPath|Optional folder or file to upload on Dropbox from the local filesystem. If this option has not been configured then the message body is used as the content to upload.||string|
|newRemotePath|Destination file or folder||string|
|uploadMode|Which mode to upload. in case of add the new file will be renamed if a file with the same name already exists on dropbox. in case of force if a file with the same name already exists on dropbox, this will be overwritten.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|client|To use an existing DbxClient instance as Dropbox client.||object|
|accessToken|The access token to make API requests for a specific Dropbox user||string|
|apiKey|The apiKey to make API requests for a specific Dropbox user||string|
|apiSecret|The apiSecret to make API requests for a specific Dropbox user||string|
|expireIn|The expire time to access token for a specific Dropbox user||integer|
|refreshToken|The refresh token to refresh the access token for a specific Dropbox user||string|
