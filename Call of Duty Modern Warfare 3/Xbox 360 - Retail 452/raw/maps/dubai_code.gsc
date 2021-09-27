#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\dubai_anim;
#include maps\dubai_finale;
#include maps\dubai_utils;
#include maps\_hud_util;
#include maps\_shg_common;
#include maps\dubai_fx;
#include maps\_audio;
#include maps\_credits;

debug_elevator_attack=false;

setup_level_scripting()
{
	level.finale_fall_time = 5;
	
	array_spawn_function_noteworthy( "street_runner", ::civilian_drone_runners_think );
	
	thread elevator_entered_cleanup();
	thread start_outdoor_lighting_override();
	thread start_outdoor_lighting_roof_override();
	thread ocean_logic();
	
	thread setup_exterior();
	thread setup_lobby();
	thread setup_elevator();
	thread setup_top_floor_atrium();
	thread setup_restaurant();
	thread setup_stairwell();
	thread setup_finale();
	
	thread maps\dubai_pip::setup_pip();
}

intro_vision(pause_time)
{
	aud_send_msg("aud_start_van_blackout_foley");
	fade_out_time = 1.5;

	introblack = get_black_overlay();
	introblack.alpha = 1;
	
	wait pause_time;
	
	introblack FadeOverTime( fade_out_time );
	introblack.alpha = 0;
}

intro_text()
{
	lines = [];
	// "Dust to Dust"
	lines[ lines.size ] = &"DUBAI_INTROSCREEN_LINE1";
	// Day 16, 22:14
	lines[ "date" ]     = &"DUBAI_INTROSCREEN_LINE2";
	// Captain Price
	lines[ lines.size ] = &"DUBAI_INTROSCREEN_LINE3";
	// Task Force 141 - Disavowed
	lines[ lines.size ] = &"DUBAI_INTROSCREEN_LINE4";
	// United Arab Emirates
	lines[ lines.size ] = &"DUBAI_INTROSCREEN_LINE5";

	maps\_introscreen::introscreen_feed_lines( lines );
}

setup_friends(location)
{
	//Yuri Juggernaut
	yuri_juggernaut_spawner = getent( "yuri_juggernaut", "targetname" );
	yuri_juggernaut_spawner.script_noteworthy = "yuri_juggernaut";
	yuri_juggernaut_spawner thread add_spawn_function( ::setup_yuri );
	
	//Yuri Normal
	yuri_spawner = getent( "yuri", "targetname" );
	yuri_spawner.script_noteworthy = "yuri";
	yuri_spawner thread add_spawn_function( ::setup_yuri );
	
	if(isdefined(location))
	{
		if( location == "player_start_exterior" || location == "player_start_exterior_circle" || location == "player_start_lobby" || location == "player_start_elevator" )
		{
			spawn_friendlies(location, "yuri_juggernaut");
			level.yuri thread juggernaut_yuri();
		}
		else
		{
			spawn_friendlies(location, "yuri");
		}
	}
	else
	{
		yuri_juggernaut_spawner thread add_spawn_function( ::setup_yuri );
		yuri_juggernaut_spawner spawn_ai(true);
		
		level.yuri thread juggernaut_yuri();
	}
}

setup_yuri()
{
	level.yuri = self;
	
	self.animname = "yuri";
	
	self.script_noteworthy = "yuri";
	
	self thread magic_bullet_shield();
	
	self disable_surprise();
}

#using_animtree( "generic_human" );
juggernaut_yuri()
{
	juggernaut_yuri_walk_rate = 0.9;
	
	self thread juggernaut_yuri_handle_stairs( juggernaut_yuri_walk_rate );
	self AllowedStances( "stand" );
	self.a.disablePain = true;
	self.dontavoidplayer = true;
	self.nododgemove = true;
	self.badplaceawareness = 0;
	self.combatMode = "no_cover";
	self.dontmelee = true;
	self.doorFlashChance = .05;
	self.aggressivemode = true;
	self.ignoresuppression = true;
	self.no_pistol_switch = true;
	self.noRunNGun = true;
	self.disableExits = true;
	self.disableArrivals = true;
	self.disableBulletWhizbyReaction = true;
	self.neverSprintForVariation = true;
	self.nogrenadereturnthrow = true;
	self disable_turnAnims();
	old_grenadeawareness = self.grenadeawareness;
	self.grenadeawareness = 0;
	
	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	
	juggernaut_move_animset[ 0 ] = %dubai_jugg_walk_f;
	juggernaut_move_animset[ 1 ] = %dubai_jugg_walk_l;
	juggernaut_move_animset[ 2 ] = %dubai_jugg_walk_r;
	juggernaut_move_animset[ 3 ] = %dubai_jugg_walk_b;
	
	self set_move_animset( "run", juggernaut_move_animset, %dubai_jugg_walk_f );
	self.customMoveAnimSet[ "run" ][ "stairs_up" ] = %dubai_juggernaut_stair_climb;
	self set_move_animset( "walk", juggernaut_move_animset );
	self.customMoveAnimSet[ "walk" ][ "stairs_up" ] = %dubai_juggernaut_stair_climb;
	self set_move_animset( "cqb", juggernaut_move_animset );
	self set_combat_stand_animset( %Juggernaut_stand_fire_burst, %Juggernaut_dubai_aim5, %Juggernaut_dubai_stand_idle, %dubai_juggernaut_stand_reload );
	self.combatStandAnims[ "add_aim_up" ] = %juggernaut_dubai_stand_aim_high;
	self.combatStandAnims[ "add_aim_down" ] = %juggernaut_dubai_stand_aim_low;
	self.combatStandAnims[ "add_aim_left" ] = %juggernaut_dubai_stand_aim_left;
	self.combatStandAnims[ "add_aim_right" ] = %juggernaut_dubai_stand_aim_right;
	self.combatStandAnims[ "turn_left_45" ] = %dubai_jugg_turn_45_l;
	self.combatStandAnims[ "turn_left_90" ] = %dubai_jugg_turn_90_l;
	self.combatStandAnims[ "turn_left_135" ] = %dubai_jugg_turn_135_l;
	self.combatStandAnims[ "turn_left_180" ] = %dubai_jugg_turn_180_l;
	self.combatStandAnims[ "turn_right_45" ] = %dubai_jugg_turn_45_r;
	self.combatStandAnims[ "turn_right_90" ] = %dubai_jugg_turn_90_r;
	self.combatStandAnims[ "turn_right_135" ] = %dubai_jugg_turn_135_r;
	self.combatStandAnims[ "turn_right_180" ] = %dubai_jugg_turn_180_r;
	self.combatStandAnims[ "fire" ] = %Juggernaut_stand_fire_burst;
	self.combatStandAnims[ "walk_aims" ][ "walk_aim_2" ] = %juggernaut_dubai_walk_aim_low;
	self.combatStandAnims[ "walk_aims" ][ "walk_aim_4" ] = %juggernaut_dubai_walk_aim_left;
	self.combatStandAnims[ "walk_aims" ][ "walk_aim_6" ] = %juggernaut_dubai_walk_aim_right;
	self.combatStandAnims[ "walk_aims" ][ "walk_aim_8" ] = %juggernaut_dubai_walk_aim_high;
	self.customIdleAnimSet = [];
	self.customIdleAnimSet[ "stand" ] = %Juggernaut_dubai_stand_idle_non_add;
	
//	self enable_cqbwalk();
	self.moveplaybackrate = juggernaut_yuri_walk_rate;
	self.noRunReload = true;
	//self.turnThreshold = 180;

	self thread local_fix_for_stuck_firing_bug();
	self thread local_fix_for_aiming_dir_bug();  // prevents aiming to far off spawn locations when ais are not visible (eg. inside suv)
	self thread local_fix_for_movemode_firing_bug();
	
	//wait until juggernaut suit is removed
	flag_wait( "remove_yuri_juggernaut" );
	
	self stop_magic_bullet_shield();
	level.yuri delete();
	level.yuri = getent( "yuri", "targetname") spawn_ai( true );
	
	flag_set( "yuri_no_juggernaut_spawned" );
}

local_fix_for_movemode_firing_bug()
{
	level endon( "remove_yuri_juggernaut" );
	
	prv_move_mode = self.moveMode;
	while( 1 )
	{
		if ( prv_move_mode != self.moveMode )
		{	// tickle to restart aim/shoot anims
			prv_move_mode = self.moveMode;	// grab this here so we can catch any changes during the  waits
			wait 0.05;	// setposemovement::PlayBlendTransitionStandRun waits 0.05 before calling SetFlaggedAnimKnobAll
			waittillframeend;		// ensure we happen after the possible call to SetFlaggedAnimKnobAll
			self.shootEnt = undefined;	// note that this will likely cause a "shoot_behavior_change" notify
		}
		wait 0.05;
	}
}

local_fix_for_stuck_firing_bug()
{
	level endon( "remove_yuri_juggernaut" );
	while( 1 )
	{
		self waittill( "shoot_behavior_change" );
		if (isdefined(self.catch_shootbehaviorchange) && (self.catch_shootbehaviorchange == 1))
		{	// we've bailed early, but haven't restarted a shot already
			self.catch_shootbehaviorchange=0;
			self animscripts\combat_utility::hideFireShowAimIdle();
		}
	}
}

local_fix_for_aiming_dir_bug()
{
	level endon( "remove_yuri_juggernaut" );
	while( 1 )
	{
		if ( isdefined( self.enemy ) )
			self getEnemyInfo( self.enemy );
		wait 0.05;
	}
}

//slow down movement rate when climbing stairs
juggernaut_yuri_handle_stairs( juggernaut_yuri_walk_rate )
{
	level endon( "remove_yuri_juggernaut" );
	
	prevStairsState = self.stairsState;
	prevMoveMode = self.moveMode;

	while ( 1 )
	{
		wait .05;
		if (( prevStairsState != self.stairsState ) || ( prevMoveMode != self.moveMode ))
		{
			if( self.stairsstate == "none" )
			{
				self.moveplaybackrate = juggernaut_yuri_walk_rate;
			}
			else
			{
				if ( self.moveMode == "walk" )
				{
					// divided by 0.6 since walk.gsc, DoWalkAnim() multiplies by 0.6
					self.moveplaybackrate = 1 / 0.6;
				}
				else
				{
					self.moveplaybackrate = 1;
				}
			}
			
			prevStairsState = self.stairsState;
			prevMoveMode = self.moveMode;
		}
	}
}

///////////////////////////////////////////////
//------------------ INTRO ------------------//
///////////////////////////////////////////////
setup_pecheneg()
{
	parts = [
//	"J_Gun",
	"TAG_HEARTBEAT",
//	"J_Ammo_Cover",
//	"J_Ammo_Cover_Flap",
	"J_Bipods",
//	"J_Reload",
	"TAG_FOREGRIP",
	"TAG_SILENCER",
//	"TAG_BRASS",
//	"TAG_CLIP",
//	"TAG_FLASH",
	"TAG_ACOG_2",
	"TAG_EOTECH",
	"TAG_MAGNIFIER",
	"TAG_MAGNIFIER_EOTECH",
	"TAG_MAGNIFIER_EOTECH_RETICLE",
	"J_Flip",
	"J_Release",
	"J_Motion_Tracker_RotY",
//	"J_Ammo_01",
//	"J_Ammo_010",
//	"J_Ammo_011",
//	"J_Ammo_012",
//	"J_Ammo_013",
//	"J_Ammo_014",
//	"J_Ammo_015",
//	"J_Ammo_016",
//	"J_Ammo_017",
//	"J_Ammo_018",
//	"J_Ammo_019",
//	"J_Ammo_02",
//	"J_Ammo_020",
//	"J_Ammo_03",
//	"J_Ammo_04",
//	"J_Ammo_05",
//	"J_Ammo_06",
//	"J_Ammo_07",
//	"J_Ammo_08",
//	"J_Ammo_09",
//	"J_Clip_Cover",
//	"TAG_RED_DOT",
	"TAG_FLASH_SILENCED",
	"TAG_THERMAL_SCOPE",
	"TAG_RETICLE_ACOG",
	//"TAG_EOTECH_RETICLE",
	"J_Motion_Tracker_RotZ",
	"TAG_RETICLE_RED_DOT",
	"TAG_RETICLE_THERMAL_SCOPE",
	"TAG_MOTION_TRACKER",
	"TAG_SCREEN_BL",
	"TAG_SCREEN_BR",
	"TAG_SCREEN_TR"
	];
	foreach (part in parts)
	{
		self hidepart( part, "viewmodel_pecheneg_sp_iw5" );
	}
}

setup_mk46()
{
	parts = [
	//"TAG_WEAPON",
	//"TAG_ACOG_2",
	//"TAG_EOTECH",
	//"TAG_HEARTBEAT",
	//"TAG_RED_DOT",
	"TAG_FOREGRIP"//,
	//"TAG_SILENCER",
	//"TAG_BRASS",
	//"TAG_CLIP",
	//"TAG_FLASH",
	//"TAG_SIGHT_ON",
	//"TAG_THERMAL_SCOPE",
	//"TAG_FLASH_SILENCED"
	];
	foreach (part in parts)
	{
		//self hidepart( part, "weapon_mk46" );
	}
}

