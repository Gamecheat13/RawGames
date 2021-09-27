/*
	Included by breach_door_frame_church prefab.  Implements a slowmo breach for the church doors in warlord.
	  Not using the _slowmo_breach code for now in order to learn the system and because it has a lot of functionality
	  I don't want or need.  I also don't want to inadverdently break any existing breaches.  Might refactor or 
	  eventually integrate into _slowmo_breach.
*/

#include maps\_anim;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_audio;

main()
{
	PreCacheModel( "viewlegs_generic" );
	
	level.breachEnemies_active = 0;
	level.breach_done = [];
	
	load_player_anims();
	load_generic_anims();
	
	breach_start_trigger = GetEnt( "trigger_use_breach", "classname" );
	breach_start_trigger SetHintString( &"SCRIPT_PLATFORM_BREACH_ACTIVATE" );
	breach_start_trigger UseTriggerRequireLookAt();
	level.breach_done[ breach_start_trigger.script_slowmo_breach ] = false;
	
	breach_start_trigger thread low_tech_breach_church();
}

breach_trigger_on()
{
	breach_start_trigger = GetEnt( "trigger_use_breach", "classname" );
	breach_start_trigger trigger_on();
}

breach_trigger_off()
{
	breach_start_trigger = GetEnt( "trigger_use_breach", "classname" );
	breach_start_trigger trigger_off();
}

#using_animtree( "player" );
load_player_anims()
{
	level.scr_animtree[ "breach_player_rig" ] 						= #animtree;
	level.scr_model[ "breach_player_rig" ] 							= "viewhands_player_us_army";
	level.scr_anim[ "breach_player_rig" ][ "lowtech_breach" ]		= %viewmodel_lowtech_breach_arms;
	
	level.scr_animtree[ "breach_player_legs" ]						= #animtree;
	level.scr_model[ "breach_player_legs" ]							= "viewlegs_generic";
	level.scr_anim[ "breach_player_legs" ][ "lowtech_breach" ]		= %viewmodel_lowtech_breach_legs;
	
	addNotetrack_customFunction( "breach_player_rig", "kick_door", ::kick_door_open, "lowtech_breach" );
	addNotetrack_customFunction( "breach_player_rig", "slowmo_breach", ::slowmo_breach_start, "lowtech_breach" );
	addNotetrack_customFunction( "breach_player_rig", "weapon_pullout", ::weapon_pullout, "lowtech_breach" );
	addNotetrack_customFunction( "breach_player_rig", "hide_player", ::hide_breach_player_rig, "lowtech_breach" );
}

#using_animtree( "generic_human" );
load_generic_anims()
{
	level.scr_anim[ "generic" ][ "breach_kick_stackl1_enter" ] 		= %breach_kick_stackl1_enter;
	level.scr_anim[ "generic" ][ "doorkick_2_cqbwalk" ] 			= %doorkick_2_cqbwalk;
	addNotetrack_customFunction( "generic", "kick", ::kick_side_door_open, "doorkick_2_cqbwalk" );
}

low_tech_breach_anim( anim_struct_targetname, open_door_function, weapon_pullout_function, slowmo_function, slowmo_arg )
{
	level.open_door_note_fn = open_door_function;
	level.weapon_pullout_note_fn = weapon_pullout_function;
	level.slowmo_breach_note_fn = slowmo_function;
	level.slowmo_breach_note_arg = slowmo_arg;
	
	level.player DisableWeapons();
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player AllowSprint( false );
	level.player AllowJump( false );
		
	level.breach_player_rig = spawn_anim_model( "breach_player_rig" );
	level.breach_player_legs = spawn_anim_model( "breach_player_legs" );
	
	guys = [];
	guys[ "breach_player_rig" ] = level.breach_player_rig;
	guys[ "breach_player_legs" ] = level.breach_player_legs;
		
	scene = "lowtech_breach";

	level.player PlayerLinkToBlend( level.breach_player_rig, "tag_player", 0.2, 0.1, 0.1 );
	
	struct = getstruct( anim_struct_targetname, "targetname" );
	struct thread anim_single( guys, scene );
	struct waittill( scene );

	level.player AllowCrouch( true );
	level.player AllowProne( true );
	level.player AllowSprint( true );
	level.player AllowJump( true );

	level.breach_player_rig Delete();
	level.breach_player_legs Delete();
	
	level notify( "low_tech_breach_anim_done" );
}

