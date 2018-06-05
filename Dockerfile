FROM ubuntu:latest
MAINTAINER rahulgolash <rahul.golash@gmail.com>

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt install net-tools

RUN apt-get update && apt-get -y install sudo
#apt-get -y upgrade &&
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN apt-get update
RUN apt-get install -y ethereum
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
RUN apt-get update

RUN apt-get -y install mongodb-org
RUN apt-get -y install bash \
		       						 curl \
                       iputils-ping \
                       git \
											 dnsutils

RUN apt-get update

RUN apt-get install -y build-essential

#RUN mkdir -p /data/db
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install -g express
RUN npm install -g truffle
RUN apt-get update
RUN apt-get install wget

# Install Redis.
RUN \
  cd /tmp && \
  wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Expose ports.
EXPOSE 6379
EXPOSE 30301
EXPOSE 30301/udp

ADD bin/* /opt/
RUN chmod +x /opt/*.sh

ENTRYPOINT ["/opt/startgeth.sh"]

# Define default command.
#CMD ["redis-server", "/etc/redis/redis.conf"]
