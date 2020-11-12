# Define parent image
FROM ros:kinetic-perception

# Set environment and working directory
ENV CATKIN_WS=/root/catkin_ws
WORKDIR $CATKIN_WS
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    libatlas-base-dev \
    libgoogle-glog-dev \
    libsuitesparse-dev \
    python-catkin-tools \
    libopencv-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy files
COPY  . src/okvis_ros/

# Build SLAM system
RUN catkin config --extend /opt/ros/$ROS_DISTRO \
      --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    catkin build && \
    sed -i '/exec "$@"/i source ~/catkin_ws/devel/setup.bash' /ros_entrypoint.sh
