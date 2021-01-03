#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_quadtank;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\callbacks_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives; 
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_hacking;
#using scripts\cp\cybercom\_cybercom_util;

#using scripts\cp\cp_mi_sing_sgen;
#using scripts\cp\cp_mi_sing_sgen_enter_silo;
#using scripts\cp\cp_mi_sing_sgen_util;
#using scripts\cp\cp_mi_sing_sgen_sound;

#using scripts\shared\math_shared;

                                                                                       
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                      	                       	     	                                                                     





#precache( "fx", "light/fx_glow_robot_control_gen_2_head" );	

#precache( "objective", "cp_standard_breadcrumb" );
	
//
//
function skipto_intro_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread spawn_qtank_encounter();
	}

	level thread util::set_streamer_hint( 1 );
	level thread intro_technicals();

	sgen::wait_for_all_players_to_spawn();

	level thread temp_fade_in();

	sgen_util::coop_teleport_on_igc_end( "cin_sgen_01_intro_3rd_pre200_overlook_sh060", "post_intro" );
	level scene::add_scene_func( "cin_sgen_01_intro_3rd_pre200_overlook_sh060", &intro_igc_complete, "done" );

	level clientfield::set( "w_flyover_buoys", 1 );
	level scene::play( "cin_sgen_01_intro_3rd_pre100_flyover" );
	level clientfield::set( "w_flyover_buoys", 0 );
	level scene::play( "cin_sgen_01_intro_3rd_pre200_overlook_sh010" );
	
	//wait here until the entire IGC is done, this is called from Hendricks animation
	level flag::wait_till( "intro_igc_done" );
	
	level thread cp_mi_sing_sgen_sound::sndMusicSet( "igc_intro" );
}

function intro_igc_complete( a_ents )
{
	util::clear_streamer_hint();
	
	//This needs to be here to ensure we move from anim to ai smoothly
	level.ai_hendricks = a_ents[ "hendricks" ];

	skipto::objective_completed( "intro" );
}

function skipto_intro_done( str_objective, b_starting, b_direct, player )
{
}


//TEMP For milestone to hide missing geo during intro
function temp_fade_in()
{
	util::screen_fade_out( 0 );
	wait 3;
	util::screen_fade_in( 2 );
}

///////////////////////////////////////////////////////////////////
//	Post Intro IGC Skipto
///////////////////////////////////////////////////////////////////
function skipto_post_intro_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread intro_technicals();
		level thread spawn_qtank_encounter();	
		
		//spawn hendricks here after the intro igc
		sgen::init_hendricks( str_objective );
	
		sgen::wait_for_all_players_to_spawn();
	}	
	
	a_outside_color_triggers = GetEntArray( "outside_color_triggers", "script_noteworthy" );
	foreach( e_trig in a_outside_color_triggers )
	{
		e_trig.script_color_stay_on = true;
	}
	
	//turn off all of the hendricks stealth color chains until player has moved down the hill
	a_trig_hendricks_stealth = GetEntArray( "trig_hendricks_stealth", "script_noteworthy" );
	foreach( e_trig in a_trig_hendricks_stealth )
	{
		e_trig thread monitor_hendricks_color_notify();
	}
	
	if ( !isdefined( level.ai_hendricks ) )
	{
		sgen::init_hendricks( "post_intro" );
	}
	
	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_hendricks colors::set_force_color( "r" );	
	
	// Keep Hendricks under control until they are alerted
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_hendricks ai::set_ignoreme( true );		
	level.ai_hendricks.b_have_assist_target	= false;
	
	//give hendricks a suppresses rifle
	e_hendricks_weapon = GetWeapon( "ar_standard_hero", "suppressed" );
	level.ai_hendricks ai::gun_switchto( e_hendricks_weapon, "right" );	
	
	//hide the enemy battle volumes
	a_enemy_battle_volumes = GetEntArray( "enemy_battle_volumes", "script_noteworthy" );
	foreach( e_vol in a_enemy_battle_volumes )
	{
		//hide the volume
		e_vol Ghost();
	}
	
	level thread sgen_entrance_54i();
	
	//add delay so hendricks says this 
	level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
	level.ai_hendricks ai::set_behavior_attribute( "sprint", true );
	
	//color chain triggered
	trigger::use( "enter_sgen_hendricks" );
	
	//turn off sgen entrance trig - For Natural progression, this is setup in skiptto's
	t_door = GetEnt( "trig_lobby_entrance", "targetname" );
	t_door TriggerEnable( false );	

	level thread intro_obj_breadcrumb();
	
	//ignore players
	foreach( e_player in level.players )
	{
		e_player thread monitor_player_gunfire();
	}
		
	//send vehicles down the road
	level flag::set( "start_technical" );
	
	//on a trigger at the bottom of the hill 
	level flag::wait_till( "start_enter_sgen" );	
	
	skipto::objective_completed( str_objective );
}

//self == trigger
function monitor_hendricks_color_notify()
{
	self endon( "death" );
	level endon( "start_hendricks_move_up_battle_1" );
	
	while( true )
	{
		self waittill( "trigger", e_player );
		
		//check to see if we only have one player
		if ( level.players.size == 1 )
		{
			//TODO
			//this flag gets set when the guys in the left building are killed
			//dont use trigger unless this flag is set
		
			//use the trigger to notify color chain
			trigger::use( self.script_string, "targetname", e_player );
				
			//give enough time for the notify to go through.
			wait 1;
		}
	}
}
	
function skipto_post_intro_done( str_objective, b_starting, b_direct, player )
{
}

///////////////////////////////////////////////////////////////////
//	Enter SGEN
///////////////////////////////////////////////////////////////////
function skipto_enter_sgen_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );
		
		// Keep Hendricks under control until they are alerted
		level.ai_hendricks ai::set_ignoreall( true );
		level.ai_hendricks ai::set_ignoreme( true );		
		level.ai_hendricks.b_have_assist_target	= false;
		
		//give hendricks a suppresses rifle
		e_hendricks_weapon = GetWeapon( "ar_standard_hero" , "suppressed" );
		level.ai_hendricks ai::gun_switchto( e_hendricks_weapon , "right" );
		
		level thread spawn_qtank_encounter();
		level thread intro_technicals( true );
		level thread sgen_entrance_54i();	
		
		sgen::wait_for_all_players_to_spawn();
		
		//send vehicles down the road
		level flag::set( "start_technical" );
		
		//add delay so hendricks says this 
		level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
		level.ai_hendricks ai::set_behavior_attribute( "sprint", true );
	
		//turn off sgen entrance trig
		t_door = GetEnt( "trig_lobby_entrance", "targetname" );
		t_door TriggerEnable( false );		

		//delete the color chains in player space before this skiptot
		a_post_intro_color_trigs = GetEntArray( "post_intro_color_trigs", "targetname" );
		foreach( e_trig in a_post_intro_color_trigs )
		{			
			e_trig Delete();
		}
		
		//get hendricks in position for skipto
		trigger::use( "sgen_skipto_color_chain", undefined, undefined, false );		
		
		a_outside_color_triggers = GetEntArray( "outside_color_triggers", "script_noteworthy" );
		foreach( e_trig in a_outside_color_triggers )
		{
			e_trig.script_color_stay_on = true;
		}		
		
		//turn off all of the hendricks stealth color chains until player has moved down the hill
		a_trig_hendricks_stealth = GetEntArray( "trig_hendricks_stealth", "script_noteworthy" );
		foreach( e_trig in a_trig_hendricks_stealth )
		{
			e_trig thread monitor_hendricks_color_notify();
		}		
		
		level flag::set( "start_enter_sgen" );

		//ignore players
		foreach( e_player in level.players )
		{
			e_player thread monitor_player_gunfire();
		}
		
		//color chain to get hendricks moving up from skipto
		trigger::use( "trig_color_security_exterior" );
	}
	
	objectives::set( "cp_level_sgen_enter_sgen" );	
	
	//this is on a trigger, but also is set when the event goes hot
	level flag::wait_till( "start_enter_sgen" ); 
	
	objectives::set( "cp_level_sgen_clear_entrance" );
	
	level thread player_lobby_entrance();

	level thread stealth_vo();
	level.ai_hendricks thread qtank_fight_hendricks();
	
	level.vh_qtank thread qtank_spawn_and_fight();
	level.vh_qtank thread quadtank_hijacked_watcher();
	level.vh_qtank thread quadtank_death_handler();
	
	//gets called when quad tanks is down
	level flag::wait_till( "intro_quadtank_dead" );
	level thread cp_mi_sing_sgen_sound::sndMusicSet( "quadtank_intro", true );
	
	//TEMP kill off all remaining enemy ai
	a_axis = GetAITeamArray( "axis" );
	foreach( e_ai in a_axis )
	{
		e_ai kill();
	}
	
	level flag::set( "qtank_fight_completed" );

	skipto::objective_completed( str_objective );
}

function stealth_vo()
{
	level endon( "exterior_gone_hot" );

	level.ai_hendricks dialog::say( "hend_54i_crawling_all_ove_0" );
	level.ai_hendricks dialog::say( "hend_waiting_on_your_shot_0", 1 );	
}

