#!/bin/bash
set -eo pipefail

CONTAINER_NAME=${CONTAINER_NAME:-syncthing}
CONTAINER_USER=${CONTAINER_USER:-run}
LOCAL_UID=${LOCAL_UID:-1000}
LOCAL_GID=${LOCAL_GID:-1000}

echo "[`date`] Bootstrapping container ${CONTAINER_NAME}..."

# Change uid + gid for container user based on env vars
# -----------------------------------------------------------------------------
echo "[`date`] Changing local user ${CONTAINER_USER} to UID: ${LOCAL_UID}, GID: ${LOCAL_GID} ..."
groupmod -o -g ${LOCAL_GID} ${CONTAINER_USER}
usermod -o -u ${LOCAL_UID} -g ${LOCAL_GID} ${CONTAINER_USER}

# Fix Perms
# -----------------------------------------------------------------------------
echo "[`date`] Start fixing permissions for -- /home/${CONTAINER_USER} /opt/syncthing/etc /opt/syncthing/bin -- ..."
echo "[`date`] Permissions in data dirs /opt/syncthing/var/* wont be changed! "
chown -R "${LOCAL_UID}":"${LOCAL_GID}" /home/${CONTAINER_USER} /opt/syncthing/etc /opt/syncthing/bin
chown "${LOCAL_UID}":"${LOCAL_GID}" /opt/syncthing

# STARTING
# If command starts with an option, prepend syncthing
# -----------------------------------------------------------------------------
if [ "${1:0:1}" = '-' ]; then
	set -- syncthing "$@"
fi

# If command starts with syncthing, run as container user
# -----------------------------------------------------------------------------
if [ "$1" = 'syncthing' ]; then
	exec gosu ${CONTAINER_USER} "$@"
fi

# Otherwise start 'normal'
exec "$@"
