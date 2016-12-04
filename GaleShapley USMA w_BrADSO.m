clc
clear N B outcome M losers i j k l p s t x y z Q MM;
% Must provide, P(preference matrix), positions(allocation per branch), and
% flight(flight qual) and BrADSO (if want serial dictatorship set BrADSO to
% zeros)
N=size(P,1);
B=P; % Dynamic preference matrix
M=ones(3000,size(positions,2))*10000;

positions=positions(1,1:16);


for i=1:N
       M(i,B(i,1))=i;
       B(i,1)=10000;
       i=i+1;
end



 k=1;
 while k<N
    % Filter aviation branch, kick out cadets who are not flight qual but
    % applied anyways
    M(:,5)=sort(M(:,5));
    for i=1:300
        if M(i,5)<1
            
        if flight(round(10000*M(i,5)),1)==1
            i=i+1;
            else
                M(i,5)=10000;
                i=i+1;
        end
        elseif M(i,5)==10000
            i=i+1;
        
        else 
            if flight(M(i,5),1)==1
            i=i+1;
            else
                M(i,5)=10000;
                i=i+1;
        end
        
        end
    end
    M(:,5)=sort(M(:,5));
    i=1;
    j=1;
   % Sort and cut by BrADSO, highest bid...
        while j<=16
            x=1;
            while x<=200;
            M(:,j)=sort(M(:,j));
           i=positions(j)+1;
            for i=positions(j)+1:3000
                if M(i,j)==10000
                    i=i+1;
                elseif M(i,j)<1
                    M(i,j)=10000;
                    i=i+1;
                elseif M(i,j)>=1 && sum(bradso(M(i,j),:)==j)==1
                    M(i,j)=M(i,j)/10000;
                    i=i+1;
                else
                    M(i,j)=10000;
                    i=i+1;
                end
            end
            
            x=x+1;
            
            end
         j=j+1;
        end       
                    
                MM=M;
              % Temp matrix to sort losers but preserve M match.     
    for j=1:16
                for i=1:positions(j)
                    if MM(i,j)<1
                        MM(i,j)=round(10000*M(i,j));
                        i=i+1;
                    else
                        i=i+1;
                    end
                end
                j=j+1;
            end  
 
            
          
            
            
            
            losers =10000*ones(N,1);
% Populate the losers matrix
        for i=1:N
                if sum(MM(:,:)==i)==0
                    losers(i,1)=i;
                    i=i+1;
                else
                    
                    i=i+1;
                end
        end

% Sort losers matrix
            losers(:,1)=sort(losers(:,1));
                 t=sum(losers(:,1)~=10000);
                 x=1;
            
                 % End matching if no losers
                 if sum(losers(:,1)~=10000)==0
                k=N+1;
                else
            %Losers try again,apply to next most preferred branch
                 while  x<=t;
                     j=1;
                     l=losers(x,1);
                     while j<=size(positions,2)
                     if B(l,j)==10000
                         j=j+1;
                     else
                     M(l+1000,B(l,j))=l;
                     B(l,j)=10000;
                     j=10000;
                     end
                     end
                     x=x+1;
                 end
                 k=k+1;
                 
            
                 end
  end
  
                 

            
            
                
 % MATCHING COMPLETE                
             
           match=M;         
            
            
       % Reset cadets <1 to normal number
            for j=1:16
                for i=1:positions(j)
                    if M(i,j)<1
                        M(i,j)=round(10000*M(i,j));
                        i=i+1;
                    else
                        i=i+1;
                    end
                end
                j=j+1;
            end  




 




% Create outcome matrix, ordered by cadet ranking, first column 1:N,
outcome=zeros(N,3);
z=1;
for z=1:N;
    outcome(z,1)=z;
    z=z+1;
end

% Second column are cadet outcomes
        
for j=1:16;
    for i=1:positions(j)
        
        if M(i,j)<1
            M(i,j)=round(10000*M(i,j));
        outcome(M(i,j),2)=j;
        i=i+1;
        else
            outcome(M(i,j),2)=j;
            i=i+1;
        end
    end
    j=j+1;
end

%Third outcome are cadet #preference

for t=1:N;
    for s=1:size(positions,2);
        if outcome(t,2)==P(t,s)
            outcome(t,3)=s;
        else
            s=s+1;
        end
    end
end

outcome=outcome(1:N,1:3);



 for j=1:16
     positions(2,j)=sum(outcome(:,2)==j);
     j=j+1;
 end
 
M=M(1:201,1:16);
match=match(1:201,1:16);

for j=1:16
    for i=1:positions(1)
         if M(i,j)==10000
            M(i,j)=0;
            match(i,j)=0;
            i=i+1;
         else
             i=i+1;
         end
    end
    j=j+1;
end
