function [SMASecuencia]=SMA(Secuencia,NHorizonte,SMA0)
SMASecuencia=zeros(1,length(Secuencia));
Seq=[SMA0;Secuencia];
for k=1:length(Secuencia)
    SMASecuencia(k)=sum(Seq(k:k+NHorizonte-1))/NHorizonte;
end
end