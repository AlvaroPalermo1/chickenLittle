function exportaVTKHex50mm(nombreArchivo, nodos, elementos, lado)
  % Exporta un archivo .vtk donde cada elemento se representa como un hexaedro alargado
  % entre sus nodos extremos, con secci'on transversal cuadrada de lado 'lado' (en mm).
  % nodos     : matriz n x 3 con coordenadas en mm
  % elementos : matriz m x 2 con 'indices de nodos (1-based)
  % lado      : lado del perfil cuadrado (mm)
  % nombreArchivo : string sin extensi'on

  L = lado / 2;  % semi-lado para la secci'on cuadrada
  puntos = [];
  celdas = [];

  for i = 1:size(elementos, 1)
    idx1 = elementos(i,1);
    idx2 = elementos(i,2);

    p1 = nodos(idx1, :);
    p2 = nodos(idx2, :);

    v = p2 - p1;
    Lvec = norm(v);
    if Lvec == 0
      continue;
    end

    x = v / Lvec;  % eje longitudinal

    % construir marco ortonormal local (x, y, z)
    up = [0 0 1];
    if abs(dot(x, up)) > 0.99
      up = [0 1 0];
    end
    y = cross(up, x); y = y / norm(y);
    z = cross(x, y); z = z / norm(z);
    R = [y; z];  % base transversal (2x3)

    % secci'on cuadrada centrada en p1 y p2 (caras opuestas)
    seccion = [
      -L -L;
      -L  L;
       L  L;
       L -L
    ];  % 4 puntos en la secci'on (YZ)

    verts = zeros(8,3);
    for j = 1:4
      offset = seccion(j,1)*y + seccion(j,2)*z;
      verts(j,:) = p1 + offset;
      verts(j+4,:) = p2 + offset;
    end

    base = size(puntos,1);
    puntos = [puntos; verts];

    % orden VTK_HEXAHEDRON
    celdas = [celdas;
      base + [1 2 3 4 5 6 7 8]];
  end

  % ==== Escritura del archivo VTK ====
  fid = fopen([nombreArchivo, '.vtk'], 'w');
  fprintf(fid, '# vtk DataFile Version 2.0\n');
  fprintf(fid, 'Estructura como hexaedros extruidos\n');
  fprintf(fid, 'ASCII\n');
  fprintf(fid, 'DATASET UNSTRUCTURED_GRID\n');

  fprintf(fid, 'POINTS %d float\n', size(puntos,1));
  fprintf(fid, '%f %f %f\n', puntos');

  fprintf(fid, 'CELLS %d %d\n', size(celdas,1), size(celdas,1)*9);
  for i = 1:size(celdas,1)
    fprintf(fid, '8 %d %d %d %d %d %d %d %d\n', celdas(i,:) - 1);
  end

  fprintf(fid, 'CELL_TYPES %d\n', size(celdas,1));
  fprintf(fid, '%d\n', repmat(12, size(celdas,1), 1));  % 12 = VTK_HEXAHEDRON

  fclose(fid);
  printf("Archivo '%s.vtk' generado con %d hexaedros perfectamente alineados.\n", nombreArchivo, size(celdas,1));
end

