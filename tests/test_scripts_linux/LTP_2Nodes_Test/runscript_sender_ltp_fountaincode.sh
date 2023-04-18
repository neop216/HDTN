#!/bin/sh

# path variables
config_files=$HDTN_SOURCE_ROOT/config_files
hdtn_config=$config_files/hdtn/hdtn_Node1_ltp.json
gen_config=$config_files/outducts/bpgen_one_stcp_port4556_2NodesTest.json
fountain_code_testfiles=$HDTN_SOURCE_ROOT/fountain_code_testfiles

cd $HDTN_SOURCE_ROOT

# HDTN one process
./build/module/hdtn_one_process/hdtn-one-process  --contact-plan-file=contactPlan2Nodes.json --hdtn-config-file=$hdtn_config &
sleep 20

# Fountain Code Encoder
./common/fountain_code/encode.py $fountain_code_testfiles/testfiles $fountain_code_testfiles/encodefiles -b 65536 -r 2.0
sleep 20

# BP Send File 
./build/common/bpcodec/apps/bpsendfile  --use-bp-version-7  --max-bundle-size-bytes=4000000 --file-or-folder-path=$fountain_code_testfiles/encodefiles --my-uri-eid=ipn:1.1 --dest-uri-eid=ipn:2.1 --outducts-config-file=$gen_config &
bpsend_PID=$!
sleep 20


