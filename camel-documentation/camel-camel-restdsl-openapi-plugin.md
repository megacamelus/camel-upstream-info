# Camel-restdsl-openapi-plugin.md

The Camel REST DSL OpenApi Maven Plugin supports the following goals

-   camel-restdsl-openapi:generate - To generate consumer REST DSL
    RouteBuilder source code from OpenApi specification

-   camel-restdsl-openapi:generate-with-dto - To generate consumer REST
    DSL RouteBuilder source code from OpenApi specification and with DTO
    model classes generated via the swagger-codegen-maven-plugin.

-   camel-restdsl-openapi:generate-xml - To generate consumer REST DSL
    XML source code from OpenApi specification

-   camel-restdsl-openapi:generate-xml-with-dto - To generate consumer
    REST DSL XML source code from OpenApi specification and with DTO
    model classes generated via the swagger-codegen-maven-plugin.

-   camel-restdsl-openapi:generate-yaml - To generate consumer REST DSL
    YAML source code from OpenApi specification

-   camel-restdsl-openapi:generate-yaml-with-dto - To generate consumer
    REST DSL YAML source code from OpenApi specification and with DTO
    model classes generated via the swagger-codegen-maven-plugin.

Only OpenAPI v3 spec is supported. The older v2 spec (also known as
swagger v2) is not supported from Camel 4.5 onwards.

# Adding plugin to Maven pom.xml

This plugin can be added to your Maven pom.xml file by adding it to the
`<plugins>` section, for example in a Spring Boot application:

    <build>
      <plugins>
        <plugin>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    
        <plugin>
          <groupId>org.apache.camel</groupId>
          <artifactId>camel-restdsl-openapi-plugin</artifactId>
          <version>4.4.0</version> <!-- use the Camel version you are using -->
        </plugin>
    
      </plugins>
    </build>

The plugin can then be executed via its prefix `camel-restdsl-openapi`
as shown

    $mvn camel-restdsl-openapi:generate

# camel-restdsl-openapi:generate

The `camel-restdsl-openapi:generate` goal of the Camel REST DSL OpenApi
Maven Plugin is used to generate REST DSL RouteBuilder implementation
source code from Maven.

## Options

The plugin supports the following options which can be configured from
the command line (use `-D` syntax), or defined in the `pom.xml` file in
the `<configuration>` tag.

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Default Value</p></td>
<td style="text-align: left;"><p>Description</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>skip</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Set to <code>true</code> to skip code
generation.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>filterOperation</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Used for including only the operation
ids specified. Multiple ids can be separated by comma. Wildcards can be
used, eg <code>find*</code> to include all operations starting with
<code>find</code>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>specificationUri</code></p></td>
<td
style="text-align: left;"><p><code>src/spec/openapi.json</code></p></td>
<td style="text-align: left;"><p>URI of the OpenApi specification,
supports filesystem paths, HTTP and classpath resources, by default
<code>src/spec/openapi.json</code> within the project directory.
Supports JSON and YAML.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>auth</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Adds authorization headers when
fetching the OpenApi specification definitions remotely. Pass in a
URL-encoded string of name:header with a comma separating multiple
values.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>className</code></p></td>
<td style="text-align: left;"><p>from <code>title</code> or
<code>RestDslRoute</code></p></td>
<td style="text-align: left;"><p>Name of the generated class, taken from
the OpenApi specification title or set to <code>RestDslRoute</code> by
default</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>packageName</code></p></td>
<td style="text-align: left;"><p>from <code>host</code> or
<code>rest.dsl.generated</code></p></td>
<td style="text-align: left;"><p>Name of the package for the generated
class, taken from the OpenApi specification host value or
<code>rest.dsl.generated</code> by default</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>indent</code></p></td>
<td
style="text-align: left;"><p><code>"&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;"</code></p></td>
<td style="text-align: left;"><p>What identing character(s) to use, by
default four spaces, you can use <code>\t</code> to signify tab
character</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>outputDirectory</code></p></td>
<td
style="text-align: left;"><p><code>generated-sources/restdsl-openapi</code></p></td>
<td style="text-align: left;"><p>Where to place the generated source
file, by default <code>generated-sources/restdsl-openapi</code> within
the project directory</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>destinationGenerator</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Fully qualified class name of the class
that implements
<code>org.apache.camel.generator.openapi.DestinationGenerator</code>
interface for customizing destination endpoint</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>destinationToSyntax</code></p></td>
<td
style="text-align: left;"><p><code>direct:${operationId}</code></p></td>
<td style="text-align: left;"><p>The default to syntax for the to uri,
which is to use the direct component.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>restConfiguration</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>Whether to include generation of the
rest configuration with detected rest component to be used.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>apiContextPath</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Define openapi endpoint path if
<code>restConfiguration</code> is set to <code>true</code>.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>clientRequestValidation</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Whether to enable request
validation.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>basePath</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Overrides the api base path as defined
in the OpenAPI specification.</p></td>
</tr>
</tbody>
</table>

