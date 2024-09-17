# Hwcloud-imagerecognition

**Since Camel 3.12**

**Only producer is supported**

Huawei Cloud Image Recognition component allows you to integrate with
[Image
Recognition](https://www.huaweicloud.com/intl/en-us/product/image.html)
provided by Huawei Cloud.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-huaweicloud-imagerecognition</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    hwcloud-imagerecognition:operation[?options]

When using imageContent option, we suggest you use
RAW(image\_base64\_value) to avoid encoding issue.

# Usage

## Message properties evaluated by the Image Recognition producer

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
style="text-align: left;"><p><code>CamelHwCloudImageContent</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The Base64 character string converted
from the image</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHwCloudImageUrl</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The URL of an image</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudImageTagLimit</code></p></td>
<td style="text-align: left;"><p><code>Integer</code></p></td>
<td style="text-align: left;"><p>The maximum number of the returned tags
when the operation is tagRecognition</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHwCloudImageTagLanguage</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The language of the returned tags when
the operation is tagRecognition</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudImageThreshold</code></p></td>
<td style="text-align: left;"><p><code>Integer</code></p></td>
<td style="text-align: left;"><p>The threshold of confidence.</p></td>
</tr>
</tbody>
</table>

## List of Supported Image Recognition Operations

-   celebrityRecognition - to analyze and identify the political
    figures, stars and online celebrities contained in the picture, and
    return the person information and face coordinates

-   tagRecognition - to recognize hundreds of scenes and thousands of
    objects and their properties in natural images

## Inline Configuration of route

### celebrityRecognition

Java DSL

    from("direct:triggerRoute")
      .setProperty(ImageRecognitionProperties.IMAGE_URL, constant("https://xxxx"))
      .setProperty(ImageRecognitionProperties.THRESHOLD,constant(0.5))
      .to("hwcloud-imagerecognition:celebrityRecognition?accessKey=*********&secretKey=********&projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&region=cn-north-4")

XML DSL

    <route>
       <from uri="direct:triggerRoute" />
       <setProperty name="CamelHwCloudImageUrl">
          <constant>https://xxxx</constant>
       </setProperty>
       <setProperty name="CamelHwCloudImageThreshold">
          <constant>0.5</constant>
       </setProperty>
       <to uri="hwcloud-imagerecognition:celebrityRecognition?accessKey=*********&amp;secretKey=********&amp;projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&amp;region=cn-north-4" />
    </route>

## tagRecognition

Java DSL

    from("direct:triggerRoute")
      .setProperty(ImageRecognitionProperties.IMAGE_CONTENT, constant("/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAA0JCgsKCA0LCgsODg0PEyAVExISEyccHhcgLikxMC4pLSwzOko+MzZGNywtQFdBRkxOUlNSMj5aYVpQYEpRUk//..."))
      .setProperty(ImageRecognitionProperties.THRESHOLD,constant(60))
      .setProperty(ImageRecognitionProperties.TAG_LANGUAGE,constant("en"))
      .setProperty(ImageRecognitionProperties.TAG_LIMIT,constant(50))
      .to("hwcloud-imagerecognition:tagRecognition?accessKey=*********&secretKey=********&projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&region=cn-north-4")

XML DSL

    <route>
        <from uri="direct:triggerRoute" />
        <setProperty name="CamelHwCloudImageContent">
            <constant>/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAA0JCgsKCA0LCgsODg0PEyAVExISEyccHhcgLikxMC4pLSwzOko+MzZGNywtQFdBRkxOUlNSMj5aYVpQYEpRUk//...</constant>
        </setProperty>
        <setProperty name="CamelHwCloudImageThreshold">
            <constant>60</constant>
        </setProperty>
        <setProperty name="CamelHwCloudImageTagLanguage">
            <constant>en</constant>
        </setProperty>
        <setProperty name="CamelHwCloudImageTagLimit">
            <constant>50</constant>
        </setProperty>
        <to uri="hwcloud-imagerecognition:tagRecognition?accessKey=*********&amp;secretKey=********&amp;projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&amp;region=cn-north-4" />
    </route>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|Name of Image Recognition operation to perform, including celebrityRecognition and tagRecognition||string|
|accessKey|Access key for the cloud user||string|
|endpoint|Fully qualified Image Recognition service url. Carries higher precedence than region based configuration.||string|
|imageContent|Indicates the Base64 character string converted from the image. The size cannot exceed 10 MB. The image resolution of the narrow sides must be greater than 15 pixels, and that of the wide sides cannot exceed 4096 pixels.The supported image formats include JPG, PNG, and BMP. Configure either this parameter or imageUrl, and this one carries higher precedence than imageUrl.||string|
|imageUrl|Indicates the URL of an image. The options are as follows: HTTP/HTTPS URLs on the public network OBS URLs. To use OBS data, authorization is required, including service authorization, temporary authorization, and anonymous public authorization. For details, see Configuring the Access Permission of OBS. Configure either this parameter or imageContent, and this one carries lower precedence than imageContent.||string|
|projectId|Cloud project ID||string|
|proxyHost|Proxy server ip/hostname||string|
|proxyPassword|Proxy authentication password||string|
|proxyPort|Proxy server port||integer|
|proxyUser|Proxy authentication user||string|
|region|Image Recognition service region. Currently only cn-north-1 and cn-north-4 are supported. This is lower precedence than endpoint based configuration.||string|
|secretKey|Secret key for the cloud user||string|
|serviceKeys|Configuration object for cloud service authentication||object|
|tagLanguage|Indicates the language of the returned tags when the operation is tagRecognition, including zh and en.|zh|string|
|tagLimit|Indicates the maximum number of the returned tags when the operation is tagRecognition.|50|integer|
|threshold|Indicates the threshold of confidence. When the operation is tagRecognition, this parameter ranges from 0 to 100. Tags whose confidence score is lower than the threshold will not be returned. The default value is 60. When the operation is celebrityRecognition, this parameter ranges from 0 to 1. Labels whose confidence score is lower than the threshold will not be returned. The default value is 0.48.||number|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|ignoreSslVerification|Ignore SSL verification|false|boolean|
