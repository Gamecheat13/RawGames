//
// file: ber3b_event_foyer.gsc
// description: reichstag foyer event script for berlin3b
// scripter: slayback
//

#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\ber3b;
#include maps\ber3b_anim;
#include maps\ber3_util;
#include maps\_music;

#using_animtree( "generic_human" );

// -- STARTS --
// start at the beginning of the map, including the intro stuff
event_intro_start()
{		
	share_screen( get_host(), true, true );

	warp_players_underworld();
	
	thread battlechatter_off( "allies" );
	
	// DIARY
	doIntroscreen = GetDvarInt( "introscreen" );
	if( IsDefined( doIntroscreen ) && doIntroscreen > 0 )
	{
		
		diary_reading();
	}
	
	thread introscene_closedoors_near();
	thread foyer_spawn_redshirts_1();
	
	level waittill( "introscene_closedoors_near_warpdone" );
	
	warp_friendlies( "struct_foyer_frontdoor_start_friends", "targetname" );
	warp_players( "struct_foyer_frontdoor_start", "targetname" );
	
	setup_commissar();
	
	//Kevins notify to start speech and march outisde
	level notify ("hitler_speak");
	
	thread intro_fakefire();
	event_foyer_introscene();
	
	thread battlechatter_on( "allies" );

	level thread event_foyer_setup();
}

// start at the beginning of the map, skipping the intro
event_foyer_start()
{
	warp_players_underworld();
	
	thread introscene_closedoors_near();
	thread foyer_spawn_redshirts_1();
	
	level waittill( "introscene_closedoors_near_warpdone" );
	
	setup_commissar();
	warp_commissar_to_intro_spot();
	
	warp_friendlies( "struct_foyer_frontdoor_start_friends", "targetname" );
	warp_players( "struct_foyer_frontdoor_start", "targetname" );
	
	thread intro_fakefire();
	
	// functions otherwise called during the introscene
	thread introscene_closedoors_far();
	level notify( "introscene_closedoors_near_startanim" );

	level thread event_foyer_setup();
}

// start at the top of the foyer steps, just before the first pacing area
event_foyer_pacing_start()
{
	warp_players_underworld();
	
	warp_friendlies( "struct_parliament_foyer_pacing_start_friends", "targetname" );
	warp_players( "struct_parliament_foyer_pacing_start", "targetname" );
	
	set_color_chain( "trig_script_color_allies_b5" );
	set_objective( 1 );
	
	// DEPRECATED
	//russian_flag_teleport( groundpos( ( 1128, 15984, 754 ) ) );
	
	level thread event_foyer_pacing_action();
}
// -- END STARTS --


// -- DIARY READING --
diary_reading()
{
	// doesn't start until introscreen knows that all the players have connected
	while( !IsDefined( level._introscreen ) )
	{
		wait( 0.05 );
	}
	
	while( !level._introscreen )
	{
		wait( 0.05 );
	}
	
	wait( 2 );

	clientNotify( "diaryreading_start" );
	//TUEY Set Music State to DIARY
	setmusicstate("DIARY");
	
	diaryLineTime = 23;  // hacky, but we have no other way of knowing when the sound should end
	EndTime = GetTime() + ( diaryLineTime * 1000 );
	
	// wait for host button press
	host = get_players()[0];
	
	fadeTime = 0.5;  // hud fade in/out time
	
	// only allow skipping after the text is done fading up
	level waittill( "finished final intro screen fadein" );

	//share_screen( get_host(), false, false );

	wait( 2.5 );

	/*
	host thread diary_hud( fadeTime );
	
	while( GetTime() < endTime )
	{
		if( host UseButtonPressed() )
		{
			//println("Notifying client diaryreading_skip");
			clientNotify( "diary_skip" );
			break;
		}
		else
		{
			wait( 0.05 );
		}
	}
	*/
	
	while( GetTime() < endTime )
	{
		wait( 0.5 );
	}
	
	host notify( "fade_diary_hud" );
	wait( 0.5 );
	
	// now tell introscreen to continue
	flag_set( level.introscreen_waitontext_flag );
}

