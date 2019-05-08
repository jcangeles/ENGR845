function featMatrix = featureExtraction(acc, labels, WLen, WInc)
%FEATUREEXTRACTION Summary of this function goes here
%   Detailed explanation goes here
%   acc = acceleration matrix where columns are axis
%   labels = labels of each frame
%   WLen = window length parameter
%   WInc = window increment paramenter

numOfFeat = 3;
sampleSize = size(acc, 1);
numOfWindows = ceil((sampleSize-WLen)/WInc);
featMatrix = [];

%instance of ZeroCrossingDetector System Object
zcd = dsp.ZeroCrossingDetector;

%   for axis x,y, z
for axis = 1:3
    %   number of window frames
    for windowIndex = 1:numOfWindows
        % starting index and range of window
        start = 1 + (windowIndex-1)*WInc;
		range = start:start+WLen-1;
        
        dataFrame = acc(range,axis);
        % FEATURE 1: mean absolute value
        mav(windowIndex) = meanabs(dataFrame);
        % FEATURE 2: Zero Crossing
        zeroCnt(windowIndex) = double(zcd(dataFrame));
        % FEATURE 3: Number of Slope changes
        slopeCnt(windowIndex) = size(findpeaks(dataFrame),1) ...
            + size(findpeaks(dataFrame*-1),1);
    end
    
    featPerChannel = [mav; zeroCnt; slopeCnt];
    featMatrix = [featMatrix; featPerChannel];
end

featMatrix = [featMatrix; labels(1:numOfWindows,1)'];
end

