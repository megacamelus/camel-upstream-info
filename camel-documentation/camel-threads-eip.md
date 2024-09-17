# Threads-eip.md

How can I decouple the continued routing of a message from the current
thread?

<figure>
<img src="eip/MessagingAdapterIcon.gif" alt="image" />
</figure>

Submit the message to a thread pool, which then is responsible for the
continued routing of the message.

In Camel, this is implemented as the Threads EIP.

# Options

# Exchange properties

# Using Threads EIP

The example below will add a Thread pool with a pool size of five
threads before sending to `mock:result`.

Java  
from("seda:a")
.threads(5)
.to("mock:result");

XML  
<route>  
<from uri="seda:a"/>  
<threads poolSize="5"/>  
<to uri="mock:result"/>  
</route>

And to use a thread pool with a task queue of only 20 elements:

Java  
from("seda:a")
.threads(5).maxQueueSize(20)
.to("mock:result");

XML  
<route>  
<from uri="seda:a"/>  
<threads poolSize="5" maxQueueSize="20"/>  
<to uri="mock:result"/>  
</route>

And you can also use a thread pool with no queue (meaning that a task
cannot be pending on a queue):

Java  
from("seda:a")
.threads(5).maxQueueSize(0)
.to("mock:result");

XML  
<route>  
<from uri="seda:a"/>  
<threads poolSize="5" maxQueueSize="0"/>  
<to uri="mock:result"/>  
</route>

## About rejected tasks

The Threads EIP uses a thread pool which has a worker queue for tasks.
When the worker queue gets full, the task is rejected.

You can customize how to react upon this using the `rejectedPolicy` and
`callerRunsWhenRejected` options. The latter is used to easily switch
between the two most common and recommended settings. Either let the
current caller thread execute the task (i.e. it will become
synchronous), but also give time for the thread pool to process its
current tasks, without adding more tasks (self throttling). This is the
default behavior.

The `Abort` policy, means the task is rejected, and a
`RejectedExecutionException` is thrown.

The reject policy options `Discard` and `DiscardOldest` is deprecated in
Camel 3.x and removed in Camel 4 onwards.

## Default values

The Threads EIP uses the default values from the default [Thread Pool
Profile](#manual:ROOT:threading-model.adoc). If the profile has not been
altered, then the default profile is as follows:

<table>
<colgroup>
<col style="width: 24%" />
<col style="width: 24%" />
<col style="width: 50%" />
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
<td style="text-align: left;"><p><strong>poolSize</strong></p></td>
<td style="text-align: left;"><p><code>10</code></p></td>
<td style="text-align: left;"><p>Sets the default core pool size
(minimum number of threads to keep in pool)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><strong>keepAliveTime</strong></p></td>
<td style="text-align: left;"><p><code>60</code></p></td>
<td style="text-align: left;"><p>Sets the default keep-alive time (in
seconds) for inactive threads</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><strong>maxPoolSize</strong></p></td>
<td style="text-align: left;"><p><code>20</code></p></td>
<td style="text-align: left;"><p>Sets the default maximum pool
size</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><strong>maxQueueSize</strong></p></td>
<td style="text-align: left;"><p><code>1000</code></p></td>
<td style="text-align: left;"><p>Sets the default maximum number of
tasks in the work queue. Use -1 for an unbounded queue.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>allowCoreThreadTimeOut</strong></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>Sets default whether to allow core
threads to timeout</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>rejectedPolicy</strong></p></td>
<td style="text-align: left;"><p><code>CallerRuns</code></p></td>
<td style="text-align: left;"><p>Sets the default handler for tasks
which cannot be executed by the thread pool. Has four options:
<code>Abort, CallerRuns, Discard, DiscardOldest</code> which corresponds
to the same four options provided out of the box in the JDK.</p></td>
</tr>
</tbody>
</table>

## See Also

See [Threading Model](#manual:ROOT:threading-model.adoc)