function intro_obj_breadcrumb()
{
	level endon( "exterior_gone_hot" );
	
	//1
	s_obj_intro_breadcrumb_1 = struct::get( "obj_intro_breadcrumb_1", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_obj_intro_breadcrumb_1 );	

	trigger::wait_till( "trig_obj_1" )
	objectives::complete( "cp_standard_breadcrumb", s_obj_intro_breadcrumb_1 );	
	
	//2
	s_obj_intro_breadcrumb_2 = struct::get( "obj_intro_breadcrumb_2", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_obj_intro_breadcrumb_2 );	
	
	trigger::wait_till( "trig_obj_2" )
	objectives::complete( "cp_standard_breadcrumb", s_obj_intro_breadcrumb_2 );	
	
	//3
	s_obj_intro_breadcrumb_3 = struct::get( "obj_intro_breadcrumb_3", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_obj_intro_breadcrumb_3 );		
	
	trigger::wait_till( "trig_obj_3" )
	objectives::complete( "cp_standard_breadcrumb", s_obj_intro_breadcrumb_3 );	
}

//self = player
function monitor_player_gunfire()
{
	self endon( "death" );
	
	self thread monitor_exterior_gunfire();
	
	level flag::wait_till( "exterior_gone_hot" );
	
	level notify( "stop_patrolling" );
}

//	self is a player
function monitor_exterior_gunfire()
{
	self endon( "death" );

	level endon( "exterior_gone_hot" );
	level endon( "stop_patrolling" );
	
	w_current_weapon = self getCurrentWeapon();

	while( true )
	{
		self waittill( "weapon_fired" );

		w_current_weapon = self getCurrentWeapon();
		
		if ( !WeaponHasAttachment( w_current_weapon, "suppressed" ) )
		{
			level flag::set( "exterior_gone_hot" );
		}
	}
}

function skipto_enter_sgen_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_sgen_clear_entrance" );
}

function force_exit_exterior_stealth()
{
	level endon( "exterior_gone_hot" );
	
	level.n_dead_bodies = 0;	
	
	//get the closest dead body to the player
	//grab that body
	//play an effect on a tag radio or something 
	//play audio on him
	//wait 2 seconds
	//options
		//grab closest guy and have him run to the location of the body
		//have hendricks call this out
		//set the even hot	
	
	//wait until we hit x amount of corpses, then kick out of this loop
	while( 1 )
	{
		if ( level.n_dead_bodies >= 5 )
		{
			break;	
		}
		
		wait 1;
	}	
	
	//allow some time for the corpse to be identified
	wait 0.5;
	
	//now run logic on corpses
	a_dead_bodies = GetCorpseArray();
	e_closest_corpse = array::get_closest( level.players[0].origin, a_dead_bodies );

	//spawn struct here on corpse
	e_closest_corpse_pos = util::spawn_model( "tag_origin", e_closest_corpse.origin, e_closest_corpse.angles );
	a_ai_enemies = GetAITeamArray( "axis" );
	ai_closest_enemy_to_corpse = array::get_closest( level.players[0].origin, a_ai_enemies );
	
	//TODO: waiting for the effect, Dale has a DT on this
	//fx to play on the corpse
//	e_closest_corpse_pos thread fx::play( ROBOT_EYE_FX, e_closest_corpse_pos.origin, e_closest_corpse_pos.angles, 10, true );	

	//Commented until approvals on easter egg to respond to radio call.	
//	while ( !level flag::get( "exterior_gone_hot" ) )
//	{
//		if ( DistanceSquared( level.players[0].origin, e_closest_corpse_pos.origin ) < ( 70 * 70 ) )
//		{
//			util::screen_message_create( "Press and Hold ^3[{+activate}]^7 to respond." );
//			
//			if ( level.players[0] UseButtonPressed() )
//			{
//				util::screen_message_delete();
//				break;
//			}
//		}
//		else
//		{
//			util::screen_message_delete();
//		}
//		
//		wait 0.05;	
//	}
//	
//	util::screen_message_delete();
	
	//blocking call for him to run to corpse
	ai_closest_enemy_to_corpse thread responder_run_to_corpse( e_closest_corpse_pos );
}

//self = ai_closest_enemy_to_corpse
function responder_run_to_corpse( e_search_pos )
{
	self endon( "death" );
	
	self thread monitor_responder_death();

	self notify( "stop_patrolling" );
		
	self.should_stop_patrolling = false;
	
	self ai::set_behavior_attribute( "sprint", true );		
	self ai::force_goal( e_search_pos.origin, 64, true );
	
	/#
		IPrintLnBold( "54i Enemy: ALARM!! ALARM!!!" );
	#/
	
	//force the event hot
	level flag::set( "exterior_gone_hot" );		
}

function monitor_responder_death()
{
	self waittill( "death" );
	level flag::set( "exterior_gone_hot" );
}

function enable_battle_volumes()
{
	//turns on the giant enemy battle volumes
	level flag::wait_till( "enable_battle_volumes" );	
	
	a_enemy_battle_volumes = GetEntArray( "enemy_battle_volumes", "script_noteworthy" );
	foreach( e_vol in a_enemy_battle_volumes )
	{
		//show the volume
		e_vol Show();
	}

	//delete reaction volumes
	a_vol_enemy_reaction = GetEntArray( "vol_enemy_reaction", "script_noteworthy" );
	array::run_all( a_vol_enemy_reaction, &Delete );
}

//	Spawns the 54i in the initial setup
function sgen_entrance_54i()
{	
	level.is_ai_attempting_alert = false;

	level thread enable_battle_volumes();
		
	level thread force_exit_exterior_stealth();
	
	spawner::add_spawn_function_group( "enemy_enter_sgen", "targetname", &setup_exterior_guy );
	spawner::add_spawn_function_group( "exterior_patroller", "targetname", &setup_exterior_guy );
	spawner::add_spawn_function_group( "quadtank_reinforcement_guy", "targetname", &setup_quadtank_reinforcement_guy );

	spawner::simple_spawn( "enemy_enter_sgen" );
	spawner::simple_spawn( "exterior_patroller" );
	
	//Turning off Battlechatter until stealth is over
	level.allowbattlechatter["bc"] = false;
	
	// We've woken the hive!
	level flag::wait_till( "exterior_gone_hot" );
	
	clear_objective_breadcrumbs();
	
	//Turning back on battlechatter
	level.allowbattlechatter["bc"] = true;
	
	//remove the player radio if it exists
	trig_player_corpse_radio = GetEnt( "trig_player_corpse_radio", "targetname" );
	if ( isdefined( trig_player_corpse_radio ) )
	{
		trig_player_corpse_radio Delete();
	}
	
	//complete the objective
	//send the driveway guys to cover during skipto's
	level flag::set( "start_enter_sgen" );	
	
	//remove the color chain triggers
	a_t_color = GetEntArray( "color_enter_sgen", "script_noteworthy" );
	array::run_all( a_t_color, &Delete );

	spawner::waittill_ai_group_amount_killed( "exterior_guys", 8 );
	
	level flag::set( "start_hendricks_move_up_battle_1" );
	
	spawner::waittill_ai_group_amount_killed( "exterior_guys", 12 );	
	
	level flag::set( "start_hendricks_move_up_battle_2" );
	
	//wait until x amount are dead, then have them fall back
	spawner::waittill_ai_group_amount_killed( "exterior_guys", 18 );

	//spawn qt tank and move hendricks up
	level flag::set( "spawn_quad_tank" );
	
	level thread cp_mi_sing_sgen_sound::sndMusicSet( "quadtank_intro" );
	
	spawner::waittill_ai_group_amount_killed( "exterior_guys", 25 );
	
	level flag::set( "fallback_to_qt" );
}

function clear_objective_breadcrumbs()
{
	s_obj_intro_breadcrumb_1 = struct::get( "obj_intro_breadcrumb_1", "targetname" );
	s_obj_intro_breadcrumb_2 = struct::get( "obj_intro_breadcrumb_2", "targetname" );
	s_obj_intro_breadcrumb_3 = struct::get( "obj_intro_breadcrumb_3", "targetname" );
	
	objectives::complete( "cp_standard_breadcrumb", s_obj_intro_breadcrumb_1 );	
	objectives::complete( "cp_standard_breadcrumb", s_obj_intro_breadcrumb_2 );	
	objectives::complete( "cp_standard_breadcrumb", s_obj_intro_breadcrumb_3 );	
}

