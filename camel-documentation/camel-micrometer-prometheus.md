# Micrometer-prometheus.md

**Since Camel 4.3**

The camel-micrometer-prometheus is used for running Camel standalone
(Camel Main), and to integrate with the Micrometer Prometheus Registry.

# Usage

## Auto-detection from classpath

To use this implementation all you need to do is to add the
`camel-micrometer-prometheus` dependency to the classpath, and turn on
metrics in `application.properties` such as:

    # enable HTTP server with metrics
    camel.server.enabled=true
    camel.server.metricsEnabled=true
    
    # turn on micrometer metrics
    camel.metrics.enabled=true
    # include more camel details
    camel.metrics.enableMessageHistory=true
    # include additional out-of-the-box micrometer metrics for cpu, jvm and used file descriptors
    camel.metrics.binders=processor,jvm-info,file-descriptor

## List of known binders from Micrometer

The following binders can be configured with `camel.metrics.binders`
that comes out of the box from Micrometer:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Binder Name</p></td>
<td style="text-align: left;"><p>Description</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>class-loader</code></p></td>
<td style="text-align: left;"><p>JVM class loading metrics</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>commons-object-pool2</code></p></td>
<td style="text-align: left;"><p>Apache Commons Pool 2.x
metrics</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>file-descriptor</code></p></td>
<td style="text-align: left;"><p>File descriptor metrics gathered by the
JVM</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>hystrix-metrics-binder</code></p></td>
<td style="text-align: left;"><p>Hystrix Circuit Breaker
metrics</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jvm-compilation</code></p></td>
<td style="text-align: left;"><p>JVM compilation metrics</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>jvm-gc</code></p></td>
<td style="text-align: left;"><p>Garbage collection and GC
pauses</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jvm-heap-pressure</code></p></td>
<td style="text-align: left;"><p>Provides methods to access measurements
of low pool memory and heavy GC overhead</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>jvm-info</code></p></td>
<td style="text-align: left;"><p>JVM information</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>jvm-memory</code></p></td>
<td style="text-align: left;"><p>Utilization of various memory and
buffer pools.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>jvm-thread</code></p></td>
<td style="text-align: left;"><p>JVM threads statistics</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>log4j2</code></p></td>
<td style="text-align: left;"><p>Apache Log4j 2 statistics</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>logback</code></p></td>
<td style="text-align: left;"><p>Logback logger statistics</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>processor</code></p></td>
<td style="text-align: left;"><p>CPU processing statistics</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>uptime</code></p></td>
<td style="text-align: left;"><p>Uptime statistics</p></td>
</tr>
</tbody>
</table>
