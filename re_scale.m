 function [value] = re_scale(map)
        maxx = max(map(:));
        minn = min(map(:));
        value = (map-minn)/(maxx-minn);
 end