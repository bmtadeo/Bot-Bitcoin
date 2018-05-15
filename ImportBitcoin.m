clc
clear all
close all

urlwrite('https://api.blockchain.info/charts/market-price?timespan=all&format=csv','bitcoin.csv');
[ListadoFicheros]=dir;
[NumeroFicheros,q]=size(ListadoFicheros);
Bitcoin=[];
Fechas=[];
for k=1:NumeroFicheros
    if length(strfind(ListadoFicheros(k).name,'bitcoin'))>0
        %Lectura del fichero
        filename=ListadoFicheros(k).name;
        ImportarDatosBitcoin;
        Bitcoin=[Bitcoin,VarName2];
    end
end
save Bitcoin