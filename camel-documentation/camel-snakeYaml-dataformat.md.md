# SnakeYaml-dataformat.md

**Since Camel 2.17**

YAML is a Data Format to marshal and unmarshal Java objects to and from
[YAML](http://www.yaml.org/).

For YAML to object marshalling, Camel provides integration with three
popular YAML libraries:

-   The [SnakeYAML](http://www.snakeyaml.org/) library

Every library requires adding the special camel component (see
"Dependency…" paragraphs further down). By default Camel uses the
SnakeYAML library.

# YAML Options

SnakeYAML can load any class from YAML definition which may lead to
security breach so by default, SnakeYAML DataForma restrict the object
it can load to standard Java objects like List or Long. If you want to
load custom POJOs you need to add theirs type to SnakeYAML DataFormat
type filter list. If your source is trusted, you can set the property
allowAnyType to true so SnakeYAML DataForma won’t perform any filter on
the types.

# Using YAML data format with the SnakeYAML library

-   Turn Object messages into yaml then send to MQSeries
    
        from("activemq:My.Queue")
          .marshal().yaml()
          .to("mqseries:Another.Queue");
        
        from("activemq:My.Queue")
          .marshal().yaml(YAMLLibrary.SnakeYAML)
          .to("mqseries:Another.Queue");

-   Restrict classes to be loaded from YAML
    
        // Creat a SnakeYAMLDataFormat instance
        SnakeYAMLDataFormat yaml = new SnakeYAMLDataFormat();
        
        // Restrict classes to be loaded from YAML
        yaml.addTypeFilters(TypeFilters.types(MyPojo.class, MyOtherPojo.class));
        
        from("activemq:My.Queue")
          .unmarshal(yaml)
          .to("mqseries:Another.Queue");

# Using YAML in Spring DSL

When using Data Format in Spring DSL you need to declare the data
formats first. This is done in the **DataFormats** XML tag.

    <dataFormats>
      <!--
        here we define a YAML data format with the id snake and that it should use
        the TestPojo as the class type when doing unmarshal. The unmarshalType
        is optional
      -->
      <yaml
        id="snake"
        library="SnakeYAML"
        unmarshalType="org.apache.camel.component.yaml.model.TestPojo"/>
    
      <!--
        here we define a YAML data format with the id snake-safe which restricts the
        classes to be loaded from YAML to TestPojo and those belonging to package
        com.mycompany
      -->
      <yaml id="snake-safe">
        <typeFilter value="org.apache.camel.component.yaml.model.TestPojo"/>
        <typeFilter value="com.mycompany\..*" type="regexp"/>
      </yaml>
    </dataFormats>

And then you can refer to those ids in the route:

      <route>
        <from uri="direct:unmarshal"/>
        <unmarshal>
          <custom ref="snake"/>
        </unmarshal>
        <to uri="mock:unmarshal"/>
      </route>
      <route>
        <from uri="direct:unmarshal-safe"/>
        <unmarshal>
          <custom ref="snake-safe"/>
        </unmarshal>
        <to uri="mock:unmarshal-safe"/>
      </route>

# Dependencies for SnakeYAML

To use YAML in your camel routes you need to add the a dependency on
**camel-snakeyaml** which implements this data format.

If you use maven you could just add the following to your pom.xml,
substituting the version number for the latest \& greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-snakeyaml</artifactId>
      <version>${camel-version}</version>
    </dependency>
