function c=analyseCC(imf,immul)
df=double(imf);
dmul=double(immul);
[mf,nf]=size(imf);
rmul=imresize(dmul,[mf nf],'bicubic');%resample
c=corr2(rmul(:),df(:));%�����ϵ������ӳ�ں�Ӱ��ͬԭ�����Ӱ���������Ƴ̶ȣ������ױ�������
