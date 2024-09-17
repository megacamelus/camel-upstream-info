# FailoverLoadBalancer-eip.md

This EIP allows using fail-over (in case of failures, the exchange will
be tried on the next endpoint) with the [Load
Balancer](#loadBalance-eip.adoc) EIP.

# Options

# Exchange properties

# Example

In the example below, calling the three http services is done with the
load balancer:

Java  
from("direct:start")
.loadBalance().failover()
.to("http:service1")
.to("http:service2")
.to("http:service3")
.end();

XML  
<route>  
<from uri="direct:start"/>  
<loadBalance>  
<failoverLoadBalancer/>  
<to uri="http:service1"/>  
<to uri="http:service2"/>  
<to uri="http:service3"/>  
</loadBalance>  
</route>

In the default mode, the fail-over load balancer will always start with
the first processor (i.e., "http:service1"). And in case this fails,
then try the next, until either it succeeded or all of them failed. If
all failed, then Camel will throw the caused exception which means the
Exchange is failed.

## Using round-robin mode

You can use the `roundRobin` mode to start again from the beginning,
which then will keep trying until one succeed. To prevent endless
retries, then it’s recommended to set a maximum fail-over value.

Setting this in Java DSL is not *pretty* as there are three parameters:

    from("direct:start")
        .loadBalance().failover(10, false, true)
            .to("http:service1")
            .to("http:service2")
            .to("http:service3")
        .end();
    
    .failover(10, false, true)

Where `10` is the maximum fail over attempts, And `false` is a special
feature related to inheriting error handler. The last parameter `true`
is to use round-robin mode.

In XML, it is straightforward as shown:

    <route>
        <from uri="direct:start"/>
        <loadBalance>
            <failoverLoadBalancer roundRobin="true" maximumFailoverAttempts="10"/>
            <to uri="http:service1"/>
            <to uri="http:service2"/>
            <to uri="http:service3"/>
        </loadBalance>
    </route>

## Using sticky mode

The sticky mode is used for remember the last known good endpoint, so
the next exchange will start from there, instead from the beginning.

For example, support that http:service1 is down, and that service2 is
up. With sticky mode enabled, then Camel will keep starting from
service2 until it fails, and then try service3.

If sticky mode is not enabled (it’s disabled by default), then Camel
will always start from the beginning, which means calling service1.

Java  
Setting sticky mode in Java DSL is not *pretty* as there are four
parameters.

    from("direct:start")
        .loadBalance().failover(10, false, true, true)
            .to("http:service1")
            .to("http:service2")
            .to("http:service3")
        .end();

The last `true` argument is to enable sticky mode.

XML  
<route>  
<from uri="direct:start"/>  
<loadBalance>  
<failoverLoadBalancer roundRobin="true" maximumFailoverAttempts="10" stickyMode="true"/>  
<to uri="http:service1"/>  
<to uri="http:service2"/>  
<to uri="http:service3"/>  
</loadBalance>  
</route>

## Fail-over on specific exceptions

The fail-over load balancer can be configured to only apply for a
specific set of exceptions. Suppose you only want to fail-over in case
of `java.io.Exception` or `HttpOperationFailedException` then you can
do:

    from("direct:start")
        .loadBalance().failover(IOException.class, HttpOperationFailedException.class)
            .to("http:service1")
            .to("http:service2")
            .to("http:service3")
        .end();

And in XML DSL:

    <route>
        <from uri="direct:start"/>
        <loadBalance>
            <failoverLoadBalancer>
                <exception>java.io.IOException</exception>
                <exception>org.apache.camel.http.base.HttpOperationFailedException</exception>
            </failoverLoadBalancer>
            <to uri="http:service1"/>
            <to uri="http:service2"/>
            <to uri="http:service3"/>
        </loadBalance>
    </route>
