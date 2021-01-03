//-----------------------------------------------------------------------------
// codescripts
// ----------------------------------------------------------------------------
#using scripts\codescripts\struct;

// ----------------------------------------------------------------------------
// shared
// ----------------------------------------------------------------------------
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                               	                                                          	              	                                                                                           

// ----------------------------------------------------------------------------
// systems
// ----------------------------------------------------------------------------
#using scripts\cp\_debug;
#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_spawn_manager;

// ----------------------------------------------------------------------------
// Infection
// ----------------------------------------------------------------------------
#using scripts\cp\cp_mi_cairo_infection_util;
#using scripts\cp\_siegebot_theia;

// ----------------------------------------------------------------------------
// #define
// ----------------------------------------------------------------------------





// ----------------------------------------------------------------------------
// #precache
// ----------------------------------------------------------------------------
#precache( "lui_menu", "VtolArrival" );
#precache( "lui_menu", "SarahDNI" );

#precache( "triggerstring", "CP_MI_CAIRO_INFECTION_T_DNI" );
#precache( "model", "c_hro_sarah_base_fb" );
#precache( "model", "veh_t7_mil_apc_dead" );
#precache( "model", "veh_t7_civ_truck_pickup_tech_egypt_dead" );
#precache( "fx", "explosions/fx_exp_quadtank_death_sm" );
#precache( "material", "mtl_veh_t7_mil_vtol_egypt_screenglow" );
#precache( "model", "c_civ_egypt_female_body3_1" );
#precache( "model", "c_civ_egypt_male_body4_2" );
#precache( "model", "c_civ_egypt_female_body2_1" );
#precache( "model", "c_civ_egypt_male_body1_3" );
#precache( "model", "c_civ_egypt_male_head1_1" );
#precache( "model", "c_civ_egypt_female_head1_1" );

#namespace sarah_battle;

// ----------------------------------------------------------------------------
// main
// ----------------------------------------------------------------------------
function main()
{
	setup_scenes();
	
	level flag::init( "vtol_intro_complete" );
	
	//crashed vtol
	level.wrecked_vtol = GetEntArray( "inf_wrecked_vtol", "targetname");
	level.sarah_bash2_clip = GetEnt( "sarah_bash2_clip", "targetname");
	
	if( isdefined( level.sarah_bash2_clip ) )
	{
		level.sarah_bash2_clip NotSolid();
		level.sarah_bash2_clip ConnectPaths();
	}		
	

	init_clientfields();
	
	level._effect[ "crashed_vtol_exp_fx" ] = "explosions/fx_exp_quadtank_death_sm";

}

function init_clientfields()
{
	//number of building pieces
	n_clientbits = GetMinBitCountForNum( 8 );
	
	clientfield::register( "world", "building_destruction_callback", 1, n_clientbits, "int" );
	clientfield::register( "world", "building_end_callback", 1, 1, "int" );
}
	
// ----------------------------------------------------------------------------
// setup_scenes
// ----------------------------------------------------------------------------
function setup_scenes()
{
	scene::add_scene_func("cin_inf_03_01_interface_1st_dni_02", &interface_1st_dni , "play" );
	scene::add_scene_func("cin_inf_01_01_vtolarrival_1st_encounter_v2", &vtol_arrival_callback , "play" );
	scene::add_scene_func("cin_inf_02_01_vign_interface_siegebot_bash_2", &sarah_truck_bash_2 , "play" );
	scene::add_scene_func("cin_inf_01_03_vtolarrival_1st_getup", &vtol_arrival_getup , "play" );
}

function vtol_model_init()
{
	vtol = GetEnt( "vtol_intro", "targetname" );
	vtol.targetname = "vtol"; //targetname used by intro IGC
	vtol thread vtol_intro_states();
	
	vtol_lights = GetEntArray( "light_vtol_flyin", "targetname" );
	foreach( light in vtol_lights )
	{
		light LinkTo( vtol );
		light thread vtol_light_cleanup();
	}
	
	vtol_spotlight = GetEnt( "light_vtol_flyin_spotlight", "targetname" );
	
	if( isdefined( vtol_spotlight ) )
	{	
		vtol_spotlight LinkTo( vtol, "tag_winch" );
		vtol_spotlight thread vtol_light_cleanup();
	}
	
	//vtol MoveTo( (-25883, 24857, -20197), 1);	//for deugging purposes only.
}

function vtol_light_cleanup()
{
	//delete lights when done
	level waittill( "vtol_crashed" );
	
	if( isdefined( self ) )
	{
		self Delete();
	}		
}	

function vtol_intro_states()
{
	//turn on console
	self ShowPart( "tag_console_center_screen_animate_d0" );
	self ShowPart( "tag_console_left_screen_animate_d0" );
	self ShowPart( "tag_console_right_screen_animate_d0" );

	//self = vtol
	//undamaged = tag_glass_animate, tag_glass1_animate, tag_glass2_animate, tag_glass3_animate...thru5
	//Damage state 1 = tag_glass_d1_animate
	//damage state 2 = tag_glass_d2_animate
	//damage state 3 = tag_glass4_d3_animate (single ?)

	num_parts = 5;

	//hide damage state 1
	self HidePart( "tag_glass_d1_animate" );
	for( i = 1; i <= num_parts; i++ )
	{
		self HidePart( "tag_glass" + i + "_d1_animate" );
	}
	//hide damage state 2
	self HidePart( "tag_glass_d2_animate" );
	for( i = 1; i <= num_parts; i++ )
	{
		self HidePart( "tag_glass" + i + "_d2_animate" );
	}
	//hide damage state 3
	self HidePart( "tag_glass4_d3_animate" );
	
	level waittill( "sarah_explode_building" );
	
	//hide undamaged
	self HidePart( "tag_glass_animate" );
	for( i = 1; i <= num_parts; i++ )
	{
		self HidePart( "tag_glass" + i + "_animate" );
	}
	//Show state 2
	self ShowPart( "tag_glass_d2_animate" );
	for( i = 1; i <= num_parts; i++ )
	{
		self ShowPart( "tag_glass" + i + "_d2_animate" );
	}
}	
// ----------------------------------------------------------------------------
// DIALOG: reinforcements_sent
// ----------------------------------------------------------------------------
function vo_reinforcements_sent()
{
	// if triggered before intial vo done wait till it is.
	while( !( isdefined( level.initial_vo_done ) && level.initial_vo_done ) )
	{
		wait 1;
	}	
	
	level.ai_khalil dialog::say( "khal_central_where_s_our_0", 1.0 );
	level dialog::remote( "ecmd_apc_s_have_just_reac_0", 0.0 );

	level waittill( "reinforcements_arrived" );
	level dialog::remote( "ecmd_lieutenant_egyptian_0", 1.0 );
}	

