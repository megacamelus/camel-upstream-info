# Stax

**Since Camel 2.9**

**Only producer is supported**

The StAX component allows messages to be processed through a SAX
[ContentHandler](http://download.oracle.com/javase/6/docs/api/org/xml/sax/ContentHandler.html).  
Another feature of this component is to allow iterating over JAXB
records using StAX, for example, using the [Split
EIP](#eips:split-eip.adoc).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-stax</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    stax:content-handler-class

example:

    stax:org.superbiz.FooContentHandler

You can look up a `org.xml.sax.ContentHandler` bean from the Registry
using the # syntax as shown:

    stax:#myHandler

# Usage of a content handler as StAX parser

The message body after the handling is the handler itself.

Here is an example:

    from("file:target/in")
      .to("stax:org.superbiz.handler.CountingHandler")
      // CountingHandler implements org.xml.sax.ContentHandler or extends org.xml.sax.helpers.DefaultHandler
      .process(new Processor() {
        @Override
        public void process(Exchange exchange) throws Exception {
            CountingHandler handler = exchange.getIn().getBody(CountingHandler.class);
            // do some great work with the handler
        }
      });

# Iterate over a collection using JAXB and StAX

First, we suppose you have JAXB objects.

For instance, a list of records in a wrapper object:

    import java.util.ArrayList;
    import java.util.List;
    import javax.xml.bind.annotation.XmlAccessType;
    import javax.xml.bind.annotation.XmlAccessorType;
    import javax.xml.bind.annotation.XmlElement;
    import javax.xml.bind.annotation.XmlRootElement;
    
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlRootElement(name = "records")
    public class Records {
        @XmlElement(required = true)
        protected List<Record> record;
    
        public List<Record> getRecord() {
            if (record == null) {
                record = new ArrayList<Record>();
            }
            return record;
        }
    }

and

    import javax.xml.bind.annotation.XmlAccessType;
    import javax.xml.bind.annotation.XmlAccessorType;
    import javax.xml.bind.annotation.XmlAttribute;
    import javax.xml.bind.annotation.XmlType;
    
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "record", propOrder = { "key", "value" })
    public class Record {
        @XmlAttribute(required = true)
        protected String key;
    
        @XmlAttribute(required = true)
        protected String value;
    
        public String getKey() {
            return key;
        }
    
        public void setKey(String key) {
            this.key = key;
        }
    
        public String getValue() {
            return value;
        }
    
        public void setValue(String value) {
            this.value = value;
        }
    }

Then you get an XML file to process:

    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <records>
      <record value="v0" key="0"/>
      <record value="v1" key="1"/>
      <record value="v2" key="2"/>
      <record value="v3" key="3"/>
      <record value="v4" key="4"/>
      <record value="v5" key="5"/>
    </record>

The StAX component provides an `StAXBuilder` which can be used when
iterating XML elements with the Camel Splitter

    from("file:target/in")
        .split(stax(Record.class)).streaming()
            .to("mock:records");

Where `stax` is a static method on
`org.apache.camel.component.stax.StAXBuilder` which you can have static
import in the Java code. The stax builder is by default namespace aware
on the XMLReader it uses. You can turn this off by setting the boolean
parameter to false, as shown below:

    from("file:target/in")
        .split(stax(Record.class, false)).streaming()
            .to("mock:records");

## The previous example with XML DSL

The example above could be implemented as follows in Spring XML

      <!-- use STaXBuilder to create the expression we want to use in the route below for splitting the XML file -->
      <!-- notice we use the factory-method to define the stax method, and to pass in the parameter as a constructor-arg -->
      <bean id="staxRecord" class="org.apache.camel.component.stax.StAXBuilder" factory-method="stax">
        <!-- FQN class name of the POJO with the JAXB annotations -->
        <constructor-arg index="0" value="org.apache.camel.component.stax.model.Record"/>
      </bean>
    
      <camelContext xmlns="http://camel.apache.org/schema/spring">
        <route>
          <!-- pickup XML files -->
          <from uri="file:target/in"/>
          <split streaming="true">
            <!-- split the file using StAX (ref to bean above) -->
            <!-- and use streaming mode in the splitter -->
            <ref>staxRecord</ref>
            <!-- and send each split to a mock endpoint, which will be a Record POJO instance -->
            <to uri="mock:records"/>
          </split>
        </route>
      </camelContext>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|contentHandlerClass|The FQN class name for the ContentHandler implementation to use.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
