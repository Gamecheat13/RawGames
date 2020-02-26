#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\arcadia_code;
#include maps\arcadia_stryker;

/*
#######################
#######################


Bug 102896 Ending scene needs russian dialogue to sell it.
-In final scene, russian guy's gun wobbles because it needs to be a detached ent until he grabs it, then it can animate. Animation system doesn't have the precision to have a linked entity be stable while the main entity animates.
-Spawn friendlies in groups of 2 or 3 instead of constant stream
-prefabs/_common/scripted/ammo_crates/airdrop_pallet_open.map

HITLIST

( for others? )
- Bug 102139 Subtitles come up under timestamp at beginning.
- Bug 102251 The honey badger firing sound will be a challenge.  Need it to not be annoying.  GANUS/CHAD
- Bug 102253 Level getting much harder... but silent movie.  Big battle, nobody talks.  (sounds like there is no headset, can hear guys in the distance maybe talking) CHAD/SLAYBACK
- Bug 102254 I see RPGs fire and HB talks about anti-missile system.  Is the trophy in there?  Needs distinctive f/x and audio.  CHAD/ROBOT/GANUS
- Bug 102259 Artillery needs dialog confirmation, timing, incoming f/x, incoming audio.  GANUS/CHAD/ROBOT
- Bug 102653 Someone needs to acknowledge plane going down.  (ie, that's why you don't fly c130s during the day/no choice exchange).  CHAD/STEVE

( todo )
- Watched HB run over friendly. CHAD
- Need the guys on rooftops waving their arms for rescue in 1 spot, and chopper picking up guys in another.  Can spot.  PAUL/CHAD
- When Honey Badger is going to run you over friendlies should yell warnings/watch yourself/etc.  CHAD/STEVE/SLAYBACK


#######################
#######################
*/

//sound alias - veh_helicopter_loop

//checkpoint_chopper_sounds
//golfcourse_chopper_sounds
//street2_chopper_sounds

