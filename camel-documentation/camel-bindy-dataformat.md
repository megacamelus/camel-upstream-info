# Bindy-dataformat.md

**Since Camel 2.0**

The goal of this component is to allow the parsing/binding of
non-structured data (or to be more precise non-XML data)  
to/from Java Beans that have binding mappings defined with annotations.
Using Bindy, you can bind data from sources such as:

-   CSV records,

-   Fixed-length records,

-   *FIX messages*,

-   or almost any other non-structured data

to one or many Plain Old Java Object (POJO). Bindy converts the data
according to the type of the java property. POJOs can be linked together
with one-to-many relationships available in some cases. Moreover, for
data type like Date, LocalDate, LocalTime, LocalDateTime, ZonedDateTime,
Double, Float, Integer, Short, Long and BigDecimal, you can provide the
pattern to apply during the formatting of the property.

For the BigDecimal numbers, you can also define the precision and the
decimal or grouping separators.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Format Type</th>
<th style="text-align: left;">Pattern example</th>
<th style="text-align: left;">Link</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Date</p></td>
<td style="text-align: left;"><p><code>DateFormat</code></p></td>
<td style="text-align: left;"><p><code>dd-MM-yyyy</code></p></td>
<td style="text-align: left;"><p><a
href="https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/SimpleDateFormat.html">https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/SimpleDateFormat.html</a></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Decimal*</p></td>
<td style="text-align: left;"><p><code>DecimalFormat</code></p></td>
<td style="text-align: left;"><p><code>..##</code></p></td>
<td style="text-align: left;"><p><a
href="https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/DecimalFormat.html">https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/DecimalFormat.html</a></p></td>
</tr>
</tbody>
</table>

\*Decimal = Double, Integer, Float, Short, Long

**Format supported**

This first release only supports comma separated values fields and key
value pair fields (e.g.: *FIX messages*).

To work with camel-bindy, you must first define your model in a package
(e.g. `com.acme.model`) and for each model class (e.g., `Order`,
`Client`, `Instrument`, …) add the required annotations (described
hereafter) to the Class or field.

**Multiple models**

As you configure bindy using class names, instead of package names, you
can put multiple models in the same package.

# Options

# Usage

## Annotations

The annotations created allow mapping different concept of your model to
the POJO like:

-   Type of record (CSV, key value pair (e.g., *FIX message*), fixed
    length …),

-   Link (to link an object in another object),

-   DataField and their properties (int, type, …),

-   KeyValuePairField (for key = value format like we have in FIX
    financial messages),

-   Section (to identify a header, body and footer section),

-   OneToMany,

-   BindyConverter,

-   FormatFactories

This section will describe them.

## 1. CsvRecord

The CsvRecord annotation is used to identify the root class of the
model. It represents a record = "a line of a CSV file" and can be linked
to several children’s model classes.

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Annotation name</th>
<th style="text-align: left;">Record type</th>
<th style="text-align: left;">Level</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>CsvRecord</strong></p></td>
<td style="text-align: left;"><p>CSV</p></td>
<td style="text-align: left;"><p>Class</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Default value</th>
<th style="text-align: left;">Info</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>separator</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>✓</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code> Separator used to split a record in tokens (mandatory) - can be &#39;,&#39; or &#39;;&#39; or &#39;anything&#39;. The only whitespace
character supported is tab (\t). No other whitespace characters (spaces) are not supported. This value is
interpreted as a regular expression. If you want to use a sign which has a special meaning in regular
expressions, e.g., the &#39;|&#39; sign, then you have to mask it, like &#39;|&#39;</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>allowEmptyStream</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>The allowEmptyStream parameter will
allow to prcoess the unavaiable stream for CSV file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>autospanLine</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><pre><code> Last record spans rest of line (optional) - if enabled then the last column is auto spanned to end of line, for
example if it is a comment, etc this allows the line to contain all characters, also the delimiter char.</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>crlf</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>WINDOWS</p></td>
<td style="text-align: left;"><pre><code> Character to be used to add a carriage return after each record (optional) - allow defining the carriage return
character to use. If you specify a value other than the three listed before, the value you enter (custom) will be
used as the CRLF character(s). Three values can be used : WINDOWS, UNIX, MAC, or custom.</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>endWithLineBreak</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>The endWithLineBreak parameter flags if
the CSV file should end with a line break or not (optional)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>generateHeaderColumns</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>The generateHeaderColumns parameter
allow to add in the CSV generated the header containing names of the
columns</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>isOrdered</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Indicates if the message must be
ordered in output</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>name</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Name describing the record
(optional)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>quote</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>"</p></td>
<td style="text-align: left;"><pre><code> Whether to marshal columns with the given quote character (optional) - allow to specify a quote character of the
fields when CSV is generated. This annotation is associated to the root class of the model and must be declared
one time.</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>quoting</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Indicate if the values (and headers)
must be quoted when marshaling (optional)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>quotingEscaped</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Indicate if the values must be escaped
when quoting (optional)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>quotingOnlyWhenNeeded</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><pre><code> Indicate if the values should be quoted only when needed (optional) - if enabled then the value is only quoted
when it contains the configured separator, quote, or crlf characters. The quoting option must also be enabled.</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>removeQuotes</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>The remove quotes parameter flags if
unmarshalling should try to remove quotes for each field</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>skipField</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><pre><code> The skipField parameter will allow skipping fields of a CSV file. If some fields are not necessary, they can be
skipped.</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>skipFirstLine</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><pre><code> The skipFirstLine parameter will allow skipping or not the first line of a CSV file. This line often contains
columns definition</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>trimLine</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>Whether to trim each line (stand and
end) before parsing the line into data fields.</p></td>
</tr>
</tbody>
</table>

**case 1:separator = *,***

The separator used to segregate the fields in the CSV record is `,` :

    10, J, Pauline, M, XD12345678, Fortis Dynamic 15/15, 2500, USD, 08-01-2009
    
    @CsvRecord( separator = "," )
    public Class Order {
    
    }

**case 2:separator = *;***

Compare to the previous case, the separator here is `;` instead of `,` :

    10; J; Pauline; M; XD12345678; Fortis Dynamic 15/15; 2500; USD; 08-01-2009
    
    @CsvRecord( separator = ";" )
    public Class Order {
    
    }

**case 3:separator = *\|***

