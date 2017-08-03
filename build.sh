docker build -f Dockerfile.base -t syndbg/postgres-xl-base .
docker build -f Dockerfile.coordinator -t syndbg/postgres-xl-coordinator .
docker build -f Dockerfile.gtm -t syndbg/postgres-xl-gtm .
docker build -f Dockerfile.proxy -t syndbg/postgres-xl-proxy .
docker build -f Dockerfile.datanode -t syndbg/postgres-xl-datanode .
docker build -f Dockerfile.standby -t syndbg/postgres-xl-standby .