intro()
{
	g_friendlyNameDist_old = GetDvarInt( "g_friendlyNameDist" );
	SetSavedDvar( "g_friendlyNameDist", 0 );
	
	level.player freezecontrols( true );
	
	thread battlechatter_off( "allies" );
	
	level.player disableweapons();
	level.player enableinvulnerability();
	level.player allowcrouch( false );
	level.player enableslowaim();
	SetSavedDvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", 1 );
	SetSavedDvar( "hud_showstance", 0 );
	SetSavedDvar( "actionSlotsHide", 1 );
	
	delaythread( 1, ::flag_set, "vo_intro_on_black" );
	
	blackout_time = 15;
	thread intro_vision(blackout_time);
	
	thread intro_yelling_enemies();
	
	//wait 2;
	
	delaythread( blackout_time - 5, ::intro_text );
	
	delaythread( blackout_time - 1, ::intro_squibs, 15 );
	delaythread( blackout_time + .5, ::intro_squibs, 12 );
	delaythread( blackout_time + 1.9, ::intro_squibs, 5 );
	delaythread( blackout_time + 3, ::intro_squibs, 15 );
	delaythread( blackout_time + 5, ::intro_squibs, 9 );
	delaythread( blackout_time + 8.3, ::intro_squibs, 4 );
	delaythread( blackout_time + 11, ::intro_squibs, 3 );
	delaythread( blackout_time + 13.6, ::intro_squibs, 6 );
	delaythread( blackout_time + 14.85, ::intro_squibs, 2 );
	delaythread( blackout_time + 16.5, ::intro_squibs, 7 );
	delaythread( blackout_time + 19, ::intro_squibs, 6 );
	
	level.player delaycall( blackout_time + 16.2, ::playrumbleonentity, "damage_light" );
	
	wait blackout_time - 1;
	
	SetSavedDvar( "g_friendlyNameDist", g_friendlyNameDist_old );
	
	level.player Shellshock( "slowview", 26 );
	
	anime = "intro";	
	anim_node = getent( "intro_anim_node", "targetname" );
	
	level.yuri thread intro_yuri( anim_node );
	level.yuri setup_mk46();
	
	thread intro_starting_enemies( anim_node );
	
	intro_truck = getent( "intro_truck", "targetname" );
	intro_truck.animname = "intro_truck";
	intro_truck UseAnimTree( level.scr_animtree[ "intro_truck" ] );
	
	player_rig = spawn_anim_model( "player_rig_juggernaut", (0, 0, 0) );
	player_rig.animname = "player_rig_juggernaut";
	
	player_body = spawn_anim_model( "player_body_jugg", (0, 0, 0) );
	player_body.animname = "player_body_jugg";
	
	player_rifle = spawn( "script_model", anim_node.origin );
	player_rifle setmodel( "viewmodel_pecheneg_sp_iw5" );
	player_rifle.animname = "intro_player_gun";
	player_rifle UseAnimTree( level.scr_animtree[ "intro_player_gun" ] );
	player_rifle setup_pecheneg();
	
	
	actors = [];
	actors[actors.size] = player_rig;
	actors[actors.size] = player_body;
	actors[actors.size] = player_rifle;
	actors[actors.size] = intro_truck;
	
	anim_node anim_first_frame( actors, anime );
	blend_time = 0.15;
	level.player PlayerLinkToBlend( player_rig, "tag_player", blend_time);
	level.player delaycall( blend_time + 0.05, ::playerlinktodelta, player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	level.player delaycall( blend_time + 0.1, ::LerpViewAngleClamp, 0.5, 0.25, 0.25, 5, 25, 25, 0 );
	
	level.player freezecontrols( false );
	anim_node thread anim_single( actors, anime );
	
	thread juggernaut_player();
	
	player_rig thread intro_player_raise_weapon();
	
	thread maps\dubai_fx::intro_breach_fx();
	
	anim_node waittill( anime );
	
	level.player unlink();
	level.player disableinvulnerability();
	level.player allowcrouch( true );
	level.player disableslowaim();
	
	player_rig delete();
	player_body delete();
	player_rifle delete();
	
	flag_set( "intro_complete" );
	thread autosave_by_name( "intro_complete" );
	thread battlechatter_on( "allies" );
	
	flag_set( "update_obj_pos_exterior_on_yuri" );
	
	thread intro_driver();
	
}

intro_yelling_enemies()
{
	source = spawn( "script_origin", (6200, -238, 60) );
	
	wait 2;

	source playsound( "dubai_scg1_stepout" );
		
	wait 5;
		
	source playsound( "dubai_scg1_openfire" );
		
	wait 6.5;
		
	source playsound( "dubai_scg1_fire" );
}

intro_player_raise_weapon()
{
	self waittillmatch( "single anim", "raise_weapon" );
	level.player enableweapons();
	SetSavedDvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", 0 );
	SetSavedDvar( "hud_showstance", 1 );
	SetSavedDvar( "actionSlotsHide", 0 );
	
	wait 0.5;
	level.player playrumbleonentity( "damage_light" );
}

intro_yuri( anim_node )
{
	anime = "intro_yuri";
	
	helmet = spawn( "script_model", anim_node.origin );
	helmet setModel( "dub_juggernaut_helmet" );
	helmet.animname = "intro_yuri_helmet";
	helmet UseAnimTree( level.scr_animtree[ "intro_yuri_helmet" ] );
	
	yuri_intro = getent( "yuri_intro", "targetname" ) spawn_ai( true );
	yuri_intro.animname = "yuri";
	
	self hide();
	
	actors = [];
	actors[actors.size] = self;
	actors[actors.size] = yuri_intro;
	actors[actors.size] = helmet;
	
	self thread juggernaut_yuri_anim_setup();
	yuri_intro thread juggernaut_yuri_anim_setup();
	
	anim_node thread anim_single_run( actors, anime );
	
	self waittillmatch( "single anim", "ram_door" );
	
	level.player playrumbleonentity( "damage_light" );
	
	aud_send_msg("dubai_exit_van");
	
	flag_set( "exterior_initial_enemies" );
	
	self show();
	yuri_intro delete();
	helmet delete();
	
	thread autosave_now(1);
	
	anim_node waittill( anime );
	self notify( "anim_complete" );
	trigger_activate_targetname( "trig_intro_yuri_move" );
}

intro_squibs( bullets, delay )
{
	level endon( "intro_truck_left" );
	
	sourceOrg = (6532, -284, 88);
	source = spawn( "script_origin", sourceOrg );
	source.origin = (sourceOrg[0], sourceOrg[1] + randomintrange(-36, 36), sourceOrg[2] + randomintrange(-32, 32) );
		
	for( i = 0; i < bullets; i++ )
	{
		source.origin = source.origin + (0, randomintrange(-15, 15), randomintrange(-15, 15) );
		MagicBullet( "ak47", source.origin, source.origin + (-1, 0, 0) );
		MagicBullet( "ak47", source.origin, source.origin + (1, randomfloatrange(-0.5, 0.5), randomfloatrange(-0.5, 0.5) ) );
		
		//10% chance to play rumble
		if( randomint(100) < 10 )
			level.player PlayRumbleOnEntity( "damage_light" );
		
		wait 0.1;
	}
	
	source delete();
}
		
juggernaut_viewbob()
{
	vbaS = GetDvar("bg_viewBobAmplitudeStanding");
	vbaSA = GetDvar("bg_viewBobAmplitudeStandingAds");
	vbaD = GetDvar("bg_viewBobAmplitudeDucked");
	vbaDA = GetDvar("bg_viewBobAmplitudeDuckedAds");
	//vbaSp = GetDvar("bg_viewBobAmplitudeSprinting");
	wbaS = GetDvar("bg_weaponBobAmplitudeStanding");
	//wbaSp = GetDvar("bg_weaponBobAmplitudeSprinting");
	// Juggernaut view bob settings
	SetSavedDvar("bg_viewBobAmplitudeStanding",				"0.035 0.03" );		//default: 0.007	0.007
	SetSavedDvar("bg_viewBobAmplitudeStandingAds",			"0.025 0.02" );	//default: 0.007	0.007
	SetSavedDvar("bg_viewBobAmplitudeDucked",				"0.025 0.02" );			//default: 0.0075 0.0075
	SetSavedDvar("bg_viewBobAmplitudeDuckedAds",			"0.02 0.015" );		//default: 0.007	0.007
	//SetSavedDvar("bg_viewBobAmplitudeSprinting",			"0.2 0.1" );			//default: 0.02		0.014
	SetSavedDvar("bg_weaponBobAmplitudeStanding",			"0.1 0.05" );			//default: 0.055	0.025
	//SetSavedDvar("bg_weaponBobAmplitudeSprinting",			"0.2 0.1" );		//default: 0.02		0.014
		
	flag_wait( "remove_player_juggernaut" );
	
    // Restore
	SetSavedDvar("bg_viewBobAmplitudeStanding",				vbaS );
	SetSavedDvar("bg_viewBobAmplitudeStandingAds",		vbaSA );
	SetSavedDvar("bg_viewBobAmplitudeDucked", 				vbaD );
	SetSavedDvar("bg_viewBobAmplitudeDuckedAds", 			vbaDA );
	//SetSavedDvar("bg_viewBobAmplitudeSprinting",			vbaSp );
	SetSavedDvar("bg_weaponBobAmplitudeStanding",			wbaS );
	//SetSavedDvar("bg_weaponBobAmplitudeSprinting",		wbaSp );
}


juggernaut_player()
{
	level.cover_warnings_disabled = true;
	
	thread juggernaut_player_dynamic_speed();
	thread juggernaut_viewbob();
	
	old_health_regen_delay = level.player.gs.playerHealth_RegularRegenDelay;
	level.player.gs.playerHealth_RegularRegenDelay = level.player.gs.playerHealth_RegularRegenDelay / 4;
	old_health_long_regen_delay = level.player.gs.longregentime;
	level.player.gs.longregentime = level.player.gs.longregentime / 5;

	level.player AllowJump( false );
	level.player allowprone( false );
	
	level.player SetViewKickScale( 0.3 );
	
	old_dmg_mult = GetDvarFloat( "player_damageMultiplier" );
	setsaveddvar( "player_damageMultiplier", 0.3);
	setsaveddvar( "player_radiusDamageMultiplier", 0.5);
	//setsaveddvar( "player_meleeDamageMultiplier", 0.3);
	
	SetHUDLighting( true );
	juggernaut_overlay = maps\_hud_util::create_client_overlay( "juggernaut_overlay_half", 1, level.player );
	juggernaut_overlay.foreground = false;
	juggernaut_overlay setshader( "juggernaut_overlay_half", 640, 240 );

	flag_wait( "elevator_chopper_attack" );
	flag_wait( "elevator_chopper_crash_done" );
	
	juggernaut_overlay Destroy();
	
	juggernaut_overlay = maps\_hud_util::create_client_overlay( "juggernaut_damaged_overlay", 1, level.player );
	juggernaut_overlay.foreground = false;

	flag_wait( "remove_player_juggernaut" );
	
	level.cover_warnings_disabled = undefined;
	
	setsaveddvar( "player_damageMultiplier", old_dmg_mult);
	setsaveddvar( "player_radiusDamageMultiplier", 1);
	//setsaveddvar( "player_meleeDamageMultiplier", 0.4);
	
	juggernaut_overlay Destroy();
	SetHUDLighting( false );

	level.player SetViewmodel( "viewhands_pmc" );

	level.player DisableInvulnerability();
	level.player AllowJump( true );
	level.player AllowSprint( true );
	
	level.player SetViewKickScale( 1 );
	
	wait 0.05;
	level.player blend_MoveSpeedscale_Percent( 100 );
	
	level.player.gs.playerHealth_RegularRegenDelay = old_health_regen_delay;
	level.player.gs.longregentime = old_health_long_regen_delay;
}

juggernaut_player_dynamic_speed()
{
	level endon( "remove_yuri_juggernaut" );

	flag_set( "player_dynamic_move_speed" );

	current = 1;
	actor = undefined;

	level.yuri.plane_origin = SpawnStruct();

	SetDvarIfUninitialized( "debug_playerDMS", 0 );

	guy = level.yuri;

	level.player blend_MoveSpeedscale_Percent( 50 );
	level.player.baseline_speed = 0.5;

	while ( flag( "player_dynamic_move_speed" ) )
	{
		//if we're close enough to an actor to be significant - then just use him
		//otherwise go through a series of complicated steps to figure out where 
		//we are in relation to the whole team
		
		ahead = false;

		//we dont have distance2d SQUARED...so here's a hack
		origin1 = ( level.player.origin[ 0 ], level.player.origin[ 1 ], 0 );
		origin2 = ( guy.origin[ 0 ], guy.origin[ 1 ], 0 );
		
		ahead = guy player_DMS_ahead_test();
		guy.plane_origin.origin = guy player_DMS_get_plane();
		actor = guy.plane_origin;
		/#
			if ( GetDvarInt( "debug_playerDMS" ) )
				Line( actor.origin, level.player.origin, ( 0, 1, 0 ), 1 );
			#/
		
		
		/#
		if ( GetDvarInt( "debug_playerDMS" ) )
			Print3d( actor.origin, "dist: " + Distance( level.player.origin, actor.origin ), ( 1, 1, 1 ), 1 );
		#/
		//if he's wait out in front - really slow him down
		if ( DistanceSquared( level.player.origin, actor.origin ) > squared( 100 ) && ahead )
		{
			/#
			if ( GetDvarInt( "debug_playerDMS" ) )
				PrintLn( "TOOO FAR AHEAD!!!!!!!!!!!" );
			#/
			if ( current > .55 )
				current -= .015;
		}
		//if he's too close - take him as much as 20% under his baseline
		else
		if ( DistanceSquared( level.player.origin, actor.origin ) < squared( 50 ) || ahead )
		{
			if ( current < .78 )
				current += .015;

			if ( current > .8 )
				current -= .015;
		}
		//if he's REALLY far away - take him as much as 55% over his baseline ( as long as total speed doesn't reach 110%, capped below )
		else
		if ( DistanceSquared( level.player.origin, actor.origin ) > squared( 300 ) )
		{
			if ( current < 1.0 )
				current += .02;
		}
		//if he's far away - take him as much as 25% over his baseline
		else
		if ( DistanceSquared( level.player.origin, actor.origin ) > squared( 100 ) )
		{
			if ( current < 1.0 )
				current += .01;
		}
		//if he's in range - take him back to his baseline
		else
		if ( DistanceSquared( level.player.origin, actor.origin ) < squared( 85 ) )
		{
			if ( current > 1.0 )
				current -= .01;
			if ( current < 1.0 )
				current += .01;
		}

		//set his speed based on baseline and this ratio
		level.player.adjusted_baseline = level.player.baseline_speed * current;
		if ( level.player.adjusted_baseline > 1.1 )
			level.player.adjusted_baseline = 1.1;

		/#
		if ( GetDvarInt( "debug_playerDMS" ) )
			PrintLn( "baseline: " + level.player.baseline_speed + ", 	adjusted: " + level.player.adjusted_baseline );
		#/

		level.player SetMoveSpeedScale( ( level.player.adjusted_baseline ) );
		wait .05;
	}
	
	level.player blend_MoveSpeedscale_Percent( 50, 3 );
}

intro_starting_enemies( anim_node )
{
	
	anime1 = "intro_guy1_death";
	anime2 = "intro_guy2_death";
	anime3 = "intro_guy3_death";
	anime4 = "intro_guy4_death";
	anime5 = "intro_guy5_death";
	anime6 = "intro_guy6_death";
	
	guy1 = getent( "intro_guy1", "targetname" ) spawn_ai( true );
	guy2 = getent( "intro_guy2", "targetname" ) spawn_ai( true );
	guy3 = getent( "intro_guy3", "targetname" ) spawn_ai( true );
	guy4 = getent( "intro_guy4", "targetname" ) spawn_ai( true );
	guy5 = getent( "intro_guy5", "targetname" ) spawn_ai( true );
	guy6 = getent( "intro_guy6", "targetname" ) spawn_ai( true );
	
	guy1.animname = "generic";
	guy2.animname = "generic";
	guy3.animname = "generic";
	guy4.animname = "generic";
	guy5.animname = "generic";
	guy6.animname = "generic";
	
	anim_node thread anim_single_solo( guy1, anime1 );
	anim_node thread anim_single_solo( guy2, anime2 );
	anim_node thread anim_single_solo( guy3, anime3 );
	anim_node thread anim_single_solo( guy4, anime4 );
	anim_node thread anim_single_solo( guy5, anime5 );
	anim_node thread anim_single_solo( guy6, anime6 );
	
	flag_wait( "intro_truck_left" );
	
	flag_wait( "intro_complete" );
}

intro_driver()
{
	intro_driver = getent( "intro_driver", "targetname" ) spawn_ai();
	intro_driver.animname = "generic";
	intro_driver set_deathanim( "civilian_crawl_1_death_A" );
	intro_driver kill();
}

///////////////////////////////////////////////
//---------------- EXTERIOR -----------------//
///////////////////////////////////////////////

setup_exterior()
{
	level.destructible_badplace_radius_multiplier = 0.6;
	
	thread exterior_enemies();
	thread exterior_rpg_enemies();
	thread exterior_suv_scene();
	thread exterior_enemy_cleanup();
	thread exterior_yuri_movement();
	thread exterior_bridge_suvs();
	thread exterior_civilians_initial();
	thread exterior_civilians_ramp();
	thread exterior_civilians_lobby_runners();
	
	thread exterior_lobby_front_door_fall();
	
	goal_vols = [];
	goal_vols[0] = getent( "exterior_goal_1", "targetname" );
	goal_vols[1] = getent( "exterior_goal_2", "targetname" );
	goal_vols[2] = getent( "exterior_goal_3", "targetname" );
	exterior_enemies = getentarray( "exterior_enemy", "script_noteworthy" );
	array_spawn_function( exterior_enemies, ::exterior_enemies_ai_think, goal_vols );
	
	thread exterior_setup_dont_leave_failure();
	thread exterior_setup_dont_leave_hint();
	add_hint_string( "hint_dont_leave_yuri", &"DUBAI_DONT_LEAVE", ::exterior_should_break_dont_leave );
	
	array_spawn_function_noteworthy( "suburban", ::exterior_suv_ai_think );
}

exterior_yuri_movement()
{
	flag_wait( "intro_complete" );
	thread exterior_juggernaut_paired_think();
	
	flag_wait( "yuri_car_climb" );
	delaythread( 0.5, ::flag_set, "exterior_suv_scene" );
}

exterior_juggernaut_paired_think()
{
	flag_wait( "exterior_juggernaut_paired_setup" );
	
	anime = "exterior_juggernaut_paired";
	animnode = getent( "exterior_juggernaut_paired_node", "targetname" );
	
	guy = spawn_targetname( "exterior_juggernaut_paired_enemy", true );
	
	guy thread exterior_juggernaut_paired_guy_ai_think( anime, animnode );
		
	animnode anim_reach_solo( level.yuri, anime );
		
	flag_set( "exterior_juggernaut_paired_start" );
		
	if( !flag( "exterior_juggernaut_paired_complete" ) )
	{
		level.yuri thread juggernaut_yuri_anim_setup();
		
		animnode anim_single_solo_run( level.yuri, anime );
		level.yuri notify( "anim_complete" );
		
		flag_set( "exterior_juggernaut_paired_complete" );
	}
	level.yuri enable_ai_color();
}

exterior_juggernaut_paired_guy_ai_think( anime, animnode )
{
	self endon( "death" );
	
	self.animname = "generic";
	
	self.allowdeath = true;
	self.ignoreme = true;
	self.health = 1;
	self setflashbangimmunity( true );
	
	animnode thread anim_first_frame_solo( self, anime );
	
	thread exterior_juggernaut_paired_interupted( level.yuri, self );
	
	flag_wait( "exterior_juggernaut_paired_start" );
	
	animnode anim_single_solo( self, anime );
}

exterior_juggernaut_paired_interupted( yuri, guy )
{
	guy waittill( "death" );
	
	flag_set( "exterior_juggernaut_paired_complete" );
	
	//only clear Yuri's animation if it was started in the first place
	if( flag( "exterior_juggernaut_paired_start" ) )
	{
	yuri notify( "single anim", "end" );
	yuri StopAnimScripted();
}
}

exterior_enemies()
{
	flag_wait( "exterior_initial_enemies" );
	
	exterior_initial_enemies = array_spawn_targetname( "exterior_initial_enemies", true );
	exterior_initial_enemies thread exterior_initial_enemies_monitor_death();
	
	flag_wait( "exterior_suv_1" );
	
	wait 3;
	array_spawn_targetname( "exterior_enemies_1", true );
	
	wait 5;
	array_spawn_targetname( "exterior_enemies_2", true );
	
	flag_wait( "yuri_car_climb" );
	array_spawn_targetname( "exterior_enemies_3", true );
}

exterior_initial_enemies_monitor_death()
{
	level delaythread( 8, ::flag_set, "vo_streets_start" );
	
	guys = self;
	
	while( guys.size > 0 )
	{
		guys = array_removedead_or_dying( guys );
		wait 0.25;
	}
	
	wait 1;
	
	flag_set( "vo_streets_start" );
}

exterior_civilians_initial()
{
	//array_spawn_targetname( "exterior_civilians" );
	
	flag_wait( "exterior_civilians_initial" );
	//thread exterior_civilian_drones_wave( 15, "civilians_lobby_runners", .25, .3 );
	wait 10;
	
	//thread exterior_civilian_drones_wave( 6, "civilians_lobby_runners", .25, .3 );
	
	array_spawn_function_noteworthy( "exterior_run_and_hide", ::civilian_drone_run_and_hide_think, "elevator_doors_closed" );
	//array_spawn_noteworthy( "exterior_run_and_hide" );
}

exterior_civilians_ramp()
{
	flag_wait( "exterior_civilians_ramp" );
	//thread exterior_civilian_drones_wave( 4, "civilians_lobby_runners", .25, .3 );
	wait 6;
	//thread exterior_civilian_drones_wave( 7, "civilians_lobby_runners", .25, .3 );
}

exterior_civilians_lobby_runners()
{
	flag_wait( "exterior_enemies_violent_death" );
	thread exterior_civilian_drones_wave( 10, "civilians_lobby_runners", .2 );
}

exterior_enemies_ai_think( goal_vols )
{
	self endon( "death" );
	
	self.pathrandompercent = 200;
	
	//keep updating the goal position depending on where the combat takes place
	self SetGoalVolumeAuto( goal_vols[0] );

	flag_wait( "exterior_suv_1" );
	self SetGoalVolumeAuto( goal_vols[1] );

	flag_wait( "yuri_car_climb" );
	self SetGoalVolumeAuto( goal_vols[2] );
}

exterior_starting_enemies_ai_think()
{
	old_grenade_ammo = self.grenadeAmmo;
	
	flag_wait( "intro_complete" );
	
	self.grenadeAmmo = old_grenade_ammo;
}

exterior_rpg_enemies()
{
	flag_wait( "exterior_rpg_enemies" );
	
	array_spawn_function_targetname( "exterior_rpg_enemies", ::exterior_rpg_enemies_ai_think );
	array_spawn_targetname( "exterior_rpg_enemies", true );
}

exterior_rpg_enemies_ai_think()
{
	self endon( "death" );
	
	self.goalradius = 256;
	self.DropWeapon = false;
	
	while( !self cansee( level.player ) )
	{
		wait 0.5;
	}
	
	wait 1;
	
	flag_set( "exterior_rpg_enemies_in_position" );
	
	flag_wait( "remove_exterior_rpg_enemies" );
	
	self delete();
}

exterior_bridge_suvs()
{
	thread maps\dubai_fx::sedan_enable_lights_01();
	thread maps\dubai_fx::sedan_enable_lights_02();
	
	exterior_suv_initial = getent("suv_dest_still_01", "targetname");
	exterior_suv_initial thread maps\dubai_fx::suv_enable_lights();
	exterior_suv_initial thread handle_suv_damage( 201, 3 );
	
	exterior_suv_initial_2 = getent("suv_dest_still_02", "targetname");
	exterior_suv_initial_2 thread maps\dubai_fx::suv_enable_lights();
	exterior_suv_initial_2 thread handle_suv_damage( 206, 3 );
	
	exterior_suv_initial add_damage_function( ::exterior_suv_special_damage_funtion );
	//exterior_suv_initial_2 add_damage_function( ::exterior_suv_special_damage_funtion );
	flag_wait( "exterior_juggernaut_paired_start" );
	exterior_suv_initial remove_damage_function( ::exterior_suv_special_damage_funtion );
	//exterior_suv_initial_2 add_damage_function( ::exterior_suv_special_damage_funtion );
	
	//exterior_suv_initial_2 add_damage_function( ::exterior_suv_special_damage_funtion );
	//flag_wait( "exterior_juggernaut_paired_start" );
	//exterior_suv_initial_2 remove_damage_function( ::exterior_suv_special_damage_funtion );
	
	flag_wait( "exterior_suv_1" );
	
	thread autosave_by_name( "exterior_suv_1" );
	
	exterior_suv_1 = spawn_vehicle_from_targetname_and_drive( "exterior_suv_1" );
	exterior_suv_1 thread handle_suv_damage( 202, 4 );
	
	aud_send_msg("bridge_suv_start_1", exterior_suv_1);
	
	//Add lights to SUV
	exterior_suv_1 thread maps\dubai_fx::suv_enable_lights();
	//Setup skid marks for SUV
	//thread maps\dubai_fx::exterior_suv_skid1(exterior_suv_1);
	
		wait 3;
	
	exterior_suv_2 = spawn_vehicle_from_targetname_and_drive( "exterior_suv_2" );
	exterior_suv_2 thread handle_suv_damage( 203, 4 );
	
	aud_send_msg("bridge_suv_start_2", exterior_suv_2);
	
	//Add lights to SUV
	exterior_suv_2 thread maps\dubai_fx::suv_enable_lights();
	//Setup skid marks for SUV
	//thread maps\dubai_fx::exterior_suv_skid2(exterior_suv_2);
}

//wait until SUVs unload before they can be blown up
exterior_suv_ai_think()
{
	self add_damage_function( ::exterior_suv_special_damage_funtion );
	
	self waittill( "unloaded" );
	
	self remove_damage_function( ::exterior_suv_special_damage_funtion );
}

exterior_suv_special_damage_funtion( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	//don't die until unloaded, but still take damage
	if( damage >= (self.health - self.healthbuffer) )
		self.health += damage;
}

exterior_suv_scene()
{
	flag_wait( "exterior_suv_scene" );
	
	thread autosave_by_name( "exterior_suv_scene" );
	
	exterior_suv_left = spawn_vehicle_from_targetname_and_drive( "exterior_suv_left" );
	
	aud_send_msg("suv_start_1", exterior_suv_left);
	
	exterior_suv_left thread maps\dubai_fx::suv_enable_lights();
	exterior_suv_left thread handle_suv_damage( 205, 4 );
	
	//thread maps\dubai_fx::exterior_suv_skid3(exterior_suv_left);
	
	wait 1.2;
	exterior_suv_right = spawn_vehicle_from_targetname_and_drive( "exterior_suv_right" );
	aud_send_msg("suv_start_2", exterior_suv_right);
	
	exterior_suv_right thread maps\dubai_fx::suv_enable_lights();
	//thread maps\dubai_fx::exterior_suv_skid4(exterior_suv_right);
	exterior_suv_right thread handle_suv_damage( 204, 4 );
	
	exterior_crash_glass = getent( "exterior_crash_glass", "targetname" );
	noself_delaycall( 3, ::GlassRadiusDamage, exterior_crash_glass.origin, 100, 100, 100 );
	aud_send_msg("suv_04_crash", exterior_crash_glass);
}

exterior_enemy_cleanup()
{
	flag_wait( "exterior_enemies_violent_death" );
	
	foreach( enemy in getaiarray( "axis" ) )
	{
		enemy thread bloody_death( RandomFloatRange( 0, 3 ), level.yuri );
	}
}

exterior_setup_dont_leave_failure()
{
	flag_wait( "player_left_map" );
	
	level notify ( "mission failed" );
	setDvar( "ui_deadquote", &"DUBAI_DONT_LEAVE_FAILURE");	
	maps\_utility::missionFailedWrapper();	
}

exterior_setup_dont_leave_hint()
{
	while( 1 )
	{
		//player_returning_to_map
		flag_wait( "player_leaving_map" );
	
		display_hint_timeout( "hint_dont_leave_yuri", 5 );
		
		wait 5;
	}
}

exterior_should_break_dont_leave()
{
	if( flag( "player_returning_to_map" ) )
		return true;
	else
		return false;	
}

exterior_lobby_front_door_fall()
{
	door = getent( "dub_lobby_frontdoor_scripted", "targetname" );
	
	doorparts = getentarray( door.target, "targetname" );
	
	foreach( part in doorparts )
	{
		part linkto( door );
	}
	
	door.angles = (0, 42, 0);
	
	flag_wait( "exterior_enemies_violent_death" );
	
	fall_time_1 = .8;
	
	door rotateto( door.angles + ( 353, 0, 90 ), fall_time_1, fall_time_1 );
	aud_send_msg("hotel_door_fall", door);
	wait fall_time_1;
	door rotateto( door.angles + ( -4, 0, -4 ), 0.2, 0, 0.2 );
	wait 0.2;
	door rotateto( door.angles + ( 4, 0, 4 ), 0.15, 0.15 );
}

exterior_civilian_drones_wave( civ_total, targetname, delay_min, delay_max )
{
	civilian_spawners = getentarray( targetname, "targetname" );
	
	spawned = 0;
	
	if( !isdefined( delay_min ) )
		delay_min = 0.2;
	if( !IsDefined( delay_max ) )
		delay_max = delay_min;
	
	
	while( spawned < civ_total )
	{
		civilian_spawners = array_randomize( civilian_spawners );
		
		num = randomintrange( 1, civilian_spawners.size );
		
		//make sure we don't spawn too many
		num = min( civ_total-spawned, num );
		
		for( i = 0; i < num; i++ )
		{
			civilian_spawners[i].drone_run_speed = randomintrange( 150, 200 );
			
			guy = civilian_spawners[i] spawn_ai();
			aud_send_msg("spawned_hotel_civilian", guy);
			
			if( delay_min >= delay_max )
				wait delay_min;
			else
				wait RandomFloatRange( delay_min, delay_max );
			spawned++;
		}
	}
}

///////////////////////////////////////////////
//------------------ LOBBY ------------------//
///////////////////////////////////////////////

setup_lobby()
{
	thread lobby_yuri_movement();
	thread lobby_combat_initial();
	thread lobby_combat_ascent();
	thread lobby_combat_top_left();
	thread lobby_combat_top_right();
	thread lobby_combat_top_gallery();
	thread lobby_combat_top_final();
	thread lobby_civilians();
}

lobby_yuri_movement()
{
	flag_wait( "lobby_yuri_to_elevator" );
	
	thread lobby_combat_cleanup();
	
	anime = "elevator_enter";
	animnode = getent( "elevator_button_anim_node", "targetname" );
	animnode anim_reach_solo( level.yuri, anime );
	animnode thread anim_single_solo( level.yuri, anime );
	animnode waittill( anime );
	
	flag_set( "yuri_in_elevator" );
	anime = "elevator_enter_idle";
	animnode thread anim_loop_solo( level.yuri, anime, "player_in_elevator" );
	
	flag_wait( "player_in_elevator" );
	flag_clear( "player_dynamic_move_speed" );
	animnode notify( "player_in_elevator" );
}

lobby_combat_initial()
{
	flag_wait( "lobby_combat_initial" );
	
	wait 2;
	array_spawn_function_targetname( "lobby_combat_initial_enemies", ::lobby_combat_initial_enemies_ai_think );
	array_spawn_targetname( "lobby_combat_initial_enemies" );
	
	wait 2;
	flag_set( "vo_lobby_start" );
}

lobby_combat_initial_enemies_ai_think()
{
	self endon( "death" );
	
	self disable_long_death();
	self.script_forcegoal = true;
	
	flag_wait( "lobby_combat_top" );
	self setgoalentity( level.player, 5 );
}

lobby_combat_ascent()
{
	flag_wait( "lobby_combat_ascent" );
	aud_send_msg("mus_board_escalator");
	
	thread lobby_combat_top_initial();
	
	flag_set( "remove_exterior_rpg_enemies" );
	
	array_spawn_targetname( "lobby_combat_ascent_enemies" );
}

lobby_combat_top_initial()
{
	array_spawn_function_targetname( "lobby_combat_top_initial_enemies", ::lobby_combat_top_initial_enemies_ai_think );
	array_spawn_targetname( "lobby_combat_top_initial_enemies" );
}

lobby_combat_top_initial_enemies_ai_think()
{
	self endon( "death" );
	self magic_bullet_shield();
	self setgoalpos( self.origin );
	self.goalradius = 200;
	
	flag_wait( "lobby_combat_top" );
	
	self stop_magic_bullet_shield();
	self.goalradius = 500;
}

lobby_combat_top_left()
{
	level endon( "lobby_combat_top_right" );
	
	flag_wait( "lobby_combat_top_left" );
	flag_set( "lobby_combat_top" );
	// commenting out temorarily: aud_send_msg("mus_second_floor");
	
	array_spawn_targetname( "lobby_combat_top_left_enemies" );
}

lobby_combat_top_right()
{
	level endon( "lobby_combat_top_left" );
	
	flag_wait( "lobby_combat_top_right" );
	flag_set( "lobby_combat_top" );
	// commenting out temorarily: aud_send_msg("mus_second_floor");
	
	array_spawn_targetname( "lobby_combat_top_right_enemies" );
}

lobby_combat_top_gallery()
{
	flag_wait( "lobby_combat_top_gallery" );
	
	array_spawn_targetname( "lobby_combat_top_gallery_enemies" );
}

lobby_combat_top_final()
{
	flag_wait( "lobby_combat_top_final" );
	
	array_spawn_targetname( "lobby_combat_top_enemies" );
}

lobby_combat_cleanup()
{
	foreach( enemy in getaiarray( "axis" ) )
	{
		enemy thread bloody_death( RandomFloatRange( 0, 3 ), level.yuri );
	}
}

lobby_civilians()
{
	thread lobby_elevator_civilians();
	array_spawn_function_noteworthy( "civilians_lobby_stationary", ::civilian_drone_stationary_think, "elevator_doors_closed" );
	array_spawn_function_noteworthy( "civilians_lobby_top_drones", ::civilian_drone_run_and_hide_think, "elevator_doors_closed" );
	
	flag_wait( "lobby_combat_top" );
	array_spawn_noteworthy( "civilians_lobby_top_drones" );
	
	flag_wait( "lobby_combat_ascent" );
	array_spawn_targetname( "civilians_lobby_cower_upstairs", true );
}

lobby_elevator_civilians()
{
	array_spawn_function_noteworthy( "civilians_lobby_elevator", ::civilian_drone_elevator_think );
	
	//wait until lobby combat starts, then close door
	flag_wait( "lobby_combat_ascent" );
	level.player_elevator thread common_scripts\_elevator::close_outer_doors(0);
	
	//when player approaches door, open it
	flag_wait( "lobby_yuri_to_elevator" );
	level.player_elevator thread common_scripts\_elevator::open_outer_doors(0);
	
	aud_send_msg( "1st_elevator_doors_open", level.player_elevator common_scripts\_elevator::get_housing_leftdoor() );
	
	elev_civs = array_spawn_targetname( "civilians_lobby_elevator_drones" );
	aud_send_msg("start_elevator_civ_runners", elev_civs);
}

ocean_logic()
{
	ocean_initial = getent( "ocean_initial", "targetname" );
	ocean_vista = getent( "ocean_vista", "targetname" );
	
	ocean_vista hide();
	
	while( 1 )
	{
		flag_wait( "ocean_vista" );
		flag_clear( "ocean_initial" );
		
		ocean_vista show();
		ocean_initial hide();
		
		flag_wait( "ocean_initial" );
		flag_clear( "ocean_vista" );
		
		ocean_initial show();
		ocean_vista hide();
	}
}

///////////////////////////////////////////////
//---------------- ELEVATOR -----------------//
///////////////////////////////////////////////

setup_elevator()
{
	SetDvar( "scr_elevator_speed", "125" );
	
	level.elevator_debug = true;
	
	level.player_elevator = get_elevator( "usable_elevator" );
	level.replacement_elevator = get_elevator( "replacement_elevator" );
	
	level.player_elevator thread elevator_glass_attach();
	level.replacement_elevator thread elevator_glass_attach();
	
	thread elevator_glass();
	thread elevator_logic();
	thread elevator_sequence();
	thread elevator_player_logic();
	thread elevator_yuri_movement();
	
	//make sure enemies don't path into the elevator
	lobby_elevator_badplace = getent( "lobby_elevator_badplace", "targetname" );
	BadPlace_Brush( "lobby_elevator_badplace", -1, lobby_elevator_badplace, "axis" );
	
	top_floor_elevator_badplace = getent( "top_floor_elevator_badplace", "targetname" );
	BadPlace_Brush( "top_floor_elevator_badplace", -1, top_floor_elevator_badplace, "axis" );
}

elevator_glass()
{
	level.elevatorGlassHealth = 300;
	
	array_thread( getentarray( "elevator_glass", "targetname" ), ::elevator_glass_think );
}

elevator_player_death()
{
	level endon("player_jumping");	// don't link to this elevator on death after the player jumps
	level endon("drop_player_elevator");	// don't link to this elevator on death after it starts dropping
	level endon("player_falling_kill_in_progress"); //don't link to this elevator on death if already falling
	
	level.player waittill("death");
	tag_origin = spawn_tag_origin();
	tag_origin.origin = level.player.origin;
	tag_origin linkto( level.player_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );
	level.player PlayerLinkTo( tag_origin );
	//elevator_player_death_angles_and_height();
}

elevator_player_death_replacement_elevator()
{
	level endon("player_at_top_floor");	// don't link to this elevator on death once the player is at the top floor
	
	level.player waittill("death");
	tag_origin = spawn_tag_origin();
	tag_origin.origin = level.player.origin;
	elevator_replacement_blocker = getent( "elevator_replacement_blocker", "targetname" );
	tag_origin linkto( elevator_replacement_blocker );
	level.player PlayerLinkTo( tag_origin );
	//elevator_player_death_angles_and_height();
}

//TODO: doesn't quite work yet, but this is supposed to adjust the player's height and angles to mimic that of normal death
elevator_player_death_angles_and_height()
{
	view_angle_controller_entity = spawn( "script_origin", (0, 0, 0 ) );
	view_angle_controller_entity.angles = level.player.angles;
	level.player playerSetGroundReferenceEnt( view_angle_controller_entity );
	pitch = 45;
	moveTime = 0.1;
	//view_angle_controller_entity rotateto( view_angle_controller_entity.angles + (pitch, 0, pitch), moveTime, moveTime / 2, moveTime / 2 );
	
	height_delta = 3;
	
	//death height is 8 units
	//60, 40, 11 -> 8
	if( level.player getstance() == "stand" )
	{
		height_delta = 52;
	}
	else if( level.player getstance() == "crouch" )
	{
		height_delta = 32;
	}
	
	level.player SetOrigin( level.player.origin - (0, 0, height_delta) );
	level.player SetPlayerAngles( level.player.angles + (0, 0, 45) );
	
	
	//level.player teleport( level.player.origin - (0, 0, height_delta), level.player.angles + (45, 0, 45) );
	//level.player setstance( "prone" );
}

elevator_player_logic()
{
	flag_wait( "elevator_chopper_killed" );
	
	level.player allowcrouch( false );
	level.player enableinvulnerability();
	
	
	flag_wait( "elevator_chopper_crash_done" );
	
	level.player HideViewModel();
	
	//level.player DoDamage( level.player.health / 2, level.player.origin );
	//level.player DoDamage( 50 / level.player.damageMultiplier, (-1024, 128, level.player.origin[2]) );
	//delay slightly so regen can be adjusted
	//level.player delaycall( 0.05, ::DoDamage, level.player.health * 0.9, (-1024, 128, level.player.origin[2]) );
	
	level.player thread play_fullscreen_blood_splatter_alt(4, 0, 2, 1);
	
	g_friendlyNameDist_old = GetDvarInt( "g_friendlyNameDist" );
	SetSavedDvar( "g_friendlyNameDist", 0 );
	SetSavedDvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", 1 );
	SetSavedDvar( "hud_showstance", 0 );
	SetSavedDvar( "actionSlotsHide", 1 );
	
	elevator_anim_node = getent( "elevator_button_anim_node", "targetname" );
	
	anime = "remove_gear_player";
	
	old_weapon = level.player GetCurrentWeapon();
	
	if ( old_weapon != level.secondaryweapon )
	{
		// switch to the default secondary if it's in the player's inventory
		weaps = level.player GetWeaponsListAll();
		foreach ( weap in weaps )
		{
			if ( weap == level.secondaryweapon )
			{
				old_weapon = level.secondaryweapon;
			}
		}
	}
	
	level.player SwitchToWeapon( old_weapon );
	
	level.player DisableWeapons();
	player_rig = spawn_anim_model( "player_rig_juggernaut", elevator_anim_node.origin );
	player_rig.animname = "player_rig_juggernaut";
	player_rig linkto( elevator_anim_node );
	
	thread maps\dubai_fx::player_fire_vfx(player_rig);
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.5, 0.2, 0.2 );
	
	elevator_anim_node thread anim_single_solo( player_rig, anime );
	player_rig thread elevator_player_slowmo();
	
	overlay = get_black_overlay();
	
	setBlur( 4, 0 );
	noself_delayCall( 2, ::setblur, 2, 2 );
	
	/*
	 * Remove juggernaut mask.  Cover with quick black screen
	 */
	player_rig waittillmatch( "single anim", "remove_player_helm" );

	wait 0.4;
	
	level.player playrumbleonentity( "damage_light" );
	blackout_time = 0.05;
	overlay thread blackOut( blackout_time, 2 );
	wait blackout_time;
	flag_set( "remove_player_juggernaut" );
	wait 0.1;
	overlay restoreVision( 0.1, 2 );
	
	/*
	 * Back out for a sec while Yuri swaps models
	 */
	player_rig waittillmatch( "single anim", "fade_out" );
	
	overlay blackout( 0.5, 4 );
	
	elevator_anim_node waittill( anime );
	
	player_rig setmodel( "viewhands_player_pmc" );
	player_rig.animname = "player_rig";
	
	anime2 = "remove_gear_player_2";
	elevator_anim_node anim_first_frame_solo( player_rig, anime2 );
	
	level.player freezecontrols( true );
	
	wait 2.5;
	
	flag_set( "elevator_remove_gear_2" );
	
	level.player freezecontrols( false );
	
	elevator_anim_node thread anim_single_solo( player_rig, anime2 );
	overlay thread restoreVision( 1, 2 );
	
	noself_delayCall ( 1, ::setBlur, 0, 1 );
	
	level.player delayCall( 1.5, ::playrumbleonentity, "damage_light" );
	
	player_rig waittillmatch( "single anim", "hide_player_chest_piece" );
	level notify( "hide_player_chest_piece" );
	
	elevator_anim_node waittill( anime2 );
	
	level.player allowcrouch( true );
	level.player allowprone( true );
	
	SetSavedDvar( "g_friendlyNameDist", g_friendlyNameDist_old );
	SetSavedDvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", 0 );
	SetSavedDvar( "hud_showstance", 1 );
	SetSavedDvar( "actionSlotsHide", 0 );
	
	thread elevator_view_tilt();
	
	thread autosave_by_name( "elevator_jump_start" );
	
	player_rig unlink();
	level.player unlink();
	player_rig delete();
	
	flag_wait( "replacement_elevator_in_position" );
	thread elevator_player_jump();
	
	flag_wait( "player_jumped_to_replacement_elevator" );
	level.player AllowJump( false );
	
	level waittill( "elevator_doors_opening" );
	level.player AllowJump( true );
	
	level.player disableinvulnerability();
}

