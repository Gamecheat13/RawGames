//
// file: ber2_event1.gsc
// description: event 1 script for berlin2
// scripter: slayback
//

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\ber2;
#include maps\ber2_util;
#include maps\ber2_anim;
#include maps\_music;
#include maps\_busing;

#using_animtree( "generic_human" );

// -- STARTS --
// start at the very beginning of event 1
event1_start()
{	
	warp_players_underworld();
	warp_friendlies( "struct_event1_start_friends", "targetname" );
	warp_players( "struct_event1_start", "targetname" );
	set_color_chain( "trig_script_color_allies_b35" );
	
	level thread event1_intro_reznov_dialogue();
	level thread event1_intro_execution_vignette();

	level thread event1_setup();
}

// start just before the first dropdown (beginning of e1 combat)
event1_start_action()
{
	warp_players_underworld();
	warp_friendlies( "struct_event1_startaction_friends", "targetname" );
	warp_players( "struct_event1_startaction", "targetname" );
	set_color_chain( "trig_script_color_allies_b2" );
	
	level thread event1_setup();
}

// start on the stairs leading down to the second apartment
event1_start_apt2()
{
	warp_players_underworld();
	warp_friendlies( "struct_e1_apt2_friends", "targetname" );
	warp_players( "struct_e1_apt2", "targetname" );
	set_color_chain( "trig_script_color_allies_b5" );
	
	level thread event1_setup( false );
}

// start at the bank atrium after the first two sets of apartments
event1_start_atrium()
{
	warp_players_underworld();
	warp_friendlies( "struct_event1_before_atrium_friends", "targetname" );
	warp_players( "struct_event1_before_atrium", "targetname" );
	set_color_chain( "trig_script_color_allies_b9" );
	
	level thread event1_setup( false );
}

// start before the loading dock area
event1_start_loadingdock()
{
	GetEnt( "trig_script_color_allies_b13", "targetname" ) Delete();
	
	warp_players_underworld();
	warp_friendlies( "struct_start_loadingdock_friends", "targetname" );
	warp_players( "struct_start_loadingdock", "targetname" );
	set_color_chain( "trig_script_color_allies_b14" );
	
	level thread event1_setup( false );
}

// start outside the first set of buildings, on the street
event1_start_outside()
{
	GetEnt( "trig_script_color_allies_b18", "targetname" ) Delete();
	
	warp_players_underworld();
	warp_friendlies( "struct_event1_outside_friends", "targetname" );
	warp_players( "struct_event1_outside", "targetname" );
	set_color_chain( "trig_script_color_allies_b19" );
	
	level thread event1_setup( false );
}

// start outside at the schoolcircle
event1_start_street_regroup()
{
	warp_players_underworld();
	warp_friendlies( "struct_event1_street_regroup_friends", "targetname" );
	
	guys = [];
	guys = level.friends;
	
	spawners = GetEntArray( "spawner_outside_russian_1", "targetname" );
	nodes = GetNodeArray( "node_street_regroup", "targetname" );
	ASSERTEX( IsDefined( nodes ), nodes.size > 0, "Couldn't find nodes" );
	
	for( i = 0; i < 6; i++ )
	{
		guy = spawners[i] StalingradSpawn();
		if( spawn_failed( guy ) )
		{
			ASSERTMSG( "Key redshirt failed to spawn for the schoolcircle start spot setup." );
			return;
		}
		
		guy Teleport( nodes[i].origin, guy.angles );
		guys[guys.size] = guy;
	}
	
	// let aigroup threads catch the spawn
	wait( 0.05 );
	
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] thread magic_bullet_shield_safe();
		guys[i] SetGoalPos( guys[i].origin );
	}
	
	warp_players( "struct_event1_street_regroup", "targetname" );
	
	level thread event1_setup( false );
	
	building_collapse_street_executions();
}
// -- END STARTS --

event1_setup( doSneak )
{
	if( !IsDefined( doSneak ) )
	{
		doSneak = true;
	}
		
	set_objective( 0 );
	//TUEY Set Music State to "INTRO"
	setmusicstate("INTRO");
	
	thread event1_action();
	
	// ambient threads
	thread event1_fallingdebris_triggers_setup();
	thread event1_fallingsign();
	thread event1_random_arty_shake();
	thread event1_fakefire();
	thread event1_katyusha();
	thread event1_ambient_streetbattle_drones();
	
	// gameplay threads
	if( doSneak )
	{
		thread event1_aisneak_apt1();
	}
	
	thread event1_atrium_dialogue();
	thread event1_smoky_hallway();
	
	// vignette threads
	thread event1_knees_execution( "trig_e1_knees_execution" );
	
	thread loadingdock_dialogue();
	
	// street action
	thread street_action();
}

event1_ambient_streetbattle_drones()
{
	trigger_wait( "trig_script_color_allies_b16", "targetname" );
	level notify( "kill_e1_ambient_street_battle_drones" );
	
	kill_drones( "drone", "targetname", 0, 1 );
}

event1_intro_reznov_dialogue()
{
	level waittill( "controls_active" );
	
	// "Dimitri, are you ready?"
	level.sarge playsound_generic_facial( "Ber2_IGD_400A_REZN" );
}

// --- intro execution vignette ---
event1_intro_execution_vignette()
{
	flag_wait( "all_players_connected" );

	if( is_german_build() )
	{
		level thread intro_execution_runpast_colorchain();
		flag_set( "intro_execution_done" );
			
		// friendlies wait for a bit before wanting to move up
		wait( 1.5 );
		
		if( !flag( "intro_execution_friendlies_moveup" ) )
		{
			//set_color_chain( "trig_script_color_allies_b41" );
			flag_set( "intro_execution_friendlies_moveup" );
		}

		return;
	}

	level thread intro_execution_runpast_colorchain();
	level thread friendlies_intro_patrolwalk();
	level thread intro_execution_friends_dialogue();
	
	// battlechatter gets turned back on after sneaky action
	thread battlechatter_off( "allies" );
	thread battlechatter_off( "axis" );
	
	animSpot = getstruct_safe( "struct_intro_execution_animref", "targetname" );
	victimSpawner = getent_safe( animSpot.target, "targetname" );
	
	redshirtSpawners = GetEntArray( victimSpawner.target, "targetname" );
	ASSERTEX( redshirtSpawners.size == 3, "Couldn't find enough redshirt spawners for the intro execution vignette." );
	
	victim = victimSpawner spawn_ai();
	if ( spawn_failed( victim ) )
	{
		ASSERTMSG( "Intro execution vignette victim failed to spawn." );
		return;
	}
	
	victim.ignoreme = true;
	victim.anim_disableLongDeath = true;
	victim.pathenemyfightdist = 0;
	victim.pathenemylookahead = 0;
	victim.nodeathragdoll = true;
	victim.grenadeammo = 0;
	victim.dropweapon = 0;
	victim.animname = "introIGC_victim";
	victim.targetname = "introIGC_victim";
	victim animscripts\shared::DropAIWeapon();
	
	victim remove_gear();
	
	// give him a poppable helmet
	if( IsDefined( victim.hatModel ) )
	{
		if( victim.hatModel != "char_ger_wermachtwet_helm1" )
		{
			victim Detach( victim.hatModel, "" );
			victim.hatModel = "char_ger_wermachtwet_helm1";
			victim Attach( victim.hatModel, "" );
		}
	}
	else
	{
		victim.hatModel = "char_ger_wermachtwet_helm1";
		victim Attach( victim.hatModel, "" );
	}
	
	guys = [];
	
	for( i = 0; i < redshirtSpawners.size; i++ )
	{
		guy = redshirtSpawners[i] spawn_ai();
		
		if ( spawn_failed( victim ) )
		{
			ASSERTMSG( "Intro execution vignette redshirt failed to spawn from spawner at " + redshirtSpawners[i].origin );
			return;
		}
		
		guy thread magic_bullet_shield_safe();
		guy.ignoreme = true;
		guys[guys.size] = guy;
	}
	
	// clean up spawners
	thread delete_group( redshirtSpawners, 5 );
	victimSpawner thread scr_delete( 5 );
	
	for( i = 1; i < guys.size; i++ )
	{
		ASSERTEX( is_active_ai( guys[i] ), "One of the intro IGC friendlies can't be found." );
	}

	guys[0].animname = "introIGC_guy2";
	guys[1].animname = "introIGC_guy3";
	guys[2].animname = "introIGC_guy4";
	
	victim.executioner = guys[1];
	
	// animate the victim with his deathanim
	victim.deathanim = level.scr_anim["introIGC_victim"]["intro_igc"];
	newOrigin = GetStartOrigin( animSpot.origin, animSpot.angles, victim.deathanim );
	newAngles = GetStartAngles( animSpot.origin, animSpot.angles, victim.deathanim );
	victim Teleport( newOrigin, newAngles );
	
	// animate everyone in one-frame idles so we're ready to start on a dime
	animSpot thread anim_loop_solo( victim, "idle", undefined, "stop_idle_loop" );
	animSpot thread anim_loop( guys, "idle", undefined, "stop_idle_loop" );
	wait( 0.05 );
	
	// now wait for anim to start	
	trigger_wait( "trig_intro_executionvignette_start", "targetname" );

	animSpot notify( "stop_idle_loop" );
	array_thread( guys, ::anim_stopanimscripted );
	victim anim_stopanimscripted();
	
	// take guy2 out because his anim ends earlier
	allGuys = guys;
	guy2 = guys[0];
	guys = array_remove( guys, guy2 );
	
	level thread event1_introIGC_headshotFX( victim );
	victim thread event1_introIGC_victimDialogue();
	victim DoDamage( victim.health + 5, (0,0,0) );
	
	victim thread introIGC_victim_playerkill( allGuys );
	
	//animate redshirts
	guy2 thread intro_execution_guy_cleanup( 1 );
	guys[0] thread intro_execution_guy_cleanup( 2 );
	guys[1] thread intro_execution_guy_cleanup( 3 );
	animSpot thread anim_single_solo( guy2, "intro_igc" );
	animSpot thread anim_single( guys, "intro_igc" );
	
	guys[0] waittillmatch( "single anim", "end" );
	flag_set( "intro_execution_done" );
		
	// friendlies wait for a bit before wanting to move up
	wait( 1.5 );
	
	if( !flag( "intro_execution_friendlies_moveup" ) )
	{
		set_color_chain( "trig_script_color_allies_b41" );
		flag_set( "intro_execution_friendlies_moveup" );
	}
}

introIGC_victim_playerkill( redshirts )
{
	level endon( "intro_execution_done" );
	
	while( 1 )
	{
		self waittill( "damage", amount, attacker );
	
		if( IsPlayer( attacker ) )
		{
			break;
		}
	}
	
	level notify( "intro_execution_interrupted" );
	
	arcademode_assignpoints( "arcademode_score_assist", attacker );
	self anim_stopanimscripted();
	self startragdoll();
	
	for( i = 0; i < redshirts.size; i++ )
	{
		redshirts[i] anim_stopanimscripted();
		redshirts[i] SetGoalPos( self.origin );
		redshirts[i] notify( "single anim", "end" );
	}
}

event1_introIGC_victimDialogue()
{
	level endon( "intro_execution_interrupted" );
	
	self waittillmatch( "deathanim", "dialog" );
	self PlaySound( "Ber2_IGD_000A_GER1" );
	self waittillmatch( "deathanim", "dialog" );
	self PlaySound( "Ber2_IGD_002A_GER1" );
}

// just waits to see if we hit the color chain trigger that moves friendlies past the execution scene
intro_execution_runpast_colorchain()
{
	level endon( "intro_execution_friendlies_moveup" );
	
	trigger_wait( "trig_script_color_allies_b41", "targetname" );
	flag_set( "intro_execution_friendlies_moveup" );
}

friendlies_intro_patrolwalk()
{
	// introscreen doesn't show up on checkpoint restart
	doingIntroscreen = GetDvarInt( "introscreen" );
	if( IsDefined( doingIntroscreen ) && doingIntroscreen )
	{
		level waittill( "controls_active" );
	}
	
	trig = getent_safe( "trig_script_color_allies_b0", "targetname" );
	//trig notify( "trigger" );
	trig waittill( "trigger" );
	wait( 1.5 );
	
	friends = get_friends( false );
	array_thread( friends, ::scr_intro_patrolwalk );
	
	flag_wait( "intro_execution_friendlies_moveup" );
	
	friends = get_friends( false )
	array_thread( friends, ::scr_intro_patrolwalk_reset );
}

intro_execution_friends_dialogue()
{
	flag_wait_all( "intro_execution_friendlies_moveup", "intro_execution_done" );
	
	if( !flag( "aisneak_dialogue_thread_started" ) )
	{
		level.hero1 say_dialogue( "hero1", "notwar_murder", true );
	}
	
	if( !flag( "aisneak_dialogue_thread_started" ) )
	{
		wait( 1 );
	}
	
	if( !flag( "aisneak_dialogue_thread_started" ) )
	{
		sarge_giveorder( "how_you_end_a_war", true );
	}
	
	flag_set( "intro_execution_dialogue_done" );
}

scr_intro_patrolwalk()
{
	self.disableArrivals = true;
	self.disableExits = true;
	self thread set_generic_run_anim( "patrol_walk", true );
}

scr_intro_patrolwalk_reset()
{
	self.disableArrivals = false;
	self.disableExits = false;
	self thread clear_run_anim();
}

intro_execution_guy_cleanup( extraWait )
{
	self endon( "death" );
	
	self waittillmatch( "single anim", "end" );
	
	if( IsDefined( extraWait ) )
	{
		wait( extraWait );
	}
	
	self.goalradius = 24;
	self SetGoalNode( getnode_safe( self.target, "targetname" ) );
	
	self waittill( "goal" );
	
	self thread stop_magic_bullet_shield_safe();
	wait( 8 );
	
	while( is_active_ai( self ) )
	{
		playerCanSee = false;
		
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( SightTracePassed( players[i] GetEye(), self GetEye(), false, players[i] ) )
			{
				playerCanSee = true;
				break;
			}
		}
		
		if( !playerCanSee )
		{
			self bloody_death( true );
		}
		
		wait( 5 );
	}
}

event1_introIGC_gunshotFX( executioner )
{
	level endon( "intro_execution_interrupted" );
	
	PlayFxOnTag( level._effect["rifleflash"], executioner, "tag_flash" );
	wait( 0.2 );
	PlayFxOnTag( level._effect["rifle_shelleject"], executioner, "tag_brass" );
}

event1_introIGC_headshotFX( victim )
{
	level endon( "intro_execution_interrupted" );
	
	executioner = victim.executioner;
	
	victim waittillmatch( "deathanim", "head_shot" );
	
	victim thread animscripts\death::helmetPop();
	
	if( is_mature() )
	{
		forward = AnglesToForward( ( executioner GetTagAngles( "tag_flash" ) ) );
		PlayFX( level._effect["headshot"], victim GetTagOrigin( "J_Brow_LE" ), forward );
		victim PlaySound( "bullet_large_flesh" );
	
		wait( 0.3 );
		PlayFxOnTag( level._effect["bloodspurt"], victim, "J_Brow_LE" );
		wait( 1.6 );
		PlayFxOnTag( level._effect["bloodspurt"], victim, "J_Brow_LE" );
	}
}
// --- end intro IGC ---

event1_action()
{
	// kick off ambient stuff on the street
	level thread event1_rooftop_rockets();
	
	// send control to event 2 script when we hit a trigger
	trigger_wait( "trigger_objective1_reached", "targetname" );
	level thread maps\ber2_event2::event2_setup();
}

event1_random_arty_shake()
{
	wait( 0.1 );
	
	ender = "subway_gate_opened";
	level endon( ender );
	
	level.pauseRandomShake = false;
	
	minWait = 30;
	maxWait = 60;
	
	soundSpot = Spawn( "script_origin", ( 2023, 137, -104 ) );
	soundSpot thread event1_random_arty_shake_cleanup( ender );
	
	while( 1 )
	{
		wait( RandomIntRange( minWait, maxWait ) );
		
		if( !level.pauseRandomShake )
		{
			players = get_players();
			
			soundSpot PlaySound( "bomb_far" );
			
			//Kevin:  Notify to play arty hitting building
			level notify("ber2_earthquake");
			
			for( i = 0; i < players.size; i++ )
			{
				players[i] thread generic_rumble_loop( 5.4 );
				Earthquake( RandomFloatRange( .20, .25 ), 6, players[i].origin, 500 );
			}
		}
	}
}

event1_random_arty_shake_cleanup( ender )
{
	level waittill( ender );
	
	wait( 1 );
	
	if( IsDefined( self ) )
	{
		self Delete();
	}
}

event1_fakefire()
{
	if( IsDefined( level.clientscripts ) && level.clientscripts )
	{
		flag_set( "event1_fakefire_start" );
		clientNotify( "e1fs" );
	}
	else
	{
		firePoints = GetStructArray( "struct_e1_fakefire", "targetname" );
		ASSERTEX( IsDefined( firePoints ) && firePoints.size > 0, "Can't find fakefire points." );
	
		array_thread( firePoints, maps\ber2_fx::ambient_fakefire, "subway_gate_closed", true );
	}
}

event1_katyusha()
{
	level waittill ( "spawnvehiclegroup5" );
	
	wait( 0.1 );
	
	kat = getent_safe( "e1_ambient_katyusha", "targetname" );
	//kat transmittargetname(); 	// transmit target name to client, so we can get ent there...
	
	kat veh_stop_at_node( "node_katyusha_stop1", "script_noteworthy", 10, 10 );
	
	wait( 1.5 );
	
	// shoot rockets until we want to move on
	if( !flag( "street_charge_moveup1" ) )
	{
		//clientNotify( "katStart" );	// start clientside katyusha barrage

		while( !flag( "street_charge_moveup1" ) )
		{
			// rocket barrage
			//rocket_amount, targets, attack_range, dest_z_height
			targets = GetStructArray( "struct_e1_katyusha_target", "targetname" );
			kat maps\_katyusha::rocket_barrage( 10, targets, 600, 1800 );
				
			if( !flag( "street_charge_moveup1" ) )
			{
				wait( RandomIntRange( 5, 9 ) );
			}
		}
	}
	
	//clientNotify("katStop");	// kill clientside katyusha barrage
	
	// GTFO
	kat notify( "stop_rocket_barrage" );
	kat.rollingdeath = 1;
	kat ResumeSpeed( 11, 3, 3 );
	
	// wait for death node
	deathnode = getvehiclenode_safe( "node_katyusha_rocketdeath", "script_noteworthy" );
	deathnode waittill( "trigger" );
	
	// rocket death
	//rocketStart1 = ( 2854.3, 1112.2, 472 );
	//rocketStart2 = ( 2791.7, 1282.9, 472 );
	//rocketStart3 = ( 2724.7, 1473.8, 472 );
	rocketStart1 = ( 2328, 3654, 1020 );
	rocketStart2 = ( 2328, 3654, 844 );
	rocketStart3 = ( 2344, 3846, 684 );
	
	while( !OkTospawn() )
	{
		wait( 0.1 ); 
	}
	
	MagicBullet( "panzerschrek", rocketStart2, kat.origin );
	wait( 1.2 );
	MagicBullet( "panzerschrek", rocketStart1, kat.origin );
	wait( 0.85 );
	MagicBullet( "panzerschrek", rocketStart2, kat.origin );
	wait( 1.2 );
	
	// kill tank
	if( kat.health )
	{
		RadiusDamage( kat.origin, 10, kat.health + 1, kat.health + 1 );
	}
}

