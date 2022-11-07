%--------------------------------------------------------------------------
%   初始化
%--------------------------------------------------------------------------
clear;clc;

%--------------------------------------------------------------------------
%   构造2个阵元，全向天线
%--------------------------------------------------------------------------
shape = [0 0;-0.5 0.5;0 0];
lambda = 2;
w_angle = 0;

%--------------------------------------------------------------------------
%   和波束
%--------------------------------------------------------------------------
w = exp(-1i*2*pi/lambda*1*sind(w_angle)).^(0:1)'; 
[theta,E] = rt.array_pattern(shape,lambda,w);
E_sum = mean(E,2);

%--------------------------------------------------------------------------
%   差波束
%--------------------------------------------------------------------------
w(2) = -w(2);
[theta,E] = rt.array_pattern(shape,lambda,w);
E_delta = mean(E,2);



figure(1)
subplot(211)
plot(theta,pow2db(abs(E_sum).^2));hold on
plot(theta,pow2db(abs(E_delta).^2));

hold off
grid on;
axis([-90 90 -50 0]);title('和差波束')
%--------------------------------------------------------------------------
%   和差波束曲线
%--------------------------------------------------------------------------
subplot(212)
fai = abs(E_delta)./abs(E_sum).*sign(angle(conj(E_sum).*E_delta));
plot(theta,fai);grid on;
axis([-90 90 -20 20]);title('和差波束查表曲线')

%--------------------------------------------------------------------------
%   三次函数拟合查表曲线
%--------------------------------------------------------------------------
st = find(theta == -45);
en = find(theta == 45);
scale = st:en;
t = theta(scale);t = t(:);
f = fai(scale);f = f(:);
plot(t,f);grid on
[poly5_rate2angle, gof] = createFit(f, t)







