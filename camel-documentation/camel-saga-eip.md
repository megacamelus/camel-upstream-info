# Saga-eip.md

The Saga EIP provides a way to define a series of related actions in a
Camel route that should be either completed successfully (**all of
them**) or not-executed/compensated. Sagas implementations are able to
coordinate **distributed services communicating using any transport**
towards a globally **consistent outcome**.

Although their main purpose is similar, Sagas are different from
classical ACID distributed (XA) transactions. That is because the status
of the different participating services is guaranteed to be consistent
only at the end of the Saga and not in any intermediate step (lack of
isolation).

<figure>
<img src="eip/SagaPattern.png" alt="image" />
</figure>

Conversely, Sagas are suitable for many use cases where usage of
distributed transactions is discouraged. For example, services
participating in a Saga are allowed to use any kind of datastore:
classical databases or even NoSQL non-transactional databases. Sagas are
also suitable for being used in stateless cloud services as they do not
require a transaction log to be stored alongside the service.

Differently from transactions, Sagas are also not required to be
completed in a small amount of time because they don’t use
database-level locks. They can live for a longer time span: from a few
seconds to several days. The Saga EIP implementation based on the
MicroProfile sandbox spec is indeed called LRA that stands for
*"Long-Running Action"*. It also supports coordination of external
**heterogeneous services**, written with any language/technology and
also running outside a JVM.

see camel-lra.

Sagas don’t use locks on data. Instead, they define the concept of
"Compensating Action" that is an action that should be executed when the
standard flow encounters an error, with the purpose of restoring the
status that was present before the flow execution. Compensating actions
can be declared in Camel routes using the Java or XML DSL and will be
invoked by Camel only when needed (if the saga is canceled due to an
error).

# Options

# Exchange properties

# Exchange headers

The following exchange headers are set on each `Exchange` participating
in a Saga (normal actions, compensating actions and completions):

<table>
<colgroup>
<col style="width: 36%" />
<col style="width: 18%" />
<col style="width: 45%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>Long-Running-Action</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>A globally unique identifier for the
Saga that can be propagated to remote systems using transport-level
headers (e.g., HTTP).</p></td>
</tr>
</tbody>
</table>

# Saga Service Configuration

