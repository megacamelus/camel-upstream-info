# Google-functions

**Since Camel 3.9**

**Only producer is supported**

The Google Functions component provides access to [Google Cloud
Functions](https://cloud.google.com/functions/) via the [Google Cloud
Functions Client for
Java](https://github.com/googleapis/java-functions).

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-google-functions</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.x.x</version>
    </dependency>

# Authentication Configuration

Google Functions component authentication is targeted for use with the
GCP Service Accounts. For more information, please refer to [Google
Cloud
Authentication](https://github.com/googleapis/google-cloud-java#authentication).

When you have the **service account key**, you can provide
authentication credentials to your application code. Google security
credentials can be set through the component endpoint:

    String endpoint = "google-functions://myCamelFunction?serviceAccountKey=/home/user/Downloads/my-key.json";

Or by setting the environment variable `GOOGLE_APPLICATION_CREDENTIALS`
:

    export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/my-key.json"

# URI Format

    google-functions://functionName[?options]

You can append query options to the URI in the following format,
`?options=value&option2=value&...`

For example, to call the function `myCamelFunction` from the project
`myProject` and location `us-central1`, use the following snippet:

    from("direct:start")
        .to("google-functions://myCamelFunction?project=myProject&location=us-central1&operation=callFunction&serviceAccountKey=/home/user/Downloads/my-key.json");

# Usage

## Google Functions Producer operations

Google Functions component provides the following operation on the
producer side:

-   listFunctions

-   getFunction

-   callFunction

-   generateDownloadUrl

-   generateUploadUrl

-   createFunction

-   updateFunction

-   deleteFunction

If you don’t specify an operation by default, the producer will use the
`callFunction` operation.

## Advanced component configuration

If you need to have more control over the `client` instance
configuration, you can create your own instance and refer to it in your
Camel google-functions component configuration:

    from("direct:start")
        .to("google-functions://myCamelFunction?client=#myClient");

## Google Functions Producer Operation examples

-   `ListFunctions`: This operation invokes the Google Functions client
    and gets the list of cloud Functions

<!-- -->

    //list functions
    from("direct:start")
        .to("google-functions://myCamelFunction?serviceAccountKey=/home/user/Downloads/my-key.json&project=myProject&location=us-central1&operation=listFunctions")
        .log("body:${body}")

This operation will get the list of cloud functions for the project
`myProject` and location `us-central1`.

-   `GetFunction`: this operation gets the Cloud Functions object

<!-- -->

    //get function
    from("direct:start")
        .to("google-functions://myCamelFunction?serviceAccountKey=/home/user/Downloads/my-key.json&project=myProject&location=us-central1&operation=getFunction")
        .log("body:${body}")
        .to("mock:result");

This operation will get the `CloudFunction` object for the project
`myProject`, location `us-central1` and functionName `myCamelFunction`.

-   `CallFunction`: this operation calls the function using an HTTP
    request

<!-- -->

    //call function
    from("direct:start")
        .process(exchange -> {
          exchange.getIn().setBody("just a message");
        })
        .to("google-functions://myCamelFunction?serviceAccountKey=/home/user/Downloads/my-key.json&project=myProject&location=us-central1&operation=callFunction")
        .log("body:${body}")
        .to("mock:result");

-   `GenerateDownloadUrl`: this operation generates the signed URL for
    downloading deployed function source code.

<!-- -->

    //generate download url
    from("direct:start")
        .to("google-functions://myCamelFunction?serviceAccountKey=/home/user/Downloads/my-key.json&project=myProject&location=us-central1&operation=generateDownloadUrl")
        .log("body:${body}")
        .to("mock:result");

-   `GenerateUploadUrl`: this operation generates a signed URL for
    uploading a function source code.

<!-- -->

    from("direct:start")
        .to("google-functions://myCamelFunction?serviceAccountKey=/home/user/Downloads/my-key.json&project=myProject&location=us-central1&operation=generateUploadUrl")
        .log("body:${body}")
        .to("mock:result");

-   `createFunction`: this operation creates a new function.

<!-- -->

    from("direct:start")
        .process(exchange -> {
          exchange.getIn().setHeader(GoogleCloudFunctionsConstants.ENTRY_POINT, "com.example.Example");
          exchange.getIn().setHeader(GoogleCloudFunctionsConstants.RUNTIME, "java11");
          exchange.getIn().setHeader(GoogleCloudFunctionsConstants.SOURCE_ARCHIVE_URL, "gs://myBucket/source.zip");
        })
        .to("google-functions://myCamelFunction?serviceAccountKey=/home/user/Downloads/my-key.json&project=myProject&location=us-central1&operation=createFunction")
        .log("body:${body}")
        .to("mock:result");

-   `updateFunction`: this operation updates existing function.

<!-- -->

    from("direct:start")
        .process(exchange -> {
          UpdateFunctionRequest request = UpdateFunctionRequest.newBuilder()
            .setFunction(CloudFunction.newBuilder().build())
            .setUpdateMask(FieldMask.newBuilder().build()).build();
          exchange.getIn().setBody(request);
        })
        .to("google-functions://myCamelFunction?serviceAccountKey=/home/user/Downloads/my-key.json&project=myProject&location=us-central1&operation=updateFunction&pojoRequest=true")
        .log("body:${body}")
        .to("mock:result");

-   `deleteFunction`: this operation Deletes a function with the given
    name from the specified project.

<!-- -->

    from("direct:start")
        .to("google-functions://myCamelFunction?serviceAccountKey=/home/user/Downloads/my-key.json&project=myProject&location=us-central1&operation=deleteFunction")
        .log("body:${body}")
        .to("mock:result");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|functionName|The user-defined name of the function||string|
|serviceAccountKey|Service account key to authenticate an application as a service account||string|
|location|The Google Cloud Location (Region) where the Function is located||string|
|operation|The operation to perform on the producer.||object|
|pojoRequest|Specifies if the request is a pojo request|false|boolean|
|project|The Google Cloud Project name where the Function is located||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|client|The client to use during service invocation.||object|
