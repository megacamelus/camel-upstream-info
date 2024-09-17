# Ref-language.md

**Since Camel 2.8**

The Ref Expression Language is really just a way to lookup a custom
`Expression` or `Predicate` from the
[Registry](#manual:ROOT:registry.adoc).

This is particular useable in XML DSLs.

# Ref Language options

# Example usage

The Splitter EIP in XML DSL can utilize a custom expression using
`<ref>` like:

    <bean id="myExpression" class="com.mycompany.MyCustomExpression"/>
    
    <route>
      <from uri="seda:a"/>
      <split>
        <ref>myExpression</ref>
        <to uri="mock:b"/>
      </split>
    </route>

in this case, the message coming from the seda:a endpoint will be split
using a custom `Expression` which has the id `myExpression` in the
[Registry](#manual:ROOT:registry.adoc).

And the same example using Java DSL:

    from("seda:a").split().ref("myExpression").to("seda:b");

# Dependencies

The Ref language is part of **camel-core**.
