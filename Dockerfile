FROM ros:kinetic-perception

ENV CATKIN_WS=/root/catkin_ws \
    OKVIS_ROOT=/root/catkin_ws/src/okvis_ros/ \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    libatlas-base-dev \
    libgoogle-glog-dev \
    libsuitesparse-dev \
    python-catkin-tools \
    libopencv-dev && \
    rm -rf /var/lib/apt/lists/*

COPY  . $OKVIS_ROOT
COPY ./scripts $CATKIN_WS

WORKDIR $CATKIN_WS

RUN /bin/bash -c "chmod +x build.sh && chmod +x modify_entrypoint.sh && sync && ./build.sh && ./modify_entrypoint.sh"
