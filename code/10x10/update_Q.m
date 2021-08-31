 x_new_idx      = find(x_space == newState(1,1));
 y_new_idx      = find(y_space == newState(1,2));
 vx_new_idx     = find(vx_space == newState(1,3));
 vy_new_idx     = find(vy_space == newState(1,4));
        
 x_idx      = find(x_space == state(1,1));
 y_idx      = find(y_space == state(1,2));
 vx_idx     = find(vx_space == state(1,3));
 vy_idx     = find(vy_space == state(1,4));
        
 action_idx = action;
 
 Q(x_idx,y_idx,vx_idx,vy_idx,action_idx) = Q(x_idx,y_idx,vx_idx,vy_idx,action_idx) + alpha * ( r + gamma * max(Q(x_new_idx,y_new_idx,vx_new_idx,vy_new_idx,:)) - Q(x_idx,y_idx,vx_idx,vy_idx,action_idx));
 
 