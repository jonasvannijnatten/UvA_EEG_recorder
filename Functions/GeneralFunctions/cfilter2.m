function zz = cfilter2( yy,nn )
% 2D filter of yy, convolutes with nn x nn smoother nn must be uneven
% Detailed explanation goes here
if nn==1
    zz=yy;
    return
end
if rem(nn,2)==0
   errordlg('You must filter with an uneven width, no action taken','Error','modal'); 
   zz=yy;
   return
end
B=ones(nn,nn); B=B*0.5;
mm=1+floor(nn/2);
if nn>3
  B(mm-1:mm+1,mm-1:mm+1)=0.75;
end
if nn>1
  B(mm,mm)=1;
end
summat=sum(sum(B));
B=B/summat;
zz=yy; kk=size(yy);
for ii=1:mm-1
    a=zz(:,1); b=zz(:,end); zz=[a zz b];
    c=zz(1,:); d=zz(end,:); zz=[c; zz; d];
end
zz=conv2(zz,B);
zz=zz((mm+mm-1):(mm+mm+kk(1)-2),(mm+mm-1):(mm+mm+kk(2)-2));