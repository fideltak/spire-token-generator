ARG ALPINE=alpine:latest
FROM ${ALPINE}
ARG KUBERNETES_RELEASE=v1.20.11
WORKDIR /bin
RUN set -x \
 && apk --no-cache add curl jq\
 && curl -fsSLO https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_RELEASE}/bin/linux/amd64/kubectl \
 && chmod +x kubectl

COPY ./get-spire-token.sh /
CMD ["/get-spire-token.sh"]