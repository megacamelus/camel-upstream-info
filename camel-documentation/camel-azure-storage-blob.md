# Azure-storage-blob

**Since Camel 3.3**

**Both producer and consumer are supported**

The Azure Storage Blob component is used for storing and retrieving
blobs from [Azure Storage
Blob](https://azure.microsoft.com/services/storage/blobs/) Service using
**Azure APIs v12**. However, in the case of versions above v12, we will
see if this component can adopt these changes depending on how much
breaking changes can result.

Prerequisites

You must have a valid Windows Azure Storage account. More information is
available at [Azure Documentation
Portal](https://docs.microsoft.com/azure/).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-azure-storage-blob</artifactId>
        <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

    azure-storage-blob://accountName[/containerName][?options]

In the case of a consumer, `accountName`, `containerName` are required.

In the case of a producer, it depends on the operation that is being
requested, for example, if operation is on a container level, e.b:
createContainer, accountName and containerName are only required, but in
case of operation being requested in blob level, e.g: getBlob,
accountName, containerName and blobName are required.

The blob will be created if it does not already exist. You can append
query options to the URI in the following format,
`?options=value&option2=value&...`

**Required information options:**

To use this component, you have multiple options to provide the required
Azure authentication information:

-   By providing your own
    [BlobServiceClient](https://azuresdkdocs.blob.core.windows.net/$web/java/azure-storage-blob/12.0.0/com/azure/storage/blob/BlobServiceClient.html)
    instance which can be injected into `blobServiceClient`. Note: You
    don’t need to create a specific client, e.g.: BlockBlobClient, the
    BlobServiceClient represents the upper level which can be used to
    retrieve lower level clients.

-   Via Azure Identity, when specifying `credentialType=AZURE_IDENTITY`
    and providing required [environment
    variables](https://github.com/Azure/azure-sdk-for-java/tree/main/sdk/identity/azure-identity#environment-variables).
    This enables service principal (e.g. app registration)
    authentication with secret/certificate as well as username password.
    Note that this is the default authentication strategy.

-   Via shared storage account key, when specifying
    `credentialType=SHARED_ACCOUNT_KEY` and providing `accountName` and
    `accessKey` for your Azure account, this is the simplest way to get
    started. The accessKey can be generated through your Azure portal.

-   Via shared storage account key, when specifying
    `credentialType=SHARED_KEY_CREDENTIAL` and providing a
    [StorageSharedKeyCredential](https://azuresdkartifacts.blob.core.windows.net/azure-sdk-for-java/staging/apidocs/com/azure/storage/common/StorageSharedKeyCredential.html)
    instance which can be injected into `credentials` option.

-   Via Azure SAS, when specifying `credentialType=AZURE_SAS` and
    providing a SAS Token parameter through the `sasToken` parameter.

# Usage

For example, to download a blob content from the block blob `hello.txt`
located on the `container1` in the `camelazure` storage account, use the
following snippet:

    from("azure-storage-blob://camelazure/container1?blobName=hello.txt&credentialType=SHARED_ACCOUNT_KEY&accessKey=RAW(yourAccessKey)").
    to("file://blobdirectory");

## Advanced Azure Storage Blob configuration

If your Camel Application is running behind a firewall or if you need to
have more control over the `BlobServiceClient` instance configuration,
you can create your own instance:

    StorageSharedKeyCredential credential = new StorageSharedKeyCredential("yourAccountName", "yourAccessKey");
    String uri = String.format("https://%s.blob.core.windows.net", "yourAccountName");
    
    BlobServiceClient client = new BlobServiceClientBuilder()
                              .endpoint(uri)
                              .credential(credential)
                              .buildClient();
    // This is camel context
    context.getRegistry().bind("client", client);

Then refer to this instance in your Camel `azure-storage-blob` component
configuration:

    from("azure-storage-blob://cameldev/container1?blobName=myblob&serviceClient=#client")
    .to("mock:result");

## Automatic detection of BlobServiceClient client in registry

The component is capable of detecting the presence of an
BlobServiceClient bean into the registry. If it’s the only instance of
that type, it will be used as the client, and you won’t have to define
it as uri parameter, like the example above. This may be really useful
for smarter configuration of the endpoint.

## Azure Storage Blob Producer operations

Camel Azure Storage Blob component provides a wide range of operations
on the producer side:

**Operations on the service level**

For these operations, `accountName` is **required**.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>listBlobContainers</code></p></td>
<td style="text-align: left;"><p>Get the content of the blob. You can
restrict the output of this operation to a blob range.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getChangeFeed</code></p></td>
<td style="text-align: left;"><p>Returns transaction logs of all the
changes that occur to the blobs and the blob metadata in your storage
account. The change feed provides ordered, guaranteed, durable,
immutable, read-only log of these changes.</p></td>
</tr>
</tbody>
</table>

**Operations on the container level**

For these operations, `accountName` and `containerName` are
**required**.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>createBlobContainer</code></p></td>
<td style="text-align: left;"><p>Create a new container within a storage
account. If a container with the same name already exists, the producer
will ignore it.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>deleteBlobContainer</code></p></td>
<td style="text-align: left;"><p>Delete the specified container in the
storage account. If the container doesn’t exist, the operation
fails.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listBlobs</code></p></td>
<td style="text-align: left;"><p>Returns a list of blobs in this
container, with folder structures flattened.</p></td>
</tr>
</tbody>
</table>

**Operations on the blob level**

For these operations, `accountName`, `containerName` and `blobName` are
**required**.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Blob Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>getBlob</code></p></td>
<td style="text-align: left;"><p>Common</p></td>
<td style="text-align: left;"><p>Get the content of the blob. You can
restrict the output of this operation to a blob range.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>deleteBlob</code></p></td>
<td style="text-align: left;"><p>Common</p></td>
<td style="text-align: left;"><p>Delete a blob.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>downloadBlobToFile</code></p></td>
<td style="text-align: left;"><p>Common</p></td>
<td style="text-align: left;"><p>Download the entire blob into a file
specified by the path. The file will be created and must not exist, if
the file already exists a <code>FileAlreadyExistsException</code> will
be thrown.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>downloadLink</code></p></td>
<td style="text-align: left;"><p>Common</p></td>
<td style="text-align: left;"><p>Generate the download link for the
specified blob using shared access signatures (SAS). This by default
only limits to 1hour of allowed access. However, you can override the
default expiration duration through the headers.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>uploadBlockBlob</code></p></td>
<td style="text-align: left;"><p>BlockBlob</p></td>
<td style="text-align: left;"><p>Creates a new block blob, or updates
the content of an existing block blob. Updating an existing block blob
overwrites any existing metadata on the blob. Partial updates are not
supported with PutBlob; the content of the existing blob is overwritten
with the new content.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>stageBlockBlobList</code></p></td>
<td style="text-align: left;"><p><code>BlockBlob</code></p></td>
<td style="text-align: left;"><p>Uploads the specified block to the
block blob’s "staging area" to be later committed by a call to
commitBlobBlockList. However, in case header
<code>CamelAzureStorageBlobCommitBlobBlockListLater</code> or config
<code>commitBlockListLater</code> is set to false, this will commit the
blocks immediately after staging the blocks.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>commitBlobBlockList</code></p></td>
<td style="text-align: left;"><p><code>BlockBlob</code></p></td>
<td style="text-align: left;"><p>Write a blob by specifying the list of
block IDs that are to make up the blob. To be written as part of a blob,
a block must have been successfully written to the server in a prior
<code>stageBlockBlobList</code> operation. You can call
<code>commitBlobBlockList</code> to update a blob by uploading only
those blocks that have changed, then committing the new and existing
blocks together. Any blocks not specified in the block list and
permanently deleted.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getBlobBlockList</code></p></td>
<td style="text-align: left;"><p><code>BlockBlob</code></p></td>
<td style="text-align: left;"><p>Returns the list of blocks that have
been uploaded as part of a block blob using the specified blocklist
filter.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>createAppendBlob</code></p></td>
<td style="text-align: left;"><p><code>AppendBlob</code></p></td>
<td style="text-align: left;"><p>Creates a 0-length append blob. Call
commitAppendBlo`b operation to append data to an append blob.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>commitAppendBlob</code></p></td>
<td style="text-align: left;"><p><code>AppendBlob</code></p></td>
<td style="text-align: left;"><p>Commits a new block of data to the end
of the existing append blob. In case of header
<code>CamelAzureStorageBlobCreateAppendBlob</code> or config
<code>createAppendBlob</code> is set to true, it will attempt to create
the appendBlob through internal call to <code>createAppendBlob</code>
operation first before committing.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>createPageBlob</code></p></td>
<td style="text-align: left;"><p><code>PageBlob</code></p></td>
<td style="text-align: left;"><p>Creates a page blob of the specified
length. Call <code>uploadPageBlob</code> operation to upload data to a
page blob.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>uploadPageBlob</code></p></td>
<td style="text-align: left;"><p><code>PageBlob</code></p></td>
<td style="text-align: left;"><p>Write one or more pages to the page
blob. The size must be a multiple of 512. In case of header
<code>CamelAzureStorageBlobCreatePageBlob</code> or config
<code>createPageBlob</code> is set to true, it will attempt to create
the appendBlob through internal call to <code>createPageBlob</code>
operation first before uploading.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>resizePageBlob</code></p></td>
<td style="text-align: left;"><p><code>PageBlob</code></p></td>
<td style="text-align: left;"><p>Resizes the page blob to the specified
size, which must be a multiple of 512.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>clearPageBlob</code></p></td>
<td style="text-align: left;"><p><code>PageBlob</code></p></td>
<td style="text-align: left;"><p>Free the specified pages from the page
blob. The size of the range must be a multiple of 512.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getPageBlobRanges</code></p></td>
<td style="text-align: left;"><p><code>PageBlob</code></p></td>
<td style="text-align: left;"><p>Returns the list of valid page ranges
for a page blob or snapshot of a page blob.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>copyBlob</code></p></td>
<td style="text-align: left;"><p><code>Common</code></p></td>
<td style="text-align: left;"><p>Copy a blob from one container to
another one, even from different accounts.</p></td>
</tr>
</tbody>
</table>

Refer to the example section in this page to learn how to use these
operations into your camel application.

## Consumer Examples

To consume a blob into a file using the file component, this can be done
like this:

    from("azure-storage-blob://camelazure/container1?blobName=hello.txt&accountName=yourAccountName&accessKey=yourAccessKey").
    to("file://blobdirectory");

However, you can also write to file directly without using the file
component, you will need to specify `fileDir` folder path to save your
blob in your machine.

    from("azure-storage-blob://camelazure/container1?blobName=hello.txt&accountName=yourAccountName&accessKey=yourAccessKey&fileDir=/var/to/awesome/dir").
    to("mock:results");

Also, the component supports batch consumer, hence you can consume
multiple blobs with only specifying the container name, the consumer
will return multiple exchanges depending on the number of the blobs in
the container. Example:

    from("azure-storage-blob://camelazure/container1?accountName=yourAccountName&accessKey=yourAccessKey&fileDir=/var/to/awesome/dir").
    to("mock:results");

## Producer Operations Examples

-   `listBlobContainers`:

<!-- -->

    from("direct:start")
      .process(exchange -> {
        // set the header you want the producer to evaluate, refer to the previous
        // section to learn about the headers that can be set
        // e.g.:
        exchange.getIn().setHeader(BlobConstants.LIST_BLOB_CONTAINERS_OPTIONS, new ListBlobContainersOptions().setMaxResultsPerPage(10));
      })
      .to("azure-storage-blob://camelazure?operation=listBlobContainers&client&serviceClient=#client")
      .to("mock:result");

-   `createBlobContainer`:

<!-- -->

    from("direct:start")
      .process(exchange -> {
        // set the header you want the producer to evaluate, refer to the previous
        // section to learn about the headers that can be set
        // e.g.:
        exchange.getIn().setHeader(BlobConstants.BLOB_CONTAINER_NAME, "newContainerName");
      })
      .to("azure-storage-blob://camelazure/container1?operation=createBlobContainer&serviceClient=#client")
      .to("mock:result");

-   `deleteBlobContainer`:

<!-- -->

    from("direct:start")
      .process(exchange -> {
        // set the header you want the producer to evaluate, refer to the previous
        // section to learn about the headers that can be set
        // e.g.:
        exchange.getIn().setHeader(BlobConstants.BLOB_CONTAINER_NAME, "overridenName");
      })
      .to("azure-storage-blob://camelazure/container1?operation=deleteBlobContainer&serviceClient=#client")
      .to("mock:result");

-   `listBlobs`:

<!-- -->

    from("direct:start")
      .process(exchange -> {
        // set the header you want the producer to evaluate, refer to the previous
        // section to learn about the headers that can be set
        // e.g.:
        exchange.getIn().setHeader(BlobConstants.BLOB_CONTAINER_NAME, "overridenName");
      })
      .to("azure-storage-blob://camelazure/container1?operation=listBlobs&serviceClient=#client")
      .to("mock:result");

-   `getBlob`:

We can either set an `outputStream` in the exchange body and write the
data to it. E.g.:

    from("direct:start")
      .process(exchange -> {
        // set the header you want the producer to evaluate, refer to the previous
        // section to learn about the headers that can be set
        // e.g.:
        exchange.getIn().setHeader(BlobConstants.BLOB_CONTAINER_NAME, "overridenName");
    
        // set our body
        exchange.getIn().setBody(outputStream);
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=getBlob&serviceClient=#client")
      .to("mock:result");

If we don’t set a body, then this operation will give us an
`InputStream` instance which can proceeded further downstream:

    from("direct:start")
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=getBlob&serviceClient=#client")
      .process(exchange -> {
          InputStream inputStream = exchange.getMessage().getBody(InputStream.class);
          // We use Apache common IO for simplicity, but you are free to do whatever dealing
          // with inputStream
          System.out.println(IOUtils.toString(inputStream, StandardCharsets.UTF_8.name()));
      })
      .to("mock:result");

-   `deleteBlob`:

<!-- -->

    from("direct:start")
      .process(exchange -> {
        // set the header you want the producer to evaluate, refer to the previous
        // section to learn about the headers that can be set
        // e.g.:
        exchange.getIn().setHeader(BlobConstants.BLOB_NAME, "overridenName");
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=deleteBlob&serviceClient=#client")
      .to("mock:result");

-   `downloadBlobToFile`:

<!-- -->

    from("direct:start")
      .process(exchange -> {
        // set the header you want the producer to evaluate, refer to the previous
        // section to learn about the headers that can be set
        // e.g.:
        exchange.getIn().setHeader(BlobConstants.BLOB_NAME, "overridenName");
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=downloadBlobToFile&fileDir=/var/mydir&serviceClient=#client")
      .to("mock:result");

-   `downloadLink`

<!-- -->

    from("direct:start")
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=downloadLink&serviceClient=#client")
      .process(exchange -> {
          String link = exchange.getMessage().getHeader(BlobConstants.DOWNLOAD_LINK, String.class);
          System.out.println("My link " + link);
      })
      .to("mock:result");

-   `uploadBlockBlob`

<!-- -->

    from("direct:start")
      .process(exchange -> {
        // set the header you want the producer to evaluate, refer to the previous
        // section to learn about the headers that can be set
        // e.g.:
        exchange.getIn().setHeader(BlobConstants.BLOB_NAME, "overridenName");
        exchange.getIn().setBody("Block Blob");
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=uploadBlockBlob&serviceClient=#client")
      .to("mock:result");

-   `stageBlockBlobList`

<!-- -->

    from("direct:start")
      .process(exchange -> {
          final List<BlobBlock> blocks = new LinkedList<>();
          blocks.add(BlobBlock.createBlobBlock(new ByteArrayInputStream("Hello".getBytes())));
          blocks.add(BlobBlock.createBlobBlock(new ByteArrayInputStream("From".getBytes())));
          blocks.add(BlobBlock.createBlobBlock(new ByteArrayInputStream("Camel".getBytes())));
    
          exchange.getIn().setBody(blocks);
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=stageBlockBlobList&serviceClient=#client")
      .to("mock:result");

-   `commitBlockBlobList`

<!-- -->

    from("direct:start")
      .process(exchange -> {
          // We assume here you have the knowledge of these blocks you want to commit
          final List<Block> blockIds = new LinkedList<>();
          blockIds.add(new Block().setName("id-1"));
          blockIds.add(new Block().setName("id-2"));
          blockIds.add(new Block().setName("id-3"));
    
          exchange.getIn().setBody(blockIds);
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=commitBlockBlobList&serviceClient=#client")
      .to("mock:result");

-   `getBlobBlockList`

<!-- -->

    from("direct:start")
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=getBlobBlockList&serviceClient=#client")
      .log("${body}")
      .to("mock:result");

-   `createAppendBlob`

<!-- -->

    from("direct:start")
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=createAppendBlob&serviceClient=#client")
      .to("mock:result");

-   `commitAppendBlob`

<!-- -->

    from("direct:start")
      .process(exchange -> {
        final String data = "Hello world from my awesome tests!";
        final InputStream dataStream = new ByteArrayInputStream(data.getBytes(StandardCharsets.UTF_8));
    
        exchange.getIn().setBody(dataStream);
    
        // of course, you can set whatever headers you like, refer to the headers section to learn more
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=commitAppendBlob&serviceClient=#client")
      .to("mock:result");

-   `createPageBlob`

<!-- -->

    from("direct:start")
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=createPageBlob&serviceClient=#client")
      .to("mock:result");

-   `uploadPageBlob`

<!-- -->

    from("direct:start")
      .process(exchange -> {
        byte[] dataBytes = new byte[512]; // we set range for the page from 0-511
        new Random().nextBytes(dataBytes);
        final InputStream dataStream = new ByteArrayInputStream(dataBytes);
        final PageRange pageRange = new PageRange().setStart(0).setEnd(511);
    
        exchange.getIn().setHeader(BlobConstants.PAGE_BLOB_RANGE, pageRange);
        exchange.getIn().setBody(dataStream);
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=uploadPageBlob&serviceClient=#client")
      .to("mock:result");

-   `resizePageBlob`

<!-- -->

    from("direct:start")
      .process(exchange -> {
        final PageRange pageRange = new PageRange().setStart(0).setEnd(511);
    
        exchange.getIn().setHeader(BlobConstants.PAGE_BLOB_RANGE, pageRange);
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=resizePageBlob&serviceClient=#client")
      .to("mock:result");

-   `clearPageBlob`

<!-- -->

    from("direct:start")
      .process(exchange -> {
        final PageRange pageRange = new PageRange().setStart(0).setEnd(511);
    
        exchange.getIn().setHeader(BlobConstants.PAGE_BLOB_RANGE, pageRange);
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=clearPageBlob&serviceClient=#client")
      .to("mock:result");

-   `getPageBlobRanges`

<!-- -->

    from("direct:start")
      .process(exchange -> {
        final PageRange pageRange = new PageRange().setStart(0).setEnd(511);
    
        exchange.getIn().setHeader(BlobConstants.PAGE_BLOB_RANGE, pageRange);
      })
      .to("azure-storage-blob://camelazure/container1?blobName=blob&operation=getPageBlobRanges&serviceClient=#client")
      .log("${body}")
      .to("mock:result");

-   `copyBlob`

<!-- -->

    from("direct:copyBlob")
      .process(exchange -> {
        exchange.getIn().setHeader(BlobConstants.BLOB_NAME, "file.txt");
        exchange.getMessage().setHeader(BlobConstants.SOURCE_BLOB_CONTAINER_NAME, "containerblob1");
        exchange.getMessage().setHeader(BlobConstants.SOURCE_BLOB_ACCOUNT_NAME, "account");
      })
      .to("azure-storage-blob://account/containerblob2?operation=copyBlob&sourceBlobAccessKey=RAW(accessKey)")
      .to("mock:result");

In this way the `file.txt` in the container `containerblob1` of the
account `account`, will be copied to the container `containerblob2` of
the same account.

## SAS Token generation example

SAS Blob Container tokens can be generated programmatically or via Azure
UI. To generate the token with java code, the following can be done:

    BlobContainerClient blobClient = new BlobContainerClientBuilder()
                .endpoint(String.format("https://%s.blob.core.windows.net/%s", accountName, accessKey))
                .containerName(containerName)
                .credential(new StorageSharedKeyCredential(accountName, accessKey))
                .buildClient();
    
            // Create a SAS token that's valid for 1 day, as an example
            OffsetDateTime expiryTime = OffsetDateTime.now().plusDays(1);
    
            // Assign permissions to the SAS token
            BlobContainerSasPermission blobContainerSasPermission = new BlobContainerSasPermission()
                .setWritePermission(true)
                .setListPermission(true)
                .setCreatePermission(true)
                .setDeletePermission(true)
                .setAddPermission(true)
                .setReadPermission(true);
    
            BlobServiceSasSignatureValues sasSignatureValues = new BlobServiceSasSignatureValues(expiryTime, blobContainerSasPermission);
    
            return blobClient.generateSas(sasSignatureValues);

The generated SAS token can be then stored to an application.properties
file so that it can be loaded by the camel route, for example:

    camel.component.azure-storage-blob.sas-token=MY_TOKEN_HERE
    
    from("direct:copyBlob")
      .to("azure-storage-blob://account/containerblob2?operation=uploadBlockBlob&credentialType=AZURE_SAS")

## Development Notes (Important)

All integration tests use
[Testcontainers](https://www.testcontainers.org/) and run by default.
Obtaining of Azure accessKey and accountName is needed to be able to run
all integration tests using Azure services. In addition to the mocked
unit tests, you **will need to run the integration tests with every
change you make or even client upgrade as the Azure client can break
things even on minor versions upgrade.** To run the integration tests,
on this component directory, run the following maven command:

    mvn verify -DaccountName=myacc -DaccessKey=mykey -DcredentialType=SHARED_ACCOUNT_KEY

Whereby `accountName` is your Azure account name and `accessKey` is the
access key being generated from Azure portal.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|blobName|The blob name, to consume specific blob from a container. However, on producer it is only required for the operations on the blob level||string|
|blobOffset|Set the blob offset for the upload or download operations, default is 0|0|integer|
|blobType|The blob type in order to initiate the appropriate settings for each blob type|blockblob|object|
|closeStreamAfterRead|Close the stream after read or keep it open, default is true|true|boolean|
|configuration|The component configurations||object|
|credentials|StorageSharedKeyCredential can be injected to create the azure client, this holds the important authentication information||object|
|credentialType|Determines the credential strategy to adopt|AZURE\_IDENTITY|object|
|dataCount|How many bytes to include in the range. Must be greater than or equal to 0 if specified.||integer|
|fileDir|The file directory where the downloaded blobs will be saved to, this can be used in both, producer and consumer||string|
|maxResultsPerPage|Specifies the maximum number of blobs to return, including all BlobPrefix elements. If the request does not specify maxResultsPerPage or specifies a value greater than 5,000, the server will return up to 5,000 items.||integer|
|maxRetryRequests|Specifies the maximum number of additional HTTP Get requests that will be made while reading the data from a response body.|0|integer|
|prefix|Filters the results to return only blobs whose names begin with the specified prefix. May be null to return all blobs.||string|
|regex|Filters the results to return only blobs whose names match the specified regular expression. May be null to return all if both prefix and regex are set, regex takes the priority and prefix is ignored.||string|
|sasToken|In case of usage of Shared Access Signature we'll need to set a SAS Token||string|
|serviceClient|Client to a storage account. This client does not hold any state about a particular storage account but is instead a convenient way of sending off appropriate requests to the resource on the service. It may also be used to construct URLs to blobs and containers. This client contains operations on a service account. Operations on a container are available on BlobContainerClient through BlobServiceClient#getBlobContainerClient(String), and operations on a blob are available on BlobClient through BlobContainerClient#getBlobClient(String).||object|
|timeout|An optional timeout value beyond which a RuntimeException will be raised.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|blobSequenceNumber|A user-controlled value that you can use to track requests. The value of the sequence number must be between 0 and 263 - 1.The default value is 0.|0|integer|
|blockListType|Specifies which type of blocks to return.|COMMITTED|object|
|changeFeedContext|When using getChangeFeed producer operation, this gives additional context that is passed through the Http pipeline during the service call.||object|
|changeFeedEndTime|When using getChangeFeed producer operation, this filters the results to return events approximately before the end time. Note: A few events belonging to the next hour can also be returned. A few events belonging to this hour can be missing; to ensure all events from the hour are returned, round the end time up by an hour.||object|
|changeFeedStartTime|When using getChangeFeed producer operation, this filters the results to return events approximately after the start time. Note: A few events belonging to the previous hour can also be returned. A few events belonging to this hour can be missing; to ensure all events from the hour are returned, round the start time down by an hour.||object|
|closeStreamAfterWrite|Close the stream after write or keep it open, default is true|true|boolean|
|commitBlockListLater|When is set to true, the staged blocks will not be committed directly.|true|boolean|
|createAppendBlob|When is set to true, the append blocks will be created when committing append blocks.|true|boolean|
|createPageBlob|When is set to true, the page blob will be created when uploading page blob.|true|boolean|
|downloadLinkExpiration|Override the default expiration (millis) of URL download link.||integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|The blob operation that can be used with this component on the producer|listBlobContainers|object|
|pageBlobSize|Specifies the maximum size for the page blob, up to 8 TB. The page blob size must be aligned to a 512-byte boundary.|512|integer|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|accessKey|Access key for the associated azure account name to be used for authentication with azure blob services||string|
|sourceBlobAccessKey|Source Blob Access Key: for copyblob operation, sadly, we need to have an accessKey for the source blob we want to copy Passing an accessKey as header, it's unsafe so we could set as key.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|accountName|Azure account name to be used for authentication with azure blob services||string|
|containerName|The blob container name||string|
|blobName|The blob name, to consume specific blob from a container. However, on producer it is only required for the operations on the blob level||string|
|blobOffset|Set the blob offset for the upload or download operations, default is 0|0|integer|
|blobServiceClient|Client to a storage account. This client does not hold any state about a particular storage account but is instead a convenient way of sending off appropriate requests to the resource on the service. It may also be used to construct URLs to blobs and containers. This client contains operations on a service account. Operations on a container are available on BlobContainerClient through getBlobContainerClient(String), and operations on a blob are available on BlobClient through getBlobContainerClient(String).getBlobClient(String).||object|
|blobType|The blob type in order to initiate the appropriate settings for each blob type|blockblob|object|
|closeStreamAfterRead|Close the stream after read or keep it open, default is true|true|boolean|
|credentials|StorageSharedKeyCredential can be injected to create the azure client, this holds the important authentication information||object|
|credentialType|Determines the credential strategy to adopt|AZURE\_IDENTITY|object|
|dataCount|How many bytes to include in the range. Must be greater than or equal to 0 if specified.||integer|
|fileDir|The file directory where the downloaded blobs will be saved to, this can be used in both, producer and consumer||string|
|maxResultsPerPage|Specifies the maximum number of blobs to return, including all BlobPrefix elements. If the request does not specify maxResultsPerPage or specifies a value greater than 5,000, the server will return up to 5,000 items.||integer|
|maxRetryRequests|Specifies the maximum number of additional HTTP Get requests that will be made while reading the data from a response body.|0|integer|
|prefix|Filters the results to return only blobs whose names begin with the specified prefix. May be null to return all blobs.||string|
|regex|Filters the results to return only blobs whose names match the specified regular expression. May be null to return all if both prefix and regex are set, regex takes the priority and prefix is ignored.||string|
|sasToken|In case of usage of Shared Access Signature we'll need to set a SAS Token||string|
|serviceClient|Client to a storage account. This client does not hold any state about a particular storage account but is instead a convenient way of sending off appropriate requests to the resource on the service. It may also be used to construct URLs to blobs and containers. This client contains operations on a service account. Operations on a container are available on BlobContainerClient through BlobServiceClient#getBlobContainerClient(String), and operations on a blob are available on BlobClient through BlobContainerClient#getBlobClient(String).||object|
|timeout|An optional timeout value beyond which a RuntimeException will be raised.||object|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|blobSequenceNumber|A user-controlled value that you can use to track requests. The value of the sequence number must be between 0 and 263 - 1.The default value is 0.|0|integer|
|blockListType|Specifies which type of blocks to return.|COMMITTED|object|
|changeFeedContext|When using getChangeFeed producer operation, this gives additional context that is passed through the Http pipeline during the service call.||object|
|changeFeedEndTime|When using getChangeFeed producer operation, this filters the results to return events approximately before the end time. Note: A few events belonging to the next hour can also be returned. A few events belonging to this hour can be missing; to ensure all events from the hour are returned, round the end time up by an hour.||object|
|changeFeedStartTime|When using getChangeFeed producer operation, this filters the results to return events approximately after the start time. Note: A few events belonging to the previous hour can also be returned. A few events belonging to this hour can be missing; to ensure all events from the hour are returned, round the start time down by an hour.||object|
|closeStreamAfterWrite|Close the stream after write or keep it open, default is true|true|boolean|
|commitBlockListLater|When is set to true, the staged blocks will not be committed directly.|true|boolean|
|createAppendBlob|When is set to true, the append blocks will be created when committing append blocks.|true|boolean|
|createPageBlob|When is set to true, the page blob will be created when uploading page blob.|true|boolean|
|downloadLinkExpiration|Override the default expiration (millis) of URL download link.||integer|
|operation|The blob operation that can be used with this component on the producer|listBlobContainers|object|
|pageBlobSize|Specifies the maximum size for the page blob, up to 8 TB. The page blob size must be aligned to a 512-byte boundary.|512|integer|
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
|accessKey|Access key for the associated azure account name to be used for authentication with azure blob services||string|
|sourceBlobAccessKey|Source Blob Access Key: for copyblob operation, sadly, we need to have an accessKey for the source blob we want to copy Passing an accessKey as header, it's unsafe so we could set as key.||string|
