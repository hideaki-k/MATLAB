%==========================================================================
% Estimate rotation and translation from RGB-D point clouds
% pc1, pc2 are point clouds from kinect (organized point cloud with color).
% It is assumed that the two point clouds contain data of the same size.
%
% The problem is solved by finding the corresponding points through 2-D
% feature matching first, then computing the transformation matrix by SVD.
%
%  Copyright 2015 The MathWorks, Inc.
%==========================================================================
function tform = findRtFromRGBD(pc1, pc2, isPlanarMotion, hAxes)
color_i = pc1.Color;
XYZ_i = pc1.Location;
depth_i = XYZ_i(:,:,3);

color_j = pc2.Color;
XYZ_j = pc2.Location;
depth_j = XYZ_j(:,:,3);

% Extract keypoint features
gray_i = rgb2gray(color_i);
points_i = detectSURFFeatures(gray_i,'MetricThreshold', 100);
[fi, vptsi] = extractFeatures(gray_i, points_i);

gray_j = rgb2gray(color_j);
points_j = detectSURFFeatures(gray_j,'MetricThreshold', 100);
[fj, vptsj] = extractFeatures(gray_j, points_j);

% Match features across images
indexPairs = matchFeatures(fi, fj, 'Unique', true);
matched_ptsi = vptsi(indexPairs(:, 1));
matched_ptsj = vptsj(indexPairs(:, 2));

% Clean the matches with RANSAC algorithm
[~,inlierPoints1,inlierPoints2] = estimateGeometricTransform(matched_ptsi,matched_ptsj,'affine','MaxDistance',7);

% Clean the matches where the corresponding 3-D point has valid value
loc_i = round(inlierPoints1.Location);
ind_i = sub2ind(size(gray_i), loc_i(:,2), loc_i(:,1));
valid_i = depth_i(ind_i)>0;
loc_j = round(inlierPoints2.Location);
ind_j = sub2ind(size(gray_j), loc_j(:,2), loc_j(:,1));
valid_j = depth_j(ind_j)>0;
valid_ij = valid_i&valid_j;
    
ind_i = ind_i(valid_ij);
ind_j = ind_j(valid_ij);

% Use showMatchedFeatures to visualize the matching result
showMatchedFeatures(gray_i,gray_j,inlierPoints1(valid_ij),inlierPoints2(valid_ij),'Parent',hAxes);

%fprintf('find candidate matching pairs: %d, valid pairs: %d\n', ...
%        length(indexPairs), size(ind_i,1));

% Estimate the rotation and translation as a least square solution
sz = pc1.Count;
xyz_i = [XYZ_i(ind_i), XYZ_i(ind_i+sz), XYZ_i(ind_i+2*sz)];
xyz_j = [XYZ_j(ind_j), XYZ_j(ind_j+sz), XYZ_j(ind_j+2*sz)];

if isPlanarMotion
    % Assume there is no motion in Z-axis
    [R, T] = minimizePointToPointMetric(xyz_i(:,1:2), xyz_j(:,1:2));    
    R = [R, zeros(2,1); 0,0,1];
    T = [T; 0];
else
    [R, T] = minimizePointToPointMetric(xyz_i, xyz_j);
end

tform = affine3d([R, T; zeros(1,3),1]');

%==========================================================================
% Solve the following minimization problem:
%       min_{R, T} sum(|R*p+T-q|^2)
%
% p, q are all N-by-d matrix with N data points
%
% The problem is solved by SVD
%==========================================================================
function [R, T] = minimizePointToPointMetric(p, q)
n = size(p, 1);
m = size(q, 1);

% Find data centroid and deviations from centroid
pmean = sum(p,1)/n;
p2 = p - repmat(pmean, n, 1);

qmean = sum(q,1)/m;
q2 = q - repmat(qmean, m, 1);

% Covariance matrix
C = p2'*q2; 

[U,~,V] = svd(C); 

% Handle the reflection case
R = V*diag([ones(1,size(C,1)-1) sign(det(U*V'))])*U';

% Compute the translation
T = qmean' - R*pmean';
