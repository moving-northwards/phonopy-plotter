%% PlotGruneisenDispCruve 
% MatLab plot of dispersion curves with a colour filter for Gruneisen parameters.
% from frequencies calculated by phonopy (by A. Togo) from VASP calculations. 
% Input file is gruneisen.yaml from phonopy. 
% Make sure you specify BAND not MP when extracting the Gruneisen parameters.
% Input your band labels here using LateX notation for Greek letters. 
% Requires ReadYaml.m and ReadYamlRaw.m by Yauhen Yakimovich (ewiger on github).
% Also requires cline.m by S. Hlz, TU-Berlin, seppel_mit_ppATweb.de

%% Read in YAML containing Gruneisen and frequency along high symmetry directions

Q=ReadYaml('AuCN_PBE_gdisp.yaml'); 

%% Other inputs

minG=-20; % max cutoff gruneisen parameter
maxG=20; % min cutoff gruneisen parameter
str={'$\Gamma$','M','K','$\Gamma$','A','L','H','A'};  % High symmetry point labels according to your chosen path
ymin=-5; % minimum frequency on plot in meV
ymax=85; % maximum frequency on plot in meV
fontsize = 25;
linewidth = 1.5;
width = 1000; % figure width
colormap = jet; % pick your colour map or create your own

%% Extract Information
nsympoint=length(Q.path); % total number of paths/high symmetry points in reciporcal space 
nphon=length(Q.path{1,1}.phonon{1,1}.band); % total number of phonons
nqpoint=Q.path{1,1}.nqpoint; % total number of q-points 

D=zeros(nsympoint,nqpoint); % This gives the x axis of dipersion curve
for i=1:1:nsympoint
    for j=1:1:nqpoint
        D(i,j)= Q.path{1,i}.phonon{1,j}.distance;
    end
end

for i=2:nsympoint % Adding each path to the last to get a continuous x axis
    for j=1:nqpoint
        D(i,j)=D(i,j)+D(i-1,nqpoint);
    end
end

%% Extract Results

F=zeros(nsympoint,nphon,nqpoint); % The frequencies
for i=1:nsympoint
    for j=1:nqpoint
        for k=1:nphon
            F(i,k,j)=Q.path{1,i}.phonon{1,j}.band{1,k}.frequency*4.1356655;
        end
    end
end
    
G=zeros(nsympoint,nphon,nqpoint); % The Gruneisen Parameters
for i=1:nsympoint
    for j=1:nqpoint
        for k=1:nphon
            G(i,k,j)=Q.path{1,i}.phonon{1,j}.band{1,k}.gruneisen;
        end
    end
end

%% Plain disp curve - Use this as a check to see the data is being read properly 

for i=1:nsympoint
    plot(D(i,:),squeeze(F(i,:,:)),'k');
    hold on 
end

%% Remove max and min - set between a max and min
C=zeros(nsympoint,nphon,nqpoint);
for i=1:nsympoint
    for j=1:nqpoint
        for k=1:nphon
            if G(i,k,j)> maxG
                C(i,k,j)= maxG;
            elseif G(i,k,j)< minG
                C(i,k,j)= minG;
            else
                C(i,k,j)= G(i,k,j);
            end
        end
    end
end


%%
d = (ymax-ymin)/(2*width/100); % space between x axis and label
offset = D(nsympoint,nqpoint)/100; % offset of x axis label to vertical lines

figure('colormap',colormap)
for i=1:nsympoint
    for k=1:nphon
        cline(squeeze(D(i,:)),squeeze(squeeze(F(i,k,:))),squeeze(squeeze(C(i,k,:))));
        hold on 
    end
end
plot([0 D(nsympoint,nqpoint)], [0 0],'k'); hold on % Horizontal line at zero
text(0-offset, ymin-d,str{1,1}); hold on % First label
for i=1:nsympoint % plot high symmetry point vertical lines plus all other labels
    plot([D(i,nqpoint) D(i,nqpoint)],[ymin ymax],'k')
    hold on
    try
        text(D(i,nqpoint)-offset,ymin-d,str{1,i+1})
    catch
        disp('number of symmetry point labels is less than number of symmetry points in chosen path')
    end
end
hold off
ylim([ymin ymax])
xlim([0 D(nsympoint,nqpoint)])
ylabel('E (meV)')
set(gca,'XTick',[],'YMinorTick','on','TickDir','in','TickLength',[0.02 0.035])

bar = colorbar;
title(bar,'$\gamma$','interpreter','Latex')
bar.TickLabelInterpreter = 'Latex';
bar.TickLabels = ({'$\leq$-20', '-16', '-12', '-8', '-4', '0', '4', '8', '12', '16', '$\geq$20'});
bar.TickLabelInterpreter = 'Latex';

%% General Figure Cosmetics
set(gca,'TickLabelInterpreter','latex');
set(gca,'box','on')
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







