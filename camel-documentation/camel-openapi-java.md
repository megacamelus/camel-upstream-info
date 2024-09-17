# Openapi-java.md

**Since Camel 3.1**

The Rest DSL can be integrated with the `camel-openapi-java` module
which is used for exposing the REST services and their APIs using
[OpenApi](https://www.openapis.org/).

Only OpenAPI spec version 3.x is supported. You cannot use the old
Swagger 2.0 spec.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-openapi-java</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

The camel-openapi-java module can be used from the REST components
(without the need for servlet)

# Using OpenApi in rest-dsl

You can enable the OpenApi api from the rest-dsl by configuring the
`apiContextPath` dsl as shown below:

    public class UserRouteBuilder extends RouteBuilder {
        @Override
        public void configure() throws Exception {
            // configure we want to use servlet as the component for the rest DSL,
            // and we enable json binding mode
            restConfiguration().component("netty-http").bindingMode(RestBindingMode.json)
                // and output using pretty print
                .dataFormatProperty("prettyPrint", "true")
                // setup context path and port number that netty will use
                .contextPath("/").port(8080)
                // add OpenApi api-doc out of the box
                .apiContextPath("/api-doc")
                    .apiProperty("api.title", "User API").apiProperty("api.version", "1.2.3")
                    // and enable CORS
                    .apiProperty("cors", "true");
    
            // this user REST service is json only
            rest("/user").description("User rest service")
                .consumes("application/json").produces("application/json")
                .get("/{id}").description("Find user by id").outType(User.class)
                    .param().name("id").type(path).description("The id of the user to get").dataType("int").endParam()
                    .to("bean:userService?method=getUser(${header.id})")
                .put().description("Updates or create a user").type(User.class)
                    .param().name("body").type(body).description("The user to update or create").endParam()
                    .to("bean:userService?method=updateUser")
                .get("/findAll").description("Find all users").outType(User[].class)
                    .to("bean:userService?method=listUsers");
        }
    }

# Options

The OpenApi module can be configured using the following options. To
configure using a servlet, you use the init-param as shown above. When
configuring directly in the rest-dsl, you use the appropriate method,
such as `enableCORS`, `host,contextPath`, dsl. The options with
`api.xxx` is configured using `apiProperty` dsl.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>cors</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
<td style="text-align: left;"><p>Whether to enable CORS. Notice this
only enables CORS for the api browser, and not the actual access to the
REST services. The default is false.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>openapi.version</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>OpenApi spec version. Only spec version
3.x is supported. Is default 3.0.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>host</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>To set up the hostname. If not
configured, camel-openapi-java will calculate the name as localhost
based.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>schemes</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>The protocol schemes to use. Multiple
values can be separated by comma such as "http,https". The default value
is "http".</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>base.path</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p><strong>Required</strong>: To set up
the base path where the REST services are available. The path is
relative (e.g., do not start with http/https) and camel-openapi-java
will calculate the absolute base path at runtime, which will be
<code>protocol://host:port/context-path/base.path</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>api.path</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>To set up the path where the API is
available (eg /api-docs). The path is relative (e.g., do not start with
http/https) and camel-openapi-java will calculate the absolute base path
at runtime, which will be
<code>protocol://host:port/context-path/api.path</code> So using
relative paths is much easier. See above for an example.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>api.version</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>The version of the api. Is default
0.0.0.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>api.title</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>The title of the application.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>api.description</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>A short description of the
application.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>api.termsOfService</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>A URL to the Terms of Service of the
API.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>api.contact.name</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Name of person or organization to
contact</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>api.contact.email</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>An email to be used for API-related
correspondence.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>api.contact.url</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>A URL to a website for more contact
information.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>api.license.name</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>The license name used for the
API.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>api.license.url</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>A URL to the license used for the
API.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>api.default.consumes</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Comma-separated list of default media
types when <code>RestParamType.body</code> is used without providing any
<code>.consumes()</code> configuration. The default value is
<code>application/json</code>. Note that this applies only to the
generated OpenAPI document and not to the actual REST services.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>api.default.produces</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Comma-separated list of default media
types when <code>outType</code> is used without providing any
<code>.produces()</code> configuration. The default value is
<code>application/json</code>. Note that this applies only to the
generated OpenAPI document and not to the actual REST services</p></td>
</tr>
</tbody>
</table>

# Adding Security Definitions in API doc

The Rest DSL now supports declaring OpenApi `securityDefinitions` in the
generated API document. For example, as shown below:

    rest("/user").tag("dude").description("User rest service")
        // setup security definitions
        .securityDefinitions()
            .oauth2("petstore_auth").authorizationUrl("http://petstore.swagger.io/oauth/dialog").end()
            .apiKey("api_key").withHeader("myHeader").end()
        .end()
        .consumes("application/json").produces("application/json")

Here we have set up two security definitions

-   OAuth2: with implicit authorization with the provided url

-   Api Key: using an api key that comes from HTTP header named
    *myHeader*

Then you need to specify on the rest operations which security to use by
referring to their key (petstore\_auth or api\_key).

    .get("/{id}/{date}").description("Find user by id and date").outType(User.class)
        .security("api_key")
    
    ...
    
    .put().description("Updates or create a user").type(User.class)
        .security("petstore_auth", "write:pets,read:pets")

Here the get operation is using the Api Key security, and the put
operation is using OAuth security with permitted scopes of read and
write pets.

# JSon or Yaml

The camel-openapi-java module supports both JSon and Yaml out of the
box. You can specify in the request url what you want by using `.json`
or `.yaml` as suffix in the context-path If none is specified, then the
HTTP Accept header is used to detect if json or yaml can be accepted. If
either both are accepted or none was set as accepted, then json is
returned as the default format.

# useXForwardHeaders and API URL resolution

The OpenApi specification allows you to specify the host, port \& path
that is serving the API. In OpenApi V2 this is done via the `host` field
and in OpenAPI V3 it is part of the `servers` field.

By default, the value for these fields is determined by `X-Forwarded`
headers, `X-Forwarded-Host` \& `X-Forwarded-Proto`.

This can be overridden by disabling the lookup of `X-Forwarded` headers
and by specifying your own host, port \& scheme on the REST
configuration.

    restConfiguration().component("netty-http")
        .useXForwardHeaders(false)
        .apiProperty("schemes", "https");
        .host("localhost")
        .port(8080);

# Examples

In the Apache Camel distribution we ship the `camel-example-openapi-cdi`
and `camel-example-spring-boot-rest-openapi-simple` which demonstrates
using this OpenApi component.
