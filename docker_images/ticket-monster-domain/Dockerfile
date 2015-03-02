# Use latest jboss/wildfly
FROM jboss/wildfly

MAINTAINER "Rafael Benevides" <benevides@redhat.com>

#Create admin user
RUN /opt/jboss/wildfly/bin/add-user.sh -u admin -p docker#admin --silent

# Add customization folder
COPY customization /opt/jboss/wildfly/customization/

COPY ticket-monster.war /opt/jboss/wildfly/customization/
COPY postgresql-9.4-1201.jdbc41.jar /opt/jboss/wildfly/customization/

USER root

RUN chown -R jboss:jboss /opt/jboss/wildfly/

USER jboss

RUN chmod +x /opt/jboss/wildfly/customization/execute.sh

RUN /opt/jboss/wildfly/customization/execute.sh

#Fix for JBAS014647: Could not rename /opt/jboss/wildfly/domain/configuration/*_xml_history/current
RUN rm -rf /opt/jboss/wildfly/domain/configuration/domain_xml_history/current
RUN rm -rf /opt/jboss/wildfly/domain/configuration/host_xml_history/current

# Expose the ports we're interested in
EXPOSE 9990 9999

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/wildfly/bin/domain.sh", "-b", "0.0.0.0","-bmanagement","0.0.0.0"]