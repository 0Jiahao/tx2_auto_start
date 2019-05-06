#!/bin/sh

# start camera node
gnome-terminal --tab "realsense" -x bash -c "source /opt/ros/kinetic/setup.bash;source ~/catkin_ws/devel/setup.bash;roslaunch realsense2_camera rs_low_res.launch;exec bash;"

sleep 1s

# start orb node
gnome-terminal --tab "orb_slam" -x bash -c "source /opt/ros/kinetic/setup.bash;source ~/catkin_ws/devel/setup.bash;export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/nvidia/ORB_SLAM2_GPU/Examples/ROS;rosrun ORB_SLAM2_GPU Mono /home/nvidia/ORB_SLAM2_GPU/Vocabulary/ORBvoc.txt /home/nvidia/ORB_SLAM2_GPU/Examples/Monocular/realsense_mono_low_res.yaml;exec bash;"

sleep 5s

# start fusion node
gnome-terminal --tab "fusion" -x bash -c "source /opt/ros/kinetic/setup.bash;source ~/catkin_ws/devel/setup.bash;roslaunch robot_localization orb_imu_fuse.launch;exec bash;"

sleep 1s

# start print odometry
gnome-terminal --tab "echo" -x bash -c "source /opt/ros/kinetic/setup.bash;source ~/catkin_ws/devel/setup.bash;rostopic echo /bebop2/odometry;exec bash;"

sleep 1s

# wait for wifi connection
name1=`iw wlan0 info | grep ssid | awk '{print $2}'`

name2="Bebop2-068469"

#if [ "${name1}" != "${name2}" ]; then
#echo "not equal"
#fi

while [ "${name1}" != "${name2}" ]
do
	name1=`iw wlan0 info | grep ssid | awk '{print $2}'`
	echo "[INFO] wait for connection ..."
done

echo "[INFO] bebop is connected!"

echo "[INFO] Start ROS nodes!"

# start ground control node
gnome-terminal --tab "ground_control" -x bash -c "source /opt/ros/kinetic/setup.bash;source ~/catkin_ws/devel/setup.bash;roslaunch ground_control joystick_node.launch;exec bash;"

sleep 1s


