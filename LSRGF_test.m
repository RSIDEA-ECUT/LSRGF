clear all;
close all;

path(path,'mtic')
nLevel = 4;

tic
[imagename1 imagepath1]=uigetfile('source images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
A=imread(strcat(imagepath1,imagename1)); 
[imagename2 imagepath2]=uigetfile('source images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image'); 
B=imread(strcat(imagepath2,imagename2)); 

Y1=double(A)/255;
Y2=double(B)/255;
%img2_YUV=ConvertRGBtoYUV(Y2);
%Y2_Y=img2_YUV(:,:,1);
I3 = rgb2hsv(Y2);
Y2_Y = I3(:,:,3);

[hei, wid] = size(Y1);

%% ---------- Hybrid Multi-scale Decomposition --------------
sigma1=2;%sigma1=2.0£»
%sigma = 2.0;
%sigma_r = 0.05;
k = 2;
iteration = 1 ;
M1 = cell(1, nLevel+1);
M1L = cell(1, nLevel+1);
M1{1} = Y1;
M1L{1} = Y1;
M1D = cell(1, nLevel+1);
M1E = cell(1, nLevel+1);

sigma_s=20;%BFLS=20 %BFLS_CNP=20
sigma_r=2;%BFLS=0.517 %BFLS_CNP=2
for j = 2:nLevel+1,
    w = floor(3*sigma1);
    h = fspecial('gaussian', [2*w+1, 2*w+1],2);   
    M1{j} = imfilter(M1{j-1}, h, 'symmetric'); 
    %M1L{j} = 255*bfilter2(M1L{j-1}/255,w,[sigma0, sigma_r/(k^(j-2))]);
    %M1L{j} = 255*fast_bfilter2(M1L{j-1}/255,[sigma0, sigma_r/(k^(j-2))]);
    M1L{j} = BLF_LS(M1L{j-1}, M1L{j-1},sigma_s, sigma_r);
    M1L{j}=double( M1L{j});
    M1D{j} = M1{j-1} - M1L{j};
    M1E{j} = M1L{j} - M1{j};
    
    sigma1 = k*sigma1;
end


sigma2=2 ;%sigma2=2.0;
%sigma = 2.0;
%sigma_r = 0.05;
k = 2;

M2 = cell(1, nLevel+1);
M2L = cell(1, nLevel+1);
M2{1} = Y2_Y;
M2L{1} = Y2_Y;

M2D = cell(1, nLevel+1);
M2E = cell(1, nLevel+1);
%sigma = 2.0;
%sigma_r=0.5;
for j = 2:nLevel+1,
    w = floor(3*sigma2);
    h = fspecial('gaussian', [2*w+1, 2*w+1], 2);   
    M2{j} = imfilter(M2{j-1}, h, 'symmetric');
    %M2L{j} = 255*bfilter2(M2L{j-1}/255,w,[sigma0, sigma_r/(k^(j-2))]);
    % M2L{j} = 255*fast_bfilter2(M2L{j-1}/255,[sigma0, sigma_r/(k^(j-2))]);
    M2L{j} = BLF_LS(M2L{j-1},M2L{j-1}, sigma_s, sigma_r);
    M2L{j}=double( M2L{j});
    M2D{j} = M2{j-1} - M2L{j};
    M2E{j} = M2L{j} - M2{j};
    
    sigma2 = k*sigma2;
end

%% ---------- Multi-scale Combination --------------
for j = nLevel+1:-1:3

% Base level combination
    MF =base_fuse(M1{j},M2{j});
 %Large-scale combination
D_F{j} = Low_fusion(M1E{j},M2E{j});
MF = MF + D_F{j};
D_F{j} = Low_fusion(M1D{j},M2D{j});
MF = MF + D_F{j};
end 


% Small-scale combination  

sigma0 = 2;
w = floor(3*sigma0);
h = fspecial('gaussian', [2*w+1, 2*w+1], sigma0);   
C_0 = double(abs(M1E{2}) < abs(M2E{2}));
C_0 = imfilter(C_0, h,'symmetric');
D_F = C_0.*M2E{2} + (1-C_0).*M1E{2};
MF = MF + D_F;  
C_0 = abs(M1D{2}) < abs(M2D{2});
C_0 = imfilter(C_0, h,'symmetric');
D_F = C_0.*M2D{2} + (1-C_0).*M1D{2};
MF = MF + D_F;

%imgf_YUV=zeros(hei,wid,3);
%imgf_YUV(:,:,1)=MF;
%imgf_YUV(:,:,2)=img2_YUV(:,:,2);
%imgf_YUV(:,:,3)=img2_YUV(:,:,3);
%imgf=ConvertYUVtoRGB(imgf_YUV);

I3(:,:,3)=MF ;
imgf = hsv2rgb(I3);
toc

F = uint8(imgf*255);
figure,imshow(F);
imwrite(F,'results/LSRGF_CNP.tif');
B=F(:,:,1);
G=F(:,:,2);
R=F(:,:,3);
Z=ZONG(B,G,R,F)






