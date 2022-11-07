%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                               InSAR 数据处理
% 
%   针对“1300m乘以800m的矩形场景中，有半径250m，高度80m的圆锥”干涉处理
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 说明如下：
% （1）成像：
%      用在二维频域相位相乘实现SRC的 RD 算法进行成像，分别得到两个天线的SLC；
% （2）配准：
%      由于场景大小仅为1300m乘以800m，经过计算可以得到：
%           近距（两天线）斜距差为 4.2876 m;
%           远距（两天线）斜距差为 4.3690 m;
%           近距与远距斜距差的差别仅为约 0.08m，远小于斜距分辨率约 2.67m。
%      因此，图像配准只需要进行整体配准（粗配准）即可。
%      实际处理中，调用函数进行“图像配准”（包括粗配准和精配准）
%           —— co_registration（）
% （3）去平地相位；
% （4）相位滤波；
%      可以选择以下两种方法中的一种进行相位滤波：
%           a）回转均值滤波——调用函数：Average_Filtering
%           b）回转中值滤波——调用函数：Median_Filtering
% （5）相位解缠绕;
%     a）残差点计算——调用函数：calculata_residue
%     b）二维相位解缠绕：
%        在该干涉仿真中，我经过计算得到的残差点个数恰好为 0 ，这是最理想的情况。
%      而残差点个数为 0 意味着环路积分结果与积分路径无关，因此不需要使用特殊的
%      算法，只需要直接进行普通的环路积分即可，如下：
%           —— 残差点个数为 0 时，调用函数：Phase_unwrapping
%        此外，我也编写了采用“最小二乘法”进行相位解缠绕的函数，也可以采取该
%      函数进行解缠绕——调用函数：LS_unwrapping
% （6）平地相位恢复：
%       使用（3）中计算得到的平地相位，恢复即可；
% （7）高程反演，得到斜距平面的高程信息：
%      a）根据公式可以计算得到与斜距一一对应的高程信息；
%      b）再由此计算得到相应地距平面的坐标后，即可以得到地距平面的高程信息，
%         也就是我们需要的地面高程模型（这相当于完成了斜地变换）；
% 至此，所有干涉处理结果完成。
%
% 截止到 2014.12.22. 17:06 p.m.
%       ——还有一些问题待解决

%%
close all
clear 
clc

%%
% -----------------------------------------------------------------------
%                                   成像
%                           分别得到两个天线的 SLC
% -----------------------------------------------------------------------
% 生成天线 A 和天线 B 对应的成像结果，并进行后续处理

% 生成天线 A 对应的成像结果
[s_imag_A,R0_RCMC,Parameter] = RDA_imaging2(1);  % 调用函数 RDA_imaging2(raw_data_type)，
                            % 令 raw_data_type == 1，代表对天线 A 的原始数据成像；
                            % 返回值除了成像结果外，还返回了参数 Parameter，
                            % 方便后面用来计算平地相位。

% 生成天线 B 对应的成像结果
[s_imag_B,R0_RCMC,Parameter] = RDA_imaging2(2);  % 调用函数 RDA_imaging(raw_data_type)，
                            % 令 raw_data_type == 2，代表对天线 B 的原始数据成像
                            % 返回值除了成像结果外，还返回了参数 Parameter，
                            % 方便后面用来计算平地相位。
% 注意：
% 在上述的两个返回值中，R0_RCMC 和 Parameter，对于天线A的成像过程和天线B的成像
% 过程都是相同的，因此我们不加区分。返回值写为相同的参数名，互相覆盖。

%%
% -----------------------------------------------------------------------
%                                 图像配准
%                           对两幅SLC进行配准处理
% -----------------------------------------------------------------------
% 不经过配准，直接得到相位图，如下：
s = s_imag_A.*conj(s_imag_B);           % 不经过配准时的干涉图（包括幅度和相位）
figure;imagesc(angle(s));title('不经过配准，直接得到的干涉相位图');
% colormap(gray);

% 对天线 B 的 SLC-B 进行“图像配准”，结果如下：
[s_imag_B_after_CoRe,R] = co_registration(s_imag_A,s_imag_B);% 图像配准后
figure;
imagesc(abs(s_imag_B_after_CoRe));
title('经过“图像配准”后的图像B');
% colormap(gray);

% 利用“图像配准”后的天线B的SLC，与天线A的SLC，生成相位图如下：
s_after_CoRe = s_imag_A.*conj(s_imag_B_after_CoRe);
figure;imagesc(angle(s_after_CoRe));title('经过“图像配准”后，得到的相位图');
% colormap(gray);

