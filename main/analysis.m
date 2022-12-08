%% %%%%%%%% 手动传输、组织和命名数据 Manual data transfer, organization, and naming

% - 检查谷歌表格上的日志条目 check log entries on the google sheets
% - 以官方名称编制官方数据目录 make official data directory with official name
% - rsync -av将文件从naxos导入 "dicom"。 rsync -av the files from naxos into "dicom"
%   - 将额外的扫描结果放入 "extra_scans "中 stick extra scans into "extra_scans"
%   - 记得检查文件/目录的大小 remember to check file/dir sizes
% - rsync -av .mat文件和 "data "及 "scripts "文件夹进入 "mat_files_from_scan".  rsync -av .mat files and "data" and "scripts" folders into "mat_files_from_scan"
%   - 检查预定实验的时间顺序，并删除任何不需要的文件!  check chronological order of the intended experiments and delete any unwanted files!
% - 获取slice.png（将bmp转换为png）。 get slice.png (convert bmp to png)

% - 对于幻影测试数据。 for phantom test data:
%   - 转移数据和组织，只运行autoqc_fmri。  transfer data and organize and run autoqc_fmri only.
%   - 嗯，对于DATECENSORED-ST001-NSD_phantom，只需转移。  hm, for DATECENSORED-ST001-NSD_phantom, just transferred only.

% hints below...

transcode eyetracking video [very fast 480] and store it away /research/nsd/eyetracking/

DATECENSORED-NSD139-structural4
0216
NSD139
subj139
139*

  # TYPE
mkdir /home/surly-raid1/kendrick-data/nsd/rawdata/DATECENSORED-NSD139-structural4/

  # TYPE
rsync -av ~/dicom/*0216*NSD139*session*/* /home/surly-raid1/kendrick-data/nsd/rawdata/DATECENSORED-NSD139-structural4/dicom/

get flicker .mat specially?

stimmac
cd ~/Desktop/cvnlab/kendrick/
  # TYPE
rsync -av 2019*subj139*     kendrick@stone.cmrr.umn.edu:"~/fmridata/nsd/rawdata/DATECENSORED-NSD139-structural4/mat_files_from_scan/"
rsync -av eye_2019*subj139* kendrick@stone.cmrr.umn.edu:"~/fmridata/nsd/rawdata/DATECENSORED-NSD139-structural4/eyetracking/"
mv *2019*subj139* \ old\ files/
  rsync -av fLoc/data/139*    kendrick@stone.cmrr.umn.edu:"~/fmridata/nsd/rawdata/DATECENSORED-NSD139-structural4/mat_files_from_scan/data/"
  rsync -av fLoc/scripts/139* kendrick@stone.cmrr.umn.edu:"~/fmridata/nsd/rawdata/DATECENSORED-NSD139-structural4/mat_files_from_scan/scripts/"
  rm -rf fLoc/data/139*
  rm -rf fLoc/scripts/139*

  # TYPE
convert /home/stone/tmp/*NSD139*T2*.bmp /home/surly-raid1/kendrick-data/nsd/rawdata/DATECENSORED-NSD139-structural4/slice_HRT2.png
rm -rf /home/stone/tmp/*NSD139*T2*.bmp
convert /home/stone/tmp/*NSD139*.bmp /home/surly-raid1/kendrick-data/nsd/rawdata/DATECENSORED-NSD139-structural4/slice.png
rm -rf /home/stone/tmp/*NSD139*.bmp

  # PHYSIO?
rsync -av /home/stone/tmp/Physio*2019* /home/surly-raid1/kendrick-data/nsd/rawdata/DATECENSORED-NSD139-structural4/physio/
rm -rf /home/stone/tmp/Physio*2019*
ls -lad ~/nsd/rawdata/DATECENSORED-NSD139-structural4/physio/* | wc -l
% 4x60 = 240; 300; 360; 420; 480; 540; 600; 660; 720; 780; 840; 900; 960; 1020; 1080; 1200; 1320; 1380; 1440; 1500; 1560; 1620; 1680
%   1740; 60√√
% do we need to remove excess files? (or to a new scan directory)

cd /home/surly-raid1/kendrick-data/nsd/rawdata/DATECENSORED-NSD139-structural4/mat_files_from_scan/
ls -la
rm *run99*
ls -latr * data/*/*.mat

cd /home/surly-raid1/kendrick-data/nsd/rawdata/DATECENSORED-NSD139-structural4/dicom/
mkdir extra_scans
mv *local* *SBRef extra_scans/
ls -la
mv MR-SE003* extra_scans/
du -hs *
du -s *

