/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\angola_2_util;

#insert raw\maps\angola.gsh;
#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!
	maps\angola_2_fx::main();
	maps\angola_2_util::setup_objectives();
	maps\_pbr::init();
	maps\_heatseekingmissile::init();
	level_precache();
	init_flags();
	init_spawn_funcs();
	setup_skiptos();

	// There should not be any waits before this function is called.  If you need a wait, make sure the function
	//	is either threaded or called after _load::main.
	maps\_load::main();

	maps\_drones::init();  // required for drones to function

	animscripts\dog_init::initDogAnimations();	// initialize dog animations. Note that these are included in "common_dogs" in the CSV.

	maps\angola_2_anim::main();
	maps\angola_2_amb::main();
	
	SetSavedDvar("phys_buoyancy", 1);  // this enables buoyant physics objects in Radiant (our boat)
	SetSavedDvar("phys_ragdoll_buoyancy", 1);  // this enables ragdoll corpses to float. Note required, but fun. 
	
	SetSavedDvar( "g_vehicleJoltTime", 0.5 );
	SetSavedDvar( "g_vehicleJoltWaves", 1 );
	SetSavedDvar( "g_vehicleJoltIntensity", 0.5 );
	
	level thread maps\_objectives::objectives();

	OnPlayerConnect_Callback( ::on_player_connect );

	//level thread maps\createart\angola_art::main();
}

on_player_connect()
{
	self thread setup_challenges();
}

setup_challenges()
{
	self thread maps\_challenges_sp::register_challenge( "nodeath", ::nodeath_challenge);
	self thread maps\_challenges_sp::register_challenge( "beartrap", ::enemy_kills_with_beartrap_challenge );
	self thread maps\_challenges_sp::register_challenge( "walkingplank", ::escort_boat_kills);
	self thread maps\_challenges_sp::register_challenge( "helidown", ::destroy_heli_using_bullets);
	self thread maps\_challenges_sp::register_challenge( "snipertreekill", ::enemy_kills_using_sniper_tree_challenge );
	self thread maps\_challenges_sp::register_challenge( "hmgboatkill", ::hmg_boat_kills );	
	
	//carry over from Angola 1
	self thread maps\_challenges_sp::register_challenge( "machetegib", ::challenge_machete_gibs );
	self thread maps\_challenges_sp::register_challenge( "mortarkills", ::challenge_mortar_kills );
}


nodeath_challenge( str_notify )
{
	self waittill( "mission_finished" );
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}
	
}

enemy_kills_with_beartrap_challenge( str_notify )
{
	self waittill( "mission_finished" );

	if( IsDefined(level.num_beartrap_catches) && (level.num_beartrap_catches >= level.num_beartrap_challenge_kills) )
	{
		self notify( str_notify );
	}
}


escort_boat_kills( str_notify )
{
	self waittill( "walking_plank_event_over");
	
	if(isdefined( level.challenge_escort_boat_destroy ) && level.challenge_escort_boat_destroy == 8)
	{
		self notify(str_notify);
	}
}

hmg_boat_kills( str_notify )
{
	level waittill( "medium_boat_chase_sequence_done");
	
	if(isdefined( level.challenge_hmg_boat_destroy ) && level.challenge_hmg_boat_destroy >= 5)
	{
		self notify(str_notify);
	}
}

destroy_heli_using_bullets( str_notify )
{
	self waittill( "heli_down_using_bullets");
	
	self notify( str_notify );
}


enemy_kills_using_sniper_tree_challenge( str_notify )
{
	level endon( "end_of_jungle_escape" );

	while( 1 )
	{
		level waittill( "sniper_tree_kill" );

		level.num_snipertree_kills++;
		if( (level.num_snipertree_kills >= level.num_snipertree_challenge_kills) )
		{
			self notify( str_notify );
			return;
		}
	}
}

