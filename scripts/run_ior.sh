#!/bin/bash
TMP_DIR=/tmp/$USER
AGENT_DIR=$TMP_DIR
URI_PATH=$HOME
HDF5_DAOS_VOL_BUILD_PATH=$HOME/daos-vol/build
orterun -np 4 \
-x D_LOG_FILE=$TMP_DIR/daos_client.log             \
-x D_LOG_MASK=ERR                                  \
-x CRT_PHY_ADDR_STR=ofi+sockets                    \
-x OFI_INTERFACE=ib0                               \
-x PSM2_MULTI_EP=1                                 \
-x FI_PSM2_DISCONNECT=1                            \
-x CRT_CTX_SHARE_ADDR=1                            \
-x CRT_CTX_NUM=8                                   \
-x CRT_TIMEOUT=10                                  \
-x DAOS_SINGLETON_CLI=1                            \
-x CRT_ATTACH_INFO_PATH=$URI_PATH                  \
-x DAOS_AGENT_DRPC_DIR=$AGENT_DIR                  \
-x HDF5_PLUGIN_PATH=$HDF5_DAOS_VOL_BUILD_PATH/bin  \
-x HDF5_VOL_CONNECTOR=daos                         \
-x DAOS_POOL=$1                                    \
-x DAOS_SVCL=$2                                    \
$HOME/ior/src/ior -a HDF5 -b 100m -t 1m -i 1 -w -r -E -k -W -R --hdf5.chunkSize=1024 \
--hdf5.objectClass=RP_3G1 \
--hdf5.serverNumber=0 \
--hdf5.whichRepetition=0 \
--hdf5.whichIterate=85 \
--hdf5.readOrWrite=read
