%%================================================================
%%文件名：NearSAR.m
%%作者：徐一凡
%%功能：合成孔径雷达距离多普勒算法点目标成像 
%%================================================================
clear;clc;close all;
%%================================================================
%%常数定义
C=3e8;                            %光速
%%雷达参数
Fc=1e9;                          %载频1GHz
lambda=C/Fc;                     %波长
%%目标区域参数
Xmin=0;                          %目标区域方位向范围[Xmin,Xmax]
Xmax=50;                  
Yc=10000;                      %成像区域中线
Y0=500;                          %目标区域距离向范围[Yc-Y0,Yc+Y0]
                                       %成像宽度为2*Y0
%%轨道参数
V=100;                            %SAR的运动速度100 m/s
H=5000;                          %高度 5000 m
R0=sqrt(Yc^2+H^2); %最短距离
seita = atan(Yc/H);
%%天线参数
D=4;                                %方位向天线长度
Lsar=lambda*R0/D;   %SAR合成孔径长度，《合成孔径雷达成像??算法与实现》P.100
Tsar=Lsar/V;                   %SAR照射时间
%%慢时间域参数
Ka=-2*V^2/lambda/R0;    %多普勒频域调频率P.93
Ba=abs(Ka*Tsar);           %多普勒频率调制带宽
PRF=Ba;                         %脉冲重复频率，PRF其实为多普勒频率的采样率，又为复频率，所以等于Ba.P.93
PRT=1/PRF;                   %脉冲重复时间
ds=PRT;                         %慢时域的时间步长
Nslow=ceil((Xmax-Xmin+Lsar)/V/ds); %慢时域的采样数，ceil为取整函数，结合P.76的图理解  
Nslow=2^nextpow2(Nslow);              %nextpow2为最靠近2的幂次函数，这里为fft变换做准备
sn=linspace((Xmin-Lsar/2)/V,(Xmax+Lsar/2)/V,Nslow);%慢时间域的时间矩阵
PRT=(Xmax-Xmin+Lsar)/V/Nslow;    %由于Nslow改变了，所以相应的一些参数也需要更新，周期减小了
PRF=1/PRT;
ds=PRT;
%%快时间域参数设置
Tr=5e-6;                         %脉冲持续时间5us
Br=30e6;                        %chirp频率调制带宽为30MHz
Kr=Br/Tr;                        %chirp调频率
Fsr=2*Br;                        %快时域采样频率，为2倍的带宽
dt=1/Fsr;                         %快时域采样间隔
Rmin=sqrt((Yc-Y0)^2+H^2);
Rmax=sqrt((Yc+Y0)^2+H^2+(Lsar/2)^2);
Nfast=ceil(2*(Rmax-Rmin)/C/dt+Tr/dt);%快时域的采样数量
Nfast=2^nextpow2(Nfast);                   %更新为2的幂次，方便进行fft变换
tm=linspace(2*Rmin/C,2*Rmax/C+Tr,Nfast); %快时域的离散时间矩阵
dt=(2*Rmax/C+Tr-2*Rmin/C)/Nfast;    %更新间隔
Fsr=1/dt;
%%分辨率参数设置
DY=C/2/Br;                           %距离向分辨率
DX=D/2;                                %方位向分辨率
%%点目标参数设置
Ntarget=5;                            %点目标的数量
%点目标格式[x,y,反射系数sigma]
Ptarget=[Xmin,Yc-50*DY,1               %点目标位置，这里设置了5个点目标，构成一个矩形以及矩形的中心
              Xmin+50*DX,Yc-50*DY,1
              Xmin+25*DX,Yc,1
              Xmin,Yc+50*DY,1
              Xmin+50*DX,Yc+50*DY,1];  
