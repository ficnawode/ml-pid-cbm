#!/bin/bash

read -p "Do you want to start the job? (y/n): " response

if [ "$response" != "y" ]; then
    echo "Exiting the program."
    exit 1
fi

timestamp=$(date +"%Y%m%d_%H%M%S")

# Create the directory with the desired name
DIR_NAME="batchrun_train_${timestamp}"
WORKDIR=/lustre/cbm/users/$USER/pid/$DIR_NAME
mkdir -p $WORKDIR
echo "Created directory: $WORKDIR"
LOGDIR=$WORKDIR/log
mkdir -p $LOGDIR
mkdir -p $LOGDIR/out
mkdir -p $LOGDIR/error

echo "logs can be found at $LOGDIR"

alias conda="/lustre/cbm/users/$USER/miniconda3/bin/conda"

NBINS="5"

mlpidpath=/lustre/cbm/users/$USER/ml-pid-cbm/ml_pid_cbm
CONFIG=$mlpidpath/slurm_config.json


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