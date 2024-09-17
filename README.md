# Camel Upstream Info

Repository with Apache Camel information in markdown format for usage with InstructLab.

Use the following commands to update the documentation from the latest dataset:

```shell
make fetch-all
```

When using it with Camel JBang AI for training a new model, you must also ensure that
the component dataset is available. For that, use the following command:

```shell
make fetch-all
```