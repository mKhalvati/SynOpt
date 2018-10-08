clc
clear all;
format long g;
%format short 
DS    = 0.001;


% This function extract data from a text-based input; 
% The format of input file are presented in the comment of this function
% The function generats Elem matric which contains element's data
% ElementLine which contains sequence of elements
% Epart particles energy in Gev

input_file_add = 'lat_ISSP_SOR_TOKYO.txt';
  
[Elem, ElementLine, Epart, NS] = extract_data(input_file_add );
% Generate input for OPA, it can be converted to MAD and elegant using OPA
[opa_input] = Generate_opa_script(Elem,ElementLine,Epart)   ;
sprintf(opa_input)

% This function do beam optics and return Machine_funcs (alfa_x beta_x 
% alfa_z, beta_z)' and the lattic length 
[Machine_funcs emit_inp celLen] = Beam_optic_calc(Elem,ElementLine,DS,NS,Epart);

% calculate_ring_parameters
param       = Calc_ring_param(Epart,celLen,emit_inp,NS);
tune        = calculate_tunes(Machine_funcs, NS);

emit        = param(1);%in nm-rad
CompFact    = param(2);%momentum compaction factor

display(sprintf('emit(nm-rad) \t MomComFact \t tune(x) \t tune(z)'))
display(sprintf([num2str(emit), ' \t\t ', num2str(CompFact) ,' \t\t ', num2str(tune(1)) ,' \t ', num2str(tune(2)) ]))

[IsPlotted] = plotMachineFunctions(Elem,ElementLine,DS,Machine_funcs);



