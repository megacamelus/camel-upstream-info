# File

**Since Camel 1.0**

**Both producer and consumer are supported**

The File component provides access to file systems, allowing files to be
processed by any other Camel Components or messages from other
components to be saved to disk.

# URI format

    file:directoryName[?options]

Where `directoryName` represents the underlying file directory.

**Only directories**

Camel supports only endpoints configured with a starting directory. So
the `directoryName` **must be** a directory. If you want to consume a
single file only, you can use the `fileName` option, e.g., by setting
`fileName=thefilename`. Also, the starting directory must not contain
dynamic expressions with `${ }` placeholders. Again use the `fileName`
option to specify the dynamic part of the filename.

**Avoid reading files currently being written by another application**

Beware the JDK File IO API is a bit limited in detecting whether another
application is currently writing/copying a file. And the implementation
can be different depending on the OS platform as well. This could lead
to that Camel thinks the file is not locked by another process and start
consuming it. Therefore, you have to do your own investigation what
suites your environment. To help with this Camel provides different
`readLock` options and `doneFileName` option that you can use. See also
[Consuming files from folders where others drop files
directly](#File2-Consumingfilesfromfolderswhereothersdropfilesdirectly).

**Default behavior for file producer**

By default, it will override any existing file if one exists with the
same name.

# Move, Pre Move and Delete operations

By default, Camel will move consumed files to the `.camel` subfolder
relative to the directory where the file was consumed.

If you want to delete the file after processing, the route should be:

    from("file://inbox?delete=true").to("bean:handleOrder");

There is a sample [showing reading from a directory and the default move
operation](#File2-ReadingFromADirectoryAndTheDefaultMoveOperation)
below.

## Move, Delete and the Routing process

Any move or delete operations are executed after the routing has
completed. So, during processing of the `Exchange` the file is still
located in the inbox folder.

Let’s illustrate this with an example:

    from("file://inbox?move=.done").to("bean:handleOrder");

When a file is dropped in the `inbox` folder, the file consumer notices
this and creates a new `FileExchange` that is routed to the
`handleOrder` bean. The bean then processes the `File` object. At this
point in time the file is still located in the `inbox` folder. After the
bean completes, and thus the route is completed, the file consumer will
perform the move operation and move the file to the `.done` sub-folder.

The `move` and the `preMove` options are considered as a directory name.
Though, if you use an expression such as [File
Language](#languages:file-language.adoc), or
[Simple](#languages:simple-language.adoc), then the result of the
expression evaluation is the file name to be used. E.g., if you set:

    move=../backup/copy-of-${file:name}

Then that’s using the [File Language](#languages:file-language.adoc)
which we use to return the file name to be used. This can be either
relative or absolute. If relative, the directory is created as a
subfolder from within the folder where the file was consumed.

## Move and Pre Move operations

We have introduced a `preMove` operation to move files **before** they
are processed. This allows you to mark which files have been scanned as
they are moved to this subfolder before being processed.

    from("file://inbox?preMove=inprogress").to("bean:handleOrder");

You can combine the `preMove` and the regular `move`:

    from("file://inbox?preMove=inprogress&move=.done").to("bean:handleOrder");

So in this situation, the file is in the `inprogress` folder when being
processed, and after it’s processed, it’s moved to the `.done` folder.

## Fine-grained control over Move and PreMove option

The `move` and `preMove` options are Expression-based, so we have the
full power of the [File Language](#languages:file-language.adoc) to do
advanced configuration of the directory and name pattern. Camel will, in
fact, internally convert the directory name you enter into a [File
Language](#languages:file-language.adoc) expression. So, when we use
`move=.done` Camel will convert this into:
`${file:parent}/.done/${file:onlyname}`.

This is only done if Camel detects that you have not provided a `${ }`
in the option value yourself. So when you enter a `${ }` Camel will
**not** convert it, and thus you have the full power.

So if we want to move the file into a backup folder with today’s date,
as the pattern, we can do:

    move=backup/${date:now:yyyyMMdd}/${file:name}

## About moveFailed

The `moveFailed` option allows you to move files that **could not** be
processed successfully to another location such as an error folder of
your choice. For example, to move the files in an error folder with a
timestamp you can use

See more examples at [File Language](#languages:file-language.adoc)

# Exchange Properties, file consumer only

As the file consumer implements the `BatchConsumer` it supports batching
the files it polls. By batching, we mean that Camel will add the
following additional properties to the Exchange:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>CamelBatchSize</code></p></td>
<td style="text-align: left;"><p>The total number of files that was
polled in this batch.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>CamelBatchIndex</code></p></td>
<td style="text-align: left;"><p>The current index of the batch. Starts
from 0.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelBatchComplete</code></p></td>
<td style="text-align: left;"><p>A <code>boolean</code> value indicating
the last Exchange in the batch. Is only <code>true</code> for the last
entry.</p></td>
</tr>
</tbody>
</table>

This allows you, for instance, to know how many files exist in this
batch and for instance, let the Aggregator2 aggregate this number of
files.

# Using charset

The `charset` option allows configuring the encoding of the files on
both the consumer and producer endpoints. For example, if you read utf-8
files and want to convert the files to iso-8859-1, you can do:

    from("file:inbox?charset=utf-8")
      .to("file:outbox?charset=iso-8859-1")

You can also use the `convertBodyTo` in the route. In the example below,
we have still input files in utf-8 format, but we want to convert the
file content to a byte array in iso-8859-1 format. And then let a bean
process the data. Before writing the content to the outbox folder using
the current charset.

    from("file:inbox?charset=utf-8")
      .convertBodyTo(byte[].class, "iso-8859-1")
      .to("bean:myBean")
      .to("file:outbox");

If you omit the charset on the consumer endpoint, then Camel does not
know the charset of the file, and would by default use `UTF-8`. However,
you can configure a JVM system property to override and use a different
default encoding with the key `org.apache.camel.default.charset`.

In the example below, this could be a problem if the files are not in
UTF-8 encoding, which would be the default encoding for read the files.
In this example when writing the files, the content has already been
converted to a byte array, and thus would write the content directly as
is (without any further encodings).

    from("file:inbox")
      .convertBodyTo(byte[].class, "iso-8859-1")
      .to("bean:myBean")
      .to("file:outbox");

You can also override and control the encoding dynamic when writing
files, by setting a property on the exchange with the key
`Exchange.CHARSET_NAME`. For example, in the route below, we set the
property with a value from a message header.

    from("file:inbox")
      .convertBodyTo(byte[].class, "iso-8859-1")
      .to("bean:myBean")
      .setProperty(Exchange.CHARSET_NAME, header("someCharsetHeader"))
      .to("file:outbox");

We suggest keeping things simpler, so if you pick up files with the same
encoding, and want to write the files in a specific encoding, then favor
to use the `charset` option on the endpoints.

Notice that if you have explicitly configured a `charset` option on the
endpoint, then that configuration is used, regardless of the
`Exchange.CHARSET_NAME` property.

If you have some issues then you can enable DEBUG logging on
`org.apache.camel.component.file`, and Camel logs when it reads/write a
file using a specific charset. For example, the route below will log the
following:

    from("file:inbox?charset=utf-8")
      .to("file:outbox?charset=iso-8859-1")

And the logs:

    DEBUG GenericFileConverter           - Read file /Users/davsclaus/workspace/camel/camel-core/target/charset/input/input.txt with charset utf-8
    DEBUG FileOperations                 - Using Reader to write file: target/charset/output.txt with charset: iso-8859-1

# Common gotchas with folder and filenames

When Camel is producing files (writing files), there are a few gotchas
affecting how to set a filename of your choice. By default, Camel will
use the message ID as the filename, and since the message ID is normally
a unique generated ID, you will end up with filenames such as:
`ID-MACHINENAME-2443-1211718892437-1-0`. If such a filename is not
desired, then you must provide a filename in the `CamelFileName` message
header. The constant, `Exchange.FILE_NAME`, can also be used.

The sample code below produces files using the message ID as the
filename:

    from("direct:report").to("file:target/reports");

To use `report.txt` as the filename you have to do:

    from("direct:report").setHeader(Exchange.FILE_NAME, constant("report.txt")).to( "file:target/reports");

1.  the same as above, but with `CamelFileName`:

<!-- -->

    from("direct:report").setHeader("CamelFileName", constant("report.txt")).to( "file:target/reports");

And a syntax where we set the filename on the endpoint with the
`fileName` URI option.

    from("direct:report").to("file:target/reports/?fileName=report.txt");

# Filename Expression

Filename can be set either using the **expression** option or as a
string-based [File Language](#languages:file-language.adoc) expression
in the `CamelFileName` header. See the [File
Language](#languages:file-language.adoc) for syntax and samples.

# Consuming files from folders where others drop files directly

Beware if you consume files from a folder where other applications write
files too. Take a look at the different `readLock` options to see what
suits your use cases. The best approach is, however, to write to another
folder and, after writing, move the file in the drop folder. However, if
you write files directly to the drop folder, then the option `changed`
could better detect whether a file is currently being written/copied as
it uses a file changed algorithm to see whether the file size /
modification changes over a period of time. The other `readLock` options
rely on Java File API that, sadly, is not always very good at detecting
this. You may also want to look at the `doneFileName` option, which uses
a marker file (*done file*) to signal when a file is done and ready to
be consumed.

# Done files

## Using done files

See also section [*writing done files*](#File2-WritingDoneFiles) below.

If you want only to consume files when a *done file* exists, then you
can use the `doneFileName` option on the endpoint.

    from("file:bar?doneFileName=done");

It will only consume files from the *bar* folder if a *done file* exists
in the same directory as the target files. Camel will automatically
delete the *done file* when it’s done consuming the files.

Camel does not delete automatically the *done file* if `noop=true` is
configured.

However, it is more common to have one *done file* per target file. This
means there is a 1:1 correlation. To do this, you must use dynamic
placeholders in the `doneFileName` option. Currently, Camel supports the
following two dynamic tokens: `file:name` and `file:name.noext` which
must be enclosed in `${ }`. The consumer only supports the static part
of the *done file* name as either prefix or suffix (not both).

Suffix  
from("file:bar?doneFileName=${file:name}.done");

In this example, the files will only be polled if there exists a *done
file* with the name `_file name_.done`. For example:

-   `hello.txt`: is the file to be consumed

-   `hello.txt.done`: is the associated `done` file

Prefix  
from("file:bar?doneFileName=ready-${file:name}");

You can also use a prefix for the *done file*, such as:

-   `hello.txt`: is the file to be consumed

-   `ready-hello.txt`: is the associated `done` file

## Writing done files

After you have written a file, you may want to write an additional *done
file* as a kind of marker, to indicate to others that the file is
finished and has been written. To do that, you can use the
`doneFileName` option on the file producer endpoint.

    .to("file:bar?doneFileName=done");

This will create a file named `done` in the same directory as the target
file.

However, it is more common to have one *done file* per target file. This
means there is a 1:1 correlation. To do this, you must use dynamic
placeholders in the `doneFileName` option. Currently, Camel supports the
following two dynamic tokens: `file:name` and `file:name.noext`. They
must be enclosed in `${ }`:

Prefix and file name  
.to("file:bar?doneFileName=done-${file:name}");

This will, for example, create a file named `done-foo.txt` if the target
file was `foo.txt` in the same directory as the target file.

Suffix and file name  
.to("file:bar?doneFileName=${file:name}.done");

This will, for example, create a file named `foo.txt.done` if the target
file was `foo.txt` in the same directory as the target file.

File name without the extension  
.to("file:bar?doneFileName=${file:name.noext}.done");

Will, for example, create a file named `foo.done` if the target file was
`foo.txt` in the same directory as the target file.

# Using flatten

If you want to store the files in the `outputdir` directory in the same
directory, disregarding the source directory layout (e.g., to flatten
out the path), you add the `flatten=true` option on the file producer
side:

    from("file://inputdir/?recursive=true&delete=true").to("file://outputdir?flatten=true")

It will result in the following output layout:

    outputdir/foo.txt
    outputdir/bar.txt

# Writing to files

Camel is also able to write files, i.e., produce files. In the sample
below, we receive some reports on the SEDA queue that we process before
they are being written to a directory.

## Write to subdirectory using `Exchange.FILE_NAME`

Using a single route, it is possible to write a file to any number of
subdirectories. If you have a route setup as such:

    <route>
      <from uri="bean:myBean"/>
      <to uri="file:/rootDirectory"/>
    </route>

You can have `myBean` set the header `Exchange.FILE_NAME` to values such
as:

    Exchange.FILE_NAME = hello.txt => /rootDirectory/hello.txt
    Exchange.FILE_NAME = foo/bye.txt => /rootDirectory/foo/bye.txt

This allows you to have a single route to write files to multiple
destinations.

## Writing file through the temporary directory relative to the final destination

Sometimes you need to temporarily write the files to some directory
relative to the destination directory. Such a situation usually happens
when some external process with limited filtering capabilities is
reading from the directory you are writing to. In the example below
files will be written to the `/var/myapp/filesInProgress` directory and
after data transfer is done, they will be atomically moved to the\`
/var/myapp/finalDirectory \`directory.

    from("direct:start").
      to("file:///var/myapp/finalDirectory?tempPrefix=/../filesInProgress/");

# Avoiding reading the same file more than once (idempotent consumer)

Camel supports Idempotent Consumer directly within the component, so it
will skip already processed files. This feature can be enabled by
setting the `idempotent=true` option.

    from("file://inbox?idempotent=true").to("...");

Camel uses the absolute file name as the idempotent key, to detect
duplicate files. You can customize this key by using an expression in
the idempotentKey option. For example, to use both the name and the file
size as the key

    <route>
      <from uri="file://inbox?idempotent=true&amp;idempotentKey=${file:name}-${file:size}"/>
      <to uri="bean:processInbox"/>
    </route>

By default, Camel uses an in-memory store for keeping track of consumed
files. It uses the least recently used cache holding up to 1000 entries.
You can plug in your own implementation of this store by using the
`idempotentRepository` option using the `#` sign in the value to
indicate it’s a referring to a bean in the Registry with the specified
`id`.

     <!-- define our store as a plain spring bean -->
     <bean id="myStore" class="com.mycompany.MyIdempotentStore"/>
    
    <route>
      <from uri="file://inbox?idempotent=true&amp;idempotentRepository=#myStore"/>
      <to uri="bean:processInbox"/>
    </route>

Camel will log at `DEBUG` level if it skips a file because it has been
consumed before:

    DEBUG FileConsumer is idempotent and the file has been consumed before. Will skip this file: target\idempotent\report.txt

# Idempotent Repository

## Using a file-based idempotent repository

In this section we will use the file-based idempotent repository
`org.apache.camel.processor.idempotent.FileIdempotentRepository` instead
of the in-memory one that is used as default. This repository uses a
first level cache to avoid reading the file repository. It will only use
the file repository to store the content of the first level cache.
Thereby, the repository can survive server restarts. It will load the
content of the file into the first level cache upon startup. The file
structure is basic as it stores the key in separate lines in the file.
By default, the file store has a size limit of 1mb. When the file grows
larger, Camel will truncate the file store, rebuilding the content by
flushing the first level cache into a fresh empty file.

We configure our repository using Spring XML creating our file
idempotent repository and define our file consumer to use our repository
with the `idempotentRepository` using `#` sign to indicate Registry
lookup:

## Using a JPA based idempotent repository

In this section, we will use the JPA based idempotent repository instead
of the in-memory based that is used as default.

First we need a persistence-unit in `META-INF/persistence.xml` where we
need to use the class
`org.apache.camel.processor.idempotent.jpa.MessageProcessed` as the
model.

    <persistence-unit name="idempotentDb" transaction-type="RESOURCE_LOCAL">
      <class>org.apache.camel.processor.idempotent.jpa.MessageProcessed</class>
    
      <properties>
        <property name="openjpa.ConnectionURL" value="jdbc:derby:target/idempotentTest;create=true"/>
        <property name="openjpa.ConnectionDriverName" value="org.apache.derby.jdbc.EmbeddedDriver"/>
        <property name="openjpa.jdbc.SynchronizeMappings" value="buildSchema"/>
        <property name="openjpa.Log" value="DefaultLevel=WARN, Tool=INFO"/>
        <property name="openjpa.Multithreaded" value="true"/>
      </properties>
    </persistence-unit>

Next, we can create our JPA idempotent repository in the spring XML file
as well:

    <!-- we define our jpa based idempotent repository we want to use in the file consumer -->
    <bean id="jpaStore" class="org.apache.camel.processor.idempotent.jpa.JpaMessageIdRepository">
        <!-- Here we refer to the entityManagerFactory -->
        <constructor-arg index="0" ref="entityManagerFactory"/>
        <!-- This 2nd parameter is the name (= a category name).
             You can have different repositories with different names -->
        <constructor-arg index="1" value="FileConsumer"/>
    </bean>

And yes then we just need to refer to the **jpaStore** bean in the file
consumer endpoint using the `idempotentRepository` using the `#` syntax
option:

    <route>
      <from uri="file://inbox?idempotent=true&amp;idempotentRepository=#jpaStore"/>
      <to uri="bean:processInbox"/>
    </route>

# Filtering Strategies

Camel supports pluggable filtering strategies. They are described below.

## Filter using the `GenericFilter`

The `filter` option allows you to implement a custom filter in Java code
by implementing the `org.apache.camel.component.file.GenericFileFilter`
interface.

### Implementing a GenericFilter

The interface has an `accept` method that returns a boolean. The meaning
of the return values are:

-   `true` to include the file

-   `false` to skip the file.

There is also a `isDirectory` method on `GenericFile` to inform whether
the file is a directory. This allows you to filter unwanted directories,
to avoid traversing down unwanted directories.

### Using the `GenericFilter`

You can then configure the endpoint with such a filter to skip certain
files being processed.

In the sample we have built our own filter that skips files starting
with `skip` in the filename:

And then we can configure our route using the `filter` attribute to
reference our filter (using `#` notation) that we have defined in the
spring XML file:

    <!-- define our filter as a plain spring bean -->
    <bean id="myFilter" class="com.mycompany.MyFileFilter"/>
    
    <route>
      <from uri="file://inbox?filter=#myFilter"/>
      <to uri="bean:processInbox"/>
    </route>

## Filtering using ANT path matcher

The ANT path matcher is based on
[AntPathMatcher](http://static.springframework.org/spring/docs/2.5.x/api/org/springframework/util/AntPathMatcher.html).

The file paths are matched with the following rules:

-   `?` matches one character

-   `*` matches zero or more characters

-   `**` matches zero or more directories in a path

The `antInclude` and `antExclude` options make it easy to specify ANT
style include/exclude without having to define the filter. See the URI
options above for more information.

The sample below demonstrates how to use it:

    from("file://inbox?antInclude=**/*.txt").to("...");

# Sorting Strategies

Camel supports pluggable sorting strategies. They are described below.

## Sorting using Comparator

This strategy it to use the build in `java.util.Comparator` in Java. You
can then configure the endpoint with such a comparator and have Camel
sort the files before being processed.

In the sample, we have built our own comparator that just sorts by file
name:

And then we can configure our route using the **sorter** option to
reference to our sorter (`mySorter`) we have defined in the spring XML
file:

     <!-- define our sorter as a plain spring bean -->
     <bean id="mySorter" class="com.mycompany.MyFileSorter"/>
    
    <route>
      <from uri="file://inbox?sorter=#mySorter"/>
      <to uri="bean:processInbox"/>
    </route>

**URI options can reference beans using the # syntax**

In the Spring DSL route above notice that we can refer to beans in the
Registry by prefixing the id with `#`. So writing `sorter=#mySorter`,
will instruct Camel to go look in the Registry for a bean with the ID,
`mySorter`.

## Sorting using sortBy

Camel supports pluggable sorting strategies. This strategy uses the
[File Language](#languages:file-language.adoc) to configure the sorting.
The `sortBy` option is configured as follows:

    sortBy=group 1;group 2;group 3;...

Where each group is separated with semicolon. In the simple situations
you just use one group, so a simple example could be:

    sortBy=file:name

This will sort by file name, you can reverse the order by prefixing
`reverse:` to the group, so the sorting is now Z to A:

    sortBy=reverse:file:name

As we have the full power of [File
Language](#languages:file-language.adoc), we can use some of the other
parameters, so if we want to sort by file size, we do:

    sortBy=file:length

You can configure to ignore the case, using `ignoreCase:` for string
comparison, so if you want to use file name sorting but to ignore the
case, then we do:

    sortBy=ignoreCase:file:name

You can combine ignore case and reverse. However, `reverse` must be
specified first:

    sortBy=reverse:ignoreCase:file:name

In the sample below we want to sort by the last modified file, so we do:

    sortBy=file:modified

And then we want to group by name as a second option, so files with the
same modification time are sorted by name:

    sortBy=file:modified;file:name

Now there is an issue here, can you spot it? Well, the modified
timestamp of the file is too fine as it will be in milliseconds, but
what if we want to sort by date only and then subgroup by name? Well, as
we have the true power of [File
Language](#languages:file-language.adoc), we can use its date command
that supports patterns. So this can be solved as:

    sortBy=date:file:yyyyMMdd;file:name

Yeah, that is pretty powerful, oh by the way, you can also use reverse
per group, so we could reverse the file names:

    sortBy=date:file:yyyyMMdd;reverse:file:name

# Using GenericFileProcessStrategy

The option `processStrategy` can be used to use a custom
`GenericFileProcessStrategy` that allows you to implement your own
*begin*, *commit* and *rollback* logic. For instance, let’s assume a
system writes a file in a folder you should consume. But you should not
start consuming the file before another *ready* file has been written as
well.

So by implementing our own `GenericFileProcessStrategy` we can implement
this as:

-   In the `begin()` method we can test whether the special *ready* file
    exists. The `begin` method returns a `boolean` to indicate if we can
    consume the file or not.

-   In the `abort()` method special logic can be executed in case the
    `begin` operation returned `false`, for example, to clean up
    resources etc.

-   in the `commit()` method we can move the actual file and also delete
    the *ready* file.

# Using bridgeErrorHandler

If you want to use the Camel Error Handler to deal with any exception
occurring in the file consumer, then you can enable the
`bridgeErrorHandler` option as shown below:

    // to handle any IOException being thrown
    onException(IOException.class)
        .handled(true)
        .log("IOException occurred due: ${exception.message}")
        .transform().simple("Error ${exception.message}")
        .to("mock:error");
    
    // this is the file route that pickup files. Notice how we bridge the consumer to use the Camel routing error handler
    // the exclusiveReadLockStrategy is only configured because this is from a unit test, so we use that to simulate exceptions
    from("file:target/nospace?bridgeErrorHandler=true")
        .convertBodyTo(String.class)
        .to("mock:result");

So all you have to do is to enable this option, and the error handler in
the route will take it from there.

When using bridgeErrorHandler, then `interceptors`, `OnCompletions` do
**not** apply. The Exchange is processed directly by the Camel Error
Handler, and does not allow prior actions such as interceptors,
onCompletion to take action.

# Debug logging

This component has log level **TRACE** that can be helpful if you have
problems.

# Samples

## Reading from a directory and the default move operation

By default, Camel will move any processed file into a `.camel`
subdirectory in the directory the file was consumed from.

    from("file://inputdir/?recursive=true&delete=true").to("file://outputdir")

Affects the layout as follows:  
**before**

    inputdir/foo.txt
    inputdir/sub/bar.txt

**after**

    inputdir/.camel/foo.txt
    inputdir/sub/.camel/bar.txt
    outputdir/foo.txt
    outputdir/sub/bar.txt

## Read from a directory and write to another directory

    from("file://inputdir/?delete=true").to("file://outputdir")

## Read from a directory and write to another directory using a dynamic name

    from("file://inputdir/?delete=true").to("file://outputdir?fileName=copy-of-${file:name}")

Listen to a directory and create a message for each file dropped there.
Copy the contents to the `outputdir` and delete the file in the
`inputdir`.

## Reading recursively from a directory and writing to another

    from("file://inputdir/?recursive=true&delete=true").to("file://outputdir")

Listen to a directory and create a message for each file dropped there.
Copy the contents to the `outputdir` and delete the file in the
`inputdir`. Will scan recursively into subdirectories. Will lay out the
files in the same directory structure in the `outputdir` as the
`inputdir`, including any subdirectories.

    inputdir/foo.txt
    inputdir/sub/bar.txt

It will result in the following output layout:

    outputdir/foo.txt
    outputdir/sub/bar.txt

## Read from a directory and process the message in java

    from("file://inputdir/").process(new Processor() {
      public void process(Exchange exchange) throws Exception {
        Object body = exchange.getIn().getBody();
        // do some business logic with the input body
      }
    });

The body will be a `File` object that points to the file that was just
dropped into the `inputdir` directory.

## Using expression for filenames

In this sample, we want to move consumed files to a backup folder using
today’s date as a subfolder name:

    from("file://inbox?move=backup/${date:now:yyyyMMdd}/${file:name}").to("...");

See [File Language](#languages:file-language.adoc) for more samples.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|directoryName|The starting directory||string|
|charset|This option is used to specify the encoding of the file. You can use this on the consumer, to specify the encodings of the files, which allow Camel to know the charset it should load the file content in case the file content is being accessed. Likewise when writing a file, you can use this option to specify which charset to write the file as well. Do mind that when writing the file Camel may have to read the message content into memory to be able to convert the data into the configured charset, so do not use this if you have big messages.||string|
|doneFileName|Producer: If provided, then Camel will write a 2nd done file when the original file has been written. The done file will be empty. This option configures what file name to use. Either you can specify a fixed name. Or you can use dynamic placeholders. The done file will always be written in the same folder as the original file. Consumer: If provided, Camel will only consume files if a done file exists. This option configures what file name to use. Either you can specify a fixed name. Or you can use dynamic placeholders.The done file is always expected in the same folder as the original file. Only ${file.name} and ${file.name.next} is supported as dynamic placeholders.||string|
|fileName|Use Expression such as File Language to dynamically set the filename. For consumers, it's used as a filename filter. For producers, it's used to evaluate the filename to write. If an expression is set, it take precedence over the CamelFileName header. (Note: The header itself can also be an Expression). The expression options support both String and Expression types. If the expression is a String type, it is always evaluated using the File Language. If the expression is an Expression type, the specified Expression type is used - this allows you, for instance, to use OGNL expressions. For the consumer, you can use it to filter filenames, so you can for instance consume today's file using the File Language syntax: mydata-${date:now:yyyyMMdd}.txt. The producers support the CamelOverruleFileName header which takes precedence over any existing CamelFileName header; the CamelOverruleFileName is a header that is used only once, and makes it easier as this avoids to temporary store CamelFileName and have to restore it afterwards.||string|
|delete|If true, the file will be deleted after it is processed successfully.|false|boolean|
|moveFailed|Sets the move failure expression based on Simple language. For example, to move files into a .error subdirectory use: .error. Note: When moving the files to the fail location Camel will handle the error and will not pick up the file again.||string|
|noop|If true, the file is not moved or deleted in any way. This option is good for readonly data, or for ETL type requirements. If noop=true, Camel will set idempotent=true as well, to avoid consuming the same files over and over again.|false|boolean|
|preMove|Expression (such as File Language) used to dynamically set the filename when moving it before processing. For example to move in-progress files into the order directory set this value to order.||string|
|preSort|When pre-sort is enabled then the consumer will sort the file and directory names during polling, that was retrieved from the file system. You may want to do this in case you need to operate on the files in a sorted order. The pre-sort is executed before the consumer starts to filter, and accept files to process by Camel. This option is default=false meaning disabled.|false|boolean|
|recursive|If a directory, will look for files in all the sub-directories as well.|false|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|directoryMustExist|Similar to the startingDirectoryMustExist option but this applies during polling (after starting the consumer).|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|extendedAttributes|To define which file attributes of interest. Like posix:permissions,posix:owner,basic:lastAccessTime, it supports basic wildcard like posix:, basic:lastAccessTime||string|
|includeHiddenDirs|Whether to accept hidden directories. Directories which names starts with dot is regarded as a hidden directory, and by default not included. Set this option to true to include hidden directories in the file consumer.|false|boolean|
|includeHiddenFiles|Whether to accept hidden files. Files which names starts with dot is regarded as a hidden file, and by default not included. Set this option to true to include hidden files in the file consumer.|false|boolean|
|inProgressRepository|A pluggable in-progress repository org.apache.camel.spi.IdempotentRepository. The in-progress repository is used to account the current in progress files being consumed. By default a memory based repository is used.||object|
|localWorkDirectory|When consuming, a local work directory can be used to store the remote file content directly in local files, to avoid loading the content into memory. This is beneficial, if you consume a very big remote file and thus can conserve memory.||string|
|onCompletionExceptionHandler|To use a custom org.apache.camel.spi.ExceptionHandler to handle any thrown exceptions that happens during the file on completion process where the consumer does either a commit or rollback. The default implementation will log any exception at WARN level and ignore.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|probeContentType|Whether to enable probing of the content type. If enable then the consumer uses Files#probeContentType(java.nio.file.Path) to determine the content-type of the file, and store that as a header with key Exchange#FILE\_CONTENT\_TYPE on the Message.|false|boolean|
|processStrategy|A pluggable org.apache.camel.component.file.GenericFileProcessStrategy allowing you to implement your own readLock option or similar. Can also be used when special conditions must be met before a file can be consumed, such as a special ready file exists. If this option is set then the readLock option does not apply.||object|
|startingDirectoryMustExist|Whether the starting directory must exist. Mind that the autoCreate option is default enabled, which means the starting directory is normally auto created if it doesn't exist. You can disable autoCreate and enable this to ensure the starting directory must exist. Will throw an exception if the directory doesn't exist.|false|boolean|
|startingDirectoryMustHaveAccess|Whether the starting directory has access permissions. Mind that the startingDirectoryMustExist parameter must be set to true in order to verify that the directory exists. Will thrown an exception if the directory doesn't have read and write permissions.|false|boolean|
|appendChars|Used to append characters (text) after writing files. This can for example be used to add new lines or other separators when writing and appending new files or existing files. To specify new-line (slash-n or slash-r) or tab (slash-t) characters then escape with an extra slash, eg slash-slash-n.||string|
|checksumFileAlgorithm|If provided, then Camel will write a checksum file when the original file has been written. The checksum file will contain the checksum created with the provided algorithm for the original file. The checksum file will always be written in the same folder as the original file.||string|
|fileExist|What to do if a file already exists with the same name. Override, which is the default, replaces the existing file. - Append - adds content to the existing file. - Fail - throws a GenericFileOperationException, indicating that there is already an existing file. - Ignore - silently ignores the problem and does not override the existing file, but assumes everything is okay. - Move - option requires to use the moveExisting option to be configured as well. The option eagerDeleteTargetFile can be used to control what to do if an moving the file, and there exists already an existing file, otherwise causing the move operation to fail. The Move option will move any existing files, before writing the target file. - TryRename is only applicable if tempFileName option is in use. This allows to try renaming the file from the temporary name to the actual name, without doing any exists check. This check may be faster on some file systems and especially FTP servers.|Override|object|
|flatten|Flatten is used to flatten the file name path to strip any leading paths, so it's just the file name. This allows you to consume recursively into sub-directories, but when you eg write the files to another directory they will be written in a single directory. Setting this to true on the producer enforces that any file name in CamelFileName header will be stripped for any leading paths.|false|boolean|
|jailStartingDirectory|Used for jailing (restricting) writing files to the starting directory (and sub) only. This is enabled by default to not allow Camel to write files to outside directories (to be more secured out of the box). You can turn this off to allow writing files to directories outside the starting directory, such as parent or root folders.|true|boolean|
|moveExisting|Expression (such as File Language) used to compute file name to use when fileExist=Move is configured. To move files into a backup subdirectory just enter backup. This option only supports the following File Language tokens: file:name, file:name.ext, file:name.noext, file:onlyname, file:onlyname.noext, file:ext, and file:parent. Notice the file:parent is not supported by the FTP component, as the FTP component can only move any existing files to a relative directory based on current dir as base.||string|
|tempFileName|The same as tempPrefix option but offering a more fine grained control on the naming of the temporary filename as it uses the File Language. The location for tempFilename is relative to the final file location in the option 'fileName', not the target directory in the base uri. For example if option fileName includes a directory prefix: dir/finalFilename then tempFileName is relative to that subdirectory dir.||string|
|tempPrefix|This option is used to write the file using a temporary name and then, after the write is complete, rename it to the real name. Can be used to identify files being written and also avoid consumers (not using exclusive read locks) reading in progress files. Is often used by FTP when uploading big files.||string|
|allowNullBody|Used to specify if a null body is allowed during file writing. If set to true then an empty file will be created, when set to false, and attempting to send a null body to the file component, a GenericFileWriteException of 'Cannot write null body to file.' will be thrown. If the fileExist option is set to 'Override', then the file will be truncated, and if set to append the file will remain unchanged.|false|boolean|
|chmod|Specify the file permissions which is sent by the producer, the chmod value must be between 000 and 777; If there is a leading digit like in 0755 we will ignore it.||string|
|chmodDirectory|Specify the directory permissions used when the producer creates missing directories, the chmod value must be between 000 and 777; If there is a leading digit like in 0755 we will ignore it.||string|
|eagerDeleteTargetFile|Whether or not to eagerly delete any existing target file. This option only applies when you use fileExists=Override and the tempFileName option as well. You can use this to disable (set it to false) deleting the target file before the temp file is written. For example you may write big files and want the target file to exists during the temp file is being written. This ensure the target file is only deleted until the very last moment, just before the temp file is being renamed to the target filename. This option is also used to control whether to delete any existing files when fileExist=Move is enabled, and an existing file exists. If this option copyAndDeleteOnRenameFails false, then an exception will be thrown if an existing file existed, if its true, then the existing file is deleted before the move operation.|true|boolean|
|forceWrites|Whether to force syncing writes to the file system. You can turn this off if you do not want this level of guarantee, for example if writing to logs / audit logs etc; this would yield better performance.|true|boolean|
|keepLastModified|Will keep the last modified timestamp from the source file (if any). Will use the FileConstants.FILE\_LAST\_MODIFIED header to located the timestamp. This header can contain either a java.util.Date or long with the timestamp. If the timestamp exists and the option is enabled it will set this timestamp on the written file. Note: This option only applies to the file producer. You cannot use this option with any of the ftp producers.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|moveExistingFileStrategy|Strategy (Custom Strategy) used to move file with special naming token to use when fileExist=Move is configured. By default, there is an implementation used if no custom strategy is provided||object|
|autoCreate|Automatically create missing directories in the file's pathname. For the file consumer, that means creating the starting directory. For the file producer, it means the directory the files should be written to.|true|boolean|
|bufferSize|Buffer size in bytes used for writing files (or in case of FTP for downloading and uploading files).|131072|integer|
|copyAndDeleteOnRenameFail|Whether to fallback and do a copy and delete file, in case the file could not be renamed directly. This option is not available for the FTP component.|true|boolean|
|renameUsingCopy|Perform rename operations using a copy and delete strategy. This is primarily used in environments where the regular rename operation is unreliable (e.g. across different file systems or networks). This option takes precedence over the copyAndDeleteOnRenameFail parameter that will automatically fall back to the copy and delete strategy, but only after additional delays.|false|boolean|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|antExclude|Ant style filter exclusion. If both antInclude and antExclude are used, antExclude takes precedence over antInclude. Multiple exclusions may be specified in comma-delimited format.||string|
|antFilterCaseSensitive|Sets case sensitive flag on ant filter.|true|boolean|
|antInclude|Ant style filter inclusion. Multiple inclusions may be specified in comma-delimited format.||string|
|eagerMaxMessagesPerPoll|Allows for controlling whether the limit from maxMessagesPerPoll is eager or not. If eager then the limit is during the scanning of files. Where as false would scan all files, and then perform sorting. Setting this option to false allows for sorting all files first, and then limit the poll. Mind that this requires a higher memory usage as all file details are in memory to perform the sorting.|true|boolean|
|exclude|Is used to exclude files, if filename matches the regex pattern (matching is case in-sensitive). Notice if you use symbols such as plus sign and others you would need to configure this using the RAW() syntax if configuring this as an endpoint uri. See more details at configuring endpoint uris||string|
|excludeExt|Is used to exclude files matching file extension name (case insensitive). For example to exclude bak files, then use excludeExt=bak. Multiple extensions can be separated by comma, for example to exclude bak and dat files, use excludeExt=bak,dat. Note that the file extension includes all parts, for example having a file named mydata.tar.gz will have extension as tar.gz. For more flexibility then use the include/exclude options.||string|
|filter|Pluggable filter as a org.apache.camel.component.file.GenericFileFilter class. Will skip files if filter returns false in its accept() method.||object|
|filterDirectory|Filters the directory based on Simple language. For example to filter on current date, you can use a simple date pattern such as ${date:now:yyyMMdd}||string|
|filterFile|Filters the file based on Simple language. For example to filter on file size, you can use ${file:size} 5000||string|
|idempotent|Option to use the Idempotent Consumer EIP pattern to let Camel skip already processed files. Will by default use a memory based LRUCache that holds 1000 entries. If noop=true then idempotent will be enabled as well to avoid consuming the same files over and over again.|false|boolean|
|idempotentEager|Option to use the Idempotent Consumer EIP pattern to let Camel skip already processed files. Will by default use a memory based LRUCache that holds 1000 entries. If noop=true then idempotent will be enabled as well to avoid consuming the same files over and over again.|false|boolean|
|idempotentKey|To use a custom idempotent key. By default the absolute path of the file is used. You can use the File Language, for example to use the file name and file size, you can do: idempotentKey=${file:name}-${file:size}||string|
|idempotentRepository|A pluggable repository org.apache.camel.spi.IdempotentRepository which by default use MemoryIdempotentRepository if none is specified and idempotent is true.||object|
|include|Is used to include files, if filename matches the regex pattern (matching is case in-sensitive). Notice if you use symbols such as plus sign and others you would need to configure this using the RAW() syntax if configuring this as an endpoint uri. See more details at configuring endpoint uris||string|
|includeExt|Is used to include files matching file extension name (case insensitive). For example to include txt files, then use includeExt=txt. Multiple extensions can be separated by comma, for example to include txt and xml files, use includeExt=txt,xml. Note that the file extension includes all parts, for example having a file named mydata.tar.gz will have extension as tar.gz. For more flexibility then use the include/exclude options.||string|
|maxDepth|The maximum depth to traverse when recursively processing a directory.|2147483647|integer|
|maxMessagesPerPoll|To define a maximum messages to gather per poll. By default no maximum is set. Can be used to set a limit of e.g. 1000 to avoid when starting up the server that there are thousands of files. Set a value of 0 or negative to disabled it. Notice: If this option is in use then the File and FTP components will limit before any sorting. For example if you have 100000 files and use maxMessagesPerPoll=500, then only the first 500 files will be picked up, and then sorted. You can use the eagerMaxMessagesPerPoll option and set this to false to allow to scan all files first and then sort afterwards.||integer|
|minDepth|The minimum depth to start processing when recursively processing a directory. Using minDepth=1 means the base directory. Using minDepth=2 means the first sub directory.||integer|
|move|Expression (such as Simple Language) used to dynamically set the filename when moving it after processing. To move files into a .done subdirectory just enter .done.||string|
|exclusiveReadLockStrategy|Pluggable read-lock as a org.apache.camel.component.file.GenericFileExclusiveReadLockStrategy implementation.||object|
|readLock|Used by consumer, to only poll the files if it has exclusive read-lock on the file (i.e. the file is not in-progress or being written). Camel will wait until the file lock is granted. This option provides the build in strategies: - none - No read lock is in use - markerFile - Camel creates a marker file (fileName.camelLock) and then holds a lock on it. This option is not available for the FTP component - changed - Changed is using file length/modification timestamp to detect whether the file is currently being copied or not. Will at least use 1 sec to determine this, so this option cannot consume files as fast as the others, but can be more reliable as the JDK IO API cannot always determine whether a file is currently being used by another process. The option readLockCheckInterval can be used to set the check frequency. - fileLock - is for using java.nio.channels.FileLock. This option is not avail for Windows OS and the FTP component. This approach should be avoided when accessing a remote file system via a mount/share unless that file system supports distributed file locks. - rename - rename is for using a try to rename the file as a test if we can get exclusive read-lock. - idempotent - (only for file component) idempotent is for using a idempotentRepository as the read-lock. This allows to use read locks that supports clustering if the idempotent repository implementation supports that. - idempotent-changed - (only for file component) idempotent-changed is for using a idempotentRepository and changed as the combined read-lock. This allows to use read locks that supports clustering if the idempotent repository implementation supports that. - idempotent-rename - (only for file component) idempotent-rename is for using a idempotentRepository and rename as the combined read-lock. This allows to use read locks that supports clustering if the idempotent repository implementation supports that.Notice: The various read locks is not all suited to work in clustered mode, where concurrent consumers on different nodes is competing for the same files on a shared file system. The markerFile using a close to atomic operation to create the empty marker file, but its not guaranteed to work in a cluster. The fileLock may work better but then the file system need to support distributed file locks, and so on. Using the idempotent read lock can support clustering if the idempotent repository supports clustering, such as Hazelcast Component or Infinispan.|none|string|
|readLockCheckInterval|Interval in millis for the read-lock, if supported by the read lock. This interval is used for sleeping between attempts to acquire the read lock. For example when using the changed read lock, you can set a higher interval period to cater for slow writes. The default of 1 sec. may be too fast if the producer is very slow writing the file. Notice: For FTP the default readLockCheckInterval is 5000. The readLockTimeout value must be higher than readLockCheckInterval, but a rule of thumb is to have a timeout that is at least 2 or more times higher than the readLockCheckInterval. This is needed to ensure that ample time is allowed for the read lock process to try to grab the lock before the timeout was hit.|1000|integer|
|readLockDeleteOrphanLockFiles|Whether or not read lock with marker files should upon startup delete any orphan read lock files, which may have been left on the file system, if Camel was not properly shutdown (such as a JVM crash). If turning this option to false then any orphaned lock file will cause Camel to not attempt to pickup that file, this could also be due another node is concurrently reading files from the same shared directory.|true|boolean|
|readLockIdempotentReleaseAsync|Whether the delayed release task should be synchronous or asynchronous. See more details at the readLockIdempotentReleaseDelay option.|false|boolean|
|readLockIdempotentReleaseAsyncPoolSize|The number of threads in the scheduled thread pool when using asynchronous release tasks. Using a default of 1 core threads should be sufficient in almost all use-cases, only set this to a higher value if either updating the idempotent repository is slow, or there are a lot of files to process. This option is not in-use if you use a shared thread pool by configuring the readLockIdempotentReleaseExecutorService option. See more details at the readLockIdempotentReleaseDelay option.||integer|
|readLockIdempotentReleaseDelay|Whether to delay the release task for a period of millis. This can be used to delay the release tasks to expand the window when a file is regarded as read-locked, in an active/active cluster scenario with a shared idempotent repository, to ensure other nodes cannot potentially scan and acquire the same file, due to race-conditions. By expanding the time-window of the release tasks helps prevents these situations. Note delaying is only needed if you have configured readLockRemoveOnCommit to true.||integer|
|readLockIdempotentReleaseExecutorService|To use a custom and shared thread pool for asynchronous release tasks. See more details at the readLockIdempotentReleaseDelay option.||object|
|readLockLoggingLevel|Logging level used when a read lock could not be acquired. By default a DEBUG is logged. You can change this level, for example to OFF to not have any logging. This option is only applicable for readLock of types: changed, fileLock, idempotent, idempotent-changed, idempotent-rename, rename.|DEBUG|object|
|readLockMarkerFile|Whether to use marker file with the changed, rename, or exclusive read lock types. By default a marker file is used as well to guard against other processes picking up the same files. This behavior can be turned off by setting this option to false. For example if you do not want to write marker files to the file systems by the Camel application.|true|boolean|
|readLockMinAge|This option is applied only for readLock=changed. It allows to specify a minimum age the file must be before attempting to acquire the read lock. For example use readLockMinAge=300s to require the file is at last 5 minutes old. This can speedup the changed read lock as it will only attempt to acquire files which are at least that given age.|0|integer|
|readLockMinLength|This option is applied only for readLock=changed. It allows you to configure a minimum file length. By default Camel expects the file to contain data, and thus the default value is 1. You can set this option to zero, to allow consuming zero-length files.|1|integer|
|readLockRemoveOnCommit|This option is applied only for readLock=idempotent. It allows to specify whether to remove the file name entry from the idempotent repository when processing the file is succeeded and a commit happens. By default the file is not removed which ensures that any race-condition do not occur so another active node may attempt to grab the file. Instead the idempotent repository may support eviction strategies that you can configure to evict the file name entry after X minutes - this ensures no problems with race conditions. See more details at the readLockIdempotentReleaseDelay option.|false|boolean|
|readLockRemoveOnRollback|This option is applied only for readLock=idempotent. It allows to specify whether to remove the file name entry from the idempotent repository when processing the file failed and a rollback happens. If this option is false, then the file name entry is confirmed (as if the file did a commit).|true|boolean|
|readLockTimeout|Optional timeout in millis for the read-lock, if supported by the read-lock. If the read-lock could not be granted and the timeout triggered, then Camel will skip the file. At next poll Camel, will try the file again, and this time maybe the read-lock could be granted. Use a value of 0 or lower to indicate forever. Currently fileLock, changed and rename support the timeout. Notice: For FTP the default readLockTimeout value is 20000 instead of 10000. The readLockTimeout value must be higher than readLockCheckInterval, but a rule of thumb is to have a timeout that is at least 2 or more times higher than the readLockCheckInterval. This is needed to ensure that ample time is allowed for the read lock process to try to grab the lock before the timeout was hit.|10000|integer|
|backoffErrorThreshold|The number of subsequent error polls (failed due some error) that should happen before the backoffMultipler should kick-in.||integer|
|backoffIdleThreshold|The number of subsequent idle polls that should happen before the backoffMultipler should kick-in.||integer|
|backoffMultiplier|To let the scheduled polling consumer backoff if there has been a number of subsequent idles/errors in a row. The multiplier is then the number of polls that will be skipped before the next actual attempt is happening again. When this option is in use then backoffIdleThreshold and/or backoffErrorThreshold must also be configured.||integer|
|delay|Milliseconds before the next poll.|500|integer|
|greedy|If greedy is enabled, then the ScheduledPollConsumer will run immediately again, if the previous run polled 1 or more messages.|false|boolean|
|initialDelay|Milliseconds before the first poll starts.|1000|integer|
|repeatCount|Specifies a maximum limit of number of fires. So if you set it to 1, the scheduler will only fire once. If you set it to 5, it will only fire five times. A value of zero or negative means fire forever.|0|integer|
|runLoggingLevel|The consumer logs a start/complete log line when it polls. This option allows you to configure the logging level for that.|TRACE|object|
|scheduledExecutorService|Allows for configuring a custom/shared thread pool to use for the consumer. By default each consumer has its own single threaded thread pool.||object|
|scheduler|To use a cron scheduler from either camel-spring or camel-quartz component. Use value spring or quartz for built in scheduler|none|object|
|schedulerProperties|To configure additional properties when using a custom scheduler or any of the Quartz, Spring based scheduler.||object|
|startScheduler|Whether the scheduler should be auto started.|true|boolean|
|timeUnit|Time unit for initialDelay and delay options.|MILLISECONDS|object|
|useFixedDelay|Controls if fixed delay or fixed rate is used. See ScheduledExecutorService in JDK for details.|true|boolean|
|shuffle|To shuffle the list of files (sort in random order)|false|boolean|
|sortBy|Built-in sort by using the File Language. Supports nested sorts, so you can have a sort by file name and as a 2nd group sort by modified date.||string|
|sorter|Pluggable sorter as a java.util.Comparator class.||object|
