#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.so_compass_zoom = "close";

	add_start( "start_map", ::start_map );
	maps\oilrig::main();
	default_start( ::start_map );
	thread maps\oilrig::above_water_art_and_ambient_setup();
	thread maps\oilrig::killtrigger_ocean_on();
}

start_map()
{
	level endon( "special_op_terminated" );
	
	/*-----------------------
	INITIALIZATION
	-------------------------*/	
	level.hostagemanhandle = false;
	thread fade_challenge_in();
	thread enable_challenge_timer( "breaching_on", "barracks_cleared" );
	thread music_to_first_breach();
	thread music_to_top_deck();
	thread music_end();
	thread breach_flags();
	thread maps\oilrig::c4_barrels();
	assert( isdefined( level.gameskill ) );
	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	gameskill_Regular();	break;	// Regular
		case 2:	gameskill_hardened();	break;	// Hardened
		case 3:	gameskill_veteran();	break;	// Veteran
	}
	thread obj_main();

	maps\_compass::setupMiniMap( "compass_map_oilrig_lvl_1" );
	array_thread( getentarray( "compassTriggers", "targetname" ), maps\oilrig::compass_triggers_think );
	
	/*-----------------------
	FIRST BREACH
	-------------------------*/	
	
	//"Sub Command: Civilian hostages hostages at your position, watch your fire."
	delaythread( 2,::radio_dialogue, "oilrig_sbc_civilhostages" );
	
	/*-----------------------
	OPEN GATE, SOUND ALARMS
	-------------------------*/	
	flag_wait( "upper_room_cleared" );
	
	//"Sub Command: Hotel Six, hostages from lower decks are being extracted by Team 2. Proceed to the top deck ASAP to secure the rest, over."
	delaythread( 2,::radio_dialogue, "oilrig_sbc_gettolz" );
	
	thread maps\oilrig::open_gate( undefined, true );
	thread maps\oilrig::spawn_trigger_dummy( "dummy_spawner_ballsout_intro" );
	thread maps\oilrig::spawn_trigger_dummy( "dummy_spawner_ballsout" );
	level.hostageNodes = getnodearray( "node_hostage_scaffolding", "targetname" );
	volume_ambush_room = getent( "volume_ambush_room", "script_noteworthy" );
	thread hostage_evac( volume_ambush_room );
	thread alarm();
	
	flag_wait( "player_at_deck1_midpoint" );
	
	/*-----------------------
	DECK 2 RAPPELERS
	-------------------------*/	
	aSpawners = getentarray( "hostiles_rappel_deck2", "targetname" );
	flag_wait( "rappel_dudes_failsafe" );
	aHostiles = maps\oilrig::spawn_group_staggered( aSpawners );
	
	/*-----------------------
	DECK 2 HELICOPTER
	-------------------------*/	
	heliSpawner = getent( "heli_deck2", "targetname" );
	heliSpawner.origin = heliSpawner.origin + ( 0, 0, -250 );
	eHeli = spawn_vehicle_from_targetname_and_drive( "heli_deck2" );
	foreach( eTurret in eHeli.mgturret )
	{
		eTurret turret_set_default_on_mode( "manual" );
		eTurret setMode( "manual" );
	}
	eHeli.dontWaitForPathEnd = true;
	thread maps\oilrig::heli_ramp_up_damage( eHeli );
	eHeli delaythread ( 3, maps\_attack_heli::heli_spotlight_on, "tag_barrel", true );
	thread maps\oilrig::heli_kill_failsafe( eHeli );
	wait( 6 );
	eHeli = maps\_attack_heli::begin_attack_heli_behavior( eHeli );

	/*-----------------------
	DECK 3
	-------------------------*/	
	flag_wait( "player_at_stairs_to_top_deck" );
	thread maps\oilrig::deck3_firefight();
	
	flag_wait( "player_approaching_topdeck_building" );
	//***Sub Command			Hotel Six, be advised, hostages have been confirmed at your location along with possible explosives, over.
	radio_dialogue( "oilrig_sbc_hostconfirmed" );
	
	/*-----------------------
	FINAL BREACH
	-------------------------*/	
	flag_wait( "top_deck_room_breached" );
	
	
	/*-----------------------
	LEVEL END
	-------------------------*/	
	flag_wait( "barracks_cleared" );
	
	wait( 1 );
	//***Sub Command Good job, Hotel Six. Marine reinforcements are inserting now to dismantle the SAM sites. Get your team ready for phase two of the operation. Out.	
	radio_dialogue( "oilrig_sbc_phase2" );
	
	
	thread dialogue_end_chatter();
	thread fade_challenge_out();
	
}

dialogue_end_chatter()
{
	
	//***Marine HQ			Hunter Two-Two, this is Punisher Actual. GOPLAT secure. All EOD teams are cleared for landing.
	radio_dialogue( "oilrig_rmv_goplat" );
	
	//***Marine 1			Roger Punisher, Hunter Two-Two copies all.		military monotone, background flavor dialogue	
	radio_dialogue( "oilrig_gm1_copies" );
	
	//***F-15 Pilot			Punisher this is Phoenix One-One, flight of two F-15s en route to grid 257221 for SEAD mission, requesting sitrep over
	radio_dialogue( "oilrig_f15_twof15s" );
	
	//***Marine HQ			Phoenix One-One, Punisher. Blue sky, I repeat blue sky. Come to heading two-four-zero and continue on course to target area. Good hunting. Over.
	radio_dialogue( "oilrig_rmv_bluesky" );
	
	//***F-15 Pilot			Phoenix One-One copies. Out.
	radio_dialogue( "oilrig_f15_copies" );
		
	//***Marine HQ			Punisher to all flights in vicinity of grid 255202, local airspace is secure. I repeat, local airspace is secure. Proceed on course to target area along Route November Two.
	radio_dialogue( "oilrig_rmv_localairspace" );
	
	//***Marine 1			Punisher this Hunter Actual. Hunter Two-Two is moving to secure the SAM site at the southwest corner of main deck. Hunter Two-Three is proceeding towards the derrick building to disarm the explosives.
	radio_dialogue( "oilrig_gm1_hunteractual" );
	
	//***Marine HQ			Punisher copies all. We have eyes on two-two. They are arriving at the southwest SAM site… standby… standby…Site is secure, repeat site is secure.
	//radio_dialogue( "oilrig_rmv_standby" );
	
	//***Marine HQ			Punisher Actual to all strike teams - all SAM sites neutralized, repeat, all SAM sites have been neutralized. Blue sky in effect.
	radio_dialogue( "oilrig_rmv_samsitesneut" );
}


