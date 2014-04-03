%iris recognition program 
%for esteblising iris database 

clear all; 
close all; 
 
belta=0.35;     %cut value for pupil localization 
net_N=8;        %net number for pupil localization 
ratio=1.0;      %iris radius ratio to pupil radius 
re_size=200;    %iris picture resize,should be divide by 2*(1+ratio) 
 
%-----read iris image------- 
 
a0=imread('C:\Users\Nam Chau\Desktop\School\CSCI 448\Iris Feature Extraction\Version2\iris3.jpg','jpg'); 
%a0=imread('hongmo_1.jpg','jpg'); 
%a0=imread('liming.bmp','bmp'); 
a1p=rgb2gray(a0);                       %grayscalig the image
a1=imnoise(a1p,'gaussian',0,0.00);      %add noise to the picture 
bigest=sum(max(max(a1)));               %setting maximum value of a1 to biggest
smallest=sum(min(min(a1)));             %setting minimus value of a1 to smallest
if (bigest-smallest)==0 
    disp('The iris picture can not be processed, please capture iris picture again.'); 
end  
[arow,acol]=size(a1);
for i=1:arow   
    for j=1:acol 
        a(i,j)=(double(a1(i,j))-smallest)/(bigest-smallest); 
    end 
end 
      
%------iris localization------ 
 
%make a net 
%net_N was equal to 8
anet_row_delta=arow/net_N-rem(arow/net_N,1);
anet_col_delta=acol/net_N-rem(acol/net_N,1); 
for i=1:net_N-1 
   for j=1:net_N-1 
      anet(i,j,1)=i*anet_row_delta; 
      anet(i,j,2)=j*anet_col_delta; 
   end 
end 
 
%iris localized by net center 
arow_half=floor(arow/2+0.5); 
acol_half=floor(acol/2+0.5); 
 
c_left=acol_half; 
mark=0; 
%belta was equal to 0.35
while mark==0 
    if a(arow_half,c_left)>=belta 
        mark=1; 
    else 
        c_left=c_left-1; 
    end 
end 
c_left=c_left+1; 

c_right=acol_half; 
mark=0; 
while mark==0 
    if a(arow_half,c_right)>=belta 
        mark=1; 
    else 
        c_right=c_right+1; 
    end 
end 
c_right=c_right-1; 
 
if (c_right-c_left)>acol/20 
    useful_net_row=arow_half; 
    useful_net_col=acol_half; 
    % disp('the program is still running,please waiting...'); 
else 
    %....iris localized by net       
    %for i=1:net_N-1 
    %for j=1:net_N-1 

    i=1; 
    finder1=1;
    finder2=1; 
    %net_N is still set at 8
    while (finder1==1)&&(i<net_N) 
         j=1; 
         while (finder2==1)&&(j<net_N) 
               arow_half=anet(i,j,1);    
               acol_half=anet(i,j,2); 

               c_left=acol_half; 
               mark=0; 
               while mark==0 
                  if a(arow_half,c_left)>=belta 
                      mark=1; 
                    else 
                      c_left=c_left-1; 
                  end 
               end
               
               c_left=c_left+1;

               c_right=acol_half; 
               mark=0; 
               while mark==0 
                  if a(arow_half,c_right)>=belta 
                      mark=1; 
                    else 
                      c_right=c_right+1; 
                  end 
               end 
               c_right=c_right-1; 

              if (c_right-c_left)>acol/20 
                    %break;  
                    finder2=0; 
                    useful_net_row=anet(i,j,1);
                  useful_net_col=anet(i,j,2); 
                  c_left; 
                  c_right; 
                 %disp('the program is still running,please waiting...'); 
                  h=waitbar(0,'Please wait...'); %make a wa 
                   for i=1:100; 
                       waitbar(i/100); 
                   end 
                   close(h)          %waitbar 
                else 
                  j=j+1; 
               end 

         end 

         if finder2==0 
            finder1=0; 
         else 
            i=i+1; 
         end 

         if (i>net_N-1) 
              disp('iris is not properly put in the picture,please capture iris picture again!');  
              stop; 
         end 

    end
end
 
 
pupil_center_col=c_left; 
pupil_row_low=arow_half; 
for i=c_left:c_right 
   r0_low=arow_half; 
   mark=0; 
   while mark==0 
     if a(r0_low,i)>=belta 
         mark=1; 
     else 
         r0_low=r0_low+1; 
     end 
   end 
   if r0_low>=pupil_row_low 
      pupil_row_low=r0_low;  
      pupil_center_col=i;    %now get the pupil center colume number 
   end 
end 
pupil_row_low=pupil_row_low-1; %now get the lower pupil row number 
 
r0_up=pupil_row_low; 
mark=0; 
while mark==0 
   if a(r0_up,pupil_center_col)>=belta 
       mark=1; 
    else 
       r0_up=r0_up-1; 
   end 
