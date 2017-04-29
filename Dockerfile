FROM centos:7

#ARG http_proxy=http://wwwproxy.hud.ac.uk:3128
#ARG https_proxy=http://wwwproxy.hud.ac.uk:3128

RUN yum -y install dnsmasq git make

# install n
WORKDIR /
RUN git clone https://github.com/tj/n.git \
	&& cd n \
	&& make \
	&& make install \
	&& cd .. \
	&& rm -r n

# use n to install node
RUN n 6.10.2

# use npm to install config-templater
RUN npm install -g config-templater

COPY entrypoint.sh /entrypoint.sh

EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 67/udp
EXPOSE 68/udp
EXPOSE 69/udp

ENTRYPOINT ["/entrypoint.sh"]

CMD ["dnsmasq", "--no-daemon"]