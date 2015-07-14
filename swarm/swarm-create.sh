echo "Creating cluster ..."
TOKEN=`docker run --rm swarm create`
echo "Got the token " $TOKEN
echo "Creating Swarm master ..."
docker-machine create -d virtualbox --swarm --swarm-master --swarm-strategy "spread" --swarm-discovery  token://$TOKEN swarm-master
echo "Creating Swarm node 01 ..."
docker-machine create -d virtualbox --swarm --swarm-discovery token://$TOKEN swarm-node-01
echo "Creating Swarm node 02 ..."
docker-machine create -d virtualbox --swarm --swarm-discovery token://$TOKEN swarm-node-02
