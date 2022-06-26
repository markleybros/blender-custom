FROM centos:7

RUN yum -y install epel-release

RUN yum -y install awscli patch python3 cmake3 mesa-libGL-devel gcc gcc-c++ git subversion make cmake libX11-devel libXxf86vm-devel libXi-devel libXcursor-devel libXrandr-devel libXinerama-devel libstdc++-static wget

RUN alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
    --slave /usr/local/bin/ctest ctest /usr/bin/ctest3 \
    --slave /usr/local/bin/cpack cpack /usr/bin/cpack3 \
    --slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3 \
    --family cmake

RUN yum install -y centos-release-scl
RUN yum install -y devtoolset-11
RUN echo "source /opt/rh/devtoolset-11/enable" >> /etc/bashrc
SHELL ["/bin/bash", "--login", "-c"]

# CUDA 11.4 and OptiX 7.2.0 are confirmed to work. Other versions/combinations may not!

RUN yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
RUN yum -y install cuda-11-4

ENV OPTIX_VERSION=NVIDIA-OptiX-SDK-7.2.0-linux64-x86_64
COPY restricted/"${OPTIX_VERSION}".sh /root/"${OPTIX_VERSION}".sh
RUN chmod +x /root/"${OPTIX_VERSION}".sh
RUN /root/"${OPTIX_VERSION}".sh --skip-license --prefix=/opt --include-subdir
ENV WITH_CYCLES_DEVICE_OPTIX=ON
ENV OPTIX_ROOT_DIR=/opt/"${OPTIX_VERSION}"

