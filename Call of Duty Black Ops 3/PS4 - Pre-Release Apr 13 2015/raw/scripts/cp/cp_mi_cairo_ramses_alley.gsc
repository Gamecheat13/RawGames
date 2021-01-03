//----------------------------------------------------------
// Notes:
//		Blockout Hunter crash ents:
//			- hunter_crash01
//			- scarab_statue
//			- tail_breakthrough
//			- broken_corner
//----------------------------------------------------------
#using scripts\codescripts\struct;

//shareds
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\codescripts\struct;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_vehicle;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\cp\_objectives;
#using scripts\shared\ai_shared;
#using scripts\cp\_dialog;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses2_fx;
#using scripts\cp\cp_mi_cairo_ramses2_sound;

#using scripts\cp\cp_mi_cairo_ramses_arena_defend;
#using scripts\cp\cp_mi_cairo_ramses_utility;

#precache( "objective", "cp_level_ramses_reinforce_safiya" );
#precache( "objective", "cp_level_ramses_reinforce_safiya_breadcrumb" );
#precache( "objective", "cp_level_ramses_vtol_breadcrumb" );

#precache( "fx", "explosions/fx_exp_generic_lg" );

#namespace alley;

function alley_main()
{
	precache();

	level flag::wait_till( "first_player_spawned" );
	
	alley_battle_main();	
	
	skipto::objective_completed( "alley" );
}

function precache()
{	
	level flag::init( "alley_event_started" );
	level flag::init( "alley_midpoint_reached" );
	
	level._effect[ "large_explosion" ]			= "explosions/fx_exp_generic_lg";
	
}

function alley_entrance_scene()
{
	level.ai_khalil colors::disable();
	level.ai_hendricks colors::disable();	
	
	nd_hendricks_alley_pos = GetNode( "hendricks_alley_pos", "targetname" );
	nd_khalil_alley_pos = GetNode( "khalil_alley_pos", "targetname" );
		
	level.ai_hendricks thread ai::force_goal( nd_hendricks_alley_pos, 32 );
	level.ai_khalil thread ai::force_goal( nd_khalil_alley_pos, 32 );

//	array::wait_till( level.heroes, "goal" );
	
	level.ai_khalil.goalradius = 32;
	
	level.ai_hendricks.goalradius = 32;	
	
	trigger::wait_till( "trig_player_alley_entrance" );
	
	level thread hunter_crash_fx_anims();
	
	level thread scene::play( "cin_ram_05_02_block_vign_moveout" );
	
	//TODO: spawn sound ent for dialog
	e_dialog_ent = util::spawn_model( "tag_origin", level.players[0].origin, level.players[0].angles );
	e_dialog_ent dialog::say( "rach_there_are_pockets_of_0" ); //There are pockets of NRC forces between you and the plaza.
	
	//Temp: wait for the anim to end
	wait 8;
	
	e_dialog_ent Delete();

	level.ai_hendricks colors::enable();	
	level.ai_hendricks colors::set_force_color( "o" );
	
	trigger::use( "trig_color_post_entrance", "targetname", undefined, false );	
}

function alley_battle_main()
{
	//spawn funcs
	a_alley_wasps = GetEntArray( "alley_wasps", "script_noteworthy" );
	array::thread_all( a_alley_wasps, &spawner::add_spawn_function, &init_alley_enemy_vehicle );
	
	a_alley_egypt_intro_guy = GetEntArray( "alley_egypt_intro_guy", "targetname" );
	array::thread_all( a_alley_egypt_intro_guy, &spawner::add_spawn_function, &init_intro_alley_guy );		
	
	a_alley_nrc_intro_guy = GetEntArray( "alley_nrc_intro_guy", "targetname" );
	array::thread_all( a_alley_nrc_intro_guy, &spawner::add_spawn_function, &init_intro_alley_guy );			
	
	a_egyptian_hero = GetEntArray( "egyptian_hero", "targetname" );
	array::thread_all( a_egyptian_hero, &spawner::add_spawn_function, &init_egyptian_hero );			
	
	a_amws_enemy = GetEntArray( "amws_enemy", "script_noteworthy" );
	array::thread_all( a_amws_enemy, &spawner::add_spawn_function, &init_alley_enemy_vehicle );
	
	level flag::set( "alley_event_started" );
	level thread arena_defend::stop_hunter_crash_fx_anims();

	level thread alley_objectives();		
	
	//thread this for now, but we need to figure out what we want to do here
 	level thread alley_entrance_scene();
	alley_intro_battle();
	alley_end_battle();
}

