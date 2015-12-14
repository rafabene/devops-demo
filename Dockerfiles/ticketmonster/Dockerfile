# Use latest jboss/wildfly
FROM rafabene/wildfly-admin

MAINTAINER "Rafael Benevides" <benevides@redhat.com>

ENV MODCLUSTER_HOST ""
ENV MODCLUSTER_PORT 80

# Add customization folder
COPY customization /opt/jboss/wildfly/customization/

USER root

RUN yum install -y nmap telnet

# Run customization scripts as root
RUN chmod +x /opt/jboss/wildfly/customization/execute.sh
RUN /opt/jboss/wildfly/customization/execute.sh standalone standalone-ha.xml

ADD ticket-monster.war /opt/jboss/wildfly/standalone/deployments/

ADD launch.sh /

RUN chmod +x /launch.sh 

# Fix for Error: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

RUN chown -R jboss:jboss /opt/jboss/wildfly/

USER jboss

# Expose the ports we're interested in
EXPOSE 8080 9990 8009

CMD /launch.sh
