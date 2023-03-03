function [x, P] = linearUpdate(x, P, y, H, R)
%LINEARPREDICTION calculates mean and covariance of predicted state
%   density using a linear Gaussian model.
%
%Input:
%   x           [n x 1] Prior mean
%   P           [n x n] Prior covariance
%   y           [m x 1] Measurement
%   H           [m x n] Measurement model matrix
%   R           [m x m] Measurement noise covariance
%
%Output:
%   x           [n x 1] updated state mean
%   P           [n x n] updated state covariance
%

% Your code here

% Step 3, update Kalman gain
S = (R + H * P * H');				% Innovations covariance
v =  y - H * x; 						% Innovations vector
K = (P * H') * (S)^(-1) ;				% Kalman gain matrix

% Step 4, update the a posteriori state vector xp
x = x + K * v; 

% Step 5, update the a posteriori covariance matrix Pp
P = P - K * S *  K';                
P = 0.5 * (P + P');

% I = eye(max(size(x)));
% J = (I - K * H);                  % Joseph stabilized version     
% P = J * P * J' + K * R * K';      % Alternative implementation


end