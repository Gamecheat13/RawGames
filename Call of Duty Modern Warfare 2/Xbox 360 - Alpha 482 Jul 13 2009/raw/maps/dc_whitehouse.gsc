#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_weather;
//#include maps\_hud_util;
//#include maps\_slowmo_breach;
//#include maps\_vehicle;
//#include maps\_casual_killer;

#include maps\dc_whitehouse_code;
//#include maps\dcemp_code;

#using_animtree( "generic_human" );

/*
// custom command line
+exec scripter +set start "" +difficultyhard +set cg_drawfps 1 +set debug_colorfriendlies "off"
*/

main()
{
	//STARTS
	default_start( ::start_tunnels );
	add_start( "tunnels", 	::start_tunnels, "[tunnels] -> make you way to WH", ::tunnels_main );
//	add_start( "whitehouse2", 	::start_whitehouse, "[whitehouse] -> fight through the whitehouse", ::whitehouse_main );
	add_start( "flare", ::start_flare, "[flare] -> pop the flare", ::flare_main );

	flags();
	global_inits();
}

global_inits()
{	
	maps\dc_whitehouse_precache::main();
	maps\createart\dc_whitehouse_fog::main();
	maps\createfx\dc_whitehouse_fx::main();
	maps\dc_whitehouse_fx::main();
	maps\_load::main();

//	thread maps\_mortar::bog_style_mortar();

	precacheshellshock( "minor" );
	precachemodel( "mil_sandbag_plastic_white_single_flat" );
	precachemodel( "mil_sandbag_plastic_white_single_bent" );
	precachemodel ( "rappelrope100_ri" );
	precachemodel ( "mil_emergency_flare" );
	precachemodel( "furniture_chandelier1_off" );
	PreCacheTurret( "heli_spotlight" );
	precachemodel( "cod3mg42" );	// should be a spotlight model but can't find one that works as a turret.
	PrecacheItem( "rpg_straight" );
	precachemodel( "com_door_01_handleleft2" );
	precachemodel( "mil_sandbag_plastic_white_single_flat" );
	precachemodel( "mil_sandbag_plastic_white_single_bent" );
	precachemodel( "weapon_binocular" );

	level.default_goalheight = 72;

	maps\dc_whitehouse_anim::main();
	maps\_drone_ai::init();

	level thread maps\dc_whitehouse_amb::main();

	thread maps\_utility::set_ambient( "dcemp_heavy_rain_tunnel" );
	vision_set_whitehouse();

	level.player setempjammed( true );
	add_global_spawn_function( "allies", ::set_color_goal_func );

	// jets fly by sound.
	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );

	// threat bias groups for approach whitehouse enemies. so that I can make them not shoot me in the back.
	createthreatbiasgroup( "ignore_player" );
	createthreatbiasgroup( "player" );
	SetIgnoreMeGroup( "player", "ignore_player" );
	level.player setthreatbiasgroup( "player" );

	level thread music();
}

music()
{
	music_loop( "dc_whitehouse_tunneldrone", 105 );

	flag_wait( "whitehouse_init" );
	music_play( "dc_whitehouse_attack", 3 );

	flag_wait( "whitehouse_breached" );
	music_play( "dc_whitehouse_endrun", 7 );
}

flags()
{
	flag_init( "team_initialized" );

	flag_init( "mg_threat" );
	flag_init( "oval_office_done" );
	flag_init( "oval_office_door_open" );
	flag_init( "whitehouse_kitchen_open" );
	flag_init( "whitehouse_interior" );
	flag_init( "whitehouse_radio_done" );
	flag_init( "whitehouse_hammerdown" );
	flag_init( "whitehouse_hammerdown_stopped" );
	flag_init( "whitehouse_briefing_end" );
	flag_init( "whitehouse_hammerdown_started" );
	flag_init( "whitehouse_wrapup" );
	flag_init( "whitehouse_completed" );
	flag_init( "broadcast" );
	flag_init( "broadcast_pause" );
	flag_init( "broadcast_end" );
	flag_init( "countdown" );
	flag_init( "whitehouse_hammerdown_jets" );
	flag_init( "remove_use_hint" );
	flag_init( "flare_end_fx" );
	flag_init( "whitehouse_2min" );
	flag_init( "whitehouse_90sec" );
	flag_init( "whitehouse_1min" );
	flag_init( "whitehouse_30sec" );
}

start_tunnels()
{
	spawn_team();
	activate_trigger_with_targetname( "tunnels_init_color_trigger" );

	delaythread( 5, ::activate_trigger_with_targetname, "tunnels_start_color_trigger" );
	delaythread( 9, ::activate_trigger_with_targetname, "tunnels_move_color_trigger" );

	level waittill( "introscreen_complete" );
	level thread objectives();

}

tunnels_main()
{
	maps\_weather::rainhard( 1 );

	array_spawn_function_noteworthy( "tunnel_filler_drone", ::whitehouse_filler_drone  );
	array_spawn_function_noteworthy( "tunnels_wave_guy", ::tunnels_wave_guy  );
	array_spawn_function_noteworthy( "tunnels_twirl_guy", ::tunnels_twirl_guy  );

	force_flash_setup();
	battlechatter_off( "allies" );

	flag_wait( "tunnels_wave_guy" );
	// make foley et al move faster in the tunnel
	foreach( ai in level.team )
	{
//		ai.neverenablecqb = true;
//		ai disable_cqbwalk();
	}

	flag_wait( "whitehouse_init" );

	// make foley et al move as they wish
	foreach( ai in level.team )
	{
//		ai.neverenablecqb = undefined;
	}

	normal = maps\dc_whitehouse_fx::lightning_normal;
	flashfunc = maps\dc_whitehouse_fx::lightning_flash;
	thread maps\_weather::lightningFlash( normal, flashfunc );

	level thread whitehouse_main();
}

