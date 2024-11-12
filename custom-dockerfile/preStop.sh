/bin/env sh

timeout=${1:-30}

echo "timeout: ${timeout}"
sleep ${timeout}
echo "Unregistry service after ${timeout}"
curl -X 'POST' 'http://localhost:8080/actuator/serviceregistry?status=DOWN' -H 'Content-Type: application/vnd.spring-boot.actuator.v2+json;charset=UTF-8'"

