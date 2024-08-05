# Hwcloud-dms

**Since Camel 3.12**

**Only producer is supported**

Huawei Cloud Distributed Message Service (DMS) component allows you to
integrate with
[DMS](https://www.huaweicloud.com/intl/en-us/product/dms.html) provided
by Huawei Cloud.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-huaweicloud-dms</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

    hwcloud-dms:operation[?options]

# Usage

## Message properties evaluated by the DMS producer

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
style="text-align: left;"><p><code>CamelHwCloudDmsOperation</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of operation to invoke</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsEngine</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The message engine. Either kafka or
rabbitmq</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsInstanceId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Instance ID to invoke operation
on</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The name of the instance for creating
and updating an instance</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsEngineVersion</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The version of the message
engine</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsSpecification</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The baseline bandwidth of a Kafka
instance</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsStorageSpace</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>The message storage space</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsPartitionNum</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>The maximum number of partitions in a
Kafka instance</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsAccessUser</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The username of a RabbitMQ
instance</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsPassword</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The password of a RabbitMQ
instance</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsVpcId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The VPC ID</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsSecurityGroupId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The security group which the instance
belongs to</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsSubnetId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The subnet ID</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsAvailableZones</code></p></td>
<td
style="text-align: left;"><p><code>List&lt;String&gt;</code></p></td>
<td style="text-align: left;"><p>The ID of an available zone</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsProductId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The product ID</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsKafkaManagerUser</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The username for logging in to the
Kafka Manager</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsKafkaManagerPassword</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The password for logging in to the
Kafka Manager</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsStorageSpecCode</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The storage I/O specification</p></td>
</tr>
</tbody>
</table>

If any of the above properties are set, they will override their
corresponding query parameter.

## Message properties set by the DMS producer

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
style="text-align: left;"><p><code>CamelHwCloudDmsInstanceDeleted</code></p></td>
<td style="text-align: left;"><p><code>boolean</code></p></td>
<td style="text-align: left;"><p>Set as <code>true</code> when the
deleteInstance operation is successful</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudDmsInstanceUpdated</code></p></td>
<td style="text-align: left;"><p><code>boolean</code></p></td>
<td style="text-align: left;"><p>Set as <code>true</code> when the
updateInstance operation is successful</p></td>
</tr>
</tbody>
</table>

# List of Supported DMS Operations

-   createInstance

-   deleteInstance

-   listInstances

-   queryInstance

-   updateInstance

## Create Instance

To create an instance, you can pass the parameters through the endpoint,
the exchange properties, and the exchange body as a
CreateInstanceRequestBody object or a valid JSON String representation
of it. Refer to this for the [Kafka
parameters](https://support.huaweicloud.com/en-us/api-kafka/kafka-api-180514002.html)
and the [RabbitMQ
parameters](https://support.huaweicloud.com/en-us/api-rabbitmq/rabbitmq-api-180514002.html).
If you choose to pass these parameters through the endpoint or through
exchange properties, you can only input the mandatory parameters shown
in those links. If you would like to have access to all the parameters,
you must pass a CreateInstanceRequestBody object or a valid JSON String
representation of it through the exchange body, as shown below:

    from("direct:triggerRoute")
     .setBody(new CreateInstanceRequestBody().withName("new-instance").withDescription("description").with*) // add remaining options
     .to("hwcloud-dms:createInstance?region=cn-north-4&accessKey=********&secretKey=********&projectId=*******")
    
    from("direct:triggerRoute")
     .setBody("{\"name\":\"new-instance\",\"description\":\"description\"}") // add remaining options
     .to("hwcloud-dms:createInstance?region=cn-north-4&accessKey=********&secretKey=********&projectId=*******")

## Update Instance

To update an instance, you must pass the parameters through the exchange
body as an UpdateInstanceRequestBody or a valid JSON String
representation of it. Refer to this for the [Kafka
parameters](https://support.huaweicloud.com/en-us/api-kafka/kafka-api-180514004.html)
and the [RabbitMQ
parameters](https://support.huaweicloud.com/en-us/api-rabbitmq/rabbitmq-api-180514004.html).
An example of how to do this is shown below:

    from("direct:triggerRoute")
     .setBody(new UpdateInstanceRequestBody().withName("new-instance").withDescription("description").with*) // add remaining options
     .to("hwcloud-dms:updateInstance?instanceId=******&region=cn-north-4&accessKey=********&secretKey=********&projectId=*******")
    
    from("direct:triggerRoute")
     .setBody("{\"name\":\"new-instance\",\"description\":\"description\"}") // add remaining options
     .to("hwcloud-dms:updateInstance?instanceId=******&region=cn-north-4&accessKey=********&secretKey=********&projectId=*******")

# Using ServiceKey Configuration Bean

Access key and secret keys are required to authenticate against cloud
DMS service. You can avoid having them being exposed and scattered over
in your endpoint uri by wrapping them inside a bean of class
`org.apache.camel.component.huaweicloud.common.models.ServiceKeys`. Add
it to the registry and let Camel look it up by referring the object via
endpoint query parameter `serviceKeys`.

Check the following code snippets:

    <bean id="myServiceKeyConfig" class="org.apache.camel.component.huaweicloud.common.models.ServiceKeys">
       <property name="accessKey" value="your_access_key" />
       <property name="secretKey" value="your_secret_key" />
    </bean>
    
    from("direct:triggerRoute")
     .to("hwcloud-dms:listInstances?region=cn-north-4&serviceKeys=#myServiceKeyConfig")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|Operation to be performed||string|
|accessKey|Access key for the cloud user||string|
|accessUser|The username of a RabbitMQ instance. This option is mandatory when creating a RabbitMQ instance.||string|
|availableZones|The ID of an available zone. This option is mandatory when creating an instance and it cannot be an empty array.||array|
|endpoint|DMS url. Carries higher precedence than region parameter based client initialization||string|
|engine|The message engine. Either kafka or rabbitmq. If the parameter is not specified, all instances will be queried||string|
|engineVersion|The version of the message engine. This option is mandatory when creating an instance.||string|
|ignoreSslVerification|Ignore SSL verification|false|boolean|
|instanceId|The id of the instance. This option is mandatory when deleting or querying an instance||string|
|kafkaManagerPassword|The password for logging in to the Kafka Manager. This option is mandatory when creating a Kafka instance.||string|
|kafkaManagerUser|The username for logging in to the Kafka Manager. This option is mandatory when creating a Kafka instance.||string|
|name|The name of the instance for creating and updating an instance. This option is mandatory when creating an instance||string|
|partitionNum|The maximum number of partitions in a Kafka instance. This option is mandatory when creating a Kafka instance.||integer|
|password|The password of a RabbitMQ instance. This option is mandatory when creating a RabbitMQ instance.||string|
|productId|The product ID. This option is mandatory when creating an instance.||string|
|projectId|Cloud project ID||string|
|proxyHost|Proxy server ip/hostname||string|
|proxyPassword|Proxy authentication password||string|
|proxyPort|Proxy server port||integer|
|proxyUser|Proxy authentication user||string|
|region|DMS service region||string|
|secretKey|Secret key for the cloud user||string|
|securityGroupId|The security group which the instance belongs to. This option is mandatory when creating an instance.||string|
|serviceKeys|Configuration object for cloud service authentication||object|
|specification|The baseline bandwidth of a Kafka instance. This option is mandatory when creating a Kafka instance.||string|
|storageSpace|The message storage space. This option is mandatory when creating an instance.||integer|
|storageSpecCode|The storage I/O specification. This option is mandatory when creating an instance.||string|
|subnetId|The subnet ID. This option is mandatory when creating an instance.||string|
|vpcId|The VPC ID. This option is mandatory when creating an instance.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
