# Sample-eip.md

A sampling throttler allows you to extract a sample of the exchanges
from the traffic through a route.

<figure>
<img src="eip/WireTap.gif" alt="image" />
</figure>

The Sample EIP works similar to a wire tap, but instead of tapping every
message, the sampling will select a single message in a given time
period. This selected message is allowed to pass through, and all other
messages are stopped.

# Options

# Exchange properties

# Using Sample EIP

In the example below, we sample one message per second (default time
period):

Java  
from("direct:sample")
.sample()
.to("direct:sampled");

XML  
<route>  
<from uri="direct:sample"/>  
<sample>  
<to uri="direct:sampled"/>  
</sample>  
</route>

## Sampling using time period

The default time period is 1 second, but this can easily be configured.
For example, to sample one message per 5 seconds, you can do:

Java  
from("direct:sample")
.sample(5, TimeUnit.SECONDS)
.to("direct:sampled");

XML  
<route>  
<from uri="direct:sample"/>  
<sample samplePeriod="5000">  
<to uri="direct:sampled"/>  
</sample>  
</route>

## Sampling using message frequency

The Sample EIP can also be configured to sample based on frequency
instead of a time period.

For example, to sample every 10th message you can do:

Java  
from("direct:sample")
.sample(10)
.to("direct:sampled");

XML  
<route>  
<from uri="direct:sample"/>  
<sample messageFrequency="10">  
<to uri="direct:sampled"/>  
</sample>  
</route>