tank_idle_fire_turret( aimSpot, doRandomOffset )
{
	self endon( "death" );
	self endon( "stop_tank_idle_fire" );
	
	if( !IsDefined( aimSpot ) )
	{
		aimSpot = ( 1481, 175, -92 );
	}
	
	og_aimSpot = aimSpot;
	
	while( 1 )
	{
		if( IsDefined( doRandomOffset ) && doRandomOffset )
		{
			aimSpot = og_aimSpot + ( RandomFloatRange( -100, 100 ), RandomFloatRange( -100, 100 ), RandomFloatRange( -100, 100 ) );
		}
		
		self thread tank_fire_at_origin( aimSpot );
		wait( RandomIntRange( 4, 8 ) );
	}
}

event1_fallingsign()
{
	level endon( "subway_gate_closed" );
	
	trigger_wait( "trig_e1_rooftop_ambient", "targetname" );
	
	startOrg = ( 1881, -2096, 1625 );
	startAngles = ( 12.5, 131, 45.4 );
	endOrg = getstruct_safe( "struct_fallingsign_rocketImpact", "targetname" ).origin;
	
	thread fallingsign_dialogue();
	
	// fire preview rockets
	thread event1_fallingsign_preview_rockets();
	
	// let preview rockets go first
	wait( 0.8 );
	
	level.pauseRandomShake = true;
	
	// fire impact rocket
	event1_fallingsign_fire_rocket( startOrg, startAngles, endOrg, 1.5 );
	
	PlayFX( level._effect["fallingsign_exp"], endOrg );  // explosion FX
	//Kevin adding explosion sound
	explosion = getstruct( "struct_fallingsign_rocketImpact", "targetname" );
	playsoundatposition("explosion",explosion.origin);
	level thread event1_fallingsign_playersquake( startOrg );
	Earthquake( 0.4, 3, endOrg, 2048 );
	
	// 1-3 are left-right relative to how the player first sees them
	letter1 = GetEnt( "e1_rooftopsign_letter1", "targetname" );
	letter2 = GetEnt( "e1_rooftopsign_letter2", "targetname" );
	letter3 = GetEnt( "e1_rooftopsign_letter3", "targetname" );
	
	ASSERTEX( IsDefined( letter1 ), "Can't find rooftop letter 1!" );
	ASSERTEX( IsDefined( letter2 ), "Can't find rooftop letter 2!" );
	ASSERTEX( IsDefined( letter3 ), "Can't find rooftop letter 3!" );
	
	// now using animated version
	useAnim = true;	
	if( useAnim )
	{
		// animated version
		animSpot = getnode_safe( "node_sign_reference_origin", "targetname" );
		
		letter1.script_linkto = "e_jnt";
		letter2.script_linkto = "g_jnt";
		letter3.script_linkto = "n_jnt";
		
		level.fallingsign_letters = [];
		level.fallingsign_letters[0] = letter1;
		level.fallingsign_letters[1] = letter2;
		level.fallingsign_letters[2] = letter3;
		
		maps\_anim::anim_ents( level.fallingsign_letters, "sign_fall", undefined, undefined, animSpot, "fallingsign_controlmodel" );
		
		// delete letters
		thread delete_group( level.fallingsign_letters, 2 );
	}
	else
	{
		// scripted version
		wait( 0.7 );
		
		level thread event1_fallingsign_dropletter( letter2 );
		wait( 0.45 );
		level thread event1_fallingsign_dropletter( letter1 );
		wait( 0.25 );
		level thread event1_fallingsign_dropletter( letter3 );
	}
	
	level.pauseRandomShake = false;
	//TUEY SetMusicState to run the underscore
	setmusicstate("SIGN_FELL");
}

fallingsign_dialogue()
{
	wait( 2 );
	
	flag_wait( "intro_execution_dialogue_done" );
	
	if( !flag( "aisneak_dialogue_thread_started" ) )
	{
		// "This is madness - Our rockets are tearing the city apart!"
		level.hero1 playsound_generic_facial( "Ber2_IGD_006A_CHER" );
		// "Get inside."
		level.sarge playsound_generic_facial( "Ber2_IGD_007A_REZN" );
	}
	
	flag_set( "fallingsign_dialogue_done" );
}

event1_fallingsign_preview_rockets()
{
	numCycles = 9;
	moveTime = 1.1;
	
	startOrgs = [];
	startAngles = [];
	endOrgs = [];
	moveTimes = [];
	
	startOrgs[0] = ( 2597, -1076, 1305 );
	startAngles[0] = ( 2, 167, 18 );
	endOrgs[0] = ( -1131, -260, 1081 );
	moveTimes[0] = moveTime;
	
	startOrgs[1] = ( 2357, -1636, 1657 );
	startAngles[1] = ( 7, 131, 47 );
	endOrgs[1] = ( -299, 1148, 1113 );
	moveTimes[1] = moveTime;
	
	startOrgs[2] = ( 1929, -2064, 1625 );
	startAngles[2] = ( 5, 140, 44 );
	endOrgs[2] = ( -1111, 336, 1193 );
	moveTimes[2] = moveTime;
	
	cycles = 0;
	while( cycles < numCycles )
	{
		for( i = 0; i < startOrgs.size; i++ )
		{
			thread event1_fallingsign_fire_rocket( startOrgs[i], startAngles[i], endOrgs[i], moveTimes[i] );
		
			wait( RandomFloatRange( 0.25, 0.4 ) );
		}
		
		wait( RandomFloatRange( 0.45, 0.75 ) );
		cycles++;
	}
}

event1_fallingsign_fire_rocket( startOrg, startAngles, endOrg, moveTime )
{
	rocket = Spawn( "script_model", startOrg );
	rocket SetModel( "katyusha_rocket" );
	rocket.angles = startAngles;
	rocket playloopsound( "katy_rocket_run_sign" );
	
	PlayFxOnTag( level._effect["katyusha_rocket_trail"], rocket, "tag_origin" );
	thread play_sound_in_space( "katyusha_launch", rocket.origin );
	
	rocket notify( "rocket_fired" );
	rocket MoveTo( endOrg, moveTime );
	rocket waittill( "movedone" );
	// per Tuey: to mask a "pop" when the katy_rocket_run_sign loop ends
	thread play_sound_in_space( "katy_explode_dirt", rocket.origin );
	rocket Delete();
}

// wrapper functions to figure out which letter is detaching
fallingsign_detachN( parentModel )
{
	letter = level.fallingsign_letters[2];
	fallingsign_letter_detachFX( letter );
}
fallingsign_detachG( parentModel )
{
	letter = level.fallingsign_letters[1];
	fallingsign_letter_detachFX( letter );
}
fallingsign_detachE( parentModel )
{
	letter = level.fallingsign_letters[0];
	fallingsign_letter_detachFX( letter );
}
fallingsign_letter_detachFX( letter )
{
	PlayFX( level._effect["rooftopsign_breakaway_dust"], letter.origin );
}

trail_debug()
{
	self endon( "death" );
	
	while( 1 )
	{
		level thread trailprint( self.origin );
		wait( 0.1 );
	}
}

trailprint( drawOrigin )
{
	while( 1 )
	{
		print3D( drawOrigin, "*", (1,1,1), 1, 10 );
		wait( 0.05 );
	}
}

event1_fallingsign_playersquake( expOrg )
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread fallingsign_rumble();
		Earthquake( 0.55, 2.8, players[i].origin, 500 );
		//Kevin:  Notify to play arty hitting building before the sign falls.
		level notify("ber2_earthquake");
	}
}

fallingsign_rumble()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self PlayRumbleOnEntity( "explosion_generic" );
	wait( 0.2 );
	
	duration = 2;
	stopTime = GetTime() + ( duration * 1000 );
	
	while( GetTime() <= stopTime )
	{
		self PlayRumbleOnEntity( "damage_heavy" );
		wait( 0.05 );
	}
}

event1_fallingsign_dropletter( letter )
{
	rollAngle = RandomIntRange( 100, 130 );
	rollTime = RandomFloatRange( 0.7, 1 );
	accelTime = rollTime * 0.25;
	
	letter RotateRoll( rollAngle, rollTime, accelTime );
	wait( rollTime * 0.65 );
	
	PlayFX( level._effect["rooftopsign_breakaway_dust"], letter.origin );
	letter MoveGravity( ( 20, 20, -10 ), 3 );
	
	wait( 3.5 );
	letter Delete();
}

// spawnfunc
roof_ambient_runner()
{
	spot = getstruct_safe( "struct_roof_runners_target", "targetname" );
	target = Spawn( "script_origin", spot.origin );
	trig = getent_safe( "trig_roofrunner_startfiring", "targetname" );
	
	self.goalradius = 24;
	
	self thread roof_ambient_runner_shoot( target, trig );
	level thread roof_ambient_runner_spawners_delete();
	
	self waittill( "goal" );
	
	if( IsDefined( self ) )
	{
		self notify( "death" );
	}
	
	wait( 0.05 );
	target Delete();
	
	if( IsDefined( self ) )
	{
		self Delete();
	}
}

roof_ambient_runner_spawners_delete()
{
	if( IsDefined( level.roof_ambient_runner_spawners_delete ) )
	{
		return;
	}
	
	if( !IsDefined( level.roof_ambient_runner_spawners_delete ) )
	{
		level.roof_ambient_runner_spawners_delete = true;
	}
	
	wait( 4 );
	
	spawners = GetEntArray( "spawner_roof_ambientrunner", "targetname" );
	
	for( i = 0; i < spawners.size; i++ )
	{
		if( !is_active_ai( spawners[i] ) && IsDefined( spawners[i] ) )
		{
			spawners[i] Delete();
		}
	}
}

roof_ambient_runner_shoot( target, trig )
{
	self endon( "death" );
	
	while( !self IsTouching( trig ) )
	{
		wait( 0.05 );
	}
	wait( RandomFloat( 1 ) );
	
	self.ignoreall = false;
	self SetEntityTarget( target );
	
	wait( RandomFloatRange( 2, 5 ) );
	
	self ClearEntityTarget();
	self.ignoreall = true;
}

event1_fallingdebris_triggers_setup()
{
	trigs = GetEntArray( "trig_e1_fallingDebris", "targetname" );
	ASSERTEX( IsDefined( trigs ) && trigs.size > 0, "Can't find any falling debris triggers!" );
	
	array_thread( trigs, ::event1_fallingdebris_think );
}

// self = the trigger
event1_fallingdebris_think()
{
	level endon( "subway_gate_closed" );
	
	self waittill( "trigger" );
	
	ASSERTEX( IsDefined( self.target ), "falling debris target not found for trigger at origin " + self.origin );
	debrisGroup = GetEntArray( self.target, "targetname" );
	
	if( !IsDefined( debrisGroup ) || debrisGroup.size <= 0 )
	{
		ASSERTMSG( "falling debris not found for trigger at origin " + self.origin );
		return;
	}
	
	level.pauseRandomShake = true;
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread generic_rumble_loop( 1.35 );
		Earthquake( 0.5, 2, players[i].origin, 64 );
		//Kevin:  Notify to play arty hitting building with crashing debris.
		level notify("ber2_earthquake");
	}
	
	array_thread( debrisGroup, ::event1_fallingdebris_drop );
	
	level.pauseRandomShake = false;
	
	wait( 1 );
	self Delete();
}

// self = a piece of debris
event1_fallingdebris_drop()
{
	if( IsDefined( self.script_delay ) && self.script_delay >= 0 )
	{
		wait( self.script_delay );
	}
	else
	{
		wait( RandomFloatRange( 0.15, 0.45 ) );
	}
	
	PlayFX( level._effect["fallingboards_fire"], self.origin );
	wait( 0.25 );
	
	// turn off collision so we don't damage AIs
	self NotSolid();
	
	self PhysicsLaunch( ( RandomInt( 50 ), RandomInt( 50 ), RandomInt( 50 ) ), ( 0, 0, -15 ) );
	
	if( !IsDefined( level.boardsdropped ) )
	{
		level.boardsdropped = true;
		thread event1_fallingdebris_dialogue();
	}
}

event1_fallingdebris_dialogue()
{
	if( !level.coopOptimize )
	{
		redshirt = get_randomfriend_notsarge_excluding( level.hero1 );
		redshirt say_dialogue( "redshirt", "lookout", true, true );
	}
	sarge_giveorder( "watchyourheads", true );
	level.hero1 say_dialogue( "hero1", "building_collapsing" );
}

event1_smoky_hallway()
{
	level endon( "subway_gate_closed" );
	
	playervisiontrig = GetEnt( "trig_e1_hallway_smoke_hurt", "targetname" );
	areatrig = GetEnt( "trig_e1_hallway_smoke_area", "targetname" );
	
	ASSERTEX( IsDefined( playervisiontrig ), "Can't find the smoky hallway player vision changer trigger!" );
	ASSERTEX( IsDefined( areatrig ), "Can't find the smoky hallway area trigger!" );
	
	thread event1_smoky_hallway_playervision( playervisiontrig );
	thread event1_smoky_hallway_playerspeed( areatrig );
	thread event1_smoky_hallway_sargewarning( areatrig );
	
	while( 1 )
	{
		areatrig waittill( "trigger", guy );
		
		if( !IsAlive( guy ) )
		{
			continue;
		}
		
		guy thread ignore_triggers( 0.2 );  // let others trigger the trigger
		
		if( !IsPlayer( guy ) && is_active_ai( guy ) )
		{
			// don't kick off a new thread unless we have to
			if( !IsDefined( guy.smoky_hallway_crouched ) || !guy.smoky_hallway_crouched )
			{
				guy thread event1_smoky_hallway_aicrouch( areatrig );
			}
		}
	}
}

event1_smoky_hallway_playervision( trig )
{
	level endon( "subway_gate_closed" );
	
	timerLimit = 2;
	visionStayTime = 0.4;  // how long the effect will continue to last once players leave the trigger
	visionSetSmoke = "ber2_smoke_stand";
	//visionSetCrouch = "ber2_smoke_crouch";
	visionSetClear = "ber2_interior";
	visionTransInTime = 1;
	visionTransOutTime = 0.5;
	
	timeBetweenCoughs = 4 * 1000;
	
	numTimers = 0;
	
	while( 1 )
	{
		players = get_players();
		
		for( i = 0; i < players.size; i++ )
		{	
			if( !IsDefined( players[i].ber2_hallwaytimer ) )
			{
				players[i].ber2_hallwaytimer = "hallwaytimer_" + numTimers;
				numTimers++;
			}
			
			if( players[i] IsTouching( trig ) )
			{
				set_timer( players[i].ber2_hallwaytimer, timerLimit );
				players[i] thread player_vision_change( visionSetSmoke, visionSetClear, visionTransInTime, visionTransOutTime );
				
				if( !IsDefined( players[i].lastCough ) || ( ( GetTime() - players[i].lastCough ) > timeBetweenCoughs ) )
				{
					players[i].lastCough = GetTime();
					players[i] thread player_cough();
				}
				
				players[i].ber2_inSmoke = true;
			}
			else
			{
				if( !IsDefined( players[i].ber2_inSmoke ) || players[i].ber2_inSmoke )
				{
					set_timer( players[i].ber2_hallwaytimer, visionStayTime );
					players[i].ber2_inSmoke = false;
				}
			}
		}
		
		wait( 0.1 );
	}
}

player_cough()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	if( !IsDefined( self.isCoughing ) || !self.isCoughing )
	{
		self.isCoughing = true;
	}
	else
	{
		return;
	}
	
	coughType = "cough_a";
	if( RandomInt( 100 ) > 50 )
	{
		coughType = "cough_b";
	}
	
	self PlaySound( coughType, "cough_done" );
	self waittill( "cough_done" );
	
	self.isCoughing = false;
}

event1_smoky_hallway_playerspeed( areatrig )
{
	level endon( "subway_gate_closed" );
	
	baseSpeedScale = 1;
	speedScaleMultiplier = 0.76;
	
	while( 1 )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] IsTouching( areatrig ) )
			{
				if( !IsDefined( players[i].ber2_speedAdjust ) || !players[i].ber2_speedAdjust )
				{
					players[i].ber2_speedAdjust = true;
					players[i] thread adjust_hallway_playerspeed( areatrig, baseSpeedScale, speedScaleMultiplier );
				}
			}
		}
		
		wait( 0.1 );
	}
}

// self = a player
adjust_hallway_playerspeed( areatrig, baseSpeedScale, speedScaleMultiplier )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self thread scr_player_speedscale( ( baseSpeedScale * speedScaleMultiplier ), 1.5 );
	
	while( self IsTouching( areatrig ) )
	{
		wait( 0.1 );
	}
	
	// set speed back
	self thread scr_player_speedscale( baseSpeedScale, 1.2 );
	self.ber2_speedAdjust = false;
}

scr_player_speedscale( newSpeedScale, time )
{
	self notify( "end_speedscale" );
	self endon( "end_speedscale" );
	
	if( !IsDefined( self.speedscale ) )
	{
		self.speedscale = 1;
	}
	
	if( newSpeedScale == self.speedscale )
	{
		return;
	}
	
	self SetMoveSpeedScale( newSpeedScale );
	self.speedscale = newSpeedScale;
}

// self = a player
player_vision_change( visionSetChangeTo, visionSetChangeBack, visionTransInTime, visionTransOutTime )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	if( IsDefined( self.diffVisionOn ) && self.diffVisionOn )
	{
		return;
	}
	else
	{
		self.diffVisionOn = true;
	}
	
	self VisionSetNaked( visionSetChangeTo, visionTransInTime );
	
	while( !timer_expired( self.ber2_hallwaytimer ) )
	{
		wait( 0.1 );
	}
	
	self VisionSetNaked( visionSetChangeBack, visionTransOutTime );
	self.diffVisionOn = false;
}

// sarge tells the player to get down
event1_smoky_hallway_sargewarning( areatrig )
{
	level endon( "subway_gate_closed" );
	
	while( 1 )
	{
		areatrig waittill( "trigger", guy );
	
		if( IsPlayer( guy ) )
		{
			// we know a player is in the area, so send the notify
			level notify( "e1_smoky_hallway_start" );
			//Kevin's notify for the gramophone to start playing in the loading dock.
			SetClientSysState("levelNotify","requiem");
			
			thread smoky_hallway_dialogue();
			
			break;
		}
	}
}

smoky_hallway_dialogue()
{
	// "Stay low - Smoke can steal your breath."
	level.sarge playsound_generic_facial( "Ber2_IGD_051A_REZN" );
	
	// "I can barely see."
	level.hero1 thread playsound_generic_facial( "Ber2_IGD_052A_CHER" );
	wait( 1 );
	
	if( !level.coopOptimize )
	{
		// "I can hardly breathe."
		redshirt = get_randomfriend_notsarge_excluding( level.hero1 );
		redshirt playsound_generic_facial( "Ber2_IGD_053A_RUR1" );
	}
	
	// "Complaining will not help - just keep low."
	level.sarge playsound_generic_facial( "Ber2_IGD_054A_REZN" );
	
	// "In Stalingrad, Dimitri and I crawled through many smoke filled buildings."
	level.sarge playsound_generic_facial( "Ber2_IGD_055A_REZN" );
	
	// "Do you hear him complaining?"
	level.sarge playsound_generic_facial( "Ber2_IGD_056A_REZN" );
}

loadingdock_dialogue()
{
	flag_wait( "player_can_damage_artycrew" );
	
	// "We are almost at the street!"
	level.sarge playsound_generic_facial( "Ber2_IGD_057A_REZN" );
}

// self = an ai
event1_smoky_hallway_aicrouch( areatrig )
{
	self endon( "death" );
	
	self.smoky_hallway_crouched = true;
	
	// initial setup for hitting the trigger
	wait( RandomFloatRange( 0.25, 1.25 ) );  // we don't want them all doing the same thing at the same spot
	
	// play sfx of him coughing
	// sarge doesn't cough because he's tough like that
	if( self != level.sarge )
	{
		self thread ai_hallway_coughing();
	}
		
	self AllowedStances( "crouch" );
	self.moveplaybackrate = 1.5;
	
	// wait while in trigger, possibly do stuff like random coughing or bitching
	while( self IsTouching( areatrig ) )
	{
		wait( 1 );
	}
	
	self AllowedStances( "stand", "crouch", "prone" );
	self.moveplaybackrate = 1;
}

