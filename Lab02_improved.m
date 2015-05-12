%Lab02_improved.m
%函数敛散性实验加强版
clear; clc; format long;
syms x; syms a; syms b; syms c;

%第一步:求点
disp('第一步:求点')
tic

index = 8;
cSize = 10^ceil(index/2);
rSize = 10^floor(index/2);
C = zeros(cSize,1);
I = bsxfun(@plus, 0:cSize-1, cSize*(0:rSize-1)');

for i = 1:cSize
    if ~isempty(regexp(num2str(I(1,i)), '9','ONCE'))
        C(i) = i;
    end
end

dCln = C(C~=0);

if rSize==cSize
    dRow = dCln;
else
    R = zeros(rSize,1);
    for i = 1:rSize
        if ~isempty(regexp(num2str(I(1,i)), '9','ONCE'))
            R(i) = i;
        end
    end
    dRow = R(R~=0);
end

I(:,dCln) = [];
I(dRow,:) = [];
I(1,1) = inf;
Pts = zeros(2,500);
rSize = size(I,1);
step = ceil(rSize/500);

for i = 1:step:rSize
    Pts(:,i) = [I(i,end);sum(sum(1./I(1:i,:)))];
end
X = Pts(1,:);
X = X(X~=0);
Y = Pts(2,:);
Y = Y(Y~=0);

toc

%第二步:拟合
disp('第二步:拟合')
tic

F=inline('beta(1).*exp(-22./log(x)+beta(2))+beta(3)','beta','x');
beta = nlinfit(X(1:100),Y(1:100),F,[0 0 0])
a = beta(1);
b = beta(2);
c = beta(3);

xx = 0:100:I(rSize,end);
yy = a.*exp(-22./log(xx)+b)+c;
g1 = plot(Pts(1,:),Pts(2,:));
set(g1,'LineStyle','.','color','m','Linewidth',0.05);
hold on;
g2 = plot(xx,yy);
set(g2,'LineStyle','-','color','g','Linewidth',1.5);
hold on;
xlabel('x');ylabel('y');axis([10^(index-1),10^index,10,14]);
l = legend([g1,g2],'级数散点','拟合曲线');
set(l,'Location','Best');
toc
