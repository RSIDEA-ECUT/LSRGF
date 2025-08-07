function warp = analyseDD(imf,immul)
df=double(imf);
dmul=double(immul);
[mf,nf]=size(imf);
q1 = 0
rmul=imresize(dmul,[mf nf],'bicubic');%resample
for i=1:1:mf
for j=1:1:nf
q1=q1+abs(df(i,j)-rmul(i,j));
end
end
warp=q1/(mf*nf);%--ÇóÅ¤Çú³Ì¶È(warping degree )