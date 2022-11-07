clc
clear
close all
%%
x=-2:0.1:2;
coArray=['y','m','c','r','g','b','w','k'];%��ʼ��ɫ����
liArray=['o','x','+','*','-',':','-.','--','.'];%��ʼ��������
for i=0:0.2:4
    y=i*x.^2;
    liPos=randi([1,length(liArray)],1,1);%���ѡȡ����
    liVal=liArray(liPos);%ȡ���������
    coPos=randi([1,length(coArray)],1,1);%���ѡȡ��ɫ
    coVal=coArray(coPos);%ȡ�������ɫ
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
figure('name','��ά�����')
% fill3(X,Y,Z,C) �����ά����Ρ�X��Y �� Z ��Ԫ��ָ������ζ��㡣
% ��� X��Y �� Z Ϊ������ fill3 �ᴴ�� n ������Σ����� n Ϊ�����е�������
% fill3 ��Ҫʱ�ɽ����һ���������һ�����������Ապ���Щ����Ρ�
% X��Y �� Z ��ֵ��������ֵ������ʱ�䡢����ʱ������ֵ��
% C ָ����ɫ������ C Ϊ��ǰ��ɫͼ���������������
% ��� C Ϊ��������length(C) ������� size(X,2) �� size(Y,2)����� C Ϊ��������length(C) ������� size(X,1) �� size(Y,1)��
fill3(X,Y,Z,C)
%%
plot(AQI,'b','LineWidth',2);
title('2015�괺��ʯ��ׯ�п�������ָ��','FontSize',14);
xlabel('2015�괺������','FontSize',14);
ylabel('��������ָ��AQI','FontSize',14);
axis([0 95 0 500]);%axis([xmin,xmax,ymin,ymax])
xlim([0 95]);%ֻ��x
% legend({'��';'��';'���':'�ж�':'�ض�':'����'});
figure
hold on
fill([0 95 95 0],[0 0 50 50],'g','edgecolor','none','facealpha',0.87)%edgecolor������ɫ facealpha͸����
fill([0 95 95 0],[50 50 100 100],'y','edgecolor','none','facealpha',0.87)
fill([0 95 95 0],[100 100 150 150],[243/255,143/255,17/255],'edgecolor','none','facealpha',0.87)
fill([0 95 95 0],[150 150 200 200],'r','edgecolor','none','facealpha',0.87)
fill([0 95 95 0],[200 200 300 300],[211/255,73/255,206/255],'edgecolor','none','facealpha',0.87)
fill([0 95 95 0],[300 300 500 500],[102/255,73/255,107/255],'edgecolor','none','facealpha',0.87)
plot(AQI,'black','LineWidth',2);
plot(AQI_p,'cyan','LineWidth',2);
axis([0 95 0 500]);
title('Ԥ��2015�괺��ʯ��ׯ�п�������ָ��');
xlabel('2015�괺������');
ylabel('Ԥ���������ָ��AQI');

string = {['��Ҫ��Ⱦ��Ԥ��ͼ   ',['��ȷ�ʣ�',num2str(f_accuracy)]]};
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
set(get(gca,'XLabel'),'FontSize',20,'FontName','Times New Roman');%����X������������С������  
set(get(gca,'YLabel'),'FontSize',20,'FontName','Times New Roman');%����Y������������С������  
set(gca,'FontName','Times New Roman','FontSize',20)%���������������С������  
text(2,max(get(gca,'ytick')),'10mW','horiz','center','FontSize',20,'FontName','Times New Roman'); %�����ı������ֺ�  

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
% line����
% Color:������ɫ  'color',[rand rand rand]���ɫ
% LineStyle: ����
% LineWidth: �߿�
% Marker: ����
% MarkerSize: ��Ĵ�С
% MarkerFaceColor: ����ڲ���ɫ��
%% % ����ֱ��ͨʽ��y=b*x+c�����ͨ���������ֱ�ߵĲ���(b,c)
syms b c x1 x2 y1 y2 %������ű���
ex1 = b*x1+c-y1;
ex2 = b*x2+c-y2;
[b,c] = solve(ex1,ex2,'b,c');%����������Է�����Ľ�������߾�ȷ��
% ���ֱ�߷���
A = [1 2];
B = [5 6];
x1 = A(1); x2 = B(1);
y1 = A(2); y2 = B(2);
b = subs(b)%���ż��㺯������ʾ�����ű��ʽ�е�ĳЩ���ű����滻Ϊָ�����µı���
c = subs(c)
% ��ͼ��֤
syms x y
ezplot(b*x+c-y);%���Ʒ��ź�����ͼ��,ֻ����������Ľ������ʽ����,�������,
hold on
plot(x1,y1,'ro');
plot(x2,y2,'ro');
plot(x(1),y(1),'y*',x(2),y(2),'r*',x(3),y(3),'y*',x(4),y(4),'r*')
grid on
hold off
%%  ��ӡ���
x=1:10;
y=x.^2;
plot(x,y);
hold on
str=sprintf('�õ�����\nx=%f\ny=%f',5,25);
plot(5,25,'marker','.','markersize',20)
text(5.5,25,str);
%% ����ͷ
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
%% ����ͼ
clear,clc
clf

cm = [0 1 0 0;1 0 1 1;1 0 0 1;0 0 0 0];        %�ڽӾ���
bg = biograph(cm,'','NodeAutoSize','off','ShowTextInNodes','none','ArrowSize',6);

pos = [0,100;0,0;100,0;100,100];               %�ڵ�λ�����꣬pos��ÿһ�ж�Ӧcm��ÿһ�еĵ�

dolayout(bg);
set(bg.nodes,'Shape','circle','Color',[0 0 1],...
    'LineColor',[0 0 0],'Linewidth',2,...
    {'Position'},mat2cell(pos,[1,1,1,1],2));
set(bg.edges,'LineColor',[0 0 0])
dolayout(bg,'Pathsonly',1)

view(bg)
%% solve�����������飬���ԣ������Զ�����
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
% a = 1:1:6;  %������
% b = [8.0 9.0 10.0 15.0 35.0 40.0]; %������
a = [0 10 20 30 40 50];
b = [0 0.484 0.512 0.622 0.713 0.786];
% plot(a, b, 'b');  %��Ȼ״̬�Ļ�ͼЧ��
% hold on;
%% ��һ�֣���ƽ�����ߵķ���
% c = polyfit(a, b, 2);  %������ϣ�cΪ2����Ϻ��ϵ��
% d = polyval(c, a, 1);  %��Ϻ�ÿһ���������Ӧ��ֵ��Ϊd
% plot(a, d, 'r');  %��Ϻ������
% 
% % plot(a, b, '*');  %��ÿ���� ��*������
% hold on;
%% �ڶ��֣���ƽ�����ߵķ���
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
% plot(a, b, 'b');  %��Ȼ״̬�Ļ�ͼЧ��
% hold on;
%% ��һ�֣���ƽ�����ߵķ���
% c = polyfit(a, b, 2);  %������ϣ�cΪ2����Ϻ��ϵ��
% d = polyval(c, a, 1);  %��Ϻ�ÿһ���������Ӧ��ֵ��Ϊd
% plot(a, d, 'r');  %��Ϻ������
% 
% % plot(a, b, '*');  %��ÿ���� ��*������
% hold on;
%% �ڶ��֣���ƽ�����ߵķ���
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