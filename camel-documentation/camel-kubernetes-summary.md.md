# Kubernetes-summary.md

**Since Camel 2.17**

The Kubernetes components integrate your application with Kubernetes
standalone or on top of Openshift.

# Kubernetes components

See the following for usage of each component:

indexDescriptionList::\[attributes=*group=Kubernetes*,descriptionformat=description\]

# Installation

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-kubernetes</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Usage

## Producer examples

Here we show some examples of producer using camel-kubernetes.

## Create a pod

    from("direct:createPod")
        .toF("kubernetes-pods://%s?oauthToken=%s&operation=createPod", host, authToken);

By using the `KubernetesConstants.KUBERNETES_POD_SPEC` header, you can
specify your PodSpec and pass it to this operation.

## Delete a pod

    from("direct:createPod")
        .toF("kubernetes-pods://%s?oauthToken=%s&operation=deletePod", host, authToken);

By using the `KubernetesConstants.KUBERNETES_POD_NAME` header, you can
specify your Pod name and pass it to this operation.

# Using Kubernetes ConfigMaps and Secrets

The `camel-kubernetes` component also provides [Property
Placeholder](#manual:ROOT:using-propertyplaceholder.adoc) functions that
load the property values from Kubernetes *ConfigMaps* or *Secrets*.

For more information, see [Property
Placeholder](#manual:ROOT:using-propertyplaceholder.adoc).
