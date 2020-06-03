#include maps\_utility; 
#include common_scripts\utility;
#include maps\_anim; 
#include maps\_music;
#using_animtree( "generic_human" );

// TODO: 72.3
//------
// - Add aircraft
// - Add ambient "whatever"
// - Look for what dialogue is needed.
// - Ambient, add random flybys from friendly planes.
// - Fix all bugs with guy popping smoke.
// - Tweak drones

main()
{
//	PrecacheShader( "pel1a_lightning1" );
//	PrecacheShader( "pel1a_lightning2" );
//	precacheShader( "white" );
		precachemodel ("viewmodel_usa_colt45_pistol");		// for banzai attacks
		precachemodel ("vehicle_usa_tracked_shermanm4a3_green_d");
		precachemodel ("anim_foliage_pacific_palmtree_hideout_rope");
		precachemodel ("dest_test_palm_spawnfrond2");
		precachemodel ("dest_test_palm_spawnfrond1");
		precacheitem 	("thompson");
		precacheitem 	("type100_smg");
		
		// strings
		precachestring(&"PEL1A_THROWSMOKE");
		

	// createfx needs this high up in the chain
	maps\pel1a_fx::main(); 		
			
		
	// weapon swapping for the flame thrower	
	maps\_coop_weaponswap::init();
				
	// drone loading
//	character\char_usa_marinewet_r_rifle::precache(); 
	character\char_jap_makpel_rifle::precache(); 
	character\char_usa_marine_r_rifle::precache(); 

	// Vehicles
	maps\_sherman::main( "vehicle_usa_tracked_shermanm4a3_green" ); 
	maps\_aircraft::main( "vehicle_usa_aircraft_f4ucorsair", "corsair" );
	maps\_aircraft::main( "vehicle_jap_airplane_zero_fly", "zero" );
	maps\_model3::main( "artillery_jap_model3_dist" );
		
	// These are called everytime a drone is spawned in to set up the character.
	level.drone_spawnFunction["axis"] = character\char_jap_makpel_rifle::main; 
	level.drone_spawnFunction["allies"] = character\char_usa_marine_r_rifle::main;

	// Call this before maps\_load::main(); to allow drone usage.
	maps\_drones::init(); 	
	
	// Why is this asserting?
	maps\_mganim::main(); 
	
	// Setup the friendlies, needs to be before the starts to set up animnames.
	setup_threatbiasgroups();
	setup_friends();

	// Start Function calls
	add_start( "event2", ::event2_start, &"STARTS_PEL1A_EVENT2" );
	add_start( "event3", ::event3_start, &"STARTS_PEL1A_EVENT3" );
	add_start( "event4", ::event4_start, &"STARTS_PEL1A_EVENT4" );
	default_start( ::event1_start ); 

	// _load!
	maps\_load::main(); 
	

	// Anything special external scripts.
	maps\_treefall::main(); 
	maps\_mortarteam::main();
	maps\_tree_snipers::main(); 
	
	//banzai charge assets
	maps\_banzai::init();	
	
	// All the level support scripts.
	maps\pel1a_amb::main(); 
	maps\pel1a_anim::main(); 
	maps\pel1a_status::main(); 
	//maps\createcam\pel1_cam::main(); 

	// Do all of the setup stuff.
	setup_levelvars();

	init_flags();
		
	// temp for now, figure out how to do with callbacks on connect
	level thread threat_group_setter(); 

	
	// weapon swapping for the flame thrower
	level.onPlayerWeaponSwap = maps\_coop_weaponswap::flamethrower_swap;
	
	
	// spawn player funcs

	// TFLAME's stuff
	switch(getdifficulty() )
	{
		case "easy":
		level.difficulty = 1;
		break;
		case "medium":
		level.difficulty = 2;
		break;
		case "hard":
		level.difficulty = 3;
		break;
		case "fu":
		level.difficulty = 4;
		break;
	}
	setup_spawn_functions();
	wait_for_first_player();
	players = get_players();
	array_thread(players, :: player_setup);
	
	level thread trigs_off();
	level thread trigs_setup();
	array_thread(get_players(), ::achivement_checker);
	level thread lastpit_trap();
	level thread chain_on_after_pit1clear();
	badplacesenable(0); // too much stupid AI when using flamethrower in trenches, they just stand there too often
	
	//netfriendly spawner trigger stuff
	
	trigs = getentarray("nolag_trigger_spawns", "script_noteworthy");
	array_thread(trigs, ::do_netfriendly_trigger_spawn);

	trigs = getentarray("flood_spawner_netfriendly", "targetname");
	array_thread(trigs, ::do_netfriendly_flood_spawn);
	


	if(NumRemoteClients() > 0)		// networked coop
	{
		level.max_drones["allies"] = 8;	// Down from 32
		level.max_drones["axis"] = 8; // Down from 32
	}

	thread switch_in_flamethrower();
	
	// Testing/Debug
	
	level thread info_gather();  // TEMP constantly running loop to get level variables

/#
//	level thread debug_ai_counts();
#/


}

switch_in_flamethrower()
{
	flag_wait("starting final intro screen fadeout");

	players = get_players();
	
	players[0] TakeWeapon("thompson");
	players[0] GiveWeapon("m2_flamethrower");
	players[0] SwitchToWeapon("m2_flamethrower");
	
}

// flamer's info gatherer
info_gather()
{

	while(1)
	{
		level.player = get_players()[0];
		ang = level.player getplayerangles();
		level.curious_mg = getent("auto2372", "targetname");
		wait 2;
	}
}

// Sets all of the flags used in the level
init_flags()

{
	// Used to determine if there is smoke in the event1_smoke_check trigger
	flag_init( "event1_smoke_popped" );

	// Used to turn on/off the model3
	flag_init( "model3_fire_think" );
	flag_set( "model3_fire_think" );
	flag_init( "pit2_defenders_alerted");
	flag_init("player_attacking");
	flag_init("M2_achievement_failed");
	flag_init("stop_gunquake");
	
}
//---------//
// TESTING //
//---------//

//---------------//
// Setup section //
//---------------//

// Sets up all of the initial level variables.
setup_levelvars()
{
	// global levelvars
	level.maxfriendlies = 3; 
	level.mortar = level._effect["dirt_mortar"];
	level thread maps\_mortar::set_mortar_quake( "dirt_mortar", 0.4, 1, 1500 );
	
	// local levelvars
	level.mortar_crews = 3;
}

// Setup the spawn functions for spawners.
setup_spawn_functions()
{
	// TFLAME - Guess I do it different?
	array_thread(getentarray("charge_player", "script_noteworthy"), 			:: add_spawn_function, ::charge_player_dudes);
	array_thread(getentarray("player_hater", "script_noteworthy"), 				:: add_spawn_function, ::player_hater);
	array_thread(getentarray("martyr", "script_noteworthy"), 							:: add_spawn_function, ::martyrdom);
	array_thread(getentarray("pit2_defenders", "targetname"), 						:: add_spawn_function, ::pit2_defender_setup);
	array_thread(getentarray("pit2_defenders2", "targetname"), 						:: add_spawn_function, ::pit2_defender_setup);
	array_thread(getentarray("pit2_allies", "targetname"), 								:: add_spawn_function, ::pit2_attacker_setup);
	array_thread(getentarray("mortar_dudes", "script_noteworthy"), 				:: add_spawn_function, ::mortar_dudes_setup);	
	array_thread(getentarray("no_climb", "script_noteworthy"), 						:: add_spawn_function, ::treesnipers_setup);	
	array_thread(getentarray("tankrunners", "targetname"), 								:: add_spawn_function, ::road_runners);	
	array_thread(getentarray("cave2_lastguys", "targetname"), 						:: add_spawn_function, ::killspawner_onspawn, 29);
	array_thread(getentarray("intro_helpout_dudes", "targetname"), 				:: add_spawn_function, ::intro_helpout_dudes_setup);
	array_thread(getentarray("pit1_mg_guy", "script_noteworthy"), 				:: add_spawn_function, ::my_mg_stop);
	array_thread(getentarray("outro_weary_walkers", "script_noteworthy"), :: add_spawn_function, ::weary_walkers_setup);
	array_thread(getentarray("outro_patrollers", "script_noteworthy"),	  :: add_spawn_function, ::patrollers_setup);
	array_thread(getentarray("traffic_dude", "script_noteworthy"),	  		:: add_spawn_function, ::traffic_dude);
	array_thread(getentarray("e1_firstmortar_lastguys", "targetname"),	  :: add_spawn_function, ::killspawner_onspawn, 23);
	array_thread(getentarray("actor_ally_us_usmc_reg_flamethrower", "classname"),	  :: add_spawn_function, ::dont_drop_flamer);
	array_thread(getentarray("approaching_last_tunnel_guys", "targetname"),	  :: add_spawn_function, ::killspawner_onspawn, 32);
	
	array_thread(getentarray("actor_axis_jap_reg_type100smg", "classname"),	 				:: add_spawn_function, ::no_nades_oneasy);
	create_spawner_function( "actor_axis_jap_reg_type99rifle", "classname", ::no_nades_oneasy );	// apparently there are living guys even though i don't see any in radiant
	array_thread(getentarray("actor_axis_jap_reg_camo_type99rifle", "classname"),	  :: add_spawn_function, ::no_nades_oneasy);
	array_thread(getentarray("actor_axis_jap_reg_camo_type100smg", "classname"),	  :: add_spawn_function, ::no_nades_oneasy);

	
										





	middle_mger = getent("middle_mger", "script_noteworthy");	// this guy stops shooting for some reason
	middle_mger.ignoreme = true;			
	middle_mg = getent("middle_mg", "targetname");
	middle_mg setturretignoregoals( true );	
	


	// Event2 Spawners
	create_spawner_function( "event2_mg42_spawner", "script_noteworthy", ::event2_mg42_target_wrapper );

	// Event4 Spawners
	create_spawner_function( "event4_door_kicker", "script_noteworthy", ::event4_door_kicker );

//	create_spawner_function( "event4_jap_officer", "script_noteworthy", ::event4_hara_kiri );
//	create_spawner_function( "event4_last_captor", "script_noteworthy", ::event4_hara_kiri );

	create_spawner_function( "event4_talker", "script_noteworthy", ::event4_talker );
}

