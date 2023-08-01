import numpy as np
from matplotlib import pyplot as plt
from tools.load_data import LoadData
from hipe4ml.tree_handler import TreeHandler
import argparse
import json
import gc


class AutoBin:
    @staticmethod
    def bin_by_momentum(config_path:str, ncuts:int=6, npieces:int = 8) -> np.array:
        p = AutoBin.__load_momentum(config_path, npieces);
        N = len(p)
        bins = AutoBin.__calculate_bins(p, N, ncuts)
        print(bins)
        return bins

    @staticmethod
    def __get_data_path(config_path: str)->str:
        with open(config_path) as f:
            d = json.load(f)
            return d["file_names"]["training"]
    
    @staticmethod
    def __load_data_chunk(config_path:str, lower_p_cut:float, upper_p_cut:float)->TreeHandler:
        data_path = AutoBin.__get_data_path(config_path)
        loader = LoadData(data_path,config_path,lower_p_cut, upper_p_cut, anti_particles=False)
        return loader.load_tree()

    @staticmethod
    def __load_momentum_chunk(config_path:str, lower_cut:float, upper_cut:float)->np.array:
        tree_loader = AutoBin.__load_data_chunk(config_path, lower_cut, upper_cut)
        p = tree_loader.get_data_frame()["Complex_p"].to_numpy(copy=True)
        print(f"momentum chunk length: {len(p)}")
        return p

    @staticmethod
    def __load_momentum(config_path:str, npieces:int=8)->np.array:
        chunk_boundaries = np.arange(0,12.01,12/npieces)
        p = []
        for i in range(1, len(chunk_boundaries)):
            lower_cut,upper_cut = chunk_boundaries[i-1:i+1]
            print(f"chunking: {lower_cut} - {upper_cut}")
            new_p = AutoBin.__load_momentum_chunk(config_path, lower_cut, upper_cut)
            p = np.append(p, new_p)
            print(f"full momentum array length: {len(p)}")
        return p


    @staticmethod
    def __calculate_bins(x: np.array, N: np.array, ncuts:int) -> np.array:
        counts, edges, bars = plt.hist(x, bins=1000)
        Nchunk = N / ncuts
        Ns = [Nchunk*i for i in range(0, ncuts)]
        F1 = np.cumsum(counts)
        bins = np.append(np.interp(Ns, F1, edges[1:]), 12)
        plt.vlines(bins,[0 for x in bins],[counts.max() for x in bins], colors=['red' for x in bins])
        plt.savefig("momentum_distribution.jpg", dpi=350)
        plt.xlabel("p")
        plt.ylabel("N")
        plt.show()
        counts, edges, bars = plt.hist(x,bins=bins)
        plt.bar_label(bars)
        plt.xlabel("p")
        plt.ylabel("N")
        plt.savefig("even_binning_hist.jpg")
        plt.show()
        return bins

    @staticmethod
    def parse_args()->argparse.Namespace:
        parser = argparse.ArgumentParser(
                            prog='autobinner',
                        description='',
                        epilog='')
        parser.add_argument('-c', '--config', help="Path to config.json file", type=str)
        parser.add_argument('-n', '--nbins', help="Number of bins to separate the data into", type=int, default=5)
        parser.add_argument('-p', '--npieces', help="Number of pieces to split the data into at loading", type=int, default=8)
        return parser.parse_args()  
    

if __name__ == "__main__":
    args = AutoBin.parse_args()
    bins = AutoBin.bin_by_momentum(args.config, int(args.nbins), int(args.npieces))
    with open(args.config, "r") as fp:
        config = json.load(fp)
    config['bins'] = bins.tolist()
    with open(args.config, "w") as fp:
        json.dump(config, fp)
