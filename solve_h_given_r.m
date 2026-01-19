% Resolver h dado r y L objetivo (si prefer'is fijar r)
function h = solve_h_given_r(r, L)
  % h ? [0, min(r, L/2)) y L aumenta con h -> 'unico cero
  f = @(hh) c_length(hh, r) - L;
  h_lo = 0;
  h_hi = min(r*(1-1e-9), L/2 - 1e-6);
  h = fzero(f, [h_lo, h_hi]);
end