my_func( parm1, parm2 )
{
	
}

// Setup the threatbiasgroups
setup_threatbiasgroups()
{
	// threatbias group setups
	CreateThreatBiasGroup( "players" ); 
	CreateThreatBiasGroup( "friends" ); 
	CreateThreatBiasGroup( "japanese_turret_gunners" ); 
	CreateThreatBiasGroup( "player_haters" ); 
	CreateThreatBiasGroup( "pit2_defenders" ); 
	CreateThreatBiasGroup( "pit2_attackers" );

	// ignoreme group setups
	SetIgnoreMeGroup( "players", "japanese_turret_gunners" ); 					//turret guys ignore all players
	SetIgnoreMeGroup( "friends", "japanese_turret_gunners" ); 					//turret guys ignore all friends
	SetIgnoreMeGroup( "japanese_turret_gunners", "friends" ); 					//friends ignore turretguys
	SetIgnoreMeGroup( "friends" , "player_haters"); 										//player_haters only hate player
	
	setthreatbias("player_haters", "players", 10000);
	setthreatbias("players", "player_haters", 10000);		// still confused as to which way is right
}

// Sets up the friends array, as well as threatbiasgroiups for the friendlies.
setup_friends()
{
	// Main characters setup
	level.friends = []; 

	level.roebuck 			= GetEnt( "roebuck", "script_noteworthy" ); 
	level.roebuck.animname 	= "roebuck";
	level.friends[0] 		= level.roebuck;

	level.polonsky 			= GetEnt( "polonsky", "script_noteworthy" ); 
	level.polonsky.animname = "polonsky";
	level.friends[1] 		= level.polonsky;
	
	for( i = 0; i < level.friends.size; i++ )
	{
		level.friends[i] SetThreatBiasGroup( "friends" ); 
		level.friends[i] thread magic_bullet_shield();
	}

	// Temporarily put these guys in god mode until they join the player's squad
	// TFLAME - I noticed this can look bad as they get shot with no reaction....
	/*
	joiners = GetEntArray( "event1_joiners", "targetname" );
	for( i = 0; i < joiners.size; i++ )
	{
		joiners[i] SetCanDamage( false );
		joiners[i] thread replace_on_death();
	}
	*/
}

//-------------------//
// Objective Section //
//-------------------//

// The objecive setting function for pel1
set_objective( num, ent )
{
	startplace = GetDvar( "start" ); 

	if( num == 1 )
	{
		// Get into the trenches.
		Objective_Add( 0, "active", &"PEL1A_OBJECTIVE1", ( level.roebuck.origin ) );
	}
	else if( num == 2 )
	{		
		// Eliminate enemy mortar crews. [&&1 remaining]
		Objective_Add( 1, "active" );

		Objective_String( 1, &"PEL1A_OBJECTIVE2", level.mortar_crews );

		mortar_node1 = GetNode( "auto2233", "targetname" );
		objective_location = getstruct("mortar1_objective_location", "targetname");
		Objective_AdditionalPosition( 1, 0, objective_location.origin );

		mortar_node2 = GetNode( "auto2237", "targetname" );
		Objective_AdditionalPosition( 1, 1, mortar_node2.origin );

		mortar_node3 = GetNode( "auto4863", "targetname" );
		Objective_AdditionalPosition( 1, 2, mortar_node3.origin );

		objective_current( 1 );

		level thread objective_mortar_update( "pit1_lastbunker_guys", 0 );
		level thread objective_mortar_update( "pit2_defenders", 1 );
		level thread objective_mortar_update( "pit3_defenders", 2 );
	}
	else if( num == 3 )
	{
		// interrogate japanese officers
		struct = getstruct("regroup_objective_spot", "targetname");
		Objective_Add( 0, "active", &"PEL1A_OBJECTIVE3", struct.origin );
		objective_current(0);
	}
	else if( num == 4 )
	{
		objective_state( 0, "done" );
	}
}

objective_mortar_update( mortar_aigroup, id )
{
	waittill_aigroupcleared(mortar_aigroup);
	
	increase_mortar_delay();
	
	if (mortar_aigroup == "pit1_lastbunker_guys")
	{
		level thread maps\_utility::autosave_by_name( "pit1_clear" );
	}

	level.mortar_crews--;
	
	if( level.mortar_crews == 0 )
	{
		waittill_aigroupcleared("pit3_defenders");
		Objective_AdditionalPosition( 1, id, ( 0, 0, 0 ) );
		Objective_String_NoMessage( 1, &"PEL1A_OBJECTIVE2", level.mortar_crews );
		Objective_State( 1, "done" );
		set_objective( 3 );
	}
	else 
	{
		if (level.mortar_crews == 2)
		{
			// "One down.  Move on!"\
			level.roebuck anim_single_solo(level.roebuck, "first_mortar_pit4");
		}
	
		/*TFLAME - Moved elsewhere
		if (level.mortar_crews == 1)
		{

			// "Taken out - One more pit to clear."\
			level.roebuck anim_single_solo(level.roebuck, "second_mortar_pit3");
			// "Keep it up."\
			level.roebuck anim_single_solo(level.roebuck, "second_mortar_pit4");			
		}
		*/
				
		Objective_AdditionalPosition( 1, id, ( 0, 0, 0 ) );
		Objective_String( 1, &"PEL1A_OBJECTIVE2", level.mortar_crews );
	}
}

// Decreases the frequency of the mortar explosions
increase_mortar_delay()
{
	clientNotify("imd");	// increase mortar delay.
	
	// Clientsided mortars.
	
/*	min_delay = level._explosion_min_delay["dirt_mortar"] + ( level._explosion_min_delay["dirt_mortar"] * 0.5 );
	max_delay = level._explosion_max_delay["dirt_mortar"] + ( level._explosion_max_delay["dirt_mortar"] * 0.5 );
	maps\_mortar::set_mortar_delays( "dirt_mortar", min_delay, max_delay ); */
}

//----------------//
// Events Section //
//----------------//

//---------//
// Event 1 //
//---------//

// Default start
event1_start()
{
	// Start the ambients
	level thread event1_ambients();
	
	// Send out the ai with the drones
	spawners = getentarray("intro_drone_ai", "targetname");
	level thread simple_floodspawn(spawners);

	// Set the bloomy vision
	//VisionSetNaked( "pel1a_intro", 1 );

	// Set the door angles
	left_door = GetEnt( "bunker_door_left", "targetname" );
	right_door = GetEnt( "bunker_door_right", "targetname" );
	left_door.angles = ( 0, 45, 0 );
	right_door.angles = ( 0, -30, 0 );	

	level thread set_start_position( "event1_starts", true );
	level event1_radio_man();
	



	level.roebuck setgoalnode(getnode("sarge_intro_node","targetname"));
	level.radio_man setgoalnode(getnode("radio_guy_intro_node","targetname")); 
	
	issue_color_orders( "r0", "allies" );
	//issue_color_orders( "y0", "allies" );
		
	




	

	flag_wait("all_players_connected");
	level thread event1_intro_music();
	level thread theres_only_one_Flamer();	
	level.roebuck thread event1_intro_dialog();
	battlechatter_off("allies");
	level waittill( "introscreen_complete" );

	//wait( 2 );

	// Start the colors!


	level thread event1_plane_down();
	level thread event1_pop_smoke();
	level thread player_leaves_e1_early();
	//level thread event1_joiners();

	// Start the mortars!

	// Mortars moved to the client.
	
	clientNotify("sm");
	
	/*
	// Get the dust_points for the canned mortars.
	dust_points = getstructarray( "ceiling_dust", "targetname" );
	for( i = 0; i < dust_points.size; i++ )
	{
		// Tells explosion_activate that the struct is a struct and not an entity
		dust_points[i].is_struct = true;
	}

//	level.roebuck thread maps\_anim::anim_single_solo( level.roebuck, "mortars_to_the_trenches" );
	//set_objective( 1 );

	struct = getstruct( "event1_mortar1", "targetname" );
	struct.is_struct = true; // Tells explosion_activate that the struct is a struct and not an entity
	struct thread maps\_mortar::explosion_activate( "dirt_mortar", undefined, undefined, undefined, undefined, undefined, undefined, dust_points );	

	level thread maps\_mortar::mortar_loop( "dirt_mortar", 1 );
	
	//trigger = GetEnt( "event1_mortar2", "targetname" );
	//trigger waittill( "trigger" );

	struct = getstruct( "event1_mortar2", "targetname" );
	struct.is_struct = true; // Tells explosion_activate that the struct is a struct and not an entity
	struct thread maps\_mortar::explosion_activate( "dirt_mortar", undefined, undefined, undefined, undefined, undefined, undefined, dust_points );
*/
			//TFLAME - Player shouldnt have to move to get started
			
	set_objective( 2 );
	trigger = GetEnt( "event1_find_mortars", "targetname" );
	trigger waittill( "trigger" );
	
	level notify ("headed to first mg");
	
	level.radio_man enable_ai_color();
	level.roebuck 	enable_ai_color();

	level.polonsky 	anim_single_solo( level.polonsky, "first_mg1" );	// "MG up on that hill!"\
	level.polonsky 	anim_single_solo( level.polonsky, "first_mg2" );	// "It's tearing up our men!"\
	level.roebuck 	anim_single_solo( level.roebuck, "first_mg3" );		// "Throw some smoke for cover!... Or it will rip us to shreds!"\

}

