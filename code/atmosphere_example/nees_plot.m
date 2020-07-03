%%NEES Plot 
% Author: Naveed (mohdnaveed96@gmail.com)
clear all;
load('/home/naveed/Documents/DSE_data/80_states_nees_test_12_agents_all4.mat');
t_steps = size(nees_results,2);
n_agents = 12;
%Hyb_data = zeros(t_steps,n_agents);
%ICI_data = zeros(t_steps,n_agents);
%Gold_data = zeros(t_steps,n_agents);
nees_runs = size(nees_results,1);
%{
for i = 1:t_steps
    for iter = 1:nees_runs
        
        Hyb_data(i,:) = Hyb_data(i,:) + nees_results{iter,i}.Hybrid;
        ICI_data(i,:) = ICI_data(i,:) + nees_results{iter,i}.ICI;
        Gold_data(i,:) = Gold_data(i,:) + nees_results{iter,i}.Gold;
        
    end
end
%}
Hyb_data = zeros(t_steps,nees_runs);
ICI_data = zeros(t_steps,nees_runs);
Gold_data = zeros(t_steps,nees_runs);
cen_data = zeros(t_steps,nees_runs); 

mean = 80;
sigma = sqrt(2*80);

for i = 1:t_steps
    for iter = 1:nees_runs
        
        Hyb_data(i,iter) = (nees_results{iter,i}.Hybrid(1) - mean)/sigma;
        ICI_data(i,iter) = (nees_results{iter,i}.ICI(1) - mean)/sigma;
        Gold_data(i,iter) = (nees_results{iter,i}.Gold(1) - mean)/sigma;
        cen_data(i,iter) = (nees_results{iter,i}.cen(1) - mean)/sigma;
        
    end
end

%Hyb_data = (1/nees_runs)*Hyb_data;
%ICI_data = (1/nees_runs)*ICI_data;
%Gold_data = (1/nees_runs)*Gold_data;
for i = 1:t_steps
    Hyb_mean(i) = (1/sqrt(nees_runs)).*sum(Hyb_data(i,:));
    %Hyb_var(i) = var(Hyb_data(i,:));
    ICI_mean(i) = (1/sqrt(nees_runs)).*sum(ICI_data(i,:));
    %ICI_var(i) = var(ICI_data(i,:));
    Gold_mean(i) = (1/sqrt(nees_runs)).*sum(Gold_data(i,:));
    %Gold_var(i) = var(Gold_data(i,:));
    cen_mean(i) = (1/sqrt(nees_runs)).*sum(cen_data(i,:));
end
%%
fig = figure(1);
t = 1:t_steps;
plot(t,Gold_mean(:),'Marker','*','LineWidth',4,'color',[0.9290, 0.6940, 0.1250]);
hold on
plot(t,ICI_mean(:),'Marker','*','LineWidth',2,'color','b');
plot(t,Hyb_mean(:),'--','Marker','*','LineWidth',4,'color',[0 0.5 0]);
plot(t,cen_mean(:),':','Marker','*','LineWidth',3,'color','m');

%plot(t,80*.95653*ones(t_steps,1),'LineWidth',2,'color','k');
%plot(t,80*1.0441*ones(t_steps,1),'LineWidth',2,'color','r');
plot(t,-2.*ones(t_steps,1),'LineWidth',2,'color','k');
plot(t,2.*ones(t_steps,1),'LineWidth',2,'color','r');
hlegend = legend('FHS','ICI','Hybrid','Centralised','Lower Bound','Upper Bound');
set(hlegend,'Fontsize',14)
xlabel('Time(s)','FontSize', 12)
ylabel('Average NEES','FontSize', 12)
%ylim([-0.1,1.1])
grid on 
set(fig,'Units','inches');
screenposition = get(fig,'Position');
set(fig,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters '/home/naveed/Dropbox/Research/Data/T_RO_DSE/nees_80states_12agents_all4_normalised.pdf' ;
%{
fig = figure(2);
t = 1:t_steps;
plot(t,Gold_var(:),'Marker','*','LineWidth',2,'color',[0.9290, 0.6940, 0.1250]);
hold on
plot(t,ICI_var(:),'Marker','*','LineWidth',2,'color','b');
plot(t,Hyb_var(:),'--','Marker','*','LineWidth',2,'color',[0 0.5 0]);
plot(t,(2*80/50)*ones(t_steps,1),'LineWidth',2,'color','k');
hlegend = legend('FHS','ICI','Hybrid','Variance');
xlabel('Time(s)','FontSize', 12)
ylabel('Variance','FontSize', 12)
grid on 
set(fig,'Units','inches');
screenposition = get(fig,'Position');
set(fig,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters '/home/naveed/Dropbox/Research/Data/T_RO_DSE/12_var.pdf' ;
%}











