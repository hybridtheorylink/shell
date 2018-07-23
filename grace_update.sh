#!/bin/bash

function grace_update(){
	if  [ ! -n "$1" ] ;then
	echo "请输入war包名称";
	return 0;
	fi
	#NGINX_SBIN="/usr/sbin"
	#NGINX_CONF="/etc/nginx"
	#TOMCAT_1="/data/tomcat/apache-tomcat-8.5.23"
	#TOMCAT_2="/data/tomcat/apache-tomcat-8.5.23"

	NGINX_SBIN="/usr/local/nginx/sbin"
	NGINX_CONF="/usr/local/nginx/conf"
	TOMCAT_1="/data0/tomcat-nginx-7070/apache-tomcat-8.5.23"
	TOMCAT_2="/data0/tomcat/apache-tomcat-8.5.23"	
	echo "发送停止7070服务器信号"
	rm -rf $NGINX_CONF/nginx.conf
	cp $NGINX_CONF/nginx.conf.7070 $NGINX_CONF/nginx.conf
	$NGINX_SBIN/nginx -t
	read -s -n1 -p "按任意键继续 ... "
	echo "...";

	$NGINX_SBIN/nginx -s reload
	echo "更新7070服务器"
	read -s -n1 -p "按任意键继续 ... "
	echo "...";

	#`$NGINX_SBIN`/nginx
	echo $TOMCAT_1
	
	sh publish-v2.sh $1 $TOMCAT_1/webapps
	result=$?

	if  [ $result -eq 0 ] ;then
		echo "发布错误，退出程序"
		return 0
	fi

	echo "发送停止8080服务器信号，并开启7070服务器"
	rm -rf $NGINX_CONF/nginx.conf
	cp $NGINX_CONF/nginx.conf.8080 $NGINX_CONF/nginx.conf
	$NGINX_SBIN/nginx -t
	read -s -n1 -p "按任意键继续 ... "
	echo "...";

	$NGINX_SBIN/nginx -s reload
	read -s -n1 -p "按任意键继续 ... "
	echo "...";
	echo $TOMCAT_2
	echo "更新8080服务器"
	read -s -n1 -p "按任意键继续 ... "
	echo "...";
	sh publish-v2.sh $1 $TOMCAT_2/webapps
	result=$?

	if  [ $result -eq 0 ] ;then
		echo "发布错误，退出程序"
		return 0
	fi
	echo "部署完成"
	echo "开启全部服务器"
	read -s -n1 -p "按任意键继续 ... "
	echo "...";
	cp $NGINX_CONF/nginx.conf.all $NGINX_CONF/nginx.conf
	$NGINX_SBIN/nginx -t
	read -s -n1 -p "按任意键继续 ... "
	echo "...";
	$NGINX_SBIN/nginx -s reload


	echo "it's done!"
	echo "Congratulation！！！ "	
	echo "--<--<-<@ ●-● § ^_^ § "
}

grace_update $1 