challenge_machete_gibs( str_notify )
{	
	add_global_spawn_function( "axis", ::check_machete_death, str_notify);
		
	/*a_b_storystats = [];
	
	b_right_arm = get_temp_stat( ANGOLA_RARM_CHOP );
	a_b_storystats[a_b_storystats.size] = b_right_arm;
	
	b_left_arm = get_temp_stat( ANGOLA_LARM_CHOP );
	a_b_storystats[a_b_storystats.size] = b_left_arm;
	
	b_right_leg = get_temp_stat( ANGOLA_RLEG_CHOP );
	a_b_storystats[a_b_storystats.size] = b_right_leg;
	
	b_left_leg = get_temp_stat( ANGOLA_LLEG_CHOP );
	a_b_storystats[a_b_storystats.size] = b_left_leg;
	
	b_head = get_temp_stat( ANGOLA_HEAD_CHOP );
	a_b_storystats[a_b_storystats.size] = b_head;
	
	n_machete_gib_counter = 0;
	n_machete_gib_total = 5;
	
	foreach( b_stat in a_b_storystats)
	{
		if( b_stat == true)
		{
			n_machete_gib_counter++;
		}
	}

	n_unique_gib = 0;
	
	while ( n_machete_gib_counter < n_machete_gib_total )
	{
		gib = level waittill_any_return( "machete_gib_head", "machete_gib_right_arm", "machete_gib_left_arm", 
		                                "machete_gib_right_leg", "machete_gib_left_leg", "machete_gib_no_legs");
		
		switch( gib )
		{
			case "machete_gib_right_arm":
				if( !b_right_arm )
				{	
					n_unique_gib++;
					b_right_arm = true;
					set_temp_stat( ANGOLA_RARM_CHOP, 1);
					PrintLn( "Right Arm Gibbed");
				}
				break;
			
			case "machete_gib_left_arm":
				if( !b_left_arm )
				{	
					n_unique_gib++;
					b_left_arm = true;
					set_temp_stat( ANGOLA_LARM_CHOP, 1);
					PrintLn( "Left Arm Gibbed");
				} 
				break;
			
			case "machete_gib_right_leg":
				if( !b_right_leg )
				{	
					n_unique_gib++;
					b_right_leg = true;
					set_temp_stat( ANGOLA_RLEG_CHOP, 1);
					PrintLn( "Right Leg Gibbed");
				}  
				break; 
			
			case "machete_gib_left_leg":
				if( !b_left_leg )
				{	
					n_unique_gib++;
					b_left_leg = true;
					set_temp_stat( ANGOLA_LLEG_CHOP, 1);
					PrintLn( "Left Leg Gibbed");
				}  
				break;

			case "machete_gib_no_legs":
				if( !b_right_leg )
				{	
					n_unique_gib++;
					b_right_leg = true;
					set_temp_stat( ANGOLA_RLEG_CHOP, 1);
					PrintLn( "Right Leg Gibbed");
				}  
				
				if( !b_left_leg )
				{	
					n_unique_gib++;
					b_left_leg = true;
					set_temp_stat( ANGOLA_LLEG_CHOP, 1);
					PrintLn( "Left Leg Gibbed");
				}				
				break;				
			
			case "machete_gib_head":
				if( !b_head )
				{	
					n_unique_gib++;
					b_head = true;
					set_temp_stat( ANGOLA_HEAD_CHOP, 1);
					PrintLn( "Head Gibbed");
				}  
				break; 
		}
		
		while (n_unique_gib > 0)
		{
			self notify( str_notify );
			n_machete_gib_counter++;
			n_unique_gib--;
			wait 0.1;
		}
	}	*/	
}

check_machete_death( str_notify ) //self = AI
{
	self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname );
	
	//Check if the player killed the enemy, and if he did it with the machete
	if ( (attacker == level.player) && (type == "MOD_MELEE" ) )
	{
		level notify(str_notify);
	}
}

challenge_mortar_kills( str_notify )
{
	
	
	flag_init( "mortar_challenge_complete" );
	self endon( str_notify );
	
	//wait(0.1);
	
	while ( !flag("mortar_challenge_complete") )
	{
		self waittill( "grenade_fire", e_grenade, str_weapon_name );
		
		if ( str_weapon_name == "mortar_shell_sp" )
		{	
			e_grenade thread check_mortar_killcount();
		}
	}
}

//hardcoded radius to match mortar damage radius
#define MORTAR_SP_RADIUS 512