% 考虑编辑nsdsetup.m以实现特殊的静止状态的额外运行？ consider editing nsdsetup.m for special resting-state extra runs??

% 检查physio文件（正好15个.resp文件）[2019年7月4日运行]. check physio files (exactly 15 .resp files) [ran on July 4 2019]
a1 = matchfiles('/home/surly-raid1/kendrick-data/nsd/rawdata/*/physio');
for p=1:length(a1)
  a1{p}
  b = unix_wrapper(sprintf('ls -1 %s/*.resp | wc -l',a1{p}));
  assert(str2double(b)==15);
end

% 检查预处理是否正常运行[定期]  check that pre-processing is chugging away correctly [periodically]
./checknsdfinal

STATUS:
303 134syn√
304 258syn√
305 149syn√
306 929syn√
307 168√
308 814√
309 258imag√
310 134imag√
311 400syn√
312 139syn√
313 400imag√
314 139imag√
315 149imag√
316 814syn√
317 168syn√
318 168imag√
319 814imag√
320 929imag√

nsdsyntheticpilot: 134 exists [some fixation responses 3/1]

%% %%%%%%%% 如果扫描会话有问题，在此停止。 IF QUESTIONABLE SCAN SESSION, STOP HERE.

%% %%%%%%%% 如果有必要，执行任何数据修复！ PERFORM ANY DATA FIXES IF NECESSARY!

% 历史 history:
% - datafix_script1.m
% - datafix_script2.m
% - datafix_script4.m

%% %%%%%%%% 手动定义一些参数并上传/更新 Manually define some parameters and upload/update

nsdsetup;

%% %%%%%%%% AUTOMATIC: start it

%% %%%%%%%% 快速检查 AcquisitionDate 和 AcquisitionTime  Quick check of AcquisitionDate and AcquisitionTime

% 手动检查保存在DICOM中的AcquisitionDate和AcquisitionTime.  manually inspect the AcquisitionDate and AcquisitionTime saved in the DICOM
for zz=length(datadirs):length(datadirs)
  files0 = matchfiles(sprintf('%s/dicom/extra_scans/*',datadirs{zz}));
  files1 = matchfiles(sprintf('%s/*.dcm',files0{1}));
  a0 = dicominfo(files1{1});
  fprintf('%s: %s %s\n',datadirs{zz},a0.AcquisitionDate,a0.AcquisitionTime);
end

% 断言检查扫描目录名是否有与AcquisitionDate相同的日期。 assert to check that scan directory name has a date identical to the AcquisitionDate
for zz=1:length(datadirs), zz
  files0 = matchfiles(sprintf('%s/dicom/MR*bold*',datadirs{zz}));
  files1 = matchfiles(sprintf('%s/*.dcm',files0{1}));
  f = regexp(datadirs{zz},'.+?rawdata/(.+?)-(.+?)-.+$','tokens');
  a0 = dicominfo(files1{1});
  assert(isequal(f{1}{1},a0.AcquisitionDate));
  
  tmp = a0.PatientName.FamilyName(1:length(f{1}{2}));
  if ~isequal(f{1}{2},tmp)
    fprintf('WARNING: %d: %s\n',zz,tmp);
  end
end

%% %%%%%%%% 对SliceLocation的快速检查 Quick check of SliceLocation

  % what about
  % a.ImageOrientationPatient
  % a.ImagePositionPatient

for zz=length(datadirs):length(datadirs)
  autoqc_acquisition(zz);
end

%% %%%%%%%% 生理学数据的自动质量控制 Automatic QC of physio data

for zz=length(datadirs):length(datadirs)
  autoqc_physio(zz,'/home/stone/generic/Dropbox/nsd/autoqc_physio/');
end

%% %%%%%%%% 行为数据的自动质量控制和分析 Automatic QC and analysis of behavioral data

% 群体感受野 prf
for zz=6+(1:14)
  analyzebehavior_prf(datadirs{zz});
end
analyzebehavior_prf_visualize(ppdirs(6+(1:14)),'/home/stone/generic/Dropbox/nsd/analyzebehavior_prf');

% 类别功能定位器 floc
for zz=6+(1:14)
  analyzebehavior_floc(datadirs{zz},312,12);
end
analyzebehavior_floc_visualize(ppdirs(6+(1:14)),'/home/stone/generic/Dropbox/nsd/analyzebehavior_floc');

% nsd基本文件检查[这不包括nsdsynthetic或nsdimagery]  nsd basic file check [this does not include nsdsynthetic or nsdimagery]
analyzebehavior_nsd_filecheck;