end 
pupil_row_up=r0_up+1; %now get the uper pupil row number 
 
pupil_center_row=pupil_row_up; 
pupil_col_right=pupil_center_col; 
for i=pupil_row_up:pupil_row_low 
   c0_right=pupil_center_col; 
   mark=0; 
   while mark==0 
     if a(i,c0_right)>=belta 
         mark=1; 
      else 
         c0_right=c0_right+1; 
     end 
   end 
   if c0_right>=pupil_col_right 
     pupil_col_right=c0_right;  
     pupil_center_row=i; %now get the pupil center row number 
   end 
end 
pupil_col_right=pupil_col_right-1; %now get the right pupil col number 
 
 
c0_left=pupil_col_right; 
mark=0; 
while mark==0 
   if a(pupil_center_row,c0_left)>=belta 
       mark=1; 
   end 
   if mark==0 
       c0_left=c0_left-1; 
   end 
end 
pupil_col_left=c0_left+1; %now get the left pupil col number 
 
pupil_row_up; 
pupil_center_row; 
pupil_row_low; 
 
pupil_col_left; 
pupil_center_col; 
pupil_col_right; 
%disp('the program is still running,please waiting...'); 
 
%r1=pupil_center_row-pupil_row_up; 
%r2=pupil_row_low-pupil_center_row; 
%r3=pupil_center_col-pupil_col_left; 
%r4=pupil_col_right-pupil_center_col; 
d_row=pupil_row_low-pupil_row_up; 
d_col=pupil_col_right-pupil_col_left; 
r_row=floor(0.5*d_row); 
r_col=floor(0.5*d_col); 
pupil_center_rowp=pupil_row_up+r_row; 
pupil_center_colp=pupil_col_left+r_col; 
r=max([r_row+2,r_col+2]); 
dem=floor((1+ratio)*r+0.5); 
b=ones(2*dem,2*dem); 
for i=1:2*dem 
   for j=1:2*dem 
      judge=(i-dem)^2+(j-dem)^2; 
      if (judge>=r^2)&&(judge<=dem^2) 
         b(i,j)=a(pupil_center_rowp+i-dem,pupil_center_colp+j-dem); 
      else 
         b(i,j)=1; 
      end 
   end 
end 
b_max=0;b_min=1; 
for i=1:2*dem 
   for j=1:2*dem 
      judge=(i-dem)^2+(j-dem)^2; 
      if (judge>=r^2)&&(judge<=dem^2) 
         if b(i,j)>b_max 
            b_max=b(i,j); 
         end 
         if b(i,j)<b_min 
            b_min=b(i,j); 
         end 
     end 
   end 
end 
for i=1:2*dem 
   for j=1:2*dem 
      judge=(i-dem)^2+(j-dem)^2; 
      if (judge>=r^2)&&(judge<=dem^2) 
         bp(i,j)=(b(i,j)-b_min)/(b_max-b_min); 
      else 
         bp(i,j)=1; 
      end 
   end 
end 
 
%---------image showing------- 
 
%figure; 
%imshow(a); 
 
%figure; 
%imshow(b); 
 
%figure; 
%imshow(bp); 
 
%------------convert to polar coordinate--------- 
bp_resize=imresize(bp,[re_size,re_size]); 
hh=re_size/(2*(1+ratio)); 
rr=floor(r*re_size/max(size(bp))+0.5); 
for i=1:hh 
    for j=1:720 
        x=re_size/(1+ratio)+floor((rr+(i-1))*cos(-(j-1)*0.5*pi/180)+0.5); 
        y=re_size/(1+ratio)+floor((rr+(i-1))*sin(-(j-1)*0.5*pi/180)+0.5); 
        pp(i,j)=bp_resize(y,x); 
    end 
end 
 
 
%figure; 
%imshow(bp_resize); 
 
%figure; 
             %*********extract the 1-D signal of the iris image*********************** 
   
   
          %*********plot 1-D signal signature************************************** 
%imshow(pp); 
for j=1:720 
    fold(j)=pp(5,j); 
end 
%plot(fold)                   %show the 1-D extracted iris signal 
[ca1,cd1]=dwt(fold,'db1');     %wavelete decomposition 
%subplot(2,2,1);
%plot(ca1); 
[c,l]=wavedec(fold,2,'db1'); 
ca2=appcoef(c,l,'db1',2); 
%subplot(2,2,2);
%plot(ca2); 
[c1,l1]=wavedec(fold,3,'db1'); 
ca3=appcoef(c1,l1,'db1',3); 
%subplot(2,2,3);
%plot(ca3); 
[c11,l11]=wavedec(fold,4,'db1'); 
ca4=appcoef(c11,l11,'db1',4); 
%subplot(2,2,4);
%plot(ca4)                  %end of wavelete decompositioin 
 
 
%for i=1:hh 
  %  for j=1:720 
        %x=floor((r+(i-1))*cos(-(j-1)*0.5*pi/180)+0.5); 
        %y=floor((r+(i-1))*sin(-(j-1)*0.5*pi/180)+0.5); 
        
        %end 
    %end 
 
 
