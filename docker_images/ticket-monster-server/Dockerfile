# Use latest jboss/wildfly
FROM jboss/wildfly

MAINTAINER "Rafael Benevides" <benevides@redhat.com>

ADD host.xml /opt/jboss/wildfly/domain/configuration/

# Expose the ports we're interested in
EXPOSE 8009

# Set the default command to run on boot
# This will boot WildFly in the domain mode and bind to local interface
CMD /opt/jboss/wildfly/bin/domain.sh -Djboss.domain.master.address=domain  -b $(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')