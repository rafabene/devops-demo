# Ticket-Monster Docker Swarm Cluster



This project contains several images that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server.

The pieces of this demo are:

- Wildfly 8.x Application Server (Standalone mode) + Ticket Monster application
- Postgres 9.x Database Server


This is an alternative path for running [a "docker only" example](../Dockerfiles/ticketmonster) using [docker-swarm](http://docs.docker.com/swarm).

## Running the images

1. Create the Swarm nodes

  Execute:

      ./swarm-create.sh


2. Connect on cluster

  Execute:

      eval "$(docker-machine env --swarm swarm-master)"


3. Verify if the cluster is up.

  Execute:

      docker info

  The following output will be shown:
```
    Containers: 4
    Images: 3
    Role: primary
    Strategy: spread
    Filters: affinity, health, constraint, port, dependency
    Nodes: 3
     swarm-master: 192.168.99.103:2376
      └ Containers: 2
      └ Reserved CPUs: 0 / 1
      └ Reserved Memory: 0 B / 1.022 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=4.0.5-boot2docker, operatingsystem=Boot2Docker 1.7.0 (TCL 6.3); master : 7960f90 - Thu Jun 18 18:31:45 UTC 2015, provider=virtualbox, storagedriver=aufs
     swarm-node-01: 192.168.99.104:2376
      └ Containers: 1
      └ Reserved CPUs: 0 / 1
      └ Reserved Memory: 0 B / 1.022 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=4.0.5-boot2docker, operatingsystem=Boot2Docker 1.7.0 (TCL 6.3); master : 7960f90 - Thu Jun 18 18:31:45 UTC 2015, provider=virtualbox, storagedriver=aufs
     swarm-node-02: 192.168.99.105:2376
      └ Containers: 1
      └ Reserved CPUs: 0 / 1
      └ Reserved Memory: 0 B / 1.022 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=4.0.5-boot2docker, operatingsystem=Boot2Docker 1.7.0 (TCL 6.3); master : 7960f90 - Thu Jun 18 18:31:45 UTC 2015, provider=virtualbox, storagedriver=aufs
    CPUs: 3
    Total Memory: 3.065 GiB
```

4. Start the containers

  Execute 

     docker-compose up -d

5. Verify how the cluster was deployed

  Execute

    docker ps

6. Scale the Wildfly server.

  Execute:

      docker-compose scale wildfly=5

6. Check the logs.

  Execute:
  
      docker-compose logs

7. Access the application

  Execute:

      open http://127.0.0.1/ticket-monster/  #For Linux containers
      open http://`boot2docker ip`/ticket-monster/  #For boot2docker containers

8. Reduce the quantity of servers

  Execute:

      docker-compose scale wildfly=2


9. Stop the cluster

  Execute:

      docker-compose stop
      docker-compose rm

