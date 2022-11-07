%--------------------------------------------------------------------------
%   ��ʼ��
%--------------------------------------------------------------------------
clear;clc;

%--------------------------------------------------------------------------
%   example 1
%--------------------------------------------------------------------------
a = 0.9;
N = 64;
n = 0:N-1;
x = n.*a.^n;

s = linspace(0,63,512);
x2 = sinc_interp(x,s);

plot(n,x,'o');hold on
plot(s,x2,'.')
