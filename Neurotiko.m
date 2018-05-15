clc
close all
clear all


load Cotizaciones %leer el fichero.mat
SecMat=Cotizaciones(:,1)';
L=length(SecMat);
SecCell=mat2cell(SecMat,[1],ones(1,L));
Secuencia=SecMat';
NHorizonte=10;
SMA0=Secuencia(1)*ones(NHorizonte-1,1);
[SMASecuencia]=SMA(Secuencia,NHorizonte,SMA0);%MediaMovilSimple
plot(Secuencia,'xr');
hold on
grid on
plot(SMASecuencia,'g');
EMA0=Cotizaciones(1,1);
[EMASecuencia]=EMA(Secuencia,NHorizonte,EMA0);
plot(EMASecuencia,'b')


targetSeries = SecCell;
inputSeries=[];
% Create a Nonlinear Autoregressive Network with External Input
N=NHorizonte;
feedbackDelays = 1:N;
Nneuronas=4;
net = narnet(feedbackDelays,Nneuronas);
[Xs,Xi,Ai,Ts] = preparets(net,{},{},targetSeries);
% Set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 5/100;
net.divideParam.testRatio = 15/100;
net.trainParam.max_fail=100;
% Train the Network
net = train(net,Xs,Ts,Xi,Ai);
% Test the Network
outputs = net(Xs,Xi);
plot([zeros(1,N),cell2mat(outputs)],'k')
legend('Cotizacion','SMA','EMA','Neural')
Error=norm(cell2mat(outputs)-SecMat(N+1:end))


% View the Network
view(net)

