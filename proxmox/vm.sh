id=100
name=node1.doubletop
ip=178.211.139.198
gw=178.211.139.129
disk=27748
memory=12000
cores=2
cpuunits=4
qm clone 3336 $id --name $name
qm resize $id scsi0 +${disk}G
qm set $id --ipconfig0 ip=$ip/25,gw=$gw --memory $memory --cores $cores --cpuunits $cpuunits
qm start $id