function setup_quadtank_reinforcement_guy()
{
	self endon( "death" );

	e_vol_enemy_end = GetEnt( "vol_enemy_end", "targetname" );
	self SetGoal( e_vol_enemy_end, true );	
	
	//notify from quad tank animation
	level waittill( "enemies_react" );
	
	//wait a second or two to add a stagger effect of them turning around
	wait ( RandomFloatRange( 1, 3 ) );	

	self ClearGoalVolume();	
	
	a_nd_attack_quadtank = GetNodeArray( "nd_attack_quadtank", "targetname" );
	foreach( nd_attack in a_nd_attack_quadtank )
	{
		//set their immediate goal volume, and force them there
		self thread ai::force_goal( nd_attack, 32, true );				
	}
	
	//ignore players
	foreach( e_player in level.players )
	{
		self SetIgnoreEnt( e_player, true );
	}
	
	//ignore hendricks
	self SetIgnoreEnt( level.ai_hendricks, true );
	
	self thread monitor_player_damage();
	
	//wait and fire at the guard node, then take cover from the quad tank
	wait ( RandomFloatRange( 8, 11 ) );

	//stop ignoring hendricks, since they may get close to him at this point
	self SetIgnoreEnt( level.ai_hendricks, false );		
	
	e_vol_enemy_end = GetEnt( "vol_enemy_end", "targetname" );
	self SetGoal( e_vol_enemy_end, true );	

	//wait in this volume for a bit then force the turn around on the player
	wait ( RandomFloatRange( 3, 5 ) );	
	
	self notify( "end_damage_monitor" );
	
	//stop ignoring players
	foreach( e_player in level.players )
	{
		self SetIgnoreEnt( e_player, false );
	}		
}

//self = ai
function monitor_player_damage()
{
	self endon( "end_damage_monitor" );
	
	self waittill( "damage" );
	
	//stop ignoring players
	foreach( e_player in level.players )
	{
		self SetIgnoreEnt( e_player, false );
	}	
	
	//stop ignoring hendricks
	self SetIgnoreEnt( level.ai_hendricks, false );	
}


//	self is an AI
function setup_exterior_guy()
{
	self endon( "death" );
	self endon( "corpse_responding" );
	
	self thread monitor_enemy_death_count();
	self thread sndFakeRadios();
	
	setup_ai_for_stealth();
	
	//for patrollers
	if ( isdefined( self.script_string ) )
	{
		//gets patrollers start node and sets some settings on self
		nd_start_node = get_patrol_path_node();
	
		//start path or wait to start path
		self thread patrol_exterior_path( nd_start_node );
	}

	//script bundle scenes are on these guys to play the bundle set on them
	if ( isdefined( self.script_noteworthy ) )
	{
		scene::add_scene_func( "cin_sgen_02_05_exterior_vign_using_ipad_guy01", &monitor_tablet_drop, "play" );	
		
		self thread scene::play( self.script_noteworthy, self ); //cin_sgen_02_05_exterior_vign_using_ipad_guy01
	}
	
	level flag::wait_till( "exterior_gone_hot" );

	//set him back to normal
	revert_back_to_default();
	
	//sniper in left building wait until about mid battle
	if ( self.b_ignore_goal_volumes === true ) 
	{
		level flag::wait_till( "start_hendricks_move_up_battle_2" );
	}
	
	//these enemies are on top of the catwalks and big rig, they should just take cover here
	if ( isdefined( self.str_attack_node )  )
	{
		nd_attack_node = GetNode( self.str_attack_node, "targetname" );
		self ai::force_goal( nd_attack_node.origin, 32, true );
		
		//stay here until he dies or when event ends 
		level waittill( "forever" );
	}	
	
	//stay in cover where you are when things go hot
	a_vol_enemy_reaction = GetEntArray( "vol_enemy_reaction", "script_noteworthy" );
	foreach( e_vol in a_vol_enemy_reaction )
	{
		if ( self IsTouching( e_vol ) )
		{
			//grab that specific volume for that area via targetname
			e_enemy_reaction_vol = GetEnt( e_vol.targetname, "targetname" );
			
			self SetGoal( e_enemy_reaction_vol, true );
		}
		else
		{
			//for patrollers that dont have individual reaction volumes to use when stealth breaks
			a_vol_hendricks_stealth = GetEntArray( "vol_hendricks_stealth", "targetname" );
			foreach( e_vol in a_vol_hendricks_stealth )
			{	
				if ( self IsTouching( e_vol ) )
				{
					self SetGoal( e_vol, true );
				}
			}
		}
	}

	//take cover here for a while, a set time because they could look coordinated if they share the volume with someone
	wait ( RandomFloatRange( 10, 12 ) );
	self ClearGoalVolume();	
	
	//turns on the giant enemy battle volumes
	level flag::set( "enable_battle_volumes" );
	
	//use volume that engulfs majority of the circular driveway until player pushes event forward
	e_goal_vol = GetEnt( "vol_exterior_area", "targetname" );
	self SetGoal( e_goal_vol, true );
	
	//setup volumes to where hendricks paths
	level flag::wait_till( "start_hendricks_move_up_battle_1" );
	self ClearGoalVolume();	
	
	e_vol_enemy_middle = GetEnt( "vol_enemy_middle", "targetname" );
	self SetGoal( e_vol_enemy_middle, true );
	
	level flag::wait_till( "start_hendricks_move_up_battle_2" );
	self ClearGoalVolume();	
	
	e_vol_enemy_end = GetEnt( "vol_enemy_end", "targetname" );
	self SetGoal( e_vol_enemy_end, true );
}

function sndFakeRadios()
{
	self endon( "death" );
	level endon( "exterior_gone_hot" );
	
	while(1)
	{
		wait(randomintrange(5,15));
		self playsound( "amb_enemy_fake_radio" );
	}
}

function monitor_tablet_drop( a_scene_ents )
{
	mdl_tablet = a_scene_ents[ "tablet" ];

	mdl_tablet endon( "death" );
	
	//if player shoots the tablet, itll drop and go hot
	mdl_tablet thread monitor_tablet_damage();
	
	//once we go hot, we drop the tablet in physics
	level flag::wait_till( "exterior_gone_hot" );
	
	//so we dont kill performance, this animation is temp
	wait ( RandomFloatRange( 0.05, 0.10 ) );
	
	mdl_tablet PhysicsLaunch( self.origin, (0,0,-1) );
}

//self = tablet
function monitor_tablet_damage()
{
	level endon( "exterior_gone_hot" );
	
	self setcandamage( true );
	self waittill( "damage" );
	
	level flag::set( "exterior_gone_hot" );
}

//ai = self
function setup_ai_for_stealth()
{	
	//run logic where enemy animates a radio call to set the event hot if he is not killed	
	self thread check_for_alert();
	
	//Get them to stay in place until I get idle anims
	self.goalradius = 32;
	self.old_MaxSightDistSqrd = self.MaxSightDistSqrd;
	self.MaxSightDistSqrd = 256 * 256;
	self.fovCosine = 0.8;	
}

//ai = self
function revert_back_to_default()
{
	self.goalradius = 2048;
	self.MaxSightDistSqrd = self.old_MaxSightDistSqrd;
	self.fovCosine = 0;	
	
	//kills patrolling behavior
	self.should_stop_patrolling = true;
	
	//if the guy is in an idle scene
	//we need reaction animations
	if ( isdefined( self.script_noteworthy ) )
	{	
		sgen_util::scene_stop_if_active( self.script_noteworthy );
	}
}

function get_patrol_path_node()
{
	switch( self.script_string )
	{
		case "front_driveway_left":
			nd_start_path = GetNode( "nd_front_driveway_left", "targetname" );
		break;
		case "cargo_truck_driver":
			nd_start_path = GetNode( "nd_cargo_truck_driver", "targetname" );
			self.str_flag_wait = "start_vehicle_patrols";
			
			//put AI in driver manually, force teleport him in
			self vehicle::get_in( level.e_intro_cargo_truck , "driver", true );			
		break;
		case "cargo_truck_passenger":
			nd_start_path = GetNode( "nd_cargo_truck_passenger", "targetname" );
			self.str_flag_wait = "start_vehicle_patrols";
			
			//put AI in passenger manually, force teleport him in
			self vehicle::get_in( level.e_intro_cargo_truck, "passenger1", true );			
		break;
		case "front_driveway_left_platform":
			nd_start_path = GetNode( "nd_front_driveway_left_platform", "targetname" );
		break;
		case "front_driveway_right_platform":
			nd_start_path = GetNode( "nd_front_driveway_right_platform", "targetname" );
		break;
		case "front_driveway_back":
			nd_start_path = GetNode( "nd_front_driveway_back", "targetname" );
		break;
		case "left_walkway":
			nd_start_path = GetNode( "nd_left_walkway", "targetname" );
			self.str_attack_node = "nd_left_walkway_attack";
		break;
		case "right_walkway":
			nd_start_path = GetNode( "nd_right_walkway", "targetname" );
			self.str_attack_node = "nd_right_walkway_attack";
		break;
		case "big_rig_roof_guy":
			nd_start_path = GetNode( "nd_big_rig", "targetname" );
			self.str_attack_node = "nd_bigrig_attack"; 
		break;
		case "right_truck_driver":
			nd_start_path = GetNode( "nd_patrol_right_truck_driver", "targetname" );
			self.str_flag_wait = "start_vehicle_patrols";
			
			//put AI in driver manually, force teleport him in
			self vehicle::get_in( level.e_technical_fountain_right, "driver", true );
		break;
		case "right_driveway_path":
			nd_start_path = GetNode( "nd_right_driveway_path", "targetname" );
			self.str_flag_wait = "start_enter_sgen";
			self thread exterior_battle_stealth_assist();
		break;
		case "left_driveway_path":
			nd_start_path = GetNode( "nd_left_driveway_path", "targetname" );
			self.str_flag_wait = "start_enter_sgen";
			self thread exterior_battle_stealth_assist();
		break;
		case "security_guy_right":
			nd_start_path = GetNode( "nd_security_guy_right_path", "targetname" );
			self.str_flag_wait = "trig_security_room";
			self thread exterior_battle_stealth_assist();
		break;		
		case "security_guy_left":
			nd_start_path = GetNode( "nd_security_guy_left_path", "targetname" );
			self.str_flag_wait = "trig_security_room";
			self thread exterior_battle_stealth_assist();
		break;
		case "left_building_enemy":
			nd_start_path = GetNode( "nd_left_building_enemy_path", "targetname" );
			self.str_flag_wait = "trig_left_exterior_building";
			self.b_ignore_goal_volumes = true;
			self thread exterior_battle_stealth_assist();
		break;	
	}	
	
	return nd_start_path;
}

