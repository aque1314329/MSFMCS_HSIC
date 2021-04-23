function [ CEMaps, gaussMaps, gaussianmaps ] = CEM( img, target )
[no_lines,no_rows,no_bands] = size(img);  
no_classes = size(target,1);
for i = 1:no_classes
        [temp,~] = hyperCem(img,target(i,:)');
        CEMresult(:,:,i) = reshape(temp,no_lines,no_rows);
        H = fspecial('gaussian',[5 5],1);
        gaussianmaps(:,:,i) = imfilter(CEMresult(:,:,i),H,'circular');   
    end;
    
    %%%% CEM classfication result by MAP
    maskedmapsVec = reshape(CEMresult,no_lines*no_rows,no_classes);
    [~,finalVec] = max(maskedmapsVec');
    CEMaps = reshape(finalVec,no_lines,no_rows);  % ÎÞ±³¾°Í¼Ïñ
    
    %%%% CEM-gaussian classfication result by MAP
    maskedmapsVec = reshape(gaussianmaps,no_lines*no_rows,no_classes);
    [~,finalVec] = max(maskedmapsVec');
    gaussMaps = reshape(finalVec,no_lines,no_rows);  % ÎÞ±³¾°Í¼Ïñ
end

