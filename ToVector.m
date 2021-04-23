function v = ToVector(im)
% takes MxNxL picture and returns (MN)xL vector
[no_lines, no_rows, no_bands] = size(im);  
v = reshape(im, no_lines*no_rows, no_bands);
end