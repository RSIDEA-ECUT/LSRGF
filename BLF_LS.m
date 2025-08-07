
function S = BLF_LS(Img, Guide, sigma_s, sigma_r)

% The input image and the guidance image need to be normalized into [0, 1]
if max(Img(:)) > 1 || max(Guide(:)) > 1
    error('Input image should be normalized into [0, 1]')
end

if size(Img) ~= size(Guide)
    error('Input image should be of the same size as guidance image\n')
end

% image channel number
[row, col, cha] = size(Img);

% The parameter in Eq. (7)
lambda = 1024;
iteration = 4;
% Gradients 
h_Img = [diff(Img,1,2), Img(:,1,:) - Img(:,end,:)];
v_Img = [diff(Img,1,1); Img(1,:,:) - Img(end,:,:)];

h_Guide = [diff(Guide,1,2), Guide(:,1,:) - Guide(:,end,:)];
v_Guide = [diff(Guide,1,1); Guide(1,:,:) - Guide(end,:,:)];

%  Normalize the guidance gradients into [0, 1]
h_Guide = h_Guide / 2 + 0.5;
v_Guide = v_Guide / 2 + 0.5;


% Gradients of the output image
h_S = zeros(row, col, cha);
v_S = zeros(row, col, cha);

% smooth the input gradients guided by the guidance gradients


for k = 1:cha   
    g_h = h_Guide(:, :, k);
    %h_S(:, :, k) = guidedfilter(g_h ,h_Img(:, :, k),sigma_s,sigma_r^2);
    h_S(:, :, k) = RollingGuidanceFilter_Guided(h_Img(:, :, k),sigma_s,sigma_r,iteration);
    g_v = v_Guide(:, :, k);
    %v_S(:, :, k) = guidedfilter(g_v,v_Img(:, :, k),sigma_s,sigma_r^2);
    v_S(:, :, k) = RollingGuidanceFilter_Guided(v_Img(:, :, k),sigma_s,sigma_r,iteration);
end
    
S = grad_process(Img, v_S, h_S, lambda);
