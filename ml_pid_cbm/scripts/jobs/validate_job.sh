#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate cbm23

RESULT_DIR=$1 #/lustre/cbm/users/$USER/pid/train_20230801_092302
MLPIDCBM_DIR=/lustre/cbm/users/$USER/ml-pid-cbm/ml_pid_cbm

cd $RESULT_DIR
SLURM_INDEX=${SLURM_ARRAY_TASK_ID}

iteration_count=0
for dir in model_*
do
    if [[ -d "$dir" ]]; then
        readymodels+="$dir "
        echo $dir
        CONFIG=$RESULT_DIR/$dir/slurm_config.json
        echo $CONFIG

        iteration_count=$((iteration_count + 1))

        # Check if the current iteration count matches the target number
        if [[ $iteration_count -eq $SLURM_INDEX ]]; then
            python $MLPIDCBM_DIR/validate_model.py -c $CONFIG -m $dir -n 4 -e .4 .95 40
        fi
    fi
done