Compare to the previous case, the separator here is `|` instead of `;` :

    10| J| Pauline| M| XD12345678| Fortis Dynamic 15/15| 2500| USD| 08-01-2009
    
    @CsvRecord( separator = "\\|" )
    public Class Order {
    
    }

**case 4:separator = *\\,\\***

**Applies for Camel 2.8.2 or older**

When the field to be parsed of the CSV record contains `,` or `;` which
is also used as separator, we should find another strategy to tell camel
bindy how to handle this case. To define the field containing the data
with a comma, you will use single or double quotes as delimiter (e.g.:
*10*, *Street 10, NY*, *USA* or "10", "Street 10, NY", "USA").

In this case, bindy will remove the first and last character of the line
which is a single or double quotes.

    "10","J","Pauline"," M","XD12345678","Fortis Dynamic 15,15","2500","USD","08-01-2009"
    
    @CsvRecord( separator = "\",\"" )
    public Class Order {
    
    }

Bindy automatically detects if the record is enclosed with either single
or double quotes and automatically removes those quotes when
unmarshalling from CSV to Object. Therefore, do **not** include the
quotes in the separator, but do as below:

    "10","J","Pauline"," M","XD12345678","Fortis Dynamic 15,15","2500","USD","08-01-2009"
    
    @CsvRecord( separator = "," )
    public Class Order {
    
    }

Notice that if you want to marshal from Object to CSV and use quotes,
then you need to specify which quote character to use, using the `quote`
attribute on the `@CsvRecord` as shown below:

    @CsvRecord( separator = ",", quote = "\"" )
    public Class Order {
    
    }

**case 5:separator \& skipFirstLine**

The feature is interesting when the client wants to have in the first
line of the file, the name of the data fields :

    order id, client id, first name, last name, isin code, instrument name, quantity, currency, date

To inform bindy that this first line must be skipped during the parsing
process, then we use the attribute :

    @CsvRecord(separator = ",", skipFirstLine = true)
    public Class Order {
    
    }

**case 6:generateHeaderColumns**

To include at the first line of the CSV generated, the attribute
`generateHeaderColumns` must be set to true in the annotation like this
:

    @CsvRecord( generateHeaderColumns = true )
    public Class Order {
    
    }

As a result, Bindy during the unmarshalling process will generate CSV
like this:

    order id, client id, first name, last name, isin code, instrument name, quantity, currency, date
    10, J, Pauline, M, XD12345678, Fortis Dynamic 15/15, 2500, USD, 08-01-2009

**case 7: carriage return**

If the platform where camel-bindy will run is not Windows but Macintosh
or Unix, then you can change the crlf property like this. Three values
are available: `WINDOWS`, `UNIX` or `MAC`.

    @CsvRecord(separator = ",", crlf="MAC")
    public Class Order {
    
    }

Additionally, if for some reason you need to add a different line ending
character, you can opt to specify it using the crlf parameter. In the
following example, we can end the line with a comma followed by the
newline character:

    @CsvRecord(separator = ",", crlf=",\n")
    public Class Order {
    
    }

**case 8: isOrdered**

Sometimes, the order to follow during the creation of the CSV record
from the model is different from the order used during the parsing.
Then, in this case, we can use the attribute `isOrdered = true` to
indicate this in combination with attribute `position` of the DataField
annotation.

    @CsvRecord(isOrdered = true)
    public Class Order {
    
       @DataField(pos = 1, position = 11)
       private int orderNr;
    
       @DataField(pos = 2, position = 10)
       private String clientNr;
    
    }

`pos` is used to parse the file stream, while `position` is used to
generate the CSV.

## 2. Link

The link annotation will allow linking objects together.

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Annotation name</th>
<th style="text-align: left;">Record type</th>
<th style="text-align: left;">Level</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>Link</strong></p></td>
<td style="text-align: left;"><p>all</p></td>
<td style="text-align: left;"><p>Class &amp; Property</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Default value</th>
<th style="text-align: left;">Info</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>linkType</p></td>
<td style="text-align: left;"><p>LinkType</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>OneToOne</p></td>
<td style="text-align: left;"><p>Type of link identifying the relation
between the classes</p></td>
</tr>
</tbody>
</table>

Only one-to-one relation is allowed as of the current version.

E.g.: If the model class Client is linked to the Order class, then use
annotation Link in the Order class like this :

**Property Link**

    @CsvRecord(separator = ",")
    public class Order {
    
        @DataField(pos = 1)
        private int orderNr;
    
        @Link
        private Client client;
    }

And for the class Client :

**Class Link**

    @Link
    public class Client {
    
    }

## 3. DataField

The DataField annotation defines the property of the field. Each
datafield is identified by its position in the record, a type (string,
int, date, …) and optionally of a pattern.

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Annotation name</th>
<th style="text-align: left;">Record type</th>
<th style="text-align: left;">Level</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>DataField</strong></p></td>
<td style="text-align: left;"><p>all</p></td>
<td style="text-align: left;"><p>Property</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Default value</th>
<th style="text-align: left;">Info</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>pos</p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"><p>✓</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Position of the data in the input
record, must start from 1 (mandatory). See the position
parameter.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>align</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>R</p></td>
<td style="text-align: left;"><p>Align the text to the right or left.
Use values &lt;tt&gt;R&lt;/tt&gt; or &lt;tt&gt;L&lt;/tt&gt;.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>clip</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Indicates to clip data in the field if
it exceeds the allowed length when using fixed length.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>columnName</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code> Name of the header column (optional). Uses the name of the property as default. Only applicable when `CsvRecord`
has `generateHeaderColumns = true`</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>decimalSeparator</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Decimal Separator to be used with
BigDecimal number</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>defaultValue</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Field’s default value in case no value
is set</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>delimiter</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Optional delimiter to be used if the
field has a variable length</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>groupingSeparator</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code> Grouping Separator to be used with BigDecimal number when we would like to format/parse to number with grouping
e.g. 123,456.789</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>impliedDecimalSeparator</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Indicates if there is a decimal point
implied at a specified location</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>length</p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><p>Length of the data block (number of
characters) if the record is set to a fixed length</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>lengthPos</p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><p>Identifies a data field in the record
that defines the expected fixed length for this field</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>method</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code> Method name to call to apply such customization on DataField. This must be the method on the datafield itself or
you must provide static fully qualified name of the class&#39;s method e.g: see unit test
org.apache.camel.dataformat.bindy.csv.BindySimpleCsvFunctionWithExternalMethodTest.replaceToBar</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>name</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Name of the field (optional)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>paddingChar</p></td>
<td style="text-align: left;"><p>char</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>The char to pad with if the record is
set to a fixed length</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>pattern</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code> Pattern that the Java formatter (SimpleDateFormat by example) will use to transform the data (optional). If using
pattern, then setting locale on bindy data format is recommended. Either set to a known locale such as &quot;us&quot; or
use &quot;default&quot; to use platform default locale.</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>position</p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><pre><code> Position of the field in the output message generated (should start from 1). Must be used when the position of
the field in the CSV generated (output message) must be different compare to input position (pos). See the pos
parameter.</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>precision</p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><p>precision of the {@link
java.math.BigDecimal} number to be created</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>required</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Indicates if the field is
mandatory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>rounding</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>CEILING</p></td>
<td style="text-align: left;"><pre><code> Round mode to be used to round/scale a BigDecimal Values : UP, DOWN, CEILING, FLOOR, HALF_UP,
HALF_DOWN,HALF_EVEN, UNNECESSARY e.g : Number = 123456.789, Precision = 2, Rounding = CEILING Result : 123456.79</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>timezone</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Timezone to be used.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>trim</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Indicates if the value should be
trimmed</p></td>
</tr>
</tbody>
</table>