ai_hallway_coughing()
{
	numCoughs = RandomIntRange( 1, 3 );
	
	for( i = 0; i < numCoughs; i++ )
	{
		//iprintlnbold( self.name + " is coughing" );
			
		if( RandomInt( 100 ) > 50 )
		{
			coughType = "cough_player_a";
		}
		else
		{
			coughType = "cough_player_b";
		}
			
		self playsound_generic_facial( coughType );
		
		wait( RandomFloatRange( 0.35, 0.8 ) );
	}
}


// --- SNEAKY ACTION STUFF ---

event1_aisneak_apt1()
{
	flag_init( "aisneak_alarm_sounded" );
	flag_init( "aisneak_scene_finished" );
	
	trigger_wait( "trig_e1_aisneak_apt1", "targetname" );
	
	thread event1_aisneak_alarm_flag();
	thread event1_aisneak_sarge_dialogue();
	thread event1_aisneak_battlechatter();
	
	// setup friends & enemies for sneaking
	thread aisneak_friends_setup();
	thread aisneak_setup_enemies_apt1();
	
	thread aisneak_enemy_dialogue();
}

event1_aisneak_alarm_flag()
{
	level waittill( "sound_alarm" );
	flag_set( "aisneak_alarm_sounded" );
}

event1_aisneak_sarge_dialogue()
{
	flag_set( "aisneak_dialogue_thread_started" );
	
	flag_wait( "fallingsign_dialogue_done" );
	
	sarge_giveorder( "shhh", true );
	
	sarge_giveorder( "movequietly", true );
	
	flag_set( "aisneak_sarge_firstdialogue_done" );
	
	if( !flag( "aisneak_alarm_sounded" ) && !flag( "aisneak_scene_finished" ) )
	{
		waittill_either( "aisneak_alarm_sounded", "aisneak_scene_finished" );
	}
	
	if( flag( "aisneak_scene_finished" ) )
	{
		sarge_giveorder( "takethemdown", true );
	
		if( !flag( "aisneak_alarm_sounded" ) )
		{
			sarge_giveorder( "are_you_ready", true );
		}
		
		wait( 1 );
		level.sarge AllowedStances( "stand" );
		wait( 1 );
		// sarge gets impatient
		sarge_giveorder( "cut_them_down", true );
		array_thread( level.friends, ::scr_ignoreall, false );
		
		wait( 2 );
		sarge_giveorder( "kill_them_all" );
		level.sarge AllowedStances( "stand", "crouch", "prone" );
	}
	else
	{
		// alarm sounded, Germans are also talking right now, so wait to let them stop
		wait( 2 );
		sarge_giveorder( "kill_them_all" );
	}
	
	flag_wait( "aisneak_mapreaders_dead" );
	flag_wait( "aisneak_riflemen_dead" );
	flag_wait( "aisneak_telegrapher_dead" );
	
	wait 1;
	
	sarge_giveorder( "roomclear" );
}

event1_aisneak_battlechatter()
{
	thread battlechatter_off( "allies" );
	thread battlechatter_off( "axis" );
	
	level waittill( "sound_alarm" );
	
	thread battlechatter_on( "allies" );
	thread battlechatter_on( "axis" );
}

aisneak_friends_setup()
{
	allies = GetAIArray( "allies" );
	
	for( i = 0; i < allies.size; i++ )
	{
		allies[i].ignoreall = true;
		allies[i].cqbwalking = true;
	}
	
	thread aisneak_friends_reset();
}

aisneak_friends_reset()
{
	level waittill( "sound_alarm" );
	
	allies = GetAIArray( "allies" );
	
	for( i = 0; i < allies.size; i++ )
	{
		allies[i].ignoreall = false;
		allies[i].cqbwalking = false;
	}
}

aisneak_setup_enemies_apt1()
{
	// spawn guys separately
	level thread aisneak_setup_mapreaders();
	level thread aisneak_setup_riflemen();
	level thread aisneak_setup_telegrapher();
}

aisneak_enemy_dialogue()
{
	level endon( "sound_alarm" );
	
	trigger_wait( "trig_e1_aisneak_apt1", "targetname" );
	
	mapreader1 = level.mapreader1;
	mapreader2 = level.mapreader2;
	telegrapher = level.telegrapher;
	
	mapreader1 endon( "death" );
	mapreader2 endon( "death" );
	telegrapher endon( "death" );
	
	if( !IsDefined( mapreader1 ) || !IsDefined( mapreader2 ) || !IsDefined( telegrapher ) )
	{
		ASSERTMSG( "Can't find one of the apt 1 sneaky action AIs who need to say dialogue." );
		return;
	}
	
	flag_wait( "aisneak_sarge_firstdialogue_done" );
	
	// "Russische Soldaten zum fortzufahren, sich einwärts zu bewegen (Russian soldiers to continue to move inward)."
	mapreader1 playsound_generic_facial( "Ber2_IGD_012A_GMP1" );
	
	// "Wir werden fast vollständig umgeben. (We are nearly completely surrounded)."
	mapreader2 playsound_generic_facial( "Ber2_IGD_013A_GMP2" );
	
	// "Unsere Situation ist unhaltbar. (Our situation is untenable)."
	mapreader1 playsound_generic_facial( "Ber2_IGD_014A_GMP1", mapreader2 );
	
	// "Ist das, was Sie mich wünschen, zum des Generals zu erklären? (Is that what you want me to tell the General?)"
	telegrapher playsound_generic_facial( "Ber2_IGD_015A_TEOP", mapreader1 );
	
	// "Der General sollte bereits verwirklichen. (The General should already realize). "
	mapreader2 playsound_generic_facial( "Ber2_IGD_016A_GMP2", telegrapher );
	
	// "Es sei denn er wie das fuhrer arrogant ist. (Unless he shares the fuhrer's arrogance)."
	mapreader2 playsound_generic_facial( "Ber2_IGD_017A_GMP2", mapreader1 );
	
	// "Sie werden die Tunnels überschwemmen.  (Command has already given the order to flood the subway tunnels)."
	telegrapher playsound_generic_facial( "Ber2_IGD_018A_TEOP", mapreader1 );
	
	// "Sie fürchten sich, dass die Russen sie verwenden können, um das Konigsplatz zu erreichen…  (They fear the Russians may use them to reach the Konigsplatz...)"
	mapreader1 playsound_generic_facial( "Ber2_IGD_019A_GMP1", telegrapher );
	
	// "Gott helfen uns allen…  (God help us all...)"
	mapreader2 playsound_generic_facial( "Ber2_IGD_020A_GMP2", mapreader1 );
	
	wait( 1 );
	flag_set( "aisneak_scene_finished" );
}

aisneak_setup_mapreaders()
{
	mapreaders = SpawnStruct();
	mapreaders.guys = [];
	
	mapreader_spawners = GetEntArray( "spawner_aisneak_mapreaders_apt1", "script_noteworthy" );
	ASSERTEX( IsDefined( mapreader_spawners ) && mapreader_spawners.size > 1, "couldn't find the mapreader spawners!" );
 	array_thread( mapreader_spawners, ::spawner_think, mapreaders );
	array_thread( mapreader_spawners, ::aisneak_mapreader_setup );		
	mapreaders waittill( "spawned_guy" );
	waittillframeend;
	
	level thread aisneak_mapreaders_anims( mapreaders.guys );
	
	thread delete_group( mapreader_spawners, 5 );
	
	mapreaders.guys = remove_dead_from_array( mapreaders.guys );
	waittill_dead( mapreaders.guys );
	
	flag_set( "aisneak_mapreaders_dead" );
}

aisneak_setup_riflemen()
{
	riflemen = SpawnStruct();
	riflemen.guys = [];
	
	riflemen_spawners = GetEntArray( "spawner_aisneak_riflemen_apt1", "script_noteworthy" );
	ASSERTEX( IsDefined( riflemen_spawners ) && riflemen_spawners.size > 1, "couldn't find the riflemen spawners!" );
	array_thread( riflemen_spawners, ::spawner_think, riflemen );
	array_thread( riflemen_spawners, ::aisneak_rifleman_setup );
	riflemen waittill( "spawned_guy" );
	waittillframeend;
	
	animnames[0] = "rifleman1";
	animnames[1] = "rifleman2";
	animnames[2] = "rifleman3";
	
	guys = riflemen.guys;
	for( i = 0; i < guys.size; i++ )
	{
		guys[i].animSpot = getstruct_safe( guys[i].target, "targetname" );
		guys[i].animSpot.origin = groundpos( guys[i].animSpot.origin );
		guys[i].animname = animnames[i];
		guys[i] thread aisneak_rifleman_anim();
	}
	
	thread delete_group( riflemen_spawners, 5 );
	
	guys = remove_dead_from_array( guys );
	if( guys.size > 0 )
	{
		waittill_dead( guys );
	}
	
	flag_set( "aisneak_riflemen_dead" );
}

aisneak_rifleman_anim()
{
	self endon( "death" );
	
	self.ignoreme = true;
	self.ignoreall = true;
	self.goalradius = 24;
	
	self.animSpot thread anim_loop_solo( self, "loop", undefined, "stop_looping_anim" );
	level waittill( "sound_alarm" );
	self.animSpot notify( "stop_looping_anim" );
	
	if( is_active_ai( self ) )
	{
		self.animSpot anim_single_solo( self, "reaction" );
	}
	
	if( is_active_ai( self ) )
	{
		self.goalradius = 350;
		self.ignoreall = false;
		self.ignoreme = false;
	}
}

aisneak_setup_telegrapher()
{
	telegrapher_spawner = GetEnt( "spawner_aisneak_telegrapher_apt1", "script_noteworthy" );
	ASSERTEX( IsDefined( telegrapher_spawner ), "couldn't find the telegrapher spawner!" );
	telegrapher_spawner thread aisneak_telegrapher_setup();
	telegrapher_spawner waittill( "spawned", telegrapher );
	waittillframeend;
	
	level.telegrapher = telegrapher;
	
	level thread aisneak_telegrapher_anims( telegrapher );
	
	telegrapher_spawner thread scr_delete( 5 );
	
	while( is_active_ai( telegrapher ) )
	{
		wait( 0.1 );
	}
	
	flag_set( "aisneak_telegrapher_dead" );
}

aisneak_mapreader_setup()
{
	mapreader = self DoSpawn();	
	if( spawn_failed( mapreader ) )
	{
		ASSERTMSG( "mapreader spawn failed!" );
		return;
	}
	
	mapreader endon( "death" );
	
	//mapreader.ignoreall = true;
	mapreader thread stop_ignoring_player_when_shot( "sound_alarm" );
	
	level waittill( "sound_alarm" );
	
	if( is_active_ai( mapreader ) )
	{
		mapreader.ignoreall = false;
	}
}

aisneak_rifleman_setup()
{
	rifleman = self DoSpawn();
	if( spawn_failed( rifleman ) )
	{
		ASSERTMSG( "rifleman spawn failed!" );
		return;
	}
	
	rifleman thread stop_ignoring_player_when_shot( "sound_alarm", undefined, true );
	
	level waittill( "sound_alarm" );
	
	if( is_active_ai( rifleman ) )
	{
		rifleman.ignoreall = false;
	}
}

fire_at_targets( targets, ender )
{
	self endon( "death" );
	level endon( ender );
	
	org = Spawn( "script_origin", targets[0].origin );
	
	while( 1 )
	{
		targets = array_randomize( targets );
		
		for( i = 0; i < targets.size; i++ )
		{
			self SetEntityTarget( org );
			wait( 1 );
			
			org MoveTo( targets[i].origin, 5 );
			org waittill( "movedone" );
		}
	}
}

aisneak_telegrapher_setup()
{
	waittillframeend;  // HACK asynchronous threading issue
	
	telegrapher = self DoSpawn();
	if( spawn_failed( telegrapher ) )
	{
		ASSERTMSG( "telegrapher spawn failed!" );
		return;
	}
	
	//telegrapher.ignoreall = true;
	telegrapher thread stop_ignoring_player_when_shot( "sound_alarm" );
	
	level waittill( "sound_alarm" );
	
	if( IsDefined( telegrapher ) )
	{
		telegrapher.ignoreall = false;
	}
}

aisneak_mapreaders_anims( guys )
{
	guy1 = guys[0];
	guy2 = guys[1];
	
	node1 = GetNode( guy1.target, "targetname" );
	node2 = GetNode( guy2.target, "targetname" );
	
	ASSERTEX( IsDefined( guy1 ) && IsDefined( guy2 ), "Couldn't find one of the mapreaders!" );
	ASSERTEX( IsDefined( node1 ) && IsDefined( node2 ), "Couldn't find one of the mapreader nodes!" );
	
	guy1.animname = "mapreader1";
	guy2.animname = "mapreader2";
	
	level.mapreader1 = guy1;
	level.mapreader2 = guy2;
	
	node1 thread anim_loop_solo( guy1, "readingmap", undefined, "stop_mapreading" );
	node2 thread anim_loop_solo( guy2, "readingmap", undefined, "stop_mapreading" );
	
	level waittill( "sound_alarm" );
	node1 notify( "stop_mapreading" );
	node2 notify( "stop_mapreading" );
	
	if( IsDefined( guy1 ) && IsAlive( guy1 ) )
	{
		node1 thread anim_single_solo( guy1, "readingmap_surprise" );
	}
	
	if( IsDefined( guy2 ) && IsAlive( guy2 ) )
	{
		node2 thread anim_single_solo( guy2, "readingmap_surprise" );
	}
}

aisneak_telegrapher_anims( guy )
{
	chair = getent_safe( "e1_telegrapher_chair", "targetname" );
	chairclip = getent_safe( chair.target, "targetname" );
	
	ASSERTEX( IsDefined( guy ), "Couldn't find the telegrapher!" );
	ASSERTEX( IsDefined( chair ), "Couldn't find the telegrapher's chair!" );
	
	chair NotSolid();
	
	// start telegraph sound
	telegraph = GetEnt( "telegraph","targetname" );
	telegraph PlayLoopSound( "morse_code" );
	
	guy.animname = "telegrapher";
	guy.nodeathragdoll = true;
	guy.deathanim = level.scr_anim["telegrapher"]["tapping_death"];
	guy.telegraph = telegraph;
	
	level thread telegrapher_stoptapping_ondeath( guy );
	chair thread telegrapher_chair_anims( guy );
	chair thread anim_loop_solo( guy, "tapping", "tag_align", "stop_telegraphing" );
	
	level waittill( "sound_alarm" );
	chair notify( "stop_telegraphing" );
	
	if( IsDefined( guy ) && IsAlive( guy ) )
	{
		guy.deathanim = undefined;
		guy thread telegrapher_stoptapping();
		chair anim_single_solo( guy, "tapping_surprise", "tag_align" );
		
		// only delete the chair clip if the guy kicks it out of the way
		chairclip ConnectPaths();
		chairclip Delete();
	}
}

telegrapher_stoptapping_ondeath( telegrapher )
{
	telegrapher waittill( "death" );
	telegrapher telegrapher_stoptapping();
}

telegrapher_stoptapping()
{
	// stop telegraph sound
	self.telegraph StopLoopSound();
}
// --- END SNEAKY ACTION STUFF ---


// --- KNEES EXECUTION VIGNETTE ---

event1_knees_execution( triggerTN )
{	
	trig = GetEnt( triggerTN, "targetname" );
	ASSERTEX( IsDefined( trig ), "trigger can't be found." );
	
	animSpot = GetStruct( trig.target, "targetname" );
	ASSERTEX( IsDefined( animSpot ), "anim spot (targetname " + trig.target + ") can't be found." );
	watcherSpot = GetStruct( animSpot.target, "targetname" );
	ASSERTEX( IsDefined( watcherSpot ), "anim spot (targetname " + animSpot.target + ") can't be found." );
	
	trig waittill ("trigger");
	trig Delete();
	
	thread event1_knees_execution_interruptflag();
	
	// spawn the guys
	victim_spawner = GetEnt( "e1_execution_friendly_spawner", "targetname" );
	executioner_spawner = GetEnt( "e1_execution_enemy_spawner", "targetname" );
	watcher_spawner = GetEnt( "e1_execution_enemy_watcher_spawner", "targetname" );
	
	// spawn victim
	victim = victim_spawner spawn_ai();
	if ( spawn_failed( victim ) )
	{
		ASSERTMSG( "Key friendly failed to spawn." );
		return;
	}
	victim thread magic_bullet_shield_safe();
	victim.ignoreme = true;
	victim.anim_disableLongDeath = true;
	victim.nodeathragdoll = true;
	victim.grenadeammo = 0;
	victim.dropweapon = 0;
	victim.og_pathenemyfightdist = victim.pathenemyfightdist;
	victim.og_pathenemylookahead = victim.pathenemylookahead;
	victim.og_goalheight = victim.goalheight;
	victim.og_goalradius = victim.goalradius;
	victim.og_animname = victim.animname;
	victim.pathenemyfightdist = 0;
	victim.pathenemylookahead = 0;
	victim.goalheight = 64;
	victim.goalradius = 32;
	victim.animname = "knees_execution_victim";
	victim.targetname = "knees_execution_guys";
	
	victim remove_gear();
	
	// spawn executioner
	executioner = executioner_spawner spawn_ai();
	if ( spawn_failed( executioner ) )
	{
		ASSERTMSG( "Key enemy failed to spawn." );
		return;
	}
	executioner.ignoreme = true;
	executioner.og_goalradius = executioner.goalradius;
	executioner.og_animname = executioner.animname;
	executioner.og_health = executioner.health;
	executioner.goalradius = 32;
	executioner.animname = "knees_execution_executioner";
	executioner.targetname = "knees_execution_guys";
	executioner.victim = victim;
	executioner.allowdeath = true;
	executioner.health = 1;
	
	victim.executioner = executioner;
	
	// kick off the victim/executioner anims
	level thread event1_knees_execution_2man_anims( victim, executioner, animSpot );
	
	// spawn watcher
	watcher = watcher_spawner spawn_ai();
	if ( spawn_failed( watcher ) )
	{
		ASSERTMSG( "Key enemy failed to spawn." );
		return;
	}
	watcher.ignoreme = true;
	watcher.og_goalradius = watcher.goalradius;
	watcher.og_animname = watcher.animname;
	watcher.goalradius = 32;
	watcher.animname = "mapreader2";
	watcher.targetname = "knees_execution_guys";
	watcher animscripts\shared::placeWeaponOn( victim.executioner.sidearm, "right" );
	
	level thread watcher_alarm_on_death( watcher, "execution_interrupted" );
	watcher thread stop_ignoring_player_when_shot( "execution_interrupted" );
	watcher thread event1_knees_execution_watcher_anims( watcherSpot, "execution_interrupted", victim );
	
	// clean up spawners
	victim_spawner thread scr_delete( 5 );
	executioner_spawner thread scr_delete( 5 );
	watcher_spawner thread scr_delete( 5 );
}

// tells the watcher that something else is interrupting the execution
event1_knees_execution_interruptflag()
{
	level endon( "execution_done" );
	
	level waittill( "execution_interrupted" );
	
	if( !flag( "execution_interrupted" ) )
	{
		flag_set( "execution_interrupted" );
	}
}