tunnels_dialogues()
{
	flag_wait( "whitehouse_ambience" );
	// Sounds like the party's already started.
	level.dunn dialogue_queue( "dcemp_cpd_partystarted" );

	// Roger that. Stay frosty.
	level.foley dialogue_queue( "dcemp_fly_rogerstayfrosty" );	
}

tunnels_wave_guy()
{
	self endon( "death" );

	node = getnode( self.target, "targetname" );
	node thread anim_generic_loop( self, "wave_on" );

	flag_wait( "tunnels_wave_guy" );

	wait 4.5;

	lines = [];
	lines[0] = "dcemp_ar3_hustleup";
	lines[1] = "dcemp_ar3_thisway";
	lines[2] = "dcemp_ar3_movemove";

	index = 0;
	while( !flag( "whitehouse_init" ) )
	{	
		self generic_dialogue_queue( lines[ index ] );
		wait randomfloatrange( 5, 8 );

		if ( index == 2 )
			wait 10;
		index = ( index + 1 ) % lines.size;
	}

	self delete();
}

tunnels_twirl_guy()
{
	animent = getent( "tunnels_twirl_animent", "targetname" );

	self walkdist_zero();
	animent anim_generic_reach( self, "combatwalk_F_spin" );

	// Let's go! Let's go! 
//	self thread generic_dialogue_queue( "dcemp_ar2_letsgo" );

	animent anim_generic( self, "combatwalk_F_spin" );
	self enable_ai_color();
	self walkdist_reset();
}

vision_set_tunnels()
{
	thread maps\_utility::set_vision_set( "dcemp_tunnels", 4 );	
	thread maps\_utility::vision_set_fog_changes( "dcemp_tunnels", 4 );
}

start_whitehouse()
{
	// maps\dcemp::start_common_dcemp();
	// flag_set( "end_fx" );
	
	// vision_set_whitehouse();

	// replace
	// emp_teleport_team( level.team, getstructarray( "whitehouse_start_points", "targetname" ) );
	// emp_teleport_player();

	maps\_weather::rainMedium( 1 );

	flag_set( "tunnels_teleport_done" );
	level thread objectives();
}

whitehouse_main()
{
	thread maps\_weather::rainMedium( 15 );

	autosave_by_name( "tunnel_exit" );

	array_spawn_function_noteworthy( "whitehouse_drone", ::whitehouse_drone  );
//	array_spawn_function_noteworthy( "whitehouse_filler_drone", ::whitehouse_filler_drone  );
	array_spawn_function_noteworthy( "drone_war_drone", ::whitehouse_drone_war_drone  );

	spawner = getent( "marshall", "script_noteworthy" );
	spawner add_spawn_function( ::whitehouse_marshall );
	spawner spawn_ai();

	chandelier_setup();
	magic_rpg_setup();
	whitehouse_rappel_setup();
	sandbag_group_setup( "sandbag_group" );
	sandbag_group_setup( "westwing_sandbag_group" );
	whitehouse_mg_setup();
	level thread whitehouse_spotlight_main();

	level thread oval_office();

	array_thread( level.team, ::whitehouse_team );
	level.foley thread whitehouse_foley();
	level.dunn thread whitehouse_dunn();

	level thread whitehouse_dialogue();
	level thread whitehouse_radio();
	level thread whitehouse_radio_loop();

	level.player.ignoreme = true;
	flag_wait( "whitehouse_moveout" );
	level.player.ignoreme = false;

	autosave_by_name( "moveout" );

	activate_trigger_with_targetname( "whitehouse_moveout_color_trigger" );

	battlechatter_on( "allies" );

	flag_wait( "whitehouse_spotlight" );
	thread maps\_weather::rainlight( 5 );

	level thread whitehouse_drone_slaughter();

	whitehouse_entrance();
}

whitehouse_spotlight_main()
{
	flag_wait( "whitehouse_spotlight" );

	wh_spotlight = whitehouse_spotlight_create( "whitehouse_spotlight", 400 );
	wh_spotlight thread whitehouse_spotlight_dunn();

	flag_wait( "whitehouse_entrance_init" );

	if ( isdefined( wh_spotlight ) )
		wh_spotlight.damage_ent notify( "damage", 1000, level.player );

	ww_spotlight = whitehouse_spotlight_create( "westwing_spotlight", 600 );

	wait 100;

	if ( isdefined( ww_spotlight ) )
		ww_spotlight.damage_ent notify( "damage", 1000, level.player );
}

whitehouse_spotlight_dunn()
{
	// todo: add dialogue
	flag_wait( "whitehouse_entrance_moveup" );
	wait 8;

	if ( isdefined( self ) )
	{
		level.dunn SetEntityTarget( self );
		self waittill( "death" );
		level.dunn clearEntityTarget();
	}
}

