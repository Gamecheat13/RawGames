#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom_gadget;

#using scripts\cp\cp_mi_zurich_newworld;
#using scripts\cp\cp_mi_zurich_newworld_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
           	    

#namespace newworld_rooftops;















#precache( "objective", "cp_level_newworld_rooftop_chase" );

//----------------------------------------------------------------------------
//
//

function skipto_apartment_igc_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		skipto::teleport( str_objective );
	}
	else
	{

		foreach( player in level.players )
		{
			player newworld_util::replace_weapons();
		}
	
		// TODO: TEMP until IGC hooked up, remove.
		array::run_all( GetAIArray(), &Delete );
		skipto::teleport( str_objective );
	}

	foreach( player in level.players )
	{
		player cybercom_gadget::takeAllAbilities();	// remove all abilities
		player cybercom_gadget::giveAbility( "cybercom_systemoverload", false );
		player cybercom_gadget::equipAbility( "cybercom_systemoverload" );
	}
	
	spawner::add_spawn_function_group( "patio_robot", "script_noteworthy", &patio_robot_adjustments );

	level.ai_bomber = spawner::simple_spawn_single( "chase_bomber", &bomber_spawn_function );
	level.ai_taylor = util::get_hero( "taylor" );
	level.ai_hall 	= util::get_hero( "hall" );

	level flag::wait_till( "all_players_spawned" );

	level thread util::screen_fade_in( 2.0, "white" );

	level util::delay( 2.0, undefined, &util::screen_message_create, &"CP_MI_ZURICH_NEWWORLD_TIME_ROOFTOPS", undefined, undefined, 150, 5 );

	apartment_breach();
	
	skipto::objective_completed( str_objective );

	level.ai_taylor util::self_delete();
}

function skipto_apartment_igc_done( str_objective, b_starting, b_direct, player )
{
}

function apartment_breach()
{
	a_e_doors = GetEntArray( "apartment_breach_door", "targetname" );

	a_e_doors[ 0 ] util::delay( 5, undefined, &RotateYaw, 90, 1 );
	a_e_doors[ 1 ] util::delay( 5, undefined, &RotateYaw, -90, 1 );

	level thread apartment_breach_glass_break( 11 );

	level scene::play( "cin_new_05_01_apartmentbreach_1st_setup" );
}

function apartment_breach_glass_break( n_wait )
{
	s_glass = struct::get( "chase_window_break" );
	wait n_wait;
	s_glass glass_breaker();
}

//----------------------------------------------------------------------------
//
//

function skipto_chase_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_bomber = spawner::simple_spawn_single( "chase_bomber", &bomber_spawn_function );
		level.ai_hall 	= util::get_hero( "hall" );
		
		skipto::teleport_ai( str_objective );
		
		level thread apartment_breach_glass_break( 1 );
		spawner::add_spawn_function_group( "patio_robot", "script_noteworthy", &patio_robot_adjustments );
		
		level flag::wait_till( "all_players_spawned" );
	}
	
	trigger::use( "chase_hall_start_color", undefined, undefined, false );

	util::teleport_players_igc( str_objective );		

	a_sp_civilians = GetEntArray( "opening_chase_civilian", "targetname" );
	array::thread_all( a_sp_civilians, &newworld::civilian_think );

	level flag::wait_till( "all_players_spawned" );

	level thread setup_rooftops_wasps( "bridge_collapse_wasps" );
	level thread chase_hunter();
	level thread bomber_chase_path( str_objective );
	level thread rooftops_player_checkpoints();
	level thread hall_jumps_over_bar_animation();
	
	level waittill( "bridge_collapse_igc_start" );	
	skipto::objective_completed( str_objective );
}

function bomber_spawn_function()	// self == the bomber
{
	self DisableAimAssist();
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self ai::disable_pain();
    self ai::set_behavior_attribute( "sprint", true );
	self.overrideActorDamage = &callback_bomber_damage;
	self.goalradius = 32;
	self ASMSetAnimationRate( 1.1 );
	self.script_objective = "glass_ceiling_igc";

	self DisableAimAssist();
	self util::delay( 1, "death", &fx::play, "suspect_trail", undefined, undefined, undefined, true, "J_Hip_LE" );

	self thread bomber_mission_fail_death();
	//* self thread bomber_mission_fail_flee(); // Uncomment when solution for UFOing around map
}

