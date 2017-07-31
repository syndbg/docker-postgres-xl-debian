CREATE NODE coordinator_1 WITH (TYPE = 'coordinator', HOST = 'coordinator_1', PORT = 5432);
CREATE NODE data_1 WITH (TYPE = 'datanode', HOST = 'data_1', PORT = 5432);
SELECT pgxc_pool_reload();
