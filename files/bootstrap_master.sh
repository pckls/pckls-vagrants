#!/bin/bash

BCFILE=/var/tmp/bootstrap_complete

if [ ! -e ${BCFILE} ]
then

    # Install PC1 release, install Puppet Server & git
    rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    yum install -y puppetserver git

    # Install r10k and move config into place
    /opt/puppetlabs/puppet/bin/gem install r10k
    mkdir /etc/puppetlabs/r10k && cp /vagrant/files/r10k.yaml /etc/puppetlabs/r10k/r10k.yaml

    # Move Hiera config into place
    #cp /vagrant/files/hiera.yaml /etc/puppetlabs/code/hiera.yaml

    # Setup /etc/hosts
    /opt/puppetlabs/bin/puppet resource host puppetmaster1.vagrant.pckls.io host_aliases=puppet

    # Disable firewall (manage later with Puppet)
    /opt/puppetlabs/bin/puppet resource service firewalld ensure=stopped

    # Start the Puppet Server
    /opt/puppetlabs/bin/puppet resource service puppetserver ensure=running enable=true

    # Enable the Puppet Agent
    #puppet resource service puppet ensure=running enable=true

    # Use r10k to deploy environments, hieradata, modules and manifests
    /opt/puppetlabs/puppet/bin/r10k deploy environment -p -v

    # Mark bootstrap complete
    touch ${BCFILE}

fi