function callback_bomber_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName ) 
{
	iDamage = int( iDamage * 0.3 );
	return iDamage;
}

function bomber_mission_fail_death()
{
	level endon( "rooftops_terminate" );
	self waittill( "death" );

	level notify( "bomber_killed" );

	/#
	util::screen_fade_out( 2 );
	util::screen_message_create( "You killed the bombing suspect. Capture him alive!" );
	util::screen_message_delete( 2 );
	#/
	// TODO: Below fail hint not appearing for some reason.	Above script is placeholder.
	util::missionfailedwrapper_nodeath( "You killed the bombing suspect. Capture him alive!" );
}

function bomber_mission_fail_flee()
{
	level endon( "rooftops_terminate" );
	self endon( "death" );

	level flag::wait_till( "all_players_spawned" );

	while ( true )
	{
		e_players = ArraySortClosest( level.players, self.origin );
		n_dist = Distance( e_players[ 0 ].origin, self.origin );

		if ( n_dist > 2500 )
		{
			/#
			util::screen_fade_out( 2 );
			util::screen_message_create( "The bombing suspect got away!");
			util::screen_message_delete( 2 );
			#/
			// TODO: Below fail hint not appearing for some reason.	Above script is placeholder.
			util::missionfailedwrapper_nodeath( "The bombing suspect got away!" );
			return;
		}

		wait 0.1;
	}
}

// TODO: TEMP -- This may all be orchestrated by ScriptBundle in the future.
function chase_hunter()
{
	trigger::wait_till( "chase_hunter_spawn", undefined, undefined, false );

	level.vh_hunter = spawner::simple_spawn_single( "chase_hunter", &hunter_spawn_function );
}

function hunter_spawn_function()
{
	self util::magic_bullet_shield();
	self SetTeam( "allies" );
	self ai::set_ignoreme( true );
	self vehicle_ai::start_scripted();
	self SetVehicleAvoidance( false );
	self.goalradius = 32;
	self.script_objective = "rooftops";

	if ( ( level.skipto_point === "chase" ) )
	{
		self thread hunter_follow_suspect();
		self thread hunter_target_suspect();
	}
	else if ( ( level.skipto_point === "bridge_collapse_igc" ) )
	{
		// teleport Hunter to the end of his path
		s_goal = struct::get( "chase_bridge_hunter_path_end" );
		self.origin = s_goal.origin;
		self.angles = s_goal.angles;
	}
}

function hunter_follow_suspect()
{
	level endon( "bomber_killed" );

	s_goal = struct::get( "chase_bridge_hunter_path" );

	while ( true )
	{
		self SetVehGoalPos( s_goal.origin, true );
		self util::waittill_either( "at_anchor", "goal" );

		if ( IsDefined( s_goal.target ) )
		{
			s_goal = struct::get( s_goal.target );
		}
		else
		{
			break;
		}
	}
}

function hunter_target_suspect()
{
	level endon( "bomber_killed" );
	level endon( "wasp_exploded" );

	while ( IsDefined( self ) )
	{
		self ClearTargetYaw();
		self SetTargetYaw( ( 0, VectorToAngles( level.ai_bomber.origin - self.origin )[1], 0 )[ 1 ] );

		wait ( 0.05 );
	}
}

function patio_robot_adjustments()	// self == a robot on the patio
{
	self.script_accuracy = 0.1;
	self.health = 150;
}

function patio_glass_breaker()
{
	level waittill( "apartment_jump_down" );
	a_s_glass_break = struct::get_array( "patio_glass_break", "targetname" );
	array::thread_all( a_s_glass_break, &glass_breaker );
}

function hall_jumps_over_bar_animation()
{
	level waittill( "hall_jump_over_bar_for_some_reason" );
	scene::play( "cin_new_06_01_chase_vign_traversal", level.ai_hall );
}

function skipto_chase_done( str_objective, b_starting, b_direct, player )
{
}

//----------------------------------------------------------------------------
//
//

