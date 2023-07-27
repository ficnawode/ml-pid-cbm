#!/bin/bash
RESULT_DIR=$1
NBINS=$2
CONFIG=$3

WORK_DIR=/lustre/cbm/users/$USER
MLPIDCBM_DIR=$WORK_DIR/ml-pid-cbm/ml_pid_cbm
CONFIG=$MLPIDCBM_DIR/slurm_config.json

python $MLPIDCBM_DIR/tools/auto_bin.py --config $CONFIG --nbins=$NBINS
