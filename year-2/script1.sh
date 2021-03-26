#! /bin/bash

echo Hello World!

#echo "My name is ${NAME}"

read -p "Enter your name: " NAME

echo "Hello $NAME, nice to meet you!"

if [ "$NAME" == "Brad" ]
then
	echo "your name is Brad"
elif [ "$NAME" == "Jack" ]
then
	echo "Your name is Jack"
else
	echo "Your name is Not Brad"
fi
