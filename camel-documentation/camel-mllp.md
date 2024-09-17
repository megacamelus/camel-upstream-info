# Mllp

**Since Camel 2.17**

**Both producer and consumer are supported**

The MLLP component is specifically designed to handle the nuances of the
MLLP protocol and provide the functionality required by Healthcare
providers to communicate with other systems using the MLLP protocol.

The MLLP component provides a simple configuration URI, automated HL7
acknowledgment generation, and automatic acknowledgment interrogation.

The MLLP protocol does not typically use a large number of concurrent
TCP connections - a single active TCP connection is the normal case.
Therefore, the MLLP component uses a simple thread-per-connection model
based on standard Java Sockets. This keeps the implementation simple and
eliminates the dependencies on only Camel itself.

The component supports the following:

-   A Camel consumer using a TCP Server

-   A Camel producer using a TCP Client

The MLLP component use `byte[]` payloads, and relies on Camel type
conversion to convert `byte[]` to other types.

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-mllp</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Usage

## MLLP Consumer

The MLLP Consumer supports receiving MLLP-framed messages and sending
HL7 Acknowledgements. The MLLP Consumer can automatically generate the
HL7 Acknowledgement (HL7 Application Acknowledgements only - AA, AE and
AR), or the acknowledgement can be specified using the
`CamelMllpAcknowledgement` exchange property. Additionally, the type of
acknowledgement that will be generated can be controlled by setting the
`CamelMllpAcknowledgementType` exchange property. The MLLP Consumer can
read messages without sending any HL7 Acknowledgement if the automatic
acknowledgement is disabled and the exchange pattern is `InOnly`.

### Exchange Properties

The type of acknowledgment the MLLP Consumer generates, and the state of
the TCP Socket can be controlled by these properties on the Camel
exchange:

<table>
<colgroup>
<col style="width: 34%" />
<col style="width: 32%" />
<col style="width: 32%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>Key</strong></p></td>
<td style="text-align: left;"><p><strong>Type</strong></p></td>
<td style="text-align: left;"><p><strong>Description</strong></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelMllpAcknowledgement</code></p></td>
<td style="text-align: left;"><p><code>byte[]</code></p></td>
<td style="text-align: left;"><p>If present, this property will be sent
to the client as the MLLP Acknowledgement</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelMllpAcknowledgementString</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>If present and
<code>CamelMllpAcknowledgement</code> is not present, this property will
we sent to the client as the MLLP Acknowledgement</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelMllpAcknowledgementMsaText</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>If neither
<code>CamelMllpAcknowledgement</code> or
<code>CamelMllpAcknowledgementString</code> are present and autoAck is
true, this property can be used to specify the contents of MSA-3 in the
generated HL7 acknowledgement</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelMllpAcknowledgementType</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>If neither
<code>CamelMllpAcknowledgement</code> or
<code>CamelMllpAcknowledgementString</code> are present and autoAck is
true, this property can be used to specify the HL7 acknowledgement type
(i.e. AA, AE, AR)</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelMllpAutoAcknowledge</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Overrides the autoAck query
parameter</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelMllpCloseConnectionBeforeSend</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, the Socket will be closed
before sending data</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelMllpResetConnectionBeforeSend</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, the Socket will be reset
before sending data</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelMllpCloseConnectionAfterSend</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, the Socket will be closed
immediately after sending data</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelMllpResetConnectionAfterSend</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, the Socket will be reset
immediately after sending any data</p></td>
</tr>
</tbody>
</table>

## MLLP Producer

The MLLP Producer supports sending MLLP-framed messages and receiving
HL7 Acknowledgements. The MLLP Producer interrogates the HL7
Acknowledgements and raises exceptions if a negative acknowledgement is
received. The received acknowledgement is interrogated and an exception
is raised in the event of a negative acknowledgement. The MLLP Producer
can ignore acknowledgements when configured with InOnly exchange
pattern.

### Exchange Properties

The state of the TCP Socket can be controlled by these properties on the
Camel exchange:

