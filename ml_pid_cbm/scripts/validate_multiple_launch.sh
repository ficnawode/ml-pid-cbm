
#!/bin/bash

RESULT_DIR=$1
LOG_DIR=$RESULT_DIR/log

echo "logs can be found at $LOG_DIR"

MLPIDCBM_DIR=/lustre/cbm/users/$USER/ml-pid-cbm/ml_pid_cbm
CONFIG=$MLPIDCBM_DIR/slurm_config.json

sbatch --job-name="val-mult"\
        --partition main\
        --output=$LOG_DIR/out/%j.out.log \
        --error=$LOG_DIR/error/%j.err.log \
        --wait\
        -- $PWD/jobs/validate_multiple_job.sh $WORK_DIR $CONFIG

eval "$(conda shell.bash hook)"
conda activate cbm23
python util/notify.py --config util/telegram_bot_config.json --message "Validation has finished and can be found at $RESULT_DIR"