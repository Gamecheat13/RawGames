#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\name_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\shared\ai\zombie_death;
	
                                                                                                                               

#precache( "triggerstring", "ZM_ZOD_ROBOT_NEEDS_POWER" );
#precache( "triggerstring", "ZM_ZOD_ROBOT_ONCALL_IN" );
#precache( "triggerstring", "ZM_ZOD_ROBOT_PAY_TOWARDS" );
#precache( "triggerstring", "ZM_ZOD_ROBOT_SUMMON" );
#precache( "triggerstring", "ZM_ZOD_AREA_NAME_JUNCTION" );
#precache( "triggerstring", "ZM_ZOD_AREA_NAME_SLUMS" );
#precache( "triggerstring", "ZM_ZOD_AREA_NAME_CANAL" );
#precache( "triggerstring", "ZM_ZOD_AREA_NAME_THEATER" );





#namespace zm_zod_robot;

#using_animtree( "generic" );


	// How many digits do we need to display cost

	
function autoexec __init__sytem__() {     system::register("zm_zod_robot",&__init__,undefined,undefined);    }

function __init__()
{
}

function init()
{
	level.ai_robot_remaining_cost = 2000; // init cost
	
	level flag::wait_till("initial_blackscreen_passed");

	level.zombie_robot_spawners = GetEntArray( "zombie_robot_spawner", "script_noteworthy" );
	a_e_triggers = GetEntArray( "robot_activate_trig","targetname" );

	level.a_robot_areanames = array( "junction", "slums", "canal", "theater" );
	
	foreach( str_areaname in level.a_robot_areanames ) // 4 callboxes in the level - they are named in the format "robot_callbox_[1-5]"
	{
		create_callbox_unitrigger( str_areaname, &robot_callbox_trigger_visibility, &robot_callbox_trigger_think );
	}
	
	// watch for someone activating the power to the robot system
	level thread monitor_robot_power();
	
	// update cost readouts throughout the map
	level thread update_readouts_for_remaining_robot_cost();
}

function monitor_robot_power()
{
	level flag::wait_till( "power_on" + 22 );
	
	// TODO: play any cool vfx and sounds for the initial bootup here
}

function create_callbox_unitrigger( str_areaname, func_trigger_visibility, func_trigger_thread )
{
	width = 110;
	height = 90;
	length = 110;
		
	s_callbox = struct::get( "robot_callbox_" + str_areaname, "script_noteworthy" );
	s_callbox.unitrigger_stub = spawnstruct();
	s_callbox.unitrigger_stub.origin = s_callbox.origin;
	s_callbox.unitrigger_stub.angles = s_callbox.angles;
	s_callbox.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_callbox.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_callbox.unitrigger_stub.script_width = width;
	s_callbox.unitrigger_stub.script_height = height;
	s_callbox.unitrigger_stub.script_length = length;
	s_callbox.unitrigger_stub.require_look_at = false;
	s_callbox.unitrigger_stub.str_areaname = str_areaname; // pass this onto the unitrigger stub, so we can see it in the trigger thread
	
	s_callbox.unitrigger_stub.prompt_and_visibility_func = func_trigger_visibility;
	zm_unitrigger::register_static_unitrigger( s_callbox.unitrigger_stub, func_trigger_thread );
}

function robot_callbox_trigger_visibility( player )
{
	b_is_invis = ( isdefined( player.beastmode ) && player.beastmode );
	self setInvisibleToPlayer( player, b_is_invis );

	// possible prompts
	// - callbox needs power
	// - robot is on call
	// - donate X to the Police Fund
	// - donate X to Summon the Police Robot

	if( !( level flag::get( "power_on" + 22 ) ) ) // robot is unpowered
	{
		self SetHintString( &"ZM_ZOD_ROBOT_NEEDS_POWER" );
	}
	else if( isdefined( level.ai_robot ) ) // robot is currently active
	{
		switch( level.ai_robot_area_called )
		{
			case "junction":
				hintstring_areaname = &"ZM_ZOD_AREA_NAME_JUNCTION";
				break;
			case "slums":
				hintstring_areaname = &"ZM_ZOD_AREA_NAME_SLUMS";
				break;
			case "canal":
				hintstring_areaname = &"ZM_ZOD_AREA_NAME_CANAL";
				break;
			case "theater":
				hintstring_areaname = &"ZM_ZOD_AREA_NAME_THEATER";
				break;
		}
		       
		self SetHintString( &"ZM_ZOD_ROBOT_ONCALL_IN", hintstring_areaname );
	}
	else // robot is waiting to be activated - show either the partial contribution hintstring, or the full summon hintstring
	{
		if( player.score < level.ai_robot_remaining_cost ) // Contribute to the Police Fund
		{
			self SetHintString( &"ZM_ZOD_ROBOT_PAY_TOWARDS", player.score, level.ai_robot_remaining_cost );
		}
		else // Summon the Police Robot
		{
			self SetHintString( &"ZM_ZOD_ROBOT_SUMMON", level.ai_robot_remaining_cost );
		}
	}
	
	return !b_is_invis;
}
	
