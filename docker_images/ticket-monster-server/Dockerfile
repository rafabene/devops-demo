# Use latest jjboss/wildfly
FROM jboss/wildfly

ADD host.xml /opt/jboss/wildfly/domain/configuration/

# Expose the ports we're interested in
EXPOSE 8080

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD /opt/jboss/wildfly/bin/domain.sh -Djboss.domain.master.address=$TM_DOMAIN_PORT_9999_TCP_ADDR -Djboss.domain.master.port=$TM_DOMAIN_PORT_9999_TCP_PORT -b 0.0.0.0