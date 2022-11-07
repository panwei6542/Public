% �����������������֪��������xdata���������ydata��
% ����֪������������ĺ�����ϵΪydata=F(x, xdata)��
% ����֪��ϵ������x�������������ϣ���xʹ�������������С���˱��ʽ������
% min ��(F(x,xdatai)-ydatai)^2
% 
% ���� lsqcurvefit
% ��ʽ x = lsqcurvefit(fun,x0,xdata,ydata)
% x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub)
% x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options)
% [x,resnorm] = lsqcurvefit(��)
% [x,resnorm,residual] = lsqcurvefit(��)
% [x,resnorm,residual,exitflag] = lsqcurvefit(��)
% [x,resnorm,residual,exitflag,output] = lsqcurvefit(��)
% [x,resnorm,residual,exitflag,output,lambda] = lsqcurvefit(��)
% [x,resnorm,residual,exitflag,output,lambda,jacobian] =lsqcurvefit(��)
% ����˵����
% x0Ϊ��ʼ��������xdata��ydataΪ�����ϵydata=F(x, xdata)�����ݣ�
% lb��ubΪ���������½���Ͻ�lb��x��ub����û��ָ���磬��lb=[ ]��ub=[ ]��
% optionsΪָ�����Ż�������
% funΪ����Ϻ���������x����Ϻ���ֵ���䶨��Ϊ function F = myfun(x,xdata)
% resnorm=sum ((fun(x,xdata)-ydata).^2)������x���в��ƽ���ͣ�
% residual=fun(x,xdata)-ydata������x���Ĳв
% exitflagΪ��ֹ������������
% outputΪ������Ż���Ϣ��
% lambdaΪ��x����Lagrange���ӣ�
% jacobianΪ��x����Ϻ���fun��jacobian����
% 
% ��: ���������С���˷������������
% ��֪��������xdata���������ydata���ҳ��ȶ���n������Ϻ����ı��ʽΪ:
% 
% ydata(i)=x(1)*xdata2+x(2)*sin(xdata)+x(3)*xdata3
% 
% �����ʽ�Ĳ���Ϊ[x(1),x(2),x(3)]��Ŀ�꺯��Ϊ: min��( F(x,xdata) - ydata )^2
% 
% ���У�F(x,xdata) = x(1)*xdata^2 + x(2)*sin(xdata) + x(3)*xdata^3
% ��ʼ������Ϊx0=[0.3, 0.4, 0.1]��
% 
% �⣺�Ƚ�����Ϻ����ļ���������Ϊmyfun.m

% Ȼ���������xdata��ydata
xdata = [3.6 7.7 9.3 4.1 8.6 2.8 1.3 7.9 10.0 5.4];
ydata = [16.5 150.6 263.1 24.7 208.5 9.9 2.7 163.9 325.0 54.3];
% x0 = [10, 10, 10]; %��ʼ����ֵ
x0 = [10, 10, 10];
[x,resnorm] = lsqcurvefit(@myfun,x0,xdata,ydata)

function F = myfun(x,xdata)
% F = x(1)*xdata.^2 + x(2)*sin(xdata) + x(3)*xdata.^3;
F = x(1) + x(2)*sin(xdata) + x(3)*xdata.^3;
end