**case 1: pos**

This parameter/attribute represents the position of the field in the CSV
record.

**Position**

    @CsvRecord(separator = ",")
    public class Order {
    
        @DataField(pos = 1)
        private int orderNr;
    
        @DataField(pos = 5)
        private String isinCode;
    
    }

As you can see in this example, the position starts at `1` but continues
at `5` in the class Order. The numbers from `2` to `4` are defined in
the class Client (see here after).

**Position continues in another model class**

    public class Client {
    
        @DataField(pos = 2)
        private String clientNr;
    
        @DataField(pos = 3)
        private String firstName;
    
        @DataField(pos = 4)
        private String lastName;
    }

**case 2: pattern**

The pattern allows enriching or validates the format of your data

**Pattern**

    @CsvRecord(separator = ",")
    public class Order {
    
        @DataField(pos = 1)
        private int orderNr;
    
        @DataField(pos = 5)
        private String isinCode;
    
        @DataField(name = "Name", pos = 6)
        private String instrumentName;
    
        @DataField(pos = 7, precision = 2)
        private BigDecimal amount;
    
        @DataField(pos = 8)
        private String currency;
    
        // pattern used during parsing or when the date is created
        @DataField(pos = 9, pattern = "dd-MM-yyyy")
        private Date orderDate;
    }

**case 3: precision**

The precision is helpful when you want to define the decimal part of
your number.

**Precision**

    @CsvRecord(separator = ",")
    public class Order {
    
        @DataField(pos = 1)
        private int orderNr;
    
        @Link
        private Client client;
    
        @DataField(pos = 5)
        private String isinCode;
    
        @DataField(name = "Name", pos = 6)
        private String instrumentName;
    
        @DataField(pos = 7, precision = 2)
        private BigDecimal amount;
    
        @DataField(pos = 8)
        private String currency;
    
        @DataField(pos = 9, pattern = "dd-MM-yyyy")
        private Date orderDate;
    }

**case 4: Position is different in output**

The position attribute will inform bindy how to place the field in the
CSV record generated. By default, the position used corresponds to the
position defined with the attribute `pos`. If the position is different
(that means that we have an asymmetric process comparing marshaling from
unmarshalling) then we can use `position` to indicate this.

Here is an example:

**Position is different in output**

    @CsvRecord(separator = ",", isOrdered = true)
    public class Order {
    
        // Positions of the fields start from 1 and not from 0
    
        @DataField(pos = 1, position = 11)
        private int orderNr;
    
        @DataField(pos = 2, position = 10)
        private String clientNr;
    
        @DataField(pos = 3, position = 9)
        private String firstName;
    
        @DataField(pos = 4, position = 8)
        private String lastName;
    
        @DataField(pos = 5, position = 7)
        private String instrumentCode;
    
        @DataField(pos = 6, position = 6)
        private String instrumentNumber;
    }

This attribute of the annotation `@DataField` must be used in
combination with attribute `isOrdered = true` of the annotation
`@CsvRecord`.

**case 5: required**

If a field is mandatory, use the attribute `required` set to true.

**Required**

    @CsvRecord(separator = ",")
    public class Order {
    
        @DataField(pos = 1)
        private int orderNr;
    
        @DataField(pos = 2, required = true)
        private String clientNr;
    
        @DataField(pos = 3, required = true)
        private String firstName;
    
        @DataField(pos = 4, required = true)
        private String lastName;
    }

If this field is not present in the record, then an error will be raised
by the parser with the following information :

    Some fields are missing (optional or mandatory), line :

**case 6: trim**

If a field has leading and/or trailing spaces which should be removed
before they are processed, use the attribute `trim` set to true.

**Trim**

    @CsvRecord(separator = ",")
    public class Order {
    
        @DataField(pos = 1, trim = true)
        private int orderNr;
    
        @DataField(pos = 2, trim = true)
        private Integer clientNr;
    
        @DataField(pos = 3, required = true)
        private String firstName;
    
        @DataField(pos = 4)
        private String lastName;
    }

**case 7: defaultValue**

If a field is not defined then uses the value indicated by the
`defaultValue` attribute.

**Default value**

    @CsvRecord(separator = ",")
    public class Order {
    
        @DataField(pos = 1)
        private int orderNr;
    
        @DataField(pos = 2)
        private Integer clientNr;
    
        @DataField(pos = 3, required = true)
        private String firstName;
    
        @DataField(pos = 4, defaultValue = "Barin")
        private String lastName;
    }

**case 8: columnName**

Specifies the column name for the property only if `@CsvRecord` has
annotation `generateHeaderColumns = true`.

**Column Name**

    @CsvRecord(separator = ",", generateHeaderColumns = true)
    public class Order {
    
        @DataField(pos = 1)
        private int orderNr;
    
        @DataField(pos = 5, columnName = "ISIN")
        private String isinCode;
    
        @DataField(name = "Name", pos = 6)
        private String instrumentName;
    }

