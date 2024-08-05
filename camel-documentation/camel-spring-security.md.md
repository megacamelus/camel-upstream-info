# Spring-security.md

**Since Camel 2.3**

The Camel Spring Security component provides role-based authorization
for Camel routes. It leverages the authentication and user services
provided by [Spring
Security](https://spring.io/projects/spring-security) (formerly Acegi
Security), and adds a declarative, role-based policy system to control
whether a route can be executed by a given principal.

If you are not familiar with the Spring Security authentication and
authorization system, please review the current reference documentation
on the SpringSource website linked above.

# Creating authorization policies

Access to a route is controlled by an instance of a
`SpringSecurityAuthorizationPolicy` object. A policy object contains the
name of the Spring Security authority (role) required to run a set of
endpoints and references to Spring Security `AuthenticationManager` and
`AuthorizationManager` objects used to determine whether the current
principal is authorized. Policy objects may be configured as Spring
beans or by using an `<authorizationPolicy>` element in Spring XML.

The `<authorizationPolicy>` element may contain the following
attributes:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Default Value</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>id</code></p></td>
<td style="text-align: left;"><p><code>null</code></p></td>
<td style="text-align: left;"><p>The unique Spring bean identifier which
is used to reference the policy in routes (required)</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>authenticationManager</code></p></td>
<td
style="text-align: left;"><p><code>authenticationManager</code></p></td>
<td style="text-align: left;"><p>The name of the Spring Security
<code>AuthenticationManager</code> object in the context</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>authorizationManager</code></p></td>
<td
style="text-align: left;"><p><code>authorizationManager</code></p></td>
<td style="text-align: left;"><p>The name of the Spring Security
<code>AuthorizationManager</code> object in the context</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>authenticationAdapter</code></p></td>
<td style="text-align: left;"><p>DefaultAuthenticationAdapter</p></td>
<td style="text-align: left;"><p>The name of a
<strong>camel-spring-security</strong>
<code>AuthenticationAdapter</code> object in the context that is used to
convert a <code>javax.security.auth.Subject</code> into a Spring
Security <code>Authentication</code> instance.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>useThreadSecurityContext</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>If a
<code>javax.security.auth.Subject</code> cannot be found in the In
message header under <code>Exchange.AUTHENTICATION</code>, check the
Spring Security <code>SecurityContextHolder</code> for an
<code>Authentication</code> object.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>alwaysReauthenticate</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>If set to true, the
<code>SpringSecurityAuthorizationPolicy</code> will always call
<code>AuthenticationManager.authenticate()</code> each time the policy
is accessed.</p></td>
</tr>
</tbody>
</table>

# Controlling access to Camel routes

A Spring Security `AuthenticationManager` and `AuthorizationManager` are
required to use this component. Here is an example of how to configure
these objects in Spring XML using the Spring Security namespace:

    <beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:spring-security="http://www.springframework.org/schema/security"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/security http://www.springframework.org/schema/security/spring-security.xsd">
    
        <bean id="authorizationManager" class=" org.springframework.security.authorization.AuthorityAuthorizationManager">
            <constructor-arg name="authorities" value="ROLE_ADMIN"/>
        </bean>
    
       <spring-security:authentication-manager alias="authenticationManager">
          <spring-security:authentication-provider user-service-ref="userDetailsService"/>
       </spring-security:authentication-manager>
    
       <spring-security:user-service id="userDetailsService">
          <spring-security:user name="jim" password="jimspassword" authorities="ROLE_USER, ROLE_ADMIN"/>
          <spring-security:user name="bob" password="bobspassword" authorities="ROLE_USER"/>
       </spring-security:user-service>
    
    </beans>

Now that the underlying security objects are set up, we can use them to
configure an authorization policy and use that policy to control access
to a route:

    <beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:spring-security="http://www.springframework.org/schema/security"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
        http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd
        http://camel.apache.org/schema/spring-security http://camel.apache.org/schema/spring-security/camel-spring-security.xsd
        http://www.springframework.org/schema/security http://www.springframework.org/schema/security/spring-security.xsd">
    
        <!-- import the Spring security configuration  -->
        <import resource= "classpath:org/apache/camel/component/spring/security/commonSecurity.xml"/>
    
        <authorizationPolicy id="admin"
          authorizationManager="authorizationManager"
          authenticationManager="authenticationManager"
          xmlns="http://camel.apache.org/schema/spring-security "/>
    
        <camelContext id="myCamelContext" xmlns="http://camel.apache.org/schema/spring">
          <route>
             <from uri="direct:start"/>
             <!-- The exchange should be authenticated with the role -->
             <!-- of ADMIN before it is sent to mock:endpoint -->
             <policy ref="admin">
                <to uri="mock:end"/>
             </policy>
          </route>
        </camelContext>
    </beans>

