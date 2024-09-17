# Google-secret-manager

**Since Camel 3.16**

**Only producer is supported**

The Google Secret Manager component provides access to [Google Cloud
Secret Manager](https://cloud.google.com/secret-manager/)

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-google-secret-manager</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.x.x</version>
    </dependency>

# Authentication Configuration

Google Secret Manager component authentication is targeted for use with
the GCP Service Accounts. For more information, please refer to [Google
Cloud
Authentication](https://github.com/googleapis/google-cloud-java#authentication).

When you have the **service account key**, you can provide
authentication credentials to your application code. Google security
credentials can be set through the component endpoint:

    String endpoint = "google-secret-manager://myCamelFunction?serviceAccountKey=/home/user/Downloads/my-key.json";

Or by setting the environment variable `GOOGLE_APPLICATION_CREDENTIALS`
:

    export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/my-key.json"

# URI Format

    google-secret-manager://functionName[?options]

You can append query options to the URI in the following format,
`?options=value&option2=value&...`

For example, in order to call the function `myCamelFunction` from the
project `myProject` and location `us-central1`, use the following
snippet:

    from("google-secret-manager://myProject?serviceAccountKey=/home/user/Downloads/my-key.json&operation=createSecret")
      .to("direct:test");

## Using GCP Secret Manager Properties Source

To use GCP Secret Manager, you need to provide `serviceAccountKey` file
and GCP `projectId`. This can be done using environmental variables
before starting the application:

    export $CAMEL_VAULT_GCP_SERVICE_ACCOUNT_KEY=file:////path/to/service.accountkey
    export $CAMEL_VAULT_GCP_PROJECT_ID=projectId

You can also configure the credentials in the `application.properties`
file such as:

    camel.vault.gcp.serviceAccountKey = serviceAccountKey
    camel.vault.gcp.projectId = projectId

If you want instead to use the [GCP default client
instance](https://cloud.google.com/docs/authentication/production),
you’ll need to provide the following env variables:

    export $CAMEL_VAULT_GCP_USE_DEFAULT_INSTANCE=true
    export $CAMEL_VAULT_GCP_PROJECT_ID=projectId

You can also configure the credentials in the `application.properties`
file such as:

    camel.vault.gcp.useDefaultInstance = true
    camel.vault.gcp.projectId = region

`camel.vault.gcp` configuration only applies to the Google Secret
Manager properties function (E.g when resolving properties). When using
the `operation` option to create, get, list secrets etc., you should
provide the usual options for connecting to GCP Services.

At this point you’ll be able to reference a property in the following
way by using `gcp:` as prefix in the `{{ }}` syntax:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{gcp:route}}"/>
        </route>
    </camelContext>

Where `route` will be the name of the secret stored in the GCP Secret
Manager Service.

You could specify a default value in case the secret is not present on
GCP Secret Manager:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{gcp:route:default}}"/>
        </route>
    </camelContext>

In this case, if the secret doesn’t exist, the property will fall back
to `default` as value.

Also, you are able to get a particular field of the secret, if you have,
for example, a secret named database of this form:

    {
      "username": "admin",
      "password": "password123",
      "engine": "postgres",
      "host": "127.0.0.1",
      "port": "3128",
      "dbname": "db"
    }

You’re able to do get single secret value in your route, like for
example:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <log message="Username is {{gcp:database#username}}"/>
        </route>
    </camelContext>

Or re-use the property as part of an endpoint.

You could specify a default value in case the particular field of secret
is not present on GCP Secret Manager:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <log message="Username is {{gcp:database#username:admin}}"/>
        </route>
    </camelContext>

In this case, if the secret doesn’t exist or the secret exists, but the
username field is not part of the secret, the property will fall back to
"admin" as value.

There is also the syntax to get a particular version of the secret for
both the approach, with field/default value specified or only with
secret:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{gcp:route@1}}"/>
        </route>
    </camelContext>

