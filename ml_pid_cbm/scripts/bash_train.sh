#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate cbm22

CONFIG="config.json"

#positive and negative particles
for i in 0 1 2 3 4 5 6 
do
    python -u ../../train_model.py -c $CONFIG -p $i $((i+1)) --saveplots --nworkers 16 --usevalidation --hyperparams | tee train_from_$i.txt
done
python -u ../../train_model.py -c $CONFIG -p 8 12 --saveplots --nworkers 16 --usevalidation --hyperparams | tee train_from_8.txt