% 计算“图像配准”后的相关系数：
R_after_CoRe = sum(sum(abs(s_imag_A).*abs(s_imag_B_after_CoRe)))/...
    (sqrt(sum(sum(abs(s_imag_A).^2)))*sqrt(sum(sum(abs(s_imag_B_after_CoRe).^2))));

%%
% -----------------------------------------------------------------------
%                               去平地相位
% -----------------------------------------------------------------------
B = 5;                  % 基线长度
theta_B = 0;            % 基线倾角

% 计算对应场景的平地相位
PHY_flat_earth = calculate_Phase_flat(R0_RCMC,Parameter,B,theta_B);% 计算得到的平地相位

% 将平地相位写成 exp 的指数形式
s_PHY_flat_earth = exp(1j*PHY_flat_earth);

% 将整体配准后的干涉图，与exp形式的平地相位的复共轭相乘，实现去平地相位；
% 此时，取出相乘结果的相位，即为去平地相位后的结果；
s_after_flat_earth = s_after_CoRe.*conj(s_PHY_flat_earth);% 去平地相位后的干涉图（包括幅度和相位）

% 作图
figure;imagesc(angle(s_PHY_flat_earth));title('理论计算得到的平地相位');

figure;imagesc(angle(s_after_flat_earth));title('去平地相位后的相位图');

%%
% -----------------------------------------------------------------------
%                               相位滤波
%               可以选择采用“回转均值滤波”或者“回转中值滤波”
% -----------------------------------------------------------------------
% 由于原始成像结果中，最左侧和最右侧的一部分是无数据的。因此在下面的处理中将其截取掉。
COL_min = 40;       % 左侧从第 40 列开始；
COL_max = 470;      % 右侧到第 470 列结束；
s_after_flat_earth_2 = s_after_flat_earth(:,COL_min:COL_max);    % 取第40列到第470列；
PHY_s_after_flat_earth = angle(s_after_flat_earth_2); % 取出干涉图的相位
figure;imagesc(PHY_s_after_flat_earth);title('相位滤波前的相位图');

% 设置窗口大小为：（2*window_N+1）*（2*window_M+1）
window_M = 2;
window_N = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 方法 1 ：
% 利用“回转均值滤波法”进行相位滤波
%
PHY_s_after_avg_filtering = Average_Filtering(PHY_s_after_flat_earth,window_M,window_N);

