#!/bin/sh

export JAVA_HOME=/usr/java/jdk1.8.0_111
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin

cd /server/service-validate

environment="prod"
server_port="6090"
jvm_opt="-server -Xms512m -Xmx1024m"
jar_name="service-validate.jar"
jar_temp_name="service-validate-$server_port.jar"
outputFile="/dev/null"
shutdown_url="http://127.0.0.1:$server_port/shutdown"
check_count=0
max_check_count=20

echo "---------------正在启动后台程序---------------"

echo "---------------jar包临时名称[$jar_temp_name]---------------"

ps -fe|grep jar_temp_name=$jar_temp_name |grep -v grep

if [ $? -eq 0 ];then
echo "---------------服务[$jar_temp_name]已经启动,准备kill进程重启---------------"
ID=`ps -ef | grep $jar_temp_name | grep -v "grep" | awk '{print $2}'`
echo $ID
echo "---------------"
for id in $ID
do
kill -9 $id
echo "killed $id"
done
echo "---------------服务[$jar_temp_name]开始重新启动--------------"
nohup java -Djar_temp_name=$jar_temp_name -jar $jvm_opt $jar_name --server.port=$server_port --spring.profiles.active=$environment  >> $outputFile 2>&1 &
else
echo "---------------进程[$jar_temp_name]开始启动--------------"
nohup java -Djar_temp_name=$jar_temp_name -jar $jvm_opt $jar_name --server.port=$server_port --spring.profiles.active=$environment  >> $outputFile 2>&1 &
fi
