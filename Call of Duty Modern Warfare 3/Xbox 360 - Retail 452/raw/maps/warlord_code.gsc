#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\warlord_anim;
#include maps\warlord_stealth;
#include maps\warlord_utility;
#include maps\warlord_obj;
#include maps\_stealth_utility;
#include maps\_hud_util;
#include maps\_audio;
#include maps\_vehicle;
#include maps\_shg_common;

spawn_allies()
{
	if ( !IsDefined( level.price ) )
	{
		price_spawner = GetEnt("price", "targetname");
		level.price = price_spawner spawn_ai( true );
		if ( !IsDefined( level.price.magic_bullet_shield ) )
		{
			level.price magic_bullet_shield();
		}
		level.price.animname = "price";
		level.price.disable_sniper_glint = 1;
		level.price.ignoreSuppression = true;
		level.price thread warlord_waterfx();
		
		level.price.spotted_color = "y";
	}
	
	if ( !IsDefined( level.soap ) )
	{
		soap_spawner = GetEnt("soap", "targetname");
		level.soap = soap_spawner spawn_ai( true );
		if ( !IsDefined( level.soap.magic_bullet_shield ) )
		{
			level.soap magic_bullet_shield();
		}
		level.soap.animname = "soap";
		level.soap.disable_sniper_glint = 1;
		level.soap.ignoreSuppression = true;
		level.soap thread warlord_waterfx();
		
		// currently using seal version, force voice to be taskforce
		level.soap.voice = "taskforce";
		level.soap.countryID = "TF";
		
		level.soap.spotted_color = "g";
	}
	
	flag_set( "allies_spawned" );
}

// introscreen functions
warlord_intro_text()
{
	thread maps\_introscreen::introscreen_generic_black_fade_in( 2.5, 5 );
	
	lines = [];
	// "God Already Left Africa"
	lines[ lines.size ] = &"WARLORD_INTROSCREEN_LINE1";
	// Day 2 - 18:27:02
	lines[ "date" ]     = &"WARLORD_INTROSCREEN_LINE2";
	// Codename Yuri
	lines[ lines.size ] = &"WARLORD_INTROSCREEN_LINE3";
	// Prometheus Security Group
	lines[ lines.size ] = &"WARLORD_INTROSCREEN_LINE4";
	// Sierra Leone
	lines[ lines.size ] = &"WARLORD_INTROSCREEN_LINE5";

	wait( 2 );
	flag_set( "river_allies_stand" );
	
	level waittill( "finished_water_emerge" );
	
	//level.price thread ally_move_dynamic_speed();
	//level.soap thread ally_move_dynamic_speed();
	
	level.price enable_cqbwalk();
	level.soap enable_cqbwalk();
	
	activate_trigger_with_targetname( "trig_intro_allies" );
	wait 3;
	level.price disable_cqbwalk();
	level.soap disable_cqbwalk();
	level.price thread ally_move_dynamic_speed();
	level.soap thread ally_move_dynamic_speed();
	flag_wait( "river_intro_vo_done" );
	maps\_introscreen::introscreen_feed_lines( lines );
}

intro_water_sheeting()
{
	level.player SetWaterSheeting( 1, 5.5 );
}

/////////////////////////////////////////////////
// STEALTH INTRO
/////////////////////////////////////////////////

start_allies()
{
	// make sure allies exist
	spawn_allies();
	
	thread play_ally_intro();
	
	level.player AllowSprint( false );
	level.player thread player_in_water_trigger();
	level.price thread ally_in_water_trigger();
	level.soap thread ally_in_water_trigger();
}

play_ally_intro()
{
	flag_set( "play_river_dialogue" );
	level.player DisableWeapons();
	level.player FreezeControls( true );
	
	thread interrupt_intro_anim();
	
	org = getstruct( "org_intro", "targetname" );
	
	// player in initial position
	player_rig = spawn_anim_model( "player_rig" );
	player_rig Hide();
	player_weapon = spawn_anim_model( "sniper_rifle" );
	thread maps\warlord_fx::intro_player_drips_vfx(player_weapon,player_rig);
	player_weapon Hide();
	org anim_first_frame_solo( player_rig, "water_emerge" );
	level.player thread intro_lock_player_view( player_rig, "tag_player" );
	time = GetAnimLength( player_rig getanim( "water_emerge" ) );
	level.player Shellshock( "slowview", time + 2 );
	
	// allies in initial position
	level.price thread anim_loop_solo( level.price, "water_crouch_idle", "water_emerge" );
	level.soap thread anim_loop_solo( level.soap, "water_crouch_idle", "water_emerge" );
	
	flag_wait( "river_allies_stand" );
	delaythread( 1.5, ::flag_set, "river_dialogue" );
	
	thread maps\warlord_fx::water_emerge_vfx();
	
	guys = [];
	guys[0] = level.price;
	guys[1] = level.soap;
	guys[2] = player_rig;
	guys[3] = player_weapon;
	
	level.soap notify( "water_emerge" );
	level.price notify( "water_emerge" );
	
	player_rig delayCall( 0.2, ::Show );
	player_weapon delaythread( 0.2, ::show_player_weapon );
	
	level.price thread multiple_dialogue_queue( "price_emerge_lines" );
	org anim_single( guys, "water_emerge" );
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.2, 0.1, 0.1 );
	wait 0.2;
	
	player_rig delete();
	player_weapon delete();
	flag_wait( "player_show_gun" );
	flag_set( "obj_first_follow_price" );
	level.player EnableWeapons();
	level.player Unlink();
	level.player FreezeControls( false );
	
	//level.price notify( "water_emerge" );
	//level.soap notify( "water_emerge" );

	//level.price thread anim_single_solo( level.price, "water_emerge" );
	//level.soap anim_single_solo( level.soap, "water_emerge", undefined, 2 );
	
	level notify( "finished_water_emerge" );
}

intro_lock_player_view( player_rig, player_tag )
{
	// force view to be oriented correctly at start
	self PlayerLinkToDelta( player_rig, player_tag, 1, 0, 0, 0, 0, true );
	// takes a couple frames for some reason before the player angles take the animation angles
	wait 2;
	self PlayerLinkToDelta( player_rig, player_tag, 1, 15, 10, 15, 5 );
}

show_player_weapon()
{
	self Show();

	self HidePart( "TAG_FOREGRIP" );
	self HidePart( "TAG_THERMAL_SCOPE" );
	self HidePart( "TAG_ACOG_2" );
	self HidePart( "TAG_HEARTBEAT" );
	self HidePart( "TAG_MOTION_TRACKER" );
}

interrupt_intro_anim()
{
	level endon( "finished_water_emerge" );
	
	interrupt_intro_anim_trigger = GetEnt( "interrupt_intro_anim_trigger", "targetname" );
	interrupt_intro_anim_trigger waittill( "trigger" );
	
	level.price notify( "single anim", "end" );
	level.price StopAnimScripted();
	
	level.soap notify( "single anim", "end" );
	level.soap StopAnimScripted();
}

player_in_water_trigger()
{
	deep_water_trigger = GetEnt( "deep_water_trigger", "targetname" );
	while ( true )
	{
		deep_water_trigger waittill( "trigger", guy );
		if ( guy != self )
		{
			continue;
		}

		// entered trigger
		while ( level.player IsTouching( deep_water_trigger ) )
		{
			if ( level.player.origin[2] < -154 )
			{
				level.player AllowCrouch( false );
				level.player AllowProne( false );
				level.player AllowJump( false );
			}
			else if ( level.player.origin[2] < -129 )
			{
				level.player AllowCrouch( true );
				level.player AllowProne( false );
				level.player AllowJump( false );
			}
			else if ( level.player.origin[2] < -127 )
			{
				level.player AllowCrouch( true );
				level.player AllowProne( true );
				level.player AllowJump( true );
			}
			
			// figure out speed based on water depth
			speed_percent = ( ( level.player.origin[2] + 167.875 ) / 40 ) * 100;
			speed_percent = max( speed_percent, 30 );
			player_speed_percent( speed_percent );
			
			wait 0.05;
		}
		
		// exited trigger
		player_speed_percent( 70 );
		level.player AllowCrouch( true );
		level.player AllowProne( true );
		level.player AllowJump( true );
		level.player AllowSprint( true );
	}
}

ally_in_water_trigger()
{
	deep_water_trigger = GetEnt( "deep_water_trigger", "targetname" );
	while ( true )
	{
		deep_water_trigger waittill( "trigger", guy );
		if ( guy != self )
		{
			continue;
		}

		// entered trigger
		while ( guy IsTouching( deep_water_trigger ) )
		{
			// figure out speed based on water depth
			speed_percent = ( ( guy.origin[2] + 167.875 ) / 40 );
			speed_percent = max( speed_percent, 0.4 );
			guy.moveplaybackrate = speed_percent;
			guy.disableExits = true;
			wait 0.05;
		}
		
		// exited trigger
		guy.moveplaybackrate = 1;
		guy.disableExits = false;
	}
}

river_corpses()
{
	spawners = getentarray( "civ_river_corpse", "targetname" );
	
	foreach( spawner in spawners )
	{
		org = getstruct( spawner.target, "targetname" );
		if( isDefined( org ) )
		{
			spawner corpse_setup( org, org.animation );
		}
	}
	
	thread river_create_body_piles();
}

corpse_setup( org, deathanim )
{
	self.count = 1;
	corpse_drone = self spawn_ai( true );
	corpse_drone.animname = "generic";
	sAnim = corpse_drone getanim( deathanim );
	org anim_generic_first_frame( corpse_drone, deathanim );
	dummy = maps\_vehicle_aianim::convert_guy_to_drone( corpse_drone );
	dummy setanim( sAnim, 1, .2, 0 );
	dummy notsolid();
	dummy thread drone_wait_to_delete();
}

drone_wait_to_delete()
{
	flag_wait( "clean_up_river" );
	if ( IsDefined( self ) )
	{
		self delete();
	}
}

river_create_body_piles()
{
	orgs = getstructarray( "org_body_pile", "targetname" );
	
	foreach( org in orgs )
	{
		river_create_body_pile( org.origin, ( 0, 90, 0 ), true );
	}
}

