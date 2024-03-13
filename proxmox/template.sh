VMID=9000
is_vmid_busy() {
    qm_status_output=$(qm status $1 2>&1)
    if [[ "$qm_status_output" == *"does not exist"* ]]; then
        return 0
    else
        return 1
    fi
}
while is_vmid_busy "$VMID"; do
    ((VMID++))
done
apt-get install libguestfs-tools -y
STORAGE_POOL=$(vgs --noheadings | awk '{print $1}' | tr -d ' ')
TEMPLATE_NAME="ubuntu-20.04-template"
ISO_PATH="/var/lib/vz/template/iso/ubuntu-20.04-minimal-cloudimg-amd64.img"
URL="https://cloud-images.ubuntu.com/minimal/releases/focal/release/ubuntu-20.04-minimal-cloudimg-amd64.img"
wget -O $ISO_PATH $URL
DISK_SIZE="5"
virt-customize -a $ISO_PATH --install qemu-guest-agent
qm create $VMID --name $TEMPLATE_NAME --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci 
qm set $VMID --scsi0 $STORAGE_POOL:0,import-from=$ISO_PATH
qm set $VMID --ide2 local:cloudinit
qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0
qm template $VMID
