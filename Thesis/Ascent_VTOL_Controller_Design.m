syms k1 k2 k3 xcg1 xcg2 ycg2 Iyy Ixx
% state: (zdot, pitch, pitch rate, roll, roll rate)
lbm2slug = 0.031;
Ixx = 13900*lbm2slug/144;
Izz = 8300*lbm2slug/144;
Iyy = 20150*lbm2slug/144;
Ixy = -220*lbm2slug/144;
Ixz = -720*lbm2slug/144;
Iyz = -1271*lbm2slug/144;

m = 120*lbm2slug;
xcg1 = (37 - 13.6)/12;
xcg2 = (44.25 - 37)/12;
ycg2 = 6/12;
Tsmall = 33;
Tbig = 56;
g = 32;
a = 637137;
e = 0.0818191908426;

A=[0 0 0 1 0 0 0 0 0 0 0 0;
    0 0 0 0 1 0 0 0 0 0 0 0;
    0 0 0 0 0 1 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 -g 0 0 0;
    0 0 0 0 0 0 0 g 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 1 0 0;
    0 0 0 0 0 0 0 0 0 0 1 0;
    0 0 0 0 0 0 0 0 0 0 0 1;
    0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0];
B=[0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    -1/m -1/m -1/m 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 (Tsmall*xcg1)/Izz
    0 ycg2/Ixx -ycg2/Ixx 0
    xcg1/Iyy -xcg2/Iyy -xcg2/Iyy 0];
C=eye(12);
D=zeros(12,4); 
Q = [1/1^2 0 0 0 0 0 0 0 0 0 0 0;
    0 1/1^2 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 1/1^2 0 0 0 0 0 0 0 0;
    0 0 0 0 1/1^2 0 0 0 0 0 0 0;
    0 0 0 0 0 1/0.1^2 0 0 0 0 0 0;
    0 0 0 0 0 0 1/0.1^2 0 0 0 0 0;
    0 0 0 0 0 0 0 1/0.1^2 0 0 0 0;
    0 0 0 0 0 0 0 0 1/0.1^2 0 0 0;
    0 0 0 0 0 0 0 0 0 1/1.5^2 0 0;
    0 0 0 0 0 0 0 0 0 0 1/1.5^2 0;
    0 0 0 0 0 0 0 0 0 0 0 1/1.5^2];

R = [1/33^2 0 0 0;
    0 1/56^2 0 0;
    0 0 1/56^2 0;
    0 0 0 1/0.5^2];

% Q = [10^6 0 0 0 0; 0 10^9 0 0 0; 0 0 1 0 0; 0 0 0 10^5 0; 0 0 0 0 1];
% R = eye(3);
K = lqr(A,B,Q,R);
rank(ctrb(A,B))
% Nss = -inv(C*inv(A-B*K)*B);
B21 = k1/m;
B22 = k2/m;
B23 = k3/m;
B41 = -(k1*xcg1)/Iyy;
B42 = (k2*xcg2)/Iyy;
B43 = (k3*xcg2)/Iyy;
B62 = -(k2*ycg2)/Ixx;
B63 = (k3*ycg2)/Ixx;
B21max = (12*Tsmall)/m;
B22max = (12*Tbig)/m;
B23max = (12*Tbig)/m;
B41min = -(12*Tsmall*xcg1)/Iyy;
B42max = (12*Tbig*xcg2)/Iyy;
B43max = (12*Tbig*xcg2)/Iyy;
B62min = -(12*Tbig*ycg2)/Ixx;
B63max = (12*Tbig*ycg2)/Ixx;
Rscub = 7.7/24;
Cdprop = 0.045;
d = 0.5*Rscub^3*0.0024*0.8*(pi*Rscub^2)*Cdprop;
ScubRPM = 14000;
ScubTLBS = 250/4.45;
bScub = ScubTLBS/ScubRPM^2;
VasRPM = 30000;
VasTLBS = 200/4.45;
bVas = VasTLBS/VasRPM^2;

Aproj = 8.8;
rho = 0.0024;
Cdvertical = 1;