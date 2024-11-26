function [p] = plm(l, m, thetaRAD)
if nargin == 2
   thetaRAD = m;
   m  = 0;
end
if min(size(l)) ~= 1,  error('Degree l must be vector (or scalar)'), end
if any(rem(l,1) ~= 0), error('Vector l contains non-integers.'), end
if max(size(m)) ~= 1,  error('Order m must be scalar.'), end
if rem(m,1)     ~= 0,  error('Order m must be integer.'), end
msign = 1; if m<0; msign = (-1)^m;end; m= abs(m);
lcol = size(l,2);
trow = size(thetaRAD,1);
lmax = max(l);
if lmax < m, 
    p = zeros(length(thetaRAD), length(l));
    return
end
n = length(thetaRAD);			
t = thetaRAD(:);
x = cos(t);
y = sin(t);
lvec = l(:)';
if min(t) < -1e-14 || (max(t) - pi) > 1e-14
    warning('Is the co-latitude ''thetaRAD'' given in radian?')
end
ptmp = zeros(n, lmax - m + 2);
ptmp(:,1) = secrecur(m, y);
ptmp = lrecur(ptmp, x, m, lmax);
lind = (lvec < m);			    
pcol = lvec - m + 1;			       
pcol(lind) = (lmax - m + 2) * ones(sum(lind), 1);	
p = msign * ptmp(:, pcol);			
function out = secrecur(m, y)
if m == 0
   fac = 1;
else
   mm  = 2 * (1:m);
   fac = sqrt(2 * prod((mm + 1) ./ mm));
end
out = fac * y.^m;
function in = lrecur(in, x, m, lmax)
for l = m+1 : lmax
   col = l - m + 1; 
   root1 = sqrt((2 * l + 1) * (2 * l - 1) / ((l - m) * (l + m)));
   root2 = sqrt((2 * l + 1) * (l + m - 1) * (l - m - 1) / ((2 * l - 3) * (l - m) * (l + m)));
   if l == m + 1
       in(:, col) = root1 * x .* in(:, col - 1);
   else
       in(:, col) = root1 * x .* in(:, col - 1) - root2 * in(:, col - 2);
   end
end