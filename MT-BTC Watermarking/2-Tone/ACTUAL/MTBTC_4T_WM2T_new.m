%WATERMARKING IN MULTITONE BLOCK TRUNCATION CODING IMAGES
%Multitone BTC: 4-Tones, Watermark: 2-Tone (Binary)
%imh: host image; iw: watermark image, bs: block size


function [CDR,Y]=MTBTC_4T_WM2T_new(imh,iw,bs)

% imh=uint8(imh);
%Read host and watermark image
[s1,s2]=size(imh);
w1=s1/bs; w2=s2/bs;  
iw=imresize(iw,[w1 w2]);
iwr=iw;
r1=randperm(w1*w2);
r1=vec2mat(r1,w1);
rr=1;

%Random distribution of image

for i=1:1:w1
    for j=1:1:w2
        [p1,p2]=find(r1==rr);
        iw(i,j)=iwr(p1,p2);
        rr=rr+1;
    end
end

% figure,imshow(iw);


%Dither Array  Selection

[DA,DAc]=newDA();


T=3;

%Watermark Embedding 

blc=zeros(bs,bs);
x1=1;y1=1;

for i=1:bs:s1
     for j=1:bs:s2           
        bl=imh(i:i+(bs-1),j:j+(bs-1));
        mx=double(max(bl(:)));
        mn=double(min(bl(:)));
        mnn=double(mean(bl(:)));
        k=double(mx-mn);       
       
        for p=1:T
        DAbl(:,:,p)=k.*DA(:,:,p)+mn;
        DAblc(:,:,p)=k.*DAc(:,:,p)+mn;
        end
        
       for nT=1:1:T     
        MT=(bl>=DAbl(:,:,nT));        
        M(:,:,nT)=MT;
        MTc=(bl>=DAblc(:,:,nT));        
        Mc(:,:,nT)=MTc;
       end
        
       if(iw(x1,y1)==1)
       for x=1:1:bs
           for y=1:1:bs              
              if(Mc(x,y,1)==1 )
                  blc(x,y)=mx;
              elseif(Mc(x,y,2)==1)
                  blc(x,y)=mx-(k*0.33);                    
              elseif(Mc(x,y,3)==1 )
                  blc(x,y)=mx-(k*0.66);   
              else
                  blc(x,y)=mn;   
              end
           end
       end
           
                 
       else         
           for x=1:1:bs
           for y=1:1:bs               
              if(M(x,y,1)==1 )
                  blc(x,y)=mx;
              elseif(M(x,y,2)==1)
                  blc(x,y)=mx-(k*0.66);          %Intertone shifting for whole block         
              elseif(M(x,y,3)==1 )
                  blc(x,y)=mx-(k*0.33);         
                    
              else
                  blc(x,y)=mn;
              
              end
           end
           end         
       end
         
         Y(i:(i+(bs-1)),j:(j+(bs-1)))=blc;          
           
         y1=y1+1;      
     end
     
     y1=1;
     x1=x1+1;
end
 


% Watermark Extraction

x1=1;y1=1;
imw=Y;    %Watermark Image
x1=1;y1=1;
for i=1:bs:s1
     for j=1:bs:s2         
         bl=imw(i:(i+(bs-1)),j:(j+(bs-1)));
         mx=double(max(bl(:)));
         mn=double(min(bl(:)));
         k=(mx-mn);
         mnn=ones(bs,bs).*mean(bl(:));       
         
         for p=1:3
         DAbl(:,:,p)=k.*DA(:,:,p)+mn;
         DAblc(:,:,p)=k.*DAc(:,:,p)+mn;
         end       
             
        for nT=1:1:T     
         MT=(mnn>=DAbl(:,:,nT));
         M(:,:,nT)=MT;
         MTc=(mnn>=DAblc(:,:,nT));
         Mc(:,:,nT)=MTc;
        end
        
       for x=1:1:bs
           for y=1:1:bs               
              if(Mc(x,y,1)==1)
                  blc(x,y)=mx;
              elseif(Mc(x,y,2)==1)
                  blc(x,y)=mx-(k*0.33);                    
              elseif(Mc(x,y,3)==1)
                  blc(x,y)=mx-(k*0.66); 
              else
                  blc(x,y)=mn;              
              end
           end
       end
       iwh=blc;
        for x=1:1:bs
           for y=1:1:bs               
              if(M(x,y,1)==1)
                  blc(x,y)=mx;
              elseif(M(x,y,2)==1)
                  blc(x,y)=mx-(k*0.66);              %Intertone shifting similar to encodding       
              elseif(M(x,y,3)==1)
                  blc(x,y)=mx-(k*0.33);                    
              else
                  blc(x,y)=mn;              
              end
           end
        end     
       ia=blc;              
         

       C1= nnz(bl==ia);
       C2= nnz(bl==iwh);          

          
          if (C1>= C2)
              YW(x1,y1)=0;
          else
              YW(x1,y1)=1;
          end
           
          y1=y1+1;      
     end
         
          y1=1;
     x1=x1+1;
end

figure,imshow(YW);

rr=1;
for i=1:1:w1
    for j=1:1:w2
        [p1,p2]=find(r1==rr);
        YW1(p1,p2)=YW(i,j);
        rr=rr+1;
    end
end

 
 CDR= (1/(w1*w2))*sum(sum(not(xor(YW,iw))))*100;
 
 figure,subplot(1,2,1),imshow(iwr); xlabel('Watermark Image')
 subplot(1,2,2),imshow(YW1);xlabel(['Decoded Image CDR ',num2str(CDR)])
% imwrite(YW1,sprintf('1 (%d).JPEG',bs));


end
 
 
 
 
 
 
 
 



