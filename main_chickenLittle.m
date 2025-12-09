%Gallinero

clear; close all; clc;


%'borrador'
%          -- > Cuentas iniciales, sobre todo de geometria para altura de techo

%'Estructura3D - V01'
%          -- > Ploteos de comparaciones 3D - V01

caso = 'Estructura3D - V01'; %'borrador', 'Estructura3D - V01'

switch caso
  case 'borrador'

%           BciloTotal
%          -------------
%         |             |
%         |             |    L
%         |             |
%         |             |    c
%         |             |    i
%         |             |    l
%         |             |    o
%         |             |
%         |             |
%         |             |
%         |             |
%          -------------

aproximacionPizarron = 0;
if aproximacionPizarron == 1
    %Materia Prima
    bCilo = 4; %[m]
    LCilo = 7;    %[m]

    %Usuario
    nCilosEnParalelo = 2;
    BciloTotal = 7;

    %Outputs Geometricos
    BciloHorizontal = BciloTotal/2;
    thetaTecho = acosd(BciloHorizontal/bCilo)
endif %cierro -->  aproximacionPizarron == 1;

%Pruebas de geometria
Area1 = 7.8 * 3;    %[m2]
hSilo = 0.75; % [m] - Altura vertical del techo
hipSilo = 3;
theta = asind(hSilo/hipSilo);

%Condiciones de carga
    %Presiones Segun la velocidad del viento en [m/s]
    p8 = 39; %[N/m2]
    p12 = 88; %[N/m2]
    p15 = 138; %[N/m2]
    p20 = 245; %[N/m2]
    %Fuerzas segun un area particular [m/s]
    F = @(p,A) p*A;

    F8 = F(p8,Area1);   %[N]
    FH8 = sind(theta)*F8;%[N]
    FV8 = cosd(theta)*F8;%[N]

    F12 = F(p12,Area1); %[N]
    FH12 = sind(theta)*F12;%[N]
    FV12 = cosd(theta)*F12;%[N]

    F15 = F(p15,Area1); %[N]
    FH15 = sind(theta)*F15;%[N]
    FV15 = cosd(theta)*F15;%[N]

    F20 = F(p20,Area1); %[N]
    FH20 = sind(theta)*F20;%[N]
    FV20 = cosd(theta)*F20;%[N]


case 'Estructura3D - V01'
%Siempre sera presentada la informacion en el siguiente orden
%20x20x1.5
%40x40x1.5
%50x50x1.25



%nElementosCriticos;

%Tension maxima recuperada en Nx
sigmaMax = [213 51 40]; % [MPa]
flechasMax = []; %[mm]

coordenadasGlobales = [ 0 0 0
                        0 1800 0
                        1452 2175 0
                        2900 1800 0
                        2900 2550 0
                        4348 2175 0
                        5900 1800 0
                        5900 0 0
                        0 0 2000
                        0 1800 2000
                        1452 2175 2000
                        2900 1800 2000
                        2900 2550 2000
                        4348 2175 2000
                        5900 1800 2000
                        5900 0 2000
                        0 0 4000
                        0 1800 4000
                        1452 2175 4000
                        2900 1800 4000
                        2900 2550 4000
                        4348 2175 4000
                        5900 1800 4000
                        5900 0 4000
                        0 0 6000
                        0 1800 6000
                        1452 2175 6000
                        2900 1800 6000
                        2900 2550 6000
                        4348 2175 6000
                        5900 1800 6000
                        5900 0 6000
                        0 0 8000
                        0 1800 8000
                        1452 2175 8000
                        2900 1800 8000
                        2900 2550 8000
                        4348 2175 8000
                        5900 1800 8000
                        5900 0 8000   ];

elementosGlobales = [1  2       %1-Comienza Portico 1
                     2  3       %2-
                     2  4       %3-
                     3  5       %4-
                     4  5       %5-
                     5  6       %6-
                     4  7       %7-
                     6  7       %8-
                     7  8       %9-
                     3  4       %10-
                     4  6       %11-
                     9  10      %12-Comienza Portico 2
                    10   11
                    10   12
                    11   13
                    12   13
                    13   14
                    12   15
                    14   15
                    15   16
                    11   12
                    12   14
                    17   18    %12-Comienza Portico 3
                    18   19
                    18   20
                    19   21
                    20   21
                    21   22
                    20   23
                    22   23
                    23   24
                    19   20
                    20   22  %12-Comienza Portico 4
                    25   26
                    26   27
                    26   28
                    27   29
                    28   29
                    29   30
                    28   31
                    30   31
                    31   32
                    27   28
                    28   30
                    33   34   %12-Comienza Portico 4
                    34   35
                    34   36
                    35   37
                    36   37
                    37   38
                    36   39
                    38   39
                    39   40
                    35   36
                    36   38
                    1  9 %1-Comienzan elementos de conexion
                    2 10
                    5 13
                    7 15
                    8 16
                    1 10
                    8 15
                    9 17     %2-Comienzan elementos de conexion
                    10 18
                    13 21
                    15 23
                    16 24
                    10 17
                    15 24
                    17 25  %3-Comienzan elementos de conexion
                    18 26
                    21 29
                    23 31
                    24 32
                    24 31
                    17 26
                    26 33
                    31 40
                    25 33
                    26 34
                    29 37
                    31 39
                    32 40];



dibujaEstructura(coordenadasGlobales, elementosGlobales);
figure(1)
hold on; grid on;


ladoPerfilRectangular_1 = 20/1000;
tPerfilRectangular_1 = 1.5/1000;

ladoPerfilRectangular_2 = 40/1000;
tPerfilRectangular_2 = 1.5/1000;

ladoPerfilRectangular_3 = 50/1000;
tPerfilRectangular_3 = 1.25/1000;

rhoAcero = 7800;

[L1,pesoTotal_1] = volumenEstructura(coordenadasGlobales, elementosGlobales,...
                      ladoPerfilRectangular_1, tPerfilRectangular_1,...
                      rhoAcero)

[L2,pesoTotal_2] = volumenEstructura(coordenadasGlobales, elementosGlobales,...
                      ladoPerfilRectangular_2, tPerfilRectangular_2,...
                      rhoAcero)

[L3,pesoTotal_3] = volumenEstructura(coordenadasGlobales, elementosGlobales,...
                      ladoPerfilRectangular_3, tPerfilRectangular_3,...
                      rhoAcero)

exportaVTKHex50mm('estructura_hex', coordenadasGlobales, elementosGlobales, 50);

LlargueroPuerta = 6;
Lpuerta = 2*1.5;
Ltrailer = (6000 + 2*3100 + 3100 + 3200 + 1000 + 100 + 100) / 1000;
Lcinta = (3 * (2*1000 + 1000) + 2 * 6000 ) / 1000;
Lporticos = ((2 * 2000 + 3 * 2000 + 2*2700 ) + (2*1800 + 6000 + 2*3100 + 2*1500 + 750) )/ 1000
Lfinal = L3 + LlargueroPuerta + Lpuerta + Ltrailer + Lcinta


endswitch %cierro --> switch caso
