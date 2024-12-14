#!/bin/bash

touch file
getent passwd | cut -d: -f1 > file
i=1
for user in $(cat file)
do
    echo "$i. $user"
    ((i++))
done