objectives()
{
	wait 2;

	Objective_Add( 9, "current", &"DC_WHITEHOUSE_OBJ_WHISKEY_HOTEL" );
	objective_onentity( 9, level.foley, ( 0,0,70 ) );

	flag_wait( "whitehouse_moveout" );
	Objective_state( 9, "done" );

	pos = getstruct( "objective_entrance", "targetname" );
	Objective_Add( 10, "current", &"DC_WHITEHOUSE_OBJ_BREACH_WH", pos.origin );

	flag_wait( "oval_office_done" );
	Objective_state( 10, "done" );

	pos = getstruct( "objective_roof", "targetname" );
	Objective_Add( 11, "current", &"DC_WHITEHOUSE_OBJ_DEPLOY_FLARE" );
	objective_onentity( 11, level.foley, ( 0,0,70 ) );

	flag_wait( "whitehouse_30sec" );
	wait 2;
	Objective_Position( 11, pos.origin );

	flag_wait( "whitehouse_hammerdown_jets_safe" );
	wait 6;
	Objective_state( 11, "done" );

	flag_wait( "whitehouse_completed" );

	if ( is_default_start() )
	{
		nextmission();
	}
	else
		IPrintLnBold( "DEVELOPER: END OF SCRIPTED LEVEL" );
}

/*
step_obj( obj_id, ent )
{
	level endon( "whitehouse_radio" );

	while( isdefined( ent.target ) )
	{
		trigger = Spawn( "trigger_radius", ent.origin, 0, ent.radius, 72 );
		trigger waittill( "trigger" );
		trigger delete();

		if ( isdefined( self.script_flag_wait ) )
			flag_wait( self.script_flag_wait );

		ent = getstruct( ent.target, "targetname" );
		objective_Position( obj_id, ent.origin );
	}
}
*/

oval_office()
{
	flag_wait( "whitehouse_entrance_clear" );
	array_spawn_function_noteworthy( "oval_office_door_guy", ::oval_office_door_guy );
	level thread oval_office_radio();
}

oval_office_radio()
{
	volume = getent( "oval_office_volume", "targetname" );
	volume waittill_volume_dead();

	guys = [];
	guys[0] = level.foley;
	guys[1] = level.dunn;

	animent = getent( "of_radio_animent", "targetname" );
	level.dunn oval_office_dunn( animent );

	animent anim_reach_solo( level.foley, "dcemp_wh_radio" );

	level.dunn anim_stopanimscripted();
	animent notify( "stop_loop" );

	delayThread( 15, ::activate_trigger_with_targetname, "oval_office_exit_enemies_trigger" );
	delayThread( 17, ::activate_trigger_with_targetname, "oval_office_exit_color_trigger" );
	level thread flag_set_delayed( "oval_office_door_open", 19 );

	animent anim_single( guys, "dcemp_wh_radio" );
	flag_set( "oval_office_done" );

	level.foley enable_ai_color();
	level.dunn enable_ai_color();
}

oval_office_door_guy()
{
	self magic_bullet_shield();
	self.animname = "generic";

	self.neverenablecqb = true;
	self disable_cqbwalk();

	animent = getent( "oval_office_kick_animent_alt", "targetname" );
	door = getent( "oval_office_door", "targetname" );
	door.origin = animent.origin;

	flag_wait( "oval_office_door_open" );
	animent anim_reach_solo( self, "doorburst_fall" );
	animent anim_single_solo( self, "doorburst_fall", undefined, 1.8 );

	self stop_magic_bullet_shield();
	self startragdoll();
//	self.ragdoll_immediate = true;
//	self kill();
}

oval_office_door( guy )
{
	// started from notetrack in %doorburst_fall
	door = getent( "oval_office_door", "targetname" );
	door RotateYaw( door.angles[1] + 140, .5, 0, 0.5 );	
	door playsound( "door_wood_double_kick" );
	door connectpaths();
}

oval_office_dunn( animent )
{
	animent anim_reach_and_approach_solo( self, "dcemp_wh_radio_idle" );
	animent thread anim_loop_solo( self, "dcemp_wh_radio_idle" );
}

whitehouse_dialogue()
{
	level thread whitehouse_nag();

	// Keep hitting 'em with the Two-Forty Bravos! Get more men moving on the left flank! 
	level.marshall dialogue_queue( "dcemp_cml_moremen" );	

	flag_wait( "whitehouse_entrance_init" );

	//We need to punch through right here!
	level.foley dialogue_queue( "dcemp_fly_punchthrough" );	
	//Take out those machine guns!
	level.foley dialogue_queue( "dcemp_fly_machineguns" );	

	flag_wait( "whitehouse_entrance_clear" );
	//Ramirez, let's go! 
	level.foley dialogue_queue( "dcemp_fly_ramirezgo" );	

//	flag_wait( "whitehouse_radio" );
	// Hey, there's a radio over here! The transmitter's not working, but I'm getting something!
//	level.dunn dialogue_queue( "dcemp_cpd_radiooverhere" );	
//	flag_set( "whitehouse_radio_done" );

	// What the hell are they talking about?
//	level.dunn dialogue_queue( "dcemp_cpd_talkingabout" );	

	flag_wait( "whitehouse_2min" );

	//Hammer Down means they're gonna flatten the city - we gotta get to the roof and stop 'em! 
//	level.foley dialogue_queue( "dcemp_fly_flattenthecity" );	

//	flag_set( "whitehouse_flare_obj" );

	//We got less than two minutes, let's go!
	level.foley dialogue_queue( "dcemp_fly_lessthantwomins" );	

	flag_wait( "whitehouse_90sec" );
	// 90 seconds! We got to push through.
	level.foley dialogue_queue( "dcemp_fly_90seconds" );

	flag_wait( "whitehouse_1min" );
	// One minute! Go go go!
	level.foley dialogue_queue( "dcemp_fly_60seconds" );

	flag_wait( "whitehouse_30sec" );
	// 30 seconds! We gotta get to the roof now!! Go! Go!
	level.foley dialogue_queue( "dcemp_fly_30seconds" );

}

