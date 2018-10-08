function [MachineFunction emit_inp celLen] = Beam_optic_calc(Elem,ElemLine,DS,NS,Epart)
% MachineFunction     = [l be al ga bez alz gaz Dif Difp];
% emit_inp I1 to I5 integeral
% celLen: Cell length
    format long g;

    for j=1:numel(ElemLine)
       setup(j)    =  Elem(ElemLine(j),1);
       setupl(j)   =  Elem(ElemLine(j),2);
       setupQf(j)  =  Elem(ElemLine(j),3); 
       setupR(j)   =  Elem(ElemLine(j),4);
       setupAng(j) =  Elem(ElemLine(j),5);
    end  
    
    MTT = zeros(5);
    Mnew = zeros(5);

    % build lattice table (I called it History !)

    k   = 1;
    his(k,1) = 0;
    his(k,2) = 0;
    DSS = [];
    c = 0;
    for j=1:numel(setup)      
        for l=1:setupl(j)/DS
         k=k+1;   
         his(k,1)  = setup(j);
         his(k,2)  = setupQf(j);
         his(k,3)  = setupR(j);
         his(k,4)  = setupAng(j);
        end
    end
    k   = 1;


    for j= 1:numel(his(:,1))
        if(j~=1)
    %------------------------------------------------       
            if (his(j,1)==1)
               Mnew=QpoleF(his(j,2),DS);
            end

            if (his(j,1)==2)
               Mnew=Drift(DS); 
            end


            if (his(j,1)==4)
                Mnew=Dipole(his(j,3),DS,his(j,2)); 
                if (his(j-1,1)~=4)&&(his(j,4)~=0)
                    Mnew = Mnew * edge(his(j,4),his(j,3)) ; 
                elseif (his(j+1,1)~=4)&&(his(j,4)~=0)
                   Mnew = edge(his(j,4),his(j,3))*Mnew ; 
                end
            end

            if (his(j,1)==5)
               Mnew=QpoleD(his(j,2),DS); 
            end
            if (j==2)
               MTT = Mnew;
            else
               MTT =Mnew*MTT;
            end 
    %------------------------------------------------        
       end    
    end

    %'end matrices'

    
    %CHECK STABILITY  CONDITIONS FOR EXICTING OF BETA FUNCTIONS
    stx=MTT(1,2)/MTT(2,1);
    stz=MTT(3,4)/MTT(4,3);
    if((stx<0)&&(stz<0))

    %initial value of dispersion functions
    des0 = -MTT(2,5)/MTT(2,1);
    des1 = -((MTT(1,1)*MTT(2,5))/MTT(2,1))+MTT(1,5);

    %initial optical value for x direction
    bet0 = sqrt(-(MTT(1,2)*MTT(2,2))/(MTT(2,1)*MTT(1,1)));
    alf0 = 0;
    gam0 = 1/bet0;



    %initial optical value for z direction
    betz0 = abs(sqrt(-(MTT(3,4)*MTT(4,4))/(MTT(4,3)*MTT(3,3))));
    alfz0 = 0;
    gamz0 = 1/betz0;

    MB      = zeros(5);
    be      = zeros(numel(his(:,1)),1);
    Dif     = be;
    Difp    = Dif;
    al      = zeros(numel(his(:,1)),1);
    ga      = zeros(numel(his(:,1)),1);
    l       = zeros(numel(his(:,1)),1);
    Hint    = zeros(numel(his(:,1)),1);
    I1      = zeros(numel(his(:,1)),1);
    I2      = zeros(numel(his(:,1)),1);
    I3      = zeros(numel(his(:,1)),1);
    I4      = zeros(numel(his(:,1)),1);
    I5      = zeros(numel(his(:,1)),1);
    be(1,1) = bet0;
    al(1,1) = alf0;
    ga(1,1) = gam0 ;

    for j= 1:numel(his(:,1))
