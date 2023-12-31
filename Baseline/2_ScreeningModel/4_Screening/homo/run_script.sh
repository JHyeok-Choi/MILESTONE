#!/usr/bin/env bash

export CUDA_VISIBLE_DEVICES=0
export PYTHONIOENCODING=utf-8

dataset="QM"
output_dir="../return_test/"$dataset"/"

time_stamp=`date '+%s'`

mkdir -p $output_dir"error/"
mkdir -p $output_dir"stdout/"


config_file="./"$dataset".json"

commit_id=`git rev-parse HEAD`

out_file=${output_dir}"stdout/"${time_stamp}_${commit_id}".out"
err_file=${output_dir}"error/"${time_stamp}_${commit_id}".err"

nohup python -u ./main.py --config=$config_file --id=$commit_id --ts=$time_stamp --dir=$output_dir \
  --wandb_project="pdf_test" 1>$out_file 2>$err_file &

pid=$!

echo "Stdout dir:   $out_file"
echo "Start time:   `date -d @$time_stamp  '+%Y-%m-%d %H:%M:%S'`"
echo "CUDA DEVICES: $CUDA_VISIBLE_DEVICES"
echo "pid:          $pid"
cat $config_file

tail -f $out_file $err_file -q
