# Hwcloud-functiongraph

**Since Camel 3.11**

**Only producer is supported**

Huawei Cloud FunctionGraph component allows you to integrate with
[FunctionGraph](https://www.huaweicloud.com/intl/en-us/product/functiongraph.html)
provided by Huawei Cloud.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-huaweicloud-functiongraph</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

    hwcloud-functiongraph:operation[?options]

# Usage

## Message properties evaluated by the FunctionGraph producer

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudFgOperation</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of operation to invoke</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudFgFunction</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of function to invoke operation
on</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudFgPackage</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of the function package</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudFgXCffLogType</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Type of log to be returned by
FunctionGraph operation</p></td>
</tr>
</tbody>
</table>

If the operation, function name, or function package are set, they will
override their corresponding query parameter.

## Message properties set by the FunctionGraph producer

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudFgXCffLogs</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Unique log returned by FunctionGraph
after processing the request if <code>CamelHwCloudFgXCffLogType</code>
is set</p></td>
</tr>
</tbody>
</table>

# List of Supported FunctionGraph Operations

-   invokeFunction - to invoke a serverless function

# Using ServiceKey Configuration Bean

Access key and secret keys are required to authenticate against cloud
FunctionGraph service. You can avoid having them being exposed and
scattered over in your endpoint uri by wrapping them inside a bean of
class
`org.apache.camel.component.huaweicloud.functiongraph.models.ServiceKeys`.
Add it to the registry and let Camel look it up by referring the object
via endpoint query parameter `serviceKeys`.

Check the following code snippets:

    <bean id="myServiceKeyConfig" class="org.apache.camel.component.huaweicloud.functiongraph.models.ServiceKeys">
       <property name="accessKey" value="your_access_key" />
       <property name="secretKey" value="your_secret_key" />
    </bean>
    
    from("direct:triggerRoute")
     .setProperty(FunctionGraphProperties.OPERATION, constant("invokeFunction"))
     .setProperty(FunctionGraphProperties.FUNCTION_NAME ,constant("your_function_name"))
     .setProperty(FunctionGraphProperties.FUNCTION_PACKAGE, constant("your_function_package"))
     .to("hwcloud-functiongraph:invokeFunction?projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&region=cn-north-4&serviceKeys=#myServiceKeyConfig")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|Operation to be performed||string|
|endpoint|FunctionGraph url. Carries higher precedence than region parameter based client initialization||string|
|functionName|Name of the function to invoke||string|
|functionPackage|Functions that can be logically grouped together|default|string|
|projectId|Cloud project ID||string|
|region|FunctionGraph service region. This is lower precedence than endpoint based configuration||string|
|serviceKeys|Configuration object for cloud service authentication||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|proxyHost|Proxy server ip/hostname||string|
|proxyPassword|Proxy authentication password||string|
|proxyPort|Proxy server port||integer|
|proxyUser|Proxy authentication user||string|
|accessKey|Access key for the cloud user||string|
|ignoreSslVerification|Ignore SSL verification|false|boolean|
|secretKey|Secret key for the cloud user||string|
