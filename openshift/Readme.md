Ticket-Monster Openshift HA Cluster
--------------------------------


This project contains Pods that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server inside a [Openshift v3](https://www.openshift.org/) Cluster

The pieces of this demo are:

- Postgres 9.x Database Server - [Docker image](https://hub.docker.com/r/openshift/postgresql-92-centos7/)
    - POD
    - Service
- Wildfly 9.x Application Server + Ticket Monster application - [Dockerfile](../DockerFiles/ticketmonster/Dockerfile)
    - POD
    - Service
    - Openshift Route
    
Suggested Openshift Installation
================================

Use: https://github.com/redhat-developer-tooling/openshift-vagrant

Running the Openshift Cluster
==============================

1. Login in Vagrant Box.

  Execute:

      vagrant ssh


2. Only If you are NOT using openshift-vagrant - Change Openshift SCC to allow USER directive in Dockerfile.

  If you are installing Openshift from https://github.com/redhat-developer-tooling/openshift-vagrant you can skip this step. openshift-vagrant already has this configuration to allow any Docker image to be run on OpenShift 

  Execute:
  
      oc --config=/var/lib/origin/openshift.local.config/master/admin.kubeconfig edit scc restricted

  Change the runAsUser.Type strategy to RunAsAny. 

3. Login with your credentials.

  Execute:
  
      oc login

4. Create a new project in Openshift.

  Execute:

      oc new-project wildfly-ticketmonster-cluster

5. Deploy postgres.

  _Note: Due to Openshift security restrictions we are using openshift/postgresql-92-centos7 instead_

  Execute:
  
      oc new-app --name postgres openshift/postgresql-92-centos7 -e POSTGRESQL_USER=ticketmonster -e POSTGRESQL_DATABASE=ticketmonster -e POSTGRESQL_PASSWORD=ticketmonster-docker

6. We won't deploy mod_cluster because Openshift uses [routes](https://docs.openshift.com/enterprise/3.0/architecture/core_concepts/routes.html) to expose Services.

  Due to this, we will deploy a [Kubernetes Services](https://docs.openshift.com/enterprise/3.0/architecture/core_concepts/pods_and_services.html#services) for WildFly instead.

7. Get WildFly (Replication Controller + Service + Route) yaml file.

  Get the [yaml file](https://github.com/rafabene/devops-demo/blob/master/openshift/wildfly-rc-service-route.yaml) that contains the definition of a `Replication Controller`, a `Service` and a `Route`.
  
  Execute:
  
      curl https://raw.githubusercontent.com/rafabene/devops-demo/master/openshift/wildfly-rc-service-route.yaml -o wildfly-rc-service-route.yaml    


8. Deploy WildFly Replication Controller + Service + Route.

  Execute:
  
      oc create -f wildfly-rc-service-route.yaml

9. Create a DNS (or hosts file) entry pointing to www.example.com.

  If you don't have access to your DNS server you can do that by including the entry in `/etc/hosts`.
  
  Edit your hosts file and add the following entry to it:
  
  - Linux or Mac Hosts file: /etc/hosts
  - Windows: C:\Windows\System32\drivers\etc\hosts
  
      <IP OF OPENSHIFT>      www.example.com


10. Access Ticket-monster.

  Execute:
  
      open http://www.example.com/ticket-monster



11. Scale the number of WildFly instances.

  Execute:
  
      oc scale rc/wf-ticketmonster-rc --replicas=2

12. Cleanup.

  Execute:
  
      oc delete project wildfly-ticketmonster-cluster
