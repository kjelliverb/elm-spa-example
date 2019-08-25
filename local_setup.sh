#!/bin/bash
TASK=$1

if [ $TASK = "build" ]
then
	docker build --no-cache -t example-web .

	#remove all exited containers
	docker rm $(docker ps -a -f status=exited -q)

	#remove all dangling images
	docker rmi $(docker images -f "dangling=true" -q)
fi

if [ $TASK = "run" ]
then
	docker run -d --publish 8080:80 --name example-web example-web
fi

if [ $TASK = "update" ]
then

	#stop and remove container
	if [ "$(docker ps -a -q -f name=example-web)" ] 
	then
		docker stop example-web
		docker rm example-web
	fi

	#build image
	docker build --no-cache -t example-web .

	#remove all exited containers
	if [ "$(docker ps -a -f status=exited -q)" ] 
	then
		docker rm $(docker ps -a -f status=exited -q)
	fi

	#remove all dangling images
	docker rmi $(docker images -f "dangling=true" -q)

	docker run -itd --name example-web --publish 8888:80 example-web

fi