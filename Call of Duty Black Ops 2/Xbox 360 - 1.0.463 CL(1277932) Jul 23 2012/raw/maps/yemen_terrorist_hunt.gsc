#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_vehicle;
#include maps\yemen_utility;
#include maps\_objectives;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	flag_init( "terrorist_hunt_start" );
	flag_init( "terrorist_hunt_rockethall_start" );
	flag_init( "rocket_hall_zone_hit" );
	flag_init( "kill_rocket_hall_vo" );
}

//
//	event-specific spawn functions
init_spawn_funcs()
{
	
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_terrorist_hunt()
{
	load_gump( "yemen_gump_market_streets" );
	skipto_teleport( "skipto_terrorist_hunt_player" );
	
	maps\_vehicle::vehicle_add_main_callback( "heli_quadrotor", maps\yemen_utility::yemen_quadrotor_indicator );	
	
	level thread maps\yemen::meet_menendez_objectives();
}

/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
/#
	IPrintLn( "Terrorist Hunt" );
#/

	level thread vo_terrorist_hunt();
	terrorist_hunt_setup();
	
	flag_set( "terrorist_hunt_start" );
	
	level thread rocket_hall();
	
	collapse_door_and_load_area();
	
	flag_wait_either( "rocket_hall_group_cleared", "rocket_hall_bypassed" ); //-- "rocket_hall_bypassed" set in radiant
	flag_set( "kill_rocket_hall_vo" );
		
	terrorist_hunt_clean_up();
	autosave_by_name( "terrorist_hunt" );
}

vo_terrorist_hunt()
{
	level thread vo_market_end();	
	trigger_wait( "spawn_rockethall" );
	level thread vo_rocket_hall();
}

vo_market_end()
{
	if ( !flag( "kill_rocket_hall_vo" ) )
	{
		dialog_start_convo();
		level.player priority_dialog( "fari_harper_i_can_t_kee_0" );	//Harper!  I can’t keep this going.  There’s too many of them!
		level.player priority_dialog( "harp_egghead_listen_to_0" );		//Egghead!  Listen to me.
		level.player priority_dialog( "harp_whatever_menendez_ha_0" );	//Whatever Menendez has planned is going down tomorrow.  A lot of innocent people are going to die.
		dialog_end_convo();
	}
	
	if ( !flag( "kill_rocket_hall_vo" ) )
	{
		dialog_start_convo();
		level.player priority_dialog( "maro_watchtower_watchtow_0" );	//Watchtower, Watchtower, Kilo four-two actual heavily engaged! We are taking fire from the upper floors.
    	level.player priority_dialog( "harp_you_cannot_blow_0" );		//YOU - CANNOT - BLOW - YOUR COVER!
    	level.player priority_dialog( "mart_kilo_four_two_kilo_0" );	//Kilo four-two, Kilo three, we are pinned down in the courtyard.
    	level.player priority_dialog( "harp_stay_strong_and_i_p_0" );	//Stay strong, and I promise I’ll get you through this.  Okay?
    	level.player priority_dialog( "maro_negative_three_watc_0" );	//Negative three. Watchtower, we have a dozen hostiles above the street. Anyone able to support, over?
    	dialog_end_convo();
	}
}

vo_rocket_hall()
{
	dialog_start_convo();
	level.player priority_dialog( "harp_they_re_allies_fari_0", 0, "player_attacked_yemeni", "kill_rocket_hall_vo" );	//They're allies, Farid.  Do not engage without good reason!
	level.player priority_dialog( "fari_yes_1", 0, "player_attacked_yemeni", "kill_rocket_hall_vo" );					//Yes.
//	level.player priority_dialog( "fari_harper_i_killed_so_0", 3, "rocket_hall_zone_hit", "rocket_hall_bypassed" );		//Harper!  I killed some bad guys.
	level.player priority_dialog( "harp_you_got_away_with_it_0", 0, "rocket_hall_zone_hit", "rocket_hall_bypassed" );	//You got away with it, but don't push it, Farid.
	level.player priority_dialog( "harp_the_yemeni_troops_ar_0" );														//The Yemeni troops are taking heavy losses... We're losing too many VTOLS.
    level.player priority_dialog( "harp_get_to_the_courtyard_0" );														//Get to the courtyard, help them however you can.
    dialog_end_convo();
}

