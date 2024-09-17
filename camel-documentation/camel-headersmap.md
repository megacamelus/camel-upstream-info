# Headersmap.md

**Since Camel 2.20**

The Headersmap component is a faster implementation of a
case-insensitive map which can be plugged in and used by Camel at
runtime to have slight faster performance in the Camel Message headers.

# Usage

## Auto-detection from classpath

To use this implementation all you need to do is to add the
`camel-headersmap` dependency to the classpath, and Camel should
auto-detect this on startup and log as follows:

    Detected and using HeadersMapFactory: camel-headersmap
