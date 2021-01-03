#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\cp_mi_sing_blackstation_utility;
#using scripts\cp\cp_mi_sing_blackstation_comm_relay;
#using scripts\cp\cp_mi_sing_blackstation_station;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "string", "CP_MI_SING_BLACKSTATION_CROSS_BRIDGE" );

function objective_cross_debris_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_cross_debris" );
		blackstation_utility::init_kane( "objective_blackstation_exterior" );
		
		level thread water_visual();
	}
	
	level clientfield::set( "water_level", 3 );
	
	level thread blackstation_utility::player_rain_intensity( "heavy" );
	level thread cross_debris_waypoints();
	level thread water_current();
	level thread building_collapse();
	level thread frogger_whirlpool_death();
	level thread building_sink();
	level thread walkway_collapse();
	level thread atrium_destruction();
	
	if ( b_starting )
	{
		level flag::wait_till( "all_players_connected" );
	}
	
	level.ai_hendricks thread cross_debris_dialog();
	level.ai_hendricks thread hendricks_behavior();
}

function objective_cross_debris_done( str_objective, b_starting, b_direct, player )
{
	if ( isdefined( level.ai_kane ) )
	{
		level.ai_kane skipto::teleport_single_ai( struct::get( "kane_ziplines" , "script_noteworthy" ) );
	}
	
	objectives::complete( "cp_standard_follow_breadcrumb" , level.ai_hendricks );
}