//self = ai
function monitor_enemy_death_count()
{
	level endon( "exterior_gone_hot" );
	
	self waittill( "death" );
	level.n_dead_bodies++;
	
	//if this is the left_building sniper, then trigger color chain on solo play
	if ( self.script_string === "left_building_enemy" )
	{
		//only occur on solo play
		if ( level.players.size == 1)
		{
			trigger::use( "trig_color_left_exterior_building_upstairs" );
		}
	}
}

//this should only run on enemies who are near someone on the outer perimeter of the battle space
//self is an enemy
function exterior_battle_stealth_assist()
{
	level endon( "exterior_gone_hot" );
	self endon( "assisted_kill" );
	
	self.b_assisted_kill_guy = true;
	
	//driveway guy that patrols to the middle has this on his node 
	//once he gets too far away and rejoins other enemies
	self endon( "stop_assisted_kill" ); 
	
	self waittill( "death", e_attacker );	
	
	//if the player killed him and stealth is not broken
	if( IsPlayer( e_attacker ) & !level flag::get( "exterior_gone_hot" ) )
	{
		//grab the closest ai to this one
		a_axis = GetAITeamArray( "axis" );
		
		ai_close = array::get_closest( self.origin, a_axis, 512 );
		
		if ( isdefined( ai_close ) && DistanceSquared( self.origin, ai_close.origin ) < ( 512 * 512 ) )
		{
			if ( IsAlive( ai_close ) )
			{	
				//kill alert scripts because he's entering the radio anim here
				ai_close notify( "stealth_assist_alerted" );			
			
				ai_close thread scene::play( "cp_prologue_alerting_scene", ai_close );		
			}
				
			//wait a bit then run a check if hendricks can actually see the closest enemy, then if he can shoot him in the head
			wait ( RandomFloatRange( 0.4, 0.8 ) );
			
			//check to see if he's already shooting at someone
			if ( !level.ai_hendricks.b_have_assist_target )
			{					
				//he is someone we setup as an assisted kill
				if ( ai_close.b_assisted_kill_guy === true )
				{					
					//check to see if hendricks can actually see him
					if( level.players.size == 1 && !util::within_fov( level.ai_hendricks.origin, level.players[0].angles, level.players[0].origin, cos(70.0) ) )
	    			{
						level.ai_hendricks.b_have_assist_target = true;
	    				
						vec_directionToHendricks =  VectorNormalize( level.ai_hendricks GetEye() - ai_close GetEye() );
						vec_bulletStartOrigin = ai_close GetEye() + VectorScale( vec_directionToHendricks, 300 );
						vec_bulletEndOrigin = ai_close GetEye();
						MagicBullet( level.ai_hendricks.weapon, vec_bulletStartOrigin, vec_bulletEndOrigin, level.ai_hendricks );
	    				
						//end this guys stealth assist thread
						ai_close notify( "assisted_kill" );	    				

	    				//kill ai_close	
						ai_close kill( vec_bulletStartOrigin, level.ai_hendricks );
						
//						//TODO: need VO SFX here
//						if ( math::cointoss() )
//						{
//							//ill take the other guy
//								level.ai_hendricks thread dialog::say( "Enemy down." );
//							
//						}
//						else
//						{
//							//ill take the other guy
//							level.ai_hendricks thread dialog::say( "Target down." );
//						}
					
	    			}
				}
			}
			else
			{
//				//TODO: need VO SFX here
				//hendricks can't see the target
//				level.ai_hendricks thread dialog::say( "I don't have sights on target!" );
				
				if ( IsAlive( ai_close ) )
				{				
					//function within_fov( start_origin, start_angles, end_origin, fov )
					// if there is a close AI, at this point he is not targettable by Hendricks. So, if he is seeing this current guy, we set him off.
					if ( IsDefined( ai_close ) && util::within_fov( ai_close.origin, ai_close.angles, self.origin, cos(70.0) ) )
					{
						//end this guys stealth assist thread
						ai_close notify( "assisted_kill" );	    
							
						//kill alert scripts because he's entering the radio anim here
						ai_close notify( "stealth_assist_alerted" );			
						
	
						ai_close thread scene::play( "cp_prologue_alerting_scene" , ai_close );		
				
						level flag::set( "exterior_gone_hot" );
					}
				}
			}
		}
		else
		{
			level notify( "positive_kill" );
		}
	}
}

//self = ai patroller
function patrol_exterior_path( nd_start_path )
{
	self endon( "death" );
	level endon( "exterior_gone_hot" );
	
	//this is for the intro right truck driver
	if ( isdefined( self.str_flag_wait ) && !level flag::get( "exterior_gone_hot" ) )
	{
		level flag::wait_till( self.str_flag_wait );
		
		self thread ai::patrol( nd_start_path );
	}
	else
	{
		self thread ai::patrol( nd_start_path );	
	}	
}

//	54I technical rolls down the hill to the entrance
function intro_technicals( b_skip_to_end = false )
{
	level.W_QUADTANK_PLAYER_WEAPON = GetWeapon( "quadtank_main_turret_player" );
	level.W_QUADTANK_MLRS_WEAPON = GetWeapon( "quadtank_main_turret_rocketpods_straight" );
	level.W_QUADTANK_MLRS_WEAPON2 = GetWeapon( "quadtank_main_turret_rocketpods_javelin" );	
	
	if ( b_skip_to_end )
	{
		//spawn vehicle and set its angles and origins to the struct in place
		level.e_technical_fountain_right = vehicle::simple_spawn_single( "technical_fountain_right" );	
		level.e_technical_fountain_right SetSeatOccupied( 0 );
		level.e_technical_fountain_right thread exterior_vehicle_damagefunc();
		
		e_technical_fountain_left = vehicle::simple_spawn_single( "technical_fountain_left" );
		e_technical_fountain_left SetSeatOccupied( 0 );		
		e_technical_fountain_left thread truck_gunner_replace( level.players.size, 2.5, "start_hendricks_move_up_battle_2" );
		e_technical_fountain_left thread exterior_vehicle_damagefunc();
		
		level.e_intro_cargo_truck = vehicle::simple_spawn_single( "intro_cargo_truck" );	
		level.e_intro_cargo_truck SetSeatOccupied( 0 );		
		level.e_intro_cargo_truck thread exterior_vehicle_damagefunc();

		//send the vehicles on their paths
		level flag::wait_till( "start_technical" );
		
		wait 1;  //give time for guys to get into vehicles first

		//notify unload on right technical so guys get out
		level.e_technical_fountain_right vehicle::unload( "all" );
		level.e_intro_cargo_truck vehicle::unload( "all" );
		
		//kicks off patrol logic in spawn function
		level flag::set( "start_vehicle_patrols" );
	}
	else
	{
		//spawn vehicle and set its angles and origins to the struct in place
		level.e_technical_fountain_right = vehicle::simple_spawn_single( "technical_fountain_right" );
		level.e_technical_fountain_right SetSeatOccupied( 0 );
		level.e_technical_fountain_right thread exterior_vehicle_damagefunc();
		
		e_technical_fountain_left = vehicle::simple_spawn_single( "technical_fountain_left" );
		e_technical_fountain_left SetSeatOccupied( 0 );		
		e_technical_fountain_left thread truck_gunner_replace( level.players.size, 2.5, "start_hendricks_move_up_battle_2" );
		e_technical_fountain_left thread exterior_vehicle_damagefunc();
		
		//Technical left of fountainl
		level.e_intro_cargo_truck = vehicle::simple_spawn_single( "intro_cargo_truck" );
		level.e_intro_cargo_truck thread exterior_vehicle_damagefunc();
			
		//send the vehicles on their paths
		level flag::wait_till( "start_technical" );
		
		wait 1;  //give time for guys to get into vehicles first
		
		//notify unload on right technical so guys get out
		level.e_technical_fountain_right vehicle::unload( "all" );
		level.e_intro_cargo_truck vehicle::unload( "all" );
		
		//kicks off patrol logic in spawn function
		level flag::set( "start_vehicle_patrols" );
	}
}

