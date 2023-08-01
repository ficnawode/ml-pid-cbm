#!/bin/bash
RESULT_DIR=$1
NBINS=$2
CONFIG=$3

WORK_DIR=/lustre/cbm/users/$USER
MLPIDCBM_DIR=$WORK_DIR/ml-pid-cbm/ml_pid_cbm

PATH=$WORK_DIR/miniconda3/bin/:$PATH
eval "$(conda shell.bash hook)"
conda activate cbm23
cd $RESULT_DIR

python $MLPIDCBM_DIR/tools/auto_bin.py --config=$CONFIG --nbins=$NBINS
