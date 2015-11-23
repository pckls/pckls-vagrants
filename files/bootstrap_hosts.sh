#!/bin/bash

# Setup /etc/hosts
/opt/puppetlabs/bin/puppet resource host puppetmaster1.vagrant.pckls.io host_aliases=puppet
