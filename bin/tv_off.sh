#!/bin/sh

#echo 'on 0' | cec-client -s
ssh root@192.168.1.11 "echo 'standby 0' | cec-client -s"