event1_intro_dialog()
{
	level endon ("headed to first mg");

	level thread event1_radio_guy_moveup();
	
	self.animname = "roebuck";
	wait 1.5;
	self anim_single_solo(self, "intro1");	// "Our Tanks are getting hammered by mortar fire!"\
	self anim_single_solo(self, "intro2");	// "We're need to clear these trenches and knock out each mortar pit!"\
	self anim_single_solo(self, "intro3");	// "Get ready with that flamethrower!"\
	self anim_single_solo(self, "intro4");	// "Incoming!!!"\
	//wait 1;		// too long of a wait right now, no dialogue yet
	
	// turn on roebucks color Ai again, send the squad up if the player hasn't moved up yet
	self enable_ai_color();
	battlechatter_on("allies");
	battlechatter_on("axis");
	battlechatter_on();
	
	trig = getent("event1_find_mortars","targetname");
	
	if (isdefined(trig))
	{
		trig notify ("trigger");
	}	
}

event1_radio_guy_moveup()
{	
	trigger_wait("event1_find_mortars","targetname");
	
	wait 2.25;
	level.radio_man enable_ai_color();
}

event1_radio_man()
{
	level.radio_man = GetEnt( "radio_man", "targetname" );
	level.radio_man thread magic_bullet_shield();
	level.radio_man.animname = "radio_man";
	//radio_man maps\_anim::anim_single_solo( radio_man, "air_support" );

	level.radio_man set_force_color( "y" );
}

// Ambients
event1_ambients()
{
	// Put the Bunker MG gunners in "god" mode till the player flanks.
	guys = GetEntArray( "bunker_mg_gunners", "targetname" );

	for( i = 0; i < guys.size; i++ )		// this needs to be turned back on for when player can flank behind
	{
		guys[i] SetCanDamage( false );
	}

	// Set the mgs to only shoot at drones
	mgs = GetEntArray( "bunker_mgs", "script_noteworthy" );

	for( i = 0; i < mgs.size; i++ )
	{
		mgs[i].script_fireondrones = true;
		mgs[i] thread maps\_mgturret::mg42_target_drones( false, "axis" );
	}

	level thread event1_model3_fire_think();
}

event1_model3_fire_think()
{
	gun = GetEnt( "model3_gun", "targetname" );

	while( 1 )
	{
		if( !flag( "model3_fire_think" ) )
		{
			wait( 0.05 );
			continue;
		}

		gun FireWeapon();
		gun notify( "model3_fired" );
		if (!flag("stop_gunquake") )
		{
			earthquake (0.5, 0.7, gun.origin, 8000);
		}
		wait( RandomFloatRange( 6, 10 ) );
	}
}

// Set the vision for right after the introscreen
event1_intro_music()
{
	wait( 1 );
	//TUEY Set Music State to INTRO
	setmusicstate("INTRO");
	//VisionSetNaked( "pel1a", 5 );
}

event1_bunker_doors_open()
{
	left_door = GetEnt( "bunker_door_left", "targetname" );
	left_door.script_linkto = "origin_animate_jnt";

	right_door = GetEnt( "bunker_door_right", "targetname" );
	right_door.script_linkto = "origin_animate_jnt";

	left_door ConnectPaths();
	right_door ConnectPaths();

//	left_door RotateTo( ( 0, 90, 0 ), 3, 1, 0.2 );
//	right_door RotateTo( ( 0, -95, 0 ), 3.5, 2, 0.3 );	

	level thread maps\_anim::anim_ents_solo( left_door, "open", undefined, undefined, left_door, "bunker_door_left" );
	level thread maps\_anim::anim_ents_solo( right_door, "open", undefined, undefined, right_door, "bunker_door_right" );

	anim_org = getstruct( "event1_intro_spot", "targetname" );
	guys[0] = level.polonsky;
	guys[1] = level.roebuck;

	level thread maps\_anim::anim_single( guys, "event1_open_door", undefined, undefined, anim_org );
}

//event1_intro_dialogue()
//{
//	level.polonsky maps\_anim::anim_single( level.polonsky, "intro_talk" );
//	level.roebuck maps\_anim::anim_single( level.roebuck, "intro_talk" );
//}

//// Tells the Joiners to group with the squad.
//event1_joiners()
//{
//	trigger = GetEnt( "event1_joiners_trigger", "targetname" );
//
//	guys = GetEntArray( "event1_joiners", "targetname" );
//	for( i = 0; i < guys.size; i++ )
//	{
//		guys[i] set_force_color( "r" );
//		guys[i].animname = "joiner";
//		guys[i].ignoreall = true;
//	}
//
//	trigger = GetEnt( "event1_joiner_rush_talk", "targetname" );
//	trigger waittill( "trigger", guy );
//
//	maps\_anim::anim_single_solo( guy, "rush_talk" );
//
//	for( i = 0; i < guys.size; i++ )
//	{
//		guys[i] event1_joiners_thread();
//	}
//}

// When the Joiners get to their goal (color node), reset the ignores/damage variables.
//event1_joiners_thread()
//{
//	self waittill( "goal" );
//
//	self SetCanDamage( true );
//	self.ignoreall = false;	
//}

// Start the little plane-being-shot-down vignette
event1_plane_down()
{
	trigger = GetEnt( "event1_plane_down", "targetname" );
	trigger waittill( "trigger" );

	//level.polonsky thread maps\_anim::anim_single_solo( level.polonsky, "plane_down1" );

	level thread event1_plane_explosion();
}

// Plays the proper FX for the plane
event1_plane_explosion()
{
	v_node = GetVehicleNode( "auto4820", "targetname" );
	v_node waittill( "trigger", plane );

	PlayFx( level._effect["plane_explosion"], plane GetTagOrigin( "tag_prop" ) );
	PlayFxOnTag( level._effect["plane_trail"], plane, "tag_prop" );
	//level.polonsky thread maps\_anim::anim_single_solo( level.polonsky, "plane_down2" );

	plane waittill( "reached_end_node" );
	PlayFx( level._effect["plane_ground_explosion"], plane.origin );	
	playsoundatposition("pel1a_corsair_crash", plane.origin);
}

// Roebuck pops smoke
event1_pop_smoke()
{
	level endon( "stop_pop_smoke" );

	smoke_trigger = GetEnt( "event1_smoke_trigger_check", "targetname" );
	smoke_trigger thread check_smoke_in_trigger( "event1_smoke_popped" );

	trigger = GetEnt( "event1_pop_smoke", "targetname" );
	trigger waittill( "trigger" );
	
	
	level thread smoke_hint_and_reset();
	level thread event1_pop_smoke_skip();



	level thread event1_pop_smoke_anim();


	
	level waittill( "event1_smoke_popped" );
	wait( 8 );

//	level.roebuck custom_battlechatter( "move_generic" );

	level notify( "smoke_popped" );

	level thread event2();
}

// Check to see if the player skips the pop smoke scene
event1_pop_smoke_skip()
{
	level endon( "smoke_popped" );
	trigger = GetEnt( "ev4_mortarcrew_spawn_trig", "targetname" );
	trigger waittill( "trigger" );

	// Player made it past the pop smoke without waiting
	level notify( "stop_pop_smoke" );

	level thread event2();
}

// Tells Roebuck to toss a smoke grenade
event1_pop_smoke_anim()
{
	level endon( "stop_pop_smoke" );

	while(1)
	{
		nades = get_players()[0] getweaponammostock("m8_white_smoke");
		if (nades == 0)
		{
			break;
		}
		wait 0.5;
	}

	node = GetNode( "event1_pop_smoke", "targetname" );
//	level.roebuck maps\_anim::anim_single_solo( level.roebuck, "will_pop_smoke" );

	og_radius = level.roebuck.goalradius;

	//TFLAME - dunno why need to do this
	// level.roebuck disable_ai_color();
 	level.roebuck PushPlayer( true );
	level.roebuck.dontavoidplayer = true;
	level.roebuck.goalradius = 4;
	level.roebuck.ignoreall = true;
	level.roebuck.ignoreme = true;
	level.roebuck SetCanDamage( false );
	level.roebuck disable_pain();

	level.roebuck SetGoalNode( node );
	level.roebuck waittill( "goal" );

	level.roebuck maps\_grenade_toss::force_grenade_toss( ( 27000, -3896, 8 ), "m8_white_smoke" );
	level.roebuck.goalradius = og_radius;

 	level.roebuck PushPlayer( false );
	level.roebuck.dontavoidplayer = false;
	level.roebuck.ignoreall = false;
	level.roebuck SetCanDamage( true );
	level.roebuck enable_pain();
	level.roebuck.ignoreme = false;

	level.roebuck enable_ai_color();

}

//---------//
// EVENT 2 //
//---------//

event2_start()
{
	set_start_position( "event2_starts" ); // AI First
	set_start_position( "event2_starts", true ); // Players 2nd
	set_start_objective( 2 );

//	// Re-enable the joiners damage.
//	joiners = GetEntArray( "event1_joiners", "targetname" );
//	for( i = 0; i < joiners.size; i++ )
//	{
//		joiners[i] SetCanDamage( true );
//
//		// Reset the color and animnames.
//		joiners[i] set_force_color( "r" );
//		joiners[i].animname = "joiner";
//	}

	// Start the drones
	trigger = GetEnt( "auto878", "target" );
	trigger notify( "trigger" );

	// Start the ambients
	level thread event1_ambients();

	// Start the mortars
//	level thread maps\_mortar::mortar_loop( "dirt_mortar", 1 );
	clientNotify("sm");

	// Start the friendly reinforcements
	trigger = GetEnt( "auto4850", "target" );
	trigger notify( "trigger" );

	level thread event2();
}