/*
diary_hud( fadeTime )
{
	self endon( "disconnect" );
	
	diaryhud = NewClientHudElem( self );
	diaryhud.alignX = "center";
	diaryhud.alignY = "top";
	diaryhud.fontScale = 1.25;
	diaryhud.x = 330;
	diaryhud.y = 25;
	diaryhud.sort = 1;
	diaryhud.foreground = true;
	diaryhud.alpha = 0;
	
	diaryhud SetText( level.diary_skip );
	diaryhud FadeOverTime( fadeTime );
	diaryhud.alpha = 1;
	
	self waittill( "fade_diary_hud" );
	
	diaryhud FadeOverTime( fadeTime );
	diaryhud.alpha = 0;
	
	wait( fadeTime + 0.05 );
	diaryhud Destroy();
}
*/
// -- END DIARY READING --


// -- INTRO SCENE --
event_foyer_introscene()
{	
	//TUEY Set music state to INTRO
	setmusicstate("INTRO");
	
	// get players and friendlies in position
	thread crouch_players();
	thread align_friendlies();

	flag_init( "intro_interrupt" );
	thread introscene_playercheck();
	
	// introscreen doesn't show up on checkpoint restart
	doingIntroscreen = GetDvarInt( "introscreen" );
	if( IsDefined( doingIntroscreen ) && doingIntroscreen )
	{
		// waiting on custom flag now
		//level waittill( "finished final intro screen fadein" );
		flag_wait( level.introscreen_waitontext_flag );
		wait( 2 );
	}
	
	thread introscene_artystrikes();
	
	level notify( "introscene_closedoors_near_startanim" );
	thread introscene_closedoors_far();
	
	sarge = level.sarge;
	
	sarge.animname = "sarge";
	
	//animSpot = getnode_safe( "node_intro_align", "targetname" );
	animSpot = Spawn( "script_origin", sarge.origin );
	animSpot.angles = ( 0, 0, 0 );
	
	sarge thread anim_finished_notify( "intro_sarge_anim_done" );
	animSpot thread anim_single_solo_earlyout( sarge, "intro_peptalk" );
	
	level thread delayed_screen_restore( 2 );

	level waittill_any( "intro_interrupt", "intro_sarge_anim_done" );
	
	if( flag( "intro_interrupt" ) )
	{
		sarge anim_stopanimscripted();
	}
	
	level notify( "intro_finished" );
}

delayed_screen_restore( time )
{
	wait( time );
	share_screen( get_host(), false, false );
}

anim_finished_notify( notifystring )
{
	level endon( "intro_interrupt" );
	
	animtime = GetAnimLength( level.scr_anim["sarge"]["intro_peptalk"] );
	//self waittillmatch( "single anim", "end" );
	wait( animtime - 2 );
	
	level notify( notifystring );
}

introscene_artystrikes()
{
	level endon( "intro_finished" );
	level endon( "intro_interrupt" );
	
	minWait = 5;
	maxWait = 10;
	
	firstTime = true;
	
	while( 1 )
	{
		if( firstTime )
		{
			firstTime = false;
		}
		else
		{
			wait( RandomFloatRange( minWait, maxWait ) );
		}
		//kevin adding notify.  This has to be here to make these go off.
		level notify( "arty_strike" );
		thread arty_strike_on_players( RandomFloatRange( .2, .3 ), 3, 500 );
	}
}

// called at map start to set the doors up to the appropriate angles for the animation
setup_frontdoors()
{
	door1 = getent_safe( "sbmodel_frontdoor_set1_right", "targetname" );
	door2 = getent_safe( "sbmodel_frontdoor_set1_left", "targetname" );
	
	door1 ConnectPaths();
	door2 ConnectPaths();
	
	//door1.angles = ( 0, -150, 0 );
	//door2.angles = ( 0, 175, 0 );
	//door1.angles = ( 0, -90, 0 );
	//door2.angles = ( 0, 90, 0 );
	
	//door1 DisconnectPaths();
	//door2 DisconnectPaths();
}

