# Aws2-s3

**Since Camel 3.2**

**Both producer and consumer are supported**

The AWS2 S3 component supports storing and retrieving objects from/to
[Amazon’s S3](https://aws.amazon.com/s3) service.

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon S3. More information is available at [Amazon
S3](https://aws.amazon.com/s3).

# URI Format

    aws2-s3://bucketNameOrArn[?options]

The bucket will be created if it doesn’t already exist.

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

Required S3 component options

You have to provide the amazonS3Client in the Registry or your accessKey
and secretKey to access the [Amazon’s S3](https://aws.amazon.com/s3).

# Usage

## Batch Consumer

This component implements the Batch Consumer.

This allows you, for instance, to know how many messages exist in this
batch and for instance, let the Aggregator aggregate this number of
messages.

## S3 Producer operations

Camel-AWS2-S3 component provides the following operation on the producer
side:

-   copyObject

-   deleteObject

-   listBuckets

-   deleteBucket

-   listObjects

-   getObject (this will return an S3Object instance)

-   getObjectRange (this will return an S3Object instance)

-   createDownloadLink

If you don’t specify an operation, explicitly the producer will do:

-   a single file upload

-   a multipart upload if multiPartUpload option is enabled

# Examples

For example, to read file `hello.txt` from bucket `helloBucket`, use the
following snippet:

    from("aws2-s3://helloBucket?accessKey=yourAccessKey&secretKey=yourSecretKey&prefix=hello.txt")
      .to("file:/var/downloaded");

## Advanced AmazonS3 configuration

If your Camel Application is running behind a firewall or if you need to
have more control over the `S3Client` instance configuration, you can
create your own instance and refer to it in your Camel aws2-s3 component
configuration:

    from("aws2-s3://MyBucket?amazonS3Client=#client&delay=5000&maxMessagesPerPoll=5")
    .to("mock:result");

## Use KMS with the S3 component

To use AWS KMS to encrypt/decrypt data by using AWS infrastructure, you
can use the options introduced in 2.21.x like in the following example

    from("file:tmp/test?fileName=test.txt")
         .setHeader(AWS2S3Constants.KEY, constant("testFile"))
         .to("aws2-s3://mybucket?amazonS3Client=#client&useAwsKMS=true&awsKMSKeyId=3f0637ad-296a-3dfe-a796-e60654fb128c");

In this way, you’ll ask S3 to use the KMS key
3f0637ad-296a-3dfe-a796-e60654fb128c, to encrypt the file test.txt. When
you ask to download this file, the decryption will be done directly
before the download.

## Static credentials, Default Credential Provider and Profile Credentials Provider

You have the possibility of avoiding the usage of explicit static
credentials by specifying the useDefaultCredentialsProvider option and
set it to true.

The order of evaluation for Default Credentials Provider is the
following:

-   Java system properties - `aws.accessKeyId` and `aws.secretKey`.

-   Environment variables - `AWS_ACCESS_KEY_ID` and
    `AWS_SECRET_ACCESS_KEY`.

-   Web Identity Token from AWS STS.

-   The shared credentials and config files.

-   Amazon ECS container credentials - loaded from the Amazon ECS if the
    environment variable `AWS_CONTAINER_CREDENTIALS_RELATIVE_URI` is
    set.

-   Amazon EC2 Instance profile credentials.

You have also the possibility of using Profile Credentials Provider, by
specifying the useProfileCredentialsProvider option to true and
profileCredentialsName to the profile name.

Only one of static, default and profile credentials could be used at the
same time.

For more information about this you can look at [AWS credentials
documentation](https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/credentials.html)

## S3 Producer Operation examples

-   Single Upload: This operation will upload a file to S3 based on the
    body content

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(AWS2S3Constants.KEY, "camel.txt");
              exchange.getIn().setBody("Camel rocks!");
          }
      })
      .to("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client")
      .to("mock:result");

This operation will upload the file camel.txt with the content "Camel
rocks!" in the *mycamelbucket* bucket

