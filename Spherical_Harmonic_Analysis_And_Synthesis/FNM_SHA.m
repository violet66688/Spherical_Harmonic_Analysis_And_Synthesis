function Result_CSnm =FNM_SHA(Anm,Bnm,data,nlat,nmax)
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
theta = Lat' * pi/180;
    L=nlat;
    in=cos(theta);
    x  = in(:);
    theta1 = acos(x);  
    l  = 0:(length(x)-1);
    pp = plm(l, theta1)';  
    r  = [2;zeros(length(x)-1,1)]; 
    w  = pp \ r;  
    if (size(x) ~= size(w)), w = w'; end
    for m = 0:L
        p  = plm(m:L, m, theta);
        a = Anm(:, m+1);
        b = Bnm(:, m+1);
        Cnm(m+1:L+1, m+1) = (1 + (m==0))/4 * p' * (w.*a);
        Snm(m+1:L+1, m+1) = (1 + (m==0))/4 * p' * (w.*b);
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

