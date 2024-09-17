# Elytron.md

**Since Camel 3.1**

The Elytron Security Provider provides Elytron security over the Camel
Elytron component. It enables the Camel Elytron component to use Elytron
security capabilities. To force Camel Elytron to use elytron security
provider, add the elytron security provider library on classpath and
provide instance of `ElytronSecurityConfiguration` as
`securityConfiguration` parameter into the Camel Elytron component or
provide both `securityConfiguration` and `securityProvider` into the
Camel Elytron component.

Configuration has to provide all three security attributes:

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 30%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>domainBuilder</strong></p></td>
<td style="text-align: left;"><p>Builder for security domain.</p></td>
<td
style="text-align: center;"><p><code>SecurityDomain.Builder</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><strong>mechanismName</strong></p></td>
<td style="text-align: left;"><p>MechanismName should be selected with
regard to default securityRealm. For example, to use bearer_token
security, mechanism name has to be <code>BEARER_TOKEN</code> and realm
has to be <code>TokenSecurityReal</code></p></td>
<td style="text-align: center;"><p><code>String</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>elytronProvider</strong></p></td>
<td style="text-align: left;"><p>Instance of WildFlyElytronBaseProvider
with respect of mechanismName</p></td>
<td
style="text-align: center;"><p><code>WildFlyElytronBaseProvider</code></p></td>
</tr>
</tbody>
</table>

Each exchange created by Undertow endpoint with Elytron security
contains header `securityIdentity` with current Elytron’s security
identity as value. (`org.wildfly.security.auth.server.SecurityIdentity`)
or is *FORBIDDEN* (status code 403)

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-elytron</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Other Elytron capabilities

This security provider contains only basic Elytron dependencies (without
any transitive dependency from `org.wildfly.security:wildfly-elytron`).
Ignored libraries should be added among application’s dependencies for
their usage.
