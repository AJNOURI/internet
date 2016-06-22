FROM alpine
RUN apk update
RUN apk add iptables
RUN apk add ip6tables
RUN apk add iptables-doc
RUN apk add iproute2
RUN apk add drill
RUN apk add iputils
RUN apk add bash
RUN apk add dialog
ADD nat.sh /data/nat.sh
VOLUME /data
CMD /data/nat.sh
