function [f]=FFT_SHS(CSnm,nmax,latmax,latmin,lonmax,lonmin,dlat,dlon)

nlat = 180 / dlat;
nlon = 360 / dlon;
Lat = linspace(latmax, latmin, nlat);
Lon = linspace(lonmin, lonmax, nlon);

f = zeros(nlat, nlon);

Cnm = zeros(nmax+1, nmax+1);
Snm = zeros(nmax+1, nmax+1);


nmnumber = 0;
for i = 1:nmax + 1
    nmnumber = i + nmnumber;
end

for i = 1:nmnumber
    Cnm(CSnm(i, 1) + 1, CSnm(i, 2) + 1) = CSnm(i, 3);
    Snm(CSnm(i, 1) + 1, CSnm(i, 2) + 1) = CSnm(i, 4);
end

for i = 1:nlat
   
    rlat = 90 - Lat(i);  
    pnm = zeros(nmax+1, nmax+1);  
    
    for m = 0:nmax
        pnm(:, m + 1) = plm(0:nmax, m, deg2rad(rlat));  
    end
    
    CS = zeros(nmax + 1, 1);  
    
    for m = 0:nmax
        alpham = 0;
        beltam = 0;

        for n = m:nmax
            alpham = alpham + Cnm(n + 1, m + 1) * pnm(n + 1, m + 1);
            beltam = beltam + Snm(n + 1, m + 1) * pnm(n + 1, m + 1);
        end
        
        cm = alpham / 2;
        sm = beltam / 2;
        CS(m + 1) = complex(cm, -sm);
    end
    
    CS2 = fft(CS, nlon);  
    f(i, 1:nlon) = 2 * real(CS2(1:nlon));
end

nlon2 = nlon / 2;
if lonmin < 0
    ft = zeros(size(f));
    ft(:, 1:nlon2) = f(:, nlon2 + 1:nlon);
    ft(:, nlon2 + 1:nlon) = f(:, 1:nlon2);
    f = ft;
end
f = fliplr(f);
end