function skipto_bridge_collapse_igc_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_bomber = spawner::simple_spawn_single( "chase_bomber", &bomber_spawn_function );
		level.ai_hall 	= util::get_hero( "hall" );

		skipto::teleport( str_objective );
		
		level flag::wait_till( "all_players_spawned" );
		
		level.vh_hunter = spawner::simple_spawn_single( "chase_hunter", &hunter_spawn_function );

		level thread setup_rooftops_wasps( "bridge_collapse_wasps" );
		level thread bomber_chase_path( str_objective );
		level thread rooftops_player_checkpoints();
	}
	
	level thread hall_bridge_dropdown( false );

	level waittill( "bridge_collapse_igc_done" );
	skipto::objective_completed( str_objective );

}

function skipto_bridge_collapse_igc_done( str_objective, b_starting, b_direct, player )
{
}

function bridge_collapse( a_ents )	// called as a scene_func when cin_new_06_01_chase_vign_device plays
{
	// TODO: Temp, needs notetracks to time this properly
	wait 0.6;

	s_goal = struct::get( "chase_bridge_hunter_impact" );
	a_s_wasp_spawns = struct::get_array( "chase_bridge_wasp" );
	a_s_wasp_goals = struct::get_array( "chase_bridge_wasp_goal" );

	foreach ( s_wasp in a_s_wasp_spawns )
	{
		s_wasp notify( "awaken" );
	}

	wait 0.1; // Allow Wasps to Spawn

	a_ai_wasps = GetEntArray( "chase_bridge_wasp_ai", "targetname" );

	foreach ( n_index, ai_wasp in a_ai_wasps )
	{
		ai_wasp thread wasp_bridge_spawn_function( a_s_wasp_goals[ n_index] );
	}

	level waittill( "wasp_exploded" );

	level.vh_hunter SetVehGoalPos( s_goal.origin, false );
	level.vh_hunter SetTargetYaw( s_goal.angles[ 1 ] );

	wait 1.2;	// this used to be a waittill "goal" on the Hunter but that was too unreliable

	level.vh_hunter util::stop_magic_bullet_shield();
	level.vh_hunter Kill();
	level.vh_hunter.delete_on_death = true;
	
	RadiusDamage( s_goal.origin, 650, 20, 100, level.ai_bomber, "MOD_EXPLOSIVE" );
	PlayRumbleOnPosition( "grenade_rumble", s_goal.origin );
	Earthquake( 0.5, 0.5, s_goal.origin, 512 );
	PlayFX( level._effect[ "large_explosion" ], s_goal.origin, ( 0, 0, 1 ) );	

	array::run_all( GetEntArray( "collapse_bridge", "targetname" ), &MoveZ, -768, 1 );
	GetEnt( "bridge_monster_clip", "targetname" ) MoveZ( -768, 1 );
	
	level notify( "bridge_collapse_igc_done" );	
}

function wasp_bridge_spawn_function( s_wasp_goal )
{
	self vehicle_ai::start_scripted();
	self SetVehicleAvoidance( false );
	self.goalradius = 32;

	self SetSpeed( 260 );
	self SetVehGoalPos( s_wasp_goal.origin, false );

	self thread bridge_collapse_wasp_think();
}

function bridge_collapse_wasp_think()
{
	self endon( "death" );
	self waittill( "goal" );

	level notify( "wasp_exploded" );

	self Kill();
}

function hall_bridge_dropdown( b_no_wait )
{
	if( !b_no_wait )
	{
		trigger::wait_till( "sarah_bridge_dropdown", undefined, undefined, false );
	}

	scene::play( "cin_new_07_01_bridge_collapse_traverse", level.ai_hall );
}

//----------------------------------------------------------------------------
//
//

