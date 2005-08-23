#!/bin/sh
# virtualmin-install.sh
# Copyright 2005 Virtualmin, Inc.
# Simple script to grab the virtualmin-release and virtualmin-base packages.
# The packages do all of the hard work, so this script can be small and 
# lazy.

LANG=
export LANG

SERIAL=$SERIAL
KEY=$KEY
VER=2.74
arch=i386 # XXX need to detect x86_64

echo "***********************************************************************"
echo "*   Welcome to the Virtualmin Professional installer, version $VER    *"
echo "***********************************************************************"
echo ""
sleep 3

# Check for wget or curl
printf "Checking for curl or wget..."
if [ -x "/usr/bin/curl" ]; then
	download="/usr/bin/curl -O"
elif [ -x "/usr/bin/wget" ]; then
	download="/usr/bin/wget"
else
	echo "No web download program available: Please install curl or wget"
	echo "and try again."
	exit 1
fi
printf "found $download\n"

# Checking for perl
printf "Checking for perl..."
if [ -x "/usr/bin/perl" ]; then
	perl="/usr/bin/perl"
elif [ -x "/usr/local/bin/perl" ]; then
	perl="/usr/local/bin/perl"
else
	echo "Perl was not found on your system: Please install perl and try again"
	exit 1
fi
printf "found $perl\n"

# Only root can run this
id | grep "uid=0(" >/dev/null
if [ $? != "0" ]; then
	uname -a | grep -i CYGWIN >/dev/null
	if [ $? != "0" ]; then
		echo "ERROR: The Virtualmin install script must be run as root";
		echo "";
		exit 1;
	fi
fi

# Insert the serial number and password into /etc/virtualmin-license
echo "SerialNumber=$SERIAL" > /etc/virtualmin-license
echo "LicenseKey=$KEY"	>> /etc/virtualmin-license

# Find temp directory
if [ "$tempdir" = "" ]; then
	if [ -e "/tmp/.virtualmin" ]; then
		rm -rf /tmp/.virtualmin
	fi
	tempdir=/tmp/.virtualmin
	mkdir $tempdir
fi

# Detecting the OS
# Grab the Webmin oschooser.pl script
mkdir $tempdir/files
srcdir=$tempdir/files
cd $srcdir
if $download http://$SERIAL:$KEY@software.virtualmin.com/lib/oschooser.pl
then continue
else exit 1
fi
if $download http://$SERIAL:$KEY@software.virtualmin.com/lib/os_list.txt
then continue
else exit 1
fi
cd ..

# Ask for operating system type
echo "***********************************************************************"  
if [ "$os_type" = "" ]; then
  if [ "$autoos" = "" ]; then
      autoos=2
    fi
    $perl "$srcdir/oschooser.pl" "$srcdir/os_list.txt" $tempdir/$$.os $autoos
    if [ $? != 0 ]; then
      exit $?
    fi
    . $tempdir/$$.os
    rm -f $tempdir/$$.os
  fi
echo "Operating system name:    $real_os_type"
echo "Operating system version: $real_os_version"
echo ""

# Grab virtualmin-release from the server
# XXX:Needs to choose RPM/deb/ebuild/whatever based on OS
echo "Downloading virtualmin-release package for $real_os_type $real_os_version..."
if $download http://$SERIAL:$KEY@software.virtualmin.com/$os_type/$os_version/$arch/virtualmin-release-latest.noarch.rpm
then continue
else exit
fi

# Install it using the package manager
echo "Installing virtualmin-release..."
if rpm -Uvh virtualmin-release-latest.noarch.rpm
then continue
else exit
fi

# Use apt-get, yum, or up2date to install everything else
if [ $os_type = "fedora" ]; then
	install="/usr/bin/yum -y install"
elif [ $os_type = "rhel" ]; then
	install="/usr/bin/up2date -i"
elif [ $os_type = "suse" ]; then
	# We need to grab and install yum here...yast has crappy dep resolution
	rpm -Uvh http://software.virtualmin.com/suse/extras/yum-latest.noarch.rpm
	install="/usr/bin/yum -y install"
elif [ $os_type = "mandriva" ]; then
	install="/usr/bin/urpmi"
else
	echo "Your OS is not currently supported by this installer.  Please contact us at"
	echo "support@virtualmin.com to let us know what OS you'd like to install Virtualmin"
	echo "Professional on, and we'll try to help."
	exit 1
fi

echo "Installing Virtualmin and all related packages now using the command:"
echo "$install virtualmin-base"

$install virtualmin-base

echo "Installation completed."
