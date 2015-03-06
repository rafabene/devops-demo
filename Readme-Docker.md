Ticket-Monster Docker HA Cluster
--------------------------------


This project contains several images that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server.

The pieces of this demo are:

- Wildfly 8.x Application Server (Domain mode)
- Postgres 9.x Database Server
- Ticket Monster application
- Apache HTTPD + mod_cluster

Running the images
==================

Before start, make sure you have the latest version of the images used on this Demo.

Execute:

    docker pull rafabene/wildfly-ticketmonster-domain
    docker pull rafabene/wildfly-ticketmonster-server
    


1. Start the postgres server container

Execute:

    docker run --name db -d -p 5432:5432 -e POSTGRES_USER=ticketmonster -e POSTGRES_PASSWORD=ticketmonster-docker postgres
    

2. Start the Wildfly Domain conroller

Execute:

    docker run -Pd --name domain rafabene/wildfly-ticketmonster-domain
    

3. Start the Apache httpd + modcluster

Execute:

    docker run -d --name modcluster -p 80:80 goldmann/mod_cluster
    

4. Check /mod_cluster_manager

Before starting the Wildfly servers, open /mod_cluster_manager that was exposed on port 80 in the previous step[3]

Execute:

    open http://127.0.0.1/mod_cluster_manager  #For Linux containers
    open http://`boot2docker ip`/mod_cluster_manager  #For boot2docker containers

6. Start the Wildfly server

Execute:

    docker run -d --name server1 --link db:db --link modcluster:modcluster --link domain:domain rafabene/wildfly-ticketmonster-server
    

7. Check at /mod_cluster_manager page that Wildfly was registered at modcluster

8. You can create as many wildfly instances you want

Execute:

    docker run -d --name server1 --link db:db --link modcluster:modcluster --link domain:domain rafabene/wildfly-ticketmonster-server
    docker run -d --name server2 --link db:db --link modcluster:modcluster --link domain:domain rafabene/wildfly-ticketmonster-server
    docker run -d --name server3 --link db:db --link modcluster:modcluster --link domain:domain rafabene/wildfly-ticketmonster-server
    

9. Access the application

Execute:

    open http://127.0.0.1/ticket-monster/  #For Linux containers
    open http://`boot2docker ip`/ticket-monster/  #For boot2docker containers

10. You can stop some servers and check the application behaviour

Execute:

    docker stop server1
    docker stop server2