whitehouse_radio_broadcast( soundalias )
{
	flag_waitopen( "broadcast" );
	flag_set( "broadcast" );

	radio_array = SortByDistance( level.radio_array, level.player.origin );
	play_count = 1; // 3

	radio = undefined;
	for ( i=0; i<radio_array.size; i++ )
	{	
		// distance above or below player
		dist = abs( level.player.origin[2] - radio_array[i].origin[2] );
		if ( dist > 256 )
			continue;

		radio =  radio_array[i];
		radio PlaySound( soundalias, "sounddone" );

		play_count--;
		if ( !play_count )
			break;
	}
	assert( isdefined( radio ) );
	radio waittill( "sounddone" );
	flag_clear( "broadcast" );
}

whitehouse_radio_loop()
{
	level endon( "broadcast_terminate" );
	flag_wait( "whitehouse_radio_start" );

	while( true )
	{
		flag_clear( "broadcast_end" );

		flag_waitopen( "broadcast_pause" );
		// This is Cujo-Five-One to any friendly units in D.C.: Hammer Down is in effect, I repeat, Hammer Down is in effect. 
		whitehouse_radio_broadcast( "dcemp_fp1_hammerdown" );

		flag_waitopen( "broadcast_pause" );
		// If you can receive this transmission, you are in a hardened high-value structure. 
		whitehouse_radio_broadcast( "dcemp_fp1_highvalue" );

		flag_waitopen( "broadcast_pause" );
		// Deploy green flares on the roof of this structure to indicate you are still combat effective. 
		whitehouse_radio_broadcast( "dcemp_fp1_greenflares" );

		flag_waitopen( "broadcast_pause" );
		// We will abort our mission on direct visual contact with this countersign. 
		whitehouse_radio_broadcast( "dcemp_fp1_willabort" );

		flag_set( "broadcast_end" );
		wait 0.05;	// lets other threads react to flags
	}
}

countdown_trigger()
{
	self waittill( "trigger" );
	if ( self.script_index == level.countdown_index )
	{
		flag_set( "countdown" );
		if ( self.script_index == 2 )
			autosave_by_name( "whitehouse_parlor" );
	}
}

countdown_timeout()
{
	level endon( "countdown" );
	wait 30;
	flag_set( "countdown" );
}

whitehouse_radio()
{
	level endon( "whitehouse_hammerdown" );

	level.radio_array = getentarray( "radio_origin", "targetname" );

	flag_wait( "whitehouse_radio_start" );

	level.countdown_index = 0;

	triggers = getentarray( "countdown_trigger", "targetname" );
	array_thread( triggers, ::countdown_trigger );

	level.hammerdown_time = gettime() + 120 * 1000;

	countdown_line = [];
	countdown_line[0] = "dcemp_fp1_2minutes";
	countdown_line[1] = "dcemp_fp1_90secs";
	countdown_line[2] = "dcemp_fp1_1minute";
	countdown_line[3] = "dcemp_fp1_30secs";

	countdown_flag = [];
	countdown_flag[0] = "whitehouse_2min";
	countdown_flag[1] = "whitehouse_90sec";
	countdown_flag[2] = "whitehouse_1min";
	countdown_flag[3] = "whitehouse_30sec";

	flag_wait( "countdown_start" );
//	flag_wait( "whitehouse_radio" );

	flag_set( "whitehouse_interior" );

	start_time = gettime();

	while( true )
	{
		level.countdown_index++;

		flag_set( "broadcast_pause" );
		flag_waitopen( "broadcast" );

		println( "***********************************" );
		println( "********** COUNTDOWN: " + elapsed_time( start_time ) + " **********" );
		println( "***********************************" );
		level whitehouse_radio_broadcast( countdown_line[ level.countdown_index - 1 ] );
		start_time = gettime();

		// set countdown flags
		flag_set( countdown_flag[ level.countdown_index - 1 ] );

		if ( level.countdown_index == 4 )
			break;

		level thread countdown_timeout();
		wait 6;
		flag_clear( "broadcast_pause" );

		flag_wait( "countdown" );
		flag_clear( "countdown" );
	}

	// 30 seconds to go ...
	flag_set( "whitehouse_hammerdown_jets" );

	wait 3;
//	flag_wait( "whitehouse_hammerdown_jets_fly" );

	//(garble)...target package Whiskey Hotel Zero-One has been authorized....roger...passing IP Buick...standby…
//	level thread whitehouse_radio_broadcast( "dcemp_fp1_beenauthorized" );

	flag_wait( "whitehouse_hammerdown_jets_safe" );

	wait 3.5; // 2.5

	// Countersign detected at the Whiskey Hotel! Abort abort!!
	whitehouse_radio_broadcast( "dcemp_fp1_abortabort" );
	//We got a countersign! Abort mission!
	whitehouse_radio_broadcast( "dcemp_fp2_abortmission" );
	//Aborting weapons release! Rolling out!
	whitehouse_radio_broadcast( "dcemp_fp3_rollingout" );
	//Roger, weapons on safe! Aborting mission!
	whitehouse_radio_broadcast( "dcemp_fp4_abortingmission" );
	// Cujo 5-1 to friendly ground units at the Whiskey Hotel - that was a close one. 
	whitehouse_radio_broadcast( "dcemp_fp1_closeone" );
	//We're sending word back to HQ, stay alive down there. Cujo 5-1 out.
	whitehouse_radio_broadcast( "dcemp_fp1_wordtohq" );
}

