FROM ubuntu:xenial
MAINTAINER Coindroid <mail@coindroid.org>

ARG USER_ID
ARG GROUP_ID
ARG VERSION


ENV COIN digitalcoin
ENV USER ${COIN}
ENV COMPONENT ${USER}
ENV HOME /${USER}

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} ${USER} \
	&& useradd -u ${USER_ID} -g ${USER} -s /bi/bash -m -d ${HOME} ${USER}

# grab gosu for easy step-down from root

ENV GOSU_VERSION 1.7
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates software-properties-common curl wget git cron\
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && apt-add-repository ppa:bitcoin/bitcoin \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash \
	 && apt-get update && apt-get install -y libdb4.8-dev libdb4.8++-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && gosu nobody true \
	 && npm install pm2 -g 

RUN wget -O /tmp/${COMPONENT}.tar.gz "https://cdn.coindroid.org/${COIN}/${COIN}.tar.gz" \
    && cd /tmp/ \
    && tar zxvf ${COMPONENT}.tar.gz \
	 && mkdir -p /opt/${COMPONENT}/daemon \
    && mv /tmp/cdn_coindroid/digitalcoin/daemon/* /opt/${COMPONENT}/daemon \
    && rm -rf /tmp/*


RUN git clone https://github.com/masternoder/single-api.git /opt/single-api \
    && cd /opt/single-api \
	 && npm i



# RUN set -x \
#     && apt-get update && apt-get install -y libminiupnpc-dev python-virtualenv git virtualenv cron \
#     && mkdir -p /sentinel \
#     && cd /sentinel \
#     && git clone https://github.com/lomtax/sentinel . \
#     && virtualenv ./venv \
#     && ./venv/bin/pip install -r requirements.txt \
#     && touch sentinel.log \
#     && chown -R ${USER} /sentinel \
#     && echo '* * * * * '${USER}' cd /sentinel && SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py >> sentinel.log 2>&1' >> /etc/cron.d/sentinel \
#     && chmod 0644 /etc/cron.d/sentinel \
#     && touch /var/log/cron.log

#  7999 default Digitalcoin p2p port ,5691 port for single API
EXPOSE 7999 8000 

VOLUME ["${HOME}"]
WORKDIR ${HOME}
ADD ./bin /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start-unprivileged.sh"]
