function [nees_results] = nees_func()
%Function to compute errors for NEES evaluation
%@Naveed

global opt_dist

%% calculate error statistics
if opt_dist.FLAGS.compare_with_CI
    [nees_results.ICI] = calc_error_stat('ICI');
end
if opt_dist.FLAGS.our_method
    [nees_results.Hybrid] = calc_error_stat('Hybrid');
end

[nees_results.Gold] = calc_error_stat('Gold');
[nees_results.cen] = calc_error_stat('Cent');

end

function [nees_mean] = calc_error_stat(method)
%Compute Normalised error
    global opt_dist

    x_gt = opt_dist.sim.gt.x_bar;

    for j_agent = 1 : opt_dist.nAgents
        
        switch method
            case 'Gold'
                %disp('Gold');
                P_gold =  opt_dist.result.est_gold{j_agent}.P_bar; 
                x_gold = opt_dist.result.est_gold{j_agent}.x_bar ;
                error = (x_gold - x_gt);
                nees_mean(j_agent) = error'*inv(P_gold)*error;
                %P = 0;
        
            case 'ICI'
                %disp('ICI');
                P = inv(opt_dist.result.est{end}.Y_bar_CI(:,:,j_agent));
                x = P*(opt_dist.result.est{end}.y_bar_CI(:,j_agent));
                error = (x - x_gt);
                nees_mean(j_agent) = error'*inv(P)*error;
                %P = 0;
            
            case 'Hybrid'
                %disp('Hybrid');
                P = inv(opt_dist.result.est{end}.Y_bar(:,:,j_agent));
                x = P*(opt_dist.result.est{end}.y_bar(:,j_agent));   
                error = (x - x_gt);
                nees_mean(j_agent) = error'*inv(P)*error;
                %P = 0;
                
            case 'Cent'
                %disp('Cent');
        
                P_cen = inv(opt_dist.result.est{1}.Y_cen);
                x_cen = P_cen*(opt_dist.result.est{1}.y_cen);
                
                %disp('error:');
                %error = x_cen - x_gt; 
                error = (x_cen - x_gt);
                nees_mean(j_agent) = error'*inv(P_cen)*error;
                %{
                if j_agent == 1 %for printing
                    disp(['Eig(P)=',num2str(eig(P_cen)')]); 
                    disp(['nees_mean=',num2str(nees_mean(j_agent))]);
                end
                %}
                %P(j_agent) = sqrt(P_cen(4,4));
                
        end

    end

end
