FROM lihaixin/sshd
MAINTAINER Haixin Lee <docker@lihaixin.name>
ENV TZ "Asia/Chongqing"


# 配置时区
RUN   echo $TZ > /etc/timezone && \
           cp -f /usr/share/zoneinfo/$TZ /etc/localtime

#安装pptp客户端拨号程序
RUN    apt-get update -y  && apt-get install -y --no-install-recommends pptp-linux
COPY chap-secrets /etc/ppp/chap-secrets
COPY options.pptp  /etc/ppp/options.pptp
COPY tap1 /etc/ppp/peers/tap1
COPY ip-up /etc/ppp/ip-up
COPY ip-down /etc/ppp/ip-down
RUN chmod +x /etc/ppp/ip-up
RUN chmod +x /etc/ppp/ip-down



# 容器里超级进程管理
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY myrun /usr/bin/myrun
RUN  chmod +x /usr/bin/myrun


# 运行各种Service
CMD ["/usr/bin/supervisord"]
