# Jasypt.md

**Since Camel 2.5**

[Jasypt](http://www.jasypt.org/) is a simplified encryption library that
makes encryption and decryption easy. Camel integrates with Jasypt to
allow sensitive information in
[Properties](#ROOT:properties-component.adoc) files to be encrypted. By
dropping **`camel-jasypt`** on the classpath those encrypted values will
automatically be decrypted on-the-fly by Camel. This ensures that human
eyes can’t easily spot sensitive information such as usernames and
passwords.

If you are using Maven, you need to add the following dependency to your
`pom.xml` for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jasypt</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Tooling

The Jasypt component is a runnable JAR that provides a command line
utility to encrypt or decrypt values.

The usage documentation can be output to the console to describe the
syntax and options it provides:

    Apache Camel Jasypt takes the following options
    
      -h or -help = Displays the help screen
      -c or -command <command> = Command either encrypt or decrypt
      -p or -password <password> = Password to use
      -i or -input <input> = Text to encrypt or decrypt
      -a or -algorithm <algorithm> = Optional algorithm to use
      -rsga or -algorithm <algorithm> = Optional random salt generator algorithm to use
      -riga or -algorithm <algorithm> = Optional random iv generator algorithm to use

A simple way of running the tool is with
[JBang](https://www.jbang.dev/).

For example, to encrypt the value `tiger`, you can use the following
parameters. Make sure to specify the version of camel-jasypt that you
want to use.

    $ jbang org.apache.camel:camel-jasypt:<camel version here> -c encrypt -p secret -i tiger

Which outputs the following result

    Encrypted text: qaEEacuW7BUti8LcMgyjKw==

This means the encrypted representation `qaEEacuW7BUti8LcMgyjKw==` can
be decrypted back to `tiger` if you know the *master* password which was
`secret`.  
If you run the tool again, then the encrypted value will return a
different result. But decrypting the value will always return the
correct original value.

You can test decrypting the value by running the tooling using the
following parameters:

    $ jbang org.apache.camel:camel-jasypt:<camel version here> -c decrypt -p secret -i qaEEacuW7BUti8LcMgyjKw==

Which outputs the following result:

    Decrypted text: tiger

The idea is to then use the encrypted values in your
[Properties](#ROOT:properties-component.adoc) files. For example.

    # Encrypted value for 'tiger'
    my.secret = ENC(qaEEacuW7BUti8LcMgyjKw==)

# Protecting the master password

The *master* password used by Jasypt must be provided, so that it’s
capable of decrypting the values. However, having this *master* password
out in the open may not be an ideal solution. Therefore, you can provide
it as a JVM system property or as an OS environment setting. If you
decide to do so then the `password` option supports prefix that dictates
this:

-   `sysenv:` means to look up the OS system environment with the given
    key.

-   `sys:` means to look up a JVM system property.

For example, you could provide the password before you start the
application

    $ export CAMEL_ENCRYPTION_PASSWORD=secret

Then start the application, such as running the start script.

When the application is up and running, you can unset the environment

    $ unset CAMEL_ENCRYPTION_PASSWORD

On runtimes like Spring Boot and Quarkus, you can configure a password
property in `application.properties` as follows.

    password=sysenv:CAMEL_ENCRYPTION_PASSWORD

Or if configuring `JasyptPropertiesParser` manually, you can set the
password like this.

    jasyptPropertiesParser.setPassword("sysenv:CAMEL_ENCRYPTION_PASSWORD");

# Example configuration

Java  
On the Spring Boot and Quarkus runtimes, Camel Jasypt can be configured
via configuration properties. Refer to their respective documentation
pages for more information.

Else, in Java DSL you need to configure Jasypt as a
`JasyptPropertiesParser` instance and set it on the
[Properties](#ROOT:properties-component.adoc) component as shown below:

    // create the jasypt properties parser
    JasyptPropertiesParser jasypt = new JasyptPropertiesParser();
    // set the master password (see above for how to do this in a secure way)
    jasypt.setPassword("secret");
    
    // create the properties' component
    PropertiesComponent pc = new PropertiesComponent();
    pc.setLocation("classpath:org/apache/camel/component/jasypt/secret.properties");
    // and use the jasypt properties parser, so we can decrypt values
    pc.setPropertiesParser(jasypt);
    // end enable nested placeholder support
    pc.setNestedPlaceholder(true);
    
    // add properties component to camel context
    context.setPropertiesComponent(pc);

It is possible to configure custom algorithms on the
JasyptPropertiesParser like this.

    JasyptPropertiesParser jasyptPropertiesParser = new JasyptPropertiesParser();
    
    jasyptPropertiesParser.setAlgorithm("PBEWithHmacSHA256AndAES_256");
    jasyptPropertiesParser.setRandomSaltGeneratorAlgorithm("PKCS11");
    jasyptPropertiesParser.setRandomIvGeneratorAlgorithm("PKCS11");

The properties file `secret.properties` will contain your encrypted
configuration values, such as shown below. Notice how the password value
is encrypted and is surrounded like `ENC(value here)`.

    my.secret.password=ENC(bsW9uV37gQ0QHFu7KO03Ww==)

XML (Spring)  
In Spring XML you need to configure the `JasyptPropertiesParser` which
is shown below. Then the Camel
[Properties](#ROOT:properties-component.adoc) component is told to use
`jasypt` as the property parser, which means Jasypt has its chance to
decrypt values looked up in the properties file.

    <!-- define the jasypt properties parser with the given password to be used -->
    <bean id="jasypt" class="org.apache.camel.component.jasypt.JasyptPropertiesParser">
        <property name="password" value="secret"/>
    </bean>
    
    <!-- define the camel properties component -->
    <bean id="properties" class="org.apache.camel.component.properties.PropertiesComponent">
        <!-- the properties file is in the classpath -->
        <property name="location" value="classpath:org/apache/camel/component/jasypt/secret.properties"/>
        <!-- and let it leverage the jasypt parser -->
        <property name="propertiesParser" ref="jasypt"/>
        <!-- end enable nested placeholder -->
        <property name="nestedPlaceholder" value="true"/>
    </bean>

The [Properties](#ROOT:properties-component.adoc) component can also be
inlined inside the `<camelContext>` tag which is shown below. Notice how
we use the `propertiesParserRef` attribute to refer to Jasypt.

    <!-- define the jasypt properties parser with the given password to be used -->
    <bean id="jasypt" class="org.apache.camel.component.jasypt.JasyptPropertiesParser">
        <!-- password is mandatory, you can prefix it with sysenv: or sys: to indicate it should use
             an OS environment or JVM system property value, so you don't have the master password defined here -->
        <property name="password" value="secret"/>
    </bean>
    
    <camelContext xmlns="http://camel.apache.org/schema/spring">
        <!-- define the camel properties placeholder, and let it leverage jasypt -->
        <propertyPlaceholder id="properties"
                             location="classpath:org/apache/camel/component/jasypt/secret.properties"
                             nestedPlaceholder="true"
                             propertiesParserRef="jasypt"/>
        <route>
            <from uri="direct:start"/>
            <to uri="{{cool.result}}"/>
        </route>
    </camelContext>
