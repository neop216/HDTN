#!/bin/sh

# path variables
config_files=$HDTN_SOURCE_ROOT/config_files
hdtn_config=$config_files/hdtn/hdtn_ingress1tcpclv4_port4556_egress1tcpclv4_port4558flowid2.json
sink_config=$config_files/inducts/bpsink_one_tcpclv4_port4558.json
gen_config=$config_files/outducts/bpgen_one_tcpclv4_port4556.json
fountain_code_testfiles=$HDTN_SOURCE_ROOT/fountain_code_testfiles

cd $HDTN_SOURCE_ROOT

# BP Receive File
./build/common/bpcodec/apps/bpreceivefile --save-directory=received --my-uri-eid=ipn:2.1 --inducts-config-file=$sink_config &
bpreceive_PID=$!
sleep 3

# HDTN one process
./build/module/hdtn_one_process/hdtn-one-process --contact-plan-file=contactPlanCutThroughMode.json --hdtn-config-file=$hdtn_config &
one_process_PID=$!
sleep 6

# Fountain Code Encoder
./common/fountain_code/encode.py $fountain_code_testfiles/testfiles $fountain_code_testfiles/encodefiles -b 65536 -r 2.0
sleep 20

# BP Send File 
./build/common/bpcodec/apps/bpsendfile  --use-bp-version-7  --max-bundle-size-bytes=4000000 --file-or-folder-path=$fountain_code_testfiles/encodefiles --my-uri-eid=ipn:1.1 --dest-uri-eid=ipn:2.1 --outducts-config-file=$gen_config &
bpsend_PID=$!
sleep 20

# Fountain Code Decoder
./common/fountain_code/decode.py ./received $fountain_code_testfiles/outfiles
sleep 20

# cleanup
sleep 55
echo "\nkilling bp send file..." && kill -2 $bpsend_PID
sleep 2
echo "\nkilling HDTN one process ..." && kill -2 $one_process_PID
sleep 2
echo "\nkilling bp receive file..." && kill -2 $bpreceive_PID


