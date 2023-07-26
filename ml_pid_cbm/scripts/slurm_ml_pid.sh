#!/bin/bash

RESULTDIR=$1
NBINS=$2


INDEX=${SLURM_ARRAY_TASK_ID}
WORK=/lustre/cbm/users/$USER

#path to ml-pid-cbm python package
mlpidpath=$WORK/ml-pid-cbm/ml_pid_cbm
#load conda from home directory on lustre
export PATH=$WORK/miniconda3/bin/:$PATH
eval "$(conda shell.bash hook)"
conda activate cbm23
#needed for pritning graphs as slurm doesn't find it automatically
export FONTCONFIG_FILE=$CONDA_PREFIX/etc/fonts/fonts.conf
export FONTCONFIG_PATH=$CONDA_PREFIX/etc/fonts/
#get into folder for training
CONFIG=$mlpidpath/slurm_config.json
cd $RESULTDIR

#run training
python $mlpidpath/train_model.py -c $CONFIG --autobins=$NBINS --saveplots >&training_output_${INDEX}.txt

