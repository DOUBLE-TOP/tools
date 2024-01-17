#!/bin/bash

disk=327748
memory=12000
template_vm_id=3336
bridge="vmbr0"
cores=4
sockets=2
vcpus=8

while IFS=';' read -r id name ip gw mac
do
    [[ "$id" =~ ^#.*$ || -z "$id" ]] && continue 

    qm clone $template_vm_id $id --name $name

    qm resize $id scsi0 +${disk}G

    qm set $id --ipconfig0 ip=$ip/25,gw=$gw --memory $memory --cores $cores --sockets $sockets --vcpus $vcpus --net0 model=virtio,bridge=$bridge,macaddr=$mac

    qm start $id

    echo "VM $name created successfully"
done < vm_info.txt