//self = =ai
function init_egyptian_hero()
{
	self endon( "death" );
	
	self util::magic_bullet_shield();
}

//self = AI
function init_intro_alley_guy()
{
	self endon( "death" );
	
	//dont make them too deadly so we can see the ongoing fight
	self.accuracy = 0.2;
	
	level flag::wait_till( "alley_gone_hot" );
	
	//stagger them a bit
	wait ( randomintrange( 1, 3 ) );
	
	self.accuracy = 1.0;
}
	
//self == vehicle
function init_alley_enemy_vehicle()
{
	self endon( "death" );
	
	e_fight_vol = GetEnt( self.target, "targetname" );
	self setgoalpos( e_fight_vol.origin );
}

function alley_intro_battle()
{
	level thread ramses_util::light_shift_think( "ramses_light_shift_1", "vtol_igc_done", &ramses_util::set_lighting_state_time_shift_1 );
	
	level thread flak_exploders();
	
	level thread alley_hunter_crash();	
	
/////////////////////////////////////////////////////////////
//					//INTRO ALLEY FIREFIGHT
/////////////////////////////////////////////////////////////	
	
	trigger::wait_till( "trig_start_alley_intro" );
	
	spawn_manager::enable( "sm_alley_egypt_intro" );	
	spawn_manager::enable( "sm_alley_nrc_intro" );
	
	//set ignore me on heroes so they dont fire on skirmish
	foreach( e_hero in level.heroes )
	{
		e_hero thread monitor_ai_alley_gone_hot();
	}
	
	foreach( e_player in level.players )
	{
		e_player thread monitor_player_alley_gone_hot( "player_alley_intro" );
	}
	
	level thread color_alley_movement_behavior_think();
	
/////////////////////////////////////////////////////////////
//					//BACK ALLEY FIREFIGHT
/////////////////////////////////////////////////////////////		

	level flag::wait_till( "player_mid_alley" );

	level thread hendricks_alley_movement();
	
	//setup VTOL igc
	level scene::init( "cin_ram_06_05_safiya_1st_friendlydown_init" );
	
	spawn_manager::enable( "sm_alley_egypt_mid" );	
	spawn_manager::enable( "sm_alley_nrc_mid" );	
	
	level flag::wait_till( "player_front_alley_end" );
	
	//wait until player reaches this area then wait for x amount of guys to die to trigger killspawn and colortrig
	spawner::waittill_ai_group_amount_killed( "alley_nrc_mid", 8 );
	trigger::use( "trig_color_back_alley_mid", "targetname", undefined, false );
}

function color_alley_movement_behavior_think()
{
	level flag::wait_till( "alley_gone_hot" );
	trigger::use( "trig_color_alley_intro", "targetname", undefined, false );
	
	//move hendricks up 
	spawner::waittill_ai_group_amount_killed( "alley_nrc_intro", 5 );
	trigger::use( "trig_color_alley_front", "targetname", undefined, false );

	//kill the spawn manager if it hasnt already been done by the ingame trig
	spawner::waittill_ai_group_amount_killed( "alley_nrc_intro", 8 );
	
	//kills enemy intro spawn manager
	trigger::use( "trig_killspawn_intro", "targetname", undefined, false );		
	
	n_intro_nrc_count = spawner::get_ai_group_sentient_count( "alley_nrc_intro" );
	while( n_intro_nrc_count >= 1 )
	{
		n_intro_nrc_count = spawner::get_ai_group_sentient_count( "alley_nrc_intro" );
		
		wait 0.05;	
	}
	
	trigger::use( "trig_color_alley_mid", "targetname", undefined, false );	
	
	//check to see if the player has made it far into the alley
	//if he hasn't, then run the ignore logic on everyone
	//if he has moved past this point, ignore it all
	if ( !level flag::get( "player_front_alley_end" ) )
	{
		//set ignore to heroes
		foreach( e_hero in level.heroes )
		{
			e_hero thread monitor_ai_alley_gone_hot();
		}
	
		//set ignore to players
		foreach( e_player in level.players )
		{
			e_player thread monitor_player_alley_gone_hot( "player_front_alley_end" );
		}		
		
		//set ignore to intro friendlies
		a_intro_egypt_guys = GetEntArray( "alley_egypt_intro_guy_ai", "targetname" );
		foreach( e_guy in a_intro_egypt_guys )
		{
			e_guy thread monitor_ai_alley_gone_hot();
		}
	}
}
	
