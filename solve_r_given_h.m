% Resolver r dado h y un L objetivo (ej: 6000 mm)
function r = solve_r_given_h(h, L)
  assert(L > 2*h, 'No hay solucion si L <= 2*h (el arco colapsa)');
  f = @(rr) c_length(h, rr) - L;

  % Bracketing: r crece monotonamente => existe 'unico cero en (h, +inf)
  r_lo = max(h*(1+1e-9), h + 1e-6);
  r_hi = max(L/pi, r_lo*1.5);
  % expandir r_hi hasta cambiar de signo
  max_iter = 50;
  iter = 0;
  while f(r_hi) < 0  && iter < max_iter
    r_hi = r_hi * 1.5;
    iter = iter + 1;
  endwhile
  r = fzero(f, [r_lo, r_hi]);
end
