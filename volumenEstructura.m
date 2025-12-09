function [Ltotal, pesoTotal] = volumenEstructura(nodos, elementos, a, t, densidad)
  % Calcula el volumen total y el peso de la estructura
  % nodos     : matriz nNodos x 3 (coordenadas)
  % elementos : matriz nElementos x 2 (nodos inicial y final)
  % a         : lado exterior del tubo (m)
  % t         : espesor del tubo (m)
  % densidad  : densidad del material (kg/m^3)
  %
  % Devuelve:
  % volTotal  : volumen total de la estructura (m^3)
  % pesoTotal : peso total de la estructura (kg)

  % 'Area transversal del tubo cuadrado (secci'on hueca)
  A = a^2 - (a - 2*t)^2;

  volTotal = 0;
  Ltotal = 0;

  for i = 1:size(elementos, 1)
    ni = elementos(i,1);
    nf = elementos(i,2);

    % coordenadas de los nodos
    p1 = nodos(ni, :);
    p2 = nodos(nf, :);

    % longitud del elemento
    L = (norm(p2 - p1))/1000; %[m]
    Ltotal = Ltotal + L;

    % volumen del elemento
    volTotal += A * L;
  end

  % peso total
  pesoTotal = volTotal * densidad;
end