check_mortar_killcount() //self = grenade
{
	self waittill( "death" );
	
	wait 0.25;
	
	a_enemies = GetAIArray( "axis" );
	a_drones = drones_get_array( "axis" );
	a_enemies_and_drones = ArrayCombine( a_enemies, a_drones,true,false );
	a_enemies_in_range = get_within_range( self.origin, a_enemies_and_drones, MORTAR_SP_RADIUS );
	
	n_killcount = 0;
	
	foreach( guy in a_enemies_in_range )
	{
		if(	!(is_alive(guy)) )
		{
			n_killcount++;
		}  	
		else if( (guy.targetname == "drone") && (isdefined(guy.dead)) )
		{
			n_killcount++;
		}
	}
	
	iprintlnbold( "Mortar toss killed " + n_killcount);
	
	if (n_killcount >= 5)
	{
		flag_set( "mortar_challenge_complete" );
	}
}
//
// All precache calls go here
level_precache()
{
	PrecacheItem( "barretm82_nosway_sp" );
	PrecacheItem( "rpg_player_sp" );
	PrecacheItem( "huey_rockets" );
	PrecacheItem( "mgl_sp" );
	PrecacheItem( "m16_sp" );
	Precacheitem( "m60_sp" );
	PrecacheItem( "dragunov_sp" );
	PrecacheItem( "rpg_magic_bullet_sp" );
	PrecacheItem( "strela_sp" );
	// Bear Trap assets
	PrecacheItem( "beartrap_sp" );
	PrecacheItem( "mortar_shell_sp" );
	PrecacheItem( "Stinger_sp" );
	PreCacheItem( "fnp45_sp" );
	PrecacheItem( "usrpg_player_sp" );	
	
	PrecacheModel( "viewmodel_knife" );

	PrecacheModel( "t6_wpn_mortar_shell_prop_view" );
	PrecacheModel( "t6_wpn_bear_trap_prop" );
	PrecacheModel( "t6_wpn_machete_prop" );
	PrecacheModel( "veh_t6_mil_gaz66_cargo" );
	precachemodel( "veh_t6_air_alouette_dmg_att" );
	precachemodel( "c_usa_jungmar_barechest_fb");
	precachemodel( "fxanim_angola_barge_wheelhouse_mod" );
	precachemodel( "fxanim_angola_barge_aft_debris_mod" );
	Precachemodel( "fxanim_angola_barge_side_debris_mod" ); 
	precachemodel( "t6_wpn_pistol_browninghp_prop_view" );
	Precachemodel( "veh_t6_sea_gunboat_medium_waterbox" );
	Precachemodel( "veh_t6_sea_barge_rear_dmg_destroyed" );
	Precachemodel( "veh_t6_sea_barge_side_dmg_destroyed" );
	PrecacheModel( "veh_t6_mil_gaz66_cargo_door_left" );
	PrecacheModel( "veh_t6_mil_gaz66_cargo_door_right" );
	PrecacheModel( "t6_wpn_launch_stinger_obj" );
	Precachemodel( "p6_angola_dead_pile_on_floor");
	PrecacheModel( "p6_angola_dead_pile_on_crate");
//	PrecacheModel( "t6_wpn_launch_mm1_world" );
	PrecacheModel( "t6_wpn_launch_usrpg_world" );
	
	precacheRumble( "tank_damage_light_mp" );
	precacheRumble( "buzz_high" );
	PrecacheRumble( "la_1_fa38_intro_rumble" );
	PrecacheRumble( "explosion_generic" );
	PrecacheRumble( "angola_hind_ride" );
}


//
// Each event's init_flags called here
init_flags()
{
	// SECTION 1
//	maps\angola_2_eventname::init_flags();
	
	// SECTION 2

	// SECTION 3

}


//
//  Each event's init_spawn_funcs called here.
init_spawn_funcs()
{
	// SECTION 1
//	maps\angola_2_eventname::init_spawn_funcs();
	
	// SECTION 2

	// SECTION 3
}


/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
//	These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
setup_skiptos()
{
	// SECTION 1
//	add_skipto( "eventname", 		maps\angola_2_eventname::skipto_eventname,
//				"EVENTNAME", 		maps\angola_2_eventname::main );

	// SECTION 2


	// SECTION 3


	add_skipto( "riverbed_intro", 	::angola_skipto);
	add_skipto( "riverbed",			::angola_skipto);
	add_skipto( "savannah_start", 	::angola_skipto);
	add_skipto( "savannah_hill", 	::angola_skipto);	
	add_skipto( "savannah_finish",  ::angola_skipto);
	
	add_skipto( "river", 				maps\angola_river::skipto_river, 									"River",				maps\angola_river::main );
	add_skipto( "Heli_Jump", 			maps\angola_river::skipto_heli_jump,								"Heli_jumpdown",		maps\angola_river::main_jump );
	add_skipto( "Barge",				maps\angola_barge::skipto_barge,									"Barge Fight",			maps\angola_barge::main );
	add_skipto( "jungle_stealth", 		maps\angola_jungle_stealth::skipto_jungle_stealth, 					"Jungle Stealth",		maps\angola_jungle_stealth::main );
	add_skipto( "jungle_stealth_house", maps\angola_jungle_stealth_house::skipto_jungle_stealth_house, 		"Jungle Stealth House",	maps\angola_jungle_stealth_house::main );
	add_skipto( "village", 				maps\angola_village::skipto_village, 								"Village",				maps\angola_village::main );
	add_skipto( "jungle_escape", 		maps\angola_jungle_escape::skipto_jungle_escape,					"Jungle Escape",		maps\angola_jungle_escape::main );
	add_skipto( "jungle_ending",		maps\angola_jungle_ending::skipto_jungle_ending,					"Jungle Ending",		maps\angola_jungle_ending::main );
	
	default_skipto( "river" );
	

	//set_skipto_cleanup_func( ::skipto_cleanup );
}

angola_skipto()
{
	ChangeLevel("angola", true);
}


//
//	Perform any necessary cleanup for the skipto to work properly.  
//	Set flags, cleanup ents, or whatever else as needed so that the skipto will
//	behave as if normal progression occurred.  You don't have to mimic everything;
//	only the necessary things that affect progression.
skipto_cleanup()
{
	skipto = level.skipto_point;

	//	SECTION 1
	if ( skipto == "eventname" )
		return;

	if ( skipto == "eventname2" )
		return;
	
	//	SECTION 2
	
	//	SECTION 3
}


//*****************************************************************************
//*****************************************************************************

level_fade_out( m_player_body )
{
	screen_fade_out( 0 );
}