function skipto_rooftops_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_bomber = spawner::simple_spawn_single( "chase_bomber", &bomber_spawn_function );
		level.ai_hall 	= util::get_hero( "hall" );

		skipto::teleport( str_objective );
		
		array::run_all( GetEntArray( "collapse_bridge", "targetname" ), &Delete );

		level flag::wait_till( "all_players_spawned" );
		
		level thread hall_bridge_dropdown( true );
		level thread bomber_chase_path( str_objective );
		level thread rooftops_player_checkpoints();
	}
	
	array::run_all( GetEntArray( "construction_site_train", "targetname" ), &Hide );
	
	level thread hall_train_station_wallrun();
	level thread setup_rooftops_wasps( "rooftops_wasps_01" );
	level thread setup_rooftops_wasps( "rooftops_wasps_02" );
	level thread setup_rooftops_wasps( "rooftops_wasps_03" );
	level thread rooftops_tutorial();

	array::thread_all( GetEntArray( "chase_trains", "targetname" ), &train_mover, -41984, 18, "chase_trains_b" );

	a_sp_civilians = GetEntArray( "train_chase_civilian", "targetname" );
	array::thread_all( a_sp_civilians, &newworld::civilian_think );

	rooftops();
}

function skipto_rooftops_done( str_objective, b_starting, b_direct, player )
{
}

function hall_train_station_wallrun()
{
	trigger::wait_till( "do_hall_train_station_wallrun" );
	scene::play( "cin_new_06_02_chase_vign_wallrun", level.ai_hall );
	trigger::use( "hall_post_train_station_wallrun_color_trigger", "targetname" );
}

function rooftops_tutorial()
{
	trigger::wait_till( "rooftops_tutorial_overload", "script_noteworthy", undefined, false );

	level.players[ 0 ] dialog::say( "System Overload temporarily disables robots and drones." );
	level thread util::screen_message_create( &"CP_MI_ZURICH_NEWWORLD_USE_CYBERCORE", undefined, undefined, 0, 12 );
}

function rooftops()
{
}

//----------------------------------------------------------------------------
//
//

function skipto_construction_site_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_bomber = spawner::simple_spawn_single( "chase_bomber", &bomber_spawn_function );
		level.ai_hall 	= util::get_hero( "hall" );

		skipto::teleport( str_objective );
		
		array::run_all( GetEntArray( "collapse_bridge", "targetname" ), &Delete );
		array::run_all( GetEntArray( "chase_train_b", "targetname" ), &Delete );

		level flag::wait_till( "all_players_spawned" );
		
		level thread bomber_chase_path( str_objective );
		level thread rooftops_player_checkpoints();
	}

	a_sp_civilians = GetEntArray( "construction_site_civilian", "targetname" );
	array::thread_all( a_sp_civilians, &newworld::civilian_think );

	construction_site();
}

function construction_site()
{
	level thread teleport_hall_at_slide_hack();	// TODO: Replace with custom anim for Hall sliding down roof at start of Construction Site
	level thread construction_site_glass_breaker();
	level thread construction_site_train();
}

function skipto_construction_site_done( str_objective, b_starting, b_direct, player )
{
}

function teleport_hall_at_slide_hack()
{
	trigger::wait_till( "teleport_hall_at_slide" );
	nd_hall_goto = GetNode( "teleport_hall_at_slide_node", "targetname" );
	level.ai_hall ForceTeleport( nd_hall_goto.origin, nd_hall_goto.angles );
}

function construction_site_glass_breaker()
{
	a_s_glass_break = struct::get_array( "construction_glass_break", "targetname" );
	array::thread_all( a_s_glass_break, &glass_breaker );
}

function construction_site_train()
{
	t_train_start = GetEnt( "chase_post_construction", "targetname" );
	t_train_start train_mover( 51984, 18 );
}

//----------------------------------------------------------------------------
//
//

function skipto_glass_ceiling_igc_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );

		skipto::teleport( str_objective );
	}
	
	level notify( "rooftops_terminate" );

	wait 1.0;  //TEMP until real logic is added

	if ( IsDefined( level.ai_bomber ) )
	{
		objectives::complete( "cp_level_newworld_rooftop_chase", level.ai_bomber );
	}

	// TODO: TEMP until IGC hooked up, remove.
	array::run_all( GetAIArray(), &Delete );
	
	util::screen_fade_out( 2.0, "white" );
	wait 1;	// wait a little extra so the change isn't so jarring

	skipto::objective_completed( str_objective );
}


function skipto_glass_ceiling_igc_done( str_objective, b_starting, b_direct, player )
{
}


