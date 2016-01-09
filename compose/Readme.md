# Ticket-Monster Docker HA Cluster using Compose



This project contains several images that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server.

The pieces of this demo are:

- Wildfly 9.x Application Server (Standalone mode) + Ticket Monster application - [Dockerfile](../Dockerfiles/ticketmonster-ha/Dockerfile)
- Postgres 9.x Database Server - [Docker image](https://hub.docker.com/_/postgres/)
- Apache HTTPD + mod_cluster (Using Server advertisement) - [Dockerfile](https://hub.docker.com/r/karm/mod_cluster-master-dockerhub/)

This is an alternative path for running [a "docker only" example](../Dockerfiles/ticketmonster) using [docker-compose](http://docs.docker.com/compose).

## Running the images


1. Create a network (if it doesn't exist)

  Execute:
  
    docker network create mynet

2. Start the containers.

  Execute:

      docker-compose up -d


2. Check /mcm (mod_cluster manager).

  Before starting the Wildfly servers, open /mcm that was exposed on port 80 in the previous step[3]

  Execute:

      open http://127.0.0.1/mcm  #For Linux containers
      active=`docker-machine active`; open http://`docker-machine ip $active`/mcm  #For docker-machine containers

  Click on `Auto Refresh` link.

3. Check at /mcm page that Wildfly was registered at modcluster.

4. Scale the Wildfly server.

  Execute:

      docker-compose scale wildfly=3

5. Verify that more servers were included at /mcm (mod_cluster manager).

6. Check the logs.

  Execute:

      docker-compose logs

7. Access the application.

  Execute:

      open http://127.0.0.1/ticket-monster/  #For Linux containers
      active=`docker-machine active`; open http://`docker-machine ip $active`/ticket-monster  #For docker-machine containers

8. Reduce the quantity of servers.

  Execute:

      docker-compose scale wildfly=2


9. Stop the cluster.

  Execute:

      docker-compose stop
      docker-compose rm

