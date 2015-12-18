Ticket-Monster Openshift HA Cluster
--------------------------------


This project contains Pods that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server inside a [Openshift v3](https://www.openshift.org/) Cluster

The pieces of this demo are:

- Apache HTTPD + mod_cluster 
    - POD 
    - Services
- Postgres 9.x Database Server
    - POD
    - Services
- Wildfly 9.x Application Server + Ticket Monster application
    - POD

Running the Openshift Cluster
==============================

1. Login with your credentials

  Execute:
  
    oc login

2. Create a new project in Openshift

  Execute:

    oc new-project wildfly-ticketmonster-cluster

3. Deploy postgres

  Execute
  
    oc new-app --name postgres openshift/postgresql-92-centos7 -e POSTGRESQL_USER=ticketmonster -e POSTGRESQL_DATABASE=ticketmonster -e POSTGRESQL_PASSWORD=ticketmonster-docker

_Note: Due to Openshift security restrictions we are using openshift/postgresql-92-centos7 instead_

4. Chance Openshift SCC to allow USER directive in Dockerfile

  Execute
  
    oc --config=/var/lib/origin/openshift.local.config/master/admin.kubeconfig edit scc restricted

Change the runAsUser.Type strategy to RunAsAny. 

5. Deploy mod_cluster

  Execute:
  
    oc new-app rafabene/mod_cluster

6. Explose mod_cluster

  Execute
  
    oc expose svc/modcluster --hostname=www.example.com


7. Create a DNS entry pointing to www.example.com

  If you don't have access to your DNS server you can do that by including the entry on /etc/hosts.
  
  Execute:
  
    echo "<IP OF OPENSHIFT>      www.example.com" >> /etc/hosts    


8. Access mod_cluster

  Execute
  
    open http://www.example.com/mod_cluster_manager
    


9. Get WildFly Replication Controller yaml file from Kubernetes example

  This shows that the same Kubernetes file can be used to deploy WildFly
  
  Execute:
  
    curl https://raw.githubusercontent.com/rafabene/devops-demo/master/kubernetes/wildfly-server.yaml -o wildfly-server.yaml    

10. Deploy WildFly Replication Controller

  Execute:
  
    oc create -f wildfly-server.yaml

11. Scale the number of WildFly instances

  Execute:
  
    oc scale rc/wildfly-replication-controller --replicas=3

12. Cleanup

  Execute:
  
    oc delete project wildfly-ticketmonster-cluster
