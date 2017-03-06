Ticket-Monster Openshift HA Cluster
--------------------------------


This project contains Pods that allows you to run [Ticket Monster](http://www.jboss.org/ticket-monster/) on a [WildFly](http://www.wildfly.org) server inside a [Openshift v3](https://www.openshift.org/) Cluster

The pieces of this demo are:

- Postgres 9.x Database Server - [Docker image](https://hub.docker.com/r/openshift/postgresql-92-centos7/)
    - POD
    - Service
- Wildfly 10.x Application Server + Ticket Monster application - [Dockerfile](../Dockerfiles/ticketmonster/Dockerfile)
    - POD
    - Service
    - Openshift Route
    
Suggested Openshift Installations
=================================

- [Openshift Origin 1.1 - All-In-One Virtual Machine](https://www.openshift.org/vm/)

- [Openshift Enterprise 3.1 - CDK 2.0 Alpha](https://github.com/redhat-developer-tooling/openshift-vagrant)


Running the Openshift Cluster
==============================

1. Login in Vagrant Box (If you are using CDK).

  If you are using CDK, run the commands from inside Vagrant BOX.

  Execute:

      vagrant ssh

2. Login with your credentials.

  Execute:
  
      oc login

3. Create a new project in Openshift.

  Execute:

      oc new-project wildfly-ticketmonster-project

4. Deploy postgres.

  _Note: Due to Openshift security restrictions we are using openshift/postgresql-92-centos7 instead_

  Execute:
  
      oc new-app --name postgres openshift/postgresql-92-centos7 -e POSTGRESQL_USER=ticketmonster -e POSTGRESQL_DATABASE=ticketmonster -e POSTGRESQL_PASSWORD=ticketmonster-docker

5. We won't deploy mod_cluster because Openshift uses [routes](https://docs.openshift.com/enterprise/3.0/architecture/core_concepts/routes.html) to expose Services.

  Due to this, we will deploy a [Kubernetes Services](https://docs.openshift.com/enterprise/3.0/architecture/core_concepts/pods_and_services.html#services) for WildFly instead.
  
6. Deploy WildFly POD (via CLI)

  This step uses CLI to create a wildfly pod. Alternatively, You can use a YAML file bellow that contains this definition.

  Execute:
  
      oc run wildfly --image=rafabene/wildfly-ticketmonster --command=true "sh" -- "-c" "/opt/jboss/wildfly/bin/standalone.sh -b \`hostname --ip-address\` -Dpostgres.host=\$POSTGRES_SERVICE_HOST -Dpostgres.port=\$POSTGRES_SERVICE_PORT"

7. Expose WildFly as a Service (via CLI)

  This step uses CLI to create a wildfly service. Alternatively, You can use a YAML file bellow that contains this definition.

  Execute:
  
      oc expose dc wildfly --name=wf-ticketmonster-svc --port=80 --target-port=8080

8. Expose WildFly Route (via CLI)

  This step uses CLI to create a route. Alternatively, You can use a YAML file bellow that contains this definition.

  Execute:
  
      oc expose svc/wf-ticketmonster-svc --hostname www.timo.com


6. (Alternative for Steps 6, 7 and 8) - Deploy WildFly (Replication Controller + Service + Route) via yaml file.

  Execute Steps 1, 2, 3, 4 and 5.
  
  Instead of executing 3 commands to run a POD, create service and them create a route to that service, you can specify a YAML file that defines these 3 Openshift/Kubernetes objects.

  Get the [yaml file](https://github.com/rafabene/devops-demo/blob/master/openshift/wildfly-rc-service-route.yaml) that contains the definition of a `Replication Controller`, a `Service` and a `Route`.
  
  Execute :
  
      oc create -f https://raw.githubusercontent.com/rafabene/devops-demo/master/openshift/wildfly-rc-service-route.yaml


9. Access Ticket-monster.

  Execute:
        
      #When using CDK
      open http://wf-ticketmonster-route-myproject.<CDK IP>.xip.io/


12. Scale the number of WildFly instances.

  Execute:
  
      #If you deployed WildFly via CLI
      oc scale dc/wildfly --replicas=2 
      
      #If you used the YAML file
      oc scale rc/wf-ticketmonster-rc --replicas=2  

13. Cleanup.

  Execute:
  
      oc delete project wildfly-ticketmonster-project