event2()
{
	thread event2_moveup_dialog();
	thread event2_uphill_dialog();	
	
	spawners = getentarray("intro_helpout_dudes", "targetname");
	if (level.difficulty < 4)
	{
		level thread simple_spawn( spawners, randomintrange(10, 20) );	// guys that help you out if you are pinned down by ridge guys in begining
	}
	
	// Make it so only the left side of the intro brunker, drones are going.
	trigger = GetEnt( "auto878", "target" );	
	temp_array = [];
	for( i = 0; i < trigger.targeted.size; i++ )
	{
		if( trigger.targeted[i].origin[0] < 27200 )
		{
			temp_array[temp_array.size] = trigger.targeted[i];
		}
	}

	trigger.targeted = temp_array;

	// Drone trigger
	trigger = GetEnt( "auto878", "target" );

	// Turn down the amount of drones
	trigger.script_delay_min = 1;
	trigger.script_delay_max = 5;

	getent("squad_up_past_smoke_chain", "targetname") notify ("trigger");

	//kill off the intro ai fakedrones
	maps\_spawner::kill_spawnernum(120);
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		if (isdefined(allies[i].script_noteworthy) && allies[i].script_noteworthy == "intro_drone_ai")
		{
			allies[i] thread wait_and_kill(randomint(10) );
		}
	}

	trigger = GetEnt( "event3", "targetname" );
	trigger waittill( "trigger" );
	level thread event3();
}

event2_uphill_dialog()
{
	level thread cave2_clear();
	trigger_wait("pit2_chain","script_noteworthy");

	level.roebuck anim_single_solo(level.roebuck, "up_hill1"); // "Get up there!"\
	level.roebuck anim_single_solo(level.roebuck, "up_hill2"); // "Take the high ground!"\
	
	wait 3;
	level.polonsky anim_single_solo(level.polonsky, "second_mortar_pit1"); 	// "There's the next mortar pit!"\
	level.roebuck anim_single_solo(level.roebuck, "second_mortar_pit2"); // "Burn 'em!!!!"\
	
	waittill_aigroupcleared("pit2_defenders");
	// "Taken out - One more pit to clear."\
	level.roebuck anim_single_solo(level.roebuck, "second_mortar_pit3");
	// "Keep it up."\
	level.roebuck anim_single_solo(level.roebuck, "second_mortar_pit4");	
	
}

event2_moveup_dialog()
{
	level notify ("squad_moving_up");
	wait 1;
	level.roebuck anim_single_solo( level.roebuck, "first_mg5" );	// "Go!"\
	level.roebuck anim_single_solo( level.roebuck, "first_mg7" ); // "All right... let's keep on 'em!"\
	level.roebuck anim_single_solo( level.roebuck, "first_mg8" ); // "This way!"\
	
	wait 2;

	level.roebuck anim_single_solo( level.roebuck, "first_mortar_pit1" );	// "Eyes open!"\
	level.polonsky anim_single_solo( level.polonsky, "first_mortar_pit2" );	// "First mortar pit up ahead!"\
	level.roebuck anim_single_solo( level.roebuck, "first_mortar_pit3" );	// "Go clear it out, Miller…"\
}

// Handles the movement of the mg42 target
event2_mg42_target_wrapper()
{
	level thread event2_mg42_target( self );

	level thread event2_mg_dialogue( self );
}

event2_mg_dialogue( guy )
{
	guy endon( "death" );

	wait( 2 );
//	level.polonsky thread maps\_anim::anim_single_solo( level.polonsky, "take_out_mg" );
}

event2_mg42_target( guy )
{
	turret = GetEnt( "event2_mg42_gun", "script_noteworthy" );

	center = ( 26134, -3170, -80 );

	target = Spawn( "script_origin", center );
	target thread event2_mg42_target_movement();

	trigger = Spawn( "trigger_radius", center, 2, 84, 200 );
	
	current_mode = "";
	request_mode = "manual_ai";

	while( IsAlive( guy ) )
	{
		if( current_mode != request_mode )
		{
			current_mode = request_mode;
			turret SetMode( current_mode );

			if( current_mode == "manual_ai" )
			{
				guy SetEntityTarget( target );
				turret SetTargetEntity( target );
			}
			else
			{
				guy ClearEntityTarget( target );
				turret ClearTargetEntity( target );
			}
		}

		// Check to see if anyone is touching the trigger
		if( any_player_IsTouching( trigger ) )
		{
			request_mode = "auto_ai";
		}
		else if( trigger team_is_touching( "allies" ) )
		{
			request_mode = "auto_ai";
		}
		else
		{
			request_mode = "manual_ai";
		}

		wait( 0.1 );
	}	

	target Delete();
	trigger Delete();
}

event2_mg42_target_movement()
{
	self endon( "death" );

	x = 26128;
	min_y = 3136;
	min_z = 70;
	max_y = 3240;
	max_z = 83;

	while( 1 )
	{
		pos = ( x, RandomFloatRange( min_y, max_y ) * -1, RandomFloatRange( min_z, max_z ) * -1 );
		self MoveTo( pos, RandomFloat( 3, 7 ) );
		self waittill( "movedone" );

		wait( RandomFloat( 1, 5 ) );
	}
}

//---------//
// Event 3 //
//---------//

event3_start()
{
	//delete_ent( "auto3286", "target" ); // Trigger that spawns guys in the bunker at the start
	level event1_radio_man();
	set_start_position( "event3_starts" ); // AI First
	set_start_position( "event3_starts", true ); // Players 2nd
	set_start_objective( 2 );

	wait 1;
	maps\_spawner::kill_spawnernum(200);
	maps\_spawner::kill_spawnernum(23);
	maps\_spawner::kill_spawnernum(25);

	// Start the colors!
	//issue_color_orders( "r7", "allies" );

	// Re-enable the joiners damage.
//	joiners = GetEntArray( "event1_joiners", "targetname" );
//	for( i = 0; i < joiners.size; i++ )
//	{
//		joiners[i] SetCanDamage( true );
//
//		// Reset the color and animnames.
//		joiners[i] set_force_color( "r" );
//		joiners[i].animname = "joiner";
//	}

	// Start the drones
	trigger = GetEnt( "auto878", "target" );
	trigger notify( "trigger" );

	// Start the ambients
	level thread event1_ambients();

	// Start the mortars
	//level thread maps\_mortar::mortar_loop( "dirt_mortar", 1 );
	clientNotify("sm");

	// Start the friendly reinforcements
	//trigger = GetEnt( "auto4850", "target" );
	//trigger notify( "trigger" );

	level thread event3();
}

// Sets up a couple threads for Event3.
event3()
{
	level thread distance_fight_smoke_hint();
	level thread event3_mg_blow();
	level thread pit2_threatbias_setup();	
	level thread kill_middle_mger();	

	level thread event3_ridge_enemy_dialog();
	
	level thread event4();

//	wait_for_first_player();
//	players = get_players();
//	while( 1 )
//	{
//		origin2 = players[0].origin - ( 0, 100, 0 );
//		PlayFx( level._effect["mg_tunnel_explosion"], players[0].origin, VectorNormalize( players[0].origin - origin2 ) );
//		wait( 3 );
//	}

	trigger = GetEnt( "event3_ridge", "targetname" );
	trigger waittill( "trigger" );

//	level.polonsky thread maps\_anim::anim_single_solo( level.polonsky, "lookout" );
}

event3_ridge_enemy_dialog()
{
	trigger_wait("event3_ridge", "targetname");
	maps\_spawner::kill_spawnernum(23);
	level.polonsky anim_single_solo(level.polonsky, "treesnipers");		// "We got snipers in the trees!"
	level.roebuck anim_single_solo(level.roebuck, "barrel_enemies1");	// "Take cover!  Behind the barrels, get down!"\
	wait 5;
	level.polonsky anim_single_solo(level.polonsky, "ridge_enemies1");	// "Look out!  Enemies on the ridge!"\
}

event3_mg_blow()
{
	trigger = GetEnt( "event3_mg_blow", "targetname" );

	amount = 0;
	while( 1 )
	{
		trigger waittill( "damage", dmg, attacker, dir, point, type );
		
		if( attacker.classname == "script_model" )
		{
			amount += dmg;
		}

		if( amount > 400 )
		{
			break;
		}
	}

	struct = getstruct( trigger.target, "targetname" );
	PlayFx( level._effect["mg_tincan_explosion"], struct.origin );

	origin = struct.origin - ( 0, 0, 200 );
	origin2 = struct.origin - ( 0, 100, 200 );
	forward = VectorNormalize( origin - origin2 );
	PlayFx( level._effect["mg_tunnel_explosion"], origin, forward );

	wait( 2 );
	origin = struct.origin - ( 0, 0, 100 );
	PlayFx( level._effect["smoke_plume_xlg_slow_blk_w"], origin );
}

//---------//
// Event 4 //
//---------//
event4_start()
{
	
	set_start_position( "event4_starts" ); // AI First
	set_start_position( "event4_starts", true ); // Players 2nd

	wait 12;
	players = get_players();
	if (players.size == 1)
	{
		getent("tanks_movein","targetname") notify ("trigger");
	}
	
	set_start_objective( 2 );
	set_mortar_notify( 2 );

	// Start the colors!
	issue_color_orders( "r7", "allies" );

	// Re-enable the joiners damage.
//	joiners = GetEntArray( "event1_joiners", "targetname" );
//	for( i = 0; i < joiners.size; i++ )
//	{
//		joiners[i] SetCanDamage( true );
//
//		// Reset the color and animnames.
//		joiners[i] set_force_color( "r" );
//		joiners[i].animname = "joiner";
//	}

	// Start the drones
//	trigger = GetEnt( "auto878", "target" );
//	trigger notify( "trigger" );

	// Start the ambients
	level thread event1_ambients();

	// Start the mortars
//	level thread maps\_mortar::mortar_loop( "dirt_mortar", 1 );

	// Start the friendly reinforcements
	trigger = GetEnt( "auto4850", "target" );
	trigger notify( "trigger" );

	level thread event4();
}

