Requirements for OVS
--------------------------

      % sudo apt-get install build-essential fakeroot debhelper \
                    autoconf automake bzip2 libssl-dev \
                    openssl graphviz python-all procps \
                    python-qt4 python-zopeinterface \
                    python-twisted-conch libtool

Install OpenVSwitch
-------------------

Enter OVS root directory

Generate configuration file

      % ./boot.sh 

Configure to generate makefile (--with-linux is required to build kernel module)

      % ./configure --with-linux=/lib/modules/`uname -r`/build

Compile and install

      % make

      % sudo make install && make modules_install

Init configuration database (in OVS root directory)

      % sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema

Prepare virtual environment
--------------------

Install QEMU and KVM

      % sudo apt-get install qemu-kvm 

Copy two scripts in /etc

      % sudo cp qemu-ifup /etc

      % sudo cp qemu-ifdown /etc

      % sudo chmod a+x /etc/qemu-ifup

      % sudo chmod a+x /etc/qemu-ifdown


Start OpenVSwitch
-----------------

Run the script

      % sudo ./setup_ovs.sh

Add a bridge (only when first start, the bridge will be read from configuration database later on)

      % sudo ovs-vsctl add-br br0

Start VMs
---------

Make sure VM images are ready and run the script

      % sudo ./startvm-1

      % sudo ./startvm-2
