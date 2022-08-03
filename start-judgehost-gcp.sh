#!/usr/bin/env bash

### GCP command
### wget https://raw.github.com/WISVCH/chipcie-startup-scripts/main/start-judgehost-gcp.sh -v -O start-judgehost-gcp.sh && chmod +x start-judgehost-gcp.sh && ./start-judgehost-gcp.sh password; rm -rf start-judgehost-gcp.sh

### gcloud command
### gcloud compute instances create judgehost-1 --project=chipcie --zone=europe-west4-a --machine-type=e2-medium --metadata=judgehost_password=CHANGEME,startup-script=wget\ https://raw.github.com/WISVCH/chipcie-startup-scripts/main/start-judgehost-gcp.sh\ -v\ -O\ start-judgehost-gcp.sh\ \&\&\ chmod\ \+x\ start-judgehost-gcp.sh\ \&\&\ ./start-judgehost-gcp.sh\;\ rm\ -rf\ start-judgehost-gcp.sh --create-disk=auto-delete=yes,boot=yes,image=projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2204-jammy-v20220712,size=10

function metadata-exists () {
	return_code=$(curl --write-out '%{http_code}' --silent --output /dev/null "http://metadata.google.internal/computeMetadata/v1/instance/attributes/$1"  -H "Metadata-Flavor: Google")
	[[ "$return_code" = "200" ]]
	return $?
}

function get-metadata() {
	if ! metadata-exists $1; then
		return 1
	fi

	echo $(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/$1" -H "Metadata-Flavor: Google")
	return 0
}

if ! metadata-exists judgehost_password; then
	echo "Must providde metadata \"judgehost_password\""
fi

apt update
apt install -y \
		vim \
		wget \
		curl \
		git \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y \
		docker-ce \
		docker-ce-cli \
		containerd.io \
		docker-compose-plugin

if ! [[ "$(cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX_DEFAULT=")" =~ .*"cgroup_enable=memory".* ]]; then
	sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& cgroup_enable=memory/' /etc/default/grub
fi

if ! [[ "$(cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX_DEFAULT=")" =~ .*"swapaccount=1".* ]]; then
	sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& swapaccount=1/' /etc/default/grub
fi

if ! [[ "$(cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX_DEFAULT=")" =~ .*"systemd.unified_cgroup_hierarchy=0".* ]]; then
	sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& systemd.unified_cgroup_hierarchy=0/' /etc/default/grub
fi

if ! [[ "$(cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX=")" =~ .*"cgroup_enable=memory".* ]]; then
	sed -i 's/GRUB_CMDLINE_LINUX="[^"]*/& cgroup_enable=memory/' /etc/default/grub
fi

if ! [[ "$(cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX=")" =~ .*"swapaccount=1".* ]]; then
	sed -i 's/GRUB_CMDLINE_LINUX="[^"]*/& swapaccount=1/' /etc/default/grub
fi

if ! [[ "$(cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX=")" =~ .*"systemd.unified_cgroup_hierarchy=0".* ]]; then
	sed -i 's/GRUB_CMDLINE_LINUX="[^"]*/& systemd.unified_cgroup_hierarchy=0/' /etc/default/grub
fi

if ! ([[ "$(cat /proc/cmdline)" =~ .*"cgroup_enable=memory".* ]] && [[ "$(cat /proc/cmdline)" =~ .*"cgroup_enable=memory".* ]] && [[ "$(cat /proc/cmdline)" =~ .*"systemd.unified_cgroup_hierarchy=0".* ]]); then
	echo "restart required"
	update-grub
	reboot
fi

git clone https://github.com/WISVCH/chipcie-startup-scripts.git || (cd chipcie-startup-scripts; git pull; cd)

cd chipcie-startup-scripts

hostname="gcp-$(hostname)"

./start-judgehost.sh \
--hostname $hostname \
--password $(get-metadata judgehost_password) \
$( metadata-exists domserver_baseurl && printf %s "--domserver-baseurl $(get-metadata domserver_baseurl))" ) \
$( metadata-exists judgehost_container && printf %s "--container $(get-metadata judgehost_container))" ) \
$( metadata-exists judgehost_version && printf %s "--version $(get-metadata judgehost_version))" ) \
--detach \
1
