# Ticket-Monster Docker Swarm Cluster



This project contains several images that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server.

The pieces of this demo are:

- Wildfly 9.x Application Server (Standalone mode) + Ticket Monster application - [Dockerfile](../Dockerfiles/ticketmonster-ha/Dockerfile)
- Postgres 9.x Database Server - [Docker image](https://hub.docker.com/_/postgres/)
- Apache HTTPD + mod_cluster (Without Server advertisement) - [Dockerfile](https://hub.docker.com/r/karm/mod_cluster-master-dockerhub/)


This is an alternative path for running [a "docker only" example](../Dockerfiles/ticketmonster) using [docker-swarm](http://docs.docker.com/swarm).

## Running the images

1. Create the Swarm nodes - This script creates a Swarm Cluster with Multi hosting network enabled.

  Execute:

      ./swarm-create.sh


2. Connect on cluster.

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

4. Create an Overlay network.

  Execute

      docker network create --driver overlay mynet

5. Start the containers.

  Execute


      cd ../compose
      docker-compose pull
      docker-compose  up -d

6. Verify how the cluster was deployed.

  Execute

      docker ps

7. Check /mcm (mod_cluster manager).

  Execute
  
      open http://`docker-compose port modcluster 80`/mcm

8. Scale the Wildfly server.

  Execute:

      docker-compose scale wildfly=3

9. Check the logs.

  Execute:

      docker-compose logs

10. Access the application.

  Execute:

      open http://`docker-compose port modcluster 80`/ticket-monster/  

11. Reduce the quantity of servers.

  Execute:

      docker-compose scale wildfly=2


12. Stop the cluster.

  Execute:

      docker-compose stop
      docker-compose rm

13. Destroy de cluster.

  Execute:
  
      cd ../swarm
      ./swarm-destroy.sh


## Running Swarm at AWS

1. Create a IAM user.

  - Log in https://console.aws.amazon.com/iam/ and create a user and group.
  - Take notes of `Access Key ID` and `Secret Access Key`.
  - Give the group the `AmazonEC2FullAccess` permission.
  - Assign the group to the newly created user.
  
2. Create a VPC.

  - Log in https://console.aws.amazon.com/vpc/
  - Click on `VPC Wizard`.
  - Select `VPC with a Single Public Subnet` and click `Select`.
  - Give it a name and create the VPC with the default options.
  - Take notes of the VPC id
  
3. Setup the environment variables

  Execute:
  
      export AWS_ACCESS_KEY_ID=<Access Key ID>
      export AWS_SECRET_ACCESS_KEY=<Secret Access Key>
      export AWS_VPC_ID=<VPC id>

4. Create the cluster in AWS

  Execute:
  
      ./swarm-create-aws.sh

 - When asked to setup the 'docker-machine' group inbound rules, go to https://console.aws.amazon.com/ec2/ and open ALL TCP, UDP and ICMP ports.
 
5. Connect on cluster.

  Execute:

      eval "$(docker-machine env --swarm aws-swarm-master)"


6. Continue at Step 3. at the main instructions.