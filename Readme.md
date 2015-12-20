Ticket-Monster HA Cluster using Containers
------------------------------------------


This project contains images and files that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server.

You can use [Docker](https://www.docker.com/), [Kubernetes](http://kubernetes.io/) or [Openshift](https://www.openshift.org/).

More info: http://rafabene.com/2015/12/15/docker-learning-path-wildfly/

The pieces of this demo are:

- Wildfly 9.x Application Server + Ticket Monster application
- Postgres 9.x Database Server
- Apache HTTPD + mod_cluster

![](http://rafabene.com/images/docker_mod_cluster.png)

==================================

To run this demo on raw Docker, check [Docker image Readme.md](Dockerfiles/ticketmonster/Readme.md)

To run this demo using Docker Compose, check [Docker Compose Readme.md](compose/Readme.md)

To run this demo on a Docker Swarm Cluster, check [Docker Swarm Readme.md](swarm/Readme.md)

To run this demo on a Kubernetes Cluster, check [Kubernetes Readme.md](kubernetes/Readme.md)

To run this demo on Openshift, check [Openshift Readme.md](openshift/Readme.md)
