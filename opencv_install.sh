#!/usr/bin/env bash

ALL_OPENCV_MODULES="calib3d core features2d highgui imgcodecs imgproc objdetect photo video videoio ximgproc xphoto aruco bgsegm bioinspired ccalib datasets dnn dnn_objdetect dpm face flann freetype fuzzy hdf hfs img_hash java_bindings_generator line_descriptor ml optflow phase_unwrapping plot python_bindings_generator python_tests reg rgbd saliency sfm shape stereo stitching structured_light superres surface_matching text tracking videostab world xfeatures2d xobjdetect"

apt-get remove x264 libx264-dev
apt-get install -y build-essential checkinstall cmake pkg-config yasm
apt-get install -y git gfortran
apt-get install -y libjpeg8-dev libjasper-dev libpng12-dev
apt-get install -y libtiff4-dev
apt-get install -y libtiff5-dev
apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
apt-get install -y libxine2-dev libv4l-dev
apt-get install -y libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
apt-get install -y qt5-default libgtk2.0-dev libtbb-dev
apt-get install -y libatlas-base-dev
apt-get install -y libfaac-dev libmp3lame-dev libtheora-dev
apt-get install -y libvorbis-dev libxvidcore-dev
apt-get install -y libopencore-amrnb-dev libopencore-amrwb-dev
apt-get install -y x264 v4l-utils
apt-get install -y libprotobuf-dev protobuf-compiler
apt-get install -y libgoogle-glog-dev libgflags-dev
apt-get install -y libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
apt-get install -y python-dev python-pip python3-dev python3-pip
pip install --upgrade pip
pip install numpy

git clone https://github.com/opencv/opencv.git
cd opencv
git checkout 3.4.7
cd ..

git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout 3.4.7
cd ..

# Disable All modules
for module in $ALL_OPENCV_MODULES; do
    export BUILD_opencv_${module}=OFF
done

# Enable listed modules
opencv_modules_to_install=$@
for module in $opencv_modules_to_install; do
    export BUILD_opencv_${module}=ON
done

cd opencv   &&
mkdir build &&
cd build    &&

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D INSTALL_C_EXAMPLES=OFF \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D WITH_TBB=ON \
      -D WITH_V4L=ON \
      -D WITH_QT=OFF \
      -D WITH_OPENGL=ON \
      -D OPENCV_ENABLE_NONFREE=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_opencv_aruco=${BUILD_opencv_aruco} \
      -D BUILD_opencv_bgsegm=${BUILD_opencv_bgsegm} \
      -D BUILD_opencv_bioinspired=${BUILD_opencv_bioinspired} \
      -D BUILD_opencv_calib3d=${BUILD_opencv_calib3d} \
      -D BUILD_opencv_ccalib=${BUILD_opencv_ccalib} \
      -D BUILD_opencv_core=${BUILD_opencv_core} \
      -D BUILD_opencv_datasets=${BUILD_opencv_datasets} \
      -D BUILD_opencv_dnn=${BUILD_opencv_dnn} \
      -D BUILD_opencv_dnn_objdetect=${BUILD_opencv_dnn_objdetect} \
      -D BUILD_opencv_dpm=${BUILD_opencv_dpm} \
      -D BUILD_opencv_face=${BUILD_opencv_face} \
      -D BUILD_opencv_features2d=${BUILD_opencv_features2d} \
      -D BUILD_opencv_flann=${BUILD_opencv_flann} \
      -D BUILD_opencv_freetype=${BUILD_opencv_freetype} \
      -D BUILD_opencv_fuzzy=${BUILD_opencv_fuzzy} \
      -D BUILD_opencv_hdf=${BUILD_opencv_hdf} \
      -D BUILD_opencv_hfs=${BUILD_opencv_hfs} \
      -D BUILD_opencv_highgui=${BUILD_opencv_highgui} \
      -D BUILD_opencv_imgcodecs=${BUILD_opencv_imgcodecs} \
      -D BUILD_opencv_img_hash=${BUILD_opencv_img_hash} \
      -D BUILD_opencv_imgproc=${BUILD_opencv_imgproc} \
      -D BUILD_opencv_java_bindings_generator=${BUILD_opencv_java_bindings_generator} \
      -D BUILD_opencv_line_descriptor=${BUILD_opencv_line_descriptor} \
      -D BUILD_opencv_ml=${BUILD_opencv_ml} \
      -D BUILD_opencv_objdetect=${BUILD_opencv_objdetect} \
      -D BUILD_opencv_optflow=${BUILD_opencv_optflow} \
      -D BUILD_opencv_phase_unwrapping=${BUILD_opencv_phase_unwrapping} \
      -D BUILD_opencv_photo=${BUILD_opencv_photo} \
      -D BUILD_opencv_plot=${BUILD_opencv_plot} \
      -D BUILD_opencv_python_bindings_generator=${BUILD_opencv_python_bindings_generator} \
      -D BUILD_opencv_python_tests=${BUILD_opencv_python_tests} \
      -D BUILD_opencv_reg=${BUILD_opencv_reg} \
      -D BUILD_opencv_rgbd=${BUILD_opencv_rgbd} \
      -D BUILD_opencv_saliency=${BUILD_opencv_saliency} \
      -D BUILD_opencv_sfm=${BUILD_opencv_sfm} \
      -D BUILD_opencv_shape=${BUILD_opencv_shape} \
      -D BUILD_opencv_stereo=${BUILD_opencv_stereo} \
      -D BUILD_opencv_stitching=${BUILD_opencv_stitching} \
      -D BUILD_opencv_structured_light=${BUILD_opencv_structured_light} \
      -D BUILD_opencv_superres=${BUILD_opencv_superres} \
      -D BUILD_opencv_surface_matching=${BUILD_opencv_surface_matching} \
      -D BUILD_opencv_text=${BUILD_opencv_text} \
      -D BUILD_opencv_tracking=${BUILD_opencv_tracking} \
      -D BUILD_opencv_video=${BUILD_opencv_video} \
      -D BUILD_opencv_videoio=${BUILD_opencv_videoio} \
      -D BUILD_opencv_videostab=${BUILD_opencv_videostab} \
      -D BUILD_opencv_world=${BUILD_opencv_world} \
      -D BUILD_opencv_xfeatures2d=${BUILD_opencv_xfeatures2d} \
      -D BUILD_opencv_ximgproc=${BUILD_opencv_ximgproc} \
      -D BUILD_opencv_xobjdetect=${BUILD_opencv_xobjdetect} \
      -D BUILD_opencv_xphoto=${BUILD_opencv_xphoto} .. &&
make -j `nproc --all`&&
make install -j`nproc --all` &&
sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf' &&
ldconfig