main()
{
	destructible_volumes = getentarray( "volume_second_half", "targetname" );
	mask_destructibles_in_volumes( destructible_volumes );
	mask_interactives_in_volumes( destructible_volumes );
	
	default_start( ::startStreet );
	add_start( "street", ::startStreet );
	add_start( "checkpoint", ::startCheckpoint );
	add_start( "golf", ::startGolf );
	add_start( "crash", ::startCrash );
	
	setsaveddvar( "r_lightGridEnableTweaks", 1 );
	setsaveddvar( "r_lightGridIntensity", 1.2 );
	setsaveddvar( "r_lightGridContrast", 0 );
	
	precacheString( &"ARCADIA_OBJECTIVE_AA_GUNS" );
	precacheString( &"ARCADIA_OBJECTIVE_BROOKMERE" );
	precacheString( &"ARCADIA_OBJECTIVE_INTEL" );
	precacheString( &"ARCADIA_LASER_HINT" );
	precacheString( &"ARCADIA_LASER_HINT_GOLFCOURSE" );
	precacheString( &"ARCADIA_PICK_UP_BRIEFCASE_HINT" );
	
	precacheShader( "dpad_laser_designator" );
	
	precacheModel( "vehicle_zpu4_burn" );
	precacheModel( "cs_vodkabottle01" );
	precacheModel( "electronics_camera_pointandshoot_animated" );
	
	setDvarIfUninitialized( "arcadia_debug_stryker", "0" );
	
	precacheItem( "rpg_straight" );
	
	precache_masked_destructibles();
	
	add_earthquake( "b2bomb", 0.5, 0.5, 2000 );
	
	//maps\createfx\arcadia_audio::main();
	maps\arcadia_fx::main();
	maps\arcadia_precache::main();
	maps\createart\arcadia_art::main();
	maps\_load::main();
	maps\arcadia_anim::main();
	maps\_drone_ai::init();
	common_scripts\_sentry::main();
	
	//VisionSetNaked( "arcadia" );
	
	maps\_compass::setupMiniMap("compass_map_arcadia");
	
	thread maps\arcadia_amb::main();
	
	flag_init( "used_laser" );
	flag_init( "used_laser_golf" );
	flag_init( "laser_hint_print" );
	flag_init( "stealth_bombed_0" );
	flag_init( "stealth_bombed_1" );
	flag_init( "golfcourse_vehicles_dead" );
	flag_init( "picked_up_briefcase" );
	flag_init( "examine_tats" );
	
	//--------------------------------
	// Friendlies and Friendly Respawn
	//--------------------------------
	
	level.foley = getent( "foley", "script_noteworthy" );
	assert( isAlive( level.foley ) );
	level.foley.animname = "foley";
	level.foley magic_bullet_shield();
	
	level.dunn = getent( "dunn", "script_noteworthy" );
	assert( isAlive( level.dunn ) );
	level.dunn.animname = "dunn";
	level.dunn magic_bullet_shield();
	
	friends = getaiarray( "allies" );
	array_thread( friends, ::ai_avoid_stryker );
	friends = array_remove( friends, level.foley );
	friends = array_remove( friends, level.dunn );
	
	level.friendly_startup_thread = ::ai_avoid_stryker;
	flag_set( "respawn_friendlies" );
	set_empty_promotion_order( "r" );
	set_empty_promotion_order( "b" );
	array_thread( friends, ::replace_on_death );
	
	//--------------------------------
	// spawners with script_parameters get processed on spawn
	//--------------------------------
	all_axis_spawners = getspawnerteamarray( "axis" );
	script_parameter_spawners = [];
	foreach( spawner in all_axis_spawners )
	{
		if ( !isdefined( spawner.script_parameters ) )
			continue;
		script_parameter_spawners[ script_parameter_spawners.size ] = spawner;
	}
	array_spawn_function( script_parameter_spawners, ::process_ai_script_parameters );
	
	//--------------------------------
	// Spawn Stryker vehicle
	//--------------------------------
	level.stryker = spawn_vehicle_from_targetname_and_drive( "stryker" );
	//level.stryker.veh_pathtype = "follow";
	level.stryker.vehicle_stays_alive = true;
	level.stryker vehPhys_DisableCrashing();
	level.stryker.damageIsFromPlayer = true;
	setup_stryker_modes();
	level.stryker.lastTarget = level.stryker;
	level.stryker thread stryker_setmode_ai();
	level.stryker thread stryker_laser_reminder_dialog();
	level.stryker thread stryker_death_wait();
	level.stryker thread stryker_dialog();
	level.stryker thread stryker_laser_reminder_dialog();
	level.stryker thread stryker_damage_monitor();
	level.stryker setVehicleLookAtText( "Honey Badger", &"" );
	level.stryker.missileAttractor = spawn( "script_origin", level.stryker.origin + ( 0, 0, 70 ) );
	level.stryker.missileAttractor LinkTo( level.stryker );
	missile_CreateAttractorEnt( level.stryker.missileAttractor, 10000, 3000 );
	
	level.stealth_bombed_target[ 0 ] = false;
	level.stealth_bombed_target[ 1 ] = false;
	
	//--------------------------------
	// Array / Spawn threads
	//--------------------------------
	array_spawn_function_noteworthy( "drop_plane", ::drop_plane );
	run_thread_on_targetname( "sentry_activate", ::sentry_activate_trigger );
	run_thread_on_targetname( "vehicle_path_disconnector", ::vehicle_path_disconnector );
	run_thread_on_targetname( "delete_ai_trigger", ::delete_ai_trigger );
	run_thread_on_noteworthy( "plane_sound", maps\_mig29::plane_sound_node );
	run_thread_on_noteworthy( "moveup_trig", ::move_up_dialog );
	run_thread_on_noteworthy( "evac_chopper_1", ::add_spawn_function, ::evac_chopper_1 );
	run_thread_on_noteworthy( "ignore_until_unload", ::ignore_until_unload );
	
	add_hint_string( "use_laser", &"ARCADIA_LASER_HINT", ::should_stop_laser_hint );
	add_hint_string( "use_laser_golf", &"ARCADIA_LASER_HINT_GOLFCOURSE", ::should_stop_laser_golf_hint );
	
	//--------------------------------
	// Level threads
	//--------------------------------
	thread civilian_car();
	thread checkpoint_cleared_dialog();
	thread laser_targeting_device( level.player );
	thread fake_checkpoint_choppers();
	thread fake_creek_choppers();
	thread golf_course_fake_choppers();
	thread second_street_friendlies();
	thread golf_course_battle();
	thread crashing_c130();
	thread harriers();
	thread fridge_guy();
	thread foley_dunn_get_to_ending();
	thread level_ending_sequence();
	thread pool();
	thread player_picks_up_briefcase();
	thread activate_second_half_destructibles();
	thread all_enemies_low_health();
	
	//--------------------------------
	// Make friendlies less accurate so the AI will fight longer without player interaction
	//--------------------------------
	wait 0.05;
	friendlies = getaiarray( "allies" );
	foreach( friend in friendlies )
		friend.baseaccuracy = 0.4;
	
	after0 = get_golf_geo( "golf_after", 0 );
	assert( after0.size > 0 );
	array_call( after0, ::hide );
	
	after1 = get_golf_geo( "golf_after", 1 );
	assert( after1.size > 0 );
	array_call( after1, ::hide );
}

startStreet()
{
	movePlayerToStartPoint( "playerstart_street" );
	thread objective_aa_guns();
	
	thread dialog_enemies_yellow_house();
	thread dialog_enemies_grey_house();
	thread dialog_enemies_pink_house();
	thread dialog_enemies_apartments();
	thread get_off_streets_dialog();
	
	array_thread( getentarray( "opening_rpg_location", "targetname" ), ::opening_rpgs );
	
	level.stryker thread stryker_rpg_dialog();
}

startCheckpoint()
{
	flag_set( "used_laser" );
	
	activate_trigger( "checkpoint_vision_trigger", "script_noteworthy" );
	
	movePlayerToStartPoint( "playerstart_checkpoint" );
	thread objective_aa_guns();
}