function cross_debris_waypoints()
{
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_cross_debris01" ) );
	
	trigger::wait_till( "trig_waypoint_cross_debris01" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_cross_debris01" ) );
	
	level flag::wait_till( "building_collapse" );
	
	trigger::wait_till( "trig_waypoint_cross_debris02" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_cross_debris02" ) ); //this gets set in dialog function
	
	skipto::objective_completed( "objective_cross_debris" );
}

function cross_debris_dialog()  //self = hendricks
{
	self dialog::say( "Kane, the orders are sent. 54I are holding at the station for now." , 1 );
	
	level dialog::remote( "Copy that. I'm in position." , 1 );
	
	level flag::wait_till( "walkway_collapse" );
	
	self dialog::say( "What was that?!" , 1 );
	level dialog::remote( "The flooding is destabilizing those structures, you need to get out." );
	
	if ( !level flag::get( "at_makeshift_bridge" ) )
	{
		level thread dialog::remote( "There's a crossing nearby, feeding to your DNI." );
	
		objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_cross_debris01" ) );
	}
	
	level flag::wait_till( "at_makeshift_bridge" );
	
	self dialog::say( "Stick behind me. Let's take this slowly." );
	
	level notify( "hendricks_on_bridge" );
	
	level flag::wait_till( "begin_building_collapse" ); //flag set on trigger in radiant

	level.ai_hendricks dialog::say( "Oh shit - it's falling right on us!" , 0.5 );
	
	level flag::wait_till( "player_in_house" );
	
	self dialog::say( "Still alive? Good. Now get out of there." , 2 );
	
	level flag::wait_till( "player_reached_top" );
	
	objectives::set( "cp_standard_breadcrumb" , self );
	
	if ( !level flag::get( "midway_impact" ) )
	{
		self dialog::say( "See me? You need to find a way over here." );
		
		level flag::wait_till( "midway_impact" );
	}
	
	self dialog::say( "Hold on - it's coming this way now!" );	
		
	level flag::wait_till( "path_is_open" );
	
	objectives::complete( "cp_standard_breadcrumb" , self );
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_cross_debris02" ) );
	
	self dialog::say( "Jump!" , 1 );
}

function hendricks_behavior() //self = hendricks
{
	self SetGoal( GetNode( "hendricks_bridge_start" , "targetname" ) , true );
	
	level waittill( "hendricks_on_bridge" );
	
	level thread queue_players_for_bridge();

	s_start = struct::get( "bridge_start" );
	
	mdl_ai_mover = util::spawn_model( "tag_origin", self.origin, self.angles );
	
	self LinkTo( mdl_ai_mover , "tag_origin" );
	
	mdl_ai_mover RotateTo( s_start.angles , 1 );
	mdl_ai_mover MoveTo( s_start.origin , 1 );	//HACK in case Hendricks isn't at bridge
	mdl_ai_mover waittill( "rotatedone" );
	
	while ( !level flag::get( "begin_building_collapse" ) )
	{
		e_closest_player = util::get_closest_player( mdl_ai_mover.origin , "allies" );
		
		n_dist = Distance( mdl_ai_mover.origin , e_closest_player.origin );
		
		if ( n_dist < 200 ) 
		{
			mdl_ai_mover MoveTo( mdl_ai_mover.origin + (16,0,0) , 0.25 );
		
			mdl_ai_mover waittill( "movedone" );
		}
		else
		{
			wait .25; //wait for player if they're not close
		}
	}
	
	wait 0.5; //wait for building to move a bit before running away
	
	mdl_ai_mover Delete();
	
	GetEnt( "bridge_player_clip" , "targetname" ) Delete(); //this clip blocks the entrance of the bridge, not needed by this point
	
	self SetGoal( GetNode( "hendricks_bridge_end" , "targetname" ) );
	
	level flag::wait_till( "player_reached_top" );
	
	wait 2; //keep Hendricks in place for a moment before moving out, make sure player sees him
	
	self SetGoal( GetNode( "hendricks_crossdebris_landing" , "targetname" ) );
}

function queue_players_for_bridge()
{	
	level thread bridge_move_hint();
	
	level endon( "bridge_collapsed" );
	
	while ( 1 )
	{
		t_bridge_queue = trigger::wait_till( "trig_player_on_bridge" , "targetname" );
	
		level flag::set( "bridge_start_blocked" );
	
		t_bridge_queue.who thread player_movement_on_bridge();
	
		while ( level flag::get( "bridge_start_blocked" ) )
		{
			wait 0.25;
		}
	}
}

function bridge_move_hint() //TODO make this show up on each individual player as they get on the bridge. right now it plays for everyone, and only when the first player gets on.
{
	trigger::wait_till( "trig_player_on_bridge" , "targetname" );
	
	level thread util::screen_message_create( &"CP_MI_SING_BLACKSTATION_CROSS_BRIDGE" , undefined , undefined , 0 , 5 );
}

function player_movement_on_bridge() //self = player on bridge
{
	//TODO need another end condition in case player doesn't ever get on bridge
	self endon( "death" );
	
	self.b_on_bridge = true;
	
	self SetLowReady( true ); //TODO replace with first person slow-walk animation
	
	mdl_playermover = util::spawn_model( "tag_origin", self.origin, self.angles );
	
	self PlayerLinkToDelta( mdl_playermover , "tag_origin" , 0 , 45 , 45 , 45 , 45);
	
	s_start = struct::get( "bridge_start" );
	
	mdl_playermover MoveTo( s_start.origin , 2 );
	mdl_playermover RotateTo( s_start.angles , 2 );
	
	mdl_playermover waittill( "movedone" );
	
	a_players_off_bridge = GetPlayers( "allies" );
	
	for ( i = 0; i < a_players_off_bridge.size; i++ )
	{
		if ( a_players_off_bridge[i].b_on_bridge === true ) //find all players on the bridge and remove from array
		{
			ArrayRemoveIndex( a_players_off_bridge , i );
			
			i--;
		}
	}
	
	if ( a_players_off_bridge.size > 0 ) //if not, the array was empty so no need to move player
	{		
		mdl_playermover MoveX( a_players_off_bridge.size * 50 , a_players_off_bridge.size * 0.5 ); //move player out of the way to prevent stacking/clipping
		
		mdl_playermover waittill( "movedone" );
	}
	
	level flag::set_val( "bridge_start_blocked" , false );
	
	const FORWARD_THRESHOLD = 0.2;
	const DISTANCE_THRESHOLD = 32;
	const n_step_dist = 8;
	const n_step_time = .1;
	
	while ( self.b_on_bridge == true )
	{	
		v_stick = self GetNormalizedMovement();
		n_forward = v_stick[0];
		
		if ( n_forward > FORWARD_THRESHOLD )
		{
			a_players = GetPlayers( "allies" );
			
			if ( a_players.size == 1 )
			{
				mdl_playermover MoveX( n_step_dist , n_step_time );
				mdl_playermover waittill( "movedone" );
			}
			else
			{
				ArrayRemoveValue( a_players , self );
				
				e_closest_player = ArraySort( a_players , self.origin , true , 1 )[0];

				n_dist = Distance( e_closest_player.origin , self.origin );	
			
				if ( n_dist > DISTANCE_THRESHOLD && e_closest_player.origin[0] > self.origin[0] )
				{
					mdl_playermover MoveX( n_step_dist , n_step_time );
					mdl_playermover waittill( "movedone" );
				}
				else if ( e_closest_player.origin[0] <= self.origin[0] ) //checks if the closest player is behind me and moves me forward if so. prevents stacking/clipping into other players.
				{
					mdl_playermover MoveX( n_step_dist , n_step_time );
					mdl_playermover waittill( "movedone" );
				}
				else 
				{
					//too close to move right now, nudge forward to give some feedback
					mdl_playermover MoveX( 2 , 0.1 );
					mdl_playermover waittill( "movedone" );
					
					b_path_clear = false;
					
					while ( n_forward > FORWARD_THRESHOLD && b_path_clear == false && self.b_on_bridge == true ) //wait for stick release or close player to move out of the way
					{
						wait .1;
						
						n_dist = Distance( e_closest_player.origin , self.origin );
						
						if ( n_dist > DISTANCE_THRESHOLD ) //not blocked by another player, resume movement
						{
							b_path_clear = true; //leave this loop
						}
						else
						{
							v_stick = self GetNormalizedMovement();
							n_forward = v_stick[0];
						}
					}
					
					if ( n_forward <= FORWARD_THRESHOLD )
					{
						mdl_playermover MoveX( -2 , 0.1 ); //nudge back if player lets go of stick
						mdl_playermover waittill( "movedone" );
					}
				}
			}
		}
		else
		{
			{wait(.05);};
		}
	}
	
	mdl_playermover Delete();
	
	//make any player still on bridge move slowly for a moment after bridge collapse, so players don't accidentally move off bridge right away
	if ( self.b_in_house === false )
	{
		self AllowJump( false );
		self AllowDoubleJump( false );
		
		x = 0.1;
		
		while ( x < 1 )
		{
			self SetMoveSpeedScale( x );
			
			wait .25;
			
			x = x + 0.1;
		}
		
		self.b_in_house = undefined;
		x = undefined;
		
		self AllowJump( true );
		self AllowDoubleJump( true );
		self SetLowReady( false );
	}
}

// PRE-BRIDGE THINGS ///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//TODO - replace with FXAnim
function walkway_collapse()
{
	level flag::wait_till( "walkway_collapse" ); //flag set on trigger in radiant
	
	foreach( player in level.players )
	{
		player PlayRumbleOnEntity( "cp_blackstation_building_lean_rumble" );
	}
	
	a_e_walkway = GetEntArray( "power_bridge", "targetname" );
	
	foreach( e_walkway in a_e_walkway )
	{
		e_walkway RotatePitch( -6, 0.5 );
		e_walkway MoveZ( -6, 0.5 );
	}
	
	wait 1; //wait for first motion to finish
	
	foreach( e_walkway in a_e_walkway )
	{
		e_walkway RotateRoll( 6, 1.5 );
		e_walkway MoveZ( -3, 1 );
	}
}

function atrium_destruction()
{
	level endon( "begin_building_collapse" );
	
	a_s_windows = struct::get_array( "crossdebris_window" );
	
	flag::wait_till( "walkway_collapse" ); //set on trigger in radiant
	
	while ( a_s_windows.size >= 2 )
	{	
		foreach( player in level.players )
		{
			player PlayRumbleOnEntity( "cp_blackstation_building_lean_rumble" );
			
			player SetMoveSpeedScale( 0.1 ); //slow player very briefly when rumble hits //TODO look into making this a util function, to "stumble" the player during a screenshake moment
		}
		
		for ( i = 0 ; i < 2 ; i++ )
		{
			s_breaker = array::random( a_s_windows );
	
			GlassRadiusDamage( s_breaker.origin , 10 , 500 , 500 );
		
			ArrayRemoveValue( a_s_windows , s_breaker );
			
			wait RandomFloat( 0.2 ); //tiny timing offset for each window
		}
		
		foreach( player in level.players )
		{			
			player SetMoveSpeedScale( 1 );
		}
		
		wait RandomFloatRange( 2 , 4 ); //wait before breaking more
		
		flag::wait_till( "in_atrium" ); //set on trigger in radiant
		
		if ( !level flag::get( "atrium_rubble_dropped" ) ) //set on trigger in radiant
		{
			//TODO replace with FX Anim
			e_rubble = GetEnt( "crossdebris_rubble_drop" , "targetname" );
			e_rubble PhysicsLaunch();
			
			level flag::set( "atrium_rubble_dropped" );
			
			v_origin = struct::get( "crossdebris_rubble_impact" ).origin;
			
			RadiusDamage( v_origin , 800 , 5 , 5 );
		}		
	}
}

// MOVING BUILDINGS SEQUENCE ///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

function splash_fx() //TODO temp fx
{
	wait 1.5; //wait for building to collapse into water a bit
	
	s_wave = struct::get( "crossdebris_wave_fx01" ); 
	fx::play( "wave_pier", s_wave.origin , s_wave.angles , 3 );
}

//TODO - replace with FXAnim
function building_collapse()
{
	e_linkto = GetEnt( "linker_building_collapse", "targetname" );
	
	t_inside = GetEnt( "trigger_in_house", "targetname" );
	t_inside EnableLinkTo();
	t_inside LinkTo( e_linkto ); 

	a_t_house = GetEntArray( "trig_collapsed_house", "script_noteworthy" );
	foreach ( t_house in a_t_house )
	{
		t_house EnableLinkTo();
		t_house LinkTo( e_linkto ); 
	}
	
	a_e_landing = GetEntArray( "building_bridge_landing" , "targetname" ); //4 landing spots in house for after bridge collapse
	
	foreach( e_landing in a_e_landing )
	{
		e_landing LinkTo( e_linkto );
	}
	
	a_e_parts = GetEntArray( "frogger_building_collapse", "targetname" );
	
	foreach( e_part in a_e_parts )
	{
		e_part LinkTo( e_linkto );
	}
	
	a_e_platforms = GetEntArray( "frogger_platform", "script_noteworthy" );

	foreach( e_platform in a_e_platforms )
	{
		e_platform SetMovingPlatformEnabled( true );
	}
	
	e_linkto MoveX( 100 , 0.05 ); //TODO Temp, trying to reposition house better, should ultimately be moved in radiant
	
	level flag::wait_till( "tease_building_collapse" );//flag set on trigger in radiant

	foreach( player in level.players )
	{
		player PlayRumbleOnEntity( "cp_blackstation_building_lean_rumble" );
	}
	
	e_linkto MoveZ( -60 , 0.5 );
	e_linkto RotatePitch( -5, 1 );
	e_linkto waittill( "rotatedone" );
	
	level flag::wait_till( "begin_building_collapse" ); //flag set on trigger in radiant
	
	level thread slow_motion_collapse();

	foreach( player in level.players )
	{
		player PlayRumbleOnEntity( "cp_blackstation_building_lean_rumble" );
	}
	
	level thread splash_fx();
	
	e_linkto RotateTo( ( -80 , -3 , 8 ) , 2.25 );
	e_linkto waittill( "rotatedone" );
	
	level flag::set( "stop_slow_mo" );
	
	t_bridge = GetEnt( "trig_bridge_collapse_area" , "targetname" );
	
	b_player_sent_to_house = false;
	
	foreach ( player in level.players )
	{
		if ( player IsTouching( t_bridge ) ) //grab any players currently on collapsing section of bridge
		{	
			b_player_sent_to_house = true;
			
			ArraySortClosest( a_e_landing , player.origin );
			
			player.landing = a_e_landing[0];
			
			ArrayRemoveIndex( a_e_landing , 0 );
			
			player thread player_jump_into_house(); //move players on bridge into building
		}
		else
		{
			player.b_in_house = false; //used to identify players that did not get pulled into house
			player.b_on_bridge = false; //frees player from restricted controls
		}
		
		player PlayRumbleOnEntity( "cp_blackstation_building_collapse_rumble" );
	}
	
	e_linkto MoveZ( -20, 1 );
	e_linkto RotatePitch( -8, 1 );
	e_linkto waittill( "movedone" );

	level thread bridge_collapse();
	
	level flag::set( "bridge_collapsed" );
	
	if ( b_player_sent_to_house )
	{
		e_linkto MoveTo( struct::get( "building_moveto_midway" ).origin + (-300,0,50) , 40 );
		e_linkto RotateRoll( 65, 40 );
		
		level flag::wait_till( "player_in_house" );
		
		a_e_debris = GetEntArray( "frogger_building_debris", "script_noteworthy" );
		
		foreach( e_debris in a_e_debris )
		{
			e_debris Unlink();
			e_debris PhysicsLaunch( e_debris.origin , ( 0 , 0 , RandomIntRange( -5 , 0 ) ) );
			e_debris thread util::deleteaftertime( 10 );
		}
		
		level thread house_wall_break();
		
		level flag::wait_till_timeout( 20 , "house_bottom_empty" );
	}
	
	e_linkto MoveTo( struct::get( "building_moveto_midway" ).origin , 15 );
	e_linkto RotateRoll( 65, 15 );
	e_linkto waittill( "movedone" ); //hits near bank, starts to rotate
	
	foreach( player in level.players )
	{
		player PlayRumbleOnEntity( "cp_blackstation_building_lean_rumble" );
	}	
	
	level flag::set( "midway_impact" );
	
	e_linkto MoveTo( struct::get( "building_moveto_landing" ).origin + (0,0,75) , 10 , 5 , .05 );
	e_linkto RotateRoll( -20, 10 );
	
	wait 3;
	level notify( "stage_1" );
	
	wait 4;
	level notify( "stage_2" );
	
	//e_linkto waittill( "movedone" ); //hits landing building
	
	wait 2;
	
	level flag::set( "building_teeter" );
	
	foreach( player in level.players )
	{
		player PlayRumbleOnEntity( "cp_blackstation_building_collapse_rumble" );
	}
	
	wait .5; //brief pause to let rumble finish before house starts moving away
	
	e_linkto MoveTo( struct::get( "building_moveto_final" ).origin , 20 );
	e_linkto RotateRoll( -40, 20 );
}

function bridge_collapse() //TODO replace with FX Anim
{
	GetEnt( "crossdebris_bridge_rope1" , "targetname" ) Delete();
	GetEnt( "crossdebris_bridge_rope2" , "targetname" ) Delete();
	
	a_mdl_bridge = GetEntArray( "crossdebris_bridge_piece" , "targetname" );
	
	foreach ( mdl_piece in a_mdl_bridge )
	{
		mdl_piece PhysicsLaunch( mdl_piece.origin , ( 0 , -100 , 0 ) );
		mdl_piece thread util::deleteaftertime( 10 );
	}
}

function slow_motion_collapse()
{
	level endon( "building_teeter" );	
	
	level thread slow_mo_delay_check(); //prevents slow mo if all players are NOT looking at building collapse area within a short time
	
	trigger::wait_till( "trig_slow_mo_check" , "targetname" ); //trigger requires all players be in it
	
	s_look_target = struct::get( "slow_mo_look_check" );
	
	foreach ( player in level.players )
	{
		if ( !player util::is_looking_at( s_look_target, 0.5 ) ) //make sure all players are looking
		{
			level flag::set( "cancel_slow_mo" );
		}
	}
	
	if ( !level flag::get( "cancel_slow_mo" ) )
	{   
		const n_timescale = .333;
		const n_default = 1.0;
		const n_time_start = 2;
		const n_time_end = 0.25;
		
		SetSlowMotion( n_default, n_timescale, n_time_start );
		
		level flag::wait_till( "stop_slow_mo" );
		
		SetSlowMotion( n_timescale , n_default, n_time_end );
	}
}

function slow_mo_delay_check()
{
	wait .5;
	
	level flag::set( "cancel_slow_mo" );
}

function house_wall_break()  //TODO - commenting out until replaced with FXAnim
{	
//	trigger::wait_till( "trig_house_wall_break" , "targetname" );
	
	a_e_wall = GetEntArray( "frogger_building_wall_piece" , "script_noteworthy" );
	
	foreach( e_wall in a_e_wall )
	{
		e_wall Delete();
//		e_wall Unlink();
//		e_wall PhysicsLaunch();
//		e_wall thread util::deleteaftertime( 5 );
	}
}

//TODO replace with animated scene
function player_jump_into_house() //self = player
{
	self.b_on_bridge = false;
	
	mdl_playermover = util::spawn_model( "tag_origin", self.origin, self.angles );
			
	self PlayerLinkTo( mdl_playermover , "tag_origin" );  //link them and drop them into the building
	
	mdl_playermover Movez( 35 , 0.5 ); //player jumps up
	mdl_playermover waittill( "movedone" );
	
	mdl_playermover MoveTo( self.landing.origin + (0,0,150) , 0.5 ); //player jumps into house
	mdl_playermover waittill( "movedone" );
	
	mdl_playermover MoveTo( self.landing.origin , 0.5 ); //player drops down to bottom of house //TODO should set angles/rotation so player is facing the right way
	mdl_playermover waittill( "movedone" );
	
	mdl_playermover MoveTo( self.landing.origin , 0.05 ); //HACK to make sure player gets in right place (landing is a moving target)
	mdl_playermover waittill( "movedone" );
	
	mdl_playermover Delete();
	
	self SetOrigin( self.landing.origin );
	
	self.landing = undefined;
	
	level flag::set( "player_in_house" );
	
	self thread player_in_house();
}

function player_in_house() //self = player in house
{
	self endon( "death" );
	
	const n_house_move_speed = 0.75;
	
	self SetMoveSpeedScale( n_house_move_speed );
	
	self DoDamage( 10 , self.origin );
	
	self thread house_rumble( n_house_move_speed );
	
	while ( self IsTouching( GetEnt( "trig_collapsed_house" , "targetname" ) ) )
	{
		wait 0.05;
	}
	
	self notify( "player_left_house" );
	
	self SetMoveSpeedScale( 1 );
	
	self SetLowReady( false );
}

function house_rumble( n_house_move_speed ) //self = player in house
{
	self endon( "player_left_house" );
	
	self PlayRumbleOnEntity( "cp_blackstation_building_collapse_rumble" ); //rumble every couple seconds
	
	self SetMoveSpeedScale( 0.1 ); //get slowed while rumbling
	
	wait 1.75; //wait for rumble to finish
	
	self SetMoveSpeedScale( n_house_move_speed ); //back to in-house speed after a brief delay	
	
	trigger::wait_till( "trig_house_wall_break" , "targetname" );
	
	while ( !level flag::get( "building_teeter" ) )
	{	
		self PlayRumbleOnEntity( "cp_blackstation_building_lean_rumble" ); //rumble every couple seconds
		
		self SetMoveSpeedScale( 0.1 ); //get slowed while rumbling
		
		wait RandomFloatRange( 0.5 , 1 );
		
		self SetMoveSpeedScale( n_house_move_speed ); //back to in-house speed after a brief delay
		
		wait RandomFloatRange( 2 , 3 );
	}
}

function building_sink()
{
	level flag::wait_till( "midway_impact" );
			
	a_building_1 = GetEntArray( "frogger_broken_wall_bottom_1", "targetname" );
	a_building_2 = GetEntArray( "frogger_broken_wall_bottom_2", "targetname" );
	a_building_3 = GetEntArray( "frogger_broken_wall", "targetname" );
	
	e_linkto = GetEnt( "linker_building_sink", "targetname" );
	
	level waittill( "stage_1" );
	
	foreach ( e_part in a_building_1 )
	{
		e_part Delete();
	}
	
	level waittill( "stage_2" );
	
	foreach ( e_part in a_building_2 )
	{
		e_part Delete();
	}
	
	level flag::wait_till( "building_teeter" );
	
	foreach ( e_part in a_building_3 )
	{
		e_part LinkTo( e_linkto );
	}
	
	e_linkto MoveZ( -20, 0.5 );
	e_linkto RotateRoll( 25, 0.5 );
	
	wait 0.5;  //dramatic pause
	
	foreach( player in level.players )
	{
		player PlayRumbleOnEntity( "cp_blackstation_building_collapse_rumble" );
	}
	
	level flag::set( "path_is_open" );
	
	e_linkto MoveZ( -300, 3 );
	e_linkto RotateRoll( 80 , 3 ); 
	e_linkto waittill( "movedone" );
	e_linkto Delete();
	
	level flag::set( "building_collapse" ); 
}

// WATER AND FLOODING //////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function water_current()
{
	s_water = struct::get( "frogger_water_direction" );
	
	t_safe = GetEnt( "trigger_low_current", "targetname" );
	t_house = GetEnt( "trig_collapsed_house", "targetname" );
	t_landing = GetEnt( "trig_landing_water" , "targetname" );
	t_inside = GetEnt( "trigger_in_house", "targetname" );
	
	while( true )
	{
		foreach( player in level.players )
		{
			if ( player DepthOfPlayerInWater() > 0 && !isdefined( player.b_whirlpool ) && !player IsTouching( t_inside ) )
			{
				v_dir = AnglesToForward( ( 0, s_water.angles[1], 0 ) );	
				
				if ( player IsTouching( t_house ) )
				{
					n_push_strength = 0;
				}
				else if ( player IsTouching( t_safe ) || player IsTouching( t_landing ) )
				{
					n_push_strength = 15;
				}
				else
				{
					n_push_strength = 45;
				}
			
				v_velocity = player GetVelocity() + ( v_dir * n_push_strength );

				player SetVelocity( v_velocity );
			}
		}

		wait 0.1;
	}
}

//TODO replace with FXAnim
function water_visual()
{
	a_s_start = struct::get_array( "water_fx_start" );
	
	foreach ( s_water in a_s_start )
	{
		s_water thread water_visual_movement();
	}
}

function water_visual_movement() //self = struct from where water fx spawns
{
	level endon( "blackstation_exterior_engaged" );
	
	v_goal = struct::get( self.target ).origin;
	
	n_speed = Distance( v_goal , self.origin ) * .0018; //approximating terrifying water speed
	
	while ( 1 )
	{
		mdl_tag = util::spawn_model( "tag_origin", self.origin, self.angles );
		
		mdl_tag fx::play( "wave_pier", self.origin , self.angles - (90,0,0) , "movedone" , true , "tag_origin" );
		
		mdl_tag MoveTo( v_goal , n_speed );
		
		mdl_tag thread delete_on_movedone();
		
		wait 0.75; //spawn waves this often
	}
}

function delete_on_movedone() //self = water fx entity
{
	self waittill( "movedone" );
	
	self Delete();
}

//TODO - replace with FXAnim
function frogger_debris_start()
{
	level endon( "blackstation_exterior_engaged" );
	
	a_s_starts = struct::get_array( "debris_float_start" );
	a_e_debris = array( "p7_debris_junkyard_scrap_pile_01", "p7_debris_junkyard_scrap_pile_02", "p7_debris_junkyard_scrap_pile_03" );
	
	while( 1 )
	{
		s_start = a_s_starts[RandomInt(a_s_starts.size)];
		e_debris = Spawn( "script_model", s_start.origin );
		e_debris SetModel( a_e_debris[RandomInt(a_e_debris.size)] );
		e_debris thread frogger_debris_float( s_start );
		e_debris thread frogger_debris_roll();
		e_debris thread player_hit();
		
		wait RandomFloatRange( 0.8, 1.3 );
	}
}

function frogger_debris_float( s_start )  //self = debris entity
{
	self endon( "death" );
	
	v_goal = struct::get( s_start.target );
	
	self MoveTo( v_goal.origin, 20 );
	self waittill( "movedone" );
	self Delete();
}

function frogger_debris_roll()  //self = debris entity
{
	self endon( "death" );
	
	while( 1 )
	{
		self RotateRoll( RandomIntRange( 80, 110 ), 1 );
		wait 0.9;
	}
}

function player_hit()  //self = debris entity
{
	self endon( "death" );
	
	n_hit_dist_sq = 40*40;
	
	while( 1 )
	{
		foreach( player in level.players )
		{
			if ( !isdefined( player.b_hit ) && DistanceSquared( self.origin, player.origin ) < n_hit_dist_sq  && !player IsTouching( GetEnt( "trig_collapsed_house" , "targetname" ) ) )
			{
				player.b_hit = true;
				player DoDamage( player.health/4, self.origin );
				player PlayRumbleOnEntity( "damage_heavy" );
				
				wait 4;  //don't want player to be continuously hit
				
				player.b_hit = undefined;
			}
		}
		
		wait 0.05;
	}
}

function frogger_whirlpool_death()
{
	level endon( "blackstation_exterior_engaged" );
	
	t_whirlpool = GetEnt( "trigger_whirlpool_death", "targetname" );
	
	while ( 1 )
	{
		t_whirlpool trigger::wait_till();
		
		player = t_whirlpool.who;
		
		if ( !isdefined( player.b_whirlpool ) )
		{
			e_linkto = util::spawn_model( "tag_origin", player.origin, player.angles );
		
			player PlayerLinkToDelta( e_linkto, "tag_origin", 1, 45, 45, 45, 45 );
		
			e_linkto thread drag_player_down( player );
		
			player.b_whirlpool = true;
		}
	}
}

function drag_player_down( player )  //self = entity player is linked to
{
	s_top = struct::get( "whirlpool_top" );
	s_bot = struct::get( "whirlpool_bottom" );
	
	self thread spin_player();
	
	self MoveTo( s_top.origin, 2 );
	self waittill( "movedone" );
	
	self MoveTo( s_bot.origin, 3 );
	self waittill( "movedone" );
	
	self Delete();
	
	player DoDamage( player.health, player.origin );
}

function spin_player() //self = entity player is linked to
{
	self endon( "death" );
	
	while( 1 )
	{
		self RotateYaw( -180, 1 );
		wait 0.9;
	}
}