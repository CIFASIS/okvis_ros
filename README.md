README                        {#mainpage}
======

## Original repository
This repository is a modified version of [okvis_ros](https://github.com/ethz-asl/okvis_ros) (see original README below). We facilitate the installation process and the use of Docker.

## Docker support

In order to facilitate the installation process, the system is wrapped up using Docker.
We provide scripts to create a Docker image, build the system and run it in a Docker container. 

### Dependencies 
* Docker
* ROS
* [`pose_listener`](https://github.com/CIFASIS/pose_listener) (if you use `run_rosario_sequence.sh`, see below)

### Building the system
Run:
```
./run.sh -b
```

This command creates a Docker image, installs all the dependencies and builds the system. The resulting image contains a version of the system ready to be run.

### Running the system in VIS mode
If you are not interested in making changes in the source code, you should run the system in VIS mode. Run:
```
./run.sh -v
```
The system is launched in a Docker container based on the previously built image. By default, this command executes a launch file which is configured to run the Rosario dataset. If you want to run your own dataset, **write a launch file and placed it in the `launch/` folder**. Configuration files must be placed in the `config/` folder. Then, run the script with the option `-l <LAUNCH_FILE_NAME>`. For example, if you are testing EuRoC, write `euroc_dataset.launch`, move it into `launch/` and type:
```
./run.sh -v -l euroc_dataset.launch
```
Making changes in launch/configuration files in the host is possible because these folders are mounted into the Docker container. It is not necessary to access the container through a bash shell to modify these files.

See below for information about input data and visualization.

### Running the system in DEV mode
DEV mode allows developers to make changes in the source code, recompile the system and run it with the modifications. To do this, the whole repository is mounted in a container. Run:
```
./run.sh -d
```
This opens a bash shell in a docker container. You can edit source files in the host and after that you can use this shell to recompile the system. When the compilation process finishes, you can run the method using `roslaunch`.

See below for information about input data and visualization.

### Input data and visualization

At this point, the system is waiting for input data. Either you can run `rosbag play` or you can use `run_rosario_sequence.sh`.
If you choose the latter, open a second terminal and run:
```
./run_rosario_sequence.sh -o <OUTPUT_TRAJECTORY_FILE> <ROSBAG_FILE>
```
In contrast to what `run.sh` does, `run_rosario_sequence.sh` executes commands in the host (you can modify it to use a Docker container). 

`ROSBAG_FILE` is played using `rosbag`. Also, make sure you have cloned and built `pose_listener` in your catkin workspace. Default path for the workspace is `${HOME}/catkin_ws`, set `CATKIN_WS_DIR` if the workspace is somewhere else (e.g.: `export CATKIN_WS_DIR=$HOME/foo_catkin_ws`). `pose_listener` saves the estimated trajectory in `<OUTPUT_TRAJECTORY_FILE>` (use absolute path). You can edit `run_rosario_sequence.sh` if you prefer to save the trajectory using your own methods. Additionally, `run_rosario_sequence.sh` launches `rviz` to display visual information during the execution of the system.

Alternatively, if you are not interested in development but in testing or visualization, instead of running `run.sh` and `run_rosario_sequence.sh` in two different terminals, you can just run:
```
./run_rosario_sequence.sh -r -o <OUTPUT_TRAJECTORY_FILE> <ROSBAG_FILE>
```
This launches a Docker container and executes the default launch file (see `LAUNCH_FILE` in `run.sh`). After that, the bagfile is played and `rviz` and `pose_listener` are launched. Add `-b` if you want to turn off the visualization.



# Original README

Welcome to OKVIS: Open Keyframe-based Visual-Inertial SLAM. 

This is the Author's implementation of the [1] and [3] with more results in [2].

[1] Stefan Leutenegger, Simon Lynen, Michael Bosse, Roland Siegwart and Paul 
    Timothy Furgale. Keyframe-based visual–inertial odometry using nonlinear 
    optimization. The International Journal of Robotics Research, 2015.

[2] Stefan Leutenegger. Unmanned Solar Airplanes: Design and Algorithms for 
    Efficient and Robust Autonomous Operation. Doctoral dissertation, 2014.

[3] Stefan Leutenegger, Paul Timothy Furgale, Vincent Rabaud, Margarita Chli, 
    Kurt Konolige, Roland Siegwart. Keyframe-Based Visual-Inertial SLAM using 
    Nonlinear Optimization. In Proceedings of Robotics: Science and Systems, 
    2013.

Note that the codebase that you are provided here is free of charge and without 
any warranty. This is bleeding edge research software.

Also note that the quaternion standard has been adapted to match Eigen/ROS, 
thus some related mathematical description in [1,2,3] will not match the 
implementation here.

If you publish work that relates to this software, please cite at least [1].

### How do I get set up? ###

This is a catkin package that wraps the pure CMake project.

You will need to install the following dependencies,

* ROS (currently supported: hydro, indigo and jade). Read the instructions in 
  http://wiki.ros.org/indigo/Installation/Ubuntu. You will need the additional 
  package pcl-ros as (assuming indigo)

        sudo apt-get install ros-indigo-pcl-ros

* google-glog + gflags,

        sudo apt-get install libgoogle-glog-dev
   
* The following should get installed through ROS anyway:

        sudo apt-get install libatlas-base-dev libeigen3-dev libsuitesparse-dev 
        sudo apt-get install libopencv-dev libboost-dev libboost-filesystem-dev

* Optional: use the the package with the Skybotix VI sensor.
  Note that this requires a system install, not just as ROS package. Also note 
  that Skybotix OSX support is experimental (checkout the feature/osx branch).

        git clone https://github.com/ethz-asl/libvisensor.git
        cd libvisensor
        ./install_libvisensor.sh

then download and expand the archive into your catkin workspace:

    wget https://www.doc.ic.ac.uk/~sleutene/software/okvis_ros-1.1.3.zip
    unzip okvis_ros-1.1.3.zip && rm okvis_ros-1.1.3.zip

Or, clone the repository from github into your catkin workspace:

    git clone --recursive git@github.com:ethz-asl/okvis_ros.git

or

    git clone --recursive https://github.com/ethz-asl/okvis_ros.git

### Building the project ###

From the catkin workspace root, type 

    catkin_make
    
You will find a demo application in okvis_apps. It can process datasets in the 
ASL/ETH format.

In order to run a minimal working example, follow the steps below:

1. Download a dataset of your choice from 
   http://projects.asl.ethz.ch/datasets/doku.php?id=kmavvisualinertialdatasets. 
   Assuming you downloaded MH_01_easy/. 
   You will find a corresponding calibration / estimator configuration in the 
   okvis/config folder.

2. Run the app as

        ./okvis_apps path/to/okvis_ros/okvis/config/config_fpga_p2_euroc.yaml path/to/MH_01_easy/
				
You can also run a dataset processing ros node that will publish topics that can 
be visualized with rviz

    rosrun okvis_ros okvis_node_synchronous path/to/okvis_ros/okvis/config/config_fpga_p2_euroc.yaml path/to/MH_01_easy/

Use the rviz.rviz configuration in the okvis_ros/config/ directory to get the pose / 
landmark display.

If you want to run the live application connecting to a sensor, use the okvis_node 
application (modify the launch file launch/okvis_node.launch).

### Outputs and frames

In terms of coordinate frames and notation, 

* W denotes the OKVIS World frame (z up), 
* C\_i denotes the i-th camera frame, 
* S denotes the IMU sensor frame,
* B denotes a (user-specified) body frame.

The output of the okvis library is the pose T\_WS as a position r\_WS and quaternion 
q\_WS, followed by the velocity in World frame v\_W and gyro biases (b_g) as well as 
accelerometer biases (b_a). See the example application to get an idea on how to
use the estimator and its outputs (callbacks returning states).

The okvis_node ROS application will publish a configurable state -- see just below.

### Configuration files ###

The okvis/config folder contains example configuration files. Please read the
documentation of the individual parameters in the yaml file carefully. 
You have various options to trade-off accuracy and computational expense as well 
as to enable online calibration. You also have various options concerning the
things that will get published -- in particular weather or not landmarks should
be published (may be important to turn off for on-bard operation). Moreover, you 
can specify how the body frame is specified (T_BS) or define a custom World frame.
In other words, the final pose published will be 
T\_Wc\_B = T\_Wc\_W * T\_WS * T\_BS^(-1) . You have the option to express the
velocity as well as the rotation rates in either B, S, or Wc. 

### HEALTH WARNING: calibration ###

If you would like to run the software/library on your own hardware setup, be 
aware that good results (or results at all) may only be obtained with 
appropriate calibration of the 

* camera intrinsics,
* camera extrinsics (poses relative to the IMU), 
* knowledge about the IMU noise parameters,
* and ACCURATE TIME SYNCHRONISATION OF ALL SENSORS.

To perform a calibration yourself, we recommend the following:

* Get Kalibr by following the instructions here 
  https://github.com/ethz-asl/kalibr/wiki/installation . If you decide to build from 
	source and you run ROS indigo checkout pull request 3:

    git fetch origin pull/3/head:request3
    git checkout request3

* Follow https://github.com/ethz-asl/kalibr/wiki/multiple-camera-calibration to 
  calibrate intrinsic and extrinsic parameters of the cameras. If you receive an 
  error message that the tool was unable to make an initial guess on focal 
  length, make sure that your recorded dataset contains frames that have the 
  whole calibration target in view.

* Follow https://github.com/ethz-asl/kalibr/wiki/camera-imu-calibration to get 
  estimates for the spatial parameters of the cameras with respect to the IMU.

### Contribution guidelines ###

* Contact s.leutenegger@imperial.ac.uk to request access to the bitbucket 
  repository.

* Programming guidelines: please follow 
  https://github.com/ethz-asl/programming_guidelines/wiki/Cpp-Coding-Style-Guidelines .
	
* Writing tests: please write unit tests (gtest).

* Code review: please create a pull request for all changes proposed. The pull 
  request will be reviewed by an admin before merging.

### Support ###

The developpers will be happy to assist you or to consider bug reports / feature 
requests. But questions that can be answered reading this document will be 
ignored. Please contact s.leutenegger@imperial.ac.uk.

### Docker and testing on the Rosario Dataset ###

Being in the okvis_ros directory, to build the image execute this:

```bash
docker build --rm --tag okvis:ros_kinetic .
```

To run on the Rosario dataset:

```bash
docker run --rm -it --net=host -v "`pwd`/config:/root/catkin_ws/src/okvis_ros/config:ro" -v "`pwd`/launch:/root/catkin_ws/src/okvis_ros/launch:ro" okvis:ros_kinetic roslaunch okvis_ros okvis_node_rosario.launch
```

Then launch visualization (`rviz -d rviz/okvis.rviz &`) and play some sequence (`rosbag play --pause --clock path/to/sequence04.bag`).

To visualize the output after, it is neccesary to record the odometry topic (using [`pose_listener`](https://github.com/jcremona/pose_listener) it would be `rosrun pose_listener pose_listener _topic:=/okvis_node/okvis_odometry _type:=O`). Then it can be plotted with [evo](https://github.com/MichaelGrupp/evo):

```bash
evo_traj tum trajectory.txt --plot
```
