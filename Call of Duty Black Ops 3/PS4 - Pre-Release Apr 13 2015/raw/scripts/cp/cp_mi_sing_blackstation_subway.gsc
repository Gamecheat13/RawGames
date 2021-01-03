#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\cp_mi_sing_blackstation_utility;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                              	   	                             	  	                                      

#precache( "triggerstring", "CP_MI_SING_BLACKSTATION_CLEAR_OBSTACLE" );

function subway_main()
{
	level thread subway_waypoints();
	level thread subway_completion();
	level thread subway_floating_bodies();
	level thread subway_floating_trash();
	level thread subway_scare_scene_01();
	level thread subway_scare_scene_02();
	level thread subway_scare_scene_03();
	level thread hendricks_swimming();
	level thread subway_dialog();
	level thread hendricks_movement();
	
	//HACK to get hendricks in correct place
	level.ai_hendricks skipto::teleport_single_ai( struct::get( "objective_subway_ai" ) );
	
	//HACK to make sure there are no AI left alive when subway starts. Otherwise stealth behaviors can break. This doesn't check for sight though.
	foreach ( ai in GetAITeamArray( "axis" ) )
	{
		ai Delete();
	}
}

function subway_waypoints()
{
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_subway01" ) );
	
	level flag::wait_till( "flag_waypoint_subway01" );
	
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_subway01" ) );
	
	level notify( "exit_subway" );
}

function subway_completion()
{
	level waittill( "exit_subway" );
	
	wait 2; //delay so dialog won't start as soon as combat ends
	
	level.ai_hendricks thread dialog::say( "Exit's just ahead. Keep moving up." );
	
	skipto::objective_completed( "objective_subway" );
}

function subway_dialog()
{
	level flag::wait_till( "all_players_spawned" );
	
	level.ai_hendricks dialog::say( "Kane, we've cleared the docks and are moving to the rendezvous point." );
	
	level.ai_hendricks dialog::say( "Shortest route is through the subway." , 1 );
	
	level dialog::remote( "Copy that. Your destination is an old police station. The 54 I converted it into a communications hub." , 1 );
}

function hendricks_swimming()
{
	trigger::wait_till( "trig_hendricks_swim" );
	
	level.ai_hendricks.ignoreall = true;
	
	start_struct = struct::get( "hendricks_swim_start" , "targetname" );
	
	//HACK temp teleport hendricks to make sure he's in the right place
	level.ai_hendricks skipto::teleport_single_ai( start_struct );
	
	//spawn mover and link hendricks
	e_mover = util::spawn_model( "tag_origin", start_struct.origin , start_struct.angles );
	//level.ai_hendricks LinkTo( e_mover , "tag_origin" );
	
	e_mover thread scene::play( "cin_blackstation_swim_temp" , level.ai_hendricks ); //TODO need an aligned swim anim scene to play here
	
	n_swim_speed = 180; //approximating swim speed
	
	//TODO temp, move hendricks from struct to struct like he's swimming
	do
	{
		next_struct = struct::get( start_struct.target, "targetname" );
		
		if ( next_struct.targetname == "hendricks_swim04" )
		{
			n_swim_speed = 110; //go slower in the cars
		}
		else if ( next_struct.targetname == "hendricks_swim08" )
		{
			n_swim_speed = 180; //swim fast again
		}
		
		//Snap the guy to face his next node
		new_angles = next_struct.origin - start_struct.origin;
		e_mover.angles = ( 0, VectorToAngles(new_angles)[1], 0 );			
		
		//Calculate move time
		move_time = Distance( next_struct.origin, start_struct.origin ) / n_swim_speed ; 
		e_mover Moveto( next_struct.origin, move_time );
		
		e_mover waittill( "movedone" );
		
		start_struct = next_struct;
	} 
	while( isdefined( start_struct.target ) );
	
	e_mover scene::stop( "cin_blackstation_swim_temp" );
	
	e_mover Unlink();
	e_mover Delete();
	
	level.ai_hendricks notify( "move_to_subway_exit" );
	
}

function hendricks_movement()
{
	level.ai_hendricks waittill( "move_to_subway_exit" ); 
	
	level flag::wait_till( "flag_hendricks_out_of_water" ); //wait until hendricks touches the end flag
	
	//level notify( "out_of_water" ); //stops ambient dialog
	
	level.ai_hendricks skipto::teleport_single_ai( struct::get( "hendricks_teleport_out_of_water" , "targetname" ) );
	
	trigger::use( "trig_hendricks_color_b2" , "targetname" ); //sends hendricks to next color chain node
	
	level flag::wait_till( "flag_waypoint_subway01" );
	
	waittillframeend; //delay incase the player runs ahead so the color triggers don't fire at the same time 
	
	trigger::use( "trig_hendricks_color_b3" , "targetname" ); //sends hendricks to next color chain node
	
}

