#!/bin/sh

# path variables
config_files=$HDTN_SOURCE_ROOT/config_files
hdtn_config=$config_files/hdtn/hdtn_Node2_ltp.json
sink_config=$config_files/inducts/bpsink_one_stcp_port4558_2NodesTest.json
fountain_code_testfiles=$HDTN_SOURCE_ROOT/fountain_code_testfiles

cd $HDTN_SOURCE_ROOT

# BP Receive File
./build/common/bpcodec/apps/bpreceivefile --save-directory=received --my-uri-eid=ipn:2.1 --inducts-config-file=$sink_config &
bpreceive_PID=$!
sleep 20

# HDTN one process
./build/module/hdtn_one_process/hdtn-one-process --contact-plan-file=contactPlan2Nodes.json  --hdtn-config-file=$hdtn_config &
sleep 40

# Fountain Code Decoder
./common/fountain_code/decode.py ./received $fountain_code_testfiles/outfiles
sleep 20


