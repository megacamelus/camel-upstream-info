# Aws-xray.md

**Since Camel 2.21**

The camel-aws-xray component is used for tracing and timing incoming and
outgoing Camel messages using [AWS XRay](https://aws.amazon.com/xray/).

Events (subsegments) are captured for incoming and outgoing messages
being sent to/from Camel.

# Configuration

The configuration properties for the AWS XRay tracer are:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>addExcludePatterns</p></td>
<td style="text-align: left;"><p> </p></td>
<td style="text-align: left;"><p>Sets exclude pattern(s) that will
disable tracing for Camel messages that matches the pattern. The content
is a Set&lt;String&gt; where the key is a pattern matching routeId’s.
The pattern uses the rules from Intercept.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>setTracingStrategy</p></td>
<td style="text-align: left;"><p>NoopTracingStrategy</p></td>
<td style="text-align: left;"><p>Allows a custom Camel
<code>InterceptStrategy</code> to be provided to track invoked processor
definitions like <code>BeanDefinition</code> or
<code>ProcessDefinition</code>.
<code>TraceAnnotatedTracingStrategy</code> will track any classes
invoked via <code>.bean(...)</code> or <code>.process(...)</code> that
contain a <code>@XRayTrace</code> annotation at class level.</p></td>
</tr>
</tbody>
</table>

There is currently only one way an AWS XRay tracer can be configured to
provide distributed tracing for a Camel application:

## Explicit

Include the `camel-aws-xray` component in your POM, along with any
specific dependencies associated with the AWS XRay Tracer.

To explicitly configure AWS XRay support, instantiate the `XRayTracer`
and initialize the camel context. You can optionally specify a `Tracer`,
or alternatively it can be implicitly discovered using the `Registry` or
`ServiceLoader`.

    XRayTracer xrayTracer = new XRayTracer();
    // By default, it uses a NoopTracingStrategy, but you can override it with a specific InterceptStrategy implementation.
    xrayTracer.setTracingStrategy(...);
    // And then initialize the context
    xrayTracer.init(camelContext);

To use XRayTracer in XML, all you need to do is to define the AWS XRay
tracer bean. Camel will automatically discover and use it.

      <bean id="tracingStrategy" class="..."/>
      <bean id="aws-xray-tracer" class="org.apache.camel.component.aws.xray.XRayTracer">
        <property name="tracer" ref="tracingStrategy"/>
      </bean>

In case of the default `NoopTracingStrategy` only the creation and
deletion of exchanges is tracked but not the invocation of certain beans
or EIP patterns.

## Tracking of comprehensive route execution

To track the execution of an exchange among multiple routes, on exchange
creation a unique trace ID is generated and stored in the headers if no
corresponding value was yet available. This trace ID is copied over to
new exchanges to keep a consistent view of the processed exchange.

As AWS XRay traces work on a thread-local basis, the current sub/segment
should be copied over to the new thread and set as explained in [the AWS
XRay
documentation](https://docs.aws.amazon.com/xray/latest/devguide/xray-sdk-java-multithreading.html).
The Camel AWS XRay component therefore provides an additional header
field that the component will use to set the passed AWS XRay `Entity` to
the new thread and thus keep the tracked data to the route rather than
exposing a new segment which seems uncorrelated with any of the executed
routes.

The component will use the following constants found in the headers of
the exchange:

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Camel-AWS-XRay-Trace-ID</p></td>
<td style="text-align: left;"><p>Contains a reference to the AWS XRay
<code>TraceID</code> object to provide a comprehensive view of the
invoked routes</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Camel-AWS-XRay-Trace-Entity</p></td>
<td style="text-align: left;"><p>Contains a reference to the actual AWS
XRay <code>Segment</code> or <code>Subsegment</code> which is copied
over to the new thread. This header should be set in case a new thread
is spawned and the performed tasks should be exposed as part of the
executed route instead of creating a new unrelated segment.</p></td>
</tr>
</tbody>
</table>

Note that the AWS XRay `Entity` (i.e., `Segment` and `Subsegment`) are
not serializable and therefore should not get passed to other JVM
processes.

# Example

You can find an example demonstrating the way to configure AWS XRay
tracing within the tests accompanying this project.

# Dependency

To include AWS XRay support into Camel, the archive containing the Camel
related AWS XRay related classes needs to be added to the project. In
addition to that, AWS XRay libraries also need to be available.

To include both AWS XRay and Camel dependencies, use the following Maven
imports:

      <dependencyManagement>
        <dependencies>
          <dependency>
            <groupId>com.amazonaws</groupId>
            <artifactId>aws-xray-recorder-sdk-bom</artifactId>
            <version>2.4.0</version>
            <type>pom</type>
            <scope>import</scope>
          </dependency>
        </dependencies>
      </dependencyManagement>
    
      <dependencies>
          <dependency>
            <groupId>org.apache.camel</groupId>
            <artifactId>camel-aws-xray</artifactId>
          </dependency>
    
          <dependency>
            <groupId>com.amazonaws</groupId>
            <artifactId>aws-xray-recorder-sdk-core</artifactId>
          </dependency>
          <dependency>
            <groupId>com.amazonaws</groupId>
            <artifactId>aws-xray-recorder-sdk-aws-sdk</artifactId>
          </dependency>
      </dependencies>
