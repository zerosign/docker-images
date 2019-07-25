#!/usr/bin/env bash

hostname | xargs printf "<configuration><property><name>fs.defaultFS</name><value>hdfs://%s:9000</value></property></configuration>" > $HADOOP_HOME/etc/hadoop/core-site.xml

/usr/sbin/sshd -D &
sleep 1 ; $HADOOP_HOME/bin/hdfs namenode -format 2>&1 &
sleep 1 ; $HADOOP_HOME/sbin/start-dfs.sh 2>&1 &
sleep 5 ; tail -f /opt/hadoop/logs/*
