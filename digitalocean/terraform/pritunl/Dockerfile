FROM ubuntu:20.04

RUN apt update -q &&\
    apt -y install gnupg2 
   
RUN echo "deb [trusted=yes] http://repo.pritunl.com/stable/apt focal main" | tee /etc/apt/sources.list.d/pritunl.list

RUN apt update &&\ 
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv E162F504A20CDF15827F718D4B7C549A058F8B6B &&\
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A &&\
    apt update

RUN apt --assume-yes install pritunl

RUN apt update -q &&\
    apt -y install apt-transport-https &&\
    apt update -q &&\
    apt install -y locales &&\
        locale-gen en_US en_US.UTF-8 &&\
    dpkg-reconfigure locales &&\
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime &&\
    apt update -q &&\
    apt install -y software-properties-common &&\
    apt install -y iptables &&\
    apt clean &&\
    apt -y -q autoclean &&\
    apt -y -q autoremove

ADD start_pritunl /tmp

EXPOSE 80 443 1194

ENTRYPOINT ["/tmp/start_pritunl"]
