
clc
clear
close all

s = tf('s');

%% DATOS DEFINIDOS EN OGATA

KCR = 30;
PCR = 2.8099;

%% TF DE LA PLANTA

Gp = 1 / ( s * (s + 1) * (s + 5) );

%% TF DEL PID

Kp = 0.6 * KCR;
Ti = 0.5 * PCR;
Td = 0.125 * PCR;

Gc = Kp * (1 + 1/(Ti*s) + (Td * s) );

%% TF DEL SISTEMA

TFS = (Gp * Gc) / ( 1 + (Gp * Gc) );

%% RESPUESTA AL ESCALON

step (TFS);
grid
title('Unit-Step Response')
