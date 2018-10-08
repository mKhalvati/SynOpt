function [IsPlotted] = plotMachineFunctions(Elem,ElemLine,DS,Machine_funcs)
        Dist        = Machine_funcs(:,1);
        beta_x      = Machine_funcs(:,2);
        beta_z      = Machine_funcs(:,5);
        Disp        = Machine_funcs(:,8);

        xDev =[0, 0, 0, 0];
        yDev =[0, 0, 0, 0];
        a       = +5;
        delta1  = .5; % the rectangle width for all kinds of magnets 
        delta2  = .05; % the rectangle width for drift sections

       figure;
       grid on;
       hold on;
       plot(Dist,beta_x,'LineWidth',2)
       hold on;
       plot(Dist, beta_z,'r','LineWidth',2)
       hold on;
       plot(Dist,Disp*10,'g','LineWidth',2)
       xlabel('Distance m');
       ylabel('Machine functions m');
       legend('\beta_x','\beta_z','10*\eta_x')
       box('on')
     % find max and min
       oldxminval = 1000;
       oldxmaxval = 0;
        for j= 1:numel(Dist)
             if(beta_x(j)<oldxminval)
                     oldxminval = beta_x(j);
             end
             if(beta_x(j)>oldxmaxval)
                     oldxmaxval = beta_x(j);
             end    
        end

        oldzminval = 1000;
        oldzmaxval = 0;
        for j= 1:numel(Dist)
             if(beta_z(j)<oldzminval)
                     oldzminval = beta_z(j);
             end
             if(beta_z(j)>oldzmaxval)
                      oldzmaxval = beta_z(j);
             end
        end
        a = min(oldxminval,oldzminval)-2;

                            
        cont = 0;
        for j= 1:numel(ElemLine)
            for k=1:Elem(ElemLine(j),2)/(DS)
                cont = cont+1;
                     %------------------------------------------------       
                     if (Elem(Elem(ElemLine(j),6),1)==1)
                               xDev =[ Dist(cont),Dist(cont),Dist(cont)+DS,Dist(cont)+DS];
                               yDev =[ a,a+delta1,a+delta1,a];
                               hold on;
                               fill(xDev,yDev,'r', 'LineStyle','none')   
                     end
                     
                     if (Elem(Elem(ElemLine(j),6),1)==2)
                               xDev =[ Dist(cont),Dist(cont),Dist(cont)+DS,Dist(cont)+DS];
                               yDev =[ a-delta2,a+delta2,a+delta2,a-delta2];
                               hold on;
                               fill(xDev,yDev,'g', 'LineStyle','none')   
                     end 
                     
                     if (Elem(Elem(ElemLine(j),6),1)==4)
                               xDev =[ Dist(cont),Dist(cont),Dist(cont)+DS,Dist(cont)+DS];
                               yDev =[ a-delta1,a+delta1,a+delta1,a-delta1];
                               hold on;
                               fill(xDev,yDev,'black', 'LineStyle','none')                        
                     end
                     if (Elem(Elem(ElemLine(j),6),1)==5)
                               xDev =[ Dist(cont),Dist(cont),Dist(cont)+DS,Dist(cont)+DS];
                               yDev =[ a,a-delta1,a-delta1,a];
                               hold on;
                               fill(xDev,yDev,'b', 'LineStyle','none');     
                     end      
            end
        end
        
        
%        xDev =[ 0,0,15*DS,15*DS];
%        yDev =[ a,a-delta1,a-delta1,a];
%        hold on;
%        fill(xDev,yDev-1.5,'b', 'LineStyle','none');           
% 
%        xDev =[ Dist(cont)/4,Dist(cont)/4,Dist(cont)/4+15*DS,Dist(cont)/4+15*DS];
%        yDev =[ a,a+delta1,a+delta1,a];
%        hold on;
%        fill(xDev,yDev-1.5,'r', 'LineStyle','none')   
% 
%        xDev =[ Dist(cont)/2,Dist(cont)/2,Dist(cont)/2+40*DS,Dist(cont)/2+40*DS];
%        yDev =[ a-delta1,a+delta1,a+delta1,a-delta1];
%        hold on;
%        fill(xDev,yDev-1.5,'black', 'LineStyle','none')                        
% 
%        xDev =[ Dist(cont)*3/4,Dist(cont)*3/4,Dist(cont)*3/4+40*DS,Dist(cont)*3/4+40*DS];
%        yDev =[ a-delta1,a+delta1,a+delta1,a-delta1];
%        hold on;
%        fill(xDev,yDev-1.5,'g', 'LineStyle','none')                        
% 
       IsPlotted = true;
                                       
      
end