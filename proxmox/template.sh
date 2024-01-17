user=user
password=user_password
vg_name=my_vg
disk_name=vm-3336-disk-0
size=30G
lvcreate -L 30G -n $disk_name $vg_name
qm create 3336 --memory 12048 -vcpus 8 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci 
qm set 3336 --scsi0 my_vg:$disk_name,size=$size
qm set 3336 --ide2 local:cloudinit
qm set 3336 --boot order=scsi0
qm set 3336 --serial0 socket --vga serial0
qm set 3336 --sshkey ~/.ssh/razumv.pub
qm set 3336 --cipassword $password --ciuser $user
qm template 3336