event1_knees_execution_2man_anims( victim, executioner, animSpot )
{	
	victim thread event1_knees_execution_victim_saved( executioner, animSpot );
	
	knees_execution_guys_array = [];
	knees_execution_guys_array[0] = victim;
	knees_execution_guys_array[1] = executioner;
	
	// run the anim
	animSpot thread anim_single( knees_execution_guys_array, "execute" );
	animSpot thread victim_death( victim );
}

// self = the victim
event1_knees_execution_victim_saved( executioner, animSpot )
{
	self endon( "death" );
	level endon( "execution_done" );
	
	while( !flag( "execution_interrupted" ) && IsAlive( executioner ) )
	{
		wait( 0.05 );
	}
	
	if( !flag( "execution_interrupted" ) )
	{
		flag_set( "execution_interrupted" );
	}
	
	if( IsAlive( executioner ) )
	{
		executioner thread event1_knees_executioner_reset();
	}
	
	self StopAnimScripted();
	animSpot anim_single_solo( self, "saved_getup" );  // you're saved, get up
	
	// set values back
	self.pathenemyfightdist = self.og_pathenemyfightdist;
	self.pathenemylookahead = self.og_pathenemylookahead;
	self.goalheight = self.og_goalheight;
	self.animname = self.og_animname;
	self.anim_disableLongDeath = false;
	
	// if not coop...
	if( !level.coopOptimize )
	{
		// add to level.friends and the color chain
		self friend_add();
		self set_force_color( "b" );
	}
	
	// find a cover node
	self.goalradius = 4;
	self SetGoalNode( GetNode( "auto736", "targetname" ) );
	self waittill( "goal" );
	self.goalradius = self.og_goalradius;
	
	// give him a fighting chance
	wait( 2 );
	self.ignoreme = false;
	self thread stop_magic_bullet_shield_safe();
	self.allowdeath = true;
	
	// if coop, kill him off
	if( level.coopOptimize )
	{
		wait( 5 );
		self thread bloody_death( true, 1 );
	}
}

event1_knees_executioner_reset()
{
	self endon( "death" );
	self StopAnimScripted();
	
	self.goalradius = self.og_goalradius;
	self.health = self.og_health;
	self.animname = self.og_animname;
	
	wait( 1 );
	self.ignoreme = false;
}

// self = the animspot
victim_death( victim )
{
	level endon( "execution_interrupted" );
	
	// wait for the headshot notetrack
	victim.executioner waittillmatch( "single anim", "shot_in_the_head" );
	flag_set( "execution_done" );
	
	victim thread stop_magic_bullet_shield_safe();
	victim DoDamage( victim.health + 5, ( 0, 0, 0 ) );
	
	// wait for the shooting animation to finish
	victim waittillmatch( "single anim", "end" );
}

watcher_alarm_on_death( watcher, alarm )
{
	level endon( "execution_interrupted" );
	level endon( "execution_done" );
	
	watcher waittill( "death" );
	wait( 0.21 );
	level notify( alarm );
}

// self = the guy watching the execution
event1_knees_execution_watcher_anims( animSpot, notifystring, victim )
{
	self endon( "death" );
	
	// watching loop
	animSpot thread anim_loop_solo( self, "readingmap", undefined, "execution_watcher_stoploop", undefined );
	
	while( !flag( "execution_interrupted" ) && !flag( "execution_done" ) )
	{
		wait( 0.05 );
	}
	
	// stop the loop
	animSpot notify( "execution_watcher_stoploop" );
	self notify( "bulletwhizby" );
	
	// if the player interrupted it...
	if( flag( "execution_interrupted" ) )
	{
		// play surprised anim
		animSpot thread anim_single_solo( self, "readingmap_surprise" );
		self PlaySound( "Ber2_IGD_036A_GER3" );  // "The Russians!"
		self waittillmatch( "single anim", "end" );
	}
	
	// reset values
	self.ignoreme = false;
	self.animname = self.og_animname;
	
	// get ready for pathfinding
	self.goalradius = 128;
	
	// if the player interrupted it...
	if( flag( "execution_interrupted" ) )
	{
		// attack the closest player!
		self SetGoalPos( get_closest_player( self.origin ).origin );
	}
	else
	{
		// head for cover
		self SetGoalNode( GetNode( "auto723", "targetname" ) );
	}
	
	// reset pathfinding values
	self waittill( "goal" );
	self.goalradius = self.og_goalradius;
}

event1_knees_execution_gunshotFX( executioner )
{
	executioner endon( "death" );
	
	PlayFxOnTag( level._effect["rifleflash"], executioner, "tag_flash" );
	wait( 0.2 );
	PlayFxOnTag( level._effect["rifle_shelleject"], executioner, "tag_brass" );
}

// not really a headshot anymore, ah well
event1_knees_execution_headshotFX( executioner )
{
	executioner endon( "death" );
	
	victim = executioner.victim;
	victimFXTag = "J_Clavicle_RI";  // used to be "J_Brow_RI"
	
	if( is_mature() )
	{
		forward = AnglesToForward( ( executioner GetTagAngles( "tag_flash" ) ) );
		backward = forward * -1;
		PlayFX( level._effect["headshot"], victim GetTagOrigin( victimFXTag ), forward );
		PlayFX( level._effect["headshot"], victim GetTagOrigin( victimFXTag ), backward );
		victim PlaySound( "bullet_large_flesh" );
	
		wait( 0.3 );
		PlayFxOnTag( level._effect["bloodspurt"], victim, victimFXTag );
		wait( 1.6 );
		PlayFxOnTag( level._effect["bloodspurt"], victim, victimFXTag );
	}
	
}
// --- END KNEES EXECUTION VIGNETTE ---

event1_atrium_dialogue()
{
	level endon( "subway_gate_closed" );
	level endon( "atrium_mger_done" );
	
	trigger_wait( "trig_script_color_allies_b10", "targetname" );
	
	// "The area is heavily defended!"
	level.sarge playsound_generic_facial( "Ber2_IGD_042A_REZN" );
	wait( 2 );
	// "Someone, throw a Molotov down there - Burn them!"
	level.sarge playsound_generic_facial( "Ber2_IGD_043A_REZN" );
	
	trigTN = "e1_blocker_audioprompt";
	trigger_wait( trigTN, "targetname" );
	
	// "MG42!"
	level.hero1 playsound_generic_facial( "Ber2_IGD_045A_CHER" );
	// "Head on attack is impossible!"
	level.sarge playsound_generic_facial( "Ber2_IGD_046A_REZN" );
	// "We'll keep fire on him!"
	level.hero1 playsound_generic_facial( "Ber2_IGD_047A_CHER" );
	// "Move upstairs! Flank them from above!"
	level.sarge playsound_generic_facial( "Ber2_IGD_048A_REZN" );
	
	wait( 10 );
	trigger_wait( trigTN, "targetname" );
	
	// "Find another way!"
	level.scr_sound["hero1"]["find_another_way"] = "Ber2_IGD_049A_REZN";
}

// --- SCRIPTED MGERS ---
// spawnfunc
// self = the atrium MGer
event1_atrium_mger()
{
	//TUEYS HACK to get music in tonight!  
	setmusicstate("BANK");
	
	alertNotify = "atrium_mg_alert";
	killTrig = getent_safe( "trig_script_color_allies_b14", "targetname" );
	
	self.scripted_mger_getawayTime = 5;
	
	level thread event1_atrium_mger_alert( alertNotify );
	level thread event1_atrium_mger_alertflag( alertNotify );
	level thread event1_atrium_mger_friendlies( self, alertNotify );
	level thread scripted_mger_think( self, alertNotify, killTrig, true, ( 3792, -1876, -12 ), false );
}

event1_atrium_mger_alert( alertNotify )
{
	trigger_wait( "trig_script_color_allies_b13", "targetname" );
	wait( 1.5 );
	level notify( alertNotify );
}

event1_atrium_mger_alertflag( alertNotify )
{
	level waittill( alertNotify );
	flag_set( "atrium_mger_alerted" );
}

event1_atrium_mger_friendlies( mger, alertNotify )
{
	while( is_active_ai( mger ) && !flag( "atrium_mger_alerted" ) )
	{
		wait( 0.1 );
	}
	
	level notify( "atrium_mger_done" );
	
	// "Good work."
	level.sarge playsound_generic_facial( "Ber2_IGD_050A_REZN" );
	
	// move friendlies up
	if( IsDefined( GetEnt( "trig_script_color_allies_b13", "targetname" ) ) )
	{
		set_color_chain( "trig_script_color_allies_b13" );
	}
	
	// remove hallway color chain, if possible
	chaintrig = GetEnt( "trig_script_color_allies_b12", "targetname" );
	if( IsDefined( chaintrig ) )
	{
		chaintrig Delete();
	}
}

// spawnfunc
// self = the balcony MGer
event1_balcony_mger()
{
	// BJoyal - weird things happen when you throw a grenade at him.  Turning off grenade awareness
	self.grenadeawareness = 0;
	self.ignoreall = true;
	
	alertNotify = "balcony_mg_alert";
	killTrig = getent_safe( "trig_script_color_allies_b10", "targetname" );
	
	level thread event1_balcony_mger_alert( alertNotify );
	level thread scripted_mger_think( self, alertNotify, killTrig, true, ( 1148, -1108, 440 ) );
}

event1_balcony_mger_alert( alertNotify )
{
	trigger_wait( "trig_killspawner_3", "targetname" );
	wait( 0.75 );
	level notify( alertNotify );
}

scripted_mger_think( guy, alertNotify, killTrig, killAtEnd, goalPos, scaredOfPlayer )
{
	if( !IsDefined( scaredOfPlayer ) )
	{
		scaredOfPlayer = false;
	}
	
	guy.ignoreme = true;
	guy.anim_disableLongDeath = true;
	guy.og_pathenemyfightdist = guy.pathenemyfightdist;
	guy.og_pathenemylookahead = guy.pathenemylookahead;
	guy.pathenemyfightdist = 0;
	guy.pathenemylookahead = 0;
	
	if( !IsDefined( guy.proxAlertDist ) )
	{
		guy.proxAlertDist = 96;
	}
	
	guy.alerted = false;
	
	node = getnode_safe( guy.target, "targetname" );
	turret = getent_safe( node.target, "targetname" );
	
	targets = undefined;
	if( IsDefined( turret.target ) )
	{
		targets = GetEntArray( turret.target, "targetname" );
	}
	
	guy thread scripted_mger_catch_alert( alertNotify );
	guy thread scripted_mger_kill( alertNotify, killTrig );
	
	if( scaredOfPlayer )
	{
		guy thread stop_ignoring_player_when_shot( alertNotify, undefined, true );
	}
	
	level thread maps\_mgturret::mg42_setdifficulty( turret, GetDifficulty() );
	turret SetMode( "auto_ai" );
	turret SetTurretIgnoreGoals( true );
		
	while( IsDefined( guy ) && IsAlive( guy ) && !guy.alerted && IsDefined( turret ) )
	{
		if( !IsDefined( guy GetTurret() ) )
		{
			guy UseTurret( turret );
		}
		
		level waittill_notify_or_timeout( alertNotify, 0.05 );
	}
	
	if( IsDefined( turret ) )
	{
		turret SetMode( "manual_ai" );
	}
	
	if( is_active_ai( guy ) )
	{
		guy StopUseTurret();
		guy.pacifist = 0;
		guy.ignoreall = false;
		guy.ignoreme = false;
		guy.pathenemyfightdist = guy.og_pathenemyfightdist;
		guy.pathenemylookahead = guy.og_pathenemylookahead;
	}
	
	if( is_active_ai( guy ) && IsDefined( goalPos ) )
	{
		guy.goalradius = 96;
		guy SetGoalPos( goalPos );
		guy waittill( "goal" );
	}
	
	if( is_active_ai( guy ) && IsDefined( goalPos ) )
	{
		guy.anim_disableLongDeath = false;
		
		if( !IsDefined( guy.scripted_mger_getawayTime ) )
		{
			guy.scripted_mger_getawayTime = 10;
		}
		
		wait( guy.scripted_mger_getawayTime );
	}
	
	if( !IsDefined( killAtEnd ) )
	{
		killAtEnd = true;
	}
	
	if( is_active_ai( guy ) && killAtEnd )
	{
		guy thread bloody_death( true );
	}
	
	wait( 1 );
	if( IsDefined( targets ) )
	{
		thread delete_group( targets );
	}
}

scripted_mger_catch_alert( alertNotify )
{
	self endon( "death" );
	
	level waittill( alertNotify );
	self.alerted = true;
}

scripted_mger_kill( alertNotify, trig )
{
	self endon( "death" );
	level endon( alertNotify );
	
	trig waittill( "trigger" );
	
	if( IsDefined( self ) && IsAlive( self ) )
	{
		self thread bloody_death( true );
	}
}
// --- END SCRIPTED MGERS ---


// self = an AI
event1_loadingdock_patroller()
{
	self endon( "death" );
	
	self waittill( "enemy" );
	
	// send them to their last node on the chain
	node = GetNode( self.target, "targetname" );
	while( IsDefined( node ) )
	{
		if( IsDefined( node.target ) )
		{
			node = GetNode( node.target, "targetname" );
		}
		else
		{
			self SetGoalNode( node );
			break;
		}
	}
	
	self.ignoreall = false;
	self.maxsightdistsqrd = 1024*1024;	
	self.pacifist = false;
}

// --- STREET ACTION ---
street_action()
{
	thread street_action_tanks();
	thread street_bank_window();
	thread street_ambient_rockets();
	thread street_fakefire();
	
	thread building_collapse_setup();
	
	flag_wait( "player_outside" );
	set_objective( 1 );
	
	// wet up the friendlies
	level thread ais_wetness_change( 1, 10, false, "allies" );
	
	// cap the AI count
	SetAILimit( 26 );
	
	thread street_dialogue();
	
	//TUEY Set Music State to Street Entrance and the bus state to STREET
	setmusicstate("STREET_ENTRANCE");
	setbusstate("STREET");


	//level waittill( "building_collapse_fallout_done" );
	level waittill( "building_critical_hit" );
	
	// uncap AI count
	ResetAILimit();  
	
	// kick off street executions
	// level progression continues from this thread
	level thread building_collapse_street_executions();
}

street_action_tanks()
{
	level waittill ( "spawnvehiclegroup6" );
	wait( 0.1 );
	
	tank = getent_safe( "e1_street_tank", "targetname" );
	tank SetVehicleLookAtText( "Nizhny Machine Factory No. 195" );
	
	tank2 = getent_safe( "e1_street_tank2", "targetname" );
	tank2 SetVehicleLookAtText( "12th Guards Tank Division" );
	
	tank3 = getent_safe( "e1_street_tank3", "targetname" );
	tank3 SetVehicleLookAtText( "Kirovsky Factory No. 501" );
	
	tank thread tank1_strat();  // this tank takes down the building
	tank2 thread tank2_strat();  // first one to die
	tank3 thread tank3_strat();  // second to die
}

// this tank takes down the building
tank1_strat()
{
	veh_stop_at_node( "street_tank_stopnode_1", "script_noteworthy", 10, 10 );
	
	// wait for player to move up a bit
	if( !flag( "street_charge_moveup1" ) )
	{
		self SetSpeed( 0, 15, 15 );
		
		self thread tank_idle_fire_turret( ( 2791, 1282, 472 ), true );
			
		flag_wait( "street_charge_moveup1" );
		
		self notify( "stop_tank_idle_fire" );
		self notify( "end_tank_fire_at" );
		wait( 0.05 );
		
		self thread tank_reset_turret();
	}
	
	self SetSpeed( 8, 8, 8 );
	
	stopnode = getvehiclenode_safe( "street_tank_stopnode_2", "script_noteworthy" );
	stopnode waittill( "trigger" );
	
	// wait for player again
	if( !flag( "tank3_blowup" ) )
	{
		self SetSpeed( 0, 15, 15 );
		
		self notify( "end_tank_reset_turret" );
		fireSpot = ( -186, -700.8, 544 );
		self thread tank_idle_fire_turret( fireSpot, true );
		
		flag_wait( "tank3_blowup" );
	}
	
	wait( 1 );  // wait a sec so we don't steal the second destroyed tank's spotlight
	
	// move to building shoot spot
	self SetSpeed( 6, 3, 3 );
	
	self notify( "stop_tank_idle_fire" );
	self notify( "end_tank_fire_at" );
	wait( 0.05 );
	
	self thread tank_move_with_player( 6, 3, 3, "veh_stop_at_node" );
	
	veh_stop_at_node( "street_tank_bldgfire_node", "script_noteworthy", 10, 10 );
	
	// make sure player has gotten there
	if( !flag( "street_charge_bldgfire" ) )
	{
		fireSpot = ( -186, -700.8, 544 );
		self thread tank_idle_fire_turret( fireSpot, true );
		
		flag_wait( "street_charge_bldgfire" );
		self notify( "stop_tank_idle_fire" );
		self notify( "end_tank_fire_at" );
		wait( 0.05 );
	}
	
	set_objective( 2 );
	
	// finally, fire at the building
	bldgTarget1 = getstruct_safe( "struct_building_collapse_tankshot1", "targetname" );
	bldgTarget2 = getstruct_safe( "struct_building_collapse_tankshot2", "targetname" );
	
	// slow down the turret rotation
	self.turretrotscale = 0.45;
	
	// turn off coax mg
	self.script_turretmg = 0;
	
	// this section interfaces with building_collapse_think() to drop the building
	// first shot
	self tank_fire_at_struct( bldgTarget1, 1.3, 2 );
	wait( 0.2 );  // time to fly through air
	
	playsoundatposition("explosion2",bldgTarget1.origin);  // //Kevin playing custom explosion
	
	PlayFX( level._effect["building_t34_impact"], bldgTarget1.origin );  // HACK t34 impact fx are weaksauce
	flag_set( "building_hit1" );  // shake the building
	level waittill( "building_hit1_anim_done" );
	
	// second shot
	wait( 0.4 );
	self tank_fire_at_struct( bldgTarget2, 1.2, 2 );
	wait( 0.2 );  // time to fly through air
	//Kevin playing custom explosion
	playsoundatposition("explosion",bldgTarget2.origin);
	
	PlayFX( level._effect["building_t34_impact"], bldgTarget2.origin );  // HACK t34 impact fx are weaksauce
	flag_set( "building_critical_hit" );  // drop the building
	//clientNotify( "bch" );	// no need to send this - 'collapse' is already sent, using that to kill the fake fire on the client instead.
	level waittill( "building_hit2_anim_done" );
	
	flag_wait( "building_collapse_fallout_done" );
	
	level.pauseRandomShake = false;
	
	// tank keep a rollin
	self ResumeSpeed( 8, 8, 8 );
	self waittill( "reached_end_node" );
}

tank_move_with_player( goSpeed, accel, decel, ender )
{
	self endon( "death" );
	
	if( IsDefined( ender ) )
	{
		self endon( ender );
	}
	
	movedist = 356;
	
	while( IsDefined( self ) )
	{
		players = get_players();
		
		foundOne = false;
		
		for( i = 0; i < players.size; i++ )
		{
			// adjust tank origin to match player's Y origin
			tankOrgAdjusted = ( self.origin[0], players[i].origin[1], self.origin[2] );
			
			if(
			( Distance2D( players[i].origin, tankOrgAdjusted ) < movedist ) ||
			( players[i].origin[0] < self.origin[0] ) )  // or is ahead of the tank
			{
				foundOne = true;
				break;
			}
		}
		
		if( foundOne )
		{
			if( self GetSpeed() < goSpeed )
			{
				self SetSpeed( goSpeed, accel, decel );
			}
		}
		else
		{
			if( self GetSpeed() > 0 )
			{
				self SetSpeed( 0, accel, decel );
			}
		}
		
		wait( 1 );
	}
	
}

