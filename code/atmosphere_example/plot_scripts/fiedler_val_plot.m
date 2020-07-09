%Fiedler value plot

clear all;
load('/home/naveed/Documents/DSE_data/fiedler_value.mat');
t_steps = size(fiedler_array,1);
t = 1:t_steps;

fig = figure(1);
hold on 
for i = 1:size(n_receptors_array,2)-1
    plot(t,fiedler_array(:,i),'LineWidth',2,'Marker','*')
end
hlegend = legend('10','20','30','40','50','60','80','100');
xlabel('Time(s)','FontSize', 12)
ylabel('Fiedler Value','FontSize', 12)
grid on 
set(fig,'Units','inches');
screenposition = get(fig,'Position');
set(fig,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters '/home/naveed/Dropbox/Research/Data/T_RO_DSE/fiedler.pdf' ;