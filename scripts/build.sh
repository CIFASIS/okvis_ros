#!/bin/bash
source /opt/ros/$ROS_DISTRO/setup.bash
catkin config --extend /opt/ros/$ROS_DISTRO \
  --cmake-args -DCMAKE_BUILD_TYPE=Release \
  -DLOG_TRACKING_TIMESTAMPS=ON
catkin build
