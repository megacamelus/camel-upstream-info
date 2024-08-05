# Hwcloud-iam

**Since Camel 3.11**

**Only producer is supported**

Huawei Cloud Identity and Access Management (IAM) component allows you
to integrate with
[IAM](https://www.huaweicloud.com/intl/en-us/product/iam.html) provided
by Huawei Cloud.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-huaweicloud-iam</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

    hwcloud-iam:operation[?options]

# Usage

## Message properties evaluated by the IAM producer

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
style="text-align: left;"><p><code>CamelHwCloudIamOperation</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of operation to invoke</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudIamUserId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>User ID to invoke operation on</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudIamGroupId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Group ID to invoke operation
on</p></td>
</tr>
</tbody>
</table>

If any of the above properties are set, they will override their
corresponding query parameter.

# List of Supported IAM Operations

-   listUsers

-   getUser - `userId` parameter is **required**

-   updateUser - `userId` parameter is **required**

-   listGroups

-   getGroupUsers - `groupId` is **required**

-   updateGroup - `groupId` is **required**

## Passing Options Through Exchange Body

There are many options that can be submitted to [update a
user](https://support.huaweicloud.com/en-us/api-iam/iam_08_0011.html)
(Table 4) or to [update a
group](https://support.huaweicloud.com/en-us/api-iam/iam_09_0004.html)
(Table 4). Since there are multiple user/group options, they must be
passed through the exchange body.

For the `updateUser` operation, you can pass the user options as an
UpdateUserOption object or a Json string:

    from("direct:triggerRoute")
     .setBody(new UpdateUserOption().withName("user").withDescription("employee").withEmail("user@email.com"))
     .to("hwcloud-iam:updateUser?userId=********&region=cn-north-4&accessKey=********&secretKey=********")
    
    from("direct:triggerRoute")
     .setBody("{\"name\":\"user\",\"description\":\"employee\",\"email\":\"user@email.com\"}")
     .to("hwcloud-iam:updateUser?userId=********&region=cn-north-4&accessKey=********&secretKey=********")

For the `updateGroup` operation, you can pass the group options as a
KeystoneUpdateGroupOption object or a Json string:

    from("direct:triggerRoute")
     .setBody(new KeystoneUpdateGroupOption().withName("group").withDescription("employees").withDomainId("1234"))
     .to("hwcloud-iam:updateUser?groupId=********&region=cn-north-4&accessKey=********&secretKey=********")
    
    from("direct:triggerRoute")
     .setBody("{\"name\":\"group\",\"description\":\"employees\",\"domain_id\":\"1234\"}")
     .to("hwcloud-iam:updateUser?groupId=********&region=cn-north-4&accessKey=********&secretKey=********")

# Using ServiceKey Configuration Bean

Access key and secret keys are required to authenticate against cloud
IAM service. You can avoid having them being exposed and scattered over
in your endpoint uri by wrapping them inside a bean of class
`org.apache.camel.component.huaweicloud.iam.models.ServiceKeys`. Add it
to the registry and let Camel look it up by referring the object via
endpoint query parameter `serviceKeys`.

Check the following code snippets:

    <bean id="myServiceKeyConfig" class="org.apache.camel.component.huaweicloud.iam.models.ServiceKeys">
       <property name="accessKey" value="your_access_key" />
       <property name="secretKey" value="your_secret_key" />
    </bean>
    
    from("direct:triggerRoute")
     .setProperty(IAMPropeties.OPERATION, constant("listUsers"))
     .setProperty(IAMPropeties.USER_ID ,constant("your_user_id"))
     .setProperty(IAMPropeties.GROUP_ID, constant("your_group_id))
     .to("hwcloud-iam:listUsers?region=cn-north-4&serviceKeys=#myServiceKeyConfig")

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
|groupId|Group ID to perform operation with||string|
|ignoreSslVerification|Ignore SSL verification|false|boolean|
|proxyHost|Proxy server ip/hostname||string|
|proxyPassword|Proxy authentication password||string|
|proxyPort|Proxy server port||integer|
|proxyUser|Proxy authentication user||string|
|region|IAM service region||string|
|secretKey|Secret key for the cloud user||string|
|serviceKeys|Configuration object for cloud service authentication||object|
|userId|User ID to perform operation with||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
