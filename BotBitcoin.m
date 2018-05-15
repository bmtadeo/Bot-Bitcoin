clc
clear all
close all
%Llamamos al script que nos importa desde la web de Blockchain un CSV 
%actualizado del precio del Bitcoin desde sus inicios

ImportBitcoin;
title('Bitcoin')
hold on
grid on
xlabel('Dias');
ylabel('Valor [USD]');
NHorizonte=10;%Numero de Cotizaciones para la media
SecMat=Bitcoin(:,1)';
L=length(SecMat);
SecCell=mat2cell(SecMat,[1],ones(1,L));
Secuencia=SecMat';
%Media Aritmetica Simple
SMA0=Secuencia(1)*ones(12-1,1);
[SMASecuencia]=SMA(Secuencia,12,SMA0);%MediaMovilSimple
plot(Secuencia,'xr');
plot(SMASecuencia,'g');
%Media Exponencial
EMA0=Bitcoin(1,1);
[EMASecuencia]=EMA(Secuencia,26,EMA0);
plot(EMASecuencia,'b');
%RSI
rsi=[];
rsi=rsindex(Bitcoin(:,1))';
save rsi
for i=1:length(rsi)
    valor=rsi(:,i);
    if(valor<30)
        disp('Es recomendable vender, sobrecompra')
        disp(valor)
    elseif (valor>70)
        disp('Es recomendable comprar, sobreventa')
        disp(valor)
    elseif (valor>30 | valor<70)
        disp('Zona neutra, se puede comprar y vender')
        disp(valor)
    end
end
%Comenzamos con la red neuronal
targetSeries = SecCell;
inputSeries=[];
% Create a Nonlinear Autoregressive Network with External Input
N=NHorizonte;
feedbackDelays = 1:N;
Nneuronas=4;
net = narnet(feedbackDelays,Nneuronas);
[Xs,Xi,Ai,Ts] = preparets(net,{},{},targetSeries);
% Set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 88/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.trainParam.max_fail=100;
% Train the Network
net = train(net,Xs,Ts,Xi,Ai);
% Test the Network
outputs = net(Xs,Xi);
plot(cell2mat(outputs),'k');
salidaDatos= cell2mat(outputs)';
Error=norm(cell2mat(outputs)-SecMat(N+1:end))
%Bandas de Bollinger
[mid,uppr,lower]=bollinger(Bitcoin(:,1));
CloseBolling = [uppr,lower,mid];
plot(CloseBolling,'--c')
% View the Network
view(net)
legend('Cotizacion','EMA','SMA','Red Neuronal','Bandas de Bollinger')
%RSI Neuronal
rsiNeu=[];
rsiNeu=rsindex(salidaDatos(:,1))';
save rsiNeu
for i=1:length(rsiNeu)
    valorNeu=rsiNeu(:,i);
    if(valorNeu<30)
        disp('Es recomendable vender, sobrecompra. El valor RSI de la red neuronal es:')
        disp(valorNeu)
    elseif (valorNeu>70)
        disp('Es recomendable comprar, sobreventa. El valor RSI de la red neuronal es:')
        disp(valorNeu)
    elseif (valorNeu>30 | valorNeu<70)
        disp('Zona neutra, se puede comprar y vender. El valor RSI de la red neuronal es:')
        disp(valorNeu)
    end
end