elevator_player_slowmo()
{
	slowmo_setspeed_slow( .75 );
	slowmo_setlerptime_in( 0 );
	slowmo_setlerptime_out( .5 );
	
	self waittillmatch( "single anim", "start_slomo" );
	slowmo_lerp_in();
	
	self waittillmatch( "single anim", "end_slomo" );
	slowmo_lerp_out();
}

elevator_yuri_movement()
{
	flag_wait( "player_in_elevator" );
	animnode = getent( "elevator_button_anim_node", "targetname" );
	animnode linkto( level.player_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );
	
	anime = "elevator_press_button";
	animnode thread anim_single_solo( level.yuri, anime );
	
	level.yuri waittillmatch( "single anim", "anim_elevator_button_pressed" );
	flag_set( "elevator_button_pressed" );
	aud_send_msg("mus_elevator_button_pressed");
	
	level waittill( "elevator_interior_button_pressed" );
	level.yuri LinkTo( level.player_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );
	
	elevator_anim_node = getent( "elevator_button_anim_node", "targetname" );
	elevator_anim_node linkto( level.player_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );
	
	top_floor_yuri_grenade_location = getent( "top_floor_yuri_grenade_location", "targetname" );
	top_floor_yuri_grenade_location LinkTo( level.replacement_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );
	
	level.yuri thread elevator_yuri_target_chopper();
	level.yuri thread elevator_yuri_kill_chopper();
	
	animnode waittill( anime );
	
	loop_anime = "elevator_idle_scan";
	animnode thread anim_loop_solo( level.yuri, loop_anime, "chopper_attack_started" );
	
	flag_wait( "elevator_chopper_preattack" );
	level.yuri set_combat_stand_animset( %dubai_jugg_elevator_idle_scan_fire, %Juggernaut_high_aim5, %juggernaut_high_aim_idle, %dubai_juggernaut_stand_reload );
	level.yuri.combatStandAnims[ "add_aim_up" ] = %dubai_jugg_scan_aim_high;
	level.yuri.combatStandAnims[ "add_aim_down" ] = %dubai_jugg_scan_aim_low;
	level.yuri.combatStandAnims[ "add_aim_left" ] = %dubai_jugg_scan_aim_left;
	level.yuri.combatStandAnims[ "add_aim_right" ] = %dubai_jugg_scan_aim_right;
	level.yuri AllowedStances( "stand" );
	level.yuri.a.disablePain = true;
	savedMinPainDamage = level.yuri.minPainDamage;
	level.yuri.minPainDamage = 100000;
	savedAimPitchDiffTolerance = anim.aimPitchDiffTolerance;
	savedAimYawDiffFarTolerance = anim.aimYawDiffFarTolerance;
	anim.aimPitchDiffTolerance = 60;
	anim.aimYawDiffFarTolerance = 45;

	animnode notify( "chopper_attack_started" );
	
	level.yuri.ignoreme = true;
	
	flag_wait( "elevator_chopper_near_crash" );
	
	level.yuri.ignoreme = false;
	
	anime = "chopper_react";
	elevator_anim_node thread anim_single_solo( level.yuri, anime );
	//level.yuri linkto( elevator_anim_node );
	
	flag_wait( "elevator_chopper_crash_done" );
	level.yuri set_combat_stand_animset( %Juggernaut_stand_fire_burst, %Juggernaut_dubai_aim5, %Juggernaut_dubai_stand_idle, %dubai_juggernaut_stand_reload );
	level.yuri.combatStandAnims[ "add_aim_up" ] = %juggernaut_dubai_stand_aim_high;
	level.yuri.combatStandAnims[ "add_aim_down" ] = %juggernaut_dubai_stand_aim_low;
	level.yuri.combatStandAnims[ "add_aim_left" ] = %juggernaut_dubai_stand_aim_left;
	level.yuri.combatStandAnims[ "add_aim_right" ] = %juggernaut_dubai_stand_aim_right;
	level.yuri AllowedStances( "stand", "crouch", "prone" );
	level.yuri.a.disablePain = false;
	level.yuri.minPainDamage = savedMinPainDamage;
	anim.aimPitchDiffTolerance = savedAimPitchDiffTolerance;
	anim.aimYawDiffFarTolerance = savedAimYawDiffFarTolerance;
	
	//level.player shellshock( "default", 0.5, true);
	earthquake( .4, 3, level.player.origin, 8000 );
	
	elevator_gear = spawn( "script_model", elevator_anim_node.origin );
	elevator_gear setModel( "dub_juggernaut_chestarmor" );
	elevator_gear.animname = "elevator_gear";
	elevator_gear UseAnimTree( level.scr_animtree[ "elevator_gear" ] );
	
	flag_set( "remove_yuri_juggernaut" );
	
	flag_wait( "yuri_no_juggernaut_spawned" );
	
	anime = "remove_gear";
	actors[0] = level.yuri;
	actors[1] = elevator_gear;
	
	level.yuri setmodel( "body_juggernaut_quartergear" );
	
	elevator_anim_node anim_first_frame( actors, anime );
	level.yuri linkto( elevator_anim_node );
	elevator_anim_node thread anim_single( actors, anime );
	
	elevator_helmet = spawn( "script_model", elevator_anim_node.origin );
	elevator_helmet setModel( "dub_juggernaut_helmet" );
	elevator_helmet teleport_to_ent_tag( level.yuri, "TAG_INHAND" );
	elevator_helmet linkto( level.yuri, "TAG_INHAND" );
	
	anime2 = "remove_gear_2";
	
	flag_wait( "elevator_remove_gear_2" );
	
	elevator_helmet delete();
	elevator_gear thread elevator_gear_remove_on_notify();
	
	level.yuri setmodel( "body_juggernaut_nogear" );
	
	level.yuri LinkTo( level.player_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );
	
	elevator_anim_node thread anim_single( actors, anime2 );
	
	/*
	 * Call elevator for consistent timing
	 */
	level.yuri waittillmatch( "single anim", "elevator_replacement_call" );
	level.replacement_elevator thread elevator_replacement_move_to_jump_position();
	
	/*
	 * Shake elevator to correspond with animation
	 */
	level.yuri waittillmatch( "single anim", "elevator_shake" );
	flag_set( "elevator_initial_short_drop" );
	
	thread elevator_yuri_jump_end( top_floor_yuri_grenade_location );
	thread elevator_yuri_jump_glass_break();
	
	/*
	 * Drop elevator a bit right when yuri jumps off
	 */
	level.yuri waittillmatch( "single anim", "elevator_drop" );
	
	flag_set( "elevator_initial_big_drop" );
	// dv, comenting out temporarily: aud_send_msg("mus_elevator_heli_yuri_jump");
	
	level.yuri unlink();
	level.yuri LinkTo( level.replacement_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );
}

elevator_yuri_jump_end( top_floor_yuri_grenade_location )
{
	flag_wait( "player_jumped_to_replacement_elevator" );
	
	wait 0.4;
	//place yuri ready for grenade throw
	level.yuri thread top_floor_yuri_throw_grenade( top_floor_yuri_grenade_location );
	
	//level arrives at top floor
	level waittill( "elevator_doors_opening" );
	level.yuri unlink();
}

elevator_yuri_jump_glass_break()
{
	level endon( "elevator_break_glass" );
	
	level.yuri waittillmatch( "single anim", "elevator_break_glass" );
	level notify( "elevator_break_glass" );
}

elevator_break_glass()
{
	level.elevatorGlassHealth = 400;
	
	level waittill( "elevator_break_glass" );
	
	elevator_glass = getentarray( "elevator_replacement_glass_des", "script_noteworthy" );
	foreach( glass in elevator_glass )
	{
		glass.damagetype = "MOD_RIFLE_BULLET";
	}
	array_thread( elevator_glass, ::elevator_glass_destroy );
	
	level.elevatorGlassHealth = 300;
}

elevator_gear_remove_on_notify()
{
	level waittill( "hide_player_chest_piece" );
	
	self delete();
}

elevator_yuri_target_chopper()
{
	thread elevator_yuri_target_chopper_end();
	
	self.ignoreall = true;
	
	level endon( "elevator_chopper_killed" );
	
	flag_wait( "elevator_chopper_preattack" );
	
	self.ignoreall = false;
	
	targets = getentarray( "elevator_attack_chopper_target_ents", "script_noteworthy" );

	self setentitytarget( targets[ 0 ] );
	
	//randomly choose a new target position on the chopper every few seconds
// 	while( !flag( "elevator_chopper_killed") )
// 	{
// 		self setentitytarget( targets[ randomintrange( 0, targets.size) ] );
// 		
// 		wait randomfloatrange( 3, 5 );
// 	}
}

elevator_yuri_target_chopper_end()
{
	flag_wait( "elevator_chopper_killed" );
	
	//weird issue with removing and replacing yuri only on a debug checkpoint
	if( IsDefined( self ) )
	{
		self clearentitytarget();
	}
}

elevator_yuri_kill_chopper()
{
	level endon( "elevator_chopper_killed" );
	
	while( self.origin[2] < 5120 )
	{
		wait 0.25;
	}
	
	//no winning now
	level.elevator_attack_chopper godon();
	
	level.player endon( "death" );
	level.player EnableHealthShield( false );
	
	level.elevator_attack_chopper thread play_loop_sound_on_entity( "littlebird_gatling_fire" );
	
	for ( ;; )
	{
		foreach( turret in level.elevator_attack_chopper.mgturret )
		{
			playfxontag( getfx("blackhawk_flash_armada"), turret, "tag_flash" );
		}
		
		level.player DoDamage( 15 / level.player.damagemultiplier, level.elevator_attack_chopper.origin, level.elevator_attack_chopper );
		timer = RandomFloatRange( 0.1, 0.3 );
		wait( timer );
	}
}