low_tech_breach_church()
{
	self endon( "kill_breach" );
	
	while ( true )
	{
		self waittill( "trigger" );
		
		if ( self breach_failed_to_start() )
		{
			continue;
		}
		
		break;
	}
	
	self trigger_off();
	
	// top off player's weapon if difficulty is easy/normal
	if ( level.gameskill <= 1 )
	{
		weapon = level.player GetCurrentWeapon();
		clipSize = WeaponClipSize( weapon );
		if ( level.player GetWeaponAmmoClip( weapon ) < clipSize )
			level.player SetWeaponAmmoClip( weapon, clipSize );
	}
	
	setsaveddvar( "objectiveHide", true );
	
	aud_send_msg("aud_player_breach");
	
	level notify( "low_tech_breach_started" );
	thread low_tech_breach_anim( "anim_node_breach_door", ::open_church_doors, ::church_weapon_pullout, ::slowmo_begins, 3.5 );
	
	self spawn_breach_enemies();
	thread ally_breach();

	level waittill( "low_tech_breach_anim_done" );
	level waittill( "slowmo_breach_ending" );
	level.breach_done[ self.script_slowmo_breach ] = true;
}

ally_breach()
{
	if ( !IsDefined( level.price ) )
	{
		price_spawner = GetEnt( "price_spawner", "targetname" );
		soap_spawner = GetEnt( "soap_spawner", "targetname" );
	
		level.price = price_spawner spawn_ai( true );
		level.soap = soap_spawner spawn_ai( true );
	}
	
	right_breach_anim = GetEnt( "ally_right_breach_origin", "targetname" );
	left_breach_anim = GetEnt( "ally_left_breach_origin", "targetname" );
	
	left_breach_anim thread anim_generic_first_frame( level.price, "breach_kick_stackl1_enter" );
	right_breach_anim thread anim_generic_first_frame( level.soap, "doorkick_2_cqbwalk" );
	
	level waittill( "kick_door_open" );
	
	level.price SetGoalPos( level.price.origin );
	level.soap SetGoalPos( level.soap.origin );
	
	left_breach_anim thread anim_generic_run( level.price, "breach_kick_stackl1_enter" );
	right_breach_anim thread anim_generic_run( level.soap, "doorkick_2_cqbwalk" );
	
	flag_set( "church_breach_ally_dialogue" );
}

spawn_breach_enemies()
{
	breach_enemy_spawners = GetEntArray( "breach_enemy_spawner", "targetname" );
	
	array_thread( breach_enemy_spawners, ::add_spawn_function, ::track_enemy_status );
	array_thread( breach_enemy_spawners, ::add_spawn_function, ::delay_shooting );
	array_thread( breach_enemy_spawners, ::add_spawn_function, ::play_custom_animation );
	array_thread( breach_enemy_spawners, ::add_spawn_function, ::low_health_during_breach );
	
	foreach ( breach_enemy_spawner in breach_enemy_spawners )
	{
		// spawn enemies for same breach group
		if ( breach_enemy_spawner.script_slowmo_breach == self.script_slowmo_breach )
		{
			breach_enemy_spawner StalingradSpawn();
		}
	}
}

track_enemy_status()
{
	level.breachEnemies_active++;
	self waittill( "death" );
	level.breachEnemies_active--;
}

delay_shooting()
{
	self endon( "death" );
	self.dontEverShoot = true;
	wait 2.7;
	self.dontEverShoot = undefined;
}

play_custom_animation()
{
	self endon( "death" );
	
	if ( IsDefined( self.animation ) )
	{
		reference = self.spawner;
		self anim_generic_first_frame( self, self.animation );
		level waittill( "kick_door_open" );
		self.allowdeath = true;
		reference anim_generic( self, self.animation );
	}
}