% nsd
for zz=21:length(datadirs)
  if ~ismember(zz,[nsdsyntheticsession nsdimagerysession])
    analyzebehavior_nsd(datadirs{zz},nsdexpfile);
  end
end
analyzebehavior_nsd_visualize(ppdirs(setdiff(21:length(ppdirs),[nsdsyntheticsession nsdimagerysession])),'/home/stone/generic/Dropbox/nsd/analyzebehavior_nsd');

% nsdsynthetic [ran it√]
for zz=21:length(datadirs)
  if ismember(zz,[nsdsyntheticsession])
    analyzebehavior_nsdsynthetic(datadirs{zz},nsdsyntheticexpfile);
  end
end

% nsdimagery [ran it√]
for zz=21:length(datadirs)
  if ismember(zz,[nsdimagerysession])
    analyzebehavior_nsdimagery(datadirs{zz},nsdimageryexpfile);
  end
end

% 陈旧 OBSOLETE (由合成物引起)  OBSOLETE (caused by synthetic)
% % nsd by subject
% mkdirquiet('/home/stone/generic/Dropbox/nsd/analyzebehavior_nsd_bysubject');
% for zz=1:length(allnsdids)
%   tmp0 = tempdir;
%   ix = cellfun(@(x) ~isempty(regexp(x,sprintf('%s-nsd',allnsdids{zz}))),dirs);
%   if any(ix)
%     analyzebehavior_nsd_visualize(ppdirs(ix),tmp0);
%     movefile([tmp0 '/accuracyrt.png'],sprintf('/home/stone/generic/Dropbox/nsd/analyzebehavior_nsd_bysubject/%s.png',allnsdids{zz}));
%   end
% end

%% %%%%%%%% 对原始MRI数据进行自动质量控制  Automatic QC of raw MRI data

for zz=length(datadirs):length(datadirs)
  autoqc_fmri(datadirs{zz},expecteddim{sessiontypes(zz)});
end
autoqc_fmri_visualize(ppdirs,'/home/stone/generic/Dropbox/nsd/autoqc_fmri',length(ppdirs):length(ppdirs));

% % THIS WAS EXPERIMENTAL. DEPRECATED.
% for zz=290:302
%   autoqc_fmri2(datadirs{zz});
% end

%% %%%%%%%% Perform volume-based pre-processing