//----------------------------------------------------------------------------
// Common
//

function bomber_chase_path( str_objective )
{
	scene::add_scene_func( "cin_new_06_01_chase_vign_device", &bridge_collapse, "play" );
	
	objectives::set( "cp_level_newworld_rooftop_chase", level.ai_bomber );	

	a_bomber_multinode_path = [];
	
	nd_temp_initial_goto = GetNode( "chase_temp_initial_goto", "targetname" );
	nd_pre_bridge01 = GetNode( "chase_pre_bridge01", "targetname" );
	nd_pre_bridge02 = GetNode( "chase_pre_bridge02", "targetname" );
	nd_pre_bridge03 = GetNode( "chase_pre_bridge03", "targetname" );
	nd_pre_bridge04 = GetNode( "chase_pre_bridge04", "targetname" );
	nd_pre_bridge05 = GetNode( "chase_pre_bridge05", "targetname" );	
	nd_pre_bridge_wait = GetNode( "chase_pre_bridge_wait", "targetname" );	// waits here before bridge collapse scene
	nd_bridge_collapse_traversal = GetNode( "bridge_collapse_traversal", "targetname" );	// traversal connecting patio to bridge
	nd_post_explosion_teleport_cheat = GetNode( "chase_post_explosion_teleport_cheat", "targetname" );	// teleported to here to speed up bomber
	nd_post_explosion = GetNode( "chase_post_explosion", "targetname" );	// teleported to here right after bridge collapse
	nd_post_bridge = GetNode( "chase_post_bridge", "targetname" );	// bomber traverses down as players run through wreckage of bridge & Hunter
	nd_pre_train_traversals01 = GetNode( "chase_pre_train_traversals01", "targetname" );	// teleported here as player mantles up
	nd_pre_train_traversals02 = GetNode( "chase_pre_train_traversals02", "targetname" );	// teleported here as player mantles up
	nd_train_station01 = GetNode( "chase_train_station01", "targetname" );	// teleported here as player mantles up
	nd_train_station02 = GetNode( "chase_train_station02", "targetname" );	// teleported here as player mantles up
	nd_train_station03 = GetNode( "chase_train_station03", "targetname" );	// teleported here as player mantles up
	nd_train_station04 = GetNode( "chase_train_station04", "targetname" );	// teleported here as player mantles up
	nd_wasp_group01_activate = GetNode( "chase_wasp_group01_activate", "targetname" );	// teleported here after train passes through the station
	nd_old_rooftop_start01 = GetNode( "chase_old_rooftop_start_cheat01", "targetname" );	// teleported here after bomber drops down from train station
	nd_old_rooftop_start02 = GetNode( "chase_old_rooftop_start_cheat02", "targetname" );	// teleported here after bomber drops down from train station
	nd_old_rooftop_start03 = GetNode( "chase_old_rooftop_start_cheat03", "targetname" );	// teleported here after bomber drops down from train station
	nd_old_rooftop_start04 = GetNode( "chase_old_rooftop_start_cheat04", "targetname" );	// teleported here after bomber drops down from train station
	nd_wasp_group02_activate = GetNode( "chase_wasp_group02_activate", "targetname" );	// "hack" wasps #2
	nd_wasp_group03_activate = GetNode( "chase_wasp_group03_activate", "targetname" );	// "hack" wasps #3
	nd_pre_slide = GetNode( "chase_pre_slide", "targetname" );	// bomber pathing breaks a lot around the slide
	nd_post_slide = GetNode( "chase_post_slide", "targetname" );	// bomber pathing breaks a lot around the slide
	nd_construction01 = GetNode( "chase_construction01", "targetname" );	// get through construction site area
	nd_construction02 = GetNode( "chase_construction02", "targetname" );	// get through construction site area
	nd_post_construction = GetNode( "chase_post_construction", "targetname" );	// waits here after construction site area

	level.ai_bomber.goalradius = 8;

	if ( ( str_objective === "chase" ) )
	{
		level waittill( "apartment_jump_down" );		
		level.ai_bomber SetGoal( nd_pre_bridge01 );
		level.ai_bomber waittill( "goal" );
		array::add( a_bomber_multinode_path, nd_pre_bridge02 );
		array::add( a_bomber_multinode_path, nd_pre_bridge03 );
		bomber_node_by_node_warping( a_bomber_multinode_path );
		
		a_bomber_multinode_path = [];
		array::add( a_bomber_multinode_path, nd_pre_bridge04 );
		array::add( a_bomber_multinode_path, nd_pre_bridge05 );
		array::add( a_bomber_multinode_path, nd_pre_bridge_wait );
		level.ai_bomber ASMSetAnimationRate( 1.4 );		
		bomber_node_by_node_pathing( a_bomber_multinode_path );
		level.ai_bomber ASMSetAnimationRate( 1.1 );		
		trigger::wait_till( "chase_pre_bridge", undefined, undefined, false );
		level notify( "bridge_collapse_igc_start" );
	}
	else
	{
		level.ai_bomber ForceTeleport( nd_pre_bridge_wait.origin, nd_pre_bridge_wait.angles );
	}

	if ( ( str_objective === "chase" ) || ( str_objective === "bridge_collapse_igc" ) )
	{
		LinkTraversal( nd_bridge_collapse_traversal );
		level.ai_bomber util::magic_bullet_shield();	// protect bomber from radius damage of Hunter destroying bridge
		level.ai_bomber ASMSetAnimationRate( 1.0 );
		level scene::play( "cin_new_06_01_chase_vign_device" );
		level.ai_bomber ASMSetAnimationRate( 1.1 );
		level.ai_bomber SetGoal( nd_post_explosion_teleport_cheat );
		level.ai_bomber ForceTeleport( nd_post_explosion_teleport_cheat.origin, nd_post_explosion.angles );
		level.ai_bomber util::stop_magic_bullet_shield();
		UnlinkTraversal( nd_bridge_collapse_traversal );
		{wait(.05);};	// allow the trail to draw path correctly
		level.ai_bomber SetGoal( nd_post_explosion );
	}
	else
	{
		level.ai_bomber ForceTeleport( nd_post_explosion.origin, nd_post_explosion.angles );
	}

	if ( ( str_objective === "chase" ) || ( str_objective === "bridge_collapse_igc" ) || ( str_objective === "rooftops" ) )
	{
		trigger::wait_till( "bomber_post_bridge_traversals", undefined, undefined, false );	// player has jumped down after bridge collapse
		a_bomber_multinode_path = [];
		array::add( a_bomber_multinode_path, nd_post_bridge );
		array::add( a_bomber_multinode_path, nd_pre_train_traversals01 );
		bomber_node_by_node_pathing( a_bomber_multinode_path, "chase_post_bridge" );

		if( !flag::get( "chase_post_bridge_mantle_up" ) )	// set by "chase_post_bridge" trigger
		{
			flag::wait_till( "chase_post_bridge_mantle_up" );
		}

		level.ai_bomber ForceTeleport( nd_pre_train_traversals01.origin, nd_pre_train_traversals01.angles );
		{wait(.05);};
		level.ai_bomber SetGoal( nd_pre_train_traversals02 );

		trigger::wait_till( "chase_pre_train", undefined, undefined, false );	// player is approaching 1st mantle fence on the way to train station
		level.ai_bomber ForceTeleport( nd_pre_train_traversals02.origin, nd_pre_train_traversals02.angles );
		a_bomber_multinode_path = [];
		array::add( a_bomber_multinode_path, nd_train_station01 );
		array::add( a_bomber_multinode_path, nd_train_station02 );
		array::add( a_bomber_multinode_path, nd_train_station03 );
		array::add( a_bomber_multinode_path, nd_train_station04 );
		bomber_node_by_node_warping( a_bomber_multinode_path );
		
		if( !flag::get( "chase_train_station_glass_ceiling" ) )	// set by "chase_train_station_glass_ceiling" trigger near railing overlooking glass ceiling
		{
			flag::wait_till( "chase_train_station_glass_ceiling" );
		}
		
		bomber_wasp_group_activate( nd_wasp_group01_activate, 1 );
		level.ai_bomber SetGoal( nd_old_rooftop_start01 );
		wait 1.5;	// using a delay instead of waiting for "goal" because we just need bomber to drop down out of sight here
		
		a_bomber_multinode_path = [];
		array::add( a_bomber_multinode_path, nd_old_rooftop_start02 );
		array::add( a_bomber_multinode_path, nd_old_rooftop_start03 );
		array::add( a_bomber_multinode_path, nd_old_rooftop_start04 );
		bomber_node_by_node_warping( a_bomber_multinode_path );
		
		a_bomber_multinode_path = [];
		array::add( a_bomber_multinode_path, nd_wasp_group02_activate );
		array::add( a_bomber_multinode_path, nd_wasp_group03_activate );
		bomber_multi_wasp_group_activate( a_bomber_multinode_path, 2 );
	}
	else
	{	
		level.ai_bomber ForceTeleport( nd_pre_slide.origin, nd_pre_slide.angles );
	}
	
	if ( ( str_objective === "chase" ) || ( str_objective === "bridge_collapse_igc" ) 
	|| 	 ( str_objective === "rooftops" ) || ( str_objective === "construction_site" ) )
	{
		// these are here because pathing keeps breaking around the slide, and it's just conveient to keep these cheat options
		//level.ai_bomber ForceTeleport( nd_pre_slide.origin, nd_pre_slide.angles );
		level.ai_bomber ForceTeleport( nd_post_slide.origin, nd_post_slide.angles );
		{wait(.05);};
		
		a_bomber_multinode_path = [];
		array::add( a_bomber_multinode_path, nd_construction01 );
		array::add( a_bomber_multinode_path, nd_construction02 );
		array::add( a_bomber_multinode_path, nd_post_construction );
		level thread bomber_node_by_node_pathing( a_bomber_multinode_path, "chase_post_construction" );
		
		trigger::wait_till( "chase_post_construction", undefined, undefined, false );
		
		s_end = struct::get( "chase_bomber_rooftops_pre_glass_end" );
		level.ai_bomber SetGoal( s_end.origin );
	}
}

