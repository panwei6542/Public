clc
clear
close all
%%
x=-2:0.1:2;
coArray=['y','m','c','r','g','b','w','k'];%初始颜色数组
liArray=['o','x','+','*','-',':','-.','--','.'];%初始线条数组
for i=0:0.2:4
    y=i*x.^2;
    liPos=randi([1,length(liArray)],1,1);%随机选取线条
    liVal=liArray(liPos);%取得随机线条
    coPos=randi([1,length(coArray)],1,1);%随机选取颜色
    coVal=coArray(coPos);%取得随机颜色
    plot(x,y,[coVal liVal]);
    hold on;
end
grid;
%%
X = [0 1 1 2; 1 1 2 2; 0 0 1 1];
Y = [1 1 1 1; 1 0 1 0; 0 0 0 0];
Z = [1 1 1 1; 1 0 1 0; 0 0 0 0];
C = [0.5000 1.0000 1.0000 0.5000;
     1.0000 0.5000 0.5000 0.1667;
     0.3330 0.3330 0.5000 0.5000];
figure('name','三维多边形')
% fill3(X,Y,Z,C) 填充三维多边形。X、Y 和 Z 三元组指定多边形顶点。
% 如果 X、Y 或 Z 为矩阵，则 fill3 会创建 n 个多边形，其中 n 为矩阵中的列数。
% fill3 必要时可将最后一个顶点与第一个顶点相连以闭合这些多边形。
% X、Y 和 Z 的值可以是数值、日期时间、持续时间或类别值。
% C 指定颜色，其中 C 为当前颜色图索引的向量或矩阵。
% 如果 C 为行向量，length(C) 必须等于 size(X,2) 和 size(Y,2)；如果 C 为列向量，length(C) 必须等于 size(X,1) 和 size(Y,1)。
fill3(X,Y,Z,C)
%%
plot(AQI,'b','LineWidth',2);
title('2015年春季石家庄市空气质量指数','FontSize',14);
xlabel('2015年春季天数','FontSize',14);
ylabel('空气质量指数AQI','FontSize',14);
axis([0 95 0 500]);%axis([xmin,xmax,ymin,ymax])
xlim([0 95]);%只限x
% legend({'优';'良';'轻度':'中度':'重度':'严重'});
figure
hold on
fill([0 95 95 0],[0 0 50 50],'g','edgecolor','none','facealpha',0.87)%edgecolor边沿颜色 facealpha透明度
fill([0 95 95 0],[50 50 100 100],'y','edgecolor','none','facealpha',0.87)
fill([0 95 95 0],[100 100 150 150],[243/255,143/255,17/255],'edgecolor','none','facealpha',0.87)
fill([0 95 95 0],[150 150 200 200],'r','edgecolor','none','facealpha',0.87)
fill([0 95 95 0],[200 200 300 300],[211/255,73/255,206/255],'edgecolor','none','facealpha',0.87)
fill([0 95 95 0],[300 300 500 500],[102/255,73/255,107/255],'edgecolor','none','facealpha',0.87)
plot(AQI,'black','LineWidth',2);
plot(AQI_p,'cyan','LineWidth',2);
axis([0 95 0 500]);
title('预测2015年春季石家庄市空气质量指数');
xlabel('2015年春季天数');
ylabel('预测空气质量指数AQI');

string = {['首要污染物预测图   ',['正确率：',num2str(f_accuracy)]]};
title(string)
%%
x = 1:3;
y1 = [3213	3111	3097

];
y2 = [3210	3001	2931];
hold on
plot(x,y1,'r-*','LineWidth',1)
plot(x,y2,'b-o','LineWidth',1)

set(gca,'xtick',0:1:3)
set(gca,'yticklabel',get(gca,'ytick'))
set(get(gca,'XLabel'),'FontSize',20,'FontName','Times New Roman');%设置X坐标标题字体大小，字型  
set(get(gca,'YLabel'),'FontSize',20,'FontName','Times New Roman');%设置Y坐标标题字体大小，字型  
set(gca,'FontName','Times New Roman','FontSize',20)%设置坐标轴字体大小，字型  
text(2,max(get(gca,'ytick')),'10mW','horiz','center','FontSize',20,'FontName','Times New Roman'); %设置文本字型字号  

legend({'Otsu';'Niblack'});
xlabel('Light spot sequence image');
ylabel('Pixel area/pixel');
% title('Accuracy and Time');

x = [x1 y1];
y = [x2 y2];
X = [x1 x2];
Y = [y1 y2];
% axis([0 225 0 225]);
line(X,Y,'color','y','LineWidth','1');
% line属性
% Color:线条颜色  'color',[rand rand rand]随机色
% LineStyle: 线型
% LineWidth: 线宽
% Marker: 点型
% MarkerSize: 点的大小
% MarkerFaceColor: 点的内部颜色。
%% % 根据直线通式（y=b*x+c）求出通过两定点的直线的参数(b,c)
syms b c x1 x2 y1 y2 %定义符号变量
ex1 = b*x1+c-y1;
ex2 = b*x2+c-y2;
[b,c] = solve(ex1,ex2,'b,c');%用来求解线性方程组的解析解或者精确解
% 求出直线方程
A = [1 2];
B = [5 6];
x1 = A(1); x2 = B(1);
y1 = A(2); y2 = B(2);
b = subs(b)%符号计算函数，表示将符号表达式中的某些符号变量替换为指定的新的变量
c = subs(c)
% 作图验证
syms x y
ezplot(b*x+c-y);%绘制符号函数的图像,只需给出函数的解析表达式即可,不需计算,
hold on
plot(x1,y1,'ro');
plot(x2,y2,'ro');
plot(x(1),y(1),'y*',x(2),y(2),'r*',x(3),y(3),'y*',x(4),y(4),'r*')
grid on
hold off
%%  打印标记
x=1:10;
y=x.^2;
plot(x,y);
hold on
str=sprintf('该点坐标\nx=%f\ny=%f',5,25);
plot(5,25,'marker','.','markersize',20)
text(5.5,25,str);
%% 画箭头
axis([0 20 0 30]);
arrow([2,3],[4,5]);

