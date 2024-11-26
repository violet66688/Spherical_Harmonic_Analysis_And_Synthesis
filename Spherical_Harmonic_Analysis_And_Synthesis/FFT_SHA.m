function Result_CSnm = FFT_SHA(data, nmax, dlat, dlon, nlat, nlon)

    Cnm = zeros(nmax+1, nmax+1);
    Snm = zeros(nmax+1, nmax+1);

    latmax = max(data(:,2));
    latmin = min(data(:,2));
    lonmin = min(data(:,1));
    lonmax = max(data(:,1));
    Lat = linspace(latmax, latmin, nlat);
    Lon = linspace(lonmin, lonmax, nlon);

    data_t = reshape(data(:,3), nlon, nlat)';
    nlon2 = nlon / 2;
    nlon2 = round(nlon2);
    if lonmin < 0
        data_t = [data_t(:, nlon2+1:nlon), data_t(:, 1:nlon2)];
    end
    data_t = fliplr(data_t);

    dlat = dlat * pi / 180;
    dlon = dlon * pi / 180;

for i=1:nlat
    rlat = (90 - Lat(i)) * pi / 180;
    C = zeros(1, nlon);

    for j=1:nlon
        C(j) = complex(data_t(i,j) * dlon, 0);
    end
    C2 = fft(C, nlon);
  for m = 0:nmax
        pnm_values = plm(m:nmax, m, rlat);        
        for n = m:nmax
            pnm = pnm_values(n-m+1); 
            Cnm(n+1, m+1) = Cnm(n+1, m+1) + pnm * real(C2(m+1)) * sin(rlat) * dlat / (4 * pi);
            Snm(n+1, m+1) = Snm(n+1, m+1) + pnm * imag(C2(m+1)) * sin(rlat) * dlat / (4 * pi);
        end
  end
end

nmnumber=0;

for i=1:nmax+1
    nmnumber=i+nmnumber;
end

Result_CSnm=zeros(nmnumber,4);
row=1;

for n=0:nmax
    for m=0:n
        Result_CSnm(row,1)=n;
        Result_CSnm(row,2)=m;
        Result_CSnm(row,3)=Cnm(n+1,m+1);
        Result_CSnm(row,4)=Snm(n+1,m+1);
        row=1+row;
    end
end

end

