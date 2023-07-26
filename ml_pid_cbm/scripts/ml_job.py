import os
import argparse
from ml_pid_cbm.tools.auto_bin import AutoBin
from ml_pid_cbm import train_model
import sys
import subprocess


class MlPIDJob:
    def __init__(self, config_path, nbins = 6):
        self.config_path=config_path
        self.nbins = nbins
        parent = os.path.join(os.getcwd(), os.pardir)
        self.ml_pid_path = os.path.abspath(parent)


    def run(self):
        print("made it to run calculating bounds")
        lower, upper = self.calculate_bounds(self.config_path, self.nbins)
        print(f"{lower}, {upper}")
        # print("made it to subprocess running")
        # train_model.launch(self.config_path, lower, upper)
    
    @staticmethod
    def calculate_bounds(tree_handler, nbins):
        bins = AutoBin.bin_by_momentum(tree_handler, nbins)
        slurm_index = os.getenv("SLURM_INDEX")
        return bins[slurm_index - 1], bins[slurm_index]
    
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
    print("Beginning logging")
    args = MlPIDJob.parse_args()
    print("Successfully parsed args")
    job = MlPIDJob(args.config, args.nbins)
    print("Successfully initialized job object")
    job.run()