disp('Parameters:')    %参数显示
disp('Sampling Rate in fast-time domain');disp(Fsr/Br)
disp('Sampling Number in fast-time domain');disp(Nfast)
disp('Sampling Rate in slow-time domain');disp(PRF/Ba)
disp('Sampling Number in slow-time domain');disp(Nslow)
disp('Range Resolution');disp(DY)
disp('Cross-range Resolution');disp(DX)     
disp('SAR integration length');disp(Lsar)     
disp('Position of targets');disp(Ptarget)
%%================================================================
%%绘制发射信号
% figure;
% t=0:dt:4*PRT;
% duty=Tr/PRT*100;
% rect=0.5*square(2*pi*PRF*t,duty)+0.5;
% sigal_tiaozhi=cos(2*pi*Fc*t+pi*Kr*t.*t);
% sigal_fashe=rect .* sigal_tiaozhi;
% subplot(2,2,1);
% plot(t,rect);
% ylim([-1.1,1.1]);
% title('矩形波');
% 
% subplot(2,2,2);
% plot(t,sigal_tiaozhi);
% ylim([-1.1,1.1]);
% title('调制波形');
% subplot(2,2,3);
% plot(t,sigal_fashe);
% ylim([-1.2,1.2]);
% xlim([0,2*Tr]);
% title('发射信号');
%%================================================================
%%生成回波信号
K=Ntarget;                                %目标数目
N=Nslow;                                  %慢时域的采样数
M=Nfast;                                  %快时域的采样数
T=Ptarget;                                %目标矩阵
Srnm=zeros(N,M);                          %生成零矩阵存储回波信号
for k=1:1:K                               %总共K个目标
    sigma=T(k,3);                         %得到目标的反射系数
    Dslow=sn*V-T(k,1);                    %方位向距离，投影到方位向的距离  
    R=sqrt(Dslow.^2+T(k,2)^2+H^2);        %实际距离矩阵
    tau=2*R/C;                            %回波相对于发射波的延时
    Dfast=ones(N,1)*tm-tau'*ones(1,M);    %(t-tau)，其实就是时间矩阵，ones(N,1)和ones(1,M)都是为了将其扩展为矩阵
    phase=pi*Kr*Dfast.^2-(4*pi/lambda)*(R'*ones(1,M));%相位，公式参见P.96
    Srnm=Srnm+sigma*exp(1i*phase).*(0<Dfast&Dfast<Tr).*((abs(Dslow)<Lsar/2)'*ones(1,M));%由于是多个目标反射的回波，所以此处进行叠加
    
    %%================================================================
%绘制回波信号
figure;
xx=linspace(-1,1,M);
yy=linspace(-1,1,N);
[x,y]=meshgrid(xx,yy);
subplot(221);
surf(x,y,Dfast);
title('时间矩阵');
subplot(222);
surf(x,y,phase);
title('相位');
subplot(223);
surf(x,y,abs(Srnm));
title('回波');
end

%%================================================================
%%绘制场景点
figure;
plot(Ptarget(:,2),Ptarget(:,1), 'o');
ylim([Xmin-Lsar/2,Xmax+Lsar/2]);
xlim([0,Yc+Y0]);
grid on;
ylabel('x轴(方位向)'); 
xlabel('y轴(距离向)');
title('观测场景及点目标');

%%================================================================
%%距离-多普勒算法开始
%%距离向压缩
tic;
tr=tm-2*Rmin/C;  %时间对齐到0
Refr=exp(1i*pi*Kr*tr.^2).*(0<tr&tr<Tr);
Sr=ifty(fty(Srnm).*(ones(N,1)*conj(fty(Refr)))); %频域中做脉冲压缩
Gr=abs(Sr);

% figure;
% [x,y]=meshgrid(1:size(Gr,2),1:size(Gr,1));
% surf(x,y,Gr,gradient(Gr));


%%开始进行距离弯曲补偿正侧视没有距离走动项 主要是因为斜距的变化引起回波包络的徙动 
%%补偿方法：最近邻域插值法，具体为：先变换到距离多普勒域，分别对单个像素点计算出距离徙动量，得到距离徙动量与距离分辨率的比值，
%%该比值可能为小数，按照四舍五入的方法近似为整数，而后在该像素点上减去徙动量
%%方位向做fft处理 再在频域做距离弯曲补偿
Sa_RD = ftx(Sr);     %  方位向FFT 变为距离多普域进行距离弯曲校正
%距离徙动运算,由于是正侧视 ，fdc=0,只需要进行距离弯曲补偿。
Kp=1;                                  %计算或者预设预滤波比
h = waitbar(0,'最近邻域插值');
%%首先计算距离迁移量矩阵
for n=1:N     %总共有N个方位采样
    for m=1:M %每个方位采样上有M个距离采样
        delta_R = (1/8)*(lambda/V)^2*(R0+(m-M/2)*C/2/Fsr)*((n-N/2)*PRF/N)^2;%距离迁移量P.160；(R0+(m-M/2)*C/2/Fsr)：每个距离向点m的R0更新；(n-N/2)*PRF/N：不同方位向的多普勒频率不一样
        RMC=2*delta_R*Fsr/C;    %此处为delta_R/DY，距离徒动了几个距离单元
%         RMC = delta_R / DY;
        delta_RMC = RMC-floor(RMC);%距离徒动量的小数部分
        if m+round(RMC)>M              %判断是否超出边界
            Sa_RD(n,m)=Sa_RD(n,M/2);   
        else
            if delta_RMC>=0.5  %五入
                Sa_RD(n,m)=Sa_RD(n,m+floor(RMC)+1);
            else               %四舍
                Sa_RD(n,m)=Sa_RD(n,m+floor(RMC));
            end
        end
    end
    waitbar(n/N)
end
close(h)
%========================
Sr_rmc=iftx(Sa_RD);   %%距离徙动校正后还原到时域
Ga = abs(Sr_rmc);
%%方位向压缩
ta=sn-Xmin/V;
Refa=exp(1i*pi*Ka*ta.^2).*(abs(ta)<Tsar/2);
Sa=iftx(ftx(Sr_rmc).*(conj(ftx(Refa)).'*ones(1,M)));
Gar=abs(Sa);

% figure;
% [x,y]=meshgrid(1:size(Gar,2),1:size(Gar,1));
% surf(x,y,Gar,gradient(Gar));

toc;
%%================================================================
%%绘图
colormap(gray);
figure;
subplot(211);
% row=tm*C/2;%-2008;
% col=sn*V;%-26;
row = Yc + (tm * C / 2 - R0) / sin(seita);
col = sn * V;
imagesc(row,col,255-Gr);           %距离向压缩，未校正距离徙动的图像
% axis([Yc-Y0,Yc+Y0,Xmin-Lsar/2,Xmax+Lsar/2]);
xlabel('距离向'),ylabel('方位向'),
title('距离向压缩，未校正距离徙动的图像'),
subplot(212);
imagesc(row,col,255-Ga);          %距离向压缩，校正距离徙动后的图像
% axis([Yc-Y0,Yc+Y0,Xmin-Lsar/2,Xmax+Lsar/2]);
xlabel('距离向'),ylabel('方位向'),
title('距离向压缩，校正距离徙动后的图像'),
figure;
colormap(gray);
imagesc(row,col,255-Gar);          %方位向压缩后的图像
% axis([Yc-Y0,Yc+Y0,Xmin-Lsar/2,Xmax+Lsar/2]);
xlabel('距离向'),ylabel('方位向'),
title('方位向压缩后的图像'),
