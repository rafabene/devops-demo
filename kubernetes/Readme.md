Ticket-Monster Kubernetes HA Cluster
--------------------------------


This project contains Pods that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server inside a [Kubernetes](http://kubernetes.io/) Cluster

The pieces of this demo are:

- Apache HTTPD + mod_cluster 
    - POD 
    - Services
- Postgres 9.x Database Server
    - POD
    - Services
- Wildfly 8.x Application Server + Ticket Monster application
    - POD

Running the Kubernetes Cluster
==============================

Start you Kubernetes Cluster. For more informaton about creating the Kubernetes Cluster, take a look on its [Kubernetes Getting Started Guide](http://kubernetes.io/gettingstarted/)
_Note: It is suggested to use Vagrant as it's easier to setup. Use the latest stable release to avoid unexpected issues_

1. Check the numbers of minions available and what pods are running

  Execute:

      cluster/kubectl.sh get nodes
      cluster/kubectl.sh get pods
    

2. Install the Postgres POD and Service

  Execute:

      cluster/kubectl.sh create -f <PATH TO THIS DEMO>/postgres.yaml
      cluster/kubectl.sh create -f <PATH TO THIS DEMO>/postgres-service.yaml
    

3. Install the Apache httpd + modcluster (Pod and Service)

  Execute:

      cluster/kubectl.sh create -f <PATH TO THIS DEMO>/modcluster.yaml
      cluster/kubectl.sh create -f <PATH TO THIS DEMO>/modcluster-service.yaml
    

  _Note that if the Status is "Pending" it could be that the Pod still downloading the image like explained on Step [3]_


4. Check /mod_cluster_manager

  Run 'cluster/kubectl.sh get pods -o wide' and verify the IP where the modcluster is running. 
  
  Run 'cluster/kubectl.sh describe service modcluster' to get the service port (under NodePort)

  Open the /modcluster-manager URL in a browser

  Execute:

      open http://<modcluster host ip>:30000/mod_cluster_manager  #For Linux containers



5. Start the Wildfly Server pods

  These Servers doesn't need a Service because it acts as a backend.

  Execute:

      cluster/kubectl.sh create -f <PATH TO THIS DEMO>/wildfly-server.yaml
    

  Check the pods:

      cluster/kubectl.sh get pods
    

  _Note that if the Status is "Pending" it could be that the Pod still downloading the Docker image like explained on Troubleshooting_
  
  Scale the number of pods:
  
    cluster/kubectl.sh scale --replicas=3 rc wildfly-replication-controller
    

6. Check at /mod_cluster_manager page that Wildfly was registered at modcluster


7. You can stop some servers (frontend, backend or database) and check the application behaviour

Execute:

    cluster/kubectl.sh stop pod <POD NAME>
    

Verify that the pod is recreated to keep at least 2 instances of wildfly-server-rc running.

8. Cleanup

Execute:

    cluster/kubectl.sh delete rc,services,pods   -l context=DevOpsDemo
    


9. Troubleshoot

  You can check the logs by running the log command on the POD.
  First get the pod name and the container name:

      cluster/kubectl.sh get pods
    

 Debuging "Pending Status"
  Observe the pod name. It will be something like wildfly-server-rc-?????.
  Observe the container name. It will be something like postgres

  _Note: If the Status is "Pending", wait until the POD download the docker image._
  You can check the cause of "Pending" by running:
  
      cluster/kubectl.sh get pod wildfly-server-rc-???? -o json
    

  Once the Status is "Running", execute:

      cluster/kubectl.sh log -f <POD_NAME> <CONTAINER>
      
