#!/bin/bash

# Copyright 2015-2016, Google Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set -ex

cd $(dirname $0)/../..
set root=`pwd`
CC=${CC:-cc}

# allow openssl to be pre-downloaded
if [ ! -e third_party/openssl-1.0.2f.tar.gz ]
then
  echo "Downloading http://openssl.org/source/openssl-1.0.2f.tar.gz to third_party/openssl-1.0.2f.tar.gz"
  wget http://openssl.org/source/openssl-1.0.2f.tar.gz -O third_party/openssl-1.0.2f.tar.gz
fi

# clean openssl directory
rm -rf third_party/openssl-1.0.2f

# extract archive
cd third_party
tar xfz openssl-1.0.2f.tar.gz

# build openssl
cd openssl-1.0.2f
CC="$CC -fPIC -fvisibility=hidden" ./config no-asm
make

# generate the 'grpc_obj' directory needed by the makefile
mkdir grpc_obj
cd grpc_obj
ar x ../libcrypto.a
ar x ../libssl.a
