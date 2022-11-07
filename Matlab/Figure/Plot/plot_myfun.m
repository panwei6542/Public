% 非线性曲线拟合是已知输入向量xdata和输出向量ydata，
% 并且知道输入与输出的函数关系为ydata=F(x, xdata)，
% 但不知道系数向量x。今进行曲线拟合，求x使得输出的如下最小二乘表达式成立：
% min Σ(F(x,xdatai)-ydatai)^2
% 
% 函数 lsqcurvefit
% 格式 x = lsqcurvefit(fun,x0,xdata,ydata)
% x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub)
% x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options)
% [x,resnorm] = lsqcurvefit(…)
% [x,resnorm,residual] = lsqcurvefit(…)
% [x,resnorm,residual,exitflag] = lsqcurvefit(…)
% [x,resnorm,residual,exitflag,output] = lsqcurvefit(…)
% [x,resnorm,residual,exitflag,output,lambda] = lsqcurvefit(…)
% [x,resnorm,residual,exitflag,output,lambda,jacobian] =lsqcurvefit(…)
% 参数说明：
% x0为初始解向量；xdata，ydata为满足关系ydata=F(x, xdata)的数据；
% lb、ub为解向量的下界和上界lb≤x≤ub，若没有指定界，则lb=[ ]，ub=[ ]；
% options为指定的优化参数；
% fun为待拟合函数，计算x处拟合函数值，其定义为 function F = myfun(x,xdata)
% resnorm=sum ((fun(x,xdata)-ydata).^2)，即在x处残差的平方和；
% residual=fun(x,xdata)-ydata，即在x处的残差；
% exitflag为终止迭代的条件；
% output为输出的优化信息；
% lambda为解x处的Lagrange乘子；
% jacobian为解x处拟合函数fun的jacobian矩阵。
% 
% 例: 求解如下最小二乘非线性拟合问题
% 已知输入向量xdata和输出向量ydata，且长度都是n，待拟合函数的表达式为:
% 
% ydata(i)=x(1)*xdata2+x(2)*sin(xdata)+x(3)*xdata3
% 
% 即表达式的参数为[x(1),x(2),x(3)]。目标函数为: minΣ( F(x,xdata) - ydata )^2
% 
% 其中：F(x,xdata) = x(1)*xdata^2 + x(2)*sin(xdata) + x(3)*xdata^3
% 初始解向量为x0=[0.3, 0.4, 0.1]。
% 
% 解：先建立拟合函数文件，并保存为myfun.m

% 然后给出数据xdata和ydata
xdata = [3.6 7.7 9.3 4.1 8.6 2.8 1.3 7.9 10.0 5.4];
ydata = [16.5 150.6 263.1 24.7 208.5 9.9 2.7 163.9 325.0 54.3];
% x0 = [10, 10, 10]; %初始估计值
x0 = [10, 10, 10];
[x,resnorm] = lsqcurvefit(@myfun,x0,xdata,ydata)

function F = myfun(x,xdata)
% F = x(1)*xdata.^2 + x(2)*sin(xdata) + x(3)*xdata.^3;
F = x(1) + x(2)*sin(xdata) + x(3)*xdata.^3;
end