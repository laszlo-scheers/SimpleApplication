#!/usr/bin/env bash
sudo apt update && sudo apt install nodejs npm
# Install pm2 which is a production process manager for Node.js with a built-in load balancer
sudo npm install -g pm2
# stop any instance of our application running currently
pm2 stop simple_app
# Check if there is instance running with the image name we are deploying
CURRENT_INSTANCE=$(docker ps -a -q --filter ancestor="laszloscheers/exampleapp" --format="{{.ID}}")

#If an instance does exist, stops the instance
if [ "$CURRENT_INSTANCE" ]
then
    docker rm $(docker stop $CURRENT_INSTANCE)
fi
# change directory into folder where application is downloaded
cd SimpleApplication/
# Install application dependencies
npm install
echo $PRIVATE_KEY > privatekey.pem
echo $SERVER > server.crt
# Start the application with the process name example_app using pm2
pm2 start ./bin/www --name simple_app