function intro_truck_path( str_start_node )
{
	self setcandamage( false );
	self playsound( "evt_sgen_technical_drive" );
	self thread vehicle::get_on_and_go_path( str_start_node );
	
	//disconnect navmesh when the truck reaches end node
	self waittill( "reached_end_node" );
	self disconnectpaths();
	self setcandamage( true );
	
}

//
//	Spawn the quadtank in the rubble and the 54i around it
function spawn_qtank_encounter()
{
	if ( isdefined( level.vh_qtank ) )
	{
		return;
	}

	level.vh_qtank = spawner::simple_spawn_single( "entrance_qtank" );
	level.vh_qtank.ignoreme = true;
	level.vh_qtank.animname = "entrance_qtank";
	level.vh_qtank.team = "team3";		// Super Soldier-controlled tank
	//level.vh_qtank.health = 3250; //cut the qt's health in half
	
	RadiusDamage( level.vh_qtank.origin, level.vh_qtank.radius, 2500, 2500, undefined, "MOD_UNKNOWN", level.weaponnone );
	level.vh_qtank SetCanDamage( false );
	
	//turn QT on.
	level.vh_qtank quadtank::quadtank_off();
	level thread scene::init( "cin_sgen_03_01_qt_attack_vign_reveal_qt01" );
	level thread scene::init( "p7_fxanim_cp_sgen_quadtank_reveal_debris_bundle" );
	level waittill( "tankOn" ); //added to fix bug with audio not playing on the quadtank
}

//self = hendricks
function qtank_fight_hendricks()
{
	level flag::wait_till( "exterior_gone_hot" );
	
	//Play vo only if any player had a silenced weapon
	//Didn’t I tell you we couldn’t keep this quiet?!!
	//check to see if the player brought in a suppressed weapon
	foreach( e_player in level.players )
	{
		w_current_weapon = e_player getCurrentWeapon();
		
		//check to see if the player has a suppressed weapon and set level flag for vo
		if ( WeaponHasAttachment( w_current_weapon, "suppressed" ) )
		{
			level flag::set( "player_has_silenced_weap" );
		}
	}
		
	if ( level flag::get( "player_has_silenced_weap" ) )
	{
		level.ai_hendricks thread dialog::say( "hend_didn_t_i_tell_you_we_0" );
	}
	
	level.ai_hendricks ai::set_ignoreall( false );
	level.ai_hendricks ai::set_ignoreme( false );
	
	//disable cqb sprint, and only use sprint
	level.ai_hendricks ai::set_behavior_attribute( "cqb", false );
	level.ai_hendricks ai::set_behavior_attribute( "sprint", true );	
	
	//disable color on hendircks
	//grab all of the volumes
	//check which one hendricks is touching
	//have him use that volume
	//wait until x amount of guys are killed
	//then kick him out of that volume
	//have him head towards the middle driveway path and push the event forward

	//check to see if hendricks is in any of his stealth volumes at the bottom of the hill
	if ( !level flag::get( "hendricks_on_hill" ) ) //trigger only set to AI at the bottom of the hill
	{
		trigger::use( "trig_color_security_exterior" );
	}
	
	a_vol_hendricks_stealth = GetEntArray( "vol_hendricks_stealth", "targetname" );
	while ( !level flag::get( "start_hendricks_move_up_battle_1" ) )
	{
		foreach( e_vol in a_vol_hendricks_stealth )
		{
			if ( level.ai_hendricks IsTouching( e_vol ) && e_vol.b_hendricks_in_vol === true )
			{
				e_vol.b_hendricks_in_vol = true;
				
				//grab that specific volume for that area
				level.ai_hendricks.e_current_vol = GetEnt( e_vol.script_noteworthy, "targetname" );
		
				level.ai_hendricks SetGoal( level.ai_hendricks.e_current_vol, true );
				
				//wait until he leaves this volume
				if ( !level.ai_hendricks IsTouching( level.ai_hendricks.e_current_vol ) )
				{	
					wait 1;
				}
				
				e_vol.b_hendricks_in_vol = false;
			}
		}
	
		wait 5;	
	}
	
	//clear his goal volumetrig_color_exterior_fight
	level.ai_hendricks ClearGoalVolume();
	
	//determine which path hendricks should take this point
	foreach( e_vol in a_vol_hendricks_stealth )
	{
		if ( level.ai_hendricks IsTouching( e_vol ) )
		{
			switch( e_vol.script_noteworthy )
			{
				case "vol_security_room":
					//path through security right
					level.b_hendricks_right_path = true;
				
					trig_color_stop_1 = GetEnt( "trig_color_move_security_1", "targetname" );
					trig_color_stop_2 = GetEnt( "trig_color_move_security_2", "targetname" );		
					trig_color_stop_3 = GetEnt( "trig_color_move_security_3", "targetname" );					
				break;
				case "vol_driveway": //middle
					level.b_hendricks_right_path = false;
				
					trig_color_stop_1 = GetEnt( "trig_color_move_middle_1", "targetname" );
					trig_color_stop_2 = GetEnt( "trig_color_move_middle_2", "targetname" );
					trig_color_stop_3 = GetEnt( "trig_color_move_middle_3", "targetname" );
				break;
				case "vol_left_building_exterior":
					level.b_hendricks_right_path = false;
				
					//path from left building out to the fountain area
					trig_color_stop_1 = GetEnt( "trig_color_left_building_1", "targetname" );
					trig_color_stop_2 = GetEnt( "trig_color_left_building_2", "targetname" );			
					
					//use the last middle color chain
					trig_color_stop_3 = GetEnt( "trig_color_move_middle_3", "targetname" );
				break;
				case "vol_left_building":
					level.b_hendricks_right_path = false;
				
					//path through security right
					trig_color_stop_1 = GetEnt( "trig_color_left_building_1", "targetname" );
					trig_color_stop_2 = GetEnt( "trig_color_left_building_2", "targetname" );				

					//use the last middle color chain
					trig_color_stop_3 = GetEnt( "trig_color_move_middle_3", "targetname" );					
				break;
				default:
					level.b_hendricks_right_path = false;
				
					//setup default path through middle 
					trig_color_stop_1 = GetEnt( "trig_color_move_middle_1", "targetname" );
					trig_color_stop_2 = GetEnt( "trig_color_move_middle_2", "targetname" );
					trig_color_stop_3 = GetEnt( "trig_color_move_middle_3", "targetname" );
				break;
			}
		}
	}
	
	//fail safe until we get color goal volumes to work
	if ( !isdefined( trig_color_stop_1 ) )
	{
		trig_color_stop_1 = GetEnt( "trig_color_move_middle_1", "targetname" );
	}
	if ( !isdefined( trig_color_stop_2 ) )
	{
		trig_color_stop_2 = GetEnt( "trig_color_move_middle_2", "targetname" );
	}	
	if ( !isdefined( trig_color_stop_3 ) )
	{
		trig_color_stop_3 = GetEnt( "trig_color_move_middle_3", "targetname" );
	}	
	
	//move up to the first stop
	trigger::use( trig_color_stop_1.targetname );
	
	level flag::wait_till( "start_hendricks_move_up_battle_2" );
	
	//move up to the second stop
	trigger::use( trig_color_stop_2.targetname );	

	level flag::wait_till( "spawn_quad_tank" );
	
	//move up to the third stop
	trigger::use( trig_color_stop_3.targetname );
}

function quadtank_hijacked_watcher()
{
	level endon( "intro_quadtank_dead" );
	
	while( 1 )
	{
		level waittill( "ClonedEntity", e_clone);

		if ( isdefined( e_clone.scriptvehicletype ) && ( e_clone.scriptvehicletype == "quadtank" ) )
		{
			level flag::set( "quadtank_hijacked" );
			
			e_clone thread quadtank_hijacked_death_handler();
		}
	}
}

