#!/bin/bash

timestamp=$(date +"%Y%m%d_%H%M%S")
NEW_DIR_NAME="train_${timestamp}"
WORK_DIR=/lustre/cbm/users/$USER/pid/$NEW_DIR_NAME
mkdir -p $WORK_DIR
echo "created directory $WORK_DIR"
LOG_DIR=$WORK_DIR/log
mkdir -p $LOG_DIR
mkdir -p $LOG_DIR/out
mkdir -p $LOG_DIR/error

echo "logs can be found at $LOG_DIR"

NBINS="5"

MLPIDCBM_DIR=/lustre/cbm/users/$USER/ml-pid-cbm/ml_pid_cbm
CONFIG=$MLPIDCBM_DIR/slurm_config.json

# sbatch --job-name="autobin"\
#         --partition main\
#         --output=$LOG_DIR/out/%j.out.log \
#         --error=$LOG_DIR/error/%j.err.log \
#         --wait\
#         -- $PWD/jobs/autobin_job.sh $WORK_DIR $NBINS $CONFIG

sbatch --job-name="train-all" \
        -t 6:00:00 \
        --partition main \
        --output=$LOG_DIR/out/%j.out.log \
        --error=$LOG_DIR/error/%j.err.log \
        --array=1-$NBINS\
        --wait\
        -- $PWD/jobs/train_job.sh $WORK_DIR $NBINS $CONFIG

sbatch --job-name="validate-all"\
        --partition main\
        --output=$LOG_DIR/out/%j.out.log \
        --error=$LOG_DIR/error/%j.err.log \
        --wait\
        -- $PWD/jobs/validate_job.sh $WORK_DIR $CONFIG

eval "$(conda shell.bash hook)"
conda activate cbm23
python util/notify.py --config util/telegram_bot_config.json --message "Your neural network has finished training and results can be found at $WORK_DIR"