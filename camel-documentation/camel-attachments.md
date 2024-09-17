# Attachments.md

**Since Camel 3.0**

The Attachments component provides the `javax.attachments` API support
for Apache Camel. A few Camel component uses attachments such as mail
and web-service components. The Attachments component is included
automatically when using these components.

The Attachments support is on Camel `Message` level, for example to get
the `javax.activation.DataHandler` instance of the attachment, you can
do as shown below:

    AttachmentMessage attMsg = exchange.getIn(AttachmentMessage.class);
    Attachment attachment = attMsg.getAttachmentObject("myAttachment");
    DataHandler dh = attachment.getDataHandler();

And if you want to add an attachment, to a Camel `Message` you can do as
shown:

    AttachmentMessage attMsg = exchange.getIn(AttachmentMessage.class);
    attMsg.addAttachment("message1.xml", new DataHandler(new FileDataSource(new File("myMessage1.xml"))));
