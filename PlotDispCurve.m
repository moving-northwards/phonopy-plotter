%% PlotDispCruve 
% MatLab plot of dispersion curves from phonon frequencies extracted 
% by phonopy (by A. Togo) from VASP calculations. 
% Input file is band.yaml from phonopy. 
% You only need to specify ATOM_NAME, DIM and BAND to phonopy for this.
% Input your band labels here using LateX notation for Greek letters. 
% Requires ReadYaml.m and ReadYamlRaw.m by Yauhen Yakimovich (ewiger on github).

%% Read in data: DO ONLY ONCE AS TIME CONSUMING 
P=ReadYaml('band.yaml');

%% Other inputs
str={'$\Gamma$','M','K','$\Gamma$','A','L','H','A'};  % High symmetry point labels according to your chosen path
ymin=-5; % minimum frequency on plot in meV
ymax=85; % maximum frequency on plot in meV
fontsize = 25;
linewidth = 1.5;
width = 1000; % figure width

%% Extract information
nqpoint=P.nqpoint; % total number of q-points 
nsympoint=P.npath; % total number of paths/high symmetry points in reciporcal space 
nphon=P.natom*3; % total number of phonons
D=zeros(1,nqpoint); % This gives the x axis of dipersion curve
for i=1:1:nqpoint
    D(1,i)= P.phonon{1,i}.distance;
end

%% Extract the frequencies of all the phonons
F=zeros(nphon,nqpoint); 
for i=1:1:nqpoint
    for j=1:1:nphon
        F(j,i)=P.phonon{1,i}.band{1,j}.frequency*4.1356655; %frequency is converted to meV
    end
end

%% Plotting
d = (ymax-ymin)/(2*width/100); % space between x axis and labels

figure 
plot(D,F,'k'); hold on 
plot([0 D(1,nqpoint)], [0 0],'k'); hold on % Horizontal line at zero 
text(0-0.011, ymin-d,str{1,1}) % First label
for k=1:1:nsympoint % plot high symmetry point vertical lines plus all other labels
    hold on
    plot([D(1,k*nqpoint/nsympoint) D(1,k*nqpoint/nsympoint)],[ymin ymax],'k')
    hold on
    try
        text(D(1,k*nqpoint/nsympoint)-0.011, ymin-d,str{1,k+1})
    catch
        disp('number of symmetry point labels is less than number of symmetry points in chosen path')
    end
end
hold off
ylim([ymin ymax])
xlim([0 D(1,nqpoint)])
ylabel('E (meV)')
set(gca,'XTick',[],'YMinorTick','on','TickDir','in','TickLength',[0.02 0.035])

%% General Figure Cosmetics
set(gca,'TickLabelInterpreter','latex');
set(gcf,'Position',[100 100 width 0.75*width]);
set(gcf,'Color',[1 1 1]);


H = findall(gcf); % find all handles

for l = 1 : length(H) % set font sizes - same for all
  try
    set(H(l),'fontsize',fontsize); 
  catch
  end
  
  try
    set(H(l),'Linewidth',linewidth);
  catch
  end
  
  try
    set(H(l),'Interpreter','latex');
  catch
  end
end

