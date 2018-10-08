function [tune] = calculate_tunes(Machine_funcs, NS)
    %[l, be, al, ga, bez, alz, gaz, Dif, Difp];
    l       = Machine_funcs(:,1);
    be      = Machine_funcs(:,2);
    bez     = Machine_funcs(:,5);

    for j=1:numel(l)
       beb(j)=1./be(j); 
       bezb(j)=1./bez(j);
    end
    Qx      = trapz(l,beb)/(2*pi);
    Qz      = trapz(l,bezb)/(2*pi);
    Qx      = Qx *NS;
    Qz      = Qz *NS;
    tune    = [Qx Qz];
end