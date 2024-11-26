function [Result_CSnm] = LS_SHA(Anm,Bnm,data,nlat,nmax)
nmax1=nmax+1;
Cnm=zeros(nmax1,nmax1);
Snm=zeros(nmax1,nmax1);
latmax=max(data(:,2));
latmin=min(data(:,2));
latinterval=(latmax-latmin)/(nlat-1);
 Lat = latmin:latinterval:latmax;
if latmin<0
  Lat = Lat+90;
end
L   = nlat;
theta = Lat' * pi/180;
 for m = 0:L
        p  = plm(m:L, m, theta);
        ai = Anm(:, m+1);
        bi = Bnm(:, m+1);
        Cnm(m+1:L+1, m+1) = p \ ai;
        Snm(m+1:L+1, m+1) = p \ bi;  
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

