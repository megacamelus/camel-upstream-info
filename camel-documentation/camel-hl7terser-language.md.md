# Hl7terser-language.md

**Since Camel 2.11**

[HAPI](https://hapifhir.github.io/hapi-hl7v2/) provides a
[Terser](https://hapifhir.github.io/hapi-hl7v2/base/apidocs/ca/uhn/hl7v2/util/Terser.html)
class that provides access to fields using a commonly used terse
location specification syntax. The HL7 Terser language allows using this
syntax to extract values from HL7 messages and to use them as
expressions and predicates for filtering, content-based routing, etc.

# HL7 Terser Language options

# Example

In the example below, we want to set a header with the patent id from
field QRD-8 in the QRY\_A19 message:

    import static org.apache.camel.component.hl7.HL7.hl7terser;
    
    // extract patient ID from field QRD-8 in the QRY_A19 message above and put into message header
    from("direct:test1")
       .setHeader("PATIENT_ID", hl7terser("QRD-8(0)-1"))
       .to("mock:test1");
    
    // continue processing if extracted field equals a message header
    from("direct:test2")
       .filter(hl7terser("QRD-8(0)-1").isEqualTo(header("PATIENT_ID"))
       .to("mock:test2");

# HL7 Validation

Often it is preferable to first parse a HL7v2 message and in a separate
step validate it against a HAPI
[ValidationContext](https://hapifhir.github.io/hapi-hl7v2/base/apidocs/ca/uhn/hl7v2/validation/ValidationContext.html).

The example below shows how to do that. Notice how we use the static
method `messageConformsTo` which validates that the message is a HL7v2
message.

    import static org.apache.camel.component.hl7.HL7.messageConformsTo;
    import ca.uhn.hl7v2.validation.impl.DefaultValidation;
    
    // Use standard or define your own validation rules
    ValidationContext defaultContext = new DefaultValidation();
    
    // Throws PredicateValidationException if a message does not validate
    from("direct:test1")
       .validate(messageConformsTo(defaultContext))
       .to("mock:test1");

## HL7 Validation using the HapiContext

The HAPI Context is always configured with a
[ValidationContext](https://hapifhir.github.io/hapi-hl7v2/base/apidocs/ca/uhn/hl7v2/validation/ValidationContext.html)
(or a
[ValidationRuleBuilder](https://hapifhir.github.io/hapi-hl7v2/base/apidocs/ca/uhn/hl7v2/validation/builder/ValidationRuleBuilder.html)),
so you can access the validation rules indirectly.

Furthermore, when unmarshalling the HL7 data format forwards the
configured HAPI context in the `CamelHL7Context` header, and the
validation rules of this context can be reused:

    import static org.apache.camel.component.hl7.HL7.messageConformsTo;
    import static org.apache.camel.component.hl7.HL7.messageConforms;
    
    HapiContext hapiContext = new DefaultHapiContext();
    hapiContext.getParserConfiguration().setValidating(false); // don't validate during parsing
    
    // customize HapiContext some more ... e.g., enforce that PID-8 in ADT_A01 messages of version 2.4 is not empty
    ValidationRuleBuilder builder = new ValidationRuleBuilder() {
       @Override
       protected void configure() {
          forVersion(Version.V24)
             .message("ADT", "A01")
             .terser("PID-8", not(empty()));
       }
    };
    hapiContext.setValidationRuleBuilder(builder);
    
    HL7DataFormat hl7 = new HL7DataFormat();
    hl7.setHapiContext(hapiContext);
    
    from("direct:test1")
      .unmarshal(hl7)                // uses the GenericParser returned from the HapiContext
      .validate(messageConforms())   // uses the validation rules returned from the HapiContext
                                     // equivalent with .validate(messageConformsTo(hapiContext))
       // route continues from here

# HL7 Acknowledgement expression

A common task in HL7v2 processing is to generate an acknowledgement
message as a response to an incoming HL7v2 message, e.g., based on a
validation result. The `ack` expression lets us accomplish this very
elegantly:

    import static org.apache.camel.component.hl7.HL7.messageConformsTo;
    import static org.apache.camel.component.hl7.HL7.ack;
    import ca.uhn.hl7v2.validation.impl.DefaultValidation;
    
    // Use standard or define your own validation rules
    ValidationContext defaultContext = new DefaultValidation();
    
    from("direct:test1")
       .onException(Exception.class)
          .handled(true)
          .transform(ack()) // auto-generates negative ack because of exception in Exchange
          .end()
       .validate(messageConformsTo(defaultContext))
       // do something meaningful here
    
       // acknowledgement
      .transform(ack())

## Custom Acknowledgement for MLLP

In special situations, you may want to set a custom acknowledgement
without using Exceptions. This can be achieved using the `ack`
expression:

    import org.apache.camel.component.mllp.MllpConstants;
    import ca.uhn.hl7v2.AcknowledgmentCode;
    import ca.uhn.hl7v2.ErrorCode;
    
    // In process block
    exchange.setProperty(MllpConstants.MLLP_ACKNOWLEDGEMENT,
      ack(AcknowledgmentCode.AR, "Server didn't accept this message", ErrorCode.UNKNOWN_KEY_IDENTIFIER).evaluate(exchange, Object.class)