collapse_door_and_load_area()
{
	s_door = getstruct( "market_door_spot" );
	
	while ( true )
	{
		trigger_wait( "trigger_market_unload" );
		level.player waittill_player_not_looking_at( s_door.origin, .4, true );
		
		if ( !flag( "market_unload_cancel" ) )
		{
			exploder( 900 ); // geo swap and fx
			Earthquake( .35, 2, level.player.origin, 500 );
			level.player PlayRumbleOnEntity( "artillery_rumble" );
			level thread load_gump( "yemen_gump_morals" );
			break;
		}
	}
}

terrorist_hunt_setup()
{
	add_spawn_function_group( "rocket_hall_actors", "script_noteworthy", ::rocket_hall_terrorist_spawnfunc );
	add_spawn_function_group( "rocket_hall_actors", "script_noteworthy", ::rocket_hall_terrorist_switch_team );
	
	GetEnt( "rocket_hall_guy1", "targetname" ) add_spawn_function( ::rocket_hall_xm25_carrier_spawn_func );
	
	simple_spawn( "terrorist_hunt_court_terrorist", maps\yemen_utility::terrorist_teamswitch_spawnfunc );
	trigger_use( "terrorist_hunt_spawn_drones", "targetname", level.player );
}

terrorist_hunt_court_clean_up()
{
	cleanup( "terrorist_hunt_court_terrorist", "script_noteworthy" );
	cleanup( "terrorist_hunt_court_drones", "script_noteworthy" );
}

terrorist_hunt_clean_up()
{
	exploder( 1030 );
	level notify( "fxanim_market_canopy_delete" );
}

/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/

rocket_hall()
{
	level endon( "rocket_hall_bypassed" );
	
	trigger_wait( "spawn_rockethall" );
	//autosave_by_name( "rocket_hall_start" );
	level thread maps\yemen_anim::terrorist_hunt_anims();	
	rocket_hall_setup();
	
	level thread rocket_hall_switch_team();
		
	level thread rocket_hall_rpgs();
	
	level thread run_scene( "rocket_hall_intro" );

	trig = trigger_wait( "rocket_hall_damage_trig", "targetname", level.player );
	RadiusDamage( trig.origin, 600, 200, 0, undefined, "MOD_EXPLOSIVE" );
	Earthquake( .5, 1, level.player.origin, 100 );
	trig Delete();
	
	flag_set( "rocket_hall_zone_hit" );
	GetEnt( "t_rocket_hall_bypassed", "targetname" ) Delete();
	
	//level thread rocket_hall_american_destruction();
	
	exploder( 330 );
	exploder( 331 );
	exploder( 332 );
	exploder( 333 );
	exploder( 334 );
	
	level notify( "fxanim_ceiling_collapse_start" );
	PlaySoundAtPosition( "fxa_ceiling_collapse", ( -877, -6204, 383 ) );
	
	rocket_hall_play_death_anims();
}

rocket_hall_xm25_carrier_spawn_func()
{
	self endon( "death" );	
	self queue_dialog( "woun_i_am_wounded_0", 2 );			// I am wounded!
	self queue_dialog( "woun_take_it_help_the_f_0", 1 );	// Take it!  Help the fight, brother!
}

// get everything ready for the rocket hall event (spawn fx/actors, clean up behind us)
rocket_hall_setup()
{
	stop_exploder( 1010 );		// turn off FX behind the player
	
	terrorist_hunt_court_clean_up();		
	
	// Spawn in yemeni and other ambient goodies
	spawn_vehicle_from_targetname_and_drive( "rocket_hall_amb_vtol" );
	vh_quadrotor = spawn_vehicle_from_targetname( "rocket_hall_quadrotor" );
	vh_quadrotor.goalpos = vh_quadrotor.origin;
	vh_quadrotor thread maps\_quadrotor::quadrotor_fireupdate();
	
	simple_spawn( "rocket_hall_extra_guys" );	
	
	e_yemeni_spawner = GetEnt("rocket_hall_yemeni", "targetname");
	e_yemeni_spawner add_spawn_function( ::yemeni_teamswitch_spawnfunc );
	e_yemeni_spawner add_spawn_function( ::rocket_hall_yemeni_run_in );
	spawn_manager_enable( "sm_rocket_hall_yemeni" );
		
	flag_set( "terrorist_hunt_rockethall_start" );
}