introscene_closedoors_far()
{
	door1 = getent_safe( "sbmodel_frontdoor_set1_right", "targetname" );
	door2 = getent_safe( "sbmodel_frontdoor_set1_left", "targetname" );

	animSpot = getstruct_safe( "struct_intro_doors_animref_1", "targetname" );
	spawner1 = getent_safe( animSpot.target, "targetname" );
	spawner2 = getent_safe( spawner1.target, "targetname" );
	
	guy1 = spawn_guy( spawner1 );
	guy2 = spawn_guy( spawner2 );
	
	guys[0] = guy1;
	guys[1] = guy2;
	
	for( i = 0; i < guys.size; i++ )
	{
		guy = guys[i];
		guy.ignoreme = true;
		guy.ignoreall = true;
		guy PushPlayer( true );
	}
	
	guy1.animname = "intro_door_closer_1";
	guy2.animname = "intro_door_closer_2";
	
	animSpot anim_reach( guys, "closedoor" );
	
	door1 thread reichstag_dooranim( "reichstag_frontdoor_1", "closedoor", "frontdoor_anim" );
	door2 thread reichstag_dooranim( "reichstag_frontdoor_2", "closedoor", "frontdoor_anim" );
	animSpot anim_single( guys, "closedoor" );
	
	for( i = 0; i < guys.size; i++ )
	{
		guy = guys[i];
		guy.ignoreme = false;
		guy.ignoreall = false;
		guy PushPlayer( false );
		
		node = getnode_safe( guy.target, "targetname" );
		guy SetGoalNode( node );
		
		guy thread bloody_death_after_wait( 10, true, 5 );
	}
}

introscene_closedoors_near()
{
	door3 = getent_safe( "sbmodel_frontdoor_set2_right", "targetname" );
	door4 = getent_safe( "sbmodel_frontdoor_set2_left", "targetname" );
	animSpot = getstruct_safe( "struct_intro_doors_animref_2", "targetname" );
	spawner3 = getent_safe( animSpot.target, "targetname" );
	spawner4 = getent_safe( spawner3.target, "targetname" );
	
	guy3 = spawn_guy( spawner3 );
	guy4 = spawn_guy( spawner4 );
	
	guys[0] = guy3;
	guys[1] = guy4;
	
	for( i = 0; i < guys.size; i++ )
	{
		guy = guys[i];
		guy.ignoreme = true;
		guy.ignoreall = true;
		guy PushPlayer( true );
	}
	
	guy3.animname = "intro_door_closer_3";
	guy4.animname = "intro_door_closer_4";
	
	guy3 maps\_anim::set_start_pos( "closedoor", animSpot.origin, animSpot.angles, undefined );
	guy4 maps\_anim::set_start_pos( "closedoor", animSpot.origin, animSpot.angles, undefined );
	
	level notify( "introscene_closedoors_near_warpdone" );
	level waittill( "introscene_closedoors_near_startanim" );
	
	door3 thread reichstag_dooranim( "reichstag_frontdoor_3", "closedoor", "frontdoor_anim" );
	door4 thread reichstag_dooranim( "reichstag_frontdoor_4", "closedoor", "frontdoor_anim" );
	animSpot anim_single( guys, "closedoor" );
	
	for( i = 0; i < guys.size; i++ )
	{
		guy = guys[i];
		guy.ignoreme = false;
		guy.ignoreall = false;
		guy PushPlayer( false );
		
		node = getnode_safe( guy.target, "targetname" );
		guy SetGoalNode( node );
		
		guy thread bloody_death_after_wait( 10, true, 5 );
	}
}

introscene_playercheck()
{
	level endon( "intro_finished" );
	
	trig = getent_safe( "trig_script_color_allies_b1", "targetname" );
	
	while( IsDefined( trig ) )
	{
		trig waittill( "trigger", guy );
	
		if( IsPlayer( guy ) )
		{
			break;
		}
	}
	
	flag_set( "intro_interrupt" );
}

crouch_players()
{
	flag_wait( "warp_players_done" );
	
	players = get_players();
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		player SetStance( "crouch" );
	}
}

