# Rollback-eip.md

The Rollback EIP is used for marking an
[Exchange](#manual::exchange.adoc) to rollback and stop continue routing
the message.

# Options

# Exchange properties

# Using Rollback

We want to test a message for some conditions and force a rollback if a
message may be faulty.

In Java DSL we can do:

Java  
from("direct:start")
.choice().when(body().contains("error"))
.rollback("That do not work")
.otherwise()
.to("direct:continue");

XML  
<route>  
<from uri="direct:start"/>  
<choice>  
<when>  
<simple>${body} contains 'error'</simple>  
<rollback message="That do not work"/>  
</when>  
<otherwise>  
<to uri="direct:continue"/>  
</otherwise>  
</choice>  
</route>

When Camel is rolling back, then a `RollbackExchangeException` is thrown
with the cause message `_"That do not work"_`.

## Marking for Rollback only

When a message is rolled back, then Camel will by default throw a
`RollbackExchangeException` to cause the message to fail and rollback.

This behavior can be modified to only mark for rollback, and not throw
the exception.

Java  
from("direct:start")
.choice().when(body().contains("error"))
.markRollbackOnly()
.otherwise()
.to("direct:continue");

XML  
<route>  
<from uri="direct:start"/>  
<choice>  
<when>  
<simple>${body} contains 'error'</simple>  
<rollback markRollbackOnly="true"/>  
</when>  
<otherwise>  
<to uri="direct:continue"/>  
</otherwise>  
</choice>  
</route>

Then no exception is thrown, but the message is marked to rollback and
stopped routing.

## Using Rollback with Transactions

Rollback can be used together with
[transactions](#transactional-client.adoc). For more details, see
[Transaction Client](#transactional-client.adoc) EIP.