// self = player and the string, if defined, will wait until monitoring the conditions to go hot	
function monitor_player_alley_gone_hot( str_flag_wait )
{
	self endon( "disconnect" );

	self.ignoreme = true;

	level flag::clear( "alley_gone_hot" );
	
	level flag::wait_till( str_flag_wait );
	
	//conditions where enemies will fire on player and hendricks, flag is also set on a trigger if player runs up
	self thread monitor_alley_flank_player_gunfire();
	level thread monitor_alley_flank_timeout();
	
	level flag::wait_till( "alley_gone_hot" );
	
	self.ignoreme = false;		
}

function monitor_alley_flank_timeout()
{
	level endon( "alley_gone_hot" );
	wait 15	;
	level flag::set( "alley_gone_hot" );
}

function monitor_alley_flank_player_gunfire()
{
	self waittill( "weapon_fired" );
	level flag::set( "alley_gone_hot" );
}

//self is ai/hero
function monitor_ai_alley_gone_hot()
{
	self endon( "death" );
	
	if( !IsDefined( self ) )
	{
		return;	
	}
	
	self.ignoreme = true;
	self.ignoreall = true;	
	
	level flag::wait_till( "alley_gone_hot" );
	
	self.ignoreme = false;
	self.ignoreall = false;
}

//self = ai
function rooftop_guy_run_and_delete()
{
	self endon( "death" );
	
	//stagger them running off
	wait ( RandomIntRange( 1, 3 ) );
	
	nd_delete = GetNode( "rooftop_delete_node", "targetname" );

	self thread ai::force_goal( nd_delete, 32 );
	self waittill( "goal" );
	self Delete();
}