%        if (his(j,1)==0)
%           l(j,1)=0;
%        end    
       if (j==1)
          Dif(1)  = des0;
          Difp(1) = 0.;
       end   
        if(j~=1)
           if (his(j,1)==1)
               Mnew=QpoleF(his(j,2),DS); 
               l(j,1)=l(j-1,1)+DS;
           end
           if (his(j,1)==2)
               Mnew=Drift(DS); 
               l(j,1)=l(j-1,1)+DS;
           end   
           if (his(j,1)==4)
               Mnew=Dipole(his(j,3),DS,his(j,2));
                if (his(j-1,1)~=4)&&(his(j,4)~=0)                
                    Mnew = Mnew * edge(his(j,4),his(j,3)) ; 
                elseif (his(j+1,1)~=4)&&(his(j,4)~=0)
                   Mnew = edge(his(j,4),his(j,3))*Mnew ; 
                end
               l(j,1)=l(j-1,1)+DS;
           end
           if (his(j,1)==5)
               Mnew=QpoleD(his(j,2),DS); 
               l(j,1)=l(j-1,1)+DS;
           end

          MB     =  Mnew;
          be(j)  = ((MB(1,1)*MB(1,1))*be(j-1,1))-(2*MB(1,1)*MB(1,2)*al(j-1,1))+(MB(1,2)*MB(1,2)*ga(j-1,1));
          al(j)  = (-MB(1,1)*MB(2,1)*be(j-1,1))+(((MB(1,1)*MB(2,2))+(MB(1,2)*MB(2,1)))*al(j-1,1))-(MB(2,2)*MB(1,2)*ga(j-1,1));
          ga(j)  = ((MB(2,1)*MB(2,1))*be(j-1,1))-(2*MB(2,2)*MB(2,1)*al(j-1,1))+(MB(2,2)*MB(2,2)*ga(j-1,1));
          Dif(j) = (MB(1,1)*Dif(j-1))+(MB(1,2)*Difp(j-1))+(MB(1,5));
          Difp(j)= (MB(2,1)*Dif(j-1))+(MB(2,2)*Difp(j-1))+(MB(2,5));


           if (his(j,1)==4)
               Hint(j)  =  (ga(j)*(Dif(j)^2))+(2*al(j)*Dif(j)*Difp(j))+(be(j)*(Difp(j)^2))/(his(j,3)^3.);
               I1(j)    =  (Dif(j)/his(j,3));
               I2(j)    =  (1/(his(j,3)^2.));
               I3(j)    =  (1/(his(j,3)^3.));
               neff     =   his(j,3)*his(j,3)*his(j,2);
               I4(j)    =  (((1-(2*neff))*Dif(j))/(his(j,3)^3.));
               I5(j)    =  (Hint(j)/(his(j,3)^3.));
           else
               Hint(j)  =  0;
               I1(j)    =  0;
               I2(j)    =  0;
               I3(j)    =  0;
               I4(j)    =  0;
               I5(j)    =  0;
           end    
      end

    end
    % this variable store values for calculation of emitance, comp.
    % factor, jx, jepsi
    emit_inp = [l, I1,I2,I3,I4,I5];
    celLen    =  l(numel(his(:,1)));



    MB        = zeros(5);
    bez       = zeros(numel(his(:,1)),1);
    alz       = zeros(numel(his(:,1)),1);
    gaz       = zeros(numel(his(:,1)),1);
    lz        = zeros(numel(his(:,1)),1);
    bez(1,1)  = betz0 ;alz(1,1) =alfz0 ;gaz(1,1) =gamz0 ;


    for j= 1:numel(his(:,1))
       if (his(j,1)==0)
          lz(j,1)=0;
       end
        if(j~=1)
            if (his(j,1)==1)
                Mnew=QpoleF(his(j,2),DS); 
                lz(j,1)=lz(j-1,1)+DS;
            end
            if (his(j,1)==2)
                Mnew=Drift(DS); 
                lz(j,1)=lz(j-1,1)+DS;
            end   
            if (his(j,1)==4)
                Mnew=Dipole(his(j,3),DS,his(j,2));
                if (his(j-1,1)~=4)&&(his(j,4)~=0)
                    Mnew = Mnew * edge(his(j,4),his(j,3)) ; 
                elseif (his(j+1,1)~=4)&&(his(j,4)~=0)
                   Mnew = edge(his(j,4),his(j,3))*Mnew ; 
                end
                lz(j,1)=lz(j-1,1)+DS;
            end
            if (his(j,1)==5)
                Mnew=QpoleD(his(j,2),DS); 
                lz(j,1)=lz(j-1,1)+DS;
            end

                 MB =Mnew;
                 bez(j) =((MB(3,3)*MB(3,3))*bez(j-1,1))-(2*MB(3,3)*MB(3,4)*alz(j-1,1))+(MB(3,4)*MB(3,4)*gaz(j-1,1));
                 alz(j) =(-MB(3,3)*MB(4,3)*bez(j-1,1))+(((MB(3,3)*MB(4,4))+(MB(3,4)*MB(4,3)))*alz(j-1,1))-(MB(4,4)*MB(3,4)*gaz(j-1,1));
                 gaz(j) =((MB(4,3)*MB(4,3))*bez(j-1,1))-(2*MB(4,4)*MB(4,3)*alz(j-1,1))+(MB(4,4)*MB(4,4)*gaz(j-1,1));

        end

    end

    MachineFunction     = [l, be, al, ga, bez, alz, gaz, Dif, Difp];


 

    else
        'this data havent any stable solutions'
    
    end
end