event4()
{
	// You are far enough, be sure the spawners are dead back in event2.
	scripted_kill_spawners( 200 );
	level thread before_last_tunnel_guys_clear();

	trigger = GetEnt( "event4", "targetname" );
	trigger waittill( "trigger" );

	thread event4_tunnel_dialog();
	
	// Clear out the guys we don't want to see at the end of the level.
	level thread bloody_death_array( "event3_ridge_guys", "script_noteworthy" );

	guys = GetAiArray( "axis" );
	for( i = 0; i < guys.size; i++ )
	{
		if( guys[i].origin[0] < 27000 )
		{
			guys[i] thread bloody_death( 5 );
		}
	}

	flag_clear( "model3_fire_think" );

	level thread event4_tank_dust();
	level thread event4_last_area();
}

event4_tunnel_dialog()
{
	level.roebuck anim_single_solo(level.roebuck, "third_mortar_pit3"); // "Get in there and clear those tunnels!"\
	
	trigger_wait("event4_dialog_tunnels", "targetname");
	waittill_aigroupcleared("pre_pit3_defenders");
	level.roebuck anim_single_solo(level.roebuck, "third_mortar_pit1");	// "Last mortar pit's dead ahead - Move!"\
	level.roebuck anim_single_solo(level.roebuck, "third_mortar_pit2");	// "We're almost done here."\

	while (level.mortar_crews)
	{
		wait 0.5;
	}
	waittill_aigroupcleared("pit3_defenders");
	axis = getaiarray("axis");
	for (i=0; i < axis.size; i++)
	{
		axis[i] thread wait_and_kill(randomfloat(1,5));
	}
	
	waittill_aigroupcleared("pre_pit3_defenders");
	waittill_aigroupcleared("pit1_lastbunker_guys");		// more checks since i changed up event 1
	
	level.roebuck anim_single_solo(level.roebuck, "third_mortar_pit5");	// "Outstanding!"\
	level thread battlechatter_off("allies");
	
	level.at_end_place_count = 0;
	
	level.roebuck disable_ai_color();
	level.radio_man disable_ai_color();
	level.polonsky disable_ai_color();
	
	level.roebuck thread  add_to_place_count_on_goal("end_sarge_node");
	level.radio_man thread  add_to_place_count_on_goal("end_radio_guy_node");
	level.polonsky thread  add_to_place_count_on_goal("end_polo_node");
	
	while (level.at_end_place_count != 3)
	{
		wait 0.1;
	}
	getent("player_in_regroup_spot", "targetname") trigger_on();
	getent("player_in_regroup_spot", "targetname") waittill ("trigger");
	
	thread end_level();	
}

add_to_place_count_on_goal(node_string)
{
	self.goalradius = 256;
	
	self setgoalnode(getnode(node_string,"targetname"));
	self thread early_goal_arrive();
	self waittill ("goal");
	level.at_end_place_count++;
}

early_goal_arrive()
{
	self endon ("goal");
	wait 0.05;
	while(1)
	{
		dist = distance(self.origin, self.goalpos);
		if (dist < 400)
		{
			self notify ("goal");
		}
		wait 0.05;
	}
}
	
end_level()
{
	time = 0;
	players = get_players();					// Check for M2 and u cheev
	if (players.size == 1)
	{
		getent("tanks_movein","targetname") notify ("trigger");
		time = 6;
	}
	
	thread end_level_dialog(time);
}

end_level_dialog(time)
{


	//TUEY Set music state to Level End
	setmusicstate("LEVEL_END");

// _endmission.gsc already checks this 	
//	players = get_players();					// Check for M2 and u cheev
//	for (i=0; i < players.size; i++)
//	{
//		if (isdefined(players[i].failedachievement) && players[i].failedachievement == false)
//		{
//			players[i] maps\_utility::giveachievement_wrapper( "ANY_ACHIEVEMENT_FTONLY");
//			//iprintlnbold("ACHIEVEMENT GW");
//		}
//	}
	
	
	level.radio_man anim_single_solo(level.radio_man, "outro1");	//"Sir - Mortar pits have been neutralized... Tanks are now en route to the point."\
	level.polonsky anim_single_solo(level.polonsky, "outro2");	// "Tanks are moving up!"\
	level.roebuck anim_single_solo(level.roebuck, "outro3");	// "Radio command - Tell 'em we've cleared the mortar pits."\
	level.roebuck anim_single_solo(level.roebuck, "outro4");	// "Good work, Marines…"\
	
	set_objective(4);
	
	if (isdefined(time))
	{
		wait time;
	}
	nextmission();	
}


event4_tank_dust()
{
	level waittill( "vehiclegroup spawned" + 5, tanks );

	for( i = 0; i < tanks.size; i++ )
	{
		tanks[i] thread event4_tank_dust_think();
	}

	v_node = GetVehicleNode( "auto3451", "targetname" );
	v_node waittill( "trigger" );

//	level.polonsky thread maps\_anim::anim_single_solo( level.polonsky, "tanks_show_up" );
}

event4_tank_dust_think()
{
	self endon( "death" );

	range = 180;
	while( 1 )
	{
		if( self.origin[1] < -1900 )
		{
			wait( 0.2 );
			continue;
		}

		tank_forward = AnglesToForward( ( 0, self.angles[1], 0 ) );
		tank_origin = self.origin + vector_multiply( tank_forward, 100 );

		yaw = RandomInt( 360 );

		forward = AnglesToForward( ( 0, yaw, 0 ) );
		origin = tank_origin + vector_multiply( forward, RandomInt( range ) );

		if( self.origin[1] > -1400 )
		{
			origin = ( origin[0], origin[1], 24 );
		}
		else
		{
			origin = ( origin[0], origin[1], 80 );
		}

		PlayFX( level._effect["ceiling_dust"], origin );

		wait( RandomFloat( 0.5 ) );
	}
}

// Spawner function
event4_door_kicker()
{
	self.animname = "event4_door_kicker";
	self SetCanDamage( false );	

	door = GetEnt( "kick_door1", "targetname" );
	maps\_anim::anim_reach_solo( self, "kick_door", undefined, undefined, door );
	maps\_anim::anim_single_solo( self, "kick_door", undefined, undefined, door );
	issue_color_orders( "r15", "allies" );
}

event4_last_area()
{
	trigger = GetEnt( "event4_last_mortar", "targetname" );
	trigger waittill( "trigger" );

	// Kill the mger
	mger = GetEnt( "last_mger", "script_noteworthy" );

	if( IsDefined( mger ) ) // Incase he gets deleted for whatever reason.
	{
		mger SetCanDamage( true );
		mger DoDamage( mger.health + 1, ( 0, 0, 0 ) );
	}

	flag_set( "model3_fire_think" );

//	level thread event4_push_scene_setup( "event4_push_a" );
//	level thread event4_push_scene_setup( "event4_push_b" );
//
//	level thread event4_disable_weapon();
		//level thread event4_last_objective();
//
//	event4_conversation();

	//flag_set( "last_objective" );
}

event4_conversation()
{
//	level.roebuck maps\_anim::anim_single_solo( level.roebuck, "glad_to_see" );
//	level.polonsky maps\_anim::anim_single_solo( level.polonsky, "same_gun" );
//	level.roebuck maps\_anim::anim_single_solo( level.roebuck, "detour" );
}

// Spawn function
event4_talker()
{
	self.walkdist = 999;
	self.animname = "talker";
	self.targetname = "event4_talker";
}

// Waits for the right conditions before setting the last objective.
event4_last_objective()
{
	// Flag set either by delay (above) or by triggerH
	level waittill( "last_objective" );

	talker = GetEnt( "event4_talker", "targetname" );
//	talker thread maps\_anim::anim_single_solo( talker, "found_one" );

	trigger = GetEnt( "event4_more_info", "targetname" );
	trigger waittill( "trigger" );

//	talker thread maps\_anim::anim_single_solo( talker, "more_info" );
}

// Spawns and sets up the AI's properly after spawning in.
// This is the scene where the Allies are overtaking the last mortar pit
event4_push_scene_setup( t_name )
{
	// PushA guys
	spawners = GetEntArray( t_name + "_spawners", "targetname" );

	guys = [];
	for( i = 0; i < spawners.size; i++ )
	{
		guys[i] = spawners[i] StalingradSpawn();
		guys[i].ignoreme = true;

		guys[i].ignoreall = true;

		if( guys[i].team == "allies" )
		{
			guys[i].animname = t_name + "_ally";
		}
		else
		{
			guys[i].animname = t_name + "_axis";				
		}
	}

	node = GetNode( t_name, "targetname" );
	level thread event4_push_scene( guys, node );
}

event4_push_scene( guys, node )
{
	maps\_anim::anim_single( guys, "intro", undefined, node );
	maps\_anim::anim_loop( guys, "loop", undefined, "never_end", node  );
}

// Disables the player's weapon if not in the trigger
event4_disable_weapon()
{
	trigger = GetEnt( "event4_disable_weapon", "targetname" );
	trigger waittill( "trigger" );

	while( 1 )
	{
		trigger waittill( "trigger", other );

		if( IsPlayer( other ) && ( !IsDefined( other.disabled_weapon ) || !other.disabled_weapon ) )
		{
			other.disabled_weapon = true;

			other DisableWeapons();
			other thread event4_enable_weapon( trigger );
		}
	}
}

// Enables the player's weapon if not in the trigger
event4_enable_weapon( trigger )
{
	while( 1 )
	{
		wait( 1 );

		if( !self IsTouching( trigger ) )
		{
			self EnableWeapons();
			self.disabled_weapon = false;
			return;
		}
	}
}

