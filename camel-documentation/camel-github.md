# Github

**Since Camel 2.15**

**Both producer and consumer are supported**

The GitHub component interacts with the GitHub API by encapsulating
[egit-github](https://git.eclipse.org/c/egit/egit-github.git/). It
currently provides polling for new pull requests, pull request comments,
tags, and commits. It is also able to produce comments on pull requests,
as well as close the pull request entirely.

Rather than webhooks, this endpoint relies on simple polling. Reasons
include:

-   Concern for reliability/stability

-   The types of payloads we’re polling aren’t typically large (plus,
    paging is available in the API)

-   The need to support apps running somewhere not publicly accessible
    where a webhook would fail

Note that the GitHub API is fairly expansive. Therefore, this component
could be easily expanded to provide additional interactions.

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-github</artifactId>
        <version>${camel-version}</version>
    </dependency>

# URI format

    github://endpoint[?options]

# Configuring authentication

The GitHub component requires to be configured with an authentication
token on either the component or endpoint level.

For example, to set it on the component:

    GitHubComponent ghc = context.getComponent("github", GitHubComponent.class);
    ghc.setOauthToken("mytoken");

# Consumer Endpoints:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Endpoint</th>
<th style="text-align: left;">Context</th>
<th style="text-align: left;">Body Type</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>pullRequest</p></td>
<td style="text-align: left;"><p>polling</p></td>
<td
style="text-align: left;"><p><code>org.eclipse.egit.github.core.PullRequest</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p>pullRequestComment</p></td>
<td style="text-align: left;"><p>polling</p></td>
<td
style="text-align: left;"><p><code>org.eclipse.egit.github.core.Comment</code>
(comment on the general pull request discussion) or
<code>org.eclipse.egit.github.core.CommitComment</code> (inline comment
on a pull request diff)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>tag</p></td>
<td style="text-align: left;"><p>polling</p></td>
<td
style="text-align: left;"><p><code>org.eclipse.egit.github.core.RepositoryTag</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p>commit</p></td>
<td style="text-align: left;"><p>polling</p></td>
<td
style="text-align: left;"><p><code>org.eclipse.egit.github.core.RepositoryCommit</code></p></td>
</tr>
</tbody>
</table>

# Producer Endpoints:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Endpoint</th>
<th style="text-align: left;">Body</th>
<th style="text-align: left;">Message Headers</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>pullRequestComment</p></td>
<td style="text-align: left;"><p>String (comment text)</p></td>
<td style="text-align: left;"><p>- <code>GitHubPullRequest</code>
(integer) (REQUIRED): Pull request number.</p>
<p>- <code>GitHubInResponseTo</code> (integer): Required if responding
to another inline comment on the pull request diff. If left off, a
general comment on the pull request discussion is assumed.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>closePullRequest</p></td>
<td style="text-align: left;"><p>none</p></td>
<td style="text-align: left;"><p>- <code>GitHubPullRequest</code>
(integer) (REQUIRED): Pull request number.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>createIssue</p></td>
<td style="text-align: left;"><p>String (issue body text)</p></td>
<td style="text-align: left;"><p>- <code>GitHubIssueTitle</code>
(String) (REQUIRED): Issue Title.</p></td>
</tr>
</tbody>
</table>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|oauthToken|GitHub OAuth token. Must be configured on either component or endpoint.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|type|What git operation to execute||object|
|branchName|Name of branch||string|
|repoName|GitHub repository name||string|
|repoOwner|GitHub repository owner (organization)||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|startingSha|The starting sha to use for polling commits with the commit consumer. The value can either be a sha for the sha to start from, or use beginning to start from the beginning, or last to start from the last commit.|last|string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|eventFetchStrategy|To specify a custom strategy that configures how the EventsConsumer fetches events.||object|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|encoding|To use the given encoding when getting a git commit file||string|
|state|To set git commit status state||string|
|targetUrl|To set git commit status target url||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|backoffErrorThreshold|The number of subsequent error polls (failed due some error) that should happen before the backoffMultipler should kick-in.||integer|
|backoffIdleThreshold|The number of subsequent idle polls that should happen before the backoffMultipler should kick-in.||integer|
|backoffMultiplier|To let the scheduled polling consumer backoff if there has been a number of subsequent idles/errors in a row. The multiplier is then the number of polls that will be skipped before the next actual attempt is happening again. When this option is in use then backoffIdleThreshold and/or backoffErrorThreshold must also be configured.||integer|
|delay|Milliseconds before the next poll.|500|integer|
|greedy|If greedy is enabled, then the ScheduledPollConsumer will run immediately again, if the previous run polled 1 or more messages.|false|boolean|
|initialDelay|Milliseconds before the first poll starts.|1000|integer|
|repeatCount|Specifies a maximum limit of number of fires. So if you set it to 1, the scheduler will only fire once. If you set it to 5, it will only fire five times. A value of zero or negative means fire forever.|0|integer|
|runLoggingLevel|The consumer logs a start/complete log line when it polls. This option allows you to configure the logging level for that.|TRACE|object|
|scheduledExecutorService|Allows for configuring a custom/shared thread pool to use for the consumer. By default each consumer has its own single threaded thread pool.||object|
|scheduler|To use a cron scheduler from either camel-spring or camel-quartz component. Use value spring or quartz for built in scheduler|none|object|
|schedulerProperties|To configure additional properties when using a custom scheduler or any of the Quartz, Spring based scheduler.||object|
|startScheduler|Whether the scheduler should be auto started.|true|boolean|
|timeUnit|Time unit for initialDelay and delay options.|MILLISECONDS|object|
|useFixedDelay|Controls if fixed delay or fixed rate is used. See ScheduledExecutorService in JDK for details.|true|boolean|
|oauthToken|GitHub OAuth token. Must be configured on either component or endpoint.||string|