// ----------------------------------------------------------------------------
// DIALOG: javelin warning
// ----------------------------------------------------------------------------
function vo_javelin_warning()
{
	while( true )
	{
		level waittill( "theia_preparing_javelin_attack" );
		
		//20% chance won't play so not so repetitive
		if( RandomInt( 100 ) > 60 )
		{	
			level.ai_hendricks dialog::say( "hend_javelin_missiles_inc_0", 1.0 );//Javelin missiles incoming!!
		}
		else if( RandomInt( 100 ) < 40 )
		{	
			level.ai_hendricks dialog::say( "hend_javelin_s_inbound_0", 1.0 );//Javelin’s inbound!!
		}
	}		
}


// ----------------------------------------------------------------------------
// DIALOG: spike launcher warning
// ----------------------------------------------------------------------------
function vo_spike_launcher()
{
	level.ai_hendricks dialog::say( "hend_explosive_spikes_inc_0", 1.0 );//Explosive spikes incoming, look out!
}

// ----------------------------------------------------------------------------
// DIALOG: VO for sarah's states
// ----------------------------------------------------------------------------
function sarah_battle_state_init()
{
	level.ai_sarah endon( "death" );

	level waittill( "intial_battle_vo_done" );
	
	level.ai_sarah thread vo_sarah_movement_watcher();
	level.ai_sarah thread vo_sarah_health_watcher();
	level thread vo_javelin_warning();
}	

function vo_sarah_movement_watcher()
{
	self endon( "death" );

	while( true )
	{
		wait( RandomFloatRange( 5, 20 ) );
		//self waittill( "change_state" );

		while( ( isdefined( level.dialog_playing ) && level.dialog_playing ) )
		{
			wait 0.1;
		}	

		level.dialog_playing = true;

		state = vehicle_ai::get_current_state();
		if( state == "groundCombat" )
		{
			//groundcombat
			if( RandomInt( 100 ) > 50 )
			{	
				level.ai_hendricks dialog::say( "hend_she_s_in_the_plaza_0", 1.0 );//She’s in the plaza, evasive action!!
			}
			else
			{	
				level.ai_khalil dialog::say( "khal_siege_bot_approachin_0", 1.0 );//Siege Bot approaching the plaza, find cover!!
			}	
		}
		else if( state == "combat" )
		{
			//building perch
			if( RandomInt( 100 ) > 50 )
			{	
				level.ai_hendricks dialog::say( "hend_eyes_up_hall_s_take_0", 1.0 );//Eyes up, Hall’s taken higher ground!!
			}
			else
			{	
				level.ai_khalil dialog::say( "khal_the_enemy_siege_bot_0", 1.0 );//The enemy Siege Bot is taking refuge in that building -- FOCUS FIRE!!
			}				
		}
		else if( state == "jumpUp" || state == "jumpDown" )
		{
			//jumping
			level.ai_hendricks dialog::say( "hend_she_s_on_the_move_0", 1.0 );//She’s on the move!!
		}
		
		level.dialog_playing = false;
	}	
}

function vo_sarah_health_watcher()
{
	level endon( "Sarah_interface_init" );
	self endon( "death" );
	
	self thread sarah_death_failsafe();

	n_start_health = self.health;

	self thread wait_for_sarah_death();

	while( self.health > (n_start_health * 0.7) ) //70% health
	{
		wait 0.1;
	}

	while( ( isdefined( level.dialog_playing ) && level.dialog_playing ) )
	{
		wait 0.1;
	}	

	level.dialog_playing = true;


	level dialog::remote( "kane_siege_bot_operating_0", 1.0 ); //Siege Bot Operating at 70%.
	level.ai_hendricks dialog::say( "hend_we_gotta_get_through_0", 1.0 );//We gotta get through her to get Taylor, focus fire!!

	level.dialog_playing = false;


	while( self.health > (n_start_health * 0.4) ) //40% health
	{
		wait 0.1;
	}

	while( ( isdefined( level.dialog_playing ) && level.dialog_playing ) )
	{
		wait 0.1;
	}	

	level.dialog_playing = true;
	
	level dialog::remote( "kane_siege_bot_now_operat_0", 1.0 ); //Siege Bot now operating at 40%.
	level.ai_hendricks dialog::say( "hend_her_shields_won_t_ho_0", 1.0 );//Her shields won’t hold much longer, focus fire!!

	level.dialog_playing = false;

	while( self.health > (n_start_health * 0.1) ) //10% health
	{
		wait 0.1 ;
	}

	while( ( isdefined( level.dialog_playing ) && level.dialog_playing ) )
	{
		wait 0.1;
	}	

	level.dialog_playing = true;

	
	level dialog::remote( "kane_siege_bot_energy_dow_0", 1.0 ); //Siege Bot energy down to 10%!
	level dialog::remote( "kane_she_s_our_only_lead_0", 1.0 ); //She’s our only lead to Taylor, bring her down!!

	level.dialog_playing = false;

}

function sarah_death_failsafe()
{
	self waittill( "death" );
	
	wait 3; //time for any dialog to finish
	
	level.dialog_playing = false;
}	
	
function wait_for_sarah_death()
{		
	self waittill( "death" );

	while( ( isdefined( level.dialog_playing ) && level.dialog_playing ) )
	{
		wait 0.1;
	}	

	level.dialog_playing = true;

	level dialog::remote( "kane_she_s_down_she_s_do_0", 1.0 );//She’s down, she’s down!!
	//level.ai_khalil dialog::say( "khal_siege_bot_down_move_0", 1.0 );//Siege Bot down, move in, move in!!	
	
	level.dialog_playing = false;
}

// ----------------------------------------------------------------------------
// DIALOG: sarah_battle_vo
// ----------------------------------------------------------------------------
function vo_sarah_battle( a_ents )
{
	level.ai_khalil dialog::say( "khal_mech_suit_hostile_h_0", 1.5 );//Mech Suit! Hostile Heavy operating on manual with a human pilot! 
	level dialog::remote( "kane_looks_like_sarah_hal_0", 1.0 );//kane:	Looks like Sarah Hall in the cockpit.
	level dialog::player_say( "plyr_you_got_a_fix_on_tay_0", 1.0 );//player:	You got a fix on Taylor or Maretti? Where are they heading?
	level dialog::remote( "kane_negative_0", 1.0 );//kane:	Negative.
	level dialog::player_say( "plyr_then_the_only_way_to_0", 1.0 );//player:	Then the only way to Taylor is through Hall. We can’t afford to lose him again.

	level notify( "intial_battle_vo_done" );
	level.initial_vo_done = true;
}	