elevator_yuri_jump_anims( elevator_anim_node )
{
	elevator_glass = getentarray( "elevator_replacement_glass_des", "script_noteworthy" );
	foreach( glass in elevator_glass )
	{
		glass.damagetype = "MOD_RIFLE_BULLET";
	}
	delaythread( 1, ::array_thread, elevator_glass, ::elevator_glass_shatter );
	
	anime = "elevator_jump";
	elevator_anim_node thread anim_single_solo(level.yuri, anime);
	
	delaythread( 1.8, ::array_thread, elevator_glass, ::elevator_glass_destroy );
	
	flag_wait( "replacement_elevator_in_position" );
	
	delaythread( 3, ::flag_set, "update_obj_pos_elevator_jump" );
	
	elevator_anim_node unlink();
	elevator_anim_node LinkTo( level.replacement_elevator.e[ "housing" ][ "mainframe" ][ 0 ] );
	
	elevator_anim_node waittill( anime );
	
	level endon( "player_elevator_jump_successul" );
	
	anime = "elevator_jump_idle";
	
	elevator_anim_node thread anim_single_solo( level.yuri, anime );
}

elevator_logic()
{
	level.player_elevator thread elevator_initial_think();
	level.replacement_elevator thread elevator_replacement_think();
}

keep_player_away_from_yuri( min_distance2D )
{
	self endon( "done_player_keep_away_from_yuri" );
	while ( 1 )
	{
		away_from_entity = level.yuri;
		if ( isdefined( away_from_entity ) )
		{
			player_pos = level.player.origin;
			away_pos = away_from_entity.origin;
			distance2D = Distance2D( player_pos, away_pos );
			if ( distance2D < min_distance2D )
			{
				heightDiff = player_pos[2] - away_pos[2];
				if ( ( heightDiff > -4 ) && ( heightDiff < 72 ) )
				{
					push_dir = player_pos - away_pos;
					push_dir = ( push_dir[0], push_dir[1], 0 );
					push_dir = VectorNormalize( push_dir );
					speed = ( min_distance2D - distance2D ) * 1000 * 0.05;
					player_velocity = push_dir * speed * 0.2;
					level.player SetVelocity( player_velocity );
				}
			}
		}
		wait 0.05;
	}
}

elevator_sequence()
{
	level waittill( "elevator_interior_button_pressed" );
	flag_set( "update_obj_pos_in_elevator" );
	
	level.player thread keep_player_away_from_yuri( 40 );

	thread elevator_player_death();
	
	thread battlechatter_off( "allies" );
	thread battlechatter_off( "axis" );
	
	wait 0.25;
	flag_set( "vo_elevator_start" );
	
	/#
	//shortcuts for testing elevator animations
	if( GetDvarInt( "dev_elevator_anim_test" ) )
	{
		wait 10;
		flag_set( "elevator_chopper_preattack" );
		flag_set( "elevator_chopper_attack" );
		flag_set( "elevator_chopper_killed");
		flag_set( "elevator_chopper_near_crash" );
		wait 0.8;
		flag_set( "elevator_chopper_crash_done" );
	}
	#/

	wait 6.5;

	//little birds come into scene
	array_spawn_function_targetname( "elevator_ambient_chopper", ::elevator_ambient_chopper_think );
	elevator_ambient_chopper  = spawn_vehicle_from_targetname_and_drive( "elevator_ambient_chopper" );
	aud_send_msg("ambient_elevator_chopper", elevator_ambient_chopper);
	
	level.player.chopper_tgt = spawn_tag_origin();
	level.player.chopper_tgt_offset = 60;
	level.player thread elevator_chopper_tgt_update();
	attack_chopper_spawner = getent( "elevator_attack_chopper", "targetname" );
	attack_chopper_spawner add_spawn_function( ::elevator_attack_chopper_think );
	level.elevator_attack_chopper = attack_chopper_spawner spawn_vehicle_and_gopath();
	level.elevator_attack_chopper add_damage_function( ::elevator_attack_chopper_special_damage_function );
	aud_send_msg("elevator_attack_chopper", level.elevator_attack_chopper);
	
	if( GetDvarInt( "dev_elevator_anim_test" ) )
	{
		level.elevator_attack_chopper kill();
		level.elevator_attack_chopper delete();
	}
	
	level waittill( "elevator_doors_opening" );
	flag_set( "player_at_top_floor" );
	flag_set( "update_obj_pos_top_floor_atrium_landing" );
	
	level.player notify( "done_player_keep_away_from_yuri" );
	thread autosave_by_name( "top_floor_start" );
	
	thread battlechatter_on( "allies" );
	thread battlechatter_on( "axis" );
}

manage_linking_elevator_player_jump_node()
{
	// if we jump early, then we jump linked to the original epjn, and move the epjn to match the one linked to the replacement elevator
	// if we jump after the first drop, then we jump linked to the original epjn, which is linked to the replacement elevator
	elevator_player_jump_node = getent( "elevator_player_jump_node", "targetname" );
	starting_node = spawn_tag_origin();
	starting_node.origin = elevator_player_jump_node.origin;
	starting_node.angles = elevator_player_jump_node.angles;
	starting_mainframe = level.player_elevator	common_scripts\_elevator::get_housing_mainframe();
	replacement_mainframe = level.replacement_elevator common_scripts\_elevator::get_housing_mainframe();
	
	flag_wait( "replacement_elevator_in_position" );
	org_replacement_contents = replacement_mainframe SetContents( 0 );	// disable collision on replacement
	thread elevator_yuri_handle_collision();
	
	elevator_player_jump_node.origin = elevator_player_jump_node.origin + (0,0,100);	// before drop, it is 100 units up
	elevator_player_jump_node linkto( starting_mainframe );	// for the early jump, we'll track with starting elevator
	level waittill( "player_elevator_jump_successul" );	// wait until the player jump starts
	time_in_air = 1000*(26.0/30.0);	// amount of time in ms from start of anim that the jump is in-air
	jump_start_time = gettime();	// start of jump
	
	flag_wait( "elevator_initial_big_drop" );	// don't move epjn until the big drop starts
	animtime = gettime() - jump_start_time;
	if (!flag( "elevator_initial_big_drop_done" ))
	{	// if the big drop isn't finished, then we'll move the node to the target over time
		starting_node.origin = starting_node.origin + (0,0,100);	// our reference node for this anim is 100 units up
		if (animtime >= time_in_air)
		{	// we've already made contact, so don't need to match
			elevator_player_jump_node unlink();
			elevator_player_jump_node.origin = starting_node.origin;
			elevator_player_jump_node linkto( replacement_mainframe );	// link it so it will track the target elevator
		}
		else
		{	// we haven't made contact and it is starting to move, so we'll move the epjn to match the moving_node
			elevator_player_jump_node unlink();	// it was attached to the first elevator, so it will have moved
			time_to_match = (time_in_air - animtime)*0.001;
			if (time_to_match > 0.05)
			{
				elevator_player_jump_node moveto( starting_node.origin, time_to_match, 0.0, 0.0 );
				wait time_to_match;
			}
			elevator_player_jump_node.origin = starting_node.origin;
			elevator_player_jump_node linkto( replacement_mainframe );
		}
		
	}
	else
	{	// if the big drop was finished when we started the jump, then we don't need to move the epjn
		elevator_player_jump_node unlink();
		elevator_player_jump_node.origin = starting_node.origin;
		elevator_player_jump_node linkto( replacement_mainframe );	// link it so it will track the target elevator
	}
	starting_node Delete();
	flag_wait( "player_finished_jump_to_replacement_elevator" );
	replacement_mainframe SetContents( org_replacement_contents );	// restore collision on replacement elevator
}

elevator_yuri_handle_collision()
{
	wait 1;
	yuri_contents = level.yuri SetContents( 0 );	// disable collision on yuri
	
	flag_wait( "player_finished_jump_to_replacement_elevator" );
	
	level.yuri SetContents( yuri_contents );	// restore collision on yuri
}

elevator_player_jump()
{
	thread manage_linking_elevator_player_jump_node();
	
	elevator_player_jump_node = getent( "elevator_player_jump_node", "targetname" );
	jumpForward = AnglesToForward( elevator_player_jump_node.angles + (0,-90,0) );
	
	player_rig = spawn_anim_model( "player_rig", elevator_player_jump_node.origin );
	player_rig hide();
	
	jumpstart_trig = GetEnt( "elevator_jump_trigger", "targetname" );
	//edgeref = GetStruct( "struct_player_bigjump_edge_reference", "targetname" );
	//groundref = GetStruct( "struct_player_recovery_animref", "targetname" );
	
	thread player_jump_watcher();
	
	// takes care of a player who missed the cool animated jump and just fell
	//thread player_normalfall_watcher();
	//level endon( "player_fell_normally" );
	
	while( 1 )
	{
		breakout = false;
		
		while( level.player IsTouching( jumpstart_trig ) )
		{
			flag_wait( "player_jumping" );
			if( player_leaps( jumpstart_trig, jumpForward, 0.915, true ) )  // 0.925
			{
				breakout = true;
				break;
			}
			wait( 0.05 );
		}
		
		if( breakout )
		{
			break;
		}
		wait( 0.05 );
	}
	
	level notify( "player_jump_watcher_stop" );
	level notify( "player_elevator_jump_successul" );
	
	//stop any rumbles while the player jumps
	stopallrumbles();
	
	aud_send_msg("mus_elevator_heli_player_jump");
	
	//if elevator is already falling, drop out of the function
	if( flag( "drop_player_elevator" ) )
	{
		return;
	}
	
	flag_set( "update_obj_pos_elevator_jump_complete" );
	
	delaythread( 2, ::flag_set, "drop_player_elevator" ); 
	
	anime = "elevator_jump_player";
	if (!flag("elevator_initial_big_drop") || !flag("elevator_initial_big_drop_done"))
	{
		anime = "elevator_jump_player_early";
	}
	actors[0] = player_rig;
	elevator_player_jump_node anim_first_frame(actors,anime);
		
	player_rig linkto( elevator_player_jump_node );
	
	blend_time = 0.75;
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", blend_time );
	level.player delaycall( 5.5, ::EnableWeapons );
	level.player delaycall( 5.5, ::ShowViewModel );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	
	player_rig delaycall( blend_time, ::Show );
	level delaythread( 1.0, ::flag_set, "player_jumped_to_replacement_elevator" );
	
	level thread notify_delay( "elevator_break_glass", 0.8 );
	level.player delaycall( 0.8, ::playrumbleonentity, "damage_light" );
	
	elevator_player_jump_node thread anim_single_solo( actors[1], anime );
	elevator_player_jump_node anim_single_solo( actors[0], anime );	// separate calls since the leg anim is shorter than the arms
	
	flag_set( "player_finished_jump_to_replacement_elevator" );
	
	level.player unlink();
	player_rig delete();
	thread elevator_player_death_replacement_elevator();
	
	//thread autosave_by_name( "elevator_jump_complete" );
	
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	
	wait 4;
	flag_set( "top_floor_countdown_start" );
}

elevator_player_jump_fail_watcher()
{
	level endon( "player_elevator_jump_successul" );
	
	volume = getent( "elevator_drop_volume", "targetname" );
	
	while( level.player.origin[2] > level.elevator_jump_start_height || ( level.player istouching( volume ) ) )
	{
		wait 0.05;
	}
	
	flag_set( "elevator_player_missed_jump" );
	flag_set( "vo_elevator_player_falling" );
	
	thread player_falling_kill_logic();
	
	stopallrumbles();
}

elevator_initial_think()
{
	mainframe = self common_scripts\_elevator::get_housing_mainframe();
	
	elevator_destroyed_section_intact = getent( "elevator_destroyed_section_intact", "script_noteworthy" );
	elevator_destroyed_section_intact linkto( mainframe );
	
	elevator_helicopter_crash_location = getent( "elevator_helicopter_crash_location", "script_noteworthy" );
	elevator_helicopter_crash_location linkto( mainframe );
	
	//rocket miss targets
	elevator_chopper_rocket_miss_targets = getentarray( "elevator_chopper_rocket_miss_targets", "targetname" );
	foreach( target in elevator_chopper_rocket_miss_targets )
	{
		target linkto( mainframe );
	}
	
	elevator_jump_trigger = getent( "elevator_jump_trigger", "targetname" );
	elevator_jump_trigger enablelinkto();
	elevator_jump_trigger linkto( mainframe );
	
	//connect paths at ground floor
	left_door = self common_scripts\_elevator::get_outer_leftdoor( 0 );
	right_door = self common_scripts\_elevator::get_outer_rightdoor( 0 );
	left_door ConnectPaths();
	right_door ConnectPaths();
	
	//wait until yuri and player are both in the elevator
	
	player_elevator_blocker = getent( "player_elevator_blocker", "targetname" );
	player_elevator_blocker notsolid();
	
	flag_wait( "lobby_yuri_to_elevator" );
	
	thread elevator_floor_numbers( "elevator_initial_model", "player_jumped_to_replacement_elevator" );
	
	flag_wait( "player_in_elevator" );
	
	player_elevator_blocker solid();
	
	flag_wait( "elevator_button_pressed" );
	
	//move elevator to top floor
	self common_scripts\_elevator::call_elevator(1);
	
	aud_send_msg( "1st_elevator_doors_close", self common_scripts\_elevator::get_housing_leftdoor() );
	
	self waittill( "closed_inner_doors" );
	flag_set( "elevator_doors_closed" );
	
	ent = get_rumble_ent( "subtle_tank_rumble" );
	ent.intensity = 0.45;
	
	aud_send_msg( "1st_elevator_platform_start", mainframe );
	
	flag_wait( "elevator_chopper_crash_done" );
	
	ent StopRumble( "subtle_tank_rumble" );
	
	aud_send_msg( "1st_elevator_platform_stop", mainframe );
	
	//Elevator is now destroyed
	
	//move_elevator(delta_vec, moveTime, acceleration, deceleration)
	self move_elevator( (0, 0, 1) , 0.05, 0.025, 0.025 );
	self delaythread( 0.05, ::move_elevator, (0, 0, -1) , 0.05, 0.025, 0.025 );
	
	//elevator_destroyed_section_intact delete();
	exploder(100);
	
	
	elevator_initial_model = getent( "elevator_initial_model", "script_noteworthy" );
	elevator_initial_model setmodel( "dub_bldg_elevator_des" );

	mainframe = self common_scripts\_elevator::get_housing_mainframe();

	elev_origin = self.e[ "housing" ][ "mainframe" ][ 1 ];
	
	thread maps\dubai_fx::elevator_sparks_vfx(elev_origin);
	thread maps\dubai_fx::body_fire_vfx();
	
	//mainframe stoploopsound( "elev_run_loop" );
	//mainframe playsound( "elev_run_end" );
	
	short_drop_distance = 50;
	initial_drop_distance = 100;
	
	level.elevator_jump_start_height = mainframe.origin[2] - initial_drop_distance - short_drop_distance - 100;
	thread elevator_player_jump_fail_watcher();
	
	//explosion rumble
	ent = get_rumble_ent( "steady_rumble" );
	ent thread rumble_ramp_to( 0, 3 );
	
	thread elevator_falling_rumble_logic();
	
	flag_wait( "elevator_initial_short_drop" );
	aud_send_msg("elevator_short_drop", mainframe);
	
	fallTime = 1;
	
	self thread drop_elevator( falltime, short_drop_distance );
	
	thread maps\dubai_fx::elevator_drop_brake_vfx(elev_origin);
	
	earthquake( 0.25, fallTime, level.player.origin, 200 );
	wait fallTime;
	earthquake( 0.5, 0.5, level.player.origin, 200 );
	
	thread maps\dubai_fx::elevator_drop_vfx(elev_origin);
	
	flag_wait( "replacement_elevator_in_position" );
	
	thread flag_set_delayed( "drop_player_elevator", 7 );
	
	flag_wait( "elevator_initial_big_drop" );
	aud_send_msg("elevator_big_drop", mainframe);	
	
	fallTime = 1;
	
	self thread drop_elevator( fallTime, initial_drop_distance );
	
	thread maps\dubai_fx::elevator_drop_brake_vfx(elev_origin);
	
	earthquake( 0.25, fallTime, mainframe.origin, 200 );
	wait fallTime;
	flag_set( "elevator_initial_big_drop_done" );
	earthquake( 1, 0.5, mainframe.origin, 200 );
	
	thread maps\dubai_fx::elevator_drop_vfx_2(elev_origin);
	
	flag_wait( "drop_player_elevator" ); 
	
	aud_send_msg("elevator_freefall", elev_origin); 
	
	//player hasn't successfully jumped.  Disable jumping while elevator falls
	if( !flag( "update_obj_pos_elevator_jump_complete" ) )
	{
		level.player AllowJump( false );
		flag_set( "vo_elevator_player_falling" );
		thread elevator_player_falling_inside();
	}
	
	//TBD - need to calculate variable fall time depending on when the elevator stopped ascending
	fallTime = 10;
	self thread drop_elevator( fallTime );
	
	thread maps\dubai_fx::elevator_brake_vfx(elev_origin);
	
	//wait until elevator crashes into the bottom
	while( elev_origin.origin[2] > 160 )
	{
		wait 0.05;
	}
	aud_send_msg("aud_elevator_fail_fall", elev_origin);
	
	self.e[ "housing" ][ "inside_trigger" ] Delete();
	
	earthquake( .15, 1, level.player.origin, 200 );
	
	elevator_crash_explosion_marker = getent( "elevator_crash_explosion_marker", "targetname" );
	PlayFX( level._effect[ "elevator_explosion" ], elevator_crash_explosion_marker.origin );
}

elevator_player_falling_inside()
{
	level endon( "elevator_player_missed_jump" );
	
	ent = get_rumble_ent( "steady_rumble" );
	ent.intensity = 0.25;
}

elevator_falling_rumble_logic()
{
	level endon( "player_elevator_jump_successul" );
	level endon( "drop_player_elevator" );
	level endon( "elevator_player_missed_jump" );
	
	flag_wait( "elevator_initial_short_drop" );
	
	ent = get_rumble_ent( "steady_rumble" );
	ent.intensity = 0;
	ent rumble_ramp_to( 1, 1 );
	ent rumble_ramp_to( 0, 0.5 );
	
	flag_wait( "elevator_initial_big_drop" );
	
	ent = get_rumble_ent( "steady_rumble" );
	ent.intensity = 0;
	ent rumble_ramp_to( 1, 1 );
	ent rumble_ramp_to( 0, 0.5 );
}

elevator_view_tilt()
{
	view_angle_controller_entity = spawn( "script_origin", (0, 0, 0 ) );
	
	level.player playerSetGroundReferenceEnt( view_angle_controller_entity );
	
	loop_count = 0;
	pitch = 0;
	
	while( !flag( "player_jumped_to_replacement_elevator" ) )
	{
		old_pitch = pitch;
		
		moveTime = randomfloatrange( 2, 5 );
		if( loop_count % 2 )
		{
			pitch = randomintrange( 2, 5 );
		}
		else
		{
			pitch = randomintrange( -5, -2 );
		}
		
		moveTime = 2.0;
		view_angle_controller_entity rotatePitch( pitch - old_pitch, moveTime, moveTime / 2, moveTime / 2 );
		wait moveTime;
		loop_count++;
	}
	
	level.player playerSetGroundReferenceEnt( undefined );
	view_angle_controller_entity delete();
}

elevator_replacement_think()
{
	mainframe = self common_scripts\_elevator::get_housing_mainframe();
	
	elevator_player_jump_node = getent( "elevator_player_jump_node", "targetname" );
	elevator_player_jump_node linkto( mainframe );
	
	elevator_replacement_blocker = getent( "elevator_replacement_blocker", "targetname" );
	elevator_replacement_blocker linkto( mainframe );
	
	level waittill( "elevator_interior_button_pressed" );
	
	self common_scripts\_elevator::close_inner_doors();
	
	flag_wait( "elevator_chopper_crash_done" );
	
	thread elevator_break_glass();
	
	level waittill_any( "elevator_break_glass", "player_elevator_jump_successul" );
	
	elevator_replacement_blocker notsolid();
	
	//wait for a few things to happen before moving the elevator up
	flag_wait( "elevator_initial_big_drop" );
	flag_wait( "player_jumped_to_replacement_elevator" );
	
	flag_wait( "player_finished_jump_to_replacement_elevator" );

	ent = get_rumble_ent( "subtle_tank_rumble" );
	ent.intensity = 0.45;

	self thread elevator_replacement_move_to_top_floor();
	
	elevator_replacement_blocker solid();
	
	level waittill( "elevator_doors_opening" );
	
	stopallrumbles();
	
	left_door = self common_scripts\_elevator::get_outer_leftdoor( 1 );
	right_door = self common_scripts\_elevator::get_outer_rightdoor( 1 );
	left_door ConnectPaths();
	right_door ConnectPaths();
}

elevator_replacement_move_to_jump_position()
{
	thread elevator_floor_numbers( "elevator_replacement_model", "restaurant_destruction" );
	
	mainframe = self.e[ "housing" ][ "mainframe" ][0];
	
	aud_send_msg( "2nd_elevator_platform_start", mainframe );
	
	player_elevator_mainframe = level.player_elevator.e[ "housing" ][ "mainframe" ][0];
	
	dist = player_elevator_mainframe.origin[2] - mainframe.origin[2] - 104;
	delta_vec = (0, 0, dist);
	
	//adjust the move time to fit with any position the elevator stopped at
	moveTime = 13;
	//yuriLeadTime = 0.25;
	speed = dist/moveTime;

	// move housing
	self move_elevator(delta_vec, moveTime, moveTime * level.elevator_accel, moveTime * level.elevator_decel );
	
	wait moveTime;// - yuriLeadTime;
	
	//flag_set( "elevator_yuri_jump" );
	
	//wait yuriLeadTime;
		
	flag_set( "replacement_elevator_in_position" );
	
	aud_send_msg( "elevator_platform_stop", mainframe );
	
	delaythread( 2, ::flag_set, "update_obj_pos_elevator_jump" );
}

elevator_replacement_move_to_top_floor()
{
	mainframe = self common_scripts\_elevator::get_housing_mainframe();
	
	delta_vec = self.e[ "floor1_pos" ] - mainframe.origin;

	speed = level.elevator_speed;
	dist = abs( distance( self.e[ "floor1_pos" ], mainframe.origin ) );
	//moveTime = dist / speed;
	
	movetime = 15;

	// move housing:
	self thread move_elevator(delta_vec, moveTime, moveTime * level.elevator_accel, moveTime * level.elevator_decel );
	
	level.elevator_replacement_movetime = moveTime;
	
	flag_set( "elevator_replacement_moving_to_top" );
	
	aud_send_msg( "elevator_platform_start", mainframe );
	
	//thread elevator_replacement_show_timer();
	
	wait moveTime;
	
	self thread common_scripts\_elevator::open_inner_doors();
	self thread common_scripts\_elevator::open_outer_doors(1);
	
	aud_send_msg( "2nd_elevator_platform_stop", mainframe );
	aud_send_msg( "2nd_elevator_doors_open", self common_scripts\_elevator::get_housing_leftdoor() );
	aud_send_msg("mus_enter_top_floor");
}

