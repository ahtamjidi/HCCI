%%NEES Plot with consensus iterations
% Author: Naveed (mohdnaveed96@gmail.com)
clear all;
load('/home/naveed/Documents/DSE_data/10_states_nees_test_15_agents_all4.mat');
t_steps = size(nees_results,3);
dim_state = 10;
n_agents = 15;

%Hyb_data = zeros(t_steps,n_agents);
%ICI_data = zeros(t_steps,n_agents);
%Gold_data = zeros(t_steps,n_agents);
nees_runs = size(nees_results,2);
c_steps = size(converg_steps_array,2);
%{
for i = 1:t_steps
    for iter = 1:nees_runs
        
        Hyb_data(i,:) = Hyb_data(i,:) + nees_results{iter,i}.Hybrid;
        ICI_data(i,:) = ICI_data(i,:) + nees_results{iter,i}.ICI;
        Gold_data(i,:) = Gold_data(i,:) + nees_results{iter,i}.Gold;
        
    end
end
%}
Hyb_data = zeros(c_steps,t_steps,nees_runs);
ICI_data = zeros(c_steps,t_steps,nees_runs);
Gold_data = zeros(c_steps,t_steps,nees_runs);
cen_data = zeros(c_steps,t_steps,nees_runs);
mu = 0;%TODO change for Gaussian
sigma = sqrt(1); %TODO change for Gaussian

for j = 1:c_steps
    for i = 1:t_steps
        for iter = 1:nees_runs
        
            Hyb_data(j,i,iter) = (nees_results{j,iter,i}.Hybrid(1) - mu)/sigma;
            ICI_data(j,i,iter) = (nees_results{j,iter,i}.ICI(1) - mu)/sigma;
            Gold_data(j,i,iter) = (nees_results{j,iter,i}.Gold(1) - mu)/sigma;
            cen_data(j,i,iter) = (nees_results{j,iter,i}.cen(1) - mu)/sigma;
        end
    end
end

for j = 1:c_steps
    for i = 1:t_steps
        %Hyb_mean(j,i) = (1/sqrt(nees_runs)).*sum(Hyb_data(j,i,:));
        Hyb_mean(j,i) = mean(Hyb_data(j,i,:));
        %ICI_mean(j,i) = (1/sqrt(nees_runs)).*sum(ICI_data(j,i,:));
        ICI_mean(j,i) = mean(ICI_data(j,i,:));
        %Gold_mean(j,i) = (1/sqrt(nees_runs)).*sum(Gold_data(j,i,:));
        Gold_mean(j,i) = mean(Gold_data(j,i,:));
        %cen_mean(j,i) = (1/sqrt(nees_runs)).*sum(cen_data(j,i,:));
        cen_mean(j,i) = mean(cen_data(j,i,:));
    end
end
nees_lb = 0.50*((sqrt(2*dim_state*nees_runs - 1) - 1.96)^2)/nees_runs;
nees_ub = 0.50*((sqrt(2*dim_state*nees_runs - 1) + 1.96)^2)/nees_runs;
%%
fig = figure(1);
t = 1:t_steps;
for j = 1:c_steps

    %plot(t,Gold_mean(j,:),'Marker','*','LineWidth',2,'color',[0.9290, 0.6940, 0.1250],'DisplayName','FHS');
    hold on
    p = plot(t,ICI_mean(j,:),'Marker','*','LineWidth',2,'color','b');
    p.Annotation.LegendInformation.IconDisplayStyle = 'off';
    plot(t,Hyb_mean(j,:),'--','Marker','*','LineWidth',2,'DisplayName',['Hybrid' '-' num2str(converg_steps_array(j)) 'step']);
    %plot(t,cen_mean(j,:),':','Marker','*','LineWidth',2,'color','m','DisplayName','Centralised');
end
plot(t,Gold_mean(c_steps,:),'Marker','*','LineWidth',3,'color',[0.9290, 0.6940, 0.1250],'DisplayName','FHS');
plot(t,ICI_mean(c_steps,:),'Marker','*','LineWidth',2,'color','b','DisplayName','ICI');
plot(t,cen_mean(c_steps,:),':','Marker','*','LineWidth',3,'color','m','DisplayName','Centralised');
%plot(t,80*.95653*ones(t_steps,1),'LineWidth',2,'color','k');
%plot(t,80*1.0441*ones(t_steps,1),'LineWidth',2,'color','r');
plot(t,nees_lb.*ones(t_steps,1),'LineWidth',2,'color','k','DisplayName','Lower Bound');
plot(t,nees_ub.*ones(t_steps,1),'LineWidth',2,'color','r','DisplayName','Upper Bound');
%hlegend = legend('FHS','ICI','Hybrid','Centralised','Lower Bound','Upper Bound');
%set(hlegend,'Fontsize',14)
legend('Location','SouthEast')
xlabel('Time(s)','FontSize', 12)
ylabel('Average NEES','FontSize', 12)
%ylim([-0.1,1.1])
grid on 
set(fig,'Units','inches');
screenposition = get(fig,'Position');
set(fig,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
%print -dpdf -painters '/home/naveed/Dropbox/Research/Data/T_RO_DSE/nees_40states_40agents_w_con_iters_rand_mod.pdf' ;
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