-   Multipart Upload: This operation will perform a multipart upload of
    a file to S3 based on the body content

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(AWS2S3Constants.KEY, "empty.txt");
              exchange.getIn().setBody(new File("src/empty.txt"));
          }
      })
      .to("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client&multiPartUpload=true&autoCreateBucket=true&partSize=1048576")
      .to("mock:result");

This operation will perform a multipart upload of the file empty.txt
with based on the content the file src/empty.txt in the *mycamelbucket*
bucket

-   CopyObject: this operation copies an object from one bucket to a
    different one

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(AWS2S3Constants.BUCKET_DESTINATION_NAME, "camelDestinationBucket");
              exchange.getIn().setHeader(AWS2S3Constants.KEY, "camelKey");
              exchange.getIn().setHeader(AWS2S3Constants.DESTINATION_KEY, "camelDestinationKey");
          }
      })
      .to("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client&operation=copyObject")
      .to("mock:result");

This operation will copy the object with the name expressed in the
header camelDestinationKey to the camelDestinationBucket bucket, from
the bucket *mycamelbucket*.

-   DeleteObject: this operation deletes an object from a bucket

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(AWS2S3Constants.KEY, "camelKey");
          }
      })
      .to("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client&operation=deleteObject")
      .to("mock:result");

This operation will delete the object camelKey from the bucket
*mycamelbucket*.

-   ListBuckets: this operation lists the buckets for this account in
    this region

<!-- -->

      from("direct:start")
      .to("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client&operation=listBuckets")
      .to("mock:result");

This operation will list the buckets for this account

-   DeleteBucket: this operation deletes the bucket specified as URI
    parameter or header

<!-- -->

      from("direct:start")
      .to("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client&operation=deleteBucket")
      .to("mock:result");

This operation will delete the bucket *mycamelbucket*

-   ListObjects: this operation list object in a specific bucket

<!-- -->

      from("direct:start")
      .to("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client&operation=listObjects")
      .to("mock:result");

This operation will list the objects in the *mycamelbucket* bucket

-   GetObject: this operation gets a single object in a specific bucket

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(AWS2S3Constants.KEY, "camelKey");
          }
      })
      .to("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client&operation=getObject")
      .to("mock:result");

This operation will return an S3Object instance related to the camelKey
object in *mycamelbucket* bucket.

-   GetObjectRange: this operation gets a single object range in a
    specific bucket

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(AWS2S3Constants.KEY, "camelKey");
              exchange.getIn().setHeader(AWS2S3Constants.RANGE_START, "0");
              exchange.getIn().setHeader(AWS2S3Constants.RANGE_END, "9");
          }
      })
      .to("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client&operation=getObjectRange")
      .to("mock:result");

This operation will return an S3Object instance related to the camelKey
object in *mycamelbucket* bucket, containing the bytes from 0 to 9.

-   CreateDownloadLink: this operation will return a download link
    through S3 Presigner

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(AWS2S3Constants.KEY, "camelKey");
          }
      })
      .to("aws2-s3://mycamelbucket?accessKey=xxx&secretKey=yyy&region=region&operation=createDownloadLink")
      .to("mock:result");

This operation will return a download link url for the file camel-key in
the bucket *mycamelbucket* and region *region*. Parameters (`accessKey`,
`secretKey` and `region`) are mandatory for this operation, if S3 client
is autowired from the registry.

If checksum validations are enabled, the url will no longer be browser
compatible because it adds a signed header that must be included in the
HTTP request.

## AWS S3 Producer minimum permissions

For making the producer work, you’ll need at least PutObject and
ListBuckets permissions. The following policy will be enough:

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "s3:PutObject",
                "Resource": "arn:aws:s3:::*/*"
            },
            {
                "Effect": "Allow",
                "Action": "s3:ListBucket",
                "Resource": "arn:aws:s3:::*"
            }
        ]
    }

A variation to the minimum permissions is related to the usage of Bucket
autocreation. In that case the permissions will need to be increased
with CreateBucket permission

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "s3:PutObject",
                "Resource": "arn:aws:s3:::*/*"
            },
            {
                "Effect": "Allow",
                "Action": "s3:ListBucket",
                "Resource": "arn:aws:s3:::*"
            },
            {
                "Effect": "Allow",
                "Action": "s3:CreateBucket",
                "Resource": "arn:aws:s3:::*"
            }
        ]
    }

