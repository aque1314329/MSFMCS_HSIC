function [ ClasMap,cmap ] = EPF(img,Map)
% edge preserving filter
% Inputs
%     img - 3D data matrix (num_row, num_col, num_dim)
%     Map - classification result
% Outputs
%     cmap - EPF result
%     ClasMap - classification result after EPF with MAP

[r,c] = size(Map);
bands = size(img,2);
img = reshape(img,[r,c,bands]);
   
GDimg = GDConA(img);
[ClasMap,cmap] = CostF(Map, GDimg);

function [GDimg] = GDConA(img)
[r,c,b] = size(img);
x = reshape(img,[r*c b]);
x = compute_mapping(x,'PCA',1);
x = mat2gray(x);
x = reshape(x,[r,c,1]);
GDimg = x;
end

function [ClassMap,c] = CostF(Map, GDimg)
L = max(Map(:));
for i = 1:L
    p = zeros(size(Map));
    p(Map==i) = 1;
    c(:,:,i) = guidedfilter(GDimg,p,3,0.1^3);     
end
[unused,ClassMap] = max(c,[],3);
end

end