low_health_during_breach()
{
	self endon( "death" );
	
	old_health = self.health;
	self.health = 1;
	level waittill( "slowmo_breach_ending" );
	self.health = old_health;
}

slowmo_breach_start( breach_player_rig )
{
	if ( IsDefined( level.slowmo_breach_note_fn ) )
	{
		[[level.slowmo_breach_note_fn]](level.slowmo_breach_note_arg);
	}
	
	level.slowmo_breach_note_fn = undefined;
	level.slowmo_breach_note_arg = undefined;
}

kick_door_open( breach_player_rig )
{
	level notify( "kick_door_open" );
	[[level.open_door_note_fn]]();
}

open_church_doors()
{
	breach_door_left = GetEnt( "breach_door_left", "targetname" );
	breach_door_right = GetEnt( "breach_door_right", "targetname" );
	
	breach_door_left RotateYaw( 90, 0.2, 0.1, 0.1 );
	breach_door_right RotateYaw( -90, 0.2, 0.1, 0.1 );
	
	breach_door_left ConnectPaths();
	breach_door_right ConnectPaths();
}

kick_side_door_open( ent )
{
	breach_side_door_left = GetEnt( "breach_side_door_left", "targetname" );
	breach_side_door_right = GetEnt( "breach_side_door_right", "targetname" );
	
	breach_side_door_left RotateYaw( 180, 0.2, 0.1, 0.1 );
	breach_side_door_right RotateYaw( -180, 0.2, 0.1, 0.1 );
	
	breach_side_door_left ConnectPaths();
	breach_side_door_right ConnectPaths();
}

weapon_pullout( breach_player_rig )
{
	if ( IsDefined( level.weapon_pullout_note_fn ) )
	{
		[[level.weapon_pullout_note_fn]]();
	}
}

church_weapon_pullout()
{
	level.player EnableWeapons();
	arc = 180;
	level.player PlayerLinkToDelta( level.breach_player_rig, "tag_player", 1, arc, arc, arc, arc, 1 );
}

hide_breach_player_rig( breach_player_rig )
{
	level.breach_player_rig Hide();
	level.breach_player_legs Hide();
}

slowmo_begins( slomo_duration )
{
	level notify( "slowmo_go" );
	level endon( "slowmo_go" );

	slomoLerpTime_in = 0.5;
	slomoLerpTime_out = 0.75;
	slomobreachplayerspeed = 0.2;

	level.player thread play_sound_on_entity( "slomo_whoosh" );
	level.player thread player_heartbeat();

	thread slomo_breach_vision_change( ( slomoLerpTime_in * 2 ), ( slomoLerpTime_out / 2 ) );

	thread slomo_difficulty_dvars();
	flag_clear( "can_save" );
	
	level.player AllowMelee( false ); ///melee is useless and causes bugs during slomo
	
	slowmo_setspeed_slow( 0.25 );
	slowmo_setlerptime_in( slomoLerpTime_in );
	slowmo_lerp_in();
	
	level.player SetMoveSpeedScale( slomobreachplayerspeed );

	startTime = GetTime();
	endTime = startTime + ( slomo_duration * 1000 );

	level.player thread catch_weapon_switch();// called after the player weapons are force - changed, so this is cool to put here

	// be lenient about some slowmo-ending activities at the start of the slowmo period
	reloadIgnoreTime = 500;// ms
	switchWeaponIgnoreTime = 1000;

	// wait for slowmo timeout, or wait for conditions to be met that will interrupt the slowmo
	for ( ;; )
	{
		if ( IsDefined( level.forced_slowmo_breach_slowdown ) )
		{
			if ( !level.forced_slowmo_breach_slowdown )
			{
				if ( IsDefined( level.forced_slowmo_breach_lerpout ) )
					slomoLerpTime_out = level.forced_slowmo_breach_lerpout;
				break;
			}

			wait( 0.05 );
			continue;
		}

		if ( GetTime() >= endTime )
			break;

		// is everyone dead?
		if ( level.breachEnemies_active <= 0 )
		{
			// lerp out a little slower so we see more of the last guy's death in slowmo
			slomoLerpTime_out = 1.15;
			break;
		}

		// Only worry about weapon status changes in single player.
		if ( !is_coop() )
		{
			// did the player start reloading after the reload ignore time window has expired?
			if ( level.player.lastReloadStartTime >= ( startTime + reloadIgnoreTime ) )
			{
				break;
			}

			// did player switch weapons?
			if ( level.player.switchedWeapons && ( ( GetTime() - startTime ) > switchWeaponIgnoreTime ) )
			{
				break;
			}
		}

		wait( 0.05 );
	}

	level notify( "slowmo_breach_ending", slomoLerpTime_out );
	level notify( "stop_player_heartbeat" );

	level.player thread play_sound_on_entity( "slomo_whoosh" );
	slowmo_setlerptime_out( slomoLerpTime_out );
	slowmo_lerp_out();
	
	level.player AllowMelee( true ); ///melee is useless and causes bugs during slomo

	flag_set( "can_save" );
	
	if ( IsDefined( level.playerSpeed ) )
		level.player SetMoveSpeedScale( level.playerSpeed );
	else
		level.player SetMoveSpeedScale( 1 );
	
	setsaveddvar( "objectiveHide", false );
}

