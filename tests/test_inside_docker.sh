#!/bin/sh -xe

OS_VERSION=$1

yum install -y iproute epel-release
yum install -y ansible @minimal openssh-server

echo "===================== CREATE TAP INTERFACE =============================="
/usr/sbin/ip tuntap add dev tap0 mode tap

echo "======================== SHOW INTERFACES ================================"
/usr/sbin/ip addr

echo "========================================================================="

# Add monitor interface to config
mkdir -p /etc/rocknsm
cat <<EOF > /etc/rocknsm/config.yml
---
rock_monifs:
  - tap0
EOF

# Generate defaults
/rock/bin/generate_defaults.sh

echo "======================== DUMP DEFAULT VALUES ============================"
cat /etc/rocknsm/config.yml


echo "======================== END DEFAULT VALUES ============================="

# Run deploy
DEBUG=1 /rock/bin/deploy_rock.sh