whitehouse_hammerdown_jet_safe()
{
	level endon( "whitehouse_hammerdown" );

	level.jets = [];
	array_spawn_function_noteworthy( "hammer_down_jet", ::whitehouse_hammerdown_jet  );

	flag_wait( "whitehouse_hammerdown_jets" );
	activate_trigger_with_targetname( "hammer_down_jet_safe_trigger" );
	foreach( jet in level.jets )
	{
		jet delete();
	}
}

whitehouse_hammerdown_jet()
{
	level.jets[ level.jets.size ] = self;
}

whitehouse_hammerdown()
{
	level thread whitehouse_hammerdown_jet_safe();
//	level thread whitehouse_early_bombs();

	flag_wait( "whitehouse_hammerdown_jets" );

//
//	flag_wait_or_timeout( "whitehouse_hammerdown_jets_fly", 15 );
//	flag_set( "whitehouse_hammerdown_jets_fly" );
//	activate_trigger_with_targetname( "hammer_down_jet_trigger" );

	level endon( "whitehouse_hammerdown_jets_safe" );
	wait 20;

	flag_set( "whitehouse_hammerdown" );

	wait 3;
	flag_set( "whitehouse_hammerdown_started" );

	// Bombs away bombs away.
	whitehouse_radio_broadcast( "dcemp_fp1_bombsaway" );
	wait 2;

	exploder( "carpetbomb" );

	earthquake( 0.1, 1, level.player.origin, 512 );
	wait 0.5;
	earthquake( 0.2, 1, level.player.origin, 512 );
	wait 0.5;
	earthquake( 0.4, 1, level.player.origin, 512 );
	wait 0.5;
	earthquake( 0.6, 3, level.player.origin, 512 );
	wait .75;

	level notify( "whitehouse_hammerdown_death" );

	PlayFX( level._effect[ "carpetbomb" ], level.player.origin );
	level.player PlaySound( "explo_metal_rand" );
	wait 0.5;

	level.foley stop_magic_bullet_shield();
	level.dunn stop_magic_bullet_shield();

	level.foley kill();
	level.dunn kill();

	level.player kill();
	waittillframeend;
	setDvar( "ui_deadquote", &"DC_WHITEHOUSE_FLARE_DEADQUOTE" );
}

/*
whitehouse_early_bombs()
{
	flag_wait( "whitehouse_pop_flare" );
	exploder( "early_bomb_2" );
	wait 2;
	exploder( "early_bomb_3" );
	wait 1.5;
	exploder( "early_bomb" );
}
*/

whitehouse_nag()
{
	level endon( "whitehouse_entrance_init" );

	flag_wait( "whitehouse_briefing_end" );

	while( true )
	{
		wait 8;

		//Work your way to the left!!
		level.foley dialogue_queue( "dcemp_fly_workyourwayleft" );	
		wait 8;

		//Ramirez, let's go! 
		level.foley dialogue_queue( "dcemp_fly_ramirezgo" );	
		wait 15;
	
		//Move up! We gotta take the left flank!
		level.foley dialogue_queue( "dcemp_fly_takeleftflank" );	

		wait 12;
	}
}

whitehouse_team()
{
	if ( self is_hero() )
		return;

	self endon( "death" );

	self.ignoreme = true;
	self.ignoreall = true;

	flag_wait( "whitehouse_moveout" );
	self.ignoreme = false;
	self.ignoreall = false;
}

whitehouse_briefing( animent )
{
//	level endon( "whitehouse_moveout" );

	guys = [];
	guys[0] = level.foley;
	guys[1] = level.marshall;

	animent anim_single( guys , "DCemp_whitehouse_briefing" );

	flag_set( "whitehouse_briefing_end" );
}

whitehouse_foley()
{
	self disable_ai_color();
	self.ignoreme = true;
	self.ignoreall = true;

	wait 1;

	node = getnode( "foley_briefing_approach_node", "targetname" );
	self.goalradius = node.radius;
	self setgoalnode( node );
	self waittill( "goal" );

	animent = getent( "whitehouse_briefing_ent", "targetname" );
	animent anim_reach_solo( self, "DCemp_whitehouse_briefing" );

	level thread whitehouse_briefing( animent );

	flag_wait( "whitehouse_moveout" );
	self enable_ai_color();

	self.ignoreme = false;
	self.ignoreall = false;

	flag_wait( "whitehouse_entrance_init" );
	old_awareness = self.grenadeawareness;
	self.grenadeawareness = 0;

	flag_wait( "whitehouse_breached" );
	self disable_ai_color();

	// add door kick

//	start_node = getnode( "foley_radio_node", "targetname" );
//	self thread maps\_spawner::go_to_node( start_node );
//	self.grenadeawareness = old_awareness;
//	wait 2;

/*	flag_wait( "whitehouse_radio" );

	// turn off cqb so that the guy will idle at idle node.
	self.neverenablecqb = true;
	self disable_cqbwalk();
	self.ignoreme = true;
	self.ignoreall = true;

	flag_wait( "whitehouse_flare_obj" );

	self notify( "stop_going_to_node" );
*/
//	flag_wait( "whitehouse_flare" );

	door = getent( "whitehouse_kitchen_door", "targetname" );
	parts = getentarray( door.target, "targetname" );
	array_call( parts, ::linkto, door );

	// kick open kitchen door
	animent = getent( "whitehouse_kitchen_kick", "targetname" );
	animent anim_generic_reach( level.foley, "doorburst_wave" );
	animent thread anim_generic_gravity( level.foley, "doorburst_wave" );
	door thread door_open_kick();

	flag_set( "whitehouse_kitchen_open" );


	start_node = getnode( "foley_wh_path", "targetname" );
	self thread maps\_spawner::go_to_node( start_node );
	self.neverenablecqb = undefined;
	self enable_cqbwalk();
	self.ignoreme = false;
	self.ignoreall = false;

	// trying to not make him stop in the kitchen
	self set_ignoreSuppression( true );
	self set_fixednode_false();  // this one seemed to do it

	flag_wait( "whitehouse_path_elevator" );

	// reset stuff trying to not make him stop in the kitchen
	self set_ignoreSuppression( false );
	self set_fixednode_true();

//	self thread whitehouse_foley_flare();
}

