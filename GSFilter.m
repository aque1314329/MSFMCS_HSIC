function [GSresult, GSmap] = GSFilter(Cmap, no_class)
% gaussian filtering
% Inputs
%     Cmap - classification result
%     no_class - class number
% Outputs
%     GSmap - gaussian filtering result
%     GSresult - classification result after GS with MAP
%  
[x,y] = size(Cmap);
IM = zeros(x*y,no_class);
map = reshape(Cmap,x*y,1);
  for i = 1:no_class 
   IM(map==i,i) = i;
   w = fspecial('gaussian',[5,5],1);
   GSmap(:,:,i) = imfilter(reshape(IM(:,i),x,y),w,'replicate');
  end
   [unused,GSresult] = max(GSmap,[],3);
end
