FROM docker.io/argoproj/argocd:${ARGOCD_VERSION:-latest} AS argocd
FROM docker.io/bitnami/kubectl:${KUBECTL_VERSION:-latest} AS kubectl
FROM docker.io/alpine:latest

COPY --from=argocd /usr/local/bin/argocd         /usr/local/bin/
COPY --from=argocd /usr/local/bin/helm           /usr/local/bin/
COPY --from=argocd /usr/local/bin/kustomize      /usr/local/bin/
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

RUN apk update && apk add --update git bash openssh

RUN apk update \
    && apk add --no-cache curl jq yq bash git openssh go-task \
    && rm -rf /var/cache/apk/*

RUN ln -s /usr/bin/go-task /usr/bin/task


ENV HELM_EXPERIMENTAL_OCI=1

ENTRYPOINT ["/bin/bash", "-l", "-c"]