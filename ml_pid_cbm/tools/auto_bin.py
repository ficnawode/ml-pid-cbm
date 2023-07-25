import numpy as np
from matplotlib import pyplot as plt
from load_data import LoadData
import argparse
import json


class AutoBin:
    @staticmethod
    def bin_by_momentum(config_path:str, ncuts:int=6) -> np.array:
        P = AutoBin.__load_dataframe(config_path)["Complex_p"];
        N = P.count()
        return AutoBin.__calculate_bins(P, N, ncuts)

    def __get_data_path(config_path: str)->str:
        with open(config_path) as f:
            d = json.load(f)
            return d["file_names"]["training"]
        
    @staticmethod
    def __load_dataframe(config_path: str):
        data_path = AutoBin.__get_data_path(config_path)
        load_data = LoadData(data_path, config_path, 0, 12, False)
        tree_handler = load_data.load_tree(data_path)
        return tree_handler.get_data_frame()

    @staticmethod
    def __calculate_bins(x: np.array, N: np.array, ncuts:int) -> np.array:
        counts, bins, bars = plt.hist(x, bins=1000)
        Nchunk = N / ncuts
        Ns = [Nchunk*i for i in range(0, ncuts)]
        F1 = np.cumsum(counts)
        return np.interp(Ns, F1, bins[1:])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
                    prog='autobinner',
                    description='',
                    epilog='')
    parser.add_argument('-c', '--config')
    parser.add_argument('-n', '--nbins')
    args = parser.parse_args()  
    AutoBin.bin(args.config, int(args.nbins))