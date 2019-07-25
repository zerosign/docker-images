arg JAVA_VERSION

from openjdk:$JAVA_VERSION-alpine

arg JAVA_VERSION
arg HADOOP_VERSION
arg HADOOP_MIRROR
arg HADOOP_HOME
arg HADOOP_USER

env HADOOP_VERSION=$HADOOP_VERSION
env HADOOP_MIRROR=$HADOOP_MIRROR
env HADOOP_HOME=$HADOOP_HOME
env HDFS_NAMENODE_USER=$HADOOP_USER
env HDFS_DATANODE_USER=$HADOOP_USER
env HDFS_SECONDARYNAMENODE_USER=$HADOOP_USER

run apk update && apk add \
   bash \
   shadow \
   curl \
   openssh-server \
   openssh-client \
   rsync \
   tar

run echo $HADOOP_MIRROR/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
run curl -O $HADOOP_MIRROR/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
run tar xzf hadoop-$HADOOP_VERSION.tar.gz && \
    mkdir -p $HADOOP_HOME && \
    mv hadoop-$HADOOP_VERSION/* $HADOOP_HOME && \
    rm -rf hadoop-$HADOOP_VERSION && \
    rm -rf hadoop-$HADOOP_VERSION.tar.gz && \
    echo "PATH=$PATH:$HADOOP_HOME/bin" >> /etc/profile.d/hadoop.sh && \
    chmod +x /etc/profile.d/hadoop.sh && \
    mkdir -p /opt/hadoop/logs

run chsh -s /bin/bash

run printf "HADOOP_VERSION=$HADOOP_VERSION\nHADOOP_HOME=$HADOOP_HOME\nHDFS_NAMENODE_USER=$HDFS_NAMENODE_USER\nHDFS_DATANODE_USER=$HDFS_DATANODE_USER\nHDFS_SECONDARYNAMENODE_USER=$HDFS_SECONDARYNAMENODE_USER" >> /etc/profile.d/hadoop.sh

run mkdir -p ~/.ssh && \
    ssh-keygen -t rsa -P '' -f ~/.ssh/hadoop.key && \
    cat ~/.ssh/hadoop.key.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    ssh-keygen -A

run echo "<configuration><property><name>dfs.replication</name><value>1</value></property></configuration>" > $HADOOP_HOME/etc/hadoop/hdfs-site.xml
run printf "Host *\n\tIdentityFile ~/.ssh/hadoop.key\n\tUserKnownHostsFile /dev/null\n\tStrictHostKeyChecking no" > ~/.ssh/config

# cleanup apk
run rm -rf /var/cache/apk/*

workdir /opt/hadoop
run printf "JAVA_HOME=$JAVA_HOME" >> /opt/hadoop/etc/hadoop/hadoop-env.sh

copy entrypoint.sh /opt/hadoop/

run chmod +x /opt/hadoop/entrypoint.sh

entrypoint /opt/hadoop/entrypoint.sh
