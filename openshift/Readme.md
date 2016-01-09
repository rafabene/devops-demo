Ticket-Monster Openshift HA Cluster
--------------------------------


This project contains Pods that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server inside a [Openshift v3](https://www.openshift.org/) Cluster

The pieces of this demo are:

- Postgres 9.x Database Server - [Docker image](https://hub.docker.com/r/openshift/postgresql-92-centos7/)
    - POD
    - Service
- Wildfly 9.x Application Server + Ticket Monster application - [Dockerfile](../Dockerfiles/ticketmonster-ha/Dockerfile)
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
  
7. Deploy WildFly POD (via CLI)

  Execute:
  
      oc run wildfly --image=rafabene/wildfly-ticketmonster --command=true "sh" -- "-c" "/opt/jboss/wildfly/bin/standalone.sh -b \`hostname --ip-address\` -Dpostgres.host=\$POSTGRES_SERVICE_HOST -Dpostgres.port=\$POSTGRES_SERVICE_PORT"

8. Expose WildFly as a Service (via CLI)

  Execute:
  
      oc expose dc wildfly --name=wf-ticketmonster-svc --port=80 --target-port=8080

9. Expose WildFly Route (via CLI)

  Execute:
  
      oc expose svc/wf-ticketmonster-svc --hostname www.example.com


7. (Alternative for Steps 7, 8 and 9) - Deploy WildFly (Replication Controller + Service + Route) via yaml file.

  Execute Steps 1, 2, 3, 4 and 5.
  
  Instead of executing 3 commands to run a POD, create service and them create a route to that service, you can specify a YAML file that defines these 3 Openshift/Kubernetes objects.

  Get the [yaml file](https://github.com/rafabene/devops-demo/blob/master/openshift/wildfly-rc-service-route.yaml) that contains the definition of a `Replication Controller`, a `Service` and a `Route`.
  
  Execute :
  
      curl https://raw.githubusercontent.com/rafabene/devops-demo/master/openshift/wildfly-rc-service-route.yaml -o wildfly-rc-service-route.yaml    
      oc create -f wildfly-rc-service-route.yaml

10. Create a DNS (or hosts file) entry pointing to www.example.com.

  If you don't have access to your DNS server you can do that by including the entry in `/etc/hosts`.
  
  Edit your hosts file and add the following entry to it:
  
  - Linux or Mac Hosts file: /etc/hosts
  - Windows: C:\Windows\System32\drivers\etc\hosts
  
  File content:
  
        <IP OF OPENSHIFT>      www.example.com


11. Access Ticket-monster.

  Execute:
  
      open http://www.example.com/ticket-monster



12. Scale the number of WildFly instances.

  Execute:
  
      oc scale dc/wildfly --replicas=2 #If you deployed WildFly via command line
      oc scale rc/wf-ticketmonster-rc --replicas=2  #If you used the YAML file

13. Cleanup.

  Execute:
  
      oc delete project wildfly-ticketmonster-cluster
