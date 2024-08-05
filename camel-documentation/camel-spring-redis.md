# Spring-redis

**Since Camel 2.11**

**Both producer and consumer are supported**

This component allows sending and receiving messages from
[Redis](https://redis.io/). Redis is an advanced key-value store where
keys can contain strings, hashes, lists, sets and sorted sets. In
addition, it provides pub/sub functionality for inter-app
communications. Camel provides a producer for executing commands,
consumer for subscribing to pub/sub messages an idempotent repository
for filtering out duplicate messages.

**Prerequisites**

To use this component, you must have a Redis server running.

# URI Format

    spring-redis://host:port[?options]

# Usage

See also the unit tests available at
[https://github.com/apache/camel/tree/main/components/camel-spring-redis/src/test/java/org/apache/camel/component/redis](https://github.com/apache/camel/tree/main/components/camel-spring-redis/src/test/java/org/apache/camel/component/redis).

## Message headers evaluated by the Redis producer

The producer issues commands to the server, and each command has a
different set of parameters with specific types. The result from the
command execution is returned in the message body.

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 36%" />
<col style="width: 45%" />
<col style="width: 9%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Hash Commands</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Parameters</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>HSET</code></p></td>
<td style="text-align: left;"><p>Set the string value of a hash
field</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.FIELD</code>/"CamelRedis.Field" (String),
<code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HGET</code></p></td>
<td style="text-align: left;"><p>Get the value of a hash field</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.FIELD</code>/"CamelRedis.Field"
(String)</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HSETNX</code></p></td>
<td style="text-align: left;"><p>Set the value of a hash field only if
the field does not exist</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.FIELD</code>/"CamelRedis.Field" (String),
<code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HMSET</code></p></td>
<td style="text-align: left;"><p>Set multiple hash fields to multiple
values</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUES</code>/"CamelRedis.Values"
(Map&lt;String, Object&gt;)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HMGET</code></p></td>
<td style="text-align: left;"><p>Get the values of all the given hash
fields</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.FIELDS</code>/"CamelRedis.Fields"
(Collection&lt;String&gt;)</p></td>
<td style="text-align: left;"><p>Collection&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HINCRBY</code></p></td>
<td style="text-align: left;"><p>Increment the integer value of a hash
field by the given number</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.FIELD</code>/"CamelRedis.Field" (String),
<code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Long)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HEXISTS</code></p></td>
<td style="text-align: left;"><p>Determine if a hash field
exists</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.FIELD</code>/"CamelRedis.Field"
(String)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HDEL</code></p></td>
<td style="text-align: left;"><p>Delete one or more hash fields</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.FIELD</code>/"CamelRedis.Field"
(String)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HLEN</code></p></td>
<td style="text-align: left;"><p>Get the number of fields in a
hash</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HKEYS</code></p></td>
<td style="text-align: left;"><p>Get all the fields in a hash</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Set&lt;String&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HVALS</code></p></td>
<td style="text-align: left;"><p>Get all the values in a hash</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Collection&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>HGETALL</code></p></td>
<td style="text-align: left;"><p>Get all the fields and values in a
hash</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Map&lt;String, Object&gt;</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 36%" />
<col style="width: 45%" />
<col style="width: 9%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">List Commands</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Parameters</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>RPUSH</code></p></td>
<td style="text-align: left;"><p>Append one or multiple values to a
list</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>RPUSHX</code></p></td>
<td style="text-align: left;"><p>Append a value to a list only if the
list exists</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>LPUSH</code></p></td>
<td style="text-align: left;"><p>Prepend one or multiple values to a
list</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>LLEN</code></p></td>
<td style="text-align: left;"><p>Get the length of a list</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>LRANGE</code></p></td>
<td style="text-align: left;"><p>Get a range of elements from a
list</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.START</code>/"CamelRedis.Start"Long),
<code>RedisConstants.END</code>/"CamelRedis.End" (Long)</p></td>
<td style="text-align: left;"><p>List&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>LTRIM</code></p></td>
<td style="text-align: left;"><p>Trim a list to the specified
range</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.START</code>/"CamelRedis.Start"Long),
<code>RedisConstants.END</code>/"CamelRedis.End" (Long)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>LINDEX</code></p></td>
<td style="text-align: left;"><p>Get an element from a list by its
index</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.INDEX</code>/"CamelRedis.Index"
(Long)</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>LINSERT</code></p></td>
<td style="text-align: left;"><p>Insert an element before or after
another element in a list</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object),
<code>RedisConstants.PIVOT</code>/"CamelRedis.Pivot" (String),
<code>RedisConstants.POSITION</code>/"CamelRedis.Position"
(String)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>LSET</code></p></td>
<td style="text-align: left;"><p>Set the value of an element in a list
by its index</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object),
<code>RedisConstants.INDEX</code>/"CamelRedis.Index" (Long)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>LREM</code></p></td>
<td style="text-align: left;"><p>Remove elements from a list</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object),
<code>RedisConstants.COUNT</code>/"CamelRedis.Count" (Long)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>LPOP</code></p></td>
<td style="text-align: left;"><p>Remove and get the first element in a
list</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>RPOP</code></p></td>
<td style="text-align: left;"><p>Remove and get the last element in a
list</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>RPOPLPUSH</code></p></td>
<td style="text-align: left;"><p>Remove the last element in a list,
append it to another list and return it</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String),
<code>RedisConstants.DESTINATION</code>/"CamelRedis.Destination"
(String)</p></td>
<td style="text-align: left;"><p>Object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>BRPOPLPUSH</code></p></td>
<td style="text-align: left;"><p>Pop a value from a list, push it to
another list and return it; or block until one is available</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String),
<code>RedisConstants.DESTINATION</code>/"CamelRedis.Destination"
(String), <code>RedisConstants.TIMEOUT</code>/"CamelRedis.Timeout"
(Long)</p></td>
<td style="text-align: left;"><p>Object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>BLPOP</code></p></td>
<td style="text-align: left;"><p>Remove and get the first element in a
list, or block until one is available</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.TIMEOUT</code>/"CamelRedis.Timeout"
(Long)</p></td>
<td style="text-align: left;"><p>Object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>BRPOP</code></p></td>
<td style="text-align: left;"><p>Remove and get the last element in a
list, or block until one is available</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.TIMEOUT</code>/"CamelRedis.Timeout"
(Long)</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 36%" />
<col style="width: 45%" />
<col style="width: 9%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Set Commands</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Parameters</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>SADD</code></p></td>
<td style="text-align: left;"><p>Add one or more members to a
set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SMEMBERS</code></p></td>
<td style="text-align: left;"><p>Get all the members in a set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Set&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SREM</code></p></td>
<td style="text-align: left;"><p>Remove one or more members from a
set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SPOP</code></p></td>
<td style="text-align: left;"><p>Remove and return a random member from
a set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SMOVE</code></p></td>
<td style="text-align: left;"><p>Move a member from one set to
another</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object),
<code>RedisConstants.DESTINATION</code>/"CamelRedis.Destination"
(String)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SCARD</code></p></td>
<td style="text-align: left;"><p>Get the number of members in a
set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SISMEMBER</code></p></td>
<td style="text-align: left;"><p>Determine if a given value is a member
of a set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SINTER</code></p></td>
<td style="text-align: left;"><p>Intersect multiple sets</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.KEYS</code>/"CamelRedis.Keys"
(String)</p></td>
<td style="text-align: left;"><p>Set&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SINTERSTORE</code></p></td>
<td style="text-align: left;"><p>Intersect multiple sets and store the
resulting set in a key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.KEYS</code>/"CamelRedis.Keys" (String),
<code>RedisConstants.DESTINATION</code>/"CamelRedis.Destination"
(String)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SUNION</code></p></td>
<td style="text-align: left;"><p>Add multiple sets</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.KEYS</code>/"CamelRedis.Keys"
(String)</p></td>
<td style="text-align: left;"><p>Set&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SUNIONSTORE</code></p></td>
<td style="text-align: left;"><p>Add multiple sets and store the
resulting set in a key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.KEYS</code>/"CamelRedis.Keys" (String),
<code>RedisConstants.DESTINATION</code>/"CamelRedis.Destination"
(String)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SDIFF</code></p></td>
<td style="text-align: left;"><p>Subtract multiple sets</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.KEYS</code>/"CamelRedis.Keys"
(String)</p></td>
<td style="text-align: left;"><p>Set&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SDIFFSTORE</code></p></td>
<td style="text-align: left;"><p>Subtract multiple sets and store the
resulting set in a key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.KEYS</code>/"CamelRedis.Keys" (String),
<code>RedisConstants.DESTINATION</code>/"CamelRedis.Destination"
(String)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SRANDMEMBER</code></p></td>
<td style="text-align: left;"><p>Get one or multiple random members from
a set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 36%" />
<col style="width: 45%" />
<col style="width: 9%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Ordered set Commands</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Parameters</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>ZADD</code></p></td>
<td style="text-align: left;"><p>Add one or more members to a sorted
set, or update its score if it already exists</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object),
<code>RedisConstants.SCORE</code>/"CamelRedis.Score" (Double)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZRANGE</code></p></td>
<td style="text-align: left;"><p>Return a range of members in a sorted
set, by index</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.START</code>/"CamelRedis.Start"Long),
<code>RedisConstants.END</code>/"CamelRedis.End" (Long),
<code>RedisConstants.WITHSCORE</code>/"CamelRedis.WithScore"
(Boolean)</p></td>
<td style="text-align: left;"><p>Object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZREM</code></p></td>
<td style="text-align: left;"><p>Remove one or more members from a
sorted set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZINCRBY</code></p></td>
<td style="text-align: left;"><p>Increment the score of a member in a
sorted set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object),
<code>RedisConstants.INCREMENT</code>/"CamelRedis.Increment"
(Double)</p></td>
<td style="text-align: left;"><p>Double</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZRANK</code></p></td>
<td style="text-align: left;"><p>Determine the index of a member in a
sorted set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZREVRANK</code></p></td>
<td style="text-align: left;"><p>Determine the index of a member in a
sorted set, with scores ordered from high to low</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZREVRANGE</code></p></td>
<td style="text-align: left;"><p>Return a range of members in a sorted
set, by index, with scores ordered from high to low</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.START</code>/"CamelRedis.Start"Long),
<code>RedisConstants.END</code>/"CamelRedis.End" (Long),
<code>RedisConstants.WITHSCORE</code>/"CamelRedis.WithScore"
(Boolean)</p></td>
<td style="text-align: left;"><p>Object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZCARD</code></p></td>
<td style="text-align: left;"><p>Get the number of members in a sorted
set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZCOUNT</code></p></td>
<td style="text-align: left;"><p>Count the members in a sorted set with
scores within the given values</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.MIN</code>/"CamelRedis.Min" (Double),
<code>RedisConstants.MAX</code>/"CamelRedis.Max" (Double)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZRANGEBYSCORE</code></p></td>
<td style="text-align: left;"><p>Return a range of members in a sorted
set, by score</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.MIN</code>/"CamelRedis.Min" (Double),
<code>RedisConstants.MAX</code>/"CamelRedis.Max" (Double)</p></td>
<td style="text-align: left;"><p>Set&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZREVRANGEBYSCORE</code></p></td>
<td style="text-align: left;"><p>Return a range of members in a sorted
set, by score, with scores ordered from high to low</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.MIN</code>/"CamelRedis.Min" (Double),
<code>RedisConstants.MAX</code>/"CamelRedis.Max" (Double)</p></td>
<td style="text-align: left;"><p>Set&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZREMRANGEBYRANK</code></p></td>
<td style="text-align: left;"><p>Remove all members in a sorted set
within the given indexes</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.START</code>/"CamelRedis.Start"Long),
<code>RedisConstants.END</code>/"CamelRedis.End" (Long)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZREMRANGEBYSCORE</code></p></td>
<td style="text-align: left;"><p>Remove all members in a sorted set
within the given scores</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.START</code>/"CamelRedis.Start"Long),
<code>RedisConstants.END</code>/"CamelRedis.End" (Long)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZUNIONSTORE</code></p></td>
<td style="text-align: left;"><p>Add multiple sorted sets and store the
resulting-sorted set in a new key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.KEYS</code>/"CamelRedis.Keys" (String),
<code>RedisConstants.DESTINATION</code>/"CamelRedis.Destination"
(String)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ZINTERSTORE</code></p></td>
<td style="text-align: left;"><p>Intersect multiple sorted sets and
store the resulting sorted set in a new key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.KEYS</code>/"CamelRedis.Keys" (String),
<code>RedisConstants.DESTINATION</code>/"CamelRedis.Destination"
(String)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 36%" />
<col style="width: 45%" />
<col style="width: 9%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">String Commands</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Parameters</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>SET</code></p></td>
<td style="text-align: left;"><p>Set the string value of a key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>GET</code></p></td>
<td style="text-align: left;"><p>Get the value of a key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>STRLEN</code></p></td>
<td style="text-align: left;"><p>Get the length of the value stored in a
key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>APPEND</code></p></td>
<td style="text-align: left;"><p>Append a value to a key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(String)</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SETBIT</code></p></td>
<td style="text-align: left;"><p>Sets or clears the bit at offset in the
string value stored at key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.OFFSET</code>/"CamelRedis.Offset" (Long),
<code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Boolean)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>GETBIT</code></p></td>
<td style="text-align: left;"><p>Returns the bit value at offset in the
string value stored at key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.OFFSET</code>/"CamelRedis.Offset"
(Long)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SETRANGE</code></p></td>
<td style="text-align: left;"><p>Overwrite part of a string at key
starting at the specified offset</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object),
<code>RedisConstants.OFFSET</code>/"CamelRedis.Offset" (Long)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>GETRANGE</code></p></td>
<td style="text-align: left;"><p>Get a substring of the string stored at
a key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.START</code>/"CamelRedis.Start"Long),
<code>RedisConstants.END</code>/"CamelRedis.End" (Long)</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SETNX</code></p></td>
<td style="text-align: left;"><p>Set the value of a key only if the key
does not exist</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SETEX</code></p></td>
<td style="text-align: left;"><p>Set the value and expiration of a
key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object),
<code>RedisConstants.TIMEOUT</code>/"CamelRedis.Timeout" (Long),
SECONDS</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>DECRBY</code></p></td>
<td style="text-align: left;"><p>Decrement the integer value of a key by
the given number</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Long)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>DECR</code></p></td>
<td style="text-align: left;"><p>Decrement the integer value of a key by
one</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String),</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>INCRBY</code></p></td>
<td style="text-align: left;"><p>Increment the integer value of a key by
the given amount</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Long)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>INCR</code></p></td>
<td style="text-align: left;"><p>Increment the integer value of a key by
one</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>MGET</code></p></td>
<td style="text-align: left;"><p>Get the values of all the given
keys</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.FIELDS</code>/"CamelRedis.Fields"
(Collection&lt;String&gt;)</p></td>
<td style="text-align: left;"><p>List&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>MSET</code></p></td>
<td style="text-align: left;"><p>Set multiple keys to multiple
values</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.VALUES</code>/"CamelRedis.Values"
(Map&lt;String, Object&gt;)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>MSETNX</code></p></td>
<td style="text-align: left;"><p>Set multiple keys to multiple values
only if none of the keys exist</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>GETSET</code></p></td>
<td style="text-align: left;"><p>Set the string value of a key and
return its old value</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Object</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 36%" />
<col style="width: 45%" />
<col style="width: 9%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Key Commands</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Parameters</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>EXISTS</code></p></td>
<td style="text-align: left;"><p>Determine if a key exists</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>DEL</code></p></td>
<td style="text-align: left;"><p>Delete a key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEYS</code>/"CamelRedis.Keys"
(String)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>TYPE</code></p></td>
<td style="text-align: left;"><p>Determine the type stored at
key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>DataType</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>KEYS</code></p></td>
<td style="text-align: left;"><p>Find all keys matching the given
pattern</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.PATERN</code>/"CamelRedis.Pattern"
(String)</p></td>
<td style="text-align: left;"><p>Collection&lt;String&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>RANDOMKEY</code></p></td>
<td style="text-align: left;"><p>Return a random key from the
keyspace</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.PATERN</code>/"CamelRedis.Pattern"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(String)</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>RENAME</code></p></td>
<td style="text-align: left;"><p>Rename a key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>RENAMENX</code></p></td>
<td style="text-align: left;"><p>Rename a key, only if the new key does
not exist</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(String)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>EXPIRE</code></p></td>
<td style="text-align: left;"><p>Set a key’s time to live in
seconds</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.TIMEOUT</code>/"CamelRedis.Timeout"
(Long)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SORT</code></p></td>
<td style="text-align: left;"><p>Sort the elements in a list, set or
sorted set</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>List&lt;Object&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>PERSIST</code></p></td>
<td style="text-align: left;"><p>Remove the expiration from a
key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>EXPIREAT</code></p></td>
<td style="text-align: left;"><p>Set the expiration for a key as a UNIX
timestamp</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.TIMESTAMP</code>/"CamelRedis.Timestamp"
(Long)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>PEXPIRE</code></p></td>
<td style="text-align: left;"><p>Set a key’s time to live in
milliseconds</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.TIMEOUT</code>/"CamelRedis.Timeout"
(Long)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>PEXPIREAT</code></p></td>
<td style="text-align: left;"><p>Set the expiration for a key as a UNIX
timestamp specified in milliseconds</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.TIMESTAMP</code>/"CamelRedis.Timestamp"
(Long)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>TTL</code></p></td>
<td style="text-align: left;"><p>Get the time to live for a key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>MOVE</code></p></td>
<td style="text-align: left;"><p>Move a key to another database</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.DB</code>/"CamelRedis.Db"
(Integer)</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 36%" />
<col style="width: 45%" />
<col style="width: 9%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Geo Commands</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Parameters</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>GEOADD</code></p></td>
<td style="text-align: left;"><p>Adds the specified geospatial items
(latitude, longitude, name) to the specified key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.LATITUDE</code>/"CamelRedis.Latitude"
(Double), <code>RedisConstants.LONGITUDE</code>/"CamelRedis.Longitude"
(Double), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>GEODIST</code></p></td>
<td style="text-align: left;"><p>Return the distance between two members
in the geospatial index for the specified key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUES</code>/"CamelRedis.Values"
(Object[])</p></td>
<td style="text-align: left;"><p>Distance</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>GEOHASH</code></p></td>
<td style="text-align: left;"><p>Return valid Geohash strings
representing the position of an element in the geospatial index for the
specified key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>List&lt;String&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>GEOPOS</code></p></td>
<td style="text-align: left;"><p>Return the positions (longitude,
latitude) of an element in the geospatial index for the specified
key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(Object)</p></td>
<td style="text-align: left;"><p>List&lt;Point&gt;</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>GEORADIUS</code></p></td>
<td style="text-align: left;"><p>Return the element in the geospatial
index for the specified key which is within the borders of the area
specified with the center location and the maximum distance from the
center (the radius)</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.LATITUDE</code>/"CamelRedis.Latitude"
(Double), <code>RedisConstants.LONGITUDE</code>/"CamelRedis.Longitude"
(Double), <code>RedisConstants.RADIUS</code>/"CamelRedis.Radius"
(Double), <code>RedisConstants.COUNT</code>/"CamelRedis.Count"
(Integer)</p></td>
<td style="text-align: left;"><p>GeoResults</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>GEORADIUSBYMEMBER</code></p></td>
<td style="text-align: left;"><p>This command is exactly like GEORADIUS
with the sole difference that instead of taking, as the center of the
area to query, a longitude and latitude value, it takes the name of a
member already existing inside the geospatial index for the specified
key</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEY</code>/"CamelRedis.Key"
(String), <code>RedisConstants.VALUE</code>/"CamelRedis.Value" (Object),
<code>RedisConstants.RADIUS</code>/"CamelRedis.Radius" (Double),
<code>RedisConstants.COUNT</code>/"CamelRedis.Count" (Integer)</p></td>
<td style="text-align: left;"><p>GeoResults</p></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: left;"><p>Other Command</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Parameters</p></td>
<td style="text-align: left;"><p>Result</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>MULTI</code></p></td>
<td style="text-align: left;"><p>Mark the start of a transaction
block</p></td>
<td style="text-align: left;"><p>none</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>DISCARD</code></p></td>
<td style="text-align: left;"><p>Discard all commands issued after
MULTI</p></td>
<td style="text-align: left;"><p>none</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>EXEC</code></p></td>
<td style="text-align: left;"><p>Execute all commands issued after
MULTI</p></td>
<td style="text-align: left;"><p>none</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>WATCH</code></p></td>
<td style="text-align: left;"><p>Watch the given keys to determine
execution of the MULTI/EXEC block</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.KEYS</code>/"CamelRedis.Keys"
(String)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>UNWATCH</code></p></td>
<td style="text-align: left;"><p>Forget about all watched keys</p></td>
<td style="text-align: left;"><p>none</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ECHO</code></p></td>
<td style="text-align: left;"><p>Echo the given string</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.VALUE</code>/"CamelRedis.Value"
(String)</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>PING</code></p></td>
<td style="text-align: left;"><p>Ping the server</p></td>
<td style="text-align: left;"><p>none</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>QUIT</code></p></td>
<td style="text-align: left;"><p>Close the connection</p></td>
<td style="text-align: left;"><p>none</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>PUBLISH</code></p></td>
<td style="text-align: left;"><p>Post a message to a channel</p></td>
<td
style="text-align: left;"><p><code>RedisConstants.CHANNEL</code>/"CamelRedis.Channel"
(String), <code>RedisConstants.MESSAGE</code>/"CamelRedis.Message"
(Object)</p></td>
<td style="text-align: left;"><p>void</p></td>
</tr>
</tbody>
</table>

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-spring-redis</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version`} must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|redisTemplate|Reference to a pre-configured RedisTemplate instance to use.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|The host where Redis server is running.||string|
|port|Redis server port number||integer|
|channels|List of topic names or name patterns to subscribe to. Multiple names can be separated by comma.||string|
|command|Default command, which can be overridden by message header. Notice the consumer only supports the following commands: PSUBSCRIBE and SUBSCRIBE|SET|object|
|connectionFactory|Reference to a pre-configured RedisConnectionFactory instance to use.||object|
|redisTemplate|Reference to a pre-configured RedisTemplate instance to use.||object|
|serializer|Reference to a pre-configured RedisSerializer instance to use.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|listenerContainer|Reference to a pre-configured RedisMessageListenerContainer instance to use.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
