clear

alpha    = 0.9;
gamma    = 0.1;
eps      = 0.5;

x_space = linspace(1,50,50);
y_space = linspace(1,50,50);
vx_space = linspace(-2,2,5);
vy_space = linspace(-2,2,5);

UP              = 1;
DOWN            = 2;
RIGHT           = 3;
LEFT            = 4;
NEUTRAL         = 5;
action_space    = [UP;DOWN;RIGHT;LEFT;NEUTRAL];

Q = rand([50,50,5,5,5]);

runs_list = zeros(100,1);
wins_list = zeros(100,1);
violations_list = zeros(100,1);
index = 1;
counter = 0; 
for episode = 1:1000000
    randomIndex1 = randi(length(x_space), 1);
    randomIndex2 = randi(length(y_space), 1);
    randomIndex3 = randi(length(vx_space), 1);
    randomIndex4 = randi(length(vy_space), 1);
    startPt = [x_space(randomIndex1),y_space(randomIndex2),vx_space(randomIndex3),vy_space(randomIndex3)];
    state = startPt;
       
    for k = 1:1000       
        
        x_idx      = find(x_space == state(1,1));
        y_idx      = find(y_space == state(1,2));
        vx_idx     = find(vx_space == state(1,3));
        vy_idx     = find(vy_space == state(1,4));
        
        if rand() > eps
            [~,action] = max(Q(x_idx,y_idx,vx_idx,vy_idx,:));
        else
            action = randi(length(action_space),1);
        end
             
        %update the states
        if action==UP
            newState(1,1) = state(1,1)+state(1,3); %x_pos
            newState(1,2) = state(1,2)+state(1,4); %y_pos
            newState(1,3) = state(1,3)+0;             %v_x
            newState(1,4) = state(1,4)+1;             %v_y
        elseif action==DOWN            
            newState(1,1) = state(1,1)+state(1,3); %x_pos
            newState(1,2) = state(1,2)+state(1,4); %y_pos
            newState(1,3) = state(1,3)+0;             %v_x
            newState(1,4) = state(1,4)-1;             %v_y            
        elseif action==LEFT            
            newState(1,1) = state(1,1)+state(1,3); %x_pos
            newState(1,2) = state(1,2)+state(1,4); %y_pos
            newState(1,3) = state(1,3)-1;             %v_x
            newState(1,4) = state(1,4)+0;             %v_y             
        elseif action==RIGHT            
            newState(1,1) = state(1,1)+state(1,3); %x_pos
            newState(1,2) = state(1,2)+state(1,4); %y_pos
            newState(1,3) = state(1,3)+1;             %v_x
            newState(1,4) = state(1,4)+0;             %v_y
        elseif action==NEUTRAL          
            newState(1,1) = state(1,1)+state(1,3); %x_pos
            newState(1,2) = state(1,2)+state(1,4); %y_pos
            newState(1,3) = state(1,3)+0;             %v_x
            newState(1,4) = state(1,4)+0;             %v_y
        end
        
        
        r2 = 0;
        %speed limit
        if newState(1,3) > 2
            newState(1,3) = 2;
            r2 = -100;
        elseif newState(1,3) < -2
            newState(1,3) = -2;
            r2 = -100;
        elseif newState(1,4) > 2
            newState(1,4) = 2;
            r2 = -100;
        elseif newState(1,4) < -2
            newState(1,4) = -2;
            r2 = -100;
        end
        
        %reward
        r1 = -(25 - newState(1,1))^2 + -(1 - newState(1,2))^2;
        r = r1 + r2;
        
        
        
        %succes
        if (newState(1,1)>23) && (newState(1,1)<27) && (newState(1,2)==1) && (newState(1,3)==0) && (newState(1,4)==-1) 
            bonus = 50000;
            r = bonus + r;
            update_Q;
            %episode
            break;       
        end
        
        %fail
        if (newState(1,1)<1) || (newState(1,1)>50) || (newState(1,2)<1) || (newState(1,2)>50)
            if newState(1,1)<1
               newState(1,1)=1;
            end
            
            if newState(1,1)>50
               newState(1,1)=50;
            end
            
            if newState(1,2)<1
               newState(1,2)=1;
            end
            
            if newState(1,2)>50
               newState(1,2)=50;
            end
            
            bonus = -50000;
            r = bonus + r;
            update_Q;
            break;
        end
        update_Q;        
        state = newState;
    if counter >= 10000
        assignment_learned_Q;
        %percentage wins and violations per run
        runs_list(index) = episode;
        wins_list(index) = wins/10000*100;
        violations_list(index) = violations/10000;
        index = index + 1;
        counter = 0;
    end
    
    end
    counter = counter + 1;
end

save('Q_table.mat','Q')

figure()
plot(runs_list(1:99),wins_list(1:99))
xlabel("Number of episoded")
ylabel("Percentage of wins by a greedy policy")

figure()
plot(runs_list(1:99),violations_list(1:99))
xlabel("Number of episoded")
ylabel("Average speed violations per run")