startGolf()
{
	flag_set( "golf_course_vehicles" );
	flag_set( "golf_course_mansion" );
	flag_set( "used_laser" );
	
	activate_trigger( "golfcourse_vision_trigger", "script_noteworthy" );
	
	movePlayerToStartPoint( "playerstart_golf" );
	thread objective_aa_guns();
	thread objective_laze_golfcourse();
	
	flag_set( "first_bridge" );
	
	wait 0.05;
	
	allies = getaiarray( "allies" );
	locations = getentarray( "start_golf_friendly_teleport", "targetname" );
	foreach( i, guy in allies )
		guy forceTeleport( locations[ i ].origin, locations[ i ].angles );
	
	trig = getent( "start_golf_friendly_trigger", "script_noteworthy" );
	trig notify( "trigger", level.player );
	
	exploder( "tanker_explosion_tall" );
}

startCrash()
{
	activate_trigger( "crash_vision_trigger", "script_noteworthy" );
	movePlayerToStartPoint( "playerstart_crash" );
	
	flag_set( "fridge_guy" );
	flag_set( "ending_prep" );
	
	wait 0.05;
	
	allies = getaiarray( "allies" );
	locations = getentarray( "start_crash_friendly_teleport", "targetname" );
	foreach( i, guy in allies )
	{
		guy forceTeleport( locations[ i ].origin, locations[ i ].angles );
		guy.goalradius = 32;
		guy setGoalPos( locations[ i ].origin );
	}
	
	trig = getent( "start_crash_friendly_respawn_trigger", "script_noteworthy" );
	trig notify( "trigger", level.player );
	
	thread objective_brookmere_road();
	
	exploder( "tanker_explosion_tall" );
}

objective_aa_guns()
{
	objective_add( 0, "current", &"ARCADIA_OBJECTIVE_AA_GUNS" );
	objective_onentity( 0, level.foley );
}

objective_laze_golfcourse()
{
	level notify( "objective_laze_golfcourse" );
	wait 0.05;
	thread objective_brookmere_road();
	
	objective_position( 0, ( 0, 0, 0 ) );
	objective_additionalposition( 0, 0, getent( "obj_location_stealth_0", "targetname" ).origin );
	objective_additionalposition( 0, 1, getent( "obj_location_stealth_1", "targetname" ).origin );
	
	thread laser_golf_hint_print();
	
	flag_wait( "stealth_bombed_0" );
	flag_wait( "stealth_bombed_1" );
	
	wait 3.0;
	
	objective_state( 0, "done" );
	
	wait 10;
	
	flag_set( "golfcourse_vehicles_dead" );
}

objective_brookmere_road()
{
	flag_wait_any( "second_bridge", "golfcourse_vehicles_dead" );
	
	brookmere_road_dialog();
	
	location = getent( "objective_brookmere_location", "targetname" );
	objective_add( 1, "current", &"ARCADIA_OBJECTIVE_BROOKMERE", location.origin );
	
	flag_wait( "brookmere_house" );
	
	objective_state( 1, "done" );
	
	thread objective_intel();
}

objective_intel()
{
	location = getent( "objective_intel_location", "targetname" );
	objective_add( 2, "current", &"ARCADIA_OBJECTIVE_INTEL", location.origin );
}

brookmere_road_dialog()
{
	// Overlord, Hunter Two-One-Actual. Triple-A has been neutralized. We're heading to 4677 Brookmere Road, over.
	thread radio_dialogue( "arcadia_fly_headingto4677" );
	
	// Interrogative - what exactly are we looking for, over?
	thread radio_dialogue( "arcadia_fly_lookingfor" );
	
	// You are to search the house for a 'panic room' and retrieve an HVO.
	thread radio_dialogue( "arcadia_hqr_panicroom" );
	
	// One silver briefcase, serial number - #27515-3.
	thread radio_dialogue( "arcadia_hqr_silverbriefcase" );
	
	// Everything else is need-to-know. Just bring it back for G-2 to analyze. Overlord out.
	thread radio_dialogue( "arcadia_hqr_needtoknow" );
}

second_street_friendlies()
{
	// once coming up to the second street before the bridge we change all the friendlies
	// to GREEN color group so they all stick together.
	// Also, 2 friendlies get set to 1 health and are told to no longer respawn on death.
	// This leaves us with 4 friendlies instead of 6 for the new area
	
	flag_wait( "first_bridge" );
	
	friendlies = getaiarray( "allies" );
	foreach( count, friend in friendlies )
	{
		if ( count == 0 || count == 1 )
		{
			friend thread disable_replace_on_death();
			friend.health = 1;
		}
		friend thread set_force_color( "g" );
	}
	
}

dialog_enemies_yellow_house()
{
	flag_wait( "enemies_yellow_house" );
	
	// We got hostiles in the yellow house!
	level.foley thread dialogue_queue( "arcadia_fly_yellowhouse" );
}

dialog_enemies_grey_house()
{
	flag_wait( "enemies_grey_house" );
	
	// Enemies in the grey house!!!
	level.dunn thread dialogue_queue( "arcadia_cpd_greyhouse" );
	
	wait 1;
	
	// Squad, we got hostiles that grey house! Take 'em out!!
	level.foley thread dialogue_queue( "arcadia_fly_greyhouse" );
}

