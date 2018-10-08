function [Elem, ElementLine, Epart, NS] = extract_data(filename)
% Particles energy needs to be entered after '-epart, ' and in Gev: example('-epart, 3') 
% Number of super cells needs to be entered after '-NS, ' : example for 4 periods('-NS, 4') 
% The element's properties must be entered as a Nx6 elements(N is the number of elements):
% type of elements should be entered after '-t, ' command, there are five
% types of elements defined in the present version
% Quadrupol focusing '-t, qf'
% Quadrupol focusing '-t, qd'
% Drift section '-t, d'
% Bending magnet '-t, b'
% The length of each elements must be entered in the same line after -t
% command using '-l ' command (in meter): example '-t qf, -l 1.2'
% The Quadruple strength for bending magnet or QF or Qd must be eneters
% after '-k ' commands. Example('-t qf, -l 1.2, -k 3')
% The bending angle of each bending magnet must be eneters
% after '-a ' commands in radian. Example('-t qf, -l 1.2, -a 1.57')
% -n is the number of each element.
% Sequence of elements in lattice comes after '-line, ' command without
% comma, as an example: '-line, 1 4 2 5 3 4 6'
% NS is number of periods

    fid = fopen(filename);
    Epart = 0;
    NS = 0;
    ElementLine = [];
    input_data = '';
    for c=1:100
        strtmp = fgets(fid);
        if (strtmp~=-1) 
                tmp = '';
            if numel(strfind(lower(strtmp),'-t'))>0
                input_data = strcat(input_data, strtmp);
                input_data = strcat(input_data, '\n'); 
            elseif numel(strfind(lower(strtmp),'-line'))>0
                tmp = strrep(strtmp,'-line',' ');
                tmp = strrep(tmp,',',' ');
                tmp = strtrim(tmp);                
                ElementLinecell = strsplit(tmp,' ');
            elseif numel(strfind(lower(strtmp),'-epart'))>0
                tmp = strrep(strtmp,'-epart',' ');
                tmp = strrep(tmp,',',' ');
                tmp = strtrim(tmp);                
                Epart = str2double(strsplit(tmp,' '));
            elseif numel(strfind(lower(strtmp),'-ns'))>0
                tmp = strrep(strtmp,'-ns',' ');
                tmp = strrep(tmp,',',' ');
                tmp = strtrim(tmp);                
                NS = str2double(strsplit(tmp,' '));                
            end
        end
    end
    fclose(fid);    
    
    
    input_data  = strrep(input_data,'\n',' ^ ');
    inputArr    = strsplit(input_data,'^');
    Elem        = zeros(numel(inputArr),6);
    count       = 1;
    for j = 1:numel(inputArr)
        isDIPOL = 0;
        ElementData    = strsplit(inputArr{j},',');  
        for k =1:numel(ElementData)
            tmp = lower(strtrim(strrep(ElementData{k},'-t','')));       
            switch (tmp)
                case 'qd'
                    Elem(count,1) = 5;
                case 'qf'
                    Elem(count,1) = 1;
                case 'd'
                    Elem(count,1) = 2;
                case 'ef'
                    Elem(count,1) = 3;                    
                case 'b'
                    Elem(count,1) = 4;
                    isDIPOL = 1;
                %case 'a'
                %    Elem(count,1) = 3;
            end
            tmp = lower(strtrim(strrep(ElementData{k},'-l','')));
            if not(isnan(str2double(tmp)))           
                Elem(count,2) = str2double(tmp);
            end
            tmp = lower(strtrim(strrep(ElementData{k},'-r','')));
            if not(isnan(str2double(tmp)))           
                Elem(count,3) = str2double(tmp);
            end
            tmp = lower(strtrim(strrep(ElementData{k},'-ea','')));
            if not(isnan(str2double(tmp)))           
                Elem(count,5) = str2double(tmp);
            end            
            tmp = lower(strtrim(strrep(ElementData{k},'-e','')));
            if not(isnan(str2double(tmp)))           
                Elem(count,4) = str2double(tmp);
            end             
            tmp = lower(strtrim(strrep(ElementData{k},'-k','')));
            if not(isnan(str2double(tmp)))           
                Elem(count,3) = str2double(tmp);
            end                        
            tmp = lower(strtrim(strrep(ElementData{k},'-n','')));
            if not(isnan(str2double(tmp)))           
                Elem(count,6) = str2double(tmp);
            end                        
            %check if the entery is bending angle
            tmp = lower(strtrim(strrep(ElementData{k},'-a','')));             
            if not(isnan(str2double(tmp)))           
                Elem(count,4) = str2double(tmp);
            end                 
        end
        if isDIPOL==1
            Elem(count,4) = Elem(count,2)/Elem(count,4);               
        end
        count = count +1;
    end
    %ElementLine = zeros()
    for j = 1: numel(ElementLinecell)
        ElementLine(j) = str2double(ElementLinecell{j});
    end
    
    
    
end