The Saga EIP requires that a service implementing the interface
`org.apache.camel.saga.CamelSagaService` is added to the \`CamelContext.

Camel currently supports the following Saga Services:

-   `InMemorySagaService`: Is a **basic** implementation of the Saga EIP
    that does not support advanced features (no remote context
    propagation, no consistency guarantee in case of application
    failure).

-   `LRASagaService`: Is a **fully-fledged** implementation of the Saga
    EIP based on MicroProfile sandbox LRA specification that supports
    remote context propagation and provides consistency guarantees in
    case of application failure.

## Using the In-Memory Saga Service

The in-memory Saga service is not recommended for production
environments. It does not support the persistence of the Saga status (it
is kept only in-memory), so it cannot guarantee the consistency of Sagas
in case of application failure (e.g., JVM crash).

Also, when using an in-memory Saga service, Saga contexts cannot be
propagated to remote services using transport-level headers (it can be
done with other implementations).

Users that want to use the in-memory saga service should add the
following code to customize the Camel context.

    context.addService(new org.apache.camel.saga.InMemorySagaService());

This service belongs in the `camel-support` module.

## Using the LRA Saga Service

The LRA Saga Service is an implementation based on the MicroProfile
sandbox LRA specification. It leverages an **external Saga coordinator**
to control the execution of the various steps of the Saga. The proposed
reference implementation for the LRA specification is the [Narayana LRA
Coordinator](http://jbossts.blogspot.it/2017/12/narayana-lra-implementation-of-saga.html).
Users can follow instructions present on the Narayana website to **start
up a remote instance of the coordinator**.

The URL of the LRA coordinator is a required parameter of the Camel LRA
service. The Camel application and the LRA service communicate using the
HTTP protocol.

To use the LRA Saga service, maven users will need to add the following
dependency to their `pom.xml`:

    <dependency>
     <groupId>org.apache.camel</groupId>
     <artifactId>camel-lra</artifactId>
     <!-- use the same version as your Camel core version -->
     <version>x.y.z</version>
    </dependency>

A Camel REST context is also required to be present for the LRA
implementation to work. You may add `camel-undertow` for example.

    <dependency>
     <groupId>org.apache.camel</groupId>
     <artifactId>camel-undertow</artifactId>
     <!-- use the same version as your Camel core version -->
     <version>x.y.z</version>
    </dependency>

The LRA implementation of the Saga EIP will add some web endpoints under
the `_"/lra-participant"_` path. Those endpoints will be used by the LRA
coordinator for calling back the application.

    // Configure the LRA saga service
    org.apache.camel.service.lra.LRASagaService sagaService = new org.apache.camel.service.lra.LRASagaService();
    sagaService.setCoordinatorUrl("http://lra-service-host");
    sagaService.setLocalParticipantUrl("http://my-host-as-seen-by-lra-service:8080/context-path");
    
    // Add it to the Camel context
    context.addService(sagaService);

### Using the LRA Saga Service in Spring Boot

Spring Boot users can use a simplified configuration model for the LRA
Saga Service. Maven users can include the **camel-lra-starter** module
in their project:

    <dependency>
     <groupId>org.apache.camel.springboot</groupId>
     <artifactId>camel-lra-starter</artifactId>
     <!-- use the same version as your Camel core version -->
     <version>x.y.z</version>
    </dependency>
    
    <dependency>
     <groupId>org.apache.camel.springboot</groupId>
     <artifactId>camel-undertow-starter</artifactId>
     <!-- use the same version as your Camel core version -->
     <version>x.y.z</version>
    </dependency>

Configuration can be done in the Spring Boot `application.yaml` file:

**application.yaml**

    camel:
      lra:
        enabled: true
        coordinator-url: http://lra-service-host
        local-participant-url: http://my-host-as-seen-by-lra-service:8080/context-path

Once done, the Saga EIP can be directly used inside Camel routes, and it
will use the LRA Saga Service under the hood.

# Examples

Suppose you want to place a new order, and you have two distinct
services in your system: one managing the orders and one managing the
credit. Logically, you can place an order if you have enough credits for
it.

With the Saga EIP you can model the `direct:buy` route as a Saga
composed of two distinct actions, one to create the order and one to
take the credit.

**Both actions must be executed, or none of them**: an order placed
without enough credits can be considered an inconsistent outcome (and a
payment without an order).

    from("direct:buy")
      .saga()
        .to("direct:newOrder")
        .to("direct:reserveCredit");

**That’s it**. The buy action will not change for the rest of the
examples. We’ll just see different options that can be used to model the
"New Order" and "Reserve Credit" actions in the following.

We have used a `direct` endpoint to model the two actions since this
example can be used with both implementations of the Saga service. We
could have used **http** or other kinds of endpoint with the LRA Saga
service.

Both services called by the `direct:buy` route can **participate in the
Saga** and declare their compensating actions.

    from("direct:newOrder")
      .saga()
      .propagation(SagaPropagation.MANDATORY)
      .compensation("direct:cancelOrder")
        .transform().header(Exchange.SAGA_LONG_RUNNING_ACTION)
        .bean(orderManagerService, "newOrder")
        .log("Order ${body} created");

Here the propagation mode is set to `MANDATORY` meaning that any
exchange flowing in this route must be already part of a saga. And it is
the case in this example, since the saga is created in the `direct:buy`
route.

The `direct:newOrder` route declares a compensating action called
`direct:cancelOrder`, responsible for undoing the order in case the saga
is canceled.

Each exchange always contains a `Exchange.SAGA_LONG_RUNNING_ACTION`
header that here is used as id of the order. This is done to identify
the order to delete in the corresponding compensating action, but it is
not a requirement (options can be used as an alternative solution).

The compensating action of `direct:newOrder` is `direct:cancelOrder`,
and it’s shown below:

    from("direct:cancelOrder")
      .transform().header(Exchange.SAGA_LONG_RUNNING_ACTION)
      .bean(orderManagerService, "cancelOrder")
      .log("Order ${body} cancelled");

It is called automatically by the Saga EIP implementation when the order
should be canceled.

It should not terminate with error. In case an error is thrown in the
`direct:cancelOrder` route, the EIP implementation should periodically
retry to execute the compensating action up to a certain limit. This
means that **any compensating action must be idempotent**, so it should
take into account that it may be triggered multiple times and should not
fail in any case.

If compensation cannot be done after all retries, a manual intervention
process should be triggered by the Saga implementation.

It may happen that due to a delay in the execution of the
`direct:newOrder` route the Saga is canceled by another party in the
meantime. For instance, due to an error in a parallel route or a timeout
at Saga level.

So, when the compensating action `direct:cancelOrder` is called, it may
not find the Order record that should be canceled. It is important to
guarantee full global consistency, so that **any main action and its
corresponding compensating action are commutative**, i.e., if
compensation occurs before the main action, it should have the same
effect.

Another possible approach, when using a commutative behavior is not
possible, is to consistently fail in the compensating action until data
produced by the main action is found (or the maximum number of retries
is exhausted): this approach may work in many contexts, but it’s
**heuristic**.

The credit service may be implemented almost in the same way as the
order service.

    // action
    from("direct:reserveCredit")
      .saga()
      .propagation(SagaPropagation.MANDATORY)
      .compensation("direct:refundCredit")
        .transform().header(Exchange.SAGA_LONG_RUNNING_ACTION)
        .bean(creditService, "reserveCredit")
        .log("Credit ${header.amount} reserved in action ${body}");
    
    // compensation
    from("direct:refundCredit")
      .transform().header(Exchange.SAGA_LONG_RUNNING_ACTION)
      .bean(creditService, "refundCredit")
      .log("Credit for action ${body} refunded");

Here the compensating action for a credit reservation is a refund.

This completes the example. It can be run with both implementations of
the Saga EIP, as it does not involve remote endpoints.

Further, options will be shown next.

## Handling Completion Events

It is often required to do some processing when the Saga is completed.
Compensation endpoints are invoked when something wrong happens and the
Saga is canceled. Equivalently, **completion endpoints** can be invoked
to do further processing when the Saga is completed successfully.

For example, in the order service above, we may need to know when the
order is completed (and the credit reserved) to actually start preparing
the order. We will not want to start to prepare the order if the payment
is not done (unlike most modern CPUs that give you access to reserved
memory before ensuring that you have rights to read it).

This can be done easily with a modified version of the `direct:newOrder`
endpoint:

    from("direct:newOrder")
      .saga()
      .propagation(SagaPropagation.MANDATORY)
      .compensation("direct:cancelOrder")
      .completion("direct:completeOrder") // completion endpoint
        .transform().header(Exchange.SAGA_LONG_RUNNING_ACTION)
        .bean(orderManagerService, "newOrder")
        .log("Order ${body} created");
    
    // direct:cancelOrder is the same as in the previous example
    
    // called on successful completion
    from("direct:completeOrder")
      .transform().header(Exchange.SAGA_LONG_RUNNING_ACTION)
      .bean(orderManagerService, "findExternalId")
      .to("jms:prepareOrder")
      .log("Order ${body} sent for preparation");

When the Saga is completed, the order is sent to a JMS queue for
preparation.

Like compensating actions, also completion actions may be called
multiple times by the Saga coordinator. Especially in case of errors,
like network errors. In this example, the service listening to the
`prepareOrder` JMS queue should be prepared to hold possible duplicates.

Check the Idempotent Consumer EIP for examples on how to handle
duplicates.

## Using Custom Identifiers and Options

The example shown so far uses the `Exchange.SAGA_LONG_RUNNING_ACTION` as
identifier for the resources `order` and `credit`. This is not always a
desired approach, as it may pollute the business logic and the data
model.

An alternative approach is to use Saga options to "register" custom
identifiers. For example, the credit service may be refactored as
follows:

    // action
    from("direct:reserveCredit")
      .bean(idService, "generateCustomId") // generate a custom ID and set it in the body
      .to("direct:creditReservation")
    
    // delegate action
    from("direct:creditReservation")
      .saga()
      .propagation(SagaPropagation.SUPPORTS)
      .option("CreditId", body()) // mark the current body as needed in the compensating action
      .compensation("direct:creditRefund")
        .bean(creditService, "reserveCredit")
        .log("Credit ${header.amount} reserved. Custom Id used is ${body}");
    
    // called only if the saga is canceled
    from("direct:creditRefund")
      .transform(header("CreditId")) // retrieve the CreditId option from headers
      .bean(creditService, "refundCredit")
      .log("Credit for Custom Id ${body} refunded");

**Note how the previous listing is not using the
`Exchange.SAGA_LONG_RUNNING_ACTION` header at all.**

Since the `direct:creditReservation` endpoint can be now called also
from outside a Saga, the propagation mode can be set to `SUPPORTS`.

Multiple options\* can be declared in a Saga route.

## Setting Timeouts

Sagas are long-running actions, but this does not mean that they should
not have a bounded timeframe to execute. **Setting timeouts on Sagas is
always a good practice** as it guarantees that a Saga does not remain
stuck forever in the case of machine failure.

The Saga EIP implementation may have a default timeout set on all Sagas
that don’t specify it explicitly

When the timeout expires, the Saga EIP will decide to **cancel the
Saga** (and compensate all participants), unless a different decision
has been taken before.

Timeouts can be set on Saga participants as follows:

    from("direct:newOrder")
      .saga()
      .timeout(1, TimeUnit.MINUTES) // newOrder requires that the saga is completed within 1 minute
      .propagation(SagaPropagation.MANDATORY)
      .compensation("direct:cancelOrder")
      .completion("direct:completeOrder")
        // ...
        .log("Order ${body} created");

All participants, e.g., credit service, order service, can set their own
timeout. When a participant joins an existing transaction, the timeout
of the already active saga can be influenced. It should calculate the
moment in time the saga would become eligible for cancellation based on
the time which the request enters the method and the timeout. When this
moment is earlier than the moment calculated for the saga at that time,
this new moment becomes the timeout moment for the saga. So when
multiple participants define a timeout period, the earliest one will
trigger the cancellation of the saga.

A timeout can also be specified at saga level as follows:

    from("direct:buy")
      .saga()
      .timeout(5, TimeUnit.MINUTES) // timeout at saga level
        .to("direct:newOrder")
        .to("direct:reserveCredit");

## Choosing Propagation

In the examples above, we have used the `MANDATORY` and `SUPPORTS`
propagation modes, but also the `REQUIRED` propagation mode, that is the
default propagation used when nothing else is specified.

These propagation modes map 1:1 the equivalent modes used in
transactional contexts. Here’s a summary of their meaning:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Propagation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>REQUIRED</code></p></td>
<td style="text-align: left;"><p>Join the existing saga or create a new
one if it does not exist.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>REQUIRES_NEW</code></p></td>
<td style="text-align: left;"><p>Always create a new saga. Suspend the
old saga and resume it when the new one terminates.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>MANDATORY</code></p></td>
<td style="text-align: left;"><p>A saga must be already present. The
existing saga is joined.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>SUPPORTS</code></p></td>
<td style="text-align: left;"><p>If a saga already exists, then join
it.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>NOT_SUPPORTED</code></p></td>
<td style="text-align: left;"><p>If a saga already exists, it is
suspended and resumed when the current block completes.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>NEVER</code></p></td>
<td style="text-align: left;"><p>The current block must never be invoked
within a saga.</p></td>
</tr>
</tbody>
</table>

## Using Manual Completion (Advanced)

When a Saga cannot be all executed in a synchronous way, but it requires
e.g. communication with external services using asynchronous
communication channels, the completion mode cannot be set to `AUTO`
(default). That is because the saga is not completed when the exchange
that creates it is done.

This is often the case for Sagas that have long execution times (hours,
days). In these cases, the `MANUAL` completion mode should be used.

    from("direct:mysaga")
      .saga()
      .completionMode(SagaCompletionMode.MANUAL)
      .completion("direct:finalize")
      .timeout(2, TimeUnit.HOURS)
        .to("seda:newOrder")
        .to("seda:reserveCredit");
    
    // Put here asynchronous processing for seda:newOrder and seda:reserveCredit
    // They will send asynchronous callbacks to seda:operationCompleted
    
    from("seda:operationCompleted") // an asynchronous callback
      .saga()
      .propagation(SagaPropagation.MANDATORY)
        .bean(controlService, "actionExecuted")
        .choice()
          .when(body().isEqualTo("ok"))
            .to("saga:complete") // complete the current saga manually (saga component)
        .end()
    
    // You can put here the direct:finalize endpoint to execute final actions

Setting the completion mode to `MANUAL` means that the saga is not
completed when the exchange is processed in the route `direct:mysaga`
but it will last longer (max duration is set to 2 hours).

When both asynchronous actions are completed, the saga is completed. The
call to complete is done using the Camel Saga Component’s
`saga:complete` endpoint. There is a similar endpoint for manually
compensating the Saga (`saga:compensate`).

Apparently, the addition of the saga markers adds little value to the
flow: it works also if you remove all Saga EIP configuration. But Sagas
add a lot of value, since they guarantee that even in the presence of
unexpected issues (servers crashing, messages are lost, etc.) there will
always be a consistent outcome: order placed and credit reserved, or
none of them changed. In particular, if the Saga is not completed within
2 hours, the compensation mechanism will take care of fixing the status.

# Using Saga with XML DSL

Saga features are also available for users that want to use the XML DSL.

The following snippet shows an example:

    <route>
      <from uri="direct:start"/>
      <saga>
        <compensation uri="direct:compensation" />
        <completion uri="direct:completion" />
        <option optionName="myOptionKey">
          <constant>myOptionValue</constant>
        </option>
        <option optionName="myOptionKey2">
          <constant>myOptionValue2</constant>
        </option>
      </saga>
      <to uri="direct:action1" />
      <to uri="direct:action2" />
    </route>
