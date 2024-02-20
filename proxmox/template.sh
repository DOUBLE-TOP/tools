VMID=9000
STORAGE_POOL=$(vgs --noheadings | awk '{print $1}' | tr -d ' ')
TEMPLATE_NAME="ubuntu-20.04-template"
ISO_PATH="/var/lib/vz/template/iso/ubuntu-20.04-minimal-cloudimg-amd64.img"
DISK_SIZE="5"

qm create $VMID --name $TEMPLATE_NAME --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci 

qm set $VMID --scsi0 $STORAGE_POOL:0,import-from=$ISO_PATH

qm set $VMID --ide2 local:cloudinit

qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0
qm template $VMID
