clear; close all; clc;

caso = 1; %Caso inicial
caso = 2; %19/01/2026
caso = 3; %Definicion de caso de carga de viento
caso = 4; %Caso de carga segun la teoria de flujo potencial

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

    case 3 %Carga de viento boca %25/01/2026


          %Cargas
          %[8 12 15 20] [m/s]
          Fviento_superficie = [39 88 138 245]; %[N/m2]

          %Geometria
          rx = 2132; %[mm]
          profundidad = 6000; % [mm]
          nPorticos = 9; %[-]
          nNodosEnArcoCargado = 9

          thetaI = 27.5; %[o]
          thetaF = 90;   %[o]
          deltaArcoCargado = abs(thetaF-thetaI)  %[o]

          perimetroMediaCircunferencia = pi*rx
          perimetroCurvo = deltaArcoCargado * perimetroMediaCircunferencia / 180 % [mm]
          areaDeAplicacion = (perimetroCurvo * profundidad) / (1000^2) % [m2]
          Ftotal = Fviento_superficie * areaDeAplicacion % [N]
          FPortico = Ftotal / nPorticos
          FNodal = FPortico / nNodosEnArcoCargado
          Fx = FNodal/2
          Fy = Fx

    case 4 %Carga de viento - Teoria de flujo potencial %01/02/2026

          V = [8 12 15 20];           % [m/s]  (ejemplo)
          rho = 1.225;                % [kg/m3] aire

          % Geometr'ia
          rx_mm = 2132;               % [mm] radio
          rx = rx_mm / 1000;          % [m]
          profundidad_mm = 6000;      % [mm] largo del galp'on
          L = profundidad_mm / 1000;  % [m]  "profundidad"
          nPorticos = 9;

          % Discretizaci'on del arco
          nNodos = 9;                 % User input
          nElem  = nNodos - 1;        % 7 elementos
          thetaI_deg = 27.5;          % nodo 1
          thetaF_deg = 90.0;          % nodo 8

          theta_nodes_deg = linspace(thetaI_deg, thetaF_deg, nNodos); % 1x8
          theta_nodes_rad = deg2rad(theta_nodes_deg);


          % Direcci'on del viento (signo de Fx)
          % +1 => fuerzas con +Fx hacia +X
          % -1 => fuerzas con +Fx hacia -X (viento empuja hacia la izquierda)
          signoFx = +1;


          % =========================
          % MODELO Cp(theta)
          % =========================
          % Modelo 1er orden: cilindro en flujo lateral, flujo potencial:
          % Cp(theta) = 1 - 4*sin(theta)^2
          % donde theta=0¢X es el punto de estancamiento (frente al viento).
          %
          % IMPORTANTE:
          % - Esto da Cp negativo (succi'on) para theta grandes.
          % - Si tu "primera aproximaci'on" quiere SOLO empuje (sin succi'on),
          %   pod'es clipear: Cp = max(Cp, 0);
          usar_solo_empuje = false;

          Cp_fun = @(th) (1 - 4*(sin(th)).^2);

          %Outputs
          nV = numel(V);
          Fx_all = zeros(nV, nNodos);
          Fy_all = zeros(nV, nNodos);

          for k = 1:nV
          Vk = V(k);

          % Presi'on din'amica base
          qinf = 0.5*rho*Vk^2;    % [N/m2]

          % Inicializo vectores nodales para este caso
          Fx_nodes = zeros(1, nNodos);
          Fy_nodes = zeros(1, nNodos);

            % Recorro elementos del arco
            for e = 1:nElem
                th1 = theta_nodes_rad(e);
                th2 = theta_nodes_rad(e+1);

                % 'Angulo medio y delta 'angulo
                thm = 0.5*(th1 + th2);
                dth = (th2 - th1);              % [rad] positivo

                % Longitud de arco del elemento
                ds = rx * dth;                  % [m]

                % Cp y presi'on local sobre la superficie
                Cp = Cp_fun(thm);

                if usar_solo_empuje
                    Cp = max(Cp, 0);
                end

                p = qinf * Cp;                  % [N/m2] presi'on neta (puede ser negativa)

                % Fuerza total sobre la "tira" de este elemento (para TODO el largo)
                % dF = p * (area) = p * (ds * L)
                Fe_total = p * (ds * L);        % [N] para TODA la estructura en largo L

                % Reparto entre p'orticos longitudinales
                Fe = Fe_total / nPorticos;      % [N] carga equivalente en este p'ortico

                % Direcci'on: normal radial (cos thm, sin thm)
                % Componentes de la fuerza elemental
                Fx_e = signoFx * Fe * cos(thm);
                Fy_e =          Fe * sin(thm);

                % Lump a nodos del elemento (mitad y mitad)
                Fx_nodes(e)   += 0.5 * Fx_e;
                Fx_nodes(e+1) += 0.5 * Fx_e;

                Fy_nodes(e)   += 0.5 * Fy_e;
                Fy_nodes(e+1) += 0.5 * Fy_e;
            end

    % Guardo
    Fx_all(k, :) = Fx_nodes;
    Fy_all(k, :) = Fy_nodes;


    % =========================
    % MOSTRAR RESULTADOS
    % =========================
    disp("theta_nodes_deg = ");
    disp(theta_nodes_deg);

      for k = 1:nV
          fprintf("\nV = %.1f m/s\n", V(k));
          disp("Fx_nodes [N] = "); disp(Fx_all(k,:));
          disp("Fy_nodes [N] = "); disp(Fy_all(k,:));
      end
    end
    %GraficoEnX
    figure; hold on; grid on;
    plot(theta_nodes_deg , abs(Fx_all(1,:)),'*-r')
    plot(theta_nodes_deg , abs(Fx_all(2,:)),'*-b')
    plot(theta_nodes_deg , abs(Fx_all(3,:)),'*-g')
    plot(theta_nodes_deg , abs(Fx_all(4,:)),'*-k')
    legend('8 m/s','12','15','20')
    xlabel('Angulo Portico - [deg]')
    ylabel('Fx Nodal - [N]')

    %GraficoEnY
    figure; hold on; grid on;
    xlabel('Angulo Portico - [deg]')
    ylabel('Fy Nodal - [N]')
    plot(theta_nodes_deg , abs(Fy_all(1,:)),'*-r')
    plot(theta_nodes_deg , abs(Fy_all(2,:)),'*-b')
    plot(theta_nodes_deg , abs(Fy_all(3,:)),'*-g')
    plot(theta_nodes_deg , abs(Fy_all(4,:)),'*-k')
    legend('8 m/s','12','15','20')

    %Comparo con el caso 3 de a lo boca
    Fxnodal = [ 3.3593    7.5799   11.8867   21.1031 ];
    nNodos = 9;
    Fxportico = nNodos * Fxnodal;
    figure(1);
    plot(theta_nodes_deg , ones(1,nNodos)*Fxnodal(1),':r','linewidth',2)
    plot(theta_nodes_deg , ones(1,nNodos)*Fxnodal(2),':b','linewidth',2)
    plot(theta_nodes_deg , ones(1,nNodos)*Fxnodal(3),':g','linewidth',2)
    plot(theta_nodes_deg , ones(1,nNodos)*Fxnodal(4),':k','linewidth',2)
    %FX == Fy..
    figure(2);
    plot(theta_nodes_deg , ones(1,nNodos)*Fxnodal(1),':r','linewidth',2)
    plot(theta_nodes_deg , ones(1,nNodos)*Fxnodal(2),':b','linewidth',2)
    plot(theta_nodes_deg , ones(1,nNodos)*Fxnodal(3),':g','linewidth',2)
    plot(theta_nodes_deg , ones(1,nNodos)*Fxnodal(4),':k','linewidth',2)

    disp('')
    disp('')
    disp('')
    disp('')
    disp('')

    FalvaX_portico = nNodos * Fxnodal
    FalvaY_portico = nNodos * Fxnodal

    FflujoPotencialX_portico = [ sum(abs(Fx_all(1,:))) , sum(abs(Fx_all(2,:))) , sum(abs(Fx_all(3,:))) , sum(abs(Fx_all(4,:))) ]
    FflujoPotencialY_portico = [ sum(abs(Fy_all(1,:))) , sum(abs(Fy_all(2,:))) , sum(abs(Fy_all(3,:))) , sum(abs(Fy_all(4,:))) ]

endswitch
