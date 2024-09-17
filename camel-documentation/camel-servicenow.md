# Servicenow

**Since Camel 2.18**

**Only producer is supported**

The ServiceNow component provides access to ServiceNow platform through
their REST API.

The component supports multiple versions of ServiceNow platform with
default to Helsinki.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-servicenow</artifactId>
        <version>${camel-version}</version>
    </dependency>

# URI format

    servicenow://instanceName?[options]

<table>
<caption>API Mapping</caption>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 70%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">CamelServiceNowResource</th>
<th style="text-align: left;">CamelServiceNowAction</th>
<th style="text-align: left;">Method</th>
<th style="text-align: left;">API URI</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>TABLE</p></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/table/{table_name}/{sys_id}</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>CREATE</code></pre></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/table/{table_name}</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>MODIFY</code></pre></td>
<td style="text-align: left;"><pre><code>PUT</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/table/{table_name}/{sys_id}</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>DELETE</code></pre></td>
<td style="text-align: left;"><pre><code>DELETE</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/table/{table_name}/{sys_id}</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>UPDATE</code></pre></td>
<td style="text-align: left;"><pre><code>PATCH</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/table/{table_name}/{sys_id}</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>AGGREGATE</code></pre></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/stats/{table_name}</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>IMPORT</p></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/import/{table_name}/{sys_id}</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>CREATE</code></pre></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/import/{table_name}</code></pre></td>
<td></td>
</tr>
</tbody>
</table>

API Mapping

