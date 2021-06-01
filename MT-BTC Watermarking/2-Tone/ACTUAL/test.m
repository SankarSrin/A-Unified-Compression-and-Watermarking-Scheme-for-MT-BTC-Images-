%MT-BTC Testing
%2-Tone Watermarking in 4-Tone MT-BTC Image


%Read host and watermark image
imh=imread('1 (98).JPEG');
iw=imread('logo7.png');

%Block size 
bs=16;
s=64;   %watermark size

[CDR,Y]=MTBTC_4T_WM2T_new(imh,iw,bs);



