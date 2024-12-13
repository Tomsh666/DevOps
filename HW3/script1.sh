#!/bin/bash

read -p "Enter username: " username
if ! id "$username" &>/dev/null; then
    echo "User $username not found"
    exit 1
fi
user_info=$(grep "^$username:" /etc/passwd)
shell=$(echo "$user_info" | cut -d: -f7)
home_dir=$(echo "$user_info" | cut -d: -f6)
groups_info=$(id -nG "$username")
echo $user_info
echo $shell
echo $home_dir
echo $groups_info
echo "Сhoice?"
echo "1. UID"
echo "2. Home dir"
echo "3. Group"
read -p "Enter number: " action
final_command="usermod "
case $action in
    1)
        read -p "Enter new UID: " new_uid
        if getent passwd | awk -F: '{print $3}' | grep -q "^$new_uid$"; then
            echo "Wrong UID $new_uid"
            read -p "Enter new UID: " new_uid
            if getent passwd | awk -F: '{print $3}' | grep -q "^$new_uid$"; then
                echo "Wrong UID $new_uid"
            else
                final_command+="-u $new_uid"
            fi
        else
            final_command+="-u $new_uid"
        fi
        ;;
    2)
        read -p "Enter new home dir?" new_home_dir
        read -p "Move to new dir? (Y/n)" tmp
        if [[ "$tmp" == "Y" ]]; then
            final_command+="-m -d $new_home_dir"
        else
            final_command+="-d $new_home_dir"
        fi
        ;;

    3)
        read -p "Change primary group or secondary?(1/2) " tmp
        if [[ "$tmp" == "1" ]]; then
            final_command+="-g $new_home_dir"
        else
            final_command+="-aG $new_home_dir"
        fi
        ;;

    *)
        echo "Wrong choice"
        exit 1
        ;;
esac
echo "$final_command $username"