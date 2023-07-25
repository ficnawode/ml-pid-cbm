import argparse
from train_model import TrainModel
from tools.auto_bin import AutoBin
import os
import subprocess


class MlPIDJob:
    def __init__(self, config_path, nbins = 6):
        self.bins = AutoBin.bin_by_momentum(config_path, nbins)
        self.slurm_index = os.getenv("SLURM_INDEX")
    
    def run(self):
        train_model = TrainModel()
    
    @staticmethod
    def parse_args()->argparse.Namespace:
        parser = argparse.ArgumentParser(
                        prog='PID job for slurm',
                        description='',
                        epilog='')
        parser.add_argument('-b', '--nbins', type=int)
        parser.add_argument('-c', '--config')
        return parser.parse_args()  


if __name__ == "__main__":
    args = MlPIDJob.parse_args()
    job = MlPIDJob(args.config, args.nbins)
    job.run()
    pass