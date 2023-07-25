#!/bin/bash

CONFIG=$1
NBINS=$2

eval "$(conda shell.bash hook)"
conda activate cbm23
export PYTHONPATH=/lustre/cbm/users/tfic/ml-pid-cbm/
python ml_job.py --config=$CONFIG --nbins=$NBINS