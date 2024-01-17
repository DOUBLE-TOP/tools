qm create 3336 --memory 12048 -vcpus 8 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
qm set 3336 --scsi0 vg1:vm-3336-disk-0,size=30G
qm set 3336 --ide2 local:cloudinit
qm set 3336 --boot order=scsi0
qm set 3336 --serial0 socket --vga serial0
qm set 3336 --sshkey ~/.ssh/razumv.pub
qm set 3336 --cipassword $password --ciuser $user
qm template 3336
