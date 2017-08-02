/syslog-stdout/syslog-stdout &

haproxy -vv -f $HAPROXY_HOME/haproxy.cfg

exec $1
