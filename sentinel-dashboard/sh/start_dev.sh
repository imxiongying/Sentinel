#!/bin/sh

environment="dev"
server_port="8049"
jvm_opt="-Xms256m -Xmx256m"
jar_name="sentinel-dashboard.jar"
jar_temp_name="sentinel-dashboard-$server_port.jar"
outputFile="/server/logs/sentinel-dashboard-$server_port.log"

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
nohup java  -Djar_temp_name=$jar_temp_name -Dproject.name=tbt-dev-sentinel-dashboard -Dserver.port=$server_port -Dcsp.sentinel.dashboard.server=localhost:$server_port -jar $jvm_opt $jar_name --spring.profiles.active=$environment --auth.password=tbt_sentinel_1234!@# >> $outputFile 2>&1 &
else
echo "---------------进程[$jar_temp_name]开始启动--------------"
nohup java  -Djar_temp_name=$jar_temp_name -Dproject.name=tbt-dev-sentinel-dashboard -Dserver.port=$server_port -Dcsp.sentinel.dashboard.server=localhost:$server_port -jar $jvm_opt $jar_name --spring.profiles.active=$environment --auth.password=tbt_sentinel_1234!@# >> $outputFile 2>&1 &
fi


