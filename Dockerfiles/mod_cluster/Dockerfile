FROM fedora:23

MAINTAINER Rafael Benevides <rafabene@gmail.com>


RUN dnf install -y httpd mod_cluster iproute

# Disable mod_proxy_balancer module to allow mod_cluster to work
RUN sed -i 's|LoadModule proxy_balancer_module|# LoadModule proxy_balancer_module|' /etc/httpd/conf.modules.d/00-proxy.conf

ADD launch.sh /
ADD mod_cluster.conf /etc/httpd/conf.d/mod_cluster.conf

EXPOSE 80
EXPOSE 23364/udp

RUN chmod +x /launch.sh

# Do the required modifications and launch Apache after boot
ENTRYPOINT /launch.sh