whitehouse_dunn()
{
	self.ignoreme = true;
	self.ignoreall = true;

	wait 0.8;

	flag_wait( "whitehouse_moveout" );
	self.ignoreme = false;
	self.ignoreall = false;
	self.neverenablecqb = true;
	self disable_cqbwalk();

	flag_wait( "whitehouse_entrance_init" );
	old_awareness = self.grenadeawareness;
	self.grenadeawareness = 0;

	flag_wait( "whitehouse_breached" );
	self disable_ai_color();
	start_node = getnode( "dunn_wh_path", "targetname" );
	self thread maps\_spawner::go_to_node( start_node );
	self.grenadeawareness = old_awareness;

//	// turn off cqb so that the guy will idle at idle node.
//	flag_wait( "whitehouse_radio" );
//	self.ignoreme = true;
//	self.ignoreall = true;

//	flag_wait( "whitehouse_flare_obj" );
//	self.neverenablecqb = undefined;
//	self enable_cqbwalk();
//	self.ignoreme = false;
//	self.ignoreall = false;

//	flag_wait( "whitehouse_pop_flare" );
//	self.neverenablecqb = true;
//	self disable_cqbwalk();
//	self.ignoreme = true;
//	self.ignoreall = true;
}

whitehouse_marshall()
{
	self endon( "death" );

	self.animname = "marshall";
	self.ignoreme = true;
	self.ignoreall = true;
	level.marshall = self;
	self magic_bullet_shield();

	self AllowedStances( "crouch" );

	animent = getent( "whitehouse_briefing_ent", "targetname" );
	animent thread anim_first_frame_solo( self, "DCemp_whitehouse_briefing" );

	self Attach( "weapon_binocular", "tag_inhand" );

	flag_wait( "whitehouse_briefing_end" );

	self detach( "weapon_binocular", "tag_inhand" );

	self stop_magic_bullet_shield();
	self.ignoreme = false;
	self.ignoreall = false;

	wait 1;
	self AllowedStances( "prone", "crouch", "stand" );

	flag_wait( "whitehouse_spotlight" );
	self delete();
}

whitehouse_entrance()
{
	flag_wait( "whitehouse_entrance_moveup" );
	level thread whitehouse_cleanup_approach();

	flag_wait( "whitehouse_entrance_init" );
	autosave_by_name( "entrance" );

	flag_wait( "whitehouse_entrance_clear" );

	thread maps\_weather::rainNone( 5 );

	flag_wait( "whitehouse_breached" );

//	battlechatter_off( "allies" );

	activate_trigger_with_targetname( "drone_war_trigger" );

	flag_wait( "whitehouse_kitchen_open" );

	whitehouse_interior();
}

whitehouse_interior()
{
	autosave_by_name( "interior" );

	set_group_advance_to_enemy_parameters( 45, 1 );
	reset_group_advance_to_enemy_timer( "axis" );

	level.foley enable_heat_behavior( true );
	level.dunn enable_heat_behavior( true );

	level thread whitehouse_hammerdown();
	level thread whitehouse_dunn_flare();

	setsaveddvar( "ai_friendlysuppression", 0 );
	setsaveddvar( "ai_friendlyfireblockduration", 0 );

	flag_wait( "whitehouse_path_elevator" );
//	battlechatter_on( "allies" );

	flag_wait( "whitehouse_chandelier" );
	source_ent = getent( "chandelier_grenade_source", "targetname" );
	target_ent = getent( source_ent.target, "targetname" );
	MagicGrenade( "fraggrenade", source_ent.origin, target_ent.origin, 1.5 );

	flag_wait( "whitehouse_path_office_2" );
	thread maps\_weather::rainlight( 8 );

//	flag_wait( "whitehouse_pop_flare" );

//	level.foley disable_heat_behavior();
//	level.dunn disable_heat_behavior();
}

whitehouse_drone()
{
	self endon( "death" );

	if ( !isdefined( level.whitehouse_drone_array ) )
		level.whitehouse_drone_array = [];
	level.whitehouse_drone_array[ level.whitehouse_drone_array.size ] = self;

	self.health = 10000;

	flag_wait( "whitehouse_silhouette_ready");

	if ( isdefined( self.script_animation ) )
		self.deathanim = level.drone_death_anims[ self.script_animation ];

	self.health = 200;
}

whitehouse_filler_drone()
{
	self endon( "death" );

//	self.runanim = %walk_cqb_f;
//	self.runanim = %run_cqb_f_search_v1;
//	self.runanim = %walk_forward;

	// happens in after _drone script sets it to 1.
	self.moveplaybackrate = 0.8;

	self.health = 1000;
	flag_wait( "whitehouse_breached" );
	wait randomfloat( 5 );
	self delete();
}

whitehouse_drone_war_drone()
{
	self endon( "death" );

	flag_wait( "whitehouse_path_roof" );
	wait randomfloat( 5 );
	self delete();
}

