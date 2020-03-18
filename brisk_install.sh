#!/bin/bash

git clone https://github.com/gwli/brisk.git &&
cd brisk                                    &&
mkdir build                                 &&
cd build                                    &&
cmake -DCMAKE_BUILD_TYPE=Release ..         &&
make -j8