#using_animtree( "generic_human" );
river_create_body_pile( origin, angles, notlastguy )
{
	link = spawn( "script_origin", origin );
	link.angles = ( 0, 0, 0 );

	guy = river_create_drone( link, origin, ( 0, 0, 0 ) );
	guy useAnimTree( #animtree );
	guy clearanim( %root, 0 );
	guy setanim( %covercrouch_death_1 );
	guy notsolid();

	guy = river_create_drone( link, origin + ( -25, 0, 0 ), ( 0, 0, 0 ) );
	guy useAnimTree( #animtree );
	guy clearanim( %root, 0 );
	guy setanim( %covercrouch_death_2 );
	guy notsolid();

	guy = river_create_drone( link, origin + ( -20, 40, 0 ), ( 0, -135, 0 ) );
	guy useAnimTree( #animtree );
	guy clearanim( %root, 0 );
	guy setanim( %covercrouch_death_3 );
	guy notsolid();

	if ( !isdefined( notlastguy ) )
	{
		guy = river_create_drone( link, origin + ( -45, 20, -5 ), ( 6, 90, 0 ) );
		guy useAnimTree( #animtree );
		guy clearanim( %root, 0 );
		guy setanim( %corner_standR_death_grenade_slump );
		guy notsolid();
	}

	if ( isdefined( angles ) )
	{
		link rotateto( angles, .1 );
		wait .15;
	}
	link delete();
}

river_create_drone( link, origin, angles )
{
	spawner = getent( "river_deadguy_1", "script_noteworthy" );
	spawner.count = 1;
	ai = dronespawn( spawner );
	ai.script_noteworthy = undefined;
	ai.ignoreall = true;
	ai.ignoreme = true;
	ai.team = "neutral";
	//ai detach( getWeaponModel( "ak47" ), "TAG_WEAPON_RIGHT" );
	ai.origin = origin;
	ai.angles = spawner.angles + angles;
	ai linkto( link );
	wait .05;
	return ai;
}

///////////////////////
// technicals encounter
///////////////////////

river_technicals_encounter()
{
	flag_init( "river_stop_soap_idle" );
	trigger_wait_targetname( "trigger_encounter_2" );
	thread stealth_death_hint_technicals();
	thread change_allies_spotted_accuracy( 0.2 );
	thread get_soap_to_anim();
	level.price thread ally_can_push_player();
	level.soap thread ally_can_push_player();
	
	thread river_mantle_brush();
	thread river_technicals_encounter_ranges();
	thread river_technicals_encounter_driveby();
	wait( 2 );
	
	truck_1 = setup_river_technical( "river_technical_1" );
	wait 1.5;
	truck_2 = setup_river_technical( "river_technical_3" );
	
	level.river_technical_riders = array_combine( truck_1.riders, truck_2.riders );
	
	thread river_technicals_stop( truck_1, truck_2 );
	thread monitor_river_encounter_end();
	thread monitor_river_first_encounter_stealth();
	thread monitor_river_mantle_brush();
	thread river_technical_patroller_end();
	thread river_bird_fx();
	level.price thread river_technical_handle_ally();
	level.soap thread river_technical_handle_ally();
	
	aud_technicals = [truck_1, truck_2];
	aud_send_msg("intro_river_technicals", aud_technicals);
	
	if( !isDefined( level.river_technical_patrol ) )
	{
		level.river_technical_patrol = [];
	}
	
	flag_wait( "river_encounter_done" );
	
	wait 1;
	river_short_stealth_ranges();
	
	level notify( "enable_river_mantle" );

	flag_set( "river_technicals_move_dialogue" );
	thread price_play_log_anims();
	// wait till ally is done mantling
	trig_ally_river_mantle_done = GetEnt( "trig_ally_river_mantle_done", "targetname" );
	trig_ally_river_mantle_done waittill( "trigger" );
	flag_set( "river_stop_soap_idle" );
	thread soap_play_log_anims();
}

river_mantle_brush()
{
	mantle_brush = getent( "river_log_mantle", "targetname" );
	mantle_brush_origin = mantle_brush.origin;
	mantle_brush.origin = (0,0,0);
	
	level waittill( "enable_river_mantle" );
	river_mantle_clip = GetEnt( "river_mantle_clip", "targetname" );
	river_mantle_clip Delete();
	mantle_brush.origin = mantle_brush_origin;
}

monitor_river_mantle_brush()
{
	level endon( "river_encounter_done" );
	if ( flag( "river_encounter_done" ) )
	{
		return;
	}
	
	wait 30;
	
	flag_wait( "_stealth_spotted" );
	level notify( "enable_river_mantle" );
}

stealth_death_hint_technicals()
{
	level endon( "river_encounter_done" );
	level.player waittill( "death" );
	
	level notify( "new_quote_string" );
	SetDvar( "ui_deadquote", &"WARLORD_STEALTH_DEATH" );
}

get_soap_to_anim()
{
	org = getstruct( "org_soap_pulldown", "targetname" );
	
	org anim_reach_solo( level.soap, "africa_soap_pulldown_entrance_guy1" );
	org anim_single_solo( level.soap, "africa_soap_pulldown_entrance_guy1" );
	org thread play_soap_crouch_idle();
}

play_soap_crouch_idle()
{
	self notify( "stop_loop" );
	level.soap notify( "stop_soap_crouch_idle" );
	level.soap endon( "stop_soap_crouch_idle" );
	
	self thread anim_loop_solo( level.soap, "africa_soap_pulldown_crouch_idle_guy1", "stop_loop" );
	flag_wait_any( "river_stop_soap_idle", "_stealth_spotted" );
	self notify( "stop_loop" );
}

ally_can_push_player()
{
	// don't change goalradius if it's already smaller
	//   (for example, if the AI is in an anim_reach)
	old_radius = undefined;
	if ( self.goalradius > 32 )
	{
		old_radius = self.goalradius;
		self.goalradius = 32;
	}
	
	self PushPlayer( true );
	flag_wait_any( "river_encounter_done", "_stealth_spotted" );
	self PushPlayer( false );
	
	if ( IsDefined( old_radius ) )
	{
		self.goalradius = old_radius;
	}
}

river_technical_handle_ally()
{
	level endon( "river_encounter_done" );
	flag_wait( "_stealth_spotted" );
	self force_sidearm_on_spotted( "river_encounter_done" );
}

monitor_river_first_encounter_stealth()
{
	level endon( "river_encounter_done" );
	if ( flag( "river_encounter_done" ) )
	{
		return;
	}
	
	flag_wait( "_stealth_spotted" );
	
	flag_set( "technical_steal_broken_vo" );
	
	aud_send_msg( "mus_river_first_encounter_spotted" );
	
	// path enemies to goal volume
	river_bank_goal_volume = GetEnt( "river_bank_goal_volume", "targetname" );
	
	river_banks = [];
	river_banks[ river_banks.size ] = river_bank_goal_volume;
	
	if ( flag( "river_technicals_stop" ) )
	{
		river_far_bank_goal_volume = GetEntArray( "river_far_bank_goal_volume", "targetname" );
		foreach ( far_bank in river_far_bank_goal_volume )
		{
			river_banks[ river_banks.size ] = far_bank;
		}
	}

	foreach ( enemy_ai in level.river_technical_riders )
	{
		if ( IsDefined( enemy_ai ) && IsAlive( enemy_ai ) )
		{
			if ( river_banks.size == 1 )
			{
				enemy_ai thread path_after_vehicle_exit( river_banks[0] );
			}
			else
			{
				closest_bank = undefined;
				closest_bank_distance = undefined;
				
				foreach ( river_bank in river_banks )
				{
					bank_distance = DistanceSquared( river_bank.origin, enemy_ai.origin );
					if ( !IsDefined( closest_bank ) || ( bank_distance < closest_bank_distance ) )
					{
						closest_bank = river_bank;
						closest_bank_distance = bank_distance;
					}
				}
				
				enemy_ai thread path_after_vehicle_exit( closest_bank );
			}
		}
	}
}

path_after_vehicle_exit( goal_volume )
{
	self endon( "death" );

	if ( IsDefined( self.vehicle_position ) )
	{
		self waittill( "jumpedout" );
	}
	
	self disable_long_death();
	self SetGoalVolumeAuto( goal_volume );
}

river_technicals_encounter_ranges()
{
	level endon( "river_encounter_done" );
	if ( flag( "river_encounter_done" ) )
	{
		return;
	}
	
	thread reset_on_enemy_bad_event( "river_encounter_done" );
	level endon( "enemy_bad_event" );
	
	thread manage_overlapping_flag_trigger( "in_crouch_stealth_range", "flag_in_crouch_stealth_range", "river_encounter_done" );
	
	river_start_stealth_ranges();
	while ( true )
	{
		flag_wait( "flag_in_crouch_stealth_range" );
		river_crouch_stealth_ranges();
		flag_waitopen( "flag_in_crouch_stealth_range" );
		river_start_stealth_ranges();
	}
}

reset_on_enemy_bad_event( encounter_end_event )
{
	level endon( encounter_end_event );
	level waittill( "enemy_bad_event" );
	river_far_stealth_ranges();
}

setup_river_technical( targetname )
{
	technical = spawn_vehicle_from_targetname_and_drive( targetname );
	technical ent_flag_init( "no_unload_zone" );
	technical thread scan_while_stealth();
	technical thread unload_on_spotted();
	technical thread manage_unloading();
	technical thread vehicle_turret_no_ai_detach();
	technical thread kill_gunner_if_cant_shoot();
	return technical;
}

kill_gunner_if_cant_shoot()
{
	self endon( "death" );
	
	waittillframeend;
	
	gunner = undefined;
	foreach ( rider in self.riders )
	{
		if ( rider.vehicle_position == 1 )
		{
			gunner = rider;
		}
	}
	
	gunner endon( "death" );
	gunner ent_flag_waitopen( "_stealth_normal" );
	
	while ( IsDefined( self.mgturret[0] ) )
	{
		self.mgturret[0] waittill( "turretstatechange" );
		if ( self.mgturret[0].doFiring )
		{
			gunner notify( "dont_kill_me" );
		}
		else
		{
			gunner thread magic_bullet_kill_after_time( 5 );
		}
	}
}

magic_bullet_kill_after_time( wait_time )
{
	self endon( "death" );
	self endon( "dont_kill_me" );
	wait wait_time;
	
	while ( true )
	{
		target = self GetEye();
		
		ally = undefined;
		if ( CoinToss() )
		{
			ally = level.price;
		}
		else
		{
			ally = level.soap;
		}
		ally_eye = ally GetEye();
		MagicBullet( ally.weapon, ally_eye, target );
		wait 0.1;
	}
}

vehicle_turret_no_ai_detach()
{
	foreach ( turret in self.mgturret )
	{
		turret setTurretCanAiDetach( false );
	}
	
	foreach ( rider in self.riders )
	{
		if ( rider.vehicle_position == 1 )
		{
			rider thread watch_for_flashbang( self );
		}
	}
}

watch_for_flashbang( vehicle )
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "flashed" );
		
		// want to thread it so guy can get flashed while still reacting to the last flash
		if ( IsDefined( vehicle ) && IsDefined( vehicle.mgturret ) )
		{
			vehicle.mgturret[0] thread disable_turret_for_time( 3, self );
		}
	}
}

disable_turret_for_time( disable_time, gunner )
{
	self endon( "death" );
	
	self notify( "disable_turret_for_time" );
	self endon( "disable_turret_for_time" );

	// use shared field for it since TurretFireDisable can be called
	//   from other script	
	self set_shared_field_value( "TurretFireDisable" );
	gunner waittill_notify_or_timeout( "death", disable_time );
	self unset_shared_field_value( "TurretFireDisable" );
}

// if stealth is broken, set the river_technicals_gone flag manually
//   if all technicals destroyed
monitor_river_encounter_end()
{
	level endon( "river_encounter_done" );
	
	// wait til all guys killed
	any_guy_alive = true;
	while ( any_guy_alive )
	{
		any_guy_alive = false;
		foreach ( enemy_ai in level.river_technical_riders )
		{
			if ( !enemy_ai ent_flag_exist( "river_passenger_patrol_done" ) || !enemy_ai ent_flag( "river_passenger_patrol_done" ) )
			{
				any_guy_alive = any_guy_alive || IsAlive( enemy_ai );
			}
		}
		
		wait 0.05;
	}
	
	flag_waitopen( "_stealth_spotted" );
	aud_send_msg( "mus_river_first_encounter_all_clear" ); // has to go before flag_set( "river_encounter_done" ) below, or the thread will "endon".
	wait 1;
	flag_set( "river_encounter_done" );
}

scan_while_stealth()
{
	scan_mgturret( 10, 60, -45, 45 );
	
	// turn firing back on if no longer scanning
	if ( IsDefined( self ) && IsDefined( self.mgturret[0] ) )
	{
		if ( IsDefined( self.dummy_turret_target ) )
		{
			self.dummy_turret_target Delete();
		}
		
		self.mgturret[0] unset_shared_field_value( "TurretFireDisable" );
	}
}

river_technicals_stop( truck_1, truck_2 )
{
	truck_1 endon( "stealth_broken_unload" );
	truck_2 endon( "stealth_broken_unload" );

	flag_wait( "river_technical_stopped" );
	
	// make sure unload_on_spotted can unload before this can unload
	waittillframeend;
	truck_1 thread unload_patroller( "river_passenger_path_1", 0.05 );
	wait 0.1;
	truck_2 thread unload_patroller( "river_passenger_path_2", 0.2 );
	
	wait_to_cross_road();
	
	// make sure trucks have drivers before going
	driver_1 = truck_1 get_driver();
	driver_2 = truck_2 get_driver();
	if ( IsDefined( driver_1 ) && IsAlive( driver_1 ) &&
		 IsDefined( driver_2 ) && IsAlive( driver_2 ) )
	{
		flag_set( "river_technicals_stop" );
	}
	
	flag_wait( "river_technicals_stop" );
	thread maps\warlord_fx::intro_truck_splash_vfx();

	// position guys for pulldown kill
	anim_reach_pulldown_kill();
	
	// thread it off so kill can't be interrupted past this point
	thread play_pulldown_kill();
}

wait_to_cross_road()
{
	// wait for the guy to jump out and be defined, etc
	wait( 7 );
	
	if ( IsDefined( level.river_patroller ) )
	{
		// make sure if the patroller is still alive, he's out of the way of the road
		level.river_patroller endon( "death" );
		flag_wait( "river_passenger_wait" );
	}
}

anim_reach_pulldown_kill()
{
	if ( !IsDefined( level.pulldown_guy ) || !IsAlive( level.pulldown_guy ) )
	{
		return;
	}
	
	if ( !level.pulldown_guy ent_flag( "_stealth_normal" ) )
	{
		return;
	}
	
	level.pulldown_guy endon( "death" );
	level.pulldown_guy endon( "_stealth_normal" );
	
	org = getstruct( "org_soap_pulldown", "targetname" );
	
	// path pulldown guy separately, soap should already be in position if nothing went wrong
	org anim_reach_solo( level.pulldown_guy, "river_pulldown" );
	
	guys = [];
	guys[ 0 ] = level.soap;
	guys[ 1 ] = level.pulldown_guy;
	
	soap_ready = org check_anim_reached( level.soap, "river_pulldown" );
	enemy_ready = org check_anim_reached( level.pulldown_guy, "river_pulldown" );
	while ( !soap_ready || !enemy_ready )
	{
		// make sure everyone is in a good position
		if ( !soap_ready && !enemy_ready )
		{
			org anim_reach( guys, "river_pulldown" );
		}
		else if ( !soap_ready )
		{
			org anim_reach_solo( level.soap, "river_pulldown" );
		}
		else if ( !enemy_ready )
		{
			org anim_reach_solo( level.pulldown_guy, "river_pulldown" );
		}
		
		soap_ready = org check_anim_reached( level.soap, "river_pulldown" );
		enemy_ready = org check_anim_reached( level.pulldown_guy, "river_pulldown" );
	}
}

play_pulldown_kill()
{
	org = getstruct( "org_soap_pulldown", "targetname" );
	guys = [];
	guys[ 0 ] = level.soap;
	guys[ 1 ] = level.pulldown_guy;
	
	if ( isAlive( level.pulldown_guy ) && !level.pulldown_guy doingLongDeath() &&
		 level.pulldown_guy ent_flag( "_stealth_normal" ) )
	{
		org notify( "stop_loop" );
		level.pulldown_guy disable_stealth_for_ai();
		// wait for stealth to be turned off for AI
		waittillframeend;
		
		// need to check again in case he's dying this frame
		if ( isAlive( level.pulldown_guy ) && !level.pulldown_guy doingLongDeath() )
		{
			// notify threads to end
			level.pulldown_guy notify( "start_pulldown_guy_kill" );
			
			level.pulldown_guy thread set_battlechatter( false );
			level.pulldown_guy.ignoreall = true;
			level.pulldown_guy.allowdeath = false;
			level.pulldown_guy setFlashbangImmunity( true );
			org anim_single( guys, "river_pulldown" );
			level.pulldown_guy kill_no_react();
		}
	}
	
	org thread play_soap_crouch_idle();
	level.soap enable_ai_color_dontmove();
}

unload_patroller( patrol_path, start_delay )
{
	self endon( "death" );
	
	unloaded_ai = self vehicle_unload( "passengers" );
	patroller = unloaded_ai[0];
	if ( IsDefined( patroller ) )
	{
		patroller waittill( "jumpedout" );
		if ( IsDefined( start_delay ) && start_delay > 0 )
		{
			wait start_delay;
		}
		patroller.script_parameters = patrol_path;
		
		anim_override = undefined;
		disableArrivals = undefined;
		disableExits = undefined;
		
		if ( patroller.script_parameters == "river_passenger_path_1" )
		{
			level.pulldown_guy = patroller;
			level.pulldown_guy.animname = "militia";
			level.pulldown_guy thread pulldown_change_run_anim();
			disableArrivals = true;
		}
		else
		{
			level.river_patroller = patroller;
		}
		
		patroller thread patroller_logic(anim_override);
		patroller thread river_technical_patroller_setup(anim_override, disableArrivals, disableExits);
	}
}

river_technical_patroller_setup( anim_override, disableArrivals, disableExits )
{	
	self endon( "death" );
	wait( 0.05 );
	self.animname = "militia";
	if(!isdefined(anim_override))
		self clear_run_anim();
	self.alertlevel = "alert";
	if(!isdefined(anim_override))
	{
		self.goalradius = 8;
		self thread enable_cqbwalk();
	}
	self.disablearrivals = disableArrivals;
	self.disableexits = disableExits;
	self ent_flag_init( "river_passenger_patrol_done" );
	level.river_technical_patrol = array_add( level.river_technical_patrol, self );
}

pulldown_change_run_anim()
{
	level endon( "_stealth_spotted" );
	self endon( "death" );
	self thread switch_run_on_alert();
	wait( 2.5 );
	self clear_run_anim();
	self disable_cqbwalk();
	self set_run_anim( "pulldown_walk" );
}

switch_run_on_alert()
{
	// kill thread on death or if pulldown anim starts
	self endon( "death" );
	self endon( "start_pulldown_guy_kill" );
	
	flag_wait( "_stealth_spotted" );
	self anim_stopanimscripted();
	self clear_run_anim();
	self enable_cqbwalk();
}

river_technical_patroller_end()
{
	flag_wait( "river_encounter_done" );
	
	foreach ( patroller in level.river_technical_patrol )
	{
		if ( IsDefined( patroller ) && IsAlive( patroller ) )
		{
			// so AI isn't surprised by exiting patroller
			patroller.ignoreme = 1;
			patroller.ignoreall = 1;
		}
	}
	
	ai_delete_when_out_of_sight( level.river_technical_patrol, 256 );
}

manage_unloading()
{
	self endon( "death" );
	self endon( "stealth_broken_unload" );
	
	self disable_unloading();
	flag_wait( "river_technical_stopped" );
	self enable_unloading();
	flag_wait( "river_technicals_stop" );
	self disable_unloading();
	wait 5.7;
	self enable_unloading();
}

disable_unloading()
{
	if ( IsDefined( self ) && IsAlive( self ) )
	{
		self SetCanDamage( false );
		self thread make_driver_invul();
		self ent_flag_set( "no_unload_zone" );
	}
}

enable_unloading()
{
	if ( IsDefined( self ) && IsAlive( self ) )
	{
		self SetCanDamage( true );
		self thread end_make_driver_invul();
		self ent_flag_clear( "no_unload_zone" );
	}
}

river_technicals_encounter_driveby()
{
	wait( 4 );
	if ( stealth_is_everything_normal() )
	{
		flag_set( "river_technical_dialogue" );
		
		level.price set_shared_field_value( "ignoreall" );
		level.soap set_shared_field_value( "ignoreall" );
		
		thread should_show_crouch();
		
		aud_send_msg( "mus_river_first_encounter_start" );
		
		wait_til_ally_should_stop_hiding();
		
		level.price unset_shared_field_value( "ignoreall" );
		level.soap unset_shared_field_value( "ignoreall" );
	}
}

should_show_crouch()
{
	level endon( "_stealth_spotted" );
	level endon( "river_encounter_done" );
	
	if( flag( "_stealth_spotted" ) )
	{
		return;
	}
	
	flag_wait( "flag_in_crouch_stealth_range" );
	
	stance = level.player GetStance();
		
	if ( stance == "stand" )
	{
		thread display_hint_from_map( "crouch" );
	}
}

get_hint_from_map( hint_key )
{
	hint_list = level.hint_binding_map[ hint_key ];
	foreach ( hint_pair in hint_list )
	{
		binding = getKeyBinding( hint_pair[0] );
		if ( !binding[ "count" ] )
			continue;
			
		return hint_pair[1];
	}
	
	return undefined;
}

display_hint_from_map( hint_key )
{
	level notify( "end_display_hint_from_map" );
	level endon( "end_display_hint_from_map" );	
	
	hint_string = get_hint_from_map( hint_key );
	if ( IsDefined( hint_string ) )
	{
		display_hint( hint_string );
		
		if ( !level.Console )
		{
			level.player ent_flag_wait( "global_hint_in_use" );
			while ( level.player ent_flag( "global_hint_in_use" ) )
			{
				if ( IsDefined( level.current_hint ) )
				{
					hint_string = get_hint_from_map( hint_key );
					if ( IsDefined( hint_string ) && IsDefined( level.trigger_hint_string[ hint_string ] ) )
					{
						level.current_hint SetText( level.trigger_hint_string[ hint_string ] );
					}
					else
					{
						level.current_hint SetText( "" );
					}
				}
				
				wait 0.05;
			}
		}
	}
}

no_crouch_hint()
{
	stance = level.player GetStance();
	if ( stance != "stand" )
	{
		level notify( "end_display_hint_from_map" );
		return true;
	}
	
	if ( flag( "_stealth_spotted" ) )
	{
		level notify( "end_display_hint_from_map" );
		return true;
	}
	
	if( !flag( "flag_in_crouch_stealth_range" ) )
	{
		level notify( "end_display_hint_from_map" );
		return true;
	}
	
	return false;
}

river_bird_fx()
{
	flag_wait( "river_birds" );
	wait( 0.5 );
	org = getstruct( "org_bird_fx", "targetname" );
	forward = AnglesToForward( org.angles );
	up_vector = AnglesToUp( org.angles );
	
	PlayFx( getfx( "bird_takeoff" ), org.origin, forward, up_vector );
}

wait_til_ally_should_stop_hiding()
{
	level endon( "_stealth_spotted" );
	flag_wait( "river_encounter_done" );
}

restore_player_run_speed()
{
	trigger_wait_targetname( "trig_player_out_of_water" );
	
	player_speed_percent( 100 );
	level.player AllowSprint( true );
}


//////////////////
// prone encounter
//////////////////

price_play_log_anims()
{
	activate_trigger_with_targetname( "trig_move_price_to_prone_log" );
	
	org = getstruct( "org_log_duck", "targetname" );
	org anim_reach_solo( level.price, "price_log_duck" );
	org anim_single_solo_run( level.price, "price_log_duck" );
	level.price enable_ai_color_dontmove();
	
	if ( !flag( "river_encounter_3_complete" ) )
	{
		// price hand signal
		org = getstruct( "org_river_price_handsignal", "targetname" );
		org anim_reach_solo( level.price, "CornerStndR_alert_signal_enemy_spotted" );
		flag_set( "price_past_log" );
		if ( org check_anim_reached( level.price, "CornerStndR_alert_signal_enemy_spotted" ) )
		{
			// if not at correct pos, just skip (can happen if you beat the enc really quickly)
			org anim_single_solo( level.price, "CornerStndR_alert_signal_enemy_spotted" );
		}
		level.price enable_ai_color_dontmove();
	}
	
	wait 0.05;
	flag_set( "price_ready_to_reach_door" );
}

soap_play_log_anims()
{
	activate_trigger_with_targetname( "trig_move_soap_to_prone_log" );
	
	org = getstruct( "org_log_duck", "targetname" );
	org anim_reach_solo( level.soap, "soap_log_duck" );
	org anim_single_solo_run( level.soap, "soap_log_duck" );
	activate_trigger_with_targetname( "trig_post_log_duck" );
	level.soap enable_cqbwalk();
	level.soap enable_ai_color();
	
	wait 0.05;
	flag_set( "soap_ready_to_reach_door" );
}

river_prone_encounter()
{
	flag_init( "interrupt_body_toss" );
	flag_init( "log_encounter_audio" );
	flag_wait( "river_prone_encounter_spawn" );
	aud_send_msg("river_prone_encounter");
	
	// this is to possibly fix a rare bug in which the "pain" animscript can turn off ignoreme
	//   if given the right set of steps.  Not full-proof, but should be very rare now.  heh.
	// (spotted in encounter before, ally in pain animscript, encounter finished, pain animscript ends)
	level.price enforce_shared_field_value( "ignoreme" );
	level.soap enforce_shared_field_value( "ignoreme" );
	
	flag_init("river_encounter_3_guy_1_dead");

	thread monitor_river_prone_encounter_stealth();
	thread river_prone_encounter_ranges();
	thread price_sees_enemy();
	thread dog_eat();
	thread burn_body_pile();
	thread check_prone_encounter_well_done();
	
	// prone log patrol
	spawners = GetEntArray( "enemy_spawner_stealth_prone", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::set_grenadeammo, 0 );
	array_thread( spawners, ::add_spawn_function, ::river_prone_encounter_guys_detect_death );
	array_thread( spawners, ::add_spawn_function, ::setup_body_toss_guys );
	array_thread( spawners, ::add_spawn_function, ::monitor_stealth_audio );
	guys = array_spawn( spawners, true );
	
	thread prone_guys_anim( guys );
}

dog_eat()
{
	dog_spawner = getent( "river_house_dog", "targetname" );
	dog = dog_spawner spawn_ai();
	dog.animname = "dog";
	dog.ignoreme = true;
	dog.allowdeath = true;
	
	dog endon( "death" );
	
	//guy_spawner = getent( "hyena_eat_corpse", "targetname" );
	//guy = guy_spawner spawn_ai( true );
	//guy_dummy = maps\_vehicle_aianim::convert_guy_to_drone( guy );
	//guy_dummy.animname = "generic";
	
	//guys = [];
	//guys[0] = dog;
	//guys[1] = guy_dummy;
	
	org = getstruct( "org_river_house_dog", "targetname" );
	dog thread monitor_eat_anim( org );
	dog thread maps\warlord_fx::hyena_village_fx();
	org anim_loop_solo( dog, "dog_eat", "stop_eat_loop" );
	
	
	if( isDefined( dog ) && isAlive( dog ) )
	{
		dog anim_single_solo( dog, "dog_growl" );
		node = getnode( "hyena_node", "targetname" );
		dog.goalradius = 8;
		dog set_goal_node( node );
		dog waittill( "goal" );
		if( isDefined( dog ) && isAlive( dog ) )
		{
			dog delete();
		}
	}
}

monitor_eat_anim( org )
{
	self wait_for_death_or_distance();
	org notify( "stop_eat_loop" );
	self anim_stopanimscripted();
}

wait_for_death_or_distance()
{
	//self = the dog
	self endon( "death" );
	level endon( "player_close_to_dog" );
	
	while( 1 )
	{
		dist = distance( level.player.origin, self.origin );
		if( dist < 350 )
		{
			level notify( "player_close_to_dog" );
		}
		wait( 0.05 );
	}
}

burn_body_pile()
{
	anims = [];
	anims[0] = "africa_burnbody_1";
	anims[1] = "africa_burnbody_2";
	anims[2] = "africa_burnbody_3";
	anims[3] = "africa_burnbody_4";
	anims[4] = "africa_burnbody_5";
	
	spawner = getent( "body_toss_corpse_pile_guy", "targetname" );
	org = getstruct( "org_body_toss_fire_pile", "targetname" );
	
	for( i = 0; i < 5; i++ )
	{
		guy = spawner spawn_ai( true );
		dummy = maps\_vehicle_aianim::convert_guy_to_drone( guy );
		dummy notsolid();
		dummy.animname = "generic";
		dummy thread drone_wait_to_delete();
		org thread anim_loop_solo( dummy, anims[i] );
		wait( 0.05 );
	}
}

prone_guys_anim( guys )
{
	org = getstruct( "org_body_toss_fire", "targetname" );
	spawner_1 = getent( "body_toss_corpse_1", "targetname" );
	spawner_2 = getent( "body_toss_corpse_2", "targetname" );
	
	// probably could spawn drone directly if needed
	civ_1 = spawner_1 spawn_ai( true );
	civ_1_dummy = maps\_vehicle_aianim::convert_guy_to_drone( civ_1 );
	civ_1_dummy.animname = "civ_1";
	
	civ_2 = spawner_2 spawn_ai( true );
	civ_2_dummy = maps\_vehicle_aianim::convert_guy_to_drone( civ_2 );
	civ_2_dummy.animname = "civ_2";
	
	civ_dummies = [ civ_1_dummy, civ_2_dummy ];
	
	foreach ( dummy in civ_dummies )
	{
		dummy NotSolid();
		dummy.anim_interrupt_state = "pause";
	}
	
	guys[0] gun_remove();
	guys[0] thread do_burn_carry_anim( org, civ_1_dummy, civ_2_dummy );
	guys[1] thread do_watch_anim( org );
	thread burn_pile_dialogue( guys[0], guys[1] );
	guys[0] thread stop_vo_on_interrupt();
	guys[1] thread stop_vo_on_interrupt();
	flag_wait( "interrupt_body_toss" );
	
	org notify( "stop_loop" );
	
	foreach ( dummy in civ_dummies )
	{
		if ( dummy.anim_interrupt_state == "pause" )
		{
			// pause at current anim time
			dummy_anim = dummy getanim( "burn_dragger_drag" );
			anim_time = dummy GetAnimTime( dummy_anim );
			dummy anim_stopanimscripted();
			dummy SetAnim( dummy_anim, 1, 0, 0 );
			dummy SetAnimTime( dummy_anim, anim_time );
		}
		else
		{
			// stop and ragdoll
			dummy anim_stopanimscripted();
			dummy StartRagdoll();
		}
	}
	
	if ( IsAlive( guys[ 0 ] ) )
	{
		guys[0] gun_recall();
		guys[0] anim_stopanimscripted();
	}
	
	if ( IsAlive( guys[ 1 ] ) )
	{
		guys[1] anim_stopanimscripted();
	}
}

burn_pile_dialogue( guy_1, guy_2)
{
	level endon( "interrupt_body_toss" );
	wait( 2 );
	//Militia 1: Did you know Hadams was killed last week?
	guy_1 dialogue_queue( "warlord_mlt1_didyouknow" );
	//Militia 2: Oh really?
	guy_2 dialogue_queue( "warlord_mlt2_ohreally" );
	//Militia 1: Walked right into the middle of one of Waraabe's foreign deals.
	guy_2 dialogue_queue( "warlord_mlt1_walkedright" );
	//Militia 1: Waraabe popped him twice without even looking.
	guy_1 dialogue_queue( "warlord_mlt1_poppedhim" );
	//Militia 3: No shit! Yeah, Hadams was an idiot.
	guy_2 dialogue_queue( "warlord_mlt3_wasanidiot" );
}

stop_vo_on_interrupt()
{
	level waittill( "interrupt_body_toss" );
	if( isDefined( self ) && isAlive( self ) )
	{
		self StopSounds();
	}
}

do_burn_carry_anim( org, civ_1_dummy, civ_2_dummy )
{
	self endon( "death" );
	level endon( "interrupt_body_toss" );
	
	burn_guys = [];
	burn_guys[0] = self;
	burn_guys[1] = civ_1_dummy;
	burn_guys[2] = civ_2_dummy;
	
	level thread change_anim_interrupt_state( civ_1_dummy, civ_2_dummy );
	
	org anim_single( burn_guys, "burn_dragger_drag" );
	org anim_loop_solo( self, "burn_dragger_idle", "stop_loop" );
}

change_anim_interrupt_state( civ_1_dummy, civ_2_dummy )
{
	level endon( "interrupt_body_toss" );
	
	wait ( ( 233-105 ) / 30 );
	civ_2_dummy.anim_interrupt_state = "";
	wait ( ( 527-233 ) / 30 );
	civ_2_dummy.anim_interrupt_state = "pause";
	wait ( ( 744-527 ) / 30 );
	civ_1_dummy.anim_interrupt_state = "";
	wait ( ( 1020-744) / 30 );
	civ_1_dummy.anim_interrupt_state = "pause";
}

do_watch_anim( org )
{
	self endon( "death" );
	level endon( "interrupt_body_toss" );
	
	org anim_single_solo( self, "burn_watcher_watch" );
	org thread anim_loop_solo( self, "burn_watcher_idle", "stop_loop" );
}

setup_body_toss_guys()
{
	level endon( "interrupt_body_toss" );
	self.animname = "militia";
	self.allowdeath = true;
	wait_for_alerted_or_death();
	flag_set( "interrupt_body_toss" );
}

wait_for_alerted_or_death()
{
	self endon( "death" );
	
	if ( !self ent_flag( "_stealth_bad_event_listener" ) )
	{
		self endon( "_stealth_bad_event_listener" );
	}

	self endon( "flashbang" );
	self ent_flag_waitopen( "_stealth_normal" );
}

monitor_river_prone_encounter_stealth()
{
	level endon( "river_encounter_3_complete" );
	if ( flag( "river_encounter_3_complete" ) )
	{
		return;
	}
	
	flag_wait( "log_encounter_audio" );
	aud_send_msg( "mus_take_them_out_busted" );
}

monitor_stealth_audio()
{
	level endon( "log_encounter_audio" );
	
	self ent_flag_waitopen( "_stealth_normal" );
	flag_set( "log_encounter_audio" );
}

river_prone_encounter_ranges()
{
	level endon( "river_encounter_3_complete" );
	if ( flag( "river_encounter_3_complete" ) )
	{
		return;
	}
	
	// allies are default accuracy for this encounter
	thread change_allies_spotted_accuracy( 0.2 );
	thread reset_on_enemy_bad_event( "river_encounter_3_complete" );
	level endon( "enemy_bad_event" );
	
	river_short_stealth_ranges();
	while ( true )
	{
		flag_wait( "flag_in_crouch_stealth_range" );
		river_crouch_stealth_ranges();
		flag_waitopen( "flag_in_crouch_stealth_range" );
		river_far_stealth_ranges();
	}
}

price_sees_enemy()
{
	level endon( "price_dont_talk" );
	level endon( "river_encounter_3_complete" );
	
	flag_wait( "price_past_log" );
	
	aud_send_msg( "mus_take_them_out" );
	
	if ( stealth_is_everything_normal() )
	{
		flag_set( "prone_encounter_start_dialogue" );
	}
}

river_prone_encounter_guys_detect_death()
{
	self waittill( "death", attacker );
	level notify( "price_dont_talk" );
	if ( flag( "river_encounter_3_guy_1_dead") )
	{
		aud_send_msg( "mus_take_them_out_all_clear" );
		wait 1; //make sure the bullet noises are done and whatnot, so alert levels will stick
		flag_set( "river_encounter_3_complete" );
	}
	else
	{
		flag_set( "river_encounter_3_guy_1_dead" );
	}
}

check_prone_encounter_well_done()
{
	flag_wait( "interrupt_body_toss" );
	start_encounter_time = GetTime();
	flag_wait( "river_encounter_3_complete" );
	encounter_length = GetTime() - start_encounter_time;
	if ( encounter_length < 4000 )
	{
		flag_set( "prone_encounter_well_done_dialogue" );
	}
}

setup_jeer_guys()
{
	river_guys_spawners = GetEntArray( "river_near_patrol", "targetname" );
	array_thread( river_guys_spawners, ::add_spawn_function, ::setup_river_big_moment_guys );
	level.river_patrol_1 = array_spawn( river_guys_spawners, true );
	level.river_patrol_1 thread play_jeer_anims();
}

play_jeer_anims()
{
	foreach ( guy in self )
	{
		guy.ignoreme = true;
		guy.allowDeath = true;
		guy set_battlechatter( false );
		
		org = getstruct( guy.script_noteworthy, "targetname" );
		
		jeer_loop = undefined;
		if ( guy.script_noteworthy == "river_jeer_1" || guy.script_noteworthy == "river_jeer_3" )
		{
			jeer_loop = "jeer_loop_3";
		}
		else
		{
			jeer_loop = "jeer_loop_2";
		}
		
		guy thread play_jeer_loop( org, jeer_loop );
		guy thread monitor_jeer_guys();
	}
}

play_jeer_loop( org, anime )
{
	self endon( "death" );
	
	org thread anim_generic_loop( self, anime, "stop_loop" );
	
	self waittill( "stop_jeer_loop" );
	org notify( "stop_loop" );
	self anim_stopanimscripted();
}

monitor_jeer_guys()
{
	self endon( "death" );
	
	thread jeer_guy_leave();
	
	self wait_for_alerted_or_death();
	self notify( "stop_jeer_loop" );
	self notify( "stop_jeer_patrol" );
	self.ignoreme = false;
	self.ignoreall = false;
}

jeer_guy_leave()
{
	level endon( "clean_up_river" );
	self endon( "death" );
	self endon( "stop_jeer_patrol" );
	
	flag_wait( "jeer_guy_leave" );
	
	if ( IsDefined( self.script_parameters ) )
	{
		self notify( "stop_jeer_loop" );
		self thread patroller_logic();
	}
}

river_house_door()
{
	flag_wait( "river_encounter_3_complete" );
	
	// path allies
	activate_trigger_with_targetname( "trig_price_path_to_dog_house" );
	activate_trigger_with_targetname( "trig_soap_path_to_dog_house" );
	
	// wait to make sure the color goal is set before pathing them
	//   anywhere else.
	wait 0.05;

	flag_wait( "price_ready_to_reach_door" );
	flag_wait( "soap_ready_to_reach_door" );
	
	level.soap thread go_to_node_with_targetname( "node_soap_river_stand" );
	
	org_door = getent( "org_price_river_open_door", "targetname" );
	org_door anim_reach_and_approach_solo( level.price, "sniper_open_door", undefined, "Cover Right" );
	flag_wait( "river_house_door_open" );
	
	//truck = spawn_vehicle_from_targetname( "burn_truck" );
	//truck SetCanDamage( true );
	
	while ( !org_door check_anim_reached( level.price, "sniper_open_door" ) || level.price isFlashed() )
	{
		if ( level.price isFlashed() )
		{
			flash_left = level.price.flashEndTime - gettime();
			wait ( flash_left / 1000 );
		}
		
		org_door anim_reach_and_approach_solo( level.price, "sniper_open_door", undefined, "Cover Right" );
	}
	
	flag_set( "river_house_burn_execution_setup" );
	door = getent( "river_house_door", "targetname" );
	door thread delayed_door_open_slow_wide( 0.75 );
	door thread close_river_door();
	org_door anim_single_solo( level.price, "sniper_open_door" );
	level.price enable_ai_color_dontmove();
	level.price enable_cqbwalk();
	level.soap enable_cqbwalk();
	level.soap thread ally_get_to_burn( "soap_burn_in", "soap_burn_idle", "soap_burn_out" );
	level.price thread ally_get_to_burn( "price_burn_in", "price_burn_idle", "price_burn_out" );
	flag_set( "river_house_burn_execution" );
	// reset player's friendlyfire points (so if you aim for and kill the civ, it will fail)
	level.player.participation = 0;
}

close_river_door()
{
	flag_wait( "flag_player_first_beat" );
	self shut_open_door_wide();
}

ally_get_to_burn( anime_in, anime_idle, anime_out )
{
	org = getstruct( "org_watch_burn_anims", "targetname" );
	
	old_collision = self SetContents( 0 );
	org anim_reach_solo( self, anime_in );
	self SetContents( old_collision );
	self enable_ai_color();
	if ( org check_anim_reached( self, anime_in ) && !flag( "river_burn_interrupted" ) )
	{
		org anim_single_solo( self, anime_in );
		if ( !flag( "river_burn_interrupted" ) )
		{
			org thread anim_loop_solo( self, anime_idle, "stop_burn_idle" );
		}
		wait_for_burn_to_end();
		
		org notify( "stop_burn_idle" );
		if( flag( "river_house_burn_anim_finished" ) )
		{
			org thread anim_single_solo( self, anime_out );
		}
		else
		{
			self anim_stopanimscripted();
		}
	}
}

wait_for_burn_to_end()
{
	flag_wait_any( "allies_path_to_big_moment", "river_burn_interrupted" );
}

village_corpse()
{
	flag_wait( "river_prone_encounter_spawn" );
	spawner = getent( "civ_village_corpse", "targetname" );
	org = getstruct( spawner.target, "targetname" );
	spawner thread corpse_setup( org, org.animation );
}

burn_ambient_walk()
{
	flag_wait( "river_house_burn_ambient_guys" );
	civ_spawn = getent( "burn_ambient_civ", "targetname" );
	civ_spawn add_spawn_function( ::monitor_ambient_civ, "civilian_run_hunched_C" );
	guy_spawn = getent( "burn_ambient_militia", "targetname" );
	guy_spawn add_spawn_function( ::monitor_ambient_guy );
	
	civ = civ_spawn spawn_ai();
	//wait( 0.5 );
	level.burn_guard = guy_spawn spawn_ai();
}

monitor_ambient_civ( run )
{
	self endon( "death" );
	self set_generic_run_anim( "civ_captured" );
	flag_wait_any( "river_house_burn_anim_finished", "river_burn_interrupted" );
	self set_generic_run_anim( run );
	fov_var = GetDVarInt( "cg_fov" );
	angle = cos( fov_var );
	while( within_fov_of_players( self.origin, angle ) )
	{
		wait( 0.05 );
	}
	self delete();
}
   
monitor_ambient_guy()
{
	self endon( "death" );
	level endon( "river_burn_interrupted" );
	
	self.moveplaybackrate = 0.9;
	self set_generic_run_anim( "casual_killer_walk_f" );

	flag_wait( "river_house_burn_anim_finished" );
	
	fov_var = GetDVarInt( "cg_fov" );
	angle = cos( fov_var );
	while( within_fov_of_players( self.origin, angle ) )
	{
		wait( 0.05 );
	}
	self delete();
}
   

// burn setup
river_house_burn_execution()
{
	level endon( "river_burn_interrupted" );
	level endon( "house_burn_watchers_dead" );
	
	flag_init( "allies_path_to_big_moment" );
	flag_wait( "river_house_burn_execution_setup" );
	
	// set ranges and wait a frame before spawning ai
	thread river_burn_ranges();
	wait 0.05;
	
	// setup jeer guys during the burn encounter;  otherwise they can detect
	//   bullets and stuff from the log encounter and cause stealth to be broken
	//   immediately going to burn encounter
	thread setup_jeer_guys();
	thread river_house_burn_watchers();
	thread river_burn_dialogue();
	thread river_burn_music();
	thread river_burn_handle_allies();

	// set up animation
	spawner_1 = getent( "burn_victim", "targetname" );
	spawner_2 = getent( "burn_badguy", "targetname" );
	org = getstruct( "org_burn", "targetname" );
	
	victim = spawner_1 spawn_ai( true );
	victim.animname = "victim";
	victim.allowdeath = true;
	victim SetModel( "africa_civ_male_notburned" );
	badguy = spawner_2 spawn_ai( true );
	badguy.animname = "militia";
	badguy.allowdeath = true;
	badguy set_generic_run_anim( "london_dock_soldier_walk" );
	badguy thread monitor_river_burn_interrupted();
	badguy thread ignoreme_while_stealth();
	thread monitor_burn_scene( badguy );
	
	guys = [];
	guys[ 0 ] = victim;
	guys[ 1 ] = badguy;
	
	victim thread handle_burn_victim();

	thread handle_attachments( badguy );
	org thread anim_single( guys, "burn" );

	wait 0.05;
	anim_set_time( guys, "burn", 0.40 );
	anim_set_rate( guys, "burn", 0 );
	
	flag_wait( "river_house_burn_execution" );
	//childthread burn_actors_dialogue( victim, badguy );
	childthread maps\warlord_fx::gas_can_fx( guys[ 1 ],victim);
	
	// start playing the scene
	anim_set_rate( guys, "burn", 1 );
	
	badguy thread unlink_gas_can_notify();
	
	// wait for burn anim to finish
	org waittill( "burn" );
	flag_set( "river_house_burn_anim_finished" );
	if( isAlive( badguy ) )
	{
		badguy thread smooth_patrol_transition();
		badguy thread go_to_node_with_targetname( "militia_house_burn_node" );
		wait( 10 );
		flag_set( "allies_path_to_big_moment" );
	}
}

burn_actors_dialogue( victim, badguy )
{
	flag_wait( "river_house_burn_execution" );
	//Militia 2: You thought you could outsmart us? Hide from us?
	badguy dialogue_queue( "warlord_mlt2_outsmart" );
	//Civilian: No! No, it's not like that please…
	victim dialogue_queue( "warlord_civ_notlikethat" );
	
	flag_wait( "victim_burn_vo" );
	//Civilian: NOOOO!!! AHHHH! (Pain screams)
	victim dialogue_queue( "warlord_civ_scream" );
}


river_burn_handle_allies()
{
	level endon( "allies_path_to_big_moment" );
	level waittill( "river_burn_interrupted" );
		
	level.price thread force_sidearm_on_spotted( "allies_path_to_big_moment" );
	level.soap thread force_sidearm_on_spotted( "allies_path_to_big_moment" );
}

force_sidearm_on_spotted( in_flag )
{
	self AllowedStances( "stand" );
	self.forceSideArm = true;
	flag_wait( in_flag );
	self AllowedStances( "stand", "crouch", "prone" );
	self.forceSideArm = undefined;
}

smooth_patrol_transition()
{
	self endon( "death" );
	
	// after coming out of animation, animscript wants to put him in crouch for some reason,
	//   and wants to play a transition out of cover.  turn it off until you start the custom run.
	self AllowedStances( "stand" );
	self.disableExits = true;
	wait 0.1;
	self.disableExits = undefined;
	self AllowedStances( "stand", "crouch", "prone" );
}

unlink_gas_can_notify()
{
	self endon( "death" );
	
	// TODO: should be moved to notetrack
	wait 15;
	self notify( "unlink_gas_can" );
}

river_burn_ranges()
{
	level endon( "allies_path_to_big_moment" );
	if ( flag( "allies_path_to_big_moment" ) )
	{
		return;
	}
	
	// allies are default accuracy for this encounter
	thread change_allies_spotted_accuracy( 0.2 );
	thread reset_on_enemy_bad_event( "allies_path_to_big_moment" );
	level endon( "enemy_bad_event" );
	
	river_far_stealth_ranges();
	while ( true )
	{
		flag_wait( "flag_in_short_stealth_range" );
		river_short_stealth_ranges();
		flag_waitopen( "flag_in_short_stealth_range" );
		river_far_stealth_ranges();
	}
}

monitor_river_burn_interrupted()
{
	self endon( "death" );
	level endon( "river_burn_interrupted" );
	wait_on_river_burn_interrupted();
	level.player thread max_participation();
	flag_set( "river_burn_interrupted" );
}

max_participation()
{
	level endon( "allies_path_to_big_moment" );
	while( 1 )
	{
		self.participation = 1000;
		wait( 0.05 );
	}
}

wait_on_river_burn_interrupted()
{
	self endon( "flashbang" );
	
	self ent_flag_wait( "_stealth_normal" );
	self ent_flag_waitopen( "_stealth_normal" );
}

river_burn_dialogue()
{
	level endon( "river_burn_interrupted" );
	level endon( "house_burn_watchers_dead" );
	level endon( "kill_river_burn_dialogue" );
	flag_wait( "flag_house_burn_play" );
	flag_set( "tire_necklace_dialogue" );
	aud_send_msg( "mus_tire_burning_start" );
}

river_burn_music()
{
	level endon( "river_second_leg" );
	flag_wait( "_stealth_spotted" );
	aud_send_msg( "mus_tire_burning_busted" );
	flag_waitopen( "_stealth_spotted" );
	aud_send_msg( "mus_tire_burning_all_clear" );
}

monitor_burn_scene( badguy )
{
	level waittill_any( "river_burn_interrupted", "allies_path_to_big_moment", "house_burn_watchers_dead" );
	
	// river burn interrupted, or successfully snuck past
	if ( !flag( "river_burn_interrupted" ) && flag( "allies_path_to_big_moment" ) )
	{
		// successfully snuck past enemies
		return;
	}
	
	// interrupted, move allies up after everyone's dead
	if ( IsDefined( badguy ) && IsAlive( badguy ) )
	{
		badguy anim_stopanimscripted();
		badguy waittill( "death" );
	}
	
	if ( IsDefined( level.burn_guard ) && IsAlive( level.burn_guard ) )
	{
		level.burn_guard waittill( "death" );
	}
	
	flag_wait( "house_burn_watchers_dead" );
	flag_set( "allies_path_to_big_moment" );
	
	// reset player's friendlyfire points (so if you aim for and kill the civ, it will fail)
	wait 0.5;
	level.player.participation = 0;
}

handle_burn_victim()
{
	self endon( "burn_victim_interrupted" );
	
	self thread interrupt_burn_victim();

	self waittill( "victim_on_fire" );
	
	self thread maps\warlord_fx::set_guy_on_fire();
	
	if ( IsDefined( self ) && IsAlive( self ) )
	{
		self notify( "burn_victim_uninterruptible" );
		level notify( "kill_river_burn_dialogue" );
		
		// victim on fire, cannot be saved past this point
		self.allowdeath = false;
		self waittillmatch( "single anim", "end" );
		
		self.allowdeath = true;
		self kill_no_react();
		dummy = maps\_vehicle_aianim::convert_guy_to_drone( self );
		dummy.animname = "victim";
		dummy NotSolid();
		victim_burn_anim = dummy getanim( "burn" );
		dummy SetModel( "africa_civ_male_burned" );
		dummy SetAnim( victim_burn_anim, 1, 0, 0 );
		dummy SetAnimTime( victim_burn_anim, 1 );
	}
}

interrupt_burn_victim()
{
	self endon( "death" );
	self endon( "burn_victim_uninterruptible" );
	
	flag_wait( "river_burn_interrupted" );
	self notify( "killanimscript" );
	self notify( "burn_victim_interrupted" );
	
	org = getstruct( "org_burn", "targetname" );
	org anim_single_solo( self, "burn_escape" );
	
	self set_generic_run_anim( "civilian_run_hunched_C", true );
	burn_victim_escape_path = GetStruct( "burn_victim_escape_path", "targetname" );
	self thread follow_path( burn_victim_escape_path );
	
	wait 10;
	AI_delete_when_out_of_sight( [ self ], 1024 );
}

handle_attachments( badguy )
{
	thread handle_gas_can( badguy );
	thread handle_weapon( badguy );
}

handle_gas_can( badguy )
{
	gas_can = Spawn( "script_model", ( 0, 0, 0 ) );
	gas_can SetModel( "accessories_gas_canister_highrez" );
	gas_can Show();
	gas_can LinkTo( badguy, "tag_inhand", (0,0,-20), (0,0,0) );
	
	wait_to_unlink_gas_can( badguy );
	gas_can Unlink();
	gas_can PhysicsLaunchClient( gas_can.origin, (0,0,0) );
	
	flag_wait( "clean_up_river" );
	gas_can Delete();
}

wait_to_unlink_gas_can( badguy )
{
	badguy endon( "death" );
	level endon( "river_burn_interrupted" );
	if ( flag( "river_burn_interrupted" ) )
	{
		return;
	}

	badguy waittill( "unlink_gas_can" );
}

handle_weapon( badguy )
{
	badguy animscripts\shared::placeWeaponOn( badguy.weapon, "chest" );
	wait_to_equip_weapon( badguy );
	if ( IsDefined( badguy ) && IsAlive( badguy ) )
	{
		badguy animscripts\shared::placeWeaponOn( badguy.weapon, "right" );
	}
}

wait_to_equip_weapon( badguy )
{
	badguy endon( "death" );
	level endon( "river_burn_interrupted" );
	if ( flag( "river_burn_interrupted" ) )
	{
		return;
	}

	flag_wait( "river_house_burn_anim_finished" );
}

river_house_burn_watchers()
{
	spawners = getentarray( "river_house_burn_watchers", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::patroller_logic, "london_dock_soldier_walk" );
	array_thread( spawners, ::add_spawn_function, ::river_house_burn_watchers_setup );
	array_thread( spawners, ::add_spawn_function, ::monitor_river_burn_interrupted );
	array_thread( spawners, ::spawn_ai, true );
}

river_house_burn_watchers_setup()
{
	self endon( "death" );
	level endon( "river_burn_interrupted" );
	
	self ent_flag_init( "post_burn_in_house" );
	
	self thread ignoreme_while_stealth();
	self thread ambient_stealth_anim();
	self thread post_burn_ambient_anim();

	flag_wait( "river_house_burn_anim_finished" );
	self anim_stopanimscripted();
}

ambient_stealth_anim()
{
	self endon( "death" );
	if( isDefined( self.script_parameters ) )
	{
		anim_info = getstruct( self.script_parameters, "targetname" );
		if( isDefined( anim_info.animation ) )
		{
			self thread monitor_end_loop();
			anime = anim_info.animation;
			self thread anim_generic_loop( self, anime, "end_loop" );
		}
	}
}

monitor_end_loop()
{
	self endon( "death" );
	flag_wait_any( "river_burn_interrupted", "river_house_burn_anim_finished" );
	self notify( "end_loop" );
	
	// stop scripted in case of flashbang, so flashed reaction can play
	self anim_stopanimscripted();
}

post_burn_ambient_anim()
{
	if( !isDefined( level.burn_direction ) )
	{
		level.burn_direction = 1;
	}
	
	self endon( "death" );
	self ent_flag_wait( "post_burn_in_house" );
	
	animations = [];
	animations[0] = "jeer_loop_2";
	animations[1] = "jeer_loop_3";
	
	if( level.burn_direction % 2 == 0 )
	{ 
		self teleport( self.origin, ( 0, 225, 0 ) );
	}
	
	level.burn_direction += 1;
	
	self thread monitor_post_burn_end_loop();
	self anim_generic_loop( self, animations[ RandomInt( 2 ) ], "end_loop" );
}

monitor_post_burn_end_loop()
{
	self endon( "death" );
	self wait_for_alerted_or_death();
	self notify( "end_loop" );
	self anim_stopanimscripted();
}

ignoreme_while_stealth()
{
	self endon( "death" );
	
	self.ignoreme = 1;
	flag_wait( "river_burn_interrupted" );

	//after interrupting we can play a reaction
	//if we havent completed the sequence	
	if ( !flag("allies_path_to_big_moment" ) )
	{
		if ( IsDefined( self.script_parameters ) )
		{
			my_anim_info = getstruct( self.script_parameters, "targetname" );
			assert( isdefined( my_anim_info ) );
			if ( isdefined( my_anim_info.script_parameters ) )
			{
				waittillframeend;
				if ( !self isFlashed() )
				{
					self.animname = "generic";
					anim_single_solo( self, my_anim_info.script_parameters);
				}
			}
		}
	}
	
	self.ignoreme = 0;
}

////////////////
// big moment
////////////////

allies_path_to_big_moment()
{
	flag_wait( "allies_path_to_big_moment" );
	activate_trigger_with_targetname( "trig_path_to_big_moment" );
	level.price thread ally_stop_dynamic_speed();
	level.soap thread ally_stop_dynamic_speed();
	level.price thread enable_cqbwalk();
	level.soap thread enable_cqbwalk();
}

river_big_moment()
{
	level endon( "river_big_moment_stealth_spotted" );
	
	flag_init( "river_moment_technical_driveup" );
	flag_init( "river_moment_allies_run" );

	thread river_big_moment_spotted();
	thread river_big_moment_setup();
	thread river_big_moment_music();
	thread river_execution_moment();

	river_big_moment_first_beat();
	river_big_moment_second_beat();
	river_big_moment_third_beat();
	river_bridge();
}

river_execution_moment()
{
	flag_wait( "river_second_leg" );
	
	flag_init( "river_execution_interrupted" );
	
	level.drone_death_handler = ::civ_drone_death_handler;
	
	org = getstruct( "org_execution_scene", "targetname" );
	
	soldier_spawner_1 = getent( "execution_soldier_1", "targetname" );
	soldier_spawner_2 = getent( "execution_soldier_2", "targetname" );
	
	soldier_1 = soldier_spawner_1 spawn_ai( true );
	soldier_1.animname = "militia_1";
	soldier_1.allowdeath = true;
	soldier_1.moveplaybackrate = 1.15;
	soldier_1 thread setup_river_executioner();
	soldier_2 = soldier_spawner_2 spawn_ai( true );
	soldier_2.animname = "militia_2";
	soldier_2.allowdeath = true;
	soldier_2.moveplaybackrate = 1.15;
	
	soldier_1 thread monitor_execution_interrupt();
	soldier_2 thread monitor_execution_interrupt();
	
	dummy_1 = create_civilian_execution_drone( "execution_civ_1", "civ_1", org, "execution_loop_1", getgenericanim( "civ_crouch_death" ), "execution_blood_fx" );
	dummy_2 = create_civilian_execution_drone( "execution_civ_2", "civ_2", org, "execution_loop_2", getgenericanim( "civ_crouch_death2" ), "execution_blood_fx" );
	dummy_3 = create_civilian_execution_drone( "execution_civ_3", "civ_3", org, "execution_loop_3", getgenericanim( "civ_crouch_death" ), "execution_blood_fx_2" );
	
	guys = [];
	guys[0] = soldier_1;
	guys[1] = soldier_2;
	guys[2] = dummy_1;
	guys[3] = dummy_2;
	guys[4] = dummy_3;
	
	org anim_first_frame( guys, "river_execution" );
	
	flag_wait( "flag_player_first_beat" );
	//thread execution_dialogue( soldier_1, dummy_1, dummy_3 );
	org anim_single( guys, "river_execution" );
	
	if ( !flag( "river_execution_interrupted" ) )
	{
		if( isDefined( soldier_1 ) && isAlive( soldier_1 ) )
		{
			soldier_1 thread post_execution_patrol( "patrol_warlord_walk_1" );
		}
		
		if( isDefined( soldier_2 ) && isAlive( soldier_2 ) )
		{
			soldier_2 thread post_execution_patrol( "patrol_warlord_walk_2" );
		}
		
		flag_set( "river_moment_allies_run" );
	}
	
	level.drone_death_handler = undefined;
}

execution_dialogue( soldier, civ_1, civ_2 )
{
	level endon( "river_execution_interrupted" );
	//Militia 2: Did you think we wouldn't find you?
	soldier dialogue_queue( "warlord_mlt2_wouldnt" );
	//Civilian: Please, my family… they need me!
	civ_1 dialogue_queue( "warlord_civ_myfamily" );
	
	level waittill( "execution_victim_killed" );
	//Militia 2: Waraabe is not a forgiving man. You should have given him what he wanted.
	soldier dialogue_queue( "warlord_mlt2_whathewanted" );
	
	level waittill( "execution_victim_killed" );
	//Militia 2: It's time to pay the price.
	soldier dialogue_queue( "warlord_mlt2_timetopay" );
	//Civilian: No, no, I'll do whatever you want! Please!
	civ_2 dialogue_queue( "warlord_civ_noplease" );
}

civ_drone_death_handler( deathanim )
{
	// wait for my specialized damage function to run to see
	//   if the civ died from the animation or from some other action
	waittillframeend;
	
	self NotSolid();
	self thread maps\_drone::drone_thermal_draw_disable( 2 );
	
	if ( IsDefined( self.deathanim ) )
	{
		// if you have a deathanim specified, make sure to interrupt the execution
		flag_set( "river_execution_interrupted" );
		self maps\_drone::drone_play_scripted_anim( self.deathanim, "deathplant" );
	}
}

create_civilian_execution_drone( spawner_targetname, animname, org, interrupt_loop_anim, civ_death_anim, execution_fx )
{
	civ_spawner = getent( spawner_targetname, "targetname" );
	civ_drone = civ_spawner spawn_ai( true );
	civ_drone.animname = animname;
	civ_drone.noragdoll = true;
	civ_drone.nocorpsedelete = true;	// corpse deleted by river clean up
	civ_drone thread monitor_execution_interrupt_civ( org, interrupt_loop_anim );
	civ_drone thread drone_detect_damage( civ_death_anim, execution_fx );
	civ_drone thread drone_wait_to_delete();
	return civ_drone;
}

drone_detect_damage( civ_death_anim, execution_fx )
{
	while ( true )
	{
		self waittill( "damage", amount, attacker, direction, position, damage_type );
		
		if ( !flag( "river_execution_interrupted" ) && IsDefined( attacker ) && IsDefined( attacker.animname ) && attacker.animname == "militia_1" )
		{
			// if killed by the executioner in the scripted anim, play specific fx
			PlayFxOnTag( getfx( execution_fx ), attacker, "TAG_FLASH" );
			level notify( "execution_victim_killed" );
		}
		else
		{
			// not killed in execution scene...
			if ( IsDefined( position ) && IsDefined( damage_type ) )
			{
				if ( damage_type == "MOD_PISTOL_BULLET" ||
					 damage_type == "MOD_RIFLE_BULLET" || 
				 	 damage_type == "MOD_EXPLOSIVE_BULLET" )
				{
					if ( self.health <= 0 )
					{
						PlayFx( getfx( "headshot" ), position );
					}
					else
					{
						PlayFx( getfx( "bodyshot" ), position );
					}
				}
			}
			
			if ( self.health <= 0 )
			{
				self.deathanim = civ_death_anim;
				break;
			}
		}
	}
}

setup_river_executioner()
{
	self endon( "death" );
	
	// coltanaconda is too big and will clip into the head of the civs and not kill them.
	//   switching to fnfiveseven
	self forceuseweapon( "fnfiveseven", "sidearm" );
	flag_wait_either( "river_moment_allies_run", "river_execution_interrupted" );
	
	// switch to primary weapon.  reset .lastweapon or else
	//   if it switches to a sidearm and then dies it will assert.
	//   i think switching to a sidearm may need to set lastweapon properly?
	self gun_remove();
	self forceuseweapon( self.primaryweapon, "primary" );
	self gun_recall();
	self.lastweapon = self.primaryweapon;
}

monitor_execution_interrupt()
{
	self wait_for_execution_interrupt();
	flag_set( "river_execution_interrupted" );
	if( isDefined( self ) && isAlive( self ) )
	{
		self anim_stopanimscripted();
	}
}

wait_for_execution_interrupt()
{
	level endon( "river_execution_interrupted" );
	if ( flag( "river_execution_interrupted" ) )
		return;
	
	self wait_for_alerted_or_death();
}

monitor_execution_interrupt_civ( org, interrupt_loop_anim )
{
	self endon( "death" );
	
	flag_wait( "river_execution_interrupted" );
	
	self anim_stopanimscripted();
	org thread anim_loop_solo( self, interrupt_loop_anim );
}

post_execution_patrol( anime )
{
	self endon( "death" );
	if( isDefined( anime ) )
	{
		self thread patroller_logic( anime );
	}
	else
	{
		self thread patroller_logic();
	}
}

river_big_moment_music()
{
	flag_wait( "river_second_leg" );
	aud_send_msg( "mus_river_big_moment_start" );
	
	thread river_big_moment_music_busted();
	level endon( "river_big_moment_stealth_spotted" );
	if ( flag( "river_big_moment_stealth_spotted" ) )
	{
		// if spotted, river_big_moment_music_busted will send the all clear
		return;
	}
	
	flag_wait( "end_river_big_moment" );
	aud_send_msg( "mus_river_big_moment_all_clear" );
}

river_big_moment_music_busted()
{
	level endon( "end_river_big_moment" );
	flag_wait( "river_big_moment_stealth_spotted" );
	aud_send_msg( "mus_river_big_moment_busted" );
	flag_waitopen( "_stealth_spotted" );
	aud_send_msg( "mus_river_big_moment_all_clear" );
}

start_river_big_moment_stealth()
{
	// allies are more inaccurate for this encounter
	thread change_allies_spotted_accuracy( 0.1 );
	
	river_big_moment_ranges();
	
	thread river_big_moment_detected();
}

river_big_moment_detected()
{
	level endon( "_stealth_enabled" );
	level endon( "clean_up_river" );
	if ( !flag( "_stealth_enabled" ) )
		return;
		
	// catch case where everyone is dead 
	//   but you're still considered spotted for a second. (bug 154066)
	if ( flag( "_stealth_spotted" ) )
		wait 1.30;
	
	flag_wait( "_stealth_spotted" );
	flag_set( "river_big_moment_stealth_spotted" );
}

river_big_moment_spotted()
{
	level endon( "_stealth_enabled" );
	level endon( "clean_up_river" );
	flag_wait( "river_big_moment_stealth_spotted" );
	
	// logic to progress after being spotted?  kill all enemies?  just run past everybody?  hmmm.
	//IPrintLnBold( "You've been spotted!" );
	flag_set( "river_spotted_dialogue" );
	
	level.price thread ally_river_spotted( "trig_price_post_bridge", "price_post_bridge" );
	level.soap thread ally_river_spotted( "trig_soap_post_bridge", "soap_post_bridge" );
	
	setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
}

ally_river_spotted( end_trigger, post_bridge_flag )
{
	self endon( "kill_ally_river_spotted" );
	
	self notify( "kill_pose_transition" );
	self unset_shared_field_value( "ignoreall" );
	wait 0.05;
	
	self AllowedStances( "stand", "crouch", "prone" );
	self.goalradius = 2048;
	self PushPlayer( false );
	self.dontchangepushplayer = undefined;
	
	flag_set( post_bridge_flag );

	flag_waitopen( "_stealth_spotted" );
	wait 0.05;
	
	trigger = getent( end_trigger, "targetname" );
	trigger notify( "trigger", level.player );
}

setup_river_dialogue_guys()
{
	if( !isDefined( level.river_dialogue_guys ) )
	{
		level.river_dialogue_guys = [];
	}
	
	level.river_dialogue_guys[ level.river_dialogue_guys.size ] = self;
	self.animname = "militia";
}

river_big_moment_clip_blocker()
{
	clip = getent( "clip_execution_blocker", "targetname" );
	flag_wait_any( "river_big_moment_stealth_spotted", "flag_player_second_beat" );
	clip ConnectPaths();
	clip delete();
}

river_big_moment_setup()
{
	flag_wait( "river_second_leg" );
	
	thread stealth_death_hint();
	
	thread start_river_big_moment_stealth();
	
	level.price set_shared_field_value( "ignoreall" );
	level.soap set_shared_field_value( "ignoreall" );

	/****patrol = getentarray( "river_moment_patrol", "script_noteworthy" );
	array_thread( patrol, ::add_spawn_function, ::patroller_logic );
	array_thread( patrol, ::add_spawn_function, ::setup_river_big_moment_guys );
	array_thread( patrol, ::add_spawn_function, ::setup_river_dialogue_guys );
	array_thread( patrol, ::add_spawn_function, ::wait_for_search_anims );
	array_spawn( patrol, true );
	***/
	
	far_patrol_spawners = getentarray( "river_far_bank_patrol", "targetname" );
	array_thread( far_patrol_spawners, ::add_spawn_function, ::patroller_logic );
	array_thread( far_patrol_spawners, ::add_spawn_function, ::river_far_patrol_setup );
	array_thread( far_patrol_spawners, ::add_spawn_function, ::setup_river_big_moment_guys );	
	array_spawn( far_patrol_spawners, true );
	
	prone_patrol = getentarray( "river_moment_prone_patrol", "targetname" );
	array_thread( prone_patrol, ::add_spawn_function, ::river_prone_patrol_setup );
	array_thread( prone_patrol, ::add_spawn_function, ::setup_river_big_moment_guys );
	array_thread( prone_patrol, ::add_spawn_function, ::setup_river_dialogue_guys );
	array_thread( prone_patrol, ::add_spawn_function, ::wait_for_search_anims );
	array_spawn( prone_patrol, true );
	
	end_patrol = getentarray( "river_moment_end_guys", "targetname" );
	array_thread( end_patrol, ::add_spawn_function, ::river_moment_end_guys_setup );
	array_thread( end_patrol, ::add_spawn_function, ::setup_river_big_moment_guys );	
	array_spawn( end_patrol, true );
	
	// set up bridge guys
	spawners = getentarray( "river_bridge_guys", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::patroller_logic );
	array_thread( spawners, ::add_spawn_function, ::watch_for_bridge_guy_death );
	array_thread( spawners, ::add_spawn_function, ::watch_for_bridge_guy_spotted );
	array_thread( spawners, ::add_spawn_function, ::watch_for_premature_bridge_death );
	array_thread( spawners, ::add_spawn_function, ::add_idle_variance );

	// get the specific entities, entarray might reorder
	river_bridge_spawner_1 = GetEnt( "river_bridge_guy_1", "targetname" );
	river_bridge_spawner_2 = GetEnt( "river_bridge_guy_2", "targetname" );

	level.river_bridge_guys = [];
	level.river_bridge_guys[ 0 ] = river_bridge_spawner_1 spawn_ai( true );
	level.river_bridge_guys[ 0 ].bridge_anim_node = getstruct( "org_bridge_price", "targetname" );
	level.river_bridge_guys[ 0 ].death_animscene = "bridge_death_1";
	level.river_bridge_guys[ 0 ].noragdoll = true;
	level.river_bridge_guys[ 0 ].disable_dive_whizby_react = true;
	level.river_bridge_guys[ 1 ] = river_bridge_spawner_2 spawn_ai( true );
	level.river_bridge_guys[ 1 ].bridge_anim_node = getstruct( "org_bridge_soap", "targetname" );
	level.river_bridge_guys[ 1 ].death_animscene = "bridge_death_2";
	level.river_bridge_guys[ 1 ].noragdoll = true;
	level.river_bridge_guys[ 1 ].disable_dive_whizby_react = true;
	
	thread river_big_moment_technical_drive();
	thread river_big_moment_super_technical_drive();
}

setup_river_big_moment_guys()
{
	self.baseaccuracy = 3;
}

river_guy_spotted()
{
	self endon( "death" );
	
	flag_wait( "river_big_moment_stealth_spotted" );
	self.goalradius = 2048;
	self clear_run_anim();
	self.disablearrivals = undefined;
	self.disableexits = undefined;
	self.moveplaybackrate = 1;
	self.ignoreme = 0;
}

wait_for_search_anims()
{
	self endon( "death" );
	level endon( "river_big_moment_stealth_spotted" );
	
	if( isDefined( self.script_parameters ) && self.script_parameters == "node_prone_patrol_2" )
	{
		self ent_flag_init( "prone_search_1" );
		self ent_flag_wait( "prone_search_1" );
		self.allowdeath = true;
		self anim_generic( self, "prone_search_1" );
	}
	else if( isDefined( self.script_parameters ) && self.script_parameters == "node_prone_patrol_3" )
	{
		self ent_flag_init( "prone_search_2" );
		self ent_flag_wait( "prone_search_2" );
		self.allowdeath = true;
		self anim_generic( self, "prone_search_2" );
	}
}

river_far_patrol_setup()
{
	self endon( "death" );
	level endon( "river_big_moment_stealth_spotted" );
	thread river_guy_spotted();
	wait( 0.05 );
	self.alertlevel = "alert";
	//self.moveplaybackrate = 0.5;
}

river_big_moment_super_technical_drive()
{
	technical = spawn_vehicle_from_targetname_and_drive( "river_moment_technical_driveup_2" );
	technical SetCanDamage( false );
	technical.dontunloadonend = true;
	technical.mgturret[0] makeTurretSolid();
	aud_send_msg("super_technical", technical);
	technical thread make_driver_invul();
	technical thread make_gunner_invul();
	
	technical_2 = spawn_vehicle_from_targetname( "river_moment_technical_driveup_3" );
	technical_2.dontunloadonend = true;
	technical_2 thread kill_path_on_death();
	technical_2 thread unload_on_spotted();
	technical_2 thread vehicle_turret_no_ai_detach();
	technical_2 thread watch_lead_technical();
	technical_2 thread technical_rumble();
	
	wait( 2.0 );
	technical_2 thread gopath();
	aud_send_msg("technical_2", technical_2);
}

river_big_moment_technical_drive()
{
	flag_wait( "river_moment_technical_driveup" );
	
	level.technical_1 = spawn_vehicle_from_targetname( "river_moment_technical_driveup" );
	level.technical_1.dontunloadonend = true;
	level.technical_1 thread unload_on_spotted();
	level.technical_1.animname = "technical";
	level.technical_1 thread technical_open_gate();
	level.technical_1 thread switch_rider_idle_anims_stop();
	level.technical_1 thread technical_rumble();
	aud_send_msg("river_technical_01", level.technical_1); 
	
	level.technical_1 endon( "death" );
	wait 0.5;
	level.technical_1 thread gopath();
	
	level.technical_1 thread kill_path_on_death();
	foreach( guy in level.technical_1.riders )
	{
		guy.goalradius = 8;
	}
}

technical_rumble()
{
	level endon( "river_big_moment_stealth_spotted" );
	self endon( "death" );
	
	while( 1 )
	{
		self PlayRumbleOnEntity( "subtle_tank_rumble" );
		wait( 1 );
	}
}

technical_open_gate()
{
	anime = self getanim( "open_gate" );
	self SetAnim( anime[0] );
}

switch_rider_idle_anims_stop()
{
	level endon( "river_big_moment_stealth_spotted" );
	self endon( "death" );
	
	flag_wait( "swtich_truck_rider_anims" );
	
	animation = "";
	tag_name = "";
	do_nothing = false;
	
	foreach( rider in self.riders )
	{
		switch( rider.vehicle_position )
		{
			case 2:
				do_nothing = false;
				animation = "africa_technical_passenger_rside_idle_stopped";
				tag_name = "tag_guy1";
				break;
			case 3:
				do_nothing = false;
				animation = "africa_technical_passenger_lside_idle_stopped";
				tag_name = "tag_guy0";
				break;
			case 4:
				do_nothing = false;
				animation = "africa_technical_passenger_back_idle_stopped";
				tag_name = "tag_guy3";
				break;
			case 5:
				do_nothing = false;
				animation = "africa_technical_passenger_backside_idle_stopped";
				tag_name = "tag_guy2";
				break;
			default:
				do_nothing = true;
				break;
		}
		
		if( !do_nothing )
		{
			self thread anim_generic_loop( rider, animation, undefined, tag_name );
			
			// bah, since the end loop gets called on self, not on the guy animating,
			//   if the guy is doingLongDeath, anim_loop can infinite loop.  
			// intercept stop_loop message and resend on proper entity
			rider thread end_rider_idle_loop( self );
		}
	}
}

end_rider_idle_loop( technical )
{
	self endon( "death" );
	self waittill( "stop_loop" );
	technical notify( "stop_loop" );
}

kill_path_on_death()
{
	// needed to fix what looks to be a bug in the vehicle code.
	//   vehicle_paths keeps running after a vehicle is killed, and if certain
	//   triggers/flags are hit, it will try to resume the vehicle after death
	
	// also kill path when driver is killed
	self wait_to_kill_path();
	self notify( "newpath" );
}

wait_to_kill_path()
{
	self endon( "death" );
	self endon( "driver dead" );
	level waittill( "eternity" );
}

watch_lead_technical()
{
	self endon( "death" );
	
	// if first technical stops, make sure to stop and unload also
	while ( !IsDefined( level.technical_1 ) )
	{
		wait 0.05;
	}
	
	level.technical_1 wait_for_technical_stop();
	
	if( isDefined( level.technical_1 ) )
	{
		self notify( "unload_on_stealth_broken" );
	}
}

wait_for_technical_stop()
{
	self endon( "death" );
	self endon( "driver dead" );
	self waittill( "stealth_broken_unload" );
}

river_big_moment_first_beat()
{
	flag_wait( "flag_player_first_beat" );
	
	// turn off friendly suppression during stealth
	//   so AI don't stop moving when you prime a flash grenade
	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	
	// turn on PushPlayer before anim_generic_reach
	//   so it's harder for player to get in ally's collision
	//   while prone (bug 150116)
	if ( !flag( "river_big_moment_stealth_spotted" ) )
	{
		level.price.dontchangepushplayer = true;
		level.price PushPlayer( true );
		level.soap.dontchangepushplayer = true;
		level.soap PushPlayer( true );
	}
	
	thread river_big_moment_first_beat_aware();
	wait( 3.0 );
	flag_set( "river_moment_technical_driveup" );
	thread flag_set_delayed( "dont_be_stupid_dialogue", 7 );
	flag_wait( "river_moment_allies_run" );
	flag_set( "second_beat_move_dialogue" );
	thread river_moment_allies_move();
	thread river_moment_allies_move_aware();
}

river_big_moment_first_beat_aware()
{
	level endon( "river_moment_allies_run" );
	level endon( "river_big_moment_stealth_spotted" );

	thread reset_on_enemy_bad_event( "river_moment_allies_run" );
	level endon( "enemy_bad_event" );

	wait_for_first_beat_aware_ranges();
	thread big_moment_first_beat_aware_ranges();
}

wait_for_first_beat_aware_ranges()
{
	level endon( "river_execution_interrupted" );
	if ( flag( "river_execution_interrupted" ) )
		return;
	
	big_moment_first_beat_aware = GetEnt( "big_moment_first_beat_aware", "targetname" );
	big_moment_first_beat_aware waittill( "trigger" );
}

big_moment_first_beat_aware_ranges()
{
	level endon( "river_big_moment_stealth_spotted" );
	
	river_far_stealth_ranges();
	
	flag_wait( "river_moment_allies_run" );
	flag_waitopen( "_stealth_spotted" );
	river_big_moment_ranges();
}

river_moment_allies_move()
{
	level.price thread river_moment_guy_move( "node_river_moment_price" );
	wait( 1 );
	level.soap thread river_moment_guy_move( "node_river_moment_soap" );
}

river_moment_allies_move_aware()
{
	level endon( "flag_player_second_beat" );
	level endon( "river_big_moment_stealth_spotted" );
	
	thread reset_on_enemy_bad_event( "flag_player_second_beat" );
	level endon( "enemy_bad_event" );
	
	childthread wait_for_jeer_guys_leave();
	
	big_moment_allies_move_aware = GetEnt( "big_moment_allies_move_aware", "targetname" );
	big_moment_allies_move_aware wait_for_trigger_or_timeout( 12 );
	thread big_moment_allies_move_aware_ranges();
}

wait_for_jeer_guys_leave()
{
	wait 7;
	flag_set( "jeer_guy_leave" );
}

big_moment_allies_move_aware_ranges()
{
	level endon( "river_big_moment_stealth_spotted" );
	
	river_far_stealth_ranges();
	
	flag_wait( "flag_player_second_beat" );
	flag_waitopen( "_stealth_spotted" );
	river_big_moment_ranges();
}

river_moment_guy_move( name )
{
	self enable_cqbwalk();
	self thread go_to_node_with_targetname( name );
	
	wait( 4 );
	self thread disable_cqbwalk();
	self enable_sprint();
	self disable_arrivals();
	
	node = getnode( name, "targetname" );
	node anim_generic_reach( self, "prone_dive" );
	self enable_arrivals();
	self disable_sprint();
	self enable_ai_color_dontmove();
	
	// only go prone if not spotted yet
	if ( !flag( "river_big_moment_stealth_spotted" ) )
	{
		self AllowedStances( "prone" );
		node anim_custom_animmode_solo( self, "gravity", "prone_dive" );
		self.a.movement = "stop";
		
		// notetrack will put ally in prone, but uses %exposed_aiming as the "level" animation,
		//   which will cause a pop when crawling up.  use %exposed_modern for moving up instead
		self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_modern, %prone_legs_up );
		self set_goal_pos( self.origin );
	}
}

