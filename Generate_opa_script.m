function [opa_input] = Generate_opa_script(Elem,ElemLine,Epart)    
    resOPA = '';
    c1 = 1;
    j1 =1;
    for j2 =1:numel(ElemLine)
    str  = ' '; 
    jl=ElemLine(j2);
      if(Elem(jl,1)==2)
          str = strcat('D',num2str(ElemLine(j2))) ;
          str = strcat(str,' : Drift, L = ') ;
          str = strcat(str,num2str(Elem(jl,2), '%11.14g' )) ;
          str = strcat(str,';\n') ;
      end
      if(Elem(jl,1)==1)
          str = strcat('D',num2str(ElemLine(j2))) ;
          str = strcat(str,' : Quadrupole, L = ') ;
          str = strcat(str,num2str(Elem(jl,2), '%11.14g' )) ;
          str = strcat(str,' ,K = ') ;
          str = strcat(str,num2str(Elem(jl,3), '%11.14g' )) ;
          str = strcat(str,';\n') ;
      end  
      if(Elem(jl,1)==5)
          str = strcat('D',num2str(ElemLine(j2))) ;
          str = strcat(str,' : Quadrupole, L = ') ;
          str = strcat(str,num2str(Elem(jl,2), '%11.14g' )) ;
          str = strcat(str,' ,K = ') ;
          str = strcat(str,num2str(Elem(jl,3), '%11.14g' )) ;
          str = strcat(str,';\n') ;
      end  
      if(Elem(jl,1)==4)
          str = strcat('D',num2str(ElemLine(j2))) ;
          str = strcat(str,' : Bending, L = ') ;
          str = strcat(str,num2str(Elem(jl,2), '%11.14g' )) ;
          str = strcat(str,' , T = ') ;
          str = strcat(str,num2str((Elem(jl,2)/Elem(jl,4))*180/pi, '%11.14g' )) ;
          str = strcat(str,' ,K = -') ;
          str = strcat(str,num2str(Elem(jl,3), '%11.14g' )) ;
          str = strcat(str,' \n , T1 = 0.00, T2 = 0.00, Gap = 0.00,\n') ;
          str = strcat(str,'  , K1IN = 0.00, K1EX = 0.00, K2IN = 0.00, K2EX = 0.00;\n') ;
      end
      if(Elem(jl,1)==3)
        c1 =c1 -1;    
      end
      c1 =c1 +1;
      resOPA = strcat(resOPA,str);
    end  
    str = '';
    for k = 1:numel(ElemLine)
        str = [str, 'D' num2str(ElemLine(k)), ','];
    end
    str = str(1:end-1)
    resOPA = ['energy = ' num2str(Epart) ';\n\n' resOPA  '\n\n Line :' str ';\n\n'];
    opa_input = resOPA;
    
    
end   
