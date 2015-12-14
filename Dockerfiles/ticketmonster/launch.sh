#!/bin/bash
set -m

JBOSS_HOME=/opt/jboss/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE-ha.xml"}
HOST=`hostname -i`

function wait_for_server() {
  until `$JBOSS_CLI -c --controller=$HOST --command=":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}


if [ -n "$MODCLUSTER_HOST" ]; then
    echo "=> Starting WildFly server and waiting to configure modcluster"
    $JBOSS_HOME/bin/$JBOSS_MODE.sh -b $HOST -bmanagement $HOST -c $JBOSS_CONFIG &

    echo "=> Waiting for the server to boot"
    wait_for_server

    echo "=> Configuring modcluster"
    $JBOSS_CLI -c --controller=$HOST --command="/subsystem=modcluster/:add-proxy(host=$MODCLUSTER_HOST,port=$MODCLUSTER_PORT)"
    
    echo "=> Running WildFly in foreground mode"
    fg %1
  else
    echo "=> Starting WildFly server"
    $JBOSS_HOME/bin/$JBOSS_MODE.sh -b $HOST -bmanagement $HOST -c $JBOSS_CONFIG    
fi  



