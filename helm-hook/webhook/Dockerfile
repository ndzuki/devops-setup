FROM alpine

LABEL project="imx-cloud"
LABEL usedTo="helm hook"

ENV PROJECT_ENDPOINT=""
ENV PROJECT_SERVICE_PORT=""
ENV PROJECT_SERVICE_NAME=""
ENV PROJECT_NAMESPACE=""
ENV PROJECT_IMAGE=""

RUN apk add --no-cache curl


COPY webhook.sh /webhook.sh

RUN chmod +x /webhook.sh

ENTRYPOINT [ "sh" ]
CMD [ "/webhook.sh" ]