align_friendlies()
{	
	// move players so they don't have LOS to the teleport spots
	warp_players_underworld();
	
	warp_commissar_to_intro_spot();
	
	sargeSpot = getstruct_safe( "struct_intro_sarge_spot", "targetname" );
	level.sarge Teleport( groundpos( sargeSpot.origin ), sargeSpot.angles );
	
	// move players back
	warp_players( "struct_foyer_frontdoor_start", "targetname" );
	
	// crouch guys (not sarge)
	for( i = 0; i < level.friends.size; i++ )
	{
		guy = level.friends[i];
		
		if( is_active_ai( guy ) && guy != level.sarge )
		{
			guy AllowedStances( "crouch" );
		}
	}
	
	// wait for intro scene to be over or interrupted
	level waittill_any( "intro_finished", "intro_interrupt" );
	
	reset_friendlies();
}

reset_friendlies()
{
	for( i = 0; i < level.friends.size; i++ )
	{
		guy = level.friends[i];
		
		if( is_active_ai( guy ) )
		{
			guy AllowedStances( "stand", "crouch", "prone" );
		}
	}
}
// -- END INTRO SCENE --

setup_commissar()
{
	// set up the commissar
	commissar_spawner = getent_safe( "commissar", "targetname" );
	commissar = spawn_guy( commissar_spawner );
	commissar.ignoreme = true;
	commissar thread magic_bullet_shield_safe();
	
	// DEPRECATED
	// turn off color respawning on this guy
	//commissar disable_replace_on_death();
	
	level.commissar = commissar;
	
	ASSERTEX( is_active_ai( level.commissar ), "setup_commissar(): couldn't assign level.commissar." );
	
	thread commissar_action();
}

commissar_action()
{
	while( !IsDefined( level.commissar.wasWarped ) )
	{
		wait( 0.05 );
	}
	
	level.commissar animscripts\shared::placeWeaponOn( level.commissar.primaryweapon, "none" );
	level.commissar Attach( "clutter_berlin_megaphone", "tag_weapon_left" );
	
	level.commissar.animname = "commissar";
	level.commissar thread anim_loop_solo( level.commissar, "intro_idle", undefined, "idle_stop" );
	
	level waittill_any( "intro_finished", "intro_interrupt" );
	
	level.commissar notify( "idle_stop" );

	level.commissar anim_single_solo( level.commissar, "intro" );
	
	flag_set( "commissar_dialogue_done" );
	
	level.commissar thread anim_loop_solo( level.commissar, "intro_idle", undefined, "idle_stop" );
	
	wait( 10 );
	level.commissar wait_while_players_can_see( 400, 5 );
	
	level.commissar notify( "idle_stop" );
	level.commissar thread stop_magic_bullet_shield_safe();
	level.commissar Delete();
}

warp_commissar_to_intro_spot()
{
	comSpot = getstruct_safe( "struct_intro_commissar_spot", "targetname" );
	level.commissar Teleport( groundpos( comSpot.origin ), comSpot.angles );
	level.commissar.wasWarped = true;
}

event_foyer_setup()
{
	set_objective( 1 );
	
	thread event_foyer_action();
	thread foyer_mg();
	thread foyer_bazookateam();
	// DEPRECATED - commissar is no longer on a color chain
	// thread cleanup_forcecolor_redshirts( "g", "trig_pacing1_kicked_door", "targetname" );
	thread kill_aigroup_at_trigger( "trig_pacing1_kicked_door", "targetname", "ai_foyer_redshirts_1" );
}

event_foyer_action()
{
	set_color_chain( "trig_script_color_allies_b0" );
	
	thread foyer_intro_hallway_running_dialogue();
	
	thread event_foyer_pacing_action();

	thread foyer_force_ai_fire();
}

foyer_force_ai_fire()
{
	trigger = getent( "foyer_colors_stair_base", "targetname" );
	trigger waittill( "trigger" );

	autosave_by_name( "Ber1 reached stair" );

	enemies = GetAIArray( "axis" );
	for( i = 0; i < enemies.size; i++ )
	{
		enemies[i].ignoreme = false;
		if( enemies[i].origin[2] < 15216 )
		{
			enemies[i].health = 1;
		}
	}
}	

