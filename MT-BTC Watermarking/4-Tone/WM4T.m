%Function to generate four tone watermark

function [Y]=WM4T(im)

[s1 s2]=size(im);

for i=1:1:s1
    for j=1:1:s2
        
        if(im(i,j)>191)
            Y(i,j)=1;
        elseif(im(i,j)>128)
            Y(i,j)=0.6;
        elseif(im(i,j)>63)
            Y(i,j)=0.3;
        else
            Y(i,j)=0;
        end
    end
end
end