// Spawner Function
// This sets up the japanese officers as well as play their hara kiri animation
event4_hara_kiri()
{
	self.ignoreall = true;
	self.ignoreme = true;
	self.goalradius = 0;
	self SetGoalPos( self.origin );

	if( self.team == "allies" )
	{
		return;
	}

	// So nothing can hurt them until we want them to kill themselves.
	self SetCanDamage( false );

	if( !IsDefined( level.event4_officers ) )
	{
		level.event4_officers = 0;
	}

	level.event4_officers++;
	
	self.animname = "event4_officer" + level.event4_officers;

	self gun_remove();
	self thread maps\_anim::anim_loop_solo( self, "hara_kiri_idle", undefined, "stop_idle" );

	trigger = GetEnt( "event4_hara_kiri_anim", "targetname" );
	trigger waittill( "trigger" );

	wait( RandomFloat( 1 ) );

	// Attach the katana
	self Attach( "weapon_jap_katana", "tag_weapon_right" );

	self notify( "stop_idle" );

	self SetCanDamage( true );
	self.deathanim = level.scr_anim[self.animname]["hara_kiri"];
	self DoDamage( self.health + 1, ( 0, 0, 0 ) );

	self thread event4_hara_fx();

	if( IsDefined( level.mission_done ) )
	{
		return;
	}

	level.mission_done = true;
	wait( 13 );
	nextmission();
}

// Plays the blood fx when they are dead
event4_hara_fx()
{
	for( ;; )
	{
		self waittill( "deathanim", notetrack );

		if( notetrack == "sndnt#bayonet_stab" )
		{
			PlayFxOnTag( level._effect["flesh_hit"], self, "tag_weapon_right" );
			break;
		}
	}
}

//////////////////////////////////////////////////////////////////
///////////////////// UTILITY FUNCTIONS //////////////////////////
//////////////////////////////////////////////////////////////////


//------------//
// START UTIL //
//------------//

// Get starting AI, probably heros
get_starting_guys()
{
	guys1 = GetEntArray( "starting_allies", "targetname" );
//	guys2 = GetEntArray( "event1_joiners", "targetname" );
	guys2 = [];
	radio_man = GetEnt( "radio_man", "targetname" );

	guys2[guys2.size] = radio_man;

	return array_combine( guys1, guys2 );
}

// Get the points to warp the starting AI to
get_start_points( start_name, only_players )
{
	starts = [];

	if( only_players )
	{
		structs = getstructarray( start_name, "targetname" );

		for( i = 0; i < structs.size; i++ )
		{
			if( IsDefined( structs[i].script_int ) )
			{
				starts[starts.size] = structs[i];
			}
		}

		starts = ascend_starts( starts );
	}
	else
	{
		structs = getstructarray( start_name, "targetname" );

		for( i = 0; i < structs.size; i++ )
		{
			if( !IsDefined( structs[i].script_int ) )
			{
				starts[starts.size] = structs[i];
			}
		}
	}
	
	return starts; 
}

check_smoke_in_trigger( flag_ref )
{
	wait 0.05;
	level endon ("squad_moving_up");
	for( ;; )
	{
		grenades = GetEntArray( "grenade", "classname" );

		for( i = 0 ; i < grenades.size; i++ )
		{
			if( grenades[i].model != "projectile_us_smoke_grenade" )
			{
				continue;
			}
	
			if( grenades[i] IsTouching( self ) )
			{
				flag_set( flag_ref );
				level notify ("smoke_grenade_done");
			}
		}

		wait( 0.5 );
	}
}

ascend_starts( array )
{
	temp = array;
	for( i = 0; i < array.size; i++ )
	{
		for( j = i; j < array.size; j++ )
		{
			if( temp[j].script_int < array[i].script_int )
			{
				array[i] = temp[j];
			}
		}
	}

	return array;
}

// Does all of the players/ai position upon a start.
set_start_position( start_name, only_players )
{
	
	flag_wait("all_players_connected");
	only_players = 1;
	if( !only_players )
	{
		start_hide_players();

		start_warp_guys( start_name ); 

		start_unhide_players();
	}

	start_warp_guys( start_name, only_players );
}

// warp the starting ai to the start points
start_warp_guys( start_name, only_players )
{
	if( !IsDefined( only_players ) )
	{
		only_players = false;
	}

	if( only_players )
	{
		guys = get_players();
	}
	else
	{
		guys = get_starting_guys();
	}

	//starts = get_start_points( start_name, only_players ); 
	starts = getstructarray( start_name, "targetname" );
	
	if( !IsDefined( starts ) || starts.size < 1 || !IsDefined( guys ) )
	{
		println( "^1start_warp_guys(), starts or guys are not defined!" );
		return; 
	}
	
	if( only_players )
	{
		for( i = 0; i < guys.size; i++ )
		{
			guys[i] SetOrigin( starts[i].origin );
			guys[i] SetPlayerAngles( starts[i].angles );
		}
	}
	else
	{
		for( i = 0; i < guys.size; i++ )
		{
			guys[i] Teleport( starts[i].origin, starts[i].angles ); 
		}
	}
}

// hide players so AI to teleport, doesnt work atm
start_hide_players()
{
	// get all players
	players = get_players();
	hide_spot = GetStruct( "hide_spot", "targetname" );

	for( i = 0; i < players.size; i++ )
	{
		players[i].og_start_origin = players[i].origin;
		players[i] SetOrigin( hide_spot.origin );
	}
}

// unhide the players
start_unhide_players()
{
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		if( IsDefined( players[i].og_start_origin ) ) // Support hot-join for starts
		{
			players[i] SetOrigin( players[i].og_start_origin );
		}
		else
		{
			players[i] SetOrigin( players[0].og_start_origin );
		}
	}
}

// Set the the objective if using a start.
set_start_objective( num )
{
	for( i = 0; i < num; i++ )
	{
		set_objective( i + 1 );
	}
}

// Sets off notifies so the objectives update properly
set_mortar_notify( num )
{
	wait( 0.05 );

	mortar_node1 = GetNode( "auto2233", "targetname" );
	mortar_node2 = GetNode( "auto2237", "targetname" );
	mortar_node3 = GetNode( "mortar_node3", "targetname" );

	if( num >= 1 )
	{
		mortar_node1 notify( "mortar_done" );
	}

	if( num >= 2 )
	{
		mortar_node2 notify( "mortar_done" );		
	}	
}

// until we get the proper way to do this
threat_group_setter()
{
	while( 1 )
	{
		players = get_players(); 
		for( i = 0; i < players.size; i++ )
		{
			players[i] SetThreatBiasGroup( "players" ); 
		}
		wait( 2 ); 
	}
}

// Check to see if anyone is touching self
team_is_touching( team )
{
	if( IsDefined( team ) )
	{
		guys = GetAiArray( team );
	}
	else
	{
		guys = GetAiArray();
	}

	for( i = 0; i < guys.size; i++ )
	{
		if( guys[i] IsTouching( self ) )
		{
			return true;
		}
	}

	return false;
}

// used for starts
delete_ent( value, key )
{
	ent = GetEnt( value, key );
	ent Delete();
}

create_spawner_function( value, key, func )
{
	spawners = GetEntArray( value, key );

	for( i = 0; i < spawners.size; i++ )
	{
		if (!isalive(spawners[i]) )
		{
			spawners[i] add_spawn_function( func );
		}
		else
		{
			spawners[i] thread [[func]]();
		}
	}
}

bloody_death_array( value, key )
{
	ents = GetEntArray( value, key );
	for( i = 0; i < ents.size; i++ )
	{
		ents[i] thread bloody_death( 1 );
	}
}

// Fake death
// self = the guy getting worked
bloody_death( delay )
{
	self endon( "death" );

	if( !IsSentient( self ) || !IsAlive( self ) )
	{
		return;
	}

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for( i = 0; i < 3 + RandomInt( 5 ); i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	self DoDamage( self.health + 50, self.origin );
}	

// self = the AI on which we're playing fx
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}

scripted_kill_spawners( num )
{
	spawners = GetSpawnerArray(); 
	for( i = 0 ; i < spawners.size ; i++ )
	{
		if( ( IsDefined( spawners[i].script_killspawner ) ) &&( num == spawners[i].script_killspawner ) )
		{
			spawners[i] Delete(); 
		}
	}
}

//---------------//
// Debug Section //
//---------------//

do_print3d( msg )
{
	self endon( "death" );
	while( 1 )
	{
		print3d( self.origin, msg );
		wait( 0.05 );
	}
}

line_to_player()
{
	players = get_players();
	while( 1 )
	{
		line( self.origin, players[0].origin );
		wait( 0.05 );
	}
}

debug_ai_counts()
{
/#
	SetDvar( "show_ai_count", "1" );

	huds = [];
	huds["drones"] = debug_ai_createhud( 620, 325, "Drones:" );
	huds["allies"] = debug_ai_createhud( 620, 340, "Allies:" );
	huds["axis"] = debug_ai_createhud( 620, 355, "Axis:" );
	huds["total"] = debug_ai_createhud( 620, 370, "Total:" );

	while( 1 )
	{
		dvar = GetDvarInt( "show_ai_count" );
		if( dvar )
		{
			allies = [];
			axis = [];

			allies = GetAiArray( "allies" );
			axis = GetAiArray( "axis" );

			keys = GetArraykeys( huds );
			for( i = 0; i < keys.size; i++ )
			{
				huds[keys[i]].title.alpha = 1;
				huds[keys[i]].value.alpha = 1;
			}

			huds["drones"].value SetText( level.drones["allies"].lastindex + level.drones["axis"].lastindex );
			huds["allies"].value SetText( allies.size );
			huds["axis"].value SetText( axis.size );
			huds["total"].value SetText( allies.size + axis.size );
		}
		else
		{
			keys = GetArraykeys( huds );
			for( i = 0; i < keys.size; i++ )
			{
				huds[keys[i]].title.alpha = 0;
				huds[keys[i]].value.alpha = 0;
			}
		}

		wait( 0.05 );
	}
#/
}

