%WATERMARKING IN MULTITONE BLOCK TRUNCATION CODING IMAGES
%Multitone BTC: 4-Tones, Watermark: 4-Tone Image
%imh: host image; iw: watermark image, bs: block size


function [iwr,YW1]=MTBTC_4T_WM4T_new(imh,iw,bs)


%Read host and watermark image
[s1,s2]=size(imh);
w1=s1/bs; w2=s2/bs;  
iw=imresize(iw,[w1 w2]);
iw=WM4T(iw);
iwr=iw;
r1=randperm(w1*w2);
r1=vec2mat(r1,w1);
rr=1;

figure,imshow(iw);
%Random distribution of image

for i=1:1:w1
    for j=1:1:w2
        [p1,p2]=find(r1==rr);
        iw(i,j)=iwr(p1,p2);
        rr=rr+1;
    end
end

figure,imshow(iw);


%Dither Array  Selection

[DAn0,DAn1,DAn2,DAn3,DAm0,DAm1,DAm2,DAm3,DAp0,DAp1,DAp2,DAp3]=newDA();
DA=DAn0;DAc=DAn1;DAt=DAm0;DAct=DAm1;  %Four different configuratino of dither array are picked 
                                      %Two from each filer

T=3;

%Watermark Embedding 

blc=zeros(bs,bs);
x1=1;y1=1;

for i=1:bs:s1
    for j=1:bs:s2             
        bl=imh(i:i+(bs-1),j:j+(bs-1));
        mx=double(max(bl(:)));
        mn=double(min(bl(:)));       
        k=double(mx-mn);              
        for p=1:T
        DAbl(:,:,p)=k.*DA(:,:,p)+mn;
        DAblc(:,:,p)=k.*DAc(:,:,p)+mn;
        DAblt(:,:,p)=k.*DAt(:,:,p)+mn;
        DAbltc(:,:,p)=k.*DAct(:,:,p)+mn;        
        end                
       for nT=1:1:T     
       MT=(bl>=DAbl(:,:,nT));
       MTc=(bl>=DAblc(:,:,nT));
       MTt=(bl>=DAblt(:,:,nT));
       MTtc=(bl>=DAbltc(:,:,nT));
       M(:,:,nT)=MT;
       Mc(:,:,nT)=MTc;  
       Mt(:,:,nT)=MTt;  
       Mtc(:,:,nT)=MTtc;  
       end
        
       for x=1:1:bs
           for y=1:1:bs
              
              if(iw(x1,y1)==1) 
              if(M(x,y,1)==1 )
                  blc(x,y)=mx;
              elseif(M(x,y,2)==1)
                  blc(x,y)=mx-0.33*k;                    
              elseif(M(x,y,3)==1 )
                  blc(x,y)=mx-0.66*k;                      
              else
                  blc(x,y)=mn;
              end
              
              
              elseif(iw(x1,y1)==0.6) 
              if(Mt(x,y,1)==1 )
                  blc(x,y)=mx;
              elseif(Mt(x,y,2)==1)
                  blc(x,y)=mx-0.66*k;                    
              elseif(Mt(x,y,3)==1 )
                  blc(x,y)=mx-0.33*k;                  
              else
                  blc(x,y)=mn;
              end
              
              elseif(iw(x1,y1)==0.3)
              if(Mtc(x,y,1)==1)
                  blc(x,y)=mx;
              elseif(Mtc(x,y,2)==1)
                  blc(x,y)= mx-0.33*k;                 
              elseif(Mtc(x,y,3)==1 )
                  blc(x,y)=mx-0.66*k;             
              else
                  blc(x,y)=mn;   
              end
              
              else
              if(Mc(x,y,1)==1)
                  blc(x,y)=mx;
              elseif(Mc(x,y,2)==1)
                  blc(x,y)=mx-0.66*k;                    
              elseif(Mc(x,y,3)==1 )
                  blc(x,y)=mx-0.33*k;                    
              else
                  blc(x,y)=mn;
              end
              end                   
              
           end
              end
       
      
 Y(i:i+(bs-1),j:j+(bs-1))=blc;
         y1=y1+1; 

    end
    
     y1=1;
     x1=x1+1;