dialog_enemies_pink_house()
{
	flag_wait( "enemies_pink_house" );
	
	// Squad, put suppressing fire on that house!!
	level.foley thread dialogue_queue( "arcadia_fly_suppressingfire" );
	
	wait 8;
	
	// Squad, concentrate your fire on that house!!
	level.foley thread dialogue_queue( "arcadia_fly_suppressingfire" );
}

dialog_enemies_apartments()
{
	flag_wait( "enemies_apartments" );
	
	// Enemy foot-mobiles by the apartments!
	level.dunn thread dialogue_queue( "arcadia_cpd_apartments" );
	
	wait 1;
	
	// Roger that, enemy foot-mobiles by the apartments, take 'em ouuut!!
	level.foley thread dialogue_queue( "arcadia_fly_apartments" );
}

get_off_streets_dialog()
{
	battlechatter_off( "allies" );
	
	wait 5;
	
	// Hunter Two-One, this is Hunter Two-One Actual. Our evac choppers are taking heavy losses from ground fire!
	level.foley thread dialogue_queue( "arcadia_fly_heavylosses" );
	
	wait 1;
	
	// We gotta destroy those triple-A positions so they can get the rest of the civvies outta here! Let's go!
	level.foley thread dialogue_queue( "arcadia_fly_destroytriplea" );
	
	battlechatter_on( "allies" );
	
	wait 10;
	
	// Get off the streets!!
	level.foley thread dialogue_queue( "arcadia_fly_getoffstreets" );
	
	wait 10;
	
	// Get off the streets, use the houses for cover!!
	level.foley thread dialogue_queue( "arcadia_fly_offstreets" );
	
	wait 15;
	
	// Get outta the street!!
	level.foley thread dialogue_queue( "arcadia_fly_outtastreets" );
	
	wait 15;
	
	// Flank 'em through the houses!! Go go go!!
	level.foley thread dialogue_queue( "arcadia_fly_flankthruhouses" );
	
	wait 20;
	
	// Squad, move up through these houses, let's go, let's go!!
	level.foley thread dialogue_queue( "arcadia_fly_movethruhouses" );
}

move_up_dialog()
{
	// wait for the trigger to get hit that tells the friendlies to move up
	self waittill( "trigger" );
	
	guy = undefined;
	anime = undefined;
	
	rand = randomint( 4 );
	switch( rand )
	{
		case 0:
			// Everyone move up!
			guy = level.foley;
			anime = "arcadia_fly_everyoneup";
			break;
		case 1:
			// Move up!
			guy = level.foley;
			anime = "arcadia_fly_moveup";
			break;
		case 2:
			// Move up!!!
			guy = level.dunn;
			anime = "arcadia_cpd_moveup";
			break;
		case 3:
			// Let's go, let's go!!
			guy = level.dunn;
			anime = "arcadia_cpd_letsgo";
			break;
	}
	
	assert( isalive( guy ) );
	assert( isdefined( anime ) );
	
	guy thread dialogue_queue( anime );
}

stryker_rpg_dialog()
{
	self endon( "death" );
	
	flag_wait( "stryker_rpg_danger_dialog_1" );
	wait 8;
	
	// Squad! Protect the Stryker! Watch for foot-mobiles with RPGs!
	level.foley thread dialogue_queue( "arcadia_fly_protectstryker" );
	
	
	flag_wait( "stryker_rpg_danger_dialog_2" );
	wait 8;
	
	// Squad! They're targeting the Stryker! Watch for RPGs!
	level.foley thread dialogue_queue( "arcadia_fly_watchforrpgs" );
	
	flag_wait( "stryker_rpg_danger_dialog_3" );
	wait 8;
	
	// Hunter Two-One Actual, this is Badger One! Our anti-missile system cannot handle the volume of RPG fire, we need your team to thin 'em out, how copy, over?
	thread radio_dialogue( "arcadia_str_rpgfire" );
	
	// Solid copy Badger One, we're on it! Out!
	level.foley thread dialogue_queue( "arcadia_fly_wereonit" );
}

checkpoint_cleared_dialog()
{
	flag_wait( "past_checkpoint" );
	
	// Hunter Two-One-Actual, Overlord. Gimme a sitrep over.
	radio_dialogue( "arcadia_hqr_sitrep" );
	
	// We're just past the enemy blockade at Checkpoint Lima. Now proceeding into Arcadia, over.
	level.foley dialogue_queue( "arcadia_fly_intoarcadia" );
	
	// Roger that. I have new orders for you. This comes down from the top, over.
	radio_dialogue( "arcadia_hqr_neworders" );
	
	// Solid copy Overlord, send it.
	level.foley dialogue_queue( "arcadia_fly_solidcopy" );
	
	// Your team is to divert to 4677 Brookmere Road after you have eliminated the triple-A.
	radio_dialogue( "arcadia_hqr_divertto4677" );
	
	// Solid copy Overlord. Divert to 4677 Brookmere Road once the guns are destroyed. Got it.
	level.foley dialogue_queue( "arcadia_fly_divertto4677" );
	
	// Check back with me when you've completed your main objective. Overlord out.
	radio_dialogue( "arcadia_hqr_checkback" );
}