// ----------------------------------------------------------------------------
// DIALOG: vo_sarah_interface_init
// ----------------------------------------------------------------------------
function vo_sarah_interface_init()
{
	level endon( "sarah_battle_end" );
	level endon( "Sarah_interface_init" );

	while( ( isdefined( level.dialog_playing ) && level.dialog_playing ) )
	{
		wait 0.1;
	}	

	level dialog::remote( "kane_no_sign_of_taylor_an_0", 1.0 );//We've lost Taylor and Maretti. You need to interface with Hall.
		
	level notify( "inteface_trig_init" );
	level thread dialog::remote( "kane_i_know_this_isn_t_ea_0", 0.0 );//I know this isn't easy, but the only way to find Taylor is by interfacing with Hall.
	
	//if not threaded image never goes away, adding wait here instead.
	wait 4;
	
	level thread dialog::remote( "kane_her_systems_are_fail_0", 0.0 );//Her systems are failing. If you don't interface not only do we lose her -- we lose Taylor.
}

// ----------------------------------------------------------------------------
// interface_1st_dni
// ----------------------------------------------------------------------------
function interface_1st_dni( a_ents )
{
	level notify( "Sarah_interface_init" );
	
	level.players[0] waittill( "start_interface" ); //sent from notetrack

	//# IPrintLnBold( "start sarah interface fx" ); #/
	level thread infection_util::movie_transition( "cp_ramses1_fs_connectioninterrupted" );
	
}

// ----------------------------------------------------------------------------
// close_cacwaitmenu
// ----------------------------------------------------------------------------
function close_cacwaitmenu()
{
	wait 1;  //wait until IGC has started playing before closing menu
	
	if ( level.players.size > 1 )
	{
		foreach( player in level.players )
		{
			if ( isdefined( player.wait_menu ) )
			{
				player CloseLUIMenu( player.wait_menu );
			}	
		}
	}
}

// ----------------------------------------------------------------------------
// vtol_arrival_init
// ----------------------------------------------------------------------------
function vtol_arrival_init( str_objective, b_starting )
{
	/# IPrintLnBold( "vtol_arrival_init" ); #/
	objectives::set( "cp_level_infection_find_dr" );	

	// Force streamer to load VTOL Arrival.
	if( b_starting )
	{
		skipto::set_level_start_flag( "start_level" );
		util::set_streamer_hint( 1 );
		level util::set_lighting_state( 0 );

		level vtol_model_init();
	}

	//hide wrecked vtol
	foreach( e_piece in level.wrecked_vtol )
	{
		e_piece Hide();
	}

	// Spawn Hendricks
	level.ai_hendricks = util::get_hero( "hendricks" );		
		
	level flag::wait_till( "all_players_spawned" );

	level thread util::screen_fade_in( 0.5, "black" );

	// Spawn sarah
	spawn_sarah_boss();
	level thread building_destruction_init();

	// Spawn Egyptian army
	level thread friendly_ai_controller();

	level flag::set( "start_level" );
	level scene::play( "cin_inf_01_01_vtolarrival_1st_encounter_v2" );	

	objectives::complete( "cp_level_infection_find_dr" );

	//clear streamer hint after scene done
	util::clear_streamer_hint();
	
	// Warp players to starting location for sarah battle
	skipto::objective_completed( "vtol_arrival" );
}


// ----------------------------------------------------------------------------
// VTOL INTRO vehicles and background ai (for intro only)
// ----------------------------------------------------------------------------
function vtol_arrival_callback( a_ents )
{
	level thread move_ai_intro();
	level thread balcony_civilians();

	//vtol_intro_veh1 - 3
	n_vehicle_convoy = 3;
	
	for( i = 1; i <= n_vehicle_convoy; i++ )
	{
		vh_intro = spawner::simple_spawn_single( "vtol_intro_veh" + i );
		vh_intro.animname = "vtol_intro_veh" + i;

		vehicle_start = GetVehicleNode( "vtol_intro_veh" + i + "_start", "targetname" );	
		vh_intro thread vehicle::get_on_and_go_path( vehicle_start );
		vh_intro thread intro_delete_at_end();
	}
	
	level waittill( "vtol_fade_out" );
	
	level thread util::screen_fade_out( 2, "black" );
}	

function balcony_civilians()
{
	s_civs = struct::get_array( "balcony_civs", "targetname" );
	for( i=0; i < s_civs.size; i++ )
	{
		if(isdefined(s_civs[i].model))
		{	
			e_civ = util::spawn_model( s_civs[i].model, s_civs[i].origin, s_civs[i].angles );
			e_civ.targetname = s_civs[i].targetname;
		}
	}
	
	level waittill( "vtol_fade_out" );

	e_civs = GetEntArray( "balcony_civs", "targetname" );
	for( i=0; i < e_civs.size; i++ )
	{
		e_civs[i] Delete();
	}
}

function move_ai_intro()
{
	//wait 17; //TODO: wait till looking in plaza. eventually from note.
	level waittill( "start_plaza_ai" );
	
	
	//find furthest hero cover from khalils current position
	pos = find_good_coverpos( level.ai_khalil.origin );

	a_allies = GetEntArray( "team_khalil", "script_noteworthy" );
	foreach( ai in a_allies )
	{
		ai.old_radius = ai.goalradius;
		ai.goalradius = 512;
	}	

	//send hero, along with following ai, to position away.
	level.ai_khalil ai::set_ignoreall( true );
	level.ai_khalil ai::force_goal(pos.origin, 32 );
			
	level.ai_khalil waittill( "goal" );
	level.ai_khalil ClearForcedGoal();
	level.ai_khalil ai::set_ignoreall( false );	

	//return ai followers to old goal radius, if was defined
	a_allies = GetEntArray( "team_khalil", "script_noteworthy" );
	foreach( ai in a_allies )
	{
		if( isdefined( ai.old_radius ) )
		{	
			ai.goalradius = ai.old_radius;
			ai.old_radius = undefined;
		}
	}	
}

function intro_delete_at_end()
{
	level waittill( "vtol_fade_out" );
	
	self Delete();
}	

