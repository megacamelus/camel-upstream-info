# Ical-dataformat.md

**Since Camel 2.12**

The ICal dataformat is used for working with
[iCalendar](http://en.wikipedia.org/wiki/ICalendar) messages.

A typical iCalendar message looks like:

    BEGIN:VCALENDAR
    VERSION:2.0
    PRODID:-//Events Calendar//iCal4j 1.0//EN
    CALSCALE:GREGORIAN
    BEGIN:VEVENT
    DTSTAMP:20130324T180000Z
    DTSTART:20130401T170000
    DTEND:20130401T210000
    SUMMARY:Progress Meeting
    TZID:America/New_York
    UID:00000000
    ATTENDEE;ROLE=REQ-PARTICIPANT;CN=Developer 1:mailto:dev1@mycompany.com
    ATTENDEE;ROLE=OPT-PARTICIPANT;CN=Developer 2:mailto:dev2@mycompany.com
    END:VEVENT
    END:VCALENDAR

# Options

# Basic Usage

To unmarshal and marshal the message shown above, your route will look
like the following:

    from("direct:ical-unmarshal")
      .unmarshal("ical")
      .to("mock:unmarshaled")
      .marshal("ical")
      .to("mock:marshaled");

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-ical</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>
