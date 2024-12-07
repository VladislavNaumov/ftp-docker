FROM alpine:latest

RUN apk add --no-cache vsftpd

ARG FTP_USER
ARG FTP_PASS

RUN adduser -D $FTP_USER && \
    echo "$FTP_USER:$FTP_PASS" | chpasswd && \
    mkdir -p /var/ftp/$FTP_USER && \
    chown -R $FTP_USER:$FTP_USER /var/ftp/$FTP_USER && \
    chmod a-w /var/ftp/$FTP_USER && \
    chmod 755 /var/ftp && \
    mkdir -p /var/run/vsftpd/empty && \
    echo "$FTP_USER" > /etc/vsftpd.userlist && \
    chmod 644 /etc/vsftpd.userlist && \
    chown root:root /etc/vsftpd.userlist

RUN mkdir -p /opt/PROD && \
    chown -R $FTP_USER:$FTP_USER /opt/PROD && \
    chmod 755 /opt/PROD

COPY ./vsftpd.conf /etc/vsftpd.conf

EXPOSE 21
EXPOSE 10000-10100

CMD ["vsftpd", "/etc/vsftpd.conf"]