// first tank to die
tank2_strat()
{
	self thread tank_invincible();
	
	self SetSpeed( 8, 8, 8 );
	
	stopnode = getvehiclenode_safe( "street_tank2_stopnode_1", "script_noteworthy" );
	stopnode waittill( "trigger" );
	
	if( !flag( "player_outside" ) )
	{
		self SetSpeed( 0, 15, 15 );
		flag_wait( "player_outside" );
		self SetSpeed( 8, 8, 8 );
	}
	
	hitnode = getvehiclenode_safe( "vnode_tank2_hit", "script_noteworthy" );
	hitnode waittill( "trigger" );
	
	if( !flag( "street_charge_moveup1" ) )
	{
		self SetSpeed( 0, 15, 15 );
		
		self thread tank_idle_fire_turret();
			
		flag_wait( "street_charge_moveup1" );
		
		self notify( "stop_tank_idle_fire" );
		self notify( "end_tank_fire_at" );
		wait( 0.05 );
	}
	
	self SetSpeed( 3, 4.5, 4.5 );
	
	self notify( "stop_tank_invincibility" );
	self.health = 1;
	self.rollingdeath = 1;
	
	wait( 1 );  // let the tank get going
	
	while( !OkTospawn() )
	{
		wait( 0.1 ); 
	}
	
	rocketStart = ( 1320, -384, -56 );
	MagicBullet( "panzerschrek", rocketStart, self.origin + ( 0, 0, 64 ) );
	
	self SetTurretTargetVec( rocketStart );
	
	wait( 1 );
	
	if( IsDefined( self ) )
	{
		RadiusDamage( self.origin, 10, self.health + 1, self.health + 1 );
	}
	
	flag_set( "tank2_dead" );
}

// second tank to die
tank3_strat()
{
	self SetSpeed( 8, 8, 8 );
	
	stopnode = getvehiclenode_safe( "street_tank3_stopnode_1", "script_noteworthy" );
	stopnode waittill( "trigger" );
	
	// wait for player to get outside
	if( !flag( "player_outside" ) )
	{
		self SetSpeed( 0, 15, 15 );
		
		self thread tank_idle_fire_turret( ( 2791, 1282, 472 ), true );
			
		flag_wait( "player_outside" );
		
		self notify( "stop_tank_idle_fire" );
		self notify( "end_tank_fire_at" );
		wait( 0.05 );
		
		self thread tank_reset_turret();
	}
	
	self SetSpeed( 8, 8, 8 );
	
	stopnode = getvehiclenode_safe( "street_tank3_stopnode_2", "script_noteworthy" );
	stopnode waittill( "trigger" );
	
	// wait for player to move up
	if( !flag( "street_charge_moveup1" ) )
	{
		self SetSpeed( 0, 15, 15 );
		
		self notify( "end_tank_reset_turret" );
		wait( 0.05 );
		
		self thread tank_idle_fire_turret( ( 2791, 1282, 472 ), true );
			
		flag_wait( "street_charge_moveup1" );
		
		self notify( "stop_tank_idle_fire" );
		self notify( "end_tank_fire_at" );
		wait( 0.05 );
		
		self SetSpeed( 8, 8, 8 );
		self thread tank_reset_turret();
	}
	
	hitnode = getvehiclenode_safe( "vnode_tank3_hit", "script_noteworthy" );
	hitnode waittill( "trigger" );
	
	// wait for player again
	if( !flag( "tank3_blowup" ) )
	{
		self SetSpeed( 0, 15, 15 );
		
		self notify( "end_tank_reset_turret" );
		fireSpot = ( 1142, -250, -96 ) + ( 0, 0, 75 );
		self thread tank_idle_fire_turret( fireSpot, true );
		
		flag_wait( "tank3_blowup" );
	}
	
	self SetSpeed( 3, 4.5, 4.5 );
	
	self notify( "stop_tank_idle_fire" );
	self notify( "end_tank_fire_at" );
	wait( 0.05 );
	
	self notify( "stop_tank_invincibility" );
	self.health = 100;
	self.rollingdeath = 1;
	
	wait( 1 );  // let the tank get going
	
	while( !OkTospawn() )
	{
		wait( 0.1 ); 
	}
	
	rocketStart = ( 44, 274, 492 );
	MagicBullet( "panzerschrek", rocketStart, self.origin + ( 0, 0, 64 ) );
	
	self SetTurretTargetVec( rocketStart );
	
	wait( 1.2 );
	
	if( IsDefined( self ) )
	{
		RadiusDamage( self.origin, 10, self.health + 1, self.health + 1 );
	}
}

// self = the tank
tank_invincible()
{
	self endon( "death" );
	self endon( "stop_tank_invincibility" );
	level endon( "subway_gate_closed" );
	
	bighealth = 1000000;
	self.health = bighealth;
	
	while( IsDefined( self ) )
	{
		self waittill( "damage" );
		
		if( self.health < bighealth )
		{
			self.health = bighealth;
		}
	}
}

street_fakefire()
{
	flag_wait( "player_outside" );
	
	if( IsDefined( level.clientscripts ) && level.clientscripts )
	{
		clientNotify( "sfs" );
	}
	else
	{
		firePoints = GetStructArray( "struct_street_fakefire", "targetname" );
		ASSERTEX( IsDefined( firePoints ) && firePoints.size > 0, "Can't find fakefire points." );
		array_thread( firePoints, maps\ber2_fx::ambient_fakefire, "building_critical_hit", true );
		
		firePoints = [];
		firePoints = GetStructArray( "struct_street_building_fakefire", "targetname" );
		ASSERTEX( IsDefined( firePoints ) && firePoints.size > 0, "Can't find fakefire points." );
		array_thread( firePoints, maps\ber2_fx::ambient_fakefire, "building_tower_fall", true );
	}
}

street_bank_window()
{
	opel = getent_safe( "bldg_collapse_dest_opel_close", "script_noteworthy" );
	
	flag_wait( "player_outside" );
	
	// kill this first opel so we can clear our view for the money explosion
	if( IsDefined( opel ) )
	{
		player_look_wait_timeout( opel.origin + ( 0, 0, 42 ), 5, "street_opel", 0.9 );
		
		if( IsDefined( opel ) )
		{
			RadiusDamage( opel.origin, 10, opel.health + 1, opel.health + 1 );
		}
	}
	
	wait( 5 );
	
	flag_wait( "street_charge_moveup1" );
	thread street_bank_window_exp();
	
	street_bank_flag_sequence();
	
	flag_wait( "tank2_dead" );  // wait for 1st tank to blow up
	wait( 3 );
	thread street_bank_window_exp();
	
	flag_wait( "tank3_blowup" );
	wait( 5 );
	thread street_bank_window_exp();
}

player_look_wait_timeout( lookatOrg, timeout, timerIDString, reqDot )
{
	if( !IsDefined( reqDot ) )
	{
		reqDot = 0.8;
	}
	
	timerName = "player_look" + timerIDString;
	set_timer( timerName, timeout );
	
	while( !timer_expired( timerName ) )
	{
		players = get_players();
		
		foundOne = false;
		for( i = 0; i < players.size; i++ )
		{
			// check basic sight trace
			if( SightTracePassed( players[i] GetEye(), lookatOrg, false, undefined ) )
			{
				normal = VectorNormalize( lookatOrg - players[i].origin );
				player_angles = players[i] GetPlayerAngles();
				player_forward = AnglesToForward( player_angles );
	
				dot = VectorDot( player_forward, normal );
			
				// make sure it's centered up in the player view
				if( dot >= reqDot )
				{
					foundOne = true;
					break;
				}
			}
		}
		
		if( foundOne )
		{
			return;
		}
		
		wait( 0.05 );
	}
}

street_bank_window_exp()
{
	rocketStartOrg = ( 1608.6, 408, 270 );
	fxSpot = getstruct_safe( "bank_money_exp", "targetname" );

	while( !OkTospawn() )
	{
		wait( 0.1 ); 
	}
	
	MagicBullet( "panzerschrek", rocketStartOrg, fxSpot.origin );
	wait( 0.75 );  // rocket travel time
	
	PlayFX( level._effect["bank_window_money_exp"], fxSpot.origin, AnglesToForward( fxSpot.angles ) );
	
	windowFxSpots = GetStructArray( fxSpot.target, "targetname" );
	windowFX = level._effect["window_explosion"];
	array_thread( windowFxSpots, ::scr_playfx, windowFX, RandomFloatRange( 0.15, 0.35 ) );
}

scr_playfx( fx, delay )
{
	if( IsDefined( delay ) && delay >= 0 )
	{
		wait( delay );
	}
	
	PlayFX( fx, self.origin, AnglesToForward( self.angles ) );
}

street_bank_flag_sequence()
{
	animSpot = Spawn( "script_origin", ( 2075, -688, 232 ) );
	//animSpot = getnode_safe( "anim_bank_flag", "targetname" );
	
	guy = Spawn( "script_model", animSpot.origin );
	guy.angles = animSpot.angles;
	guy setup_ally_char_model();
	guy UseAnimTree( #animtree );
	guy.animname = "flag_guy";
	
	flag = Spawn( "script_model", animSpot.origin );
	flag Hide();
	flag SetModel( level.scr_model["big_flag"] );
	flag.animname = "big_flag";
	
	animSpot thread street_bank_flag_anims( flag, guy );
	animSpot anim_single_solo( guy, "unfurl" );
	
	guy Delete();
}

street_ambient_rockets()
{
	flag_wait( "player_outside" );
	
	startSpots = GetStructArray( "street_charge_ambient_rockets", "targetname" );
	ASSERTEX( IsDefined( startSpots ) && startSpots.size > 0, "couldn't find any street charge ambient rocket spots." );
	
	array_thread( startSpots, ::street_ambient_rocket_think );
}

street_ambient_rocket_think()
{
	level endon( "kill_ambient_rockets" );
	if( IsDefined( self.script_ender ) )
	{
		level endon( self.script_ender );
	}
	
	// start delay
	wait( RandomFloat( 2, 6 ) );
	
	while( 1 )
	{
		// derive target spot
		randomizedAngles = self.angles + ( RandomFloatRange( 1, 5 ), RandomFloatRange( -5, 5 ), 0 );
		forward = AnglesToForward( randomizedAngles );
		targetOrg = self.origin + vectorScale( forward, 1000 );
		
		while( !OkTospawn() )
		{
			wait( 0.1 ); 
		}
		
		MagicBullet( "panzerschrek", self.origin, targetOrg );
		
		wait( RandomFloatRange( 10, 16 ) );
	}
}
// --- END STREET ACTION ---

// -- TURRET STUFF: IW steez, primarily --
building_collapse_mgers()
{
	flag_wait( "building_mgs_start" );
	
	mgs = GetEntArray( "collapsingbuilding_manual_mg", "targetname" );
	ASSERTEX( IsDefined( mgs ) && mgs.size > 0, "Can't find the mg turrets in the collapsing building." );
	
	array_thread( mgs, ::scr_setmode, "manual" );
	gun1 = mgs[ 0 ];
	gun2 = mgs[ 1 ];
	
	array_thread( mgs, ::player_mg_fire );
	
	gun1 thread manual_mg_fire();
	wait( 0.15 );
	gun2 thread manual_mg_fire();
	
	gun1 thread shoot_mg_targets();
	wait( 0.25 );
	gun2 thread shoot_mg_targets();
	
	flag_wait( "building_critical_hit" );
	
	wait( 0.05 );
	
	for( i = 0; i < mgs.size; i++ )
	{
		mgs[i] Delete();
	}
	
	// also delete their targets
	thread delete_group( GetEntArray( "auto1052", "targetname" ), 0.5 );
}

scr_setmode( mode )
{
	self setmode( mode );
}

// try to kill players if they get too far up the street
player_mg_fire()
{
	self endon( "death" );
	level endon( "building_critical_hit" );
	
	while( IsDefined( self ) )
	{
		players = get_players();
		
		for( i = 0; i < players.size; i++ )
		{
			if( !IsDefined( players[i].isMgTargeted ) )
			{
				players[i].isMgTargeted = false;
			}
			
			if( players[i].origin[0] < 1378 && !players[i].isMgTargeted )
			{
				self thread mg_playerdamage( players[i] );
			}
		}
		
		wait( 0.1 );
	}
}

mg_playerdamage( player )
{
	player endon( "death" );
	player endon( "disconnect" );
	self endon( "death" );
	level endon( "building_critical_hit" );
	
	self notify( "stop_firing" );
	player.isMgTargeted = true;
	
	if( self GetTurretTarget() != player )
	{
		self SetTargetEntity( player );
	}
	
	turretSightChecker = ( 100, 202, 340 );
	// make sure we're not behind cover
	if( BulletTracePassed( player GetEye(), turretSightChecker, false, player ) )
	{
		self thread mg_fake_tracers( player );
		player DoDamage( 30, self.origin );
	}
	
	player.isMgTargeted = false;
}

mg_fake_tracers( player )
{
	player endon( "death" );
	player endon( "disconnect" );
	self endon( "death" );
	level endon( "building_critical_hit" );
	
	for( i = 0; i < 3; i++ )
	{
		BulletTracer( self GetTagOrigin( "tag_flash" ), player GetEye(), true );
		wait( RandomFloatRange( 0.05, 0.12 ) );
	}
}

manual_mg_fire()
{
	self endon( "stop_firing" );
	level endon( "building_critical_hit" );
	
	self.turret_fires = true;
	for ( ;; )
	{
		timer = randomfloatrange( 0.2, 0.7 ) * 20;
		if ( self.turret_fires )
		{
			for ( i = 0; i < timer; i++ )
			{
				self shootturret();
				wait( 0.05 );
			}
		}
		wait( randomfloat( 0.5, 2 ) );
	}
}

shoot_mg_targets()
{
	self endon( "stop_firing" );
	level endon( "building_critical_hit" );
	
	//thread do_in_order( ::flag_wait, "player_enters_apartment_rubble_area", ::send_notify, "stop_firing" );
	thread stop_firing_when_shot();
	targets = getentarray( self.target, "targetname" );
	
	for ( ;; )
	{
		target = random( targets );
		self settargetentity( target );
		wait( randomfloatrange( 1, 5 ) );
	}
}

stop_firing_when_shot()
{
	self endon( "stop_firing" );
	level endon( "building_critical_hit" );
	
	trigger = getent_safe( self.script_linkto, "script_linkname" );
	shots_until_stop = randomintrange( 3, 5 );
	for ( ;; )
	{
		trigger waittill( "damage", damage, other, direction, origin, damage_type );
		if ( !IsPlayer( other ) )
			continue;

		if ( explosive_damage( damage_type ) )
		{
			self.turret_fires = false;
			return;
		}
		
		shots_until_stop--;
		if ( shots_until_stop > 0 )
			continue;
		
		shots_until_stop = randomintrange( 3, 4 );
		self.turret_fires = false;
		wait( randomfloatrange( 4, 7 ) );
		self.turret_fires = true;
	}
}

explosive_damage( type )
{
	return issubstr( type, "GRENADE" );
}
// -- END TURRET STUFF --


// --- BUILDING COLLAPSE STUFF ---
building_collapse_setup()
{
	thread building_collapse_mgers();
	thread building_collapse_think();
}

/#
building_collapse_debug()
{
	level waittill("first_player_ready", player);
	iprintlnbold( "building collapse debug enabled" );
		
	animSpot = Spawn( "script_origin", ( 28, 225, -112 ) );
	animSpot.angles = ( 0, 0, 0 );
	
	waittill_player_within_range( animSpot.origin, 1000, 0.5 );
	
	// mg position geo
	mgGeo[0] = getent_safe( "sb_model_bldg_collapse_window_boards", "targetname" );
	sandbags = GetEntArray( "bldg_collapse_window_sandbags", "targetname" );
	for( i = 0; i < sandbags.size; i++ )
	{
		mgGeo[mgGeo.size] = sandbags[i];
	}
	
	// gets pieces, sets them up in an animation-friendly array
	pieces = building_collapse_setup_anim_pieces();
	
	thread building_collapse_hit1_fx( pieces );
	maps\_anim::anim_ents( pieces, "hit1", undefined, undefined, animSpot, "buildingcollapse_rig" );
	
	level thread building_collapse_fx( pieces );
	array_thread( mgGeo, ::mg_geo_delete );
		
	wait( 1 );
	
	maps\_anim::anim_ents( pieces, "hit2", undefined, undefined, animSpot, "buildingcollapse_rig" );
	
	wait( 5 );
	
	thread tower_fx( pieces );
	maps\_anim::anim_ents( pieces, "towerfall", undefined, undefined, animSpot, "buildingcollapse_rig" );
	
	wait( 2 );
	animSpot Delete();
}
#/

building_collapse_think()
{
	// set up the pieces to animate
	// the node is in paul's layer, so manufacture it
	animSpot = Spawn( "script_origin", ( 28, 225, -112 ) );
	animSpot.angles = ( 0, 0, 0 );
	
	
	// mg position geo
	mgGeo[0] = getent_safe( "sb_model_bldg_collapse_window_boards", "targetname" );
	sandbags = GetEntArray( "bldg_collapse_window_sandbags", "targetname" );
	for( i = 0; i < sandbags.size; i++ )
	{
		mgGeo[mgGeo.size] = sandbags[i];
	}
	
	// gets pieces, sets them up in an animation-friendly array
	pieces = building_collapse_setup_anim_pieces();
	
	level waittill( "building_hit1" );
	
	// TODO: need to warp players here so they don't see AI being killed off if they are further behind
	
	level thread street_executions_playerspeed();  // slow players down for a while
	thread building_collapse_kill_ais();  // kill off remaining street AIs
	thread building_collapse_hit1_fx( pieces );
	maps\_anim::anim_ents( pieces, "hit1", undefined, undefined, animSpot, "buildingcollapse_rig" );
	level notify( "building_hit1_anim_done" );
	
	level waittill( "building_critical_hit" );
	level thread alleyway_fx();
	level thread building_collapse_players_shock();  // shock em if they're up where they shouldn't be
	thread building_collapse_fx( pieces );
	array_thread( mgGeo, ::mg_geo_delete );
	maps\_anim::anim_ents( pieces, "hit2", undefined, undefined, animSpot, "buildingcollapse_rig" );
	level notify( "building_hit2_anim_done" );

	// wait for players and then drop the tower
	flag_wait( "building_tower_fall" );

	//Kevin playing tower sounds
	tower_impact = getent("tower_impact","targetname");

//	animSpot playsound("tower1");							// Moved this to the client
	tower_impact playsound("tower_impact1");
	
	thread tower_fx( pieces );
	maps\_anim::anim_ents( pieces, "towerfall", undefined, undefined, animSpot, "buildingcollapse_rig" );
	level notify( "building_towerfall_anim_done" );
	
	wait( 2 );
	animSpot Delete();
}

building_collapse_setup_anim_pieces()
{
	// automating the process of getting the pieces
	// each line should do the same as this:
	// pieces["rig 1:tower01"] = getent_safe( "sb_model_tower_01", "targetname" );
	// ...etc.
	startNum = 1;
	numPieces = 32;
	bonePrefix = "tower";
	sbModelPrefix = "sb_model_tower_";
	
	pieces = [];
	
	for( i = startNum; i <= numPieces; i++ )
	{
		if( i < 10 )
		{
			tagName = bonePrefix + "0" + i;
			sbModelTNString = sbModelPrefix + "0" + i;
		}
		else
		{
			tagName = bonePrefix + i;
			sbModelTNString = sbModelPrefix + i;
		}
		
		piece = getent_safe( sbModelTNString, "targetname" );
		piece transmittargetname();
		piece.script_linkto = tagName;
		pieces[pieces.size] = piece;
	}
	
	ASSERTEX( IsDefined( pieces ) && pieces.size == 32, "Something went wrong with getting the collapsing building pieces." );
	
	return pieces;
}

building_collapse_kill_ais()
{
	getent_safe( "trig_script_killspawner_113", "targetname" ) notify( "trigger" );
	getent_safe( "trig_script_killspawner_115", "targetname" ) notify( "trigger" );
	wait( 0.1 );
	guys = GetAIArray( "axis" );
	wait( 0.1 );
	array_thread( guys, ::bloody_death, true, 2 );
}

building_collapse_hit1_fx( pieces )
{
	clientNotify( "bch" );  // now clientsided
	//array_thread( pieces, ::building_collapse_oneshot_fx_randomchance, 15 );
}

// obscures the alleyway from where we need to spawn friendlies
alleyway_fx()
{
	origin = ( 1252, -772, -120 );
	PlayFX( level._effect["smokescreen"], origin );
}

building_collapse_fx( pieces )
{
	//TODO TUEY:  Set up busses so that there is NO sound
	//Kevin client notify for bus change and to start tinnitus
	level notify( "tinnitus" );

	//TUEY Set Music STate to BOOM Mofo
	setmusicstate("BOOM_MFER");
	
	fxSpot = getstruct_safe( "struct_building_corner_fxsource", "targetname", "collapsing building fx script struct" );
	
	collapseFX = level._effect["building_collapse"];
	falloutFX = level._effect["building_collapse_fallout"];
	//lingeringSmokeFX = level._effect["battle_smoke_heavy"];  // this has been clientsided
	
	clientNotify( "bcf" );  // now clientsided
	//array_thread( pieces, ::building_collapse_oneshot_fx_randomchance, 50 );
	
	wait( 1.2 );
	PlayFX( collapseFX, fxSpot.origin );
	wait( 1.5 );
	PlayFX( falloutFX, fxSpot.origin, AnglesToForward( fxSpot.angles ) );
	wait( 0.8 );

	// destroy opels in the area
	thread building_collapse_destroy_opels();
	
	thread building_collapse_player_damage();
	
	wait( 0.5 );
	
	flag_set( "building_collapse_fallout_done" );
	clientNotify("lsmoke");  // lingering smoke has been clientsided
	flag_wait( "metrogate_executions_done" );
	clientNotify("lsmokedone");  // lingering smoke has been clientsided
}

building_collapse_oneshot_fx_randomchance( chancePercent )
{
	if( chancePercent < 0 )
	{
		chancePercent = 0;
	}
	if( chancePercent > 100 )
	{
		chancePercent = 100;
	}
	
	if( RandomInt( 100 ) < chancePercent )
	{
		self building_collapse_oneshot_fx();
	}
}

building_collapse_oneshot_fx()
{
	oneShotFX = level._effect["building_collapse_oneshot"];
	wait( RandomFloat( 0.5 ) );
	
	players = get_players();
	player = players[0];
	
	if( players.size > 1 )
	{
		player = get_random( players );
	}
	
	angles = VectorToAngles( self.origin - player.origin );
	
	PlayFX( oneShotFX, self.origin, angles );
}

building_collapse_destroy_opels()
{
	opels = GetEntArray( "bldg_collapse_dest_opel", "script_noteworthy" );
	
	if( IsDefined( opels ) && opels.size > 0 )
	{
		array_thread( opels, ::building_collapse_opel_destroy );
	}
}

building_collapse_opel_destroy()
{
	wait( RandomFloat( 2 ) );
	
	if( IsDefined( self ) )
	{
		RadiusDamage( self.origin, 10, self.health + 1, self.health + 1 );
	}
}

building_collapse_player_damage()
{
	// do some damage to the area in case players are close
	//RadiusDamage( ( 52, 236, 208 ), 770, 50, 100 );
	
	origin = ( 52, 236, 208 );
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( Distance( origin, players[i].origin ) <= 770 )
		{
			players[i] DoDamage( RandomIntRange( 50, 100 ), origin );
		}
	}
}