In this example, the endpoint `mock:end` will not be executed unless a
Spring Security `Authentication` object that has been or can be
authenticated and contains the `ROLE_ADMIN` authority can be located by
the *admin* `SpringSecurityAuthorizationPolicy`.

# Authentication

This component does not specify the process of obtaining security
credentials that are used for authorization. You can write your own
processors or components which get authentication information from the
exchange depending on your needs. For example, you might create a
processor that gets credentials from an HTTP request header originating
in the [Jetty](#ROOT:jetty-component.adoc) component. No matter how the
credentials are collected, they need to be placed in the In message or
the `SecurityContextHolder` so the Camel [Spring
Security](#spring-security.adoc) component can access them:

    import javax.security.auth.Subject;
    import org.apache.camel.*;
    import org.apache.commons.codec.binary.Base64;
    import org.springframework.security.authentication.*;
    
    
    public class MyAuthService implements Processor {
        public void process(Exchange exchange) throws Exception {
            // get the username and password from the HTTP header
            // https://en.wikipedia.org/wiki/Basic_access_authentication
            String userpass = new String(Base64.decodeBase64(exchange.getIn().getHeader("Authorization", String.class)));
            String[] tokens = userpass.split(":");
    
            // create an Authentication object
            UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(tokens[0], tokens[1]);
    
            // wrap it in a Subject
            Subject subject = new Subject();
            subject.getPrincipals().add(authToken);
    
            // place the Subject in the In message
            exchange.getIn().setHeader(Exchange.AUTHENTICATION, subject);
    
            // you could also do this if useThreadSecurityContext is set to true
            // SecurityContextHolder.getContext().setAuthentication(authToken);
        }
    }

The `SpringSecurityAuthorizationPolicy` will automatically authenticate
the `Authentication` object if necessary.

There are two issues to be aware of when using the
`SecurityContextHolder` instead of or in addition to the
`Exchange.AUTHENTICATION` header. First, the context holder uses a
thread-local variable to hold the `Authentication` object. Any routes
that cross thread boundaries, like **seda** or **jms**, will lose the
`Authentication` object. Second, the Spring Security system appears to
expect that an `Authentication` object in the context is already
authenticated and has roles (see the Technical Overview [section
5\.3.1](http://static.springsource.org/spring-security/site/docs/3.0.x/reference/technical-overview.html#tech-intro-authentication)
for more details).

The default behavior of **camel-spring-security** is to look for a
`Subject` in the `Exchange.AUTHENTICATION` header. This `Subject` must
contain at least one principal, which must be a subclass of
`org.springframework.security.core.Authentication`. You can customize
the mapping of `Subject` to `Authentication` object by providing an
implementation of the
`org.apache.camel.component.spring.security.AuthenticationAdapter` to
your `<authorizationPolicy>` bean. This can be useful if you are working
with components that do not use Spring Security but do provide a
`Subject`. At this time, only the [CXF](#ROOT:cxf-component.adoc)
component populates the `Exchange.AUTHENTICATION` header.

# Handling authentication and authorization errors

If authentication or authorization fails in the
`SpringSecurityAuthorizationPolicy`, a `CamelAuthorizationException`
will be thrown. This can be handled using Camel’s standard exception
handling methods, like the Exception Clause. The
`CamelAuthorizationException` will have a reference to the ID of the
policy which threw the exception, so you can handle errors based on the
policy as well as the type of exception:

    <onException>
      <exception>org.springframework.security.authentication.AccessDeniedException</exception>
      <choice>
        <when>
          <simple>${exception.policyId} == 'user'</simple>
          <transform>
            <constant>You do not have ROLE_USER access!</constant>
          </transform>
        </when>
        <when>
          <simple>${exception.policyId} == 'admin'</simple>
          <transform>
            <constant>You do not have ROLE_ADMIN access!</constant>
          </transform>
        </when>
      </choice>
    </onException>