%figure; 
%imshow(pp(x,y)); 
 
 
%==================second picture 
 
%-----read iris image------- 
 
a0=imread('C:\Users\Nam Chau\Desktop\School\CSCI 448\Iris Feature Extraction\Version2\iris3.jpg','jpg'); 
%a0=imread('iris1_b6.bmp','bmp'); 
%a0=imread('pic002.bmp','bmp'); 
a1p=rgb2gray(a0); 
a1pp=imnoise(a1p,'gaussian',0,0.0001); %add noise to the picture 
a1=imrotate(a1pp,5,'bilinear','crop'); 
 
 
bigest=sum(max(max(a1))); 
smallest=sum(min(min(a1))); 
if (bigest-smallest)==0 
  disp('The iris picture can not be processed, please capture iris picture again.'); 
end  
[arow,acol]=size(a1); 
for i=1:arow   
   for j=1:acol 
      a(i,j)=(sum(a1(i,j))-smallest)/(bigest-smallest); 
   end 
end 
       
%------iris localization------ 
 
%.....make a net 
anet_row_delta=arow/net_N-rem(arow/net_N,1); 
anet_col_delta=acol/net_N-rem(acol/net_N,1); 
for i=1:net_N-1 
   for j=1:net_N-1 
      anet(i,j,1)=i*anet_row_delta; 
      anet(i,j,2)=j*anet_col_delta; 
   end 
end 
 
%....iris localized by net center 
  arow_half=floor(arow/2+0.5); 
  acol_half=floor(acol/2+0.5); 
 
  c_left=acol_half; 
  mark=0; 
  while mark==0 
    if a(arow_half,c_left)>=belta 
         mark=1; 
      else 
         c_left=c_left-1; 
    end 
  end 
  c_left=c_left+1; 
          
  c_right=acol_half; 
  mark=0; 
  while mark==0 
    if a(arow_half,c_right)>=belta 
         mark=1; 
      else 
         c_right=c_right+1; 
    end 
  end 
  c_right=c_right-1; 
 
if (c_right-c_left)>acol/20 
   useful_net_row=arow_half; 
   useful_net_col=acol_half; 
    %  disp('the program is still running,please waiting...'); 
 else 
%....iris localized by net       
%for i=1:net_N-1 
%for j=1:net_N-1 
i=1; 
finder1=1;
finder2=1; 
while (finder1==1)&&(i<net_N) 
 j=1; 
 while (finder2==1)&&(j<net_N) 
 
   arow_half=anet(i,j,1);    
   acol_half=anet(i,j,2); 
 
   c_left=acol_half; 
   mark=0; 
   while mark==0 
      if a(arow_half,c_left)>=belta 
          mark=1; 
        else 
          c_left=c_left-1; 
      end 
   end 
      c_left=c_left+1; 
       
   c_right=acol_half; 
   mark=0; 
   while mark==0 
      if a(arow_half,c_right)>=belta 
          mark=1; 
        else 
          c_right=c_right+1; 
      end 
   end 
   c_right=c_right-1; 
 
  if (c_right-c_left)>acol/20 
     %break;  
     finder2=0; 
      useful_net_row=anet(i,j,1); 
      useful_net_col=anet(i,j,2); 
      c_left; 
      c_right; 
      %disp('the program is still running,please waiting...'); 
    else 
      j=j+1; 
   end 
    
 end 
  
 if finder2==0 
    finder1=0; 
 else 
    i=i+1; 
 end 
  
 if (i>net_N-1) 
      disp('iris is not properly put in the picture,please capture iris picture again!');  
      stop; 
 end 
  
end    
 
end 
 
 
pupil_center_col=c_left; 
pupil_row_low=arow_half; 
for i=c_left:c_right 
   r0_low=arow_half; 
   mark=0; 
   while mark==0 
     if a(r0_low,i)>=belta 
         mark=1; 
     else 
         r0_low=r0_low+1; 
     end 
   end 
   if r0_low>=pupil_row_low 
      pupil_row_low=r0_low;  
      pupil_center_col=i;    %now get the pupil center colume number 
   end 
end 
pupil_row_low=pupil_row_low-1; %now get the lower pupil row number 
 
r0_up=pupil_row_low; 
mark=0; 
while mark==0 
   if a(r0_up,pupil_center_col)>=belta 
       mark=1; 
    else 
       r0_up=r0_up-1; 
   end 
end 
pupil_row_up=r0_up+1; %now get the uper pupil row number 
 
