#!/bin/bash
TMP_DIR=/tmp/$USER
AGENT_DIR=$TMP_DIR
URI_PATH=$HOME
HDF5_DAOS_VOL_BUILD_PATH=$HOME/daos-vol_new/build

mpirun -np 8 \
-x D_LOG_FILE=$TMP_DIR/daos_client.log             \
-x D_LOG_MASK=ERR                                  \
-x CRT_PHY_ADDR_STR=ofi+sockets                    \
-x OFI_INTERFACE=ib0                               \
-x CRT_TIMEOUT=10                                  \
-x DAOS_SINGLETON_CLI=1                            \
-x CRT_ATTACH_INFO_PATH=$URI_PATH                  \
-x DAOS_AGENT_DRPC_DIR=$AGENT_DIR                  \
-x HDF5_PLUGIN_PATH=$HDF5_DAOS_VOL_BUILD_PATH/bin  \
-x HDF5_VOL_CONNECTOR=daos                         \
-x DAOS_POOL=$1                                    \
-x DAOS_SVCL=$2                                    \
$HOME/ior/src/ior -i 3 -w -W -r -R -b 8m -t 128k -a HDF5 \
--hdf5.chunkSize=1024 \
--hdf5.objectClass=RP_3G1 \
--hdf5.nFaultInjects=2 \
--hdf5.daosServerRanks=4,2 \
--hdf5.faultIterates=0,1 \
--hdf5.faultRW=read,read
