echo "Destroying Swarm cluster ..."
docker-machine rm aws-mh-keystore aws-swarm-master aws-swarm-node-01 aws-swarm-node-02 -f