//hendricks logic for doing a wall run, bridge jump, then another wall run
function hendricks_alley_movement()
{
	//send rooftop guys tp traverse behind the building and delete
	a_rooftop_guys = spawner::get_ai_group_ai( "alley_egypt_intro_roofop" );
	foreach( e_guy in a_rooftop_guys )
	{
		e_guy thread rooftop_guy_run_and_delete();
	}
	
	level.ai_hendricks colors::disable();
	
//	nd_hendricks_pre_wallrun = GetNode( "hendricks_pre_wallrun", "script_noteworthy" );
//	level.ai_hendricks thread ai::force_goal( nd_hendricks_pre_wallrun, 32 );
//	level.ai_hendricks waittill( "goal" );
//	level.ai_hendricks.goalradius = 32;		
//	
//	s_hendricks_mid_start = struct::get( "s_hendricks_mid_start", "targetname" );
//	s_wallrun_start = struct::get( s_hendricks_mid_start.target, "targetname" );
//	s_wallrun_end = struct::get( s_wallrun_start.target, "targetname" );
//	
//	e_traverse_anchor = util::spawn_model( "tag_origin", s_hendricks_mid_start.origin, s_hendricks_mid_start.angles );
//	level.ai_hendricks LinkTo( e_traverse_anchor );		
//	
//	e_traverse_anchor MoveTo( s_wallrun_start.origin, 1 );
//	e_traverse_anchor waittill( "movedone" );			
//	
//	e_traverse_anchor MoveTo( s_wallrun_end.origin, 1 );
//	e_traverse_anchor waittill( "movedone" );				
//	
//	level.ai_hendricks Unlink();
//	e_traverse_anchor Delete();		
//	
//	//bridge jump
//	nd_hendricks_pre_jump = GetNode( "hendricks_pre_jump", "script_noteworthy" );
//	level.ai_hendricks thread ai::force_goal( nd_hendricks_pre_jump, 32 );
//	level.ai_hendricks waittill( "goal" );
//	level.ai_hendricks.goalradius = 32;	
//
//	s_hendricks_bridge_jump_start = struct::get( "hendricks_bridge_jump_start", "targetname" );
//	s_jump_off = struct::get( s_hendricks_bridge_jump_start.target, "targetname" );
//	s_mid_air = struct::get( s_jump_off.target, "targetname" );
//	s_end_jump_land = struct::get( s_mid_air.target, "targetname" );
//	
//	e_traverse_anchor = util::spawn_model( "tag_origin", s_hendricks_bridge_jump_start.origin, s_hendricks_bridge_jump_start.angles );
//	level.ai_hendricks LinkTo( e_traverse_anchor );
//	
//	e_traverse_anchor MoveTo( s_jump_off.origin, 1 );
//	e_traverse_anchor waittill( "movedone" );	
//	
//	e_traverse_anchor MoveTo( s_mid_air.origin, 0.5 );
//	e_traverse_anchor waittill( "movedone" );	
//	
//	e_traverse_anchor MoveTo( s_end_jump_land.origin, 0.5 );
//	e_traverse_anchor waittill( "movedone" );	
//	
//	level.ai_hendricks Unlink();
//	e_traverse_anchor Delete();	
	
	nd_hendricks_post_jump = GetNode( "hendricks_post_jump", "targetname" );
	level.ai_hendricks thread ai::force_goal( nd_hendricks_post_jump, 32 );
	level.ai_hendricks.goalradius = 32;		

	///second wallrun
	trigger::wait_till( "trig_killspawn_mid", "script_noteworthy" );
	
	nd_hendricks_alley_far = GetNode( "hendricks_alley_far", "targetname" );	
	level.ai_hendricks thread ai::force_goal( nd_hendricks_alley_far, 32 );
	level.ai_hendricks waittill( "goal" );
	level.ai_hendricks.goalradius = 32;	
//	level.ai_hendricks.ignoreall = true;
//	level.ai_hendricks.ignoreme = true;
	
	level flag::wait_till( "player_end_battle" );
	
//	s_hendricks_far_start = struct::get( "s_hendricks_far_start", "targetname" );
//	s_end_wall_run_pos = struct::get( s_hendricks_far_start.target, "targetname" );
//	s_ground_pos = struct::get( s_end_wall_run_pos.target, "targetname" );
//	
//	e_traverse_anchor = util::spawn_model( "tag_origin", s_hendricks_far_start.origin, s_hendricks_far_start.angles );
//	level.ai_hendricks LinkTo( e_traverse_anchor );
//	
//	e_traverse_anchor MoveTo( s_end_wall_run_pos.origin, 1 );
//	e_traverse_anchor waittill( "movedone" );
//	
//	e_traverse_anchor MoveTo( s_ground_pos.origin, 1 );
//	e_traverse_anchor waittill( "movedone" );
//	
//	level.ai_hendricks Unlink();
//	e_traverse_anchor Delete();
//	level.ai_hendricks.ignoreall = false;
//	level.ai_hendricks.ignoreme = false;
	level.ai_hendricks colors::enable();
}

function monitor_alley_death()
{
	self waittill( "death" );

	level.n_threat_in_trig--;
}

function alley_end_battle()
{
	trigger::wait_till( "trig_start_back_alley" );
	
	//guys that are up front and hold a line while the SM populates behind them
	spawner::simple_spawn( "alley_nrc_end_frontline" );
	
	spawn_manager::enable( "sm_alley_nrc_end" );
	
	//spawn ASD's 
	spawner::simple_spawn( "alley_nrc_end_amws" );
	
	trigger::wait_till( "trig_back_alley_end" );
	
	nd_hendricks_pre_vtol = GetNode( "hendricks_pre_vtol", "targetname" );
	level.ai_hendricks thread ai::force_goal( nd_hendricks_pre_vtol, 32 );
	
	level thread alley_cleanup();			
}

// Lighting Shift
////////////////////////////////////////////////////////////////////

