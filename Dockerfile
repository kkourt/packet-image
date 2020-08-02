FROM scratch
ADD rootfs.tar.gz /

MAINTAINER David Laube <dlaube@packet.net>
LABEL name="Ubuntu Canonical Base Image" \
    vendor="Ubuntu" \
    license="GPLv2" \
    build-date="20181217"

# Setup the environment
ENV DEBIAN_FRONTEND=noninteractive

# Unminimize system
RUN yes | unminimize

# Install packages
RUN apt-get -q update && \
    apt-get -y -qq upgrade && \
    apt-get -y -qq install \
		apt-transport-https \
		bash \
		bash-completion \
		bc \
		ca-certificates \
		cloud-init \
		cron \
		curl \
		dbus \
		dstat \
		ethstatus \
		file \
		fio \
		htop \
		ifenslave \
		ioping \
		iotop \
		iperf \
		iptables \
		iputils-ping \
		jq \
		less \
		locales \
		locate \
		lsb-release \
		lsof \
		make \
		man-db \
		mdadm \
		mg \
		mosh \
		mtr-tiny \
		multipath-tools \
		nano \
		net-tools \
		netcat \
		nmap \
		ntp \
		ntpdate \
		open-iscsi \
		python-apt \
		python-yaml \
		rsync \
		rsyslog \
		screen \
		shunit2 \
		socat \
		software-properties-common \
		ssh \
		sudo \
		sysstat \
		tar \
		tcpdump \
		tmux \
		traceroute \
		unattended-upgrades \
		uuid-runtime \
		vim \
		wget

# Install a specific kernel
RUN apt-get -q update && \
	apt-get -y -qq upgrade && \
	apt-get -y -qq install \
	linux-image-5.4.0-42-generic \
	linux-modules-extra-5.4.0-42-generic

# Configure locales
RUN locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales

# Fix permissions
RUN chown root:syslog /var/log \
	&& chmod 755 /etc/default

# Fix cloud-init EC2 warning
RUN touch /root/.cloud-warnings.skip

# Install kubeadmin
RUN echo "net.bridge.bridge-nf-call-ip6tables = 1"  > /etc/sysctl.d/k8s.conf  && \
    echo "net.bridge.bridge-nf-call-iptables = 1"  >> /etc/sysctl.d/k8s.conf  && \
    apt-get install -y apt-transport-https curl && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -  && \
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list && \
	apt-get update  && \
	apt-get install -y kubelet kubeadm kubectl && \
	apt-mark hold kubelet kubeadm kubectl

RUN apt-get install -y docker.io

# Clean APT cache
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*


# vim: set tabstop=4 shiftwidth=4:
