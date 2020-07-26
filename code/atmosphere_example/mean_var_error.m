%finding expectation of error and variance of error

sample_size = size(nees_results,2);
n_agents = 1;
samples = zeros(sample_size,n_agents);
t_steps = size(nees_results,3);

%Mean
for t_s = 1:t_steps
    disp('t:'); disp(t_s);
    for j_agent = 1: n_agents
        for i_sample = 1:sample_size
            samples(i_sample,j_agent) = nees_results{1,i_sample,t_s}.cen(j_agent);
        end
    end

    for j_agent = 1: n_agents

        disp('mean:'); disp(j_agent);
        disp(mean(samples(:,j_agent)));

    end
end