fridge_guy()
{
	flag_wait( "fridge_guy" );
	
	guy = spawn_targetname( "fridge_guy_spawner" );
	guy.animname = "fridge_guy";
	guy set_ignoreme( true );
	guy disable_surprise();
	
	fridge = getent( "fridge", "targetname" );
	assert( isdefined( fridge ) );
	fridge.animname = "fridge";
	fridge setAnimTree();
	
	bottle = spawn( "script_model", guy.origin );
	bottle setModel( "cs_vodkabottle01" );
	bottle linkTo( guy, "tag_inhand", (0,0,0), (0,0,0) );
	guy thread fridge_guy_remove_bottle_drop( bottle );
	guy thread fridge_guy_remove_bottle_death( bottle );
	
	guy_and_fridge[ 0 ] = guy;
	guy_and_fridge[ 1 ] = fridge;
	
	fridge thread anim_loop( guy_and_fridge, "fridge_idle", "stop_idle" );
	guy.allowdeath = true;
	
	fridge thread fridge_guy_spots_player( guy_and_fridge );
}

fridge_guy_remove_bottle_drop( bottle )
{
	self endon( "death" );
	self waittillmatch( "single anim", "break_bottle" );
	bottle notify( "delete" );
	bottle delete();
}

fridge_guy_remove_bottle_death( bottle )
{
	bottle endon( "delete" );
	self waittill( "death" );
	bottle delete();
}

fridge_guy_spots_player( guy_and_fridge )
{
	guy_and_fridge[ 0 ] endon( "death" );
	
	trigger_wait( "fridge_guy_react", "targetname" );
	
	self notify( "stop_idle" );
	self thread anim_single( guy_and_fridge, "fridge_react" );
	
	guy_and_fridge[ 0 ] set_ignoreme( false );
}

foley_dunn_get_to_ending()
{
	flag_wait( "heros_become_red" );
	
	// move foley and dunn to red
	level.foley thread set_force_color( "r" );
	level.foley.animplaybackrate = 1.2;
	level.foley allowedStances( "stand" );
	
	level.dunn thread set_force_color( "r" );
	level.dunn.animplaybackrate = 1.2;
	level.dunn allowedStances( "stand" );
}

level_ending_sequence()
{
	// Wait for player to be approaching the end
	flag_wait( "ending_prep" );
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	node = getent( "ending_node", "targetname" );
	assert( isdefined( node ) );
	
	// Spawn panic room enemies
	ending_spawners = getentarray( "ending_spawner", "targetname" );
	ending_enemies = [];
	foreach( i, spawner in ending_spawners )
	{
		ending_enemies[ i ] = spawner spawn_ai( true );
		ending_enemies[ i ].animname = "ending_enemy_" + i;
		ending_enemies[ i ] disable_surprise();
		ending_enemies[ i ] magic_bullet_shield();
		ending_enemies[ i ] linkto( node );
	}
	assert( ending_enemies.size == 2 );
	
	ending_enemies[ 0 ] allowedStances( "crouch" );
	ending_enemies[ 1 ] allowedStances( "stand" );
	
	// Enemies get into position
	node thread anim_first_frame( ending_enemies, "ending" );
	
	// Wait for player to enter panic room
	flag_wait( "start_ending" );
	
	ending_enemies[ 0 ] setLookAtEntity( level.player );
	ending_enemies[ 0 ] thread handle_panic_room_death( node, false );
	ending_enemies[ 1 ] thread handle_panic_room_death( node, true );
	node thread anim_single_solo( ending_enemies[ 0 ], "ending" );
	node thread anim_single_solo( ending_enemies[ 1 ], "ending" );
	
	foley_and_dunn[ 0 ] = level.foley;
	foley_and_dunn[ 1 ] = level.dunn;
	array_call( foley_and_dunn, ::pushPlayer, true );
	array_thread( foley_and_dunn, ::dontmelee, true );
	node thread anim_reach( foley_and_dunn, "ending" );
	
	waittill_dead( ending_enemies );
	
	thread level_ending_sequence_dialog();
	node anim_reach( foley_and_dunn, "ending" );
	
	// wait for player to pick up briefcase before doing final anims
	if ( !flag( "picked_up_briefcase" ) )
	{
		// Ramirez, grab the briefcase.
		level.foley thread dialogue_queue( "arcadia_fly_grabbriefcase" );
		flag_wait( "picked_up_briefcase" );
	}
	
	objective_state( 2, "done" );
	flag_set( "examine_tats" );
	node thread anim_single( foley_and_dunn, "ending" );
	wait 22;
	nextmission();
}

