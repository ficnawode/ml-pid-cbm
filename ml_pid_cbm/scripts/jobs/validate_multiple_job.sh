#!/bin/bash

# This job can only be run after 
# training and validation to combine 
# data from multiple validation processes

eval "$(conda shell.bash hook)"
conda activate cbm23

RESULT_DIR=$1 
CONFIG=$2
MLPIDCBM_DIR=/lustre/cbm/users/$USER/ml-pid-cbm/ml_pid_cbm

cd $RESULT_DIR
for dir in model_*
    do
        if [[ -d "$dir" ]]; then
            readymodels+="$dir "
       fi
done

python $MLPIDCBM_DIR/validate_multiple_models.py -c $CONFIG -m $readymodels --nworkers 4