function bomber_node_by_node_warping( a_nd_path )
{
	foreach( nd_path in a_nd_path )
	{
		level.ai_bomber ForceTeleport( nd_path.origin, nd_path.angles );
		wait 0.1;
	}
}

function bomber_node_by_node_pathing( a_nd_path, str_endon )
{
	level.ai_bomber endon( "death" );
	if( isdefined( str_endon ) )
	{
		level endon( str_endon );
	}
	
	foreach( nd_path in a_nd_path )
	{
		level.ai_bomber SetGoal( nd_path );
		level.ai_bomber waittill( "goal" );
	}
}

function bomber_wasp_group_activate( nd_path, n_index )
{
	level.ai_bomber SetGoal( nd_path, true );
	level.ai_bomber waittill( "goal" );
	if( !flag::get( "wasp_group0" + n_index ) )	// this flag is set when player hits a wasp trigger
	{
		flag::wait_till( "wasp_group0" + n_index );
	}
	level.ai_bomber animation::play( "ch_new_06_01_chase_vign_device_guy01", nd_path );
}

function bomber_multi_wasp_group_activate( a_nd_path, n_starting_index )
{
	level.ai_bomber endon( "death" );
	
	foreach( nd_path in a_nd_path )
	{
		level.ai_bomber SetGoal( nd_path, true );
		level waittill( "wasp_group0" + n_starting_index );	// this notify is raised when player hits a wasp trigger
		level.ai_bomber ForceTeleport( nd_path.origin, nd_path.angles );
		{wait(.05);};
		level.ai_bomber animation::play( "ch_new_06_01_chase_vign_device_guy01", nd_path );
		n_starting_index++;
	}
}

