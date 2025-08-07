clear;
clc;
close all;

[imagename1 imagepath1]=uigetfile('source images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
b=imread(strcat(imagepath1,imagename1)); 
[imagename1 imagepath1]=uigetfile('source images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
g=imread(strcat(imagepath1,imagename1));
[imagename1 imagepath1]=uigetfile('source images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
r=imread(strcat(imagepath1,imagename1));
PAN=imread('SAR.tif');
B=imread('MS_B.tif');
G=imread('MS_G.tif');
R=imread('MS_R.tif');

MI_B=VIFF_Public(PAN,B,b);
MI_G=VIFF_Public(PAN,G,g);
MI_R=VIFF_Public(PAN,R,r);
AA=(MI_B+MI_G+MI_R)/3;
YY=[MI_B;MI_G;MI_R;AA]