// ----------------------------------------------------------------------------
// sarah_battle
// ----------------------------------------------------------------------------
function sarah_battle_init( str_objective, b_starting )
{
	/# IPrintLnBold( "sarah_battle_init" ); #/

	level util::set_lighting_state( 1 );

	util::screen_fade_out( 0, "black" );

	// Spawn Hendricks
	level.ai_hendricks = util::get_hero( "hendricks" );
	hendricks_start_pos = struct::get( "hendricks_start_pos_sarah_battle_start", "targetname" );
	level.ai_hendricks ForceTeleport( hendricks_start_pos.origin, hendricks_start_pos.angles );

	// make sure player doesn't take too much damage from spike
	level.overridePlayerDamage = &player_callback_damage;

	if ( b_starting )
	{
		// Spawn sarah
		spawn_sarah_boss();

		// Spawn Egyptian army
		level thread friendly_ai_controller();

		level flag::set( "vtol_intro_complete" );
		level thread building_destruction_init();
	}

	//fire fx after crash
	exploder::exploder( "sarah_battle_vtol_crash_fire" );
	e_vtol_apc = GetEnt( "vtol_crash_apc", "targetname" );	
	if(isdefined( e_vtol_apc ) )
	{
		e_vtol_apc SetModel( "veh_t7_mil_apc_dead" );
	}		
	
	level notify( "vtol_crashed" );
		
	level thread scene::init( "cin_inf_02_01_vign_interface_siegebot_bash");

	//ai may target sarah, she wont target till after scene
	level.ai_sarah ai::set_ignoreme( false );
		
	//show wrecked vtol
	foreach( e_piece in level.wrecked_vtol )
	{
		e_piece Show();
	}	
	
	level flag::wait_till( "all_players_spawned" );

	level thread rocket_launcher_init();

	level thread util::screen_fade_in( 2, "black" );

	skipto::teleport_players( "sarah_battle", false );

	// hack: forcing a wait to fix issue of next scene not playing properly
	wait 0.1;
	
	// Make all players play the get up anim.
	foreach ( player in level.players )
	{
		player EnableInvulnerability();
		
		if( (player scene::is_playing()) )
		{
			player scene::stop();
		}
		
		player thread scene::play( "cin_inf_01_03_vtolarrival_1st_getup", player );
	}
	
	//necessary to fix notify coming from vtol crashing scene instead of getting up.
	array::wait_till( level.players, "getup_done" );
	
	level thread vo_sarah_battle();
	level thread sarah_battle_state_init();
	level thread crashed_vtol_explosion();

	close_lui_menu();
	
	objectives::set( "cp_level_infection_defeat_sarah", level.ai_sarah );
	
	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i] DisableInvulnerability();
	}		

	level thread monitor_sarah_battle();
	
	level.ai_hendricks thread hero_check_distance();
	level.ai_khalil thread hero_check_distance();	
}

function vtol_arrival_getup( a_ents )
{
	level waittill( "deletevtol" );
	a_ents[ "vtol_getup" ] Delete();
}	

// ----------------------------------------------------------------------------
// Spawn Sarah Seigebot and set her damage override so friendlies can't kill her
function spawn_sarah_boss()
{
	// Spawn sarah
	level.ai_sarah = spawner::simple_spawn_single( "sarah_boss" );
	level.ai_sarah ai::set_ignoreall( true );
	level.ai_sarah ai::set_ignoreme( true );
	level.ai_sarah.targetname = "sarah_siegebot";
	level.ai_sarah vehicle_ai::start_scripted();
		
	//Spawn Theia model inside siegebot
	driver_pos = level.ai_sarah GetTagOrigin( "tag_driver" );
	driver_angles = level.ai_sarah GetTagAngles( "tag_driver" );
	level.sarah_driver = util::spawn_model( "c_hro_sarah_base_fb", driver_pos, driver_angles );
	level.sarah_driver LinkTo(level.ai_sarah, "tag_driver", (0, 0, -32));
	level.sarah_driver.targetname = "sarah_driver";

	CreateThreatBiasGroup( "sarah_battle_seigebot" );
	CreateThreatBiasGroup( "players" );
	SetThreatBias( "players", "sarah_battle_seigebot", 1000 );	

	level thread player_hijack_monitor();

	callback::on_spawned( &on_player_spawn );

	level.ai_sarah SetThreatBiasGroup( "sarah_battle_seigebot" );
	foreach( player in level.players )
	{
		player SetThreatBiasGroup( "players" );
		player._spawn_time = GetTime();
	}
	update_player_threat_bias();
}

function update_player_threat_bias()
{
	if ( level.players.size <= 1 )
	{
		threatBias = 900;
	}
	else
	{
		threatBias = 1000 + 300 * level.players.size - 1;
	}
	SetThreatBias( "players", "sarah_battle_seigebot", threatBias );	
}

function on_player_spawn()
{
	self SetThreatBiasGroup( "players" );
	self._spawn_time = GetTime();
	update_player_threat_bias();
}

function player_hijack_monitor()
{
	level.ai_sarah endon( "death" );

	level waittill("ClonedEntity", clone);

	clone SetThreatBiasGroup( "players" );
}

// ----------------------------------------------------------------------------
// Spike launcher watcher
// ----------------------------------------------------------------------------
function sarah_spike_launcher_watcher()
{
	level.ai_sarah endon( "death" );
	
	hero_array = [];
	array::add(hero_array, level.ai_hendricks, false);
	array::add(hero_array, level.ai_khalil, false);
	
	while( true )
	{
		//wait for sarah to perform a spike launcher attack and get closet hero leader to attack position
		level waittill("theia_preparing_spike_attack", target_origin );
		closest_hero = array::get_closest( target_origin, hero_array );

		level thread vo_spike_launcher();

		//find furthest hero cover from attack position
		pos = find_good_coverpos( target_origin );

		//find ai followers and reduce goalradius temporarily.
		if( closest_hero == level.ai_hendricks )
		{
			team = "team_hendricks";
		}
		else
		{
			team = "team_khalil";
		}				

		a_allies = GetEntArray( team, "script_noteworthy" );
		foreach( ai in a_allies )
		{
			ai.old_radius = ai.goalradius;
			ai.goalradius = 512;
		}	

		//send hero, along with following ai, to position away from attack.
		closest_hero ai::set_ignoreall( true );
		closest_hero ai::force_goal(pos.origin, 32 );
			
		closest_hero waittill( "goal" );
		closest_hero ClearForcedGoal();
		closest_hero ai::set_ignoreall( false );
		
		//return ai followers to old goal radius, if was defined
		a_allies = GetEntArray( team, "script_noteworthy" );
		foreach( ai in a_allies )
		{
			if( isdefined( ai.old_radius ) )
			{	
				ai.goalradius = ai.old_radius;
				ai.old_radius = undefined;
			}
		}				
	}	
}
// ----------------------------------------------------------------------------
// Building Destruction
// ----------------------------------------------------------------------------
function building_destruction_init()
{
	a_building_dest_trigs = GetEntArray( "building_trigs","targetname" );
	a_building_dest_trigs array::thread_all(	a_building_dest_trigs, &building_destruction_watcher );
		
	//initial building blowing out
	if(	level.current_skipto == "vtol_arrival")
	{
		level thread vtol_arrival_building();
	}				
}	

function building_destruction_watcher()
{
	//p7_fxanim_cp_infection_sarah_building_0 (num) _bundle (example: "p7_fxanim_cp_infection_sarah_building_01_bundle")
	//building_a = 1 (first destruction), 2 (second destruction)
	//building_b = 3, 4 
	//building_c = 5, 6 
	//building_d = 7, 8 

	self.n_destroyed = 0;
	self.scene_num = 1;
	
	if( isdefined( self.script_int ) )
	{	
		self.scene_num = self.script_int;
	}
	
	level.ai_sarah endon( "death" );

	//from skipto sarah battle end, remove largest piece of each building
	if(	level.current_skipto == "sarah_battle_end")
	{
		level clientfield::set( "building_end_callback", 1 );

		return;
	}	

	level flag::wait_till( "vtol_intro_complete" );
	
	while( true )
	{
		self waittill( "trigger", who );
		if( who == level.ai_sarah )
		{
			//sarah bashes through building for second special scene
			if( ( self.script_noteworthy === "building_b" ) && self.n_destroyed == 0 ) 
			{	
				level notify( "sarah_building_b_init" );
				level.ai_sarah.dontchangestate = true;
			}
				
			level clientfield::set( "building_destruction_callback", self.scene_num );
				
			self.n_destroyed++;
			self.scene_num++;
			
			//last piece destroyed
			if( self.n_destroyed == 2 )
			{
				return;
			}	
			
			while(who IsTouching(self))
			{
				wait 0.1;
			}			
		}
		wait 0.1;
	}
}	

