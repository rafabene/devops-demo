# Ticket-Monster Docker HA Cluster using Compose



This project contains several images that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server.

The pieces of this demo are:

- Wildfly 9.x Application Server (Standalone mode) + Ticket Monster application - [Dockerfile](../DockerFiles/ticketmonster/Dockerfile)
- Postgres 9.x Database Server - [Docker image](https://hub.docker.com/_/postgres/)
- Apache HTTPD + mod_cluster (Using Server advertisement) - [Dockerfile](../DockerFiles/mod_cluster/Dockerfile)

This is an alternative path for running [a "docker only" example](../Dockerfiles/ticketmonster) using [docker-compose](http://docs.docker.com/compose).

## Running the images


1. Start the containers.

  Execute:

      docker-compose up -d


2. Check /mod_cluster_manager.

  Before starting the Wildfly servers, open /mod_cluster_manager that was exposed on port 80 in the previous step[3]

  Execute:

      open http://127.0.0.1/mod_cluster_manager  #For Linux containers
      active=`docker-machine active`; open http://`docker-machine ip $active`/mod_cluster_manager  #For docker-machine containers

  Click on `Auto Refresh` link.

3. Check at /mod_cluster_manager page that Wildfly was registered at modcluster.

4. Scale the Wildfly server.

  Execute:

      docker-compose scale wildfly=5

5. Verify that more servers were included at /mod_cluster_manager.

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

