clearvars
close all
clc
%%
load('/home/naveed/Documents/DSE_data/80_states_convergence_rate_30_100.mat')
agents_count = n_receptors_array;
steps = size(converg_steps_array,2);
T = size(error_(1,1).e_BC_dist_gold,2);    
N = size(agents_count,2);
fig = figure(1);

Hyb_errors = zeros(T, N,steps);
ICI_errors = zeros(T, N,steps);
time = zeros(N,steps);

full_converg_steps_array = converg_steps_array;
for i=[1]
    for j=1:steps
        Hyb_errors(:,i,j) = error_(i,j).e_BC_dist_gold(1,:);%./mean(error_(i,end).e_BC_dist_gold(1,:));
        ICI_errors(:,i,j) = error_(i,j).e_BC_dist_gold(2,:);%./mean(error_(i,end).e_BC_dist_gold(2,:));
        %time(i,j) = time_array(i,j);
    end


    
    
    %{
    if i == 1
        color = [1 0 0];
    else
        color = [0 0 1];
    end
    %}
    h = boxplot(squeeze(Hyb_errors(:,i,:)),'positions', converg_steps_array,'symbol','', 'color',(1/255).*[51,255,51]);
    hold on 
    set(h,'LineWidth',2);
    boxplot(squeeze(ICI_errors(:,i,:)),'positions', converg_steps_array,'symbol','','PlotStyle','compact','color',(1/255).*[0,204,204])
   
end
%%
load('/home/naveed/Documents/DSE_data/80_states_convergence_rate_30_agents_range10.mat')
agents_count = n_receptors_array;
partial_steps = size(converg_steps_array,2);
T = size(error_(1,1).e_BC_dist_gold,2);    
N = size(agents_count,2);

Hyb_errors = zeros(T, N,steps);
ICI_errors = zeros(T, N,steps);
%time = zeros(N,steps);


for i=[1]
    for j=1:partial_steps
        Hyb_errors(:,i,j) = error_(i,j).e_BC_dist_gold(1,:);%./mean(error_(i,end).e_BC_dist_gold(1,:));
        ICI_errors(:,i,j) = error_(i,j).e_BC_dist_gold(2,:);%./mean(error_(i,end).e_BC_dist_gold(2,:));
        %time(i,j) = time_array(i,j);
    end
end
load('/home/naveed/Documents/DSE_data/80_states_convergence_rate_30_agents_range10_extend_citers.mat')
for i=[1]
    for j= partial_steps+1:steps
        Hyb_errors(:,i,j) = error_(i,j-partial_steps).e_BC_dist_gold(1,:);%./mean(error_(i,end).e_BC_dist_gold(1,:));
        ICI_errors(:,i,j) = error_(i,j-partial_steps).e_BC_dist_gold(2,:);%./mean(error_(i,end).e_BC_dist_gold(2,:));
        %time(i,j) = time_array(i,j);
    end
end
h = boxplot(squeeze(Hyb_errors(:,i,:)),'positions', full_converg_steps_array,'symbol','', 'color',[0 0.5 0]);
set(h,'LineWidth',2); 
boxplot(squeeze(ICI_errors(:,i,:)),'positions', full_converg_steps_array,'symbol','','PlotStyle','compact')
%%
%{
load('/home/naveed/Documents/DSE_data/80_states_convergence_rate_30_agents_range10_extend_citers.mat')
agents_count = n_receptors_array;
steps = size(converg_steps_array,2);
T = size(error_(1,1).e_BC_dist_gold,2);    
N = size(agents_count,2);

Hyb_errors = zeros(T, N,steps);
ICI_errors = zeros(T, N,steps);
time = zeros(N,steps);


for i=[1]
    for j=1:steps
        Hyb_errors(:,i,j) = error_(i,j).e_BC_dist_gold(1,:);%./mean(error_(i,end).e_BC_dist_gold(1,:));
        ICI_errors(:,i,j) = error_(i,j).e_BC_dist_gold(2,:);%./mean(error_(i,end).e_BC_dist_gold(2,:));
        %time(i,j) = time_array(i,j);
    end


    
    
    %{
    if i == 1
        color = [1 0 0];
    else
        color = [0 0 1];
    end
    %}
    h = boxplot(squeeze(Hyb_errors(:,i,:)),'positions', converg_steps_array,'symbol','', 'color',[0 0.5 0]);
    set(h,'LineWidth',2);
   
    boxplot(squeeze(ICI_errors(:,i,:)),'positions', converg_steps_array,'symbol','','PlotStyle','compact')
   
end
%}
%%

xticks(full_converg_steps_array);
boxes = findall(gca,'Tag','Box');

xticklabels({'1','','10','','20','30','40','50','60','80','100','120','140','160','180','200'}) %,%
%hLegend = legend(boxes([1 end]), {'Hybrid 40 agents','Hybrid 60 agents'},'Location','northwest','Fontsize',14);
hLegend = legend(boxes([1 17 34 end]), {'ICI-1','Hybrid-1','ICI-2','Hybrid-2'},'Location','east','Fontsize',14);
xlabel('Number of consensus iterations','FontSize', 12)
ylabel('$D_B$','Interpreter','latex','FontSize', 14)
ylim([0 1.1]);
xlim = [0 210];
ax = gca;
ax.FontSize = 12; 
set(fig,'Units','inches');
screenposition = get(fig,'Position');
set(fig,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);

print -dpdf -painters '/home/naveed/Dropbox/Research/Data/T_RO_DSE/Convergence/convergence_80_states_30_agents_comp.pdf' ;
%print -dpdf -painters 'time_taken_80states_30agents.pdf' ;