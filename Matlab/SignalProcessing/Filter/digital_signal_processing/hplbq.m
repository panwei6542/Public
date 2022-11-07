clear all
%第一步：性能指标转换
hpWp=2000*2*pi;%通带截止角频率
hpWst=1600*2*pi;%阻带截止角频率
det1=3;%通带最大衰减
det2=20;%阻带最小衰减
Fs=10000;
%性能指标修正
hpWp=Fs*2*tan(hpWp/Fs/2);%通带截止角频率
hpWst=Fs*2*tan(hpWst/Fs/2);%阻带截止角频率
%将高通性能指标转化为低通性能指标
lpWp=1;%hpWp;
lpWst=abs(hpWp*lpWp/hpWst);

%第二步：把低通性能指标代入巴特沃斯模型计算出归一化模拟低通滤波器
[N,Wc]=buttord(lpWp,lpWst,det1,det2,'s');%将性能指标代入巴特沃斯模型，计算出滤波器阶数N和3dB截止角频率
[Z,P,K]=buttap(N);%计算阶数为N的截止角频率为1巴特沃斯滤波器系统函数，得到的是零极点模型
[Bap,Aap]=zp2tf(Z,P,K);%将截止角频率为1的零极点模型转换为多项式模型

%第三步：将归一化模拟低通滤波器转换为高通滤波器
[bx,ax]=lp2hp(Bap,Aap,hpWp);

%第四步：根据采样频率，利用双线性变换法，将模拟滤波器转化为数字滤波器
[bz,az]=bilinear(bx,ax,Fs);

%第五步：画出设计好的滤波器的幅度响应，检验是否满足要求
[H,W]=freqz(bz,az);
figure
plot(W*Fs/(2*pi),abs(H),'k');
grid
xlabel('频率/Hz');
ylabel('幅度响应');