## AWS S3 Consumer minimum permissions

For making the producer work, you’ll need at least GetObject,
ListBuckets and DeleteObject permissions. The following policy will be
enough:

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "s3:ListBucket",
                "Resource": "arn:aws:s3:::*"
            },
            {
                "Effect": "Allow",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::*/*"
            },
            {
                "Effect": "Allow",
                "Action": "s3:DeleteObject",
                "Resource": "arn:aws:s3:::*/*"
            }
        ]
    }

By Default the consumer will use the deleteAfterRead option, this means
the object will be deleted once consumed, this is why the DeleteObject
permission is required.

## Streaming Upload mode

With the stream mode enabled, users will be able to upload data to S3
without knowing ahead of time the dimension of the data, by leveraging
multipart upload. The upload will be completed when the batchSize has
been completed or the batchMessageNumber has been reached. There are two
possible naming strategies: progressive and random. With the progressive
strategy, each file will have the name composed by keyName option and a
progressive counter, and eventually the file extension (if any), while
with the random strategy a UUID will be added after keyName and
eventually the file extension will be appended.

As an example:

    from(kafka("topic1").brokers("localhost:9092"))
            .log("Kafka Message is: ${body}")
            .to(aws2S3("camel-bucket").streamingUploadMode(true).batchMessageNumber(25).namingStrategy(AWS2S3EndpointBuilderFactory.AWSS3NamingStrategyEnum.progressive).keyName("{{kafkaTopic1}}/{{kafkaTopic1}}.txt"));
    
    from(kafka("topic2").brokers("localhost:9092"))
             .log("Kafka Message is: ${body}")
             .to(aws2S3("camel-bucket").streamingUploadMode(true).batchMessageNumber(25).namingStrategy(AWS2S3EndpointBuilderFactory.AWSS3NamingStrategyEnum.random).keyName("{{kafkaTopic2}}/{{kafkaTopic2}}.txt"));

The default size for a batch is 1 Mb, but you can adjust it according to
your requirements.

When you stop your producer route, the producer will take care of
flushing the remaining buffered message and complete the upload.

In Streaming upload, you’ll be able to restart the producer from the
point where it left. It’s important to note that this feature is
critical only when using the progressive naming strategy.

By setting the restartingPolicy to lastPart, you will restart uploading
files and contents from the last part number the producer left.

As example: - Start the route with progressive naming strategy and
keyname equals to camel.txt, with batchMessageNumber equals to 20, and
restartingPolicy equals to lastPart - Send 70 messages. - Stop the
route - On your S3 bucket you should now see four files: camel.txt,
camel-1.txt, camel-2.txt and camel-3.txt, the first three will have 20
messages, while the last one is only 10. - Restart the route - Send 25
messages - Stop the route - You’ll now have two other files in your
bucket: camel-5.txt and camel-6.txt, the first with 20 messages and the
second with 5 messages. - Go ahead

This won’t be needed when using the random naming strategy.

On the opposite, you can specify the override restartingPolicy. In that
case, you’ll be able to override whatever you written before (for that
particular keyName) in your bucket.

In Streaming upload mode, the only keyName option that will be taken
into account is the endpoint option. Using the header will throw an NPE
and this is done by design. Setting the header means potentially change
the file name on each exchange, and this is against the aim of the
streaming upload producer. The keyName needs to be fixed and static. The
selected naming strategy will do the rest of the work.

Another possibility is specifying a streamingUploadTimeout with
batchMessageNumber and batchSize options. With this option, the user
will be able to complete the upload of a file after a certain time
passed. In this way, the upload completion will be passed on three
tiers: the timeout, the number of messages and the batch size.

As an example:

    from(kafka("topic1").brokers("localhost:9092"))
            .log("Kafka Message is: ${body}")
            .to(aws2S3("camel-bucket").streamingUploadMode(true).batchMessageNumber(25).streamingUploadTimeout(10000).namingStrategy(AWS2S3EndpointBuilderFactory.AWSS3NamingStrategyEnum.progressive).keyName("{{kafkaTopic1}}/{{kafkaTopic1}}.txt"));