mg_geo_delete()
{
	wait( 1 );
	self Delete();
}

tower_fx( pieces )
{
	fxPieces = [];
	fxPieces[0] = pieces[1];
	fxPieces[1] = pieces[2];
	fxPieces[2] = pieces[3];
	fxPieces[3] = pieces[4];
	fxPieces[4] = pieces[5];
	
	clientNotify( "bct" );  // now clientsided
	//array_thread( fxPieces, ::building_collapse_oneshot_fx );
	array_thread( fxPieces, ::tower_fx_piece );
}

tower_fx_piece()
{
	while( !OkTospawn() )
	{
		wait( 0.1 ); 
	}
	
	org = Spawn( "script_model", self.origin );
	org SetModel( "tag_origin" );
	
	org LinkTo( self );
	
	/*
	tags[0] = "tag_origin";
	org thread tags_debug_print( tags );
	*/
	
	PlayFxOnTag( level._effect["tower_dust_trail"], org, "tag_origin" );
	
	level waittill( "building_towerfall_anim_done" );
	org Unlink();
	org Delete();
}
// --- END BUILDING COLLAPSE STUFF ---

street_dialogue()
{
	wait( 3 );
	
	// "Berlin will be in ruins by the time war is over."
	level.sarge playsound_generic_facial( "Ber2_IGD_058A_REZN" );
	
	flag_wait( "street_charge_moveup1" );
	wait( RandomFloatRange( 1, 3 ) );
	// "Stay with the tanks!"
	level.sarge playsound_generic_facial( "Ber2_IGD_061A_REZN" );
	
	flag_wait( "building_mgs_start" );
	wait( RandomFloatRange( 1, 2 ) );
	// "MGs up ahead - third floor!"
	level.sarge playsound_generic_facial( "Ber2_IGD_060A_REZN" );
	// "Keep moving"
	level.sarge playsound_generic_facial( "Ber2_IGD_062A_REZN" );
}

// --- STREET EXECUTION STUFF ---
building_collapse_street_executions()
{
	// wait at least 2 seconds from now to spawn the guys on the ground
	timeToSpawnGroundGuys = GetTime() + 2000;  // 2000 ms = 2 seconds
	
	animSpots = GetStructArray( "struct_e1_street_executions", "targetname" );
	ASSERTEX( IsDefined( animSpots ) && animSpots.size > 0, "Couldn't find any animspot script_structs for street executions." );
	
	// set up the metrogate regroup nodes for street_execution guys to join the crew after doing their thing
	level.metrogateRegroupNodes = GetNodeArray( "node_street_regroup", "targetname" );
	ASSERTEX( IsDefined( level.metrogateRegroupNodes ) && level.metrogateRegroupNodes.size > 0, "Couldn't find any metrogate regroup nodes." );
	
	// "extras" = molotov throwers
	numMetrogateExtras = 4;
	totalRequiredRedshirts = animSpots.size + numMetrogateExtras;
	
	// clear level.friends color nodes
	array_thread( level.friends, ::clear_force_color );
	
	// get squad redshirts
	killers = [];
	for( i = 0; i < level.friends.size; i++ )
	{
		if( IsDefined( level.friends[i] )
			&& IsAlive( level.friends[i] )
			&& ( level.friends[i] != level.sarge )
			&& ( level.friends[i] != level.hero1 ) )
		{
			killers[killers.size] = level.friends[i];
		}
	}

	// get other friendly redshirts
	redshirts = get_ai_group_ai( "ai_outside_russians_1" );
	// turn off color respawning on these guys & kill their spawners
	array_thread( redshirts, ::disable_replace_on_death );
	getent_safe( "trig_killspawner_421", "targetname" ) notify( "trigger" );
	
	killers = array_combine( killers, redshirts );
	
	// if we don't have enough guys for our animations, we have to spawn more
	if( killers.size < totalRequiredRedshirts )
	{
		numToSpawn = totalRequiredRedshirts - killers.size;
		spawner = getent_safe( "spawner_street_extraguy", "targetname" );
		
		for( i = 0; i < numToSpawn; i++ )
		{
			spawner.count++;
			
			extra = undefined;
			while( !IsDefined( extra ) )
			{
				while( !OkToSpawn() )
				{
					wait( 0.05 );
				}
				extra = spawn_guy( spawner );
				
				wait( 0.1 );
			}
			
			extra thread magic_bullet_shield_safe();
			
			// just move out of the way
			extra SetGoalPos( ( 1122, -408, -92 ) );
			
			// add to the killers array
			killers[killers.size] = extra;
			
			wait( 0.1 );
		}
		
		// clean up spawner
		spawner thread scr_delete( 1 );
	}
	
	ASSERTEX( killers.size >= totalRequiredRedshirts, "Too many execution animations for the number of available redshirts!" );
	
	flag_init( "street_executions_death_watcher_started" );
	flag_init( "street_execution_guys_spawning" );
	
	lastIndex = 0;	
	// some guys do street executions
	for( i = 0; i < animSpots.size; i++ )
	{
		if( IsDefined( killers[i] ) )
		{
			killers[i] thread street_execution_anim( animSpots[i], timeToSpawnGroundGuys );
		}
		
		lastIndex = i;
	}
	
	level thread building_collapse_monitor_victims( animSpots.size );
	
	// rest of them are metrogate extras
	metrogateExtras = [];
	for( i = ( lastIndex + 1 ); i < killers.size; i++ )
	{
		metrogateExtras[metrogateExtras.size] = killers[i];
	}
	
	level thread metrogate_execution( metrogateExtras );
	
	flag_wait( "metrogate_executions_done" );
	
	// take level.friends guys out of the killers array
	killers = array_exclude( killers, level.friends );
	
	// repopulate level.friends up to a given size, removing the repopulated guys from killers
	// now we will have an array of redshirts who are ok to kill off during the mortar run
	levelFriendsTargetSize = undefined;
	if( level.coopOptimize )
	{
		// we want level.friends to be smaller in coop
		levelFriendsTargetSize = 4;
	}
	else
	{
		levelFriendsTargetSize = 6;
	}
	
	while( level.friends.size < levelFriendsTargetSize )
	{
		newfriend = get_random( killers );
		newfriend friend_add();
		newfriend set_force_color( "b" );
		newfriend thread replace_on_death();
		killers = array_remove( killers, newfriend );
	}
	
	// squad regroup and rocket barrage
	// level progression continues in this thread
	level thread street_regroup( killers );
}

// need this to keep players from running ahead
building_collapse_players_shock()
{
	wait( 1 );
	
	duration = 8;
	stanceLockDuration = 7;
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		if( player.origin[0] < 1900 )
		{
			player thread building_collapse_player_shock( duration, stanceLockDuration );
		}
	}
	
	wait( stanceLockDuration );
	
	set_objective( 3 );
	thread street_executions_dialogue();
}

building_collapse_player_shock( duration, stanceLockDuration )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	//self EnableInvulnerability( true );
	
	self VisionSetNaked( "ber2_collapse", ( duration * 0.25 ) );
	
	// origin, duration, shock_range, nMaxDamageBase, nRanDamageBase, nMinDamageBase, nExposed, customShellShock, stanceLockDuration
	self thread maps\_shellshock::main( self.origin, duration, 64, 2, 1, 1, undefined, undefined, stanceLockDuration );
		
	wait( duration * 0.75 );
	
	self VisionSetNaked( "ber2", ( duration * 0.25 ) );
	
	wait( duration * 0.25 );
	
	//self EnableInvulnerability( false );
}

street_executions_playerspeed()
{
	baseSpeedScale = 1;
	speedScaleMultiplier = 0.6;
	
	array_thread( get_players(), ::scr_player_speedscale, ( baseSpeedScale * speedScaleMultiplier ), 1 );
	
	flag_wait( "metrogate_reach_done" );
	
	// set speed back
	array_thread( get_players(), ::scr_player_speedscale, baseSpeedScale, 3 );
}

street_executions_dialogue()
{
	if( flag( "metrogate_execution_player_close" ) )
	{
		return;
	}
	
	level endon( "metrogate_execution_player_close" );
	
	// "Make sure they are all dead."
	level.sarge playsound_generic_facial( "Ber2_IGD_063A_REZN" );
	
	wait( 2 );
	
	// "Kill them all."
	level.sarge playsound_generic_facial( "Ber2_IGD_064A_REZN" );
	// "Wipe this scum from the streets."
	level.sarge playsound_generic_facial( "Ber2_IGD_065A_REZN" );
}

street_regroup( guys )
{
	//set_objective( 4 );  // removed objective 4
	
	autosave_by_name( "ber2_street_escape" );
	
	thread rocket_barrage( guys );  // redshirts move in this thread
	
	//TUEY Set the music state to RUN_MORTARS
	setmusicstate("RUN_MORTARS");
	
	wait( 2 );  // wait for sarge to react
	

	
	thread rocket_barrage_redshirts_go( guys );
	set_objective( 5 );

	
	// level.friends go
	array_thread( level.friends, ::set_force_color, "b" );
	
	// level progression continues: kick off the subway gate action
	level thread subway_gate_action();
}

rocket_barrage( guys )
{
	level.pauseRandomShake = true;
	
	/#
	level thread maps\_debug::set_event_printname( "Event 2 - Rocket Barrage", true );
	#/
	
	thread players_safe_belowground();
	
	waveSpots1 = GetStructArray( "metrogate_rocket_wave1", "targetname" );
	waveSpots2 = GetStructArray( "metrogate_rocket_wave2", "targetname" );
	waveSpots3 = GetStructArray( "metrogate_rocket_wave3", "targetname" );
	waveSpots4 = GetStructArray( "metrogate_rocket_wave4", "targetname" );
	ASSERTEX( array_validate( waveSpots1 ), "Couldn't find wave 1 rocket spots" );
	ASSERTEX( array_validate( waveSpots2 ), "Couldn't find wave 2 rocket spots" );
	ASSERTEX( array_validate( waveSpots3 ), "Couldn't find wave 3 rocket spots" );
	ASSERTEX( array_validate( waveSpots4 ), "Couldn't find wave 4 rocket spots" );
	
	thread rocket_wave( waveSpots1, undefined, "rocket_barrage_wave1_done" );
	level waittill( "rocket_wave_done" );
	
	wait( RandomFloatRange( 2.5, 3.5 ) );
	
	thread rocket_wave( waveSpots2 );
	delayThread( 1, ::tank_rocket_hit );
	level waittill( "rocket_wave_done" );
	
	wait( RandomFloatRange( 2.5, 3.5 ) );
	
	thread rocket_wave( waveSpots3 );
	level waittill( "rocket_wave_done" );
	
	wait( RandomFloatRange( 2.5, 3.5 ) );
	
	// start thinking about killing off stragglers
	array_thread( get_players(), ::rocket_barrage_target_player );
	
	// loop until the gate is closed
	numLoops = 0;
	while( !flag( "subway_gate_closed" ) )
	{
		if( numLoops % 2 == 0 )
		{
			thread rocket_wave( waveSpots4 );
		}
		else
		{
			thread rocket_wave( waveSpots3 );
		}
		numLoops++;
		level waittill( "rocket_wave_done" );
		wait( RandomFloatRange( 2.5, 3.5 ) );
	}
	
	level.pauseRandomShake = false;
}

rocket_barrage_redshirts_go( guys )
{
	array_thread( guys, ::stop_magic_bullet_shield_safe );
	
	// redshirts go
	redshirtsRunSpot = ( 1264, -1092, -88 );
	for( i = 0; i < guys.size; i++ )
	{
		if( IsDefined( guys[i] ) )
		{
			guys[i].goalradius = 128;
			guys[i] SetGoalPos( redshirtsRunSpot );
			guys[i] thread bloody_death_delayed( 8, 10 );
		}
	}
}

players_safe_belowground()
{
	belowground =  -176;
	xGate = 1600;
	
	while( !flag( "subway_gate_closed" ) )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( IsDefined( players[i] ) && IsAlive( players[i] ) && players[i].origin[2] < belowground && players[i].origin[0] < xGate )
			{
				SetPlayerIgnoreRadiusDamage( true );
			}
			else
			{
				SetPlayerIgnoreRadiusDamage( false );
			}
		}
		wait( 0.2 );
	}
	
	// once the gate is closed, wait a bit and make them all take radius damage again
	wait( 10 );
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( IsDefined( players[i] ) && IsAlive( players[i] ) )
		{
			SetPlayerIgnoreRadiusDamage( false );
		}
	}
}

rocket_barrage_target_player()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	rocketTravelDelay = 1.5;
	
	xGate = 1600;
	
	while( !flag( "subway_gate_closed" ) )
	{
		if( self.origin[2] > -130 || self.origin[0] > xGate )
		{
			thread rocket_wave_rocket( origin_offset_2D( self.origin, -64, 64 ) );
			thread rocket_wave_rocket( origin_offset_2D( self.origin, -128, 128 ) );
			thread rocket_wave_rocket( origin_offset_2D( self.origin, -256, 256 ) );
			
			wait( rocketTravelDelay );
		}
		else
		{
			wait( 0.5 );
		}
	}
}

origin_offset_2D( refOrg, minOffset, maxOffset )
{
	return refOrg + ( RandomIntRange( minOffset, maxOffset ), RandomIntRange( minOffset, maxOffset ), 0 );
}

rocket_wave( waveSpots, waveRepeats, extraNotify )
{
	if( !IsDefined( waveRepeats ) || waveRepeats < 1 )
	{
		waveRepeats = 2;
	}
	
	for( j = 0; j < waveRepeats; j++ )
	{
		for( i = 0; i < waveSpots.size; i++ )
		{
			thread rocket_wave_rocket( waveSpots[i].origin );
			
			if( i != ( waveSpots.size - 1 ) )
			{
				wait( RandomFloatRange( 0.3, 0.5 ) );
			}
		}
	}
		
	if( IsDefined( extraNotify ) )
	{
		level notify( extraNotify );
	}
	
	level notify( "rocket_wave_done" );
}

rocket_wave_rocket( expOrg )
{
	rocket = Spawn( "script_model", expOrg + ( 0, 0, 6000 ) );
	rocket SetModel( "katyusha_rocket" );
	rocket.angles = ( 90, 0, 0 );
	
	rocket playloopsound( "katy_rocket_run" );
	PlayFxOnTag( level._effect["katyusha_rocket_trail"], rocket, "tag_origin" );
	thread play_sound_in_space( "katyusha_launch", rocket.origin );
	
	rocket MoveTo( expOrg, RandomFloatRange( 1, 2 ) );
	rocket waittill( "movedone" );
	rocket Delete();
	
	PlayFX( level._effect["katyusha_rocket_explosion"], expOrg );
	RadiusDamage( expOrg, 196, 25, 45 );
	array_thread( get_players(), ::generic_rumble_explosion );
	array_thread4( get_players(), ::scr_earthquake, 0.45, 0.4, expOrg, 3000 );
}

tank_rocket_hit()
{
	tank = GetEnt( "e1_street_tank", "targetname" );
	if( !IsDefined( tank ) || !IsAlive( tank ) )
	{
		return;
	}
	
	//spot = getstruct_safe( "subway_rocket_tankblast", "targetname" );
	rocket_wave_rocket( tank.origin );
	wait( 0.1 );
	if( IsDefined( self ) && IsDefined( self.health ) && self.health > 0 )
	{
		RadiusDamage( self.origin, 10, self.health + 1, self.health + 1 );
	}
}

bloody_death_delayed( delayMin, delayMax )
{
	wait( delayMin );
	self thread bloody_death( true, delayMax - delayMin );
}

