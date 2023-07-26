#!/bin/bash

CONFIG=$1
NBINS=$2

eval "$(conda shell.bash hook)"
conda activate cbm23
export PYTHONPATH=/lustre/cbm/users/tfic/ml-pid-cbm/
LOGDIR=/lustre/cbm/users/tfic/pid/log
python ml_job.py --config=$CONFIG --nbins=$NBINS >&$LOGDIR/log$SLURM_ARRAY_TASK_ID.txt