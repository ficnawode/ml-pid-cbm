
#!/bin/bash

RESULT_DIR='/lustre/cbm/users/tfic/pid/train_20230803_132715'
CONFIG='/lustre/cbm/users/tfic/ml-pid-cbm/ml_pid_cbm/scripts/configs/config10bins.json'
LOG_DIR=$RESULT_DIR/log

echo "logs can be found at $LOG_DIR"

MLPIDCBM_DIR=/lustre/cbm/users/$USER/ml-pid-cbm/ml_pid_cbm

bash $PWD/jobs/validate_multiple_job.sh $RESULT_DIR $CONFIG