<table>
<colgroup>
<col style="width: 34%" />
<col style="width: 32%" />
<col style="width: 32%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>Key</strong></p></td>
<td style="text-align: left;"><p><strong>Type</strong></p></td>
<td style="text-align: left;"><p><strong>Description</strong></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelMllpCloseConnectionBeforeSend</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, the Socket will be closed
before sending data</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelMllpResetConnectionBeforeSend</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, the Socket will be reset
before sending data</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelMllpCloseConnectionAfterSend</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, the Socket will be closed
immediately after sending data</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelMllpResetConnectionAfterSend</code></p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>If true, the Socket will be reset
immediately after sending any data</p></td>
</tr>
</tbody>
</table>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|autoAck|Enable/Disable the automatic generation of a MLLP Acknowledgement MLLP Consumers only|true|boolean|
|charsetName|Sets the default charset to use||string|
|configuration|Sets the default configuration to use when creating MLLP endpoints.||object|
|hl7Headers|Enable/Disable the automatic generation of message headers from the HL7 Message MLLP Consumers only|true|boolean|
|requireEndOfData|Enable/Disable strict compliance to the MLLP standard. The MLLP standard specifies START\_OF\_BLOCKhl7 payloadEND\_OF\_BLOCKEND\_OF\_DATA, however, some systems do not send the final END\_OF\_DATA byte. This setting controls whether or not the final END\_OF\_DATA byte is required or optional.|true|boolean|
|stringPayload|Enable/Disable converting the payload to a String. If enabled, HL7 Payloads received from external systems will be validated converted to a String. If the charsetName property is set, that character set will be used for the conversion. If the charsetName property is not set, the value of MSH-18 will be used to determine th appropriate character set. If MSH-18 is not set, then the default ISO-8859-1 character set will be use.|true|boolean|
|validatePayload|Enable/Disable the validation of HL7 Payloads If enabled, HL7 Payloads received from external systems will be validated (see Hl7Util.generateInvalidPayloadExceptionMessage for details on the validation). If and invalid payload is detected, a MllpInvalidMessageException (for consumers) or a MllpInvalidAcknowledgementException will be thrown.|false|boolean|
|acceptTimeout|Timeout (in milliseconds) while waiting for a TCP connection TCP Server Only|60000|integer|
|backlog|The maximum queue length for incoming connection indications (a request to connect) is set to the backlog parameter. If a connection indication arrives when the queue is full, the connection is refused.|5|integer|
|bindRetryInterval|TCP Server Only - The number of milliseconds to wait between bind attempts|5000|integer|
|bindTimeout|TCP Server Only - The number of milliseconds to retry binding to a server port|30000|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions occurred while the consumer is trying to receive incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. If disabled, the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions by logging them at WARN or ERROR level and ignored.|true|boolean|
|lenientBind|TCP Server Only - Allow the endpoint to start before the TCP ServerSocket is bound. In some environments, it may be desirable to allow the endpoint to start before the TCP ServerSocket is bound.|false|boolean|
|maxConcurrentConsumers|The maximum number of concurrent MLLP Consumer connections that will be allowed. If a new connection is received and the maximum is number are already established, the new connection will be reset immediately.|5|integer|
|reuseAddress|Enable/disable the SO\_REUSEADDR socket option.|false|boolean|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.|InOut|object|
|connectTimeout|Timeout (in milliseconds) for establishing for a TCP connection TCP Client only|30000|integer|
|idleTimeoutStrategy|decide what action to take when idle timeout occurs. Possible values are : RESET: set SO\_LINGER to 0 and reset the socket CLOSE: close the socket gracefully default is RESET.|RESET|object|
|keepAlive|Enable/disable the SO\_KEEPALIVE socket option.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|tcpNoDelay|Enable/disable the TCP\_NODELAY socket option.|true|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|defaultCharset|Set the default character set to use for byte to/from String conversions.|ISO-8859-1|string|
|logPhi|Whether to log PHI|true|boolean|
|logPhiMaxBytes|Set the maximum number of bytes of PHI that will be logged in a log entry.|5120|integer|
|maxBufferSize|Maximum buffer size used when receiving or sending data over the wire.|1073741824|integer|
|minBufferSize|Minimum buffer size used when receiving or sending data over the wire.|2048|integer|
|readTimeout|The SO\_TIMEOUT value (in milliseconds) used after the start of an MLLP frame has been received|5000|integer|
|receiveBufferSize|Sets the SO\_RCVBUF option to the specified value (in bytes)|8192|integer|
|receiveTimeout|The SO\_TIMEOUT value (in milliseconds) used when waiting for the start of an MLLP frame|15000|integer|
|sendBufferSize|Sets the SO\_SNDBUF option to the specified value (in bytes)|8192|integer|
|idleTimeout|The approximate idle time allowed before the Client TCP Connection will be reset. A null value or a value less than or equal to zero will disable the idle timeout.||integer|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|hostname|Hostname or IP for connection for the TCP connection. The default value is null, which means any local IP address||string|
|port|Port number for the TCP connection||integer|
|autoAck|Enable/Disable the automatic generation of a MLLP Acknowledgement MLLP Consumers only|true|boolean|
|charsetName|Sets the default charset to use||string|
|hl7Headers|Enable/Disable the automatic generation of message headers from the HL7 Message MLLP Consumers only|true|boolean|
|requireEndOfData|Enable/Disable strict compliance to the MLLP standard. The MLLP standard specifies START\_OF\_BLOCKhl7 payloadEND\_OF\_BLOCKEND\_OF\_DATA, however, some systems do not send the final END\_OF\_DATA byte. This setting controls whether or not the final END\_OF\_DATA byte is required or optional.|true|boolean|
|stringPayload|Enable/Disable converting the payload to a String. If enabled, HL7 Payloads received from external systems will be validated converted to a String. If the charsetName property is set, that character set will be used for the conversion. If the charsetName property is not set, the value of MSH-18 will be used to determine th appropriate character set. If MSH-18 is not set, then the default ISO-8859-1 character set will be use.|true|boolean|
|validatePayload|Enable/Disable the validation of HL7 Payloads If enabled, HL7 Payloads received from external systems will be validated (see Hl7Util.generateInvalidPayloadExceptionMessage for details on the validation). If and invalid payload is detected, a MllpInvalidMessageException (for consumers) or a MllpInvalidAcknowledgementException will be thrown.|false|boolean|
|acceptTimeout|Timeout (in milliseconds) while waiting for a TCP connection TCP Server Only|60000|integer|
|backlog|The maximum queue length for incoming connection indications (a request to connect) is set to the backlog parameter. If a connection indication arrives when the queue is full, the connection is refused.|5|integer|
|bindRetryInterval|TCP Server Only - The number of milliseconds to wait between bind attempts|5000|integer|
|bindTimeout|TCP Server Only - The number of milliseconds to retry binding to a server port|30000|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions occurred while the consumer is trying to receive incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. If disabled, the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions by logging them at WARN or ERROR level and ignored.|true|boolean|
|lenientBind|TCP Server Only - Allow the endpoint to start before the TCP ServerSocket is bound. In some environments, it may be desirable to allow the endpoint to start before the TCP ServerSocket is bound.|false|boolean|
|maxConcurrentConsumers|The maximum number of concurrent MLLP Consumer connections that will be allowed. If a new connection is received and the maximum is number are already established, the new connection will be reset immediately.|5|integer|
|reuseAddress|Enable/disable the SO\_REUSEADDR socket option.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.|InOut|object|
|connectTimeout|Timeout (in milliseconds) for establishing for a TCP connection TCP Client only|30000|integer|
|idleTimeoutStrategy|decide what action to take when idle timeout occurs. Possible values are : RESET: set SO\_LINGER to 0 and reset the socket CLOSE: close the socket gracefully default is RESET.|RESET|object|
|keepAlive|Enable/disable the SO\_KEEPALIVE socket option.|true|boolean|
|tcpNoDelay|Enable/disable the TCP\_NODELAY socket option.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|maxBufferSize|Maximum buffer size used when receiving or sending data over the wire.|1073741824|integer|
|minBufferSize|Minimum buffer size used when receiving or sending data over the wire.|2048|integer|
|readTimeout|The SO\_TIMEOUT value (in milliseconds) used after the start of an MLLP frame has been received|5000|integer|
|receiveBufferSize|Sets the SO\_RCVBUF option to the specified value (in bytes)|8192|integer|
|receiveTimeout|The SO\_TIMEOUT value (in milliseconds) used when waiting for the start of an MLLP frame|15000|integer|
|sendBufferSize|Sets the SO\_SNDBUF option to the specified value (in bytes)|8192|integer|
|idleTimeout|The approximate idle time allowed before the Client TCP Connection will be reset. A null value or a value less than or equal to zero will disable the idle timeout.||integer|
