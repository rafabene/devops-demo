# Use jboss/wildfly 10.0.0.Final
FROM jboss/wildfly:10.0.0.Final

MAINTAINER "Rafael Benevides" <benevides@redhat.com>

ENV JBOSS_MODE standalone

#Create admin user
RUN /opt/jboss/wildfly/bin/add-user.sh -u admin -p docker#admin --silent

# Expose the ports we're interested in
EXPOSE 8080 9990

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to external interface
CMD /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -c $JBOSS_MODE.xml

