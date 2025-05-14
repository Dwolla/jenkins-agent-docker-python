#!/usr/bin/env bash
# This script installs xmlsec dependencies and should be run as root

# The following explanation is for why we need to install pkg-config and other system
# packages.
#
# TL;DR: In the Airflow update from 2.9 to 2.10, xmlsec was added as a dependency.
# xmlsec is a Python package that requires the xmlsec C library installed. This script
# installs the C library.
#
# In the Jenkins container the `install-deps` target in the Makefile is called. The
# Makefile `install-deps` target is installing dependencies from the MWAA requirements
# file: docker/config/mwaa-base-providers-requirements.txt. In that file, it lists
# apache-airflow-providers-amazon[aiobotocore]==x.x.x. The trailing [aiobotocore] is
# not just pulling in aiobotocore itself, but also pulls in all of the Amazon-provider's
# extras, including the bits that power AWS SSO support. The AWS SSO hook in the Amazon
# provider depends on the Python xmlsec library under the hood (to handle SAML digital
# signatures). So we need xmlsec installed.
#
# Our pip is pointed to Dwolla's hosted PyPI artifact repository, and we don't have a
# wheel for xmlsec. Public PyPI (https://pypi.org/project/xmlsec/) has wheels for Mac
# and Windows, but not Linux. Because Linux distributions are so diverse, it's common
# for Linux wheels to be unavailable and require building from source. This is common
# for packages like xmlsec. Because of this we need to build xmlsec from source.
#
# In addition to this, the Python xmlsec package are binding to the C library, not the C
# library itself. So we need to build and install the C library too. This script
# installs the C library. The C library requires all of the dependencies listed below.
#
# Difference between <lib> and <lib>-dev:
# libxml2 is for running software that uses libxml2.
# libxml2-dev is for building or compiling software against libxml2 (which is the
# case for building Python wheels for packages like xmlsec).
#
# After installing, the `rm` cleans up the local repository of retrieved package files.
# This reduces the size of the Docker image by removing unnecessary cached files after
# installation.

# Exit on error
set -e

echo -e "\033[94mInstalling xmlsec C library dependencies\033[0m"

# Install xmlsec dependencies
apt-get install -y pkg-config libxml2-dev libltdl-dev libxmlsec1-dev libxmlsec1-openssl

# Clean up apt cache to reduce image size
rm -rf /var/lib/apt/lists/*

# Explanation for this section:
# Because we need xmlsec from above there is a specific issue with getting xmlsec that
# we address here. We need to build and install xmlsec1 v1.3.x because when running
# apt-get for xmlsec1, version 1.3.7 is currently only available in the Debian
# experimental repository, not in the stable repository. The main Debian and Ubuntu
# distributions are still using 1.2.x versions. According to the Debian Package Tracker,
# version 1.3.7-1 was only accepted into experimental on March 25, 2025, with standard
# repositories still using 1.2.41-1.
#
# The public PyPI xmlsec wrapper (v1.3.x) expects newer C header files (including
# xmlSecKeyDataFormatEngine) introduced in the 1.3.x series. So we need to build and
# install the 1.3.x series. This whole script is temporary and can be removed once these
# packages are updated in Linux and/or the Jenkins image.
cd /tmp
curl -LO https://github.com/lsh123/xmlsec/releases/download/1.3.7/xmlsec1-1.3.7.tar.gz
tar xzf xmlsec1-1.3.7.tar.gz
cd xmlsec1-1.3.7
# Prepare build with OpenSSL support
./configure --with-openssl
# Compile source code
make
# Install library to the system
make install

# Update dynamic linker cache so programs can find the library with ldconfig.
# - Use '|| true' to prevent script from failing if ldconfig fails. CI/CD environments
#   like GitHub Actions typically run on x86_64/amd64 systems, and when they need to
#   build for arm64, they rely on QEMU for emulation. QEMU emulation has known
#   limitations with certain system calls, and ldconfig is one that commonly has
#   issues in cross-architecture builds. For this situation, it is ok for ldconfig to
#   fail with the arm build because the containers typically run on x86_64/amd64 systems
#   in AWS.
ldconfig || echo "Warning: ldconfig failed, continuing build. This is expected in " \
  "some emulated environments. See comment in scripts/build_xmlsec_3_7.sh for more" \
  "details."

cd /
# Clean up temporary files
rm -rf /tmp/xmlsec1-1.3.7*

echo -e "\033[94mxmlsec C library dependencies installed successfully\033[0m"