// self = the executioner
street_execution_anim( animSpot, timeToSpawnGroundGuys )
{
	executionNum = RandomIntRange( 1, 4 );
	
	// set up the execution anims
	victim_animname = "wounded_execution" + executionNum + "_victim" ;
	executioner_animname = "wounded_execution" + executionNum + "_executioner";
	
	street_execution_waitfor_spawn( timeToSpawnGroundGuys );
	flag_set( "street_execution_guys_spawning" );
	
	// TODO set up guys with the right weapons
	
	// set up the executioner
	if( !IsDefined( self.magic_bullet_shield ) || !self.magic_bullet_shield )
	{
		self thread magic_bullet_shield();
		self.street_execution_bullet_shield = true;
	}
	self.og_animname = self.animname;
	//self.cqbwalking = true;
	self.animname = executioner_animname;
	self pushPlayer( true );

	victim = undefined;
	guys = [];
	
	if( is_german_build() )
	{
	}
	else
	{
		// spawn the victim & set him up
		spawner = getent_safe( animSpot.target, "targetname", "street execution victim spawner" );
		spawner.count = 1;
		victim = spawn_guy( spawner );
		if( !IsDefined( victim ) )
		{
			ASSERTMSG( "Can't spawn the victim!" );
			return;
		}
		
		// don't kill this guy until we start the death watcher thread
		victim thread keep_safe_til_flag( "street_executions_death_watcher_started" );
		
		// clean up spawner
		spawner thread scr_delete( 5 );
		
		victim.ignoreme = true;
		victim.ignoreall = true;
		victim.health = 1;
		victim.nodeathragdoll = true;
		victim.allowdeath = true;
		victim.a.pose = "prone";
		victim.a.nodeath = true;
		victim.animname = victim_animname;
		victim.grenadeammo = 0;
		victim.dropweapon = 0;
		victim animscripts\shared::DropAIWeapon();
		
		self.victim = victim;
		victim.executioner = self;
		
		//guys = [];
		guys[0] = self;
		guys[1] = victim;
		
		self.executionDone = false;
		
		// start the victim's wounded loop
		notifystring = "stop_wounded_loop";
		animSpot thread anim_loop_solo( victim, "wounded_loop", undefined, notifystring, undefined );
		animSpot thread street_execution_abort( self, victim, executionNum, notifystring );
		thread street_execution_victimdeath( self, victim, notifystring );
	}
	
	// make sure players are close enough to get a chance to participate
	flag_wait( "street_executions_start" );
	
	// stagger the friendlies moving a bit
	wait( RandomFloat( 3.3 ) );
	
	// get the executioner into position
	animSpot anim_reach_solo( self, "execution_shot" );
	
	if( is_german_build() )
	{

	}
	else
	{
		// if the wounded guy is still alive...
		if( is_active_ai( victim ) )
		{
			self.isExecuting = true;
			animSpot anim_single( guys, "execution_shot" );
		}
	}
	
	self.isExecuting = false;
	self.executionDone = true;
	
	// reset the executioner
	if( IsDefined( self.street_execution_bullet_shield ) && self.street_execution_bullet_shield )
	{
		self thread stop_magic_bullet_shield_safe();
	}
	//self.cqbwalking = false;
	self.animname = self.og_animname;
	self pushPlayer( false );
	
	if( !flag( "metrogate_executions_done" ) )
	{
		// send to a node near the metro gate
		self metrogate_assign_regroupnode();
	}
}

street_execution_waitfor_spawn( timeToSpawnGroundGuys )
{
	// WAIT for the particle to fill up the read, if necessary
	if( GetTime() < timeToSpawnGroundGuys )
	{
		wait( ( timeToSpawnGroundGuys - GetTime() ) * .001 );  // = seconds
	}
}

keep_safe_til_flag( safeFlag )
{
	self magic_bullet_shield_safe();
	flag_wait( safeFlag );
	self stop_magic_bullet_shield_safe();
}

street_execution_victimdeath( executioner, victim, notifystring )
{
	victim endon( "death" );
	executioner endon( "execution_abort" );
	
	executioner waittill( "execution_gunshot" );
	
	executioner.executionSuccess = true;
	
	victim notify( notifystring );
	victim DoDamage( victim.health + 5, (0,0,0) );
}

// self = the animspot
street_execution_abort( executioner, victim, executionNum, notifystring )
{
	victim thread execution_abort_for_progression();
	
	// the victim's health is 1, so any damage will kill him
	victim waittill( "damage", amount, attacker, direction_vec, point, type );
	
	if( !IsDefined( victim.abortedForProgression ) )
	{
		// if the damage didn't come from the player...
		// and if the damage is NOT explosive
		if( !attacker is_player() && type != "MOD_GRENADE" && type != "MOD_GRENADE_SPLASH" && type != "MOD_EXPLOSIVE" )
		{
			// kill the thread
			return;
		}
	}
	
	// otherwise do custom stuff since a player or an explosive interrupted things
	executioner notify( "execution_abort" );
	
	// kill looping anim
	victim anim_stopanimscripted();
	self notify( notifystring );
	victim StartRagdoll();
	
	// only StopAnimScripted if the guy is actually doing an animscripted
	if( IsDefined( executioner.isExecuting ) && executioner.isExecuting )
	{
		executioner StopAnimScripted();
	}
}

execution_abort_for_progression()
{
	self endon( "death" );
	
	flag_wait( "metrogate_executions_done" );
	
	self.abortedForProgression = true;
	self DoDamage( 1, self.origin, get_players()[0] );
}

metrogate_assign_regroupnode()
{
	nodes = level.metrogateRegroupNodes;
	
	if( nodes.size < 1 )
	{
		// FALLBACK - used all the nodes, just go to a pos
		self SetGoalPos( ( 596, 564, -104 ) );
	}
	else
	{
		node = get_random( level.metrogateRegroupNodes );
		self SetGoalNode( node );
		
		// take that node out of the array so nobody else uses it
		level.metrogateRegroupNodes = array_remove( level.metrogateRegroupNodes, node );
	}
}

building_collapse_monitor_victims( numExecutions )
{
	// wait for the guys to spawn
	flag_wait( "street_execution_guys_spawning" );
	
	wait( 0.1 );

	if( is_german_build() )
	{
		flag_set( "street_executions_death_watcher_started" );
		wait( 1 );
		flag_set( "e1_street_executions_done" );
		return;
	}

	victims = get_ai_group_ai( "ai_e1_street_execution_victims" );
	ASSERTEX( IsDefined( victims ) && victims.size > 0, "Couldn't find any street execution victims!" );
	ASSERTEX( victims.size == numExecutions, "Didn't find enough victims for the number of street executions" );
	
	flag_set( "street_executions_death_watcher_started" );
	
	// BJoyal - Added a limit to how long the script waits due to a rare bug of this event never ending.
	thread building_collapse_monitor_victims_safety_net();
	
	while( 1 )
	{
		victimsAlive = false;
		
		for( i = 0; i < victims.size; i++ )
		{
			if( is_active_ai( victims[i] ) )
			{
				// if any are alive, that's all we need to know
				victimsAlive = true;
				break;
			}
		}
		
		// if none are still around, break the loop
		if( !victimsAlive || flag( "metrogate_executions_done" ) )
		{
			break;
		}
		
		wait( 0.1 );
	}
	
	flag_set( "e1_street_executions_done" );
}

building_collapse_monitor_victims_safety_net()
{
	wait(15);
	
	flag_set( "e1_street_executions_done" );	
	
	wait(5);
	
	flag_set( "metrogate_reach_done" );
}

street_execution_gunshotFX( executioner )
{	
	// collect all the info about the victim before he dies
	victim = executioner.victim;
	
	fxSpot_head = undefined;
	fxSpot_clavicle_left = undefined;
	fxSpot_clavicle_right = undefined;
	fxSpot_spine = undefined;
	
	// the victim could be dead already
	if( IsDefined( victim ) )
	{
		fxSpot_head = victim GetTagOrigin( "J_Brow_RI" );
		fxSpot_clavicle_left = victim GetTagOrigin( "j_clavicle_le" );
		fxSpot_clavicle_right = victim GetTagOrigin( "j_clavicle_ri" );
		fxSpot_spine = victim GetTagOrigin( "j_spine4" );
	}
	
	executioner notify( "execution_gunshot" );
	
	PlayFxOnTag( level._effect["rifleflash"], executioner, "tag_flash" );  // muzzleflash
	
	if( IsDefined( fxSpot_head ) && is_mature() )
	{
		forward = AnglesToForward( ( executioner GetTagAngles( "tag_flash" ) ) );
		PlayFX( level._effect["headshot"], fxSpot_head, forward );  // blood
	}
	
	wait( 0.2 );
	PlayFxOnTag( level._effect["rifle_shelleject"], executioner, "tag_brass" );  // shell eject
}
// --- END STREET EXECUTION STUFF ---


// --- METROGATE EXECUTION STUFF ---
metrogate_execution( guys )
{
	thread battlechatter_off( "allies" );
	thread battlechatter_off( "axis" );
	
	/#
	level thread maps\_debug::set_event_printname( "Event 2 - Metro Gate Execution", true );
	#/
	
	flag_init( "molotovs_throw" );
	flag_init( "molotovs_cancel" );
	
	gate = GetEnt( "subway_entrance_gate", "targetname" );
	ASSERTEX( IsDefined( gate ), "Can't find the subway gate!" );
	
	sarge = level.sarge;
	hero1 = level.hero1;
	
	redshirts[0] = guys[0];
	redshirts[1] = guys[1];
	redshirts[2] = guys[2];
	redshirts[3] = guys[3];
	
	array_thread( redshirts, ::magic_bullet_shield_safe );
	
	sarge set_animname_custom( "metrogate_exe_sarge" );
	hero1 set_animname_custom( "metrogate_exe_hero1" );
	redshirts[0] set_animname_custom( "metrogate_exe_redshirt1" );
	redshirts[1] set_animname_custom( "metrogate_exe_redshirt2" );
	redshirts[2] set_animname_custom( "metrogate_exe_redshirt3" );
	redshirts[3] set_animname_custom( "metrogate_exe_redshirt4" );
	
	//array_thread( redshirts, ::metrogate_print_animname );
	
	// put into one array for convenience
	friends[0] = sarge;
	friends[1] = hero1;
	friends = array_combine( friends, redshirts );
	
	array_thread( friends, ::scr_ignoreall, true );
	
	// send friends to correct spots
	// metrogate_reach also kicks off all of the molotov throwing logic
	thread metrogate_reach_watcher( friends.size );
	array_thread( friends, ::metrogate_reach, gate );
	
	axis = [];
	if( is_german_build() == false )
	{
		spawners[0] = getent_safe( "metrogate_axis_1", "targetname" );
		spawners[1] = getent_safe( "metrogate_axis_2", "targetname" );
		spawners[2] = getent_safe( "metrogate_axis_3", "targetname" );
		
		//axis = [];
		for( i = 0; i < spawners.size; i++ )
		{
			animname = "metrogate_exe_german" + ( i + 1 );
			spawners[i].origin = GetStartOrigin( gate.origin, gate.angles, level.scr_anim[animname]["scene"] );
			spawners[i].angles = GetStartAngles( gate.origin, gate.angles, level.scr_anim[animname]["scene"] );
			guy = spawn_guy( spawners[i] );
			guy.ignoreme = true;
			guy.ignoreall = true;
			guy.goalradius = 12;
			guy SetCanDamage( false );
			guy.allowdeath = false;
			guy.health = 1000000;
			guy set_animname_custom( animname );
			axis[axis.size] = guy;
		}
		
		// clean up spawners
		thread delete_group( spawners, 5 );
		
		level.metrogate_axis = axis;
		
		level thread metrogate_axis_deathwatcher( axis );
	}
	
	// BJoyal - Moved this to before the way to prevent issues where player beats AI to the metro, causing progression issues
	if( is_german_build() == false )
	{
		for( i = 0; i < axis.size; i++ )
		{
			axis[i] SetCanDamage( true );
			axis[i].allowdeath = true;
			axis[i].health = 1;
		}
	}
	
	// wait for guys to reach
	flag_wait( "metrogate_reach_done" );
	
	// Alex Liu: The range check was not accurate. If player skirts around the perimeter
	//           he can get a clear shot at the enemies, without triggering the event.
	//		     A trigger has been placed across the entire width of the street, so the
	// 			 player must have hit it before getting a view down the subway entrance.

	// wait for player to get close
	//waittill_player_within_range( ( 888, 760, -144 ), 500, 0.05 );
	close_trigger = getent( "metro_gate_approaching", "targetname" );
	close_trigger waittill( "trigger" );

	// warp players into scene
	enable_trigger_with_noteworthy( "trig_coop_warp_metrogate_execution" );
	
	// BJoyal - Old place for turning on the ability for the germans to be killed
	
	gate notify( "heroes_stopidle" );
	flag_set( "metrogate_execution_player_close" );
	
	// save
	autosave_by_name( "ber2_metrogate_execution" );
	

	if( is_german_build() )
	{
		flag_set( "molotovs_cancel" );
	}
	else
	{
		// play scene
		actors[0] = sarge;
		actors[1] = hero1;
		allies = [];				// BJoyal - keep a seperate copy of the allies array
		allies = actors;
		
		actors = array_combine( actors, axis );
		
		if( !flag( "molotovs_cancel" ) && !flag( "molotovs_throw" ) )
		{
			gate thread anim_single( actors, "scene" );
			metrogate_scene_abort( actors[0] );
		}
		
		if( !flag( "molotovs_cancel" ) && !flag( "molotovs_throw" ) )
		{
			// start idles
			
			// BJoyal - Seperated the axis from the rest of those in the animation in case only one is killed, which causes popping issues
			//gate thread anim_loop( actors, "idle2", undefined, "stop_wait_loop" );	
			gate thread anim_loop( allies, "idle2", undefined, "stop_wait_loop" );	
			
			for(i = 0; i < axis.size; i++)
			{
				if( isdefined(axis[i]) && isalive(axis[i]) )
				{
					gate thread anim_loop_solo( axis[i], "idle2" );	
				}
			}			
			
			level thread metrogate_playerchoice_wait( 5 );
		}
		
		while( !flag( "molotovs_cancel" ) && !flag( "molotovs_throw" ) )
		{
			wait( 0.05 );
		}
	}
	
	gate notify( "stop_wait_loop" );
	
	friends = array_remove( friends, hero1 );
	friends = array_remove( friends, sarge );
	
	// if molotovs were cancelled, gun the guys down
	if( flag( "molotovs_cancel" ) )
	{
		array_thread( axis, ::scr_ignoreme, false );
		array_thread( friends, ::scr_ignoreall, false );
	}
	
	// different anims/dialogue based on what happened
	sargeAnim = undefined;
	if( flag( "molotovs_cancel" ) )
	{
		sargeAnim = "escape_mercy";
		russian_diary_event( "good" );
	}
	else
	{
		sargeAnim = "escape_burn";
		russian_diary_event( "evil" );
	}
	
	gate thread anim_single_solo( hero1, "escape" );
	gate thread anim_single_solo( sarge, sargeAnim );
	
	// TODO wait for danger notetrack
	sarge waittillmatch( "single anim", "mortar_fire" );
	
	array_thread( redshirts, ::stop_magic_bullet_shield_safe );
	
	sarge thread scr_ignoreall( false );
	hero1 thread scr_ignoreall( false );
	array_thread( friends, ::scr_ignoreall, false );
	array_thread( friends, ::reset_animname );
	
	flag_set( "metrogate_executions_done" );
}

/*
metrogate_print_animname()
{
	self endon( "death" );
	
	while( 1 )
	{
		Print3D( self.origin, self.animname, ( 1, 1, 1 ), 1, 0.3 );
		wait( 0.05 );
	}
}
*/

// stops the "scene" part of the sequence short if the player shoots someone
metrogate_scene_abort( guy )
{
	level endon( "molotovs_cancel" );
	level endon( "molotovs_throw" );
	
	thread metrogate_scene_heroes_reset();
	
	guy waittillmatch( "single anim", "end" );
	level notify( "metrogate_scene_segment_done" );
}

// the heroes look dumb if they keep doing their scripted anims when the scene is supposed to be aborted
metrogate_scene_heroes_reset()
{
	level endon( "metrogate_scene_segment_done" );
	
	flag_wait_either( "molotovs_cancel", "molotovs_throw" );
	
	level.sarge StopAnimScripted();
	level.hero1 StopAnimScripted();
}

metrogate_reach_watcher( requiredReaches )
{
	numReaches = 0;
	
	while( numReaches < requiredReaches )
	{
		level waittill( "metrogate_reached" );
		numReaches++;
	}
	
	flag_set( "metrogate_reach_done" );
}

metrogate_reach( gate )
{
	if( self == level.sarge || self == level.hero1 )
	{
		gate anim_reach_solo( self, "scene" );
		self thread metrogate_reach_notifysafe();
		
		gate anim_loop_solo( self, "idle1", undefined, "heroes_stopidle" );
	}
	else
	{
		gate anim_reach_solo( self, "molotov_takeout" );
		self thread metrogate_reach_notifysafe();
		
		// spawn a temp reference org so we can notify just for this guy to stop his first idle
		org = Spawn( "script_origin", gate.origin );
		org.angles = gate.angles;
		org thread anim_loop_solo( self, "molotov_idle1", undefined, "stop_idle1" );
		
		while( !flag( "metrogate_execution_player_close" ) )
		{
			wait( 0.1 );
		}
		
		if( !flag( "molotovs_cancel" ) && !flag( "molotovs_throw" ) )
		{
			wait( RandomFloatRange( 1, 2.25 ) );
		}
		
		org notify( "stop_idle1" );
		
		if( !flag( "molotovs_cancel" ) && !flag( "molotovs_throw" ) )
		{
			self thread anim_light_molotov();
			gate anim_single_solo( self, "molotov_takeout" );
			self thread metrogate_redshirt_think( gate );
		}
		
		if( !flag( "molotovs_cancel" ) && !flag( "molotovs_throw" ) )
		{
			gate anim_loop_solo( self, "molotov_idle2", undefined, "molotov_guys_stopidle" );
		}
		
		org Delete();
	}
}

anim_light_molotov()
{
	self endon( "death" );
	
	molotov = "weapon_rus_molotov_grenade";
	molotov_linkTag = "tag_inhand";
	molotov_flameFX = level._effect["molotov_flame"];
	molotov_flameTag = "tag_fx";
	
	zippo = "weapon_rus_zippo";
	zippo_linkTag = "tag_weapon_left";
	zippo_flameFX = level._effect["zippo_flame"];
	zippo_flameTag = "tag_fx";
	
	// attach molotov
	self waittillmatch( "single anim", "attach_molotov" );
	self.molotov = Spawn( "script_model", self GetTagOrigin( molotov_linkTag ) );
	self.molotov.angles = self GetTagAngles( molotov_linkTag );
	self.molotov SetModel( molotov );
	self.molotov LinkTo( self, molotov_linkTag );
	
	// attach zippo and light it
	self waittillmatch( "single anim", "attach_zippo" );
	self.zippo = Spawn( "script_model", self GetTagOrigin( zippo_linkTag ) );
	self.zippo.angles = self GetTagAngles( zippo_linkTag );
	self.zippo SetModel( zippo );
	self.zippo LinkTo( self, zippo_linkTag );
	PlayFxOnTag( zippo_flameFX, self.zippo, zippo_flameTag );
	
	// light molotov
	//  semi-hacky since I have to spawn a new script_model so I can snuff the flame separately
	//  (can't attach b/c the character already has a gun attached with a tag_flash)
	self waittillmatch( "single anim", "light" );
	self.molotov_fxOrg = Spawn( "script_model", self.molotov GetTagOrigin( molotov_flameTag ) );
	self.molotov_fxOrg SetModel( "tag_origin" );
	self.molotov_fxOrg.angles = self.molotov GetTagAngles( molotov_flameTag );
	self.molotov_fxOrg LinkTo( self.molotov, molotov_flameTag );
	PlayFxOnTag( molotov_flameFX, self.molotov_fxOrg, "tag_origin" );
	
	// detach zippo
	self waittillmatch( "single anim", "detach_zippo" );
	self.zippo Unlink();
	self.zippo Delete();
	
	// wait for either animation to handle detaching and killing molotov FX
	self thread molotov_waitforthrow();
	self thread molotov_waitforputaway();
}

