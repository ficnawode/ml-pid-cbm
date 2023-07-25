#!/bin/bash

RESULTDIR=$1
NBINS=$2
PYTHON_OUTPUT=$3
bins_string=${PYTHON_OUTPUT//\"/}
echo $bins_string


INDEX=${SLURM_ARRAY_TASK_ID}
WORK=/lustre/cbm/users/$USER

#path to ml-pid-cbm python package
mlpidpath=$WORK/ml-pid-cbm/ml_pid_cbm
#load conda from home directory on lustre
export PATH=$WORK/miniconda3/bin/:$PATH
eval "$(conda shell.bash hook)"
conda activate cbm23
#needed for pritning graphs as slurm doesn't find it automatically
export FONTCONFIG_FILE=$CONDA_PREFIX/etc/fonts/fonts.conf
export FONTCONFIG_PATH=$CONDA_PREFIX/etc/fonts/
#get into folder for training
CONFIG=$mlpidpath/slurm_config.json
cd $RESULTDIR

IFS=' ' read -r -a bins <<< "$bins_string"
echo "${bins[@]}"
UPPER_BOUND=${bins[$INDEX]}
echo "UPPER_BOUND=$UPPER_BOUND"
LOWER_BOUND=${bins[$INDEX-1]}
echo "LOWER_BOUND=$LOWER_BOUND"
#run training
python $mlpidpath/train_model.py -c $CONFIG -p $(LOWER_BOUND) $(UPPER_BOUND) --saveplots | tee training_output_${INDEX}.txt