river_moment_guy_getup()
{
	old_goal_node = self.node;
	
	self set_goal_pos( self.origin );
	self.goalradius = 32;
	
	while ( self.a.pose != "stand" )
	{
		self AllowedStances( "stand" );
		wait 0.1;
	}
	
	self go_to_node( old_goal_node );
	self AllowedStances( "crouch", "stand", "prone" );
}

river_big_moment_second_beat()
{
	flag_wait( "flag_player_second_beat" );

	river_driveby = spawn_vehicle_from_targetname_and_drive( "river_moment_burn_driveby" );
	aud_send_msg("river_big_moment_second_beat");
	aud_send_msg("river_driveby_technical", river_driveby);
	
	thread prone_death_hint();
	flag_set( "off_the_road_dialogue" );
	thread river_big_moment_second_beat_aware();

	thread aud_river_big_moment_grass_player_prone();
	aud_send_msg( "mus_river_big_moment_grass_start" );

	wait 2;
	flag_set( "river_burn_watchers_leave" );
	flag_wait( "second_beat_prone_move" );
	wait( 14.0 );
	thread prone_autosave();
	wait( 2 );
	flag_set( "river_big_moment_done_dialogue" );
	level.soap thread go_to_node_with_targetname_with_checks( "node_river_soap_beat_2" );
	level.price thread go_to_node_with_targetname_with_checks( "node_river_price_beat_2" );
	wait 2;
	level notify( "river_moment_move_to_third_beat" );
	thread river_move_to_third_beat_ranges();
	wait 2;
	
	level.price thread river_moment_guy_getup();
	level.soap thread river_moment_guy_getup();

	level notify( "end_aud_big_moment_grass" );
	aud_send_msg( "mus_river_big_moment_grass_stop" );
	aud_send_msg("river_big_moment_end");
}

no_prone_hint()
{
	stance = level.player GetStance();
	if( stance == "prone" )
	{
		level notify( "end_display_hint_from_map" );
		return true;
	}
	
	if ( flag( "_stealth_spotted" ) )
	{
		level notify( "end_display_hint_from_map" );
		return true;
	}
	
	return false;
}

prone_death_hint()
{
	level endon( "river_moment_move_to_third_beat" );
	level.player waittill( "death" );
	
	level notify( "new_quote_string" );
	SetDvar( "ui_deadquote", &"WARLORD_PRONE_DEATH" );
}

stealth_death_hint()
{
	level endon( "flag_player_second_beat" );
	level.player waittill( "death" );
	
	level notify( "new_quote_string" );
	SetDvar( "ui_deadquote", &"WARLORD_STEALTH_DEATH" );
}

prone_autosave()
{
	if ( level.player GetStance() == "prone" )
	{
		autosave_stealth();
	}
}

river_move_to_third_beat_ranges()
{
	level endon( "flag_player_at_third_beat" );
	if ( flag( "flag_player_at_third_beat" ) )
	{
		return;
	}
	
	thread reset_on_enemy_bad_event( "flag_player_at_third_beat" );
	level endon( "enemy_bad_event" );
	
	while ( true )
	{
		flag_wait( "flag_move_to_third_beat" );
		river_big_moment_ranges();
		flag_waitopen( "flag_move_to_third_beat" );
		river_medium_stealth_ranges();
	}
}

aud_river_big_moment_grass_player_prone()
{
	level endon( "end_aud_big_moment_grass" );
	level endon( "river_big_moment_stealth_spotted" );
	
	while ( level.player GetStance() != "prone" )
	{
		wait 0.1;
	}
	
	aud_send_msg( "mus_river_big_moment_grass_prone" );
}

river_big_moment_second_beat_aware()
{
	level endon( "river_moment_move_to_third_beat" );
	level endon( "river_big_moment_stealth_spotted" );
	
	if(isdefined(level.technical_1)) playfxontag( getfx( "truck_dust_warlord" ), level.technical_1, "tag_fx_tire_right_r" );

	thread reset_on_enemy_bad_event( "river_moment_move_to_third_beat" );
	level endon( "enemy_bad_event" );
	
	thread manage_overlapping_flag_trigger( "in_prone_stealth_area", "flag_in_prone_stealth_area", "river_moment_move_to_third_beat" );
	
	wait 5;
	river_far_stealth_ranges();
	
	while ( true )
	{
		flag_wait( "flag_in_prone_stealth_area" );
		river_big_moment_prone_ranges();
		flag_waitopen( "flag_in_prone_stealth_area" );
		river_far_stealth_ranges();
	}
}

river_big_moment_prone_hint()
{
	level endon( "river_big_moment_stealth_spotted" );
	if ( flag( "river_big_moment_stealth_spotted" ) )
		return;
	
	flag_wait( "flag_in_prone_stealth_area" );
	thread display_hint_from_map( "prone" );
}

river_prone_patrol_setup()
{
	self endon( "death" );
	level endon( "river_big_moment_stealth_spotted" );
	if( !isDefined( level.river_prone_patrol ) )
	{
		level.river_prone_patrol = [];
	}
	level.river_prone_patrol = array_add( level.river_prone_patrol, self );
	thread river_guy_spotted();
	self.goalradius = 8;
	self.animname = "militia";
	
	flag_wait( "flag_player_second_beat" );
	self.goalradius = 2048;
	self.disablearrivals = true;
	self.disableexits = true;
	self thread patroller_logic( "london_dock_soldier_walk" );
	wait( 0.05 );
	self.alertlevel = "alert";
	//self.moveplaybackrate = 0.6;
}

prone_patrol_dialogue()
{
	level endon( "river_big_moment_stealth_spotted" );
	flag_wait( "flag_player_second_beat" );
	wait( 4.5 );
	guy_1 = level.river_prone_patrol[0];
	guy_2 = level.river_prone_patrol[1];
	
	//Militia 1: Why'd they have to start this shit on my birthday?
	guy_1 dialogue_queue( "warlord_mlt1_whydidthey" );
	//Militia 3: I'd rather be here than at home eating my wife's cooking any day.
	guy_2 dialogue_queue( "warlord_mlt3_ratherbehere" );
	//Militia 1: That's true…I've had your wife's cooking.
	guy_1 dialogue_queue( "warlord_mlt1_thatstrue" );
	//Militia 3: How much longer do we have to be out here?
	guy_2 dialogue_queue( "warlord_mlt3_howmuch" );
	//Militia 1: Until I finish this cigarette..*laugh*
	guy_1 dialogue_queue( "warlord_mlt1_cigarette" );
	//Militia 3: Well then make that last a few hours, ok?
	guy_2 dialogue_queue( "warlord_mlt3_makeitlast" );
	//Militia 1: You're a son of a bitch, you know that?
	guy_1 dialogue_queue( "warlord_mlt1_sob" );
	//Militia 3: But your wife loves me!
	guy_2 dialogue_queue( "warlord_mlt3_butyourwife" );
}

wait_for_pose_transition( new_pose )
{
	self endon( "kill_pose_transition" );
	
	self set_shared_field_value( "ignoreall" );
	self thread wait_to_unset_ignoreall();
	while ( self.a.pose != new_pose )
	{
		self.alertlevel = "noncombat";
		self AllowedStances( new_pose );
		wait 0.05;
 	}
 	
 	self notify( "done_pose_transition" );
}

wait_to_unset_ignoreall()
{
	self waittill_any( "kill_pose_transition", "done_pose_transition" );
	self unset_shared_field_value( "ignoreall" );
}
	
river_big_moment_third_beat()
{
	flag_wait( "flag_player_at_third_beat" );
	autosave_stealth();
	
	thread river_big_moment_third_beat_ranges();
	thread river_moment_end_guys_dead();

	flag_wait( "flag_go_to_bridge" );
	river_medium_stealth_ranges();
	thread reset_on_enemy_bad_event( "end_river_big_moment" );
	
	level.price anim_stopanimscripted();
	level.price go_to_node_with_targetname( "price_river_node_4" );
	
	// set soap to exit crouch straight ahead
	set_custom_move_start_transition( level.soap, "cqb_crouch_exit_8" );
	level.soap anim_stopanimscripted();
	level.soap go_to_node_with_targetname( "soap_river_node_4" );
	
	autosave_stealth();
}

