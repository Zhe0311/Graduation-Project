from cmath import nan
import matplotlib
import matplotlib.pyplot as plt
import numpy as np

from read_data import read_track_csv

def get_data(data_path: str) -> list:
    return read_track_csv(data_path)

if __name__ == '__main__':
    data_path = "../../../../Desktop/highD-dataset-v1.0/data/01_tracks.csv"
    tracksInfo = get_data(data_path)

    # plot

    index = 2
    t = [i for i in range(len(tracksInfo[index]["xVelocity"]))]
    
    fig = plt.figure()

    ax1 = fig.add_subplot(111)
    ax1.plot(t, tracksInfo[index]["xAcceleration"])
    
    ax2 = ax1.twinx()
    ax2.plot(t, tracksInfo[index]["thw"])
    ax2.plot(t, tracksInfo[index]["ttc"])

    ax1.legend(["xVelocity"])
    ax2.legend(["thw", "ttc"])
    plt.show()
    