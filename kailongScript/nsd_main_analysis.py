import pandas as pd
import scipy
import scipy.io
from tqdm import tqdm
import numpy as np

# nsdexpfile = '/home/surly-raid4/kendrick-data/nsd/nsddata/experiments/nsd/nsd_expdesign.mat';  % /gpfs/milgram/data/nsd/nsddata/experiments/nsd/nsd_expdesign.mat
nsd_expdesign = scipy.io.loadmat('/gpfs/milgram/data/nsd/nsddata/experiments/nsd/nsd_expdesign.mat')
# assert nsd_expdesign.shape == (8, 10000)
# nsd_expdesign['subjectim'][:,998:]  # 可以看到前一千个图片都是一样的.

# nsd_expdesign['subjectim']
"""
    nsd_expdesign['stimpattern'].shape = (40, 12, 75)
    nsd_expdesign['subjectim'].shape = (8, 10000)  # 这里面的前1000列都是我感兴趣的图片, 这些是所有的八个被试共享的图片
    nsd_expdesign['sharedix'].shape = (1, 1000)
    nsd_expdesign['masterordering'].shape = (1, 30000)
    nsd_expdesign['basiccnt'].shape = (3, 40)
"""

"/gpfs/milgram/data/nsd/nsddata_timeseries/ppdata/subj01/func1mm/design/design_session01_run01.tsv"
"/gpfs/milgram/data/nsd/nsddata_timeseries/ppdata/subj01/func1mm/timeseries/timeseries_session01_run01.nii.gz"


# subImg = {}
# for sub_i in tqdm(range(1, 9)):
#     for session_i in range(1, 38):
#         subImg_sub = []
#         for run_i in range(1, 13):
#             try:
#                 design_t = pd.read_csv(f"/gpfs/milgram/data/nsd/nsddata_timeseries/ppdata/"
#                                        f"subj0{sub_i}/func1mm/design/"
#                                        f"design_session{f'{session_i}'.zfill(2)}_run{f'{run_i}'.zfill(2)}.tsv")
#                 subImg_sub = subImg_sub + list(np.unique(design_t['0']))
#             except:
#                 pass
#         subImg[f"subj0{sub_i}-session{f'{session_i}'.zfill(2)}"] = np.asarray(subImg_sub)


def run_GLM():
    # 第一种方法是自己运行一次GLM, 具体的操作就是首先获得感兴趣的图片(所有被试共享的1000张图片)的
    sharedImages = list(nsd_expdesign['subjectim'][0, :16])
    subImg = {}
    subImg_sub = []
    for sub_i in tqdm(range(1, 2)):  # (1, 9)
        for session_i in range(1, 2):  # (1, 38)
            subImg_sub = []
            for run_i in range(1, 13):
                try:
                    design_t = pd.read_csv(f"/gpfs/milgram/data/nsd/nsddata_timeseries/ppdata/"
                                           f"subj0{sub_i}/func1mm/design/"
                                           f"design_session{f'{session_i}'.zfill(2)}_run{f'{run_i}'.zfill(2)}.tsv")
                    for currImg, img in enumerate(sharedImages):
                        index = np.where(design_t == img)
                        if len(index) > 0:
                            pass
                    subImg_sub = subImg_sub + list(design_t['0'])
                except:
                    pass
            subImg[f"subj0{sub_i}-session{f'{session_i}'.zfill(2)}"] = np.asarray(subImg_sub)
    print(np.sum(np.asarray(subImg_sub) != 0))
    print(np.sum(np.unique(subImg_sub) != 0))
    print(np.sum(np.asarray(subImg_sub) == 2115))
    t = np.asarray(subImg_sub)
    t = list(t[t != 0])
    print(len(t))
    print(np.sum(np.asarray(t) == 2115))
    print(np.where(np.asarray(t) == 2115))

    import h5py

    f = h5py.File('/gpfs/milgram/data/nsd/nsddata_betas/ppdata/subj01/func1pt8mm/betas_fithrf/betas_session01.hdf5',
                  'r')
    list(f.keys())
    a = f['betas'][217, :]
    b = f['betas'][620, :]

    np.mean(a == b)


# def use_existing_beta():
# 第二种方法就是直接使用别人做好的GLM的beta的结果, 然后就可以对于给定的16张图片, 获得别人已经运行好了的16x3的beta, 求均值之后得到16个beta, 然后就可以进行探照灯的运算.
# 具体的做法就是, 首先在1000张图片里面, 选择第一张图片, 找到这张图片的 8个被试的分别3次的重复.
# 第一张可以尝试寻找的图片就是 nsd_expdesign['subjectim'][0, 0]
df = pd.DataFrame(columns=['imgID'])
imgIDs = nsd_expdesign['subjectim'][0, :10000]
for sub_i in tqdm(range(1, 9)):  # (1, 9)
    for session_i in range(1, 38):  # (1, 38)
        sessionTrialID = 0
        for run_i in range(1, 15):
            try:
                design_t = pd.read_csv(f"/gpfs/milgram/data/nsd/nsddata_timeseries/ppdata/"
                                       f"subj0{sub_i}/func1mm/design/"
                                       f"design_session{f'{session_i}'.zfill(2)}_run{f'{run_i}'.zfill(2)}.tsv")
                # design_t = pd.read_csv(f"/gpfs/milgram/data/nsd/nsddata_timeseries/ppdata/"
                #                        f"subj0{sub_i}/func1pt8mm/design/"
                #                        f"design_session{f'{session_i}'.zfill(2)}_run{f'{run_i}'.zfill(2)}.tsv")
                nonZeroTrial = np.asarray(design_t['0'])
                nonZeroTrial = nonZeroTrial[nonZeroTrial != 0]  # 不希望包含无图片展示的trial.
                for imgID in imgIDs:
                    index = np.where(nonZeroTrial == imgID)[0]
                    if len(index) > 0:
                        df = df.append({'imgID': imgID,
                                        'sub_i': sub_i,
                                        'session_i': session_i,
                                        'run_i': run_i,
                                        'index': index[0] + sessionTrialID
                                        },
                                       ignore_index=True)
                sessionTrialID += len(nonZeroTrial)
            except:
                pass
        if sessionTrialID != 0:
            # print(f"sub{sub_i} session {session_i} sessionTrial trial number={sessionTrialID}")
            assert sessionTrialID == 750  # 每一个session都展示了750个trial.
