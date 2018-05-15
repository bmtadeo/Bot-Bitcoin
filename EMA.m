function [EMASecuencia]=EMA(Secuencia,N,EMA0)
EMASecuencia=zeros(1,length(Secuencia));
EMASecuencia(1)=EMA0;
for k=2:length(Secuencia)
    EMASecuencia(k)=((N-1)/N)*EMASecuencia(k-1)+(Secuencia(k)/N);
end
end