catch_weapon_switch()
{
	level endon( "slowmo_breach_ending" );

	self.switchedWeapons = false;

	self waittill_any( "weapon_switch_started", "night_vision_on", "night_vision_off" );

	self.switchedWeapons = true;
}

slomo_difficulty_dvars()
{
	//Get current viewKick values
	old_bg_viewKickScale = GetDvar( "bg_viewKickScale" ); 	// 0.8
	old_bg_viewKickMax = GetDvar( "bg_viewKickMax" );		// 90
	SetSavedDvar( "bg_viewKickScale", 0.3 );		// make the view kick a little easier
	SetSavedDvar( "bg_viewKickMax", "15" );			// make the view kick a little easier

	SetSavedDvar( "bullet_penetration_damage", 0 ); // Disable bullet penetration damage so that hostages are less likely to be shot through enemies


	level waittill( "slowmo_breach_ending" );
	
	//Restore all values when slomo is over
	
	SetSavedDvar( "bg_viewKickScale", old_bg_viewKickScale );	// set view kick back to whatever it was
	SetSavedDvar( "bg_viewKickMax", old_bg_viewKickMax );		// set view kick back to whatever it was
	
	wait( 2 );	//wait a few seconds before resetting bullet dvar
	SetSavedDvar( "bullet_penetration_damage", 1 ); 			// Re - enable bullet penetration

}

slomo_breach_vision_change( lerpTime_in, lerpTime_out )
{
	if ( !IsDefined( level.slomoBasevision ) )
	{
		return;
	}

	VisionSetNaked( "slomo_breach", lerpTime_in );

	level waittill( "slowmo_breach_ending", newLerpTime );

	// maybe update the lerp time in case things changed in the main thread
	if ( IsDefined( newLerpTime ) )
	{
		lerpTime_out = newLerpTime;
	}

	wait( 1 );
	VisionSetNaked( level.slomoBasevision, lerpTime_out );
}

player_heartbeat()
{
	level endon( "stop_player_heartbeat" );
	while ( true )
	{
		self PlayLocalSound( "breathing_heartbeat" );
		wait .5;
	}
}

reset_breach()
{
	self trigger_on();
	thread close_door();
		
	// reset spawners
	breach_enemy_spawners = GetEntArray( "breach_enemy_spawner", "targetname" );
	foreach ( breach_enemy_spawner in breach_enemy_spawners )
	{
		// spawn enemies for same breach group
		if ( breach_enemy_spawner.script_slowmo_breach == self.script_slowmo_breach )
		{
			breach_enemy_spawner.count = breach_enemy_spawner.count + 1;
		}
	}
}