function robot_callbox_trigger_think()
{
	while( true )
	{		
		self waittill( "trigger", player );

		if( player zm_utility::in_revive_trigger() ) // revive triggers override trap triggers
		{
			continue;
		}
			
		if( ( player.is_drinking > 0 ) )
		{
			continue;
		}
		
		if( !zm_utility::is_player_valid( player ) ) // ensure valid player
		{
			continue;
		}
				
		if( isdefined( level.ai_robot ) ) // ensure the robot is available
		{			
			continue;			
		}
		
		if( !( level flag::get( "power_on" + 22 ) ) )
		{
			continue; // ensure the robot is powered (central power box has been turned on)
		}

		if( player.score < level.ai_robot_remaining_cost ) // player puts all their money into it
		{
			level.ai_robot_remaining_cost -= player.score;
			player zm_score::minus_to_player_score( player.score );
			self.stub zm_unitrigger::run_visibility_function_for_all_triggers();
			level thread update_readouts_for_remaining_robot_cost();
		}
		else // we have enough to activate the Robot right now
		{
			level.ai_robot_remaining_cost = 0;
			level thread spawn_robot( player, self.stub );
		}

	}
}

function spawn_robot( player, trig_stub )
{
	// get the struct that has "robot_start_pos" as targetname, and a script_noteworthy matching the trigger; use this to get the starting position where the robot touches down
	a_s_start_pos = struct::get_array( "robot_start_pos", "targetname" );
	a_s_start_pos = array::filter( a_s_start_pos, false, &filter_callbox_name, trig_stub.str_areaname );
	robot_start_pos = a_s_start_pos[0];
	pos_to_spawn = robot_start_pos.origin;

	// spawn the robot			
	spawner = level.zombie_robot_spawners[0];
	level.ai_robot = spawner spawnfromspawner( "companion_spawner", true );
	level.ai_robot.script_friendname = "Police Robot";
	level.ai_robot name::get();
	level.ai_robot.maxHealth = level.ai_robot.health;
	level.ai_robot.allow_zombie_to_target_ai = false;
	level.ai_robot.on_train = false;
	level.ai_robot SetCanDamage( false ); // Robot is invincible
	level.ai_robot_area_called = trig_stub.str_areaname;
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
	level.ai_robot.time_expired = false;
	foreach( player in level.players )
	{
		player SetPerk( "specialty_pistoldeath" );
	}

	
	// pay remaining amount
	player zm_score::minus_to_player_score( level.ai_robot_remaining_cost );
	// update cost readouts throughout the map
	level thread update_readouts_for_remaining_robot_cost();

	// robot landing in level
	// TODO: play the landing animation and effects here
	if( IsDefined( level.ai_robot ) )
	{
		level.ai_robot ForceTeleport( pos_to_spawn );
		level.ai_robot.companion_anchor_point = ( pos_to_spawn );
	}
			
	// wait until we can have a new robot
	wait( 120 );
	level.ai_robot.time_expired = true;
	
	//disable leaving if robot is in the middle of reviving a player
	while( level.ai_robot.reviving_a_player == true )
	{
		wait 0.05;
	}
			
	// TODO: play the take-off animation and effects here
	
	foreach( player in level.players )
	{
		player UnsetPerk( "specialty_pistoldeath" );
	}
	level.ai_robot SetCanDamage( true );
	level.ai_robot Kill();
	level.ai_robot = undefined;
	level.ai_robot_remaining_cost = 2000; // reset cost
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
	// update cost readouts throughout the map
	level thread update_readouts_for_remaining_robot_cost();
}

function filter_callbox_name( e_entity, str_areaname )
{
	if( !isdefined( e_entity.script_string ) || ( e_entity.script_string != str_areaname ) )
	{
		return false;
	}
	return true;
}

function update_readouts_for_remaining_robot_cost()
{
	a_e_readouts = GetEntArray( "robot_readout_model", "targetname" );
	
	foreach( e_readout in a_e_readouts )
	{
		e_readout update_readout_for_remaining_robot_cost();
	}
}
	
// visually updates the readout with the current remaining cost of the robot
function update_readout_for_remaining_robot_cost()
{
	a_cost = get_placed_array_from_number( level.ai_robot_remaining_cost );
	                             
	for( i = 0; i < 4; i++ )
	{
		for ( j = 0; j < 10; j++ )
		{
			self HidePart( "J_" + i + "_" + j ); // have to hide all the parts individually
		}
		
		self ShowPart( "J_" + i + "_" + a_cost[ i ] ); // show the code number
	}
}

// turn cost into a placed array of AI_ROBOT_COST_DIGITS size
function get_placed_array_from_number( n_number )
{
	a_number = [];
	
	for( i = 0; i < 4; i++ )
	{
		n_place = Pow( 10, ( 4 - 1 - i ) );
		a_number[ i ] = Floor( n_number / n_place );
		n_number -= ( a_number[ i ] * n_place );
	}
	
	return a_number;
}
