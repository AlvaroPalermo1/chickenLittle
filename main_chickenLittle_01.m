clear; close all; clc;

caso = 1; %Caso inicial
caso = 2; %19/01/2026

switch caso
   case 1  %Caso inicial

          %Estructura para tubos tubulares circulares

          Lunitario = 6 %[m] Largo de perfil unitario
          rGallinero = Lunitario / pi % [m]
          dGallinero = rGallinero *2 * 1000 % [mm] - diametro del gallinero


          %Estos valores se sacan de Nx, haciendo que sea tangente
          ##r600 = 2002; %El radio para una altura vertical de 600 es de 2002 mm
          ##r900 = 2111;


          %Trigonometria
          %Con hBase = 1910 mm de radio
          ##hip = r900
          ##op = hVertical
          ##thetaPositivo = asind(op/hip)
          ##thetaPerimetro = 180 - 2*thetaPositivo %[o]
          ##perimetroMediaCircunferencia = pi*r900
          ##perimetroCurvo = thetaPerimetro * perimetroMediaCircunferencia / 180
          ##pTotal = hVertical*2 + perimetroCurvo

          disp('AntesDeLaOptimizacion')

          %Con hBase = xx mm de radio
          hVertical = 900
          rx = 1933
          hip = rx
          op = hVertical
          thetaPositivo = asind(op/hip)
          thetaPerimetro = 180 - 2*thetaPositivo %[o]
          perimetroMediaCircunferencia = pi*rx
          perimetroCurvo = thetaPerimetro * perimetroMediaCircunferencia / 180
          pTotal = hVertical*2 + perimetroCurvo


          disp('LuegoDeLaOptimizacion')

          L_obj = 6000;    % mm, barra de 6 m
          h      = 900;    % mm (tu hVertical)
          r      = solve_r_given_h(h, L_obj)

          % comprobar:
          L_chk  = c_length(h, r)

    case 2  %Caso 19/01/2026
          hVertical = 900
          rx = 1933
          hip = rx
          op = hVertical

          thetaPositivo = asind(op/hip)
          thetaPerimetro = 180 - 2*thetaPositivo %[o]
          perimetroMediaCircunferencia = pi*rx

          perimetroCurvo = thetaPerimetro * perimetroMediaCircunferencia / 180
          pTotal = hVertical*2 + perimetroCurvo



endswitch
