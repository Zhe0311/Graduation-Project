from cmath import nan
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from scipy import stats

from read_data import read_track_csv

def get_data(data_path: str) -> list:
    return read_track_csv(data_path)

if __name__ == '__main__':
    data_path = "../../../../Desktop/highD-dataset-v1.0/data/01_tracks.csv"
    tracksInfo = get_data(data_path)

    # plot setting
    plt.rcParams['font.sans-serif'] = ['Arial Unicode MS']

    speedUp_no = []
    speedDown_no = []
    speedUp = []
    speedDown = []
    indexList = ["thw", "ttc", "dhw"]
    index = indexList[1]

    # print(len(tracksInfo))

    for track in tracksInfo:
        for idx, index_ in enumerate(track[index]):
            if track["followingId"][idx] != 0 and track["precedingId"][idx] != 0:  # 既在跟随，又被跟随
            # if track["precedingId"][idx] != 0: # 如果有前车
            #     followingId = track["followingId"][idx]
            #     frame = track["frame"][idx]
            #     followingDis = 0
            #     if followingId != 0: # 如果有跟随车辆
            #         beginFrame = tracksInfo[followingId-1]["frame"][0]
            #         followingDis = tracksInfo[followingId-1]["dhw"][frame-beginFrame]
            #     if sum(track["followingId"]) == 0 or followingDis > 150:
                    if track["xAcceleration"][idx] > 0:
                        speedUp.append(index_)
                    elif track["xAcceleration"][idx] < 0:
                        speedDown.append(index_)

    for track in tracksInfo:
        for idx, index_ in enumerate(track[index]):
            if track["precedingId"][idx] != 0: # 如果有前车
                followingId = track["followingId"][idx]
                frame = track["frame"][idx]
                followingDis = 0
                if followingId != 0: # 如果有跟随车辆
                    beginFrame = tracksInfo[followingId-1]["frame"][0]
                    followingDis = tracksInfo[followingId-1]["dhw"][frame-beginFrame]
                if sum(track["followingId"]) == 0 or followingDis > 150:
                    if track["xAcceleration"][idx] > 0:
                        speedUp_no.append(index_)
                    elif track["xAcceleration"][idx] < 0:
                        speedDown_no.append(index_)

    print(np.mean(speedUp), np.mean(speedDown))

    speedUp_ = []
    speedDown_ = []

    # for i in range(len(speedUp)):
    #     if speedUp[i] >= -2000 and speedUp[i] <= 2000:
    #         speedUp_.append(speedUp[i])
    # for i in range(len(speedDown)):
    #     if speedDown[i] >= -2000 and speedDown[i] <= 2000:
    #         speedDown_.append(speedDown[i])

    all = []
    all_no = []
    all = speedUp + speedDown
    all_no = speedUp_no + speedDown_no

    print(stats.ttest_ind(all, all_no))


    plt.hist(all, bins=30)
    print("all: ", np.mean(all))

    # print(speedUp)
    # plt.hist(speedUp, bins=30)

    plt.xlabel(index)
    plt.ylabel("频次")
    plt.show()

    # plt.hist(speedDown, bins=30)

    # plt.xlabel(index)
    # plt.ylabel("频次")
    # plt.show()