rocket_hall_american_destruction()
{
	s_grenade_1 = GetStruct( "rocket_hall_grenade_1", "targetname" );
	s_grenade_2 = GetStruct( "rocket_hall_grenade_2", "targetname" );
	
	//wait 4;
	
	a_zone_ai = get_ai_array( "rocket_hall_actors", "script_noteworthy" );
		
	if( IsDefined( a_zone_ai[0] ) && IsAlive( a_zone_ai[0] ) )
	{
		a_zone_ai[0] MagicGrenade( s_grenade_1.origin + (0, 0, 16 ), s_grenade_1.origin, 1 );
	}
	
	//wait 4;
	
	if( IsDefined( a_zone_ai[0] ) && IsAlive( a_zone_ai[0] ) )
	{
		a_zone_ai[0] MagicGrenade( s_grenade_2.origin + (0, 0, 16 ), s_grenade_2.origin, 1 );
	}
}

rocket_hall_rpgs()
{	
	trigger_wait( "rocket_hall_fire_at_vtol", "targetname" );
	
	rocket_hall_rpg_fire( "rocket_hall_rpg_start" );
	wait 12; // TODO: replace with notetrack
	rocket_hall_rpg_fire( "rocket_hall_rpg_court" );
}

rocket_hall_rpg_fire( str_start_struct )
{
	s_rpg_start = GetStruct( str_start_struct, "targetname" );
	s_rpg_end = GetStruct( s_rpg_start.target, "targetname" );
	
	MagicBullet( "rpg_magic_bullet_sp", s_rpg_start.origin, s_rpg_end.origin );
}

rocket_hall_play_death_anims()
{	
	level thread run_scene( "rocket_hall_death_zone_1" );
	level thread run_scene( "rocket_hall_death_zone_2" );
	
	a_ai = get_ai_array( "rocket_hall_actors", "script_noteworthy" );
	foreach ( ai in a_ai )
	{
		if ( IsAlive( ai ) && ( !IsDefined( ai._animactive ) || ( ai._animactive == 0 ) ) )
		{
			ai bloody_death();
		}
	}
}

rocket_hall_yemeni_run_in()
{
	self endon( "death" );
	s_runto_point = GetStruct( "rocket_hall_yemeni_goto_spot", "targetname" );
	
	waittill_ai_group_cleared( "rocket_hall_group" );
	
	wait RandomFloatRange( .05, 2 );
	
	self set_ignoreme( true );
	self force_goal( s_runto_point.origin, 256, false );
	self Delete();
}

/* ------------------------------------------------------------------------------------------
	Spawn Functions
-------------------------------------------------------------------------------------------*/

rocket_hall_yemeni_spawnfunc()
{
	self.team = "axis";
	//self magic_bullet_shield();
}

rocket_hall_terrorist_spawnfunc()
{
	self endon( "death" );
	
	self.team = "allies";
	
	str_notify = level waittill_any_return( "rocket_hall_zone_hit", "rocket_hall_bypassed", "rocket_hall_switch_team" );
	
	if ( str_notify == "rocket_hall_bypassed" )
	{	
		self bloody_death();
	}
	else
	{
		self.team = "team3";
	}
}

rocket_hall_terrorist_switch_team()
{
	self endon( "death" );
	
	while ( self.team == "allies" )
	{
		self waittill( "damage", damage, e_attacker );
		
		if ( IsPlayer( e_attacker ) )
		{
			level notify( "rocket_hall_switch_team" );
		}
	}
}

rocket_hall_switch_team()
{
	level endon( "rocket_hall_zone_hit" );
	level endon( "rocket_hall_bypassed" );
	
	level waittill( "rocket_hall_switch_team" );
	
	GetEnt( "rocket_hall_nosight", "targetname" ) Delete();
	
	level thread run_scene( "rocket_hall_reaction_to_gun" );
}
