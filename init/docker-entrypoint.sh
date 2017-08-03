#!/bin/bash
# NOTE: Loosely based on Docker's official Postgres
# https://github.com/docker-library/postgres/blob/master/9.6/docker-entrypoint.sh
set -e

mkdir -p "$PGDATA"
chown -R "$PG_USER":"$PG_USER" "$PGDATA"
chmod 700 "$PGDATA"

mkdir -p /var/run/postgresql
chown -R "$PG_USER" /var/run/postgresql
chmod 775 /var/run/postgresql

# NOTE: Create the transaction log directory before initdb
# is run (below) so the directory is owned by the correct user.
if [ "$POSTGRES_INITDB_XLOGDIR" ]; then
    mkdir -p "$POSTGRES_INITDB_XLOGDIR"
    chown -R "$PG_USER":"$PG_USER" "$POSTGRES_INITDB_XLOGDIR"
    chmod 700 "$POSTGRES_INITDB_XLOGDIR"
fi

test -d $PGDATA/already-initialized || gosu $PG_USER ./init.sh
touch $PGDATA/already-initialized
chown "$PG_USER":"$PG_USER" $PGDATA/already-initialized

gosu $PG_USER "$@"
