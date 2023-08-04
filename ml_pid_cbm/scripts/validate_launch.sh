#!/bin/bash

RESULT_DIR='/lustre/cbm/users/tfic/pid/train_20230803_132715'
CONFIG='/lustre/cbm/users/tfic/ml-pid-cbm/ml_pid_cbm/scripts/configs/config10bins.json'
NBINS='10'

LOG_DIR=$RESULT_DIR/log
mkdir -p $LOG_DIR
mkdir -p $LOG_DIR/out
mkdir -p $LOG_DIR/error

sbatch --job-name="validate-all"\
        --partition main\
        --mem=4095 \
        --output=$LOG_DIR/out/%j.out.log \
        --error=$LOG_DIR/error/%j.err.log \
        --array=1-$NBINS\
        -- $PWD/jobs/validate_job.sh $RESULT_DIR $CONFIG