river_big_moment_third_beat_ranges()
{
	level endon( "flag_go_to_bridge" );
	if ( flag( "flag_go_to_bridge" ) )
	{
		return;
	}

	thread reset_on_enemy_bad_event( "flag_go_to_bridge" );
	level endon( "enemy_bad_event" );
	
	while ( true )
	{
		flag_wait( "flag_player_at_third_beat" );
		river_big_moment_ranges();
		flag_waitopen( "flag_player_at_third_beat" );
		river_medium_stealth_ranges();
	}
}

river_moment_end_guys_dead()
{
	level endon( "flag_go_to_bridge" );
	level endon( "river_big_moment_stealth_spotted" );
	
	flag_wait( "river_end_guys_dead" );
	
	while ( !stealth_is_everything_normal() )
	{
		wait 0.1;
	}
	
	flag_set( "flag_go_to_bridge" );
}

river_moment_end_guys_setup()
{
	self endon( "death" );
	level endon( "river_big_moment_stealth_spotted" );
	thread river_guy_spotted();
	self.goalradius = 8;
	flag_wait( "flag_player_at_third_beat" );
	self.goalradius = 2048;
	self thread patroller_logic();
	
	wait( 0.05 );
	self.alertlevel = "alert";
	
	flag_wait( "flag_go_to_bridge" );
	if( isAlive( self ) )
	{
		self.ignoreme = 1;
	}
}

river_bridge()
{
	flag_wait( "flag_go_to_bridge" );
	flag_init( "bridge_player_done_waiting" );
	
	if ( IsAlive( level.river_bridge_guys[ 0 ] ) && IsAlive( level.river_bridge_guys[ 1 ] ) )
	{
		level.dead_river_bridge_guys = [];
		
		//technical
		flag_wait( "river_player_ready_for_bridge" );
		thread monitor_player_waiting_at_bridge();
	
		wait( 1.0 );
		
		if ( !flag( "bridge_player_done_waiting" ) )
		{
			flag_set( "church_mouse_dialogue" );
			aud_send_msg( "mus_church_mouse" );
		}
		
		wait( 1 );
		level.bridge_technical = spawn_vehicle_from_targetname_and_drive( "river_bridge_technical" );
		aud_send_msg("bridge_technical", level.bridge_technical );
		
		level.bridge_technical thread unload_on_spotted();
		flag_wait( "river_bridge_technical_gone" );
		
		if ( !flag( "bridge_player_done_waiting" ) )
		{
			flag_set( "bridge_go_loud_dialogue" );
			flag_wait( "bridge_player_done_waiting" );
		}
		
		level.price PushPlayer( false );
		level.price.dontchangepushplayer = undefined;
		level.soap PushPlayer( false );
		level.soap.dontchangepushplayer = undefined;
		
		// price kills both bridge guys
		level.price thread guy_kills_targets( level.river_bridge_guys, 0.4 );
		thread river_monitor_bridge_deaths();
		
		// soap can pull body off as soon as guy is killed
		thread play_river_bridge_scene( "river_guy_2_dead", 1, level.soap, "soap", "org_bridge_soap", "bridge_pulloff_2", "trig_soap_post_bridge", "soap_post_bridge" );
		// wait until price shoots both before price moves
		flag_wait( "river_guy_1_dead" );
		flag_wait( "river_guy_2_dead" );
		thread play_river_bridge_scene( "river_guy_1_dead", 0, level.price, "price", "org_bridge_price", "bridge_pulloff_1", "trig_price_post_bridge", "price_post_bridge" );
	}
	else
	{
		level.price PushPlayer( false );
		level.price.dontchangepushplayer = undefined;
		level.soap PushPlayer( false );
		level.soap.dontchangepushplayer = undefined;
		
		flag_set( "price_post_bridge" );
		price_trigger = getent( "trig_price_post_bridge", "targetname" );
		price_trigger notify( "trigger", level.player );
	
		flag_set( "soap_post_bridge" );
		soap_trigger = getent( "trig_soap_post_bridge", "targetname" );
		soap_trigger notify( "trigger", level.player );
	}
}

river_monitor_bridge_deaths()
{
	flag_wait( "river_guy_1_dead" );
	flag_wait( "river_guy_2_dead" );
	flag_set( "bridge_guys_dead_dialogue" );
	aud_send_msg( "mus_bridge_guys_dead" );
}

monitor_player_waiting_at_bridge()
{
	level.player endon( "death" );
	
	if ( !flag( "river_guy_1_dead" ) && !flag( "river_guy_2_dead" ) )
	{
		flag_end_arr = ["river_guy_1_dead", "river_guy_2_dead"];
		wait_til_price_can_kill( flag_end_arr );
		
		//if the technical has not passed cover is blown
		if(!flag("river_bridge_technical_gone"))
		{
			flag_set("_stealth_spotted");
		}
		
	}
	
	flag_set( "bridge_player_done_waiting" );
}

wait_til_price_can_kill( flag_end_arr )
{
	if(!IsArray( flag_end_arr ))
	{
		level endon( flag_end_arr );
	}
	else
	{
		foreach(f in flag_end_arr)
			level endon(f);
	}
	level endon( "_stealth_spotted" );
	level endon( "player_fired_weapon" );
	if ( flag( "_stealth_spotted" ) )
		return;

	childthread monitor_player_weapon();

	wait( 16.0 );
}

monitor_player_weapon()
{
	level.player waittill( "weapon_fired" );
	level notify( "price_dont_talk" );
	// give player time to kill both enemies
	wait 2;
	level notify( "player_fired_weapon" );
}

add_idle_variance()
{
	self endon( "death" );
	
	customIdleAnimSet = [];
	customIdleAnimWeights = [];
	
	customIdleAnimSet[ 0 ][ 0 ] = %casual_stand_idle;
	customIdleAnimSet[ 0 ][ 1 ] = %casual_stand_idle_twitch;
	customIdleAnimSet[ 0 ][ 2 ] = %casual_stand_idle_twitchB;
	customIdleAnimWeights[ 0 ][ 0 ] = 2;
	customIdleAnimWeights[ 0 ][ 1 ] = 1;
	customIdleAnimWeights[ 0 ][ 2 ] = 1;

	customIdleAnimSet[ 1 ][ 0 ] = %casual_stand_v2_idle;
	customIdleAnimSet[ 1 ][ 1 ] = %casual_stand_v2_twitch_radio;
	customIdleAnimSet[ 1 ][ 2 ] = %casual_stand_v2_twitch_shift;
	customIdleAnimSet[ 1 ][ 3 ] = %casual_stand_v2_twitch_talk;
	customIdleAnimWeights[ 1 ][ 0 ] = 10;
	customIdleAnimWeights[ 1 ][ 1 ] = 4;
	customIdleAnimWeights[ 1 ][ 2 ] = 7;
	customIdleAnimWeights[ 1 ][ 3 ] = 4;
	
	customIdleAnimSet[ 2 ][ 0 ] = %patrol_bored_idle;
	customIdleAnimSet[ 2 ][ 1 ] = %patrol_bored_twitch_bug;
	customIdleAnimSet[ 2 ][ 2 ] = %patrol_bored_twitch_stretch;
	customIdleAnimWeights[ 2 ][ 0 ] = 4;
	customIdleAnimWeights[ 2 ][ 1 ] = 1;
	customIdleAnimWeights[ 2 ][ 2 ] = 1;
	
	lastIdleSet = 0;
	self.customIdleAnimSet = [];
	while ( true )
	{
		idleSet = RandomInt( customIdleAnimSet.size );
		
		// don't play the same idle in a row
		if ( idleSet == lastIdleSet )
		{
			idleSet = ( lastIdleSet + 1 ) % customIdleAnimSet.size;
		}
		lastIdleSet = idleSet;
		
		self.customIdleAnimSet[ "stand" ] = animscripts\utility::anim_array( customIdleAnimSet[ idleSet ], customIdleAnimWeights[ idleSet ] );
		
		while ( true )
		{
			self waittill( "idle", note );
			if ( IsDefined( note ) && note == "end" )
			{
				break;
			}
		}
		
		// pick out an animation for the next cycle, this is so it can be
		//   deterministic instead of having the idle loop possibly double up
		waittillframeend;
	}
}

watch_for_bridge_guy_spotted()
{
	self endon( "death" );
	self.goalradius = 8;
	flag_wait( "river_big_moment_stealth_spotted" );
	self.goalradius = 2048;
}

watch_for_premature_bridge_death()
{
	level endon( "flag_go_to_bridge" );
	level endon( "_stealth_spotted" );
	if ( flag( "_stealth_spotted" ) )
		return;

	self waittill( "death" );

	// if bridge guy killed before the go_to_bridge moment,
	//   just alert everybody
	wait 1;
	flag_set( "_stealth_spotted" );
}

watch_for_bridge_guy_death()
{
	level endon( "river_big_moment_stealth_spotted" );
	if ( flag( "river_big_moment_stealth_spotted" ) )
		return;
	
	self.health = 50;
	
	self waittill( "death" );
	
	// wait for friendlyfire to update before replacing dead guys with drones
	waittillframeend;
	
	// if bridge guy deleted by river cleanup code, just exit
	if ( !IsDefined( self ) )
	{
		return;
	}
	
	find_guy_index = undefined;
	for ( i = 0; i < level.river_bridge_guys.size; i++ )
	{
		if ( self == level.river_bridge_guys[ i ] )
		{
			find_guy_index = i;
			break;
		}
	}
	
	if ( !IsDefined( find_guy_index ) )
	{
		return;
	}
	
	if ( self.bridge_anim_node check_anim_reached( self, self.death_animscene, undefined, "generic" ) &&
		 self.a.pose == "stand" )
	{
		self.a.nodeath = true;
		
		//self animscripts\shared::DropAllAIWeapons();
		self gun_remove();
		//	dummy thread play_sound_in_space( "generic_death_russian_1" );
		level.dead_river_bridge_guys[ find_guy_index ] = maps\_vehicle_aianim::convert_guy_to_drone( self );
		level.dead_river_bridge_guys[ find_guy_index ].animname = "generic";
		level.dead_river_bridge_guys[ find_guy_index ] NotSolid();
		level.dead_river_bridge_guys[ find_guy_index ] ent_flag_init( "guy_done_dying" );
		
		// play death anim
		self.bridge_anim_node anim_single_solo( level.dead_river_bridge_guys[ find_guy_index ], self.death_animscene );
		level.dead_river_bridge_guys[ find_guy_index ] ent_flag_set( "guy_done_dying" );
	}
}

play_river_bridge_scene( death_flag, dead_guy_index, ally, ally_name, anim_node_name, anim_scene, end_trigger, end_flag )
{
	level endon( "river_big_moment_stealth_spotted" );
	
	// wait for bridge guy's death
	flag_wait( death_flag );
	wait 0.05;

	if ( IsDefined( level.dead_river_bridge_guys[ dead_guy_index ] ) )
	{
		// bridge guy was turned into drone, play the pull off bridge anim
		dead_guy_drone = level.dead_river_bridge_guys[ dead_guy_index ];

		anim_node = getstruct( anim_node_name, "targetname" );
		anim_node anim_reach_solo( ally, anim_scene );
		dead_guy_drone ent_flag_wait( "guy_done_dying" );
		
		thread drag_body_off_bridge( dead_guy_drone, ally, ally_name, anim_node, anim_scene, end_trigger, end_flag );
	}
	else
	{
		thread ally_end_bridge( ally, end_trigger, end_flag );
	}
}

drag_body_off_bridge( dead_guy, ally, ally_name, anim_node, anim_scene, end_trigger, end_flag )
{
	ally notify( "kill_ally_river_spotted" );

	if ( anim_node check_anim_reached( ally, anim_scene ) )
	{
		scene_guys = [];
		scene_guys[ "generic" ] = [ dead_guy, 0 ];
		scene_guys[ ally_name ] = [ ally, 0.30 ];
	
		anim_node thread anim_single_end_early( scene_guys, anim_scene );
		
		ally waittill( "anim_ended" );
	}
	
	thread ally_end_bridge( ally, end_trigger, end_flag );
}

ally_end_bridge( ally, end_trigger, end_flag )
{
	ally set_goal_pos( ally.origin );
	ally enable_ai_color_dontmove();
	
	trigger = getent( end_trigger, "targetname" );
	trigger notify( "trigger", level.player );
	flag_set( end_flag );
}

river_cleanup()
{
	// grab everyone alive (except sleeping guard) when you hit the trigger to infiltration
	flag_wait( "end_river_big_moment" );
	all_enemies = GetAIArray( "axis" );
	river_guys = [];
	
	foreach ( enemy in all_enemies )
	{
		add_guy = true;
		if ( IsDefined( level.sleeping_guard ) && level.sleeping_guard == enemy )
		{
			add_guy = false;
		}
		
		if ( add_guy )
		{
			river_guys[ river_guys.size ] = enemy;
		}
	}
	
	flag_wait( "clean_up_river" );
	
	if ( !flag( "river_big_moment_stealth_spotted" ) )
	{
		// if allies never spotted, unset ignoreall from big moment setup
		level.price unset_shared_field_value( "ignoreall" );
		level.soap unset_shared_field_value( "ignoreall" );
	}
	
	AI_delete_when_out_of_sight( river_guys, 1024 );
}

////////////////////////
// river utility scripts
////////////////////////

wait_and_play_anim (wait_flag, anim_string)
{
	self endon( "death" );
	flag_wait( wait_flag );
	self thread anim_generic_loop( self, anim_string );
}

scan_mgturret( gun_yaw_speed_min, gun_yaw_speed_max, min_yaw, max_yaw )
{
	self endon( "death" );
	self endon( "reached_dynamic_path_end" );
	self endon( "stealth_broken_unload" );
	
	AssertEx( IsDefined( self.mgturret[0] ), "must have a mgturret on this vehicle" );

	self.dummy_turret_target = Spawn( "script_origin", self.mgturret[0].origin );
	
	// disable firing, only want to scan
	self.mgturret[0] set_shared_field_value( "TurretFireDisable" );
	self.mgturret[0] SetTargetEntity( self.dummy_turret_target, (0,0,0) );
	
	// get a random speed within the parameters
	gun_yaw_speed = RandomFloat( gun_yaw_speed_max - gun_yaw_speed_min ) + gun_yaw_speed_min;
	gun_yaw_speed_per_frame = gun_yaw_speed * 0.05;
	
	current_gun_yaw = 0;
	while( true )
	{
		if ( IsDefined( self.mgturret ) )
		{
			// figure out a new position for the dummy target based on your current gun angles
			gun_angles = self.mgturret[0].angles;
			gun_angles = ( gun_angles[0], gun_angles[1] + current_gun_yaw, gun_angles[2] );
			forward_vector = AnglesToForward( gun_angles );
			self.dummy_turret_target.origin = self.mgturret[0].origin + ( forward_vector * 72 );
			
			// update your gun angles, if you're at a min or max, get a different random speed
			//   and go back the other direction
			current_gun_yaw = AngleClamp180( current_gun_yaw + gun_yaw_speed_per_frame );
			if ( current_gun_yaw > max_yaw )
			{
				current_gun_yaw = max_yaw;
				gun_yaw_speed = RandomFloat( gun_yaw_speed_max - gun_yaw_speed_min ) + gun_yaw_speed_min;
				gun_yaw_speed_per_frame = gun_yaw_speed * 0.05 * -1;
			}
			else if ( current_gun_yaw < min_yaw )
			{
				current_gun_yaw = min_yaw;
				gun_yaw_speed = RandomFloat( gun_yaw_speed_max - gun_yaw_speed_min ) + gun_yaw_speed_min;
				gun_yaw_speed_per_frame = gun_yaw_speed * 0.05;
			}
			
			//line( self.mgturret[0].origin, self.dummy_turret_target.origin ); 
		}
		else
		{
			self.dummy_turret_target Delete();
			break;
		}
		
		wait 0.05;
	}
}


/////////////////////////////////////////////////
// INFILTRATION
/////////////////////////////////////////////////

infiltration_stealth_settings( warn_time )
{
	level endon( "infiltration_over" );
	level.player endon( "death" );
	level endon( "_stealth_enabled" );
	level endon( "end_tower_stealth_settings" );
	
	AssertEx( flag( "_stealth_enabled" ), "stealth adjusted when no longer on" );
	AssertEx( !flag( "infiltration_over" ), "stealth adjusted when infiltration is over" );
	
	// small stealth settings while touching the trigger.
	trigger = getent( "trig_tower_1", "targetname");
	while ( true )
	{
		if ( level.player IsTouching( trigger ) )
		{
			level notify( "player_at_tower" );
			inf_tower_stealth_settings();
		
			while ( level.player IsTouching( trigger ) )
			{
				wait 0.1;
			}
		}
		
		thread stealth_settings_to_tower( warn_time );
		trigger waittill( "trigger" );
	}
}

stealth_settings_to_tower( warn_time )
{
	level endon( "_stealth_enabled" );
	level endon( "player_at_tower" );
	level endon( "infiltration_over" );
	level endon( "end_tower_stealth_settings" );
	
	wait 1;
	
	inf_stealth_settings();
	
	flag_wait_any( "start_inf_snipe_encounter_1", "trig_yuri_advance" );
	
	inf_aware_stealth_settings();
}

infiltrate_detected()
{
	// end stealth when inf is over
	level endon( "infiltration_over" );
	level endon( "_stealth_enabled" );
	if ( !flag( "_stealth_enabled" ) )
		return;
		
	wait_for_infiltrate_detected();
	
	// needs to be threaded so it doesnt end when it
	//   disables stealth
	aud_send_msg( "mus_overwatch_busted" );
	thread infiltration_end_stealth();
}

wait_for_infiltrate_detected()
{
	level endon( "enemy_bad_event" );
	flag_wait( "_stealth_spotted" );
}

infiltration_end_stealth()
{
	spawners = GetEntArray( "infiltrate_reinforce", "script_noteworthy" );
	array_thread( spawners, ::spawn_ai );
	
	// spotted during infiltration, try to kill player,
	//   but if he fights everyone off, just go to advance section
	flag_set( "inf_stealth_spotted" );
	flag_set( "inf_spotted_dialogue" );
	
	level.price.ignoreall = false;
	level.soap.ignoreall = false;
	level.price.goalradius = 2048;
	level.soap.goalradius = 2048;

	// wait for normal stealth spotted code to run, before disabling stealth
	wait 1;
	
	// just turn off stealth if you're spotted
	disable_stealth_system();
	
	// just go straight to advance
	flag_set( "infiltration_over" );
	
	// wait for stealth to be disabled 
	//  (so color doesn't get turned on if they are in the middle of an anim_reach)
	wait 0.1;
	flag_set( "inf_factory_breach" );
}

infiltrate_autosave()
{
	level notify( "one_infiltrate_autosave" );
	level endon( "one_infiltrate_autosave" );
	
	level.special_autosavecondition = ::inf_tower_save_check;
	thread autosave_stealth();
	
	flag_wait( "game_saving" );
	flag_waitopen( "game_saving" );
	level.special_autosavecondition = undefined;
}

inf_tower_save_check()
{
	level.player endon( "death" );
	
	if ( flag( "warlord_advance" ) )
		return true;
	
	trigger = getent( "trig_tower_1", "targetname");
	if ( level.player IsTouching( trigger ) && !flag( "inf_stealth_spotted" ) )
	{
		// since spotted can disable stealth after awhile, stealth checks will pass,
		//   so make sure you weren't spotted
		return true;
	}
	
	return false;
}

infiltrate_civilians()
{
	flag_init( "inf_civ_runner_go" );
	level.inf_civs = [];
	thread inf_civ_1();
}

inf_civ_1()
{
	door = getent( "inf_civ_door_1", "targetname" );
	door RotateYaw( 90, 0.2, 0.1, 0.1 );
	door ConnectPaths();
	flag_wait( "inf_spawn_truck" );
	civ_run_spawn = getent( "inf_civ_runner", "targetname" );
	civ_runner = civ_run_spawn spawn_ai();
	if ( IsDefined( civ_runner ) )
	{
		civ_runner endon( "death" );
		
		civ_runner.friend_kill_points = -2000;
		level.inf_civs = array_add( level.inf_civs, civ_runner );
		flag_wait( "inf_civ_runner_go" );
		civ_runner thread go_to_node_with_targetname( "inf_civ_runner_node" );
		civ_runner waittill( "goal" );
		door RotateYaw( -90, 0.3, 0.1, 0.1 );
	}
}

inf_encounter_first_patroller()
{
	thread monitor_price_door_trigger();
	
	flag_init( "price_door_triggered" );
	flag_init( "price_post_kill_move_done" );
	flag_wait( "infiltrate_encounter_1" );
	flag_set( "aud_infiltrate_encounter_1" );
	
	spawner = getent( "snipe_guy_1", "targetname" );
	guy = spawner spawn_ai();
	if ( IsDefined( guy ) )
	{
		guy.animname = "generic";
		guy.allowdeath = true;
		guy.grenadeammo = 0;
		
		level.soap thread soap_hand_signal_and_move( guy );
		
		thread inf_encounter_1_stealth();
		thread interrupt_inf_encounter_1( guy );
		
		price_corner_kill( guy );
		if ( IsAlive( guy ) )
		{
			guy waittill( "death" );
		}
	}
		
	// stop dynamic run
	level.price thread ally_post_corner_kill_move( "node_inf_price_house", "price_post_bridge" );

	wait_til_can_start_inf();
	
	flag_set( "large_group_dialogue" );
	aud_send_msg( "mus_tower_snipe" );
	//wait( 3 );
	
	org_door = getent( "org_price_sniper_door", "targetname" );
	org_door anim_reach_and_approach_solo( level.price, "sniper_open_door", undefined, "Cover Right" );
	
	// if some other goal was given somehow, and price is not at the door,
	//   try to go to it again
	while ( !org_door check_anim_reached( level.price, "sniper_open_door" ) )
	{
		org_door anim_reach_and_approach_solo( level.price, "sniper_open_door", undefined, "Cover Right" );
	}
	
	flag_set( "start_inf_door_open" );
	door = getent( "sniper_door", "targetname" );
	door thread delayed_door_open_slow( 0.75 );
	door thread wait_to_close_sniper_door();
	org_door anim_single_solo( level.price, "sniper_open_door" );
	flag_set( "inf_civ_runner_go" );
	
	level.price enable_ai_color_dontmove();
	level.soap enable_ai_color_dontmove();

	activate_trigger_with_targetname( "trig_sniper_post_door" );
	
	thread start_inf_stealth();

	flag_set( "obj_take_overwatch_position" );
	flag_set( "cover_us_dialogue" );
}

inf_encounter_1_stealth()
{
	level endon( "start_inf_door_open" );
	if ( flag( "start_inf_door_open" ) )
		return;
		
	back_to_river_trigger = GetEnt( "back_to_river_trigger", "targetname" );
	start_infiltration_trigger = GetEnt( "start_infiltration_trigger", "targetname" );
	
	set_stealth_ranges( "inf_patroller" );
	
	while ( true )
	{
		back_to_river_trigger waittill( "trigger" );
		river_medium_stealth_ranges();
		start_infiltration_trigger waittill( "trigger" );
		set_stealth_ranges( "inf_patroller" );
	}
}

wait_to_close_sniper_door()
{
	flag_wait( "advance_player_at_combat" );
	self RotateTo( self.angles + ( 0, -110, 0 ), 0.2, 0.1, 0.1 );
}

wait_til_can_start_inf()
{
	// clean up river when price opening door to infiltration
	flag_set( "clean_up_river" );
	flag_waitopen( "_stealth_spotted" );
	
	flag_wait( "price_door_triggered" );
}

start_inf_stealth()
{
	if ( flag( "_stealth_spotted" ) )
	{
		// just end inf if going in spotted
		thread infiltration_end_stealth();
	}
	else
	{
		level.price.ignoreall = true;
		level.soap.ignoreall = true;
		
		thread infiltrate_detected();
		thread infiltration_stealth_settings( 10 );
	}
}

price_corner_kill( guy )
{
	level endon( "skip_encounter_1" );
	
	reach_price_corner_kill( guy );
	if ( IsAlive( guy ) && !guy doingLongDeath() )
	{
		thread price_corner_kill_interrupted( guy );
		guy delaythread( 4.3, ::corner_kill_uninterruptible );

		guys = [];
		guys[ 0 ] = [ guy, 0 ];
		guys[ 1 ] = [ level.price, 0.35 ];

		org = getstruct( "struct_knife_anim", "targetname" );
		org thread anim_single_end_early( guys, "price_corner_kill" );
		level.price waittill( "anim_ended" );
		level.price enable_ai_color_dontmove();
		detach_knife( level.price );
	}
}

price_corner_kill_interrupted( victim )
{
	level endon( "paired_kill_uninterruptible" );
	
	wait_for_corner_kill_interrupted( victim );
	level notify( "paired_kill_interrupted" );
	
	// kill any anim playing
	level.price notify( "single anim", "end" );
	level.price StopAnimScripted();
	level.price enable_ai_color_dontmove();
	detach_knife( level.price );
	
	if ( IsDefined( victim ) && IsAlive( victim ) )
	{
		victim notify( "single anim", "end" );
		victim StopAnimScripted();
	}
	
	// don't ignoreall, will turn back on by start_inf_stealth before overwatch
	level.price.ignoreall = false;
	level.soap.ignoreall = false;
}

wait_for_corner_kill_interrupted( victim )
{
	victim endon( "death" );
	level waittill( "skip_encounter_1" );
}

corner_kill_uninterruptible()
{
	self endon( "death" );
	level endon( "skip_encounter_1" );

	self disable_stealth_for_ai();
	self.allowdeath = false;
	level notify( "paired_kill_uninterruptible" );
}

// if player beats price to the corner, don't do scripted stuff
interrupt_inf_encounter_1( guy )
{
	guy endon( "death" );
	level endon( "paired_kill_uninterruptible" );
	guy inf_guy_1_alerted();
	level notify( "skip_encounter_1" );
	aud_send_msg( "mus_corner_kill_busted" );
}

inf_guy_1_alerted()
{
	self wait_inf_guy_1_alert();
	inf_stealth_settings();
}

wait_inf_guy_1_alert()
{
	// end if you have know of an enemy
	self endon( "enemy" );
	
	// skip paired kill if going past trigger
	trig_interrupt_inf_encounter_1 = GetEnt( "interrupt_snipe_guy_1", "targetname" );
	trig_interrupt_inf_encounter_1 endon( "trigger" );
	
	// end if everything is not normal
	self ent_flag_waitopen( "_stealth_normal" );
}

reach_price_corner_kill( enemy )
{
	enemy endon( "death" );
	level.price endon( "death" );
	
	flag_init( "enemy_reaches_price_corner_kill" );
	flag_init( "price_reaches_price_corner_kill" );
	
	org = getstruct( "struct_knife_anim", "targetname" );
	old_goalradius = enemy.goalradius;
	enemy.goalradius = 0;
	org thread enemy_reach_price_corner_kill( enemy );
	org thread price_reach_price_corner_kill( level.price );
	
	flag_wait( "enemy_reaches_price_corner_kill" );
	flag_wait( "price_reaches_price_corner_kill" );
	enemy.goalradius = old_goalradius;
}

enemy_reach_price_corner_kill( enemy )
{
	enemy endon( "death" );
	level.price endon( "death" );
	
	self anim_reach_solo( enemy, "price_corner_kill" );
	flag_set( "enemy_reaches_price_corner_kill" );
}

price_reach_price_corner_kill( price )
{
	price endon( "death" );

	// wait til we're sure we've gotten the goal from the bridge,
	//   so anim reach can overwrite it.
	flag_wait( "price_post_bridge" );
	wait 0.05;
	
	arrivalEnt = Spawn( "script_origin", self.origin );
	arrivalEnt.angles = ( self.angles[0], AngleClamp180( self.angles[1] + 48 ), self.angles[2] );
	arrivalEnt anim_reach_and_approach_solo( price, "price_corner_kill", undefined, "Cover Right" );
	arrivalEnt Delete();
	
	wait 0.2;
	flag_set( "price_reaches_price_corner_kill" );
	aud_send_msg( "mus_corner_kill" );
}

monitor_price_door_trigger()
{
	// in case it's triggered before the kill is done
	trig_sniper_price_door = GetEnt( "trig_sniper_price_door", "targetname" );
	trig_sniper_price_door waittill( "trigger" );
	
	flag_wait( "price_post_bridge" );
	flag_wait( "soap_post_bridge" );
	
	flag_set( "price_door_triggered" );
}

ally_post_corner_kill_move( goal_node, pre_move_wait_flag )
{
	self endon( "death" );
	flag_wait( pre_move_wait_flag );
	
	wait 0.05;
	if ( !self ent_flag_exist( "_stealth_normal" ) || self ent_flag( "_stealth_normal" ) )
	{
		self enable_cqbwalk();
	}
	
	// kill all back tracking pathing at this point.
	//   disable ai color in case stealth switches and changes your color.
	self notify( "kill_ally_river_spotted" );
	self disable_ai_color();
	self thread go_to_node_with_targetname( goal_node );
}

soap_hand_signal_and_move( victim )
{
	flag_wait( "soap_post_bridge" );
	wait 0.05;

	org = getstruct( "org_soap_wall_cover", "targetname" );
	org anim_reach_solo( level.soap, "soap_wall_cover_enter" );
	if ( IsDefined( victim ) && IsAlive( victim ) )
	{
		org anim_single_solo( level.soap, "soap_wall_cover_enter" );
		
		if ( IsDefined( victim ) && IsAlive( victim ) )
		{
			org thread anim_loop_solo( level.soap, "soap_wall_cover_idle", "end_loop" );
			victim waittill( "death" );
			wait( 2 );
			org notify( "end_loop" );
		}
		
		org anim_single_solo( level.soap, "soap_wall_cover_exit" );
	}
	
	level.soap enable_ai_color_dontmove();
	level.soap ally_post_corner_kill_move( "node_inf_soap_house", "soap_post_bridge" );
}

inf_encounter_sleeping_guard()
{
	spawner = getent( "inf_guy_sleep", "targetname" );
	level.sleeping_guard = spawner spawn_ai();
	aud_send_msg("sleeping_guard_spawned",level.sleeping_guard);
	thread handle_sleeping_guy( level.sleeping_guard );
	thread start_sniper_encounters( level.sleeping_guard );
}

start_sniper_encounters( guy )
{
	level endon( "inf_stealth_spotted" );

	flag_init( "throat_stab" );
	flag_init( "sleeping_guy_dead" );
	
	trigger_wait_targetname( "trig_tower_1" );
	
	level.soap thread disable_cqbwalk();
	level.price thread disable_cqbwalk();
	
	if ( IsDefined( guy ) && IsAlive( guy ) )
	{
		guy waittill( "death" );
	}

	flag_set( "start_inf_snipe_encounter_1" );
}

handle_sleeping_guy( guy )
{
	if ( !IsDefined( guy ) )
	{
		return;
	}
	
	guy.allowdeath = 1;
	guy.ignoreme = 1;
	guy.ignoreall = 1;
	guy.dontevershoot = 1;
	guy.health = 50;
	guy.animname = "generic";
	guy gun_remove();
	guy set_battlechatter( false );
	
	chair = spawn_anim_model( "chair" );
	
	guy thread check_for_melee_stab( chair );
	guy thread anim_sleep( chair );
	guy thread wake_guy_up( chair );

	if ( IsAlive( guy ) )
	{
		guy waittill( "death" );
		flag_set( "sleeping_guy_dead" );
	}
	
	if ( IsDefined( level.player.in_stab_animation ) )
	{
		level.player waittill( "stab_finished" );
	}
	
	chair thread knock_over_chair();
	clean_up_stab();
}

no_neck_stab_hint()
{
	if ( !IsAlive( level.player ) )
	{
		return true;
	}
	
	if ( !IsDefined( level.player.ready_to_neck_stab ) || !level.player.ready_to_neck_stab )
	{
		return true;
	}
	
	if ( IsDefined( level.player.in_stab_animation ) && level.player.in_stab_animation )
	{
		return true;
	}
	
	return false;
}

ready_to_stab()
{
	level.player AllowMelee( false );
	level.player.ready_to_neck_stab = true;
	level.player display_hint( "neck_stab_hint" );
}

clean_up_stab()
{
	if ( IsDefined( level.player.ready_to_neck_stab ) && level.player.ready_to_neck_stab )
	{
		level.player.ready_to_neck_stab = undefined;
		level.player AllowMelee( true );
	}
}