function vtol_arrival_building()
{
	t_sarah_building = GetEnt( "building_a", "script_noteworthy" );
	t_sarah_building.n_destroyed = 0;
	t_sarah_building.scene_num = 1;
	
	level waittill( "sarah_explode_building" );
	
	level clientfield::set( "building_destruction_callback", t_sarah_building.scene_num );

	t_sarah_building.n_destroyed++;
	t_sarah_building.scene_num++;

	level waittill( "sarah_bash_end" );
	level flag::set( "vtol_intro_complete" );
		
}

// ----------------------------------------------------------------------------
// Rocket Launcher Control
// ----------------------------------------------------------------------------
// controls number of available rocket launchers for pick up minimum 3 max 8.
function rocket_launcher_init()
{
	launchers = GetEntArray("sarah_battle_launcher", "targetname");
	
	//remove extra placed rocket launchers, 8 were placed.
	for(i = 0; i < launchers.size; i++)
	{
		if(isdefined(launchers[i].script_int) && (launchers[i].script_int > level.players.size))
		{	
			launchers[i] delete();
		}	
	}	
}	

// ----------------------------------------------------------------------------
// Fake Rocket Fire
// ----------------------------------------------------------------------------
function magic_bullet_rpg()
{
	level.ai_sarah endon( "death" );

	a_s_start_points = struct::get_array( "sarah_battle_magic_rpg", "targetname" );
	weapon = GetWeapon( "launcher_standard" );
	
	while( true )
	{
		s_start_point = array::random( a_s_start_points );
			
		//have the magic rpg fire target all around Sarah.	
		v_target = 	level.ai_sarah.origin;
		v_end_point = ( v_target[0] + RandomFloatRange(-32, 32), v_target[1] + RandomFloatRange(-32, 32), v_target[2] + RandomFloatRange(-32, 32));
			
		MagicBullet( weapon, s_start_point.origin, v_end_point );
			
		wait( RandomFloatRange( 0.25, 4.0 ) );
	}
}

// ----------------------------------------------------------------------------
// Crashed Vtol Explosion
// ----------------------------------------------------------------------------
function crashed_vtol_explosion()
{
	s_exposion_pos = struct::get( "crashed_vtol_explosion", "targetname" );
		
	if(!isdefined( s_exposion_pos ) )
	{
		return;	
	}
			
	forward = AnglesToForward(s_exposion_pos.angles);	

	//select a random player that must be looking for the explosion to go off.
	player = array::random( level.players );
	
	while( true )
	{
		if( player infection_util::IsLookingAtStruct( s_exposion_pos ) )
		{	
			PlayFx( level._effect[ "crashed_vtol_exp_fx" ], s_exposion_pos.origin, forward );
			return;
		}
		wait 0.1;
		
		//did player drop out, pick another
		if( !isdefined( player ) )
		{
			player = array::random( level.players );
		}		
	}	
}
	
// ----------------------------------------------------------------------------
// Friendly AI control
// ----------------------------------------------------------------------------
function friendly_ai_controller()
{
	level.ai_sarah endon( "death" );

 //Spawn Khalil
 	level.ai_khalil = util::get_hero( "khalil" );
	khalil_start_pos = struct::get( "khalil_start_pos_sarah_battle_end", "targetname" );
	level.ai_khalil ForceTeleport( khalil_start_pos.origin, khalil_start_pos.angles );

	level thread active_friendly_count_watcher();
	
	friendly_spawners = GetEntArray( "sarah_battle_friendly_spawners", "script_noteworthy" ); 
	array::thread_all(friendly_spawners, &spawner::add_spawn_function, &friendly_ai_spawn_function);

	//array to control all groups
	level.friendly_spawn_groups = array( "blue", "red", "yellow", "green", "purple", "orange"); 

	//spawn initial friendlies
	spawner::simple_spawn( "sp_ally_egypt_army" );

	//spawn a single rocket wasp (intro)
	ai_rocket_wasp_ally = spawner::simple_spawn_single( "rocket_wasp_ally" );
	level thread spawn_special_ally_init( ai_rocket_wasp_ally ); //rocket wasps and AMWS

	//track initial friendlies
	egypt_ai = GetEntArray( "sp_ally_egypt_army_ai", "targetname" );
	foreach(ai in egypt_ai)
	{
		ai SetGoal( level.ai_khalil, false, 1024 );
		ai.script_noteworthy = "team_khalil";
	}	

	//special technical truck introduction (sarah bash 2)
	level thread technical_vehicle_init();

	while( egypt_ai.size > 8 )
	{
		egypt_ai = GetEntArray( "sp_ally_egypt_army_ai", "targetname" );
		wait 1;
	}	

	previous_group = undefined;

	level thread vo_reinforcements_sent();

	//randomize the friendly spawngroups when to arrive.
	level.friendly_spawn_groups = array::randomize( level.friendly_spawn_groups );
	for( i=0; i < level.friendly_spawn_groups.size; i++ )
	{
		level thread reinforcements_init( level.friendly_spawn_groups[i] );
	
		//now waiting a period of time for reinforcements to arrive instead of waiting for previous to arrive.
		wait 10;
		
		previous_group = level.friendly_spawn_groups[i];
	}
	
	//when all reinforcements have initialized
	level thread reinforcements_randomize( previous_group );	
}

function spawn_special_ally_init( ai_bot )
{
	level.ai_sarah endon( "death" );
	
	sp_amws_ally = GetEnt( "amws_ally", "targetname" );
	sp_amws_ally spawner::add_spawn_function( &specialty_ally_spawn_function );

	sp_rocket_wasp_ally = GetEnt( "rocket_wasp_ally", "targetname" );
	sp_rocket_wasp_ally spawner::add_spawn_function( &specialty_ally_spawn_function );
	
	//wait for initial bot to die.	
	ai_bot waittill( "death" );

	ai_bots = [];
	num_amws = 2;
	ai_bot_spawner = undefined;
	
	while( true )
	{
		if( ai_bots.size == 0 )
		{
			chance = RandomInt( 100 );
			
			if( chance > 50 )
			{	
				ai_bot_spawner = "rocket_wasp_ally";
				ai = spawner::simple_spawn( ai_bot_spawner ); //only one flyer, too difficult to kill.
			}
			else
			{
				ai_bot_spawner = "amws_ally";
				for( i = 1; i <= num_amws; i++ )
				{
					ai = spawner::simple_spawn( ai_bot_spawner );
					wait 1.5; //wait 1 1/2 seconds for first to move out.
				}
			}
		}
		
		wait 1;	
		
		ai_bots = GetEntArray( ai_bot_spawner + "_ai", "targetname" );
		
		//remove corpses from ai_bots array
		for( i= 0; i < ai_bots.size; i++ ) 
		{
			if( !IsAlive( ai_bots[i] ) )
			{
				ai_bots[i].targetname = "ai_bot_corpse";
				ArrayRemoveValue( ai_bots, ai_bots[i] ); 
			}		
		}	
	}
}	

