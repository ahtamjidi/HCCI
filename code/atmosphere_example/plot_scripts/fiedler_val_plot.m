%Fiedler value plot

clear all;
load('/home/naveed/Documents/DSE_data/80_states_30_agents_fiedler1.mat');
t_steps = size(fiedler_array,1);
t = 1:t_steps;

fig = figure(1);
hold on 
for i = [1]
    plot(t,fiedler_array(:,i),'LineWidth',2,'Marker','*')
end

load('/home/naveed/Documents/DSE_data/80_states_30_agents_fiedler2.mat');
t_steps = size(fiedler_array,1);
t = 1:t_steps;
for i = [1]
    plot(t,fiedler_array(:,i),'LineWidth',2,'Marker','*')
end
%ylim([0,1])
hlegend = legend('network 1','network 2','Location','east');
%hlegend = legend('15 agents');
xlabel('Time(s)','FontSize', 12)
ylabel('Fiedler Value','FontSize', 12)
grid on 
pbaspect([2.5 1 1])
set(fig,'Units','inches');
screenposition = get(fig,'Position');
set(fig,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters '/home/naveed/Dropbox/Research/Data/T_RO_DSE/fiedler/fiedler_80_states_30_agents_comp.pdf' ;