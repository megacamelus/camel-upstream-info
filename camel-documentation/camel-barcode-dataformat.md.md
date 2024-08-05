# Barcode-dataformat.md

**Since Camel 2.14**

The Barcode data format is based on the [zxing
library](https://github.com/zxing/zxing). The goal of this component is
to create a barcode image from a String (marshal) and a String from a
barcode image (unmarshal). You’re free to use all features that zxing
offers.

# Dependencies

To use the barcode data format in your camel routes, you need to add a
dependency on **camel-barcode** which implements this data format.

If you use maven, you could just add the following to your pom.xml,
substituting the version number for the latest \& greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-barcode</artifactId>
      <version>x.x.x</version>
    </dependency>

# Barcode Options

# Using the Java DSL

First, you have to initialize the barcode data format class. You can use
the default constructor, or one of parameterized (see JavaDoc). The
default values are:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Parameter</th>
<th style="text-align: left;">Default Value</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>image type (BarcodeImageType)</p></td>
<td style="text-align: left;"><p>PNG</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>width</p></td>
<td style="text-align: left;"><p>100 px</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>height</p></td>
<td style="text-align: left;"><p>100 px</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>encoding</p></td>
<td style="text-align: left;"><p>UTF-8</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>barcode format (BarcodeFormat)</p></td>
<td style="text-align: left;"><p>QR-Code</p></td>
</tr>
</tbody>
</table>

    // QR-Code default
    DataFormat code = new BarcodeDataFormat();

If you want to use zxing hints, you can use the *addToHintMap* method of
your BarcodeDataFormat instance:

    code.addToHintMap(DecodeHintType.TRY_HARDER, Boolean.true);

For possible hints, please consult the xzing documentation.

## Marshalling

    from("direct://code")
      .marshal(code)
      .to("file://barcode_out");

You can call the route from a test class with:

    template.sendBody("direct://code", "This is a testmessage!");

You should find inside the *barcode\_out* folder this image:

<figure>
<img src="ROOT:qr-code.png" alt="image" />
</figure>

## Unmarshalling

The unmarshaller is generic. For unmarshalling, you can use any
BarcodeDataFormat instance. If you’ve two instances, one for
(generating) QR-Code and one for PDF417, it doesn’t matter which one
will be used.

    from("file://barcode_in?noop=true")
      .unmarshal(code) // for unmarshalling, the instance doesn't matter
      .to("mock:out");

If you’ll paste the QR-Code image above into the *barcode\_in* folder,
you should find *`This is a testmessage!`* inside the mock. You can find
the barcode data format as header variable:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>BarcodeFormat</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Value of
com.google.zxing.BarcodeFormat.</p></td>
</tr>
</tbody>
</table>

If you’ll paste the code 39 barcode that is rotated some degrees into
the *barcode\_in* folder, You can find the ORIENTATION as header
variable:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>ORIENTATION</p></td>
<td style="text-align: left;"><p>Integer</p></td>
<td style="text-align: left;"><p>rotate value in degrees .</p></td>
</tr>
</tbody>
</table>
