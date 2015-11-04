FROM alpine:latest

# Install needed packages. Notes:
#   * build-base: used so we include the basic development packages (gcc)
#   * python3-dev: are used for gevent e.g.
#   * bash: so we can access /bin/bash
RUN apk add --update \
              musl \
              build-base \
              python3 \
              python3-dev \
              bash \
  && pip3.4 install --upgrade pip \
  && rm /var/cache/apk/*

# make some useful symlinks that are expected to exist
RUN cd /usr/bin \
  && ln -sf easy_install-3.4 easy_install \
  && ln -sf idle3.4 idle \
  && ln -sf pydoc3.4 pydoc \
  && ln -sf python3.4 python \
  && ln -sf python-config3.4 python-config \
  && ln -sf pip3.4 pip

# install requirements
# this way when you build you won't need to install again
# ans since COPY is cached we don't need to wait
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# since we will be "always" mounting the volume, we can set this up
CMD python