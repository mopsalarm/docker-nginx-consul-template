FROM yanana/phusion-nginx

MAINTAINER Shun Yanaura <metroplexity@gmail.com>

RUN apt-get update \
  && apt-get -y install unzip \
  && rm -r /var/lib/apt/lists/* /var/cache/apt/*

ENV DL_URL https://releases.hashicorp.com/consul-template/0.15.0/consul-template_0.15.0_linux_amd64.zip
RUN curl -sSL $DL_URL > /tmp/consul-template.zip \
  && cd /usr/local/bin \
  && unzip /tmp/consul-template.zip \
  && rm /tmp/consul-template.zip

ADD nginx.service /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run
RUN find /etc/service -type f -name 'run' -a ! -executable -exec chmod +x {} \;

RUN rm -v /etc/nginx/conf.d/*
ADD nginx.conf /etc/nginx/nginx.conf

VOLUME /etc/consul-templates

CMD ["my_init"]
