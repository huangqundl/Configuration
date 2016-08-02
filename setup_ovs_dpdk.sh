#!/bin/bash

### setup hugetables: 2048 * 2M pages
mkdir /dev/hugepages
mount -t hugetlbfs none /dev/hugepages

#modprobe openvswitch

#### load vfio kernel module
modprobe vfio-pci
sudo chmod a+x /dev/vfio
sudo chmod 0666 /dev/vfio/*

#### load uio kernel module
modprobe uio
insmod /home/qhuang/workspace/dpdk-2.2.0/x86_64-native-linuxapp-gcc/kmod/igb_uio.ko
insmod /home/qhuang/workspace/dpdk-2.2.0/lib/librte_vhost/eventfd_link/eventfd_link.ko

#### bind NIC for DPDK
dpdk_nic_bind.py --bind=vfio-pci 00:19.0
dpdk_nic_bind.py --status

#### setup ovsdb
rm -f /etc/openvswitch/conf.db
ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema

### open ovsdb server (no SSL) 
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
    --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
    --pidfile --detach --log-file

### open ovsctl
ovs-vsctl --no-wait init

### open switched
ovs-vswitchd --dpdk -c 0x1 -n 4 --socket-mem 1024,0 -- unix:/usr/local/var/run/openvswitch/db.sock --pidfile --log-file=/var/log/openvswitch/ovs-vswitchd.log
#/usr/local/sbin/ovs-vswitchd --dpdk  -c 0x1 -n 4 -- unix:/usr/local/var/run/openvswitch/db.sock --pidfile --detach

#ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
#ovs-vsctl add-port br0  vhost-user1 -- set interface vhost-user1 type=dpdkvhostuser
#ovs-vsctl add-port br0  vhost-user2 -- set interface vhost-user2 type=dpdkvhostuser
#ovs-vsctl add-port br0  vhost-user2 -- set interface vhost-user2 type=dpdkvhostuser
#ovs-vsctl add-port br0  dpdk0 -- set interface dpdk0 type=dpdk
