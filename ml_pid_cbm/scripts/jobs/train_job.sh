#!/bin/bash

RESULT_DIR=$1
NBINS=$2
CONFIG=$3

WORK_DIR=/lustre/cbm/users/$USER

#load conda from home directory on lustre
export PATH=$WORK_DIR/miniconda3/bin/:$PATH
eval "$(conda shell.bash hook)"
conda activate cbm23

#needed for pritning graphs as slurm doesn't find it automatically
export FONTCONFIG_FILE=$CONDA_PREFIX/etc/fonts/fonts.conf
export FONTCONFIG_PATH=$CONDA_PREFIX/etc/fonts/

cd $RESULT_DIR
INDEX=${SLURM_ARRAY_TASK_ID}
MLPIDCBM_DIR=/lustre/cbm/users/$USER/ml-pid-cbm/ml_pid_cbm
python $MLPIDCBM_DIR/train_model.py -c=$CONFIG --autobins=$NBINS --saveplots >&training_output_${INDEX}.txt

