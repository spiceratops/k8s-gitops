#!/usr/bin/env bash

echo "**** install packages ****" && \
if [ -z "${MOD_VERSION}" ]; then \
MOD_VERSION=$(curl -sX GET "https://api.github.com/repos/intel/compute-runtime/releases/latest" | jq -r '.tag_name'); \
fi && \
COMP_RT_URLS=$(curl -sX GET "https://api.github.com/repos/intel/compute-runtime/releases/tags/${MOD_VERSION}" | jq -r '.body' | grep wget | grep -v .sum | grep -v .ddeb | sed 's|wget ||g') && \
echo "**** grab debs ****" && \
mkdir -p /cache/opencl-intel && \
for i in $COMP_RT_URLS; do \
echo "**** downloading ${i%$'\r'} ****" && \
curl -fS --retry 3 --retry-connrefused -o \
    /cache/opencl-intel/$(basename "${i%$'\r'}") -L \
    "${i%$'\r'}" || exit 1; \
done
cd /cache/opencl-intel
apt install *.deb