debug_print_ber3b()
{
	while( 1 )
	{
		print3d( self.origin + (0, 0, 40), "***", (1,1,1), 1, 3 );
		wait( 0.01 );
	}
}

foyer_intro_hallway_running_dialogue()
{	
	flag_wait( "commissar_dialogue_done" );
	//kevin adding notify.  This has to be here to make these go off.
	level notify( "arty_strike" );
	
	thread arty_strike_on_players( RandomFloatRange( .3, .4 ), 3, 500 );
	
	// "The building's still being shelled!!! We could be killed!"
	buddy = get_randomfriend_notsarge();
	buddy playsound_generic_facial( "Ber3B_IGD_000A_RUR2" );
	
	// "Then die with your hands around the throat of the enemy!!!"
	level.sarge playsound_generic_facial( "Ber3B_IGD_001A_REZN" );
	
	flag_set( "hallway_running_dialogue_done" );
}

event_foyer_pacing_action()
{
	thread pacing1_melees_init();
	thread pacing1_friendly_doorbreach();
	
	thread pacing1_fallbackers_kill();
	
	trigger_wait( "trig_parliament_entrance", "targetname" );
	
	// send control to parliament script
	maps\ber3b_event_parliament::event_parliament_setup();
}

pacing1_fallbackers_kill()
{
	trigger_wait( "trig_pacing1_melee1", "targetname" );
	
	enemies = get_ai_group_ai( "ai_pacing1_fallbackers" );
	
	array_thread( enemies, ::pacing1_fallbacker_kill );
}

pacing1_fallbacker_kill()
{
	self endon( "death" );
	
	self wait_while_players_can_see( 450, 5 );
	self thread bloody_death( true, 0 );
}

intro_fakefire()
{
	
	// CODER_MOD
	// DSL - Migrated fake fire over to the client side, so need to notify client scripts of state change
	// to get the party started. 
	
	if(level.clientscripts)
	{
		maps\_utility::setClientSysState("levelNotify", "intro_fakefire_start");
	}
	else
	{
		firePoints = GetStructArray( "struct_intro_fakefire", "targetname" );
		ASSERTEX( IsDefined( firePoints ) && firePoints.size > 0, "Can't find fakefire points." );
		
		array_thread( firePoints, maps\ber3b_fx::ambient_fakefire, "intro_fakefire_end", false );
	}
	
}

foyer_mg()
{
	trig = getent_safe( "trig_foyer_mgspawn", "targetname" );
	trig waittill( "trigger" );
	
	spawner = getent_safe( trig.target, "targetname" );
	node = getnode_safe( spawner.target, "targetname" );
	mg = getent_safe( node.target, "targetname" );
	
	mger = spawn_guy( spawner );
	mger.ignoreme = true;
	mger thread magic_bullet_shield();
	
	mger SetGoalNode( node );
	
	mger thread guy_stay_on_turret( mger, mg );
	
	level waittill( "bazookateam_fire" );
	mger notify( "stop magic bullet shield" );
	
	level waittill( "bazookateam_foyer_damage_done" );
	
	wait( 0.1 );
	
	if( IsDefined( mger ) && is_active_ai( mger ) )
	{
		mger DoDamage( mger.health + 5, ( 0, 0, 0 ) );
	}
	
	wait( 0.1 );
	
	if( IsDefined( mg ) )
	{
		mg Delete();
	}
}

foyer_bazookateam()
{
	trig = getent_safe( "trig_foyer_bazookateam", "targetname" );
	trig waittill( "trigger" );
	thread maps\ber3b_event_parliament::bazooka_team( trig );
		
	thread foyer_bazookateam_dialogue();
	
	// wait for damage trigger
	dmgtrig = getent_safe( "trig_damage_foyer_bazookateam_firearea", "targetname" );
	dmgtrig waittill( "trigger" );
	dmgtrig Delete();
	
	fxspot = getstruct_safe( "struct_foyer_bazookatarget_fxspot", "targetname" );
	intactGeo = GetEntArray( "scripted_foyer_center_emplacement", "targetname" );
	ASSERTEX( IsDefined( intactGeo ) && intactGeo.size > 0, "can't find foyer bazookateam intact geo" );
	
	PlayFX( level._effect["sandbag_explosion_small"], fxspot.origin );
	
	RadiusDamage( fxspot.origin, 238, 5000, 5000 );
	
	wait( 0.2 );
	
	for( i = 0; i < intactGeo.size; i++ )
	{
		intactGeo[i] Delete();
	}
	
	level notify( "bazookateam_foyer_damage_done" );
	
	flag_clear( "bazookateam_keep_firing" );
	
	weaponclip = getent_safe( "trig_foyer_bazooka_weaponclip", "targetname" );
	weaponclip Delete();
}