pupil_center_row=pupil_row_up; 
pupil_col_right=pupil_center_col; 
for i=pupil_row_up:pupil_row_low 
   c0_right=pupil_center_col; 
   mark=0; 
   while mark==0 
     if a(i,c0_right)>=belta 
         mark=1; 
      else 
         c0_right=c0_right+1; 
     end 
   end 
   if c0_right>=pupil_col_right 
     pupil_col_right=c0_right;  
     pupil_center_row=i; %now get the pupil center row number 
   end 
end 
pupil_col_right=pupil_col_right-1; %now get the right pupil col number 
 
 
c0_left=pupil_col_right; 
mark=0; 
while mark==0 
   if a(pupil_center_row,c0_left)>=belta 
       mark=1; 
   end 
   if mark==0 
       c0_left=c0_left-1; 
   end 
end 
pupil_col_left=c0_left+1; %now get the left pupil col number 
 
pupil_row_up; 
pupil_center_row; 
pupil_row_low; 
 
pupil_col_left; 
pupil_center_col; 
pupil_col_right; 
%disp('the program is still running,please waiting...'); 
 
%r1=pupil_center_row-pupil_row_up; 
%r2=pupil_row_low-pupil_center_row; 
%r3=pupil_center_col-pupil_col_left; 
%r4=pupil_col_right-pupil_center_col; 
d_row=pupil_row_low-pupil_row_up; 
d_col=pupil_col_right-pupil_col_left; 
r_row=floor(0.5*d_row); 
r_col=floor(0.5*d_col); 
pupil_center_rowp=pupil_row_up+r_row; 
pupil_center_colp=pupil_col_left+r_col; 
r=max([r_row+2,r_col+2]); 
dem=floor((1+ratio)*r+0.5); 
b=ones(2*dem,2*dem); 
for i=1:2*dem 
   for j=1:2*dem 
      judge=(i-dem)^2+(j-dem)^2; 
      if (judge>=r^2)&&(judge<=dem^2) 
         b(i,j)=a(pupil_center_rowp+i-dem,pupil_center_colp+j-dem); 
      else 
         b(i,j)=1; 
      end 
   end 
end 

b_max=0;
b_min=1; 
for i=1:2*dem 
   for j=1:2*dem 
      judge=(i-dem)^2+(j-dem)^2; 
      if (judge>=r^2)&&(judge<=dem^2) 
         if b(i,j)>b_max 
            b_max=b(i,j); 
         end 
         if b(i,j)<b_min 
            b_min=b(i,j); 
         end 
     end 
   end 
end 
for i=1:2*dem 
   for j=1:2*dem 
      judge=(i-dem)^2+(j-dem)^2; 
      if (judge>=r^2)&&(judge<=dem^2) 
         bbp(i,j)=(b(i,j)-b_min)/(b_max-b_min); 
      else 
         bbp(i,j)=1; 
      end 
   end 
end 
 
%---------image showing------- 
 
%figure; 
%imshow(a); 
 
%figure; 
%imshow(b); 
 
%figure; 
%imshow(bbp); 
 
%------------convert to polar cordinate--------- 
bbp_resize=imresize(bbp,[re_size,re_size]); 
hh=re_size/(2*(1+ratio)); 
rr=floor(r*re_size/max(size(bbp))+0.5); 
for i=1:hh 
    for j=1:720 
        x=re_size/(1+ratio)+floor((rr+(i-1))*cos(-(j-1)*0.5*pi/180)+0.5); 
        y=re_size/(1+ratio)+floor((rr+(i-1))*sin(-(j-1)*0.5*pi/180)+0.5); 
        ppp(i,j)=bbp_resize(y,x); 
    end 
end 
 
 
%figure; 
%imshow(bbp_resize); 
 
figure; 
imshow(ppp); 
 
 
%======================iris identification============== 
%phase recognition 
bfft=fft2(pp); 
bbfft=fft2(ppp); 
Suv=bfft.*conj(bbfft); 
Ejquv=Suv./abs(Suv); 
FImn=ifft2(Ejquv); 
cha=abs(FImn); 
 
 
%sum=sum(sum(cha)); 
%[sizecharow,sizechacol]=size(cha); 
%ave=sum/(sizecharow*sizechacol) 
ave=mean2(cha); 
maxval=max(max(cha)); 
ratio=maxval/ave 



%image showing

%figure 
%mesh(cha) 
%title('Phase') 



%fft2 recognition

cabie=abs(abs(bfft)-abs(bbfft)); 
%ration2=max(max(cabie))/mean2(cabie) 
ration2=max(max(cabie)); 
%ratio2=sum(sum(cabie))/(135^2) 
%figure 
%mesh(abs(bfft)); 
%title('abs(bfft)'); 
%figure 
%mesh(abs(bbfft)); 
%title('abs(bbfft)'); 
%figure 
%mesh(cabie) 