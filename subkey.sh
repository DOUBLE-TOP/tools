#!/bin/bash

if [ -f /usr/local/bin/subkey ]; then
    echo "Subkey is already installed"
else
    wget -O /usr/local/bin/subkey https://doubletop-bin.ams3.digitaloceanspaces.com/tools/subkey
    chmod +x /usr/local/bin/subkey
    echo "Subkey is installed"
fi

if [ -f $HOME/keys_$1_$2.txt ]; then
    echo "File $HOME/keys_$1_$2.txt is exist"
    mv $HOME/keys_$1_$2.txt $HOME/keys_$1_$2.txt_bk
    echo "renamed to $HOME/keys_$1_$2.txt_bk"
fi

echo "Generating $1 keys for $2 ..........."

for i in $(seq 1 $1); do
    subkey generate -n $2 -w 12 --output-type json | jq -r '.secretPhrase, .ss58PublicKey' | awk '{printf "%s;", $0}' | sed 's/;$/\n/' >> $HOME/keys_$1_$2.txt
done

echo "For view keys use: cat $HOME/keys_$1_$2.txt"
echo "Done"
