#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_hacking;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\shared\ai_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;

#using scripts\cp\cp_mi_sing_blackstation_cross_debris;
#using scripts\cp\cp_mi_sing_blackstation_utility;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "triggerstring", "CP_MI_SING_BLACKSTATION_HACK_RELAY" );
#precache( "material", "t7_hud_prompt_hack_64" );

function objective_comm_relay_traverse_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_comm_relay_traverse" );
		blackstation_utility::init_kane( "objective_comm_relay_traverse" );
		
		level.ai_hendricks SetGoal( GetNode( "hendricks_intro_end" , "targetname" ) , true ); //send Hendricks to lookout node
		level.ai_kane SetGoal( GetNode( "kane_intro_end" , "targetname" ) , true ); //send Kane to computer node
		level thread blackstation_utility::police_station_corpses();
		level thread blackstation_utility::lightning_flashes( "lightning_looting", "hendricks_at_window" );
	}
	else
	{
		level.ai_kane thread dialog::say( "Good to meet you too, Hendricks." , 1 );
	}
	
	level thread blackstation_utility::player_rain_intensity( "med" );
	
	comm_relay_traverse_main();
}

function objective_comm_relay_traverse_done( str_objective, b_starting, b_direct, player )
{
	
}

function comm_relay_traverse_main()
{
	level thread comm_relay_waypoints();
	level thread comm_relay_dialog();
	level thread cp_mi_sing_blackstation_cross_debris::water_visual();
	level thread breakable_atrium_windows_setup();
	
	level.ai_hendricks thread hendricks_behavior();	
	
	foreach ( player in level.players )
	{
		player thread water_current_by_player();
	}
	
	comm_relay_spawner_setup();
	
	trigger::wait_till( "trig_comm_relay_spawns" , "targetname" );
	
	skipto::objective_completed( "objective_comm_relay_traverse" );
}

function objective_comm_relay_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_comm_relay" );
		blackstation_utility::init_kane( "objective_blackstation_exterior" );
		
		level.ai_hendricks thread hendricks_behavior();
		
		level thread comm_relay_dialog_part2();
		level thread blackstation_utility::lightning_flashes( "lightning_looting", "hendricks_at_window" );
		
		comm_relay_spawner_setup();
		
		trigger::use( "trig_comm_relay_spawns" , "targetname" ); //spawns the ai for this event
	}
	
	comm_relay_main();
}

function comm_relay_spawner_setup()
{
	spawner::add_spawn_function_group( "comm_relay_group01" , "targetname" , &starter_behavior );
	spawner::add_spawn_function_group( "comm_relay_group02" , "targetname" , &reinforcement_behavior );
	spawner::add_spawn_function_group( "comm_relay_patroller" , "script_noteworthy" , &patrol_behavior );
	spawner::add_spawn_function_group( "comm_relay_retreater" , "script_noteworthy" , &retreater_behavior );
	spawner::simple_spawn( "comm_relay_awaken_robot" , &awaken_behavior );
}

function objective_comm_relay_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_blackstation_comm_relay" );
	objectives::set( "cp_level_blackstation_blackstation" );
}

function comm_relay_main()
{
	level thread setup_relay_object();
	level thread track_defenders();
	level thread table_flipper();
	level thread table_flipper_watcher();
	
	spawner::simple_spawn_single( "comm_relay_igc_robot" , &igc_robot );
	
	level flag::wait_till( "comm_relay_engaged" );
	
	spawner::simple_spawn( "comm_relay_back_room_humans" );
	
	level flag::wait_till( "comm_relay_hacked" );
	
	skipto::objective_completed( "objective_comm_relay" );
	
	level.ai_kane skipto::teleport_single_ai( struct::get( "kane_ziplines" , "script_noteworthy" ) );
	level.ai_kane SetGoal( GetNode( "kane_blackstation_exterior" , "targetname" ) );
}

function delete_with_delay() //self = piece of collapsing wall, delete in case it is blocking player path
{
	wait 5;
	self Delete();
}

