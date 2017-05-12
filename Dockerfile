FROM alpine
MAINTAINER VirtualBox Exton <vboxton@gmail.com>

COPY ./keys/authorized_keys /home/simple/.ssh/authorized_keys

RUN apk update &&\
    apk upgrade && \
    apk add dropbear &&\
    rm -rf /var/cache/apk/* &&\
    addgroup -g 1001 -S simple &&\
    adduser -u 1001 -s /bin/ash -S -G simple simple &&\
    mkdir -p /home/simple/.dropbear /home/simple/.ssh &&\
    chmod 0700 /home/simple/.dropbear /home/simple/.ssh &&\
    chmod 0600 /home/simple/.ssh/authorized_keys &&\
    dropbearkey -t rsa -f /home/simple/.dropbear/hk_rsa &&\
    dropbearkey -t dss -f /home/simple/.dropbear/hk_dss -s 1024 &&\
    dropbearkey -t ecdsa -f /home/simple/.dropbear/hk_ecdsa -s 384 &&\
    chown -R 1001.1001 /home/simple

USER 1001

EXPOSE 2222

CMD ["/usr/sbin/dropbear", "-EFRmsg", "-r", "/home/simple/.dropbear/hk_rsa", "-r", "/home/simple/.dropbear/hk_dss", "-r", "/home/simple/.dropbear/hk_ecdsa", "-p", "2222"]