In this case, the upload will be completed after 10 seconds.

## Bucket Auto-creation

With the option `autoCreateBucket` users are able to avoid the
auto-creation of an S3 Bucket in case it doesn’t exist. The default for
this option is `false`. If set to false, any operation on a not-existent
bucket in AWS won’t be successful and an error will be returned.

## Moving stuff between a bucket and another bucket

Some users like to consume stuff from a bucket and move the content in a
different one without using the copyObject feature of this component. If
this is case for you, remember to remove the bucketName header from the
incoming exchange of the consumer, otherwise the file will always be
overwritten on the same original bucket.

## MoveAfterRead consumer option

In addition to deleteAfterRead, it has been added another option,
moveAfterRead. With this option enabled, the consumed object will be
moved to a target destinationBucket instead of being only deleted. This
will require specifying the destinationBucket option. As example:

      from("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client&moveAfterRead=true&destinationBucket=myothercamelbucket")
      .to("mock:result");

In this case, the objects consumed will be moved to *myothercamelbucket*
bucket and deleted from the original one (because of deleteAfterRead set
to true as default).

You have also the possibility of using a key prefix/suffix while moving
the file to a different bucket. The options are destinationBucketPrefix
and destinationBucketSuffix.

Taking the above example, you could do something like:

      from("aws2-s3://mycamelbucket?amazonS3Client=#amazonS3Client&moveAfterRead=true&destinationBucket=myothercamelbucket&destinationBucketPrefix=RAW(pre-)&destinationBucketSuffix=RAW(-suff)")
      .to("mock:result");

In this case, the objects consumed will be moved to *myothercamelbucket*
bucket and deleted from the original one (because of deleteAfterRead set
to true as default).

So if the file name is test, in the *myothercamelbucket* you should see
a file called pre-test-suff.

## Using the customer key as encryption

We introduced also the customer key support (an alternative of using
KMS). The following code shows an example.

    String key = UUID.randomUUID().toString();
    byte[] secretKey = generateSecretKey();
    String b64Key = Base64.getEncoder().encodeToString(secretKey);
    String b64KeyMd5 = Md5Utils.md5AsBase64(secretKey);
    
    String awsEndpoint = "aws2-s3://mycamel?autoCreateBucket=false&useCustomerKey=true&customerKeyId=RAW(" + b64Key + ")&customerKeyMD5=RAW(" + b64KeyMd5 + ")&customerAlgorithm=" + AES256.name();
    
    from("direct:putObject")
        .setHeader(AWS2S3Constants.KEY, constant("test.txt"))
        .setBody(constant("Test"))
        .to(awsEndpoint);

## Using a POJO as body

Sometimes building an AWS Request can be complex because of multiple
options. We introduce the possibility to use a POJO as the body. In AWS
S3 there are multiple operations you can submit, as an example for List
brokers request, you can do something like:

    from("direct:aws2-s3")
         .setBody(ListObjectsRequest.builder().bucket(bucketName).build())
         .to("aws2-s3://test?amazonS3Client=#amazonS3Client&operation=listObjects&pojoRequest=true")

In this way, you’ll pass the request directly without the need of
passing headers and options specifically related to this operation.

## Create S3 client and add component to registry

Sometimes you would want to perform some advanced configuration using
AWS2S3Configuration, which also allows to set the S3 client. You can
create and set the S3 client in the component configuration as shown in
the following example

    String awsBucketAccessKey = "your_access_key";
    String awsBucketSecretKey = "your_secret_key";
    
    S3Client s3Client = S3Client.builder().credentialsProvider(StaticCredentialsProvider.create(AwsBasicCredentials.create(awsBucketAccessKey, awsBucketSecretKey)))
                    .region(Region.US_EAST_1).build();
    
    AWS2S3Configuration configuration = new AWS2S3Configuration();
    configuration.setAmazonS3Client(s3Client);
    configuration.setAutoDiscoverClient(true);
    configuration.setBucketName("s3bucket2020");
    configuration.setRegion("us-east-1");

