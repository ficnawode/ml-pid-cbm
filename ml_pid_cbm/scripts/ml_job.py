import os
import argparse
from ml_pid_cbm.tools.auto_bin import AutoBin
import subprocess


class MlPIDJob:
    def __init__(self, config_path, nbins = 6):
        self.config_path=config_path
        self.nbins = nbins
        parent = os.path.join(os.getcwd(), os.pardir)
        self.ml_pid_path = os.path.abspath(parent)


    def run(self):
        print("made it to run method")
        cmd = "python"
        cmd += f"{self.ml_pid_path}/train_model.py"
        cmd += f"--config={self.config_path}"

        print("made it to run calculating bounds")
        lower, upper = self.calculate_bounds(self.config_path, self.nbins)
        cmd += f"-p {lower} {upper}"
        cmd += f"--saveplots"
        cmd += f"tee training_output_{self.slurm_index}.txt"
        print("made it to subprocess running")
        subprocess.run(cmd)
    
    @staticmethod
    def calculate_bounds(config_path, nbins):
        bins = AutoBin.bin_by_momentum(config_path, nbins)
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
    args = MlPIDJob.parse_args()
    job = MlPIDJob(args.config, args.nbins)
    job.run()