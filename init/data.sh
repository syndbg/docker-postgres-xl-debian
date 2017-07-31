#!/bin/sh
initdb -D ${PGDATA} --nodename=${PG_DATA_NODE}

FILE=/var/lib/postgresql/data/pg_hba.conf
add_pg_hba_entry() {
    network=$1
    LINE="host all all ${network} trust"

    grep -q "${LINE}" ${FILE} || echo ${LINE} >> ${FILE}
    return 0
}

# NOTE: Allow connectivity between containers in the same Docker network.
DOCKER_NETWORK=$(ip route show | tail +2 | cut -c-13)
add_pg_hba_entry $DOCKER_NETWORK

# NOTE: Opt-in to allow more IPs/networks if needed.
# This is useful in a "real" production-ready environment
# that spans across more than 1 Docker network, VM and/or host.
if [ -z ${DOCKER_NETWORK_OPT_1+x} ]; then
    echo "skipping DOCKER_NETWORK_OPT_1"
else
    add_pg_hba_entry $DOCKER_NETWORK_OPT_1
fi

if [ -z ${DOCKER_NETWORK_OPT_2+x} ]; then
    echo "skipping DOCKER_NETWORK_OPT_2"
else
    add_pg_hba_entry $DOCKER_NETWORK_OPT_2
fi

if [ -z ${DOCKER_NETWORK_OPT_3+x} ]; then
    echo "skipping DOCKER_NETWORK_OPT_3"
else
    add_pg_hba_entry $DOCKER_NETWORK_OPT_3
fi

if [ -z ${DOCKER_NETWORK_OPT_4+x} ]; then
    echo "skipping DOCKER_NETWORK_OPT_4"
else
    add_pg_hba_entry $DOCKER_NETWORK_OPT_4
fi
