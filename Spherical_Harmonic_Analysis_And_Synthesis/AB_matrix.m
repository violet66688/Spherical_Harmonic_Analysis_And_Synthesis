function [Anm,Bnm] = AB_matrix(data,nlat,nlon)
lonmax=max(data(:,1));
lonmin=min(data(:,1));
loninterval=(lonmax-lonmin)/(nlon-1);
Lon = lonmin:loninterval:lonmax;
% if lonmin<0
%   Lon = Lon+180;  
% end
data_t=reshape(data(:,3),nlon,nlat);
data_t=data_t';
n = size(data_t,1);
nn= size(data_t,2);
L   = n;
m = 0:L;
cc = cos(Lon' * m * pi/180);
ss = sin(Lon' * m * pi/180);
cc = cc/L; 
ss = ss/L;
cc(:, 1)   = cc(:,1)/2;      
ss(:, L+1) = ss(:,L+1)/2;   
cc(:, L+1) = zeros(nn, 1);	
ss(:, 1)   = zeros(nn, 1);
Anm = data_t * cc;
Bnm = data_t * ss;
end

