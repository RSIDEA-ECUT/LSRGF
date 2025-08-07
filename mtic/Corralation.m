function y = Corralation(A,B)

A = double(A);
B = double(B);

M1 = (A - mean2(A(:)));
M2 = (B - mean2(B(:)));
M3 = M1.^2;
M4 = M2.^2;
total1 = sum(sum(M1(:).*M2(:)));
total2 = sqrt(sum(sum(M3(:)))*sum(sum(M4(:))));

y = total1/total2;