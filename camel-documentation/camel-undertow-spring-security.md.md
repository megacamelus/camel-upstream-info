# Undertow-spring-security.md

**Since Camel 3.3**

**OSGi is not supported**

The Spring Security Provider provides Spring Security (5.x) token bearer
security over the camel-undertow component. To force camel-undertow to
use spring security provider:

-   Add the spring security provider library on classpath.

-   Provide instance of SpringSecurityConfiguration as
    `securityConfiguration` parameter into the camel-undertow component
    or provide both `securityConfiguration` and `securityProvider` into
    camel-undertow component.

-   Configure spring-security.

Configuration has to provide the following security attribute:

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: left;"><p>Name</p></td>
<td style="text-align: left;"><p>Description</p></td>
<td style="text-align: left;"><p>Type</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><strong>securityFiler</strong></p></td>
<td style="text-align: left;"><p>Provides security filter gained from
configured spring security (5.x). Filter could be obtained, for example,
from DelegatingFilterProxyRegistrationBean.</p></td>
<td style="text-align: left;"><p>Filter</p></td>
</tr>
</tbody>
</table>

Each exchange created by Undertow endpoint with spring security contains
header *SpringSecurityProvider\_principal* ( name of header is provided
as a constant `SpringSecurityProvider.PRINCIPAL_NAME_HEADER`) with
current authorized identity as value or header is not present in case of
rejected requests.
