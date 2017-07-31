# Barebone cluster

Shows a very basic cluster consisting of 1 GTM and just 1 coordinator and 1 data node.

This is obviously not a very performant cluster.

It's an example of the most MVP barebones setup that you can run using Postgres-XL.

## Usage

Getting everything working by up-ing the services
and initializing the Postgres-XL cluster.

```shell
# NOTE: Any SQL file execution errors
# such as "node definition already exists" are ok.
> docker-compose up -d
> docker cp init-cluster.sql barebonecluster_coordinator_1_1:/
> docker-compose exec coordinator_1 psql -f init-cluster.sql
> docker cp init-cluster.sql barebonecluster_data_1_1:/
> docker-compose exec data_1 psql -f init-cluster.sql
> docker-compose restart
```

Now let's verify that everything is working

```shell
# NOTE: Start psql. 
# Never ever connect directly to datanodes.
# Queries are executed from coordinator(s) or proxy/ies.
# In our case we have only 1 coordinator.
> docker-compose exec coordinator_1 psql

# NOTE: Check the current Postgres XL cluster setup.
postgres=# SELECT oid, * FROM pgxc_node;
  oid  |   node_name   | node_type | node_port | node_host | nodeis_primary | nodeis_preferred |   node_id   
-------|---------------|-----------|-----------|-----------|----------------|------------------|-------------
 11819 | coordinator_1 | C         |      5432 | localhost | f              | f                |   459515430
 16416 | data_1        | D         |      5432 | data_1    | f              | f                | -1402125261
(2 rows)


# NOTE: Create one distributed and one replicated table.
# Since we have 1 data node, both must be at the same place.
postgres=# CREATE TABLE disttab(col1 int, col2 int, col3 text) DISTRIBUTE BY HASH(col1);
CREATE TABLE

postgres=# \d+ disttab
                        Table "public.disttab"
 Column |  Type   | Modifiers | Storage  | Stats target | Description 
--------|---------|-----------|----------|--------------|-------------
 col1   | integer |           | plain    |              | 
 col2   | integer |           | plain    |              | 
 col3   | text    |           | extended |              | 
Distribute By: HASH(col1)
Location Nodes: ALL DATANODES

postgres=# CREATE TABLE repltab (col1 int, col2 int) DISTRIBUTE BY REPLICATION;
CREATE TABLE

postgres=# INSERT INTO disttab SELECT generate_series(1,100), generate_series(101, 200), 'foo';
INSERT 0 100

postgres=# INSERT INTO repltab SELECT generate_series(1,100), generate_series(101, 200);
INSERT 0 100

postgres=# SELECT COUNT(*) FROM disttab;
 count 
-------
   100
(1 row)

postgres=# SELECT COUNT(*) FROM repltab;
 count 
-------
   100
(1 row)

# NOTE: `xc_node_id` is an ID of a datanode and shows that all our
# data is in `-1402125261`
postgres=# SELECT xc_node_id, count(*) FROM repltab GROUP BY xc_node_id;
 xc_node_id  | count 
-------------|-------
 -1402125261 |   100
(1 row)
```
