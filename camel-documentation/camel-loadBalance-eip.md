# LoadBalance-eip.md

The Load Balancer Pattern allows you to delegate to one of a number of
endpoints using a variety of different load balancing policies.

# Built-in load balancing policies

Camel provides the following policies out-of-the-box:

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Policy</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><a
href="#customLoadBalancer-eip.adoc">Custom Load Balancer</a></p></td>
<td style="text-align: left;"><p>To use a custom load balancer
implementation.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><a
href="#failoverLoadBalancer-eip.adoc">Fail-over Load
Balancer</a></p></td>
<td style="text-align: left;"><p>In case of failures, the exchange will
be tried on the next endpoint.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><a
href="#roundRobinLoadBalancer-eip.adoc">Round Robin Load
Balancer</a></p></td>
<td style="text-align: left;"><p>The destination endpoints are selected
in a round-robin fashion. This is a well-known and classic policy, which
spreads the load evenly.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><a
href="#randomLoadBalancer-eip.adoc">Random Load Balancer</a></p></td>
<td style="text-align: left;"><p>The destination endpoints are selected
randomly.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><a
href="#stickyLoadBalancer-eip.adoc">Sticky Load Balancer</a></p></td>
<td style="text-align: left;"><p>Sticky load balancing using an <a
href="#manual::expression.adoc">Expression</a> to calculate a
correlation key to perform the sticky load balancing.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><a
href="#topicLoadBalancer-eip.adoc">Topic Load Balancer</a></p></td>
<td style="text-align: left;"><p>Topic which sends to all
destinations.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><a
href="#weightedLoadBalancer-eip.adoc">Weighted Loader
Balancer</a></p></td>
<td style="text-align: left;"><p>Use a weighted load distribution ratio
for each server with respect to others.</p></td>
</tr>
</tbody>
</table>
