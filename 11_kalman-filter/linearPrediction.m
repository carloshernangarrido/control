function [x, P] = linearPrediction(x, P, A, Q)
%LINEARPREDICTION calculates mean and covariance of predicted state
%   density using a linear Gaussian model.
%
%Input:
%   x           [n x 1] Prior mean
%   P           [n x n] Prior covariance
%   A           [n x n] State transition matrix
%   Q           [n x n] Process noise covariance
%
%Output:
%   x           [n x 1] predicted state mean
%   P           [n x n] predicted state covariance
%
% Your code here

% Ad =  expm(A* dt);          		% Exact solution for linear systems
% Qd = (G * Q * G') .* dt;            % Digitalized covariance matrix

% Step 1, predict the a priori state vector x
x = A * x;

% Step 2, update the a priori covariance matrix P
P = (A * P * A') + Q;
P =  0.5 .* (P + P');                  % Force P to be symmetric matrix

end