handle_panic_room_death( node, has_death_c )
{
	assert( isdefined( has_death_c ) );
	
	self thread handle_panic_room_guy_notetracks( node, has_death_c );
	for(;;)
	{
		self waittill( "damage", damage, attacker );
		if ( !isdefined( attacker ) )
			continue;
		if ( attacker != level.player )
			continue;
		break;
	}
	
	self notify( "stop_monitoring_final_notetracks" );
	
	didCustomDeath = false;
	if ( !self.notetrackDeathA_start )
	{
		// no windows have come yet
		
		assert( !self.notetrackDeathA_end );
		assert( !self.notetrackDeathB );
		if ( has_death_c )
			assert( !self.notetrackDeathC );
		
		self.allowdeath = true;
	}
	else if ( self.notetrackDeathA_start && !self.notetrackDeathA_end )
	{
		// death A window
		
		assert( !self.notetrackDeathB );
		if ( has_death_c )
			assert( !self.notetrackDeathC );
		
		self anim_stopanimscripted();
		node anim_single_solo( self, "deathA" );
		didCustomDeath = true;
	}
	else if ( self.notetrackDeathA_end && !self.notetrackDeathB )
	{
		// death B window - but wait for B notetrack before doing anim
		
		if ( has_death_c )
			assert( !self.notetrackDeathC );
		
		self waittillmatch( "single anim", "deathb" );
		self anim_stopanimscripted();
		node anim_single_solo( self, "deathB" );
		didCustomDeath = true;
	}
	else if ( has_death_c && self.notetrackDeathB && !self.notetrackDeathC )
	{
		// death C window - but wait for C notetrack before doing anim
		
		self waittillmatch( "single anim", "deathc" );
		self anim_stopanimscripted();
		node anim_single_solo( self, "deathC" );
		didCustomDeath = true;
	}
	else if ( has_death_c && self.notetrackDeathC )
	{
		// Guy with death C always does death C even after anim ends
		self anim_stopanimscripted();
		node anim_single_solo( self, "deathC" );
		didCustomDeath = true;
	}
	else
	{
		// all windows for custom deaths have passed
		
		assert( self.notetrackDeathA_start );
		assert( self.notetrackDeathA_end );
		assert( self.notetrackDeathB );
		if ( has_death_c )
			assert( self.notetrackDeathC );
		
		self.allowdeath = true;
	}
	
	self thread kill_panic_room_enemy( didCustomDeath );
}

handle_panic_room_guy_notetracks( node, has_death_c )
{
	assert( isdefined( has_death_c ) );
	
	self endon( "death" );
	self endon( "stop_monitoring_final_notetracks" );
	
	self.notetrackDeathA_start = false;
	self.notetrackDeathA_end = false;
	self.notetrackDeathB = false;
	if ( has_death_c )
		self.notetrackDeathC = false;
	
	self waittillmatch( "single anim", "deatha_start" );
	self.notetrackDeathA_start = true;
	
	self waittillmatch( "single anim", "deatha_end" );
	self.notetrackDeathA_end = true;
	
	self waittillmatch( "single anim", "deathb" );
	self.notetrackDeathB = true;
	
	if ( !has_death_c )
		return;
	
	self waittillmatch( "single anim", "deathc" );
	self.notetrackDeathC = true;
}

kill_panic_room_enemy( didCustomDeath )
{
	assert( isdefined( didCustomDeath ) );
	
	if ( !isalive( self ) )
		return;
	self endon( "death" );
	
	self stop_magic_bullet_shield();
	self.allowdeath = true;
	if ( didCustomDeath )
	{
		self.a.nodeath = true;
		self.noragdoll = true;
	}
	else
		self unlink();
	
	self setContents( 0 );
	self kill();
}

dontmelee( bool )
{
	self.dontmelee = bool;
}

dontevershoot( bool )
{
	self.dontevershoot = bool;
}

level_ending_sequence_dialog()
{
	// Clear up!
	level.dunn dialogue_queue( "arcadia_cpd_clearup" );
	
	// Clear down!
	excluders[ 0 ] = level.foley;
	excluders[ 1 ] = level.dunn;
	ranger = get_closest_ai( level.player.origin, "allies", excluders );
	ranger anim_generic_queue( ranger, "arcadia_ar1_cleardown" );
	
	flag_wait( "examine_tats" );
	
	wait 2;
	
	// Sarge, check out these tats. Not your average paratrooper, huah?
	level.dunn dialogue_queue( "arcadia_cpd_checkouttats" );
	
	// Huah. Get a couple photos for G-2 and check the bodies for intel.
	level.foley dialogue_queue( "arcadia_fly_photosforg2" );
	
	// Huah.
	level.dunn dialogue_queue( "arcadia_cpd_huah" );
	
	wait 1;
	
	// Overlord, this is Hunter Two-One-Actual, we have secured the HVO, over.
	level.foley dialogue_queue( "arcadia_fly_securedhvo" );
	
	// Copy that. Get that intel back to the CP. Overlord out.
	radio_dialogue( "arcadia_hqr_getinteltocp" );
	
	wait 1;
	
	// All right, break's over! Let's get the hell outta here.
	level.foley dialogue_queue( "arcadia_fly_breaksover" );
}