//	self is a quad tank
function qtank_spawn_and_fight()
{
	level endon( "quadtank_hijacked" );
			
	//obj_sgen_behind_qt breadcrumb
	s_obj_sgen_behind_qt = struct::get( "obj_sgen_behind_qt", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_obj_sgen_behind_qt );	
	
	level flag::wait_till( "spawn_quad_tank" );
	
	//check to see if we are in stealth or not
	level flag::wait_till( "exterior_gone_hot" );
	
	s_obj_sgen_behind_qt = struct::get( "obj_sgen_behind_qt", "targetname" );
	objectives::complete( "cp_standard_breadcrumb", s_obj_sgen_behind_qt );		
	
	//spawn guys who come specifically to shoot the quadtank
	spawner::simple_spawn( "quadtank_reinforcement_guy" );
	
	level flag::set( "qtank_active" );
	level notify( "tankOn" ); 
	
	//have ai start firing on him right as he begins getting up
	self.ignoreme = false;
	
	setup_quad_tank_battle_vo_arrays();
	
	self thread quadtank_fight_vo();
	
	// Quadtank emerges from the rubble
	self thread qtank_fight_notetracks();
	level thread scene::play( "p7_fxanim_cp_sgen_quadtank_reveal_debris_bundle" );
	level scene::play( "cin_sgen_03_01_qt_attack_vign_reveal_qt01" );
	
	callback::on_vehicle_damage( &monitor_quadtank_health, self );
	self thread monitor_trophy_system_disabled();
	self thread monitor_trophy_system_destroyed();
	
	self thread qt_trophy_system_destroy_watcher();
	
	//place destroy icon on quad tank
	objectives::set( "cp_level_sgen_destroy_tower", self );
	
	self SetCanDamage( true );	// the scene is going to force candamage off again
	self quadtank::quadtank_on();
	self.goalradius = 512;
	self setneargoalnotifydist( 128 );
	
	self thread quadtank_movement_think();

	self waittill( "death" );
	
	level flag::set( "intro_quadtank_dead" );
	
	//Core Destabilized. Quad Tank is out of commission.
	level thread dialog::remote( "kane_core_destabilized_q_0" ); 	
	
	self DisconnectPaths();	// Make AI move around you
}

//self = quadtank
function qt_trophy_system_destroy_watcher()
{
	self endon( "death" );
	self endon( "trophy_system_destroyed" );
	
	while ( true )
	{
		self waittill( "trophy_system_disabled" );
		level flag::set( "trophy_system_disabled" );
			
		self waittill( "trophy_system_enabled" );
		level flag::clear( "trophy_system_disabled" );
	}
}

function setup_quad_tank_battle_vo_arrays()
{
	//setup battle nags
	//TROPHY IS UP	 
	level.a_str_trophy_active = [];
	level.a_str_trophy_active[0] = "hend_we_can_t_hit_that_qu_0"; ////We can’t hit that Quad with its Defense System Active!
	level.a_str_trophy_active[1] = "hend_what_are_you_waiting_2"; ////What are you waiting for?? Take out that trophy system NOW!
	level.a_str_trophy_active[2] = "hend_trophy_system_s_mark_0"; ////Trophy System’s marked. Focus fire!
	level.a_str_trophy_active[3] = "hend_ain_t_gonna_do_damag_0"; ////Ain’t gonna do damage if its Trophy System’s active!	
	
	//TROPHY IS DOWN
	level.a_str_trophy_down = [];
	level.a_str_trophy_down[0] = "kane_trophy_system_offlin_0"; //Trophy System offline. Hit it with the RPG before it turns back on.
	level.a_str_trophy_down[1] = "hend_c_mon_hit_it_the_rp_0"; //C’mon! Hit it the RPG now!!
	level.a_str_trophy_down[2] = "hend_what_you_want_me_to_0"; //What? You want me to ask nicely? Hit it with the DAMN RPG!!
	level.a_str_trophy_down[3] = "kane_quad_defense_disable_0"; //Quad Defense Disabled. Hit it now!
	level.a_str_trophy_down[4] = "hend_only_a_few_more_shot_0"; //Only a few more shots, hit it with your RPG!!
	level.a_str_trophy_down[5] = "hend_hurry_up_use_your_r_0"; //Hurry up! Use your RPG!
	
 	//DIRECT HITS
	level.a_str_direct_hit = [];
	level.a_str_direct_hit[0] = "kane_clean_hit_0"; ////Clean hit!
	level.a_str_direct_hit[1] = "hend_good_shot_that_ba_0"; ////Good shot -- that bastard can’t take much more!
	level.a_str_direct_hit[2] = "kane_one_more_direct_hit_0"; ////One more direct hit should bring it down. Focus on its Trophy System.
	level.a_str_direct_hit[3] = "kane_direct_hit_few_more_0"; //Direct hit. Few more of those should bring her down...	
	
	//If player hits quad tank with bullets
//	level.a_str_bullet_vo = [];
//	level.a_str_bullet_vo[0] = "hend_we_re_shooting_blank_0"; ////We’re shooting blanks with that Defense System active!!
//	level.a_str_bullet_vo[1] = "kane_keep_hammering_its_t_0"; //Keep hammering its trophy system. Shouldn’t take much more.
//	level.a_str_bullet_vo[2] = "hend_hit_its_defensive_sy_0"; //Hit its defensive system! Almost there!!		
	
	//TROPHY IS DESTROYED
	level.a_str_trophy_destroyed = [];
	level.a_str_trophy_destroyed[0] = "kane_trophy_system_offlin_1"; //Trophy System offline.
	level.a_str_trophy_destroyed[1] = "hend_this_is_it_hit_it_w_0"; //This is it! Hit it with the RPG!!
	level.a_str_trophy_destroyed[2] = "hend_c_mon_shoot_that_f_0"; //C’mon!! Shoot THAT FUCKER!!	
}

//self = quad tank
function quadtank_fight_vo()
{
	/////////////////////////////////////////////////////////////////
	//
	//	TUTORIAL - QT is active and up, teach the player how to take it out
	//
	/////////////////////////////////////////////////////////////////	
	self endon( "trophy_system_disabled" ); 
	level endon( "quadtank_hijacked" );

//	Find cover!  Quad unit is active. Repeat: Quad unit is still active.
	level dialog::remote( "kane_find_cover_quad_un_0" );
	
//	That bastard should be scrap metal, how the hell’s it operational?!!
	level.ai_hendricks dialog::say( "hend_that_bastard_should_0" );
	
	//NEW
	//Quad Tanks have a Trophy System under their cores which makes them impenetrable to incoming threats. With enough weapon fire you can temporarily disable the system.
	level dialog::remote( "kane_quad_tanks_have_a_tr_0" );
	
	//Hit the quad’s Trophy System under the core to disable its defensives.
	level dialog::remote( "kane_hit_the_quad_s_troph_0" );	
	
	self thread trophy_is_active_vo_nag();
}

//self = quad tank
function trophy_is_active_vo_nag()
{
	level endon( "quadtank_hijacked" );	
	self endon( "death" );
	self endon( "trophy_system_destroyed" ); //kill this thread if the system is completely destroyed
	
	//level.a_str_trophy_active
	while ( true )
	{
		if ( level.a_str_trophy_active.size > 0 )
		{
			if ( !level flag::get( "trophy_system_disabled" ) )
			{
				//pull random line 
				str_vo_line = array::pop( level.a_str_trophy_active );
			
				//if it's a hendricks line, if not, it's kane from remote
				if ( StrStartsWith( str_vo_line, "hend" ) )
				{
					level.ai_hendricks dialog::say( str_vo_line );
				}
				else
				{
					level dialog::remote( str_vo_line );
				}
			}
		}
		
		wait( Randomintrange( 5, 8 ) );
	}	
}

function quadtank_death_handler()  //self = quadtank
{
	level flag::wait_till( "intro_quadtank_dead" );
	
	objectives::complete( "cp_level_sgen_destroy_tower" );
}

function quadtank_hijacked_death_handler()  //self = hijacked quadtank
{
	self waittill( "death" );
	
	level flag::set( "intro_quadtank_dead" );
}

//self = all vehicles
//check to see if this is the quad tank, otherwise return
function monitor_quadtank_health( obj, params )
{
	self endon( "death" );
	
	self waittill( "damage", damage, e_attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );
	
	//do nothing if ai is shooting the quad tank
	if ( IsAI( e_attacker ) )
	{
		/#
			iprintln( "AI ATTACKING" );
		#/
		
		return;	
	}	
	
	if ( self.targetname === "entrance_qtank_ai" && IsPlayer( e_attacker ) && weapon.name === "launcher_standard" )
	{
		/#
			iprintlnbold( "PLAYER SHOOTS AND SCORES" );
		#/
		
		//check to see if its the player attacking
		//do this by checking if attack is an ai, if it is, do nothing, if it isnt, its the player
		//check the weapon type - launcher_standard_cp, it gets passed as just launcher_standard
		//play direct hit lines
		//level.a_str_direct_hit
			
		if ( level.a_str_direct_hit.size > 0  )
		{
			if ( !level flag::get( "direct_hit_vo_playing" ) )
			{
				level flag::set( "direct_hit_vo_playing" );
	
				//pull random line 
				str_vo_line = array::pop( level.a_str_direct_hit );
			
				//if it's a hendricks line, if not, it's kane from remote
				if ( StrStartsWith( str_vo_line, "hend" ) )
				{
					level.ai_hendricks dialog::say( str_vo_line );
				}
				else
				{
					level dialog::remote( str_vo_line );
				}
				
				level flag::clear( "direct_hit_vo_playing" );
			}
		}
	}
}

//self = quadtank
function monitor_trophy_system_disabled()
{
	level endon( "quadtank_hijacked" );
	self endon( "death" );
		
	//play trophy down lines
	//level.a_str_trophy_down

	while ( true )
	{
		self waittill( "trophy_system_disabled" );
		
		if ( level.a_str_trophy_down.size > 0 )
		{
			if ( level flag::get( "trophy_system_disabled" ) )
			{
				//pull random line 
				str_vo_line = array::pop( level.a_str_trophy_down );
			
				//if it's a hendricks line, if not, it's kane from remote
				if ( StrStartsWith( str_vo_line, "hend" ) )
				{
					level.ai_hendricks dialog::say( str_vo_line );
				}
				else
				{
					level dialog::remote( str_vo_line );
				}
			}
		}
		
		wait( Randomintrange( 3, 5 ) );
	}

}

