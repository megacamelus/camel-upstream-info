# Resourceresolver-github.md

**Since Camel 3.11**

A pluggable resource resolver that allows to load files from GitHub over
the internet via `https` protocol.

The syntax is

    github:organization:repository:branch:filename

The default branch is `main` so if you want to load from this branch,
you can use a shorter syntax

    github:organization:repository:name

For example to load:
`https://github.com/apache/camel-kamelets/blob/main/kamelets/aws-ddb-streams-source.kamelet.yaml`

    github:apache:camel-kamelets:main:kamelets/aws-ddb-streams-source.kamelet.yaml

Because the file is in the main branch, we can omit this:

    github:apache:camel-kamelets:kamelets/aws-ddb-streams-source.kamelet.yaml

This resource resolver can potentially load any resources from GitHub
that are in public repositories. It’s not recommended for production
usage but is great for development and demo purposes.

# Resolving from gist

You can also load resources from gist

The syntax is

    gist:user:id:cid:fileName

For example:

    gist:davsclaus:477ddff5cdeb1ae03619aa544ce47e92:cd1be96034748e42e43879a4d27ed297752b6115:mybeer.xml
