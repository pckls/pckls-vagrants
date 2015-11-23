#!/bin/bash

BCFILE=/var/tmp/bootstrap_complete

if [ ! -e ${BCFILE} ]
then

    # Install PC1 release, install Puppet Agent
    rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    yum install -y puppet-agent

    # Disable firewall (manage later with Puppet)
    /opt/puppetlabs/bin/puppet resource service firewalld ensure=stopped

    # Mark bootstrap complete
    touch ${BCFILE}

fi