elevator_replacement_show_timer()
{
	current_time = 0;
	
	step = 0.05;
	
	while( current_time < level.elevator_replacement_movetime )
	{
		current_time += step;
		
		wait step;
	}
}

elevator_chopper_tgt_update()
{
	level endon( "elevator_chopper_killed" );
	while (true)
	{
		level.player.chopper_tgt.origin = level.player.origin + (0,0,level.player.chopper_tgt_offset);
		wait 0.05;
	}	
}

elevator_attack_chopper_node_fixup( zoff )
{	// just making it easier to tune the start height
	start = getent("elevator_attack_chopper", "targetname");
	nodes[0] = getstruct( start.target, "targetname" );
	while (isdefined(nodes[nodes.size-1].target))
	{
		nodes[nodes.size] = getstruct(nodes[nodes.size-1].target, "targetname" );
	}
	// move the last two nodes before the hover node
	for (i = nodes.size-3; i<(nodes.size-1); i++)
	{
		if (i>=0)
			nodes[i].origin = nodes[i].origin + (0,0,zoff);
	}
	nodes[nodes.size-3].script_flag_set = "elevator_chopper_preattack";
	// now move all of the hover nodes
	hovernodes = getstructarray( "elevator_attack_chopper_hover_location", "script_noteworthy" );
	foreach (node in hovernodes)
	{
		node.origin = node.origin + (0,0,zoff);
	}
	
}

elevator_attack_chopper_think()
{
	level endon( "elevator_chopper_killed" );
	
	elevator_attack_chopper_node_fixup( -1000 );

	self godon();
	
	self.script_turretmg = 0;
	self.damage_taken = 0;
	self EnableAimAssist();
	
	//attach yuri target points
	elevator_attack_chopper_target_ents = getentarray( "elevator_attack_chopper_target_ents", "script_noteworthy" );
	foreach( ent in elevator_attack_chopper_target_ents )
	{
		ent linkto( self );
	}
	
	level.elevator_attack_chopper_invulnerable_time = 12;
	
	flag_wait( "elevator_chopper_preattack" );
	aud_send_msg("mus_elevator_heli_attack");
	self SetLookAtEnt( level.player.chopper_tgt );
	self thread littlebird_handle_spotlight( 0.5, true, (0, 0, -500), 250 );
	
	// Commenting out temporarily: aud_send_msg("mus_elevator_battle");
	self thread elevator_attack_chopper_manage_health();
	
	self thread elevator_attack_chopper_fire_ai_think();
	
	self thread elevator_attack_chopper_shoot_rockets_misses();
	self thread elevator_attack_chopper_shoot_rockets_at_player();
	
	flag_wait( "elevator_chopper_attack" );
	self delaythread( 1, ::elevator_chopper_loop_path_think, "elevator_attack_chopper_hover_location", "elevator_chopper_killed" );
}

elevator_attack_chopper_special_damage_function( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	//yuri doesn't do real damage
	if (( attacker == level.yuri ) || (attacker.classname == "misc_turret"))
	{
		self.health += damage;
		if ( attacker == level.yuri )
			self.damage_taken += damage;	// dodge from Yuri's attack
	}
	else
	{	// only count the player's damage to determine a dodge is needed
		self.damage_taken += damage;
	}	
}

elevator_attack_chopper_debug_state()
{
	self endon("death");
	if (!isdefined(self.ac_state))
		self.ac_state = "entry";
		
	while (true)
	{
		msg="mg"+self.script_turretmg+" state:"+self.ac_state;

		Print3d(self.origin + (0,0,120), msg, (1,1,1), 2);	
		wait 0.05;
	}
}

elevator_attack_chopper_DebugCatchHits()
{
	self endon("death");
	prvhealth = self.health - self.healthbuffer;
	while (self.health > 0)
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
		if (isdefined(amount))
		{
			curhealth = self.health - self.healthbuffer;
			self.debug_health_recs[self.debug_health_recs.size] = curhealth;
			prvhealth = curhealth;
		}
	}
}

elevator_attack_chopper_debug_health()
{
	self endon("death");
	self.debug_health_recs = [];
	self.debug_health_recs[0] = self.health - self.healthbuffer;
	self thread elevator_attack_chopper_DebugCatchHits();
	zscale = 0.1;
	while (true)
	{
		origin = self.origin;
		curhealth = self.health - self.healthbuffer;
		colr = (0, 1, 0);
		if (curhealth < 0)
			colr = (1, 1, 0);
		line(origin, origin + (0, 0, curhealth*zscale), colr);
		for (i=0; i<self.debug_health_recs.size; i++)
		{
			if (i & 1)
				colr = (1,0,0);
			else
				colr = (0,0,1);
			nxthealth = self.debug_health_recs[i];
			line(origin + (0, 0, curhealth*zscale), origin + (0, 0, nxthealth*zscale), colr);
			curhealth = nxthealth;
		}
		wait 0.05;
	}
}

elevator_attack_chopper_manage_health()
{
	chopper_fight_time = 0;
	/#
	if (debug_elevator_attack)
	{
		self thread elevator_attack_chopper_debug_health();
		chopper_fight_time = gettime();
	}
	#/
	
	self thread elevator_attack_chopper_cool_damage_effects();
	
	//ensure the vehicle isn't killed erroneously
	self.vehicle_stays_alive = true;
	
	//self.health += 2200;
	buffer = 2000;
	damage_req = 2400;
	
	chopper_crash_health = self.health + buffer;
	self.health = chopper_crash_health + damage_req;
	self.currenthealth = self.health;
	
	self godoff();
	
	delaythread( level.elevator_attack_chopper_invulnerable_time, ::flag_set, "elevator_chopper_min_time_passed" );
	
	while( !flag( "elevator_attack_chopper_kill" ) )
	{
		//if the minimum time hasn't passed, make sure the chopper isn't killed
		if( !flag( "elevator_chopper_min_time_passed" ) )
		{
			if( self.health < chopper_crash_health )
			{
				self.health = chopper_crash_health + 300;
			}
		}
		else
		{
			if( self.health < chopper_crash_health )
			{
				break;
			}
		}
		
		wait 0.05;
	}
	
	/#
		if( debug_elevator_attack )
		{
			iprintln( "chopper fight duration: " + (gettime() - chopper_fight_time) );
		}
		
	#/
	
	flag_set( "elevator_chopper_killed");
	self godon();
	thread elevator_attack_chopper_do_crash();
	
	thread kill_fx( self.model, false );
}

elevator_attack_chopper_shoot_up_windows( pos )
{
	target = spawn_tag_origin();
	target.origin = (level.player.origin[0], level.player.origin[1], pos[2]);
	/#
	if (debug_elevator_attack)
		target thread draw_label("target", 36);
	#/
	self.ac_state = "shoot_windows";	
	
	self setmaxpitchroll(45,45);
	self SetLookAtEnt( target );
	
	self SetTurretTargetEnt( target);
		
	target_height = 5000;
	time_to_pan = 6;
	weaponname = "minigun_littlebird_spinnup";
	target moveto( (level.player.origin[0], level.player.origin[1], target_height), time_to_pan, 0,0);
	self SetVehWeapon( weaponname );
	tags = ["TAG_MINIGUN_ATTACH_LEFT", "TAG_MINIGUN_ATTACH_RIGHT"];
	time_btn_shots = 0.1;
	for (time = 0; time<time_to_pan; time+=time_btn_shots)
	{
		foreach (i,mg in self.mgturret)
		{
			self FireWeapon( tags[i] );
		}
		
		wait time_btn_shots;
	}
	self setmaxpitchroll(20,20);
	target Delete();
}

elevator_attack_chopper_shoot_rockets_misses()
{
	level endon( "elevator_chopper_killed" );
	
	rocket_targets = getentarray( "elevator_chopper_rocket_miss_targets", "targetname" );;
	
	rocket_targets = array_randomize( rocket_targets );
	target = [];
	
	// Fire the opening shot
	target[0] = rocket_targets[0];
	/#
	if (debug_elevator_attack)
		target[0] thread draw_label( "opening miss tgt", 36 );
	#/

	self.ac_state = "rocket0";	
	self SetLookAtEnt( target[0] );
	self setmaxpitchroll( 20, 20 );
		
	self littlebird_fire_missile( target, 2, 0.5 );
	
	//wait 1.0;
	/#
	if (debug_elevator_attack)
		target[0] notify( "kill_debug_axis" );
	#/
	
	self elevator_attack_chopper_shoot_up_windows( target[0].origin );

	self.ac_state = "player";	
	self SetLookAtEnt( level.player.chopper_tgt );
	
	// wait for second rocket	
	while( self.origin[2] < 3584 )
	{
		wait 0.05;
	}
	
	//acquire target
	target[0] = rocket_targets[0];
	/#
	if (debug_elevator_attack)
		target[0] thread draw_label( "first miss tgt", 36 );
	#/
	
	self.ac_state = "rocket1";	
	self SetLookAtEnt( target[0] );
	self setmaxpitchroll( 20, 20 );
	wait 1;
		
	self littlebird_fire_missile( target, randomintrange( 1, 3) );
	
	self.ac_state = "player";	
	
	/#
	if (debug_elevator_attack)
		target[0] notify( "kill_debug_axis" );
	#/
	
	self SetLookAtEnt( level.player.chopper_tgt );
	}
		
elevator_attack_chopper_fire_ai_think()
{
	level endon( "elevator_chopper_killed" );

	/#
	if (debug_elevator_attack)
		self thread elevator_attack_chopper_debug_state();
	#/
	
	//wait 1.5;
	self.script_turretmg = 1;
	
	time_elapsed = 0;
	time_total = level.elevator_attack_chopper_invulnerable_time + 5;
	delay = 0.05;
	
	//cannot kill the player until time_total passes
	while( time_elapsed < time_total )
	{
		timeFraction = time_elapsed / time_total;
		healthFraction = level.player.health / 100;
		
		if( healthFraction < timeFraction )
		{
			self.script_turretmg = 0;
		}
		else
		{
			self.script_turretmg = 1;
		}
		
		time_elapsed += delay;
		wait delay;
	}
	
	self.script_turretmg = 1;
	
		/#
	if (debug_elevator_attack)
		iprintln( "Free fire mode" );
	#/
	
}

elevator_chopper_loop_path_think( loop_noteworthy, end_on, speed_min, speed_max )
{
	assert( isdefined( loop_noteworthy ) );
	
	if( IsDefined( end_on ) )
	{
		level endon( end_on );
	}
	
	if( !IsDefined( speed_min ) )
	{
		speed_min = 30;
	}
	
	if( !IsDefined( speed_max ) )
	{
		speed_max = 60;
	}
	
	self SetHoverParams( 512, 20, 5 );
	
	chopper_loop = getstructarray( loop_noteworthy, "script_noteworthy" );
	loop = chopper_loop;
	
	elevator_attack_chopper_loop = getstructarray( "elevator_attack_chopper_hover_location", "script_noteworthy" );
	
	elevator_housing = level.player_elevator.e[ "housing" ][ "mainframe" ][ 0 ];
	
	index = 0;
	dodge = false;
	adjust_height = 0;
	
	while( 1 )
	{
		/#
		if (debug_elevator_attack)
			loop[index] notify( "kill_debug_axis" );
		#/
		if( !flag( "elevator_chopper_min_time_passed" ) )
		{
			//minimum time passed, go to kill mode
			loop = GetStructArray( "elevator_attack_chopper_kill_node", "targetname" );
			index = 0;
		}
		else
		{
		loop = array_remove( chopper_loop, loop[index] );
		index = randomintrange( 0, loop.size );
		}
		
		/#
		if (debug_elevator_attack)
			loop[index] thread maps\dubai_code::draw_label( "heli node", 24 );
		#/
		
		time_towards_node = randomfloatrange( 1, 4 );
		if (dodge)
		{
			self.ac_state = "dodge";	
			speed = 1.5*randomintrange( speed_min, speed_max);
			self vehicle_setspeed( speed, speed, speed );
			self setmaxpitchroll(45,45);
			self SetHoverParams( 512, 40, 20);
			time_towards_node = 0.5;
			dodge = false;
		}
		else
		{
			if (self.ac_state == "dodge")
				self.ac_state = "player";	

			self vehicle_setspeed( randomintrange( speed_min, speed_max), 15, 15 );
			if( !flag( "elevator_chopper_min_time_passed" ) )
			{
			self setmaxpitchroll(20,20);
			}
			else
			{
				self setmaxpitchroll(45,45);
			}
			
			self SetHoverParams( 512, 20, 5);
		}
		
		delay = 0.05;
		start_damage = self.damage_taken;
		
		for( i = 0; i < time_towards_node; i = i + delay )
		{
			if (adjust_height <= 0)
			{
				delta_damage = self.damage_taken - start_damage;
				start_damage = self.damage_taken;
				if (delta_damage > 250)
				{	// dodge
					dodge = true;
					tgts_z = elevator_housing.origin[2];
					cur_z = self.origin[2];
					delta_z = tgts_z - cur_z;
					if (delta_z < 0)
						offset = RandomIntRange(0,300);
					else
						offset = RandomIntRange(-100,0);
					foreach( node in elevator_attack_chopper_loop )
					{
						node.origin = node.origin + (0, 0, offset);
					}
					adjust_height = 10;	// full half sec to dodge
					break;
				}
				else
				{
					if( flag( "elevator_chopper_min_time_passed" ) )
					{
						offset = RandomIntRange(30,60);
					}
					else
					{
						offset = RandomIntRange(0,400);
					}
					foreach( node in elevator_attack_chopper_loop )
					{
						if( node.origin[2] < elevator_housing.origin[2] + 400 )
						{
							node.origin = node.origin + (0, 0, offset);
						}
					}
					adjust_height = 5;
				}
			}
			adjust_height--;
			new_path = loop[ index ];
			self SetVehGoalPos( new_path.origin, 0 );
			
			wait delay;
		}
	}
}

elevator_attack_chopper_shoot_rockets_at_player()
{
	level endon( "elevator_chopper_killed" );
	
	flag_wait( "elevator_chopper_min_time_passed" );

	wait 5.5;

	//fire rockets
	rocket_target = [];
	rocket_target[0] = level.player;
	
	self SetLookAtEnt( rocket_target[0] );
	
	self littlebird_fire_missile( rocket_target, 2, 0.5 );
	
	wait 1;
	
	self littlebird_fire_missile( rocket_target, 3, 0.5 );
			}

attach_fx_on_target( fxSet,tagSet, point, direction_vec)
{
	self endon( "stop_looping_death_fx" );
	tagNum = find_closest_tag(point,tagSet);
	if (tagNum == -1)
		return;
	tag = tagSet[tagNum];
	fx = fxSet[tagNum];
	loopTime = 0.05;

	tag_origin = spawn_tag_origin();
	tag_origin.origin = self GetTagOrigin(tag);
	tag_origin.angles = self GetTagAngles(tag);	// we really need to get this from the direction_vec
	tag_origin linkto( self, tag );
	self.cool_damage_info[tag]["origin"] = tag_origin;
	self.cool_damage_info[tag]["fx"] = fx;
	PlayFXOnTag( fx, tag_origin, "tag_origin" );
	if (tag == "tag_light_nose")
		self littlebird_spotlight_off();	// shot out the spotlight
}

find_closest_tag(point,tags)
{
	mindist = 1000000;
	mintag = -1;
	j = 0;
	returnIndx = -1;	// returns -1 if all slots are used
	foreach (tag in tags)
	{
		if (isdefined(self.cool_damage_info) && isdefined(self.cool_damage_info[tag]))
			continue;
		tag_pos = self GetTagOrigin( tag );
		dist = Distance( tag_pos, point );
		if (dist < mindist)
		{
			mindist = dist;
			mintag = tag;
			returnIndx = j;
		}
		j++;
	}
	return returnIndx;
}

elevator_attack_chopper_kill_cool_damage_effects()
{
	self waittill("death");
	cool_damage_info = self.cool_damage_info;
	while (isdefined(self))
		wait 0.1;		// wait until it goes completely away
	if (isdefined(cool_damage_info))
	{
		foreach (tag, rec in cool_damage_info)
		{
			// kill effects and delete tag_origin
			StopFxOnTag(rec["fx"], rec["origin"], "tag_origin");
			rec["origin"] Delete();
		}
	}
}

// this thread will monitor hits and trigger smoke/fire as an enemy hind takes damage
elevator_attack_chopper_cool_damage_effects()
{
	self endon("death");
	fxs = [ "fire_smoke_trail_m_emitter"	,"heli_engine_fire"	, "fire_smoke_trail_m_emitter", "heli_engine_fire", "fire_smoke_trail_m_emitter", "fire_smoke_trail_m_emitter" ];
	tags = ["tag_origin"					, "main_rotor_jnt"	, "tag_deathfx"				  , "tag_engine"	  , "tag_light_belly"			, "tag_light_nose"			   ];
	smokefx = [];
	for(i=0;i<fxs.size;i++)
	{
		smokefx[(smokefx.size)]=level._effect[fxs[i]];
	}

	damagetillnextfx = 5000;
	numFXplaying = 0;
	curdamagetillnextfx = damagetillnextfx;
	self thread elevator_attack_chopper_kill_cool_damage_effects();
	while (true)
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
		curdamagetillnextfx -= amount;
		if (curdamagetillnextfx <= 0 && numFXplaying < 2)
		{
			self thread attach_fx_on_target( smokefx,tags, point, direction_vec);
			curdamagetillnextfx = damagetillnextfx;
			//damagetillnextfx += 2000;
			numFXplaying ++;
		}
	}
}


elevator_attack_chopper_do_crash()
{
	crashtype = "helicopter";
	model = self.model;
	
	self thread elevator_attack_chopper_crash();

	if ( IsDefined( level.vehicle_hasMainTurret[ model ] ) && level.vehicle_hasMainTurret[ model ] )
		self ClearTurretTarget();

	if ( ( IsDefined( self.crashing ) ) && ( self.crashing == true ) )
		self waittill( "crash_done" );

	self notify( "stop_looping_death_fx" );
	
	vehicle_finish_death( model );
	
	flag_set( "elevator_chopper_crash_done" );
	aud_send_msg("mus_elevator_heli_crash");
	
	//base this off the player's height so it happens in front of him
	section_num = floor(level.player.origin[2] / 288) - 10;
	
	assert( section_num >= 1, "Chopper crashed TOO LOW to support destructible frame" );
	assert( section_num <= 12 , "Chopper crashed TOO HIGH to support destructible frame" );
	
	exploder( 100 + section_num );
	
	//destroy appropraite glass	
	for( i = 0; i < 4; i++ )
	{
		GlassRadiusDamage( (-736, 192 - (i*128), (ceil(floor(level.player.origin[2] / 288)) + 1) * 288 ), 100, 300, 100 );
	}
	
	wait 0.05;
	
	self delete();

}

elevator_attack_chopper_crash()
{	
	aud_send_msg("elevator_heli_crash_start", self);
	
	self.crashing = true;
	
	if( IsDefined( self.spotlight ) )
	{
		self littlebird_spotlight_off();
	}
	
	self thread elevator_attack_chopper_crash_move();
}

elevator_attack_chopper_crash_move()
{
	if ( IsDefined( self.perferred_crash_location ) )
		crashLoc = self.perferred_crash_location;
	else
	{
		// get the nearest unused crash location
		AssertEx( level.helicopter_crash_locations.size > 0, "A helicopter tried to crash but you didn't have any script_origins with targetname helicopter_crash_location in the level" );
		unusedLocations = get_unused_crash_locations();
		AssertEx( unusedLocations.size > 0, "You dont have enough script_origins with targetname helicopter_crash_location in the level" );
		crashLoc = getClosest( self.origin, unusedLocations );
	}
	Assert( IsDefined( crashLoc ) );

	crashLoc.claimed = true;

	self detach_getoutrigs();


	// make the chopper spin around
	self thread helicopter_crash_rotate();
	self notify( "newpath" );
	self notify( "deathspin" );  //need to know when deathspin begins (not just newpath)

	if ( IsDefined( crashLoc.script_parameters ) && crashLoc.script_parameters == "direct" )
	{
		thread elevator_attack_chopper_crash_direct( crashLoc );
	}
	
	self waittill( "near_goal" );
	
	flag_set( "elevator_chopper_near_crash" );
	
	wait 0.8;

	crashLoc.claimed = undefined;
	self notify( "stop_crash_loop_sound" );
	self notify( "crash_done" );
	aud_send_msg("elevator_heli_crashed", self);
}

elevator_attack_chopper_crash_direct( crashLoc )
{
	self endon( "goal" );
	self endon( "death" );
	//self endon( "near_goal" );
	
	Assert( IsDefined( crashLoc.radius ) );
	crash_speed = 45;
	self Vehicle_SetSpeed( crash_speed, 15, 10 );
	//self SetNearGoalNotifyDist( crashLoc.radius );
	self SetNearGoalNotifyDist( 500 );
	
	while( 1 )
	{
		self SetVehGoalPos( crashLoc.origin, 0 );
		wait 0.05;
	}
}

elevator_ambient_chopper_think()
{
	self godon();
}

top_floor_yuri_throw_grenade( top_floor_yuri_grenade_location, noLoop )
{
	anime = "elevator_grenade_throw";
	anime_idle = "elevator_idle_post_jump";
	
	if( !isdefined( noLoop ) )
	{
		top_floor_yuri_grenade_location delaythread( 3, ::anim_loop_solo, self , anime_idle, "top_floor_yuri_grenade_start" );
	}
	
	flag_wait( "elevator_replacement_moving_to_top" );
	
	if( IsDefined( level.elevator_replacement_movetime ) )
	{
			wait level.elevator_replacement_movetime;
	}
	
	top_floor_yuri_grenade_location notify( "top_floor_yuri_grenade_start" );
	
	flag_set( "top_floor_yuri_grenade_start" );
	old = self.grenadeawareness;
	self.grenadeawareness = 0;
	top_floor_yuri_grenade_location thread anim_single_solo_run( self, anime );
	self waittillmatch( "single anim", "grenade_right" );
	grenade_prop = spawn( "script_model", self getTagOrigin( "tag_inhand" ) );
	grenade_prop setmodel( "projectile_m67fraggrenade" );
	grenade_prop linkto( self, "tag_inhand" );
	
	self waittillmatch( "single anim", "grenade_throw" );
	grenade_prop delete();
	wait 0.05;
	tagorigin = self getTagOrigin( "tag_inhand" );
	n1 = get_target_ent( "top_floor_yuri_grenade_dest" );
	g = MagicGrenade( "fraggrenade", tagorigin, n1.origin, 1.05 ); 
	wait( 1 );
	
	flag_set( "top_floor_yuri_grenade_thrown" );
	self.grenadeawareness = old;
	self enable_ai_color();
	
	//fixes a checkpoint issue with multiple loops playing
	wait 4;
	top_floor_yuri_grenade_location notify( "top_floor_yuri_grenade_start" );
}

