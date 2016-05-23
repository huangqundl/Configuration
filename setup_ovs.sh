#!/bin/bash

### load modules
modprobe gre
modprobe openvswitch
modprobe libcrc32c

#### setup ovsdb
#ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema

### open ovsdb server (no SSL) 
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
    --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
    --pidfile --detach --log-file

#### open ovsdb server (SSL) 
#ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
#    --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
#    --private-key=db:Open_vSwitch,SSL<Plug>PeepOpenrivate_key \
#    --certificate=db:Open_vSwitch,SSL,certificate \
#    --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
#    --pidfile --detach --log-file

### open ovsctl
ovs-vsctl --no-wait init

### open switched
ovs-vswitchd --pidfile --detach --log-file
