clc
clear all
close all

Im1 = imread('boat1.pgm');
Im2 = imread('boat2.pgm');

[matches, scores, fa, fb] = keypoint_matching(Im1,Im2);

N = 10;
K = 10;
[M, T, inliners] = RANSAC(fa,fb,matches,N,K);