check_for_melee_stab( chair )
{
	self endon( "death" );
	level.player endon( "death" );
	self endon( "guy_waking_up" );
	
	max_stab_distance_sq = 125 * 125;
	while ( true )
	{
		distance_from_player = DistanceSquared( level.player.origin, self.origin );
		angle_diff = abs( AngleClamp180( level.player.angles[1] - self.angles[1] ) );
		if ( angle_diff < 45 && distance_from_player < max_stab_distance_sq )
		{
			ready_to_stab();
			
			if ( level.player MeleeButtonPressed() && isAlive( self ) && !level.player IsMeleeing() && !level.player IsThrowingGrenade() )
			{
				aud_send_msg("aud_kill_sleeping_guard");
				self thread throat_stab_me( chair );
				return;
			}
		}
		else
		{
			clean_up_stab();
		}
		
		wait 0.05;
	}
}

throat_stab_me( chair )
{
	level.player.in_stab_animation = true;	
	
	// not using SetUpPlayerForAnimations as arbitrary waits in it
	//   can cause issues
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player AllowSprint( false );
	level.player SetStance( "stand" );
		
	level.player DisableWeapons();
	level.player DisableWeaponSwitch();
	level.player DisableOffhandWeapons();
	
	anim_org = SpawnStruct();
	anim_org.origin = self.origin;
	anim_org.angles = self.angles;
	
	player_rig = spawn_anim_model( "player_rig" );
	player_rig Hide();
	
	flag_set( "throat_stab" );

	guys = [];
	guys[ 0 ] = player_rig;
	guys[ 1 ] = self;

	// move ents to first frame of anim
	anim_org anim_first_frame_solo( player_rig, "throat_stab" );

	// interpolate player to anim start
	blend_time = 0.4;
	level.player PlayerLinkToBlend( player_rig, "tag_player", blend_time, 0.2, 0.2 );
	wait blend_time;

	if(isAlive(self))
	{
		// show knife
		player_rig Show();
		player_rig attach( "weapon_parabolic_knife", "tag_weapon_right", true );
	
			// play anims
		chair thread knock_over_chair();
		anim_org anim_single( guys, "throat_stab" );
		self kill();
		//AssertEx( !IsAlive( self ), "victim not killed during animation." );
	
		// clean up
		player_rig detach( "weapon_parabolic_knife", "tag_weapon_right", true );
		player_rig Hide();
	}

	level.player Unlink();
	player_rig Delete();	
	
	// manually point player to next place
	new_player_pos = ( level.player.origin[0], level.player.origin[1], level.player.origin[2] + 6 );
	dummy_origin = Spawn( "script_origin", new_player_pos );
	dummy_origin.angles = ( 20, -40, 0 );
	
	blend_time = 0.4;
	level.player PlayerLinkToBlend( dummy_origin, undefined, blend_time, 0, 0.2 );

	level.player EnableOffhandWeapons();	
	level.player EnableWeaponSwitch();
	level.player EnableWeapons();
	wait( blend_time );
	
	level.player Unlink();
	
	maps\_shg_common::SetUpPlayerForGamePlay();
	level.player.in_stab_animation = undefined;
	level.player notify( "stab_finished" );
}

anim_sleep( chair )
{
	self endon( "death" );	
	org = getent( "org_guard_sleep", "targetname" );
	
	org anim_first_frame_solo( chair, "sleep_react" );
	org anim_generic_loop( self, "sleep_idle" );
}

wake_guy_up( chair )
{
	self endon( "death" );
	level endon( "throat_stab" );
	
	self wait_for_waking_event();
	
	aud_send_msg("aud_wake_sleeping_guard");
	
	// waking up, no throat stab allowed
	self notify( "guy_waking_up" );
	clean_up_stab();
	
	// wake guy up!
	org = getent( "org_guard_sleep", "targetname" );
	chair thread knock_over_chair();
	org anim_generic( self, "sleep_react" );
	
	self.ignoreme = false;
	self.ignoreall = false;
	self.dontevershoot = undefined;
	self.health = self.maxhealth;
	self thread set_battlechatter( true );
	self thread gun_recall();
}

// wait for something to wake you up
wait_for_waking_event()
{
	self endon( "death" );
	self endon( "flashbang" );
	level endon( "inf_stealth_spotted" );
	
	flag_wait( "start_inf_door_open" );
	
	self AddAIEventListener( "gunshot" );
	self AddAIEventListener( "bulletwhizby" );
	self AddAIEventListener( "explode" );
	
	while ( true )
	{
		self waittill( "ai_event", event_type );
		
		if ( event_type == "gunshot" || event_type == "bulletwhizby" || event_type == "explode" )
			return;
	}
}

knock_over_chair()
{
	if ( !IsDefined( self.knocked_over ) )
	{
		self.knocked_over = true;
		org = getent( "org_guard_sleep", "targetname" );
		org anim_single_solo( self, "sleep_react" );
	}
}

handle_mantle_brush()
{
	brush = getent( "sniper_tower_mantle", "targetname" );
	original_org = brush.origin;
	brush.origin = ( 0, 0, 0 );
	flag_wait_any( "inf_stealth_spotted", "infiltration_over" );
	brush.origin = original_org;
}

infiltrate_move( target_node, in_flag )
{
	self notify( "new_infiltrate_move" );
	self endon( "new_infiltrate_move" );
	
	self enable_sprint();
	old_radius = self.goalradius;
	self.goalradius = 8;
	self set_goal_node( target_node );
	self waittill( "goal" );
	self disable_sprint();
	
	if( isdefined( in_flag ) )
	{
		flag_set( in_flag );
	}
}

infiltration_patroller_setup()
{
	self.health = 1;
	self.grenadeammo = 0;
	
	if ( !IsDefined( level.inf_guys ) )
	{
		level.inf_guys = [];
	}
	
	level.inf_guys[ level.inf_guys.size ] = self;
}

inf_snipe_encounters()
{
	level endon( "inf_stealth_spotted" );

	flag_init( "price_inf_kill_done" );
	flag_init( "soap_inf_kill_done" );

	soap_node_4 = getnode( "node_price_inf_4", "targetname" );
	price_node_4 = getnode( "node_soap_inf_6", "targetname" );
	
	thread house_guys();
	thread inf_melee_kills();
	flag_wait( "price_inf_kill_done" );

	thread infiltrate_autosave();
	
	thread inf_sniper_encounter_1();
	flag_wait_any( "inf_ramp_guys_dead", "inf_ramp_guys_gone" );
	flag_set( "inf_nice_shot_vo" );
	flag_wait( "inf_encounter_2_vo_done" );
	thread inf_sniper_encounter_2();
	flag_wait( "inf_talkers_dead" );
	level.soap thread infiltrate_move( soap_node_4 );
	level.price thread infiltrate_move( price_node_4 );
	
	thread inf_sniper_encounter_3();
	flag_set( "more_militia_dialogue" );
	flag_wait( "tower_patrols_dead" );
	flag_set( "inf_both_moving_dialogue" );

	flag_set( "inf_factory_breach" );
	flag_wait( "inf_factory_breach_done" );
	
	flag_set( "infiltration_over" );
	
	// stealth over
	disable_stealth_system();
	
	thread inf_reinforce_end_guys();
}

inf_fence_cleanup( mantle, in_origin )
{
	level.player endon( "death" );
	flag_wait_any( "inf_factory_breach", "infiltration_over", "inf_stealth_spotted" );
	
	clip = getent( "inf_fence_clip", "targetname" );
	
	mantle.origin = in_origin;
	clip delete();
}

house_guys()
{
	spawners = getentarray( "inf_end_badguys", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::infiltration_patroller_setup );
	array_thread( spawners, ::add_spawn_function, ::inf_house_guys_setup );
	array_thread( spawners, ::add_spawn_function, ::inf_house_guys_spotted_on_death );
	array_spawn( spawners );
	
	dog_spawner = getent( "inf_end_hyena", "targetname" );
	dog_spawner add_spawn_function( ::inf_house_guys_setup );
	dog = dog_spawner spawn_ai( true );
	dog ent_flag_init( "_stealth_enabled" );
	dog.moveplaybackrate = 0.7;
}

inf_house_guys_setup()
{
	self endon( "death" );
	self set_battlechatter( false );
	self.goalradius = 8;
	self set_goal_pos( self.origin );
	flag_wait( "infiltration_over" );
	self ent_flag_clear( "_stealth_enabled" );
	self set_battlechatter( true );
	
	if ( flag( "inf_stealth_spotted" ) )
	{
		// advanced because was spotted
		self.ignoreall = 0;
		self.goalradius = 1024;
		if( self.classname == "actor_enemy_dog_hyena" )
		{
			self set_goal_pos( level.price.origin );
		}
	}
	else
	{
		// advanced through stealth
		self thread house_guy_ai();
	}
}

house_guy_ai()
{
	self endon( "death" );
	
	self.ignoreall = 1;
	self.goalradius = 8;
	self set_goal_pos( level.price.origin );
	wait_to_be_alert();
	self.ignoreall = 0;
	self.goalradius = 1024;
}

wait_to_be_alert()
{
	self endon( "bulletwhizby" );
	wait 2;
}

inf_house_guys_spotted_on_death()
{
	level endon( "inf_stealth_spotted" );
	level endon( "infiltration_over" );
	
	// force stealth to be broken if any of the house guys are killed.
	//   to prevent killing all the house guys and not breaking stealth 
	//   which causes progression issues.
	
	self waittill( "death" );
	wait 1.1;
	flag_set( "_stealth_spotted" );
}

inf_melee_kills()
{
	level endon( "inf_stealth_spotted" );
	
	price_teleport = getstruct( "org_inf_price_teleport", "targetname" );
	soap_teleport = getstruct( "org_inf_soap_teleport", "targetname" );
	
	//flag_wait( "inf_teleport_allies" );
	//level.price teleport_ent( price_teleport );
	//level.price set_goal_pos( level.price.origin );
	//level.soap teleport_ent( soap_teleport );
	//level.soap set_goal_pos( level.soap.origin );
	
	flag_wait_any( "throat_stab", "sleeping_guy_dead" );
	
	if( flag( "throat_stab" ) )
	{
		wait( 0.5 );
		price_teleport_2 = getstruct( "org_inf_price_teleport_2", "targetname" );
		soap_teleport_2 = getstruct( "org_inf_soap_teleport_2", "targetname" );
		
		level.price teleport_ent( price_teleport_2 );
		level.price set_goal_pos( level.price.origin );
		level.soap teleport_ent( soap_teleport_2 );
		level.soap set_goal_pos( level.soap.origin );
		
		wait( 0.5 );
		
		thread price_inf_kill();
		thread soap_inf_kill();
	}
	else
	{
		flag_set( "price_inf_kill_done" );
		//level.price teleport_ent( price_teleport );
		level.price set_goal_ent( price_teleport );
		//level.soap teleport_ent( soap_teleport );
		level.soap set_goal_ent( soap_teleport );
	}
}

inf_clear_graph_blocker()
{
	blocker = getent( "inf_graph_blocker", "targetname" );
	blocker DisconnectPaths();
	level waittill_any( "inf_stealth_spotted", "inf_ramp_guys_dead" );
	blocker ConnectPaths();
	blocker delete();
}

price_inf_kill()
{
	level endon( "inf_stealth_spotted" );
	
	spawner = getent( "inf_price_melee_kill", "targetname" );
	guy = spawner spawn_ai( true );
	guy.animname = "generic";
	guy set_battlechatter( false );
	org = getstruct( "org_price_melee_kill", "targetname" );
	guys = [];
	guys[ 0 ] = level.price;
	guys[ 1 ] = guy;
	org anim_reach( guys, "price_corner_kill_2" );
	
	// thread off kill so once it starts, it completes and cleans up successfully
	thread play_price_inf_kill( org, guy );
}

play_price_inf_kill( org, guy )
{
	guys = [];
	guys[ 0 ] = level.price;
	guys[ 1 ] = guy;
	
	wait( 0.5 );
	org anim_single( guys, "price_corner_kill_2" );
	// animation puts gun on chest and never places it back.
	level.price animscripts\shared::PlaceWeaponOn( level.price.weapon, "right" );
	guy kill_no_react();
	level.price enable_ai_color_dontmove();
	activate_trigger_with_targetname( "trig_inf_price_melee_kill" );
	flag_set( "price_inf_kill_done" );
}

soap_inf_kill()
{
	level endon( "inf_stealth_spotted" );
	
	spawner_1 = getent( "inf_soap_ambush", "targetname" );
	guy_1 = spawner_1 spawn_ai( true );
	guy_1.animname = "generic";
	guy_1.ignoreme = true;
	guy_1.ignoreall = true;
	guy_1 set_battlechatter( false );
	guys = [];
	guys[ 0 ] = level.soap;
	guys[ 1 ] = guy_1;
	anim_org = getstruct( "org_soap_door_kill", "targetname" );
	anim_org anim_reach( guys, "soap_door_kill" );
	
	thread play_soap_inf_kill( anim_org, guy_1 );
}

play_soap_inf_kill( anim_org, guy_1 )
{
	guys = [];
	guys[ 0 ] = level.soap;
	guys[ 1 ] = guy_1;
	
	anim_org anim_single( guys, "soap_door_kill" );
	guy_1 kill();
	level.soap enable_ai_color_dontmove();
	activate_trigger_with_targetname( "trig_inf_soap_melee_kill" );
	flag_set( "soap_inf_kill_done" );
}

inf_sniper_encounter_1()
{
	level endon( "inf_stealth_spotted" );
	
	wait( 1 );
	soap_node = getnode( "soap_inf_enc_1_node", "targetname" );
	price_node = getnode( "price_inf_enc_1_node", "targetname" );
	
	if( !flag( "throat_stab" ) )
	{
		level.soap thread infiltrate_move( soap_node );
		level.price infiltrate_move( price_node );
	}
	else
	{
		level.soap thread infiltrate_move( soap_node );
		level.price thread infiltrate_move( price_node );
	}
	
	flag_set( "multiple_guards_dialogue" );
	//thread inf_sniper_encounter_2();
	thread snipe_encounter_timeout( 20, "inf_ramp_guys_dead" );
	
	wait(2);
	
	spawners = getentarray( "inf_encounter_4", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::inf_sniper_encounter_1_setup );
	array_thread( spawners, ::add_spawn_function, ::infiltration_patroller_setup );
	array_thread( spawners, ::add_spawn_function, ::patroller_logic, "london_dock_soldier_walk" );
	array_spawn( spawners );
}

inf_sniper_encounter_2()
{
	level endon( "inf_stealth_spotted" );
	
	thread snipe_encounter_timeout( 20, "inf_talkers_dead" );
	
	spawners = getentarray( "inf_patrol", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::patroller_logic, "london_dock_soldier_walk" );
	array_thread( spawners, ::add_spawn_function, ::infiltration_patroller_setup );
	array_thread( spawners, ::add_spawn_function, ::inf_sniper_encounter_1_setup );
	array_thread( spawners, ::spawn_ai, true );
}

inf_sniper_encounter_3()
{
	level endon( "inf_stealth_spotted" );
	
	thread snipe_encounter_timeout( 30, "tower_patrols_dead" );
	
	inf_tower_patrol = [];
	inf_tower_patrol[ inf_tower_patrol.size ] = getent( "inf_tower_patrol_1", "targetname" );
	inf_tower_patrol[ inf_tower_patrol.size ] = getent( "inf_tower_patrol_2", "targetname" );
	inf_tower_patrol[ inf_tower_patrol.size ] = getent( "inf_tower_patrol_3", "targetname" );
	
	inf_tower_patrol[ 0 ] add_spawn_function( ::patroller_logic );
	inf_tower_patrol[ 0 ] add_spawn_function( ::infiltration_patroller_setup );
	inf_tower_patrol[ 1 ] add_spawn_function( ::patroller_logic );
	inf_tower_patrol[ 1 ] add_spawn_function( ::infiltration_patroller_setup );
	
	inf_tower_patrol[ 2 ] add_spawn_function( ::patroller_logic, "london_dock_soldier_walk" );
	inf_tower_patrol[ 2 ] add_spawn_function( ::infiltration_patroller_setup );
	inf_tower_patrol[ 2 ] add_spawn_function( ::inf_tower_guy_setup );
	
	inf_tower_patrollers = array_spawn( inf_tower_patrol );
	foreach ( guy in inf_tower_patrollers )
	{
		guy.disable_dive_whizby_react = true;
	}
}

inf_factory_breach()
{
	flag_wait( "inf_factory_breach" );
	
	level.soap delaythread( 1, ::enable_sprint );
	level.price delaythread( 1, ::enable_sprint );
	
	guys = [];
	guys[ 0 ] = level.price;
	guys[ 1 ] = level.soap;
	org = getstruct( "org_factory_breach", "targetname" );
	
	org anim_reach( guys, "factory_breach" );
	while ( !org check_anim_reached( guys, "factory_breach" ) )
	{
		org anim_reach( guys, "factory_breach" );
	}

	org anim_single( guys, "factory_breach" );
	flag_set( "breaching_factory_dialogue" );
	
	level.price enable_ai_color_dontmove();
	level.soap enable_ai_color_dontmove();
	
	activate_trigger_with_targetname( "trig_allies_post_factory_breach" );
	
	level.soap disable_sprint();
	level.price disable_sprint();
	
	flag_wait( "breaching_factory_dialogue_done" );
	activate_trigger_with_targetname( "trig_inf_allies_end" );
	flag_set( "inf_factory_breach_done" );
	
	// if you were spotted, don't pause price by the barrel, just keep him moving
	if ( flag( "inf_stealth_spotted" ) )
	{
		activate_trigger_with_targetname( "trig_price_to_advance" );
	}
	else
	{
		thread path_price_to_advance();
	}
}

path_price_to_advance()
{
	level.price waittill( "goal" );
	level.price endon( "goal_changed" );
	wait 5;
	activate_trigger_with_targetname( "trig_price_to_advance" );
}

inf_sniper_encounter_1_setup()
{
	self endon( "death" );
	wait( 0.05 );
	self.alertlevel = "alert";
	self.moveplaybackrate = 0.6;
	self.health = 1;
	self.disable_dive_whizby_react = true;
}

inf_reinforce_end_guys()
{
	flag_wait( "inf_end_guys_aggro" );
	spawners = getentarray( "inf_end_guys", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::handle_inf_reinforce_end_guys );
	array_spawn( spawners );
}

handle_inf_reinforce_end_guys()
{
	self endon( "death" );
	self.health = 1;
}

// after a certain amount of time, make everyone more aware
snipe_encounter_timeout( expire_time, death_flag )
{
	level endon( "inf_stealth_spotted" );
	level endon( death_flag );
	
	if ( flag( death_flag ) )
		return;
	
	if ( IsDefined( expire_time ) )
	{
		wait expire_time;
	}
	
	thread snipe_encounter_aware( death_flag );
}

snipe_encounter_aware( reset_stealth_flag )
{
	level endon( "inf_stealth_spotted" );
	
	level.price unset_shared_field_value( "ignoreme" );
	level.soap unset_shared_field_value( "ignoreme" );
	inf_aware_stealth_settings();
	
	// don't switch stealth ranges based on tower if patroller time expired
	level notify( "end_tower_stealth_settings" );
	
	flag_wait( reset_stealth_flag );
	
	level.price set_shared_field_value( "ignoreme" );
	level.soap set_shared_field_value( "ignoreme" );
	
	// if you actually survived, set the stealth range to be dependent on the tower again
	thread infiltration_stealth_settings( 5 );
}

inf_tower_guy_setup()
{
	self endon( "death" );
	wait( .05 );
	self.moveplaybackrate = 0.2;
	self.health = 1;
}

infiltrate_cleanup()
{
	flag_wait( "advance_player_at_combat" );
	
	//delete civs
	level.inf_civs thread inf_delete_array();
	
	//delete any inf guys
	if ( IsDefined( level.inf_guys ) )
	{
		AI_delete_when_out_of_sight( level.inf_guys, 1024 );
	}
}

inf_delete_array()
{
	foreach( guy in self )
	{
		if( isDefined( guy ) && isAlive( guy ) )
		{
			guy delete();
		}
	}
}

show_switch_hint()
{
	flag_wait( "show_switch_hint" );
	display_hint( "switch_hint" );
}


/////////////////////////////////////////////////
// ADVANCE
/////////////////////////////////////////////////

yuri_advance()
{
	flag_wait( "infiltration_over" );
	
	level.soap thread safe_force_use_weapon( "ak47_reflex", "primary" );
	level.price thread safe_force_use_weapon( "ak47_reflex", "primary" );
	
	if ( flag( "inf_stealth_spotted" ) )
	{
		flag_wait_any( "inf_factory_breach_done", "start_spotted_advance_flag" );
		
		flag_set( "obj_move_through_shanty_given");
		flag_wait( "start_spotted_advance_flag" );
	}
	else
	{
		flag_set( "obj_move_through_shanty_given");
		autosave_by_name( "advance_through_shanty" );
		thread soap_gets_in_dive_position();
		flag_wait( "start_stealth_advance_flag" );
	}
	
	flag_set( "warlord_advance" );
}

soap_gets_in_dive_position()
{
	org_soap_dive_over_cover = GetStruct( "org_soap_dive_over_cover", "targetname" );
	
	org_soap_dive_over_cover anim_reach_solo( level.soap, "dive_over_cover" );
	org_soap_dive_over_cover anim_first_frame_solo( level.soap, "dive_over_cover" );
	level.soap set_goal_pos( level.soap.origin );
}

weapon_switch_hint()
{
	weapon = level.player GetCurrentWeapon();
	
	if( weapon != "m14ebr_scoped_silenced_warlord" )
	{
		return true;
	}
	
	return false;
}

advance_soap_runs_for_cover()
{
	soap_runs_for_cover_trigger = GetEnt( "soap_runs_for_cover_trigger", "targetname" );
	if ( !IsDefined( soap_runs_for_cover_trigger ) )
	{
		// triggered it before this function ran, just ignore
		return;
	}
	
	soap_runs_for_cover_trigger waittill( "trigger" );
	
	first_shooter_spawner = GetEnt( "advance_first_shooter", "targetname" );
	first_shooter = first_shooter_spawner spawn_ai( true );
	if ( !IsDefined( first_shooter ) || flag( "inf_stealth_spotted" ) )
	{
		// could not spawn the first shooter (probably in line of sight),
		//   OR was spotted in infiltration.
		//     skip intro
		return;
	}
	
	thread play_soap_dive_over_cover( first_shooter );
	
	first_shooter.ignoreme = true;
	first_shooter.goalradius = 8;
	first_shooter set_goal_pos( first_shooter.origin );
	first_shooter SetLookAtEntity( level.soap );
	first_shooter.favoriteenemy = level.soap;
	first_shooter.dontevershoot = true;
	first_shooter.alertlevel = "combat";

	thread ignore_while_advance_intro( first_shooter );
	
	first_shooter endon( "death" );
	
	wait 0.2;
	first_shooter shoot_around_target( level.soap, 1.4, 20, 30, -20, 20, 1, 2, true );

	// shoot cover piece as soap mantles
	wait 0.3;
	first_shooter shoot_around_target( level.soap, 1.4, 20, 30, -35, -10, 1, 2, false );
	
	first_shooter SetLookAtEntity();
	first_shooter.ignoreme = false;
	first_shooter.favoriteenemy = undefined;
	first_shooter.dontevershoot = undefined;
	first_shooter.goalradius = 2048;
	
	wait 1;
	
	level notify( "advance_intro_over" );
}

play_soap_dive_over_cover( attacker )
{
	org_soap_dive_over_cover = GetStruct( "org_soap_dive_over_cover", "targetname" );
	if ( IsAlive( attacker ) )
	{
		// soap is running for cover, make it look good
		thread grenade_near_target( attacker, level.soap );
	
		org_soap_dive_over_cover anim_single_solo( level.soap, "dive_over_cover" );
		
		/*
		ent = SpawnStruct();
		ent.origin = drop_to_ground( level.soap.origin );
		ent.origin = ( ent.origin[0], ent.origin[1], ent.origin[2] + 1 );
		ent.angles = level.soap.angles;		
		ent thread anim_loop_solo( level.soap, "CornerCrL_alert_idle", "stop_loop" );
		*/
		
		level.soap thread anim_loop_solo( level.soap, "CornerCrL_alert_idle", "stop_loop" );
		//level.soap thread anim_custom_animmode_loop( [ level.soap ], "gravity", "CornerCrL_alert_idle" );
		level.soap enable_ai_color_dontmove();
		
		wait 0.5;
		level.soap notify( "stop_loop" );
	}
}

grenade_near_target( owner, target )
{
	to_forward = AnglesToForward( target.angles );
	to_right = AnglesToRight( target.angles );
	
	soap_dive_explosion = GetStruct( "soap_dive_explosion", "targetname" );
	MagicGrenadeManual( "fraggrenade", soap_dive_explosion.origin, (0,0,0), 1.1 );
}

shoot_around_target( target, duration, min_side_distance, max_side_distance, min_up_distance, max_up_distance, min_frame_wait, max_frame_wait, refresh_target )
{
	self endon( "death" );
	
	target_pos = target GetEye();
	
	while ( duration > 0 )
	{
		if ( refresh_target )
		{
			target_pos = target GetEye();
		}
		
		target_right = AnglesToRight( target.angles );
		
		random_side_distance = RandomFloatRange( min_side_distance, max_side_distance );
		if ( CoinToss() )
		{
			random_side_distance = random_side_distance * -1;
		}
		
		dummy_target = target_pos + ( target_right * random_side_distance );
		dummy_target = ( dummy_target[0], dummy_target[1], dummy_target[2] + RandomFloatRange( min_up_distance, max_up_distance ) );
		self Shoot( 100, dummy_target );
		random_wait = 0.05 * RandomIntRange( min_frame_wait, max_frame_wait );
		
		if ( random_wait >= duration )
		{
			wait duration;
			duration = 0;
		}
		else
		{
			wait random_wait;
			duration = duration - random_wait;
		}
	}
}

ignore_while_advance_intro( first_shooter )
{
	level.price.grenadeawareness = 0;
	level.soap.grenadeawareness = 0;
	level.soap.ignoreall = true;
	level.soap disable_bulletwhizbyreaction();
	wait_til_advance_intro_over( first_shooter );
	level.price.grenadeawareness = 0.9;
	level.soap.grenadeawareness = 0.9;
	level.soap.ignoreall = false;
	level.soap enable_bulletwhizbyreaction();
	level.soap.grenadeawareness = 0.9;
}

wait_til_advance_intro_over( first_shooter )
{
	first_shooter endon( "death" );
	level waittill( "advance_intro_over" );
}

advance_go_loud()
{
	flag_wait( "start_stealth_advance_flag" );
	
	thread advance_move_guys_forward();
	
	flag_wait( "advance_player_at_combat" );
	
	thread advance_wave_1_complete();
	thread advance_to_technical_music();
	level.soap.goalradius = 2048;
	
	flag_set( "obj_go_loud_given");
	flag_set( "go_noisy_dialogue" );
	
	flag_wait( "inf_factory_breach_done" );
	flag_wait( "advance_combat_complete" );
	wait( 0.05 );
	activate_trigger_with_targetname( "trig_advance_combat_complete" );
}

advance_move_guys_forward()
{
	trigger_array = getentarray ("advance_guys_forward", "targetname");
	flag_set( "push_forward_dialogue" );
	foreach (trigger in trigger_array)
	{
		trigger thread move_guys_forward();
	}
}

move_guys_forward()
{
	position = getstruct (self.target, "targetname");
	self waittill ("trigger");
	guys = getentarray ("advance_first_wave", "script_noteworthy");
	foreach (guy in guys)
	{
		if (isAlive (guy))
		{
			guy set_goal_pos (position.origin);
			guy set_goal_radius (position.radius);
		}
	}
}

advance_wave_1_complete()
{
	flag_wait( "advance_combat_complete" );
	flag_set( "advance_go_loud_complete" );
	flag_set( "obj_follow_price_advance_given" );
}

advance_to_technical_music()
{
	flag_wait_any( "advance_combat_complete", "advance_done" );
	aud_send_msg( "mus_to_technical" );
}

monitor_advance_skip()
{
	level endon( "stop_monitoring_advance_skip" );
	
	thread check_allies_at_technical();
	
	start_technical_area_trigger = GetEnt( "trig_at_technical_combat", "targetname" );
	while ( true )
	{
		start_technical_area_trigger waittill( "trigger", ent );
		
		if ( ent == level.player )
		{
			flag_set( "advance_done" );
		}
		else
		{
			ent.at_technical_area = true;
		}
	}
}

check_allies_at_technical()
{
	flag_wait( "player_technical_drivein" );
	flag_wait( "inf_factory_breach_done" );
	
	// if allies haven't gotten to the technical ladder
	//   by this time, teleport them to it
	if ( !IsDefined( level.price.at_technical_area ) || !IsDefined( level.soap.at_technical_area ) )
	{
		if ( !IsDefined( level.price.at_technical_area ) )
		{
			level.price move_entity_to_start( "price_teleport_safeguard" );
			level.price.at_technical_area = true;
		}
	
		if ( !IsDefined( level.soap.at_technical_area ) )
		{
			level.soap move_entity_to_start( "soap_teleport_safeguard" );
			level.soap.at_technical_area = true;
		}
		
		// make sure allies are pathing to correct area
		flag_set( "advance_combat_complete" );
		waittillframeend;
		activate_trigger_with_targetname( "trig_technical_combat" );
	}
	
	level notify( "stop_monitoring_advance_skip" );
}

/////////////////////////////////////////////////
// TECHNICAL
/////////////////////////////////////////////////

technical_drivein_turret()
{
	flag_init( "technical_reached_end_node" );
	flag_wait( "player_technical_spawn" );
	
	// grab dudes to kill off
	level.advance_guys = GetAIArray( "axis" );
	
	level.player_technical = spawn_vehicle_from_targetname( "player_technical" );
	level.player_technical SetCanDamage( false );
	level.player_technical.dontunloadonend = true;
	level.player_technical thread technical_riders_ignore( true );
	level.player_technical thread technical_riders_invul( true );
	thread spawn_initial_technical_guys();
	wait( 0.5 );
	flag_wait( "player_technical_drivein" );
	aud_send_msg("player_technical", level.player_technical);
	level.player_technical thread gopath();
	level.player_technical thread technical_riders_ignore( false );
	level.player_technical thread vehicle_turret_no_ai_detach();
	level.player_technical thread technical_riders_invul( false );
	flag_set( "technical_ahead_dialogue" );
	level.player_technical thread monitor_path_end();
	
	//technical_setup
	technical_target = getent( "technical_target", "targetname" );
	level.player_technical_turret = level.player_technical.mgturret[0];
	level.player_technical_turret SetMode( "manual" );
	level.player_technical_turret SetTargetEntity( technical_target );
	level.player_technical_turret thread technical_shooting();
	
	foreach ( guy in level.player_technical.riders )
	{
		if ( guy.vehicle_position == 0 )
		{
			level.player_technical.driver = guy;
			level.player_technical.driver thread watch_for_driver_death();
		}
		else if ( guy.vehicle_position == 1 )
		{
			guy thread watch_for_gunner_death( level.player_technical, level.player_technical_turret );
		}
	}
}

technical_kill_player()
{
	level endon( "warlord_player_mortar" );
	level.player endon( "death" );
	flag_wait( "technical_kill_player" );
	
	player_angles = level.player GetPlayerAngles();
	player_yaw = ( 0, player_angles[1], 0 );
	player_forward = VectorNormalize( AnglesToForward( player_yaw ) );
	random_forward_amount = RandomIntRange( 2 * 12, 5 * 12 );
	random_forward = player_forward * random_forward_amount;
		
	player_right = VectorNormalize( AnglesToRight( player_angles ) );
	random_right_amount = RandomIntRange( -3 * 12, 3 * 12 );
	random_right = player_right * random_right_amount;
	
	from_pos = ( level.player.origin[0], level.player.origin[1], level.player.origin[2] + ( 20 * 12 ) );
	from_pos = from_pos + random_forward + random_right;
	to_pos = ( level.player.origin[0], level.player.origin[1], level.player.origin[2] - ( 10 * 12 ) );
	to_pos = to_pos + random_forward + random_right;
	trace = BulletTrace( from_pos, to_pos, 0, undefined );
	if ( trace[ "fraction" ] < 1 )
	{
		// hit something
		hit_pos = trace["position"];
		hit_info = trace;
		
		maps\_weapon_mortar60mm::mortar_hit( hit_pos, 20 * 12, 512, 512, hit_info );
	}
	
	wait 0.05;
	if ( IsAlive( level.player ) )
	{
/#
		if ( IsGodMode( level.player ) )
			return;
#/
		
		level.player Kill();
	}
}

technical_riders_ignore( ignore )
{
	if( ignore )
	{
		foreach( rider in self.riders )
		{
			rider.ignoreall = true;
			rider.ignoreme = true;
		}
	}
	else
	{
		foreach( rider in self.riders )
		{
			rider.ignoreall = false;
			if( rider.vehicle_position == 0 )
			{
				rider.ignoreme = false;
			}
		}
	}
}

