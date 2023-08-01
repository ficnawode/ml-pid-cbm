#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate cbm23

RESULT_DIR=$1 #/lustre/cbm/users/$USER/pid/train_20230801_092302
MLPIDCBM_DIR=/lustre/cbm/users/$USER/ml-pid-cbm/ml_pid_cbm

cd $RESULT_DIR

#validation of single models
for dir in model_*
    do
        if [[ -d "$dir" ]]; then
            readymodels+="$dir "
            echo $dir
            CONFIG=$RESULT_DIR/$dir/slurm_config.json
            echo $CONFIG
            python $MLPIDCBM_DIR/validate_model.py -c $CONFIG -m $dir -n 4 -e .4 .95 40 
       fi
done
python $MLPIDCBM_DIR/validate_multiple_models.py -c $CONFIG -m $readymodels --nworkers 4