//self = quadtank
function monitor_trophy_system_destroyed()
{
	level endon( "quadtank_hijacked" );
	self endon( "death" );
	self waittill( "trophy_system_destroyed" );
	
	//play trophy destroyed lines here
	//level.a_str_trophy_destroyed
	
	while ( true )
	{
		if ( level.a_str_trophy_destroyed.size > 0 )
		{
			//pull random line 
			str_vo_line = array::pop( level.a_str_trophy_destroyed );
		
			//if it's a hendricks line, if not, it's kane from remote
			if ( StrStartsWith( str_vo_line, "hend" ) )
			{
				level.ai_hendricks dialog::say( str_vo_line );
			}
			else
			{
				level dialog::remote( str_vo_line );
			}			
		}
		
		wait( Randomintrange( 5, 8 ) );
	}	
}

function quadtank_movement_think()
{
	level endon( "quadtank_hijacked" );
	self endon( "death" );
		
	a_quadtank_positions = struct::get_array( "quadtank_positions", "script_noteworthy" );
	
	//his first position 
	s_next_pos = array::random( a_quadtank_positions );
	
	while ( true )
	{
		if ( s_next_pos == s_next_pos )
		{
			s_next_pos = array::random( a_quadtank_positions );
		}
		
		self SetGoal( s_next_pos.origin, true );	
		self util::waittill_either( "near_goal", "goal" );	
	
		if ( s_next_pos.script_string === "qt_pos_back" )
		{
			//move hendricks back when QT is further back
			if ( level.b_hendricks_right_path === true )
			{
				trigger::use( "trig_color_qt_right_fallback" );
			}
			else
			{
				trigger::use( "trig_color_qt_left_fallback" );
			}
		}
		
		if ( s_next_pos.script_string === "qt_pos_back" )
		{
			//move hendricks up when QT is further back
			if ( level.b_hendricks_right_path === true )
			{
				trigger::use( "trig_color_qt_right_push" );
			}
			else
			{
				trigger::use( "trig_color_qt_left_push" );
			}
		}

		wait RandomFloatRange( 6.0 , 9.0 );
	}
}

//	self is the quadtank
function qtank_fight_notetracks()
{
	level endon( "quadtank_hijacked" );
	
	self waittill( "fire" );	// QTank fires notetrack

	wait 0.2;	// Missile travel time
	
	level thread scene::play( "p7_fxanim_cp_sgen_truck_flip_crates_bundle" );
	
	// Safety measure to make sure things in the vicinity are killed
	s_qtank_impact = struct::get( "qtank_impact", "targetname" );
	RadiusDamage( s_qtank_impact.origin, 180, 500, 90, self );
	
	//disable nodes around truck thats no longer there
	a_nodes = GetNodeArray( "qt_truck_nodes", "script_noteworthy" );
	foreach( nd_node in a_nodes )
	{
		SetEnableNode( nd_node, false );
	}	
	
	//remove the carver clip
	a_pickup_carver = GetEntArray( "pickup_carver", "targetname" );
	foreach( e_ent in a_pickup_carver )
	{
		e_ent connectpaths();
		e_ent Delete();	
	}
}

//
//	Lobby Entrance doors don't open until the quad tank dies
function player_lobby_entrance()
{	
	level flag::wait_till( "hendricks_at_lobby_idle" );
	
	// EMF trigger
	t_door = GetEnt( "trig_lobby_entrance", "targetname" );
	t_door TriggerEnable( true );
	t_door SetHintString( "Press and Hold ^3[{+activate}]^7 to transmit unlock code" );
	t_door SetCursorHint( "HINT_NOICON");
	
	level thread sndPanelHack(t_door.origin);
	
	objectives::set( "cp_standard_breadcrumb", struct::get( "objective_enter_sgen" ) );

	t_door waittill( "trigger", e_player );
	
	level flag::set( "lobby_door_opening" );
	objectives::complete( "cp_standard_breadcrumb" );
	t_door Delete();
	
	e_player thread scene::play( "cin_sgen_03_03_undeadqt_1st_transmit_player", e_player  );
	
	e_player thread snd2Dhack();
	
	e_player cybercom::cyberCom_armPulse(1);

	//hacking hud progress bar - do not pass the player since he is in an animation already
	level thread hacking::hack( 3 );
	
	level waittill( "sgen_entry_door_open" ); //notify from the player animation
	
	a_m_doors = GetEntArray( "lobby_entrance_doors", "script_noteworthy" );
	foreach( m_door in a_m_doors )
	{
		bm_clip = GetEnt( m_door.target, "targetname" );
		bm_clip LinkTo( m_door );
	}	

	// Open sesame
	n_time = 1.0;
	n_accel = 0.25;
	n_decel = 0.25;
	
	//	at angles (0,0,0), forward vector will move the door closed.
	//	temp door is 60 units wide, so multiply vector by -60
	foreach( m_door in a_m_doors )
	{
		if ( m_door.targetname == "lobby_entrance_door_left" )
		{
			v_move = AnglesToForward( m_door.angles ) * -60;
			m_door MoveTo( m_door.origin + v_move, n_time, n_accel, n_decel );
			playsoundatposition( "evt_lobby_door_open", m_door.origin );
		}
		else
		{
			v_move = AnglesToForward( m_door.angles ) * 60;
			m_door MoveTo( m_door.origin + v_move, n_time, n_accel, n_decel );					
		}

	}
	
	wait( n_time );
	
	
	foreach( m_door in a_m_doors )
	{
		m_door ConnectPaths();
	}	
	
	level flag::set( "lobby_door_opened" );
}

function snd2Dhack()
{
	self waittill( "snd2dhack" );
	self playsoundtoplayer( "evt_plr_hack", self );
}
function sndPanelHack(sndOrigin)
{
	level waittill( "sndpanelhack" );
	playsoundatposition( "evt_lobby_door_panelhack", sndOrigin );
}

///////////////////////////////////////////////////////////////////
// Enter Lobby
///////////////////////////////////////////////////////////////////
function skipto_enter_lobby_init( str_objective, b_starting )
{
	if ( b_starting )
	{		
		//spawn and destroy a quad tank - TODO: this will need to probably change to a destroyed script model
		level.vh_qtank = spawner::simple_spawn_single( "entrance_qtank" );
		level.vh_qtank.ignoreme = true;
		level.vh_qtank.team = "team3";		// Super Soldier-controlled tank
		level.vh_qtank SetCanDamage( true );
		level.vh_qtank Kill();
			
		sgen::init_hendricks( str_objective );			
		
		objectives::set( "cp_level_sgen_enter_sgen" );
		objectives::complete( "cp_level_sgen_clear_entrance" );

		//turn off sgen entrance trig
		t_door = GetEnt( "trig_lobby_entrance", "targetname" );
		t_door TriggerEnable( false );
		
		level flag::set( "player_at_sgen_entrance" );
		level flag::set( "qtank_fight_completed" );
		
		sgen::wait_for_all_players_to_spawn();
		
		level thread player_lobby_entrance();
	}
	
	//init fxanim falling glass debris through silo interior
	scene::init( "p7_fxanim_cp_sgen_overhang_building_glass_bundle" );	
	
	level thread obj_lobby_entrance();
	level thread sndLobby();
	
	level.ai_hendricks thread enter_lobby_hendricks();

	//setup function here to highlight model when drone flies by it
	scene::add_scene_func( "p7_fxanim_cp_sgen_hendricks_railing_kick_bundle", &cp_mi_sing_sgen_enter_silo::drone_highlights_glass, "init" );
	
	// The blocker props for the follow the leader scene
	scene::init( "p7_fxanim_cp_sgen_hendricks_railing_kick_bundle" );

	level flag::wait_till( "lobby_door_opened" );
	
	objectives::complete( "cp_level_sgen_enter_sgen" );
	objectives::hide( "cp_level_sgen_clear_entrance" );
	objectives::set( "cp_level_sgen_investigate_sgen" );

	//turn off the trigger that	
	trig_post_discover_data = GetEnt( "trig_post_discover_data", "targetname" );
	trig_post_discover_data TriggerEnable( false );
	
	// End
	trigger::wait_till( "trig_discover_data" );
	
	open_silo_doors();

	skipto::objective_completed( str_objective );
}

function skipto_enter_lobby_done( str_objective, b_starting, b_direct, player )
{
}

