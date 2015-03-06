Ticket-Monster HA Cluster using Containers
------------------------------------------


This project contains several images that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server.

You can use [Docker](https://www.docker.com/) or [Kubernetes](http://kubernetes.io/).

The pieces of this demo are:

- Wildfly 8.x Application Server (Domain mode)
- Postgres 9.x Database Server
- Ticket Monster application (Slave)
- Apache HTTPD + mod_cluster

==================================

To run this demo on raw Docker, check [Readme-Docker.md](Readme-Docker.md)

To run this demo on a Kubernetes Cluster, check [Readme-Kubernetes.md](Readme-Kubernetes.md)