vision_set_whitehouse()
{
	thread maps\_utility::set_vision_set( "whitehouse", 0 );	
	thread maps\_utility::vision_set_fog_changes( "whitehouse", 0 );
}

start_flare()
{
	spawn_team();
	dcwh_teleport_team( level.team, getstructarray( "flare_start_points", "targetname" ) );
	dcwh_teleport_player();

	chandelier_setup();
	vision_set_whitehouse();

/*
	start_node = getnode( "dunn_flare_path", "script_noteworthy" );
	level.dunn thread maps\_spawner::go_to_node( start_node );
	start_node = getnode( "foley_flare_path", "script_noteworthy" );
	level.foley thread maps\_spawner::go_to_node( start_node );
*/
	level thread whitehouse_dunn_flare();
//	level thread roof_flare_guy();
	level thread whitehouse_hammerdown();
	level thread whitehouse_radio();

	flag_set( "whitehouse_radio_start" );
	wait 0.1;
	level.countdown_index = 3;
	flag_set( "whitehouse_radio_done" );
	flag_clear( "broadcast" );

//	level.foley thread whitehouse_foley_flare();

	flag_wait( "whitehouse_hammerdown_jets_safe" );

	level.dunn.neverenablecqb = true;
	level.dunn disable_cqbwalk();
}

flare_main()
{
	level thread flare_dialogue();

//	flag_wait( "whitehouse_pop_flare" );
//	level.player thread whitehouse_player_flare();
}

flare_dialogue()
{
/*
	flag_wait( "whitehouse_hammerdown_jets_fly" );
	flag_wait_or_timeout( "whitehouse_pop_flare", 14 );

	// Pop the flares!!
	level.foley dialogue_queue( "dcemp_fly_poptheflares" );	
	flag_set( "whitehouse_pop_flare" );
*/

	flag_wait( "whitehouse_wrapup" );

	// What happens now?
	level.dunn dialogue_queue( "dcemp_cpd_happensnow" );	
	//This war ain't over yet Corporal...all we did was level the playing field. 
	level.foley dialogue_queue( "dcemp_fly_waraintover" );	
	//Everyone downstairs. Let's try and get the transmitter working on that radio. 
//	level.foley dialogue_queue( "dcemp_fly_backdownstairs" );	

	flag_set( "whitehouse_completed" );
}

// more or less a copy of whitehouse_dunn_flare()
roof_flare_guy()
{
//	flag_wait( "whitehouse_path_roof" );

	guy = spawn_targetname( "roof_flare_guy" );
	guy.animname = "flare_guy";

	animent = getent( "ramp_flare_animent_2", "targetname" );
//	animent anim_reach_solo( guy, "dcemp_flare_ai_start" );

	guy.neverenablecqb = true;
	guy disable_cqbwalk();

//	guy set_run_anim( "dcemp_flare_wave_run" );
	guy set_run_anim( "dcemp_flare_run" );
//	guy set_moveplaybackrate( 0.2 );

	animent anim_single_solo_run( guy, "dcemp_flare_ai_start" );
//	wait 0.5;
//	guy SetAnimTime( guy getanim( "dcemp_flare_ai_start" ), 0.6 );

//	it anim above gets threaded.
//	guy waittill( "dcemp_flare_ai_start" );

	idle = false;

	while ( true )
	{
		dist = distance( guy.origin, level.player.origin );
		if ( dist < 400 )
			break;

		if ( !idle )
		{
			idle = true;
			animent thread anim_loop_solo( guy, "dcemp_flare_ai_wait" ); // default ender notify stop_loop. call on animent
		}
		wait 0.05;
	}

	animent notify( "stop_loop" );
//	guy anim_stopanimscripted();

	animent = getent( "whitehouse_dunn_flare", "targetname" );
	animent thread anim_reach_solo( guy, "dcemp_flare_ai_end" );

	wait 3.5;
	guy Kill( animent.origin );

/*
	animent anim_reach_solo( guy, "dcemp_flare_ai_end" );
	guy clear_run_anim();
	guy.neverenablecqb = undefined;
	animent anim_single_solo( guy, "dcemp_flare_ai_end" );
*/
}

whitehouse_dunn_flare()
{
	level endon( "whitehouse_hammerdown" );
	flag_wait( "whitehouse_path_office_2" );

	// 30 seconds left when the are all dead.
	flag_set( "countdown" );

	// kill all axis in the 2:nd floor office area.
	axis = getaiarray( "axis" );
	foreach( ai in axis )
	{
		if ( isdefined( ai.script_noteworthy ) && ai.script_noteworthy == "whitehouse_office_enemy" )
			ai delayCall( randomfloat( 2 ), ::kill, level.dunn geteye() );
	}

	level.dunn notify( "stop_going_to_node" );
	animent = getent( "ramp_flare_animent", "targetname" );
	animent anim_reach_solo( level.dunn, "dcemp_flare_ai_start" );

	level.dunn.neverenablecqb = true;
	level.dunn disable_cqbwalk();

	level.dunn set_run_anim( "dcemp_flare_run" );
//	level.dunn set_run_anim( "dcemp_flare_wave_run" );
//	level.dunn set_moveplaybackrate( 0.2 );

	animent thread anim_single_solo_run( level.dunn, "dcemp_flare_ai_start" );
//	level.dunn SetAnim( level.dunn getanim( "dcemp_flare_ai_start" ), 1, 0, 0.2 );
	animent waittill( "dcemp_flare_ai_start" );

	idle = false;

	while ( !flag( "whitehouse_path_roof" ) )
	{
		sigth = player_looking_at( level.dunn.origin + (0,0,64), 0.8 );
		dist = distance( level.dunn.origin, level.player.origin );
		if ( ( sigth && ( dist < 320) ) || dist < 250 )
			break;

		if ( !idle )
		{
			idle = true;
			animent thread anim_loop_solo( level.dunn, "dcemp_flare_ai_wait" ); // default ender notify stop_loop. call on animent
		}
		wait 0.05;
	}

	animent notify( "stop_loop" );
	level.dunn anim_stopanimscripted();

	animent = getent( "whitehouse_dunn_flare", "targetname" );
/*
	animent thread anim_reach_solo( level.dunn, "dcemp_flare_ai_end" );
	wait 3.5;
	level.dunn stop_magic_bullet_shield();
	level.dunn Kill( animent.origin );
*/
	level thread hammerdown_safe_exploder();

	animent anim_reach_solo( level.dunn, "dcemp_flare_ai_end" );

	level.dunn clear_run_anim();
	level.dunn.neverenablecqb = undefined;
	animent anim_single_solo( level.dunn, "dcemp_flare_ai_end" );

	level.dunn notify( "remove_flare" );

	node = getnode( "dunn_safe_node", "script_noteworthy" );
	level.dunn maps\_spawner::go_to_node( node );

	wait 0.1;
	level.dunn flashBangStart( 6 );

	wait 10;
	flag_set( "whitehouse_wrapup" );
}