function specialty_ally_spawn_function()
{
	self SetTeam( "allies" );
	
	//bots were hitting sarah too often.
	self.accuracy = 0.2;
}	

function active_friendly_count_watcher()
{
	level.ai_sarah endon( "death" );
	
	start_health = level.ai_sarah.health;
	
	//3 are Sarah and the heroes at start of battle
	spawn_manager::set_global_active_count( 23 );
		
	while( level.ai_sarah.health > (start_health * 0.4) )
	{
		wait 0.5;
	}	
	
	// reduce to 1/2 allowed active friedlies when sarah 40% original health
	spawn_manager::set_global_active_count( int(23 * 0.5) );
	
	while( level.ai_sarah.health > (start_health * 0.25) )
	{
		wait 0.5;
	}	
	
	// reduce to 4 friendlies allowed active, plus 2 heroes, plus sarah 
	spawn_manager::set_global_active_count( 7 );
}	

function reinforcements_randomize( final_group )
{
	level.ai_sarah endon( "death" );

	//waits for last reinforcement group to arrive.
	level waittill( "reinforcements_arrived_" + final_group );

	while( true )
	{
		//randomize the friendly spawngroups when to arrive.
		level.friendly_spawn_groups = array::randomize( level.friendly_spawn_groups );
		n_spawners = 0;	
		for( i=0; i < level.friendly_spawn_groups.size; i++ )
		{
			if( n_spawners >= 4 )
			{
				continue;
			}		
			spawn_manager::enable( "sarah_battle_manager_" + level.friendly_spawn_groups[i] );
			n_spawners++;
		}
		
		//wait time till randomize again
		waittime = RandomFloatRange( 15, 45 );
		wait waittime;
	}
}


//dont let Sarah to get to close to heroes.
function hero_check_distance()
{
	self endon( "death" );
	level.ai_sarah endon( "death" );

	
	while( true )
	{
		if( distance(self.origin, level.ai_sarah.origin) < 256 )
		{
			self ai::set_ignoreall( true );

			pos = find_good_coverpos( level.ai_sarah.origin );
			
			self ai::force_goal(pos.origin, 32 );
			
			self waittill( "goal" );
			self ClearForcedGoal();
			self ai::set_ignoreall( false );

		}		
		wait 1;
	}
}	

function find_good_coverpos( pos )
{
	hero_cover = GetNodeArray( "hero_cover", "targetname" );

	cover_pos = hero_cover[0];
	dist = 0;
	
	for(i = 0; i < hero_cover.size; i++)
	{
		cover_dist = distance(pos, hero_cover[i].origin);
		if( cover_dist > dist )
		{
			cover_pos = hero_cover[i];
			dist = cover_dist;
		}		
	}	
	return cover_pos;
}	

// ----------------------------------------------------------------------------
// vehicles for reinforcements
// ----------------------------------------------------------------------------
function reinforcements_init( spawn_group )
{
	vehicle = spawner::simple_spawn_single( "vehicle_spawn_" + spawn_group );
	vehicle.animname = "vehicle_spawn_" + spawn_group;
	
	vehicle_start = GetVehicleNode( "vehicle_spawn_" + spawn_group + "_start", "targetname" );	
	vehicle thread vehicle::get_on_and_go_path( vehicle_start );
	
	//start spawning ai once reach end node
	vehicle waittill( "reached_end_node" );
	spawn_manager::enable( "sarah_battle_manager_" + spawn_group );
	level notify( "reinforcements_arrived_" + spawn_group );
	level notify( "reinforcements_arrived" );
	
	//after spawned wait 3 seconds and disable.
	wait 3;
	
	spawn_manager::disable( "sarah_battle_manager_" + spawn_group );
}	

function technical_vehicle_init()
{
	level.ai_sarah endon( "death" );
	
	level waittill( "sarah_building_b_init" );
	level thread technical_vehicle_spawn( "veh_spawn_technical_1", true ); //TODO: will be in a bash scene once available
	
	//wait for intial ai to dwindle to 4
	ai_initial = GetEntArray( "sp_ally_egypt_army_ai", "targetname" );
	while( ai_initial.size > 4 )
	{
		wait 1;
		ai_initial = GetEntArray( "sp_ally_egypt_army_ai", "targetname" );
	}	

	level thread technical_vehicle_spawn( "veh_spawn_technical_2" );
}

function technical_vehicle_spawn( tech_veh_name, b_scene = false )
{	
	if(!isdefined( tech_veh_name ) )
	{
		return;
	}		
	
	e_spawner = GetEnt( tech_veh_name, "targetname" );
	vh_techical = spawner::simple_spawn_single( e_spawner );
	//telport riders into technical	
	if( !isdefined( vh_techical ) )
	{
		return;
	}			
	
	ai_driver = spawner::simple_spawn_single( "technical_driver" );
	ai_driver thread vehicle::get_in( vh_techical, "driver", true );

	ai_gunner = spawner::simple_spawn_single( "technical_gunner" );
	ai_gunner thread vehicle::get_in( vh_techical, "gunner1", true );

	vehicle_start = GetVehicleNode( tech_veh_name + "_start", "targetname" );	
	vh_techical thread vehicle::get_on_and_go_path( vehicle_start );
	vh_techical util::magic_bullet_shield();

	vh_techical waittill( "reached_end_node" );
	
	if( ( isdefined( b_scene ) && b_scene ) )
	{
		vh_techical.driver = ai_driver;
		vh_techical.gunner = ai_gunner;

		level.ai_sarah thread sarah_bash_technical( vh_techical );
		return; 
	}

	vh_techical util::stop_magic_bullet_shield();
			
	ai_driver thread vehicle::get_out();
	ai_gunner thread vehicle::get_out();
}	

// ----------------------------------------------------------------------------
function sarah_bash_technical( vehicle )
{
	//vehicle.targetname = "truck_bash";
	vehicle.gunner.targetname = "truck_gunner";

	level util::waittill_either( "theia_finished_platform_attack", "theia_preparing_javelin_attack" );

	vehicle Delete(); //Delete truck otherwise it goes weird in physics after scene
	vehicle.driver Delete();
	
	self scene::play( "cin_inf_02_01_vign_interface_siegebot_bash_2", self );
	
	self vehicle_ai::set_state( "groundCombat" );
	self.dontchangestate = false;
	
	if( isdefined( level.sarah_bash2_clip ) )
	{
		level.sarah_bash2_clip Solid();
		level.sarah_bash2_clip DisconnectPaths();
	}			
}

