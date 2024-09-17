# Djl

**Since Camel 3.3**

**Only producer is supported**

The **Deep Java Library** component is used to infer deep learning
models from message exchanges data. This component uses the [Deep Java
Library](https://djl.ai/) as the underlying library.

To use the DJL component, Maven users will need to add the following
dependency to their `pom.xml`:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-djl</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    djl:application

Where `application` represents the
[application](https://javadoc.io/doc/ai.djl/api/latest/ai/djl/Application.html)
in the context of DJL, the common functional signature for a group of
deep learning models.

## Supported applications

Currently, the component supports the following applications.

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Application</th>
<th style="text-align: left;">Input types</th>
<th style="text-align: left;">Output type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>cv/image_classification</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.Image + byte[] + InputStream + File</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.Classifications</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>cv/object_detection</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.Image + byte[] + InputStream + File</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.output.DetectedObjects</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>cv/semantic_segmentation</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.Image + byte[] + InputStream + File</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.output.CategoryMask</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>cv/instance_segmentation</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.Image + byte[] + InputStream + File</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.output.DetectedObjects</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>cv/pose_estimation</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.Image + byte[] + InputStream + File</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.output.Joints</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>cv/action_recognition</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.Image + byte[] + InputStream + File</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.Classifications</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>cv/word_recognition</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.Image + byte[] + InputStream + File</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>cv/image_generation</code></p></td>
<td style="text-align: left;"><p><code>int[]</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.Image[]</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>cv/image_enhancement</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.Image + byte[] + InputStream + File</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.cv.Image</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>nlp/fill_mask</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p><code>String[]</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>nlp/question_answer</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.nlp.qa.QAInput + String[]</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>nlp/text_classification</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.Classifications</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>nlp/sentiment_analysis</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.Classifications</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>nlp/token_classification</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.Classifications</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>nlp/text_generation</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>nlp/machine_translation</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>nlp/multiple_choice</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>nlp/text_embedding</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.ndarray.NDArray</code></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>audio</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.modality.audio.Audio + byte[] + InputStream + File</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>timeseries/forecasting</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.timeseries.TimeSeriesData</code></p></td>
<td
style="text-align: left;"><p><code>ai.djl.timeseries.Forecast</code></p></td>
</tr>
</tbody>
</table>

# Usage

## Model Zoo

The following tables contain supported models in the model zoos per
application.

Those applications without a table mean that there are no pre-trained
models found for them from the basic, PyTorch, TensorFlow or MXNet DJL
model zoos. You may still find more models for an application from other
model zoos such as Hugging Face, ONNX, etc.

### CV - Image Classification

Application: `cv/image_classification`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>MLP</p></td>
<td
style="text-align: left;"><p><code>ai.djl.zoo:mlp:0.0.3</code></p></td>
<td style="text-align: left;"><p>mnist</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>MLP</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:mlp:0.0.1</code></p></td>
<td style="text-align: left;"><p>mnist</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ResNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.zoo:resnet:0.0.2</code></p></td>
<td style="text-align: left;"><p>50, flavor=v1, dataset=cifar10</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ResNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:resnet:0.0.1</code></p></td>
<td style="text-align: left;"><p>50, dataset=imagenet<br />
18, dataset=imagenet<br />
101, dataset=imagenet</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ResNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.tensorflow:resnet:0.0.1</code></p></td>
<td style="text-align: left;"><p>v1, layers=50,
dataset=imagenet</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ResNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:resnet:0.0.1</code></p></td>
<td style="text-align: left;"><p>18, flavor=v1, dataset=imagenet<br />
50, flavor=v2, dataset=imagenet<br />
101, dataset=imagenet<br />
152, flavor=v1d, dataset=imagenet<br />
50, flavor=v1, dataset=cifar10</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ResNet-18</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:resnet18_embedding:0.0.1</code></p></td>
<td style="text-align: left;"><p>{}</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>SENet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:senet:0.0.1</code></p></td>
<td style="text-align: left;"><p>154, dataset=imagenet</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>SE-ResNeXt</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:se_resnext:0.0.1</code></p></td>
<td style="text-align: left;"><p>101, flavor=32x4d,
dataset=imagenet<br />
101, flavor=64x4d, dataset=imagenet</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ResNeSt</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:resnest:0.0.1</code></p></td>
<td style="text-align: left;"><p>14, dataset=imagenet<br />
26, dataset=imagenet<br />
50, dataset=imagenet<br />
101, dataset=imagenet<br />
200, dataset=imagenet<br />
269, dataset=imagenet</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>SqueezeNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:squeezenet:0.0.1</code></p></td>
<td style="text-align: left;"><p>1.0, dataset=imagenet</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>MobileNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.tensorflow:mobilenet:0.0.1</code></p></td>
<td style="text-align: left;"><p>v2, dataset=imagenet</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>MobileNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:mobilenet:0.0.1</code></p></td>
<td style="text-align: left;"><p>v1, multiplier=0.25,
dataset=imagenet<br />
v1, multiplier=0.5, dataset=imagenet<br />
v1, multiplier=0.75, dataset=imagenet<br />
v1, multiplier=1.0, dataset=imagenet<br />
v2, multiplier=0.25, dataset=imagenet<br />
v2, multiplier=0.5, dataset=imagenet<br />
v2, multiplier=0.75, dataset=imagenet<br />
v2, multiplier=1.0, dataset=imagenet<br />
v3_small, multiplier=1.0, dataset=imagenet<br />
v3_large, multiplier=1.0, dataset=imagenet</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>GoogLeNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:googlenet:0.0.1</code></p></td>
<td style="text-align: left;"><p>imagenet</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Darknet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:darknet:0.0.1</code></p></td>
<td style="text-align: left;"><p>53, flavor=v3,
dataset=imagenet</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Inception v3</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:inceptionv3:0.0.1</code></p></td>
<td style="text-align: left;"><p>imagenet</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>AlexNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:alexnet:0.0.1</code></p></td>
<td style="text-align: left;"><p>imagenet</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>VGGNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:vgg:0.0.1</code></p></td>
<td style="text-align: left;"><p>11, dataset=imagenet<br />
13, dataset=imagenet<br />
16, dataset=imagenet<br />
19, dataset=imagenet<br />
batch_norm, layers=11, dataset=imagenet<br />
batch_norm, layers=13, dataset=imagenet<br />
batch_norm, layers=16, dataset=imagenet<br />
batch_norm, layers=19, dataset=imagenet</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>DenseNet</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:densenet:0.0.1</code></p></td>
<td style="text-align: left;"><p>121, dataset=imagenet<br />
161, dataset=imagenet<br />
169, dataset=imagenet<br />
201, dataset=imagenet</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Xception</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:xception:0.0.1</code></p></td>
<td style="text-align: left;"><p>65, dataset=imagenet</p></td>
</tr>
</tbody>
</table>

### CV - Object Detection

Application: `cv/object_detection`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>SSD</p></td>
<td
style="text-align: left;"><p><code>ai.djl.zoo:ssd:0.0.2</code></p></td>
<td style="text-align: left;"><p>tiny, dataset=pikachu</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>SSD</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:ssd:0.0.1</code></p></td>
<td style="text-align: left;"><p>300, backbone=resnet50,
dataset=coco</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>SSD</p></td>
<td
style="text-align: left;"><p><code>ai.djl.tensorflow:ssd:0.0.1</code></p></td>
<td style="text-align: left;"><p>mobilenet_v2,
dataset=openimages_v4</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>SSD</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:ssd:0.0.1</code></p></td>
<td style="text-align: left;"><p>512, backbone=resnet50, flavor=v1,
dataset=voc<br />
512, backbone=vgg16, flavor=atrous, dataset=coco<br />
512, backbone=mobilenet1.0, dataset=voc<br />
300, backbone=vgg16, flavor=atrous, dataset=voc</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>YOLO</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:yolo:0.0.1</code></p></td>
<td style="text-align: left;"><p>voc, version=3, backbone=darknet53,
imageSize=320<br />
voc, version=3, backbone=darknet53, imageSize=416<br />
voc, version=3, backbone=mobilenet1.0, imageSize=320<br />
voc, version=3, backbone=mobilenet1.0, imageSize=416<br />
coco, version=3, backbone=darknet53, imageSize=320<br />
coco, version=3, backbone=darknet53, imageSize=416<br />
coco, version=3, backbone=darknet53, imageSize=608<br />
coco, version=3, backbone=mobilenet1.0, imageSize=320<br />
coco, version=3, backbone=mobilenet1.0, imageSize=416<br />
coco, version=3, backbone=mobilenet1.0, imageSize=608</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>YOLOv5</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:yolo5s:0.0.1</code></p></td>
<td style="text-align: left;"><p>{}</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>YOLOv8</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:yolov8n:0.0.1</code></p></td>
<td style="text-align: left;"><p>{}</p></td>
</tr>
</tbody>
</table>

### CV - Semantic Segmentation

Application: `cv/semantic_segmentation`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>DeepLabV3</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:deeplabv3:0.0.1</code></p></td>
<td style="text-align: left;"><p>resnet50, flavor=v1b,
dataset=coco</p></td>
</tr>
</tbody>
</table>

### CV - Instance Segmentation

Application: `cv/instance_segmentation`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Mask R-CNN</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:mask_rcnn:0.0.1</code></p></td>
<td style="text-align: left;"><p>resnet18, flavor=v1b,
dataset=coco<br />
resnet101, flavor=v1d, dataset=coco</p></td>
</tr>
</tbody>
</table>

### CV - Pose Estimation

Application: `cv/pose_estimation`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Simple Pose</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:simple_pose:0.0.1</code></p></td>
<td style="text-align: left;"><p>resnet18, flavor=v1b,
dataset=imagenet<br />
resnet50, flavor=v1b, dataset=imagenet<br />
resnet101, flavor=v1d, dataset=imagenet<br />
resnet152, flavor=v1b, dataset=imagenet<br />
resnet152, flavor=v1d, dataset=imagenet</p></td>
</tr>
</tbody>
</table>

### CV - Action Recognition

Application: `cv/action_recognition`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Action Recognition</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:action_recognition:0.0.1</code></p></td>
<td style="text-align: left;"><p>vgg16, dataset=ucf101<br />
inceptionv3, dataset=ucf101</p></td>
</tr>
</tbody>
</table>

### CV - Image Generation

Application: `cv/image_generation`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>CycleGAN</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:cyclegan:0.0.1</code></p></td>
<td style="text-align: left;"><p>cezanne<br />
monet<br />
ukiyoe<br />
vangogh</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>BigGAN</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:biggan-deep:0.0.1</code></p></td>
<td style="text-align: left;"><p>12, size=128, dataset=imagenet<br />
24, size=256, dataset=imagenet<br />
12, size=512, dataset=imagenet</p></td>
</tr>
</tbody>
</table>

### NLP - Question Answer

Application: `nlp/question_answer`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>BertQA</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:bertqa:0.0.1</code></p></td>
<td style="text-align: left;"><p>distilbert, size=base, cased=false,
dataset=SQuAD<br />
distilbert, size=base, cased=true, dataset=SQuAD<br />
bert, cased=false, dataset=SQuAD<br />
bert, cased=true, dataset=SQuAD<br />
distilbert, cased=true, dataset=SQuAD</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>BertQA</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:bertqa:0.0.1</code></p></td>
<td style="text-align: left;"><p>bert,
dataset=book_corpus_wiki_en_uncased</p></td>
</tr>
</tbody>
</table>

### NLP - Sentiment Analysis

Application: `nlp/sentiment_analysis`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>DistilBERT</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:distilbert:0.0.1</code></p></td>
<td style="text-align: left;"><p>distilbert, dataset=sst</p></td>
</tr>
</tbody>
</table>

### NLP - Word Embedding

Application: `nlp/word_embedding`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>GloVe</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:glove:0.0.2</code></p></td>
<td style="text-align: left;"><p>50</p></td>
</tr>
</tbody>
</table>

### Time Series - Forecasting

Application: `timeseries/forecasting`

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Model family</th>
<th style="text-align: left;">Artifact ID</th>
<th style="text-align: left;">Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>DeepAR</p></td>
<td
style="text-align: left;"><p><code>ai.djl.pytorch:deepar:0.0.1</code></p></td>
<td style="text-align: left;"><p>m5forecast</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>DeepAR</p></td>
<td
style="text-align: left;"><p><code>ai.djl.mxnet:deepar:0.0.1</code></p></td>
<td style="text-align: left;"><p>airpassengers<br />
m5forecast</p></td>
</tr>
</tbody>
</table>

## DJL Engine implementation

Because DJL is deep learning framework-agnostic, you don’t have to make
a choice between frameworks when creating your projects. You can switch
frameworks at any point. To ensure the best performance, DJL also
provides automatic CPU/GPU choice based on hardware configuration.

### PyTorch engine

You can pull the PyTorch engine from the central Maven repository by
including the following dependency:

    <dependency>
        <groupId>ai.djl.pytorch</groupId>
        <artifactId>pytorch-engine</artifactId>
        <version>x.x.x</version>
        <scope>runtime</scope>
    </dependency>

By default, DJL will download the PyTorch native libraries into the
[cache
folder](https://docs.djl.ai/docs/development/cache_management.html) the
first time you run DJL. It will automatically determine the appropriate
jars for your system based on the platform and GPU support.

More information about [PyTorch engine
installation](https://docs.djl.ai/engines/pytorch/index.html)

### TensorFlow engine

You can pull the TensorFlow engine from the central Maven repository by
including the following dependency:

    <dependency>
        <groupId>ai.djl.tensorflow</groupId>
        <artifactId>tensorflow-engine</artifactId>
        <version>x.x.x</version>
        <scope>runtime</scope>
    </dependency>

By default, DJL will download the TensorFlow native libraries into
[cache
folder](https://docs.djl.ai/docs/development/cache_management.html) the
first time you run DJL. It will automatically determine the appropriate
jars for your system based on the platform and GPU support.

More information about [TensorFlow engine
installation](https://docs.djl.ai/engines/tensorflow/index.html)

### MXNet engine

You can pull the MXNet engine from the central Maven repository by
including the following dependency:

    <dependency>
        <groupId>ai.djl.mxnet</groupId>
        <artifactId>mxnet-engine</artifactId>
        <version>x.x.x</version>
        <scope>runtime</scope>
    </dependency>

By default, DJL will download the Apache MXNet native libraries into
[cache
folder](https://docs.djl.ai/docs/development/cache_management.html) the
first time you run DJL. It will automatically determine the appropriate
jars for your system based on the platform and GPU support.

More information about [MXNet engine
installation](https://docs.djl.ai/engines/mxnet/index.html)

# Examples

**MNIST image classification from file**

    from("file:/data/mnist/0/10.png")
        .to("djl:cv/image_classification?artifactId=ai.djl.mxnet:mlp:0.0.1");

**Object detection**

    from("file:/data/mnist/0/10.png")
        .to("djl:cv/image_classification?artifactId=ai.djl.mxnet:mlp:0.0.1");

**Custom deep learning model**

    // create a deep learning model
    Model model = Model.newInstance();
    model.setBlock(new Mlp(28 * 28, 10, new int[]{128, 64}));
    model.load(Paths.get(MODEL_DIR), MODEL_NAME);
    
    // create translator for pre-processing and postprocessing
    ImageClassificationTranslator.Builder builder = ImageClassificationTranslator.builder();
    builder.setSynsetArtifactName("synset.txt");
    builder.setPipeline(new Pipeline(new ToTensor()));
    builder.optApplySoftmax(true);
    ImageClassificationTranslator translator = new ImageClassificationTranslator(builder);
    
    // Bind model and translator beans
    context.getRegistry().bind("MyModel", model);
    context.getRegistry().bind("MyTranslator", translator);
    
    from("file:/data/mnist/0/10.png")
        .to("djl:cv/image_classification?model=MyModel&translator=MyTranslator");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|application|Application name||string|
|artifactId|Model Artifact||string|
|model|Model||string|
|showProgress|Show progress while loading zoo models. This parameter takes effect only with zoo models|false|boolean|
|translator|Translator||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