technical_riders_invul( invul )
{
	if ( invul )
	{
		foreach ( rider in self.riders )
		{
			rider magic_bullet_shield();
		}
	}
	else
	{
		foreach ( rider in self.riders )
		{
			if ( IsDefined( rider.magic_bullet_shield ) )
			{
				rider stop_magic_bullet_shield();
			}
		}
	}
}

spawn_initial_technical_guys()
{
	spawners = getentarray( "tech_arena_enemies_intro", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::lower_turret_guy_accuracy );
	array_spawn( spawners );
}

lower_turret_guy_accuracy()
{
	self.baseaccuracy = 0.05;
}

monitor_path_end()
{
	self endon( "death" );
	self waittill( "reached_end_node" );
	flag_set( "technical_reached_end_node" );
}

path_to_technical()
{
	self endon( "death" );
	level endon( "technical_combat_complete" );
	
	//path soap to the open area to cover the player
	flag_wait("turret_ready_to_use");
	flag_wait( "inf_factory_breach_done" );
	//path_node = getnode("tech_arena_soap_node_1", "targetname");
	//old_radius = self.goalradius;
	//self.goalradius = 32;
	//self set_goal_node(path_node);
	
	flag_wait( "trig_technical_rear" );
	flag_wait( "player_on_technical" );
	wait(1.0);
	
	//self.goalradius = old_radius;
	self thread soap_pulls_driver_out();
}

soap_pulls_driver_out()
{
	// self == soap
	level.player_technical anim_reach_solo( self, "technical_driver_pull_out", "tag_body" );
	self enable_ai_color();
	
	// if soap never made it to the technical before it got hit, just exit
	if ( flag( "mortar_technical" ) )
	{
		AssertEx( false, "soap did not make it to technical in time?" );
		return;
	}
	
	flag_wait("technical_reached_end_node");
	
	if ( IsAlive( level.player_technical.driver ) )
	{
		// kill driver if not already dead
		level.player_technical.driver thread kill_technical_driver();
	}
	
	guys = [];
	guys[0] = self;
	guys[1] = level.dead_driver;
	
	level.player_technical anim_single( guys, "technical_driver_pull_out", "tag_body" );
	level.player_technical thread anim_loop_solo( self, "technical_driver_pull_out_idle", "end_driver_idle", "tag_body" );
	
	flag_wait( "mortar_technical" );
	level.player_technical notify( "end_driver_idle" );
}

technical_drivein_combat(delete_dudes_flag)
{
	level endon("technical_combat_complete");
	
	wait 3.25;
	technical_1 = spawn_vehicle_from_targetname_and_drive( "tech_arena_technical_1" );
	aud_send_msg("arena_technical_01", technical_1);
	technical_1 thread setup_technical_technical( delete_dudes_flag, true );
	technical_1 thread crash_technical();
	technical_1 thread vehicle_turret_no_ai_detach();
	technical_1 thread technical_wait_delete();
	flag_set( "technical_1_dialogue" );
	
	flag_wait( "technical_drivein_combat_2_begin" );
	flag_set( "technical_2_dialogue" );
	technical_2 = spawn_vehicle_from_targetname_and_drive( "tech_arena_technical_2" );
	aud_send_msg("arena_technical_02", technical_2);
	technical_2 thread setup_technical_technical( delete_dudes_flag, false );
	technical_2 thread crash_technical();
	technical_2 thread vehicle_turret_no_ai_detach();
	technical_2 thread technical_wait_delete();
}

setup_technical_technical( delete_dudes_flag, slow_guys, wait_time )
{
	self endon( "death" );
	self.dontunloadonend = true;
	technical_driver = undefined;
	foreach( guy in self.riders)
	{
		guy thread delete_combat_dudes_from_flag_set(delete_dudes_flag);
		if ( slow_guys )
		{
			guy thread slow_enemies_technical_initial_combat();
		}
		guy.grenadeammo = 0;
		
		if ( guy.vehicle_position == 0 )
		{
			guy thread driver_invulnerable_while_driving( self );
		}
	}
	
	self waittill( "reached_dynamic_path_end" );
	
	self.dontunloadondeath = true;
	self vehicle_unload( "passenger_and_driver" );
}

technical_wait_delete()
{
	flag_wait( "delete_destroyed_technicals" );
	if( isDefined( self ) )
	{
		self notify( "delete_destructible" );
		self delete();
	}
}

driver_invulnerable_while_driving( vehicle )
{
	self endon( "death" );
	self magic_bullet_shield();
	vehicle wait_for_path_end_or_death();
	self stop_magic_bullet_shield();
}

wait_for_path_end_or_death()
{
	self endon( "reached_dynamic_path_end" );
	self waittill( "death" );
	wait 2;
}

crash_technical()
{
	self endon( "reached_dynamic_path_end" );
	
	while ( true )
	{
		self waittill( "damage", amount, attacker );
		if ( !attacker_isonmyteam( attacker ) && !attacker_troop_isonmyteam( attacker ) )
		{
			break;
		}
	}

	self.script_crashtypeoverride = "none";

	self thread make_riders_stay_in();
}

make_riders_stay_in()
{
	// ghetto way of getting the guys to stay in even though the vehicle is killed.
	//  may not be what you expect if more than 1 vehicle active at the same time...
	old_unload_ondeath = [];
	for ( i = 0; i < level.vehicle_aianims[ self.classname ].size; i++ )
	{
		anim_pos = level.vehicle_aianims[ self.classname ][i];
		old_unload_ondeath[i] = anim_pos.unload_ondeath;
		anim_pos.unload_ondeath = 2.5;
	}
	
	self waittill_any( "death_finished", "reached_dynamic_path_end" );
	for ( i = 0; i < level.vehicle_aianims[ self.classname ].size; i++ )
	{
		level.vehicle_aianims[ self.classname ][i].unload_ondeath = old_unload_ondeath[i];
	}
}

technical_combat()
{
	level endon("technical_turret_combat_timer_complete");
	flag_init("technical_drivein_combat_2_begin");
	spawners_initial = getentarray("tech_arena_enemies_wave_1", "targetname");
	array_thread( spawners_initial, ::add_spawn_function, ::technical_arena_lower_accuracy );
	spawners_front = getentarray( "turret_spawners_1", "targetname" );
	spawners_right = getentarray( "turret_spawners_2", "targetname" );
	spawners_roof_right = getentarray( "turret_spawners_3", "targetname" );
	spawners_roof_left = getentarray( "turret_spawners_4", "targetname" );
	spawners_left = getentarray( "turret_spawners_5", "targetname" );
	turret_time = 57;
	level.total_foot_guys = 0;
	
	flag_wait( "player_technical_drivein" );
	
	// kill off dudes first
	if ( IsDefined( level.advance_guys ) )
	{
		foreach( ai in level.advance_guys )
		{
			if ( IsDefined( ai ) && IsAlive( ai ) )
			{
				ai Kill();
			}
		}
		
		level.advance_guys = undefined;
	}
	
	// adjust accuracy of enemy AI while on turret
	thread technical_combat_adjust_enemy_accuracy();
	
	//initial wave - 2 dudes on foot coming down the hill
	level thread technical_combat_wave_think(spawners_initial);
	
	//path soap to the open area to cover the player once the turret guy is dead
	level.soap thread path_to_technical();
	
	//waits
	flag_wait("turret_ready_to_use");
	flag_wait("player_at_technical_arena");
	
	flag_set("technical_combat_started");
	
	//start timer for combat to end
	thread technical_turret_combat_timer(turret_time);
	
	//turn on badplaces
	thread technical_turret_badplace( turret_time );
	

	//wave 1, technical
	level thread technical_drivein_combat("mortar_technical_hit");
	wait( 6.0 );
	level thread spawn_technical_wave(spawners_initial);
	wait( 2.0 );
	level thread spawn_technical_wave(spawners_initial);
	wait( 0.5 );

	//wave 2, dudes
	spawners_right_total = array_combine( spawners_roof_right, spawners_right );
	thread technical_combat_dialogue( 4, "roof_right_dialogue" );
	thread technical_combat_wave_think( spawners_right_total, 15.0, 4 );
	level waittill( "next_combat_wave" );
	
	//wave 3, dudes
	thread technical_combat_dialogue( 3, "contact_front_1_dialogue" );
	thread technical_combat_wave_think(spawners_front, 10.0, 3);
	level waittill( "next_combat_wave" );

	//wave 4, dudes
	spawners_left_total = array_combine( spawners_left, spawners_roof_left );
	thread technical_combat_dialogue( 4, "contact_left_1_dialogue" );
	thread technical_combat_wave_think( spawners_left_total, 12.0, 3 );
	thread manage_technical_combat_door();
	level waittill( "next_combat_wave" );
	
	/*
	//wave 5, dudes
	thread technical_combat_dialogue( 5, "contact_left_2_dialogue" );
	thread technical_combat_wave_think(spawners_left, 8.0, 2);
	level waittill( "next_combat_wave" );
	*/
	
	//wave 6, 2nd technical
	flag_set("technical_drivein_combat_2_begin");
	wait( 1.0 );
	
	//wave 7, dudes
	spawners_right_front = array_combine( spawners_right, spawners_front );
	thread technical_combat_dialogue( 5, "contact_front_2_dialogue" );
	thread technical_combat_wave_think( spawners_right_front, 15.0, 4 );
	level waittill( "next_combat_wave" );
	
	//wave 8, dudes
	thread technical_combat_dialogue( 5, "contact_right_1_dialogue" );
	thread technical_combat_wave_think(spawners_right_total, 10.0, 2);
	level waittill( "next_combat_wave" );

	//wave 10, dudes
	thread technical_combat_dialogue( 5, "contact_left_3_dialogue" );
	thread technical_combat_wave_think(spawners_left, 10.0, 2);
	level waittill( "next_combat_wave" );
	
	//wave 11, dudes
	thread technical_combat_dialogue( 5, "contact_left_4_dialogue" );
	thread technical_combat_wave_think(spawners_roof_left, 10.0, 2);
	level waittill( "next_combat_wave" );
	
	//wave 12, dudes
	thread technical_combat_dialogue( 5, "contact_front_3_dialogue" );
	thread technical_combat_wave_think(spawners_front, 10.0, 2);
	level waittill( "next_combat_wave" );
	level notify( "technical_stalled_combat_complete" );
}

technical_turret_badplace( turret_time )
{
	level endon( "technical_combat_complete" );
	flag_wait( "player_on_technical" );
	badplace_volume_array = getentarray( "turret_combat_badplace", "targetname" );
	foreach ( badplace_volume in badplace_volume_array )
	{
		badplace_brush( "", turret_time, badplace_volume, "bad_guys" );
	}
}

technical_arena_lower_accuracy()
{
	self endon( "death" );
	self.accuracy = 0.06;
}

manage_technical_combat_door()
{
	if( !flag( "technical_combat_door_open" ) )
	{
		door = getent( "technical_combat_door", "targetname" );
		door RotateYaw( -110, 0.2, 0.1, 0.1 );
		door ConnectPaths();
		flag_set( "technical_combat_door_open" );
	}
}

monitor_player_at_back_of_truck()
{
	level endon( "player_on_technical" );
	level endon( "technical_combat_complete" );
	while( 1 )
	{
		flag_wait( "trig_player_at_back_of_truck" );
		wait( 10 );
		if( flag( "trig_player_at_back_of_truck" ) )
		{
			thread spawn_behind_truck_guys();
			wait( 20 );
		}
	}
}

spawn_behind_truck_guys()
{
	spawners = getentarray( "player_behind_truck_guys", "targetname" );
	array_spawn( spawners );
}

// this function is needed because we need to thread the wait for the flag,
//   otherwise the "next_combat_wave" notify could be missed.
// also, don't say anything if the next wave is already killed off.
technical_combat_dialogue( delay, flag_string )
{
	level endon( "technical_combat_complete" );
	level endon( "next_combat_wave" );
	if ( flag( "technical_combat_complete" ) )
		return;
	
	wait delay;
	flag_set( flag_string );
}

technical_combat_adjust_enemy_accuracy()
{
	level endon( "technical_combat_complete" );

	flag_wait( "player_boarding_technical" );
	
	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		if ( !isalive( guy ) )
			continue;
		
		guy.baseaccuracy = 0;
	}

	flag_wait( "player_on_technical" );

	while( true )
	{
		ai = GetAIArray( "axis" );
		foreach ( guy in ai )
		{
			
			if ( !isalive( guy ) )
				continue;
				
			if( !guy ent_flag_exist( "can_lower_accuracy" ) )
			{
				guy ent_flag_init( "can_lower_accuracy" );
				guy thread determine_can_lower_accuracy();
			}
				
			if( !guy ent_flag( "can_lower_accuracy" ) )
			{
				guy.baseaccuracy = 0.2;
				continue;
			}

			player_angles = level.player GetPlayerAngles();
			if ( within_fov_2d( level.player.origin, player_angles, guy.origin, cos( 60 ) ) )
			{
				guy.baseaccuracy = 0.2;
			}
			else
			{
				guy.baseaccuracy = 0;
			}
			
			wait( 0.02 );
		}
		
		wait( 0.05 );
	}
}

determine_can_lower_accuracy()
{
	self endon( "death" );
	
	self ent_flag_set( "can_lower_accuracy" ); 
	wait( 8 );
	self ent_flag_clear( "can_lower_accuracy" );
}

technical_combat_complete()
{
	level.player endon( "death" );
	
	level waittill_any("technical_turret_combat_timer_complete", "technical_stalled_combat_complete");
	flag_set( "technical_combat_complete" );
	
	// make sure you're not in the process of boarding the technical
	flag_waitopen( "player_boarding_technical" );
	
	thread delete_technical_wave_guys();

	if( flag( "player_on_technical" ))
	{
		thread maps\warlord_fx::pre_truck_mortar_vfx();
		wait(1.3);
		level thread crash_player_technical( level.player_technical );
		thread technical_mortar_explosions();
	}
	else
	{
		unloaded_ai = level.player_technical vehicle_unload();
		if (isDefined(unloaded_ai[0]))
		{
			unloaded_ai[0] waittill( "jumpedout" );
		}
		
		wait 0.05;
		
		thread spawn_technical_mob();
		
		level.player EnableDeathShield( true );
		level.player_technical SetCanDamage( true );
		thread maps\_weapon_mortar60mm::fire_mortar_at( level.player_technical.origin, 1, 150, 256, 3100, 3100 );
		flag_set( "obj_commandeer_technical_done" );
		wait( 1.0 );
		
		level.price thread handle_end_arena_guys();
		level.soap thread handle_end_arena_guys();
		
		flag_set( "mortar_technical" );
		flag_set( "mortar_technical_hit" );
		level notify( "turret_finished" );
		// delete barrier
		rubble = getentarray( "mortar_rubble", "targetname" );
		foreach( rubble_piece in rubble )
		{
			rubble_piece show();
		}
		
		blockers = getentarray( "technical_blocker_graph", "targetname" );
		foreach( blocker in blockers )
		{
			blocker ConnectPaths();
		}
		
		shanty_blocker_trigger = GetEnt( "shanty_45_blocker_trigger", "targetname" );
		if ( IsDefined( shanty_blocker_trigger ) )
		{
			shanty_blocker_trigger notify( "trigger" );
		}
		
		activate_trigger_with_targetname ("trig_price_mortar_01");
		activate_trigger_with_targetname ("trig_soap_mortar_start");
		
		wait 5;
		level.player EnableDeathShield( false );
	}
}

delete_technical_wave_guys()
{
	flag_wait( "mortar_technical_hit" );
	
	if ( flag( "player_on_technical" ) )
	{
		foreach ( guy in level.technical_wave_guys )
		{
			if( isAlive( guy ) )
			{
				guy delete();
			}
		}
	}
	else
	{
		delete_guys = [];
		foreach ( guy in level.technical_wave_guys )
		{
			if ( IsAlive( guy ) )
			{
				guy.goalradius = 8;
				guy set_goal_pos( guy.origin );
				delete_guys[ delete_guys.size ] = guy;
			}
		}
		
		AI_delete_when_out_of_sight( delete_guys, 512 );
	}
}

handle_end_arena_guys()
{
	self.ignoreall = 1;
	flag_wait( "delete_technical_arena_guys" );
	self.ignoreall = 0;
}

technical_mortar_explosions()
{
	mortar_explosion_technical_1 = getstruct ("mortar_explosion_technical_1", "targetname");
	flag_wait ("mortar_technical_hit");
	aud_send_msg( "mus_mortar_inbound" );
	thread maps\warlord_fx::mortar_explosion_0_fx();
	wait (4.3);
	thread maps\_weapon_mortar60mm::fire_mortar_at( mortar_explosion_technical_1.origin, 1, 150, 256, 100, 25 );
}

technical_combat_wave_think( spawner_array, time, guys_left_alive )
{
	level endon( "next_combat_wave" );
	level endon( "technical_combat_complete" );
	level notify( "reset_death_counter" );
	level.wave_guys_alive = 0;
	level.wave_spawners_active = 0;
	
	//spawn guys
	AssertEx( IsDefined( spawner_array ), "spawner_array is undefined" );
	
	// wait to start next wave until all guys are dead or the timeout time has been reached.
	//   need to have timer thread kick off before spawning (spawning could happen over several frames)
	if ( IsDefined( time ) )
	{
		level thread technical_combat_wave_timer( time );
	}
	
	if ( IsDefined( spawner_array ) )
	{
		spawn_technical_wave( spawner_array );
	}
	
	if ( IsDefined( guys_left_alive ) )
	{
		while ( level.wave_guys_alive > guys_left_alive )
		{
			level waittill( "wave_guy_removed" );
		}

		level notify( "next_combat_wave" );
	}
}

spawn_technical_wave( spawner_array )
{
	//spawn guys
	AssertEx( IsDefined( spawner_array ), "spawner_array is undefined" );
	
	array_thread( spawner_array, ::add_spawn_function, ::setup_technical_wave_guy );
	
	// keep track of how many spawners have finished spawning.
	//   there are delays on the spawners, but we want them all to start
	//   at the same time so the delay is accurate.  and we block until 
	//   all spawners are done.
	level.wave_spawners_active = spawner_array.size;
	
	foreach( spawner in spawner_array )
	{
		while ( level.total_foot_guys > 12 )
		{
			level waittill( "foot_guy_removed" );
		}
		
		// have to increment here, in case there's a delay in the spawner
		level.total_foot_guys++;
		spawner thread spawn_technical_wave_guy();
	}

	while ( level.wave_spawners_active > 0 )
	{
		level waittill( "wave_spawner_done" );
	}
}

spawn_technical_wave_guy()
{
	level endon( "next_combat_wave" );
	self spawn_ai();
	level.wave_spawners_active--;
	level notify( "wave_spawner_done" );
}

setup_technical_wave_guy()
{
	self endon( "death" );
	
	if ( !IsDefined( level.technical_wave_guys ) )
		level.technical_wave_guys = [];

	level.technical_wave_guys[ level.technical_wave_guys.size ] = self;
	
	self.grenadeammo = 0;
	self.goalradius = 8;
	self.deathFunction = ::set_turret_death_anim;
	self thread manage_wave_guy_count();
	self thread manage_total_foot_guy_count();
}

manage_wave_guy_count()
{
	level endon("reset_death_counter");
	level.wave_guys_alive++;
	self waittill("death");
	level.wave_guys_alive--;
	level notify( "wave_guy_removed" );
}

manage_total_foot_guy_count()
{
	self waittill( "death" );
	level.total_foot_guys--;
	level notify( "foot_guy_removed" );
}

set_turret_death_anim()
{
	// how do i detect a turret death?  
	if ( self.damageweapon == "none" && self.damagetaken > 100 )
	{
		deathAnim = animscripts\death::getStrongBulletDamageDeathAnim();
		if ( IsDefined( deathAnim ) )
		{
			self.deathAnim = deathAnim;
		}
	}
	
	// continue thru normal animscript either way
	return false;
}

technical_combat_wave_timer(time)
{
	level endon( "technical_combat_complete" );
	level endon( "next_combat_wave" );
	wait( time );
	level notify( "next_combat_wave" );
}

technical_turret_combat_timer(time)
{
	level endon("technical_stalled_combat_complete");
	wait(time);
	level notify("technical_turret_combat_timer_complete");
}

delete_combat_dudes_from_flag_set(flag)
{
	self endon("death");
	flag_wait(flag);
	if (isAlive(self))
	{
		self delete();
	}
}

delete_badplace( flag )
{
	flag_wait(flag);
	badplace_delete(self);
}

slow_enemies_technical_initial_combat()
{
	self endon("death");
	self.moveplaybackrate = 0.5;
	flag_wait_or_timeout( "player_on_technical", 10 );
	self.moveplaybackrate = 1;
}

#using_animtree( "vehicles" );
player_get_on_technical( turret )
{
	level endon( "technical_combat_complete" );
	
	AssertEx( IsDefined( level.dead_gunner ), "gunner dead body model not defined" );
	
	gunner_pos = self GetTagOrigin( "tag_gunner" );
	
	// create new trigger to intercept turret use message
	turret MakeUnusable();
	usable_turret_trigger = Spawn( "script_origin", gunner_pos );
	usable_turret_trigger setHintString( &"PLATFORM_HOLD_TO_USE" );
	usable_turret_trigger MakeUsable();
	
	// set up objects to be on first frame
	player_rig = spawn_anim_model( "player_rig", level.player.origin );
	player_rig Hide();
	
	guys = [];
	guys[ "player_rig" ] = player_rig;
	guys[ "turret" ] = turret;
	guys[ "gunner" ] = level.dead_gunner;
	
	thread player_get_on_technical_abort( usable_turret_trigger, player_rig, level.dead_gunner );
	
	turret ClearAnim( %root, 0 );
	level.dead_gunner Unlink();
	self anim_first_frame( guys, "get_on_technical", "tag_body" );
	usable_turret_trigger waittill( "trigger" );
	usable_turret_trigger Delete();
	
	thread player_boarding_technical( player_rig, turret );
}

player_boarding_technical( player_rig, turret )
{
	guys = [];
	guys[ "player_rig" ] = player_rig;
	guys[ "turret" ] = turret;
	guys[ "gunner" ] = level.dead_gunner;
	
	// everything set up, wait until we get a use trigger, then play get on anim
	flag_set( "player_boarding_technical" );
	aud_send_msg("player_using_tech_turret");
	
	level.player.lastweapon = level.player GetCurrentWeapon();
	level.player DisableWeapons();
	level.player set_ignoreme( true );
	level.player SetStance( "stand" );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	
	thread lerp_fov_overtime( 2, 55 );
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.4, 0.2, 0.2 );
	wait 0.2;
	player_rig delayCall( 0.2, ::Show );
	
	self anim_single( guys, "get_on_technical", "tag_body" );

	player_rig Delete();
	level.dead_gunner Delete();
	
	turret ClearAnim( %root, 0 );
	self thread player_use_technical_turret( turret );
	
	// don't do default DoF logic, doesn't work for turret for some reason
	level.level_specific_dof = true;
	level.player thread set_turret_depth_of_field();
	
	level.player set_ignoreme( false );
	flag_set( "player_on_technical" );
	aud_send_msg( "mus_player_on_technical" );
	flag_set( "obj_commandeer_technical_done" );
	
	flag_clear( "player_boarding_technical" );
}

player_get_on_technical_abort( usable_turret_trigger, player_rig, dead_gunner )
{
	usable_turret_trigger endon( "trigger" );
	
	flag_wait( "technical_combat_complete" );
	
	if ( IsDefined( usable_turret_trigger ) )
	{
		usable_turret_trigger Delete();
	}
	
	if ( IsDefined( player_rig ) )
	{
		player_rig Delete();
	}
	
	wait 1;
	if( IsDefined( level.dead_gunner ) )
	{
		level.dead_gunner delete();
	}
}

set_turret_depth_of_field()
{
	level endon( "mortar_technical_hit" );
	while ( true )
	{
		adsFrac = self PlayerAds();
		if ( adsFrac == 0 )
		{
			self maps\_art::setDefaultDepthOfField();
		}
		else
		{
			self maps\_art::setDoFTarget( adsFrac, 1, 50, 500, 500, 4.5, 1.8 );
		}

		wait 0.05;
	}
}

player_use_technical_turret( turret )
{
	level endon("mortar_technical_hit");
	
	level.player EnableWeapons();
	level.player PlayerLinkToDelta( self, "tag_gunner", 1, 180, 180, 180, 25 );
	turret MakeUsable();
	turret SetMode( "manual" );
	turret UseBy( level.player );
	level.player DisableTurretDismount();
	turret MakeUnusable();

	turret attach( level.scr_model[ "player_rig" ], "tag_player" );
	level.player thread watch_player_death( turret );
	
	is_attacking = false;
	was_attacking = false;
	
	idle_hands_anim = turret getanim( "technical_turret_hands_idle" );
	idle_gun_anim = turret getanim( "technical_turret_gun_idle" );
	turret setAnim( idle_hands_anim, 1, 0, 1 );
	turret setAnim( idle_gun_anim, 1, 0, 1 );
	turret.hands_animation = idle_hands_anim;
	turret.gun_animation = idle_gun_anim;

	while ( IsDefined( turret ) )
	{
		is_attacking = level.player AttackButtonPressed();

		if ( was_attacking != is_attacking )
		{
			if ( is_attacking )
			{
				turret thread animate_turret( "technical_turret_hands_idle2fire", "technical_turret_hands_fire", "technical_turret_gun_idle2fire", "technical_turret_gun_fire" );
			}
			else
			{
				turret thread animate_turret( "technical_turret_hands_fire2idle", "technical_turret_hands_idle", "technical_turret_gun_fire2idle", "technical_turret_gun_idle" );
			}
		}
		
		was_attacking = is_attacking;
		wait 0.05;
	}
}

watch_player_death( turret )
{
	// handle the player dying on the technical
	level endon( "mortar_technical" );
	
	if ( IsAlive( self ) )
	{
		self waittill( "death" );
		turret detach( level.scr_model[ "player_rig" ], "tag_player" );
	}
}

watch_for_driver_death()
{
	self magic_bullet_shield();
	flag_wait( "technical_reached_end_node" );
	self stop_magic_bullet_shield();
	
	//self.health = 5000;
	self bloody_death();
	self thread kill_technical_driver();
}

kill_technical_driver()
{
	AssertEx( flag( "technical_reached_end_node" ), "make sure technical finishes path before killing driver" );
	
	self gun_remove();
	level.dead_driver = maps\_vehicle_aianim::convert_guy_to_drone( self );
	level.dead_driver.animname = "generic";
	level.player_technical anim_first_frame_solo( level.dead_driver, "technical_driver_pull_out", "tag_body" );
	
	flag_wait( "mortar_technical_hit" );
	wait 1;
	if ( IsDefined( level.dead_driver ) )
	{
		level.dead_driver Delete();
	}
}

watch_for_gunner_death( technical, turret )
{
	self.health = 5000;
	self waittill( "damage", amount, attacker, direction, position, damage_type );
	
	if ( IsDefined( position ) && IsDefined( damage_type ) )
	{
		if ( damage_type == "MOD_PISTOL_BULLET" ||
			 damage_type == "MOD_RIFLE_BULLET" || 
			 damage_type == "MOD_EXPLOSIVE_BULLET" )
		{
			PlayFx( getfx( "headshot" ), position );
		}
	}
	
	flag_set( "technical_gunner_dead" );
	
	self gun_remove();
	level.dead_gunner = maps\_vehicle_aianim::convert_guy_to_drone( self );
	level.dead_gunner LinkTo( technical, "tag_gunner" );
	level.dead_gunner.animname = "generic";
	
	turret.animname = "turret";
	turret assign_animtree();
	
	guys = [];
	guys[0] = level.dead_gunner;
	guys[1] = turret;
	
	technical anim_single( guys, "technical_gunner_death", "tag_50cal" );
	turret TurretFireEnable();
	
	flag_set( "turret_ready_to_use" );
}

crash_player_technical( player_technical )
{
	level.player endon( "death" );
	AssertEx( IsDefined( level.player_technical_turret ), "technical turret undefined" );
	AssertEx( IsAlive( level.player ), "player is dead" );

	flag_set( "mortar_technical" );

	player_technical thread soap_dives_out();
	
	aud_send_msg("tech_mortar_incoming");
	level.player EnableDeathShield( true );
	
	// end the player ride
	mortar_explosion_technical = GetStruct( "mortar_explosion_technical", "targetname" );
	thread maps\_weapon_mortar60mm::fire_mortar_at( mortar_explosion_technical.origin, 1.5, 150, 400, 300, 300 );
	wait 1.5;
	
	flag_set( "mortar_technical_hit" );
	
	thread fall_rumble();
	
	// do player damage manually, the mortar radius damage sometimes can't hit the player
	level.player DoDamage( 300, mortar_explosion_technical.origin );
	
	// delete barrier
	rubble = getentarray( "mortar_rubble", "targetname" );
	foreach( rubble_piece in rubble )
	{
		rubble_piece show();
	}
	
	blockers = getentarray( "technical_blocker_graph", "targetname" );
	foreach( blocker in blockers )
	{
		blocker ConnectPaths();
	}
	
	shanty_blocker_trigger = GetEnt( "shanty_45_blocker_trigger", "targetname" );
	if ( IsDefined( shanty_blocker_trigger ) )
	{
		shanty_blocker_trigger notify( "trigger" );
	}
	
	// unequip turret
	level.player DisableWeapons();
	level.player_technical_turret UseBy( level.player );
	level.player_technical_turret detach( level.scr_model[ "player_rig" ], "tag_player" );
	level.player_technical_turret delete();
	level.player Unlink();
	level.level_specific_dof = false;
	thread lerp_fov_overtime( 2, 65 );
	aud_send_msg("player_turret_destroyed");
	
	// create another technical to play the animations on.
	//   this is a workaround because there's no way to stop a vehicle
	//   from pathing once it starts, which causes the vehicle to pop back
	//   to the last vehicle node after animating.
	level.player_technical Delete();
	
	animated_technical = spawn_anim_model( "technical_model" );
	animated_technical.animname = "technical_model";
	
	animated_turret = spawn_anim_model( "turret_model" );
	animated_turret.animname = "turret_model";
	
	//start pathing price
	price_teleport = getent( "price_technical_teleport", "targetname" );
	level.price teleport_ent( price_teleport );
	activate_trigger_with_targetname ("trig_price_mortar_start");
	
	// play knockoff animation
	knock_off_technical_node = getstruct( "anim_knock_off_technical_node", "targetname" );
	
	player_rig = spawn_anim_model( "player_rig", level.player.origin );
	player_rig Hide();
	
	guys = [];
	guys[ "player_rig" ] = player_rig;
	guys[ "technical" ] = animated_technical;
	guys[ "turret" ] = animated_turret;
	guys[ "soap" ] = level.soap;
	
	knock_off_technical_node anim_first_frame( guys, "knock_off_technical" );
	
	ground = getent( "technical_ground", "targetname" );
	ground show();
	
	flag_set( "move_anim_technical_clip" );
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.4, 0.2, 0.2 );
	player_rig Show();
	
	delaythread( 6, ::spawn_technical_mob );
	
	//Get up! We gotta get the hell out of here!
	level.soap thread multiple_dialogue_queue( "knock_off_technical_lines" );
	knock_off_technical_node anim_single( guys, "knock_off_technical" );
	
	player_rig Delete();
	level.player Unlink();
	
	ground hide();
	// player is up
	level.player EnableDeathShield( false );
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	
	level.player switch_player_weapon( "m14ebr_scoped_silenced_warlord", level.player.lastweapon );
	level.player EnableWeapons();

	// get soap and price to run to the right place
	activate_trigger_with_targetname ("trig_soap_mortar_start");
	activate_trigger_with_targetname ("trig_price_mortar_01");
	
	wait 0.05;
	level.soap.a.movement = "run";
	level.soap StopAnimScripted();
	
	level notify( "turret_finished" );
}

move_anim_technical_clip()
{
	level endon( "warlord_mortar_run" );
	clip = getent( "anim_technical_blocker", "targetname" );
	old_origin = clip.origin;
	clip.origin = ( 0, 0, 0 );
	flag_wait( "move_anim_technical_clip" );
	clip.origin = old_origin;
	clip DisconnectPaths();
}

soap_dives_out()
{
	self anim_single_solo( level.soap, "technical_driver_dive_out", "tag_body" );
	level.soap set_goal_pos( level.soap.origin );
	
	level.soap animscripts\weaponList::RefillClip();
	level.soap.a.needsToRechamber = 0;
}

technical_shooting()
{
	level.player_technical_turret SetAISpread( 8 );
	wait_time = RandomFloatRange( 4, 5 );
	wait( wait_time );
	
	while( !flag( "technical_gunner_dead" ) )
	{
		level.player_technical_turret SetAISpread( 5 );
		wait_time = RandomFloatRange( 1.5, 2 );
		wait( wait_time );
		
		level.player_technical_turret SetAISpread( 8 );
		wait_time = RandomFloatRange( 2, 3 );
		wait( wait_time );
	}
}

