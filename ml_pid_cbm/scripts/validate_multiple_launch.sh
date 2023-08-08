
#!/bin/bash

RESULT_DIR='/lustre/cbm/users/tfic/pid/train_20230804_120845'
CONFIG='/lustre/cbm/users/tfic/ml-pid-cbm/ml_pid_cbm/scripts/configs/newData10bins.json'
LOG_DIR=$RESULT_DIR/log

echo "logs can be found at $LOG_DIR"

MLPIDCBM_DIR=/lustre/cbm/users/$USER/ml-pid-cbm/ml_pid_cbm

sbatch --job-name="consolidate"\
        --partition high_mem\
        --mem=32000 \
        --output=$LOG_DIR/out/%j.out.log \
        --error=$LOG_DIR/error/%j.err.log \
        -- $PWD/jobs/validate_multiple_job.sh $RESULT_DIR $CONFIG