h=arrow([0,0],[10,10]);
set(h,'Facecolor',[0 1 0],'EdgeColor',[0 1 0]);
% x = -1:0.2:1;
% y = 2*x;
% plot(x,y)
% annotation('arrow',[0.2 0.4],[0.4 0.8])
% annotation('doublearrow',[0.2 0.4],[0.85 0.85])
% z = annotation('textarrow',[0.606 0.6],[0.55 0.65]);
% set(z,'string','y = 2x','fontsize',15);
%% 生造图
clear,clc
clf

cm = [0 1 0 0;1 0 1 1;1 0 0 1;0 0 0 0];        %邻接矩阵
bg = biograph(cm,'','NodeAutoSize','off','ShowTextInNodes','none','ArrowSize',6);

pos = [0,100;0,0;100,0;100,100];               %节点位置坐标，pos的每一行对应cm里每一行的点

dolayout(bg);
set(bg.nodes,'Shape','circle','Color',[0 0 1],...
    'LineColor',[0 0 0],'Linewidth',2,...
    {'Position'},mat2cell(pos,[1,1,1,1],2));
set(bg.edges,'LineColor',[0 0 0])
dolayout(bg,'Pathsonly',1)

view(bg)
%% solve求解代数方程组，线性，非线性都可以
S = solve('y=3.01*x-5','y=(-5*x)+20.003','x','y');
S.x
S.y

[x,y] = solve('y=3.01*x-5','y=(-5*x)+20.003','x','y');
x
y
%%
t = 0:pi/20:2*pi;
plot(t,sin(t),'-.r*')
hold on
plot(t,sin(t-pi/2),'--mo')
plot(t,sin(t-pi),':bs')
hold off
%%
clc,clear;
% a = 1:1:6;  %横坐标
% b = [8.0 9.0 10.0 15.0 35.0 40.0]; %纵坐标
a = [0 10 20 30 40 50];
b = [0 0.484 0.512 0.622 0.713 0.786];
% plot(a, b, 'b');  %自然状态的画图效果
% hold on;
%% 第一种，画平滑曲线的方法
% c = polyfit(a, b, 2);  %进行拟合，c为2次拟合后的系数
% d = polyval(c, a, 1);  %拟合后，每一个横坐标对应的值即为d
% plot(a, d, 'r');  %拟合后的曲线
% 
% % plot(a, b, '*');  %将每个点 用*画出来
% hold on;
%% 第二种，画平滑曲线的方法
values = spcrv([[a(1) a a(end)];[b(1) b b(end)]],3);
plot(values(1,:),values(2,:), 'g');
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc,clear;
a = zeros(12,6);
b = zeros(12,6);
%% 
a(1:6,:) = [0 10 20 30 40 50;
    0 10 20 30 40 50;
    0 10 20 30 40 50;
    0 10 20 30 40 50;
    0 10 20 30 40 50;
    0 10 20 30 40 50;];
b(1,:) = [0 0.484 0.512 0.622 0.713 0.786];
b(2,:) = [0 0.412 0.464 0.562 0.601 0.695];
b(3,:) = [0 0.415 0.422 0.455 0.573 0.626];
b(4,:) = [0 0.414 0.458 0.486 0.525 0.585];
b(5,:) = [0 0.492 0.534 0.620 0.698 0.725];
b(6,:) = [0 0.624 0.698 0.730 0.762 0.798];

a(7:12,:) = [0 0.2 0.4 0.6 0.8 1;
    0 0.2 0.4 0.6 0.8 1;
    0 0.2 0.4 0.6 0.8 1;
    0 0.2 0.4 0.6 0.8 1;
    0 0.2 0.4 0.6 0.8 1;
    0 0.2 0.4 0.6 0.8 1;];
b(7,:) = [0.78 0.71 0.63 0.46 0.25 0];
b(8,:) = [0.72 0.68 0.50 0.45 0.26 0];
b(9,:) = [0.76 0.65 0.52 0.43 0.16 0];
b(10,:) = [0.68 0.65 0.48 0.35 0.17 0];
b(11,:) = [0.79 0.73 0.65 0.48 0.23 0];
b(12,:) = [0.75 0.72 0.68 0.62 0.28 0];
% plot(a, b, 'b');  %自然状态的画图效果
% hold on;
%% 第一种，画平滑曲线的方法
% c = polyfit(a, b, 2);  %进行拟合，c为2次拟合后的系数
% d = polyval(c, a, 1);  %拟合后，每一个横坐标对应的值即为d
% plot(a, d, 'r');  %拟合后的曲线
% 
% % plot(a, b, '*');  %将每个点 用*画出来
% hold on;
%% 第二种，画平滑曲线的方法
figure;
for i = 1:6
    values = spcrv([[a(i,1) a(i,:) a(i,end)];[b(i,1) b(i,:) b(i,end)]],3);
    plot(values(1,:),values(2,:));
    hold on
end
hold off
figure;
for i = 7:12
    values = spcrv([[a(i,1) a(i,:) a(i,end)];[b(i,1) b(i,:) b(i,end)]],3);
    plot(values(1,:),values(2,:));
    hold on
end