elevator_entered_cleanup()
{
	flag_wait( "elevator_doors_closed" );
	
	ClearAllCorpses();
}

start_outdoor_lighting_override()
{
	flag_wait( "elevator_doors_closed" );
	struct = getstruct( "amb_exterior", "targetname" );
	EnableOuterspaceModelLighting( struct.origin, (0.18,0.21,0.25) );
}

start_outdoor_lighting_roof_override()
{
	flag_wait( "player_entered_stairwell" );
	struct = getstruct( "amb_exterior_roof", "targetname" );
	EnableOuterspaceModelLighting( struct.origin, (0.05,0.05,0.05) );
}


///////////////////////////////////////////////
//--------------- TOP FLOOR -----------------//
///////////////////////////////////////////////

setup_top_floor_atrium()
{
	goal_vols = [];
	goal_vols[0] = getent( "combat_lounge_goal_initial", "targetname" );
	goal_vols[1] = getent( "combat_lounge_goal_1", "targetname" );
	goal_vols[2] = getent( "combat_lounge_goal_2", "targetname" );
	goal_vols[3] = getent( "combat_lounge_goal_3", "targetname" );
	
	top_floor_atrium_enemies = getentarray( "top_floor_atrium_enemies", "script_noteworthy" );
	
	array_spawn_function( top_floor_atrium_enemies, ::lounge_enemies_ai_think, goal_vols );
	
	level.top_floor_lounge_combat_enemies_killed = 0;
	level.top_floor_lounge_combat_enemies_total = top_floor_atrium_enemies.size;
	
	thread top_floor_initial_enemies();
	thread top_floor_lounge_combat();
	
	thread top_floor_yuri_movement();
	
	thread top_floor_ambient_chopper();
	
	thread top_floor_countdown();
	
	thread top_floor_civilians();
	
	thread top_floor_corpses();
	
	flag_wait( "top_floor_player_in_atrium" );
}

top_floor_yuri_movement()
{
	flag_wait( "player_at_top_floor" );
	
	thread maps\dubai_fx::topfloor_environmentfx_start();
	
	level.yuri enable_cqbwalk();
	
	flag_set( "vo_top_floor_start" );
	
	flag_wait( "top_floor_lounge_clear" );
	
	wait 2;
	
	trigger_activate_targetname( "trig_combat_restaurant_approach" );
	
}

//Kill a few enemies just outside the elevator
top_floor_initial_enemies()
{
	flag_wait( "player_at_top_floor" );
	
	array_spawn_function_targetname( "combat_lounge_initial_enemies", ::lounge_combat_initial_enemies_ai_think );
	array_spawn_targetname( "combat_lounge_initial_enemies" );
}

lounge_combat_initial_enemies_ai_think()
{
	self.grenadeawareness = 0;
}

//enemies start attacking from the lounge
top_floor_lounge_combat()
{
	flag_wait( "top_floor_lounge_combat_1" );
	
	top_floor_close_path_volume = getent( "top_floor_close_path_volume", "targetname" );
	BadPlace_Brush( "top_floor_close_path_volume", -1, top_floor_close_path_volume, "allies", "axis" );
	
	array_spawn_targetname( "combat_lounge_enemies" );
	
	thread top_floor_lounge_combat_next_wave( 2, "top_floor_lounge_combat_2" );
	
	flag_wait( "top_floor_lounge_combat_2" );
	
	array_spawn_targetname( "combat_lounge_enemies_2" );
	
	BadPlace_Delete( "top_floor_close_path_volume" );
	
	thread top_floor_lounge_combat_next_wave( 2, "top_floor_lounge_combat_3" );
	
	flag_wait( "top_floor_lounge_combat_3" );
	array_spawn_targetname( "combat_lounge_enemies_3" );
}

top_floor_lounge_combat_next_wave( maxEnemies, flagName )
{
	level endon( flagName );
	
	while( 1 )
	{
		if( getaicount( "axis" ) <= maxEnemies )
		{
			flag_set( flagName );
			break;
		}
		
		wait 0.25;
	}
}

lounge_enemies_ai_think( goal_vols )
{
	self endon( "death" );
	
	self endon( "combat_restaurant_approach" );
	
	self thread lounge_enemies_ai_seek_runby_player();
	self thread lounge_enemies_monitor_death();
	
	//keep updating the goal position depending on where the combat takes place
	self SetGoalVolumeAuto( goal_vols[0] );

	flag_wait( "top_floor_lounge_combat_1" );
	self SetGoalVolumeAuto( goal_vols[1] );

	flag_wait( "top_floor_lounge_combat_2" );
	self SetGoalVolumeAuto( goal_vols[2] );
	
	flag_wait( "top_floor_lounge_combat_3" );
	self SetGoalVolumeAuto( goal_vols[3] );
	
	//wait RandomFloatRange( 20, 40 );
	
	//self setgoalpos( (434, -473, 7792) );
	//self.goalradius = 300;
	
	wait 1;
	
	while( getaicount( "axis" ) > 3 )
	{
		wait 0.25;
	}
	
	//move yuri up
	if( !flag( "top_floor_lounge_clear" ) )
		trigger_activate_targetname( "top_floor_yuri_final_color_trigger" );
	
	//when only 3 or less alive, charge player
	self setgoalentity( level.player );
	self.goalradius = 500;
}

lounge_enemies_monitor_death()
{
	self waittill( "death" );
	level.top_floor_lounge_combat_enemies_killed++;
	
	if(level.top_floor_lounge_combat_enemies_killed == 2)
	{
		//flag_set( "top_floor_lounge_combat_2" );
	}
	else if(level.top_floor_lounge_combat_enemies_killed == 11)
	{
		//flag_set( "top_floor_lounge_riotshields_1" );
	}
	else if(level.top_floor_lounge_combat_enemies_killed == 17)
	{
		//flag_set( "top_floor_lounge_combat_3" );
	}
	else if(level.top_floor_lounge_combat_enemies_killed == level.top_floor_lounge_combat_enemies_total)
	{
		flag_set( "top_floor_lounge_clear" );
	}
}

lounge_enemies_ai_seek_runby_player()
{
	self endon( "death" );
	
	//player ran past enemies.  run after him
	flag_wait( "combat_restaurant_approach" );
	
	self setgoalentity( level.player );
	self.goalradius = 500;
}

top_floor_ambient_chopper()
{
	flag_wait( "top_floor_player_in_atrium" );
	
	array_spawn_function_targetname( "top_floor_ambient_chopper", ::top_floor_ambient_chopper_ai_think );
	heli = spawn_vehicle_from_targetname_and_drive( "top_floor_ambient_chopper" );
	aud_send_msg("top_floor_ambient_chopper", heli);
}

top_floor_ambient_chopper_ai_think()
{
	self Vehicle_SetSpeedImmediate( 60, 20 );
	
	self godon();
	
	self mgoff();
	
	self thread littlebird_handle_spotlight( 0.5, false, undefined, 500 );
}

top_floor_countdown()
{
	flag_wait( "top_floor_countdown_start" );
	
	level.stopwatch = getdvarfloat( "makarov_escaping_time_left" ) * 60;
	
	thread top_floor_countdown_stopwatch();
	thread top_floor_countdown_events();
	thread top_floor_countdown_cleanup();
	
	thread top_floor_autosaves();
	
}

top_floor_countdown_stopwatch()
{
	level.hudelem = maps\_hud_util::get_countdown_hud();
	
	level.hudelem SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	countdown = 20 * 60;
	if ( isdefined( level.stopwatch ) )
		countdown = level.stopwatch;

	// Makarov Escaping : 
	level.hudelem.label = &"DUBAI_MAKAROV_ESCAPING";// + minutes + ":" + seconds
	level.hudelem settenthstimer( countdown );

	wait( level.stopwatch );

	if ( isdefined( level.hudelem ) )
		level.hudelem destroy();
}

top_floor_countdown_events()
{
	level endon( "chopper_restaurant_strafe_run" );

	wait level.stopwatch;

	if ( !flag( "chopper_restaurant_strafe_run" ) )
	{
		// Makarov got away!
		finale_makarov_escaped();
	}
}

top_floor_countdown_cleanup()
{
	flag_wait( "chopper_restaurant_strafe_run" );
	
	if ( isdefined( level.hudelem ) )
		level.hudelem destroy();
}

top_floor_autosaves()
{
	level endon( "chopper_restaurant_strafe_run" );

	totalTime = level.stopwatch * 1000;
	startTime = gettime();

	autosave_or_timeout( "timer_started", 10 );

	flag_wait( "top_floor_lounge_combat_1" );
	
	//wait a few seconds so checkpoint isn't before VO every time
	wait 3.5;
	timeSpent = ( gettime() - startTime ) / 1000;
	maxTimeAllowed = (level.stopwatch - 180);
	thread top_floor_autosaves_safety( timeSpent, maxTimeAllowed );

	/*flag_wait( "top_floor_lounge_combat_2" );
	timeSpent = ( gettime() - startTime ) / 1000;
	maxTimeAllowed = (level.stopwatch - 120);
	thread top_floor_autosaves_safety( timeSpent, maxTimeAllowed );
*/
	flag_wait( "top_floor_lounge_combat_3" );
	
	//wait 4;
	timeSpent = ( gettime() - startTime ) / 1000;
	maxTimeAllowed = (level.stopwatch - 90);
	thread top_floor_autosaves_safety( timeSpent, maxTimeAllowed );

	flag_wait( "top_floor_lounge_clear" );
	timeSpent = ( gettime() - startTime ) / 1000;
	maxTimeAllowed = (level.stopwatch - 30);
	thread top_floor_autosaves_safety( timeSpent, maxTimeAllowed );
}

top_floor_autosaves_safety( timeSpent, maxTimeAllowed, noExceptions )
{
	if ( !isdefined( noExceptions ) )
		noExceptions = false;

	if ( timeSpent + 2.5 < maxTimeAllowed )
	{
		autosave_or_timeout( "lounge_clear", maxTimeAllowed - timeSpent );

		if ( noExceptions )
			wait 3;
		else
			wait 10;

		flag_clear( "can_save" );
		wait 2;
		flag_set( "can_save" );
	}
}

top_floor_civilians()
{
	array_spawn_function_noteworthy( "atrium_runner", ::civilian_drone_run_and_hide_think, "restaurant_destruction" );
	
	array_spawn_function_noteworthy( "lower_floor_runner", ::civilian_drone_runners_think );
	
	flag_wait( "player_at_top_floor" );
	
	//thread top_floor_civilians_ambient_runners();
	
	flag_wait( "top_floor_civilians_game_room_runners" );
	array_spawn_noteworthy( "atrium_runner" );
	
	//these civilians should not fail you if they die
	level.friendlyFireDisabled = true;
	wait 5;
	level.friendlyFireDisabled = false;
}

top_floor_civilians_ambient_runners()
{
	civs_left = getentarray( "lower_floor_runner_left", "targetname" );
	civs_right = getentarray( "lower_floor_runner_right", "targetname" );
	
	player_on_left_vol = getent( "player_on_atrium_left_side", "targetname" );
	player_on_right_vol = getent( "player_on_atrium_right_side", "targetname" );
	
	for( j = 0; j < 10; j++ )
	{
		
		//spawn 1 at a time
		for( i = 0; i < 1; i++)
		{			
			civs = [];
			
			//make sure player can't see right side spawners
			if( !( level.player istouching( player_on_left_vol ) ) )
			{
				civs = array_combine( civs, civs_right );
			}
			
			//make sure player can't see left side spawners
			if( !( level.player istouching( player_on_right_vol ) ) )
			{
				civs = array_combine( civs, civs_left );
			}

			civs = array_randomize( civs );
			
			if( isdefined( civs[0] ) )
				civs[0] spawn_ai();
			
			wait RandomFloatRange( 0.2, .5 );
		}
		wait RandomFloatRange( 5, 10 );
	}
}

///////////////////////////////////////////////
//--------------- RESTAURANT ----------------//
///////////////////////////////////////////////

setup_restaurant()
{
	thread restaurant_makarov();
	thread restaurant_destruction();
	thread restaurant_combat_approach();
	thread restaurant_combat();
	thread restaurant_yuri_movement();
	thread restaurant_chopper();
	thread monitor_model_spot_lighting();
	
	thread restaurant_player_falling_to_death();
	thread restaurant_fix_pathing();
}

restaurant_yuri_movement()
{
	restaurant_yuri_badplace_vol = getent( "restaurant_yuri_badplace_vol", "targetname" );
	BadPlace_Brush( "restaurant_yuri_badplace_vol", -1, restaurant_yuri_badplace_vol, "allies" );
	
	flag_wait( "restaurant_destruction" );
	level.yuri forceteleport( (-1046, -266, 7768), (0, 0, 0) );
	level.yuri.ignoreall = true;
	level.yuri.ignoreme = true;
	
	flag_wait( "restaurant_destruction_player_over_ledge" );
	
	flag_set( "top_floor_corpses" );
	
	level.yuri delaythread( 3, ::gun_remove );
	
	anime = "restaurant_wounded";
	animeLoop = "restaurant_idle";
	
	restaurant_destruction_player_start_node = getent( "restaurant_destruction_player_start_node", "targetname" );
	
	thread maps\dubai_fx::yuri_blood_vfx();
	
	light_rig = spawn( "script_model", (0, 0, 0) );
	light_rig setmodel( "fx_char_light_rig" );
	light_rig.animname = "fx_char_light_rig";
	light_rig UseAnimTree( level.scr_animtree[ "fx_char_light_rig" ] );
	
	actors = [];
	actors[actors.size] = level.yuri;
	actors[actors.size] = light_rig;
	
	restaurant_destruction_player_start_node thread anim_single( actors, anime );
	light_rig thread maps\dubai_fx::restaurant_yuri_light(); 
	
	
	level.yuri waittillmatch( "single anim", "yuri_performance" );
	flag_set( "vo_restaurant_destruction_yuri" );
	
	level.yuri setanim( %dubai_restaurant_yuri_start_facial_b );
	
	level.yuri waittillmatch( "single anim", "dialog" );
	level.yuri clearanim( %dubai_restaurant_yuri_start_facial_b, 0.2 );
	
	restaurant_destruction_player_start_node waittill( anime );
	
	restaurant_destruction_player_start_node thread anim_loop( actors, animeLoop );
}

restaurant_makarov()
{
	flag_wait( "restaurant_makarov" );
	
	flag_wait( "restaurant_makarov_spotted" );
	
	restaurant_makarov = getent( "restaurant_makarov", "targetname" );
	restaurant_makarov add_spawn_function( ::restaurant_makarov_ai_think );
	//restaurant_makarov add_spawn_function( ::makarov_drone_runner_think );
	level.makarov = restaurant_makarov spawn_ai( true );
}

#using_animtree( "generic_human" );
restaurant_makarov_ai_think()
{
	//setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	
	self notsolid();
	
	/*self magic_bullet_shield( true );
	self.ignoreall = true;
	self.ignoreme = true;
	self.a.disablePain = true;
	self.nododgemove = true;
	self.badplaceawareness = 0;
	self.dontmelee = true;
	self.disableExits = true;
	self.disableArrivals = true;
	self.disableBulletWhizbyReaction = true;
	self.neverSprintForVariation = true;
	self.nogrenadereturnthrow = true;
	self disable_turnAnims();
	self disable_surprise();
	self.grenadeawareness = 0;
	
	self setgoalpos( self.origin );
	self.goalradius = 8;
	*/
	//self thread restaurant_makarov_spotted_check();
	
	self gun_remove();
	
	//self thread anim_generic_loop( self, "civilain_crouch_hide_idle_loop", "move" );
	self.runAnim = getgenericanim( "civilian_run_upright_relative" );
	
	flag_wait( "restaurant_makarov_spotted" );
	
	//self.target = self.cur_node["target"];
	//self thread maps\_drone::drone_move();
	//self thread makarov_drone_runner_think();
	
	flag_set( "update_obj_pos_restaurant_makarov_spotted" );
	flag_set( "vo_restaurant_start" );
	
	/*newgoal = getent( "restaurant_makarov_goal", "targetname" );
	
	self setgoalpos( newgoal.origin );
	self.goalradius = newgoal.radius;
	
	self waittill( "goal" );
	flag_set( "update_obj_pos_restaurant_makarov_escaped" );*/
	
	//self delete();
	//setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
	self waittill( "goal" );
	flag_set( "update_obj_pos_restaurant_makarov_escaped" );
	self delete();
	
}


makarov_drone_runner_think()
{
	//random running death animation
	//self.deathanim = array_randomize(	level.drone_deaths_r )[0];
		
	
	
	flag_wait( "restaurant_makarov_spotted" );
		
	
	
	
	
	//self.idleAnim = %civilain_crouch_hide_idle_loop;
		

}

restaurant_makarov_spotted_check()
{
	level endon( "restaurant_makarov_spotted" );
	
	while( !self cansee( level.yuri ) )
	{
		wait 0.5;
	}
	
	flag_set( "restaurant_makarov_spotted" );
}

restaurant_fix_pathing()
{
	des_ceilingcrossbar_01 = getentarray( "des_ceilingcrossbar_01", "script_noteworthy" );
	des_ceilingcrossbar_02 = getentarray( "des_ceilingcrossbar_02", "script_noteworthy" );
	des_ceilingcrossbar_03 = getentarray( "des_ceilingcrossbar_03", "script_noteworthy" );
	des_ceilingbeam_support_01 = getentarray( "des_ceilingbeam_support_01", "script_noteworthy" );
	des_ceilingbeam_fall_01 = getentarray( "des_ceilingbeam_fall_01", "script_noteworthy" );
	des_floor_2 = getentarray( "des_floor_2", "script_noteworthy" );
	
	des_ceilingcrossbar_01 = des_ceilingcrossbar_01 restaurant_fix_pathing_remove_models();
	des_ceilingcrossbar_02 = des_ceilingcrossbar_02 restaurant_fix_pathing_remove_models();
	des_ceilingcrossbar_03 = des_ceilingcrossbar_03 restaurant_fix_pathing_remove_models();
	des_ceilingbeam_support_01 = des_ceilingbeam_support_01 restaurant_fix_pathing_remove_models();
	des_ceilingbeam_fall_01 = des_ceilingbeam_fall_01 restaurant_fix_pathing_remove_models();
	des_floor_2 = des_floor_2 restaurant_fix_pathing_remove_models();
	
	array_call( des_ceilingcrossbar_01, ::ConnectPaths );
	array_call( des_ceilingcrossbar_02, ::ConnectPaths );
	array_call( des_ceilingcrossbar_03, ::ConnectPaths );
	array_call( des_ceilingbeam_support_01, ::ConnectPaths );
	array_call( des_ceilingbeam_fall_01, ::ConnectPaths );
	array_call( des_floor_2, ::ConnectPaths );
}

restaurant_fix_pathing_remove_models()
{
	ent_array = self;
	
	foreach( ent in ent_array)
	{
		if( ent.classname == "script_model" )
			ent_array = array_remove( ent_array, ent );
	}
	
	return ent_array;
}

restaurant_combat_approach()
{
	flag_wait( "combat_restaurant_approach" );
	
	restaurant_appraoch_enemies = getentarray( "combat_restaurant_approach_enemy", "targetname" );
	
	level.restaurant_enemies_current = restaurant_appraoch_enemies.size;
	
	array_thread( restaurant_appraoch_enemies, ::add_spawn_function, ::restaurant_enemies_ai_think);
	array_spawn( restaurant_appraoch_enemies, undefined, true );
}

restaurant_combat()
{
	flag_wait( "combat_restaurant" );
	
	restaurant_enemies = getentarray( "combat_restaurant_enemy", "targetname" );
	level.restaurant_enemies_current += restaurant_enemies.size;
	array_thread( restaurant_enemies, ::add_spawn_function, ::restaurant_enemies_ai_think);
	array_spawn( restaurant_enemies, undefined, true );
	
	//thread restaurant_combat_reinforcements();
}

restaurant_combat_reinforcements()
{
	restaurant_enemies_desired = 5;
	retaurant_reinforcement_spawners = getentarray( "combat_restaurant_enemy_reinforcement", "targetname" );
	
	array_thread( retaurant_reinforcement_spawners, ::add_spawn_function, ::restaurant_enemies_ai_think );
	//retaurant_reinforcement_spawner_1 add_spawn_function( ::restaurant_enemies_ai_think );
	
	reinforcement_current = 0;
	reinforcement_max = 10;
	
	while( !flag( "chopper_restaurant_strafe_run" ) )
	{
		if( level.restaurant_enemies_current < restaurant_enemies_desired )
		{
			retaurant_reinforcement_spawners = array_randomize( retaurant_reinforcement_spawners );
			retaurant_reinforcement_spawners[0].count++;
			retaurant_reinforcement_spawners[0] spawn_ai();
			
			level.restaurant_enemies_current++;
			
			reinforcement_current++;
		}
		
		if( reinforcement_current >= reinforcement_max )
		{
			break;
		}
		
		wait RandomFloatRange( 0.1, 1 );
	}
}

