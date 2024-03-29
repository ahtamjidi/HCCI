function [perf_index_prob,perf_index] = gold_standard_model_reduction()
clear all
global opt_dist
profile on
rng(0)
close all
% dbclear all
dbstop if error
dbstop if warning
% [A,x0,B,C] = create_sys_gold();
[A,x0,B,C] = create_sys_atmosphere_gold();




flag_converged = 0;
global fail_prob reg_deg
range_prob = [ 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
% range_prob = [ 0.4 0.6 0.8  1];
% range_prob = [ 0 0.2  0.4 0.6 0.8 1];
% range_prob = [ 0.9 ];

% range_prob = [[0.5:0.05:0.8],0.9,1];
% range_prob = [[0:0.2:0.4],[0.5:0.05:0.8],0.9,1];
% range_prob = [0.5:0.05:0.6];


% range_reg = [ 2 4 6 8];
range_reg = [ 4];

% range_prob = [ 1];
problem_def_gold(A,x0(1:size(A,1)));

if strcmp(opt_dist.scenario, '1');
    for i_step = 1:5
        i_step
        opt_dist.i_step = i_step;
        %     flag_converged = 0;
        tic
        sim_system_gold();
        pred();
        consenus_gold();
        %         update_();
        %         calc_gold_update();
        calc_super_gold_update();
        
        %          [error_results{i_step}] = post_process_gold();
        %                 [error_results{j_reg,i_prob,i_step}] = post_process_gold2();
        time_(j_reg,i_prob,i_step) = toc;
        %                 [error_results{j_reg,i_prob,i_step}] = post_process_gold3();
        [error_results{j_reg,i_prob,i_step}] = post_process_gold3();
        
    end
    profile viewer
    
else
    range_step =80;
    for j_reg=1:length(range_reg)
        reg_deg = range_reg(j_reg);
        tic
        for i_prob=1:length(range_prob)
            if ~(j_reg==1 && i_prob==1)
                fields = {'obs' ,'result','Graph_History','sim','connection_history'};
                opt_dist = rmfield(opt_dist,fields);
                %             [A,x0,B,C] = create_sys_atmosphere_gold();
            end
            problem_def_gold(A,x0(1:size(A,1)));
            
            fail_prob =  range_prob(i_prob)
            opt_dist.reg_degree = reg_deg;
            
            for i_step = 1:range_step
                %                 if rem(i_step,2)==0
                %                                 problem_def_gold(A,x0(1:size(A,1)));
                %                 end
                i_step
                opt_dist.i_step = i_step;
                %     flag_converged = 0;
                sim_system_gold();
                pred();
                consenus_gold();
                %         update_();
                calc_super_gold_update();
                time_(j_reg,i_prob,i_step) = toc;
                [error_results{j_reg,i_prob,i_step}] = post_process_gold3();
                
            end
        end
        
    end
end
mean_ = calc_composite_results_gold(error_results,length(range_reg),length(range_prob),range_step)


end

