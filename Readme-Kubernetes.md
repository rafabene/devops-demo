Ticket-Monster Kubernetes HA Cluster
--------------------------------


This project contains Pods that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server inside a [Kubernetes](http://kubernetes.io/) Cluster

The pieces of this demo are:

- Wildfly 8.x Application Server (Domain mode)
    - POD
    - Services
- Postgres 9.x Database Server
    -POD
    - Services
- Ticket Monster application
    - POD
- Apache HTTPD + mod_cluster 
    - POD 
    - Services

Running the Kubernetes Cluster
==============================

Start you Kubernetes Cluster. For more informaton about creating the Kubernetes Cluster, take a look on its [Kubernetes Getting Started Guide](http://kubernetes.io/gettingstarted/)

1. Check the numbers of minions available and what pods are running

Execute:

    cluster/kubectl.sh get minions
    cluster/kubectl.sh get pods
    

2. Install the Postgres POD and Service

Execute:

    cluster/kubectl.sh create -f <PATH TO THIS DEMO>/postgres.json
    cluster/kubectl.sh create -f <PATH TO THIS DEMO>/postgres-service.json
    

3. Install the Wildfly Domain controller POD and Service

Execute:

    cluster/kubectl.sh create -f <PATH TO THIS DEMO>/wildfly-domain.json
    cluster/kubectl.sh create -f <PATH TO THIS DEMO>/wildfly-domain-service.json
    

You can check the Wildfly log by running the log command on the POD.
First get the pod name:

    cluster/kubectl.sh get pods
    

Observe the pod name. It will be something like wildfly-domain-rc-?????.

_Note: If the Status is "Pending", wait until the POD download the docker image._
You can check the cause of "Pending" by running:
  
    cluster/kubectl.sh get pod wildfly-domain-rc-???? -o json
    

Once the Status is "Running", execute:

     cluster/kubectl.sh log -f wildfly-domain-rc-v5drx 
     


4. Install the Apache httpd + modcluster (Pod and Service)

Execute:

    cluster/kubectl.sh create -f <PATH TO THIS DEMO>/modcluster.json
    cluster/kubectl.sh create -f <PATH TO THIS DEMO>/modcluster-service.json
    

5. Check /mod_cluster_manager

Run 'cluster/kubectl.sh get pods' and verify the IP where the modcluster is running. 
_Note that if the Status is "Pending" it could be that the Pod still downloading the image like explained on Step [3]_

Open the /modcluster-manager URL in a browser

Execute:

    open http://<modcluster host ip>/mod_cluster_manager  #For Linux containers


6. Start the Wildfly Server pods

These Servers doesn't need a Service because it acts as a backend.

Execute:

    cluster/kubectl.sh create -f <PATH TO THIS DEMO>/wildfly-server.json
    

Check the pods:

    cluster/kubectl.sh get pods
    

_Note that if the Status is "Pending" it could be that the Pod still downloading the image like explained on Step [3]_

7. Check at /mod_cluster_manager page that Wildfly was registered at modcluster


8. Access the application

Execute:

    open http://127.0.0.1/ticket-monster/  #For Linux containers
    

9. You can stop some servers and check the application behaviour

Execute:

    cluster/kubectl.sh stop pod wildfly-server-rc-????  
    

Verify that the pod is recreated to keep at least 2 instances of wildfly-server-rc running.