player_picks_up_briefcase()
{
	use_trig = getent( "briefcase_trigger", "targetname" );
	use_trig setHintString( &"ARCADIA_PICK_UP_BRIEFCASE_HINT" );
	use_trig waittill( "trigger" );
	use_trig delete();
	
	flag_set( "picked_up_briefcase" );
	
	briefcase = getent( "briefcase", "targetname" );
	briefcase delete();
}

activate_second_half_destructibles()
{
	//flag_wait( "past_checkpoint" );
	wait 1;
	volume = getent( "volume_second_half", "targetname" );
	volume activate_destructibles_in_volume();
	volume activate_interactives_in_volume();
}

precache_masked_destructibles()
{
	loadfx( "smoke/car_damage_whitesmoke" );
	loadfx( "smoke/car_damage_blacksmoke" );
	loadfx( "smoke/car_damage_blacksmoke_fire" );
	loadfx( "explosions/small_vehicle_explosion" );
	loadfx( "props/car_glass_large" );
	loadfx( "props/car_glass_med" );
	loadfx( "props/car_glass_headlight" );
	loadfx( "smoke/motorcycle_damage_blacksmoke_fire" );
	loadfx( "props/car_glass_brakelight" );
	loadfx( "props/mail_box_explode" );
	loadfx( "props/garbage_spew_des" );
	loadfx( "props/garbage_spew" );
	loadfx( "explosions/wallfan_explosion_dmg" );
	loadfx( "explosions/wallfan_explosion_des" );
	loadfx( "props/filecabinet_dam" );
	loadfx( "props/filecabinet_des" );
	loadfx( "misc/light_blowout_runner" );
	loadfx( "props/electricbox4_explode" );
	loadfx( "explosions/ceiling_fan_explosion" );
	//loadfx( "explosions/airconditioner_ex_explode" );
	//loadfx( "props/news_stand_paper_spill_shatter" );
	//loadfx( "props/news_stand_explosion" );
	//loadfx( "props/news_stand_paper_spill" );
	loadfx( "props/firehydrant_leak" );
	loadfx( "props/firehydrant_exp" );
	loadfx( "props/firehydrant_spray_10sec" );
	loadfx( "explosions/tv_flatscreen_explosion" );
	
	precachemodel( "vehicle_van_white_destructible" );
	precachemodel( "vehicle_van_white_destroyed" );
	precachemodel( "vehicle_van_white_hood" );
	precachemodel( "vehicle_van_wheel_lf" );
	precachemodel( "vehicle_van_white_door_rb" );
	precachemodel( "vehicle_van_white_mirror_l" );
	precachemodel( "vehicle_van_white_mirror_r" );
	precachemodel( "vehicle_pickup_destructible_mp" );
	precachemodel( "vehicle_pickup_destroyed" );
	precachemodel( "vehicle_pickup_hood" );
	precachemodel( "vehicle_pickup_door_lf" );
	precachemodel( "vehicle_pickup_door_rf" );
	precachemodel( "vehicle_pickup_mirror_l" );
	precachemodel( "vehicle_pickup_mirror_r" );
	precachemodel( "vehicle_luxurysedan_2008_white_destructible" );
	precachemodel( "vehicle_luxurysedan_2008_white_destroy" );
	precachemodel( "vehicle_luxurysedan_2008_white_hood" );
	precachemodel( "vehicle_luxurysedan_2008_white_wheel_lf" );
	precachemodel( "vehicle_luxurysedan_2008_white_door_lf" );
	precachemodel( "vehicle_luxurysedan_2008_white_door_rf" );
	precachemodel( "vehicle_luxurysedan_2008_white_door_lb" );
	precachemodel( "vehicle_luxurysedan_2008_white_door_rb" );
	precachemodel( "vehicle_luxurysedan_2008_white_mirror_l" );
	precachemodel( "vehicle_luxurysedan_2008_white_mirror_r" );
	precachemodel( "vehicle_coupe_slate_destructible" );
	precachemodel( "vehicle_coupe_slate_destroyed" );
	precachemodel( "vehicle_coupe_slate_door_lf" );
	precachemodel( "vehicle_coupe_slate_spoiler" );
	precachemodel( "vehicle_coupe_slate_mirror_l" );
	precachemodel( "vehicle_coupe_slate_mirror_r" );
	precachemodel( "vehicle_subcompact_green_destructible" );
	precachemodel( "vehicle_subcompact_green_destroyed" );
	precachemodel( "vehicle_subcompact_wheel_lf" );
	precachemodel( "vehicle_subcompact_green_door_lb" );
	precachemodel( "vehicle_subcompact_green_door_rb" );
	precachemodel( "vehicle_subcompact_green_mirror_l" );
	precachemodel( "vehicle_subcompact_green_mirror_r" );
	precachemodel( "vehicle_motorcycle_02_destructible" );
	precachemodel( "vehicle_motorcycle_02_destroy" );
	precachemodel( "vehicle_motorcycle_01_front_wheel_d" );
	precachemodel( "vehicle_motorcycle_01_rear_wheel_d" );
	precachemodel( "vehicle_coupe_black_destructible" );
	precachemodel( "vehicle_coupe_black_destroyed" );
	precachemodel( "vehicle_coupe_black_door_lf" );
	precachemodel( "vehicle_coupe_black_spoiler" );
	precachemodel( "vehicle_coupe_black_mirror_l" );
	precachemodel( "vehicle_coupe_black_mirror_r" );
	precachemodel( "vehicle_van_blue_destructible" );
	precachemodel( "vehicle_van_blue_destroyed" );
	precachemodel( "vehicle_van_blue_hood" );
	precachemodel( "vehicle_van_blue_door_rb" );
	precachemodel( "vehicle_van_blue_mirror_l" );
	precachemodel( "vehicle_van_blue_mirror_r" );
	precachemodel( "vehicle_subcompact_white_destructible" );
	precachemodel( "vehicle_subcompact_white_destroyed" );
	precachemodel( "vehicle_subcompact_white_door_lb" );
	precachemodel( "vehicle_subcompact_white_door_rb" );
	precachemodel( "vehicle_subcompact_white_mirror_l" );
	precachemodel( "vehicle_subcompact_white_mirror_r" );
	precachemodel( "vehicle_subcompact_slate_destructible" );
	precachemodel( "vehicle_subcompact_slate_destroyed" );
	precachemodel( "vehicle_subcompact_slate_door_lb" );
	precachemodel( "vehicle_subcompact_slate_door_rb" );
	precachemodel( "vehicle_subcompact_slate_mirror_l" );
	precachemodel( "vehicle_subcompact_slate_mirror_r" );
	precachemodel( "vehicle_subcompact_blue_destructible" );
	precachemodel( "vehicle_subcompact_blue_destroyed" );
	precachemodel( "vehicle_subcompact_blue_door_lb" );
	precachemodel( "vehicle_subcompact_blue_door_rb" );
	precachemodel( "vehicle_subcompact_blue_mirror_l" );
	precachemodel( "vehicle_subcompact_blue_mirror_r" );
	precachemodel( "vehicle_suburban_destructible_beige" );
	precachemodel( "vehicle_suburban_destroyed_beige" );
	precachemodel( "vehicle_suburban_wheel_rf" );
	precachemodel( "vehicle_suburban_door_lb_beige" );
	precachemodel( "vehicle_motorcycle_01_destructible" );
	precachemodel( "vehicle_motorcycle_01_destroy" );
	precachemodel( "vehicle_policecar_lapd_destructible" );
	precachemodel( "vehicle_policecar_lapd_destroy" );
	precachemodel( "vehicle_policecar_lapd_wheel_lf" );
	precachemodel( "vehicle_policecar_lapd_door_lf" );
	precachemodel( "vehicle_policecar_lapd_door_rf" );
	precachemodel( "vehicle_policecar_lapd_door_lb" );
	precachemodel( "vehicle_policecar_lapd_mirror_l" );
	precachemodel( "vehicle_policecar_lapd_mirror_r" );
	precachemodel( "vehicle_van_deep_blue_destructible" );
	precachemodel( "vehicle_van_deep_blue_destroyed" );
	precachemodel( "vehicle_van_deep_blue_hood" );
	precachemodel( "vehicle_van_deep_blue_door_rb" );
	precachemodel( "vehicle_van_deep_blue_mirror_l" );
	precachemodel( "vehicle_van_deep_blue_mirror_r" );
	precachemodel( "mailbox_black" );
	precachemodel( "mailbox_black_dam" );
	precachemodel( "mailbox_black_dest" );
	precachemodel( "mailbox_black_door" );
	precachemodel( "mailbox_black_flag" );
	precachemodel( "com_trashbin02" );
	precachemodel( "com_trashbin02_dmg" );
	precachemodel( "com_trashbin02_lid" );
	precachemodel( "com_recyclebin01" );
	precachemodel( "com_recyclebin01_dmg" );
	precachemodel( "com_recyclebin01_lid" );
	precachemodel( "cs_wallfan1" );
	precachemodel( "cs_wallfan1_dmg" );
	precachemodel( "com_filecabinetblackclosed" );
	precachemodel( "com_filecabinetblackclosed_dam" );
	precachemodel( "com_filecabinetblackclosed_des" );
	precachemodel( "com_filecabinetblackclosed_drawer" );
	precachemodel( "com_light_ceiling_round_on" );
	precachemodel( "com_light_ceiling_round_off" );
	precachemodel( "me_electricbox2" );
	precachemodel( "me_electricbox2_dest" );
	precachemodel( "me_electricbox2_door" );
	precachemodel( "me_electricbox2_door_upper" );
	precachemodel( "me_electricbox4" );
	precachemodel( "me_electricbox4_dest" );
	precachemodel( "me_electricbox4_door" );
	precachemodel( "me_fanceil1" );
	precachemodel( "me_fanceil1_des" );
	precachemodel( "com_trashbin01" );
	precachemodel( "com_trashbin01_dmg" );
	precachemodel( "com_trashbin01_lid" );
	precachemodel( "com_firehydrant" );
	precachemodel( "com_firehydrant_dest" );
	precachemodel( "com_firehydrant_dam" );
	precachemodel( "com_firehydrant_cap" );
}