%% Inicializacion de la base de datos.

 codigo_barco = cell(1,20);
 max_y_frec = cell(1,20);
 N_grabaciones = zeros(1,20);
 frec_principales = cell(1,20);
 info_barcos = {codigo_barco; max_y_frec; N_grabaciones; frec_principales};
 
cambiar = cellfun('isempty',info_barcos{1,1});
info_barcos{1,1}(cambiar) = {'0'};
           
save('info_barcos')