foyer_bazookateam_dialogue()
{
	sarge_giveorder( "positions_fortified_need_support", true );
	sarge_giveorder( "want_bazooka_team", true );
}

pacing1_melees_init()
{
	level thread pacing1_2man_melee( "trig_pacing1_melee1", "melee1" );
	level thread pacing1_2man_melee( "trig_pacing1_melee2", "melee2" );
}

pacing1_2man_melee( triggerTN, anime )
{
	beater_animname = "rtag_melee_beater";
	victim_animname = "rtag_melee_victim";
	
	trig = getent_safe( triggerTN, "targetname" );
	trig waittill( "trigger" );
	
	animSpot = getstruct_safe( trig.target, "targetname" );
	spawner_beater = getent_safe( animSpot.target, "targetname" );
	spawner_victim = getent_safe( spawner_beater.target, "targetname" );
	beater_goalnode = getnode_safe( spawner_beater.target, "targetname" );
	
	trig Delete();
	
	beater = spawn_guy( spawner_beater );
	victim = spawn_guy( spawner_victim );
	
	beater thread magic_bullet_shield_safe();
	
	victim.nodeathragdoll = true;
	
	beater.animname = beater_animname;
	victim.animname = victim_animname;
	victim.deathanim = level.scr_anim[victim_animname][anime];
	
	victim maps\_anim::set_start_pos( anime, animSpot.origin, animSpot.angles, undefined );
	//beater maps\_anim::set_start_pos( anime, animSpot.origin, animSpot.angles, undefined );
	
	//victim animscripts\shared::DropAllAIWeapons();
	victim DoDamage( victim.health + 5, ( 0, 0, 0 ) );
	animSpot anim_single_solo( beater, anime );
	
	// run the beater away and kill him
	beater.goalradius = 24;
	beater SetGoalNode( beater_goalnode );
	beater waittill( "goal" );
	
	beater thread stop_magic_bullet_shield_safe();
	beater thread bloody_death( true, 0 );
}

pacing1_friendly_doorbreach()
{
	startDistance = 710;
	
	trig = getent_safe( "trig_pacing1_kicked_door", "targetname" );
	
	trig waittill( "trigger" );
	
	spawners = GetEntArray( trig.target, "targetname" );
	enemies = GetEntArray( "spawner_pacing1_doorkick_enemy", "targetname" );
	animSpot = getstruct_safe( "struct_pacing1_kicked_door_animref", "targetname" );
	door = getent_safe( "sbmodel_pacing1_kicked_door", "targetname" );
	
	trig Delete();
	
	enemies thread pacing1_friendly_doorbreach_enemies();
	
	guys = [];
	
	for( i = 0; i < spawners.size; i++ )
	{
		guy = spawn_guy( spawners[i] );
		guy.ignoreme = true;
		guy.ignoreall = true;
		guy PushPlayer( true );
		guys[i] = guy;
	}
	
	guys[0].animname = "pacing1_doorkick_guy1";
	guys[1].animname = "pacing1_doorkick_guy2";
	idle_anime = "idle";
	kick_anime = "doorkick";
	
	// idle til player shows up
	animSpot anim_reach( guys, kick_anime );
	animSpot thread anim_loop( guys, idle_anime, undefined, "end_loop" );
	
	// wait for a player to get close before breaching
	waittill_player_within_range( animSpot.origin, startDistance, 0.05 );
	
	animSpot notify( "end_loop" );
	door thread reichstag_dooranim( "pacing1_doorbreach_door", "doorkick", "pacing1_doorkick" );
	animSpot thread anim_single_earlyout( guys, kick_anime );
	
	goalPos1 = ( 1000, 17736, 928 );
	goalPos2 = ( 968, 17616, 928 );
	
	guys[0] thread doorbreach_guy_finish( goalPos1, kick_anime );
	guys[1] thread doorbreach_guy_finish( goalPos2, kick_anime );
}

