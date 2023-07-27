#!/bin/bash

timestamp=$(date +"%Y%m%d_%H%M%S")
NEW_DIR_NAME="train_${timestamp}"
WORK_DIR=/lustre/cbm/users/$USER/pid/$NEW_DIR_NAME
mkdir -p $WORKDIR
LOGDIR=$WORKDIR/log
mkdir -p $LOGDIR
mkdir -p $LOGDIR/out
mkdir -p $LOGDIR/error

echo "logs can be found at $LOGDIR"

NBINS="6"

sbatch --job-name="all" \
        -t 6:00:00 \
        --partition main \
        --output=$LOGDIR/out/%j.out.log \
        --error=$LOGDIR/error/%j.err.log \
        --array=1-$NBINS\
        --wait\
        -- $PWD/slurm_ml_pid.sh $WORKDIR $NBINS 

eval "$(conda shell.bash hook)"
conda activate cbm23
python notify/notify.py --config notify/telegram_bot_config.json --message "Your neural network has finished training and results can be found at $WORKDIR"