debug_ai_createhud( x, y, text )
{
/#
	struct = SpawnStruct();

	title = NewDebugHudElem();
	title.location = 0;
	title.alignX = "right";
	title.alignY = "middle";
	title.foreground = 1;
	title.fontScale = 1.2;
	title.alpha = 1;
	title.x = x;
	title.y = y;
	title SetText( text );

	value = NewDebugHudElem();
	value.location = 0;
	value.alignX = "left";
	value.alignY = "middle";
	value.foreground = 1;
	value.fontScale = 1.2;
	value.alpha = 1;
	value.x = x + 2;
	value.y = y;
	value SetText( "0" );

	struct.title = title;
	struct.value = value;

	return struct;
#/
}


///////////////////////////////////////////// TONY's STUFF I.E. NEWB CENTRAL \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/////// TFLAME UTILS \\\\\\\\\\

waittill_and_setflag(mynotify,myflag)
{
	self waittill (mynotify);
	flag_set(myflag);
}

wait_and_notify(waittime, mynotify)
{
	self endon ("death");
	wait waittime;
	self notify (mynotify);
}

wait_and_kill(time, spot)
{
	self endon ("death");
	wait time;
	if (isdefined(spot))
	{
		bullettracer(spot.origin, self geteye(), true);
		magicbullet("ppsh", spot.origin, self geteye());
		self dodamage(self.health*10, spot.origin);
	}
	else
	{
		self dodamage(self.health*10, self.origin);
	}
}

grab_ai_by_script_noteworthy(value,side)
{
	guys = getaiarray(side);
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i]) && isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == value)
		{
			return guys[i];
		}
	}
}

trigs_setup()
{
	getent("alert_pit2_guys", "targetname") thread waittill_and_setflag("trigger", "pit2_defenders_alerted");
	getent("treesnipers_chain", "targetname") thread 	waittill_trig_and_say(level.polonsky , "polonsky", "treesnipers", 5);
}



////////////////////// END TFLAME UTILS \\\\\\\\\\\\\\\\\\\\\\

charge_player_dudes()
{
	self endon ("death");
	self thread player_hater();
	if (cointoss())
	{
		self thread martyrdom();
	}
	while(1)
	{
		self.goalradius = 128;
		players = get_players();
		myenemy = players[0];
		closestdist = 5000;
		for (i=0; i < players.size; i++)
		{
			dist = distance (self.origin, players[i].origin);
			if ( dist < closestdist)
			{
				closestdist = dist;
				myenemy = players[i];
			}
		}
		self setgoalentity(myenemy);
		wait 3;
	}
}

player_hater()
{
	self setthreatbiasgroup("player_haters");
}

martyrdom()
{
	level thread martyrdom_go(self);
}	

martyrdom_go(guy)
{
	guy waittill ("death");
	axis = getaiarray("axis");
	if (isdefined(axis[0]) )
	{
		axis[0] magicgrenade(guy.origin+(0,0,30), guy.origin, randomfloatrange(3,5) );
	}
}

pit2_threatbias_setup()
{
	setignoremegroup("players", "pit2_defenders");
	setignoremegroup("friends", "pit2_defenders");
	setignoremegroup("pit2_defenders", "friends");
	flag_wait("pit2_defenders_alerted");
	wait 3;
	setthreatbias("players", "pit2_defenders", 10000);
	setthreatbias("friends", "pit2_defenders", 10000);
	setthreatbias("pit2_defenders", "friends", 10000);
}

pit2_defender_setup()
{
	self endon ("death");
	self setthreatbiasgroup("pit2_defenders");
	self.health = 300;
	mynode = getnode(self.target, "targetname");
	flag_wait("pit2_defenders_alerted");
	wait 3;
	newnode = getnode(mynode.script_noteworthy + "_flipside", "script_noteworthy");
	if (isdefined(newnode))
	{
		self setgoalnode(newnode);
	}
	self.health = 100;
}


pit2_attacker_setup()
{
	getent("alert_pit2_guys", "targetname") thread wait_and_notify(randomfloatrange(4,7), "trigger");
	self endon ("death");
	self setthreatbiasgroup("pit2_attackers");
	self.health = 300;
	mynode = getnode(self.target, "targetname");
	guy = undefined;
	while(1)
	{
		axis = getaiarray("axis");
		guy = axis[randomint(axis.size)];
		if (isdefined(guy.script_noteworthy) && guy.script_noteworthy == "pit2_defenders") 
		{
			break;
		}
		wait 0.05;
	}
	guy waittill ("death");
	self dodamage(self.health * 10, guy.origin);	// don't want them standing around looking dumb
}

kill_middle_mger()
{
	trig = getent ("pit2_allies", "target");
	trig waittill ("trigger");
	guy = grab_ai_by_script_noteworthy("middle_mger", "axis");
	guy setcandamage(true);
	guy dodamage(guy.health*10, (0,0,0) );
}

chain_on_after_pit1clear()
{
	waittill_aigroupcleared("pit1_lastbunker_guys");
	getent("auto878", "target") notify ("stop_drone_loop");
	level notify ("player_cleared_bunker1");
	flag_set("can_save");
	trig = getent("player_leaving_e1", "script_noteworthy");
	if (isdefined(trig))
	{
		trig delete(); // this trigger checked if you left before pit1 was clear
	}
	trig = getent("pit1_all_clear_chain", "targetname");
	trig trigger_on();
	trig thread bomber_sounds();
	getent("pit1_clear_chainup", "targetname") trigger_on();	
	nodes = getvehiclenodearray("bomber_nodes", "script_noteworthy");
	//flag_set("stop_gunquake");
	array_thread(nodes, ::bomber_nodes_setup);
	getent("e2_bridge_fakedrones", "target") trigger_on();
	//getent("bridge_drones", "script_noteworthy") trigger_on();	
}

achivement_checker()
{
	self.failedachievement = false;
	while(1)
	{
		self waittill("weapon_fired");
		
			weap = self getcurrentweapon();
			if (weap != "m2_flamethrower")
			{
				self.failedachievement = true;
				return;
			}
	}
}

trigs_off()
{
	getent("pit1_clear_chainup", "targetname") trigger_off();
	getent("pit1_all_clear_chain", "targetname") trigger_off();
	getent("e2_bridge_fakedrones", "target") trigger_off();
	//getent("bridge_drones", "script_noteworthy") trigger_off();	
	getent("event2_up_hill_dialog", "targetname") trigger_off();
	getent("player_in_regroup_spot", "targetname") trigger_off();
	
}

waittill_trig_and_say(guy, animname, anime, waittime)
{
	self waittill ("trigger");
	if (isdefined(waittime))
	{
		wait waittime;
	}
	guy.animname = animname;
	guy anim_single_solo(guy, anime);
}

lastpit_trap()
{
	if (level.difficulty == 1)
	{
		return;
	}
	
	getent("lastpit_trap_trig", "targetname") waittill ("trigger");
	nadespots = getstructarray("lastpit_trap_nadespots", "script_noteworthy");
	startspot = getstruct("lastpit_trap_nadestart", "targetname");
	for (i=0; i < nadespots.size; i++)
	{
		axis = getaiarray("axis");
		if (isdefined(axis[0]))
		{
			if (level.difficulty == 2 && cointoss() )
			{
				return;
			}
			axis[0] magicgrenade(startspot.origin, nadespots[i].origin, 5 );
			wait randomfloatrange( 0.3, 1.5);
			if (( level.difficulty == 2 && cointoss()) || i > 1)
			{
				return;
			}
		}
	}

}

theres_only_one_Flamer()
{
	wait randomfloatrange(0.5, 2.5);
	if (isdefined(level.flamerplayer))
	{
		return;
	}
	players = get_players();
	if (players.size > 1)
	{
		level.flamerplayer = players[randomint(players.size)];
		for (i=0; i < players.size; i++)
		{
			if (players[i] != level.flamerplayer)
			{
				players[i] takeweapon("m2_flamethrower");
				players[i] giveweapon("thompson");
				players[i] SwitchToWeapon( "thompson" );
			}
		}
	}
}

mortar_dudes_setup()
{
	self endon ("death");
	while(1)
	{
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			dist = distance(self.origin, players[i].origin);
			if (dist < 215 )
			{
				self notify ("stop_mortar");
				//self detachall();
				self animscripts\shared::placeWeaponOn( "type100_smg", "right" );
				if (isdefined(self.target))
				{
					//getnode(self.target, "targetname") notify ("mortar_done");
					//wait 0.05;
					getnode(self.target, "targetname") notify ("stop_mortar");

				}
				self stopanimscripted();
				self thread give_dude_weapon();

				self solo_set_pacifist(false);
				self thread charge_player_dudes();
				return;
			}
		}
		wait 0.5;
	}
}


give_dude_weapon()
{
	while(1)
	{
		self animscripts\shared::placeWeaponOn( "type100_smg", "right" );
		wait 0.3;
		org = self gettagorigin("tag_weapon");
		if (isdefined(org))
		{
			break;
		}
	}
}
solo_set_pacifist(pacifist_state)
{
	self endon ("death");
	if (isdefined(self) && isai(self))
	{
		self.pacifist = pacifist_state;
		if (pacifist_state == false)
		{
			self.maxsightdistsqrd = 90000000;
			self stopanimscripted();
			self.ignoreme = false;
			self.ignoreall = false;
			self.script_sightrange = 90000000;
		}
	}
}

smoke_hint_and_reset()
{
	if (flag("event1_smoke_popped") )
		return;
	level thread player_tries_toskip_mg();
	wait 2;
	smoke_hint();
	wait 1;
	if (isdefined(level.hintelem))
	{
		level.hintelem setText("");
	}
}

