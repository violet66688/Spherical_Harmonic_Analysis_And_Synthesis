function Result_CSnm = LWS_SHA(Anm,Bnm,data,nlat,nmax)
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
si = sin(theta);
si = 2 * si / sum(si);
    for m = 0:L
        p   = plm(m:L, m, theta);
        a  = Anm(:, m+1);
        b  = Bnm(:, m+1);
        d   = 1:length(theta);
        pts = p' * sparse(d,d,si);
        % Cnm(m+1:L+1, m+1) = (pts * p) \ pts * a;
        % Snm(m+1:L+1, m+1) = (pts * p) \ pts * b;  
        Cnm(m+1:L+1, m+1) = pinv(pts * p) * pts * a;
       Snm(m+1:L+1, m+1) = pinv(pts * p) * pts * b;
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


