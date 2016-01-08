# Ticket-Monster Docker HA Cluster



This project contains several images that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server.

The pieces of this demo are:

- Wildfly 9.x Application Server (Standalone mode) + Ticket Monster application - [Dockerfile](Dockerfile)
- Postgres 9.x Database Server - [Docker image](https://hub.docker.com/_/postgres/)
- Apache HTTPD + mod_cluster (Using Server advertisement) - [Dockerfile](../mod_cluster/Dockerfile)

## Running the images


Before start, make sure you have the latest version of the images used on this Demo.

Execute:

    docker pull rafabene/wildfly-ticketmonster



1. Start the postgres server container.

  Execute:

      docker run --name db -d -p 5432:5432 -e POSTGRES_USER=ticketmonster -e POSTGRES_PASSWORD=ticketmonster-docker postgres



2. Start the Apache httpd + modcluster.

  Execute:

      docker run -d --name modcluster -p 80:80 rafabene/mod_cluster


3. Check /mod_cluster_manager.

  Before starting the Wildfly servers, open /mod_cluster_manager that was exposed on port 80 in the previous step[3]

  Execute:

      open http://127.0.0.1/mod_cluster_manager  #For Linux containers
      active=`docker-machine active`; open http://`docker-machine ip $active`/mod_cluster_manager  #For docker-machine containers

  Click on `Auto Refresh` link.

4. Start the Wildfly server.

  Execute:

      docker run -d --name server1 --link db:db --link modcluster:modcluster rafabene/wildfly-ticketmonster-ha


5. Check at /mod_cluster_manager page that Wildfly was registered at modcluster.

6. You can create as many wildfly instances you want.

  Execute:

      docker run -d --name server2 --link db:db --link modcluster:modcluster rafabene/wildfly-ticketmonster-ha
      docker run -d --name server3 --link db:db --link modcluster:modcluster rafabene/wildfly-ticketmonster-ha

9. Access the application.

  Execute:

      open http://127.0.0.1/ticket-monster/  #For Linux containers
      active=`docker-machine active`; open http://`docker-machine ip $active`/ticket-monster  #For docker-machine containers


10. You can stop some servers and check the application behaviour.

  Execute:

      docker stop server1
      docker stop server2

11. Clean up all containers.

  Execute:

      docker rm -f `docker ps -aq`

## Ways to update Ticket-Monster version on a running container


_Note: This is shown here for learning purposes. This approach is not recommended because the changes are not persisted and the updated version will be lost if the container is restarted._

With the WildFly server you can deploy your application in multiple ways:

- You can use CLI
- You can use the web console
- You can use the deployment scanner

Remember to start the container exposing the port 9990.

  Execute:

    docker run -d --name server1 --link db:db -p 9990 --link modcluster:modcluster rafabene/wildfly-ticketmonster


Realize that we don't specify the host port and we let docker assign the port itself. This will avoid port colissions if running more than one WildFly instance in the same docker host.
You can query the docker host port associated with the running WilDFly container by executing:

    docker port server1


You can check if the deployment worked by checking the container log:

    docker logs -f server1


### Using the CLI

If you have a local installation of WildFly, go to it's bin/ folder and run `jboss-cli` to connect to the running WildFly docker container.
_NOTE: The usernmame and password credentials were set in the Docker image: <https://github.com/rafabene/devops-demo/blob/master/ticketmonster-dockerfile/Dockerfile#L7>_

    cd $WIDLFY_HOME/bin
    ./jboss-cli.sh --controller=<DOCKER_HOST>:<HOST_PORT>  -u=admin -p=docker#admin -c

You can also use the `docker inspect` command to get the docker host port for 9990:

    ./jboss-cli.sh --controller=localhost:`docker inspect --format='{{$map := index .NetworkSettings.Ports "9990/tcp"}}{{$result := index $map 0}}{{$result.HostPort}}' server1` -u=admin -p=docker#admin -c #For Linux containers
    active=`docker-machine active`; ./jboss-cli.sh --controller=`docker-machine ip $active`:`docker inspect --format='{{$map := index .NetworkSettings.Ports "9990/tcp"}}{{$result := index $map 0}}{{$result.HostPort}}' server1` -u='admin' -p='docker#admin' -c #For docker-machine containers

Once that you're connected through `jboss-cli`, run:

    deploy <TICKET_MONSTER_PATH>/ticket-monster.war --force


### Using the web console


_NOTE: The usernmame and password credentials were set in the Docker image: <https://github.com/rafabene/devops-demo/blob/master/Dockerfiles/widlfly-admin/Dockerfile#L6-L7>_

- Go to the container administration web console in a web browser.
- Log in with the following credentials: username: admin / password: docker#admin .
- Go to the "Deployments tab".
- Click on "Replace" button.
- On the "Step 1/2" screen, select the ticket-monster.war file on your computer and click "Next".
- On the "Step 2/2" screen, click "Next" again.

At this moment the new ticket-monster version should be deployed

### Use the deployment scanner

Here we can use two approachs:

#### Option 1: WildFly containers that already have applications deployed

To modify the content inside a running WildFly container that already have applications deployer, you will need to mount a volume from the docker container in the docker host.

In this example we will use the following host directory: `~/wildfly-deploy`

First, we will need to start the containers mapping this directory `~/wildfly-deploy` to `/tmp/deploy` inside the container

    docker run -d --name server1 --link db:db --link modcluster:modcluster -v ~/wildfy-deploy:/tmp/deploy rafabene/wildfly-ticketmonster


Then, copy the ticker-monster.war to `~/wildfly-deploy`

    cp ticket-monster.war ~/wildfy-deploy/



Finally execute a `mv` command inside the running container to move `/tmp/deploy/ticket-monster.war` to `/opt/jboss/wildfly/standalone/deployments/`

    docker exec -it server1 /bin/bash -c 'mv /tmp/deploy/ticket-monster.war /opt/jboss/wildfly/standalone/deployments/'


