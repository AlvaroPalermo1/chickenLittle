function L = c_length(h, r)
  assert(all(h >= 0), 'h debe ser >= 0');
  assert(all(r > 0),  'r debe ser > 0');
  assert(all(h <= r), 'Debe cumplirse h <= r (asin(h/r) definido)');
  theta = asin(h ./ r);           % rad
  phi   = pi - 2 .* theta;        % rad
  L     = 2 .* h + r .* phi;      % mm si h,r en mm
end