close_door()
{
	breach_door_left = GetEnt( "breach_door_left", "targetname" );
	breach_door_right = GetEnt( "breach_door_right", "targetname" );
	breach_door_left RotateYaw( -90, 0.1 );
	breach_door_right RotateYaw( 90, 0.1 );
	
	breach_side_door_left = GetEnt( "breach_side_door_left", "targetname" );
	breach_side_door_right = GetEnt( "breach_side_door_right", "targetname" );
	
	breach_side_door_left RotateYaw( -180, 0.1 );
	breach_side_door_right RotateYaw( 180, 0.1 );
}

// deactivate breach and open doors.  for use with start points.
debug_breach_done()
{
	breach_start_trigger = GetEnt( "trigger_use_breach", "classname" );
	breach_start_trigger notify( "kill_breach" );
	breach_start_trigger trigger_off();
	
	level.breach_done[ breach_start_trigger.script_slowmo_breach ] = true;
	
	thread open_church_doors();
	thread kick_side_door_open();
}

debug_reset_breach()
{
	/#
	breach_start_trigger = GetEnt( "trigger_use_breach", "classname" );
	if ( level.breach_done[ breach_start_trigger.script_slowmo_breach ] )
	{
		level.breach_done[ breach_start_trigger.script_slowmo_breach ] = false;
		breach_start_trigger reset_breach();
		breach_start_trigger waittill( "trigger" );
		breach_start_trigger low_tech_breach_church();
	}
	#/
}

breach_failed_to_start()
{
	fail_funcs = [];
	fail_funcs[ fail_funcs.size ] = ::isMeleeing;
	fail_funcs[ fail_funcs.size ] = ::isSwitchingWeapon;
	fail_funcs[ fail_funcs.size ] = ::IsThrowingGrenade;

	foreach ( player in level.players )
	{
		if ( player IsReloading() )
		{
			self thread breach_reloading_hint();
			return true;
		}
		
		if ( player using_illegal_breach_weapon() )
		{
			self thread breach_bad_weapon_hint();
			return true;
		}
		
		foreach ( func in fail_funcs )
		{
			if ( player call [[ func ]]() )
			{
				self thread breach_not_ready_hint();
				return true;
			}
		}			
	}
		
	return false;
}

breach_reloading_hint()
{
	// Cannot breach while reloading
	self thread breach_hint_create( &"SCRIPT_BREACH_RELOADING" );
}

breach_bad_weapon_hint()
{
	// Cannot breach with this weapon
	self thread breach_hint_create( &"SCRIPT_BREACH_ILLEGAL_WEAPON" );
}

breach_not_ready_hint()
{
	// You are not ready to breach
	self thread breach_hint_create( &"SCRIPT_BREACH_YOU_NOT_READY" );
}

breach_hint_create( message )
{
	level notify( "breach_hint_cleanup" );
	level endon( "breach_hint_cleanup" );

	hint_offset = 20;
	if ( issplitscreen() )
		hint_offset = -23;

	thread hint( message, 3, hint_offset );
	self thread breach_hint_cleanup();
}

breach_hint_cleanup()
{
	level notify( "breach_hint_cleanup" );
	level endon( "breach_hint_cleanup" );

	if ( IsDefined( self ) )
	{
		self SetHintString( "" );
	}

	level waittill_notify_or_timeout( "low_tech_breach_started", 3 );
	hint_fade();

	if ( isdefined( self ) )
	{
		self SetHintString( &"SCRIPT_PLATFORM_BREACH_ACTIVATE" );
	}
}

using_illegal_breach_weapon()
{
	illegal_weapons = [];
	illegal_weapons[ "riotshield" ] = true;
	illegal_weapons[ "claymore" ] = true;
	illegal_weapons[ "c4" ] = true;
	illegal_weapons[ "none" ] = true;
	
	weapon = self getCurrentWeapon();
	
	return isdefined( illegal_weapons[ weapon ] );
}