function rooftops_player_checkpoints()
{
	level endon( "rooftops_terminate" );

	e_volume = GetEnt( "rooftops_safe_area", "targetname" );

	level thread rooftops_player_fell_off();

	while ( true )
	{
		foreach ( player in level.players )
		{
			if ( player IsTouching( e_volume ) && player IsOnGround() && !player IsWallRunning() )
			{
				player.v_rooftops_checkpoint = player.origin;
			}
		}

		wait 1;
	}
}

function rooftops_player_fell_off()
{
	level endon( "rooftops_terminate" );

	e_trigger = GetEnt( "rooftops_bad_area", "targetname" );

	while ( true )
	{
		e_trigger waittill( "trigger", e_who );

		if ( IsPlayer( e_who ) )
		{
			e_who clientfield::set( "player_spawn_fx", true );
			e_who util::delay( 0.1, "death", &clientfield::set, "player_spawn_fx", false ); // Give some time for FX to play before turning off

			e_who SetOrigin( e_who.v_rooftops_checkpoint );
		}
	}
}

function setup_rooftops_wasps( str_id )
{
	t_starter = GetEnt( str_id + "_trigger", "targetname" );
	if( isdefined( t_starter ) )
	{
		t_starter thread bomber_activated_wasp_trigger();
	}
	a_s_wasps = struct::get_array( str_id + "_spawnpoint", "script_noteworthy" );

	foreach ( n_index, s_wasp in a_s_wasps )
	{
		s_wasp.e_wasp = util::spawn_model( "veh_t7_drone_wasp_gun", s_wasp.origin, s_wasp.angles );
		s_wasp.e_wasp.script_objective = "construction_site";
		s_wasp thread wasp_spawner( n_index );
	}
}