spawn_technical_mob()
{
	/*truck_1 = spawn_vehicle_from_targetname_and_drive( "mob_technical_1" );
	truck_1.mgturret[0] TurretFireDisable();
	truck_1.dontunloadonend = true;
	truck_1 thread enable_turret();
	truck_1 thread wait_to_delete();
	
	truck_2 = spawn_vehicle_from_targetname_and_drive( "mob_technical_2" );
	truck_2.mgturret[0] TurretFireDisable();
	truck_2.dontunloadonend = true;
	truck_2 thread enable_turret();
	truck_2 thread wait_to_delete();
	*/
	
	spawners = getentarray( "militia_mob_guys", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::setup_milita_mob_guys );
	array_spawn( spawners, true );
}

setup_milita_mob_guys()
{
	self endon( "death" );
	self.baseaccuracy = 0.01;
	self.ignoreall = true;
	flag_wait( "militia_vo_done" );
	//wait( 2 );
	self.ignoreall = false;
	//self thread shoot_around_target( level.player, 5, 20, 30, -35, -10, 1, 2, false );
	trigger_wait_targetname( "trig_soap_melee_kill" );
	if( isDefined( self ) && isAlive( self ) )
	{
		self delete();
	}
}

wait_to_delete()
{
	trigger_wait_targetname( "trig_soap_melee_kill" );
	foreach( guy in self.riders )
	{
		if( isDefined( guy ) && isAlive( guy ) )
		{
			guy delete();
		}
	}
	self delete();
}

/////////////////////////////////////////////////
// MORTAR RUN
/////////////////////////////////////////////////

mortar_run_ally_setup()
{
	self disable_arrivals();
	self enable_sprint();
	self disable_cqbwalk();
}

mortar_gauntlet()
{
	spawners = getentarray( "mortar_badguys", "script_noteworthy" );
	array_spawn_function( spawners, ::setup_mortar_badguys );
	
	level.price.moveplaybackrate = 1.05;
	level.soap.moveplaybackrate = 1.05;
	level.price disable_awareness();
	level.soap disable_awareness();
	player_speed_percent( 90 );
	
	thread mortar_expire_timer( 20 );
	thread mortar_extend_timer_triggers();
	
	thread mortar_run_scripted_explosions();
	thread mortar_run_soap_scripted_kill();
	thread fall_through_roof();
	//thread soap_teleport();
	thread mortar_run_soap_door_kickin();
	thread last_house();
	thread mortar_roof();
	thread mortar_fight_fire();
	thread clear_corpses();
	thread disable_weapons_on_roof();
	
	aud_send_msg("mortar_house_explode");
}

clear_corpses()
{
	trigger_wait_targetname("clear_corpses");
	ClearAllCorpses();
}

mortar_expire_timer( expire_time )
{
	level notify( "end_mortar_expire_timer" );
	level endon( "end_mortar_expire_timer" );
	level endon( "mortar_timer_done" );
	if ( flag( "mortar_timer_done" ) )
	{
		return;
	}
	
	level.mortar_run_expire_time = GetTime() + ( expire_time * 1000 );
	draw_debug_mortar_expire_timer();
	
	while ( level.mortar_run_expire_time > GetTime() )
	{
		wait 0.05;
	}

	// time expired, kill player with fake mortar
	level notify( "new_quote_string" );
	SetDvar( "ui_deadquote", &"WARLORD_MORTAR_DEATH" );
	
	player_angles = level.player GetPlayerAngles();
	player_yaw = ( 0, player_angles[1], 0 );
	player_forward = VectorNormalize( AnglesToForward( player_yaw ) );
	random_forward_amount = RandomIntRange( 2 * 12, 5 * 12 );
	random_forward = player_forward * random_forward_amount;
		
	player_right = VectorNormalize( AnglesToRight( player_angles ) );
	random_right_amount = RandomIntRange( -3 * 12, 3 * 12 );
	random_right = player_right * random_right_amount;
	
	from_pos = ( level.player.origin[0], level.player.origin[1], level.player.origin[2] + ( 20 * 12 ) );
	from_pos = from_pos + random_forward + random_right;
	to_pos = ( level.player.origin[0], level.player.origin[1], level.player.origin[2] - ( 10 * 12 ) );
	to_pos = to_pos + random_forward + random_right;
	trace = BulletTrace( from_pos, to_pos, 0, undefined );
	if ( trace[ "fraction" ] < 1 )
	{
		// hit something
		hit_pos = trace["position"];
		hit_info = trace;
		
		maps\_weapon_mortar60mm::mortar_hit( hit_pos, 20 * 12, 512, 512, hit_info );
	}
	
	wait 0.05;
	if ( IsAlive( level.player ) )
	{
/#
		if ( IsGodMode( level.player ) )
			return;
#/
		
		level.player Kill();
	}
}

mortar_extend_timer_triggers()
{	
	trig_mortar_time_extension = GetEntArray( "trig_mortar_time_extension", "targetname" );
	array_thread( trig_mortar_time_extension, ::set_mortar_expire_timer );
}

set_mortar_expire_timer()
{
	level endon( "mortar_timer_done" );
	if ( flag( "mortar_timer_done" ) )
	{
		return;
	}
	
	AssertEx( IsDefined( self.script_noteworthy ), "trig_mortar_time_extension does not have a required script_noteworthy" );
	
	self waittill( "trigger" );
	thread mortar_expire_timer( Int( self.script_noteworthy ) );
}

draw_debug_mortar_expire_timer()
{
	/*
	// Uncomment when tuning timing
	level.player endon( "death" );

	thread kill_debug_mortar_expire_timer();

	if ( !IsDefined( level.hud_time ) )
	{
		level.hud_time = newHudElem();
	    level.hud_time.foreground = true;
		level.hud_time.alignX = "left";
		level.hud_time.alignY = "top";
		level.hud_time.horzAlign = "left";
	    level.hud_time.vertAlign = "top";
	    level.hud_time.x = 0;
	    level.hud_time.y = 60;
	    //hud_time.sort = level.arcadeMode_hud_sort;
	
	  	level.hud_time.fontScale = 3;
		level.hud_time.color = ( 0.8, 1.0, 0.8 );
		//hud_time.font = "objective";
		level.hud_time.glowColor = ( 0.3, 0.6, 0.3 );
		level.hud_time.glowAlpha = 1;
	
	 	level.hud_time.hidewheninmenu = true;
	}
	
	time_in_seconds = ( level.mortar_run_expire_time - GetTime() ) / 1000;
	level.hud_time settimer( time_in_seconds );
	*/
}

kill_debug_mortar_expire_timer()
{
	flag_wait( "mortar_timer_done" );
	if ( IsDefined( level.hud_time ) )
	{
		level.hud_time Destroy();
	}
}

setup_mortar_badguys()
{
	self.grenadeammo = 0;
	//self.health = 1;
}

mortar_run_scripted_explosions()
{
	//mortars from triggers
	//place a trig multiple in radiant
	//give the trig a targetname of "mortar_explosion_trig"
	//link it to a script struct (this will be the location of the mortar explosion)
	mortar_trig_array = getentarray("mortar_explosion_trig", "targetname");
	mortar_explosion_player_on_roof_1 = getstruct("mortar_explosion_player_on_roof_1", "targetname");
	foreach(mortar_trig in mortar_trig_array)
	{
		mortar_trig thread mortar_explosion();
	}
	
	//mortars while you're in the house where soap kills dude
	thread mortar_explosions_soap_scripted_kill();
	
	//mortar when you go on the roof
	/*flag_wait ("player_on_roof_1");
	wait (4);
	thread maps\_weapon_mortar60mm::fire_mortar_at( mortar_explosion_player_on_roof_1.origin, 1, 150, 256, 100, 25 );
	*/
}

mortar_explosion()
{
	assertEx (isDefined (self), "must have a trigger to trigger mortar explosion");
	assertEx (isDefined (self.target), "must have a trigger linked to a script_struct for mortar explosion");
	
	trigger = self;
	explosion = getstruct( self.target, "targetname" );

	trigger waittill( "trigger" );
	
	thread mortar_run_explosion( explosion );
	
	thread maps\warlord_fx::mortar_explosion_1_fx();
	
}

mortar_run_explosion( explosion )
{
	thread mortar_explosion_generic( explosion );
	
	wait 1;
	
	thread maps\warlord_fx::mortar_explosion_2_fx();
	
	// play react on anyone?
	level.price thread mortar_hit_reaction( explosion.origin );
	level.soap thread mortar_hit_reaction( explosion.origin );
	
	//Do the fence sway if the mortor hits 
	maps\warlord_fx::afr_fence_rattle( explosion.origin );
}

mortar_hit_reaction( hit_position )
{
	if ( self.a.pose == "stand" && self.movemode == "run" )
	{
		hit_distance = Distance( self.origin, hit_position );
		if ( hit_distance < 550 )
		{
			self notify( "play_mortar_react" );
			self endon( "play_mortar_react" );
			
			react_run = choose_mortar_hit_react( hit_distance );
			if ( IsDefined( react_run ) )
			{
				react_run_time = GetAnimLength( react_run );
				self.run_overrideanim = react_run;
				self setFlaggedAnimKnobRestart( "reactanim", react_run, 0.5, 0.5 );
				wait react_run_time	;
				self.run_overrideanim = undefined;
				self notify( "movemode" );
			}
		}
	}
}

choose_mortar_hit_react( hit_distance )
{
	// pick a good mortar hit react, highly specialized for 2 allies and 2 reacts,
	//   just make sure same react doesn't play on both allies at the same time
	if ( IsDefined( level.last_mortar_hit_react ) )
	{
		if ( GetTime() - level.last_mortar_hit_react_time > 500 )
		{
			level.last_mortar_hit_react = undefined;
			level.last_mortar_hit_react_time = undefined;
		}
	}
	
	react_run = undefined;
	if ( hit_distance < 200 )
	{
		run_array = [ "run_react_stumble", "run_react_explosion2" ];
		run_index = RandomIntRange( 0, run_array.size );
		react_run = self getanim( run_array[ run_index ] );
		
		if ( IsDefined( level.last_mortar_hit_react ) && level.last_mortar_hit_react == react_run )
		{
			next_run_index = ( run_index + 1 ) % run_array.size;
			react_run = self getanim( run_array[ next_run_index ] );
		}
	}
	
	if ( !IsDefined( react_run ) )
	{
		run_array = [ "run_react_flinch", "run_react_explosion1" ];
		run_index = RandomIntRange( 0, run_array.size );
		react_run = self getanim( run_array[ run_index ] );
		
		if ( IsDefined( level.last_mortar_hit_react ) && level.last_mortar_hit_react == react_run )
		{
			next_run_index = ( run_index + 1 ) % run_array.size;
			react_run = self getanim( run_array[ next_run_index ] );
		}
	}
	
	level.last_mortar_hit_react = react_run;
	level.last_mortar_hit_react_time = GetTime();

	return react_run;
}

mortar_explosion_generic(target)
{
	maps\_weapon_mortar60mm::fire_mortar_at( target.origin, 1, 150, 256, 100, 25 );
	
	thread maps\warlord_fx::mortar_explosion_3_fx();
	
	// figure out if it's right or left side of the player
	player_to_target = target.origin - level.player.origin;
	player_to_target = VectorNormalize( player_to_target );
	player_right = AnglesToRight( level.player.angles );
	right_dot = VectorDot( player_to_target, player_right );
	if ( right_dot > cos( 60 ) ) // within ~60 degrees of right side
	{
		level notify( "mortar_incoming_dialogue", "right_side" );
	}
	else if ( right_dot < -1 * cos( 60 ) )
	{
		level notify( "mortar_incoming_dialogue", "left_side" );
	}
	else
	{
		level notify( "mortar_incoming_dialogue", "no_side" );
	}
		
	wait( 1.0 );
	playfx( getfx( "garbage" ), target.origin );
	playfx( getfx( "garbage_des" ), target.origin );
}

mortar_explosions_soap_scripted_kill()
{
	trigger_wait_targetname( "trig_soap_melee_kill" );
	mortar_explosion_2 = getstruct( "mortar_explosion_soap_kill_2", "targetname" );
	
	wait ( 2 );
	thread mortar_run_explosion( mortar_explosion_2 );
}

mortar_run_soap_door_kickin()
{
	flag_wait ("trig_soap_door_kickin");
	org = getstruct ("mortar_door_kickin", "targetname");
	//level.price disable_awareness();
	org anim_single_solo_run( level.price, "soap_door_kickin" );
	level.soap disable_awareness();
	level.price enable_awareness();
	flag_set( "mortar_door_dialogue" );
	level.price enable_ai_color();
	//soap_node = getnode( "soap_teleport_node", "targetname" );
	//level.price set_goal_node( soap_node );
}

mortar_run_soap_scripted_kill()
{
	trigger_wait_targetname("trig_soap_melee_kill");
	//flag_wait ("price_through_soap_kill_house");

	org = getstruct( "soap_melee_kill_org", "targetname" );
	spawner = getent( "soap_melee_kill_enemy", "targetname" );
	guy = spawner spawn_ai(true);
	guy.animname = "generic";
	guy.allowdeath = true;
	guy set_battlechatter( false );
	
	guys = [];
	guys[ 0 ] = level.soap;
	guys[ 1 ] = guy;
	
	level.soap disable_sprint(); //slow soap down so price can path ahead of event

	org anim_reach( guys, "soap_melee_kill" );

	if ( IsAlive( guy ) && !guy doingLongDeath() )
	{
		thread paired_kill_interrupted( level.soap, guy );
		guy delaythread( 1.3, ::paired_kill_uninterruptible );
		org anim_single_run( guys, "soap_melee_kill" );

		if ( IsAlive( guy ) )
		{
			guy kill_no_react();
		}
		
		level.soap enable_sprint();
	}
	activate_trigger_with_targetname ("trig_soap_post_melee_kill");
	
	level.soap enable_ai_color();
}

paired_kill_interrupted( hero, victim )
{
	level endon( "paired_kill_uninterruptible" );
	victim waittill( "death" );
	level notify( "paired_kill_interrupted" );
	hero notify( "single anim", "end" );
	hero StopAnimScripted();
}

paired_kill_uninterruptible()
{
	self endon( "death" );

	self.allowdeath = false;
	level notify( "paired_kill_uninterruptible" );
}

/*
player_track_distance()
{
	distance = 0;
	while( flag(blabla) )
	{
		//
		wait .05
	}
	return distance;
}
*/

mortar_roof()
{	
	trigger_wait_targetname ("trig_mortar_roof");
	
	thread maps\warlord_fx::mortar_explosion_4_fx();
	
	soap_node = getnode( "mortar_soap_node_1", "targetname" );
	price_node = getnode ("mortar_price_node_1", "targetname");
	level.soap.goalradius = 8;
	level.soap set_goal_node( soap_node );
	level.price.goalradius = 8;
	level.price set_goal_node( price_node );
	
	trigger_wait_targetname ("trig_player_on_roof_1");
	
	flag_wait( "player_on_roof_1" );
	
	thread maps\warlord_fx::mortar_explosion_5_fx();
}

disable_weapons_on_roof()
{
	// disable weapons prior to fall
	//   so you don't get all the madness with grenades, etc
	level endon( "mortar_timer_done" );
	if ( flag( "mortar_timer_done" ) )
	{
		return;
	}
	
	while ( true )
	{
		flag_wait( "player_on_roof_2" );
		level.player DisableOffhandWeapons();
		flag_waitopen( "player_on_roof_2" );
		level.player EnableOffhandWeapons();
	}
}

last_house()
{
	trigger_wait_targetname( "trig_mortar_last_house" );
	
	spawners = getentarray( "mortar_tube_guys", "targetname" );
	array_thread( spawners, ::spawn_ai, true );
	
	o_spawner = getent( "mortar_tube_operator", "targetname" );
	operator = o_spawner spawn_ai( true );
	operator thread mortar_use_anim();
	
	flag_wait( "mortar_fight_shot_2" );
	wait 1;
	
	blocker_ent = GetEnt( "mortar_path_blocker", "targetname" );
	assert(isdefined(blocker_ent));
	blocker_ent Delete();
	
	//soap_node = getnode( "mortar_soap_node_2", "targetname" );
	//level.soap set_goal_node( soap_node );
	
	level.soap go_to_node_with_targetname( "mortar_soap_node_2" );

	flag_set( "warlord_player_mortar" );
	
	trigger_wait_targetname( "trig_mortar_furniture" );
	
	flag_set( "mortar_introduce" );
}

mortar_use_anim()
{
	self endon( "death" );
	self thread magic_bullet_shield();
	org = getstruct( "mortar_dude_org", "targetname" );
	org thread anim_generic_loop( self, "mortar_idle", "stop_mortar_loop" );
	flag_wait( "mortar_fight_shot_2" );
	org notify( "stop_mortar_loop" );
	self anim_stopanimscripted();
	self thread stop_magic_bullet_shield();
	self thread go_to_node_with_targetname( self.target );
}

soap_teleport()
{
	trigger = getent( "trig_mortar_soap_teleport", "targetname" );
	trigger waittill( "trigger" );
	
	struct = getstruct( "soap_teleport_mortar", "targetname" );
	level.soap teleport_ent( struct );
	
	level.soap disable_sprint();
	
	soap_node = getnode( "soap_teleport_node", "targetname" );
	level.soap set_goal_node( soap_node );
}

play_roof_fx()
{
	wait(1);
	fx_ent = getent("warlord_player_fallthrough_origin","targetname");
	curr_org = fx_ent.origin-(0,0,8);
	curr_ang = (0,0,0);
	playfx(getfx("warlord_player_fallthrough"),curr_org, anglestoforward(curr_ang));
	
}

fall_blur()
{
	wait 2;
	setblur(10, 0);
	wait .35;
	setblur(0, 1.3);	
}

fall_through_roof()
{
	trigger = getent( "trig_mortar_roof_collapse", "targetname" );
	trigger waittill( "trigger" );
	
	// stop mortar timer
	flag_set( "mortar_timer_done" );
	
	org_fall_through_roof = GetStruct( "org_fall_through_roof", "targetname" );
	
	player_rig = spawn_anim_model( "player_rig" );
	player_rig Hide();
	player_legs = spawn_anim_model( "player_legs" );
	player_legs Hide();
	
	thread play_roof_fx();
	thread fall_blur();
	
	guys = [];
	guys[0] = player_rig;
	guys[1] = player_legs;
	
	// move ents to first frame of anim
	org_fall_through_roof anim_first_frame( guys, "roof_fall" );

	// disable stuff for anim (re-enabled through notetrack)
	level.player AllowSprint( false );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player AllowMelee( false );
	level.player DisableWeapons();
	
	// interpolate player to anim start
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.4, 0.2, 0.2 );
	player_rig delayCall( 0.4, ::Show );
	player_legs delaycall( 0.4, ::Show );
	wait 0.4;

	soap_pop_location = getstruct( "teleport_soap_mortar_fall", "targetname" );
	price_pop_location = getstruct( "teleport_price_mortar_fall", "targetname" );
	
	aud_send_msg( "fall_through_roof" );
	aud_send_msg( "mus_yuri_down" );
	
	// play anim
	//level.player delayCall( 0.70, ::ShellShock, "default", 4.5 );
	level.player delayCall( 0.7, ::PlayRumbleOnEntity, "damage_light" );
	
	org_fall_through_roof anim_single( guys, "roof_fall" );
	level.soap teleport_ent( soap_pop_location );
	level.price teleport_ent( price_pop_location );
	level.soap set_goal_pos( level.soap.origin );
	level.price set_goal_pos( level.price.origin );
	flag_set( "mortar_roof_fall_dialogue" );
	flag_set( "delete_destroyed_technicals" );
	aud_send_msg("mortar_run_end");
	// clean up
	level.player Unlink();
	player_rig Delete();
	player_legs Delete();
	
	level.price.moveplaybackrate = 1;
	level.soap.moveplaybackrate = 1;
	//level.price enable_awareness();
	level.soap enable_awareness();
	player_speed_percent( 100 );

	activate_trigger_with_targetname( "martar_allies_run_accross_roofs" );

	autosave_by_name( "mortar_roof_fall" );
	
	thread setup_mortar_run_roof_guys();
	
	thread maps\warlord_fx::mortar_explosion_6_fx();
}

setup_mortar_run_roof_guys()
{
	spawners = getentarray( "mortar_run_roof_guys", "script_noteworthy" );
	nodes = getnodearray( "mortar_run_roof_node", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::mortar_run_roof_guys, nodes );
}

mortar_run_roof_guys( nodes )
{
	self endon( "death" );
	self.grenadeammo = 0;
	self.goalradius = 32;
	self.ignoreme = true;
	self.baseaccuracy = 0.05;
	trigger_wait_targetname( "trig_mortar_last_house" );
	
	if( isDefined( self.script_parameters ) && self.script_parameters == "mortar_run_roof_guy_1" )
	{
		self set_goal_node( nodes[ 0 ] );
	}
	else
	{
		self set_goal_node( nodes[ 1 ] );
	}
	
	self waittill( "goal" );
	self.ignoreme = false;
}

mortar_fight_fire()
{
	flag_wait( "mortar_fight_shot" );
	
	/*target = getstruct( "mortar_fight_fire", "targetname" );
	thread mortar_explosion_generic( target );
	
	wait( 2.0 );
	*/
	target_2 = getstruct( "mortar_fight_fire_2", "targetname" );
	thread mortar_explosion_generic( target_2 );
	
	flag_set( "mortar_fight_shot_2" );
	
	thread maps\warlord_fx::mortar_explosion_7_fx();
		
	//hide dust fx in level for mortar tower
	foreach ( fx in level.createFXent )
	{
		if (( fx.v[ "type" ] == "oneshotfx" ))  
		fx pauseEffect();
	}
}

//Don't use this. Use this instead: trigger_wait_targetname()
/*
waittill_trigger_with_targetname (targetname, targetent)
{
	trigger = getent( targetname, "targetname" );
	trigger waittill( "trigger", targetent );
}
*/

//Don't use this. Use this instead: activate_trigger_with_targetname()
/*
notify_color_trigger (targetname)
{
	trigger = getent( targetname, "targetname" );
	trigger activate_trigger();
	trigger notify( "trigger", level.player );
}
*/

/////////////////////////////////////////////////
// PLAYER MORTAR
/////////////////////////////////////////////////

setup_mortar_technical( targetname )
{
	mortar_technical = spawn_vehicle_from_targetname_and_drive( targetname );
	mortar_technical thread kill_path_on_death();
	mortar_technical thread vehicle_turret_no_ai_detach();
	mortar_technical thread disonnect_path_on_death();
	
	accuracy_difficulty = [];
	accuracy_difficulty[0] = 0.06;
	accuracy_difficulty[1] = 0.06;
	accuracy_difficulty[2] = 0.12;
	accuracy_difficulty[3] = 0.24;
	
	mortar_technical.mgturret[0].accuracy = accuracy_difficulty[ level.gameskill ];
	return mortar_technical;
}

disonnect_path_on_death()
{
	// wait a couple frames before disconnecting paths
	self.dontDisconnectPaths = true;
	self waittill( "death" );
	wait 0.1;
	self DisconnectPaths();
}

setup_mortar_motivation_guys()
{
	spawners = getentarray( "mortar_motivation_guys", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::mortar_motivation_guys );
}

mortar_motivation_guys()
{
	self endon( "death" );
	self.accuracy = 0.04;
	self enable_heat_behavior( true );
}

/*force_player_up()
{
	level endon( "player_at_mortar" );
	trigger_wait_targetname( "trig_force_player_up" );
	wait( 10 );
	flag_set( "player_at_mortar" );
}
*/

mortar_introduce()
{
	flag_wait_any( "mortar_introduce", "mortar_operator_off" );
	flag_set( "head_to_mortar_dialogue" );
	flag_set( "obj_capture_mortar" );
}

mortar_fight()
{
	flag_wait( "player_at_mortar" );
	
	thread mortar_safety();
	
	spawners_2 = getentarray( "mortar_small_goal_radius", "script_noteworthy" );
	array_thread( spawners_2, ::add_spawn_function, ::setup_mortar_truck_guys );
	
	level.soap.ignoreme = true;
	level.price.ignoreme = true;
	
	level.mortar_technical_1 = setup_mortar_technical( "mortar_technical_1" );
	level notify( "mortar_technical_1_spawned" );
	aud_send_msg("mortar_technical_1_spawned");
	
	wait( 7.0 );
	
	// force player on to mortar.  don't spawn until player is on.
	//   (otherwise mortar can be optional, no good fail case)
	flag_wait( "mortar_in_use" );
	maps\_weapon_mortar60mm::disable_dismount();
	
	level.mortar_truck_1 = spawn_vehicle_from_targetname_and_drive( "mortar_pickup_1" );
	level notify( "mortar_truck_1_spawned" );
	
	flag_set( "mortar_targets_dialogue" );
	
	flag_wait_any( "mortar_technical_1_dead", "mortar_technical_1_riders_dead", "mortar_pickup_1_dead", "mortar_pickup_1_riders_dead" );
	if( flag( "mortar_technical_1_dead" ) )
	{
		wait( 3 );
	}
	
	level.mortar_technical_2 = setup_mortar_technical( "mortar_technical_2" );
	level notify( "mortar_technical_2_spawned" );
	level.mortar_technical_2 thread mortar_technical_fire();
	
	wait_to_spawn_mortar_wave();

	flag_set( "keep_firing_mortar" );
	
	level notify( "spawning_mortar_wave" );
	
	thread make_mortar_wave_aware();
	
	level.mortar_wave = [];
	spawners = getentarray( "mortar_wave", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::setup_mortar_wave_guy );	
	array_thread( spawners, ::add_spawn_function, ::mortar_death_anim );

	foreach ( spawner in spawners )
	{
		guy = spawner spawn_ai( true );
		level.mortar_wave[ level.mortar_wave.size ] = guy;
		wait( .05 );
	}
	
	flag_wait( "mortar_wave_1_dead" );
	
	maps\_weapon_mortar60mm::disable_mortar();
	
	if ( IsDefined( level.player.mortar_shots ) && level.player.mortar_shots <= 4 )
	{
		level.player thread	player_giveachievement_wrapper( "FOR_WHOM_THE_SHELL_TOLLS" );
	}
	
	//price_teleport = getstruct( "mortar_price_teleport", "targetname" );
//	level.price teleport_ent( price_teleport );
	
	flag_set( "regroup_dialogue" );
	
	level.price thread go_to_node_with_targetname( "node_price_pre_assault" );
	level.price thread price_go_assault_pipe();
	
	flag_set( "warlord_assault" );
	
	level notify( "mortar_finished" );
	
	//unhide dust fx in level after mortar is complete
	foreach ( fx in level.createFXent )
	{
		if (( fx.v[ "type" ] == "oneshotfx" ))  
		Fx restartEffect();
		
	}
}

mortar_safety()
{
	level endon( "warlord_assault" );
	flag_wait( "mortar_in_use" );
	
	thread player_invul_for_time();
}

player_invul_for_time()
{
	level.player EnableInvulnerability();
	
	invul_time = [];
	invul_time[0] = 10;
	invul_time[1] = 10;
	invul_time[2] = 8;
	invul_time[3] = 6;
	
	if( level.gameskill == 3 )
	{
		thread adjust_mortar_damage_on_vet();
	}
	
	wait( invul_time[ level.gameskill ] );
	level.player DisableInvulnerability();
}

adjust_mortar_damage_on_vet()
{
	level.player endon( "death" );
	old_value = GetDvarFloat( "player_damageMultiplier" );
	SetSavedDvar( "player_damageMultiplier", 0.7 );
	level waittill( "mortar_finished" );
	SetSavedDvar( "player_damageMultiplier", old_value );
}

price_go_assault_pipe()
{
	while( !level.player isLookingAt( level.price ) )
	{
		wait( 0.05 );
	}
	flag_set( "price_moving_to_pipe" );
}

mortar_death_anim()
{
	self.deathFunction = ::try_mortar_death;
}

try_mortar_death()
{
	if ( IsDefined( self.damageyaw ) && self.damageyaw >= -45 && self.damageyaw <= 45 )
	{
		if ( IsDefined( self.damageweapon ) && self.damageweapon == "none" &&
			 IsDefined( self.damagemod ) && self.damagemod == "MOD_EXPLOSIVE" )
		{
			// hit in the back by an explosion
			if ( RandomIntRange( 0, 100 ) < 50 )
			{
				// 50% chance of playing the explosion flying react
				self.deathanim = getgenericanim( "explosion_flying_react" );
			}
		}
	}
	
	return false;
}

setup_mortar_wave_guy()
{
	self endon( "death" );
	
	self.grenadeammo = 0;
	self.ignoreall = true;
	self.accuracy = 0.06;
	
	self enable_heat_behavior( true );
	
	mortar_wave_goal_volume = GetEnt( "mortar_volume_2", "targetname" );
	self SetGoalVolumeAuto( mortar_wave_goal_volume );
}

setup_mortar_truck_guys()
{
	self endon( "death" );
	self waittill( "jumpedout" );
	self.goalradius = 128;
	self.accuracy = 0.06;
	volume_1 = getent( "mortar_volume_1", "targetname" );
	volume_2 = getent( "mortar_volume_2", "targetname" );
	
	if( cointoss() )
	{
		self setGoalVolumeAuto( volume_1 );
	}
	else
	{
		self setGoalVolumeAuto( volume_2 );
	}
}

wait_to_spawn_mortar_wave()
{
	level endon( "mortar_technical_2_dead" );
	level endon( "mortar_technical_2_riders_dead" );
	if ( flag( "mortar_technical_2_dead" ) || flag( "mortar_technical_2_riders_dead" ) )
		return;
	flag_wait( "morter_technical_wave_2" );
}

mortar_technical_fire()
{
	self endon( "death" );
	self.mgturret[0] set_shared_field_value( "TurretFireDisable" );
	flag_wait( "mortar_technical_2_fire" );
	self.mgturret[0] unset_shared_field_value( "TurretFireDisable" );
}

mortar_allies()
{
	flag_wait( "player_at_mortar" );
	activate_trigger_with_targetname( "trig_mortar_use_post_teleport" );
}

mortar_rpg_setup()
{
	level waittill( "mortar_equipped" );

	offset = ( 256, 0, 128 );
	attractor_target_1 = spawn( "script_origin", level.player.origin + offset );
	attractor_1 = Missile_CreateAttractorEnt( attractor_target_1, 10000, 999999 );
	
	flag_wait( "assault_run_to_pipe" );
	Missile_DeleteAttractor( attractor_1 );
}

mortar_rpg_guys()
{
	level waittill( "mortar_technical_2_spawned" );
	wait( 3.0 );
	spawners = getentarray( "mortar_rpg_guys_1", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::monitor_mortar_rpg_guys );
	foreach( spawner in spawners )
	{
		guy = spawner spawn_ai( true );
		guy.health = 1;
		guy.grenadeammo = 0;
		guy.noragdoll = true;
		wait( 1.0 );
	}
	
	/*spawners_2 = getentarray( "mortar_rpg_guys_2", "script_noteworthy" );
	foreach( spawner in spawners_2 )
	{
		spawner spawn_ai( true );
		wait( 1.0 );
	}*/
}

monitor_mortar_rpg_guys()
{
	self endon( "death" );
	trigger_wait_targetname( "trig_damage_rpg_roof" );
	self kill();
}

make_mortar_wave_aware()
{
	level endon( "assault_all_clear" );

	trig_mortar_wave_1_aware = GetEnt( "trig_mortar_wave_1_aware", "targetname" );
	while ( true )
	{
		trig_mortar_wave_1_aware waittill( "trigger", enemy_ai );
		
		if ( IsDefined( enemy_ai ) && IsAlive( enemy_ai ) )
		{
			enemy_ai.ignoreall = 0;
		}
	}
}

/////////////////////////////////////////////////
// ASSAULT
/////////////////////////////////////////////////

assault_run_to_pipe()
{
	flag_wait( "assault_run_to_pipe" );
	
	// path price to pipe
	thread price_go_to_sewer_node();
	// path soap to pipe and idle
	org_rip_sewer_grate = GetStruct( "org_rip_sewer_grate", "targetname" );
	org_rip_sewer_grate anim_reach_solo( level.soap, "approach_rip_sewer" );
	AssertEx( org_rip_sewer_grate check_anim_reached( level.soap, "approach_rip_sewer" ), "Soap did not approach sewer grate, teleporting" );
	org_rip_sewer_grate anim_single_solo( level.soap, "approach_rip_sewer" );
	org_rip_sewer_grate thread anim_loop_solo( level.soap, "rip_sewer_idle", "stop_loop" );
	
	level.soap enable_ai_color_dontmove();
	wait 0.05;
	flag_set( "ready_to_open_grate" );
}

