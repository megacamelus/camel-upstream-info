# Hwcloud-smn

**Since Camel 3.8**

**Only producer is supported**

Huawei Cloud Simple Message Notification (SMN) component allows you to
integrate with
[SMN](https://www.huaweicloud.com/intl/en-us/product/smn.html) provided
by Huawei Cloud.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-huaweicloud-smn</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

To send a notification.

    hwcloud-smn:service[?options]

# Usage

## Message properties evaluated by the SMN producer

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudSmnSubject</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Subject tag for the outgoing
notification</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHwCloudSmnTopic</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Smn topic into which the message is to
be posted</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudSmnMessageTtl</code></p></td>
<td style="text-align: left;"><p><code>Integer</code></p></td>
<td style="text-align: left;"><p>Validity of the posted notification
message</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHwCloudSmnTemplateTags</code></p></td>
<td
style="text-align: left;"><p><code>Map&lt;String, String&gt;</code></p></td>
<td style="text-align: left;"><p>Contains <code>K,V</code> pairs of tags
and values when using operation
<code>publishAsTemplatedMessage</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudSmnTemplateName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of the template to use while using
operation <code>publishAsTemplatedMessage</code></p></td>
</tr>
</tbody>
</table>

## Message properties set by the SMN producer

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudSmnMesssageId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Unique message id returned by Simple
Message Notification server after processing the request</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHwCloudSmnRequestId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Unique request id returned by Simple
Message Notification server after processing the request</p></td>
</tr>
</tbody>
</table>

## Supported list of smn services and corresponding operations

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Service</th>
<th style="text-align: left;">Operations</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>publishMessageService</code></p></td>
<td style="text-align: left;"><p>publishAsTextMessage,
publishAsTemplatedMessage</p></td>
</tr>
</tbody>
</table>

## Inline Configuration of route

### publishAsTextMessage

Java DSL

    from("direct:triggerRoute")
    .setProperty(SmnProperties.NOTIFICATION_SUBJECT, constant("Notification Subject"))
    .setProperty(SmnProperties.NOTIFICATION_TOPIC_NAME,constant(testConfiguration.getProperty("topic")))
    .setProperty(SmnProperties.NOTIFICATION_TTL, constant(60))
    .to("hwcloud-smn:publishMessageService?operation=publishAsTextMessage&accessKey=*********&secretKey=********&projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&region=cn-north-4")

XML DSL

    <route>
       <from uri="direct:triggerRoute" />
       <setProperty name="CamelHwCloudSmnSubject">
          <constant>this is my subjectline</constant>
       </setProperty>
       <setProperty name="CamelHwCloudSmnTopic">
          <constant>reji-test</constant>
       </setProperty>
       <setProperty name="CamelHwCloudSmnMessageTtl">
          <constant>60</constant>
       </setProperty>
       <to uri="hwcloud-smn:publishMessageService?operation=publishAsTextMessage&amp;accessKey=*********&amp;secretKey=********&amp;projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&amp;region=cn-north-4" />
    </route>

## publishAsTemplatedMessage

Java DSL

    from("direct:triggerRoute")
    .setProperty("CamelHwCloudSmnSubject", constant("This is my subjectline"))
    .setProperty("CamelHwCloudSmnTopic", constant("reji-test"))
    .setProperty("CamelHwCloudSmnMessageTtl", constant(60))
    .setProperty("CamelHwCloudSmnTemplateTags", constant(tags))
    .setProperty("CamelHwCloudSmnTemplateName", constant("hello-template"))
    .to("hwcloud-smn:publishMessageService?operation=publishAsTemplatedMessage&accessKey=*********&secretKey=********&projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&region=cn-north-4")

## Using ServiceKey configuration Bean

Access key and secret keys are required to authenticate against cloud
smn service. You can avoid having them being exposed and scattered over
in your endpoint uri by wrapping them inside a bean of class
\`\`\`org.apache.camel.component.huaweicloud.smn.models.ServiceKeys\`\`\`.
Add it to the registry and let camel look it up by referring the object
via endpoint query parameter \`\`\`serviceKeys\`\`\`. Check the
following code snippets

    <bean id="myServiceKeyConfig" class="org.apache.camel.component.huaweicloud.smn.models.ServiceKeys">
       <property name="accessKey" value="your_access_key" />
       <property name="secretKey" value="your_secret_key" />
    </bean>
    
    from("direct:triggerRoute")
     .setProperty(SmnProperties.NOTIFICATION_SUBJECT, constant("Notification Subject"))
     .setProperty(SmnProperties.NOTIFICATION_TOPIC_NAME,constant(testConfiguration.getProperty("topic")))
     .setProperty(SmnProperties.NOTIFICATION_TTL, constant(60))
     .to("hwcloud-smn:publishMessageService?operation=publishAsTextMessage&projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&region=cn-north-4&serviceKeys=#myServiceKeyConfig")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|smnService|Name of SMN service to invoke||string|
|accessKey|Access key for the cloud user||string|
|endpoint|Fully qualified smn service url. Carries higher precedence than region parameter based client initialization||string|
|ignoreSslVerification|Ignore SSL verification|false|boolean|
|messageTtl|TTL for published message|3600|integer|
|operation|Name of operation to perform||string|
|projectId|Cloud project ID||string|
|proxyHost|Proxy server ip/hostname||string|
|proxyPassword|Proxy authentication password||string|
|proxyPort|Proxy server port||integer|
|proxyUser|Proxy authentication user||string|
|region|SMN service region. This is lower precedence than endpoint based configuration||string|
|secretKey|Secret key for the cloud user||string|
|serviceKeys|Configuration object for cloud service authentication||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