function subway_floating_bodies()
{
	level endon( "out_of_water" );
	
	e_floating_bodies = GetEntArray( "subway_corpse_floating", "targetname" );
	
	array::thread_all( e_floating_bodies, &subway_floating_bodies_move );
}

function subway_floating_bodies_move() //self == floating body
{
	level endon( "out_of_water" );
	
	e_body = self;
	
	n_rotate_angle = 60;
	
	while ( true )
	{
		e_body RotatePitch( n_rotate_angle, 5 );
		
		wait 4.5; //Wait for the rotation to compelete before starting again
	}
			
}

function subway_floating_trash()
{
	level endon( "out_of_water" );
	
	e_floating_trash = GetEntArray( "floating_trash", "targetname" );

	array::thread_all( e_floating_trash, &subway_floating_trash_move );	
}

function subway_floating_trash_move() //self == floating trash
{
	level endon( "out_of_water" );
	
	e_trash = self;
	
	while ( true )
	{
		n_rand_case = RandomInt( 3 );
		n_rand_move = RandomFloatRange( 6, 10 );
		n_rand_time = RandomFloatRange( 5, 6 );
		n_move_back = 0;
		n_move_back = n_move_back - n_rand_move;
			
		switch ( n_rand_case )
		{
			case 0:
				e_trash MoveX( n_rand_move, n_rand_time );
				wait ( n_rand_time - 0.25 );
				e_trash MoveX( n_move_back, n_rand_time );
			break;
				
			case 1:
				e_trash MoveY( n_rand_move, n_rand_time );
				wait ( n_rand_time - 0.25 );
				e_trash MoveY( n_move_back, n_rand_time );
			break;
			
			case 2:
				e_trash MoveZ( n_rand_move, n_rand_time );
				wait ( n_rand_time - 0.25 );
				e_trash MoveZ( n_move_back, n_rand_time );
			break;
		}
		
		wait ( n_rand_time - 0.50 );		
	}	
}

function subway_scare_scene_01()
{
	level endon( "out_of_water" );
	level endon( "cancel_scare" );
	
	//level thread cancel_scare();
	
	t_trigger = GetEnt( "trig_subway_scare" , "targetname" );
	
	t_trigger waittill( "trigger" , player );
	
	level notify( "scare_happened" );
	
	level thread corpse_dialog( player );
	
	e_corpse = GetEnt( "subway_corpse" , "targetname" );
	
	e_corpse MoveY( -24 , 0.75 );
	e_corpse RotateRoll( 60 , 5 );
	
	e_corpse waittill( "movedone" );
	
	e_corpse MoveTo( e_corpse.origin - (0,50,50) , 5 );
}

function cancel_scare() //this triggers if player gets in a position where the scare scene would look bad
{
	level endon( "out_of_water" );
	level endon( "scare_happened" );
	
	trigger::wait_till( "trig_subway_scare_off" );
	
	level notify( "cancel_scare" );
	
	GetEnt( "subway_corpse" , "targetname" ) Hide();
}

function subway_scare_scene_02()
{
	level endon( "out_of_water" );
	
	t_trigger = GetEnt( "trig_subway_scare_2" , "targetname" );
	
	e_corpse = GetEnt( "subway_corpse_2" , "targetname" );
	
	level waittill ( "scare_happened" );
	
	t_trigger waittill( "trigger" , player );
	
	e_corpse MoveX( -80 , 2 );
	e_corpse RotatePitch( 60 , 5 );
	
	e_corpse waittill( "movedone" );
	
	e_corpse MoveTo( e_corpse.origin - (0,-50, 50) , 5 );
}

function subway_scare_scene_03()
{
	level endon( "out_of_water" );
	
	t_trigger = GetEnt( "trig_subway_scare_3" , "targetname" );
	
	e_corpse = GetEnt( "subway_corpse_3" , "targetname" );
	
	t_trigger waittill( "trigger" , player );
	
	e_corpse MoveZ( -24 , 0.75 );
	e_corpse RotateRoll( 60 , 5 );
	
	e_corpse waittill( "movedone" );
	
	e_corpse MoveTo( e_corpse.origin - (25,25,75) , 5 );
}

function corpse_dialog( player )
{
	level endon( "out_of_water" );
	
	player dialog::say( "Look out!" , 0.5 );
	
	level.ai_hendricks dialog::say( "Just a corpse." );
	level.ai_hendricks dialog::say( "Got more out here." );
	level.ai_hendricks dialog::say( "Looks like they've been down here since the incident." , 1 );
	
	player dialog::say( "They were just abandoned?" );
	level.ai_hendricks dialog::say( "A lot of things got abandoned back then. Including the Black Station." );
}
