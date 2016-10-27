#!/bin/bash

if [ "$1" == "up" ]; then
    TF_VAR_do_token=`cat .do-token` \
    TF_VAR_ssh_pubkey=~/.ssh/id_rsa.pub \
    TF_VAR_ssh_privkey=~/.ssh/id_rsa \
    TF_VAR_user_data=./user-data.yml \
    terraform apply
    # TOKEN=`cat .do-token`
    # REGION="nyc3"
    # SSH_KEY_ID=787942
    # SIZE="48gb"
    # echo '{"region":"'"${REGION}"'", "image":"coreos-stable", "size":"'"$SIZE"'", "user_data": "'"$(cat user-data.yml)"'", "ssh_keys":["'"$SSH_KEY_ID"'"], "name":"core-1"}'
    # curl --request POST "https://api.digitalocean.com/v2/droplets" \
    #     --header "Content-Type: application/json" \
    #     --header "Authorization: Bearer $TOKEN" \
    #     --data '{"region":"'"${REGION}"'", "image":"coreos-stable", "size":"'"$SIZE"'", "user_data": "'"$(cat user-data.yml)"'", "ssh_keys":["'"$SSH_KEY_ID"'"], "name":"core-1"}'
fi

if [ "$1" == "down" ]; then
    exit 0
fi
