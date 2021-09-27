#using_animtree( "vehicles" );

FORWARD_SCALE = 1.0;
SIDE_SCALE = 2.5;

manage_player_position( player_spot )
{
    player_spot endon ( "stop_manage_player_position" );
    player_spot UseAnimTree(#animtree );
    curanim = %london_player_truck_player_move_forward;
    destanim = %london_player_truck_player_move_forward;
    cur_right_anim = %london_player_truck_player_move_right;
    cur_right_destanim = %london_player_truck_player_move_right;
    
    bob = %london_player_truck_player_move_bob;
    
    player_spot SetAnim( curanim, 1, 0, 0 );
    player_spot SetAnimTime( curanim, 0.08 );
    player_spot SetAnim( cur_right_anim, 1, 0, 0 );
    player_spot SetAnimTime( cur_right_anim, 0.37 );
    bobscale = 0.06; 
    bobrate = 2.1;
    bobstopped = true;

    movement_updated = true;
    right_movement_updated = false;
    
    
    
    level waittill ("start_manage_player_position" );
    player_spot SetAnim( bob,1, 0, 0  );
    
    while ( 1 )
    {
        if ( level.player GetStance() == "crouch" )
             bobscale = 0.5; 
        else
            bobscale = 0.7; 
        
        wait 0.05;

        normalized_movement = level.player GetNormalizedMovement();
        
        if ( !IsAlive( level.player ) )
            normalized_movement = ( 0, 0, 0 );
            
        movement_strength = Distance( ( 0, 0, 0 ), normalized_movement );
        
        normalized_movement = ( normalized_movement[ 0 ], normalized_movement[ 1 ]  *- 1, normalized_movement[ 0 ] ); // math is hard
        normalized_movement_angles = VectorToAngles( normalized_movement );
        player_angles = level.player GetPlayerAngles();
        
        if ( IsDefined( level.groundent ) )
            player_angles = CombineAngles( level.groundent.angles, player_angles );

        forward_movement_angle = CombineAngles( player_angles, normalized_movement_angles );
        movement_vector = VectorNormalize ( AnglesToForward( forward_movement_angle ) );
        
        forward_base = VectorNormalize( AnglesToForward( player_spot GetTagAngles( "tag_player" ) ) );
        right_base = VectorNormalize( AnglesToRight( player_spot GetTagAngles( "tag_player" ) ) );

        movement_vector_dot = VectorDot( movement_vector, forward_base );
        right_movement_vector_dot = VectorDot( movement_vector, right_base );
        
        forward_movement_strength = movement_strength * movement_vector_dot;
        right_movement_strength = movement_strength * right_movement_vector_dot;
        
        
        animtime = player_spot GetAnimTime( curanim );
        level.forward_animtime = animtime;
        animlength = GetAnimLength( curanim );
        anim_fraction = animtime / animlength;


        right_animtime = player_spot GetAnimTime( cur_right_anim );
        level.right_animtime = player_spot GetAnimTime( cur_right_anim );
        
        right_animlength = GetAnimLength( cur_right_anim );
        right_anim_fraction = right_animtime / right_animlength;
        
        forward_offset = 0.08;
        
        if ( movement_strength == 0 )
        {
            if ( movement_updated )
                player_spot SetAnim( curanim, 1, 0.2, 0 );
            if ( right_movement_updated )
                player_spot SetAnim( cur_right_anim, 1, 0.2, 0 );
            movement_updated = false;
            right_movement_updated = false;
            continue;
        }
        else if ( forward_movement_strength < 0 )
        {
            destanim = %london_player_truck_player_move_back;
            if ( curanim != destanim )
                anim_fraction = 1 - anim_fraction;
            anim_fraction = clamp( anim_fraction, forward_offset, 1.0  );
        }
        else
        {
            destanim = %london_player_truck_player_move_forward;
            if ( curanim != destanim )
                anim_fraction = 1 - anim_fraction;
            anim_fraction = clamp( anim_fraction, 0, 1.0 - forward_offset );
        }
        
        if ( right_movement_strength < 0 )
        {
            cur_right_destanim = %london_player_truck_player_move_left;
            if ( cur_right_anim != cur_right_destanim )
                right_anim_fraction = 1 - right_anim_fraction;
        }
        else
        {
            cur_right_destanim = %london_player_truck_player_move_right;
            if ( cur_right_anim != cur_right_destanim )
                right_anim_fraction = 1 - right_anim_fraction;
        }
        
        if( movement_updated || right_movement_updated )
        {
            should_stop_bob = false;
            if( right_movement_vector_dot > 0.7 && right_anim_fraction > 0.9 )
                should_stop_bob = true;
            if( movement_vector_dot > 0.7 && anim_fraction > 0.8 )
                should_stop_bob = true;
            if ( right_movement_vector_dot < -0.7 && right_anim_fraction > 0.9 )
                should_stop_bob = true;
            if ( movement_vector_dot < -0.7 && anim_fraction > 0.9 )
                should_stop_bob = true;
                
            avg_move = abs( forward_movement_strength ) + abs ( movement_strength ) ;
            avg_move = avg_move* 0.5;
            
            
            bobstopped = false;
            if( should_stop_bob )
            {
                player_spot ClearAnim( bob, 0.35 );
                bobstopped = true;
            }
            else if( player_spot GetAnimTime( bob ) == 1 || bobstopped)
                player_spot SetAnimRestart( bob, bobscale * avg_move, 0.25, bobrate*avg_move );
            else
                player_spot SetAnim( bob, bobscale * avg_move, 0.15,bobrate*avg_move );
        }
        else
        {
            bobstopped = true;
            player_spot ClearAnim( bob, 0.35 );
        }
        
        movement_updated = true;
        right_movement_updated = true;

        if ( curanim != destanim )
            player_spot ClearAnim( curanim, 0 );
        
        if ( cur_right_anim != cur_right_destanim )
            player_spot ClearAnim( cur_right_anim, 0 );
        
        player_spot SetAnim( destanim, 1, 0, abs( forward_movement_strength ) * FORWARD_SCALE );
        player_spot SetAnimTime( destanim, anim_fraction );
        curanim = destanim;

        player_spot SetAnim( cur_right_destanim, 1, 0, abs( right_movement_strength ) * SIDE_SCALE );
        player_spot SetAnimTime( cur_right_destanim, right_anim_fraction );
        cur_right_anim = cur_right_destanim;
    }
}

stop_manage_player_position( player_spot )
{
    player_spot notify ( "stop_manage_player_position" );
    player_spot SetAnim( %london_player_truck_player_move_forward, 1, 1, 1 );
    player_spot ClearAnim( %london_player_truck_player_move_back, 1 );
    player_spot ClearAnim( %london_player_truck_player_move_right, 1 );
    player_spot ClearAnim( %london_player_truck_player_move_left, 1 );
    wait 1;
    player_spot ClearAnim( %london_player_truck_player_move_forward, 0 );

}