function bomber_activated_wasp_trigger()	// self == trigger targeting structs for wasp launchers
{
	level endon( "rooftops_terminate" );

	a_s_wasps = struct::get_array( self.target );

	self trigger::wait_till();

	level notify( self.target );
	array::thread_all( a_s_wasps, &util::delay_notify, 0.6, "awaken" );
}

function wasp_spawner( n_index )	// self == struct for wasp spawn point
{
	level endon( "rooftops_terminate" );

	self waittill( "awaken" );
	
	self.e_wasp Hide();
	
	switch( level.players.size )
	{
		case 1:
			if( n_index > 3 )	// 4 wasps for 1 player
			{
				return;
			}
		break;
		case 2:
		case 3:
			if( n_index > 5 )	// 6 wasps for 2 - 3 players
			{
				return;
			}		
		break;
		case 4:
		break;
	}
	
	PlayFX( level._effect[ "wasp_hack" ], self.origin );

	ai_wasp = SpawnVehicle( "spawner_enemy_sec_vehicle_wasp_mg", self.origin, self.angles, "dynamic_spawn_ai" );
	ai_wasp.targetname = self.targetname + "_ai";
	ai_wasp.script_objective = "construction_site";
	if( IsDefined( self.target ) )
	{
		ai_wasp SetGoal( GetEnt( self.target, "targetname" ) );
	}
	

	self.e_wasp util::self_delete();
}

function glass_breaker()	// self == a struct
{
	GlassRadiusDamage( self.origin , 128, 2000, 1500 );
}

function train_mover( n_move_dist, n_move_time, str_endon = undefined )	// self == trigger that starts train moving
{
	if( isdefined( str_endon ) )
	{
		level endon( str_endon );
	}
	a_t_train_hurt = [];
	a_e_train = GetEntArray( self.target, "targetname" );
	
	foreach ( e_train in a_e_train )
	{
		if( e_train.classname == "trigger_hurt" )
		{
			if ( !isdefined( a_t_train_hurt ) ) a_t_train_hurt = []; else if ( !IsArray( a_t_train_hurt ) ) a_t_train_hurt = array( a_t_train_hurt ); a_t_train_hurt[a_t_train_hurt.size]=e_train;;
		}
	}
	a_e_train = array::exclude(	a_e_train, a_t_train_hurt );
	
	// link hurt triggers to a train car. Any train car, it doesn't really matter
	foreach( n_index, t_train_hurt in a_t_train_hurt )
	{
		t_train_hurt enablelinkto();
		t_train_hurt LinkTo( a_e_train[ n_index] );
	}

	self waittill( "trigger" );

	array::run_all( a_e_train, &Show );
	array::run_all( a_e_train, &MoveX, n_move_dist, n_move_time );
	GetEnt( self.target + "_collision", "targetname" ) MoveX( n_move_dist, n_move_time );
}