[Fuji REST API
Documentation](http://wiki.servicenow.com/index.php?title=REST_API#Available_APIs)

<table>
<caption>API Mapping</caption>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">CamelServiceNowResource</th>
<th style="text-align: left;">CamelServiceNowAction</th>
<th style="text-align: left;">CamelServiceNowActionSubject</th>
<th style="text-align: left;">Method</th>
<th style="text-align: left;">API URI</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>TABLE</p></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/table/{table_name}/{sys_id}</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>CREATE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/table/{table_name}</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>MODIFY</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>PUT</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/table/{table_name}/{sys_id}</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>DELETE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>DELETE</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/table/{table_name}/{sys_id}</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>UPDATE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>PATCH</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/table/{table_name}/{sys_id}</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>AGGREGATE</code></pre></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/v1/stats/{table_name}</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>IMPORT</p></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/import/{table_name}/{sys_id}</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>CREATE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/import/{table_name}</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ATTACHMENT</p></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/api/now/attachment/{sys_id}</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>CONTENT</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/attachment/{sys_id}/file</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>UPLOAD</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/api/now/attachment/file</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>DELETE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>DELETE</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/attachment/{sys_id}</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>SCORECARDS</code></pre></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"><pre><code>PERFORMANCE_ANALYTICS</code></pre></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/pa/scorecards</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>MISC</p></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"><pre><code>USER_ROLE_INHERITANCE</code></pre></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/api/global/user_role_inheritance</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>CREATE</code></pre></td>
<td style="text-align: left;"><pre><code>IDENTIFY_RECONCILE</code></pre></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/api/now/identifyreconcile</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>SERVICE_CATALOG</p></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/catalogs/{sys_id}</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"><pre><code>CATEGORIES</code></pre></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/catalogs/{sys_id}/categories</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>SERVICE_CATALOG_ITEMS</p></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/items/{sys_id}</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"><pre><code>SUBMIT_GUIDE</code></pre></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/items/{sys_id}/submit_guide</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"><pre><code>CHECKOUT_GUIDE</code></pre></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/items/{sys_id}/checkout_guide</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>CREATE</code></pre></td>
<td style="text-align: left;"><pre><code>SUBJECT_CART</code></pre></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/items/{sys_id}/add_to_cart</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>CREATE</code></pre></td>
<td style="text-align: left;"><pre><code>SUBJECT_PRODUCER</code></pre></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/items/{sys_id}/submit_producer</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>SERVICE_CATALOG_CARTS</p></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/cart</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"><pre><code>DELIVERY_ADDRESS</code></pre></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/cart/delivery_address/{user_id}</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"><pre><code>CHECKOUT</code></pre></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/cart/checkout</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>UPDATE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/cart/{cart_item_id}</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>UPDATE</code></pre></td>
<td style="text-align: left;"><pre><code>CHECKOUT</code></pre></td>
<td style="text-align: left;"><pre><code>POST</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/cart/submit_order</code></pre></td>
<td></td>
</tr>
<tr class="even">
<td style="text-align: left;"><pre><code>DELETE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>DELETE</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/cart/{sys_id}/empty</code></pre></td>
<td></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><pre><code>SERVICE_CATALOG_CATEGORIES</code></pre></td>
<td style="text-align: left;"><pre><code>RETRIEVE</code></pre></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code>GET</code></pre></td>
<td style="text-align: left;"><pre><code>/sn_sc/servicecatalog/categories/{sys_id}</code></pre></td>
</tr>
</tbody>
</table>

API Mapping

[Helsinki REST API
Documentation](https://docs.servicenow.com/bundle/helsinki-servicenow-platform/page/integrate/inbound-rest/reference/r_RESTResources.html)

# Examples:

**Retrieve 10 Incidents**

    context.addRoutes(new RouteBuilder() {
        public void configure() {
           from("direct:servicenow")
               .to("servicenow:{{env:SERVICENOW_INSTANCE}}"
                   + "?userName={{env:SERVICENOW_USERNAME}}"
                   + "&password={{env:SERVICENOW_PASSWORD}}"
                   + "&oauthClientId={{env:SERVICENOW_OAUTH2_CLIENT_ID}}"
                   + "&oauthClientSecret={{env:SERVICENOW_OAUTH2_CLIENT_SECRET}}"
               .to("mock:servicenow");
        }
    });
    
    FluentProducerTemplate.on(context)
        .withHeader(ServiceNowConstants.RESOURCE, "table")
        .withHeader(ServiceNowConstants.ACTION, ServiceNowConstants.ACTION_RETRIEVE)
        .withHeader(ServiceNowConstants.SYSPARM_LIMIT.getId(), "10")
        .withHeader(ServiceNowConstants.TABLE, "incident")
        .withHeader(ServiceNowConstants.MODEL, Incident.class)
        .to("direct:servicenow")
        .send();

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|Component configuration||object|
|display|Set this parameter to true to return only scorecards where the indicator Display field is selected. Set this parameter to all to return scorecards with any Display field value. This parameter is true by default.|true|string|
|displayValue|Return the display value (true), actual value (false), or both (all) for reference fields (default: false)|false|string|
|excludeReferenceLink|True to exclude Table API links for reference fields (default: false)||boolean|
|favorites|Set this parameter to true to return only scorecards that are favorites of the querying user.||boolean|
|includeAggregates|Set this parameter to true to always return all available aggregates for an indicator, including when an aggregate has already been applied. If a value is not specified, this parameter defaults to false and returns no aggregates.||boolean|
|includeAvailableAggregates|Set this parameter to true to return all available aggregates for an indicator when no aggregate has been applied. If a value is not specified, this parameter defaults to false and returns no aggregates.||boolean|
|includeAvailableBreakdowns|Set this parameter to true to return all available breakdowns for an indicator. If a value is not specified, this parameter defaults to false and returns no breakdowns.||boolean|
|includeScoreNotes|Set this parameter to true to return all notes associated with the score. The note element contains the note text as well as the author and timestamp when the note was added.||boolean|
|includeScores|Set this parameter to true to return all scores for a scorecard. If a value is not specified, this parameter defaults to false and returns only the most recent score value.||boolean|
|inputDisplayValue|True to set raw value of input fields (default: false)||boolean|
|key|Set this parameter to true to return only scorecards for key indicators.||boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|models|Defines both request and response models||object|
|perPage|Enter the maximum number of scorecards each query can return. By default this value is 10, and the maximum is 100.|10|integer|
|release|The ServiceNow release to target, default to Helsinki See https://docs.servicenow.com|HELSINKI|object|
|requestModels|Defines the request model||object|
|resource|The default resource, can be overridden by header CamelServiceNowResource||string|
|responseModels|Defines the response model||object|
|sortBy|Specify the value to use when sorting results. By default, queries sort records by value.||string|
|sortDir|Specify the sort direction, ascending or descending. By default, queries sort records in descending order. Use sysparm\_sortdir=asc to sort in ascending order.||string|
|suppressAutoSysField|True to suppress auto generation of system fields (default: false)||boolean|
|suppressPaginationHeader|Set this value to true to remove the Link header from the response. The Link header allows you to request additional pages of data when the number of records matching your query exceeds the query limit||boolean|
|table|The default table, can be overridden by header CamelServiceNowTable||string|
|target|Set this parameter to true to return only scorecards that have a target.||boolean|
|topLevelOnly|Gets only those categories whose parent is a catalog.||boolean|
|apiVersion|The ServiceNow REST API version, default latest||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|dateFormat|The date format used for Json serialization/deserialization|yyyy-MM-dd|string|
|dateTimeFormat|The date-time format used for Json serialization/deserialization|yyyy-MM-dd HH:mm:ss|string|
|httpClientPolicy|To configure http-client||object|
|instanceName|The ServiceNow instance name||string|
|mapper|Sets Jackson's ObjectMapper to use for request/reply||object|
|proxyAuthorizationPolicy|To configure proxy authentication||object|
|retrieveTargetRecordOnImport|Set this parameter to true to retrieve the target record when using import set api. The import set result is then replaced by the target record|false|boolean|
|timeFormat|The time format used for Json serialization/deserialization|HH:mm:ss|string|
|proxyHost|The proxy host name||string|
|proxyPort|The proxy port number||integer|
|apiUrl|The ServiceNow REST API url||string|
|oauthClientId|OAuth2 ClientID||string|
|oauthClientSecret|OAuth2 ClientSecret||string|
|oauthTokenUrl|OAuth token Url||string|
|password|ServiceNow account password, MUST be provided||string|
|proxyPassword|Password for proxy authentication||string|
|proxyUserName|Username for proxy authentication||string|
|sslContextParameters|To configure security using SSLContextParameters. See http://camel.apache.org/camel-configuration-utilities.html||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|
|userName|ServiceNow user account name, MUST be provided||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|instanceName|The ServiceNow instance name||string|
|display|Set this parameter to true to return only scorecards where the indicator Display field is selected. Set this parameter to all to return scorecards with any Display field value. This parameter is true by default.|true|string|
|displayValue|Return the display value (true), actual value (false), or both (all) for reference fields (default: false)|false|string|
|excludeReferenceLink|True to exclude Table API links for reference fields (default: false)||boolean|
|favorites|Set this parameter to true to return only scorecards that are favorites of the querying user.||boolean|
|includeAggregates|Set this parameter to true to always return all available aggregates for an indicator, including when an aggregate has already been applied. If a value is not specified, this parameter defaults to false and returns no aggregates.||boolean|
|includeAvailableAggregates|Set this parameter to true to return all available aggregates for an indicator when no aggregate has been applied. If a value is not specified, this parameter defaults to false and returns no aggregates.||boolean|
|includeAvailableBreakdowns|Set this parameter to true to return all available breakdowns for an indicator. If a value is not specified, this parameter defaults to false and returns no breakdowns.||boolean|
|includeScoreNotes|Set this parameter to true to return all notes associated with the score. The note element contains the note text as well as the author and timestamp when the note was added.||boolean|
|includeScores|Set this parameter to true to return all scores for a scorecard. If a value is not specified, this parameter defaults to false and returns only the most recent score value.||boolean|
|inputDisplayValue|True to set raw value of input fields (default: false)||boolean|
|key|Set this parameter to true to return only scorecards for key indicators.||boolean|
|models|Defines both request and response models||object|
|perPage|Enter the maximum number of scorecards each query can return. By default this value is 10, and the maximum is 100.|10|integer|
|release|The ServiceNow release to target, default to Helsinki See https://docs.servicenow.com|HELSINKI|object|
|requestModels|Defines the request model||object|
|resource|The default resource, can be overridden by header CamelServiceNowResource||string|
|responseModels|Defines the response model||object|
|sortBy|Specify the value to use when sorting results. By default, queries sort records by value.||string|
|sortDir|Specify the sort direction, ascending or descending. By default, queries sort records in descending order. Use sysparm\_sortdir=asc to sort in ascending order.||string|
|suppressAutoSysField|True to suppress auto generation of system fields (default: false)||boolean|
|suppressPaginationHeader|Set this value to true to remove the Link header from the response. The Link header allows you to request additional pages of data when the number of records matching your query exceeds the query limit||boolean|
|table|The default table, can be overridden by header CamelServiceNowTable||string|
|target|Set this parameter to true to return only scorecards that have a target.||boolean|
|topLevelOnly|Gets only those categories whose parent is a catalog.||boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|apiVersion|The ServiceNow REST API version, default latest||string|
|dateFormat|The date format used for Json serialization/deserialization|yyyy-MM-dd|string|
|dateTimeFormat|The date-time format used for Json serialization/deserialization|yyyy-MM-dd HH:mm:ss|string|
|httpClientPolicy|To configure http-client||object|
|mapper|Sets Jackson's ObjectMapper to use for request/reply||object|
|proxyAuthorizationPolicy|To configure proxy authentication||object|
|retrieveTargetRecordOnImport|Set this parameter to true to retrieve the target record when using import set api. The import set result is then replaced by the target record|false|boolean|
|timeFormat|The time format used for Json serialization/deserialization|HH:mm:ss|string|
|proxyHost|The proxy host name||string|
|proxyPort|The proxy port number||integer|
|apiUrl|The ServiceNow REST API url||string|
|oauthClientId|OAuth2 ClientID||string|
|oauthClientSecret|OAuth2 ClientSecret||string|
|oauthTokenUrl|OAuth token Url||string|
|password|ServiceNow account password, MUST be provided||string|
|proxyPassword|Password for proxy authentication||string|
|proxyUserName|Username for proxy authentication||string|
|sslContextParameters|To configure security using SSLContextParameters. See http://camel.apache.org/camel-configuration-utilities.html||object|
|userName|ServiceNow user account name, MUST be provided||string|
