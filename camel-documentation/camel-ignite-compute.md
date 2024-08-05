# Ignite-compute

**Since Camel 2.17**

**Only producer is supported**

The Ignite Compute endpoint is one of camel-ignite endpoints which
allows you to run [compute
operations](https://apacheignite.readme.io/docs/compute-grid) on the
cluster by passing in an IgniteCallable, an IgniteRunnable, an
IgniteClosure, or collections of them, along with their parameters if
necessary.

The host part of the endpoint URI is a symbolic endpoint ID, it is not
used for any purposes.

The endpoint tries to run the object passed in the body of the IN
message as the compute job. It expects different payload types depending
on the execution type.

# Expected payload types

Each operation expects the indicated types:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Expected payloads</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>CALL</p></td>
<td style="text-align: left;"><p>Collection of IgniteCallable, or a
single IgniteCallable.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>BROADCAST</p></td>
<td style="text-align: left;"><p>IgniteCallable, IgniteRunnable,
IgniteClosure.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>APPLY</p></td>
<td style="text-align: left;"><p>IgniteClosure.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>EXECUTE</p></td>
<td style="text-align: left;"><p>ComputeTask, Class&lt;? extends
ComputeTask&gt; or an object representing parameters if the taskName
option is not null.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>RUN</p></td>
<td style="text-align: left;"><p>A Collection of IgniteRunnables, or a
single IgniteRunnable.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>AFFINITY_CALL</p></td>
<td style="text-align: left;"><p>IgniteCallable.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>AFFINITY_RUN</p></td>
<td style="text-align: left;"><p>IgniteRunnable.</p></td>
</tr>
</tbody>
</table>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configurationResource|The resource from where to load the configuration. It can be a: URL, String or InputStream type.||object|
|ignite|To use an existing Ignite instance.||object|
|igniteConfiguration|Allows the user to set a programmatic ignite configuration.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|endpointId|The endpoint ID (not used).||string|
|clusterGroupExpression|An expression that returns the Cluster Group for the IgniteCompute instance.||object|
|computeName|The name of the compute job, which will be set via IgniteCompute#withName(String).||string|
|executionType|The compute operation to perform. Possible values: CALL, BROADCAST, APPLY, EXECUTE, RUN, AFFINITY\_CALL, AFFINITY\_RUN. The component expects different payload types depending on the operation.||object|
|propagateIncomingBodyIfNoReturnValue|Sets whether to propagate the incoming body if the return type of the underlying Ignite operation is void.|true|boolean|
|taskName|The task name, only applicable if using the IgniteComputeExecutionType#EXECUTE execution type.||string|
|timeoutMillis|The timeout interval for triggered jobs, in milliseconds, which will be set via IgniteCompute#withTimeout(long).||integer|
|treatCollectionsAsCacheObjects|Sets whether to treat Collections as cache objects or as Collections of items to insert/update/compute, etc.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
