# Script-eip.md

The Script EIP is used for executing a coding script.

<figure>
<img src="eip/MessagingGatewayIcon.gif" alt="image" />
</figure>

This is useful when you need to invoke some logic not in Java code such
as JavaScript, Groovy or any of the other Languages.

The returned value from the script is discarded and not used. If the
returned value should be set as the new message body, then use the
[Message Translator](#message-translator.adoc) EIP instead.

# Options

# Exchange properties

# Using Script EIP

The route below will read the file contents and call a groovy script

Java  
from("file:inbox")
.script().groovy("some groovy code goes here")
.to("bean:myServiceBean.processLine");

XML  
<route>  
<from uri="file:inbox"/>  
<script>  
<groovy>some groovy code goes here</groovy>  
</script>  
<to uri="bean:myServiceBean.processLine"/>  
</route>

Mind that you can use *CDATA* if the script uses `< >` etc:

    <route>
      <from uri="file://inbox"/>
      <script>
        <groovy><![CDATA[ some groovy script here that can be multiple lines and whatnot ]]></groovy>
      </script>
      <to uri="bean:myServiceBean.processLine"/>
    </route>

## Scripting Context

The scripting context has access to the current `Exchange` and can
essentially change the message or headers directly.

## Using external script files

You can refer to external script files instead of inlining the script.
For example, to load a groovy script from the classpath, you need to
prefix the value with `resource:` as shown:

    <route>
      <from uri="file:inbox"/>
      <script>
        <groovy>resource:classpath:com/foo/myscript.groovy</groovy>
      </script>
      <to uri="bean:myServiceBean.processLine"/>
    </route>

You can also refer to the script from the file system with `file:`
instead of `classpath:` such as `file:/var/myscript.groovy`
