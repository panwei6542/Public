function myclock 
    global aa ti hs hm hh;
    aa=1;
    hs=0;hm=0;hh=0;
     hfig=figure('NumberTitle','off','position',[624 118 600 350],...
       'name','时钟','MenuBar','none','color',[0.8 0.7 0.8]);
        editdate=['s=clock;',...
           ' p1={''年'',''月 '',''日''};',...
           'A=inputdlg(p1,''日期:'',1);',...
           ' s(1)=str2num(A{1});',...
           ' s(2)=str2num(A{2});',...
           ' s(3)=str2num(A{3});',...
           'rili(s);'  ] 
 u1=uimenu(hfig,'label','&更改日期','call',editdate);
 u2=uimenu(hfig,'label','&恢复当前日期','call','ti=clock;rili(ti);');
 ab=['global aa ti hs hm hh;',...
         'aa=0;',...
         'ti=clock;'...
         ' p2={''时'',''分 '',''秒''};',...
         'B=inputdlg(p2,''日期:'',1);',...
         ' ti(4)=str2num(B{1});',...
         ' ti(5)=str2num(B{2});',...
         ' ti(6)=str2num(B{3});',...
          'delete(hs);delete(hm);delete(hh);'...
        'aa=1;'...
        'ck(ti);'
];
u3=uimenu(hfig,'label','&更改时间','Callback',ab);
ab1=['global aa ti hs hm hh;',...
         'aa=0;',...
         'delete(hs);delete(hm);delete(hh);'...
         'ti=clock;'...
         'aa=1;'...
         'ck(ti);'
];
 u4=uimenu(hfig,'label','&恢复当前时间','call',ab1);
u5=uimenu(hfig,'label','&退出','Call','close(gcf)');
u6=uicontrol(hfig,'style','text','string','制作By 涂一云',...
          'Units','normalized', 'position',[0.85 0.01 0.15 0.05],...
          'back',[0.8 0.7 0.8])
ti=clock;rili(ti);ck(ti);