figure;imagesc(PHY_s_after_avg_filtering);title('“回转均值滤波”后的相位图');
colormap(gray);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 方法 2 ：
% 利用“回转中值滤波法”进行相位滤波
%{
PHY_s_after_median_filtering = Median_Filtering(PHY_s_after_flat_earth,window_M,window_N);

figure;imagesc(PHY_s_after_median_filtering);title('“回转中值滤波”后的相位图');
colormap(gray);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% 根据上面是采用的“回转均值滤波”还是“回转中值滤波”选取对应的输入值，进行后续处理
PHY_s_after_X_filtering = PHY_s_after_avg_filtering; 
% 这里选择的是“回转均值滤波”的处理结果

% -----------------------------------------------------------------------
%                     	残差点（residue）计算
% -----------------------------------------------------------------------
% 判断干涉图中的残差点——调用函数 calculata_residue：
[PHY_residue,residue_count] = calculata_residue(PHY_s_after_X_filtering);
disp('----------------------------------------------');
disp('计算得到的正负残差点总个数为：');
disp(residue_count);
disp('----------------------------------------------');

figure;imagesc(PHY_residue);title('残差点计算结果');colormap(gray);

% -----------------------------------------------------------------------
%                               相位解缠绕
% -----------------------------------------------------------------------
% 下面进行二维解缠绕
% 方法为：
%   1）若残差点个数为0，说明积分结果不受积分路径的影响。因此我们可以直接将一维
%      相位解缠绕的方法扩展到二维。可以采取如下积分路径：
%           a）先从左至右解缠绕第一行，再从上向下分别解缠绕各列；
%           b）先从上到下解缠绕第一列，再从左向右分别解缠绕各行；
%   2）若残差点个数不为0，则积分结果与路径相关，我们采用如下方法：
%           最小二乘法
if residue_count == 0   % 此时可以直接进行解缠绕，如上所述；
	PHY_after_unwrapping = Phase_unwrapping(PHY_s_after_X_filtering);
else                    % 残差点个数不为 0 时，采用“最小二乘法”进行解缠绕；
    PHY_after_unwrapping = LS_unwrapping(PHY_s_after_X_filtering);
    PHY_after_unwrapping = real(PHY_after_unwrapping);  % 取实部
end

% 作图
figure;imagesc(PHY_after_unwrapping);title('二维相位解缠绕结果');
% 下面用 surf 做三维曲面图
Naz = Parameter(1,1);           % Parameter 的第一行代表 Naz
Fa = 200;                       % 方位采样率
Vr = 150;                       % 雷达有效速度
ta = ( -Naz/2: Naz/2-1 )/Fa;	% 方位时间轴
R_azimuth = ta.*Vr;             % 沿方位向变化的距离轴
[X,Y] = meshgrid(R0_RCMC(COL_min:COL_max),R_azimuth);
figure;
surf(X,Y,PHY_after_unwrapping);
title('二维相位解缠绕结果');

%%
% -----------------------------------------------------------------------
%                     平地相位恢复，完成相对相位解缠绕
%                                 同时
%                根据参考点加上参考相位，完成真实相位求解
% -----------------------------------------------------------------------
% 前面去掉的平地相位是：PHY_flat_earth
% 下面再二维相位解缠绕结果的基础上，恢复平地相位，如下：
PHY_return_flat_earth = PHY_after_unwrapping + PHY_flat_earth(:,COL_min:COL_max);

figure;imagesc(PHY_return_flat_earth);title('平地相位恢复后，干涉相位图');
figure;
surf(X,Y,PHY_return_flat_earth);
title('平地相位恢复后，干涉相位图');

% 至此，相对相位解缠绕就已经完成
% 但得到的整个平面相位仍与真实干涉相位之间差一个相位，这个相位是2π的整数倍
% 而且对图像中的每个像素都一样。
% 下面依靠地面某一个已知高度的点进行标定，完成真实相位求解
%               —— 这一部分不太清楚怎么做。
%               —— 我计算过，但不是2*π的整数倍。     （待解决）
delta_PHY_reference = PHY_return_flat_earth(1,1) - PHY_flat_earth(1,COL_min);
% 以相对相位解缠绕结果的点（1,1）所对应的原始地面的点，作为参考，进行标定。
% delta_PHY_reference 是：相对相位解缠绕的结果与参考点的相位差，作为标定结果。
PHY_return_flat_earth =  PHY_return_flat_earth - delta_PHY_reference;

%%
% -----------------------------------------------------------------------
%                           计算地面高程模型
% -----------------------------------------------------------------------
lamda = Parameter(3,1);     % Parameter 的第三行代表 lamda　、
H = Parameter(2,1);         % Parameter 的第二行代表 H

% 计算出对应于每个斜距的高程信息
% 原理：
%   1）利用上面平地相位恢复后的相位图；
%   2）公式参考：保铮《雷达成像技术》第 282 页，公式（8.4）到公式（8.7）；
% 下面进行计算：
R_1 = ones(Naz,1)*R0_RCMC(:,COL_min:COL_max);   % 用于高程计算的斜距。

delta_r_PHY = PHY_return_flat_earth.*lamda/(4*pi);  
% “乒乓模式”，分母是4π；
% “标准模式”，分母是2π；
theta_r = acos(((2*R_1+delta_r_PHY).*delta_r_PHY - B^2)...
            ./(2*B.*R_1)) - (pi/2 - theta_B);

H_area = H - R_1.*cos(theta_r);
% H_area 即是对应于每个斜距的高程信息。
X_area = sqrt(R_1.^2 - (H - H_area).^2);
% X_area 是 R_1 对应的地面 x 轴坐标。

% 作图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 这是斜距平面的高程信息，作图如下：
figure;
imagesc(R0_RCMC(:,COL_min:COL_max),R_azimuth,H_area);
title('斜距平面的高程信息');
xlabel('斜距坐标，单位：m');
ylabel('方位向坐标，y 轴，单位：m');

figure;
surf(X,Y,H_area);
title('斜距平面的高程图');
xlabel('斜距坐标，单位：m');
ylabel('方位向坐标，y 轴，单位：m');
zlabel('高度坐标，z 轴，单位：m');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 这是地距平面的高程信息（即地面高程模型），作图如下：
% 注意，由于我没有进行地面重采样，所以我没法绘出地面平面的二维图，即imagesc表示
% 的图形。因此此时的地距 X 轴坐标不是规则的。如果需要绘出这样的地面高程模型
% （二维，亮度表示高度），那么还有一些工作需要去做。
% 这里我没有进行

% 下图是直接以求得的地距 X 轴坐标（也就是没有进行重采样，故而是不规则的）来绘出
% 地距平面高程图，三维的。
figure;
surf(X_area,Y,H_area);
title('地距平面的高程图，即地面高程模型');
title('地面高程模型');
xlabel('地距坐标，x 轴，单位：m');
ylabel('地距坐标，y 轴，单位：m');
zlabel('高度坐标，z 轴，单位：m');




