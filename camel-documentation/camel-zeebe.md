# Zeebe

**Since Camel 3.21**

**Both producer and consumer are supported**

The **Zeebe**: components provides the ability to interact with business
processes in [Zeebe](https://github.com/camunda/zeebe).

To use the Zeebe component, Maven users will need to add the following
dependency to their `pom.xml`:

**Prerequisites**

You must have access to a local zeebe instance. More information is
available at [Camunda Zeebe](https://camunda.com/platform/zeebe/).

# URI format

    zeebe://[endpoint]?[options]

# Producer Endpoints:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Endpoint</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>startProcess</p></td>
<td style="text-align: left;"><p>Creates and starts an instance of the
specified process.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>cancelProcess</p></td>
<td style="text-align: left;"><p>Cancels a running process
instance.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>publishMessage</p></td>
<td style="text-align: left;"><p>Publishes a message.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>completeJob</p></td>
<td style="text-align: left;"><p>Completes a job for a service
task.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>failJob</p></td>
<td style="text-align: left;"><p>Fails a job.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>updateJobRetries</p></td>
<td style="text-align: left;"><p>Updates the number of retries for a
job.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>throwError</p></td>
<td style="text-align: left;"><p>Throw an error to indicate that a
business error has occurred.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>deployResource</p></td>
<td style="text-align: left;"><p>Deploy a process resource. Currently
only supports process definitions.</p></td>
</tr>
</tbody>
</table>

The endpoints accept either Java request objects as shown in the
examples below or JSON. In JSON camel case for property names is
replaced with all lower case separated by underscores, e.g., processId
becomes process\_id.

**Examples**

-   startProcess

<!-- -->

        from("direct:start")
            .process(exchange -> {
                ProcessRequest request = new ProcessRequest();
                request.setProcessId("processId");
                request.setVariables(new HashMap<String,Object> ());
                exchange.getIn().setBody(request);
            })
            .to("zeebe://startProcess")
            .process(exchange -> {
                ProcessResponse body = exchange.getIn().getBody(ProcessResponse.class);
                if (body != null) {
                    bool success = body.getSuccess();
                    long processInstanceKey = body.getProcessInstanceKey();
                }
            });

**JSON Request Example**

        {
            "process_id" : "Process_0e3ldfm",
            "variables" : { "v1": "a", "v2": 10 }
        }

**JSON Response Example**

        {
            "success": true,
            "process_id": "Process_0e3ldfm",
            "process_instance_key": 2251799813688297,
            "process_version": 4,
            "process_key": 2251799813685906
        }

-   cancelProcess

<!-- -->

        from("direct:start")
            .process(exchange -> {
                ProcessRequest request = new ProcessRequest();
                request.setProcessInstanceKey(123);
                exchange.getIn().setBody(request);
            })
            .to("zeebe://cancelProcess")
            .process(exchange -> {
                ProcessResponse body = exchange.getIn().getBody(ProcessResponse.class);
                if (body != null) {
                    bool success = body.getSuccess();
                }
            });

-   publishMessage

<!-- -->

        from("direct:start")
            .process(exchange -> {
                MessageRequest request = new MessageRequest();
                request.setCorrelationKey("messageKey");
                request.setTimeToLive(100);
                request.setVariables(new HashMap<String,Object>());
                request.setName("MessageName");
                exchange.getIn().setBody(request);
            })
            .to("zeebe://publishMessage")
            .process(exchange -> {
                MessageResponse body = exchange.getIn().getBody(MessageResponse.class);
                if (body != null) {
                    bool success = body.getSuccess();
                    String messageKey = body.getMessageKey();
                }
            });

**JSON Request Example**

        {
            "correlation_key" : "messageKey",
            "time-to-live" : 100,
            "variables" : { "v1": "a", "v2": 10 },
            "name" : "MessageName"
        }

**JSON Response Example**

        {
            "success": true,
            "correlation_key": "messageKey",
            "message_key": 2251799813688336
        }

-   completeJob

<!-- -->

        from("direct:start")
            .process(exchange -> {
                JobRequest request = new JobRequest();
                request.setJobKey("jobKey");
                request.setVariables(new HashMap<String,Object>());
                exchange.getIn().setBody(request);
            })
            .to("zeebe://completeJob")
            .process(exchange -> {
                JobResponse body = exchange.getIn().getBody(JobResponse.class);
                if (body != null) {
                    bool success = body.getSuccess();
                }
            });

-   failJob

<!-- -->

        from("direct:start")
            .process(exchange -> {
                JobRequest request = new JobRequest();
                request.setJobKey("jobKey");
                request.setRetries(3);
                request.setErrorMessage("Error");
                exchange.getIn().setBody(request);
            })
            .to("zeebe://failJob")
            .process(exchange -> {
                JobResponse body = exchange.getIn().getBody(JobResponse.class);
                if (body != null) {
                    bool success = body.getSuccess();
                }
            });

-   updateJobRetries

<!-- -->

        from("direct:start")
            .process(exchange -> {
                JobRequest request = new JobRequest();
                request.setJobKey("jobKey");
                request.setRetries(3);
                exchange.getIn().setBody(request);
            })
            .to("zeebe://updateJobRetries")
            .process(exchange -> {
                JobResponse body = exchange.getIn().getBody(JobResponse.class);
                if (body != null) {
                    bool success = body.getSuccess();
                }
            });

-   throwError

<!-- -->

        from("direct:start")
            .process(exchange -> {
                JobRequest request = new JobRequest();
                request.setJobKey("jobKey");
                request.setErrorMessage("Error Message");
                request.setErrorCode("Error Code")
                exchange.getIn().setBody(request);
            })
            .to("zeebe://throwError")
            .process(exchange -> {
                JobResponse body = exchange.getIn().getBody(JobResponse.class);
                if (body != null) {
                    bool success = body.getSuccess();
                }
            });

-   deployResource

<!-- -->

        from("direct:start")
            .process(exchange -> {
                DeploymentRequest request = new DeploymentRequest();
                request.setName("process.bpmn");
                request.setContent(content.getBytes());
                exchange.getIn().setBody(request);
            })
            .to("zeebe://deployResource")
            .process(exchange -> {
                ProcessDeploymentResponse body = exchange.getIn().getBody(ProcessDeploymentResponse.class);
                if (body != null) {
                    bool success = body.getSuccess();
                    String bpmnProcessId = body.getBpmnProcessId();
                    int version = body.getVersion();
                    long processDefinitionKey = body.getProcessDefinitionKey();
                    String resourceName = body.getResourceName();
                }
            });

# Consumer Endpoints:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Endpoint</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>worker</p></td>
<td style="text-align: left;"><p>Registers a job worker for a job type
and provides messages for available jobs.</p></td>
</tr>
</tbody>
</table>

**Example**

        from("zeebe://worker?jobKey=job1&timeout=20")
            .process(exchange -> {
                JobWorkerMessage body = exchange.getIn().getBody(JobWorkerMessage.class);
                if (body != null) {
                    long key = body.getKey();
                    String type = body.getType();
                    Map<String,String> customHeaders = body.getCustomHeaders();
                    long processInstanceKey = body.getProcessInstanceKey();
                    String bpmnProcessId = body.getBpmnProcessId();
                    int processDefinitionVersion = body.getProcessDefinitionVersion();
                    long processDefinitionKey = body.getProcessDefinitionKey();
                    String elementId = body.getElementId();
                    long elementInstanceKey = body.getElementInstanceKey();
                    String worker = body.getWorker();
                    int retries = body.getRetries();
                    long deadline = body.getDeadline();
                    Map<String,Object> variables = body.getVariables();
                }
            })

camel-zeebe creates a route exchange per job type with a job in the
body.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-zeebe</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version`} must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|oAuthAPI|The authorization server's URL, from which the access token will be requested.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|clientId|Client id to be used when requesting access token from OAuth authorization server.||string|
|clientSecret|Client secret to be used when requesting access token from OAuth authorization server.||string|
|gatewayHost|The gateway server hostname to connect to the Zeebe cluster.|localhost|string|
|gatewayPort|The gateway server port to connect to the Zeebe cluster.|26500|integer|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operationName|The operation to use||object|
|formatJSON|Format the result in the body as JSON.|false|boolean|
|jobKey|JobKey for the job worker.||string|
|timeout|Timeout for job worker.|10|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
