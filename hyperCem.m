% Constrained Energy Minimization (CEM) programmed by Bruno Xue
% inputs:
%           HIM:        Hyperspectral Image Cube (x*y*L)
%           d_target:   desired targets (L*1)
% Outputs:
%           Zcem:       CEM results with absolute value
%           R:          R matrix using in CEM
function [Zcem,R] = hyperCem(HIM,d_target)
    [x,y,z] = size(HIM);
    R = zeros(z);
    r = reshape(HIM,x*y,z);
    r = transpose(r);
    d = d_target;
    R = r*r';
    R = R/(x*y);
    w = (R\d)/(transpose(d)*(R\d));
    
    for i = 1:x*y
        Z(i) = transpose(w)*r(:,i);
    end
    Zcem = reshape(Z,x,y);
    Zcem = abs(Zcem);
    
end