doorbreach_guy_finish( goalPos, anime )
{
	self endon( "death" );
	
	animtime = GetAnimLength( level.scr_anim[self.animname][anime] );
	wait( animtime - 2 );
	
	self.ignoreme = false;
	self.ignoreall = false;
	self PushPlayer( false );
		
	//guy set_force_color( "c" );
	self.goalradius = 200;
	self SetGoalPos( goalPos );
	self waittill( "goal" );
	self thread bloody_death_after_wait( 10, true, 5 );
}

// self = an array of spawners
pacing1_friendly_doorbreach_enemies()
{
	guys = [];
	
	for( i = 0; i < self.size; i++ )
	{
		guy = spawn_guy( self[i] );
		guy.ignoreme = true;
		guy.ignoreall = true;
		guy PushPlayer( true );
		guy SetGoalPos( guy.origin );
		guys[i] = guy;
	}
	
	level waittill( "friendly_doorbreach_dooropen" );
	
	//do animation
	guys[0].animname = "pacing1_doorkick_victim1";
	guys[1].animname = "pacing1_doorkick_victim2";
	anime = "surrender";
	
	guys[0] thread anim_single_solo( guys[0], anime );
	guys[1] thread anim_single_solo( guys[1], anime );
	
	wait( 1.5 );
	
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] anim_stopanimscripted();
		guys[i] thread bloody_death( true, 1 );
	}
}

// called with addNotetrack_CustomFunction
pacing1_friendly_doorbreach_dooropen( guy )
{
	level notify( "friendly_doorbreach_dooropen" );
}

foyer_spawn_redshirts_1()
{
	getent_safe( "trig_spawn_foyer_redshirts_1", "targetname" ) notify( "trigger" );
	
	wait( 0.1 );
	
	closeGuys = get_ai_group_ai( "ai_foyer_redshirts_1_nearplayer" );
	
	array_thread( closeGuys, ::intro_close_redshirt_think );
}

// self = a redshirt AI
intro_close_redshirt_think()
{
	self endon( "death" );
	
	playerdist = 260;
	
	self SetGoalPos( self.origin );
	self AllowedStances( "crouch" );
	
	waittill_player_within_range( self.origin, playerdist );
	
	self AllowedStances( "stand", "crouch", "prone" );
	self SetGoalNode( getnode_safe( self.target, "targetname" ) );
	
	self waittill( "goal" );
	self bloody_death( true, 10 );
}

// spawnfunc - controls guys who get mowed down at the foyer entrance
// self = an AI
foyer_flagbearer_buddies_spawnfunc()
{
	self SetGoalPos( self.origin );
	self.ignoreme = true;
	self thread magic_bullet_shield();
	
	wait( RandomFloatRange( 0.4, 0.7 ) );
	
	self notify( "stop magic bullet shield" );
	
	self.deathanim = %exposed_death_twist;
	if( self.origin[0] > 1100 )  // HACK
	{
		self.deathanim = %exposed_death_headtwist;
	}
	
	self DoDamage( self.health + 5, ( 0, 0, 0 ) );
	
	shotOrigin = ( 1178, 15578, 776 );
	bursts = RandomIntRange( 3, 5 );
	for( i = 0; i < bursts; i++ )
	{
		self maps\ber3b_event_roof::ai_tracer_burst( shotOrigin );
		wait( RandomFloatRange( 0.1, 0.2 ) );
	}
}

// spawnfunc - controls guys who run down the hallway in front of the parliament room
// self = an AI
foyer_pacing_friendly_hallrunners_spawnfunc()
{
	self waittill( "goal" );
	
	self bloody_death( true, 2 );	
}
