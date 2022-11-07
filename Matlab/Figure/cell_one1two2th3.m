C=cell(2,3);
C{1,1}='one';C{1,2}='two';C{1,3}='three';
C{2,1}=1;C{2,2}=2;C{2,3}=3;
for i=1:3
    eval([eval(['C{1,' num2str(i) '}']),'=C{2,' num2str(i) '};']);
end