
function JG = ZONG(b,g,r,F)
PAN=imread('SAR7.tif');
B=imread('MS_B7.tif');
G=imread('MS_G7.tif');
R=imread('MS_R7.tif');
O=imread('optical7.tif');

ER=ERGAS(F,O,4);


EN_B=analysis_EN(b,256);
EN_G=analysis_EN(g,256);
EN_R=analysis_EN(r,256);

AG_B=AverageGradient(b);
AG_G=AverageGradient(g);
AG_R=AverageGradient(r);

SF_B=MySF(b);
SF_G=MySF(g);
SF_R=MySF(r);

MI_B=analysis_MI(PAN,B,b);
MI_G=analysis_MI(PAN,G,g);
MI_R=analysis_MI(PAN,R,r);

SD_B= analyseDD(b,B);
SD_G= analyseDD(g,G);
SD_R= analyseDD(r,R);

SSIM_B=analysis_ssim(PAN,B,b);
SSIM_G=analysis_ssim(PAN,G,g);
SSIM_R=analysis_ssim(PAN,R,r);

PSNR_B=mySNR(b,B);
PSNR_G=mySNR(g,G);
PSNR_R=mySNR(r,R);

psnr_B=psnr(b,B);
psnr_G=psnr(g,G);
psnr_R=psnr(r,R);

QNR_B=QNR(F,O,PAN,'none',4,32,1,1,1,1);

AA=(EN_B+EN_G+EN_R)/3;
BB=(MI_B+MI_G+MI_R)/3;
CC=(AG_B+AG_G+AG_R)/3;
DD=(SF_B+SF_G+SF_R)/3;
EE=(SD_B+SD_G+SD_R)/3;
FF=(SSIM_B+SSIM_G+SSIM_R)/3;
GG=(PSNR_B+PSNR_G+PSNR_R)/3;
HH=(psnr_B+psnr_G+psnr_R)/3;
JG=[EN_B,MI_B,AG_B,SF_B,SD_B,ER,SSIM_B,PSNR_B,QNR_B;EN_G,MI_G,AG_G,SF_G,SD_G,ER,SSIM_G,PSNR_G,QNR_B;EN_R,MI_R,AG_R,SF_R,SD_R,ER,SSIM_R,PSNR_R,QNR_B;AA,BB,CC,DD,EE,ER,FF,GG,QNR_B]