restaurant_enemies_ai_think()
{
	self.noragdoll = true;	// since we're on a script_brushmodel, use animation only
	self thread restaurant_enemies_monitor_death();
	
	self endon( "death" );
	
	flag_wait( "combat_restaurant" );
	
	self disable_long_death();
	
	//fighters stick around
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "restaurant_fighter" )
	{
		restaurant_enemy_volume = getent( "restaurant_enemy_volume", "targetname" );
		self SetGoalVolumeAuto( restaurant_enemy_volume );
		
		self restaurant_enemies_ai_flee();
	}
	else
	{
		//non-fighters run
		self.pathrandompercent = 200;
		//goalnode = getent( "restaurant_makarov_goal", "targetname" );
		
		if( cointoss() )
		{
			goalnode = getent( "restaurant_makarov_goal", "targetname" );
			self setgoalpos( goalnode.origin );
			self.goalradius = goalnode.radius;
		}
		else
		{
			self setgoalpos( (-528, 984, 7768) );
			self.goalradius = 100;
		}
		
//		self setgoalpos( (-532, 986, 7782) );
		//self.goalradius = 100;
		//self.ignoreall = true;
		
		self waittill( "goal" );
		self delete();
	}
	
	flag_wait( "restaurant_drop_section_falling" );
	
	if( self istouching( getent( "restaurant_drop_volume", "targetname" ) ) )
	{
		self kill();
	}
	
	flag_wait( "restaurant_tilt" );
	
	self kill();
}

restaurant_enemies_ai_flee()
{
	wait RandomFloatRange( 2, 8 );
	
	//non-fighters run
	self.pathrandompercent = 200;
	
	if( cointoss() )
	{
		goalnode = getent( "restaurant_makarov_goal", "targetname" );
		self setgoalpos( goalnode.origin );
		self.goalradius = goalnode.radius;
	}
	else
	{
		self setgoalpos( (-528, 984, 7768) );
		self.goalradius = 100;
	}
	//self.ignoreall = true;
	
	self waittill( "goal" );
	self delete();
}

restaurant_enemies_monitor_death()
{
	self waittill( "death" );
	
	level.restaurant_enemies_current--;
}

restaurant_destruction()
{
	thread restaurant_destruction_scripted_structure_animation();
	
	/****************************
	 * Set when strafe run sequence begins
	 ****************************/
	flag_wait( "chopper_restaurant_strafe_run" );
	
	//So rocket doesn't kill player
	level.player enableinvulnerability();
	
	/****************************
	 * Set when rocket hits wall
	 ****************************/
	flag_wait( "restaurant_destruction" );
	thread restaurant_destruction_timer();
	thread restaurant_tilt_clearcorpses();
	
	//hide hud
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	
	//damage from rocket
	
	old_health_regen_delay = level.player.gs.playerHealth_RegularRegenDelay;
	level.player.gs.playerHealth_RegularRegenDelay = 500;
	old_health_long_regen_delay = level.player.gs.longregentime;
	level.player.gs.longregentime = 500;
	
	level.player thread play_fullscreen_blood_splatter_alt(4, 0, 2, 1);
	
	exploder(150);
	PlayFX( level._effect[ "dubai_rest_anim_round_table" ], ( -1029.1, 6.7, 7753), (1, 0, 0), (0, 0, 1) );
	aud_send_msg("restaurant_destruction");
	
	enemies = getaiarray( "axis" );
	//thread array_call( enemies, ::kill );
	
	starttime = gettime();
	
	flag_set( "update_obj_pos_restaurant_destruction" );
	
	thread battlechatter_off( "allies" );
	thread battlechatter_off( "axis" );
	
	thread restaurant_destroy_glass();
	
	//TODO remove player grenades so this doesn't cause issues
	thread clear_grenades_until_flag( "restaurant_sequence_complete" );
	
	//wait 0.5;
	//level.player shellshock( "default", 3, true);
	//earthquake( .5, 2.5, level.player.origin, 200 );
	//level.player shellshock( "default", 2, true);
	
	thread restaurant_animation();
	
	delaythread( 13, ::exploder, 700 );
	
	time = [];
	time[time.size] = 2.65;	//support
	time[time.size] = 5.55;	//pillar
	time[time.size] = 3.55;	//back wall
	time[time.size] = 3.55;	//ambient
	
	level notify( "view_tilt" );
		
	/****************************
	 * Back section falls
	 ****************************/
	wait 2.65;
	
	exploder(250);
	thread restaurant_destruction_drop_section();
	exploder(300);
	exploder(500);
	
	//restaurant tilts
	wait 4.38;
	exploder(600);
	
	flag_set( "restaurant_tilt" );

	flag_wait( "restaurant_sequence_complete" );
	flag_set( "restaurant_destroyed" );
	SetSavedDvar( "compass", "1" );
	SetSavedDvar( "hud_showStance", "1" );
	level.player disableinvulnerability();
	
	level.player.gs.playerHealth_RegularRegenDelay = old_health_regen_delay;
	level.player.gs.longregentime = old_health_long_regen_delay;
}

restaurant_destruction_timer()
{
	/#
		starttime = gettime();
		delay = 0.05;
		while( !flag( "restaurant_sequence_complete" ) )
		{
			println( "time: " + (gettime() - starttime) );
			wait delay;
		}
	#/
}

restaurant_animation_player_failure()
{
	level endon( "restaurant_success" );
	
	wait 10.9;
	
	thread use_hint_blinks();
	
	for( i=0; i<2; i+=0.05 )
	{
		if( level.player UseButtonPressed() )
		{
			thread fade_out_use_hint( 0.1 );
			level notify( "restaurant_success" );
		}
		wait 0.05;
	}
	
	self hide();
	
	thread fade_out_use_hint( 0.1 );
	
	//wait 0.2;
	level.player unlink();
	flag_set( "restaurant_destroyed" );
	flag_set( "restaurant_player_falling_to_death" );
	
	//thread restaurant_player_falling_to_death();
}

