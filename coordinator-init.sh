#!/bin/sh
initdb -D ${PGDATA} --nodename=${PG_COORD_NODE}
echo "host	all	all	${PG_NET_CLUSTER_A}	trust" >> ${PGDATA}/pg_hba.conf