# camel-restdsl-openapi:generate-with-dto

Works as `generate` goal but also generates DTO model classes by
automatic executing the swagger-codegen-maven-plugin to generate java
source code of the DTO model classes from the OpenApi specification.

This plugin has been scoped and limited to only support a good effort
set of defaults for using the swagger-codegen-maven-plugin to generate
the model DTOs. If you need more power and flexibility then use the
[Swagger Codegen Maven
Plugin](https://github.com/swagger-api/swagger-codegen/tree/master/modules/swagger-codegen-maven-plugin)
directly to generate the DTO and not this plugin.

The DTO classes may require additional dependencies such as:

        <dependency>
          <groupId>com.google.code.gson</groupId>
          <artifactId>gson</artifactId>
          <version>2.10.1</version>
        </dependency>
        <dependency>
          <groupId>io.swagger.core.v3</groupId>
          <artifactId>swagger-core</artifactId>
          <version>2.2.15</version>
        </dependency>

## Options

The plugin supports the following **additional** options

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Default Value</p></td>
<td style="text-align: left;"><p>Description</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>swaggerCodegenMavenPluginVersion</code></p></td>
<td style="text-align: left;"><p>3.0.54</p></td>
<td style="text-align: left;"><p>The version of the
<code>io.swagger.codegen.v3:swagger-codegen-maven-plugin</code> maven
plugin to be used.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>modelOutput</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Target output path (default is
${project.build.directory}/generated-sources/openapi)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>modelPackage</code></p></td>
<td
style="text-align: left;"><p><code>io.swagger.client.model</code></p></td>
<td style="text-align: left;"><p>The package to use for generated model
objects/classes</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>modelNamePrefix</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Sets the pre- or suffix for model
classes and enums</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>modelNameSuffix</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Sets the pre- or suffix for model
classes and enums</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>modelWithXml</code></p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Enable XML annotations inside the
generated models (only works with libraries that provide support for
JSON and XML)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>configOptions</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Pass a map of language-specific
parameters to <code>swagger-codegen-maven-plugin</code></p></td>
</tr>
</tbody>
</table>

# camel-restdsl-openapi:generate-xml

The `camel-restdsl-openapi:generate-xml` goal of the Camel REST DSL
OpenApi Maven Plugin is used to generate REST DSL XML implementation
source code from Maven.

## Options

The plugin supports the following options which can be configured from
the command line (use `-D` syntax), or defined in the `pom.xml` file in
the `<configuration>` tag.

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Default Value</p></td>
<td style="text-align: left;"><p>Description</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>skip</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Set to <code>true</code> to skip code
generation.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>filterOperation</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Used for including only the operation
ids specified. Multiple ids can be separated by comma. Wildcards can be
used, eg <code>find*</code> to include all operations starting with
<code>find</code>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>specificationUri</code></p></td>
<td
style="text-align: left;"><p><code>src/spec/openapi.json</code></p></td>
<td style="text-align: left;"><p>URI of the OpenApi specification,
supports filesystem paths, HTTP and classpath resources, by default
<code>src/spec/openapi.json</code> within the project directory.
Supports JSON and YAML.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>auth</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Adds authorization headers when
fetching the OpenApi specification definitions remotely. Pass in a
URL-encoded string of name:header with a comma separating multiple
values.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>outputDirectory</code></p></td>
<td
style="text-align: left;"><p><code>generated-sources/restdsl-openapi</code></p></td>
<td style="text-align: left;"><p>Where to place the generated source
file, by default <code>generated-sources/restdsl-openapi</code> within
the project directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>fileName</code></p></td>
<td style="text-align: left;"><p><code>camel-rest.xml</code></p></td>
<td style="text-align: left;"><p>The name of the XML file as
output.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>blueprint</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>If enabled generates OSGi Blueprint XML
instead of Spring XML.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>destinationGenerator</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Fully qualified class name of the class
that implements
<code>org.apache.camel.generator.openapi.DestinationGenerator</code>
interface for customizing destination endpoint</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>destinationToSyntax</code></p></td>
<td
style="text-align: left;"><p><code>direct:${operationId}</code></p></td>
<td style="text-align: left;"><p>The default to syntax for the to uri,
which is to use the direct component.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"><p><code>restConfiguration</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Whether to include generation of the
rest configuration with detected rest component to be used.</p></td>
<td style="text-align: left;"><p><code>apiContextPath</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Define openapi endpoint path if
<code>restConfiguration</code> is set to <code>true</code>.</p></td>
<td
style="text-align: left;"><p><code>clientRequestValidation</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Whether to enable request
validation.</p></td>
<td style="text-align: left;"><p><code>basePath</code></p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

# camel-restdsl-openapi:generate-xml-with-dto

Works as `generate-xml` goal but also generates DTO model classes by
automatic executing the swagger-codegen-maven-plugin to generate java
source code of the DTO model classes from the OpenApi specification.

This plugin has been scoped and limited to only support a good effort
set of defaults for using the swagger-codegen-maven-plugin to generate
the model DTOs. If you need more power and flexibility then use the
[Swagger Codegen Maven
Plugin](https://github.com/swagger-api/swagger-codegen/tree/master/modules/swagger-codegen-maven-plugin)
directly to generate the DTO and not this plugin.

The DTO classes may require additional dependencies such as:

        <dependency>
          <groupId>com.google.code.gson</groupId>
          <artifactId>gson</artifactId>
          <version>2.10.1</version>
        </dependency>
        <dependency>
          <groupId>io.swagger.core.v3</groupId>
          <artifactId>swagger-core</artifactId>
          <version>2.2.15</version>
        </dependency>

## Options

The plugin supports the following **additional** options

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Default Value</p></td>
<td style="text-align: left;"><p>Description</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>swaggerCodegenMavenPluginVersion</code></p></td>
<td style="text-align: left;"><p>3.0.54</p></td>
<td style="text-align: left;"><p>The version of the
<code>io.swagger.codegen.v3:swagger-codegen-maven-plugin</code> maven
plugin to be used.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>modelOutput</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Target output path (default is
${project.build.directory}/generated-sources/openapi)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>modelPackage</code></p></td>
<td
style="text-align: left;"><p><code>io.swagger.client.model</code></p></td>
<td style="text-align: left;"><p>The package to use for generated model
objects/classes</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>modelNamePrefix</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Sets the pre- or suffix for model
classes and enums</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>modelNameSuffix</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Sets the pre- or suffix for model
classes and enums</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>modelWithXml</code></p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Enable XML annotations inside the
generated models (only works with libraries that provide support for
JSON and XML)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>configOptions</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Pass a map of language-specific
parameters to <code>swagger-codegen-maven-plugin</code></p></td>
</tr>
</tbody>
</table>

# camel-restdsl-openapi:generate-yaml

The `camel-restdsl-openapi:generate-yaml` goal of the Camel REST DSL
OpenApi Maven Plugin is used to generate REST DSL YAML implementation
source code from Maven.

## Options

The plugin supports the following options which can be configured from
the command line (use `-D` syntax), or defined in the `pom.xml` file in
the `<configuration>` tag.

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Default Value</p></td>
<td style="text-align: left;"><p>Description</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>skip</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Set to <code>true</code> to skip code
generation.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>filterOperation</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Used for including only the operation
ids specified. Multiple ids can be separated by comma. Wildcards can be
used, eg <code>find*</code> to include all operations starting with
<code>find</code>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>specificationUri</code></p></td>
<td
style="text-align: left;"><p><code>src/spec/openapi.json</code></p></td>
<td style="text-align: left;"><p>URI of the OpenApi specification,
supports filesystem paths, HTTP and classpath resources, by default
<code>src/spec/openapi.json</code> within the project directory.
Supports JSON and YAML.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>auth</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Adds authorization headers when
fetching the OpenApi specification definitions remotely. Pass in a
URL-encoded string of name:header with a comma separating multiple
values.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>outputDirectory</code></p></td>
<td
style="text-align: left;"><p><code>generated-sources/restdsl-openapi</code></p></td>
<td style="text-align: left;"><p>Where to place the generated source
file, by default <code>generated-sources/restdsl-openapi</code> within
the project directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>fileName</code></p></td>
<td style="text-align: left;"><p><code>camel-rest.yaml</code></p></td>
<td style="text-align: left;"><p>The name of the YAML file as
output.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>destinationGenerator</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Fully qualified class name of the class
that implements
<code>org.apache.camel.generator.openapi.DestinationGenerator</code>
interface for customizing destination endpoint</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>destinationToSyntax</code></p></td>
<td
style="text-align: left;"><p><code>direct:${operationId}</code></p></td>
<td style="text-align: left;"><p>The default to syntax for the to uri,
which is to use the direct component.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"><p><code>restConfiguration</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Whether to include generation of the
rest configuration with detected rest component to be used.</p></td>
<td style="text-align: left;"><p><code>apiContextPath</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Define openapi endpoint path if
<code>restConfiguration</code> is set to <code>true</code>.</p></td>
<td
style="text-align: left;"><p><code>clientRequestValidation</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Whether to enable request
validation.</p></td>
<td style="text-align: left;"><p><code>basePath</code></p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

# camel-restdsl-openapi:generate-yaml-with-dto

Works as `generate-yaml` goal but also generates DTO model classes by
automatic executing the swagger-codegen-maven-plugin to generate java
source code of the DTO model classes from the OpenApi specification.

This plugin has been scoped and limited to only support a good effort
set of defaults for using the swagger-codegen-maven-plugin to generate
the model DTOs. If you need more power and flexibility then use the
[Swagger Codegen Maven
Plugin](https://github.com/swagger-api/swagger-codegen/tree/master/modules/swagger-codegen-maven-plugin)
directly to generate the DTO and not this plugin.

The DTO classes may require additional dependencies such as:

        <dependency>
          <groupId>com.google.code.gson</groupId>
          <artifactId>gson</artifactId>
          <version>2.10.1</version>
        </dependency>
        <dependency>
          <groupId>io.swagger.core.v3</groupId>
          <artifactId>swagger-core</artifactId>
          <version>2.2.15</version>
        </dependency>

## Options

The plugin supports the following **additional** options

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Default Value</p></td>
<td style="text-align: left;"><p>Description</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>swaggerCodegenMavenPluginVersion</code></p></td>
<td style="text-align: left;"><p>3.0.54</p></td>
<td style="text-align: left;"><p>The version of the
<code>io.swagger.codegen.v3:swagger-codegen-maven-plugin</code> maven
plugin to be used.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>modelOutput</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Target output path (default is
${project.build.directory}/generated-sources/openapi)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>modelPackage</code></p></td>
<td
style="text-align: left;"><p><code>io.swagger.client.model</code></p></td>
<td style="text-align: left;"><p>The package to use for generated model
objects/classes</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>modelNamePrefix</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Sets the pre- or suffix for model
classes and enums</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>modelNameSuffix</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Sets the pre- or suffix for model
classes and enums</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>modelWithXml</code></p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Enable XML annotations inside the
generated models (only works with libraries that provide support for
JSON and XML)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>configOptions</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Pass a map of language-specific
parameters to <code>swagger-codegen-maven-plugin</code></p></td>
</tr>
</tbody>
</table>