price_go_to_sewer_node()
{
	flag_wait( "price_moving_to_pipe" );
	
	trigger = getent( "trig_soap_leaving_mortar_tower", "targetname" );
	
	while( level.soap isTouching( trigger ) )
	{
		wait( 0.05 );
	}
	
	level.price thread go_to_node_with_targetname( "node_pipe_price_1" );
}

assault_pipe_crawl()
{
	trigger_wait_targetname( "trig_player_at_pipe" );
	
	foreach( ai in GetAIArray( "axis" ) )
	{
		ai delete();
	}
	
	flag_wait( "ready_to_open_grate" );
	
	level.soap thread ally_pipe_crawl();
	level.price thread ally_pipe_crawl();
	
	org_rip_sewer_grate = GetStruct( "org_rip_sewer_grate", "targetname" );
	org_rip_sewer_grate notify( "stop_loop" );
	
	AssertEx( org_rip_sewer_grate check_anim_reached( level.soap, "rip_sewer_grate" ), "Soap should already be in position" );
	
	thread maps\warlord_fx::sewer_grate_vfx();
	
	guys = [];
	guys[ 0 ] = [ level.soap, 0.05 ];
	guys[ 1 ] = [ level.sewer_grate, 0 ];
	org_rip_sewer_grate thread anim_single_end_early( guys, "rip_sewer_grate" );
	thread price_through_sewer_pipe();
	
	level.soap waittill( "anim_ended" );
	level.soap enable_ai_color_dontmove();
	
	//sewer_grate_clip = GetEnt( "sewer_grate_clip", "targetname" );
	//sewer_grate_clip NotSolid();
	//sewer_grate_clip ConnectPaths();
	
	level.soap enable_awareness();
	level.soap.goalradius = 2048;
	
	level.soap thread go_to_node_with_targetname( "node_assault_soap_1" );
	//level.price thread go_to_node_with_targetname( "node_assault_price_1" );
}

price_through_sewer_pipe()
{
	wait( 200/30 );
	sewer_grate_clip = GetEnt( "sewer_grate_clip", "targetname" );
	sewer_grate_clip NotSolid();
	sewer_grate_clip ConnectPaths();
	level.price disable_awareness();
	level.price thread go_to_node_with_targetname( "node_assault_price_1" );
	level.price waittill( "goal" );
	level.price enable_awareness();
}

ally_pipe_crawl()
{
	trig_ally_enter_pipe = GetEnt( "trig_ally_enter_pipe", "targetname" );
	while ( true )
	{
		trig_ally_enter_pipe waittill( "trigger", ally );
		if ( ally == self )
		{
			break;
		}
	}
	
	self AllowedStances( "crouch" );
	self thread assault_ally_pipe_exit();
}

assault_ally_pipe_exit()
{
	while ( true )
	{
		trigger_exit = getent( "trig_ally_exit_pipe", "targetname" );
		trigger_exit waittill( "trigger", guy );
		
		if ( guy == self )
		{
			break;
		}
	}
	
	self allowedStances( "stand", "crouch", "prone" );
}

assault_disable_prone_on_stairs()
{
	while( 1 )
	{
		if( flag( "flag_disable_prone_stairs" ) )
		{
			level.player AllowProne( false );
		}
		else
		{
			level.player AllowProne( true );
		}
		
		wait( 0.05 );
	}
}

assault_roof_deaths()
{
	spawners = getentarray( "assault_roof_guys", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::assault_roof_death_anims );
}

assault_roof_death_anims()
{
	self.animname = "generic";
	self.deathFunction = ::try_balcony_death;
}

try_balcony_death()
{	
	deathAnims = [];
	deathAnims[0] = getanim( "death_rooftop_A" );
	//deathAnims[1] = getanim( "death_rooftop_B" );
	//deathAnims[2] = getanim( "death_rooftop_D" );
	//deathAnims[3] = getanim( "death_rooftop_E" );
	self.deathanim = deathAnims[ 0 ];
	return false;
}

post_warehouse_trigger()
{
	flag_wait( "assault_warehouse_guys_dead" );
	activate_trigger_with_targetname( "trig_post_warehouse" );
}

assault_door_kick()
{
	level.player endon( "death" );
	
	thread player_ready_to_assault();
	flag_init( "price_ready_to_assault" );
	flag_init( "soap_ready_to_assault" );
	
	flag_wait_any( "assault_all_clear", "assault_compound_failsafe" );
	
	thread price_goes_to_assault_door();
	thread soap_goes_to_assault_door();
	
	flag_wait( "soap_ready_to_assault" );
	//flag_wait( "price_ready_to_assault" );
	
	thread clean_up_assault();
	
	wait( 1 );
	flag_set( "house_door_dialogue" );
	aud_send_msg("mus_shoulder_charge_door");
	org_compound_door = GetStruct( "org_compound_door", "targetname" );
	org_compound_door anim_reach_solo( level.soap, "shoulder_charge_door" );
	org_compound_door anim_single_solo( level.soap, "shoulder_charge_door" );
	level.soap enable_ai_color_dontmove();
	activate_trigger_with_targetname( "trig_soap_enter_compound_house" );
	activate_trigger_with_targetname( "trig_price_enter_compound_house" );
}

player_ready_to_assault()
{
	flag_init( "assault_compound_failsafe" );
	level endon( "trig_compound_autosave" );
	flag_wait( "player_at_compound_door" );
	wait( 5 );
	flag_set( "assault_compound_failsafe" );
}

price_goes_to_assault_door()
{
	level.price go_to_node_with_targetname( "price_wait_for_door" );
	level.price waittill( "goal" );
	flag_set( "price_ready_to_assault" );
	level.price enable_arrivals();
	level.price enable_exits();
}

soap_goes_to_assault_door()
{
	level.soap go_to_node_with_targetname( "soap_wait_for_door" );
	level.soap.goalradius = 1024;
	level.soap waittill( "goal" );
	flag_set( "soap_ready_to_assault" );
}

clean_up_assault()
{
	axis = GetAIArray( "axis" );
	AI_delete_when_out_of_sight( axis, 1024 );
}

ally_lower_accuracy()
{
	flag_wait( "trig_compound_autosave" );
	
	level.price.baseaccuracy = 0.05;
	level.soap.baseaccuracy = 0.05;
}

compound_autosave()
{
	self endon( "death" );
	level endon( "warlord_church_breach" );
	
	flag_wait( "trig_compound_autosave" );
	
	while( flag( "trig_compound_autosave" ) )
	{
		autosave_by_name( "compound" );
		wait( 25 );
	}
}

mi17_flyby()
{
	trigger_wait_targetname( "trig_mi17_flyby" );
	level.mi17 = spawn_vehicle_from_targetname_and_drive( "mi17_flyby" );
	level.mi17.animname = "mi17";
	level.mi17 SetCanDamage( false );
	level.mi17 thread switch_blurry_rotors();
	aud_send_msg("mi17_flyby", level.mi17);
}

assault_door_spawners()
{
	trigger_wait_targetname( "trig_assault_compound_wave_1" );
	spawners = getentarray( "assault_door_wave", "script_noteworthy" );
	door_wave = getent( "assault_door_wave", "targetname" );
	door_ref_wave = getstruct( "door_anim_ref_wave", "targetname" );
	
	door_kick_housespawn( spawners, door_wave, door_ref_wave );
}

monitor_super_technical_turret_damage( aa_turret )
{
	self endon( "death" );
	
	aa_turret SetCanDamage( true );
	aa_turret.health = aa_turret.health + 20000;
	keep_health = aa_turret.health;
	
	while ( true )
	{
		aa_turret waittill( "damage", amount, attacker, direction, position, damage_type );
		aa_turret.health = keep_health;
		
		if ( IsDefined( attacker ) && attacker == level.player &&
		  			 IsDefined( damage_type ) && ( ( damage_type == "MOD_PROJECTILE" || damage_type == "MOD_PROJECTILE_SPLASH" ) ) )
		{
			self.turret_hit = true;
			self DoDamage( amount, position, attacker );
		}
	}
}

assault_allies_handle_ignore()
{
	self endon( "death" );
	self pushplayer( true );
	self.ignoreall = 1;
	wait( 2.5 );
	self.ignoreall = 0;
	self pushplayer( false );
}

make_rider_invul( rider_index )
{
	invul_rider = undefined;
	foreach ( guy in self.riders )
	{
		if ( guy.vehicle_position == rider_index )
		{
			invul_rider = guy;
			break;
		}
	}

	if ( IsDefined( invul_rider ) )
	{
		invul_rider endon( "death" );
		invul_rider magic_bullet_shield();
		self waittill_any( "death", "end_make_rider_invul_" + rider_index );
		invul_rider stop_magic_bullet_shield();
	}
}

make_driver_invul()
{
	self make_rider_invul( 0 );
}

end_make_driver_invul()
{
	self notify( "end_make_rider_invul_0" );
}

make_gunner_invul()
{
	self make_rider_invul( 1 );
}

compound_truck_right()
{
	flag_wait( "compound_truck_right" );
	fov_var = GetDVarInt( "cg_fov" );
	angle = cos( fov_var );
	truck = spawn_vehicle_from_targetname_and_drive( "compound_truck_right" );
	aud_send_msg("compound_technical_right", truck);
	truck thread vehicle_turret_no_ai_detach();
	truck.riders[0] thread compound_retreat_and_delete( angle );
	truck.riders[2] thread compound_retreat_and_delete( angle );
}

compound_truck_left()
{
	flag_wait( "compound_truck_left" );
	level.super_technical = spawn_vehicle_from_targetname_and_drive( "compound_truck_left" );
	level.super_technical.dontunloadonend = true;
	level.super_technical.mgturret[0] makeTurretSolid();
	
	// picks a random number between min and max to burst fire for
	level.super_technical.mgturret[0].script_burst_min = 1.5;
	level.super_technical.mgturret[0].script_burst_max = 2.5;
	
	// picks a random number between min and max to wait between burst fires
	level.super_technical.mgturret[0].script_delay_min = 1.5;
	level.super_technical.mgturret[0].script_delay_max = 2;
	
	// delay between each shot, alternates barrels
	level.super_technical.mgturret[0].barrel_alternate_delay = 0.05;
	
	level.super_technical thread monitor_super_technical_turret_damage( level.super_technical.mgturret[0] );
}

setup_ignore_until_goal()
{
	fov_var = GetDVarInt( "cg_fov" );
	angle = cos( fov_var );
	spawners = getentarray( "ignore_until_goal", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::ignore_until_goal );
	array_thread( spawners, ::add_spawn_function, ::compound_retreat_and_delete, angle );
}
	
setup_fire_while_moving()
{
	fov_var = GetDVarInt( "cg_fov" );
	angle = cos( fov_var );
	spawners = getentarray( "fire_while_moving", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::fire_while_moving );
	array_thread( spawners, ::add_spawn_function, ::compound_retreat_and_delete, angle );
}

setup_ignore_all_until_goal()
{
	fov_var = GetDVarInt( "cg_fov" );
	angle = cos( fov_var );
	spawners = getentarray( "ignore_all_until_goal", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::ignore_all_until_goal );
	array_thread( spawners, ::add_spawn_function, ::compound_retreat_and_delete, angle );
}

setup_change_goal_radius_on_goal()
{
	fov_var = GetDVarInt( "cg_fov" );
	angle = cos( fov_var );
	spawners = getentarray( "change_goal_radius_on_goal", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::change_goal_radius_on_goal, 32 );
	array_thread( spawners, ::add_spawn_function, ::compound_retreat_and_delete, angle );
}

setup_first_guys()
{
	fov_var = GetDVarInt( "cg_fov" );
	angle = cos( fov_var );
	spawners = getentarray( "assault_first_guys", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::change_goal_radius_on_goal, 32 );
	array_thread( spawners, ::add_spawn_function, ::compound_fall_back, "vol_fall_back_1", "compound_fall_back_1" );
	array_thread( spawners, ::add_spawn_function, ::compound_retreat_and_delete, angle );
}

setup_run_guys()
{
	fov_var = GetDVarInt( "cg_fov" );
	angle = cos( fov_var );
	spawners = getentarray( "assault_run_guys", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::change_goal_radius_on_goal, 32 );
	array_thread( spawners, ::add_spawn_function, ::ignore_until_goal );
	array_thread( spawners, ::add_spawn_function, ::assault_run_guys_think );
	array_thread( spawners, ::add_spawn_function, ::compound_fall_back, "vol_fall_back_1", "compound_fall_back_1" );
	array_thread( spawners, ::add_spawn_function, ::compound_retreat_and_delete, angle );
}

setup_outside_church_guys()
{
	fov_var = GetDVarInt( "cg_fov" );
	angle = cos( fov_var );
	spawners = getentarray( "outside_church_guys", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::compound_retreat_and_delete, angle );
}

compound_retreat_and_delete( angle )
{
	self endon( "death" );
	flag_wait( "compound_church_doors" );
	volume = getent( "vol_church_retreat_delete", "targetname" );
	self.ignoreall = true;
	self.ignoreme = true;
	self.goalradius = 8;
	self SetGoalVolumeAuto( volume );
	
	while( within_fov_of_players( self.origin, angle ) )
	{
		wait( RandomFloatRange( 0.05, .3) );
	}
	self delete();
}

church_delete()
{
	self endon( "death" );
	flag_wait( "breach_starting" );
	self delete();
}
	
ignore_until_goal()
{
	self endon( "death" );
	self.ignoreme = true;
	self enable_heat_behavior( true );
	self waittill( "goal" );
	//wait randomfloatrange( 1.0, 2.0 );
	self.ignoreme = false;
}
	
fire_while_moving()
{
	self endon( "death" );
	self.accuracy = 0.08;
	self enable_heat_behavior( true );
}

ignore_all_until_goal()
{
	self endon( "death" );
	self.ignoreme = true;
	self.ignoreall = true;
	self waittill( "goal" );
	wait randomfloatrange( 1.0, 2.0 );
	self.ignoreme = false;
	self.ignoreall = false;
}
	
change_goal_radius_on_goal( new_radius )
{
	self endon( "death" );
	
	old_radius = self.goalradius;
	self.goalradius = new_radius;
	self waittill( "goal" );
	if( isDefined( self ) && isAlive( self ) )
	{
		self.goalradius = old_radius;
	}
}


compound_fall_back( volume, in_flag )
{
	self endon( "death" );
	flag_wait( in_flag );
	volume = getent( volume, "targetname" );
	if( isDefined( self ) && isAlive( self ) )
	{
		self change_goal_radius_on_goal( 32 );
		self setGoalVolumeAuto( volume );
	}
}

compound_retreat()
{
	volume = getent( "vol_assault_retreat", "targetname" );
	enemies = getaiarray( "axis" );
	
	while( ( enemies.size > 2 ) || !flag( "compound_truck_left" ) )
	{
		wait( 1 );
		enemies = getaiarray( "axis" );
	}
	
	foreach( enemy in enemies )
	{
		if( isDefined( enemy ) && isAlive( enemy ) )
		{
			enemy change_goal_radius_on_goal( 32 );
			enemy setGoalVolumeAuto( volume );
		}
}

	level notify( "compound_guys_retreat" );
}

assault_run_guys_think()
{
	self endon( "death" );
	self waittill( "goal" );
	while( 1 )
{
		self set_goal_ent( level.player );
		wait( 5 );
	}
	
}
	
delete_roof_ai()
{
	self endon( "death" );
	self waittill( "goal" );
	self delete();
}

roof_runner_1()
{
	level endon( "compound_guys_dead" );
	trigger_wait_targetname( "trig_assault_compound_wave_1" );
	spawner = getent( "compound_roof_runner_1", "targetname" );
	counter = 3;
	while( counter > 0 )
	{
		guy = spawner spawn_ai();
		guy thread delete_roof_ai();
		if( isDefined( spawner.count ) && spawner.count <= 0 )
{
			spawner.count = 1;
		}

		wait( 15 );
		counter--;
	}
}

turn_off_compound_triggers()
{
	trigger_array = getentarray( "compound_spawn_triggers", "script_noteworthy" );
	foreach( trigger in trigger_array )
	{
		trigger trigger_off();
	}
}


church_window_guy()
{
	trigger_wait_targetname( "trig_church_window_guy" );
	
	glass_1 = getglass( "church_window" );
	if( isDefined( glass_1 ) )
	{
		destroyGlass( glass_1, (0,1,0) );
		spawner = getent( "church_window_guy", "targetname" );
		spawner spawn_ai( true );
	}
}

compound_church_doors()
{
	flag_wait( "compound_church_doors" );
	flag_init( "church_doors_open" );
	
	door_left = getent( "breach_door_left", "targetname" );
	door_right = getent( "breach_door_right", "targetname" );
	aud_send_msg("church_doors_open", door_left);
	
	activate_trigger_with_targetname( "trig_allies_enter_church" );
	
	level.soap.goalradius = 64;
	level.price.goalradius = 64;

	//spawn guys	
	spawners_1 = getentarray( "church_guys", "script_noteworthy" );
	array_thread( spawners_1, ::add_spawn_function, ::setup_church_guys_1 );
	level.church_guys = array_spawn( spawners_1 );
	
	spawners_2 = getentarray( "church_guys_2", "script_noteworthy" );
	array_thread( spawners_2, ::add_spawn_function, ::setup_church_guys_2 );
	foreach( spawner in spawners_2 )
	{
		guy = spawner spawn_ai();
		level.church_guys = array_add( level.church_guys, guy );
	}
	
	thread hyena_hold_scene();
	
	door_left ConnectPaths();
	door_right ConnectPaths();
	
	door_left RotateYaw( 270, 0.2, 0.1, 0.1 );
	door_right RotateYaw( -270, 0.2, 0.1, 0.1 );
	
	flag_set( "church_doors_open" );
	flag_set( "warlord_player_breach" );

	thread monitor_church_guys();
	thread church_guys_retreat();
	thread maps\warlord_fx::fx_stop_dust();
	
	wait( 0.5 );
	
	door_left DisconnectPaths();
	door_right DisconnectPaths();
}

setup_church_guys_1()
{
	self thread church_delete();
	self.ignoreall = true;
	flag_wait( "church_doors_open" );
	self.ignoreall = false;
}

setup_church_guys_2()
{
	self thread church_delete();
	self thread ignore_all_until_goal();
	self thread change_goal_radius_on_goal( 32 );
}

monitor_church_guys()
{
	flag_init( "church_guys_retreat" );
	
	while( 1 )
	{
		if( level.church_guys.size < 3 )
		{
			flag_set( "church_guys_retreat" );
			break;
		}
		wait( 0.1 );
	}
}

church_guys_retreat()
{
	flag_wait( "church_guys_retreat" );	
	
	volume = getent( "vol_church_retreat", "targetname" );
	foreach( guy in level.church_guys )
	{
		//guy change_goal_radius_on_goal( 32 );
		guy thread ignore_all_until_goal();
		guy setGoalVolumeAuto( volume );
	}
}

hyena_hold_scene()
{
	hyena_master_spawner = GetEnt( "hyena_master", "targetname" );
	hyena_master = hyena_master_spawner spawn_ai( true );
	hyena_master.allowdeath = true;
	hyena_master.animname = "generic";
	
	hyena_pet_spawner = GetEnt( "hyena_pet", "targetname" );
	hyena_pet = hyena_pet_spawner spawn_ai( true );
	hyena_pet.allowdeath = true;
	hyena_pet.animname = "dog";
	
	play_hyena_hold( hyena_master, hyena_pet );
	
	exists_hyena_master = IsAlive( hyena_master );
	exists_hyena_pet = IsAlive( hyena_pet );
	if ( exists_hyena_master != exists_hyena_pet )
	{
		// if only one of the actors is dead, stop the anim on the other one
		if ( exists_hyena_master )
		{
			hyena_master anim_stopanimscripted();
		}
			
		if ( exists_hyena_pet )
		{
			hyena_pet anim_stopanimscripted();
		}
	}
}
	
play_hyena_hold( hyena_master, hyena_pet )
{
	hyena_master endon( "death" );
	hyena_pet endon( "death" );
	
	guys = [];
	guys[ 0 ] = hyena_master;
	guys[ 1 ] = hyena_pet;
	
	org_hyena_hold = GetStruct( "org_hyena_hold", "targetname" );
	org_hyena_hold anim_single( guys, "africa_hyena_hold" );
	
	guys = [];
	guys[ 0 ] = [ hyena_master, 0 ];
	guys[ 1 ] = [ hyena_pet, 0 ];

	org_hyena_hold thread anim_single_end_early( guys, "africa_hyena_release" );
	hyena_pet.a.movement = "run";
	
	org_hyena_hold waittill( "africa_hyena_release" );
}

squad_move_to_church_door()
{
	level.soap thread go_to_node_with_targetname( "node_breach_soap" );
	level.price thread go_to_node_with_targetname( "node_breach_price" );
}

assault_squad_teleport()
{
	soap_pos = getstruct( "assault_soap_pos", "targetname" );
	price_pos = getstruct( "assault_price_pos", "targetname" );
	
	level.soap teleport_ent( soap_pos );
	level.price teleport_ent( price_pos );
}

warlord_confrontation()
{
	level.player endon( "death" );

	flag_wait( "church_breach_complete" ); // set when all enemies in chruch breach are killed
	activate_trigger_with_targetname( "trig_pre_church_breach" );
	level.price disable_heat_behavior();
	level.soap disable_heat_behavior();
	flag_set( "obj_breach_warlord_room" );
	autosave_by_name( "warlord_confrontation" );
	
	aud_send_msg("mus_pre_church_door_breach");
	
	// set up warlord door trigger
	trig_warlord_breach = GetEnt( "trig_warlord_breach", "targetname" );
	trig_warlord_breach SetHintString( &"SCRIPT_PLATFORM_BREACH_ACTIVATE" );
	trig_warlord_breach UseTriggerRequireLookAt();
	
	// start warlord confrontation
	while ( true )
	{
		trig_warlord_breach waittill( "trigger" );
		if ( trig_warlord_breach maps\_slowmo_breach_church::breach_failed_to_start() )
		{
			continue;
		}
		
		break;

	}
	
	flag_set( "breach_starting" );
	//node is orienteed the wrong way and a little sunk into the floor
	org = getstruct( "org_warlord_standoff", "targetname" );
	
	// setup warlord confrontation
	spawner = getent( "warlord", "targetname" );
	warlord = spawner spawn_ai( true );
	warlord.animname = "warlord";
	warlord.ignoreall = 1;
	warlord.ignoreme = 1;
	warlord.allowdeath = true;
	warlord.grenadeammo = 0;
	warlord magic_bullet_shield();
	warlord set_battlechatter( false );
	
	hyena_spawner = GetEnt( "warlord_hyena", "targetname" );
	hyena = hyena_spawner spawn_ai( true );
	hyena.animname = "dog";
	hyena.ignoreall = 1;
	hyena.ignoreme = 1;
	hyena.allowdeath = true;
	hyena.team = "neutral";
	hyena magic_bullet_shield();
	hyena set_battlechatter( false );
	
	crate = spawn_anim_model( "crate" );
	org anim_first_frame_solo( crate, "warlord_ending" );
	
	player_rig = spawn_anim_model( "player_rig" );
	player_rig Hide();
	
	level.player_legs = spawn_anim_model( "player_legs" );
	level.player_legs Hide();
		
	// move ents to position
	org anim_first_frame( [ player_rig, level.player_legs, warlord, hyena ], "warlord_standoff_new" );
	org thread anim_reach_solo( level.price, "warlord_standoff_new" );

	if( isDefined( level.mi17 ) )
	{
		level.mi17 delete();
		aud_send_msg("first_heli_deleted");
	}
	
	chopper = spawn_vehicle_from_targetname( "confrontation_heli" );
	chopper.animname = "mi17";
	chopper SetCanDamage( false );
	org thread anim_loop_solo( chopper, "mi17_idle" );
	pallet = spawn_anim_model( "pallet" );
	pallet.animname = "pallet";
	org thread anim_loop_solo( pallet, "pallet_idle" );
	
	aud_send_msg("mi17_finale_flyout", chopper);
	
	bad_guys = [];
	
	spawnerArr = getentArray( "standoff_goons", "targetname" );
	
	foreach(s in spawnerArr)
	{
		guy = s spawn_ai();
		bad_guys = array_add( bad_guys, guy );
		guy.baseaccuracy = 0.05;
		guy.grenadeammo = 0;
		guy.health = 1;
		guy.noragdoll = true;
		guy.ignoreme = true;
		guy disable_long_death();
		guy set_battlechatter( false );
		//guy.moveplaybackrate = 0.6;
		//guy.team = "neutral";
	}

	array_thread( bad_guys, ::monitor_breach_end_guys );
	
	trig_warlord_breach trigger_off();
	setsaveddvar( "objectiveHide", true );
	flag_set( "obj_breach_warlord_room_started" );
	aud_send_msg( "mus_dog_scene" );
	level notify( "low_tech_breach_started" );
	
	// turn off ally BCS
	level.price thread set_battlechatter( false );
	level.soap thread set_battlechatter( false );
	
	// interpolate player to anim start
	level.player DisableWeapons();

	maps\_shg_common::SetUpPlayerForAnimations();
	
	lerp_time = 0.4;
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.4, 0.2, 0.2 );
	wait lerp_time;
	player_rig Show();
	level.player_legs Show();
	
	guys = [];
	guys[ 0 ] = [ level.price, 0 ];
	guys[ 1 ] = [ warlord, 0 ];
	org thread anim_single_end_early( guys, "warlord_standoff_new" );
	warlord thread wait_for_warlord_ending( org );
	
	guys = [];
	guys[ 0 ] = [ level.player_legs, 0 ];
	guys[ 1 ] = [ player_rig, 0 ];
	guys[ 2 ] = [ hyena, 0 ];
	
	//door breach fx
	thread maps\warlord_fx::church_breach_vfx();
	//hyena fx
	if ( IsDefined( hyena ) && IsAlive( hyena ) )
	{
		hyena thread maps\warlord_fx::hyena_attack_fx();
	}
		
	level.player AllowAds( false );
	org anim_single_end_early( guys, "warlord_standoff_new" );
	
	start = level.dofDefault;
   	dof_see_guys = [];       
   	dof_see_guys[ "nearStart" ] = 1;
   	dof_see_guys[ "nearEnd" ] = 75;
   	dof_see_guys[ "nearBlur" ] = 10;
   	dof_see_guys[ "farStart" ] = 500;
   	dof_see_guys[ "farEnd" ] = 500;
   	dof_see_guys[ "farBlur" ] = 1.8;
   	thread blend_dof( start, dof_see_guys, 0.1 );
	
	//at this point the starts have finished play the looping until we need to stop
	
	guys = [];
	guys[0] = player_rig;
	guys[1] = hyena;
	
	//give the beretta here
	level.force_weapon = level.confrontation_weapon;
	maps\_shg_common::ForcePlayerWeapon_Start(true);
	
	//now we'll allow the player to look around a little bit
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 45, 10, 25, 20, true );
	
	org thread anim_loop( guys, "warlord_standoff_loop" );
	thread warlord_ending_fail();
	
	level.player thread wait_for_melee_button( bad_guys );
	flag_wait("warlord_standoff_complete");

	aud_send_msg("warlord_end_all_clear");
	thread blend_dof( dof_see_guys, start, 0.1 );
	// WTF.  need a wait here or else paired animations will be slightly off.
	//   timing bug?
	wait 0.05;
	
	// don't allow player to look around so camera doesn't pop at the end
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.4, 0.2, 0.2 );
	
	level.player DisableWeapons();
	
	chopper delaythread( 3.5, ::switch_blurry_rotors );
	
	org thread play_warlord_ending( warlord, crate, chopper, pallet );
	
	beretta = spawn_anim_model( "beretta" );
	beretta Show();
	beretta HidePart( "tag_knife" );
	beretta HidePart( "tag_silencer" );
	
	thread maps\warlord_fx::hyena_death_fx(beretta);
	
	guys = [];
	guys[0] = player_rig;
	guys[1] = hyena;
	guys[2] = beretta;
	
	org anim_single( guys, "warlord_standoff_end" );
	
	//take away beretta here
	maps\_shg_common::ForcePlayerWeapon_End();
	
	//clean up
	level.player Unlink();
	player_rig Delete();
	
	level.player_legs Delete();
	beretta Delete();
	level.player EnableWeapons();
	
	maps\_shg_common::SetUpPlayerForGamePlay();
	level.player AllowAds( true );
	//clean up

	hyena stop_magic_bullet_shield();
	hyena kill_no_react();
	
	level.price enable_ai_color_dontmove();
	flag_set( "warlord_protect" );
	activate_trigger_with_targetname( "trig_price_post_warlord_standoff" );
	flag_set( "cleanupcrew_dialogue" );
	
	flag_wait( "confrontation_vo_finished" );
	nextmission();
}

wait_for_warlord_ending( org )
{
	self endon( "death" );
	level endon( "warlord_standoff_complete" );
	
	// warlord currently playing "warlord_standoff_new"
	self waittill( "anim_ended" );
	
	org thread anim_first_frame_solo( self, "warlord_ending" );
}

warlord_ending_fail()
{
	level endon( "warlord_standoff_complete" );
	wait( 10 );
	if( !flag( "warlord_standoff_complete" ) )
	{
		level.player kill();
	}
}

switch_blurry_rotors()
{
	self SetAnim( self getanim( "mi17_rotors" ), 1, 0, 1 );
	
	self HidePart( "main_rotor_jnt" );
	self HidePart( "tail_rotor_jnt" );
	self ShowPart( "main_rotor_jnt_blur" );
	self ShowPart( "tail_rotor_jnt_blur" );
}

wait_for_melee_button( guys )
{
	level endon( "warlord_protect" );
	
	while( 1 )
	{
		if( self MeleeButtonPressed() )
		{
			flag_set( "warlord_standoff_complete" );
			wait( 0.1 ); //wait so they don't die on screen
			foreach ( guy in guys )
			{
				if ( IsDefined( guy ) && IsAlive( guy ) )
				{
					guy kill();
				}
			}
			break;
		}
		wait( 0.05 );
	}
}

play_warlord_ending( warlord, crate, chopper, pallet )
{	
	guys = [];
	guys[0] = level.price;
	guys[1] = chopper;
	guys[2] = warlord;
	guys[3] = pallet;
	
	level.price thread multiple_dialogue_queue( "price_ending_lines" );
	self thread anim_single( guys, "warlord_ending" );
	self thread play_soap_ending( crate );
	thread flag_set_delayed( "getting_away_dialogue", 17 );
	
	// root not updated after actor killed!  wait until root will not move and then kill
	wait 9.35;
	warlord stop_magic_bullet_shield();
	warlord.noragdoll = true;
	warlord kill_no_react();
}

play_soap_ending( crate )
{
	guys = [];
	guys[0] = level.soap;
	guys[1] = spawn_anim_model( "crowbar" );
	guys[1] show();
	guys[2] = crate;
	
	wait( 3 );
	self thread anim_single( guys, "warlord_ending" );
	//Soap: Empty. What do you think Makarov was after?
	level.soap dialogue_queue( "warlord_mct_empty" );
}

monitor_breach_end_guys()
{
	self endon( "death" );
	self.baseaccuracy = 0.02;
	//wait( 1.5 );
	//self thread shoot_around_target( level.player, 5, 20, 30, -35, -10, 1, 2, false );
	self waittill( "goal" );
	wait( 2 );
	//self thread shoot_around_target( level.player, 5, 20, 30, -35, -10, 1, 2, false );
	//self.ignoreall = false;
	//self.ignoreme = false;
}

go_to_node( target_node )
{
	//old_radius = self.goalradius;
	self set_goal_radius( 8 );
	self set_goal_node( target_node );
	//self waittill ("goal");
	//if (isDefined (old_radius))
	//{
	//	self set_goal_radius (old_radius);
	//}
}

go_to_node_with_targetname( targetname )
{
	node = getnode( targetname, "targetname" );
	self thread go_to_node( node );
}

go_to_node_with_targetname_with_checks( targetname )
{
	go_to_node_with_targetname( targetname );
	
	// make sure node is usable
	self thread check_node_not_taken();
	self thread check_node_safe();
}

check_node_not_taken()
{
	self endon( "goal" );
	self waittill( "node_taken", ent );
	if ( IsDefined( ent ) )
	{
		AssertEx( false, "node taken by: " + ent.classname );
	}
	else
	{
		AssertEx( false, "node taken." );
	}
}

check_node_safe()
{
	self endon( "goal" );
	self waittill( "node_not_safe", ent );
	if ( IsDefined( ent ) )
	{
		AssertEx( false, "node not safe because of: " + ent.classname );
	}
	else
	{
		AssertEx( false, "node not safe" );
	}
}

change_allies_spotted_accuracy( accuracy )
{
	level.price thread change_friendly_stealth_spotted_accuracy( accuracy );
	level.soap thread change_friendly_stealth_spotted_accuracy( accuracy );
}