// D.E.A.D. Alley
////////////////////////////////////////////////////////////////////
function alley_hunter_crash()
{	
	trigger::wait_till( "alley_hunter_crash_trig", "targetname" );
	
	level thread scene::play( "p7_fxanim_cp_ramses_hunter_alley_drone_bundle" );
	
	//TEMP wait
	wait 2;
	
	a_alley_bridge = GetEntArray( "alley_bridge", "targetname" );
	foreach( e_pieces in a_alley_bridge )
	{
		e_pieces disconnectpaths();
		e_pieces thread fx::play( "large_explosion", e_pieces.origin, e_pieces.angles );
		e_pieces delete();
	}		
	
	a_alley_bridge_destroyed_pieces = GetEntArray( "alley_bridge_destroyed", "targetname" );
	foreach( e_pieces in a_alley_bridge_destroyed_pieces )
	{
		e_pieces connectpaths();
		e_pieces Show();
	}
	
	foreach( e_player in level.players )
	{
		e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );
		Earthquake( 0.65, 0.7, e_player.origin, 128.0 );
	}
	
	wait 2;
	
	a_bridge_building_blowout = GetEntArray( "bridge_building_blowout", "targetname" );
	foreach( e_pieces in a_bridge_building_blowout )
	{
		e_pieces connectpaths();
		e_pieces delete();
	}
	
	level thread temp_delete_hunter_crash_ents();
	
	//TODO: get back to this
	e_dialog_ent = util::spawn_model( "tag_origin", level.players[0].origin, level.players[0].angles );
	e_dialog_ent dialog::say( "rach_there_s_a_friendly_v_0" ); //There's a friendly VTOL crashed up ahead.
	
	wait 5;
	
	e_dialog_ent Delete();
}

function temp_delete_hunter_crash_ents()
{
	a_m_break_01 = GetEntArray( "broken_corner", "targetname" );
	a_m_break_02 = GetEntArray( "tail_breakthrough", "targetname" );
	a_m_crumble = GetEntArray( "wall_crumble", "targetname" );
	
	array::delete_all( a_m_break_01 );
	array::delete_all( a_m_break_02 );
	array::delete_all( a_m_crumble );
}

// Flak Exploders
////////////////////////////////////////////////////////////////////
function flak_exploders()
{
	trigger::wait_till( "ramses_light_shift_1" );
	
	level flag::set( "flak_arena_defend_stop" );
	level thread ramses_util::alley_flak_exploder();
}

// Hunter Crash FX Anims
////////////////////////////////////////////////////////////////////

function hunter_crash_fx_anims()
{
	level clientfield::set( "alley_fxanim_hunters", 1 );
}

function stop_hunter_crash_fx_anims()
{
	level clientfield::set( "alley_fxanim_hunters", 0 );
}

// Objectives
////////////////////////////////////////////////////////////////////

function alley_objectives()
{
	objectives::breadcrumb( "cp_level_ramses_reinforce_safiya_breadcrumb", "alley_temp_obj_trig" );
	objectives::complete( "cp_level_ramses_reinforce_safiya_breadcrumb" );
	
	//wait until player reaches back alley section
	level trigger::wait_till( "trig_start_back_alley" );
	
	//clear breadcrumb when player interacts with back hatch
	objectives::breadcrumb( "cp_level_ramses_vtol_breadcrumb", "trig_use_vtol_igc" );
	objectives::complete( "cp_level_ramses_vtol_breadcrumb" );	
}

// Util
////////////////////////////////////////////////////////////////////

function alley_cleanup()
{
	if ( isdefined( level.ai_khalil ) )
	{
		level.ai_khalil Delete();
	}
	
	cleanup_arena_defend_vehicles();
	
	level flag::wait_till( "dead_alley_complete" );
	
	//TODO: this is hacky, clean this up and make the friendly ai push forward and clean up ai once sumeet gets goal volumes working optimally
	a_ai = GetAITeamArray( "axis", "allies" );
	foreach( e_ai in a_ai )
	{
		if ( isdefined( e_ai.script_friendname ) )
		{
			if ( e_ai.script_friendname == "none" && e_ai != level.ai_hendricks  ) //TODO: change this to a better check.  Probably hero?
			{
				e_ai Kill();
			}
		}
	}
}

function cleanup_arena_defend_vehicles()
{
	a_vh = GetEntArray( "veh_vtol_ride_player_truck_vh", "targetname" );
	foreach( vh in a_vh )
	{
		vh.delete_on_death = true;           vh notify( "death" );           if( !IsAlive( vh ) )           vh Delete();;
	}
}
