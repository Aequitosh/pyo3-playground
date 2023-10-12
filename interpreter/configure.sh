#!/usr/bin/env bash

cmake -S . -B build/debug -DCMAKE_BUILD_TYPE=Debug
cmake -S . -B build/release -DCMAKE_BUILD_TYPE=RelWithDebInfo