function sarah_truck_bash_2( a_ents )
{
	a_ents[ "sarah_siegebot" ] waittill( "truck_crash" );

	a_ents[ "truck_bash" ] SetModel( "veh_t7_civ_truck_pickup_tech_egypt_dead" );
}	
	
// ----------------------------------------------------------------------------

function friendly_ai_spawn_function()
{
	self endon( "death" );
	
	self.overrideActorDamage = &friendly_callback_damage;
	self.accuracy = 0.2;
	
	self ai::set_ignoreme( true );
	
	//set goal volumes to keep the teams in their specific zones
	if(isdefined(self.script_string))
	{			
		e_goal_volume = GetEnt("goal_volume_" + self.script_string, "targetname");
	}
	
	if(!isdefined( e_goal_volume ))
	{	
		e_goal_volume = GetEnt("goal_volume_red", "targetname");
	}
	assert(isdefined(e_goal_volume), "No goal volume found");
	
	self SetGoalVolume(e_goal_volume);
	
	//sarah should ignore ai running into the battle arena.
	while(!self IsTouching( e_goal_volume ))
	{
		wait 0.1;
	}	
	self ai::set_ignoreme( false );
	self thread friendly_leader_init();

}

//all friendly ai will try to stay near Khalil or Hendricks, less than 1024 and they just bunch up around Khalil
function friendly_leader_init()
{
	if(!isdefined( level.ai_khalil) || !isdefined( level.ai_hendricks ))
	{
		return;
	}

	if( RandomInt( 100 ) > 50) //50%
	{
		self	SetGoal( level.ai_khalil, false, 1024 );
		self.script_noteworthy = "team_khalil";
	}	
	else
	{	
		self	SetGoal( level.ai_hendricks, false, 1024 );
		self.script_noteworthy = "team_hendricks";
	}
}

function friendly_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	// Don't allow players to kill friendlies
	if( isdefined(eAttacker) && IsPlayer(eAttacker) )
	{
		iDamage = 0;
	}
	
	if ( weapon == GetWeapon( "spike_charge_siegebot_theia" ) )
	{
		iDamage *= 100;
	}

	return iDamage;
}			

function player_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{
	// don't let player take multiple spike damages in short period
	minSpikeDamageInterval = 3; // in seconds
	if ( weapon == GetWeapon( "spike_charge_siegebot_theia" ) )
	{
		if ( isdefined( self._last_spike_damage_time ) && self._last_spike_damage_time + minSpikeDamageInterval * 1000 > GetTime() )
		{
			return 0;
		}
		else
		{
			self._last_spike_damage_time = GetTime();
		}
	}

	return iDamage;
}
// ----------------------------------------------------------------------------
// sarah_battle_end_init
// ----------------------------------------------------------------------------
function sarah_battle_end_init( str_objective, b_starting )
{
	/# IPrintLnBold( "sarah_battle_end_init" ); #/

	level util::set_lighting_state( 1 );
		
	level flag::wait_till( "all_players_spawned" );
		
	if ( b_starting )
	{
		util::screen_fade_out( 0, "black" );
						
		level.ai_hendricks = util::get_hero( "hendricks" );
		hendricks_start_pos = struct::get( "hendricks_start_pos_sarah_battle_end", "targetname" );
		level.ai_hendricks ForceTeleport( hendricks_start_pos.origin, hendricks_start_pos.angles );

	 //Spawn Khalil
	 	level.ai_khalil = util::get_hero( "khalil" );
		khalil_start_pos = struct::get( "khalil_start_pos_sarah_battle_end", "targetname" );
		level.ai_khalil ForceTeleport( khalil_start_pos.origin, khalil_start_pos.angles );

		//fire fx after crash
		exploder::exploder( "sarah_battle_vtol_crash_fire" );
		vtol_apc = GetEnt( "vtol_crash_apc", "targetname" );	
		if(isdefined( vtol_apc ) )
		{
			vtol_apc SetModel( "veh_t7_mil_apc_dead" );
		}		

		// Spawn sarah
		spawn_sarah_boss();

		level flag::set( "vtol_intro_complete" );
		level thread building_destruction_init();

		death_pos = struct::get( "seigebot_sarah_battle_end", "targetname" );
		
		level scene::skipto_end( "cin_inf_02_01_vign_interface_siegebot_bash");
		wait 0.5;
		
		//kill sarah
		level.ai_sarah.origin = death_pos.origin;
		level.ai_sarah.angles = death_pos.angles;

		level.ai_sarah vehicle_ai::set_state( "groundCombat" );
		level.ai_sarah util::stop_magic_bullet_shield();
		level.ai_sarah siegebot_theia::pain_toggle(false);
		level.ai_sarah DoDamage(level.ai_sarah.health + 10000, level.ai_sarah.origin, level.players[0] );
		
		level thread util::screen_fade_in( 0, "black" );	 		
	}
	level thread monitor_seigebot_sarah_end();
}

// ----------------------------------------------------------------------------
// open_lui_menu
// ----------------------------------------------------------------------------
function open_lui_menu( str_menu )
{
	foreach ( e_player in level.players )
	{
		e_player.infection_temp_menu = e_player OpenLUIMenu( str_menu );
	}
}

// ----------------------------------------------------------------------------
// close_lui_menu
// ----------------------------------------------------------------------------
function close_lui_menu()
{	
	foreach ( e_player in level.players )
	{
		if ( isDefined( e_player.infection_temp_menu ) )
		{
			e_player CloseLUIMenu( e_player.infection_temp_menu );
			e_player.infection_temp_menu = undefined;
		}
	}
}

// ----------------------------------------------------------------------------
// vtol_arrival_done
// ----------------------------------------------------------------------------
function vtol_arrival_done( str_objective, b_starting, b_direct, player )
{
	/# IPrintLnBold( "vtol_arrival_done" ); #/		
		
	objectives::complete( "cp_level_infection_find_dr" );
	level util::set_lighting_state( 0 );
		
}

// ----------------------------------------------------------------------------
// sarah_battle_end_done
// ----------------------------------------------------------------------------
function sarah_battle_done( str_objective, b_starting, b_direct, player )
{
	/# IPrintLnBold( "sarah_battle_done" ); #/
	
	objectives::complete( "cp_level_infection_defeat_sarah" );			
}