end
 
figure,imshow(Y,[]);

% Watermark Extraction

x1=1;y1=1;
 imw=Y;    %Watermarked Image
 x1=1;y1=1;
 for i=1:bs:s1
     for j=1:bs:s2         
         bl=imw(i:(i+(bs-1)),j:(j+(bs-1)));            
          mx=double(max(bl(:)));
        mn=double(min(bl(:)));
        k=double(mx-mn);       
        mnn=ones(bs,bs).*mean(bl(:));       
       
        for p=1:T
        DAbl(:,:,p)=k.*DA(:,:,p)+mn;
        DAblc(:,:,p)=k.*DAc(:,:,p)+mn;
        DAblt(:,:,p)=k.*DAt(:,:,p)+mn;
        DAbltc(:,:,p)=k.*DAct(:,:,p)+mn;
        end
                
       for nT=1:1:T     
        MT=(mnn>=DAbl(:,:,nT));
        M(:,:,nT)=MT;
        MTc=(mnn>=DAblc(:,:,nT));
        Mc(:,:,nT)=MTc;
        MTt=(mnn>=DAblt(:,:,nT));
        Mt(:,:,nT)=MTt;
        MTtc=(mnn>=DAbltc(:,:,nT));
        Mtc(:,:,nT)=MTtc;  
        end
        
        for x=1:1:bs
           for y=1:1:bs        
        if(M(x,y,1)==1 )
                  blc(x,y)=mx;
              elseif(M(x,y,2)==1)
                  blc(x,y)=mx-0.33*k;                    
              elseif(M(x,y,3)==1 )
                  blc(x,y)=mx-0.66*k;                         
              else
                  blc(x,y)=mn;
        end
           end
        end        
              
        ia=blc;
        
          for x=1:1:bs
           for y=1:1:bs    
        
        if(Mc(x,y,1)==1 )
                  blc(x,y)=mx;
              elseif(Mc(x,y,2)==1)
                  blc(x,y)=mx-0.66*k;                    
              elseif(Mc(x,y,3)==1 )
                  blc(x,y)=mx-0.33*k;
              else
                  blc(x,y)=mn;
        end
           end
          end
          
              
        iwh=blc;
        
         for x=1:1:bs
           for y=1:1:bs    
        
        if(Mtc(x,y,1)==1 )
                  blc(x,y)=mx;     
              elseif(Mtc(x,y,2)==1)
                  blc(x,y)= mx-0.33*k;              
              elseif(Mtc(x,y,3)==1 )
                  blc(x,y)=mx-0.66*k;                        
              else
                  blc(x,y)=mn;     
        end
           end
         end
          iwh2=blc;
        
          for x=1:1:bs
           for y=1:1:bs    
              if(Mt(x,y,1)==1 )
                  blc(x,y)=mx;
              elseif(Mt(x,y,2)==1)
                  blc(x,y)=mx-0.66*k;                    
              elseif(Mt(x,y,3)==1 )
                  blc(x,y)=mx-0.33*k;                           
              else
                  blc(x,y)=mn;
        end
           end
          end
          
          
          iwh1=blc;     

          
        C1= nnz(bl==ia);
        C2= nnz(bl==iwh);
        C3= nnz(bl==iwh1);
        C4= nnz(bl==iwh2);
       
        CD=[ C1; C2;C3; C4;];
      
      [m1 m2]= max(CD);
      
      if(m2==1)
          YW(x1,y1)=1;
      elseif(m2==2)
          YW(x1,y1)=0;
      elseif(m2==3)
          YW(x1,y1)=0.6;
      else 
        YW(x1,y1)=0.3;
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

figure, imshow(YW1);
ssim(iw,YW1)
imwrite(YW1,sprintf('1 (%d).JPEG',bs));


end
 
 
 
 
 
 
 
 