molotov_waitforthrow()
{
	self endon( "molotov_threadkill" );
	
	self waittillmatch( "single anim", "throw" );
	self.molotov_fxOrg Unlink();
	self.molotov_fxOrg Delete();
	self.molotov Unlink();
	self.molotov Delete();
	
	self notify( "molotov_threadkill" );
}

molotov_waitforputaway()
{
	self endon( "molotov_threadkill" );
	
	self waittillmatch( "single anim", "snuff" );
	self.molotov_fxOrg Unlink();
	self.molotov_fxOrg Delete();
	
	self waittillmatch( "single anim", "detach_molotov" );
	self.molotov Unlink();
	self.molotov Delete();
	
	self notify( "molotov_threadkill" );
}

metrogate_reach_notifysafe()
{
	if( !IsDefined( level.metrogate_notifying ) )
	{
		level.metrogate_notifying = true;
	}
	else
	{
		while( level.metrogate_notifying )
		{
			wait( 0.05 );
		}
	}
	
	level notify( "metrogate_reached" );
	level.metrogate_notifying = false;
}

metrogate_axis_deathwatcher( guys )
{
	level endon( "molotovs_throw" );
	
	while( 1 )
	{
		foundOne = false;
		guy = undefined;
		
		for( i = 0; i < guys.size; i++ )
		{
			if( !IsAlive( guys[i] ) )
			{
				foundOne = true;
				guy = guys[i];
				break;
			}
		}
		
		if( foundOne )
		{
			break;
		}
		
		wait( 0.05 );
	}
	
	// if he died from grenade/molotov damage, the player was not merciful
	if( IsDefined( guy ) && IsDefined( guy.damagemod ) &&
		( guy.damagemod == "MOD_BURNED" || guy.damagemod == "MOD_GRENADE_SPLASH" ) )
	{
		flag_set( "molotovs_throw" );
	}
	else
	{
		flag_set( "molotovs_cancel" );		
	}
}

metrogate_playerchoice_wait( waitTime )
{
	level endon( "molotovs_cancel" );
	
	timer = "metrogate_playerchoice_timer";
	set_timer( timer, waitTime );
	
	println( "make your choice!" );
	
	while( !timer_expired( timer ) )
	{
		wait( 1 );
	}
	
	flag_set( "molotovs_throw" );
}

metrogate_redshirt_think( gate )
{
	level endon( "molotovs_cancel" );
	self thread metrogate_abort_throw( gate );
	
	flag_wait( "molotovs_throw" );
	
	gate notify( "molotov_guys_stopidle" );
	self thread metrogate_throw_molotov();
	gate anim_single_solo( self, "molotov_throw" );
}

metrogate_abort_throw( gate )
{
	level endon( "molotovs_throw" );
	
	flag_wait( "molotovs_cancel" );
	
	gate notify( "molotov_guys_stopidle" );
	gate anim_single_solo( self, "molotov_putaway" );
}

metrogate_throw_molotov()
{
	self waittillmatch( "single anim", "throw" );
	
	self.ogGrenadeWeapon = self.grenadeweapon;
	self.grenadeweapon = "molotov";
	self.grenadeAmmo++;
	
	// default throw target, in case we can't find a dude for some reason
	throwTarget_default = ( 946, 648, -164 );
	throwTarget = throwTarget_default;
	
	// tags that will be satisfying throw targets
	targetTags[0] = "J_Head";
	targetTags[1] = "J_SpineUpper";
	targetTags[2] = "J_SpineLower";
	targetTags[3] = "J_Ankle_LE";
	
	livingTarget = undefined;
	
	for( i = 0; i < level.metrogate_axis.size; i++ )
	{
		guy = level.metrogate_axis[i];
		if( IsDefined( guy ) )
		{
			if( !IsDefined( guy.molotovTargeted ) )
			{
				guy.molotovTargeted = true;
				livingTarget = guy;
				break;
			}
		}
	}
	
	// if we didn't find an untargeted guy...
	if( !IsDefined( livingTarget ) )
	{
		// maybe they're all targeted already, let's just try to get a random one
		guys = array_randomize( level.metrogate_axis );
		for( k = 0; k < guys.size; k++ )
		{
			if( IsDefined( guys[k] ) )
			{
				livingTarget = guys[k];						
				break;
			}
		}
	}
	
	// so, if we found a target...
	if( IsDefined( livingTarget ) )
	{
		// pick a tag and set that as the throw target
		throwTarget = livingTarget GetTagOrigin( get_random( targetTags ) );
	}
	
	// two guys need custom stuff b/c MagicGrenade is not working for them
	// TODO THIS IS STILL NOT WORKING, MAGIC GRENADE DOES NOT LIKE IT FOR SOME REASON
	if( self.animname == "metrogate_exe_redshirt3" || self.animname == "metrogate_exe_redshirt4" )
	{
		if( IsDefined( livingTarget ) )
		{
			livingTarget.molotovTargeted = false;
		}
		
		throwTarget = throwTarget_default;
	}
	
	throwStart = self GetTagOrigin( "tag_inhand" );
	
	self MagicGrenade( throwStart, throwTarget );
	
	self.grenadeweapon = self.ogGrenadeWeapon;
	
	wait( 0.9 );
	
	// force him on fire - only once though
	if( IsDefined( livingTarget ) && !IsDefined( livingTarget.molotovDeath ) )
	{
		livingTarget.molotovDeath = true;
		
		livingTarget animscripts\death::flame_death_fx();
		
		if( IsAlive( livingTarget ) )
		{
			deathArray[0] = %ai_flame_death_A;
			deathArray[1] = %ai_flame_death_B;
			deathArray[2] = %ai_flame_death_C;
			deathArray[3] = %ai_flame_death_D;
			
			livingTarget.deathanim = get_random( deathArray );
			
			livingTarget DoDamage( self.health + 1, ( 0, 0, 0 ) );
		}
	}
}
// --- END METROGATE EXECUTION STUFF ---


// --- SUBWAY GATE OPENING STUFF ---
subway_gate_action()
{
	//objective_ring( 0 );
	set_color_chain( "trig_script_color_allies_b23" );
	
	holder = level.sarge;
	opener = level.hero1;
	
	// open gate
	level thread open_subway_gate( opener, holder );

	//TUEY Sets music state to Subway
	setmusicstate("SUBWAY");
}

open_subway_gate( opener, holder)
{
	gate = GetEnt( "subway_entrance_gate", "targetname" );
	gateclip = GetEnt( "subway_entrance_gate_clip", "targetname" );
	ASSERTEX( IsDefined( gate ), "Can't find the subway gate!" );
	ASSERTEX( IsDefined( gateclip ), "Can't find the subway gate clip!" );
	
	// set these guys up
	guys = [];
	guys[0] = opener;
	guys[1] = holder;
	
	for( i = 0; i < guys.size; i++ )
	{
		guy = guys[i];
		guy.og_animname = guy.animname;
		guy PushPlayer( true );
		guy.ignoreme = true;
		guy.ignoreall = true;
	}
	
	opener.animname = "metro_gate_opener";
	holder.animname = "metro_gate_holder";
	
	// turn off lightning so it doesn't mess with subway fog settings
	level.disableLightning = true;
	
	// friendlies run to gate
	gate anim_reach( guys, "open" );
	
	// open gate
	gate notify( "stop_beam_resting_idle" );
	gate thread subway_gate_woodbeam_anim_single( "open" );
	
	opener thread opener_move( "open" );
	gate thread subway_gate_openanim();
	gate thread gate_hold_loop( holder );
	gate thread anim_single_solo_earlyout( opener, "open" );
	gate thread anim_single_solo( holder, "open" );
	
	// wait for opener to be out of the way
	holder waittillmatch( "single anim", "gate_clear" );
	
	// move the clip out of the way
	gateclip ConnectPaths();
	gateclip.og_origin = gateclip.origin;
	gateclip MoveTo( gateclip.origin + ( 0, 0, -10000 ), 0.05 );
	gateclip waittill( "movedone" );
	
	level notify( "subway_gate_opened" );
	
	objective_position( 0, getstruct_safe( "struct_into_subway_gate", "targetname" ).origin );
	
	ASSERTEX( level.friends.size > 3, "Not enough guys in level.friends to move some over to a new chain." );
	
	// set half of the friendlies onto the second color chain
	secondChainGroup = [];
	
	for( i = 0; i < level.friends.size; i++ )
	{
		// we only want half of them moving over
		if( secondChainGroup.size >= ( (level.friends.size / 2) ) )
		{
			break;
		}
		
		guy = level.friends[i];
		
		if( guy != level.sarge )
		{
			secondChainGroup[secondChainGroup.size] = guy;
		}
	}
	
	ASSERTEX( secondChainGroup.size > 0, "The second chain group of AIs didn't get set up." );
	
	for( i = 0; i < secondChainGroup.size; i++ )
	{
		secondChainGroup[i] set_force_color( "p" );
	}
	
	// send friendlies into the metro
	set_color_chain( "trig_script_color_allies_b24" );
	
	heightGate = -276;  // the Z value that player origins have to be lower than for the gate to close
	xGate = 1600;  // greater than this and it's a fail because we have another metro entrance down the street
	
	// wait for AIs to move through
	while( 1 )
	{
		// make a new array that doesn't include the gate holder, since we know he's behind the gate
		nonHolders = [];
		
		for( i = 0; i < level.friends.size; i++ )
		{
			if( level.friends[i] != holder )
			{
				nonHolders[nonHolders.size] = level.friends[i];
			}
		}
		
		aiIsAboveGround = false;
		
		for( i = 0; i < nonHolders.size; i++ )
		{
			guy = nonHolders[i];
			if( guy.origin[2] > heightGate || guy.origin[0] > xGate )
			{
				// fail
				aiIsAboveGround = true;
				break;
			}
		}
		
		if( !aiIsAboveGround )
		{
			break;
		}
		else
		{
			wait( 0.05 );
		}
	}
	
	playerBugTime = 8;
	level.isBuggingPlayer = false;
	level.nextGateBug = GetTime() + ( playerBugTime * 1000 );
	
	// wait for players to move through
	while( 1 )
	{
		players = get_players();
		
		playerIsAboveGround = false;
		
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			if( player.origin[2] >= heightGate || player.origin[0] > xGate )
			{
				// fail
				playerIsAboveGround = true;
				break;
			}
		}
		
		if( !playerIsAboveGround )
		{
			break;
		}
		else
		{
			if( !level.isBuggingPlayer )
			{
				if( GetTime() > level.nextGateBug )
				{
					thread subway_gate_bugplayer();
					level.nextGateBug = GetTime() + ( playerBugTime * 1000 );
				}
			}
			wait( 0.05 );
		}
	}
	
	// move clip back into place
	gateclip MoveTo( gateclip.og_origin, 0.05 );
	gateclip waittill( "movedone" );
	gateclip DisconnectPaths();
	
	// animate gate/beam and AI closing
	gate notify( "stop_holding_gate" );
	gate thread subway_gate_closeanim();
	
	gate notify( "stop_beam_holding_idle" );
	gate thread subway_gate_woodbeam_anim_single( "close" );
	gate anim_single_solo( holder, "close" );
	
	set_objective( 6 );
	
	flag_set( "subway_gate_closed" );
	clientNotify( "subway_gate_closed" );
	
	// reset guys to pre-anim states
	for( i = 0; i < guys.size; i++ )
	{
		guy = guys[i];
		guy.animname = guy.og_animname;
		guy PushPlayer( false );
		guy.ignoreme = false;
		guy.ignoreall = false;
	}
	
	// put the holder back on the color chain
	holder set_force_color( "b" );
	
	thread battlechatter_on( "allies" );
	thread battlechatter_on( "axis" );
	
	// "Split up - cover both platforms."
	level.sarge playsound_generic_facial( "Ber2_IGD_080A_REZN" );
}

gate_hold_loop( holder )
{
	holder waittillmatch( "single anim", "end" );
	
	// hold gate
	self thread anim_loop_solo( holder, "hold", undefined, "stop_holding_gate" );
	
	// wood beam animate
	self thread subway_gate_woodbeam_anim_loop( "hold", "stop_beam_holding_idle" );
}

subway_gate_bugplayer()
{
	level.isBuggingPlayer = true;
	
	bugLines[0] = "Ber2_IGD_076A_REZN";  // "This way!"
	bugLines[1] = "Ber2_IGD_077A_REZN";  // "Get down here!"
	bugLines[2] = "Ber2_IGD_078A_REZN";  // "Hurry!"
	bugLines[3] = "Ber2_IGD_201A_REZN";  // "Move faster - We have to escape the barrage!"
	
	level.sarge playsound_generic_facial( get_random( bugLines ) );
	
	level.isBuggingPlayer = false;
}

// puts opener back on his color chain once his anim is done
opener_move( anime )
{
	animtime = GetAnimLength( level.scr_anim[self.animname][anime] );
	wait( animtime - 2 );
	
	self.og_goalradius = self.goalradius;
	self.goalradius = 16;

	// Alex Liu: The original position chernov was sent to is too deep into the subway
	//           It resulted in a sharp turn and drop-into-ground effect when blending 
    //			 out of the scripted anim. This new node is directly in front of chernov
	//			 and very close. Hopefully he will go straight forward a few steps before
	//			 turning.

	intermediate_node = getnode( "chernov_gate_enter_middle_node", "targetname" );
	self SetGoalNode( intermediate_node );
	
	self waittill( "goal" );
	self.goalradius = self.og_goalradius;
	self set_force_color( "b" );
}
// --- END SUBWAY GATE OPENING STUFF ---

// --- AMBIENT STUFF ---

event1_rooftop_rockets()
{
	level endon( "subway_gate_closed" );
	
	startSpots = GetStructArray( "struct_e1_rooftop_rockets", "targetname" );
	if( !IsDefined( startSpots ) || startSpots.size <= 0 )
	{
		ASSERTMSG( "can't find any rocket start spots for event1_rooftop_rockets()!" );
		return;
	}
	
	rocketModel = "katyusha_rocket";
	
	while( 1 )
	{
		startSpots = array_randomize( startSpots );
		
		for( i = 0; i < startSpots.size; i++ )
		{
			thread rocket_fake_fire( startSpots[i], rocketModel, 7 );
			//Kevin adjusted this to match the _katyusha.gsc salvo speed
			wait( RandomFloatRange( 0.2, 0.25 ) );
		}
		
		// wait for next flurry
		wait( RandomFloatRange( 10, 20 ) );
	}
}

// spawns a rocket model at an entity's location and "fires" it off
rocket_fake_fire( startSpot, rocketModel, moveTime, speed )
{
	while( !OkTospawn() )
	{
		wait( 0.1 ); 
	}
			
	rocket = Spawn( "script_model", startSpot.origin );
	rocket SetModel( rocketModel );
	rocket.angles = startSpot.angles;
	rocket playloopsound( "katy_rocket_run" );

	thread rocket_move( rocket, moveTime, speed );
}

// actually moves the rocket when it is "fired"
rocket_move( rocket, moveTime, speed )
{
	if( !IsDefined( moveTime ) || moveTime <= 0 )
	{
		moveTime = 5.0;
	}
	
	if( !IsDefined( speed ) || speed <= 0 )
	{
		speed = 3000;
	}

	// derive velocity
	velocity = AnglesToForward( rocket.angles ) * speed;

	// start the particle
	PlayFxOnTag( level._effect["katyusha_rocket_trail"], rocket, "tag_origin" );
	
	// play launching sound
	thread play_sound_in_space( "katyusha_launch", rocket.origin );

	// move the rocket
	rocket MoveGravity( velocity, moveTime );

	// notify that we fired the rocket
	rocket notify( "rocket_fired" );

	// wait until the rocket is done moving, then delete it
	wait( moveTime );
	rocket Delete();
}
// --- END AMBIENT STUFF ---

// --- CHAIR ANIMTREE ---
#using_animtree( "ber2_chair" );

telegrapher_chair_anims( guy )
{
	self UseAnimTree( #animtree );
	
	tappingAnim = level.scr_anim["telegrapher_chair"]["tapping"];
	self thread telegrapher_chair_animloop( guy, tappingAnim );
	
	self waittill( "stop_telegraphing" );
	
	if( IsAlive( guy ) )
	{
		self SetFlaggedAnimKnob( "death_anim", level.scr_anim["telegrapher_chair"]["tapping_death"], 1.0, 0.2, 1.0 );
		self waittillmatch( "death_anim", "end" );
	}
	else
	{
		self ClearAnim( tappingAnim, 0 );
	}
}

telegrapher_chair_animloop( guy, tappingAnim )
{
	self endon( "stop_telegraphing" );
	
	while( IsAlive( guy ) )
	{
		self SetFlaggedAnimKnob( "idle_anim", tappingAnim, 1.0, 0.2, 1.0 );
		self waittillmatch( "idle_anim", "end" );
	}
}

// --- GATE ANIMTREE ---
#using_animtree( "ber2_metro_entrance_gate" );

// self = the subway gate
subway_gate_openanim()
{
	self UseAnimTree( #animtree );
	self SetFlaggedAnimKnob( "metrogate_anim", level.scr_anim["metro_gate_model"]["open"], 1.0, 0.2, 1.0 );
	self waittillmatch( "metrogate_anim", "end" );
}

// self = the subway gate
subway_gate_closeanim()
{
	self SetFlaggedAnimKnob( "metrogate_anim", level.scr_anim["metro_gate_model"]["close"], 1.0, 0.2, 1.0 );
	self waittillmatch( "metrogate_anim", "end" );
}

// --- WOODBEAM ANIMTREE ---
#using_animtree( "ber2_woodbeam" );

// spawns the wooden beam for the subway gate and idles it
subway_gate_woodbeam_init()
{
	animRef = "resting";
	anime = level.scr_anim["metrogate_woodbeam"][animRef][0];
	gate = getent_safe( "subway_entrance_gate", "targetname" );
	
	origin = GetStartOrigin( gate.origin, gate.angles, anime );
	angles = GetStartAngles( gate.origin, gate.angles, anime );
	
	beam = Spawn( "script_model", origin );
	beam.angles = angles;
	beam SetModel( "berlin_wood_beam_short" );
	
	beam UseAnimTree( #animtree );
	beam.animname = "metrogate_woodbeam";
	
	level.metrogate_woodbeam = beam;
	
	gate thread subway_gate_woodbeam_anim_loop( animRef, "stop_beam_resting_idle" );
}

subway_gate_woodbeam_anim_single( animRef )
{
	self anim_single_solo( level.metrogate_woodbeam, animRef );
	level.metrogate_woodbeam waittillmatch( "single anim", "end" );
}

subway_gate_woodbeam_anim_loop( animRef, ender )
{
	self thread anim_loop_solo( level.metrogate_woodbeam, animRef, undefined, ender );
}

// --- FLAG ANIMTREE ---
#using_animtree( "ber2_flag" );

street_bank_flag_anims( flag, guy )
{
	anime = level.scr_anim[flag.animname]["unfurl"];
	
	guy waittillmatch( "single anim", "start_flag" );
	flag Show();
	
	flag.origin = GetStartOrigin( self.origin, self.angles, anime );
	
	flag UseAnimTree( #animtree );
	flag SetFlaggedAnimKnob( "unfurl_anim", anime, 1.0, 0.2, 1.0 );
	flag waittillmatch( "unfurl_anim", "end" );
	
	while( 1 )
	{
		flag SetFlaggedAnimKnob( "idle_anim", level.scr_anim[flag.animname]["idle"], 1.0, 0.2, 1.0 );
		flag waittillmatch( "idle_anim", "end" );
	}
}
