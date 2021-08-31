%clear
%load Q_table.mat

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

wins = 0;
violations = 0;
for run = 1:10000
    randomIndex1 = randi(length(x_space), 1);
    randomIndex2 = randi(length(y_space), 1);
    randomIndex3 = randi(length(vx_space), 1);
    randomIndex4 = randi(length(vy_space), 1);
    startPt = [x_space(randomIndex1),y_space(randomIndex2),vx_space(randomIndex3),vy_space(randomIndex4)];
    state = startPt;
        
    for k = 1:1000
        
        x_idx      = find(x_space == state(1,1));
        y_idx      = find(y_space == state(1,2));
        vx_idx     = find(vx_space == state(1,3));
        vy_idx     = find(vy_space == state(1,4));

        [~,action] = max(Q(x_idx,y_idx,vx_idx,vy_idx,:));
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
        
        %speed limit
        if newState(1,3) > 2
            newState(1,3) = 2;
            violations = violations + 1;
        elseif newState(1,3) < -2
            newState(1,3) = -2;
            violations = violations + 1;
        elseif newState(1,4) > 2
            newState(1,4) = 2;
            violations = violations + 1;
        elseif newState(1,4) < -2
            newState(1,4) = -2;
            violations = violations + 1;
        end        

        
       
        
        
        %succes
        if (newState(1,1)>23) && (newState(1,1)<27) && (newState(1,2)==1) && (newState(1,3)==0) && (newState(1,4)==-1) 
            wins = wins + 1;
            break;       
        end
        
        %fail
        if (newState(1,1)<1) || (newState(1,1)>50) || (newState(1,2)<1) || (newState(1,2)>50)
            break;
        end
                
        state = newState;
    
    end
end