hammerdown_safe_exploder()
{
	level endon( "whitehouse_hammerdown" );

	wait 3;
	flag_set( "whitehouse_hammerdown_jets_safe" );
	flag_set( "whitehouse_hammerdown_jets_fly" );
	wait 2.5;
	exploder( "hammerdown" );

	earthquake( 0.1, 3, level.player.origin, 512 );
	wait 1;
	earthquake( 0.1, 3, level.player.origin, 512 );
	wait 1;
	earthquake( 0.15, 3, level.player.origin, 512 );
	wait 1;
	earthquake( 0.2, 3, level.player.origin, 512 );
	wait 1;
	earthquake( 0.25, 3, level.player.origin, 512 );
	wait 1;
	earthquake( 0.4, 5, level.player.origin, 512 );
	wait 1;
//	level.player ViewKick( 256, level.dunn.origin );
	level.player setstance( "crouch" );
	level.player ShellShock( "minor", 6, true );
	level.player disableweapons();
	level.foley flashBangStart( 7 );
	wait 5;
	level.player enableweapons();
}

whitehouse_player_flare()
{
	level endon( "whitehouse_hammerdown_started" );

	player_attached_use( &"SCRIPT_PLATFORM_HINTSTR_POPFLARE" );

	while( !level.player IsOnGround() )
		wait 0.05;

	lerp_time = 0.5;
	enablePlayerWeapons( false );
	level.player.rig = spawn_anim_model( "flare_rig", level.player.origin );
	level.player.rig hide();
	level.player.rig.angles = ( 0,180,0 );
	level.player.rig anim_first_frame_solo( level.player.rig, "flare");

	if ( !flag( "whitehouse_hammerdown" ) )
		flag_set( "whitehouse_hammerdown_stopped" );

	// get rid of the flare and release the player when he should die.
	level thread whitehouse_player_flare_death();

	level.player PlayerLinkToBlend( level.player.rig, "tag_player", lerp_time );
	wait lerp_time;
	level.player PlayerLinkToDelta( level.player.rig, "tag_player", 1, 20, 20, 20, 20 );

	movement_ent = level.player.rig spawn_tag_origin();
	movement_ent thread steer_player_rig();
	level.player.rig linkto( movement_ent );

	level.player.rig thread player_flare();
	level.player.rig show();
	movement_ent anim_single_solo( level.player.rig, "flare");

	flag_set( "flare_end_fx" );

	level.player Unlink();
	level.player.rig delete();
	enablePlayerWeapons( true );

	wait 3;
	flag_set( "whitehouse_wrapup" );
}

steer_player_rig()
{
	level endon( "flare_end_fx" );

	moveRate = 3;

	box1 = make_box( "flare_box1" );
	box2 = make_box( "flare_box2" );

	z_origin = level.player.origin[2];
	while( true )
	{
		wait( 0.05 );

		movement = level.player GetNormalizedMovement();
		//iprintlnbold( movement[ 0 ] + " : " + movement[ 1 ] );
		
		forward = anglesToForward( level.player.angles );
		right = anglesToRight( level.player.angles );
		
		forward *= movement[ 0 ] * moveRate;
		right *= movement[ 1 ] * moveRate;
		
		newLocation = self.origin + forward + right;
		newLocation = ( newLocation[ 0 ], newLocation[ 1 ], z_origin );

		if ( inside_box( newLocation, box1 ) || inside_box( newLocation, box2 ) )
			self MoveTo( newLocation, 0.05 );
	}
}

inside_box( new_origin, box )
{
	x = new_origin[0];
	y = new_origin[1];

	if ( x > box[0][0] )
		return false;
	if ( y > box[0][1] )
		return false;
	if ( x < box[1][0] )
		return false;
	if ( y < box[1][1] )
		return false;

	return true;
}

make_box( targetname_str )
{
	box = [];
	top = getstruct( targetname_str, "targetname" );
	bottom = getstruct( top.target, "targetname" );
	box[0] = top.origin;
	box[1] = bottom.origin;
	return box;
}

whitehouse_player_flare_death()
{
	level waittill( "whitehouse_hammerdown_death" );

	level.player Unlink();
	level.player.rig delete();
	enablePlayerWeapons( true );
}