function [out] = Calc_ring_param(Epart,celLen,emit_inp,NS)
    l   = emit_inp(:,1);
    I1  = emit_inp(:,2);
    I2  = emit_inp(:,3);
    %I3  = emit_inp(:,4);
    I4  = emit_inp(:,5);
    I5  = emit_inp(:,6);
    cq            = 3.84e-13;    
    % calculation of reletivistic factor
    gamsq         = (Epart*1.e9)/(0.5109925*1.e6);%for electron accelerator
    em1           = trapz(l,I5)/(trapz(l,I2)-trapz(l,I4));
    em2           = gamsq*gamsq*cq;
    % calculated ring circumference
    Circ  = NS * celLen;
    % momentum compaction factor
    compaction_factor  = (trapz(l,I1)*NS)/Circ;
    % calculated emittance
    emit  = em2*em1./1.e-9;
    % calculated jx
    jx  = 1-(trapz(l,I4)/trapz(l,I2));
    % calculated jepsi
    jepsi  = 1+(trapz(l,I4)/trapz(l,I2));

    out= [emit compaction_factor jx jepsi];
end