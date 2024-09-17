# Hwcloud-frs

**Since Camel 3.15**

**Only producer is supported**

Huawei Cloud Face Recognition Service component allows you to integrate
with [Face Recognition
Service](https://support.huaweicloud.com/intl/en-us/productdesc-face/face_01_0001.html)
provided by Huawei Cloud.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-huaweicloud-frs</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    hwcloud-frs:operation[?options]

When using imageBase64 or videoBase64 option, we suggest you use
RAW(base64\_value) to avoid encoding issue.

# Usage

## Message properties evaluated by the Face Recognition Service producer

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
style="text-align: left;"><p><code>CamelHwCloudFrsImageBase64</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The Base64 character string converted
from an image. This property can be used when the operation is
faceDetection or faceVerification.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHwCloudFrsImageUrl</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The URL of an image. This property can
be used when the operation is faceDetection or
faceVerification.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudFrsImageFilePath</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The local file path of an image. This
property can be used when the operation is faceDetection or
faceVerification.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHwCloudFrsAnotherImageBase64</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The Base64 character string converted
from another image. This property can be used when the operation is
faceVerification.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudFrsAnotherImageUrl</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The URL of another image. This property
can be used when the operation is faceVerification.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHwCloudFrsAnotherImageFilePath</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The local file path of another image.
This property can be used when the operation is
faceVerification.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudFrsVideoBase64</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The Base64 character string converted
from a video. This property can be used when the operation is
faceLiveDetection.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHwCloudFrsVideoUrl</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The URL of a video. This property can
be used when the operation is faceLiveDetection.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudFrsVideoFilePath</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The local file path of a video. This
property can be used when the operation is faceLiveDetection.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHwCloudFrsVideoActions</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The action code sequence list. This
property can be used when the operation is faceLiveDetection.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHwCloudFrsVideoActionTimes</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The action time array. This property is
used when the operation is faceLiveDetection.</p></td>
</tr>
</tbody>
</table>

## List of Supported Operations

-   faceDetection - detect, locate, and analyze the face in an input
    image, and output the key facial points and attributes.

-   faceVerification - compare two faces to verify whether they belong
    to the same person and return the confidence level

-   faceLiveDetection - determine whether a person in a video is alive
    by checking whether the person’s actions in the video are consistent
    with those in the input action list

## Inline Configuration of route

### faceDetection

Java DSL

    from("direct:triggerRoute")
      .setProperty(FaceRecognitionProperties.FACE_IMAGE_URL, constant("https://xxxx"))
      .to("hwcloud-frs:faceDetection?accessKey=*********&secretKey=********&projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&region=cn-north-4")

XML DSL

    <route>
       <from uri="direct:triggerRoute" />
       <setProperty name="CamelHwCloudFrsImageUrl">
          <constant>https://xxxx</constant>
       </setProperty>
       <to uri="hwcloud-frs:faceDetection?accessKey=*********&amp;secretKey=********&amp;projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&amp;region=cn-north-4" />
    </route>

## faceVerification

Java DSL

    from("direct:triggerRoute")
      .setProperty(FaceRecognitionProperties.FACE_IMAGE_BASE64, constant("/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAA0JCgsKCA0LCgsODg0PEyAVExISEyccHhcgLikxMC4pLSwzOko+MzZGNywtQFdBRkxOUlNSMj5aYVpQYEpRUk..."))
      .setProperty(FaceRecognitionProperties.ANOTHER_FACE_IMAGE_BASE64, constant("/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgFBgcGBQgHBgcJCAgJDBMMDAsLDBgREg4THBgdHRsYGxofIywlHyEqIRobJjQnKi4vMTIxHiU2Os..."))
      .to("hwcloud-frs:faceVerification?accessKey=*********&secretKey=********&projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&region=cn-north-4")

XML DSL

    <route>
        <from uri="direct:triggerRoute" />
        <setProperty name="CamelHwCloudFrsImageBase64">
            <constant>/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAA0JCgsKCA0LCgsODg0PEyAVExISEyccHhcgLikxMC4pLSwzOko+MzZGNywtQFdBRkxOUlNSMj5aYVpQYEpRUk...</constant>
        </setProperty>
        <setProperty name="CamelHwCloudFrsAnotherImageBase64">
            <constant>/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgFBgcGBQgHBgcJCAgJDBMMDAsLDBgREg4THBgdHRsYGxofIywlHyEqIRobJjQnKi4vMTIxHiU2Os...</constant>
        </setProperty>
        <to uri="hwcloud-frs:faceVerification?accessKey=*********&amp;secretKey=********&amp;projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&amp;region=cn-north-4" />
    </route>

## faceLiveDetection

Java DSL

    from("direct:triggerRoute")
      .setProperty(FaceRecognitionProperties.FACE_VIDEO_FILE_PATH, constant("/tmp/video.mp4"))
      .setProperty(FaceRecognitionProperties.FACE_VIDEO_ACTIONS, constant("1,3,2"))
      .to("hwcloud-frs:faceLiveDetection?accessKey=*********&secretKey=********&projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&region=cn-north-4")

XML DSL

    <route>
        <from uri="direct:triggerRoute" />
        <setProperty name="CamelHwCloudFrsVideoFilePath">
            <constant>/tmp/video.mp4</constant>
        </setProperty>
        <setProperty name="CamelHwCloudFrsVideoActions">
            <constant>1,3,2</constant>
        </setProperty>
        <to uri="hwcloud-frs:faceLiveDetection?accessKey=*********&amp;secretKey=********&amp;projectId=9071a38e7f6a4ba7b7bcbeb7d4ea6efc&amp;region=cn-north-4" />
    </route>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|Name of Face Recognition operation to perform, including faceDetection, faceVerification and faceLiveDetection||string|
|accessKey|Access key for the cloud user||string|
|actions|This param is mandatory when the operation is faceLiveDetection, indicating the action code sequence list. Actions are separated by commas (,). Currently, the following actions are supported: 1: Shake the head to the left. 2: Shake the head to the right. 3: Nod the head. 4: Mouth movement.||string|
|actionTimes|This param can be used when the operation is faceLiveDetection, indicating the action time array. The length of the array is the same as the number of actions. Each item contains the start time and end time of the action in the corresponding sequence. The unit is the milliseconds from the video start time.||string|
|anotherImageBase64|This param can be used when operation is faceVerification, indicating the Base64 character string converted from the other image. It needs to be configured if imageBase64 is set. The image size cannot exceed 10 MB. The image resolution of the narrow sides must be greater than 15 pixels, and that of the wide sides cannot exceed 4096 pixels. The supported image formats include JPG, PNG, and BMP.||string|
|anotherImageFilePath|This param can be used when operation is faceVerification, indicating the local file path of the other image. It needs to be configured if imageFilePath is set. Image size cannot exceed 8 MB, and it is recommended that the image size be less than 1 MB.||string|
|anotherImageUrl|This param can be used when operation is faceVerification, indicating the URL of the other image. It needs to be configured if imageUrl is set. The options are as follows: 1.HTTP/HTTPS URLs on the public network 2.OBS URLs. To use OBS data, authorization is required, including service authorization, temporary authorization, and anonymous public authorization. For details, see Configuring the Access Permission of OBS.||string|
|endpoint|Fully qualified Face Recognition service url. Carries higher precedence than region based configuration.||string|
|imageBase64|This param can be used when operation is faceDetection or faceVerification, indicating the Base64 character string converted from an image. Any one of imageBase64, imageUrl and imageFilePath needs to be set, and the priority is imageBase64 imageUrl imageFilePath. The Image size cannot exceed 10 MB. The image resolution of the narrow sides must be greater than 15 pixels, and that of the wide sides cannot exceed 4096 pixels. The supported image formats include JPG, PNG, and BMP.||string|
|imageFilePath|This param can be used when operation is faceDetection or faceVerification, indicating the local image file path. Any one of imageBase64, imageUrl and imageFilePath needs to be set, and the priority is imageBase64 imageUrl imageFilePath. Image size cannot exceed 8 MB, and it is recommended that the image size be less than 1 MB.||string|
|imageUrl|This param can be used when operation is faceDetection or faceVerification, indicating the URL of an image. Any one of imageBase64, imageUrl and imageFilePath needs to be set, and the priority is imageBase64 imageUrl imageFilePath. The options are as follows: 1.HTTP/HTTPS URLs on the public network 2.OBS URLs. To use OBS data, authorization is required, including service authorization, temporary authorization, and anonymous public authorization. For details, see Configuring the Access Permission of OBS.||string|
|projectId|Cloud project ID||string|
|proxyHost|Proxy server ip/hostname||string|
|proxyPassword|Proxy authentication password||string|
|proxyPort|Proxy server port||integer|
|proxyUser|Proxy authentication user||string|
|region|Face Recognition service region. Currently only cn-north-1 and cn-north-4 are supported. This is lower precedence than endpoint based configuration.||string|
|secretKey|Secret key for the cloud user||string|
|serviceKeys|Configuration object for cloud service authentication||object|
|videoBase64|This param can be used when operation is faceLiveDetection, indicating the Base64 character string converted from a video. Any one of videoBase64, videoUrl and videoFilePath needs to be set, and the priority is videoBase64 videoUrl videoFilePath. Requirements are as follows: 1.The video size after Base64 encoding cannot exceed 8 MB. It is recommended that the video file be compressed to 200 KB to 2 MB on the client. 2.The video duration must be 1 to 15 seconds. 3.The recommended frame rate is 10 fps to 30 fps. 4.The encapsulation format can be MP4, AVI, FLV, WEBM, ASF, or MOV. 5.The video encoding format can be H.261, H.263, H.264, HEVC, VC-1, VP8, VP9, or WMV3.||string|
|videoFilePath|This param can be used when operation is faceLiveDetection, indicating the local video file path. Any one of videoBase64, videoUrl and videoFilePath needs to be set, and the priority is videoBase64 videoUrl videoFilePath. The video requirements are as follows: 1.The size of a video file cannot exceed 8 MB. It is recommended that the video file be compressed to 200 KB to 2 MB on the client. 2.The video duration must be 1 to 15 seconds. 3.The recommended frame rate is 10 fps to 30 fps. 4.The encapsulation format can be MP4, AVI, FLV, WEBM, ASF, or MOV. 5.The video encoding format can be H.261, H.263, H.264, HEVC, VC-1, VP8, VP9, or WMV3.||string|
|videoUrl|This param can be used when operation is faceLiveDetection, indicating the URL of a video. Any one of videoBase64, videoUrl and videoFilePath needs to be set, and the priority is videoBase64 videoUrl videoFilePath. Currently, only the URL of an OBS bucket on HUAWEI CLOUD is supported and FRS must have the permission to read data in the OBS bucket. For details about how to enable the read permission, see Service Authorization. The video requirements are as follows: 1.The video size after Base64 encoding cannot exceed 8 MB. 2.The video duration must be 1 to 15 seconds. 3.The recommended frame rate is 10 fps to 30 fps. 4.The encapsulation format can be MP4, AVI, FLV, WEBM, ASF, or MOV. 5.The video encoding format can be H.261, H.263, H.264, HEVC, VC-1, VP8, VP9, or WMV3.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|ignoreSslVerification|Ignore SSL verification|false|boolean|
