%declare your image and the location of the image
I=imread('C:\Users\Nam Chau\Desktop\Downloads\iris.jpg');

%setting the minimum radius value  and the maximum radius value
rmin=35;
rmax=100;

%calling function to segment iris from pupil and sclera
[ci,cp,out]=thresh(I,rmin,rmax);

%displaying result
figure;
imshow(out);