// ----------------------------------------------------------------------------
// sarah_battle_end_done
// ----------------------------------------------------------------------------
function sarah_battle_end_done( str_objective, b_starting, b_direct, player )
{
	/# IPrintLnBold( "sarah_battle_end_done" ); #/

	//don't leave ai behind from sarah battle
	allies = GetAiTeamArray( "allies" );
	for( i=0; i < allies.size; i++ )
	{
		allies[i] delete();
	}
	
	objectives::complete( "cp_level_infection_interface_sarah" );					
}

// ----------------------------------------------------------------------------
// sarah_dni_placeholder_text
// ----------------------------------------------------------------------------
function sarah_dni_placeholder_text()
{
	open_lui_menu( "SarahDNI" );
	
	wait 15;	// Give player time to read the text.
	
	close_lui_menu();
}

// ----------------------------------------------------------------------------
// monitor_seigebot_sarah_end
// ----------------------------------------------------------------------------
function clean_up()
{
	level.overridePlayerDamage = undefined;
	foreach( player in level.players )
	{
		self._last_spike_damage_time = undefined;
		self._spawn_time = undefined;
	}
}

function monitor_seigebot_sarah_end()
{
	//spawn align entity for scene (not yet used)
	e_anchor = util::spawn_model("tag_origin", level.ai_sarah.origin, level.ai_sarah.angles);
	e_anchor.targetname = "tag_align_sarah";

	//doesn't like using dead ai for scenes, let it spawn its model.
	level.ai_sarah Delete();

	// cleanup the variables we touched
	clean_up();

	level scene::init( "cin_inf_03_01_interface_1st_dni_02" );			
	
	level thread vo_sarah_interface_init();
	
	//wait for Kane to tell us to interface
	level waittill( "inteface_trig_init" );

	// create a trigger use around sarah	
	t_DNI = Spawn( "trigger_radius_use", e_anchor.origin + (0, 0, 44) , 0, 200, 144 );
   // t_DNI.angles = self.angles;
    t_DNI TriggerIgnoreTeam();
    t_DNI SetVisibleToAll();
    t_DNI SetTeamForTrigger( "none" );
    t_DNI UseTriggerRequireLookAt();
    /# DebugStar( t_DNI.origin, 1000, ( 1, 0, 0 ) ); #/   
    
    t_DNI SetHintString( &"CP_MI_CAIRO_INFECTION_T_DNI" );
    t_DNI SetCursorHint( "HINT_NOICON" );	
    
    objectives::set( "cp_level_infection_interface_sarah", e_anchor );
    
    e_anchor LinkTo( t_DNI );
	
	while (true)
	{		
		t_DNI waittill( "trigger", who );
		
		if ( IsPlayer( who ) )
		{	
			objectives::complete( "cp_level_infection_interface_sarah" );
			
			e_anchor UnLink();
			t_DNI Delete();
			
			//level thread util::screen_fade_out( 15 );
			level scene::play( "cin_inf_03_01_interface_1st_dni_02" );			
			
			level.ai_hendricks util::unmake_hero( "hendricks" );
			level.ai_hendricks util::self_delete();

			level.ai_khalil util::unmake_hero( "khalil" );
			level.ai_khalil util::self_delete();
			
			if( isdefined ( level.sarah_driver ) )
			{	
				level.sarah_driver Delete();
			}
			
			e_anchor Delete();
			
			level notify( "sarah_battle_end" );
			skipto::objective_completed( "sarah_battle_end" );
				
			return;	
		}	
	}
}



// ----------------------------------------------------------------------------
// monitor_sarah_battle
// ----------------------------------------------------------------------------
function monitor_sarah_battle()
{
	//Sarah jumps into arena and flips over truck
	level scene::play( "cin_inf_02_01_vign_interface_siegebot_bash");

	//wait for animation to finish to start her in combat.	
	level.ai_sarah ai::set_ignoreall( false );
	level.ai_sarah vehicle_ai::stop_scripted( "groundCombat" );

	level thread magic_bullet_rpg();
	level thread sarah_spike_launcher_watcher();

	level.ai_sarah waittill( "death" );
	
	end_pos = level.ai_sarah.origin;

	// Stop the spawn managers used to attack
	foreach( spawn_group in level.friendly_spawn_groups)
	{
		if( spawn_manager::is_enabled( "sarah_battle_manager_" + spawn_group ) )
		{
			spawn_manager::disable( "sarah_battle_manager_" + spawn_group );
		}
	}
	
	objectives::complete( "cp_level_infection_defeat_sarah" );

	//notify when death animation completes 
	level.ai_sarah waittill( "death_complete" );		
		
	skipto::objective_completed( "sarah_battle" );
		
	level thread send_friendlies_remaining( end_pos );
}

function send_friendlies_remaining( end_pos )
{
	a_allies = GetAiTeamArray( "allies" );

	//cull friendly ai, two heros and four other max
	//first pass, kill off unseen
	for( i=0; i < a_allies.size; i++ )
	{
		if( a_allies.size <= 6 )
		{
			continue;
		}	
		else if( !( isdefined( a_allies[i] infection_util::player_can_see_me( 256 ) ) && a_allies[i] infection_util::player_can_see_me( 256 ) ) && !a_allies[i] util::is_hero() )
		{
			ArrayRemoveValue(a_allies, a_allies[i]);
			if( IsAlive( a_allies[i] ) )
			{	
				a_allies[i] Kill();
			}
		}
	}

	if( a_allies.size > 6 )
	{
		//second pass, kill off any more needed, furthest from player1
		ai_doomed = array::get_all_farthest( level.players[0].origin, a_allies );
	
		for( i=0; i < ai_doomed.size; i++ )
		{
			if( a_allies.size <= 6 )
			{	
				continue;
			}
			else if( !ai_doomed[i] util::is_hero() && a_allies.size > 6 )
			{
				ArrayRemoveValue(a_allies, ai_doomed[i]);
				ai_doomed[i] Kill();
			}	
		}	
	}

	//find cover positions around sarah within 256 units
	a_all_cover = GetNodeArray("sarah_battle_cover", "script_noteworthy");
	a_far_cover = array::get_all_farthest( end_pos, a_all_cover, undefined, a_allies.size );

	for( i=0; i < a_allies.size; i++ )
	{
		//move surviving allies away from Sarah.
		a_allies[i] ai::set_ignoreall( true );
		
		if(a_allies[i] == level.ai_hendricks)
		{
			a_allies[i] thread send_to_sarah( end_pos );
			
		}
		else if(isdefined(a_far_cover[i]))
		{					
			a_allies[i] SetGoal(a_far_cover[i], true ); 
		}
	}	
}

//dont let ally moving in to Sarah to get to close.
function send_to_sarah( end_pos )
{
	self endon( "death" );
	self endon( "goal" );
	level endon( "sarah_battle_end" );

	//randomize distance to sarah ai will go
	n_engage_dist = RandomIntRange(128,256);

	v_to_sarah = VectorNormalize( self.origin - end_pos ) * n_engage_dist;
	v_goal = end_pos + v_to_sarah;

	self SetGoalPos(v_goal, true ); 
}	
