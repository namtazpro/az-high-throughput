#!/bin/bash

# Build Hey Container
# make sure to align clocks if you get certificate apt update error: run => sudo hwclock --hctosys
docker buildx build -t virouet/loadtest:v1 -f ./Dockerfile --load . #[dockerhubname]/[repo]:v1
# push to Dockerhub
docker push virouet/loadtest:v1

# Sample Hey Command to test from local command line
# install Hey first: sudo apt install key (linux)
hey -n 10 -c 2 -m GET -T "application/json" https://func-ingestmeasure-prem.azurewebsites.net/api/Function1?code=3PXIkcYozXNIwaR9H9lNx/g6xDExvgxVdyauPdOZIKqHQJMNM2jh7Q==

# Variables
RG=funcehtest-rg

# Single Test(s)
docker run --rm --name loadtest01 virouet/loadtest:v1 -n 10 -c 2 -m GET -T "application/json" https://func-ingestmeasure-prem.azurewebsites.net/api/Function1?code=3PXIkcYozXNIwaR9H9lNx/g6xDExvgxVdyauPdOZIKqHQJMNM2jh7Q==

az container create -g $RG --name loadtest03 --image virouet/loadtest:v1 --restart-policy Never --no-wait --command-line "/hey -n 10 -c 2 -m GET -T 'application/json' https://func-ingestmeasure-prem.azurewebsites.net/api/Function1?code=3PXIkcYozXNIwaR9H9lNx/g6xDExvgxVdyauPdOZIKqHQJMNM2jh7Q=="
az container list -o table
# Read logs from container instance that just ran
az container logs -g $RG --name loadtest03

az container list -o table

# Use For Loop
for value in {1..49}
do
    #az container create -g $RG --name loadtest$value --image kevingbb/hey:v1 --restart-policy Never --no-wait --command-line "/hey -n 10 -c 2 -m GET -T 'application/json' https://funcehtest01.azurewebsites.net/api/httpgettest?code=a/FB/hXxXtaPclZa5kqL/V0CMXh2Heye85cXjt3max4IawBvcF0gZg==&name=Fred" &
    az container create -g $RG -l northeurope --name loadtest$value --image virouet/loadtest:v1 --cpu 4 --memory 8 --restart-policy Never --no-wait --command-line "/hey -z 10m -c 10 -m GET -T 'application/json' https://func-ingestmeasure-prem.azurewebsites.net/api/Function1?code=3PXIkcYozXNIwaR9H9lNx/g6xDExvgxVdyauPdOZIKqHQJMNM2jh7Q==" > /dev/null &
done
# Another Location
for value in {50..99}
do
    #az container create -g $RG --name loadtest$value --image kevingbb/hey:v1 --restart-policy Never --no-wait --command-line "/hey -n 10 -c 2 -m GET -T 'application/json' https://funcehtest01.azurewebsites.net/api/httpgettest?code=a/FB/hXxXtaPclZa5kqL/V0CMXh2Heye85cXjt3max4IawBvcF0gZg==&name=Fred" &
    az container create -g $RG -l uksouth --name loadtest$value --image kevingbb/hey:v1 --cpu 4 --memory 8 --restart-policy Never --no-wait --command-line "/hey -z 10m -c 40 -m GET -T 'application/json' https://funcehtest001.azurewebsites.net/api/httpgettest?code=inwRPvFYFSOj2468p7lHEMIKaJ/EG8NEHkLqQ2XsDAB74fwA2voVVg==&name=${value}" > /dev/null &
done
# Another Location
for value in {200..299}
do
    #az container create -g $RG --name loadtest$value --image kevingbb/hey:v1 --restart-policy Never --no-wait --command-line "/hey -n 10 -c 2 -m GET -T 'application/json' https://funcehtest01.azurewebsites.net/api/httpgettest?code=a/FB/hXxXtaPclZa5kqL/V0CMXh2Heye85cXjt3max4IawBvcF0gZg==&name=Fred" &
    az container create -g $RG -l francecentral --name loadtest$value --image kevingbb/hey:v1 --cpu 4 --memory 8 --restart-policy Never --no-wait --command-line "/hey -z 10m -c 40 -m GET -T 'application/json' https://funcehtest001.azurewebsites.net/api/httpgettest?code=inwRPvFYFSOj2468p7lHEMIKaJ/EG8NEHkLqQ2XsDAB74fwA2voVVg==&name=${value}" > /dev/null &
done
# Another Location
for value in {300..399}
do
    #az container create -g $RG --name loadtest$value --image kevingbb/hey:v1 --restart-policy Never --no-wait --command-line "/hey -n 10 -c 2 -m GET -T 'application/json' https://funcehtest01.azurewebsites.net/api/httpgettest?code=a/FB/hXxXtaPclZa5kqL/V0CMXh2Heye85cXjt3max4IawBvcF0gZg==&name=Fred" &
    az container create -g $RG -l westeurope --name loadtest$value --image kevingbb/hey:v1 --cpu 4 --memory 8 --restart-policy Never --no-wait --command-line "/hey -z 10m -c 40 -m GET -T 'application/json' https://funcehtest001.azurewebsites.net/api/httpgettest?code=inwRPvFYFSOj2468p7lHEMIKaJ/EG8NEHkLqQ2XsDAB74fwA2voVVg==&name=${value}" > /dev/null &
done

# Use For Loop for Deleting
for value in {1..99}
do
    az container delete -g $RG --name loadtest$value -y > /dev/null &
done
