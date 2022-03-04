#!/bin/sh

cp $SRC_HOME/hadoop/hadoop_classpath.conf ~/.bashrc
echo "alias tlog='tail -f /db/tibero6/instance/tibero/log/slog/sys.log'" >> ~/.bashrc
. ~/.bashrc

if [ -d $HADOOP_HOME ]; then 
  echo "Hadoop already exists."
else 
  sh $SRC_HOME/hadoop/install.sh;
fi

tar -xzf $SRC_HOME/tibero/*.tar.gz -C /db/

if [ -d $TB_HOME/database ]; then
  echo "Tibero already exists."
  sh $SRC_HOME/tibero/sync_hostip.sh;
else
  sh $SRC_HOME/tibero/install.sh;
fi

tbboot;
tbdown immediate;
tbboot;

chmod 750 $TB_HOME/instance/$TB_SID/log
find $TB_HOME/instance/$TB_SID/log -type f -name '*.log' -exec chmod 640 {} \;
chmod -R 640 $TB_HOME/database/$TB_SID/*.ctl
chmod -R 640 $TB_HOME/database/$TB_SID/*.log
chmod -R 640 $TB_HOME/database/$TB_SID/*.dtf
