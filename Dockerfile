FROM alpine:3.18

WORKDIR /root

RUN <<EOF
sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
apk add --no-cache curl aria2 aria2-daemon openrc mini_httpd unzip tini
EOF

ARG ARIANG_VERSION=1.3.7

RUN <<EOF
curl -LSso /root/ariang.zip https://mirror.ghproxy.com/https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}-AllInOne.zip
unzip /root/ariang.zip -d /root/ariang
chown -R minihttpd /root/ariang
rm -f /root/ariang.zip
EOF

RUN <<EOF
sed -i'' 's/^#rc_logger="NO"/rc_logger="YES"/' /etc/rc.conf

sed -i'' \
  -e '/depend() {/,/}/d' \
  -e 's/command_user:=".*"/command_user:="root"/' \
  -e 's/output_log=".*"/output_log="\$logfile"/' \
  -e 's/error_log=".*"/error_log="\$logfile"/' \
  /etc/init.d/aria2

sed -i'' \
  -e '/depend() {/,/}/d' \
  -e 's/command_user:=".*"/command_user:="root"/' \
  /etc/init.d/mini_httpd

openrc
touch /run/openrc/softlevel

mkdir /root/downloads
mkdir -p /root/aria2
touch /root/aria2/aria2.session
EOF

COPY ./mini_httpd.conf /etc/mini_httpd/mini_httpd.conf
COPY ./aria2.conf /etc/aria2.conf
COPY ./start /root

VOLUME /root/aria2
EXPOSE 80 6800 6881
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/root/start"]
