# Salesforce

**Since Camel 2.12**

**Both producer and consumer are supported**

This component supports producer and consumer endpoints to communicate
with Salesforce using Java DTOs. There is a companion [maven
plugin](#MavenPlugin) that generates these DTOs.

Developers wishing to contribute to the component are instructed to look
at the
[README.md](https://github.com/apache/camel/tree/main/components/camel-salesforce/camel-salesforce-component/README.md)
file on instructions on how to get started and set up your environment
for running integration tests.

# Getting Started

Follow these steps to get started with the Salesforce component.

1.  **Create a salesforce org**. If you don’t already have access to a
    salesforce org, you can create a [free developer
    org](https://developer.salesforce.com/signup).

2.  **Create a Connected App**. In salesforce, go to Setup \> Apps
    \> App Manager, then click on **New Connected App**. Make sure to
    check **Enable OAuth Settings** and include relevant OAuth Scopes,
    including the scope called **Perform requests at any time**. Click
    **Save**.

3.  **Get the Consumer Key and Consumer Secret**. You’ll need these to
    configure salesforce authentication. View your new connected app,
    then copy the key and secret and save in a safe place.

4.  **Add Maven depdendency**.
    
        <dependency>
            <groupId>org.apache.camel</groupId>
            <artifactId>camel-salesforce</artifactId>
        </dependency>

Spring Boot users should use the starter instead.

+

    <dependency>
        <groupId>org.apache.camel.springboot</groupId>
        <artifactId>camel-salesforce-starter</artifactId>
    </dependency>

1.  **Generate DTOs**. Optionally, generate Java DTOs to represent your
    salesforce objects. This step isn’t a hard requirement per se, but
    most use cases will benefit from the type safety and
    auto-completion. Use the [maven plugin](#MavenPlugin) to generate
    DTOs for the salesforce objects you’ll be working with.

2.  **Configure authentication**. Using the OAuth key and secret, you
    generated previously, configure salesforce
    [authentication](#AuthenticatingToSalesforce).

3.  **Create routes**. Starting creating routes that interact with
    salesforce!

# Usage

## Authenticating to Salesforce <span id="AuthenticatingToSalesforce"></span>

The component supports three OAuth authentication flows:

-   [OAuth 2.0 Username-Password
    Flow](https://help.salesforce.com/articleView?id=remoteaccess_oauth_username_password_flow.htm)

-   [OAuth 2.0 Refresh Token
    Flow](https://help.salesforce.com/articleView?id=remoteaccess_oauth_refresh_token_flow.htm)

-   [OAuth 2.0 JWT Bearer Token
    Flow](https://help.salesforce.com/articleView?id=remoteaccess_oauth_jwt_flow.htm)

For each of the flows, different sets of properties need to be set:

<table>
<caption>Properties to set for each authentication flow</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Property</p></td>
<td style="text-align: left;"><p>Where to find it on Salesforce</p></td>
<td style="text-align: left;"><p>Flow</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>clientId</code></p></td>
<td style="text-align: left;"><p>Connected App, Consumer Key</p></td>
<td style="text-align: left;"><p>All flows</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>clientSecret</code></p></td>
<td style="text-align: left;"><p>Connected App, Consumer Secret</p></td>
<td style="text-align: left;"><p>Username-Password, Refresh Token,
Client Credentials</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>userName</code></p></td>
<td style="text-align: left;"><p>Salesforce user username</p></td>
<td style="text-align: left;"><p>Username-Password, JWT Bearer
Token</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>password</code></p></td>
<td style="text-align: left;"><p>Salesforce user password</p></td>
<td style="text-align: left;"><p>Username-Password</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>refreshToken</code></p></td>
<td style="text-align: left;"><p>From OAuth flow callback</p></td>
<td style="text-align: left;"><p>Refresh Token</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>keystore</code></p></td>
<td style="text-align: left;"><p>Connected App, Digital
Certificate</p></td>
<td style="text-align: left;"><p>JWT Bearer Token</p></td>
</tr>
</tbody>
</table>

Properties to set for each authentication flow

The component auto determines what flow you’re trying to configure. In
order to be explicit, set the `authenticationType` property.

Using Username-Password Flow in production is not encouraged.

The certificate used in JWT Bearer Token Flow can be a self-signed
certificate. The KeyStore holding the certificate and the private key
must contain only a single certificate-private key entry.

## General Usage

### URI format

When used as a consumer, receiving streaming events, the URI scheme is:

    salesforce:subscribe:topic?options

When used as a producer, invoking the Salesforce REST APIs, the URI
scheme is:

    salesforce:operationName?options

As a general example on using the operations in this salesforce
component, the following producer endpoint uses the upsertSObject API,
with the sObjectIdName parameter specifying *Name* as the external id
field. The request message body should be an SObject DTO generated using
the maven plugin.

    ...to("salesforce:upsertSObject?sObjectIdName=Name")...

## Passing in Salesforce headers and fetching Salesforce response headers

There is support to pass [Salesforce
headers](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/headers.htm)
via inbound message headers, header names that start with `Sforce` or
`x-sfdc` on the Camel message will be passed on in the request, and
response headers that start with `Sforce` will be present in the
outbound message headers.

For example, to fetch API limits, you can specify:

    // in your Camel route set the header before Salesforce endpoint
    //...
      .setHeader("Sforce-Limit-Info", constant("api-usage"))
      .to("salesforce:getGlobalObjects")
      .to(myProcessor);
    
    // myProcessor will receive `Sforce-Limit-Info` header on the outbound
    // message
    class MyProcessor implements Processor {
        public void process(Exchange exchange) throws Exception {
            Message in = exchange.getIn();
            String apiLimits = in.getHeader("Sforce-Limit-Info", String.class);
       }
    }

In addition, HTTP response status code and text are available as headers
`Exchange.HTTP_RESPONSE_CODE` and `Exchange.HTTP_RESPONSE_TEXT`.

### Sending null values to salesforce

By default, SObject fields with null values are not sent to salesforce.
In order to send null values to salesforce, use the `fieldsToNull`
property, as follows:

    accountSObject.getFieldsToNull().add("Site");

## Supported Salesforce APIs

Camel supports the following Salesforce APIs:

-   [REST API](#RESTAPI)

-   [Apex REST API](#ApexRESTAPI)

-   [Bulk 2 API](#Bulk2API)

-   [Bulk API](#BulkAPI)

-   [Pub/Sub API](#PubSubAPI)

-   [Streaming API](#StreamingAPI)

-   [Reports API](#ReportsAPI)

### REST API

The following operations are supported:

-   [getVersions](#getVersions) - Gets supported Salesforce REST API
    versions.

-   [getResources](#getResources) - Gets available Salesforce REST
    Resource endpoints.

-   [limits](#limits) - Lists information about limits in your org.

-   [recent](#recent) - Gets the most recently accessed items that were
    viewed or referenced by the current user.

-   [getGlobalObjects](#getGlobalObjects) - Gets metadata for all
    available SObject types.

-   [getBasicInfo](#getBasicInfo) - Gets basic metadata for a specific
    SObject type.

-   [getDescription](#getDescription) - Gets comprehensive metadata for
    a specific SObject type.

-   [getSObject](#getSObject) - Gets an SObject.

-   [getSObjectWithId](#getSObjectWithId) - Gets an SObject using an
    External Id (user defined) field.

-   [getBlobField](#getSObjectWithId) - Retrieves the specified blob
    field from an individual record.

-   [createSObject](#createSObject) - Creates an SObject.

-   [updateSObject](#updateSObject) - Updates an SObject.

-   [deleteSObject](#deleteSObject) - Deletes an SObject.

-   [upsertSObject](#upsertSObject) - Inserts or updates an SObject
    using an External Id.

-   [deleteSObjectWithId](#deleteSObjectWithId) - Deletes an SObject
    using an External Id.

-   [query](#query) - Runs a Salesforce SOQL query.

-   [queryMore](#queryMore) - Retrieves more results (in case of a large
    number of results) using the result link returned from the *query*
    API.

-   [queryAll](#queryAll) - Runs a SOQL query. Unlike the query
    operation, queryAll returns records that are deleted because of a
    merge or delete. queryAll also returns information about archived
    task and event records.

-   [search](#sosl_search) - Runs a Salesforce SOSL query.

-   [apexCall](#apexCall) - Executes a user defined APEX REST API call.

-   [approval](#approval) - Submits a record or records (batch) for
    approval process.

-   [approvals](#approvals) - Fetches a list of all approval processes.

-   [composite](#composite) - Executes up to 25 REST API requests in a
    single call. You can use the output of one request as the input to a
    subsequent request.

-   [composite-tree](#composite-tree) - Creates up to 200 records with
    parent-child relationships (up to 5 levels) in one go.

-   [composite-batch](#composite-batch) - Executes up to 25 sub-requests
    in a single request.

-   [compositeRetrieveSObjectCollections](#compositeRetrieveSObjectCollections) -
    Retrieves one or more records of the same object type.

-   [compositeCreateSObjectCollections](#compositeCreateSObjectCollections) -
    Creates up to 200 records.

-   [compositeUpdateSObjectCollections](#compositeUpdateSObjectCollections) -
    Update up to 200 records.

-   [compositeUpsertSObjectCollections](#compositeUpsertSObjectCollections) -
    Creates or updates up to 200 records based on an External Id field.

-   [compositeDeleteSObjectCollections](#compositeDeleteSObjectCollections) -
    Deletes up to 200 records.

-   [getEventSchema](#getEventSchema) - Gets the event schema for
    Plaform Events, Change Data Capture events, etc.

Unless otherwise specified, DTO types for the following options are from
`org.apache.camel.component.salesforce.api.dto` or one if its
sub-packages.

#### Versions

`getVersions`

Lists summary information about each Salesforce version currently
available, including the version, label, and a link to each version’s
root.

**Output**

Type: `List<Version>`

#### Resources by Version

`getResources`

Lists available resources for the current API version, including
resource name and URI.

**Output**

Type: `Map<String, String>`

#### Limits

`limits`

Lists information about limits in your org. For each limit, this
resource returns the maximum allocation and the remaining allocation
based on usage.

**Output**

Type: `Limits`

**Additional Usage Information**

With `salesforce:limits` operation you can fetch of API limits from
Salesforce and then act upon that data received. The result of
`salesforce:limits` operation is mapped to
`org.apache.camel.component.salesforce.api.dto.Limits` class and can be
used in a custom processors or expressions.

For instance, consider that you need to limit the API usage of
Salesforce so that 10% of daily API requests is left for other routes.
The body of output message contains an instance of
`org.apache.camel.component.salesforce.api.dto.Limits` object that can
be used in conjunction with Content Based Router and Content Based
Router and [Spring Expression Language
(SpEL)](#languages:spel-language.adoc) to choose when to perform
queries.

Notice how multiplying `1.0` with the integer value held in
`body.dailyApiRequests.remaining` makes the expression evaluate as with
floating point arithmetic, without it - it would end up making integral
division which would result with either `0` (some API limits consumed)
or `1` (no API limits consumed).

    from("direct:querySalesforce")
        .to("salesforce:limits")
        .choice()
        .when(spel("#{1.0 * body.dailyApiRequests.remaining / body.dailyApiRequests.max < 0.1}"))
            .to("salesforce:query?...")
        .otherwise()
            .setBody(constant("Used up Salesforce API limits, leaving 10% for critical routes"))
        .endChoice()

#### Recently Viewed Items

`recent`

Gets the most recently accessed items that were viewed or referenced by
the current user. Salesforce stores information about record views in
the interface and uses it to generate a list of recently viewed and
referenced records, such as in the sidebar and for the auto-complete
options in search.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>limit</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>An optional limit that specifies the
maximum number of records to be returned. If this parameter is not
specified, the default maximum number of records returned is the maximum
number of entries in RecentlyViewed, which is 200 records per
object.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `List<RecentItem>`

**Additional Usage Information**

To fetch the recent items use `salesforce:recent` operation. This
operation returns an `java.util.List` of
`org.apache.camel.component.salesforce.api.dto.RecentItem` objects
(`List<RecentItem>`) that in turn contain the `Id`, `Name` and
`Attributes` (with `type` and `url` properties). You can limit the
number of returned items by specifying `limit` parameter set to maximum
number of records to return. For example:

    from("direct:fetchRecentItems")
        to("salesforce:recent")
            .split().body()
                .log("${body.name} at ${body.attributes.url}");

#### Describe Global

`getGlobalObjects`

Lists the available objects and their metadata for your organization’s
data. In addition, it provides the organization encoding, as well as the
maximum batch size permitted in queries.

**Output**

Type: `GlobalObjects`

#### sObject Basic Information

`getBasicInfo`

Describes the individual metadata for the specified object.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of SObject, e.g.
<code>Account</code>. Alternatively, can be supplied in Body.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `SObjectBasicInfo`

#### sObject Describe

`getDescription`

Completely describes the individual metadata at all levels for the
specified object. For example, this can be used to retrieve the fields,
URLs, and child relationships for the Account object.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of SObject, e.g.
<code>Account</code>. Alternatively, can be supplied in Body.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `SObjectDescription`

#### Retrieve SObject

`getSObject`

Accesses record based on the specified object ID. This operation
requires the `packages` option to be set.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of SObject, e.g.
<code>Account</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of record to retrieve.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectFields</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Comma-separated list of fields to
retrieve</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td
style="text-align: left;"><p><code>AbstractSObjectBase</code></p></td>
<td style="text-align: left;"><p>Instance of SObject that is used to
query salesforce. If supplied, overrides <code>sObjectName</code> and
<code>sObjectId</code> parameters.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: Subclass of `AbstractSObjectBase`

#### Retrieve SObject by External Id

`getSObjectWithId`

Accesses record based on an External ID value. This operation requires
the `packages` option to be set.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectIdName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of External ID field</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectIdValue</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>External ID value</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of SObject, e.g.
<code>Account</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td
style="text-align: left;"><p><code>AbstractSObjectBase</code></p></td>
<td style="text-align: left;"><p>Instance of SObject that is used to
query salesforce. If supplied, overrides <code>sObjectName</code> and
<code>sObjectIdValue</code> parameters.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: Subclass of `AbstractSObjectBase`

#### sObject Blob Retrieve

`getBlobField`

Retrieves the specified blob field from an individual record.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>sObjectBlobFieldName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>SOSL query</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of SObject, e.g., Account</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if SObject not supplied in
body</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of SObject</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if SObject not supplied in
body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td
style="text-align: left;"><p><code>AbstractSObjectBase</code></p></td>
<td style="text-align: left;"><p>SObject to determine type and Id from.
If not supplied, <code>sObjectId</code> and <code>sObjectName</code>
parameters will be used.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>sObjectId</code> and
<code>sObjectName</code> are not supplied</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `InputStream`

#### Create SObject

`createSObject`

Creates a record in salesforce.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>AbstractSObjectBase</code> or
<code>String</code></p></td>
<td style="text-align: left;"><p>Instance of SObject to create.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of SObject, e.g.
<code>Account</code>. Only used if Camel cannot determine from
Body.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If Body is a
<code>String</code></p></td>
</tr>
</tbody>
</table>

**Output**

Type: `CreateSObjectResult`

#### Update SObject

`updateSObject`

Updates a record in salesforce.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>AbstractSObjectBase</code> or
<code>String</code></p></td>
<td style="text-align: left;"><p>Instance of SObject to update.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of SObject, e.g.
<code>Account</code>. Only used if Camel cannot determine from
Body.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If Body is a
<code>String</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of record to update. Only used if
Camel cannot determine from Body.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If Body is a
<code>String</code></p></td>
</tr>
</tbody>
</table>

#### Upsert SObject

`upsertSObject`

Upserts a record by External ID.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>AbstractSObjectBase</code> or
<code>String</code></p></td>
<td style="text-align: left;"><p>SObject to update.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectIdName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>External ID field name.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectIdValue</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>External ID value</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If Body is a
<code>String</code></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of SObject, e.g.
<code>Account</code>. Only used if Camel cannot determine from
Body.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If Body is a
<code>String</code></p></td>
</tr>
</tbody>
</table>

**Output**

Type: `UpsertSObjectResult`

#### Delete SObject

`deleteSObject`

Deletes a record in salesforce.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td
style="text-align: left;"><p><code>AbstractSObjectBase</code></p></td>
<td style="text-align: left;"><p>Instance of SObject to delete.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of SObject, e.g.
<code>Account</code>. Only used if Camel cannot determine from
Body.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If Body is not an
<code>AbstractSObjectBase</code> instance</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of record to delete.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If Body is not an
<code>AbstractSObjectBase</code> instance</p></td>
</tr>
</tbody>
</table>

#### Delete SObject by External Id

`deleteSObjectWithId`

Deletes a record in salesforce by External ID.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td
style="text-align: left;"><p><code>AbstractSObjectBase</code></p></td>
<td style="text-align: left;"><p>Instance of SObject to delete.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectIdName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of External ID field</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If Body is not an
<code>AbstractSObjectBase</code> instance</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectIdValue</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>External ID value</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If Body is not an
<code>AbstractSObjectBase</code> instance</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of SObject, e.g.
<code>Account</code>. Only used if Camel cannot determine from
Body.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If Body is not an
<code>AbstractSObjectBase</code> instance</p></td>
</tr>
</tbody>
</table>

#### Query

`query`

Runs a Salesforce SOQL query. If neither `sObjectClass` nor
`sObjectName` are set, Camel will attempt to determine the correct
`AbstractQueryRecordsBase` sublcass based on the response.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body or
<code>sObjectQuery</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>SOQL query</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>streamQueryResult</p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, returns a streaming
<code>Iterator</code> and transparently retrieves all pages as needed.
The <code>sObjectClass</code> option must reference an
<code>AbstractQueryRecordsBase</code> subclass.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectClass</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Fully qualified name of class to
deserialize response to. Usually a subclass of
<code>AbstractQueryRecordsBase</code>, e.g.
<code>org.my.dto.QueryRecordsAccount</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Simple name of class to deserialize
response to. Usually a subclass of
<code>AbstractQueryRecordsBase</code>, e.g.
<code>QueryRecordsAccount</code>. Requires the <code>package</code>
option be set.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: Instance of class supplied in `sObjectClass`, or
`Iterator<SomeSObject>` if `streamQueryResult` is true. If
`streamQueryResult` is true, the header
`CamelSalesforceQueryResultTotalSize` is set to the number of records
that matched the query.

#### Query More

`queryMore`

Retrieves more results (in case of large number of results) using result
link returned from the `query` and `queryAll` operations. If neither
`sObjectClass` nor `sObjectName` are set, Camel will attempt to
determine the correct `AbstractQueryRecordsBase` sublcass based on the
response.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body or
<code>sObjectQuery</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p><code>nextRecords</code> value. Can be
found in a prior query result in the
<code>AbstractQueryRecordsBase.nextRecordsUrl</code> property</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>X</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectClass</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Fully qualified name of class to
deserialize response to. Usually a subclass of
<code>AbstractQueryRecordsBase</code>, e.g.
<code>org.my.dto.QueryRecordsAccount</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Simple name of class to deserialize
response to. Usually a subclass of
<code>AbstractQueryRecordsBase</code>, e.g.
<code>QueryRecordsAccount</code>. Requires the <code>package</code>
option be set.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: Instance of class supplied in `sObjectClass`

#### Query All

`queryAll`

Executes the specified SOQL query. Unlike the `query` operation ,
`queryAll` returns records that are deleted because of a merge or
delete. It also returns information about archived task and event
records. If neither `sObjectClass` nor `sObjectName` are set, Camel will
attempt to determine the correct `AbstractQueryRecordsBase` sublcass
based on the response.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body or
<code>sObjectQuery</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>SOQL query</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>streamQueryResult</p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, returns a streaming
<code>Iterable</code> and transparently retrieves all pages as needed.
The <code>sObjectClass</code> option must reference an
<code>AbstractQueryRecordsBase</code> subclass.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectClass</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Fully qualified name of class to
deserialize response to. Usually a subclass of
<code>AbstractQueryRecordsBase</code>, e.g.
<code>org.my.dto.QueryRecordsAccount</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Simple name of class to deserialize
response to. Usually a subclass of
<code>AbstractQueryRecordsBase</code>, e.g.
<code>QueryRecordsAccount</code>. Requires the <code>package</code>
option be set.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: Instance of class supplied in `sObjectClass`, or
`Iterator<SomeSObject>` if `streamQueryResult` is true.

#### Search

`search`

Runs a Salesforce SOSL search

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body or
<code>sObjectSearch</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of field to retrieve</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `SearchResult2`

#### Submit Approval

`approval`

Submit a record or records (batch) for approval process.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>ApprovalRequest</code> or
<code>List&lt;ApprovalRequest&gt;</code></p></td>
<td style="text-align: left;"><p><code>ApprovalRequest</code>(s) to
process</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>Approval.</code></p></td>
<td style="text-align: left;"><p>Prefixed headers or endpoint options in
lieu of passing an <code>ApprovalRequest</code> in the body.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `ApprovalResult`

**Additional usage information**

All the properties are named exactly the same as in the Salesforce REST
API prefixed with `approval.`. You can set approval properties by
setting `approval.PropertyName` of the Endpoint these will be used as
template — meaning that any property not present in either body or
header will be taken from the Endpoint configuration. Or you can set the
approval template on the Endpoint by assigning `approval` property to a
reference onto a bean in the Registry.

You can also provide header values using the same
`approval.PropertyName` in the incoming message headers.

And finally body can contain one `AprovalRequest` or an `Iterable` of
`ApprovalRequest` objects to process as a batch.

The important thing to remember is the priority of the values specified
in these three mechanisms:

1.  value in body takes precedence before any other

2.  value in message header takes precedence before template value

3.  value in template is set if no other value in header or body was
    given

For example, to send one record for approval using values in headers
use:

Given a route:

    from("direct:example1")//
            .setHeader("approval.ContextId", simple("${body['contextId']}"))
            .setHeader("approval.NextApproverIds", simple("${body['nextApproverIds']}"))
            .to("salesforce:approval?"//
                + "approval.actionType=Submit"//
                + "&approval.comments=this is a test"//
                + "&approval.processDefinitionNameOrId=Test_Account_Process"//
                + "&approval.skipEntryCriteria=true");

You could send a record for approval using:

    final Map<String, String> body = new HashMap<>();
    body.put("contextId", accountIds.iterator().next());
    body.put("nextApproverIds", userId);
    
    final ApprovalResult result = template.requestBody("direct:example1", body, ApprovalResult.class);

#### Get Approvals

`approvals`

Returns a list of all approval processes.

**Output**

Type: `Approvals`

#### Composite

`composite`

Executes up to 25 REST API requests in a single call. You can use the
output of one request as the input to a subsequent request. The response
bodies and HTTP statuses of the requests are returned in a single
response body. The entire series of requests counts as a single call
toward your API limits. Use Salesforce Composite API to submit multiple
chained requests. Individual requests and responses are linked with the
provided *reference*.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>SObjectComposite</code></p></td>
<td style="text-align: left;"><p>Contains REST API sub-requests to be
executed.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>rawPayload</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Any (un)marshaling of requests and
responses are assumed to be handled by the route</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>compositeMethod</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>HTTP method to use for rawPayload
requests.</p></td>
<td style="text-align: left;"><p><code>POST</code></p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `SObjectCompositeResponse`

Composite API supports only JSON payloads.

As with the batch API, the results can vary from API to API so the body
of each `SObjectCompositeResult` instance is given as a
`java.lang.Object`. In most cases the result will be a `java.util.Map`
with string keys and values or other `java.util.Map` as value. Requests
are made in JSON format hold some type information (i.e., it is known
what values are strings and what values are numbers).

Let’s look at an example:

    SObjectComposite composite = new SObjectComposite("38.0", true);
    
    // first insert operation via an external id
    final Account updateAccount = new TestAccount();
    updateAccount.setName("Salesforce");
    updateAccount.setBillingStreet("Landmark @ 1 Market Street");
    updateAccount.setBillingCity("San Francisco");
    updateAccount.setBillingState("California");
    updateAccount.setIndustry(Account_IndustryEnum.TECHNOLOGY);
    composite.addUpdate("Account", "001xx000003DIpcAAG", updateAccount, "UpdatedAccount");
    
    final Contact newContact = new TestContact();
    newContact.setLastName("John Doe");
    newContact.setPhone("1234567890");
    composite.addCreate(newContact, "NewContact");
    
    final AccountContactJunction__c junction = new AccountContactJunction__c();
    junction.setAccount__c("001xx000003DIpcAAG");
    junction.setContactId__c("@{NewContact.id}");
    composite.addCreate(junction, "JunctionRecord");
    
    final SObjectCompositeResponse response = template.requestBody("salesforce:composite", composite, SObjectCompositeResponse.class);
    final List<SObjectCompositeResult> results = response.getCompositeResponse();
    
    final SObjectCompositeResult accountUpdateResult = results.stream().filter(r -> "UpdatedAccount".equals(r.getReferenceId())).findFirst().get()
    final int statusCode = accountUpdateResult.getHttpStatusCode(); // should be 200
    final Map<String, ?> accountUpdateBody = accountUpdateResult.getBody();
    
    final SObjectCompositeResult contactCreationResult = results.stream().filter(r -> "JunctionRecord".equals(r.getReferenceId())).findFirst().get()

**Using the `rawPayload` option**

It’s possible to directly call Salesforce composite by preparing the
Salesforce JSON request in the route thanks to the `rawPayload` option.

For instance, you can have the following route:

    from("timer:fire?period=2000").setBody(constant("{\n" +
         " \"allOrNone\" : true,\n" +
         " \"records\" : [ { \n" +
         "   \"attributes\" : {\"type\" : \"FOO\"},\n" +
         "   \"Name\" : \"123456789\",\n" +
         "   \"FOO\" : \"XXXX\",\n" +
         "   \"ACCOUNT\" : 2100.0\n" +
         "   \"ExternalID\" : \"EXTERNAL\"\n"
         " }]\n" +
         "}")
       .to("salesforce:composite?rawPayload=true")
       .log("${body}");

The route directly creates the body as JSON and directly submit to
salesforce endpoint using `rawPayload=true` option.

With this approach, you have complete control on the Salesforce request.

`POST` is the default HTTP method used to send raw Composite requests to
salesforce. Use the `compositeMethod` option to override to the other
supported value, `GET`, which returns a list of other available
composite resources.

#### Composite Tree

`composite-tree`

Create up to 200 records with parent-child relationships (up to 5
levels) in one go.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>SObjectTree</code></p></td>
<td style="text-align: left;"><p>Contains REST API sub-requests to be
executed.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `SObjectTree`

To create up to 200 records including parent-child relationships use
`salesforce:composite-tree` operation. This requires an instance of
`org.apache.camel.component.salesforce.api.dto.composite.SObjectTree` in
the input message and returns the same tree of objects in the output
message. The
`org.apache.camel.component.salesforce.api.dto.AbstractSObjectBase`
instances within the tree get updated with the identifier values (`Id`
property) or their corresponding
`org.apache.camel.component.salesforce.api.dto.composite.SObjectNode` is
populated with `errors` on failure.

Note that for some records operation can succeed and for some it can
fail — so you need to manually check for errors.

The easiest way to use this functionality is to use the DTOs generated
by the `camel-salesforce-maven-plugin`, but you also have the option of
customizing the references that identify each object in the tree, for
instance primary keys from your database.

Let’s look at an example:

    Account account = ...
    Contact president = ...
    Contact marketing = ...
    
    Account anotherAccount = ...
    Contact sales = ...
    Asset someAsset = ...
    
    // build the tree
    SObjectTree request = new SObjectTree();
    request.addObject(account).addChildren(president, marketing);
    request.addObject(anotherAccount).addChild(sales).addChild(someAsset);
    
    final SObjectTree response = template.requestBody("salesforce:composite-tree", tree, SObjectTree.class);
    final Map<Boolean, List<SObjectNode>> result = response.allNodes()
                                                       .collect(Collectors.groupingBy(SObjectNode::hasErrors));
    
    final List<SObjectNode> withErrors = result.get(true);
    final List<SObjectNode> succeeded = result.get(false);
    
    final String firstId = succeeded.get(0).getId();

#### Composite Batch

`composite-batch`

Submit a composition of requests in batch. Executes up to 25
sub-requests in a single request.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>SObjectBatch</code></p></td>
<td style="text-align: left;"><p>Contains sub-requests to be
executed.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `SObjectBatchResponse`

The Composite API batch operation allows you to accumulate multiple
requests in a batch and then submit them in one go, saving the round
trip cost of multiple individual requests. Each response is then
received in a list of responses with the order preserved, so that the
n-th requests response is in the n-th place of the response.

The results can vary from API to API so the result of each sub-request
(`SObjectBatchResult.result`) is given as a `java.lang.Object`. In most
cases the result will be a `java.util.Map` with string keys and values
or other `java.util.Map` as value. Requests are made in JSON format and
hold some type information (i.e., it is known what values are strings
and what values are numbers).

Let’s look at an example:

    final String acountId = ...
    final SObjectBatch batch = new SObjectBatch("53.0");
    
    final Account updates = new Account();
    updates.setName("NewName");
    batch.addUpdate("Account", accountId, updates);
    
    final Account newAccount = new Account();
    newAccount.setName("Account created from Composite batch API");
    batch.addCreate(newAccount);
    
    batch.addGet("Account", accountId, "Name", "BillingPostalCode");
    
    batch.addDelete("Account", accountId);
    
    final SObjectBatchResponse response = template.requestBody("salesforce:composite-batch", batch, SObjectBatchResponse.class);
    
    boolean hasErrors = response.hasErrors(); // if any of the requests has resulted in either 4xx or 5xx HTTP status
    final List<SObjectBatchResult> results = response.getResults(); // results of three operations sent in batch
    
    final SObjectBatchResult updateResult = results.get(0); // update result
    final int updateStatus = updateResult.getStatusCode(); // probably 204
    final Object updateResultData = updateResult.getResult(); // probably null
    
    final SObjectBatchResult createResult = results.get(1); // create result
    @SuppressWarnings("unchecked")
    final Map<String, Object> createData = (Map<String, Object>) createResult.getResult();
    final String newAccountId = createData.get("id"); // id of the new account, this is for JSON, for XML it would be createData.get("Result").get("id")
    
    final SObjectBatchResult retrieveResult = results.get(2); // retrieve result
    @SuppressWarnings("unchecked")
    final Map<String, Object> retrieveData = (Map<String, Object>) retrieveResult.getResult();
    final String accountName = retrieveData.get("Name"); // Name of the retrieved account, this is for JSON, for XML it would be createData.get("Account").get("Name")
    final String accountBillingPostalCode = retrieveData.get("BillingPostalCode"); // Name of the retrieved account, this is for JSON, for XML it would be createData.get("Account").get("BillingPostalCode")
    
    final SObjectBatchResult deleteResult = results.get(3); // delete result
    final int updateStatus = deleteResult.getStatusCode(); // probably 204
    final Object updateResultData = deleteResult.getResult(); // probably null

#### Retrieve Multiple Records with Fewer Round-Trips

`compositeRetrieveSObjectCollections`

Retrieve one or more records of the same object type.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>sObjectIds</p></td>
<td style="text-align: left;"><p>List of String or comma-separated
string</p></td>
<td style="text-align: left;"><p>A list of one or more IDs of the
objects to return. All IDs must belong to the same object type.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sObjectFields</p></td>
<td style="text-align: left;"><p>List of String or comma-separated
string</p></td>
<td style="text-align: left;"><p>A list of fields to include in the
response. The field names you specify must be valid, and you must have
read-level permissions to each field.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>sObjectName</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Type of SObject, e.g.
<code>Account</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sObjectClass</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Fully qualified class name of DTO class
to use for deserializing the response.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>sObjectName</code>
parameter does not resolve to a class that exists in the package
specified by the <code>package</code> option.</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `List` of class determined by `sObjectName` or `sObjectClass`
header

#### Create SObject Collections

`compositeCreateSObjectCollections`

Add up to 200 records. Mixed SObject types is supported.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p>List of <code>SObject</code></p></td>
<td style="text-align: left;"><p>A list of SObjects to create</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>allOrNone</code></p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>Indicates whether to roll back the
entire request when the creation of any object fails (true) or to
continue with the independent creation of other objects in the
request.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `List<SaveSObjectResult>`

#### Update SObject Collections

`compositeUpdateSObjectCollections`

Update up to 200 records. Mixed SObject types is supported.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p>List of <code>SObject</code></p></td>
<td style="text-align: left;"><p>A list of SObjects to update</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>allOrNone</code></p></td>
<td style="text-align: left;"><p><code>boolean</code></p></td>
<td style="text-align: left;"><p>Indicates whether to roll back the
entire request when the update of any object fails (true) or to continue
with the independent update of other objects in the request.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `List<SaveSObjectResult>`

#### Upsert SObject Collections

`compositeUpsertSObjectCollections`

Create or update (upsert) up to 200 records based on an external ID
field. Mixed SObject types is not supported.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p>List of <code>SObject</code></p></td>
<td style="text-align: left;"><p>A list of SObjects to upsert</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>allOrNone</code></p></td>
<td style="text-align: left;"><p><code>boolean</code></p></td>
<td style="text-align: left;"><p>Indicates whether to roll back the
entire request when the upsert of any object fails (true) or to continue
with the independent upsert of other objects in the request.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Type of SObject, e.g.
<code>Account</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectIdName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of External ID field</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `List<UpsertSObjectResult>`

#### Delete SObject Collections

`compositeDeleteSObjectCollections`

Delete up to 200 records. Mixed SObject types is supported.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectIds</code> or request
body</p></td>
<td style="text-align: left;"><p>List of String or comma-separated
string</p></td>
<td style="text-align: left;"><p>A list of up to 200 IDs of objects to
be deleted.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>allOrNone</code></p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>Indicates whether to roll back the
entire request when the deletion of any object fails (true) or to
continue with the independent deletion of other objects in the
request.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `List<DeleteSObjectResult>`

#### Get Event Schema

`getEventSchema`

Gets the definition of a Platform Event in JSON format. Other types of
events such as Change Data Capture events or custom events are also
supported. This operation is available in REST API version 40.0 and
later.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>eventName</code></p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Name of event</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p><code>eventName</code> or
<code>eventSchemaId</code> is required</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>eventSchemaId</code></p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>ID of a schema</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p><code>eventName</code> or
<code>eventSchemaId</code> is required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>eventSchemaFormat</code></p></td>
<td style="text-align: left;"><p>EventSchemaFormatEnum</p></td>
<td style="text-align: left;"><p><code>EXPANDED</code>: Apache Avro
format but doesn’t strictly adhere to the record complex type.
<code>COMPACT</code>: Apache Avro, adheres to the specification for the
record complex type. This parameter is available in API version 43.0 and
later.</p></td>
<td style="text-align: left;"><p><code>EXPANDED</code></p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `InputStream`

### Apex REST API

#### Invoke an Apex REST Web Service method

`apexCall`

You can [expose your Apex class and
methods](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_rest_intro.htm)
so that external applications can access your code and your application
through the REST architecture.

The URI format for invoking Apex REST is:

    salesforce:apexCall[/yourApexRestUrl][?options]

You can supply the apexUrl either in the endpoint (see above), or as the
`apexUrl` option as listed in the table below. In either case the Apex
URL can contain placeholders in the format of `{headerName}`. E.g., for
the Apex URL `MyApexClass/{id}`, the value of the header named `id` will
be used to replace the placeholder. If `rawPayload` is false and neither
`sObjectClass` nor `sObjectName` are set, Camel will attempt to
determine the correct `AbstractQueryRecordsBase` sublcass based on the
response.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>Map&lt;String, Object&gt;</code>
if <code>GET</code>, otherwise <code>String</code> or
<code>InputStream</code></p></td>
<td style="text-align: left;"><p>In the case of a <code>GET</code>, the
body (<code>Map</code> instance) is transformed into query parameters.
For other HTTP methods, the body is used for the HTTP body.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>apexUrl</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The portion of the endpoint URL after
<code>https://instance.salesforce.com/services/apexrest/</code>, e.g.,
<em>MyApexClass/</em></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Yes, unless supplied in
endpoint</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>apexMethod</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The HTTP method (e.g. <code>GET</code>,
<code>POST</code>) to use.</p></td>
<td style="text-align: left;"><p><code>GET</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>rawPayload</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, Camel will not serialize the
request or response bodies.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Header:
<code>apexQueryParam.[paramName]</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Headers that override apex parameters
passed in the endpoint.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of sObject (e.g.
<code>Merchandise__c</code>) used to deserialize the response</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectClass</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Fully qualified class name used to
deserialize the response</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: Instance of class supplied in `sObjectClass` input header.

### Bulk 2.0 API

The Bulk 2.0 API has a simplified model over the original Bulk API. Use
it to quickly load a large amount of data into salesforce, or query a
large amount of data out of salesforce. Data must be provided in CSV
format, usually via an `InputStream` instance. PK chunking is performed
automatically. The minimum API version for Bulk 2.0 is v41.0. The
minimum API version for Bulk Queries is v47.0. DTO classes mentioned
below are from the
`org.apache.camel.component.salesforce.api.dto.bulkv2` package. The
following operations are supported:

-   [bulk2CreateJob](#bulk2CreateJob) - Creates a bulk ingest job.

-   [bulk2CreateBatch](#bulk2CreateBatch) - Adds a batch of data to an
    ingest job.

-   [bulk2CloseJob](#bulk2CloseJob) - Closes an ingest job.

-   [bulk2AbortJob](#bulk2AbortJob) - Aborts an ingest job.

-   [bulk2DeleteJob](#bulk2DeleteJob) - Deletes an ingest job.

-   [bulk2GetSuccessfulResults](#bulk2GetSuccessfulResults) - Gets
    successful results for an ingest job.

-   [bulk2GetFailedResults](#bulk2GetFailedResults) - Gets failed
    results for an ingest job.

-   [bulk2GetUnprocessedRecords](#bulk2GetUnprocessedRecords) - Gets
    unprocessed records for an ingest job.

-   [bulk2GetJob](#bulk2GetJob) - Gets an ingest Job.

-   [bulk2GetAllJobs](#bulk2GetAllJobs) - Gets all ingest jobs.

-   [bulk2CreateQueryJob](#bulk2CreateQueryJob) - Creates a query job.

-   [bulk2GetQueryJobResults](#bulk2GetQueryJobResults) - Gets query job
    results.

-   [bulk2AbortQueryJob](#bulk2AbortQueryJob) - Aborts a query job.

-   [bulk2DeleteQueryJob](#bulk2DeleteQueryJob) - Deletes a query job.

-   [bulk2GetQueryJob](#bulk2GetQueryJob) - Gets a query job.

-   [bulk2GetAllQueryJobs](#bulk2GetAllQueryJobs) - Gets all query jobs.

#### Create a Job

`bulk2CreateJob` Creates a bulk ingest job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>Job</code></p></td>
<td style="text-align: left;"><p>Job to create</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `Job`

#### Upload a Batch of Job Data

`bulk2CreateBatch`

Adds a batch of data to an ingest job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>InputStream</code> or
<code>String</code></p></td>
<td style="text-align: left;"><p>CSV data. The first row must contain
headers.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>jobId</code> not
supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to create batch
under</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

#### Close a Job

`bulk2CloseJob`

Closes an ingest job. You must close the job in order for it to be
processed or aborted/deleted.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to close</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `Job`

#### Abort a Job

`bulk2AbortJob`

Aborts an ingest job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to abort</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `Job`

#### Delete a Job

`bulk2DeleteJob`

Deletes an ingest job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to delete</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

#### Get Job Successful Record Results

`bulk2GetSuccessfulResults`

Gets successful results for an ingest job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to get results for</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `InputStream`  
Contents: CSV data

#### Get Job Failed Record Results

`bulk2GetFailedResults`

Gets failed results for an ingest job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to get results for</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `InputStream`  
Contents: CSV data

#### Get Job Unprocessed Record Results

`bulk2GetUnprocessedRecords`

Gets unprocessed records for an ingest job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to get records for</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `InputStream` Contents: CSV data

#### Get Job Info

`bulk2GetJob`

Gets an ingest Job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>Job</code></p></td>
<td style="text-align: left;"><p>Will use Id of supplied Job to retrieve
Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>jobId</code> not
supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to retrieve</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>Job</code> not
supplied in body</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `Job`

#### Get All Jobs

`bulk2GetAllJobs`

Gets all ingest jobs.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>queryLocator</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Used in subsequent calls if results
span multiple pages</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `Jobs`

If the `done` property of the `Jobs` instance is false, there are
additional pages to fetch, and the `nextRecordsUrl` property contains
the value to be set in the `queryLocator` parameter on subsequent calls.

#### Create a Query Job

`bulk2CreateQueryJob`

Gets a query job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>QueryJob</code></p></td>
<td style="text-align: left;"><p>QueryJob to create</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `QueryJob`

#### Get Results for a Query Job

`bulk2GetQueryJobResults`

Get bulk query job results. `jobId` parameter is required. Accepts
`maxRecords` and `locator` parameters.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to get results for</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>maxRecords</code></p></td>
<td style="text-align: left;"><p><code>Integer</code></p></td>
<td style="text-align: left;"><p>The maximum number of records to
retrieve per set of results for the query. The request is still subject
to the size limits. If you are working with a very large number of query
results, you may experience a timeout before receiving all the data from
Salesforce. To prevent a timeout, specify the maximum number of records
your client is expecting to receive in the maxRecords parameter. This
splits the results into smaller sets with this value as the maximum
size.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>locator</code></p></td>
<td style="text-align: left;"><p><code>locator</code></p></td>
<td style="text-align: left;"><p>A string that identifies a specific set
of query results. Providing a value for this parameter returns only that
set of results. Omitting this parameter returns the first set of
results.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `InputStream` Contents: CSV data

Response message headers include `Sforce-NumberOfRecords` and
`Sforce-Locator` headers. The value of `Sforce-Locator` can be passed
into subsequent calls via the `locator` parameter.

#### Abort a Query Job

`bulk2AbortQueryJob`

Aborts a query job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to abort</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `QueryJob`

#### Delete a Query Job

`bulk2DeleteQueryJob`

Deletes a query job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to delete</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

#### Get Information About a Query Job

`bulk2GetQueryJob`

Gets a query job.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to retrieve</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `QueryJob`

#### Get Information About All Query Jobs

`bulk2GetAllQueryJobs`

Gets all query jobs.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>queryLocator</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Used in subsequent calls if results
span multiple pages</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `QueryJobs`

If the `done` property of the `QueryJobs` instance is false, there are
additional pages to fetch, and the `nextRecordsUrl` property contains
the value to be set in the `queryLocator` parameter on subsequent calls.

### Bulk (original) API

Producer endpoints can use the following APIs. All Job data formats,
i.e. xml, csv, zip/xml, and zip/csv are supported.  
The request and response have to be marshalled/unmarshalled by the
route. Usually the request will be some stream source like a CSV file,
and the response may also be saved to a file to be correlated with the
request.

The following operations are supported:

-   [createJob](#createJob) - Creates a Salesforce Bulk Job.

-   [getJob](#getJob) - Gets a Job using its Salesforce Id

-   [closeJob](#closeJob) - Closes a Job

-   [abortJob](#abortJob) - Aborts a Job

-   [createBatch](#createBatch) - Submits a Batch within a Bulk Job

-   [getBatch](#getBatch) - Gets a Batch using Id

-   [getAllBatches](#getAllBatches) - Gets all Batches for a Bulk Job Id

-   [getRequest](#getRequest) - Gets Request data (XML/CSV) for a Batch

-   [getResults](#getResults) - Gets the results of the Batch when its
    complete

-   [createBatchQuery](#createBatchQuery) - Creates a Batch from an SOQL
    query

-   [getQueryResultIds](#getQueryResultIds) - Gets a list of Result Ids
    for a Batch Query

-   [getQueryResult](#getQueryResult) - Gets results for a Result Id

#### Create a Job

`createJob`

Creates a Salesforce Bulk Job. PK Chunking is supported via the
pkChunking\* options. See an explanation
[here](https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/async_api_headers_enable_pk_chunking.htm).

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>JobInfo</code></p></td>
<td style="text-align: left;"><p>Job to create</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>pkChunking</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Whether to use PK Chunking</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>pkChunkingChunkSize</code></p></td>
<td style="text-align: left;"><p><code>Integer</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>pkChunkingStartRow</code></p></td>
<td style="text-align: left;"><p><code>Integer</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>pkChunkingParent</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `JobInfo`

#### Get Job Details

`getJob`

Gets a Job

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job to get</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>JobInfo</code></p></td>
<td style="text-align: left;"><p><code>JobInfo</code> instance from
which Id will be used</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>jobId</code> not
supplied</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `JobInfo`

#### Close a Job

`closeJob`

Closes a Job

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>JobInfo</code></p></td>
<td style="text-align: left;"><p><code>JobInfo</code> instance from
which Id will be used</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>jobId</code> not
supplied</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `JobInfo`

#### Abort a Job

`abortJob`

Aborts a Job

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>JobInfo</code></p></td>
<td style="text-align: left;"><p><code>JobInfo</code> instance from
which Id will be used</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>jobId</code> not
supplied</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `JobInfo`

#### Add a Batch to a Job

`createBatch`

Submits a Batch within a Bulk Job

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>contentType</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Content type of body. Can be XML, CSV,
ZIP_XML or ZIP_CSV</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>Body</code></p></td>
<td style="text-align: left;"><p><code>InputStream</code> or
<code>String</code></p></td>
<td style="text-align: left;"><p>Batch data</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `BatchInfo`

#### Get Information for a Batch

`getBatch`

Get a Batch

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>batchId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Batch</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>BatchInfo</code></p></td>
<td style="text-align: left;"><p><code>JobInfo</code> instance from
which <code>jobId</code> and <code>batchId</code> will be used</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>jobId</code> and
<code>BatchId</code> not supplied</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `BatchInfo`

#### Get Information for All Batches in a Job

`getAllBatches`

Gets all Batches for a Bulk Job Id

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>JobInfo</code></p></td>
<td style="text-align: left;"><p><code>JobInfo</code> instance from
which Id will be used</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>jobId</code> not
supplied</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `List<JobInfo>`

#### Get a Batch Request

`getRequest`

Gets Request data (XML/CSV) for a Batch

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>batchId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Batch</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>BatchInfo</code></p></td>
<td style="text-align: left;"><p><code>JobInfo</code> instance from
which <code>jobId</code> and <code>batchId</code> will be used</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>jobId</code> and
<code>BatchId</code> not supplied</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `InputStream`

#### Get Batch Results

`getResults`

Gets the results of the Batch when it’s complete

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>batchId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Batch</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>BatchInfo</code></p></td>
<td style="text-align: left;"><p><code>JobInfo</code> instance from
which <code>jobId</code> and <code>batchId</code> will be used</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>jobId</code> and
<code>BatchId</code> not supplied</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `InputStream`

#### Create Bulk Query Batch

`createBatchQuery`

Creates a Batch from an SOQL query

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>contentType</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Content type of body. Can be XML, CSV,
ZIP_XML or ZIP_CSV</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>JobInfo</code>
instance not supplied in body</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectQuery</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>SOQL query to be used for this
batch</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>JobInfo</code> or
<code>String</code></p></td>
<td style="text-align: left;"><p>Either <code>JobInfo</code> instance
from which <code>jobId</code> and <code>contentType</code> will be used,
or <code>String</code> to be used as the Batch query</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required <code>JobInfo</code> if
<code>jobId</code> and <code>contentType</code> not supplied.</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `BatchInfo`

#### Get Batch Results

`getQueryResultIds`

Gets a list of Result Ids for a Batch Query

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>batchId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Batch</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>BatchInfo</code></p></td>
<td style="text-align: left;"><p><code>JobInfo</code> instance from
which <code>jobId</code> and <code>batchId</code> will be used</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if <code>jobId</code> and
<code>BatchId</code> not supplied</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `List<String>`

#### Get Bulk Query Results

`getQueryResult`

Gets results for a Result Id

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jobId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Job</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>batchId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Batch</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if body not supplied</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>resultId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Result</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If not passed in body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>BatchInfo</code> or
<code>String</code></p></td>
<td style="text-align: left;"><p><code>JobInfo</code> instance from
which <code>jobId</code> and <code>batchId</code> will be used.
Otherwise, can be a <code>String</code> containing the
<code>resultId</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p><code>BatchInfo</code> Required if
<code>jobId</code> and <code>BatchId</code> not supplied</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `InputStream`

For example, the following producer endpoint uses the createBatch API to
create a Job Batch. The in message must contain a body that can be
converted into an `InputStream` (usually UTF-8 CSV or XML content from a
file, etc.) and header fields *jobId* for the Job and *contentType* for
the Job content type, which can be XML, CSV, ZIP\_XML or ZIP\_CSV. The
put message body will contain `BatchInfo` on success, or throw a
`SalesforceException` on error.

    ...to("salesforce:createBatch")..

### Pub/Sub API

The Pub/Sub API allows you to publish and subscribe to platform events,
including real-time event monitoring events, and change data capture
events. This API is based on gRPC and HTTP/2, and event payloads are
delivered in Apache Avro format.

#### Publishing Events

The URI format for publishing events is:

    salesforce:pubSubPublish:<topic_name>

For example:

    .to("salesforce:pubsubPublish:/event/MyCustomPlatformEvent__e")

#### Publish an Event

`pubSubPublish`

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>List</code>. List can contained
mixed types (see description below).</p></td>
<td style="text-align: left;"><p>Event payloads to be published</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

Because The Pub/Sub API requires that event payloads be serialized in
Apache Avro format, Camel will attempt to serialize event payloads from
the following input types:

-   Avro `GenericRecord`. Camel fetches the Avro schema in order to
    serialize `GenericRecord` instances. This option doesn’t require
    ahead-of-time generation of Event classes.

-   Avro `SpecificRecord`. Subclasses of `SpecificRecord` contain
    properties that are specific to an event type. The [maven
    plugin](#MavenPlugin) can generate the subclasses automatically.

-   POJO. Camel fetches the Avro schema in order to serialize POJO
    instances. The POJO’s field names must match event field names
    exactly, including case.

-   `String`. Camel will treat the `String` value as JSON and serialize
    to Avro. Note that the JSON value does not have to be Avro-encoded
    JSON. It can be arbitrary JSON, but it must be serializable to Avro
    based on the Schema associated with the topic you’re publishing to.
    The JSON object’s field names must match event field names exactly,
    including case.

-   `byte[]`. Camel will not perform any serialization. Value must be
    the Avro-encoded event payload.

-   `com.salesforce.eventbus.protobuf.ProducerEvent`. Providing a
    `ProducerEvent` allows full control, e.g., setting the `id`
    property, which can be tied back to the
    `PublishResult.CorrelationKey`.

**Output**

Type:
`List<org.apache.camel.component.salesforce.api.dto.pubsub.PublishResult>`

The order of the items in the returned `List` correlates to the order of
the items in the input `List`.

#### Subscribing

The URI format for subscribing to a Pub/Sub topic is:

    salesforce:pubSubSubscribe:<topic_name>

For example:

    from("salesforce:pubSubSubscribe:/event/BatchApexErrorEvent")

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>replayPreset</code></p></td>
<td style="text-align: left;"><p><code>ReplayPreset</code></p></td>
<td style="text-align: left;"><p>Values: <code>LATEST</code>,
<code>EARLIEST</code>, <code>CUSTOM</code>.</p></td>
<td style="text-align: left;"><p><code>LATEST</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>pubSubReplayId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>When <code>replayPreset</code> is set
to <code>CUSTOM</code>, the replayId to use when subscribing to a
topic.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>pubSubBatchSize</code></p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"><p>Max number of events to receive at a
time. Values &gt;100 will be normalized to 100 by salesforce.</p></td>
<td style="text-align: left;"><p>100</p></td>
<td style="text-align: left;"><p>X</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>pubSubDeserializeType</code></p></td>
<td
style="text-align: left;"><p><code>PubSubDeserializeType</code></p></td>
<td style="text-align: left;"><p>Values: <code>AVRO</code>,
<code>SPECIFIC_RECORD</code>, <code>GENERIC_RECORD</code>,
<code>POJO</code>, <code>JSON</code>. <code>AVRO</code> will try a
<code>SpecificRecord</code> subclass if found, otherwise
<code>GenericRecord</code></p></td>
<td style="text-align: left;"><p><code>AVRO</code></p></td>
<td style="text-align: left;"><p>X</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>pubSubPojoClass</code></p></td>
<td style="text-align: left;"><p>Fully qualified class name to
deserialize Pub/Sub API event to.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>If <code>pubSubDeserializeType</code>
is <code>POJO</code></p></td>
</tr>
</tbody>
</table>

**Output**

Type: Determined by the `pubSubDeserializeType` option.

Headers: `CamelSalesforcePubSubReplayId`

### Streaming API

The Streaming API enables streaming of events using push technology and
provides a subscription mechanism for receiving events in near real
time. The Streaming API subscription mechanism supports multiple types
of events, including PushTopic events, generic events, platform events,
and Change Data Capture events.

#### Push Topics

The URI format for consuming Push Topics is:

    salesforce:subscribe:<topic_name>[?options]

To create and subscribe to a topic

    from("salesforce:subscribe:CamelTestTopic?notifyForFields=ALL&notifyForOperations=ALL&sObjectName=Merchandise__c&updateTopic=true&sObjectQuery=SELECT Id, Name FROM Merchandise__c")...

To subscribe to an existing topic

    from("salesforce:subscribe:CamelTestTopic&sObjectName=Merchandise__c")...

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>sObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>SObject to monitor</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>sObjectQuery</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>SOQL query used to create Push
Topic</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required for creating new
topics</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>updateTopic</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Whether to update an existing Push
Topic if exists</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>notifyForFields</code></p></td>
<td
style="text-align: left;"><p><code>NotifyForFieldsEnum</code></p></td>
<td style="text-align: left;"><p>Specifies how the record is evaluated
against the PushTopic query.</p></td>
<td style="text-align: left;"><p>Referenced</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>notifyForOperationCreate</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Whether a create operation should
generate a notification.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>notifyForOperationDelete</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Whether a delete operation should
generate a notification.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>notifyForOperationUndelete</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Whether an undelete operation should
generate a notification.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>notifyForOperationUpdate</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Whether an update operation should
generate a notification.</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>notifyForOperations</code></p></td>
<td
style="text-align: left;"><p><code>NotifyForOperationsEnum</code></p></td>
<td style="text-align: left;"><p>Whether an update operation should
generate a notification. Only for use in API version &lt; 29.0</p></td>
<td style="text-align: left;"><p>All</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>replayId</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>The replayId value to use when
subscribing.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>defaultReplayId</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>Default replayId setting if no value is
found in initialReplayIdMap.</p></td>
<td style="text-align: left;"><p>-1</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>fallBackReplayId</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>ReplayId to fall back to after an
Invalid Replay Id response.</p></td>
<td style="text-align: left;"><p>-1</p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: Class passed via `sObjectName` parameter

#### Platform Events

To emit a platform event use the [createSObject](#createSObject)
operation, passing an instance of a platform event, e.g.
`Order_Event__e`.

The URI format for consuming platform events is:

    salesforce:subscribe:event/<event_name>

For example, to receive platform events use for the event type
`Order_Event__e`:

    from("salesforce:subscribe:event/Order_Event__e")

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>rawPayload</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If false, operation returns a
<code>PlatformEvent</code>, otherwise returns the raw Bayeux
Message</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>replayId</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>The replayId value to use when
subscribing.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>defaultReplayId</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>Default replayId setting if no value is
found in initialReplayIdMap.</p></td>
<td style="text-align: left;"><p>-1</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>fallBackReplayId</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>ReplayId to fall back to after an
Invalid Replay Id response.</p></td>
<td style="text-align: left;"><p>-1</p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `PlatformEvent` or `org.cometd.bayeux.Message`

#### Change Data Capture Events

Change Data Capture (CDC) allows you to receive near-real-time changes
of Salesforce records, and synchronize corresponding records in an
external data store. Change Data Capture publishes change events, which
represent changes to Salesforce records. Changes include the creation of
a new record, updates to an existing record, deletion of a record, and
undeletion of a record.

The URI format to consume CDC events is as follows:

All Selected Entities

    salesforce:subscribe:data/ChangeEvents

Standard Objects

    salesforce:subscribe:data/<Standard_Object_Name>ChangeEvent

Custom Objects

    salesforce:subscribe:data/<Custom_Object_Name>__ChangeEvent

Here are a few examples

    from("salesforce:subscribe:data/ChangeEvents?replayId=-1").log("being notified of all change events")
    from("salesforce:subscribe:data/AccountChangeEvent?replayId=-1").log("being notified of change events for Account records")
    from("salesforce:subscribe:data/Employee__ChangeEvent?replayId=-1").log("being notified of change events for Employee__c custom object")

More details about how to use the Camel Salesforce component change data
capture capabilities could be found in the
[ChangeEventsConsumerIntegrationTest](https://github.com/apache/camel/tree/main/components/camel-salesforce/camel-salesforce-component/src/test/java/org/apache/camel/component/salesforce/ChangeEventsConsumerIntegrationTest.java).

The [Salesforce developer
guide](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_intro.htm)
is a good fit to better know the subtleties of implementing a change
data capture integration application. The dynamic nature of change event
body fields, high level replication steps as well as security
considerations could be of interest.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>rawPayload</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If false, operation returns a
<code>Map&lt;String, Object&gt;</code>, otherwise returns the raw Bayeux
<code>Message</code></p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>replayId</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>The replayId value to use when
subscribing.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>defaultReplayId</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>Default replayId setting if no value is
found in initialReplayIdMap.</p></td>
<td style="text-align: left;"><p>-1</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>fallBackReplayId</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>ReplayId to fall back to after an
Invalid Replay Id response.</p></td>
<td style="text-align: left;"><p>-1</p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `Map<String, Object>` or `org.cometd.bayeux.Message`

Headers

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Name</p></td>
<td style="text-align: left;"><p>Description</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelSalesforceChangeType</code></p></td>
<td style="text-align: left;"><p><code>CREATE</code>,
<code>UPDATE</code>, <code>DELETE</code> or
<code>UNDELETE</code></p></td>
</tr>
</tbody>
</table>

### Reports API

-   [getRecentReports](#getRecentReports) - Gets up to 200 of the
    reports you most recently viewed.

-   [getReportDescription](#getReportDescription) - Retrieves report
    description.

-   [executeSyncReport](#executeSyncReport) - Runs a report
    synchronously.

-   [executeAsyncReport](#executeAsyncReport) - Runs a report
    asynchronously.

-   [getReportInstances](#getReportInstances) - Returns a list of
    instances for a report that you requested to be run asynchronously.

-   [getReportResults](#getReportResults) - Retrieves results for an
    instance of a report run asynchronously.

#### Report List

`getRecentReports`

Gets up to 200 of the reports you most recently viewed.

**Output**

Type: `List<RecentReport>`

#### Describe Report

`getReportDescription`

Retrieves the report, report type, and related metadata for a report,
either in a tabular or summary or matrix format.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>reportId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Report</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Report</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
<code>reportId</code> parameter</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `ReportDescription`

#### Execute Sync

`executeSyncReport`

Runs a report synchronously with or without changing filters and returns
the latest summary data.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>reportId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Report</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>includeDetails</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Whether to include details</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>reportMetadata</code></p></td>
<td style="text-align: left;"><p><code>ReportMetadata</code></p></td>
<td style="text-align: left;"><p>Optionally, pass ReportMetadata here
instead of body</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>ReportMetadata</code></p></td>
<td style="text-align: left;"><p>If supplied, will use instead of
<code>reportId</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
<code>reportId</code> parameter</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `AbstractReportResultsBase`

#### Execute Async

`executeAsyncReport`

Runs an instance of a report asynchronously with or without filters and
returns the summary data with or without details.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>reportId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Report</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>includeDetails</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Whether to include details</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>reportMetadata</code></p></td>
<td style="text-align: left;"><p><code>ReportMetadata</code></p></td>
<td style="text-align: left;"><p>Optionally, pass ReportMetadata here
instead of body</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>ReportMetadata</code></p></td>
<td style="text-align: left;"><p>If supplied, will use instead of
<code>reportId</code> parameter</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
<code>reportId</code> parameter</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `ReportInstance`

#### Instances List

`getReportInstances`

Returns a list of instances for a report that you requested to be run
asynchronously. Each item in the list is treated as a separate instance
of the report.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>reportId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Report</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>If supplied, will use instead of
<code>reportId</code> parameter</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
<code>reportId</code> parameter</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `List<ReportInstance>`

#### Instance Results

`getReportResults`

Contains the results of running a report.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>reportId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Report</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>instanceId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Id of Report instance</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>If supplied, will use instead of
<code>reportId</code> parameter</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required if not supplied in
<code>reportId</code> parameter</p></td>
</tr>
</tbody>
</table>

**Output**

Type: `AbstractReportResultsBase`

## Miscellaneous Operations

-   [raw](#raw) - Send requests to salesforce and have full, raw control
    over endpoint, parameters, body, etc.

### Raw

`raw`

Sends HTTP requests to salesforce with full, raw control of all aspects
of the call. Any serialization or deserialization of request and
response bodies must be performed in the route. The `Content-Type` HTTP
header will be automatically set based on the `format` option, but this
can be overridden with the `rawHttpHeaders` option.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Default</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Body</p></td>
<td style="text-align: left;"><p><code>String</code> or
<code>InputStream</code></p></td>
<td style="text-align: left;"><p>Body of the HTTP request</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>rawPath</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The portion of the endpoint URL after
the domain name, e.g.,
<em>/services/data/v51.0/sobjects/Account/</em></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>rawMethod</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The HTTP method</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>x</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>rawQueryParameters</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Comma separated list of message headers
to include as query parameters. Do not url-encode values as this will be
done automatically.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>rawHttpHeaders</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Comma separated list of message headers
to include as HTTP headers</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

**Output**

Type: `InputStream`

#### Query example

In this example we’ll send a query to the REST API. The query must be
passed in a URL parameter called "q", so we’ll create a message header
called q and tell the raw operation to include that message header as a
URL parameter:

    from("direct:queryExample")
      .setHeader("q", "SELECT Id, LastName FROM Contact")
      .to("salesforce:raw?format=JSON&rawMethod=GET&rawQueryParameters=q&rawPath=/services/data/v51.0/query")
      // deserialize JSON results or handle in some other way

#### SObject example

In this example, we’ll pass a Contact the REST API in a `create`
operation. Since the `raw` operation does not perform any serialization,
we make sure to pass XML in the message body

    from("direct:createAContact")
      .setBody(constant("<Contact><LastName>TestLast</LastName></Contact>"))
      .to("salesforce:raw?format=XML&rawMethod=POST&rawPath=/services/data/v51.0/sobjects/Contact")

The response is:

    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <Result>
        <id>0034x00000RnV6zAAF</id>
        <success>true</success>
    </Result>

## Uploading a document to a ContentWorkspace

Create the ContentVersion in Java, using a Processor instance:

    public class ContentProcessor implements Processor {
        public void process(Exchange exchange) throws Exception {
            Message message = exchange.getIn();
    
            ContentVersion cv = new ContentVersion();
            ContentWorkspace cw = getWorkspace(exchange);
            cv.setFirstPublishLocationId(cw.getId());
            cv.setTitle("test document");
            cv.setPathOnClient("test_doc.html");
            byte[] document = message.getBody(byte[].class);
            ObjectMapper mapper = new ObjectMapper();
            String enc = mapper.convertValue(document, String.class);
            cv.setVersionDataUrl(enc);
            message.setBody(cv);
        }
    
        protected ContentWorkspace getWorkSpace(Exchange exchange) {
            // Look up the content workspace somehow, maybe use enrich() to add it to a
            // header that can be extracted here
            ....
        }
    }

Give the output from the processor to the Salesforce component:

    from("file:///home/camel/library")
        .to(new ContentProcessor())     // convert bytes from the file into a ContentVersion SObject
                                        // for the salesforce component
        .to("salesforce:createSObject");

## Generating SOQL query strings

`org.apache.camel.component.salesforce.api.utils.QueryHelper` contains
helper methods to generate SOQL queries. For instance, to fetch all
custom fields from *Account* SObject, you can generate the SOQL SELECT
by invoking:

    String allCustomFieldsQuery = QueryHelper.queryToFetchFilteredFieldsOf(new Account(), SObjectField::isCustom);

## Camel Salesforce Maven Plugin

The Maven plugin generates Java DTOs to represent salesforce objects.

Please refer to
[README.md](https://github.com/apache/camel/tree/main/components/camel-salesforce/camel-salesforce-maven-plugin)
for details on how to use the plugin.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apexMethod|APEX method name||string|
|apexQueryParams|Query params for APEX method||object|
|apiVersion|Salesforce API version.|56.0|string|
|backoffIncrement|Backoff interval increment for Streaming connection restart attempts for failures beyond CometD auto-reconnect.|1000|duration|
|batchId|Bulk API Batch ID||string|
|contentType|Bulk API content type, one of XML, CSV, ZIP\_XML, ZIP\_CSV||object|
|defaultReplayId|Default replayId setting if no value is found in initialReplayIdMap|-1|integer|
|fallBackReplayId|ReplayId to fall back to after an Invalid Replay Id response|-1|integer|
|format|Payload format to use for Salesforce API calls, either JSON or XML, defaults to JSON. As of Camel 3.12, this option only applies to the Raw operation.||object|
|httpClient|Custom Jetty Http Client to use to connect to Salesforce.||object|
|httpClientConnectionTimeout|Connection timeout used by the HttpClient when connecting to the Salesforce server.|60000|integer|
|httpClientIdleTimeout|Timeout used by the HttpClient when waiting for response from the Salesforce server.|10000|integer|
|httpMaxContentLength|Max content length of an HTTP response.||integer|
|httpRequestBufferSize|HTTP request buffer size. May need to be increased for large SOQL queries.|8192|integer|
|httpRequestTimeout|Timeout value for HTTP requests.|60000|integer|
|includeDetails|Include details in Salesforce1 Analytics report, defaults to false.||boolean|
|initialReplayIdMap|Replay IDs to start from per channel name.||object|
|instanceId|Salesforce1 Analytics report execution instance ID||string|
|jobId|Bulk API Job ID||string|
|limit|Limit on number of returned records. Applicable to some of the API, check the Salesforce documentation.||integer|
|locator|Locator provided by salesforce Bulk 2.0 API for use in getting results for a Query job.||string|
|maxBackoff|Maximum backoff interval for Streaming connection restart attempts for failures beyond CometD auto-reconnect.|30000|duration|
|maxRecords|The maximum number of records to retrieve per set of results for a Bulk 2.0 Query. The request is still subject to the size limits. If you are working with a very large number of query results, you may experience a timeout before receiving all the data from Salesforce. To prevent a timeout, specify the maximum number of records your client is expecting to receive in the maxRecords parameter. This splits the results into smaller sets with this value as the maximum size.||integer|
|notFoundBehaviour|Sets the behaviour of 404 not found status received from Salesforce API. Should the body be set to NULL NotFoundBehaviour#NULL or should a exception be signaled on the exchange NotFoundBehaviour#EXCEPTION - the default.|EXCEPTION|object|
|notifyForFields|Notify for fields, options are ALL, REFERENCED, SELECT, WHERE||object|
|notifyForOperationCreate|Notify for create operation, defaults to false (API version \&gt;= 29.0)||boolean|
|notifyForOperationDelete|Notify for delete operation, defaults to false (API version \&gt;= 29.0)||boolean|
|notifyForOperations|Notify for operations, options are ALL, CREATE, EXTENDED, UPDATE (API version \&lt; 29.0)||object|
|notifyForOperationUndelete|Notify for un-delete operation, defaults to false (API version \&gt;= 29.0)||boolean|
|notifyForOperationUpdate|Notify for update operation, defaults to false (API version \&gt;= 29.0)||boolean|
|objectMapper|Custom Jackson ObjectMapper to use when serializing/deserializing Salesforce objects.||object|
|packages|In what packages are the generated DTO classes. Typically the classes would be generated using camel-salesforce-maven-plugin. Set it if using the generated DTOs to gain the benefit of using short SObject names in parameters/header values. Multiple packages can be separated by comma.||string|
|pkChunking|Use PK Chunking. Only for use in original Bulk API. Bulk 2.0 API performs PK chunking automatically, if necessary.||boolean|
|pkChunkingChunkSize|Chunk size for use with PK Chunking. If unspecified, salesforce default is 100,000. Maximum size is 250,000.||integer|
|pkChunkingParent|Specifies the parent object when you're enabling PK chunking for queries on sharing objects. The chunks are based on the parent object's records rather than the sharing object's records. For example, when querying on AccountShare, specify Account as the parent object. PK chunking is supported for sharing objects as long as the parent object is supported.||string|
|pkChunkingStartRow|Specifies the 15-character or 18-character record ID to be used as the lower boundary for the first chunk. Use this parameter to specify a starting ID when restarting a job that failed between batches.||string|
|queryLocator|Query Locator provided by salesforce for use when a query results in more records than can be retrieved in a single call. Use this value in a subsequent call to retrieve additional records.||string|
|rawPayload|Use raw payload String for request and response (either JSON or XML depending on format), instead of DTOs, false by default|false|boolean|
|reportId|Salesforce1 Analytics report Id||string|
|reportMetadata|Salesforce1 Analytics report metadata for filtering||object|
|resultId|Bulk API Result ID||string|
|sObjectBlobFieldName|SObject blob field name||string|
|sObjectClass|Fully qualified SObject class name, usually generated using camel-salesforce-maven-plugin||string|
|sObjectFields|SObject fields to retrieve||string|
|sObjectId|SObject ID if required by API||string|
|sObjectIdName|SObject external ID field name||string|
|sObjectIdValue|SObject external ID field value||string|
|sObjectName|SObject name if required or supported by API||string|
|sObjectQuery|Salesforce SOQL query string||string|
|sObjectSearch|Salesforce SOSL search string||string|
|streamQueryResult|If true, streams SOQL query result and transparently handles subsequent requests if there are multiple pages. Otherwise, results are returned one page at a time.|false|boolean|
|updateTopic|Whether to update an existing Push Topic when using the Streaming API, defaults to false|false|boolean|
|config|Global endpoint configuration - use to set values that are common to all endpoints||object|
|httpClientProperties|Used to set any properties that can be configured on the underlying HTTP client. Have a look at properties of SalesforceHttpClient and the Jetty HttpClient for all available options.||object|
|longPollingTransportProperties|Used to set any properties that can be configured on the LongPollingTransport used by the BayeuxClient (CometD) used by the streaming api||object|
|workerPoolMaxSize|Maximum size of the thread pool used to handle HTTP responses.|20|integer|
|workerPoolSize|Size of the thread pool used to handle HTTP responses.|10|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|pubSubBatchSize|Max number of events to receive in a batch from the Pub/Sub API.|100|integer|
|pubSubDeserializeType|How to deserialize events consume from the Pub/Sub API. AVRO will try a SpecificRecord subclass if found, otherwise GenericRecord.|AVRO|object|
|pubSubPojoClass|Fully qualified class name to deserialize Pub/Sub API event to.||string|
|replayPreset|Replay preset for Pub/Sub API.|LATEST|object|
|allOrNone|Composite API option to indicate to rollback all records if any are not successful.|false|boolean|
|apexUrl|APEX method URL||string|
|compositeMethod|Composite (raw) method.||string|
|eventName|Name of Platform Event, Change Data Capture Event, custom event, etc.||string|
|eventSchemaFormat|EXPANDED: Apache Avro format but doesn't strictly adhere to the record complex type. COMPACT: Apache Avro, adheres to the specification for the record complex type. This parameter is available in API version 43.0 and later.||object|
|eventSchemaId|The ID of the event schema.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|rawHttpHeaders|Comma separated list of message headers to include as HTTP parameters for Raw operation.||string|
|rawMethod|HTTP method to use for the Raw operation||string|
|rawPath|The portion of the endpoint URL after the domain name. E.g., '/services/data/v52.0/sobjects/Account/'||string|
|rawQueryParameters|Comma separated list of message headers to include as query parameters for Raw operation. Do not url-encode values as this will be done automatically.||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|httpProxyExcludedAddresses|A list of addresses for which HTTP proxy server should not be used.||object|
|httpProxyHost|Hostname of the HTTP proxy server to use.||string|
|httpProxyIncludedAddresses|A list of addresses for which HTTP proxy server should be used.||object|
|httpProxyPort|Port number of the HTTP proxy server to use.||integer|
|httpProxySocks4|If set to true the configures the HTTP proxy to use as a SOCKS4 proxy.|false|boolean|
|authenticationType|Explicit authentication method to be used, one of USERNAME\_PASSWORD, REFRESH\_TOKEN, CLIENT\_CREDENTIALS, or JWT. Salesforce component can auto-determine the authentication method to use from the properties set, set this property to eliminate any ambiguity.||object|
|clientId|OAuth Consumer Key of the connected app configured in the Salesforce instance setup. Typically a connected app needs to be configured but one can be provided by installing a package.||string|
|clientSecret|OAuth Consumer Secret of the connected app configured in the Salesforce instance setup.||string|
|httpProxyAuthUri|Used in authentication against the HTTP proxy server, needs to match the URI of the proxy server in order for the httpProxyUsername and httpProxyPassword to be used for authentication.||string|
|httpProxyPassword|Password to use to authenticate against the HTTP proxy server.||string|
|httpProxyRealm|Realm of the proxy server, used in preemptive Basic/Digest authentication methods against the HTTP proxy server.||string|
|httpProxySecure|If set to false disables the use of TLS when accessing the HTTP proxy.|true|boolean|
|httpProxyUseDigestAuth|If set to true Digest authentication will be used when authenticating to the HTTP proxy, otherwise Basic authorization method will be used|false|boolean|
|httpProxyUsername|Username to use to authenticate against the HTTP proxy server.||string|
|instanceUrl|URL of the Salesforce instance used after authentication, by default received from Salesforce on successful authentication||string|
|jwtAudience|Value to use for the Audience claim (aud) when using OAuth JWT flow. If not set, the login URL will be used, which is appropriate in most cases.||string|
|keystore|KeyStore parameters to use in OAuth JWT flow. The KeyStore should contain only one entry with private key and certificate. Salesforce does not verify the certificate chain, so this can easily be a selfsigned certificate. Make sure that you upload the certificate to the corresponding connected app.||object|
|lazyLogin|If set to true prevents the component from authenticating to Salesforce with the start of the component. You would generally set this to the (default) false and authenticate early and be immediately aware of any authentication issues. Lazy login is not supported by salesforce consumers.|false|boolean|
|loginConfig|All authentication configuration in one nested bean, all properties set there can be set directly on the component as well||object|
|loginUrl|URL of the Salesforce instance used for authentication, by default set to https://login.salesforce.com|https://login.salesforce.com|string|
|password|Password used in OAuth flow to gain access to access token. It's easy to get started with password OAuth flow, but in general one should avoid it as it is deemed less secure than other flows. Make sure that you append security token to the end of the password if using one.||string|
|pubSubHost|Pub/Sub host|api.pubsub.salesforce.com|string|
|pubSubPort|Pub/Sub port|7443|integer|
|refreshToken|Refresh token already obtained in the refresh token OAuth flow. One needs to setup a web application and configure a callback URL to receive the refresh token, or configure using the builtin callback at https://login.salesforce.com/services/oauth2/success or https://test.salesforce.com/services/oauth2/success and then retrive the refresh\_token from the URL at the end of the flow. Note that in development organizations Salesforce allows hosting the callback web application at localhost.||string|
|sslContextParameters|SSL parameters to use, see SSLContextParameters class for all available options.||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters|false|boolean|
|userName|Username used in OAuth flow to gain access to access token. It's easy to get started with password OAuth flow, but in general one should avoid it as it is deemed less secure than other flows.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operationName|The operation to use||object|
|topicName|The name of the topic/channel to use||string|
|apexMethod|APEX method name||string|
|apexQueryParams|Query params for APEX method||object|
|apiVersion|Salesforce API version.|56.0|string|
|backoffIncrement|Backoff interval increment for Streaming connection restart attempts for failures beyond CometD auto-reconnect.|1000|duration|
|batchId|Bulk API Batch ID||string|
|contentType|Bulk API content type, one of XML, CSV, ZIP\_XML, ZIP\_CSV||object|
|defaultReplayId|Default replayId setting if no value is found in initialReplayIdMap|-1|integer|
|fallBackReplayId|ReplayId to fall back to after an Invalid Replay Id response|-1|integer|
|format|Payload format to use for Salesforce API calls, either JSON or XML, defaults to JSON. As of Camel 3.12, this option only applies to the Raw operation.||object|
|httpClient|Custom Jetty Http Client to use to connect to Salesforce.||object|
|includeDetails|Include details in Salesforce1 Analytics report, defaults to false.||boolean|
|initialReplayIdMap|Replay IDs to start from per channel name.||object|
|instanceId|Salesforce1 Analytics report execution instance ID||string|
|jobId|Bulk API Job ID||string|
|limit|Limit on number of returned records. Applicable to some of the API, check the Salesforce documentation.||integer|
|locator|Locator provided by salesforce Bulk 2.0 API for use in getting results for a Query job.||string|
|maxBackoff|Maximum backoff interval for Streaming connection restart attempts for failures beyond CometD auto-reconnect.|30000|duration|
|maxRecords|The maximum number of records to retrieve per set of results for a Bulk 2.0 Query. The request is still subject to the size limits. If you are working with a very large number of query results, you may experience a timeout before receiving all the data from Salesforce. To prevent a timeout, specify the maximum number of records your client is expecting to receive in the maxRecords parameter. This splits the results into smaller sets with this value as the maximum size.||integer|
|notFoundBehaviour|Sets the behaviour of 404 not found status received from Salesforce API. Should the body be set to NULL NotFoundBehaviour#NULL or should a exception be signaled on the exchange NotFoundBehaviour#EXCEPTION - the default.|EXCEPTION|object|
|notifyForFields|Notify for fields, options are ALL, REFERENCED, SELECT, WHERE||object|
|notifyForOperationCreate|Notify for create operation, defaults to false (API version \&gt;= 29.0)||boolean|
|notifyForOperationDelete|Notify for delete operation, defaults to false (API version \&gt;= 29.0)||boolean|
|notifyForOperations|Notify for operations, options are ALL, CREATE, EXTENDED, UPDATE (API version \&lt; 29.0)||object|
|notifyForOperationUndelete|Notify for un-delete operation, defaults to false (API version \&gt;= 29.0)||boolean|
|notifyForOperationUpdate|Notify for update operation, defaults to false (API version \&gt;= 29.0)||boolean|
|objectMapper|Custom Jackson ObjectMapper to use when serializing/deserializing Salesforce objects.||object|
|pkChunking|Use PK Chunking. Only for use in original Bulk API. Bulk 2.0 API performs PK chunking automatically, if necessary.||boolean|
|pkChunkingChunkSize|Chunk size for use with PK Chunking. If unspecified, salesforce default is 100,000. Maximum size is 250,000.||integer|
|pkChunkingParent|Specifies the parent object when you're enabling PK chunking for queries on sharing objects. The chunks are based on the parent object's records rather than the sharing object's records. For example, when querying on AccountShare, specify Account as the parent object. PK chunking is supported for sharing objects as long as the parent object is supported.||string|
|pkChunkingStartRow|Specifies the 15-character or 18-character record ID to be used as the lower boundary for the first chunk. Use this parameter to specify a starting ID when restarting a job that failed between batches.||string|
|queryLocator|Query Locator provided by salesforce for use when a query results in more records than can be retrieved in a single call. Use this value in a subsequent call to retrieve additional records.||string|
|rawPayload|Use raw payload String for request and response (either JSON or XML depending on format), instead of DTOs, false by default|false|boolean|
|reportId|Salesforce1 Analytics report Id||string|
|reportMetadata|Salesforce1 Analytics report metadata for filtering||object|
|resultId|Bulk API Result ID||string|
|sObjectBlobFieldName|SObject blob field name||string|
|sObjectClass|Fully qualified SObject class name, usually generated using camel-salesforce-maven-plugin||string|
|sObjectFields|SObject fields to retrieve||string|
|sObjectId|SObject ID if required by API||string|
|sObjectIdName|SObject external ID field name||string|
|sObjectIdValue|SObject external ID field value||string|
|sObjectName|SObject name if required or supported by API||string|
|sObjectQuery|Salesforce SOQL query string||string|
|sObjectSearch|Salesforce SOSL search string||string|
|streamQueryResult|If true, streams SOQL query result and transparently handles subsequent requests if there are multiple pages. Otherwise, results are returned one page at a time.|false|boolean|
|updateTopic|Whether to update an existing Push Topic when using the Streaming API, defaults to false|false|boolean|
|pubSubBatchSize|Max number of events to receive in a batch from the Pub/Sub API.|100|integer|
|pubSubDeserializeType|How to deserialize events consume from the Pub/Sub API. AVRO will try a SpecificRecord subclass if found, otherwise GenericRecord.|AVRO|object|
|pubSubPojoClass|Fully qualified class name to deserialize Pub/Sub API event to.||string|
|pubSubReplayId|The replayId value to use when subscribing to the Pub/Sub API.||string|
|replayId|The replayId value to use when subscribing to the Streaming API.||integer|
|replayPreset|Replay preset for Pub/Sub API.|LATEST|object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|allOrNone|Composite API option to indicate to rollback all records if any are not successful.|false|boolean|
|apexUrl|APEX method URL||string|
|compositeMethod|Composite (raw) method.||string|
|eventName|Name of Platform Event, Change Data Capture Event, custom event, etc.||string|
|eventSchemaFormat|EXPANDED: Apache Avro format but doesn't strictly adhere to the record complex type. COMPACT: Apache Avro, adheres to the specification for the record complex type. This parameter is available in API version 43.0 and later.||object|
|eventSchemaId|The ID of the event schema.||string|
|rawHttpHeaders|Comma separated list of message headers to include as HTTP parameters for Raw operation.||string|
|rawMethod|HTTP method to use for the Raw operation||string|
|rawPath|The portion of the endpoint URL after the domain name. E.g., '/services/data/v52.0/sobjects/Account/'||string|
|rawQueryParameters|Comma separated list of message headers to include as query parameters for Raw operation. Do not url-encode values as this will be done automatically.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