breach_flags()
{
	level waittill( "breach_explosion" );
	flag_set( "upper_room_breached" );
	
	wait( 2 );
	
	level waittill( "breach_explosion" );
	flag_set( "top_deck_room_breached" );
}


alarm()
{
	alarm_org = getent( "origin_alarm", "targetname" );
	alarm_org playloopsound( "emt_oilrig_alarm_alert" );
	wait( 20 );
	alarm_org stopLoopSound( "emt_oilrig_alarm_alert" );
	alarm_org delete();
}

music_to_first_breach()
{
	level endon( "upper_room_breached" );
	while ( !flag( "upper_room_breached" ) )
	{
		MusicPlayWrapper( "oilrig_sneak_music" );
		wait( 89 );
		music_stop( 1 );
		wait( 1.1 );
	}
}

music_to_top_deck()
{
	flag_wait( "upper_room_breached" );
	music_stop();
	flag_wait( "upper_room_cleared" );
	
	level endon( "top_deck_room_breached" );
	while ( !flag( "top_deck_room_breached" ) )
	{
		MusicPlayWrapper( "oilrig_fight_music_01" );
		wait( 60 );
		wait( 35 );
		music_stop( 1 );
		wait( 1.1 );
	}
}


music_end()
{
	flag_wait( "top_deck_room_breached" );
	music_stop();
	
	flag_wait( "barracks_cleared" );
	musicstop();
	wait( .5 );
	MusicPlayWrapper( "oilrig_victory_music" );
}



hostage_evac( eVolume )
{
	level endon( "mission failed" );
	level endon( "missionfailed" );
	level endon( "player_shot_a_hostage" );
	aHostages = eVolume get_ai_touching_volume( "neutral" );
	if ( flag( "oilrig_mission_failed" ) )
		return;
	if ( flag( "missionfailed" ) )
		return;
	array_thread( aHostages, ::hostage_evac_think );
	thread AI_delete_when_out_of_sight( aHostages, 512 );
}

hostage_evac_think()
{
	level endon( "mission failed" );

	while( !isdefined( self.breachfinished ) )
		wait( .1 );
	
	while( self.breachfinished == false )
		wait( .1 );
	
	wait( randomfloatrange( 1, 2 ) );
	eNode = level.hostageNodes[ 0 ];
	level.hostageNodes = array_remove( level.hostageNodes, eNode );
	self endon( "death" );
	self notify( "stop_idle" );
	self setgoalnode( eNode );
	self.goalradius = 64;
	self.alertlevel = "alert";
	self waittill( "goal" );
}



gameskill_regular()
{
	level.challenge_objective = &"SO_ASSAULT_OILRIG_OBJ_MAIN";
}

gameskill_hardened()
{
	level.challenge_objective = &"SO_ASSAULT_OILRIG_OBJ_MAIN";
}

gameskill_veteran()
{
	level.challenge_objective = &"SO_ASSAULT_OILRIG_OBJ_MAIN";
}


obj_main()
{
	objective_number = 1;
	obj_positions = getentarray( "obj_breach2", "targetname" );

	objective_add( objective_number, "current", level.challenge_objective );
	objective_additionalposition( objective_number, 3, obj_positions[ 0 ].origin );
	objective_additionalposition( objective_number, 4, obj_positions[ 1 ].origin );

	flag_wait( "upper_room_breached" );
	objective_additionalposition( objective_number, 3, ( 0, 0, 0 ) );
	objective_additionalposition( objective_number, 4, ( 0, 0, 0 ) );
	
	flag_wait( "upper_room_cleared" );
	obj_position = getent( "obj_explosives_locate_01", "targetname" );
	Objective_Position( objective_number, obj_position.origin );

	flag_wait( "player_at_stairs_to_deck_2" );
	obj_position = getent( "obj_explosives_locate_01a", "targetname" );
	objective_position( objective_number, obj_position.origin );
	
	flag_wait( "player_at_corener_of_deck2" );
	obj_position = getent( "obj_explosives_locate_02", "targetname" );
	objective_position( objective_number, obj_position.origin );

	flag_wait( "player_on_right_top_deck" );
	objective_position( objective_number, ( 0, 0, 0 ) );
	obj_positions = getentarray( "obj_breach3", "targetname" );
	objective_additionalposition( objective_number, 2, obj_positions[ 0 ].origin );
	objective_additionalposition( objective_number, 3, obj_positions[ 1 ].origin );
	
	flag_wait( "top_deck_room_breached" );
	objective_additionalposition( objective_number, 2, ( 0, 0, 0 ) );
	objective_additionalposition( objective_number, 3, ( 0, 0, 0 ) );
	
	flag_wait( "barracks_cleared" );
	
	wait( 1 );
	
	objective_state( objective_number, "done" );
}