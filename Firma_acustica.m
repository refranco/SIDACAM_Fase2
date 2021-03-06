function  Firma_acustica (posicion,N_Frec)
%FIRMA ACUSTICA
% ---------------------------------------------------------------
% Luis Alberto Tafur Jimenez, decano.ingenierias@usbmed.edu.co
% Luis Esteban Gomez, estebang90@gmail.com
% David Perez Zapata, b_hh@hotmail.es
%
% Funci?n encargada de extraer la firma ac?stica de la se?al promediando todos los m?ximos
% por frecuencia de todos los recorridos de cada embarcaci?n previamente almacenados en
% Database. Adem?s extrae las frecuencias principales de cada embarcaci?n
% teniendo en cuenta la menor desviaci?n est?ndar por frecuencia. En esta sesi?n se
% parametriza la firma ac?stica y se almacena en la base de datos.
%
%ENTRADAS
%posicion          Double. Valor que indica la posici?n de la embarcaci?n ingresada.[]
%N_Frec            Double. N?mero de frecuencias para determinar la firma ac?stica. []
%SALIDAS
%Promedio_maximos  Double. Promedio de m?ximos de las se?ales de la embarcaci?n. [dB]
%Promedio_frec     Double. Promedio de frecuencias de las se?ales de la embarcaci?n. [Hz]
%Frec_principal    Double. Vector con las 3 frecuencias principales de cada embarcaci?n [Hz]
%Firma             Double. Vector que almacena la firma ac?stica de la se?al. []

%Carga de algunos vectores a utilizar.
load info_barcos
Promedio_maximos = zeros(1,35);
Promedio_frec = zeros(1,35);
Frec_principal = zeros(1,3);

for Cont_Maximos = 1:N_Frec
    %Sacando los m?ximos promedios de cada ancho de banda.
    sumatoria = sum (info_barcos{2,1}{posicion}(1,Cont_Maximos,:));
    Promedio_maximos(Cont_Maximos) = sumatoria/(info_barcos{3,1}(posicion));
    info_barcos{5,1}{posicion}(1,Cont_Maximos) = Promedio_maximos(Cont_Maximos);
    
    %Sacando las frecuencias promedios de cada ancho.
    sumatoria = sum (info_barcos{2,1}{posicion}(2,Cont_Maximos,:));
    Promedio_frec(Cont_Maximos) = sumatoria/(info_barcos{3,1}(posicion));
    info_barcos{5,1}{posicion}(2,Cont_Maximos) = Promedio_frec(Cont_Maximos);
    %Calculando desviaciones est?ndar.
    info_barcos{5,1}{posicion}(3,Cont_Maximos) = std(info_barcos{2,1}{posicion}...
        (2,Cont_Maximos,1:(info_barcos{3,1}(posicion))));
end

%Extrayendo y almacenando las frecuencias principales seg?n su desviaci?n est?ndar.
Desv_estandar = info_barcos{5,1}{posicion}(3,:);
for frec_principales = 1:3
    Pos_min = find(Desv_estandar == min(Desv_estandar));
    Frec_principal(frec_principales) = info_barcos{5,1}{posicion}(2,Pos_min(1));
    Desv_estandar(Pos_min) = 100;
end
info_barcos{4,1}{posicion} = Frec_principal;
%Parametrizaci?n de la firma ac?stica.
maximo = max (Promedio_maximos);
Firma = 1./(Promedio_maximos/maximo);
info_barcos{5,1}{posicion}(4,1:N_Frec) = Firma;

save ('info_barcos','info_barcos')