% [hm, keep in mind that we don't yet inherit the correct NIFTI headers]
%   [also, field of view change, apparent voxel resolution change]
%
% [pipeline institute the distortion effects quantification?]
%   [epi and fieldmap might be interesting for large data set stability inspections?]
%
% note that the nsd sessions now include a fieldmap regularization based on magnitude (Nov 20 2018).
% 
% NOTES:
% - /(hard-coded change to fieldmap - regularization of the fieldmap implemented! 
%  this means my copy of the preprocess will do this always. it seems to run nicely.)
%  [circa Nov 20 2018. will need to check in eventually. is the solution robust?]
%  [methods notes: 1 after threshold; squaring before the threshold]

% Define motion-correction mask.
for zz=length(datadirs):length(datadirs)
  definemcmask(datadirs{zz});
end

% Perform volume-based pre-processing.
for zz=length(datadirs):length(datadirs)
  feval(ppscripts{pptypes(zz)},zz);
end

% Need to do any fixes to the pp data?
%
% history:
% - datafix_script3a.m

% Automatic QC of pre-processing results.
for zz=length(datadirs):length(datadirs)
  autoqc_ppfmri(ppdirs{zz});
end
autoqc_ppfmri_visualize(ppdirs,'/home/stone/generic/Dropbox/nsd/autoqc_ppfmri');

% 预处理结果的人工质量控制。
% - EPIoriginal：任何主要的假象？
% - EPIoriginal->EPIundistort->braincropped：不扭曲的基本合理性。
% - EPIfinal: 整体稳定性可以吗？
% - Meanvol, stdvol: 我们是否遗漏了切片中的大脑？
% - temporalsnr：相对稳定和良好？
% - fieldmapbraincropped, fieldmapsmoothedALT: 有没有大规模的移动或问题？
% - randomvolumes: 快速检查理智程度
% - motionallruns: 有什么疯狂的吗？
%
% 在谷歌表格中记录观察结果。
% 如果有必要，重新做任何处理。

% Manual QC of pre-processing results.
% - EPIoriginal: any major artifacts?
% - EPIoriginal->EPIundistort->braincropped: basic sanity of the undistortion
% - EPIfinal: is overall stability okay?
% - meanvol, stdvol: are we missing brain in slices?
% - temporalsnr: is relatively stable and good?
% - fieldmapbraincropped, fieldmapsmoothedALT: any massive movement or problems?
% - randomvolumes: quick sanity check
% - motionallruns: anything crazy?
%
% Record observations on Google Sheets.
% Re-do any processing if necessary.

%% %%%%%%%% 为nsd筛查会议（prf和floc）分析基于容量的第一遍pp，并用于检查nsdXX的正确性。 Analyze first-pass volume-based pp for the nsd screening sessions (prf and floc) and for sanity-checking nsdXX

% 注意：我们想使用vanilla analyzePRF，所以我们这样做。  NOTE: we want to use the vanilla analyzePRF, so we do this:
rmpath(genpath('/home/stone/kendrick/code/analyzePRF/'));

% 处理prffloc. deal with prffloc
for zz=6+(1:14)
  glm_prfINITIALSCREENING(ppdirs{zz}, [1 2 5 6 9  10]);
  glm_flocINITIALSCREENING(ppdirs{zz},[3 4 7 8 11 12]);
end

% 处理nsdXX. deal with nsdXX
for zz=21:length(ppdirs)
  if ~ismember(zz,[nsdsyntheticsession nsdimagerysession])
    glm_nsdSIMPLE(ppdirs{zz});  % one-regressor GLM
  end
end

% 下载并检查数字  download and inspect figures

%% %%%%%%%% 根据nsd筛选会议选择对象 Select subjects based on nsd screening sessions

% figure: BOLDSNR
% figure: PARTICIPANTSUMMARY参与者摘要
% figure: 最终参与者总结FINALPARTICIPANTSUMMARY

%% %%%%%%%% 为主要的nsd实验创建排行榜 Create leaderboard for main nsd experiment

autoqc_nsd(setdiff(21:length(ppdirs),[nsdsyntheticsession nsdimagerysession]),'/home/stone/generic/Dropbox/nsd/autoqc_nsd');

%% %%%%%%%% 对第一阶段基于体积的预处理的平均体积进行grad unwarp 处理。 Perform gradunwarp on the mean volume from first-stage volume-based pre-processing.

for zz=7:length(datadirs), zz
  preprocess_nsd_epigradunwarp(datadirs{zz});
end

%% %%%%%%%% 根据 gradunwarp 的结果，确定裁剪范围并插入 nsdsetup.m 中。 Based on gradunwarp results, determine crop range and insert into nsdsetup.m

% 注意：只有在第一次nsd会议上才会运行！ NOTE: only gets run for first nsd session!

for zz=length(datadirs):length(datadirs), zz
  if isempty(nsdcropranges{nsdsubjixfun(zz)})
    keyboard;
    %% manually go through preprocess_nsd_crop.m
    %% rehash path; clear nsdsetup;
    %% close nomachine!
  end
end

%% %%%%%%%% 将每个环节与参考环节对齐[顺序很重要，重做是很棘手的！]。 Align each session to the reference session [order matters and re-dos are tricky!].

  % do nsd01 first
for zz=[21 22 23 24 25 27 28 31]
  preprocess_nsd_epialignment(zz);
end
  % do screening sessions next
for zz=[7 10 18 16 12 17 8 20]
  preprocess_nsd_epialignment(zz);
end
  % then:
for zz=[26 29 30 32:length(datadirs)]
  preprocess_nsd_epialignment(zz);
end

%% %%%%%%%% 进行第二阶段的基于体积的预处理。 Perform second-stage volume-based pre-processing.

for zz=[7 10 18 16 12 17 8 20 21:length(datadirs)]
  preprocess_nsd_secondstage(zz);
  if ismember(zz,[nsdimagerysession])
    preprocess_nsd_secondstageLOW1s(zz);   % IMAGERY LOW RESOLUTION is at 1s
  else
    preprocess_nsd_secondstageLOW(zz);
  end
end

% 关于nan/无效INVALID数据的%说明：[检查这个] 。
% - 预处理后，坏体素在valid.mat中被标记（基本上，当valid.mat为0时，这意味着它是一个坏顶点）。在数据文件（例如run01.mat）中，所有坏顶点的时间序列数据都被设置为全部为0（在所有运行中）。因此，数据文件只有有限的值。

% 我们是否需要对pp数据进行任何修正？
%
%历史。
% - datafix_script3b.m

% NOTES ON NAN/INVALID DATA:   [CHECK THIS]
% - After pre-processing, the bad voxels are marked in valid.mat (basically, when valid.mat is 0, this means it is a bad vertex). In the data files (e.g. run01.mat), the time-series data for all bad vertices are set to all 0 (in all runs). Thus, the data files only have finite values.

% Do we need to perform any fixes to the pp data?
%
% history:
% - datafix_script3b.m

%% %%%%%%%% 做一些基本的GLM分析。Do some basic GLM analyses.

% 运行GLM.  Perform GLM.
for zz=21:length(datadirs)
  if ~ismember(zz,[nsdsyntheticsession nsdimagerysession])

    glm_nsd(ppdirs{zz},'preprocessVER1SECONDSTAGE',   'designmatrixSINGLETRIAL_nsd.mat',           ...
      '~/nsd/ppdata/hrfbasis.mat',          1,  'glmdata'   ,'~/nsd/ppdata/hrfmanifold.mat');
    glm_nsd(ppdirs{zz},'preprocessVER1SECONDSTAGELOW','designmatrixSINGLETRIAL_3pertrial_nsd.mat', ...
      '~/nsd/ppdata/hrfbasis_3pertrial.mat',4/3,'glmdataLOW','~/nsd/ppdata/hrfmanifold_3pertrial.mat');

    % Resting-state
    if sessiontypes(zz)==8
      glm_nsdrestingstate(ppdirs{zz},'preprocessVER1SECONDSTAGE',   'designmatrixSINGLETRIAL_nsd.mat',           ...
        '~/nsd/ppdata/hrfbasis.mat',          1,  'glmdata'   ,'~/nsd/ppdata/hrfmanifold.mat');
      glm_nsdrestingstate(ppdirs{zz},'preprocessVER1SECONDSTAGELOW','designmatrixSINGLETRIAL_3pertrial_nsd.mat', ...
        '~/nsd/ppdata/hrfbasis_3pertrial.mat',4/3,'glmdataLOW','~/nsd/ppdata/hrfmanifold_3pertrial.mat');
    end
  
  end

  % deal with nsdsynthetic
  if ismember(zz,[nsdsyntheticsession])
    glm_nsdsynthetic(ppdirs{zz},'preprocessVER1SECONDSTAGE',   'designmatrixSINGLETRIAL_nsdsynthetic.mat',           ...
      '~/nsd/ppdata/hrfbasis.mat',          1,  'glmdata'   ,'~/nsd/ppdata/hrfmanifold.mat');
    glm_nsdsynthetic(ppdirs{zz},'preprocessVER1SECONDSTAGELOW','designmatrixSINGLETRIAL_3pertrial_nsdsynthetic.mat', ...
      '~/nsd/ppdata/hrfbasis_3pertrial.mat',4/3,'glmdataLOW','~/nsd/ppdata/hrfmanifold_3pertrial.mat');
  end

  % deal with nsdimagery
  if ismember(zz,[nsdimagerysession])
    glm_nsdimagery(ppdirs{zz},'preprocessVER1SECONDSTAGE',   'designmatrixSINGLETRIAL_nsdimagery.mat',           ...
      '~/nsd/ppdata/hrfbasis.mat',          1,'glmdata'   ,'~/nsd/ppdata/hrfmanifold.mat');
    glm_nsdimagery(ppdirs{zz},'preprocessVER1SECONDSTAGELOW','designmatrixSINGLETRIAL_nsdimagery.mat', ...
      '~/nsd/ppdata/hrfbasis.mat',          1,'glmdataLOW','~/nsd/ppdata/hrfmanifold.mat');
  end

end

% Automatic QC of GLM results.
for zz=[7 10 18 16 12 17 8 20 21:length(datadirs)]
  autoqc_glm_nsd(zz,'glmdata');
  autoqc_glm_nsd(zz,'glmdataLOW');
end

%% %%%%%%%% Do some grand finales.

for ss=1:8
  autoqc_nsd_grand(ss,'glmdata');
  autoqc_nsd_grand(ss,'glmdataLOW');
end
autoqc_nsd_grandfinale('glmdata',42);
autoqc_nsd_grandfinale('glmdataLOW',42);

%% %%%%%%%% AUTOMATIC END:
%%          1. look at PP QC figures in sessions/nsd (see above questions)
%%             exclude MOVIEfinal, MOVIEoriginal, randomvolumes, contours* [should we delete from server?]
%%          2. look at GLMdenoise_nsdSIMPLE_figures, sessioncoregistration, glmdata-glmBASIC 
%%          3. look at nsd Dropbox figures
%%          4. e-mail subject with the results.
%%          5. write bonus on spreadsheet
