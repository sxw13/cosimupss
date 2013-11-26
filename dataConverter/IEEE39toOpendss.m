%% converter IEEE format to opendss format for IEEE 39 test


% load ieee 39 data in matlab

d_n039_all_pst;

% define the voltage levels 

IEEE39_voltageLevel;

pB = 0.3*1e5;

% translate the loads

loadFile = 'load.dss';
fidout=fopen(loadFile,'w');
nLoad = length(PQ.con(:, 1));
for i = 1 : nLoad
    vidx = find(vl.con(:,1)==PQ.con(i,1));
    voltageLevel = vl.con(vidx,2);
    outputline = ['New ', 'Load.B', num2str(PQ.con(i, 1)), ' Bus1=B',  num2str(PQ.con(i, 1)), ' kV=', num2str(voltageLevel), ...
        ' kW=', num2str(PQ.con(i, 4)*pB), ' kvar=', num2str(PQ.con(i, 5)*pB), ' Model=1 vminpu=0.8 vmaxpu=1.5 '];
    disp(outputline);
    fprintf(fidout,'%s\n',outputline);
end
fclose(fidout);

% translate the lines
% New line.1-2   Bus1=B1  Bus2=B2  R1=3.345408  X1=10.0188   R0=10.036224 X0=30.0564    C1=803.793907242183 C0=267.931302414061 Length=1  

% Line.con = [ ...
%    2    1      100        1       60        0        0   0.0035   0.0411   0.6987        1        0        0;
lineFile = 'line.dss';
fidout = fopen(lineFile, 'w');
nBranch = length(Line.con(:, 1));
Sn = 1e8;
for i = 1 : nBranch
   if (Line.con(i, 10) == 0)
       continue;
   end
   vidx = find(vl.con(:,1)==Line.con(i,1));
   vb = vl.con(vidx, 2) * 1e3;
   R1 = Line.con(i, 8) * (vb^2)/Sn;
   X1 = Line.con(i, 9) * (vb^2)/Sn;
%    C1 = Line.con(i, 10)/ (2* pi * 60) * (Sn/(vb^2))*1e9;
   B1 = Line.con(i, 10) * Sn/(vb^2) * 1e3;
   C1 = 0;
   outline = ['New line.', num2str(Line.con(i,1)), '-' , num2str(Line.con(i,2)), ...
               ' Bus1=B', num2str(Line.con(i, 1)), ' Bus2=B', num2str(Line.con(i, 2)), ...
               ' R1=', num2str(R1), ' X1=', num2str(X1), ' R0=', num2str(R1*3), ' X0=', num2str(X1*3), ...
               ' C1=', num2str(C1), ' C0=', num2str(C1/3), '  Length=1'];
   disp(outline);
   fprintf(fidout,'%s\n',outline);
end
fclose(fidout);


% translate the transformers
% New Transformer.6-9 kVAs=[100000 100000] XHL=20.8 PPM=0
% ~ Wdg=1 R=0 kV=132 Bus=B6 Tap=0.978
% ~ Wdg=2 R=0 kV=1 Bus=B9
% ~ %loadloss=0

lineFile = 'transformer.dss';
fidout = fopen(lineFile, 'w');
nBranch = length(Line.con(:, 1));
Sn = 1e8;
for i = 1 : nBranch
   if (Line.con(i, 10) ~= 0)
       continue;
   end
   vidx1 = find(vl.con(:,1)==Line.con(i,1));
   vb1 = vl.con(vidx1, 2);
   vidx2 = find(vl.con(:,1)==Line.con(i,2));
   vb2 = vl.con(vidx2, 2);
   XLH = Line.con(i, 9) *  100;
   R = Line.con(i, 8) *  100;
   outline = ['New Transformer.', num2str(Line.con(i,1)), '-' , num2str(Line.con(i,2)), ...
               ' kVAs=[100000 100000] ', ' %R =', num2str(R), ' XHL=', num2str(XLH), ... 
               ' Wdg=1 R=0 kV=', num2str(vb1), ' Bus=B', num2str(Line.con(i, 1)), ' Tap=', num2str(Line.con(i,11)), ...
               ' Wdg=2 R=0 kV=', num2str(vb2), ' Bus=B', num2str(Line.con(i, 2)) %, ' %loadloss=0 '
               ];
   disp(outline);
   fprintf(fidout,'%s\n',outline);
end
fclose(fidout);

% translate the generators
% New Generator.B5  Bus1=B5  kV= 132 kW=1     Model=3 Vpu=1.01  Maxkvar=80000 Minkvar=-80000 !  kvar=37000 

genFile = 'generators.dss';
fidout = fopen(genFile, 'w');
nGen = length(PV.con(:, 1));
for i = 1 : nGen
%    if (PV.con(i,1)==39) 
%        continue;
%    end
   vidx = find(vl.con(:,1)==PV.con(i,1));
   vb = vl.con(vidx, 2);
   outline = ['New Generator.B', num2str(PV.con(i,1)), ...
               ' Bus1=B', num2str(PV.con(i,1)), ' kV=', num2str(vb), ... 
               ' kW=', num2str(PV.con(i,4)*pB), ' Model=3 Vpu=', num2str(PV.con(i,5)), ...
               ' Maxkvar=9900000 Minkvar=-9900000'];
%                ' Maxkvar=',num2str(PV.con(i,6)*1e3), ...
%                ' Minkvar=', num2str(PV.con(i,7)*1e3)
               
   disp(outline);
   fprintf(fidout,'%s\n',outline);
end
% vidx = find(vl.con(:,1)==SW.con(1,1));
% vb = vl.con(vidx, 2);
% outline = ['New Generator.B', num2str(SW.con(1,1)), ...
%     ' Bus1=B', num2str(SW.con(1,1)), ' kV=', num2str(vb), ...
%     ' kW=', num2str(SW.con(1,10)*pB), ' Model=3 Vpu=', num2str(SW.con(1,4)), ...
%     ' Maxkvar=9900000 Minkvar=-9900000'];
% %  disp(outline);
%  fprintf(fidout,'%s\n',outline);
fclose(fidout);



