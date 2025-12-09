function dibujaEstructura(nodos, elementos)
  % Dibuja una estructura en 3D con elementos como l'ineas azules y nodos como c'irculos negros
  % nodos      : matriz nNodos x 3 (coordenadas X, Y, Z)
  % elementos  : matriz nElementos x 2 ('indices de nodo inicial y final)

  figure; hold on; grid on;
  axis equal;
  xlabel('X'); ylabel('Y'); zlabel('Z');
  title('Visualizacion de estructura');

  % Dibujar los elementos (l'ineas entre nodos)
  for i = 1:size(elementos, 1)
    ni = elementos(i, 1);  % nodo inicial
    nf = elementos(i, 2);  % nodo final

    % coordenadas de los extremos del elemento
    x = [nodos(ni,1), nodos(nf,1)];
    y = [nodos(ni,2), nodos(nf,2)];
    z = [nodos(ni,3), nodos(nf,3)];

    plot3(x, y, z, 'b-');  % l'inea azul
  end

  % Dibujar los nodos
  plot3(nodos(:,1), nodos(:,2), nodos(:,3), 'MarkerSize',1, 'ok', 'MarkerFaceColor', 'k');

  hold off;
end

