#!/bin/bash

sudo docker build -t mailserver-mta .
sudo docker tag mailserver-mta harwig/mailserver-mta
docker push harwig/mailserver-mta