function sndLobby()
{
	level flag::wait_till( "player_in_lobby" );
	
	level thread cp_mi_sing_sgen_sound::sndMusicSet( "sgen_enter" );
		
//	Welcome to Coalescence - The future of you.
//	(beat)
//	Please check in at Reception with your party--
	
	//C.Ayers: Adding a music call into this for coolness and whatnot
	sndEnt = spawn( "script_origin", (-6,-1301,250) );
	sndEnt playsound( "mus_coalescence_theme_lobby" );
	wait(6);
	sndEnt playsound( "mus_coalescence_theme_lobby_underscore" );
	sndEnt dialog::say( "rbot_welcome_to_coalescen_0" );
	
	wait(45);
	sndEnt delete();
}

function obj_lobby_entrance()
{
	//lobby door breadcrumb
	s_obj_sgen_entrance = struct::get( "obj_sgen_entrance", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_obj_sgen_entrance );	
	level flag::wait_till( "player_at_sgen_entrance" );
	objectives::complete( "cp_standard_breadcrumb", s_obj_sgen_entrance );	
	
	level waittill( "sgen_entry_door_open" ); //notify from the player animation
	
	//lobby interior breadcrumb
	s_obj_sgen_lobby = struct::get( "obj_sgen_lobby", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_obj_sgen_lobby );
	level flag::wait_till( "player_in_lobby" );
	objectives::complete( "cp_standard_breadcrumb", s_obj_sgen_lobby );	
	
	//discover data door breadcrumb
	s_obj_sgen_data_doors = struct::get( "obj_sgen_data_doors", "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_obj_sgen_data_doors );
	level flag::wait_till( "player_at_data_doors" ); //on trigger by doors
	objectives::complete( "cp_standard_breadcrumb", s_obj_sgen_data_doors );		
}

//	Hendricks' movement through enter lobby
//	self is Hendricks
function enter_lobby_hendricks()
{	
	level flag::wait_till( "qtank_fight_completed" );
	
	self ai::set_behavior_attribute( "cqb", true );
	self ai::set_behavior_attribute( "sprint", true );
	
	nd_pre_sgen_entrance = GetNode( "nd_pre_sgen_entrance", "targetname" );
	self thread ai::force_goal( nd_pre_sgen_entrance.origin, 32 );
	
	//wait for player to be in the vicinity of the entrance
	level flag::wait_till( "player_at_sgen_entrance" );
	
	level scene::play( "cin_sgen_03_03_undeadqt_vign_limitedpower_hendricks" );
	
	level flag::set( "hendricks_at_lobby_idle" );
	
	self thread lobby_door_hendricks_vo();
	
	level flag::wait_till( "lobby_door_opening" ); //wait until player opens the door
	
	level scene::play( "cin_sgen_03_03_undeadqt_vign_limitedpower_hendricks_moveintolobby" );	
	level scene::play( "cin_sgen_04_01_lobby_vign_react_hendricks" );

	self colors::set_force_color( "r" );		
	self colors::enable();	
	
	//color trig off of the playspace to send hendricks to the silo door cover	
	trigger::use( "trig_hendricks_lobby_color" );
	
	//wait until anim ends, then wait for the player to reach door area
	level flag::wait_till( "player_at_data_doors" ); //on trigger by doors
	
	level flag::set( "hendricks_at_silo_doors" );
}

//	self is Hendricks
function lobby_door_hendricks_vo()
{
	//wait 2, to ensure the lines before are played
	wait 2;
	
//	Interface with that panel. A quick hack should get you in.
	level dialog::remote( "kane_interface_with_that_2" );
	
	//increased wait to 8, to ensure the lines before are played
	wait 8;
	
	// Stop if they already got the door opened
	if ( !level flag::get( "lobby_door_opening" ) )
	{
		self dialog::say( "hend_what_you_waiting_fo_0" ); //What, you waiting for her to say please? Open the damn door.
	}
}


//	Open the doors leading to the silo
function open_silo_doors()
{
	level flag::wait_till( "hendricks_at_silo_doors" );
	
	//TODO: this VO may have to be on the player
//	Interfacing with the silo entrance, cover me.
	level.ai_hendricks thread dialog::say( "hend_interfacing_with_the_0" );
	
	foreach( player in level.players )
	{
		player clientfield::set_to_player( "sndSiloBG", 1 );
	}
	
	//TEMP 	Temp model doors are being used.  Once we get the real stuff, we should use collmaps (saves entities)
	a_m_doors = GetEntArray( "lobby_balcony_door", "targetname" );
	foreach( m_door in a_m_doors )
	{
		a_bm_clips = GetEntArray( m_door.target, "targetname" );
		// Attach clips
		foreach( bm_clip in a_bm_clips )
		{
			bm_clip LinkTo( m_door );
		}
	}
	
	// Open sesame
	n_time = 1.0;
	n_accel = 0.25;
	n_decel = 0.25;
	
	//	at angles (0,0,0), forward vector will move the door closed.
	//	temp door is 60 units wide, so multiply vector by -60
	foreach( m_door in a_m_doors )
	{
		v_move = AnglesToForward( m_door.angles ) * -60;
		m_door MoveTo( m_door.origin + v_move, n_time, n_accel, n_decel );
		playsoundatposition( "evt_silo_door_open", m_door.origin );
	}
	wait( n_time );
	
	foreach( m_door in a_m_doors )
	{
		m_door ConnectPaths();
	}
	
	level flag::set( "silo_door_opened" );
}

//////////////////////////////////////////////
//
// exterior stealth logic
//
//////////////////////////////////////////////////

//	Alert the area if you spot an enemy
// self is an enemy AI
function check_for_alert()
{
	self endon( "death" );
	self endon( "stealth_assist_alerted" );
	level endon( "exterior_gone_hot" );
	
	while ( true )
	{
		// Give heightened vision range to detect enemy
		if ( isdefined( self.enemy ) )
		{
			self.MaxSightDistSqrd = 2250000;	// 2250000 == 1500*1500
		}
		
		if ( ( isdefined( self.enemy) && self CanSee( self.enemy ) ) || self.should_stop_patrolling === true )
		{
			self thread ai_alert_attempt();

			wait 2.0;	// If alerted, give player a chance to kill you before alerting everyone

			if ( IsAlive( self ) )	// because "death" message takes time
			{
				level flag::set( "exterior_gone_hot" );
			}
			return;
		}

		wait 0.1;
	}
}


//	Attempt to make a radio alert
// self is the AI attempting to call the base to alert
function ai_alert_attempt()
{
	self endon( "death" );

	if ( level.is_ai_attempting_alert != true )
	{
		level.is_ai_attempting_alert = true;
		
		self thread end_alert_call_on_death();
		
		wait 0.5;
		
		if ( isAlive( self ) )
		{
			self scene::play( "cp_prologue_alerting_scene" , self );
		}
	}
}


function end_alert_call_on_death()
{
	level endon( "exterior_gone_hot" );
	
	self waittill( "death" );
	
	wait RandomFloatRange( 1.0 , 3.0 );
		
	level.is_ai_attempting_alert = false;
}

function truck_gunner_replace( n_gunners = 1, n_delay = 1, str_endon )  //self = truck
{
	self endon( "death" );
	
	if ( isdefined( str_endon ) )
	{
		level endon( str_endon );
	}
	
	level flag::wait_till( "exterior_gone_hot" );
	
	self turret::enable( 1, true );	
	
	n_guys = 0;
	
	while ( n_guys < n_gunners )
	{		
		ai_gunner = self vehicle::get_rider( "gunner1" );
		
		if ( IsAlive( ai_gunner ) )
		{
			ai_gunner waittill( "death" );
		}
		else
		{
			ai_gunner = get_truck_gunner( self );
			
			if ( IsAlive( ai_gunner ) )
			{
				ai_gunner vehicle::get_in( self, "gunner1", false );
				n_guys++;
			}
		}
		
		wait n_delay;
	}	
}

function get_truck_gunner( vh_truck )
{
	a_ai_enemies = GetAIArchetypeArray( "human" , "axis" );
	
	a_ai_gunners = ArraySortClosest( a_ai_enemies, vh_truck.origin );
	
	return a_ai_gunners[0];
}

// self = vehicle
function exterior_vehicle_damagefunc() 
{
	level endon( "qt_plaza_outro_igc_started" );
	
	while( 1 )
	{
		self waittill( "damage", n_damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );
		
		if( weapon == level.W_QUADTANK_PLAYER_WEAPON || weapon == level.W_QUADTANK_MLRS_WEAPON || weapon == level.W_QUADTANK_MLRS_WEAPON2 )
		{
			self DoDamage( self.health, self.origin );
			break;
		}
	}
	
	v_launch = (AnglesToForward( self.angles ) * -350) + (0, 0, 200);
	v_org = self.origin + AnglesToForward( self.angles )*10;
	self LaunchVehicle( v_launch, v_org, false );
	self thread monitor_vehicle_landing();
	
	a_ai_riders = self.riders;
	foreach( ai in a_ai_riders )
	{
		ai DoDamage( ai.health, ai.origin );
	}
}

// self = vehicle
function monitor_vehicle_landing() 
{
	self endon( "death" );
	if ( isdefined( 60 ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( 60, "timeout" );    };
	
	self waittill( "veh_landed" );	
	
	if ( isdefined( self ) )
	{
		self PlaySound ("evt_truck_impact");
	}
}

