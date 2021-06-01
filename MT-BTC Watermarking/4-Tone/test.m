%Function to embed 4-Tone watermark in 4-Tone MTBTC image

%read the host and watermark image

imh=imread('1 (97).JPEG');
iw=imread('1 (93).JPEG');


bs=16;


[iwr,YW1]=MTBTC_4T_WM4T_new(imh,iw,bs);

