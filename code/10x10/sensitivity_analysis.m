clear

alphas = ([0.1:0.2:0.9]);
epsilons = ([0.1:0.2:0.9]);
gammas = ([0.1:0.2:0.9]);

index = 1;
parameters = zeros(length(alphas)*length(epsilons)*length(gammas),4);
for i=1:length(alphas)
    for j = 1:length(epsilons)
        for k = 1:length(gammas)
            parameters(index,1) = alphas(i);
            parameters(index,2) = epsilons(j);
            parameters(index,3) = gammas(k);
            
            index = index + 1;
        end
    end
end

for i=1:length(parameters)
    alpha = parameters(i,1);
    eps = parameters(i,2);
    gamma = parameters(i,3);
    assignment_rl_Q;
    assignment_learned_Q;
    parameters(i,4) = wins;
end

[R,P] = corrcoef(parameters);