This approach will return the RAW route secret with version *1*.

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{gcp:route:default@1}}"/>
        </route>
    </camelContext>

This approach will return the route secret value with version *1* or
default value in case the secret doesn’t exist or the version doesn’t
exist.

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <log message="Username is {{gcp:database#username:admin@1}}"/>
        </route>
    </camelContext>

This approach will return the username field of the database secret with
version *1* or admin in case the secret doesn’t exist or the version
doesn’t exist.

There are only two requirements: - Adding `camel-google-secret-manager`
JAR to your Camel application. - Give the service account used
permissions to do operation at secret management level, (for example,
accessing the secret payload, or being admin of secret manager service)

## Automatic `CamelContext` reloading on Secret Refresh

Being able to reload Camel context on a Secret Refresh could be done by
specifying the usual credentials (the same used for Google Secret
Manager Property Function).

With Environment variables:

    export $CAMEL_VAULT_GCP_USE_DEFAULT_INSTANCE=true
    export $CAMEL_VAULT_GCP_PROJECT_ID=projectId

or as plain Camel main properties:

    camel.vault.gcp.useDefaultInstance = true
    camel.vault.gcp.projectId = projectId

Or by specifying a path to a service account key file, instead of using
the default instance.

To enable the automatic refresh, you’ll need additional properties to
set:

    camel.vault.gcp.projectId= projectId
    camel.vault.gcp.refreshEnabled=true
    camel.vault.gcp.refreshPeriod=60000
    camel.vault.gcp.secrets=hello*
    camel.vault.gcp.subscriptionName=subscriptionName
    camel.main.context-reload-enabled = true

where `camel.vault.gcp.refreshEnabled` will enable the automatic context
reload, `camel.vault.gcp.refreshPeriod` is the interval of time between
two different checks for update events and `camel.vault.gcp.secrets` is
a regex representing the secrets we want to track for updates.

Note that `camel.vault.gcp.secrets` is not mandatory: if not specified
the task responsible for checking updates events will take into accounts
or the properties with an `gcp:` prefix.

The `camel.vault.gcp.subscriptionName` is the subscription name created
in relation to the Google PubSub topic associated with the tracked
secrets.

This mechanism while making use of the notification system related to
Google Secret Manager: through this feature, every secret could be
associated with one up to ten Google Pubsub Topics. These topics will
receive events related to the life cycle of the secret.

There are only two requirements: - Adding `camel-google-secret-manager`
JAR to your Camel application. - Give the service account used
permissions to do operation at secret management level, (for example,
accessing the secret payload, or being admin of secret manager service
and also have permission over the Pubsub service)

## Automatic `CamelContext` reloading on Secret Refresh - Required infrastructure’s creation

You’ll need to install the gcloud cli from
[https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)

Once the Cli has been installed we can proceed to log in and to set up
the project with the following commands:

\`\`\` gcloud auth login \`\`\`

and

\`\`\` gcloud projects create \<projectId\> --name="GCP Secret
Manager Refresh" \`\`\`

The project will need a service identity for using secret manager
service and we’ll be able to have that through the command:

\`\`\` gcloud beta services identity create --service
"secretmanager.googleapis.com" --project \<project\_id\> \`\`\`

The latter command will provide a service account name that we need to
export

\`\`\` export SM\_SERVICE\_ACCOUNT="service-…." \`\`\`

Since we want to have notifications about events related to a specific
secret through a Google Pubsub topic we’ll need to create a topic for
this purpose with the following command:

\`\`\` gcloud pubsub topics create
"projects/\<project\_id\>/topics/pubsub-gcp-sec-refresh" \`\`\`

The service account will need Secret Manager authorization to publish
messages on the topic just created, so we’ll need to add an iam policy
binding with the following command:

\`\`\` \`\`\`

We now need to create a subscription to the pubsub-gcp-sec-refresh just
created and we’re going to call it sub-gcp-sec-refresh with the
following command:

\`\`\` gcloud pubsub subscriptions create
"projects/\<project\_id\>/subscriptions/sub-gcp-sec-refresh" --topic
"projects/\<project\_id\>/topics/pubsub-gcp-sec-refresh" \`\`\`

Now we need to create a service account for running our application:

\`\`\` gcloud iam service-accounts create gcp-sec-refresh-sa
\--description="GCP Sec Refresh SA" --project \<project\_id\> \`\`\`

Let’s give the SA an owner role:

\`\`\` gcloud projects add-iam-policy-binding \<project\_id\>
\--member="serviceAccount:gcp-sec-refresh-sa@\<project\_id\>.iam.gserviceaccount.com"
\--role="roles/owner" \`\`\`

Now we should create a Service account key file for the just create SA:

\`\`\` gcloud iam service-accounts keys create \<project\_id\>.json
\--iam-account=gcp-sec-refresh-sa@\<project\_id\>.iam.gserviceaccount.com
\`\`\`

Let’s enable the Secret Manager API for our project

\`\`\` gcloud services enable secretmanager.googleapis.com --project
\<project\_id\> \`\`\`

Also the PubSub API needs to be enabled

\`\`\` gcloud services enable pubsub.googleapis.com --project
\<project\_id\> \`\`\`

If needed enable also the Billing API.

Now it’s time to create our secret, with topic notification:

\`\`\` gcloud secrets create \<secret\_name\>
\--topics=projects/\<project\_id\>/topics/pubsub-gcp-sec-refresh
\--project=\<project\_id\> \`\`\`

And let’s add the value

\`\`\` gcloud secrets versions add \<secret\_name\>
\--data-file=\<json\_secret\> --project=\<project\_id\> \`\`\`

You could now use the projectId and the service account json file to
recover the secret.

## Google Secret Manager Producer operations

Google Functions component provides the following operation on the
producer side:

-   `createSecret`

-   `getSecretVersion`

-   `deleteSecret`

-   `listSecrets`

If you don’t specify an operation by default, the producer will use the
`createSecret` operation.

## Google Secret Manager Producer Operation examples

-   `createSecret`: This operation will create a secret in the Secret
    Manager service

<!-- -->

    from("direct:start")
        .setHeader("GoogleSecretManagerConstants.SECRET_ID, constant("test"))
        .setBody(constant("hello"))
        .to("google-functions://myProject?serviceAccountKey=/home/user/Downloads/my-key.json&operation=createSecret")
        .log("body:${body}")

-   `getSecretVersion`: This operation will retrieve a secret value with
    the latest version in the Secret Manager service

<!-- -->

    from("direct:start")
        .setHeader("GoogleSecretManagerConstants.SECRET_ID, constant("test"))
        .to("google-functions://myProject?serviceAccountKey=/home/user/Downloads/my-key.json&operation=getSecretVersion")
        .log("body:${body}")

This will log the value of the secret "test".

-   `deleteSecret`: This operation will delete a secret

<!-- -->

    from("direct:start")
        .setHeader("GoogleSecretManagerConstants.SECRET_ID, constant("test"))
        .to("google-functions://myProject?serviceAccountKey=/home/user/Downloads/my-key.json&operation=deleteSecret")

-   ‘listSecrets\`: This operation will return the secrets’ list for the
    project myProject

<!-- -->

    from("direct:start")
        .setHeader("GoogleSecretManagerConstants.SECRET_ID, constant("test"))
        .to("google-functions://myProject?serviceAccountKey=/home/user/Downloads/my-key.json&operation=listSecrets")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|project|The Google Cloud Project Id name related to the Secret Manager||string|
|serviceAccountKey|Service account key to authenticate an application as a service account||string|
|operation|The operation to perform on the producer.||object|
|pojoRequest|Specifies if the request is a pojo request|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|client|The client to use during service invocation.||object|
