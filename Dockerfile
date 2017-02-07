FROM nginx:1.11.9-alpine

RUN apk update && apk add curl && rm -rf /var/cache/apk

RUN curl -sSLo /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/0.18.0/consul-template_0.18.0_linux_amd64.zip \
  && cd /usr/local/bin \
  && unzip /tmp/consul-template.zip \
  && rm /tmp/consul-template.zip

RUN curl -sSLo /tini https://github.com/krallin/tini/releases/download/v0.14.0/tini-static \
  && chmod a+x /tini

RUN mkdir -p /etc/consul-templates && touch /etc/consul-templates/app.conf.ctmpl

ENTRYPOINT ["/tini", "-v", "-g", "--"]

CMD ["consul-template", \
    "--log-level=debug", \
    "--consul-addr=consul:8500", \
    "--exec", "nginx -g 'daemon off;'", \
    "--exec-reload-signal=SIGHUP", \
    "--template=/etc/consul-templates/app.conf.ctmpl:/etc/nginx/conf.d/app.conf"]
