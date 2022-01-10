#!/bin/bash

DOCKER="docker"
CONTAINER_NAME=${CONTAINER_NAME:-pigen_work}
CONTINUE=${CONTINUE:-0}
PRESERVE_CONTAINER=${PRESERVE_CONTAINER:-0}
PIGEN_DOCKER_OPTS=${PIGEN_DOCKER_OPTS:-""}  
GIT_HASH=${GIT_HASH:-"$(cd pi-gen && git rev-parse HEAD)"}

CONTAINER_EXISTS=$(${DOCKER} ps -a --filter name="${CONTAINER_NAME}" -q)
CONTAINER_RUNNING=$(${DOCKER} ps --filter name="${CONTAINER_NAME}" -q)
if [ "${CONTAINER_RUNNING}" != "" ]; then
	echo "The build is already running in container ${CONTAINER_NAME}. Aborting."
	exit 1
fi
if [ "${CONTAINER_EXISTS}" != "" ] && [ "${CONTINUE}" != "1" ]; then
	echo "Container ${CONTAINER_NAME} already exists and you did not specify CONTINUE=1. Aborting."
	echo "You can delete the existing container like this:"
	echo "  ${DOCKER} rm -v ${CONTAINER_NAME}"
	exit 1
fi

BUILD_OPTS="-c /base/config"

${DOCKER} build -t pi-gen .

if [ "${CONTAINER_EXISTS}" != "" ]; then
	trap 'echo "got CTRL+C... please wait 5s" && ${DOCKER} stop -t 5 ${CONTAINER_NAME}_cont' SIGINT SIGTERM
	time ${DOCKER} run --rm --privileged \
		${PIGEN_DOCKER_OPTS} \
		--volume "$(pwd)":/base:ro \
		-e "GIT_HASH=${GIT_HASH}" \
		--volumes-from="${CONTAINER_NAME}" --name "${CONTAINER_NAME}_cont" \
		pi-gen \
		bash -e -o pipefail -c "apt install fdisk &&
        dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; ./build.sh ${BUILD_OPTS} &&
	rsync -av work/*/build.log deploy/" &
	wait "$!"
else
	trap 'echo "got CTRL+C... please wait 5s" && ${DOCKER} stop -t 5 ${CONTAINER_NAME}' SIGINT SIGTERM
	time ${DOCKER} run --name "${CONTAINER_NAME}" --privileged \
		${PIGEN_DOCKER_OPTS} \
		--volume "$(pwd)":/base:ro \
		-e "GIT_HASH=${GIT_HASH}" \
		pi-gen \
		bash -e -o pipefail -c "apt install fdisk &&
        dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; ./build.sh ${BUILD_OPTS} &&
	rsync -av work/*/build.log deploy/" &
	wait "$!"
fi

echo "copying results from deploy/"
${DOCKER} cp "${CONTAINER_NAME}":/pi-gen/deploy .
ls -lah deploy

# cleanup
if [ "${PRESERVE_CONTAINER}" != "1" ]; then
	${DOCKER} rm -v "${CONTAINER_NAME}"
fi

echo "Done! Your image(s) should be in deploy/"
