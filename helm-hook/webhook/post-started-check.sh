#!/bin/env sh

WEBHOOK_URL='https://oapi.dingtalk.com/robot/send?access_token=b987fc14cea6ef423e38a35654063a6ac89bbd0c1d0e6379b10d41d48faa48eb'

HEADERS='Content-Type: application/json; charset=utf-8'

SUCCESS_BODY='{
        "msgtype":"markdown",
        "markdown": {
                "title": "success",
                "text":"'"**<font color=#008000>Pods 就绪</font>** 
> ${PROJECT_SERVICE_NAME}-${PROJECT_NAMESPACE} \n
> **IMAGE_TAG: ${PROJECT_IMAGE}** \n\n 
"'"}}'

FAILURE_BODY='{
        "msgtype":"markdown",
        "markdown": {
                "title": "failure",
                "text":"'"**<font color=#FA005B>Pods 失败</font>** 
> ${PROJECT_SERVICE_NAME}-${PROJECT_NAMESPACE} \n 
> **IMAGE_TAG: ${PROJECT_IMAGE}** \n\n 
"'"}}'

DELETE_BODY='{
        "msgtype":"markdown",
        "markdown": {
                "title": "delete",
                "text":"'"**<font color=#9B001C>资源已删除</font>** 
> ${PROJECT_SERVICE_NAME}-${PROJECT_NAMESPACE} \n 
> **IMAGE_TAG: ${PROJECT_IMAGE}** \n\n 
"'"}}'

ROLLBACK_BODY='{
        "msgtype":"markdown",
        "markdown": {
                "title": "delete",
                "text":"'"**<font color=#003383>版本已回退</font>** 
> ${PROJECT_SERVICE_NAME}-${PROJECT_NAMESPACE} \n 
> **IMAGE_TAG: ${PROJECT_IMAGE}** \n\n 
"'"}}'
case ${1} in
        post-install | post-upgrade)
                # echo "upgrade or install"
                curl -sf "http://${PROJECT_SERVICE_NAME}:${PROJECT_SERVICE_PORT}/${PROJECT_ENDPOINT}"

                if [ ${?} == 0 ]; then
                        curl -XPOST ${WEBHOOK_URL} -H "${HEADERS}" -d "${SUCCESS_BODY}"
                else 
                        curl -XPOST ${WEBHOOK_URL} -H "${HEADERS}" -d "${FAILURE_BODY}"
                fi
        ;;
        post-delete)
                # echo "has deleted resource"
                curl -XPOST ${WEBHOOK_URL} -H "${HEADERS}" -d "${DELETE_BODY}"
        ;;
        post-rollback)
                # echo "has rollbacked last version"
                curl -XPOST ${WEBHOOK_URL} -H "${HEADERS}" -d "${ROLLBACK_BODY}"
        ;;
esac