repeated3imgIDs = []
for imgID in imgIDs:
    print(f"{imgID} len = {np.sum(df['imgID'] == imgID)}")
    if np.sum(df['imgID'] == imgID) == 24:
        repeated3imgIDs.append(imgID)
print(f"repeated3imgIDs={repeated3imgIDs}")  # 这些是每一个被试都重复了三次的图片的ID
# len = 358 ; repeated3imgIDs=[3050, 3158, 3172, 3435, 3627, 3688, 3810, 3848, 3857, 4052, 4250, 4424, 4668, 4691, 4787, 4836, 4893, 4931, 5035, 5543, 5584, 5603, 6432, 6445, 6490, 6522, 7121, 7367, 7655, 7841, 7860, 8007, 8110, 8510, 8647, 8808, 9028, 9049, 9435, 9918, 10047, 10065, 10108, 10245, 10472, 11160, 11522, 11618, 11690, 11797, 11838, 11845, 11933, 11943, 11953, 12309, 12797, 12923, 13139, 13313, 13315, 14529, 14595, 14794, 14821, 14899, 15365, 15507, 15820, 15940, 16253, 16345, 16703, 16824, 16918, 17049, 17375, 17486, 17550, 19075, 19182, 19200, 19934, 20055, 20081, 20207, 20266, 20634, 20651, 20821, 21193, 21195, 21219, 21602, 21951, 22264, 22516, 22531, 22588, 22795, 22880, 22958, 22968, 22994, 23037, 23716, 23730, 24203, 24215, 24531, 25112, 25269, 25285, 25589, 25703, 25742, 26164, 26352, 26436, 26459, 26721, 26896, 26910, 26991, 27243, 27276, 27327, 27436, 27569, 27879, 28069, 28097, 28160, 28190, 28320, 28350, 28525, 28596, 28752, 29382, 29712, 29887, 30082, 30396, 30408, 30673, 30857, 31029, 31234, 31660, 31748, 31802, 31838, 31937, 31965, 32054, 32233, 32626, 32773, 32892, 32911, 33172, 33246, 33522, 33544, 34127, 34239, 34830, 34851, 35744, 35753, 35799, 35987, 36577, 36624, 36732, 36911, 36946, 36975, 36979, 37060, 37225, 37495, 38023, 38026, 38298, 38487, 38642, 38830, 38854, 38979, 39290, 39370, 39403, 40424, 40576, 40722, 40771, 40841, 40847, 40925, 40936, 41117, 41163, 41567, 41654, 41711, 41928, 42167, 42172, 42215, 42225, 42564, 42698, 42782, 42852, 42913, 43160, 43165, 43429, 43446, 43620, 43676, 43819, 43951, 44053, 44721, 44845, 44981, 45130, 45214, 45596, 45751, 45844, 45946, 46151, 46373, 46461, 46463, 47291, 47294, 47409, 47688, 48158, 48261, 48375, 48423, 48509, 48680, 49467, 49732, 49945, 49956, 50115, 50654, 50735, 50756, 50812, 51078, 51149, 51522, 51789, 51984, 52071, 52555, 52932, 53053, 53371, 53728, 53729, 53882, 54079, 54258, 54362, 55108, 55406, 55409, 55670, 55679, 55969, 56155, 56682, 56724, 56785, 56851, 56868, 56912, 57047, 57436, 57554, 57651, 57839, 59047, 59195, 59285, 59586, 59700, 59995, 60095, 60187, 60252, 60506, 60554, 61134, 61511, 61678, 61739, 61810, 62016, 62229, 62303, 62684, 64296, 64868, 64881, 65149, 65254, 65268, 65446, 65770, 65800, 65873, 65944, 66005, 66217, 66279, 66331, 66465, 66490, 66774, 66837, 66947, 67238, 67296, 67743, 67803, 67830, 68279, 68340, 68815, 68843, 68859, 69008, 69241, 69840, 69855, 70096, 70194, 70233, 70428, 71233, 71242, 71411, 71895, 72016, 72210, 72313, 72949]
# subj03 29 sessions
# subj04 27 sessions
# subj06 29 sessions
# subj08 27 sessions


setOf16Images = repeated3imgIDs[0:16]
for imgID in setOf16Images:
    for sub_i in range(1, 9):
        df[df['imgID'] == imgID]
