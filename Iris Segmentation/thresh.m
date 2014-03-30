%function to segment out the iris from the pupil and sclera
function [ci,cp,out]=thresh(I,rmin,rmax);

%proceed by scaling down images 
scale=1;
rmin=rmin*scale;
rmax=rmax*scale;

%convert image to double
I=im2double(I);

pimage=I;
I=imresize(I,scale);

%help remove reflection. 
I=imcomplement(imfill(imcomplement(I),'holes'));
rows=size(I,1);
cols=size(I,2);
[X,Y]=find(I<0.5);
s=size(X,1);

for k=1:s 
    if (X(k)>rmin)&(Y(k)>rmin)&(X(k)<=(rows-rmin))&(Y(k)<(cols-rmin))
            A=I((X(k)-1):(X(k)+1),(Y(k)-1):(Y(k)+1));
            M=min(min(A));
           if I(X(k),Y(k))~=M
              X(k)=NaN;
              Y(k)=NaN;
           end
    end
end

v=find(isnan(X));
X(v)=[];
Y(v)=[];
index=find((X<=rmin)|(Y<=rmin)|(X>(rows-rmin))|(Y>(cols-rmin)));
X(index)=[];
Y(index)=[];  
N=size(X,1);

%defines two arrays to store the maximum value of blur the corresponding radius
maxb=zeros(rows,cols);
maxrad=zeros(rows,cols);

for j=1:N
    [b,r,blur]=partiald(I,[X(j),Y(j)],rmin,rmax,'inf',600,'iris');
    maxb(X(j),Y(j))=b;
    maxrad(X(j),Y(j))=r;
end

[x,y]=find(maxb==max(max(maxb)));

%the function search searches for the centre of the pupil and its radius by scanning a 10*10 window around the iris centre for establishing the pupil's centre and hence its radius
ci=search(I,rmin,rmax,x,y,'iris');
ci=ci/scale;
cp=search(I,round(0.1*r),round(0.8*r),ci(1)*scale,ci(2)*scale,'pupil');%Ref:Daugman's paper that sets biological limits on the relative sizes of the iris and pupil
cp=cp/scale;
out=drawcircle(pimage,[ci(1),ci(2)],ci(3),600);
out=drawcircle(out,[cp(1),cp(2)],cp(3),600);
