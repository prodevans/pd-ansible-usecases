#!/bin/bash
#yum remove -y $(package-cleanup --leaves | grep x86_64)
number=$(package-cleanup --leaves | wc -l)
#echo "$number"
while [ $number -gt 1 ]
do
  #number=`expr $number - 1`
  yum remove -y $(package-cleanup --leaves | grep x86_64)
  number=$(package-cleanup --leaves | wc -l)
  #echo $number
  #number=`expr $number - 1`
done
