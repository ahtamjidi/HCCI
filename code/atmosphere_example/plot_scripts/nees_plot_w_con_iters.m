%%NEES Plot with consensus iterations
% Author: Naveed (mohdnaveed96@gmail.com)
clear all;
load('/home/naveed/Documents/DSE_data/20_states_nees_test_15_agents_all4.mat');
t_steps = size(nees_results,3);
dim_state = 20;
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

mu = 0;%20;%TODO change for Gaussian
sigma = 1;%sqrt(2*20); %TODO change for Gaussian

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
nees_lb = 0.50*((sqrt(2*dim_state*nees_runs - 1) - 1.96)^2)/nees_runs -mu;
nees_ub = 0.50*((sqrt(2*dim_state*nees_runs - 1) + 1.96)^2)/nees_runs -mu;
%%
fig = figure(1);
t = 1:t_steps;
%color scheme
ICI_color = (1/255).*[0,255,255; 0,204,204; 0,0,0;  0,0,153];
Hyb_color = (1/255).*[255,0,0; 51,255,51; 0,0,0;  0,103,51];

plot(t,Gold_mean(c_steps,:),'Marker','*','LineWidth',3,'color',[0.9290, 0.6940, 0.1250],'DisplayName','FHS');
hold on
%plot(t,cen_mean(c_steps,:),':','Marker','*','LineWidth',3,'color','m','DisplayName','Centralised');
for j = [1,2,4]

    plot(t,Hyb_mean(j,:),'--','Marker','*','LineWidth',2,'color',Hyb_color(j,:),'DisplayName',['Hybrid' '-' num2str(converg_steps_array(j)) ' step']);
end
for j = [1,2,4]

    %plot(t,Gold_mean(j,:),'Marker','*','LineWidth',2,'color',[0.9290, 0.6940, 0.1250],'DisplayName','FHS');
   
    p = plot(t,ICI_mean(j,:),'Marker','*','LineWidth',2,'color',ICI_color(j,:),'DisplayName',['ICI' '-' num2str(converg_steps_array(j)) ' step']);
    %p.Annotation.LegendInformation.IconDisplayStyle = 'off';
  
    %plot(t,cen_mean(j,:),':','Marker','*','LineWidth',2,'color','m','DisplayName','Centralised');
end

%outside the loop to avoid repetition in case of multiple converg steps.
 
%plot(t,ICI_mean(c_steps,:),'Marker','*','LineWidth',2,'color','b','DisplayName','ICI');

lb = plot(t,nees_lb.*ones(t_steps,1),'LineWidth',2,'color','k');
ub = plot(t,nees_ub.*ones(t_steps,1),'LineWidth',2,'color',(1/255).*[153,51,0]);
lb.Annotation.LegendInformation.IconDisplayStyle = 'off';
ub.Annotation.LegendInformation.IconDisplayStyle = 'off';

%hlegend = legend('FHS','ICI','Hybrid','Centralised','Lower Bound','Upper Bound');

hlegend = legend('Location','northoutside','NumColumns',2);
set(hlegend,'Fontsize',10);

xlabel('Time(s)','FontSize', 12)
ylabel('Average NEES','FontSize', 12)
%ylim([-0.1,1.1])
grid on 
set(fig,'Units','inches');
screenposition = get(fig,'Position');
set(fig,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
%print -dpdf -painters '/home/naveed/Dropbox/Research/Data/T_RO_DSE/gaussian_20states_15agents.pdf' ;