function water_current_by_player() //self = player
{
	self endon( "death" ); //TODO need another end condition for this, maybe once player reaches black station skipto
	
	t_water = GetEnt( "trig_comm_relay_current" , "targetname" );
	s_current = struct::get( t_water.target );
	
	v_dir = AnglesToForward( ( 0, s_current.angles[1], 0 ) );	
	n_push_strength = 50;	
	
	while ( true )
	{
		while ( self IsTouching( t_water ) )
		{		
			self SetMoveSpeedScale( .5 );
			
			if( self.is_anchored )
			{
				//earthquake and rumble
				self PlayRumbleOnEntity( "fallwind_loop_slow" );
				Earthquake( 0.05, 0.05, self.origin, 128.0 );			
			}
			else
			{
				self SetVelocity( v_dir * n_push_strength );
			}
			
			n_push_strength++; //make current harder to go against the longer you stay in it
			
			{wait(.05);};
		}
		
		self SetMoveSpeedScale( 1 );
		n_push_strength = 50;
		
		t_water waittill( "trigger" );
	}
}

function comm_relay_waypoints()
{
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_comm_relay01" ) );
	
	level flag::wait_till( "flag_waypoint_com_relay01" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_comm_relay01" ) );
	
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_comm_relay02" ) );
	
	trigger::wait_till( "trig_waypoint_comm_relay02" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_comm_relay02" ) );
	
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_comm_relay03" ) );
}

function comm_relay_dialog()
{
	level thread comm_relay_dialog_part2();
	
	level endon( "comm_relay_engaged" );
	
	level flag::wait_till( "comm_relay_dialog01" );
	
	level dialog::remote( "54-I communication codes acquired and sent." );
	level dialog::remote( "Moving out now to Black Station." );
	
	level flag::wait_till( "comm_relay_dialog02" );
	
	level.ai_hendricks dialog::say( "Kane, we're closing on the comms relay. What's your status?" );
	level dialog::remote( "I've got eyes on the Station. Holding here until you arrive" );
}

function comm_relay_dialog_part2()
{
	level flag::wait_till( "comm_relay_dialog03" );
	
	level.ai_hendricks thread dialog::say( "Hostile robots in the relay building. Clear them out first." );
	
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_comm_relay03" ) );
	
	level flag::wait_till( "relay_room_clear" );
	
	level.ai_hendricks dialog::say( "Clear!" , 1 );
	level.ai_hendricks dialog::say( "Now get to work on that relay." );	
}

function setup_relay_object()
{
	level flag::wait_till( "relay_room_clear" ); //flag initialized on use trigger in radiant
	
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_comm_relay03" ) );
	
	t_relay_object = GetEnt( "trig_comm_relay_use" , "targetname" );
	t_relay_object SetCursorHint( "HINT_NOICON" );
	
	v_offset = ( 0, 0, 0 );
	visuals_use_object = [];
	
	e_relay_object = gameobjects::create_use_object( "allies" , t_relay_object , visuals_use_object , v_offset , undefined );
	
	// Setup use object params
	e_relay_object gameobjects::set_use_hint_text( &"CP_MI_SING_BLACKSTATION_HACK_RELAY" );
	e_relay_object gameobjects::set_visible_team( "any" );
	e_relay_object gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_hack_64" );	
	
	level thread hacking_notify( t_relay_object );
	 
	t_relay_object hacking::init_hack_trigger( 3 );
	
	t_relay_object hacking::trigger_wait();
	
	e_relay_object gameobjects::disable_object();
	
	level flag::set( "comm_relay_hacked" );
}

function hacking_notify( t_relay_object )
{
	t_relay_object waittill( "trigger" );
	
	level notify( "hacking_comm_relay" );
}

function igc_robot() //self = robot that dies and falls onto comm relay
{	
	self.allowdeath = false;
	
	self thread proximity_detection();
	
	self.fovcosine = 1; //sets field of view to an angle of 0, effectively blind
	
	trigger::wait_till( "trig_comm_relay_igc_robot" , "targetname" , self );
	
	e_clip = GetEnt( "comm_relay_console_clip" , "targetname" );
	
	e_clip MoveZ( 512 , .05 );
	
	e_clip waittill( "movedone" );
	
	self util::waittill_any( "enemy" , "damage" , "bulletwhizby" , "comm_relay_proximity" , "comm_relay_engaged" );
	
	level flag::set( "comm_relay_engaged" );
	
	self.fovcosine = 0; //sets field of view back to the default 180 degrees
	
	//TODO temp, moving robot corpse on and then off of comm relay, update once custom animations are available
	//////////////////////////////////////////////////////////////////////////////////////////////////
	while ( self.health > 5 )
	{
		wait .05;
	}
	
	level thread scene::init( "black_station_robot_console_start" );
	
	self Delete();
	
	level flag::set( "igc_robot_down" );
	
	level waittill( "hacking_comm_relay" );
	
	level scene::stop( "black_station_robot_console_start" );
	//////////////////////////////////////////////////////////////////////////////////////////////////
}

function hendricks_behavior() //self = hendricks
{
	self.ignoreall = true;
	
	level flag::wait_till( "comm_relay_engaged" );
	
	self.ignoreall = false;
	
	trigger::use( "trig_hendricks_comm_relay01" , "targetname" ); //sends hendricks to next node in color chain, inside comm relay building
	
	level flag::wait_till( "relay_room_clear" );
	
	trigger::use( "trig_hendricks_comm_relay02" , "targetname" ); //sends hendricks to next node in color chain, looking out at biodomes
	
	trigger::wait_till( "trig_comm_relay_use" , "targetname" ); //player interacts with comm relay
	
	trigger::use( "trig_hendricks_comm_relay03" , "targetname" ); //sends hendricks to next node in color chain, at start of cross debris
}

 function starter_behavior() //self = pre-spawned AI guarding comm relay area
{
	self endon( "death" );
	
	self thread proximity_detection();
	
	self.fovcosine = 1; //sets field of view to an angle of 0, effectively blind
	
	self util::waittill_any( "enemy" , "damage" , "bulletwhizby" , "comm_relay_proximity" , "comm_relay_engaged" );
	
	level flag::set( "comm_relay_engaged" );
	
	spawn_manager::enable( "comm_relay_group02_sm" , true );
	
	self.fovcosine = 0; //sets field of view back to the default 180 degrees
	
	if ( self.archetype == "robot" )
	{
		self SetGoal( GetEnt( "comm_relay_goal_volume" , "targetname" ) );
		
		level flag::wait_till( "comm_relay_back_room" );
		
		self SetGoal( GetEnt( "comm_relay_back_volume" , "targetname" ) , true );
		
//		self waittill( "goal" );
//		
//		self ai::set_behavior_attribute( "move_mode" , "rusher" );  //TODO - rushers can't reach player in certain places
	}
}

function proximity_detection() //self = robots guarding comm relay area
{
	self endon( "death" );
		
	trigger::wait_till( "trig_comm_relay_proximity" , "targetname" );
	
	self notify( "comm_relay_proximity" );
}

function reinforcement_behavior() //self = robots spawned as reinforcements
{
	self endon( "death" );
	
	self ai::set_behavior_attribute( "move_mode", "rambo" );
	
//	self waittill( "goal" );
//	
//	self ai::set_behavior_attribute( "move_mode", "rusher" );  //TODO - rushers can't reach player in certain places
}

function patrol_behavior() //self = patrolling robot
{
	self endon( "death" );
	level endon( "comm_relay_engaged" );
	
	next_node = GetNearestNode( self.origin );
	
	do
	{
		self ai::force_goal( next_node , 4 );
		
		self waittill( "goal" );
		
		if ( isdefined( next_node.script_wait_min ) && isdefined( next_node.script_wait_max ) )
		{	
			self ai::force_goal( self.origin + ( AnglesToForward( next_node.angles ) * 16 ) , 4 ); //HACK make robot face direction of patrol node while they wait
			
			wait RandomFloatRange( next_node.script_wait_min , next_node.script_wait_max );
		}
		
		next_node = GetNode( next_node.target , "targetname" );
	}
	while( isdefined( next_node ) );
}

function retreater_behavior() //self = human ai at workstation
{
	self endon( "death" );
	
	//TODO setup sitting/working animation
	
	level flag::wait_till( "comm_relay_engaged" );
	
	self SetGoal( GetEnt( "comm_relay_back_volume" , "targetname" ) , true ); //fall back to other humans when combat begins
}

function awaken_behavior() //self = robot spawning out of charging station
{
	self endon( "death" );
	level endon( "relay_room_clear" );
	
	s_scene = struct::get( self.target ); //target is scriptbundle placed in radiant
	
	s_scene scene::init( s_scene.scriptbundlename , self ); //robot anim
	
	mdl_origin = util::spawn_model( "tag_origin" , s_scene.origin , s_scene.angles + (0,90,0) ); //rotate object to play door scene off of, so they line up correctly
	
	mdl_origin scene::init( "p7_fxanim_cp_sgen_charging_station_open_01_bundle" ); //door anim
	
	level flag::wait_till( "comm_relay_engaged" );
	
	level util::waittill_any_timeout( 45 , "comm_relay_back_room" , "defenders_low" ); //back_room notify set as flag on trigger in radiant
	
	wait RandomInt( 3 ); //randomize spawn timing a bit so they don't all activate at once //TODO stagger activations more, do it in groups of 2 or 3
	
	s_scene thread scene::play( s_scene.scriptbundlename , self );
	
	self.script_noteworthy = "awakened_robot";
	
	level flag::set( "awakening_begun" );
	
	mdl_origin scene::play( "p7_fxanim_cp_sgen_charging_station_open_01_bundle" );
	
	self SetGoal( GetEnt( "comm_relay_back_volume" , "targetname" ) );
}

function track_defenders() //enables the comm relay interaction once all robots are dead
{
	level thread track_defenders_count();
	level thread track_awakened_robot_count();
	
	level flag::wait_till( "comm_relay_back_room" ); //set on trigger in radiant
	
	spawn_manager::kill( "comm_relay_group02_sm" , true );
	
	spawner::waittill_ai_group_count( "comm_relay_defenders", 2 );
	
	level flag::wait_till( "igc_robot_down" );
	
	level flag::wait_till( "no_awakened_robots" );
	
	level flag::set( "relay_room_clear" );
}

function track_defenders_count() //TODO temp workaround until above ai group cleared check works correctly
{
	level flag::wait_till( "comm_relay_engaged" );
	
	spawner::waittill_ai_group_count( "comm_relay_defenders" , 4 ); //number of ai remaining before charging-station robots are activated
	
	level notify( "defenders_low" );
}

function track_awakened_robot_count()
{
	level endon( "relay_room_clear" );
	
	level flag::wait_till( "awakening_begun" );
	
	while ( 1 )
	{
		wait 0.25; //wait between each count check for performance
		
		level.a_awakened_robots = GetAIArray( "awakened_robot" , "script_noteworthy" );
		
		if ( level.a_awakened_robots.size > 0 )
		{
			level flag::set_val( "no_awakened_robots" , false );
		}
		else
		{
			level flag::set( "no_awakened_robots" );
		}
	}
}

function table_flipper_watcher()
{
	e_linker = GetEnt( "e_table_linker" , "targetname" );
	
	foreach( player in level.players )
	{
		player thread table_flipper_sighted( e_linker );
	}
}

function table_flipper_sighted( e_table )  //self = player
{
	level endon( "table_flip" );
	
	n_distsq = 250000;
	
	while( 1 )
	{
		self util::waittill_player_looking_at( e_table.origin, 15, false, self );
		
		if ( Distance2DSquared( self.origin, e_table.origin ) <=  n_distsq )
		{
			level flag::set( "table_flip" );
		}
		
		wait 0.1;
	}
}

//TODO replace with animations
function table_flipper()
{
	level endon( "cancel_table_flip" ); //set on trigger in radiant, if player gets too close to spawn locations
	
	level flag::wait_till( "table_flip" );
		
	spawner::simple_spawn( "comm_relay_table_flippers" );
	
	trigger::wait_till( "trig_table_flip" , "targetname" ); //make sure an AI is in place before flipping
	
	a_table = GetEntArray( "com_relay_table" , "targetname" );
	
	e_linker = GetEnt( "e_table_linker" , "targetname" );
	
	foreach ( ent in a_table )
	{
		ent LinkTo( e_linker );
	}
	
	e_linker RotateRoll( 85 , 0.4 );
	e_linker MoveZ( 20 , 0.4 );
}

function breakable_atrium_windows_setup()
{
	array::thread_all( GetEntArray( "trig_atrium_glass", "targetname" ), &atrium_windows_break );
}

function atrium_windows_break() //self = window damage trigger
{
	self trigger::wait_till();
	
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "atrium_delete_path_clip" )
	{
		GetEnt( "hendricks_window_clip", "targetname" ) delete();
	}
	
	GlassRadiusDamage( self.origin, 10, 500, 500 );
}
