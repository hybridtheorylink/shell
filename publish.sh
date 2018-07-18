set -o errexit;
if  [ ! -n "$1" ] ;then
echo "请输入war包名称";
exit 0;
fi
if [ ! -f "$1.war" ];then
echo "请输入正确的war包名称";
exit 0;
fi
if [ ! -f "./backup/$1/$1.war" ];then
echo "请上传正确的war包名称";
exit 0;
fi
last_time=`stat $1.war|grep Modify|awk '{print $2}'|sed s/-//g`;
if [ ! -f "./backup/$1/$last_time/$1.war" ];then
mkdir -p "./backup/$1/$last_time";
mv $1.war ./backup/$1/$last_time;
else
file_count=`ls ./backup/$1/$last_time -l |grep "^-"|wc -l`;
echo $file_count;
#file_count=$[file_count+1];
mv $1.war ./backup/$1/$last_time/$1$file_count.war;
fi
mv backup/$1/$1.war $1.war;
echo "完成备份并发布应用";
