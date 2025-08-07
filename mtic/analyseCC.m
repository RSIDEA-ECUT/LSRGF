function c=analyseCC(imf,immul)
df=double(imf);
dmul=double(immul);
[mf,nf]=size(imf);
rmul=imresize(dmul,[mf nf],'bicubic');%resample
c=corr2(rmul(:),df(:));%求相关系数，反映融合影像同原多光谱影像特征相似程度，即光谱保持性能