restaurant_animation()
{
	level.player HideViewModel();
	
	thread restaurant_destruction_rumble();
	
	aud_send_msg("restaurant_destruction_begin");
	restaurant_destruction_player_start_node = getent( "restaurant_destruction_player_start_node", "targetname" );
	
	thread restaurant_animation_rolling_soldier();
	thread restaurant_animation_floor( restaurant_destruction_player_start_node );
	
	restaurant_destruction_player_start_node thread restaurant_animation_column( "restaurant_column_shatter_1", 2.65, 190 );
	restaurant_destruction_player_start_node thread restaurant_animation_column( "restaurant_column_shatter_2", 6.33, 191 );
	delaythread(6.333, ::aud_send_msg, "mus_restaurant_pillar_explodes");

	restaurant_destruction_player_start_node thread restaurant_animation_table( "round", 6.33, 150 );
	restaurant_destruction_player_start_node thread restaurant_animation_table( "square", 6.33, 150 );

	player_rig = spawn_anim_model( "player_rig", restaurant_destruction_player_start_node.origin );
	player_rig.angles = restaurant_destruction_player_start_node.angles;
	player_rig hide();
	
	player_rig thread restaurant_animation_player_failure();
	
	//thread autosave_now(1);
	
	
	delaythread( 6.5, ::autosave_now, 1 );
	
	player_legs = spawn_anim_model( "player_body", restaurant_destruction_player_start_node.origin );
	player_legs hide();
	restaurant_floor = spawn_anim_model( "restaurant_floor", restaurant_destruction_player_start_node.origin );
	restaurant_floor hide();
	
	des_floor = getentarray( "des_floor", "script_noteworthy" );
	
	des_floor_pivot = spawn( "script_origin", (0, 0, 0) );
	
	//level.player Shellshock( "slowview", 29 );
	
	actors = [];
	actors[actors.size] = player_rig;
	actors[actors.size] = player_legs;
	
	anime = "restaurant_destruction";
	restaurant_destruction_player_start_node anim_first_frame( actors, anime );

	level.player AllowCrouch( false );
	level.player AllowProne( false );
	blend_time = 0.15;
	level.player PlayerLinkToBlend( player_rig, "tag_player", blend_time);

	level.player disableweapons();

	level.player delaycall( blend_time + 0.05, ::playerlinktodelta, player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	level.player delaycall( blend_time + 0.1, ::LerpViewAngleClamp, 0.5, 0.25, 0.25, 5, 25, 25, 0 );
	player_rig delaycall( 0.6, ::show );
	player_legs delaycall( 0.6, ::show );
	
	// remove pitch limits otherwise the camera angles are off when we look over the edge
	save_player_view_pitch_up = getdvar( "player_view_pitch_up" );
	save_player_view_pitch_down = getdvar( "player_view_pitch_down" );
	setdvar( "player_view_pitch_up", 180 );
	setdvar( "player_view_pitch_down", 90 );
	
	restaurant_destruction_player_start_node thread anim_single( actors, anime );
	
	restaurant_destruction_player_start_node waittill( anime );
	player_rig waittillmatch( "single anim", "end" );

	setdvar( "player_view_pitch_up", save_player_view_pitch_up );
	setdvar( "player_view_pitch_down", save_player_view_pitch_down );
	
	level.player unlink();
	
	thread finale_player_hands();
	
	level.doPickyAutosaveChecks = false;
		level.player SetMoveSpeedScale( 1 );
	level.player setstance( "stand" );
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	
	player_rig delete();
	player_legs delete();
	restaurant_floor delete();
	
	flag_set( "restaurant_rubble_fall_on_yuri" );
	flag_set( "restaurant_sequence_complete" );
	flag_set( "update_obj_pos_restaurant_exit" );
	
	autosave_by_name( "restaurant_sequence_complete" );
	
	thread restaurant_chase_timer();
	level.player ShowViewModel();
	
	aud_send_msg("restaurant_destruction_end");
}

restaurant_destruction_rumble()
{
	level endon( "restaurant_player_falling_to_death" );
	
	ent = get_rumble_ent( "steady_rumble" );
	ent.intensity = 0.03;
	
	ent delaythread( 2.65, ::rumble_ramp_to, 0.5, 0.05 );
	ent delaythread( 3, ::rumble_ramp_to, 0.03, 0.5 );
	
	ent delaythread( 7.1, ::rumble_ramp_to, 0, 0.05 );
	ent delaythread( 7.6, ::rumble_ramp_to, 1, 0.05 );
	
	ent delaythread( 8, ::rumble_ramp_to, 0, 0.05 );
	ent delaythread( 8.3, ::rumble_ramp_to, 1, 0.05 );
	
	ent delaythread( 8.4, ::rumble_ramp_to, 0.1, 0.5 );
	
	ent delaycall( 13, ::StopRumble, "steady_rumble" );
	
	level.player delaycall( 15.55, ::playrumbleonentity, "damage_light" );
	level.player delaycall( 17.6, ::playrumbleonentity, "damage_light" );
	level.player delaycall( 18, ::playrumbleonentity, "damage_light" );
	
	noself_delaycall( 20, ::stopallrumbles );
}

restaurant_animation_floor( restaurant_destruction_player_start_node )
{
	restaurant_floor = spawn_anim_model( "restaurant_floor", restaurant_destruction_player_start_node.origin );
	restaurant_floor hide();
	
	des_floor = getentarray( "des_floor", "script_noteworthy" ); // final = (0 5 -10.5)
	
	des_floor_pivot = spawn( "script_origin", (0, 0, 0) );
	
	actors = [];
	actors[actors.size] = restaurant_floor;
	
	anime = "restaurant_destruction_floor";
	restaurant_destruction_player_start_node anim_first_frame( actors, anime );
	
	des_floor_pivot.origin = (-462, -0.5, 7813.5);
	
	pivot_org = des_floor_pivot.origin;
	pivot_ang = des_floor_pivot.angles;
	
	
	array_call( des_floor, ::linkto, des_floor_pivot );
	des_floor_pivot.angles = des_floor_pivot.angles + (20 , 0, 0);
	des_floor_pivot.origin = (-464, -0.5, 7715.5);
	
	des_floor_pivot linkto( restaurant_floor );
	
	level.fx_dummy_1 = spawn_tag_origin();
	level.fx_dummy_1 linkto (restaurant_floor);
	
	level.fx_dummy_4 = spawn_tag_origin();
	level.fx_dummy_4 linkto (restaurant_floor);
	
	restaurant_destruction_player_start_node thread anim_single( actors, anime );
		
	flag_wait( "restaurant_destruction_floor_done" );
	
	restaurant_floor delete();
	
	movetime = 0.25;
	
 	des_floor_pivot moveto( pivot_org, movetime );
	des_floor_pivot rotateto( pivot_ang, movetime );
	
	wait 1;
	
	level.fx_dummy_1 delete();
	level.fx_dummy_4 delete();
}

restaurant_animation_rolling_soldier()
{
	flag_wait( "restaurant_destruction_rolling_soldier" );
	
	node = getent( "restaurant_destruction_player_start_node", "targetname" );
	
	anime = "restaurant_rolling_soldier";
	actor = getent( "restaurant_rolling_soldier", "targetname" ) spawn_ai( true );
	
	node anim_generic( actor, anime );
	
	actor kill();
}

restaurant_animation_column( anime, delay, exploder_num )
{
	column = spawn( "script_model", (0, 0, 0) );
	column setmodel( "dub_restaurant_column_shatter_02" );
	column.animname = "restaurant_column";
	column UseAnimTree( level.scr_animtree[ "restaurant_column" ] );
	column hide();

	self anim_first_frame_solo( column, anime );
	
	wait delay;
	exploder( exploder_num );
	column show();
	self anim_single_solo (column, anime);
	
	column delete();
}

restaurant_animation_table( table_type, delay, exploder_num )
{
	anime = "dubai_restaurant_" + table_type + "_table_sim";
	model = "dub_restaurant_" + table_type + "table_set_sim";
	
	table = spawn( "script_model", (0, 0, 0) );
	table setmodel( model );
	table.animname = model;
	table UseAnimTree( level.scr_animtree[ model ] );

	self anim_first_frame_solo( table, anime );
	
	wait delay;
	exploder( exploder_num );
	table show();
	self anim_single_solo (table, anime);
	
	table delete();
}

restaurant_destruction_scripted_structure_animation()
{
	/*
	 * set destroyed parts to their original positions
	 */
	INTACT = 0;
	DESTROYED = 1;
	INITIAL_POS = 2;
	FINAL_POS = 3;
	INITIAL_ANGLES = 4;
	FINAL_ANGLES = 5;
	EXPLODER_NUM = 6;
	
	//300 
	ceilingbeam_fall_01 = [];
	ceilingbeam_fall_01[INTACT] = getentarray( "intact_ceilingbeam_fall_01", "script_noteworthy" );
	ceilingbeam_fall_01[DESTROYED] = getentarray( "des_ceilingbeam_fall_01", "script_noteworthy" );
	ceilingbeam_fall_01[INITIAL_POS] = ceilingbeam_fall_01[INTACT] get_group_origin();
	ceilingbeam_fall_01[FINAL_POS] = ceilingbeam_fall_01[DESTROYED] get_group_origin();
	ceilingbeam_fall_01[INITIAL_ANGLES] = (0, -5, 10.5);
	ceilingbeam_fall_01[FINAL_ANGLES] = (0, 0, 0);
	ceilingbeam_fall_01[EXPLODER_NUM] = 300;
	
	ceilingbeam_support_01 = [];
	ceilingbeam_support_01[INTACT] = getentarray( "intact_ceilingbeam_support_01", "script_noteworthy" );
	ceilingbeam_support_01[DESTROYED] = getentarray( "des_ceilingbeam_support_01", "script_noteworthy" );
	ceilingbeam_support_01[INITIAL_POS] = ceilingbeam_support_01[INTACT] get_group_origin();
	ceilingbeam_support_01[FINAL_POS] = ceilingbeam_support_01[DESTROYED] get_group_origin();
	ceilingbeam_support_01[INITIAL_ANGLES] = (0, -5, 10.5);
	ceilingbeam_support_01[FINAL_ANGLES] = (0, 0, 0);
	ceilingbeam_support_01[EXPLODER_NUM] = 300;
	
	ceilingcrossbar_01 = [];
	ceilingcrossbar_01[INTACT] = getentarray( "intact_ceilingcrossbar_01", "script_noteworthy" );
	ceilingcrossbar_01[DESTROYED] = getentarray( "des_ceilingcrossbar_01", "script_noteworthy" );
	ceilingcrossbar_01[INITIAL_POS] = ceilingcrossbar_01[INTACT] get_group_origin();
	ceilingcrossbar_01[FINAL_POS] = ceilingcrossbar_01[DESTROYED] get_group_origin();
	ceilingcrossbar_01[INITIAL_ANGLES] = (55.6, 0, 0);
	ceilingcrossbar_01[FINAL_ANGLES] = (0, 0, 0);
	ceilingcrossbar_01[EXPLODER_NUM] = 300;
	
	ceilingcrossbar_02 = [];
	ceilingcrossbar_02[INTACT] = getentarray( "intact_ceilingcrossbar_02", "script_noteworthy" );
	ceilingcrossbar_02[DESTROYED] = getentarray( "des_ceilingcrossbar_02", "script_noteworthy" );
	ceilingcrossbar_02[INITIAL_POS] = ceilingcrossbar_02[INTACT] get_group_origin();
	ceilingcrossbar_02[FINAL_POS] = ceilingcrossbar_02[DESTROYED] get_group_origin();
	ceilingcrossbar_02[INITIAL_ANGLES] = (10, 0, 0);
	ceilingcrossbar_02[FINAL_ANGLES] = (0, 0, 0);
	ceilingcrossbar_02[EXPLODER_NUM] = 300;
	
	//500
	res_floor = [];
	res_floor[INTACT] = undefined;
	res_floor[DESTROYED] = getentarray( "des_floor", "script_noteworthy" );
	res_floor[INITIAL_POS] = res_floor[DESTROYED] get_group_origin();
	res_floor[FINAL_POS] = res_floor[DESTROYED] get_group_origin();
	res_floor[INITIAL_ANGLES] = (20, 0, 0);
	res_floor[FINAL_ANGLES] = (0, 0, 0);
	res_floor[EXPLODER_NUM] = 500;
	
	ceilingbeam_fall_02 = [];
	ceilingbeam_fall_02[INTACT] = getentarray( "intact_ceilingbeam_fall_02", "script_noteworthy" );
	ceilingbeam_fall_02[DESTROYED] = getentarray( "des_ceilingbeam_fall_02", "script_noteworthy" );
	ceilingbeam_fall_02[INITIAL_POS] = ceilingbeam_fall_02[INTACT] get_group_origin();
	ceilingbeam_fall_02[FINAL_POS] = ceilingbeam_fall_02[DESTROYED] get_group_origin();
	ceilingbeam_fall_02[INITIAL_ANGLES] = (0, 0, 0);
	ceilingbeam_fall_02[FINAL_ANGLES] = (0, 0, 0);
	ceilingbeam_fall_02[EXPLODER_NUM] = 500;
	
	ceilingcrossbar_03 = [];
	ceilingcrossbar_03[INTACT] = getentarray( "intact_ceilingcrossbar_03", "script_noteworthy" );
	ceilingcrossbar_03[DESTROYED] = getentarray( "des_ceilingcrossbar_03", "script_noteworthy" );
	ceilingcrossbar_03[INITIAL_POS] = ceilingcrossbar_03[INTACT] get_group_origin();
	ceilingcrossbar_03[FINAL_POS] = ceilingcrossbar_03[DESTROYED] get_group_origin();
	ceilingcrossbar_03[INITIAL_ANGLES] = (-4, 0, 0);
	ceilingcrossbar_03[FINAL_ANGLES] = (0, 0, 0);
	ceilingcrossbar_03[EXPLODER_NUM] = 500;
	
	//animate_group( moveDelay, moveTime, moveAcc, moveDec, rotDelay, rotTime, rotAcc, rotDec )
	moveDelay = 4;
	moveTime = 1.5;
	moveAcc = moveTime;
	moveDec = 0;
	rotDelay = moveDelay;
	rotTime = moveTime;
	rotAcc = moveAcc;
	rotDec = moveDec;
	ceilingbeam_fall_01 thread animate_group( moveDelay, moveTime, moveAcc, moveDec, rotDelay, rotTime, rotAcc, rotDec );
	ceilingbeam_support_01 thread animate_group( moveDelay, moveTime, moveAcc, moveDec, rotDelay, rotTime, rotAcc, rotDec );
	
	moveDelay = 4.5;
	moveTime = 1.5;
	moveAcc = moveTime;
	moveDec = 0;
	rotDelay = moveDelay;
	rotTime = moveTime;
	rotAcc = moveAcc;
	rotDec = moveDec;
	ceilingcrossbar_01 thread animate_group( moveDelay, moveTime, moveAcc, moveDec, rotDelay, rotTime, rotAcc, rotDec );
	ceilingcrossbar_02 thread animate_group( moveDelay, moveTime, moveAcc, moveDec, rotDelay, rotTime, rotAcc, rotDec );
	
	ceilingbeam_fall_02 thread animate_group( 7, .5, .5, 0, 10, .5, .5, 0 );
	ceilingcrossbar_03 thread animate_group( 7, .5, .5, 0, 10, .5, .5, 0 );
}

animate_group( moveDelay, moveTime, moveAcc, moveDec, rotDelay, rotTime, rotAcc, rotDec )
{
	pivot = spawn( "script_origin", (0, 0, 0) );
	if( !isdefined(self[3]) )
	{
		println( "no final pivot defined" );
		return;
	}
	pivot.origin = self[3];
	
	if( !isdefined(self[5]) )
	{
		println( "no final angles defined" );
		return;
	}
	pivot.angles = self[5];
	
	array_call( self[1], ::linkto, pivot );
	
	/*
	 * Set pivot to starting position and angles
	 */
	if( !isdefined( self[2] ) )
	{
		println( "no starting pivot defined" );
		return;
	}
	pivot.origin = self[2];
	
	if( !isdefined( self[4] ) )
	{
		println( "no starting angles defined" );
	}
	pivot.angles = self[4];
	
	if( !isdefined(self[1][0].script_prefab_exploder) )
	{
		println( "no exploder defined" );
		return;
	}
	exploder_num = self[1][0].script_prefab_exploder;
	level waittill( "exploding_" + exploder_num );
	
	if( moveDelay > 0 )
	{
		pivot delayCall( moveDelay, ::moveto, self[3], moveTime, moveAcc, moveDec );
	}
	else
	{
		pivot moveto( self[3], moveTime, moveAcc, moveDec );
	}
	
	if( rotDelay > 0 )
	{
		pivot delayCall( rotDelay, ::rotateto, self[5], rotTime, rotAcc, rotDec );
	}
	else
	{
		pivot rotateto( self[5], rotTime, rotAcc, rotDec );
	}
}

restaurant_tilt_clearcorpses()
{
	for( i = 0; i < 100; i++ )
	{
		//remove remaining living enemies
		array_call( getaiarray( "axis" ), ::delete );
		ClearAllCorpses();
		array_call( getallweapons(), ::delete );
		wait 0.05;
	}
}

restaurant_destruction_drop_section()
{
	flag_set( "restaurant_drop_section_falling" );
	thread maps\dubai_fx::restaurant_rubblefx_start();
	
	//reflect that the back of the restaurant dropped off in the minimap
	thread minimap_update( 3 );
	
	restaurant_drop_volume = getent( "restaurant_drop_volume", "targetname" );
	BadPlace_Brush( "restaurant_drop_volume", -1, restaurant_drop_volume, "allies", "axis" );
	
	
	restaurant_drop_section = getentarray( "des_fall_01", "script_noteworthy" );
	
	fallTime = 2.5;
	
	restaurant_drop_section_control = getent( "restaurant_drop_section_pivot", "targetname" );
	
	array_call( restaurant_drop_section, ::linkto, restaurant_drop_section_control );
	
	level.fx_dummy = spawn_tag_origin();
	level.fx_dummy.origin = restaurant_drop_section_control.origin;
	level.fx_dummy.angles = restaurant_drop_section_control.angles;
		
	restaurant_drop_section_control rotateto( (-10, 0, -40), 1.5, 1.5, 0 );
	level.fx_dummy RotateTo ((-10, 0, -40), 1.5, 1.5, 0 );
	
	wait 1;
	
	restaurant_drop_section_control MoveGravity( (0, 0, 0), fallTime );
		
	level.fx_dummy MoveGravity ((0, 0, 0), fallTime);
	
	wait fallTime;
	
	restaurant_drop_section_control unlink();
	restaurant_drop_section_control delete();
	
	level.fx_dummy Delete();
	
	foreach( ent in restaurant_drop_section )
	{
		if( IsDefined(ent) )
			ent delete();
	}
}

restaurant_slide_object()
{
	objecttarget = getent( self.script_noteworthy + "_target", "script_noteworthy" );
	
	d = distance( self.origin, objecttarget.origin );
	moveTime = d / 50;
	accel_decel = moveTime / 4;
	
	flag_wait( "restaurant_tilt" );
	
	wait (1 + randomfloat(0.4));
	
	self moveto( objecttarget.origin, moveTime, accel_decel, accel_decel );
}

restaurant_destroy_glass()
{
	drop_volume = getent( "restaurant_drop_volume", "targetname" );

	flag_wait( "restaurant_drop_section_falling" );

	restaurant_glass = GetGlassArray( "muntaha_glass_destroy" );	
	
	foreach( glass in restaurant_glass )
	{
		if( glass_within_volume( glass, drop_volume ) )
		{
			DestroyGlass( glass );
		}
	}

	for( i = 3; i > -9; i-- )
	{
		GlassRadiusDamage( (-1196, i*128, 7824), 100, 300, 100 );
		wait 0.1;
	}
	
	flag_wait( "restaurant_destroyed" );

	foreach( glass in restaurant_glass )
	{
		DestroyGlass( glass );
	}
}

catch_death()
{
	self waittill("death");
	println("died");
}

restaurant_chopper()
{
	flag_wait( "chopper_restaurant_intro" );
	
	enemy_helicopter  = spawn_vehicle_from_targetname_and_drive( "restaurant_helicopter_initial" );
	aud_send_msg("restaurant_chopper", enemy_helicopter );
	
	enemy_helicopter Vehicle_SetSpeedImmediate( 60, 20 );
	enemy_helicopter thread littlebird_handle_spotlight( 0.5, true, undefined, 250 );
	//enemy_helicopter mgoff();
	enemy_helicopter godon();
	enemy_helicopter thread restaurant_chopper_gun_ai_think();
	
	enemy_helicopter thread restaurant_chopper_loop_path_think();
	
	flag_wait( "chopper_restaurant_strafe_run" );
	
	level.player disableweapons();	// get rid of weapons early to ensure offscreen before the explosion
	wait 0.4;
	
	//magic rocket to start it off
	start = getstruct( "restaurant_destruction_rocket_1_start", "targetname" );
	end = getstruct( "restaurant_destruction_rocket_1_end", "targetname" );
	rocket1 = MagicBullet( "zippy_rockets", start.origin, end.origin );
	
	rocket1 thread catch_death();
	rocket1 waittill_any_timeout( 0.25, "death" );
	
	flag_set( "restaurant_destruction" );
	
	level notify( "restaurant_chopper_end_loop" );	
	
	enemy_helicopter delete();
	
	chopper_spawner = getent( "restaurant_helicopter_animated", "targetname" );
	animated_chopper = chopper_spawner spawn_vehicle();
	
	animated_chopper.animname = "md500";
	anime = "restaurant_destruction";
	animated_chopper UseAnimTree( level.scr_animtree[ "md500" ] );
	animated_chopper godon();
	
	animated_chopper thread littlebird_handle_spotlight( 0, true, undefined, 250 );
	animated_chopper thread restaurant_chopper_strafe_run_path_think();
	
	node = getent( "restaurant_destruction_player_start_node", "targetname" );
	node anim_single_solo( animated_chopper, anime );
		
	animated_chopper delete();
}

restaurant_chopper_loop_path_think()
{
	level endon( "chopper_restaurant_strafe_run" );
	
	self SetLookAtEnt( level.player );
	
	flag_wait( "restaurant_chopper_move_up" );
	level notify( "restaurant_chopper_end_loop" );
	self delaythread( 1, ::chopper_loop_path_think, "restaurant_chopper_secondary_loop", "restaurant_chopper_end_loop", 15, 25 );
}

restaurant_chopper_strafe_run_path_think()
{
	lookatent = spawn( "script_origin", (0, 0, 0) );
	
	path = [];
	path[path.size] = getstruct( "restaurant_strafe_run_0", "targetname" );
	path[path.size] = getstruct( "restaurant_strafe_run_1", "targetname" );
	path[path.size] = getstruct( "restaurant_strafe_run_2", "targetname" );
	
	lookat_array = [];
	
	level.restaurant_chopper_rocket_tag = 0;
	
				targets = [];
				targets[targets.size] = GetStruct( "restaurant_strafe_run_0_target_0", "targetname" );
				targets[targets.size] = GetStruct( "restaurant_strafe_run_0_target_1", "targetname" );
				targets[targets.size] = GetStruct( "restaurant_strafe_run_0_target_2", "targetname" );
				targets[targets.size] = GetStruct( "restaurant_destruction_rocket_support_end", "targetname" );
				self delaythread( 1, ::restaurant_chopper_fire_rocket, targets[0] );
				self delaythread( 1.85, ::restaurant_chopper_fire_rocket, targets[1] );
				delaythread( 2.1, ::exploder, 151 );
				noself_delaycall( 2.1, ::PlayFX, level._effect[ "dubai_rest_anim_sqr_table" ], ( -1011.9, 381.5, 7753), (1, 0, 0), (0, 0, 1) );
				noself_delaycall( 2.1, ::PlayFX, level._effect[ "dubai_rest_anim_sqr_table" ], ( -1149, 383.6, 7753 ), (1, 0, 0), (0, 0, 1) );
				self delaythread( 2.25, ::restaurant_chopper_fire_rocket, targets[2] );
				self delaythread( 2.45, ::restaurant_chopper_fire_rocket, targets[3] );
				delaythread( 2.5, ::exploder, 152 );
				noself_delaycall( 2.5, ::PlayFX, level._effect[ "dubai_rest_anim_sqr_table_solo" ], ( -903.7, 251.9, 7753 ), (1, 0, 0), (0, 0, 1) );
				delaythread( 2.65, ::exploder, 153 );
				noself_delaycall( 2.65, ::PlayFX, level._effect[ "dubai_rest_anim_sqr_table" ], ( -1149, 191.6, 7753 ), (1, 0, 0), (0, 0, 1) );

				targets[targets.size] = GetStruct( "restaurant_strafe_run_1_target_0", "targetname" );
				targets[targets.size] = GetStruct( "restaurant_strafe_run_1_target_1", "targetname" );
				targets[targets.size] = GetStruct( "restaurant_strafe_run_1_target_2", "targetname" );
				targets[targets.size] = GetStruct( "restaurant_strafe_run_1_target_3", "targetname" );
				targets[targets.size] = GetStruct( "restaurant_destruction_rocket_pillar_end", "targetname" );
				self delaythread( 4.3, ::restaurant_chopper_fire_rocket, targets[4] );
				//self delaythread( 4.6, ::restaurant_chopper_fire_rocket, targets[5] );
				self delaythread( 5, ::restaurant_chopper_fire_rocket, targets[6] );
				self delaythread( 5.7, ::restaurant_chopper_fire_rocket, targets[7] );
				self delaythread( 6.2, ::restaurant_chopper_fire_rocket, targets[8] );
	
				//targets[targets.size] = GetStruct( "restaurant_strafe_run_2_target_0", "targetname" );
				//targets[targets.size] = GetStruct( "restaurant_strafe_run_2_target_1", "targetname" );
				//targets[targets.size] = GetStruct( "restaurant_destruction_rocket_wall_end", "targetname" );
				//self delaythread( 7.3, ::restaurant_chopper_fire_rocket, targets[9] );
				//self delaythread( 8.8, ::restaurant_chopper_fire_rocket, targets[10] );
				//self delaythread( 11, ::restaurant_chopper_fire_rocket, targets[11] );
}

restaurant_chopper_fire_rocket( target )
{
	if( level.restaurant_chopper_rocket_tag % 2 == 0 )
		tag = "tag_missile_left";
	else
		tag = "tag_missile_right";
	
	rocket = MagicBullet( "zippy_rockets", self GetTagOrigin( tag ), target.origin );
	aud_send_msg("restaurant_chopper_fire_rocket", rocket);
	rocket thread littlebird_missile_rumble_think();
	
	level.restaurant_chopper_rocket_tag++;
	return rocket;
}

monitor_model_spot_lighting()
{
	flag_wait( "model_spot_lighting_enabled" );
	setsaveddvar( "sm_spotLightScoreModelScale", 1 );
	flag_wait( "model_spot_lighting_disabled" );
}

restaurant_chopper_gun_ai_think()
{
	level endon( "chopper_restaurant_strafe_run" );
	
	self mgon();
	
	while( !flag( "restaurant_chopper_move_up" ) )
	{
		if( level.player.health < 25 )
		{
			self.script_turretmg = 0;
			wait 1;
		}
		else
		{
			self.script_turretmg = 1;
			wait 0.05;
		}
	}
	
	self.script_turretmg = 0;
	
	flag_wait( "chopper_restaurant_strafe_run" );
	
	self.script_turretmg = 1;
}

restaurant_player_falling_to_death()
{
	flag_wait( "restaurant_player_falling_to_death" );
	
	earthquake( .2, 3, level.player.origin, 8000 );
	SetBlur( 5, 0.5 );
	
	thread player_falling_kill_logic( 1.5 );
	
	fall_node = spawn( "script_origin", level.player.origin );
	fall_node.angles = (90, 180, 0);
	fall_node MoveGravity( level.player GetVelocity(), 7 );
	
	level.player PlayerLinkToBlend( fall_node, undefined, 2 );
}

restaurant_chase_timer()
{
	level endon( "finale_sequence_begin" );
	
	flag_wait_or_timeout( "update_obj_pos_stairwell", 10 );
	
	if( flag("update_obj_pos_stairwell" ) )
	{
		autosave_by_name_silent( "leaving_restaurant" );
	}
	else
	{
		finale_makarov_escaped();
	}
	
	flag_wait_or_timeout( "update_obj_pos_roof", 10 );
	
	if( flag( "update_obj_pos_roof" ) )
	{
		autosave_by_name_silent( "in_stairwell" );
	}
	else
	{
		finale_makarov_escaped();
	}
	
	flag_wait_or_timeout( "update_obj_pos_finale_chopper", 10 );
	
	if( !flag( "update_obj_pos_finale_chopper" ) )
	{
		finale_makarov_escaped();
	}
}

///////////////////////////////////////////////
//--------------- STAIRWELL -----------------//
///////////////////////////////////////////////

finale_player_hands()
{
	level.player takeallweapons();
	setsaveddvar( "player_sprintUnlimited", 1 );

	// running hands
	level.player GiveWeapon( "freerunner" );
	level.player SwitchToWeapon( "freerunner" );
	level.player disableweaponswitch();
	level.player enableweapons();
}

setup_stairwell()
{
	thread stairwell_entered();
}

stairwell_entered()
{
	flag_wait( "player_entered_stairwell" );
	
	thread maps\dubai_fx::roof_environmentfx_start();
	thread maps\dubai_fx::topfloor_environmentfx_stop();
	
	flag_set( "vo_stairwell_start" );
}

top_floor_corpses()
{
	flag_wait( "top_floor_corpses" );
	
	spawner = getent( "atrium_corpse_spawner", "targetname" );
	
	structs = getstructarray( "atrium_corpse", "targetname" );
	foreach ( s in structs )
	{
		guy = spawner spawn_ai();
		guy.origin = s.origin;
		guy.angles = s.angles;
		guy SetCanDamage( false );
		
		anime = level.scr_anim[ "generic" ][ s.animation ];
		if ( IsArray( anime ) )
			anime = anime[ 0 ];
			
		guy AnimScripted( "endanim", s.origin, s.angles, anime );
		
		guy gun_remove();
		
		guy NotSolid();
		
		if ( issubstr( s.animation, "death" ) )
			guy delayCall( 0.05, ::setAnimTime, anime, 1.0 );
	}
}

handle_suv_damage( exploderid, delay )
{
	self.health += 2500;
	
	if (isdefined(delay) && (delay > 0))
	{
		wait delay;
	}
	if (!isdefined(self))
		return;
	starting_health = self.health;
	thresh_health = starting_health - 600;
	while (self.health > 100)
	{
		self waittill("damage", amount, attacker, direction_vec, point, type );
		if (self.health < thresh_health)
		{
			exploder( exploderid );
			break;
		}
	}
	self waittill("death");
	maps\_shg_fx::kill_exploder( exploderid );	// stop the fire when it explodes
}

pulse()
{
	self endon("stop_pulse");
	while (true)
	{
		self FadeOverTime(0.5);
		self.alpha = 0.5;
		wait 0.5;
		self FadeOverTime(0.5);
		self.alpha = 1.0;
		wait 0.5;
	}
}

finale_end_mission()
{
	flag_wait("level_end");
	
	wait 1;
	
//	thread finale_credits_flyover();
	
	if ( !IsDefined( level.credits_active) || !level.credits_active )
	{
		// as a special case, in sp_dubai, nextmission doesn't actually continue to the next mission,
		// but just awards all the achievements and saves completion of the level
		nextmission();
	}
	
	finale_credits();
	wait_for_credits_to_scroll = 18;
	audio_fade_time = 4;
	
	wait wait_for_credits_to_scroll-audio_fade_time;
	if ( IsDefined( level.credits_active) && level.credits_active )
		aud_send_msg("level_fade_to_black", [0, audio_fade_time]);
	wait audio_fade_time;
	
	flag_set("end_of_credits");
//	flag_wait( "fadeout_at_end_done");
//fade out
//	black_overlay = get_black_overlay();
//	black_overlay.sort = 1;
//	black_overlay exp_fade_overlay( 1, 2 );
	
	setsaveddvar( "ui_nextMission", "0" );
	
	if ( !IsDefined( level.credits_active) || !level.credits_active )
	{
		level.player notifyOnPlayerCommand("tospecops", "pause");
		level.player notifyOnPlayerCommand("tospecops", "+gostand");
		//level.player notifyOnPlayerCommand("tospecops", "+activate");
		fade_in_time = 0.5;
		hold_time = 4;
		fade_out_time = 1;
		vscrn = newhudelem();
		vscrn.horzAlign = "fullscreen";
		vscrn.vertAlign = "fullscreen";
		vscrn.foreground = true;
		vscrn SetShader( "victory_iw5", 640, 480 );
		vscrn.x = 0;
		vscrn.y = 0;
		vscrn.alpha = 1;
		black_overlay = finale_get_black_overlay();
		black_overlay FadeOverTime( fade_in_time );
		black_overlay.alpha = 0;
		wait( fade_in_time );
		wait hold_time;
		aud_send_msg("level_fade_to_black", [0, audio_fade_time]);
		black_overlay FadeOverTime( fade_out_time );
		black_overlay.alpha = 1;
		wait( fade_out_time );
		vscrn SetShader( "victory_menu", 640, 480 );
		msg = level.player createClientFontString( "hudbig", 1.0 );
		msg.x = 0;
		msg.y = 190;
		msg.alignX = "center";
		msg.alignY = "middle";
		msg.horzAlign = "center";
		msg.vertAlign = "middle";
		msg.sort = 1;
		msg.foreground = true;
		msg SetText( &"MENU_SP_CONTINUE_TO_SPECIAL_OPS_CAPS" );
		msg.alpha = 1;
		msg.hidewheninmenu = false;
		msg.color = ( 0.9, 0.9, 0.9 );
		msg thread pulse();
		
		black_overlay FadeOverTime( fade_in_time );
		black_overlay.alpha = 0;
		level.player openmenu( "nopause" );
		wait( fade_in_time );
		level.player waittill("tospecops");

		msg notify("stop_pulse");
		black_overlay FadeOverTime( fade_out_time );
		black_overlay.alpha = 1;
		msg FadeOverTime( fade_out_time );
		msg.alpha = 0;
		wait( fade_out_time );		
		level.player openmenu( "allowpause" );
		
		missionSuccess( "sp_intro" );	// on to specops
	}
	else
	{	// back to main menu
		ChangeLevel( "", false );
	}
}

finale_credits_flyover()
{
	recs = [
	[ 10, (2303, 159, 8797), (664, -11, 8194) ],
	[ 20, (4077, 10, 7876), (664, -11, 7876) ],
	[ 60, (5098, -108, 375), (664, -11, 100) ],
	[ 60, (4077, -68, 7876), (664, -11, 7876) ],
	[ 60, (5098, -108, 375), (664, -11, 100) ],
	[ 60, (4077, -68, 7876), (664, -11, 7876) ],
	[ 60, (5098, -108, 375), (664, -11, 100) ],
	[ 60, (4077, -68, 7876), (664, -11, 7876) ],
	[ 60, (5098, -108, 375), (664, -11, 100) ]
	];
	node = spawn_tag_origin();
	node.origin = level.player.origin;
	node.angles = level.player GetPlayerAngles();
	level.player allowprone( true );
	level.player allowcrouch( true );
	level.player allowstand( true );
	level.player setstance( "crouch" );
	level.player PlayerLinkTo( node, "tag_origin", 1.0, 45, 45, 45, 45, false );
	target = spawn_tag_origin();
	forward = 1600*AnglesToForward( node.angles );
	target.origin = node.origin + forward;
	foreach (rec in recs)
	{
		t = rec[0];
		pos = rec[1];
		tgt = rec[2];
		node moveto( pos, t, 1, 1 );
		target moveto( tgt, t, 1, 1 );
		while (t > 0)
		{
			delta = target.origin - node.origin;
			angles = VectorToAngles( delta );
			node.angles = angles;
			wait 0.05;
			t -= 0.05;
		}
	}	
	
}

finale_credits()
{
//	if ( getdvar( "ui_char_museum_mode" ) == "credits_black" )
	{
		if (!isdefined(level.black))
		{
			level.black = get_black_overlay();
			level.black.sort = 1;
	}
	}
		
 //	thread music_loop( "af_chase_ending_credits" , 122, 1 );
	
//	level.player SetEqLerp( .05, level.eq_main_track );
//	AmbientStop( .05 );
//	thread maps\_ambient::use_eq_settings( "fadeall_but_music", level.eq_mix_track );
//	thread maps\_ambient::blend_to_eq_track( level.eq_mix_track , .05 );	
	
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player TakeAllWeapons();
	level.player DisableWeapons();
	level.player FreezeControls( true );
//	level.makarov Delete();
//	setSavedDvar( "hud_drawhud", "0" );
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar( "compass", "0" );					// Hide the compass
	SetSavedDvar( "ammoCounterHide", "1" );
	setsaveddvar( "g_friendlyNameDist", 0 );
	setsaveddvar( "ui_hidemap", 1 );

	flag_set( "atvi_credits_go" );
	playCredits();
}

finale_credit_setup()
{
	debug = "0";
/#
	setDvarIfUninitialized( "debug_shortcredits", "0" );
	debug = getdebugdvar("debug_shortcredits");
#/
	if (debug == "0")
	{
		initCredits("all");
	}
	else
	{
		initCredits("none");
	addCenterName( "Placeholder Credits" );
	addGap();
	addCenterName( "Placeholder Person A" );
	addCenterName( "Placeholder Person B" );
	addCenterName( "Placeholder Person C" );
	//	for (i=0; i<40; i++)
	//		addGap();
	}
//	ReadCredits( "ui/credits.csv" );
	//finale_credit_test();
}

finale_credit_test()
{
	a_c( "heading"										, &"CREDIT_GLOBAL_BRAND_MANAGEM"	);
	a_c( "spacesmall" );
	a_c( "centerdual"	, &"CREDIT_VICE_PRESIDENT_OF_MA", &"CREDIT_ROB_KOSTICH"				);
	a_c( "spacesmall" );
	a_c( "centerdual"	, &"CREDIT_DIRECTOR_OF_MARKETIN", &"CREDIT_BYRON_BEEDE"				);
	a_c( "spacesmall" );
	a_c( "centerdual"	, &"CREDIT_GLOBAL_BRAND_MANAGER", &"CREDIT_GEOFF_CARROLL"				);
	a_c( "spacesmall" );
	a_c( "centerdual"	, &"CREDIT_ASSOCIATE_BRAND_MANA", &"CREDIT_JOE_KORSMO"				);
	a_c( "name"			, undefined						, &"CREDIT_MIKE_SCHAEFER" );
	a_c( "name"			, undefined						, &"CREDIT_DAVID_WANG" );
	a_c( "gap" );
}

draw_label( label, draw_script_pt )
{
	/#
	self endon("death");
	self endon("kill_debug_axis");
	if (!isdefined(draw_script_pt))
		draw_script_pt = 0;
	while (true)
	{
		origin = self.origin;
		Print3d( origin, label );
		if (draw_script_pt > 0)
			draw_point( origin, draw_script_pt, (1,1,1) );

		wait 0.05;
	}
	#/
}

draw_ent_axis( label )
{
	/#
	if (isdefined(label))
		self thread draw_label( label );
		
	axis = spawn("script_model", self.origin);
	axis.angles = self.angles;
	axis SetModel("axis");
	axis linkto(self);
	self waittill_either("death", "kill_debug_axis" );
	axis Delete();
	#/
}
