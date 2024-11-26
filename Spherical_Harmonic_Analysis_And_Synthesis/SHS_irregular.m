function [f]=SHS_irregular(data1,cnm_snm,nmax)

mmax=nmax;

f=zeros(size(data1,1),1);
Lat=data1(:,2);
Lon=data1(:,1);
theta = Lat * pi/180;
Cnm=zeros(nmax+1,nmax+1);
Snm=zeros(nmax+1,nmax+1);


nmnumber=0;
for i=1:nmax+1
    nmnumber=i+nmnumber;
end

for i=1: nmnumber

    Cnm(cnm_snm(i,1)+1,cnm_snm(i,2)+1)=cnm_snm(i,3);
    Snm(cnm_snm(i,1)+1,cnm_snm(i,2)+1)=cnm_snm(i,4);

end



for m=0:mmax
    
    n=0:nmax;

        f=plm(n,m,pi/2-theta)*Cnm(:,m+1).*cosd(m*Lon)...
            +plm(n,m,pi/2-theta)*Snm(:,m+1).*sind(m*Lon)...
            +f;

end

end