This attribute is only applicable to optional fields.

## 4. FixedLengthRecord

The FixedLengthRecord annotation is used to identify the root class of
the model. It represents a record = "a line of a file/message containing
data fixed length (number of characters) formatted" and can be linked to
several children model classes. This format is a bit particular because
data of a field can be aligned to the right or to the left.

When the size of the data does not completely fill the length of the
field, we can then add *pad* characters.

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Annotation name</th>
<th style="text-align: left;">Record type</th>
<th style="text-align: left;">Level</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>FixedLengthRecord</strong></p></td>
<td style="text-align: left;"><p>fixed</p></td>
<td style="text-align: left;"><p>Class</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Default value</th>
<th style="text-align: left;">Info</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>countGrapheme</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Indicates how chars are
counted</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>crlf</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>WINDOWS</p></td>
<td style="text-align: left;"><pre><code> Character to be used to add a carriage return after each record (optional). Possible values: WINDOWS, UNIX, MAC,
or custom. This option is used only during marshalling, whereas unmarshalling uses system default JDK provided
line delimiter unless eol is customized.</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>eol</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code> Character to be used to process considering end of line after each record while unmarshalling (optional -
default: &quot;&quot;, which helps default JDK provided line delimiter to be used unless any other line delimiter provided)
This option is used only during unmarshalling, where marshalling uses system default provided line delimiter as
&quot;WINDOWS&quot; unless any other value is provided.</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>footer</p></td>
<td style="text-align: left;"><p>Class</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>void</p></td>
<td style="text-align: left;"><p>Indicates that the record(s) of this
type may be followed by a single footer record at the end of the
file</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>header</p></td>
<td style="text-align: left;"><p>Class</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>void</p></td>
<td style="text-align: left;"><pre><code> Indicates that the record(s) of this type may be preceded by a single header record at the beginning of in the
file</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ignoreMissingChars</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Indicates whether too short lines will
be ignored</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ignoreTrailingChars</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><pre><code> Indicates that characters beyond the last mapped filed can be ignored when unmarshalling / parsing. This
annotation is associated to the root class of the model and must be declared one time.</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>length</p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><pre><code> The fixed length of the record (number of characters). It means that the record will always be that long padded
with {#paddingChar()}&#39;s</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>name</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Name describing the record
(optional)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>paddingChar</p></td>
<td style="text-align: left;"><p>char</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>The char to pad with.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>skipFooter</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><pre><code> Configures the data format to skip marshalling / unmarshalling of the footer record. Configure this parameter on
the primary record (e.g., not the header or footer).</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>skipHeader</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><pre><code> Configures the data format to skip marshalling / unmarshalling of the header record. Configure this parameter on
the primary record (e.g., not the header or footer).</code></pre></td>
</tr>
</tbody>
</table>

A record may not be both a header/footer and a primary fixed-length
record.

**case 1: Simple fixed length record**

This example shows how to design the model to parse/format a fixed
message:

    10A9PaulineMISINXD12345678BUYShare2500.45USD01-08-2009

**Fixed-simple**

    @FixedLengthRecord(length=54, paddingChar=' ')
    public static class Order {
    
        @DataField(pos = 1, length=2)
        private int orderNr;
    
        @DataField(pos = 3, length=2)
        private String clientNr;
    
        @DataField(pos = 5, length=7)
        private String firstName;
    
        @DataField(pos = 12, length=1, align="L")
        private String lastName;
    
        @DataField(pos = 13, length=4)
        private String instrumentCode;
    
        @DataField(pos = 17, length=10)
        private String instrumentNumber;
    
        @DataField(pos = 27, length=3)
        private String orderType;
    
        @DataField(pos = 30, length=5)
        private String instrumentType;
    
        @DataField(pos = 35, precision = 2, length=7)
        private BigDecimal amount;
    
        @DataField(pos = 42, length=3)
        private String currency;
    
        @DataField(pos = 45, length=10, pattern = "dd-MM-yyyy")
        private Date orderDate;
    }

**case 2: Fixed length record with alignment and padding**

This more elaborated example show how to define the alignment for a
field and how to assign a padding character which is `' '` here:

    10A9 PaulineM ISINXD12345678BUYShare2500.45USD01-08-2009

**Fixed-padding-align**

    @FixedLengthRecord(length=60, paddingChar=' ')
    public static class Order {
    
        @DataField(pos = 1, length=2)
        private int orderNr;
    
        @DataField(pos = 3, length=2)
        private String clientNr;
    
        @DataField(pos = 5, length=9)
        private String firstName;
    
        @DataField(pos = 14, length=5, align="L")   // align text to the LEFT zone of the block
        private String lastName;
    
        @DataField(pos = 19, length=4)
        private String instrumentCode;
    
        @DataField(pos = 23, length=10)
        private String instrumentNumber;
    
        @DataField(pos = 33, length=3)
        private String orderType;
    
        @DataField(pos = 36, length=5)
        private String instrumentType;
    
        @DataField(pos = 41, precision = 2, length=7)
        private BigDecimal amount;
    
        @DataField(pos = 48, length=3)
        private String currency;
    
        @DataField(pos = 51, length=10, pattern = "dd-MM-yyyy")
        private Date orderDate;
    }

**case 3: Field padding**

Sometimes, the default padding defined for record cannot be applied to
the field as we have a number format where we would like to pad with *0*
instead of `' '`. In this case, you can use in the model the attribute
`paddingChar` on `@DataField` to set this value.

    10A9 PaulineM ISINXD12345678BUYShare000002500.45USD01-08-2009

**Fixed-padding-field**

    @FixedLengthRecord(length = 65, paddingChar = ' ')
    public static class Order {
    
        @DataField(pos = 1, length = 2)
        private int orderNr;
    
        @DataField(pos = 3, length = 2)
        private String clientNr;
    
        @DataField(pos = 5, length = 9)
        private String firstName;
    
        @DataField(pos = 14, length = 5, align = "L")
        private String lastName;
    
        @DataField(pos = 19, length = 4)
        private String instrumentCode;
    
        @DataField(pos = 23, length = 10)
        private String instrumentNumber;
    
        @DataField(pos = 33, length = 3)
        private String orderType;
    
        @DataField(pos = 36, length = 5)
        private String instrumentType;
    
        @DataField(pos = 41, precision = 2, length = 12, paddingChar = '0')
        private BigDecimal amount;
    
        @DataField(pos = 53, length = 3)
        private String currency;
    
        @DataField(pos = 56, length = 10, pattern = "dd-MM-yyyy")
        private Date orderDate;
    }

**case 4: Fixed length record with delimiter**

Fixed-length records sometimes have delimited content within the record.
The firstName and lastName fields are delimited with the `^` character
in the following example:

    10A9Pauline^M^ISINXD12345678BUYShare000002500.45USD01-08-2009

**Fixed-delimited**

    @FixedLengthRecord
    public static class Order {
    
        @DataField(pos = 1, length = 2)
        private int orderNr;
    
        @DataField(pos = 2, length = 2)
        private String clientNr;
    
        @DataField(pos = 3, delimiter = "^")
        private String firstName;
    
        @DataField(pos = 4, delimiter = "^")
        private String lastName;
    
        @DataField(pos = 5, length = 4)
        private String instrumentCode;
    
        @DataField(pos = 6, length = 10)
        private String instrumentNumber;
    
        @DataField(pos = 7, length = 3)
        private String orderType;
    
        @DataField(pos = 8, length = 5)
        private String instrumentType;
    
        @DataField(pos = 9, precision = 2, length = 12, paddingChar = '0')
        private BigDecimal amount;
    
        @DataField(pos = 10, length = 3)
        private String currency;
    
        @DataField(pos = 11, length = 10, pattern = "dd-MM-yyyy")
        private Date orderDate;
    }

The `pos` value(s) in a fixed-length record may optionally be defined
using ordinal, sequential values instead of precise column numbers.

**case 5: Fixed length record with record-defined field length**

Occasionally, a fixed-length record may contain a field that defines the
expected length of another field within the same record. In the
following example the length of the `instrumentNumber` field value is
defined by the value of `instrumentNumberLen` field in the record.

    10A9Pauline^M^ISIN10XD12345678BUYShare000002500.45USD01-08-2009

**Fixed-delimited**

    @FixedLengthRecord
    public static class Order {
    
        @DataField(pos = 1, length = 2)
        private int orderNr;
    
        @DataField(pos = 2, length = 2)
        private String clientNr;
    
        @DataField(pos = 3, delimiter = "^")
        private String firstName;
    
        @DataField(pos = 4, delimiter = "^")
        private String lastName;
    
        @DataField(pos = 5, length = 4)
        private String instrumentCode;
    
        @DataField(pos = 6, length = 2, align = "R", paddingChar = '0')
        private int instrumentNumberLen;
    
        @DataField(pos = 7, lengthPos=6)
        private String instrumentNumber;
    
        @DataField(pos = 8, length = 3)
        private String orderType;
    
        @DataField(pos = 9, length = 5)
        private String instrumentType;
    
        @DataField(pos = 10, precision = 2, length = 12, paddingChar = '0')
        private BigDecimal amount;
    
        @DataField(pos = 11, length = 3)
        private String currency;
    
        @DataField(pos = 12, length = 10, pattern = "dd-MM-yyyy")
        private Date orderDate;
    }

**case 6: Fixed length record with header and footer**

Bindy will discover fixed-length header and footer records that are
configured as part of the model – provided that the annotated classes
exist either in the same package as the primary `@FixedLengthRecord`
class, or within one of the configured scan packages. The following text
illustrates two fixed-length records that are bracketed by a header
record and footer record.

    101-08-2009
    10A9 PaulineM ISINXD12345678BUYShare000002500.45USD01-08-2009
    10A9 RichN ISINXD12345678BUYShare000002700.45USD01-08-2009
    9000000002

**Fixed-header-and-footer-main-class**

    @FixedLengthRecord(header = OrderHeader.class, footer = OrderFooter.class)
    public class Order {
    
        @DataField(pos = 1, length = 2)
        private int orderNr;
    
        @DataField(pos = 2, length = 2)
        private String clientNr;
    
        @DataField(pos = 3, length = 9)
        private String firstName;
    
        @DataField(pos = 4, length = 5, align = "L")
        private String lastName;
    
        @DataField(pos = 5, length = 4)
        private String instrumentCode;
    
        @DataField(pos = 6, length = 10)
        private String instrumentNumber;
    
        @DataField(pos = 7, length = 3)
        private String orderType;
    
        @DataField(pos = 8, length = 5)
        private String instrumentType;
    
        @DataField(pos = 9, precision = 2, length = 12, paddingChar = '0')
        private BigDecimal amount;
    
        @DataField(pos = 10, length = 3)
        private String currency;
    
        @DataField(pos = 11, length = 10, pattern = "dd-MM-yyyy")
        private Date orderDate;
    }
    
    @FixedLengthRecord
    public  class OrderHeader {
        @DataField(pos = 1, length = 1)
        private int recordType = 1;
    
        @DataField(pos = 2, length = 10, pattern = "dd-MM-yyyy")
        private Date recordDate;
    }
    
    @FixedLengthRecord
    public class OrderFooter {
    
        @DataField(pos = 1, length = 1)
        private int recordType = 9;
    
        @DataField(pos = 2, length = 9, align = "R", paddingChar = '0')
        private int numberOfRecordsInTheFile;
    }

**case 7: Skipping content when parsing a fixed length record**

It is common to integrate with systems that provide fixed-length records
containing more information than needed for the target use case. It is
useful in this situation to skip the declaration and parsing of those
fields that we do not need. To accommodate this, Bindy will skip forward
to the next mapped field within a record if the `pos` value of the next
declared field is beyond the cursor position of the last parsed field.
Using absolute `pos` locations for the fields of interest (instead of
ordinal values) causes Bindy to skip content between two fields.

Similarly, it is possible that none of the content beyond some field is
of interest. In this case, you can tell Bindy to skip parsing of
everything beyond the last mapped field by setting the
`ignoreTrailingChars` property on the `@FixedLengthRecord` declaration.

    @FixedLengthRecord(ignoreTrailingChars = true)
    public static class Order {
    
        @DataField(pos = 1, length = 2)
        private int orderNr;
    
        @DataField(pos = 3, length = 2)
        private String clientNr;
    
        // any characters that appear beyond the last mapped field will be ignored
    
    }

## 5. Message

The Message annotation is used to identify the class of your model who
will contain key value pairs fields. This kind of format is used mainly
in Financial Exchange Protocol Messages (FIX). Nevertheless, this
annotation can be used for any other format where data are identified by
keys. The key pair values are separated each other by a separator which
can be a special character like a tab delimiter (unicode representation
: `\u0009`) or a start of heading (unicode representation: `\u0001`)

**FIX information**

More information about FIX can be found on this website:
[http://www.fixprotocol.org/](http://www.fixprotocol.org/). To work with *FIX messages*, the model
must contain a Header and Trailer classes linked to the root message
class which could be an `Order` class. This is not mandatory but will be
very helpful when you use camel-bindy in combination with camel-fix
which is a Fix gateway based on quickFix project
[http://www.quickfixj.org/](http://www.quickfixj.org/).

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Annotation name</th>
<th style="text-align: left;">Record type</th>
<th style="text-align: left;">Level</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>Message</strong></p></td>
<td style="text-align: left;"><p>key value pair</p></td>
<td style="text-align: left;"><p>Class</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Default value</th>
<th style="text-align: left;">Info</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>keyValuePairSeparator</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>✓</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><pre><code> Key value pair separator is used to split the values from their keys (mandatory). Can be &#39;\u0001&#39;, &#39;\u0009&#39;, &#39;#&#39;,
or &#39;anything&#39;.</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>pairSeparator</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>✓</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Pair separator used to split the key
value pairs in tokens (mandatory). Can be <em>=</em>, <em>;</em>, or
<em>anything</em>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>crlf</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>WINDOWS</p></td>
<td style="text-align: left;"><pre><code> Character to be used to add a carriage return after each record (optional). Possible values = WINDOWS, UNIX, MAC,
or custom. If you specify a value other than the three listed before, the value you enter (custom) will be used
as the CRLF character(s).</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>isOrdered</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><pre><code> Indicates if the message must be ordered in output. This annotation is associated to the message class of the
model and must be declared one time.</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>name</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Name describing the message
(optional)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>type</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>FIX</p></td>
<td style="text-align: left;"><p>type is used to define the type of the
message (e.g. FIX, EMX, …) (optional)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>version</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>4.1</p></td>
<td style="text-align: left;"><p>version defines the version of the
message (e.g. 4.1, …) (optional)</p></td>
</tr>
</tbody>
</table>

**case 1:separator = *u0001***

The separator used to segregate the key value pair fields in a FIX
message is the ASCII `01` character or in unicode format `\u0001`. This
character must be escaped a second time to avoid a java runtime error.
Here is an example :

    8=FIX.4.1 9=20 34=1 35=0 49=INVMGR 56=BRKR 1=BE.CHM.001 11=CHM0001-01 22=4 ...

and how to use the annotation:

**FIX - message**

    @Message(keyValuePairSeparator = "=", pairSeparator = "\\u0001", type="FIX", version="4.1")
    public class Order {
    
    }

**Look at test cases**

The ASCII character like tab, … cannot be displayed in WIKI page. So,
have a look at the test case of camel-bindy to see exactly how the FIX
message looks like
([src/test/data/fix/fix.txt](https://github.com/apache/camel/blob/main/components/camel-bindy/src/test/data/fix/fix.txt))
and the Order, Trailer, Header classes
([src/test/java/org/apache/camel/dataformat/bindy/model/fix/simple/Order.java](https://github.com/apache/camel/blob/main/components/camel-bindy/src/test/java/org/apache/camel/dataformat/bindy/model/fix/simple/Order.java)).

## 6. KeyValuePairField

The KeyValuePairField annotation defines the property of a key value
pair field. Each KeyValuePairField is identified by a tag (= key) and
its value associated, a type (string, int, date, …), optionaly a pattern
and if the field is required.

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Annotation name</th>
<th style="text-align: left;">Record type</th>
<th style="text-align: left;">Level</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>KeyValuePairField</strong></p></td>
<td style="text-align: left;"><p>Key Value Pair - FIX</p></td>
<td style="text-align: left;"><p>Property</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Default value</th>
<th style="text-align: left;">Info</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>tag</p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"><p>✓</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>tag identifying the field in the
message (mandatory) - must be unique</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>impliedDecimalSeparator</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>&lt;b&gt;Camel 2.11:&lt;/b&gt;
Indicates if there is a decimal point implied at a specified
location</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>name</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>name of the field (optional)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>pattern</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>pattern that the formater will use to
transform the data (optional)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>position</p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><pre><code> Position of the field in the message generated - must be used when the position of the key/tag in the FIX message
must be different</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>precision</p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><p>precision of the BigDecimal number to
be created</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>required</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Indicates if the field is
mandatory</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>timezone</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Timezone to be used.</p></td>
</tr>
</tbody>
</table>

**case 1:tag**

This parameter represents the key of the field in the message:

**FIX message - Tag**

    @Message(keyValuePairSeparator = "=", pairSeparator = "\\u0001", type="FIX", version="4.1")
    public class Order {
    
        @Link Header header;
    
        @Link Trailer trailer;
    
        @KeyValuePairField(tag = 1) // Client reference
        private String Account;
    
        @KeyValuePairField(tag = 11) // Order reference
        private String ClOrdId;
    
        @KeyValuePairField(tag = 22) // Fund ID type (Sedol, ISIN, ...)
        private String IDSource;
    
        @KeyValuePairField(tag = 48) // Fund code
        private String SecurityId;
    
        @KeyValuePairField(tag = 54) // Movement type ( 1 = Buy, 2 = sell)
        private String Side;
    
        @KeyValuePairField(tag = 58) // Free text
        private String Text;
    }

**case 2: Different position in output**

If the tags/keys that we will put in the *FIX message* must be sorted
according to a predefined order, then use the attribute `position` of
the annotation `@KeyValuePairField`.

**FIX message - Tag - sort**

    @Message(keyValuePairSeparator = "=", pairSeparator = "\\u0001", type = "FIX", version = "4.1", isOrdered = true)
    public class Order {
    
        @Link Header header;
    
        @Link Trailer trailer;
    
        @KeyValuePairField(tag = 1, position = 1) // Client reference
        private String account;
    
        @KeyValuePairField(tag = 11, position = 3) // Order reference
        private String clOrdId;
    }

## 7. Section

In *FIX message* of fixed length records, it is common to have different
sections in the representation of the information:header, body and
section. The purpose of the annotation `@Section` is to inform bindy
about which class of the model represents the header (= section 1), body
(= section 2) and footer (= section 3)

Only one attribute/parameter exists for this annotation.

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Annotation name</th>
<th style="text-align: left;">Record type</th>
<th style="text-align: left;">Level</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>Section</strong></p></td>
<td style="text-align: left;"><p>FIX</p></td>
<td style="text-align: left;"><p>Class</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Default value</th>
<th style="text-align: left;">Info</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>number</p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"><p>✓</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Number of the section</p></td>
</tr>
</tbody>
</table>

**case 1:Section**

Definition of the header section:

**FIX message - Section - Header**

    @Section(number = 1)
    public class Header {
    
        @KeyValuePairField(tag = 8, position = 1) // Message Header
        private String beginString;
    
        @KeyValuePairField(tag = 9, position = 2) // Checksum
        private int bodyLength;
    }

Definition of the body section:

**FIX message - Section - Body**

    @Section(number = 2)
    @Message(keyValuePairSeparator = "=", pairSeparator = "\\u0001", type = "FIX", version = "4.1", isOrdered = true)
    public class Order {
    
        @Link Header header;
    
        @Link Trailer trailer;
    
        @KeyValuePairField(tag = 1, position = 1) // Client reference
        private String account;
    
        @KeyValuePairField(tag = 11, position = 3) // Order reference
        private String clOrdId;

Definition of the footer section:

**FIX message - Section - Footer**

    @Section(number = 3)
    public class Trailer {
    
        @KeyValuePairField(tag = 10, position = 1)
        // CheckSum
        private int checkSum;
    
        public int getCheckSum() {
            return checkSum;
        }

## 8. OneToMany

The purpose of the annotation `@OneToMany` is to allow working with a
`List<?>` field defined a POJO class or from a record containing
repetitive groups.

**Restrictions OneToMany**

Be careful, the one to many of bindy does not allow handling repetitions
defined on several levels of the hierarchy

The relation OneToMany ONLY WORKS in the following cases :

-   Reading a *FIX message* containing repetitive groups (= group of
    tags/keys)

-   Generating a CSV with repetitive data

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Annotation name</th>
<th style="text-align: left;">Record type</th>
<th style="text-align: left;">Level</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>OneToMany</strong></p></td>
<td style="text-align: left;"><p>all</p></td>
<td style="text-align: left;"><p>Property</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Parameter name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Default value</th>
<th style="text-align: left;">Info</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>mappedTo</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Class name associated to the type of
the List&lt;Type of the Class&gt;</p></td>
</tr>
</tbody>
</table>

**case 1: Generating CSV with repetitive data**

Here is the CSV output that we want :

    Claus,Ibsen,Camel in Action 1,2010,35
    Claus,Ibsen,Camel in Action 2,2012,35
    Claus,Ibsen,Camel in Action 3,2013,35
    Claus,Ibsen,Camel in Action 4,2014,35

The repetitive data concern the title of the book and its publication
date while first, last name and age are common.

And the classes used to modeling this. The Author class contains a List
of Book.

**Generate CSV with repetitive data**

    @CsvRecord(separator=",")
    public class Author {
    
        @DataField(pos = 1)
        private String firstName;
    
        @DataField(pos = 2)
        private String lastName;
    
        @OneToMany
        private List<Book> books;
    
        @DataField(pos = 5)
        private String Age;
    }
    
    public class Book {
    
        @DataField(pos = 3)
        private String title;
    
        @DataField(pos = 4)
        private String year;
    }

Very simple isn’t it !!!

**case 2: Reading FIX message containing group of tags/keys**

Here is the message that we would like to process in our model :

    8=FIX 4.19=2034=135=049=INVMGR56=BRKR
    1=BE.CHM.00111=CHM0001-0158=this is a camel - bindy test
    22=448=BE000124567854=1
    22=548=BE000987654354=2
    22=648=BE000999999954=3
    10=220

Tags 22, 48 and 54 are repeated.

And the code:

**Reading FIX message containing group of tags/keys**

    public class Order {
    
        @Link Header header;
    
        @Link Trailer trailer;
    
        @KeyValuePairField(tag = 1) // Client reference
        private String account;
    
        @KeyValuePairField(tag = 11) // Order reference
        private String clOrdId;
    
        @KeyValuePairField(tag = 58) // Free text
        private String text;
    
        @OneToMany(mappedTo = "org.apache.camel.dataformat.bindy.model.fix.complex.onetomany.Security")
        List<Security> securities;
    }
    
    public class Security {
    
        @KeyValuePairField(tag = 22) // Fund ID type (Sedol, ISIN, ...)
        private String idSource;
    
        @KeyValuePairField(tag = 48) // Fund code
        private String securityCode;
    
        @KeyValuePairField(tag = 54) // Movement type (1 = Buy, 2 = sell)
        private String side;
    }

## 9. BindyConverter

The purpose of the annotation `@BindyConverter` is to define a converter
to be used on field level. The provided class must implement the Format
interface.

    @FixedLengthRecord(length = 10, paddingChar = ' ')
    public static class DataModel {
        @DataField(pos =  1, length = 10, trim = true)
        @BindyConverter(CustomConverter.class)
        public String field1;
    }
    
    public static class CustomConverter implements Format<String> {
        @Override
        public String format(String object) throws Exception {
            return (new StringBuilder(object)).reverse().toString();
        }
    
        @Override
        public String parse(String string) throws Exception {
            return (new StringBuilder(string)).reverse().toString();
        }
    }

## 10. FormatFactories

The purpose of the annotation `@FormatFactories` is to define a set of
converters at record-level. The provided classes must implement the
`FormatFactoryInterface` interface.

    @CsvRecord(separator = ",")
    @FormatFactories({OrderNumberFormatFactory.class})
    public static class Order {
    
        @DataField(pos = 1)
        private OrderNumber orderNr;
    
        @DataField(pos = 2)
        private String firstName;
    }
    
    public static class OrderNumber {
        private int orderNr;
    
        public static OrderNumber ofString(String orderNumber) {
            OrderNumber result = new OrderNumber();
            result.orderNr = Integer.valueOf(orderNumber);
            return result;
        }
    }
    
    public static class OrderNumberFormatFactory extends AbstractFormatFactory {
    
        {
            supportedClasses.add(OrderNumber.class);
        }
    
        @Override
        public Format<?> build(FormattingOptions formattingOptions) {
            return new Format<OrderNumber>() {
                @Override
                public String format(OrderNumber object) throws Exception {
                    return String.valueOf(object.orderNr);
                }
    
                @Override
                public OrderNumber parse(String string) throws Exception {
                    return OrderNumber.ofString(string);
                }
            };
        }
    }

## Supported Datatypes

The DefaultFormatFactory makes formatting of the following datatype
available by returning an instance of the interface
FormatFactoryInterface based on the provided FormattingOptions:

-   BigDecimal

-   BigInteger

-   Boolean

-   Byte

-   Character

-   Date

-   Double

-   Enums

-   Float

-   Integer

-   LocalDate

-   LocalDateTime

-   LocalTime

-   Long

-   Short

-   String

-   ZonedDateTime

The DefaultFormatFactory can be overridden by providing an instance of
FactoryRegistry in the registry in use (e.g., Spring or JNDI).

## Using the Java DSL

The next step instantiates the DataFormat *bindy* class associated with
this record type and providing a class as a parameter.

For example, the following uses the class `BindyCsvDataFormat` (which
corresponds to the class associated with the CSV record type) which is
configured with *com.acme.model.MyModel.class* to initialize the model
objects configured in this package.

    DataFormat bindy = new BindyCsvDataFormat(com.acme.model.MyModel.class);

## Setting locale

Bindy supports configuring the locale on the dataformat, such as

    BindyCsvDataFormat bindy = new BindyCsvDataFormat(com.acme.model.MyModel.class);
    
    bindy.setLocale("us");

Or to use the platform default locale, then use "default" as the locale
name.

    BindyCsvDataFormat bindy = new BindyCsvDataFormat(com.acme.model.MyModel.class);
    
    bindy.setLocale("default");

## Unmarshaling

    from("file://inbox")
      .unmarshal(bindy)
      .to("direct:handleOrders");

Alternatively, you can use a named reference to a data format which can
then be defined in your registry, e.g., your Spring XML file:

    from("file://inbox")
      .unmarshal("myBindyDataFormat")
      .to("direct:handleOrders");

The Camel route will pick up files in the inbox directory, unmarshall
CSV records into a collection of model objects and send the collection  
to the route referenced by `handleOrders`.

The collection returned is a **List of Map** objects. Each Map within
the list contains the model objects marshalled out of each line of the
CSV. The reason behind this is that *each line can correspond to more
than one object*. This can be confusing when you expect one object to be
returned per line.

Each object can be retrieved using its class name.

    List<Map<String, Object>> unmarshaledModels = (List<Map<String, Object>>) exchange.getIn().getBody();
    
    int modelCount = 0;
    for (Map<String, Object> model : unmarshaledModels) {
      for (String className : model.keySet()) {
         Object obj = model.get(className);
         LOG.info("Count: {}, {}", modelCount, obj.toString());
      }
     modelCount++;
    }
    
    LOG.info("Total CSV records received by the csv bean: {}", modelCount);

Assuming that you want to extract a single Order object from this map
for processing in a route, you could use a combination of a Splitter and
a Processor as per the following:

    from("file://inbox")
        .unmarshal(bindy)
        .split(body())
            .process(new Processor() {
                public void process(Exchange exchange) throws Exception {
                    Message in = exchange.getIn();
                    Map<String, Object> modelMap = (Map<String, Object>) in.getBody();
                    in.setBody(modelMap.get(Order.class.getCanonicalName()));
                }
            })
            .to("direct:handleSingleOrder")
        .end();

Take care of the fact that Bindy uses CHARSET\_NAME property or the
CHARSET\_NAME header as define in the Exchange interface to do a
characterset conversion of the inputstream received for unmarshalling.
In some producers, (e.g., file-endpoint) you can define a characterset.
This producer can already do the character set conversion. Sometimes you
need to remove this property or header from the exchange before sending
it to the unmarshal. If you don’t remove it, the conversion might be
done twice, which might lead to unwanted results.

    from("file://inbox?charset=Cp922")
      .removeProperty(Exchange.CHARSET_NAME)
      .unmarshal("myBindyDataFormat")
      .to("direct:handleOrders");

## Marshaling

To generate CSV records from a collection of model objects, you create
the following route :

    from("direct:handleOrders")
       .marshal(bindy)
       .to("file://outbox")

## Using Spring XML

This is really easy to use Spring as your favorite DSL language to
declare the routes to be used for camel-bindy. The following example
shows two routes where the first will pick up records from files,
unmarshal the content and bind it to their model. The result is then
send to a pojo (doing nothing special) and place them into a queue.

The second route will extract the pojos from the queue and marshal the
content to generate a file containing the CSV record.

**Spring DSL**

    <?xml version="1.0" encoding="UTF-8"?>
    
    <beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="
           http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd
           http://camel.apache.org/schema/spring
           http://camel.apache.org/schema/spring/camel-spring.xsd">
    
        <!-- Queuing engine - ActiveMq - works locally in mode virtual memory -->
        <bean id="activemq" class="org.apache.activemq.camel.component.ActiveMQComponent">
            <property name="brokerURL" value="vm://localhost:61616"/>
        </bean>
    
        <camelContext xmlns="http://camel.apache.org/schema/spring">
            <dataFormats>
              <bindy id="bindyDataformat" type="Csv" classType="org.apache.camel.bindy.model.Order"/>
            </dataFormats>
    
            <route>
                <from uri="file://src/data/csv/?noop=true" />
                <unmarshal ref="bindyDataformat" />
                <to uri="bean:csv" />
                <to uri="activemq:queue:in" />
            </route>
    
            <route>
                <from uri="activemq:queue:in" />
                <marshal ref="bindyDataformat" />
                <to uri="file://src/data/csv/out/" />
            </route>
        </camelContext>
    </beans>

Please verify that your model classes implement serializable otherwise
the queue manager will raise an error.

# Dependencies

To use Bindy in your camel routes, you need to add a dependency on
**camel-bindy** which implements this data format.

If you use maven, you could add the following to your pom.xml,
substituting the version number for the latest \& greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-bindy</artifactId>
      <version>x.x.x</version>
    </dependency>
