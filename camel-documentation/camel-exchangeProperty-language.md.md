# ExchangeProperty-language.md

**Since Camel 2.0**

The ExchangeProperty Expression Language allows you to extract values of
named exchange properties.

# Exchange Property Options

# Example

The `recipientList` EIP can utilize a exchangeProperty like:

    <route>
      <from uri="direct:a" />
      <recipientList>
        <exchangeProperty>myProperty</exchangeProperty>
      </recipientList>
    </route>

In this case, the list of recipients are contained in the property
*myProperty*.

And the same example in Java DSL:

    from("direct:a").recipientList(exchangeProperty("myProperty"));

# Dependencies

The ExchangeProperty language is part of **camel-core**.