Now you can configure the S3 component (using the configuration object
created above) and add it to the registry in the configure method before
initialization of routes.

    AWS2S3Component s3Component = new AWS2S3Component(getContext());
    s3Component.setConfiguration(configuration);
    s3Component.setLazyStartProducer(true);
    camelContext.addComponent("aws2-s3", s3Component);

Now your component will be used for all the operations implemented in
camel routes.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-s3</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|autoCreateBucket|Setting the autocreation of the S3 bucket bucketName. This will apply also in case of moveAfterRead option enabled, and it will create the destinationBucket if it doesn't exist already.|false|boolean|
|configuration|The component configuration||object|
|delimiter|The delimiter which is used in the com.amazonaws.services.s3.model.ListObjectsRequest to only consume objects we are interested in.||string|
|forcePathStyle|Set whether the S3 client should use path-style URL instead of virtual-hosted-style|false|boolean|
|ignoreBody|If it is true, the S3 Object Body will be ignored completely if it is set to false, the S3 Object will be put in the body. Setting this to true will override any behavior defined by includeBody option.|false|boolean|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|policy|The policy for this queue to set in the com.amazonaws.services.s3.AmazonS3#setBucketPolicy() method.||string|
|prefix|The prefix which is used in the com.amazonaws.services.s3.model.ListObjectsRequest to only consume objects we are interested in.||string|
|region|The region in which the S3 client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|customerAlgorithm|Define the customer algorithm to use in case CustomerKey is enabled||string|
|customerKeyId|Define the id of the Customer key to use in case CustomerKey is enabled||string|
|customerKeyMD5|Define the MD5 of Customer key to use in case CustomerKey is enabled||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|deleteAfterRead|Delete objects from S3 after they have been retrieved. The deleting is only performed if the Exchange is committed. If a rollback occurs, the object is not deleted. If this option is false, then the same objects will be retrieved over and over again in the polls. Therefore, you need to use the Idempotent Consumer EIP in the route to filter out duplicates. You can filter using the AWS2S3Constants#BUCKET\_NAME and AWS2S3Constants#KEY headers, or only the AWS2S3Constants#KEY header.|true|boolean|
|destinationBucket|Define the destination bucket where an object must be moved when moveAfterRead is set to true.||string|
|destinationBucketPrefix|Define the destination bucket prefix to use when an object must be moved, and moveAfterRead is set to true.||string|
|destinationBucketSuffix|Define the destination bucket suffix to use when an object must be moved, and moveAfterRead is set to true.||string|
|doneFileName|If provided, Camel will only consume files if a done file exists.||string|
|fileName|To get the object from the bucket with the given file name||string|
|includeBody|If it is true, the S3Object exchange will be consumed and put into the body and closed. If false, the S3Object stream will be put raw into the body and the headers will be set with the S3 object metadata. This option is strongly related to the autocloseBody option. In case of setting includeBody to true because the S3Object stream will be consumed then it will also be closed, while in case of includeBody false then it will be up to the caller to close the S3Object stream. However, setting autocloseBody to true when includeBody is false it will schedule to close the S3Object stream automatically on exchange completion.|true|boolean|
|includeFolders|If it is true, the folders/directories will be consumed. If it is false, they will be ignored, and Exchanges will not be created for those|true|boolean|
|moveAfterRead|Move objects from S3 bucket to a different bucket after they have been retrieved. To accomplish the operation, the destinationBucket option must be set. The copy bucket operation is only performed if the Exchange is committed. If a rollback occurs, the object is not moved.|false|boolean|
|autocloseBody|If this option is true and includeBody is false, then the S3Object.close() method will be called on exchange completion. This option is strongly related to includeBody option. In case of setting includeBody to false and autocloseBody to false, it will be up to the caller to close the S3Object stream. Setting autocloseBody to true, will close the S3Object stream automatically.|true|boolean|
|batchMessageNumber|The number of messages composing a batch in streaming upload mode|10|integer|
|batchSize|The batch size (in bytes) in streaming upload mode|1000000|integer|
|bufferSize|The buffer size (in bytes) in streaming upload mode|1000000|integer|
|deleteAfterWrite|Delete file object after the S3 file has been uploaded|false|boolean|
|keyName|Setting the key name for an element in the bucket through endpoint parameter||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|multiPartUpload|If it is true, camel will upload the file with multipart format. The part size is decided by the partSize option. Camel will only do multipart uploads for files that are larger than the part-size thresholds. Files that are smaller will be uploaded in a single operation.|false|boolean|
|namingStrategy|The naming strategy to use in streaming upload mode|progressive|object|
|operation|The operation to do in case the user don't want to do only an upload||object|
|partSize|Set up the partSize which is used in multipart upload, the default size is 25M. Camel will only do multipart uploads for files that are larger than the part-size thresholds. Files that are smaller will be uploaded in a single operation.|26214400|integer|
|restartingPolicy|The restarting policy to use in streaming upload mode|override|object|
|storageClass|The storage class to set in the com.amazonaws.services.s3.model.PutObjectRequest request.||string|
|streamingUploadMode|When stream mode is true, the upload to bucket will be done in streaming|false|boolean|
|streamingUploadTimeout|While streaming upload mode is true, this option set the timeout to complete upload||integer|
|awsKMSKeyId|Define the id of KMS key to use in case KMS is enabled||string|
|useAwsKMS|Define if KMS must be used or not|false|boolean|
|useCustomerKey|Define if Customer Key must be used or not|false|boolean|
|useSSES3|Define if SSE S3 must be used or not|false|boolean|
|amazonS3Client|Reference to a com.amazonaws.services.s3.AmazonS3 in the registry.||object|
|amazonS3Presigner|An S3 Presigner for Request, used mainly in createDownloadLink operation||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the SQS client||string|
|proxyPort|Specify a proxy port to be used inside the client definition.||integer|
|proxyProtocol|To define a proxy protocol when instantiating the S3 client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the S3 client should expect to load credentials through a default credentials provider.|false|boolean|
|useProfileCredentialsProvider|Set whether the S3 client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the S3 client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in S3.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bucketNameOrArn|Bucket name or ARN||string|
|autoCreateBucket|Setting the autocreation of the S3 bucket bucketName. This will apply also in case of moveAfterRead option enabled, and it will create the destinationBucket if it doesn't exist already.|false|boolean|
|delimiter|The delimiter which is used in the com.amazonaws.services.s3.model.ListObjectsRequest to only consume objects we are interested in.||string|
|forcePathStyle|Set whether the S3 client should use path-style URL instead of virtual-hosted-style|false|boolean|
|ignoreBody|If it is true, the S3 Object Body will be ignored completely if it is set to false, the S3 Object will be put in the body. Setting this to true will override any behavior defined by includeBody option.|false|boolean|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|policy|The policy for this queue to set in the com.amazonaws.services.s3.AmazonS3#setBucketPolicy() method.||string|
|prefix|The prefix which is used in the com.amazonaws.services.s3.model.ListObjectsRequest to only consume objects we are interested in.||string|
|region|The region in which the S3 client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|customerAlgorithm|Define the customer algorithm to use in case CustomerKey is enabled||string|
|customerKeyId|Define the id of the Customer key to use in case CustomerKey is enabled||string|
|customerKeyMD5|Define the MD5 of Customer key to use in case CustomerKey is enabled||string|
|deleteAfterRead|Delete objects from S3 after they have been retrieved. The deleting is only performed if the Exchange is committed. If a rollback occurs, the object is not deleted. If this option is false, then the same objects will be retrieved over and over again in the polls. Therefore, you need to use the Idempotent Consumer EIP in the route to filter out duplicates. You can filter using the AWS2S3Constants#BUCKET\_NAME and AWS2S3Constants#KEY headers, or only the AWS2S3Constants#KEY header.|true|boolean|
|destinationBucket|Define the destination bucket where an object must be moved when moveAfterRead is set to true.||string|
|destinationBucketPrefix|Define the destination bucket prefix to use when an object must be moved, and moveAfterRead is set to true.||string|
|destinationBucketSuffix|Define the destination bucket suffix to use when an object must be moved, and moveAfterRead is set to true.||string|
|doneFileName|If provided, Camel will only consume files if a done file exists.||string|
|fileName|To get the object from the bucket with the given file name||string|
|includeBody|If it is true, the S3Object exchange will be consumed and put into the body and closed. If false, the S3Object stream will be put raw into the body and the headers will be set with the S3 object metadata. This option is strongly related to the autocloseBody option. In case of setting includeBody to true because the S3Object stream will be consumed then it will also be closed, while in case of includeBody false then it will be up to the caller to close the S3Object stream. However, setting autocloseBody to true when includeBody is false it will schedule to close the S3Object stream automatically on exchange completion.|true|boolean|
|includeFolders|If it is true, the folders/directories will be consumed. If it is false, they will be ignored, and Exchanges will not be created for those|true|boolean|
|maxConnections|Set the maxConnections parameter in the S3 client configuration|60|integer|
|maxMessagesPerPoll|Gets the maximum number of messages as a limit to poll at each polling. Gets the maximum number of messages as a limit to poll at each polling. The default value is 10. Use 0 or a negative number to set it as unlimited.|10|integer|
|moveAfterRead|Move objects from S3 bucket to a different bucket after they have been retrieved. To accomplish the operation, the destinationBucket option must be set. The copy bucket operation is only performed if the Exchange is committed. If a rollback occurs, the object is not moved.|false|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|autocloseBody|If this option is true and includeBody is false, then the S3Object.close() method will be called on exchange completion. This option is strongly related to includeBody option. In case of setting includeBody to false and autocloseBody to false, it will be up to the caller to close the S3Object stream. Setting autocloseBody to true, will close the S3Object stream automatically.|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|inProgressRepository|A pluggable in-progress repository org.apache.camel.spi.IdempotentRepository. The in-progress repository is used to account the current in progress files being consumed. By default a memory based repository is used.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|batchMessageNumber|The number of messages composing a batch in streaming upload mode|10|integer|
|batchSize|The batch size (in bytes) in streaming upload mode|1000000|integer|
|bufferSize|The buffer size (in bytes) in streaming upload mode|1000000|integer|
|deleteAfterWrite|Delete file object after the S3 file has been uploaded|false|boolean|
|keyName|Setting the key name for an element in the bucket through endpoint parameter||string|
|multiPartUpload|If it is true, camel will upload the file with multipart format. The part size is decided by the partSize option. Camel will only do multipart uploads for files that are larger than the part-size thresholds. Files that are smaller will be uploaded in a single operation.|false|boolean|
|namingStrategy|The naming strategy to use in streaming upload mode|progressive|object|
|operation|The operation to do in case the user don't want to do only an upload||object|
|partSize|Set up the partSize which is used in multipart upload, the default size is 25M. Camel will only do multipart uploads for files that are larger than the part-size thresholds. Files that are smaller will be uploaded in a single operation.|26214400|integer|
|restartingPolicy|The restarting policy to use in streaming upload mode|override|object|
|storageClass|The storage class to set in the com.amazonaws.services.s3.model.PutObjectRequest request.||string|
|streamingUploadMode|When stream mode is true, the upload to bucket will be done in streaming|false|boolean|
|streamingUploadTimeout|While streaming upload mode is true, this option set the timeout to complete upload||integer|
|awsKMSKeyId|Define the id of KMS key to use in case KMS is enabled||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|useAwsKMS|Define if KMS must be used or not|false|boolean|
|useCustomerKey|Define if Customer Key must be used or not|false|boolean|
|useSSES3|Define if SSE S3 must be used or not|false|boolean|
|amazonS3Client|Reference to a com.amazonaws.services.s3.AmazonS3 in the registry.||object|
|amazonS3Presigner|An S3 Presigner for Request, used mainly in createDownloadLink operation||object|
|proxyHost|To define a proxy host when instantiating the SQS client||string|
|proxyPort|Specify a proxy port to be used inside the client definition.||integer|
|proxyProtocol|To define a proxy protocol when instantiating the S3 client|HTTPS|object|
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
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the S3 client should expect to load credentials through a default credentials provider.|false|boolean|
|useProfileCredentialsProvider|Set whether the S3 client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the S3 client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in S3.|false|boolean|