smoke_hint()
{
	if (flag("event1_smoke_popped") )
		return;
	level thread smoke_vo();
	level endon ("smoke_grenade_done");
	level endon( "smoke_popped" );
	level endon ("stop_pop_smoke");
	level.hintelem = NewHudElem();
	level.hintelem init_results_hudelem(320, 160, "center", "bottom", 1.5, 1.0);
	while( 1 )
	{
		level.hintelem setText(&"PEL1A_THROWSMOKE");
		wait 8;
		level.hintelem setText("");	
		wait 15;
	}
}

smoke_vo()
{
	if (flag("event1_smoke_popped") )
		return;
	level endon ("smoke_grenade_done");
	level endon( "smoke_popped" );
	level endon ("stop_pop_smoke");
	modifier = 0;
	wait 1.5;
	while(1)
	{
		level.polonsky anim_single_solo( level.polonsky, "first_mg4" );	// "Throw smoke!"\
		if (modifier < 20)
		{
			modifier = modifier + 4;
		}
		
		wait modifier + randomintrange(5, 15);
		
		if (cointoss() )
		{
			level.roebuck anim_single_solo( level.roebuck, "first_mg3" );		// "Throw some smoke for cover!... Or it will rip us to shreds!"\
		}
		else
		{
			level.polonsky anim_single_solo( level.polonsky, "first_mg4" );	// "Throw smoke!"\
		}
		wait modifier + randomintrange(5, 15);
	}
}

init_results_hudelem(x, y, alignX, alignY, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignX = alignX;
	self.alignY = alignY;
	self.fontScale = fontScale;
	self.alpha = alpha;
	self.sort = 20;
	self.font = "objective";
}

treesnipers_setup()
{
	//self disableaimassist();
	self endon ("death");
	self.pacifist = true;
	self.ignoreall = true;
	self.ignoreme = true;
	level waittill ("treesnipers_awake");	// comes from script_notify on trigger
	//self enableaimassist();
	self.pacifist = false;
	self.ignoreall = false;
	self.ignoreme = false;	
	
	tree = getent(self.target, "targetname");
	self thread wait_and_kill(45*level.difficulty);
	level.polonsky thread wait_and_say(60, "polonsky", "treesnipers", "death", self, 1500);
	if (!isdefined(tree))
	{
		return;
	}
	while( 1 )
	{
		if (cointoss() )
		{
			playfx( level._effect["sniper_leaf_canned"], tree.origin );
		}
		
		tree waittill( "broken", broken_notify, attacker );
		
		if( broken_notify == "hideout_fronds_dmg0" )
		{
			//tree playsound( "flame_ignite_tree" );
			playsoundatposition("flame_ignite_tree", tree.origin);
		
			//TUEY - When we get entity playsound fixed, this will work...but it doesn't for now , so I'm commenting it out.		
			//level thread maps\pel2_amb::play_flame_tree_loop(tree);
			self thread animscripts\death::flame_death_fx();
			self thread tree_guy_flame_sound();
			self setcandamage( true );
			self notify( "fake tree death" );
			players = get_players();
			for (i=0; i < players.size; i++)
			{
				weap = players[i] getcurrentweapon();
				if (weap == "m2_flamethrower")
				{	//dk
					//level.player maps\_utility::giveachievement_wrapper( "PEL2_ACHIEVEMENT_TREE");
				}
			}

			wait 5;
			
			if( !isdefined(attacker) )
			{
				attacker = get_closest_player( self.origin );
			}
			self dodamage(self.health * 10, (0,0,0), attacker );
			
			break;
		}
	}
}


tree_guy_flame_sound()
{
	// TEMP!
	temp_orig = spawn( "script_origin", self.origin );
	temp_orig playsound( "body_burn_vo" );
	
	temp_orig waittill( "body_burn_vo"  );
	
	temp_orig delete();	
}

player_tries_toskip_mg()
{
	if (flag("event1_smoke_popped") )
		return;
		
	level endon( "smoke_popped" );
	level endon ("stop_pop_smoke");
	gun = getent("middle_mg", "targetname");
	trig = getent("mg_smoke_checker", "targetname");
	while(!flag("event1_smoke_popped") )
	{
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			if (players[i] istouching(trig) )
			{
				org = gun gettagorigin ("tag_flash");
				magicbullet("type99_lmg", org, players[i] geteye() );
			}
		}
		wait 0.05;
	}
	wait 6;
}

distance_fight_smoke_hint()
{
	getent("cave3_banzai_guys", "target") waittill ("trigger");
	trig = getent("ok_dont_throw_smoke", "targetname");
	trig endon ("trigger");
	modifier = 0;
	while(1)
	{
		wait (randomintrange(40, 80) + modifier) ;
		level.polonsky anim_single_solo( level.polonsky, "first_mg4" );	// "Throw smoke!"\
		modifier = modifier + 7*level.difficulty;
	}
}

road_runners()
{
	self.animname = "generic";
	keys = getarraykeys(level.scr_anim["generic"]);
	self set_run_anim(keys[randomint(keys.size)]);
}

/*------------------------------------
spawn in guys thru script. Stole from ChrisP to get around too many ents in frame error
------------------------------------*/
simple_spawn( spawners, waittime )
{
	if (isdefined(waittime))
	{
		wait waittime;
	}
	

	ai_array = [];

	for( i = 0; i < spawners.size; i++ )
	{
		if (!isdefined(spawners[i]))
		{
			continue;
		}
		if( i % 2)
		{
			//wait for a new network frame to be sent out before spawning in 
			//another guy
			wait_network_frame();
		}
		
		// check if we want to forcespawn him
		if( IsDefined( spawners[i].script_forcespawn ) )
		{
			ai = spawners[i] StalingradSpawn(); 
		}
		else
		{
			ai = spawners[i] DoSpawn(); 
		}		
		
		spawn_failed( ai );
				
		ai_array = add_to_array( ai_array, ai );
	}
	
	return ai_array;

}

simple_floodspawn(spawners)
{
	
	for(i=0;i<spawners.size;i++)
	{
		if(i % 2)
		{
			wait_network_frame();
		}
		spawners[i] thread maps\_spawner::flood_spawner_think();
	}	
}

do_netfriendly_flood_spawn()
{
	self waittill ("trigger");
	spawners = getentarray(self.target, "targetname");
	level thread simple_floodspawn(spawners);
}

do_netfriendly_trigger_spawn()
{
	self waittill ("trigger");
	spawners = getentarray(self.target, "targetname");
	level thread simple_spawn(spawners);
}

bomber_nodes_setup()
{
	self waittill ("trigger");
	struct = getstruct(self.targetname+"_drop", "script_noteworthy");
	playfx(level._effect["bomb_explosion"], struct.origin);
	earthquake(0.5, 1, struct.origin, 7000);
	playsoundatposition ("mortar_dirt", struct.origin+(-4000,0,0) );
}

killspawner_onspawn(num)
{
	wait 4;
	maps\_spawner::kill_spawnernum(num);
}

cave2_clear()
{
	waittill_aigroupcleared("cave2_guys");
	level thread maps\_utility::autosave_by_name( "cave2_clear" );
	trig = 	getent("event2_up_hill_dialog", "targetname");
	trig trigger_on();
	trig waittill ("trigger");
	trig = getent("pit2_chain", "script_noteworthy");
	if (isdefined(trig))
	{
		trig notify ("trigger");
	}
}

intro_helpout_dudes_setup()
{
	self endon ("death");
	self.ignoreme = true;
	wait 10;
	self.ignoreme = false;
	self thread wait_and_kill(randomintrange(10,20));
}

my_mg_stop()
{
	spot = getent("first_mg_target", "targetname");
	self setentitytarget(spot);
}

player_setup()
{
	self setstance("crouch");
}

bomber_sounds()
{
	self waittill ("trigger");
	wait 0.5;
	plane = getent("soundbomber", "targetname");
	//plane moveto (plane.origin+(0,2500,0), 10);
	plane playsound("pel1a_napalm_flight");
}

player_leaves_e1_early()
{
	trig = getent("player_leaving_e1", "script_noteworthy");
	level endon ("player_cleared_bunker1");
	trig waittill ("trigger");
	trig2 = getent("e1_approaching_firstmortar_guys_trig", "targetname");
	if (isdefined(trig2))
	{
		trig2 notify ("trigger");
	}
	trig2 = getent("e1_approaching_firstmortar_banzai_guys", "target");
	if (isdefined(trig2))
	{
		trig2 notify ("trigger");
	}
	wait 1;
	axis = getaiarray("axis");
	array_thread(axis, ::charge_player_dudes);
	flag_clear("can_save");
	wait 20;
	flag_set("can_save");
}

weary_walkers_setup()
{
	self.animname = "generic";
	if (cointoss() )
	{
		self set_run_anim("weary1");
	}
	else
	{
		self set_run_anim("weary2");
	}
}

patrollers_setup()
{
	self.animname = "generic";
	self set_run_anim("patroller");
}

traffic_dude()
{
	self.animname = "generic";
	self set_run_anim("weary1");
	node = getnode("traffic_dude_node", "targetname");
	node anim_reach_solo(self, "traffic_dude_reach");
	node anim_loop_solo(self, "traffic_dude", undefined, "death");
}

wait_and_say(time, animname, myline, ender, endee, distcheck)
{
	endee endon (ender);
	wait time;
	self.animname = animname;
	dist = distance(get_players()[0].origin, endee.origin);
	if (dist < distcheck)
	{
		self anim_single_solo(self, myline);
	}
}

dont_drop_flamer()
{
	self.dropweapon = false;
}

before_last_tunnel_guys_clear()
{
	waittill_aigroupcleared("before_last_tunnel_guys");
	wait 1;
	trig = getent("event4", "targetname");
	trig notify ("trigger");
}

no_nades_oneasy()
{
	if (level.difficulty > 1)
	{
		return;
	}
	self.script_grenades = 0;
	self.grenadeammo = 0;
}