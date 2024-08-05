# Syslog-dataformat.md

**Since Camel 2.6**

The Syslog dataformat is used for working with
[RFC3164](http://www.ietf.org/rfc/rfc3164.txt) and RFC5424 messages.

This component supports the following:

-   UDP consumption of syslog messages

-   Agnostic data format using either plain String objects or
    SyslogMessage model objects.

-   Type Converter from/to SyslogMessage and String

-   Integration with the [camel-mina](#ROOT:mina-component.adoc)
    component.

-   Integration with the [camel-netty](#ROOT:netty-component.adoc)
    component.

-   Encoder and decoder for the [Netty
    component](#ROOT:netty-component.adoc).

-   Support for RFC5424 also.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-syslog</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# RFC3164 Syslog protocol

Syslog uses the user datagram protocol (UDP) as its underlying transport
layer mechanism. The UDP port that has been assigned to syslog is 514.

To expose a Syslog listener service, we reuse the existing [Mina
Component](#ROOT:mina-component.adoc) or [Netty
Component](#ROOT:netty-component.adoc) where we just use the
`Rfc3164SyslogDataFormat` to marshal and unmarshal messages. Notice that
from **Camel 2.14** onwards the syslog dataformat is renamed to
`SyslogDataFormat`.

# Options

# RFC5424 Syslog protocol

**Since Camel 2.14**

To expose a Syslog listener service, we reuse the existing [Mina
Component](#ROOT:mina-component.adoc) or [Netty
Component](#ROOT:netty-component.adoc) where we just use the
`SyslogDataFormat` to marshal and unmarshal messages

## Exposing a Syslog listener

In our Spring XML file, we configure an endpoint to listen for udp
messages on port 10514, note that in netty we disable the defaultCodec,
this  
will allow a fallback to a NettyTypeConverter and delivers the message
as an InputStream:

    <camelContext id="myCamel" xmlns="http://camel.apache.org/schema/spring">
    
        <dataFormats>
              <syslog id="mySyslog"/>
        </dataFormats>
    
        <route>
              <from uri="netty:udp://localhost:10514?sync=false&amp;allowDefaultCodec=false"/>
              <unmarshal><custom ref="mySyslog"/></unmarshal>
              <to uri="mock:stop1"/>
        </route>
    
    </camelContext>

The same route using [Mina Component](#ROOT:mina-component.adoc)

    <camelContext id="myCamel" xmlns="http://camel.apache.org/schema/spring">
    
        <dataFormats>
              <syslog id="mySyslog"/>
        </dataFormats>
    
        <route>
              <from uri="mina:udp://localhost:10514"/>
              <unmarshal><custom ref="mySyslog"/></unmarshal>
              <to uri="mock:stop1"/>
        </route>
    
    </camelContext>

## Sending syslog messages to a remote destination

    <camelContext id="myCamel" xmlns="http://camel.apache.org/schema/spring">
    
        <dataFormats>
            <syslog id="mySyslog"/>
        </dataFormats>
    
        <route>
            <from uri="direct:syslogMessages"/>
            <marshal><custom ref="mySyslog"/></marshal>
            <to uri="mina:udp://remotehost:10514"/>
        </route>
    
    </camelContext>
