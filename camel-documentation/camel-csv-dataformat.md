# Csv-dataformat.md

**Since Camel 1.3**

The CSV Data Format uses [Apache Commons
CSV](http://commons.apache.org/proper/commons-csv/) to handle CSV
payloads (Comma Separated Values) such as those exported/imported by
Excel.

# Options

# Message Headers

The following headers are supported by this component:

## Producer only

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelCsvHeaderRecord</code></p></td>
<td style="text-align: left;"><p>The header record collected from the
CSV when setCaptureHeaderRecord is true.</p></td>
</tr>
</tbody>
</table>

# Examples

## Marshalling a Map to CSV

The component allows you to marshal a Java Map (or any other message
type that can be converted in a Map) into a CSV payload.

Considering the following body:

    Map<String, Object> body = new LinkedHashMap<>();
    body.put("foo", "abc");
    body.put("bar", 123);

and this route definition:

Java  
from("direct:start")
.marshal().csv()
.to("mock:result");

XML  
<route>  
<from uri="direct:start" />  
<marshal>  
<csv />  
</marshal>  
<to uri="mock:result" />  
</route>

then it will produce

    abc,123

## Unmarshalling a CSV message into a Java List

Unmarshalling will transform a CSV message into a Java List with CSV
file lines (containing another List with all the field values).

An example: we have a CSV file with names of persons, their IQ and their
current activity.

    Jack Dalton, 115, mad at Averell
    Joe Dalton, 105, calming Joe
    William Dalton, 105, keeping Joe from killing Averell
    Averell Dalton, 80, playing with Rantanplan
    Lucky Luke, 120, capturing the Daltons

We can now use the CSV component to unmarshal this file:

    from("file:src/test/resources/?fileName=daltons.csv&noop=true")
        .unmarshal().csv()
        .to("mock:daltons");

The resulting message will contain a `List<List<String>>` like…

    List<List<String>> data = (List<List<String>>) exchange.getIn().getBody();
    for (List<String> line : data) {
        LOG.debug(String.format("%s has an IQ of %s and is currently %s", line.get(0), line.get(1), line.get(2)));
    }

## Marshalling a List\<Map\> to CSV

**Since Camel 2.1**

If you have multiple rows of data you want to be marshalled into CSV
format, you can now store the message payload as a
`List<Map<String, Object>>` object where the list contains a Map for
each row.

## File Poller of CSV, then unmarshaling

Given a bean which can handle the incoming data…

**MyCsvHandler.java**

    // Some comments here
    public void doHandleCsvData(List<List<String>> csvData)
    {
        // do magic here
    }

1.  your route then looks as follows

<!-- -->

    <route>
            <!-- poll every 10 seconds -->
            <from uri="file:///some/path/to/pickup/csvfiles?delete=true&amp;delay=10000" />
            <unmarshal><csv /></unmarshal>
            <to uri="bean:myCsvHandler?method=doHandleCsvData" />
    </route>

## Marshaling with a pipe as delimiter

Considering the following body:

    Map<String, Object> body = new LinkedHashMap<>();
    body.put("foo", "abc");
    body.put("bar", 123);

And this Java route definition:

Java  
from("direct:start")
.marshal(new CsvDataFormat().setDelimiter('\|'))
.to("mock:result")

XML  
<route>  
<from uri="direct:start" />  
<marshal>  
<csv delimiter="|" />  
</marshal>  
<to uri="mock:result" />  
</route>

Then it will produce:

    abc|123

Using autogenColumns, configRef and strategyRef attributes inside XML ==
DSL

**Since Camel 2.9.2 / 2.10 and deleted for Camel 2.15**

You can customize the CSV Data Format to make use of your own
`CSVConfig` and/or `CSVStrategy`. Also note that the default value of
the `autogenColumns` option is true. The following example should
illustrate this customization.

    <route>
      <from uri="direct:start" />
      <marshal>
        <!-- make use of a strategy other than the default one which is 'org.apache.commons.csv.CSVStrategy.DEFAULT_STRATEGY' -->
        <csv autogenColumns="false" delimiter="|" configRef="csvConfig" strategyRef="excelStrategy" />
      </marshal>
      <convertBodyTo type="java.lang.String" />
      <to uri="mock:result" />
    </route>
    
    <bean id="csvConfig" class="org.apache.commons.csv.writer.CSVConfig">
      <property name="fields">
        <list>
          <bean class="org.apache.commons.csv.writer.CSVField">
            <property name="name" value="orderId" />
          </bean>
          <bean class="org.apache.commons.csv.writer.CSVField">
            <property name="name" value="amount" />
          </bean>
        </list>
      </property>
    </bean>
    
    <bean id="excelStrategy" class="org.springframework.beans.factory.config.FieldRetrievingFactoryBean">
      <property name="staticField" value="org.apache.commons.csv.CSVStrategy.EXCEL_STRATEGY" />
    </bean>

## Collecting header record

You can instruct the CSV Data Format to collect the headers into a
message header called CamelCsvHeaderRecord.

    CsvDataFormat csv = new CsvDataFormat();
    csv.setCaptureHeaderRecord(true);
    
    from("direct:start")
      .unmarshal(csv)
      .log("${header[CamelCsvHeaderRecord]}");

## Using skipFirstLine or skipHeaderRecord option while unmarshaling

\*For Camel \>= 2.16.5 The instruction for CSV Data format to skip
headers or first line is the following. Usign the Spring/XML DSL:

    <route>
      <from uri="direct:start" />
      <unmarshal>
        <csv skipHeaderRecord="true" />
      </unmarshal>
      <to uri="bean:myCsvHandler?method=doHandleCsv" />
    </route>

**Since Camel 2.10 and deleted for Camel 2.15**

You can instruct the CSV Data Format to skip the first line which
contains the CSV headers. Using the Spring/XML DSL:

Java  
CsvDataFormat csv = new CsvDataFormat();
csv.setSkipFirstLine(true);

    from("direct:start")
      .unmarshal(csv)
    .to("bean:myCsvHandler?method=doHandleCsv");

XML  
<route>  
<from uri="direct:start" />  
<unmarshal>  
<csv skipFirstLine="true" />  
</unmarshal>  
<to uri="bean:myCsvHandler?method=doHandleCsv" />  
</route>

## Unmarshaling with a pipe as delimiter

Java  
CsvDataFormat csv = new CsvDataFormat();
CSVStrategy strategy = CSVStrategy.DEFAULT\_STRATEGY;
strategy.setDelimiter('\|');
csv.setStrategy(strategy);

    from("direct:start")
      .unmarshal(csv)
      .to("bean:myCsvHandler?method=doHandleCsv");

Or, possibly:

    CsvDataFormat csv = new CsvDataFormat();
    csv.setDelimiter("|");
    
    from("direct:start")
      .unmarshal(csv)
      .to("bean:myCsvHandler?method=doHandleCsv");

Spring XML  
<route>  
<from uri="direct:start" />  
<unmarshal>  
<csv delimiter="|" />  
</unmarshal>  
<to uri="bean:myCsvHandler?method=doHandleCsv" />  
</route>

**Issue in CSVConfig**

It looks like that

    CSVConfig csvConfig = new CSVConfig();
    csvConfig.setDelimiter(';');

This doesn’t work. You have to set the delimiter as a String!

# Dependencies

To use CSV in your Camel routes, you need to add a dependency on
**camel-csv**, which implements this data format.

If you use Maven, you can add the following to your pom.xml,
substituting the version number for the latest and greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-csv</artifactId>
      <version>x.x.x</version>
    </dependency>
