#!/bin/bash

memory=12048
template_vm_id=3336
bridge="vmbr0"
cores=4
sockets=2
vcpus=8
vg_name="my_vg"
size="30G"

while IFS=';' read -r id name ip gw mac
do
    [[ "$id" =~ ^#.*$ || -z "$id" ]] && continue 
    disk_name=${name}-0
    
    lvcreate -L 30G -n $disk_name $vg_name
    
    qm clone $template_vm_id $id --name $name

    qm set $id --ipconfig0 ip=$ip/25,gw=$gw --memory $memory --cores $cores --sockets $sockets --vcpus $vcpus --net0 model=virtio,bridge=$bridge,macaddr=$mac --scsi0 my_vg:$disk_name,size=$size

    qm start $id

    echo "VM $name created successfully"
done < vm_info.txt
