#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_vehicle;
#include maps\payback_util;
#include maps\_audio;

chopper_main( chopper_not_vehicle )
{
	level notify( "chopper_not_usable" );
	
	if ( !IsDefined( chopper_not_vehicle ) || !chopper_not_vehicle )
	{
		nikolai_chopper_init();
	}
	else
	{
		if ( IsDefined( level.chopper ) )
		{
			level.chopper delete();
			//thread maps\payback_aud::delete_chopper_audio(); // do not fade out here since we're re-creating the chopper immediately following...
		}
		
		level.chopper = spawn( "script_model", ( 0, 0, 0 ) );
		level.chopper SetModel( "payback_vehicle_hind" );
		thread maps\payback_aud::loop_chopper();
	}
	
	thread chopper_think();
	
	level.chopper_weapon = "hind_12.7mm";

	level.chopper_max_fov = 55;
	level.chopper_min_fov = 25;
	level.chopper_current_fov = 55;
	
	level.chopper_min_slow_aim_yaw = 0.5;
	level.chopper_max_slow_aim_yaw = 0.7;
	level.chopper_min_slow_aim_pitch = 0.6;
	level.chopper_max_slow_aim_pitch = 0.8;
	level.chopper_current_slow_yaw = 0.7;
	level.chopper_current_slow_pitch = 0.8;
	level.chopper_firing_slow_aim_modifier = 0.0;
	
	level.chopper_kill_streak = 0;
	
	level.chopper_single_kills_vo[ 0 ] = "payback_pri_confirmedkill";
	level.chopper_single_kills_vo[ 1 ] = "payback_pri_welldoneyuri";
	level.chopper_single_kills_vo[ 2 ] = "payback_pri_roundsdown";
	level.chopper_single_kills_vo[ 3 ] = "payback_nik_niceshooting";
	level.chopper_single_kills_vo_index = RandomInt( level.chopper_single_kills_vo.size );
	
	level.chopper_multi_kills_vo[ 0 ] = "payback_pri_killsconfirmed";
	level.chopper_multi_kills_vo[ 1 ] = "payback_pri_multipleconfirmed";
	level.chopper_multi_kills_vo[ 2 ] = "payback_nik_goodkills";
	level.chopper_multi_kills_vo[ 3 ] = "payback_nik_targetsdown";
	level.chopper_multi_kills_vo[ 4 ] = "payback_nik_multiplekills";
	level.chopper_multi_kills_vo_index = RandomInt( level.chopper_multi_kills_vo.size );
	
	level.chopper_3_kills_vo = "payback_pri_atleastthree";
	level.chopper_5_kills_vo = "payback_pri_fivedown";
	level.chopper_6_kills_vo = "payback_pri_sixmorekills";
	level.chopper_8_kills_vo = "payback_pri_eightpluskills";
	
	level.chopper_strafe_ready_vo[ 0 ] = "payback_nik_gunonline";
	level.chopper_strafe_ready_vo[ 1 ] = "payback_nik_inposition";
	level.chopper_strafe_ready_vo[ 2 ] = "payback_nik_useremotegun";
	level.chopper_strafe_ready_vo[ 3 ] = "payback_nik_ready";
	level.chopper_strafe_ready_vo[ 4 ] = "payback_nik_gunrun";
	level.chopper_strafe_ready_vo[ 5 ] = "payback_nik_imready";
	level.chopper_strafe_ready_vo[ 6 ] = "payback_nik_activategun";
	level.chopper_strafe_ready_vo_index = 0;
		
	level.chopper_strafe_finished_vo[ 0 ] = "payback_nik_swingaround";
	level.chopper_strafe_finished_vo[ 1 ] = "payback_nik_anotherpass";
	level.chopper_strafe_finished_vo[ 2 ] = "payback_nik_maneuvering";
	level.chopper_strafe_finished_vo[ 3 ] = "payback_nik_circling";
	level.chopper_strafe_finished_vo[ 4 ] = "payback_nik_anotherstrafing";
	level.chopper_strafe_finished_vo[ 5 ] = "payback_nik_flyback";
	level.chopper_strafe_finished_vo[ 6 ] = "payback_nik_comingback";
	level.chopper_strafe_finished_vo_index = RandomInt( level.chopper_strafe_finished_vo.size );
	
	level.chopper_rpg_near_miss_vo[ 0 ] = "payback_nik_thatwasclose";
	level.chopper_rpg_near_miss_vo[ 1 ] = "payback_nik_aimisbetter";
	level.chopper_rpg_near_miss_vo[ 2 ] = "payback_nik_almosthit";
	level.chopper_rpg_near_miss_vo[ 3 ] = "payback_nik_luckholds"; 
	level.chopper_rpg_near_miss_vo_index = RandomInt( level.chopper_rpg_near_miss_vo.size );
	
	level.payback_chopper_hint = &"PAYBACK_REMOTE_CHOPPER_TURRET";
	
	level.originalDoFDefault = level.dofDefault;
	
	level.physicsSphereRadius = 300;
	level.physicsSphereForce = 1.0;
	
	chopper_init_fog_brushes();
	
	flag_set( "chopper_should_strafe" );
}

chopper_flag_init()
{
	flag_init( "chopper_give_player_control" );
	flag_init( "chopper_in_use_by_player" );
	flag_init( "chopper_should_strafe" );
	flag_init( "chopper_strafing" );
	flag_init( "chopper_changing_strafe_locations" );
	flag_init( "chopper_usable" );
	flag_init( "chopper_has_been_used" );
	flag_init( "chopper_final_ride" );
	flag_init( "chopper_strafe_end" );
	flag_init( "chopper_do_not_abort_strafe" );
	flag_init( "chopper_fire_random_rpgs" );
	flag_init( "chopper_fire_final_rpg" );
}

chopper_think()
{
	level endon( "chopper_not_usable" );
	
	flag_wait( "chopper_give_player_control" );
	
	if ( flag( "chopper_changing_strafe_locations" ) )
	{
		flag_waitopen( "chopper_changing_strafe_locations" );
	}
	
	flag_set( "chopper_usable" );
	
	thread chopper_remove_player_control();
	
	thread Chopper_First_Hint();
	
	if ( flag( "chopper_should_strafe" ) )
	{
		thread Chopper_VO_Nag();
	}
	
	level.player notifyOnPlayerCommand( "use_chopper", "+actionslot 4" );
	level.player notifyOnPlayerCommand( "exit_chopper", "+stance" );
	
	while ( 1 )
	{
		if ( !flag( "chopper_usable" ) )
		{
			flag_wait( "chopper_usable" );
		}
		
		level.player setWeaponHudIconOverride( "actionslot4", "dpad_remote_chopper_gunner" );
		RefreshHudAmmoCounter();

		level.player GiveWeapon( "remote_chopper_gunner" );
		level.player waittill_any( "use_chopper", "chopper_strafe_end" );
		if ( !flag( "chopper_usable" ) || level.player IsOnGround() == false )
		{
			continue;
		}
		
		level.player setWeaponHudIconOverride( "actionslot4", "none" );
		
		if ( flag( "chopper_should_strafe" ) && !flag( "chopper_strafing" ) )
		{
			level.chopper thread Chopper_Strafing_Run();
		}
		
		if ( !chopper_use() )
		{
			continue;
		}
		
		if ( !flag( "chopper_final_ride" ) )
		{
			level.player waittill_any( "exit_chopper", "chopper_strafe_end" );
			level notify( "chopper_exit" );
			flag_clear( "chopper_in_use_by_player" );
	
			level.player thread ExitFromChopperCamera( level.player.took_damage );
			
			level.player waittill( "player_finished_exit_from_chopper" );
		}
		else
		{
			break;
		}
	}
}

Remove_Chopper_Hints()
{	
	Chopper_Hint_Text_Delete();
	
	if ( IsDefined( level.iconElem ) )
	{
		level.iconElem destroy();
	}
	
	if ( IsDefined( level.iconElem2 ) )
	{
		level.iconElem2 destroy();
	}
	
	if ( IsDefined( level.iconElem3 ) )
	{
		level.iconElem3 destroy();
	}
}

Remove_Hints_On_Player_Death()
{
	level.player waittill( "death" );
	
	Remove_Chopper_Hints();
}

Remove_Hints_When_Chopper_Not_Usable()
{
	level waittill( "chopper_not_usable" );
	
	Remove_Chopper_Hints();
}

Chopper_Hint_Icon_Console()
{
	level.player endon( "death" );
	level endon( "chopper_not_usable" );
	
	level.iconElem = createIcon( "hud_dpad", 32, 32 );
	level.iconElem.hidewheninmenu = true;
	level.iconElem setPoint( "TOP", undefined, 0, 145 );
	
	level.iconElem2 = createIcon( "dpad_remote_chopper_gunner", 32, 32 );
	level.iconElem2.hidewheninmenu = true;
	level.iconElem2 setPoint( "TOP", undefined, -32, 145 );	

	level.iconElem3 = createIcon( "hud_arrow_right", 24, 24 );
	level.iconElem3.hidewheninmenu = true;
	level.iconElem3 setPoint( "TOP", undefined, 0, 149 );
	level.iconElem3.sort = 1;
	level.iconElem3.color = (1,1,0);
	level.iconElem3.alpha = .7;

 	time = 0;
	while ( level.player GetCurrentWeapon() != "remote_chopper_gunner" && time < 3 )
	{
		time += 0.05;
		wait .05;
	}
	
	level.iconElem setPoint( "CENTER", "BOTTOM", 370, -30, 1 );
	level.iconElem2 setPoint( "CENTER", "BOTTOM", 338, -30, 1 );
	level.iconElem3 setPoint( "CENTER", "BOTTOM", 370, -30, 1 );
	
	level.iconElem scaleovertime(1, 20, 20);
	level.iconElem2 scaleovertime(1, 20, 20);
	level.iconElem3 scaleovertime(1, 15, 15);
	
	time = 0;
	while ( level.player GetCurrentWeapon() != "remote_chopper_gunner" && time < 1 )
	{
		time += 0.05;
		wait .05;
	}
	
	level.iconElem fadeovertime(.3);
	level.iconElem.alpha = 0;
	
	level.iconElem2 fadeovertime(.3);
	level.iconElem2.alpha = 0;
	
	level.iconElem3 fadeovertime(.3);
	level.iconElem3.alpha = 0;
	
	level.iconElem destroy();
	level.iconElem2 destroy();
	level.iconElem3 destroy();
}

Chopper_Hint_Icon_PC()
{
	level.player endon( "death" );
	level endon( "chopper_not_usable" );
	
	level.iconElem2 = createIcon( "dpad_remote_chopper_gunner", 32, 32 );
	level.iconElem2.hidewheninmenu = true;
	level.iconElem2 setPoint( "TOP", undefined, 0, 145 );

 	time = 0;
	while ( level.player GetCurrentWeapon() != "remote_chopper_gunner" && time < 3 )
	{
		time += 0.05;
		wait .05;
	}
	
	level.iconElem2 setPoint( "CENTER", "BOTTOM", 75, 30, 1 );
	
	level.iconElem2 scaleovertime(1, 20, 20);
	
	time = 0;
	while ( level.player GetCurrentWeapon() != "remote_chopper_gunner" && time < 1 )
	{
		time += 0.05;
		wait .05;
	}
	
	level.iconElem2 fadeovertime(.3);
	level.iconElem2.alpha = 0;
	level.iconElem2 destroy();
}

Chopper_First_Hint()
{
	level.player endon( "death" );
	level endon( "chopper_not_usable" );
	
	thread Remove_Hints_On_Player_Death();
	thread Remove_Hints_When_Chopper_Not_Usable();
	
	hints = 1;
	
	if (getDifficulty() == "easy")
	{
		hints = 2;
	}
	hintNum = 0;
	while (hintNum < hints)
	{
		flag_wait( "chopper_usable" );
		hintNum++;
		
		if ( flag( "chopper_final_ride" ) )
		{
			wait 5.5;
		}
		
		if ( level.player GetCurrentWeapon() == "remote_chopper_gunner" || level.player GetCurrentWeapon() == level.chopper_weapon )
		{
			return;
		}
		
		thread Chopper_Hint_Text( level.payback_chopper_hint, 3, 0, -10 );
		
		if ( IsDefined( level.Console ) && level.Console )
		{
			Chopper_Hint_Icon_Console();
		}
		else
		{
			Chopper_Hint_Icon_PC();
		}
		
		if ( level.player GetCurrentWeapon() == "remote_chopper_gunner" )
		{
			Chopper_Hint_Text_Delete();
		}
		
		level.player waittill( "chopper_strafe_end" );
	}
}

Chopper_VO_Nag()
{
	level endon( "chopper_not_usable" );
	level.player endon( "death" );
	
	nag_delay = 30;
	
	if ( getDifficulty() == "easy" )
	{
		nag_delay = 15;
	}
	wait nag_delay;
	
	while ( 1 )
	{
		if ( !flag( "chopper_usable" ) || flag( "chopper_in_use_by_player" ) )
		{
			flag_waitopen( "chopper_in_use_by_player" );
			flag_wait( "chopper_usable" );
		}
		
		level.player thread play_vo( level.chopper_strafe_ready_vo[ level.chopper_strafe_ready_vo_index ], true );
		
		level.chopper_strafe_ready_vo_index += 1;
		
		max = level.chopper_strafe_ready_vo.size;
		
		if ( !flag( "chopper_has_been_used" ) )
		{
			max = 3;
		}
			
		if ( level.chopper_strafe_ready_vo_index >= max )
		{
			level.chopper_strafe_ready_vo_index = 0;
		}
		
		if ( getDifficulty() == "easy" )  // just in case the player switched difficulty mid-level
		{
			nag_delay = 15;
		}
		
		wait nag_delay;
	}
}

Chopper_Hint_Text( text, time, xOffset, yOffset )
{
	level endon( "chopper_text_deleted" );
	
	level.chopper_text = level.player maps\_hud_util::createClientFontString( "objective", 2.0 );
	level.chopper_text maps\_hud_util::setPoint( "CENTER", undefined, xOffset, yOffset );
	level.chopper_text SetText( text );
	
	if ( IsDefined( time ) && IsDefined( level.chopper_text ) )
	{
		wait time;
		level.chopper_text FadeOverTime( 0.25 );
		level.chopper_text.alpha = 0;
		wait 0.25;
		Chopper_Hint_Text_Delete();
	}
}

Chopper_Hint_Text_Delete()
{
	if ( IsDefined( level.chopper_text ) )
	{
		level.chopper_text Destroy();
		level.chopper_text = undefined;
		
		level notify( "chopper_text_deleted" );
	}
}

Should_Not_Display_Zoom_Hint()
{
	if ( !IsDefined( level.chopper_zoom_hint_time ) )
	{
		level.chopper_zoom_hint_time = GetTime() + 3000;
	}
	
	return level.chopper_zoom_hint_time < GetTime();
}

chopper_remove_player_control()
{
	flag_waitopen( "chopper_give_player_control" );
	
	level.player setWeaponHudIconOverride( "actionslot4", "none" );
	level.player notifyOnPlayerCommand( "use_chopper", "+actionslot 4" );
	
	if ( flag( "chopper_in_use_by_player" ) )
	{
		flag_clear( "chopper_in_use_by_player" );
		level.player thread ExitFromChopperCamera( level.player.took_damage );
	}
	else if ( level.player GetCurrentWeapon() == "remote_chopper_gunner" )
	{
		AbortLaptopSwitch( level.player );
	}
	
	level notify( "chopper_exit" );	
	level notify( "chopper_not_usable" );
}

chopper_use()
{
	level endon( "chopper_not_usable" );
	
//	level.chopper SetMaxPitchRoll( 15, 15 );
	
	if ( level.player InitializePlayerForChopper() )
	{
		level notify( "chopper_use" );

		level.player notifyOnPlayerCommand( "fire_button_release", "-attack" );
		
		level thread Update_Chopper_Targets();
		level thread Remove_Chopper_Targets();
		level.player thread prevent_player_from_shooting_chopper();
		level.player thread Handle_Firing();
		level.player thread Handle_Projectile_Impact();
		level.player thread Handle_Firing_Sound();
		level.player thread Handle_Firing_Aim_Slowdown();
		level.player thread Handle_Zoom();
		
		chopper_init_destructables();

/*		wait 20;
		
		
		flag_clear( "chopper_in_use_by_player" );
		level notify( "chopper_exit" );

		level.player thread ExitFromChopperCamera( level.player.took_damage );
*/		

		sandstorm_fx(0);
		if (level.snowLevel <= 2)
		{
			texploder_delete(2300);	
		}
		else
		{
			texploder_delete(5300);
		}
		return true;
	}
	
	return false;
}

prevent_player_from_shooting_chopper()
{
	level endon( "chopper_exit" );

	while ( 1 )
	{
		trace = BulletTrace( self GetEye(), self GetEye() + AnglesToForward( self GetGunAngles() ) * 500.0 + ( 0, 0, 40 ), true, self );
		if ( !IsDefined( trace ) || !IsDefined( trace[ "entity" ] ) || trace[ "entity" ] != level.chopper )
		{
			self EnableWeapons();
		}
		else
		{
			self DisableWeapons();
			self notify( "chopper_stop_firing" );
		}
		
		wait 0.05;		
	}
}

Handle_Firing()
{
	level endon( "chopper_exit" );
	
	while ( 1 )
	{
		self waittill( "weapon_fired" );
		
		if ( self isWeaponEnabled() )
		{
			earthquake( 0.2, 0.05, self.origin, 200 );
		}
		
		wait 0.05;
	}
}




Handle_Projectile_Impact()
{
	level endon( "chopper_exit" );
	
	if ( !IsDefined( level.chopper_projectile_org ) )
	{
		level.chopper_projectile_org = spawn( "script_origin", self.origin );
	}
	
	while ( 1 )
	{
		self waittill( "projectile_impact", weaponName, position, radius );
		level.chopper_projectile_org.origin = position;
		level.chopper_projectile_org PlaySound( "pybk_weap_chopper_impact" );
		
		// Log last hit positions
		level.chopper_last_impact_locations[ level.chopper_last_impact_locations_current_index ] = position;
		level.chopper_last_impact_locations_current_index += 1;
		if ( level.chopper_last_impact_locations_current_index >= level.chopper_last_impact_locations.size )
		{
			level.chopper_last_impact_locations_current_index = 0;
		}
		level.chopper_last_impact_time = GetTime();
		
		
//		thread Projectile_Impact_Physics_Sphere( position );
	}
}

Handle_Firing_Sound()
{
	chopper_gun_fade_in = 0.125;
	chopper_gun_fade_out = 0.125;
	level endon( "chopper_exit" );
	
	if ( !IsDefined( level.chopper_gun_sound ) )
	{
		level.chopper_gun_sound = spawn( "script_origin", self.origin );
		level.chopper_gun_sound LinkTo( self );
	}
	
	while ( 1 )
	{
		self waittill( "weapon_fired" );
		
		if ( self isWeaponEnabled() )
		{
			self PlaySound( "pybk_gatling_shot" );							// AUDIO: one-shot gatling start sound
			aud_fade_sound_in(level.chopper_gun_sound, "pybk_gatling_fire", 1.0, chopper_gun_fade_in, true);	// AUDIO: looping gatling sound
			aud_set_filter("filter_chopper_fire", 0);
			
			self waittill_any( "fire_button_release", "chopper_stop_firing" );
	
			self PlaySound( "pybk_gatling_release" );							// AUDIO: one-shot gatling release sound	
			aud_clear_filter(0);
			
			level.chopper_gun_sound ScaleVolume(0.0, chopper_gun_fade_out);
			wait(chopper_gun_fade_out);
			level.chopper_gun_sound StopLoopSound();
		}
	}
}

Handle_Firing_Aim_Slowdown()
{
	level endon( "chopper_exit" );
	
	while ( 1 )
	{
		self waittill( "weapon_fired" );
		
		level.chopper_firing_slow_aim_modifier = -0.2;
		level.chopper_current_slow_pitch += level.chopper_firing_slow_aim_modifier;
		level.chopper_current_slow_yaw += level.chopper_firing_slow_aim_modifier;
		self EnableSlowAim( level.chopper_current_slow_pitch, level.chopper_current_slow_yaw );
		
		self waittill ( "fire_button_release" );
		
		level.chopper_firing_slow_aim_modifier = 0.0;
		level.chopper_current_slow_pitch += 0.2;
		level.chopper_current_slow_yaw += 0.2;
		self EnableSlowAim( level.chopper_current_slow_pitch, level.chopper_current_slow_yaw );
	}
}

Lerp_DoF()
{
	self notify( "chopper_lerp_dof" );
	self endon( "chopper_lerp_dof" );
	
	dof_all_blur = [];
	dof_all_blur[ "nearStart" ] = 50;
	dof_all_blur[ "nearEnd" ] = 100;
	dof_all_blur[ "nearBlur" ] = 10;
	dof_all_blur[ "farStart" ] = 100;
	dof_all_blur[ "farEnd" ] = 200;
	dof_all_blur[ "farBlur" ] = 6;
	level.dofDefault = dof_all_blur;
                       
	self childthread blend_dof( dof_all_blur, level.originalDoFDefault, 0.5 );
}

Handle_Zoom()
{
	level endon( "chopper_exit" );
	
	lastLeftStick = 0;

	level.chopper_firing_slow_aim_modifier = 0.0;
	fov_range = level.chopper_max_fov - level.chopper_min_fov;
	slow_aim_yaw_range = level.chopper_max_slow_aim_yaw - level.chopper_min_slow_aim_yaw;
	slow_aim_pitch_range = level.chopper_max_slow_aim_pitch - level.chopper_min_slow_aim_pitch;
	
	if ( !IsDefined( level.chopper_zoom_sound ) )
	{
		level.chopper_zoom_sound = spawn( "script_origin", self.origin );
		level.chopper_zoom_sound LinkTo( self );
	}
	
	playing_sound = false;
	
	while ( 1 )
	{
		leftStick = self GetNormalizedMovement();
		
		if ( leftStick[ 0 ] == 0 )
		{
			if ( playing_sound )
			{
				level.chopper_zoom_sound StopLoopSound();
				playing_sound = false;
			}
			
			wait 0.05;
			continue;
		}
		
		if ( !playing_sound )
		{
			level.chopper_zoom_sound PlayLoopSound( "pybk_chopper_zoom" );
			playing_sound = true;
		}
		
		if ( ( lastLeftStick <= 0 && leftStick[ 0 ] > 0 ) || ( lastLeftStick >= 0 && leftStick[ 0 ] < 0 ) )
		{
			// DoF change
			self thread Lerp_DoF();
		}
		
		lastLeftStick = leftStick[ 0 ];
		
		scalar = 2.0;
		
		if ( leftstick[ 0 ] < 0 )
		{
			scalar = 4.0;
		}
		
		level.chopper_current_fov -= leftStick[ 0 ] * scalar;
		
		if ( level.chopper_current_fov < level.chopper_min_fov )
		{
			level.chopper_current_fov = level.chopper_min_fov;
			level.chopper_zoom_sound StopLoopSound();
			playing_sound = false;
		}
		else if ( level.chopper_current_fov > level.chopper_max_fov )
		{
			level.chopper_current_fov = level.chopper_max_fov;
			level.chopper_zoom_sound StopLoopSound();
			playing_sound = false;
		}
		
		self LerpFOV( level.chopper_current_fov, 0.05 );
		
		fov_pct = ( fov_range - ( level.chopper_max_fov - level.chopper_current_fov ) ) / fov_range;
		
		level.chopper_current_slow_yaw = level.chopper_min_slow_aim_yaw + ( slow_aim_yaw_range * fov_pct ) + level.chopper_firing_slow_aim_modifier;
		level.chopper_current_slow_pitch = level.chopper_min_slow_aim_pitch + ( slow_aim_pitch_range * fov_pct ) + level.chopper_firing_slow_aim_modifier;
		
		self EnableSlowAim( level.chopper_current_slow_pitch, level.chopper_current_slow_yaw );
		
		wait 0.05;
	}
}

Projectile_Impact_Physics_Sphere( center )
{
	wait 0.1;
	physicsExplosionSphere( center, level.physicsSphereRadius, level.physicsSphereRadius / 2, level.physicsSphereForce );
}

cancel_on_player_damage()
{
	level endon( "chopper_exit" );
	
	self.took_damage = false;
	self waittill( "damage" );
	self.took_damage = true;
}

WaitWithAbortOnDamage( time )
{
	finishTime = GetTime() + ( time * 1000 );
	while ( GetTime() < finishTime )
	{
		if ( self.took_damage )
		{
			return false;
		}

		if ( !flag( "chopper_give_player_control" ) || !flag( "chopper_usable" ) )
		{
			return false;
		}

		wait 0.05;
	}
	return true;
}

AbortLaptopSwitch( player )
{
	player thread set_black_fade( 0, 0.25 );
//	player VisionSetThermalForPlayer( level.visionThermalDefault, 0.25 );
	
	player SwitchToWeapon( player.last_weapon );
	player FreezeControls( false );
	player EnableOffhandWeapons();
	player EnableWeaponSwitch();
	aud_send_msg("player_chopper_aborted");
	
	level.chopper thread Chopper_Abort_Strafing_Run();
	
	wait 1;
	
//	iprintln( "**** AbortLaptopSwitch() ****");
	player TakeWeapon( "remote_chopper_gunner" );
}

Init_Fake_Player_Model()
{
	level.fake_player_origin = spawn( "script_origin", level.player.origin );
	level.fake_player = GetEnt( "fake_yuri", "targetname" ) spawn_ai( true );

	level.fake_player.maxhealth = 50000;
	level.fake_player.health = 50000;
	level.fake_player_origin.angles = level.player.angles;
	level.fake_player Gun_Remove();
	level.fake_player Teleport( level.player.origin, level.player.angles );
//	level.fake_player thread magic_bullet_shield( true );
	level.fake_player.animname = "generic";
	level.fake_player_origin maps\_anim::anim_generic_first_frame( level.fake_player, "stand_exposed_extendedpain_hip_2_crouch" );
	level.fake_player.ignoreall = true;
	
	Target_Set( level.fake_player, ( 0, 0, 32 ) );
	Target_SetShader( level.fake_player, "remote_chopper_hud_target_player" );
	level.fake_player.has_target_shader = true;

	level.fake_player thread Monitor_Fake_Player_For_Damage();
}

Monitor_Fake_Player_For_Damage()
{
	self endon( "chopper_exit" );
	
	while ( 1 )
	{
		self waittill( "damage", damage, attacker, dir, loc, type );
		
		if ( type == "MOD_MELEE" || type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" )
		{
			level.player.took_damage = true;
			level.player EnableHealthShield( false );
			level.player DisableInvulnerability();
			level.player DoDamage( damage, loc, attacker );
			
			level.player notify( "exit_chopper" );
			
			return;
		}
	}
}

Delete_Fake_Player_Model()
{
	if ( Target_IsTarget( level.fake_player ) )
	{
		Target_Remove( level.fake_player );
	}

	level.fake_player Delete();
	level.fake_player = undefined;
	
	level.fake_player_origin Delete();
	level.fake_player_origin = undefined;
}

Chopper_Thermal_On()
{
	self VisionSetNakedForPlayer( "remote_chopper", 0.25 );
	self VisionSetThermalForPlayer( "remote_chopper", 0.25 );
	
	if ( flag( "chopper_final_ride" ) )
	{
		self SetThermalFog( 0, (0.426061, 0.356593, 0.272478), 881.66, 227.344, 1, (0, 0, 0), (0, 0, 0), 0, 0.001, 1 );
	}
	else
	{
		self SetThermalFog( 0, (0.371452, 0.412372, 0.430688), 2644.97, 682.033, 1, (0, 0, 0), (0, 0, 0), 0, 0.001, 1 );
	}
	maps\_load::thermal_EffectsOn();
	self ThermalVisionOn();
	level.orig_thermalBlurFactorNoScope = GetDvar("thermalBlurFactorNoScope");
	SetSavedDvar( "thermalBlurFactorNoScope", "0" );
}

Chopper_Thermal_Off( exiting_chopper )
{		
	maps\_load::thermal_EffectsOff();
	self ThermalVisionOff();
	if ( !IsDefined( level.orig_thermalBlurFactorNoScope ) )
	{
		level.orig_thermalBlurFactorNoScope = "250";
	}
	SetSavedDvar( "thermalBlurFactorNoScope", level.orig_thermalBlurFactorNoScope );
	self ClearThermalFog();
	
	if ( !IsDefined( exiting_chopper ) || !exiting_chopper )
	{
		self VisionSetNakedForPlayer( "remote_chopper_storm", 0.25 );
		self VisionSetThermalForPlayer( "remote_chopper_storm", 0.25 );

		if ( flag( "chopper_final_ride" ) )
		{
			SetExpFog( 881.66, 227.344, 0.426061, 0.356593, 0.272478, 1, 0, 0, 0, 0, (0, 0, 0), 0, 0.001, 1 );
		}
		else
		{
			SetExpFog( 2644.97, 682.033, 0.371452, 0.412372, 0.430688, 1, 0, 0, 0, 0, (0, 0, 0), 0, 0.001, 1 );
		}
	}
}

Handle_Thermal_Toggle()
{
	level endon( "chopper_exit" );
	
	self notifyOnPlayerCommand( "toggle_chopper_thermal", "+usereload" );
	
	thermalEnabled = true;
	
	while ( 1 )
	{
		self waittill( "toggle_chopper_thermal" );
		
		if ( thermalEnabled )
		{
			self Chopper_Thermal_Off();
		}
		else
		{
			self Chopper_Thermal_On();
		}
		
		thermalEnabled = !thermalEnabled;
	}
}

Temp_Disable_Friendly_Fire()
{
	level.friendlyFireDisabled = true;
	
	if ( !flag( "chopper_final_ride" ) )
	{
		level.hannibal thread bravo_temp_bullet_shield("hannibal_spawned", 3);
		level.barracus thread bravo_temp_bullet_shield("barracus_spawned", 3);
		level.murdock thread bravo_temp_bullet_shield("murdock_spawned", 3);
	}
	
	wait 3;
	
	level.friendlyFireDisabled = false;
}

bravo_temp_bullet_shield(flag, time)
{
	self bravo_bullet_shield(flag);
	wait time;
	if ( IsDefined(self) && isAlive(self) && IsDefined(self.magic_bullet_shield) )
	{
		self stop_magic_bullet_shield();
	}
}



InitializePlayerForChopper()
{
	level thread custom_in_game_movie("uav_fadeIn", 0.0, 2.0);
	
	self thread cancel_on_player_damage();
	
	level.old_player_origin = self.origin;
	level.old_player_angles = self.angles;

	self.last_weapon = self GetCurrentWeapon();
	
	self GiveWeapon( "remote_chopper_gunner" );
	self SwitchToWeapon( "remote_chopper_gunner" );
	
	wait 0.25;
	
	if ( !flag( "chopper_give_player_control" ) || !( self IsOnGround() ) )
	{
		self SwitchToWeapon( self.last_weapon );
		self TakeWeapon( "remote_chopper_gunner" );
		return false;
	}
	self FreezeControls( true );
	self DisableWeaponSwitch();
	self DisableOffhandWeapons();

	aud_send_msg("player_chopper_enable"); // AUDIO: enter chopper
	
	if ( !WaitWithAbortOnDamage( 1.5 ) )
	{
		AbortLaptopSwitch( self );
		return false;
	}
	
	trans_time = 0.15;
	self thread set_black_fade( 1.0, trans_time );
	
	if ( !WaitWithAbortOnDamage( trans_time ) )
	{
		AbortLaptopSwitch( self );
		return false;
	}	
	
	self display_hint( "chopper_zoom_hint" );
	
	flag_set( "chopper_in_use_by_player" );
	flag_set( "chopper_do_not_abort_strafe" );
	
	level.player_old_fov = GetDvarInt( "cg_fov" );
	level.chopper_current_fov = level.chopper_max_fov;
	
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "actionSlotsHide", "1" );
	SetSavedDvar( "cg_fov", level.chopper_current_fov );
	SetSavedDvar( "compass", 0 );
	
	level.chopper_current_slow_pitch = level.chopper_max_slow_aim_pitch;
	level.chopper_current_slow_yaw = level.chopper_max_slow_aim_yaw;
	
	self EnableSlowAim( level.chopper_max_slow_aim_pitch, level.chopper_max_slow_aim_yaw );
/*	
	self PlayerLinkWeaponViewToDelta( level.chopper, "tag_player", 0.5, 180, 180, 0, 180, false );
	angles = level.chopper GetTagAngles( "tag_barrel2" );
	angles = ( 45, angles[ 1 ], 0 );
	self SetPlayerAngles( angles );
*/	
	self FreezeControls( false );
	self Hide();
	self EnableHealthShield( true );
	self EnableDeathShield( true );
	self EnableInvulnerability();	
	Init_Fake_Player_Model();

	self.prev_stance = self GetStance();
	
	gunnerPos = level.chopper GetTagOrigin( "tag_player" ) + AnglesToRight( level.chopper.angles ) * 20.0 - ( 0, 0, 50 );
	self SetOrigin( gunnerPos );
	
	initial_pitch = 0;

	if ( flag( "chopper_final_ride" ) )
	{
		construction_center = getstruct( "chopper_construction_site_center", "targetname" );
		toCenter = VectorToAngles( construction_center.origin - level.chopper.origin );
		initial_pitch = 30;
		gunnerAngles = ( initial_pitch, toCenter[ 1 ], 0 );
	}
	else
	{
		gunnerAngles = ( initial_pitch, level.chopper.angles[ 1 ], 0 );
	}
	
	self SetPlayerAngles( gunnerAngles );
	self PlayerLinkToDelta( level.chopper, "tag_player", 0.5, 180, 180, initial_pitch, 160, false );
	self PlayerLinkedOffsetEnable();
	
	foreach ( brush in level.chopper_fog_brushes )
	{
		brush Show();
	}
	
	if ( flag( "chopper_final_ride" ) )
	{
		SetCullDist( 2000 );
	}
	else
	{
		SetCullDist( 6000 );
	}
	self VisionSetNakedForPlayer( "remote_chopper_storm", 0.25 );
//	self VisionSetThermalForPlayer( "remote_chopper_storm", 0.25 );
//	SetThermalBodyMaterial( "thermalbody_gray" );
//	Chopper_Thermal_On();
//	self thread Handle_Thermal_Toggle();
	if ( flag( "chopper_final_ride" ) )
	{
		SetExpFog( 881.66, 227.344, 0.426061, 0.356593, 0.272478, 1, 0, 0, 0, 0, (0, 0, 0), 0, 0.001, 1 );
	}
	else
	{
		SetExpFog( 2644.97, 682.033, 0.371452, 0.412372, 0.430688, 1, 0, 0, 0, 0, (0, 0, 0), 0, 0.001, 1 );
	}
	self thread set_black_fade( 0, 0.05 );	
	
	self thread init_chopper_hud();

	self GiveWeapon( level.chopper_weapon );	
	self SwitchToWeaponImmediate( level.chopper_weapon );
	
	level.chopper thread Chopper_React_To_RPGs();
	level.chopper thread fire_rpgs_from_ai();
	
	level.chopper_last_impact_locations[ 0 ] = ( 0, 0, 0 );
	level.chopper_last_impact_locations[ 1 ] = ( 0, 0, 0 );
	level.chopper_last_impact_locations[ 2 ] = ( 0, 0, 0 );
	level.chopper_last_impact_locations[ 3 ] = ( 0, 0, 0 );
	level.chopper_last_impact_locations[ 4 ] = ( 0, 0, 0 );
	level.chopper_last_impact_locations_current_index = 0;
	level.chopper_last_impact_time = 0;
	
	thread Temp_Disable_Friendly_Fire();

	return true;
}

ExitFromChopperCamera( reasonIsPain )
{
	level thread custom_in_game_movie("uav_fadeOut", 0.05, 2.0);

	aud_send_msg("player_chopper_disable"); // AUDIO: exit from chopper
	
	self thread set_black_fade( 1.0, 0.15 );
	self VisionSetNakedForPlayer( "payback", 0.15 );
//	self VisionSetThermalForPlayer( "payback", 0.15 );
	
	self TakeWeapon( level.chopper_weapon );
	wait 0.05;
	
	self SwitchToWeaponImmediate( "remote_chopper_gunner" );

	is_chopper_rpg_crash = ( !IsAlive( level.chopper ) || level.chopper.classname == "script_model" );
	
	if ( !is_chopper_rpg_crash )
	{
		self EnableWeapons();
	}
	else
	{
		self DisableWeapons();
	}
	
	if ( IsDefined( level.chopper_gun_sound ) )
	{
		level.chopper_gun_sound StopLoopSound( "pybk_gatling_fire" );
		level.chopper_gun_sound Delete();
		level.chopper_gun_sound = undefined;
	}
	
	if ( IsDefined( level.chopper_zoom_sound ) )
	{
		level.chopper_zoom_sound StopLoopSound( "pybk_chopper_zoom" );
		level.chopper_zoom_sound Delete();
		level.chopper_zoom_sound = undefined;
	}

	if ( IsDefined ( level.chopper_projectile_org ) )
	{
		level.chopper_projectile_org Delete();
		level.chopper_projectile_org = undefined;
	}
	remove_chopper_hud( 0.25 );
	
	self maps\_art::lerpDoFValue( "farStart", 100, 0.0 );
	self maps\_art::lerpDoFValue( "farEnd", 200, 0.0 );
	self maps\_art::lerpDoFValue( "farBlur", 10, 0.0 );
	thread toggle_chopper_fx(); 
	
	wait 0.25;
	
	// Do impact fx at the last few hit locations
	if ( GetTime() - level.chopper_last_impact_time < 5000 )
	{
		for ( index = 0; index < level.chopper_last_impact_locations.size; index += 1 )
		{
			if ( level.chopper_last_impact_locations[ index ] != ( 0, 0, 0 ) )
			{
				PlayFx( level._effect["remote_chopper_default"] , level.chopper_last_impact_locations[ index ] );
			}
		}
	}
	
	level.chopper_last_impact_locations[ 0 ] = undefined;
	level.chopper_last_impact_locations[ 1 ] = undefined;
	level.chopper_last_impact_locations[ 2 ] = undefined;
	level.chopper_last_impact_locations[ 3 ] = undefined;
	level.chopper_last_impact_locations[ 4 ] = undefined;
	level.chopper_last_impact_locations_current_index = undefined;
	level.chopper_last_impact_time = undefined;
	
	Delete_Fake_Player_Model();
	
	Chopper_Hint_Text_Delete();
	
	self DisableSlowAim();
	
	self Unlink();
	self SetStance( self.prev_stance );
	self SetOrigin( level.old_player_origin );
	self SetPlayerAngles( level.old_player_angles );
	
	if ( IsDefined( level.chopper_rpg_alarm_sound ) )
	{
		level.chopper_rpg_alarm_sound StopLoopSound();
		level.chopper_rpg_alarm_sound Delete();
		level.chopper_rpg_alarm_sound = undefined;
	}
	
//	self Chopper_Thermal_Off( true );
//	SetThermalBodyMaterial( "thermalbody_default" );
	
	SetCullDist( 0 );
	foreach ( brush in level.chopper_fog_brushes )
	{
		brush Hide();
	}
	
	self vision_set_fog_changes( "payback", 0.25 );
	self thread set_black_fade( 0, 0.15 );
	if ( !is_chopper_rpg_crash )
	{
		self EnableWeapons();
	}
	self EnableWeaponSwitch();
	self EnableOffhandWeapons();
	self Show();

	self EnableHealthShield( false );
	self EnableDeathShield( false );
	self DisableInvulnerability();
	
	level.chopper_zoom_hint_time = undefined;

	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "actionSlotsHide", "0" );
	SetSavedDvar( "cg_fov", level.player_old_fov );
	SetSavedDvar( "compass", 1 );

	if ( is_chopper_rpg_crash )
	{
		to_chopper = level.chopper.origin - self.origin;
		to_chopper = ( to_chopper[0] , to_chopper[1] , to_chopper[2] / 2.0 );
		self SetStance( "stand" );
		self SetPlayerAngles( VectorToAngles( to_chopper ));
		self FreezeControls( true );
		self StopRumble( "heavy_3s" );
	}
	
	wait 0.15;

	if ( !reasonIsPain && IsAlive( level.chopper ) && level.chopper.classname != "script_model" )
	{
		wait 0.6;
	}
	
	if ( !is_chopper_rpg_crash && reasonIsPain )
	{
		//fast switch back - go right to weapon
		self SwitchToWeaponImmediate( self.last_weapon );
	}
	else if ( !IsAlive( level.chopper ) || level.chopper.classname == "script_model" )
	{
		wait 0.5;
		self FreezeControls( false );
	}
	
	//slow switch back - show laptop, etc
	self SwitchToWeapon( self.last_weapon );
	
	wait 1.5;
	
	self TakeWeapon( "remote_chopper_gunner" );
	
	self notify( "player_finished_exit_from_chopper" );
}

static_overlay( time )
{
	level endon( "chopper_exit" );
	
	level.ChopperHUDItem[ "static" ] = newClientHudElem( self );
	level.ChopperHUDItem[ "static" ].x = 0;
	level.ChopperHUDItem[ "static" ].y = 0;
	level.ChopperHUDItem[ "static" ].alignX = "left";
	level.ChopperHUDItem[ "static" ].alignY = "top";
	level.ChopperHUDItem[ "static" ].horzAlign = "fullscreen";
	level.ChopperHUDItem[ "static" ].vertAlign = "fullscreen";
	level.ChopperHUDItem[ "static" ] setshader( "overlay_static", 640, 480 );
	level.ChopperHUDItem[ "static" ].alpha = 1.0;
	level.ChopperHUDItem[ "static" ].sort = -3;
	
	target_alpha = level.ChopperHUDItem[ "static" ].alpha;
	lerp_time = 0.0;
	step = 0.0;
	iterations = 0.0;
	high_value = false;
	cur_time = time;
	
	while ( cur_time > 0.0 )
	{
		if ( iterations <= 1.0 )
		{
			if ( high_value )
			{
				pause_time = randomfloatrange( 0.5, 0.75 );
				wait pause_time;
				cur_time -= pause_time;
				target_alpha = randomfloatrange( 0.75, 0.9 );
			}
			else
			{
				target_alpha = randomfloatrange( 0.0, 0.1 );
			}
			lerp_time = randomfloatrange( 0.1, 0.25 );
			iterations = ( lerp_time / 0.05 );
			step = ( level.ChopperHUDItem[ "static" ].alpha - target_alpha ) / iterations;
			high_value = !high_value;
		}

		iterations -= 1.0;
		level.ChopperHUDItem[ "static" ].alpha -= step;
		
		cur_time -= 0.05;
		
		wait 0.05;
	}
	
	level.ChopperHUDItem[ "static" ].alpha = 1.0;
}

init_chopper_hud()
{
	if ( !isdefined( level.ChopperHUDItem ) )
	{
		level.ChopperHUDItem = [];
	}
	
	level.ChopperHUDItem[ "hit_target" ] = newClientHudElem( self );
	level.ChopperHUDItem[ "hit_target" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "hit_target" ].alignX = "center";
	level.ChopperHUDItem[ "hit_target" ].alignY = "middle";
	level.ChopperHUDItem[ "hit_target" ] setshader( "remote_chopper_hud_target_hit", 32, 32 );
	level.ChopperHUDItem[ "hit_target" ].alpha = 0;
	
	chopper_reticle_overlay();
	
	chopper_grain_overlay();
	chopper_nightvision_overlay();
	
	thread chopper_angles_overlay();
	thread chopper_weapon_ammo_overlay();
	thread chopper_targeting_overlay();
	thread chopper_height_overlay();
	thread chopper_timestamp_overlay();
	thread chopper_zoom_overlay();
	chopper_lower_left_overlay();
	chopper_upper_right_overlay();
}

remove_chopper_hud( fadeTime )
{
	keys = getArrayKeys( level.ChopperHUDItem );
	foreach ( key in keys )
	{
		level.ChopperHUDItem[ key ] fadeOverTime( fadeTime );
		level.ChopperHUDItem[ key ].alpha = 0;
	}
	
	wait fadeTime;
	
	foreach ( key in keys )
	{
		level.ChopperHUDItem[ key ] Destroy();
		level.ChopperHUDItem[ key ] = undefined;
	}
}

chopper_reticle_overlay()
{
	level.ChopperHUDItem[ "reticle" ] = createIcon( "remote_chopper_hud_reticle", 400, 226 );
	level.ChopperHUDItem[ "reticle" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "reticle" ].alignX = "center";
	level.ChopperHUDItem[ "reticle" ].alignY = "middle";
}

chopper_hit_target_overlay()
{
	level notify( "chopper_hit_target" );
	level endon( "chopper_hit_target" );
	
	level.ChopperHUDItem[ "hit_target" ].alpha = 0.65;
	
	wait 0.25;
	
	level.ChopperHUDItem[ "hit_target" ] fadeovertime( 0.25 );
	level.ChopperHUDItem[ "hit_target" ].alpha = 0;
}

chopper_grain_overlay()
{
	level.ChopperHUDItem[ "grain" ] = newClientHudElem( self );
	level.ChopperHUDItem[ "grain" ].x = 0;
	level.ChopperHUDItem[ "grain" ].y = 0;
	level.ChopperHUDItem[ "grain" ].alignX = "left";
	level.ChopperHUDItem[ "grain" ].alignY = "top";
	level.ChopperHUDItem[ "grain" ].horzAlign = "fullscreen";
	level.ChopperHUDItem[ "grain" ].vertAlign = "fullscreen";
	level.ChopperHUDItem[ "grain" ] setshader( "remote_chopper_overlay_scratches", 640, 480 );
	level.ChopperHUDItem[ "grain" ].alpha = 0.4;
	level.ChopperHUDItem[ "grain" ].sort = -3;
}

chopper_nightvision_overlay()
{
	level.ChopperHUDItem[ "nightvision" ] = newClientHudElem( self );
	level.ChopperHUDItem[ "nightvision" ].x = 0;
	level.ChopperHUDItem[ "nightvision" ].y = 0;
	level.ChopperHUDItem[ "nightvision" ].alignX = "left";
	level.ChopperHUDItem[ "nightvision" ].alignY = "top";
	level.ChopperHUDItem[ "nightvision" ].horzAlign = "fullscreen";
	level.ChopperHUDItem[ "nightvision" ].vertAlign = "fullscreen";
	level.ChopperHUDItem[ "nightvision" ] setshader( "nightvision_overlay_goggles", 640, 480 );
	level.ChopperHUDItem[ "nightvision" ].alpha = 0.4;
	level.ChopperHUDItem[ "nightvision" ].sort = -3;
}

chopper_height_overlay()
{
	level endon( "chopper_exit" );

	height = -60;
	curOffset = undefined;
	
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_left" ] = createIcon( "remote_chopper_hud_targeting_bar", 8, 4 );	
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_left" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_left" ].point = "LEFTMIDDLE";
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_left" ].relativepoint = "BOTTOMLEFT";
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_left" ].xoffset = 2;
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_left" ].yoffset = -2;
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_left" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ] );
	
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_right" ] = createIcon( "remote_chopper_hud_targeting_bar", 8, 4 );
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_right" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_right" ].point = "RIGHTMIDDLE";
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_right" ].relativepoint = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_right" ].xoffset = -2;
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_right" ].yoffset = -2;
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_right" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ] );

 	while ( 1 )
	{
		ground_pos = level.chopper groundpos( level.player.origin );
		dist = distance( ground_pos, level.player.origin );
		altitudePct = clamp( ( dist - 500 ) / 1250, 0.0, 1.0 );
		yOffset = ( height * altitudePct ) - 2;
		
		if ( !IsDefined( curOffset ) )
		{
			curOffset = yOffset;
		}
		else
		{
			curOffset = curOffset + ( ( yOffset - curOffset ) / 5 );
		}

		level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_left" ] setPoint( "LEFTMIDDLE", "BOTTOMLEFT", 2, curOffset, 0.05 );
		level.ChopperHUDItem[ "remote_chopper_hud_targeting_bar_right" ] setPoint( "RIGHTMIDDLE", "BOTTOMRIGHT", -2, curOffset, 0.05 );
		
		wait 0.05;
	}
}

chopper_angles_overlay()
{
	level endon( "chopper_exit" );
	
	top = -160;
	left = -100;
	right = 100;
	width = ( right - left ) / 2;
	curPitchOffset = undefined;
	curYawOffset = undefined;
	curRollOffset = undefined;
	
	level.ChopperHUDItem[ "remote_chopper_hud_compass_bar" ] = createIcon( "remote_chopper_hud_compass_bar", 24, 24 );
	level.ChopperHUDItem[ "remote_chopper_hud_compass_bar" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_compass_bar" ] setPoint( "CENTER", undefined, 0, top + 6 );
	
	level.ChopperHUDItem[ "remote_chopper_hud_compass_bracket" ] = createIcon( "remote_chopper_hud_compass_bracket", 20, 20 );
	level.ChopperHUDItem[ "remote_chopper_hud_compass_bracket" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_compass_bracket" ] setPoint( "CENTER", undefined, 0, top );
	
	level.ChopperHUDItem[ "remote_chopper_hud_compass_triangle" ] = createIcon( "remote_chopper_hud_compass_triangle", 16, 16 );
	level.ChopperHUDItem[ "remote_chopper_hud_compass_triangle" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_compass_triangle" ] setPoint( "CENTER", undefined, 0, top );

 	while ( 1 )
	{
		// PITCH
		pitchOffset = clamp( level.chopper.angles[ 0 ] / 45, -1.0, 1.0 ) * width;
		
		if ( !IsDefined( curPitchOffset ) )
		{
			curPitchOffset = pitchOffset;
		}
		else
		{
			curPitchOffset = curPitchOffset + ( ( pitchOffset - curPitchOffset ) / 5 );
		}

		level.ChopperHUDItem[ "remote_chopper_hud_compass_triangle" ] setPoint( "CENTER", undefined, curPitchOffset, top, 0.05 );
		
		// YAW
		yawOffset = ( AngleClamp180( level.player.angles[ 1 ] - level.chopper.angles[ 1 ] ) / 180.0 ) * width;
		
		if ( !IsDefined( curYawOffset ) )
		{
			curYawOffset = yawOffset;
		}
		else
		{
			curYawOffset = curYawOffset + ( ( yawOffset - curYawOffset ) / 5 );
		}

		level.ChopperHUDItem[ "remote_chopper_hud_compass_bar" ] setPoint( "CENTER", undefined, curYawOffset, top + 6, 0.05 );
		
		// ROLL
		rollOffset = clamp( level.chopper.angles[ 2 ] / 45, -1.0, 1.0 ) * width;
		
		if ( !IsDefined( curRollOffset ) )
		{
			curRollOffset = rollOffset;
		}
		else
		{
			curRollOffset = curRollOffset + ( ( rollOffset - curRollOffset ) / 5 );
		}

		level.ChopperHUDItem[ "remote_chopper_hud_compass_bracket" ] setPoint( "CENTER", undefined, curRollOffset, top, 0.05 );
		
		wait 0.05;
	}
}

chopper_timestamp_overlay()
{
	level endon( "chopper_exit" );
	
	top = -195;
	left = -250;
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_upper_tads" ] = level.player createClientFontString( "default", 1.5 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_upper_tads" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_upper_tads" ].x = left;
	level.ChopperHUDItem[ "remote_chopper_hud_text_upper_tads" ].y = top;
	level.ChopperHUDItem[ "remote_chopper_hud_text_upper_tads" ] SetText( &"REMOTE_CHOPPER_GUNNER_TADS" );
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_hours" ] = level.player createClientFontString( "default", 1.5 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_hours" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_hours" ].x = left;
	level.ChopperHUDItem[ "remote_chopper_hud_text_hours" ].y = top + 15;
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_minutes" ] = level.player createClientFontString( "default", 1.5 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_minutes" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_minutes" ].x = left + 20;
	level.ChopperHUDItem[ "remote_chopper_hud_text_minutes" ].y = top + 15;
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_seconds" ] = level.player createClientFontString( "default", 1.5 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_seconds" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_seconds" ].x = left + 40;
	level.ChopperHUDItem[ "remote_chopper_hud_text_seconds" ].y = top + 15;
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_z" ] = level.player createClientFontString( "default", 1.5 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_z" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_z" ].x = left + 60;
	level.ChopperHUDItem[ "remote_chopper_hud_text_z" ].y = top + 15;
	level.ChopperHUDItem[ "remote_chopper_hud_text_z" ] SetText( &"REMOTE_CHOPPER_GUNNER_Z" );
	
	if ( !IsDefined( level.HudTimeStamp ) )
	{
		level.HudTimeStamp = ( 9 * 60 * 60 ) + ( 32 * 60 ) + 10;
	}
	
	if ( !IsDefined( level.HudTimeStampStartTime ) )
	{
		level.HudTimeStampStartTime = GetTime();
	}
	
	while ( 1 )
	{
		seconds = int( level.HudTimeStamp + ( ( GetTime() - level.HudTimeStampStartTime ) / 1000 ) );
		minutes = int( seconds / 60 );
		hours = int( minutes / 60 );
		minutes -= hours * 60;
		seconds -= ( ( hours * 60 * 60 ) + ( minutes * 60 ) );
		
		hoursText = "";
		if ( hours < 10 )
		{
			hoursText = "0";
		}
		hoursText += hours;
		
		minutesText = "";
		if ( minutes < 10 )
		{
			minutesText = "0";
		}
		minutesText += minutes;
		
		secondsText = "";
		if ( seconds < 10 )
		{
			secondsText = "0";
		}
		secondsText += seconds;
		
		level.ChopperHUDItem[ "remote_chopper_hud_text_hours" ] SetText( hoursText );
		level.ChopperHUDItem[ "remote_chopper_hud_text_minutes" ] SetText( minutesText );
		level.ChopperHUDItem[ "remote_chopper_hud_text_seconds" ] SetText( secondsText );
		
		wait 0.05;
	}
}

chopper_zoom_overlay()
{
	level endon( "chopper_exit" );
	
	bottom = -105;
	right = -145;
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_x" ] = level.player createClientFontString( "default", 1.75 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_x" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_x" ].alignx = "RIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_x" ].aligny = "BOTTOM";
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_x" ].x = right;
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_x" ].y = bottom;
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_x" ] SetText( &"REMOTE_CHOPPER_GUNNER_X" );
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal" ] = level.player createClientFontString( "default", 1.75 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal" ].point = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal" ].relativepoint = "BOTTOMLEFT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal" ].xoffset = -10;
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_x" ] );
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal_point" ] = level.player createClientFontString( "default", 1.75 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal_point" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal_point" ].point = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal_point" ].relativepoint = "BOTTOMLEFT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal_point" ].xoffset = -10;
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal_point" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal" ] );
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal_point" ] SetText( &"REMOTE_CHOPPER_GUNNER_DECIMAL_POINT" );
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_int" ] = level.player createClientFontString( "default", 1.75 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_int" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_int" ].point = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_int" ].relativepoint = "BOTTOMLEFT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_int" ].xoffset = -5;
	level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_int" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal_point" ] );
	
	fov_range = level.chopper_max_fov - level.chopper_min_fov;
	
	while ( 1 )
	{		
		zoom = 1.0 + ( ( level.chopper_max_fov - level.chopper_current_fov ) / fov_range ) * 3.0;
		
		zoom_int = int( zoom );
		zoom_decimal = int( ( zoom - int( zoom ) ) * 10 );
		
		level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_int" ] SetValue( zoom_int );
		level.ChopperHUDItem[ "remote_chopper_hud_text_zoom_decimal" ] SetValue( zoom_decimal );
		
		wait 0.05;
	}
}

chopper_upper_right_overlay()
{
	top = -180;
	left = 180;
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_rct_active" ] = level.player createClientFontString( "default", 1.5 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_rct_active" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_rct_active" ].x = left;
	level.ChopperHUDItem[ "remote_chopper_hud_text_rct_active" ].y = top;
	level.ChopperHUDItem[ "remote_chopper_hud_text_rct_active" ] SetText( &"REMOTE_CHOPPER_GUNNER_RCT_ACTIVE" );
}

chopper_targeting_overlay()
{
	level endon( "chopper_exit" );

	curXOffsetRect = undefined;
	curYOffsetRect = undefined;
	curXOffsetCirc = undefined;
	curYOffsetCirc = undefined;
	
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ] = createIcon( "remote_chopper_hud_targeting_frame", 64, 64 );
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ].point = "BOTTOMLEFT";
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ].relativepoint = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ].xoffset = 15;
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ].yoffset = -24;
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_text_weapon" ] );
	
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_circle" ] = createIcon( "remote_chopper_hud_targeting_circle", 8, 8 );
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_circle" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_circle" ].point = "CENTERMIDDLE";
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_circle" ].relativepoint = "CENTERMIDDLE";
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_circle" ].xoffset = 0;
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_circle" ].yoffset = 0;
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_circle" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ] );
	
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_rectangle" ] = createIcon( "remote_chopper_hud_targeting_rectangle", 16, 16 );
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_rectangle" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_rectangle" ].point = "CENTERMIDDLE";
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_rectangle" ].relativepoint = "CENTERMIDDLE";
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_rectangle" ].xoffset = 0;
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_rectangle" ].yoffset = 0;
	level.ChopperHUDItem[ "remote_chopper_hud_targeting_rectangle" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_targeting_frame" ] );

	while ( 1 )
	{
		rightStick = level.player GetNormalizedCameraMovement();
		
		xOffset = 32 * rightStick[ 1 ];
		yOffset = -32 * rightStick[ 0 ];
		
		if ( !IsDefined( curXOffsetRect ) )
		{
			curXOffsetRect = xOffset;
		}
		else
		{
			curXOffsetRect = curXOffsetRect + ( ( xOffset - curXOffsetRect ) / 10 );
		}
		
		if ( !IsDefined( curYOffsetRect ) )
		{
			curYOffsetRect = yOffset;
		}
		else
		{
			curYOffsetRect = curYOffsetRect + ( ( yOffset - curYOffsetRect ) / 10 );
		}
		
		if ( !IsDefined( curXOffsetCirc ) )
		{
			curXOffsetCirc = xOffset;
		}
		else
		{
			curXOffsetCirc = curXOffsetCirc + ( ( xOffset - curXOffsetCirc ) / 2 );
		}
		
		if ( !IsDefined( curYOffsetCirc ) )
		{
			curYOffsetCirc = yOffset;
		}
		else
		{
			curYOffsetCirc = curYOffsetCirc + ( ( yOffset - curYOffsetCirc ) / 2 );
		}

		level.ChopperHUDItem[ "remote_chopper_hud_targeting_circle" ] setPoint( "CENTERMIDDLE", "CENTERMIDDLE", curXOffsetCirc, curYOffsetCirc, 0.05 );
		level.ChopperHUDItem[ "remote_chopper_hud_targeting_rectangle" ] setPoint( "CENTERMIDDLE", "CENTERMIDDLE", curXOffsetRect, curYOffsetRect, 0.05 );
		
		wait 0.05;
	}
}

chopper_weapon_ammo_overlay()
{
	level endon( "chopper_exit" );
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_rounds" ] = level.player createClientFontString( "default", 1.25 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_rounds" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_rounds" ].point = "BOTTOMLEFT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_rounds" ].relativepoint = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_rounds" ].xoffset = -30;
	level.ChopperHUDItem[ "remote_chopper_hud_text_rounds" ].yoffset = -8;
	level.ChopperHUDItem[ "remote_chopper_hud_text_rounds" ] SetText( &"REMOTE_CHOPPER_GUNNER_ROUNDS" );
	level.ChopperHUDItem[ "remote_chopper_hud_text_rounds" ] SetParent( level.ChopperHUDItem[ "reticle" ] );
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_ammo" ] = level.player createClientFontString( "default", 1.25 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_ammo" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_ammo" ].point = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_ammo" ].relativepoint = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_ammo" ].xoffset = 90;
	level.ChopperHUDItem[ "remote_chopper_hud_text_ammo" ].yoffset = 0;
	level.ChopperHUDItem[ "remote_chopper_hud_text_ammo" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_text_rounds" ] );
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_weapon" ] = level.player createClientFontString( "default", 1.25 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_weapon" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_weapon" ].point = "BOTTOMLEFT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_weapon" ].relativepoint = "BOTTOMLEFT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_weapon" ].xoffset = 0;
	level.ChopperHUDItem[ "remote_chopper_hud_text_weapon" ].yoffset = -12;
	level.ChopperHUDItem[ "remote_chopper_hud_text_weapon" ] SetText( &"REMOTE_CHOPPER_GUNNER_12_7MM" );
	level.ChopperHUDItem[ "remote_chopper_hud_text_weapon" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_text_rounds" ] );
	
	while ( 1 )
	{
		level.ChopperHUDItem[ "remote_chopper_hud_text_ammo" ] SetValue( level.player GetWeaponAmmoStock( level.player GetCurrentWeapon() ) );
		
		wait 0.05;
	}
}

chopper_lower_left_overlay()
{
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_recording" ] = level.player createClientFontString( "default", 1.25 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_recording" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_recording" ].point = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_recording" ].relativepoint = "BOTTOMLEFT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_recording" ].xoffset = 30;
	level.ChopperHUDItem[ "remote_chopper_hud_text_recording" ].yoffset = -8;
	level.ChopperHUDItem[ "remote_chopper_hud_text_recording" ] SetText( &"REMOTE_CHOPPER_GUNNER_RECORDING" );
	level.ChopperHUDItem[ "remote_chopper_hud_text_recording" ] SetParent( level.ChopperHUDItem[ "reticle" ] );
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_n1_4" ] = level.player createClientFontString( "default", 1.25 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_n1_4" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_n1_4" ].point = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_n1_4" ].relativepoint = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_n1_4" ].xoffset = 0;
	level.ChopperHUDItem[ "remote_chopper_hud_text_n1_4" ].yoffset = -12;
	level.ChopperHUDItem[ "remote_chopper_hud_text_n1_4" ] SetText( &"REMOTE_CHOPPER_GUNNER_N1_4" );
	level.ChopperHUDItem[ "remote_chopper_hud_text_n1_4" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_text_recording" ] );
	
	level.ChopperHUDItem[ "remote_chopper_hud_text_lower_tads" ] = level.player createClientFontString( "default", 1.25 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_lower_tads" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_lower_tads" ].point = "BOTTOMLEFT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_lower_tads" ].relativepoint = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_lower_tads" ].xoffset = -80;
	level.ChopperHUDItem[ "remote_chopper_hud_text_lower_tads" ].yoffset = 0;
	level.ChopperHUDItem[ "remote_chopper_hud_text_lower_tads" ] SetText( &"REMOTE_CHOPPER_GUNNER_TADS" );
	level.ChopperHUDItem[ "remote_chopper_hud_text_lower_tads" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_text_n1_4" ] );

	level.ChopperHUDItem[ "remote_chopper_hud_text_63" ] = level.player createClientFontString( "default", 1.25 );
	level.ChopperHUDItem[ "remote_chopper_hud_text_63" ] set_default_hud_parameters();
	level.ChopperHUDItem[ "remote_chopper_hud_text_63" ].point = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_63" ].relativepoint = "BOTTOMRIGHT";
	level.ChopperHUDItem[ "remote_chopper_hud_text_63" ].xoffset = 0;
	level.ChopperHUDItem[ "remote_chopper_hud_text_63" ].yoffset = -12;
	level.ChopperHUDItem[ "remote_chopper_hud_text_63" ] SetText( &"REMOTE_CHOPPER_GUNNER_63" );
	level.ChopperHUDItem[ "remote_chopper_hud_text_63" ] SetParent( level.ChopperHUDItem[ "remote_chopper_hud_text_n1_4" ] );
}

set_default_hud_parameters()
{
	self.alignx = "left";
	self.aligny = "top";
	self.horzAlign = "center";
	self.vertAlign = "middle";
	self.hidewhendead = false;
	self.hidewheninmenu = false;
	self.sort = 205;
	self.foreground = true;
	self.alpha = 0.65;
}

Update_Chopper_Targets()
{
	level endon( "chopper_exit" );
	
	while ( 1 )
	{
		foreach ( ai in GetAIArray() )
		{
			if ( !IsDefined( ai ) || ( IsDefined( ai.has_target_shader ) && ai.has_target_shader ) )
			{
				continue;
			}

			if ( ai.team == "axis" )
			{
				if ( IsDefined( ai.ridingvehicle ) && IsAlive( ai.ridingvehicle ) )
				{
					if ( !IsDefined( ai.ridingvehicle.has_target_shader ) )
					{
						ai.ridingvehicle.has_target_shader = true;
						Target_Set( ai.ridingvehicle, ( 0, 0, 32 ) );
						Target_SetScaledRenderMode( ai.ridingvehicle, true );
						Target_SetShader( ai.ridingvehicle, "remote_chopper_hud_target_e_vehicle" );
						Target_SetOffscreenShader( ai.ridingvehicle, "veh_hud_target_offscreen" );
						ai.ridingvehicle thread Remove_Chopper_Target_On_Death();
						ai.ridingvehicle thread Monitor_For_Damage();
						ai.ridingvehicle thread Monitor_Chopper_Vehicle_Target();
					}
					
					continue;
				}
				else
				{
					ai.has_target_shader = true;
					Target_Set( ai, ( 0, 0, 32 ) );
					Target_SetShader( ai, "remote_chopper_hud_target_enemy" );
					Target_SetOffscreenShader( ai, "veh_hud_target_offscreen" );
				}
			}
			else
			{
				ai.has_target_shader = true;
				Target_Set( ai, ( 0, 0, 32 ) );
				Target_SetShader( ai, "remote_chopper_hud_target_friendly" );
			}
			Target_ShowToPlayer( ai, level.player );
			
			ai thread Remove_Chopper_Target_On_Death();
			ai thread Handle_Thermal_Gibs();
			ai thread Monitor_For_Damage();
			
			wait 0.05;
		}
		
		wait 0.05;
	}
}

Remove_Chopper_Target_On_Death()
{
	level endon( "chopper_exit" );
	
	self waittill( "death" );
	
	if ( IsDefined( self ) && Target_IsTarget( self ) )
	{
		Target_Remove( self );
	}
}

Monitor_Chopper_Vehicle_Target()
{
	level endon( "chopper_exit" );
	self endon( "death" );
	
	while ( self.riders.size > 0 )
	{
		wait 0.05;
	}
	
	Target_Remove( self );
	self.has_target_shader = undefined;
}

Remove_Chopper_Targets()
{
	while ( 1 )
	{
		level waittill( "chopper_exit" );
		
		foreach ( target in Target_GetArray() )
		{
			Target_Remove( target );
			target.has_target_shader = undefined;
		}
	}
}

Chopper_React_To_RPGs()
{
	level endon( "chopper_exit" );
	self endon( "death" );
	
	playing_alarm_sound = false;
	last_near_miss_time = 0;
	
	if ( !IsDefined( level.chopper_rpg_alarm_sound ) )
	{
		level.chopper_rpg_alarm_sound = spawn( "script_origin", self.origin );
		level.chopper_rpg_alarm_sound LinkTo( level.player );
	}
	
	while ( 1 )
	{
		rpgs = GetEntArray( "rocket", "classname" );
		rpg_in_danger_zone = false;
		rpg_near_miss = false;
		
		if ( IsDefined( level.rpg ) )
		{
			rpgs[rpgs.size] = level.rpg;
		}
		
		foreach ( rpg in rpgs )
		{
			if ( IsDefined ( rpg.model ) && rpg.model == "projectile_rpg7" )
			{
				if ( !IsDefined( rpg.has_target_shader ) )
				{
					rpg thread Update_RPG();
				}
					
				if ( !rpg_in_danger_zone && DistanceSquared( level.player.origin, rpg.origin ) < 1000000 )
				{
					rpg_in_danger_zone = true;
				}
				
				if ( !rpg_near_miss && DistanceSquared( level.player.origin, rpg.origin ) < 250000 )
				{
					rpg_near_miss = true;
				}
			}
		}
		
		if ( rpg_in_danger_zone && !playing_alarm_sound )
		{
			level.chopper_rpg_alarm_sound PlayLoopSound( "pybk_chopper_alarm" );
			playing_alarm_sound = true;
		}
		else if ( !rpg_in_danger_zone && playing_alarm_sound )
		{
			level.chopper_rpg_alarm_sound StopLoopSound();
			playing_alarm_sound = false;
		}
		
		if ( rpg_near_miss && GetTime() - last_near_miss_time > 5000 )
		{
			last_near_miss_time = GetTime();
			level.player thread play_vo( level.chopper_rpg_near_miss_vo[ level.chopper_rpg_near_miss_vo_index ], true );
			
			level.chopper_rpg_near_miss_vo_index += 1;
			
			if ( level.chopper_rpg_near_miss_vo_index >= level.chopper_rpg_near_miss_vo.size )
			{
				level.chopper_rpg_near_miss_vo_index = 0;
			}
		}
		
		wait 0.05;
	}
}

Update_RPG()
{
	level endon( "chopper_exit" );
	
	self.has_target_shader = true;
	Target_Set( self, ( 0, 0, 0 ) );
	Target_SetShader( self, "veh_hud_target_chopperfly" );
	Target_SetOffscreenShader( self, "veh_hud_target_chopperfly_offscreen" );
	
	self PlayRumbleLoopOnEntity( "light_1s" );
	
	while ( IsDefined( self ) )
	{
		wait 0.25;
		
		if ( IsDefined( self ) )
		{
			Target_HideFromPlayer( self, level.player );
		}
		
		wait 0.25;
		
		if ( IsDefined( self ) )
		{
			Target_ShowToPlayer( self, level.player );
		}
	}
}

Handle_Thermal_Gibs()
{
	level endon( "chopper_exit" );
	self waittill( "death", attacker, type, weaponName );

	thread Chopper_Killed_Hostile_Achievement();		
	
	if ( IsDefined( weaponName ) && weaponName == "hind_12.7mm" )
	{
//		playfx( getfx( "thermal_body_gib" ), self.origin );
		
		if ( !flag( "chopper_final_ride" ) )
		{
			thread Chopper_Killed_Hostile();
		}
	}
}

Chopper_Killed_Hostile()
{
	level notify( "chopper_kill" );
	level endon( "chopper_kill" );
	
	level.chopper_kill_streak += 1;
	
	level waittill_any_timeout( 2, "chopper_exit", "chopper_strafe_end" );
	
	if ( level.chopper_kill_streak > 1 )
	{
		if ( level.chopper_kill_streak > 2 && level.chopper_kill_streak != 7 && RandomInt( 3 ) == 0 )
		{
			if ( level.chopper_kill_streak >= 8 )
			{
				level.player thread play_vo( level.chopper_8_kills_vo, true );
			}
			else if ( level.chopper_kill_streak == 6 )
			{
				level.player thread play_vo( level.chopper_6_kills_vo, true );
			}
			else if ( level.chopper_kill_streak == 5 )
			{
				level.player thread play_vo( level.chopper_5_kills_vo, true );
			}
			else if ( level.chopper_kill_streak >= 3 )
			{
				level.player thread play_vo( level.chopper_3_kills_vo, true );
			}
		}
		else
		{
			level.player thread play_vo( level.chopper_multi_kills_vo[ level.chopper_multi_kills_vo_index ], true );
			level.chopper_multi_kills_vo_index += 1;
			
			if ( level.chopper_multi_kills_vo_index >= level.chopper_multi_kills_vo.size )
			{
				level.chopper_multi_kills_vo_index = 0;
			}
		}
	}
	else
	{
		level.player thread play_vo( level.chopper_single_kills_vo[ level.chopper_single_kills_vo_index ], true );
		level.chopper_single_kills_vo_index += 1;
		
		if ( level.chopper_single_kills_vo_index >= level.chopper_single_kills_vo.size )
		{
			level.chopper_single_kills_vo_index = 0;
		}
	}
	
	level.chopper_kill_streak = 0;
}

Chopper_Killed_Hostile_Achievement()
{
	if ( !IsDefined( level.player.achieve_kill_box ) )
		level.player.achieve_kill_box = 1;
	else
		level.player.achieve_kill_box++;
	
	if ( level.player.achieve_kill_box == 20 )
		level.player player_giveachievement_wrapper( "KILL_BOX" );
	
	level waittill("chopper_exit");
	
	// grace time for in-flight projectiles
	wait 1;
	
	level.player.achieve_kill_box = undefined;
}

Monitor_For_Damage()
{
	level endon( "chopper_exit" );
	
	while ( IsAlive( self ) )
	{
		self waittill( "damage", damage, attacker );
		
		if ( attacker == level.player )
		{
			chopper_hit_target_overlay();
		}
	}
}

Chopper_Attack_Target( target, delay )
{
	if ( IsDefined( delay ) )
	{
		wait delay;
	}
	
	self maps\_helicopter_globals::Fire_Missile( "hind_zippy", 2, target, 0.1 );
}

Chopper_Change_Strafe_Locations( name, no_wait )
{
	level endon( "chopper_not_usable" );
	
	level.chopper_strafe_locations = GetStructArray( name, "targetname" );
	
	if ( !IsDefined( no_wait ) || !no_wait )
	{
		level.player waittill( "chopper_strafe_end" );
	}

	level.chopper_strafe_next_index = randomint( level.chopper_strafe_locations.size );
	level.chopper_strafe_next = level.chopper_strafe_locations[ level.chopper_strafe_next_index ];
	
	if ( !flag( "chopper_has_been_used" ) )
	{
		self notify( "newpath" );
		
		if ( !IsDefined( level.chopper_look_at_ent ) )
		{
			level.chopper_look_at_ent = spawn( "script_origin", level.chopper_strafe_next.origin );
		}
		
		self thread Chopper_Strafe_Idle_Hover();
/*		
		self SetNearGoalNotifyDist( 200 );
		self SetVehGoalPos( level.chopper_strafe_next.origin, true );
		self Vehicle_SetSpeed( 65, 60, 60 );
		if ( !IsDefined( level.chopper_look_at_ent ) )
		{
			level.chopper_look_at_ent = spawn( "script_origin", level.chopper_strafe_next.origin );
		}
		
		level.chopper_look_at_ent.origin = level.chopper_strafe_next.origin + ( anglestoforward( level.chopper_strafe_next.angles ) * 750 );
		self SetLookAtEnt( level.chopper_look_at_ent );
		
		self waittill_any( "near_goal", "goal" );
		
		wait 5;*/
	}
}

Chopper_Strafe_Idle_Hover()
{
	self endon( "newpath" );
	
	self ClearGoalYaw();
	
	level.chopper_look_at_ent.origin = GetStruct( level.chopper_strafe_next.target, "targetname" ).origin;
	self SetLookAtEnt( level.chopper_look_at_ent );
	
	right = AnglesToRight( level.chopper_strafe_next.angles );
	
	modifier = 1;
	
	self SetNearGoalNotifyDist( 200 );
	self SetMaxPitchRoll( 30, 30 );
	self Vehicle_SetSpeed( 30, 25, 25 );

	while ( 1 )
	{
		self SetVehGoalPos( level.chopper_strafe_next.origin + right * RandomFloatRange( 500, 1000 ) * modifier + ( 0, 0, RandomFloat( 250 ) ), false );
		
		self waittill_any( "near_goal", "goal" );
		
		if ( modifier == 1 )
		{
			modifier = -1;
		}
		else
		{
			modifier = 1;
		}
	}
}

Chopper_Strafing_Run()
{
	self endon( "end_strafing_run" );
	self notify( "newpath" );
	self ClearLookAtEnt();
	self ClearGoalYaw();
	
	flag_set( "chopper_strafing" );
	
	if ( level.chopper_strafe_next.origin[ 2 ] < 1000 )
	{
		self SetMaxPitchRoll( 15, 15 );
	}
	else
	{
		self SetMaxPitchRoll( 30, 30 );
	}

	level.chopper_strafe_next.radius = 100000;
	self thread vehicle_paths( level.chopper_strafe_next );
	
	flag_wait( "chopper_strafe_end" );
	
	self SetMaxPitchRoll( 30, 30 );
	
	level.chopper_strafe_next_index += 1;
	if ( level.chopper_strafe_next_index >= level.chopper_strafe_locations.size )
	{
		level.chopper_strafe_next_index = 0;
	}
	
	level.chopper_strafe_next = 500;
	level.chopper_strafe_next = level.chopper_strafe_locations[ level.chopper_strafe_next_index ];
	
	wait 1;
	
	flag_set( "chopper_has_been_used" );
	flag_clear( "chopper_strafing" );
	flag_clear( "chopper_usable" );
	flag_clear( "chopper_do_not_abort_strafe" );
	level.player setWeaponHudIconOverride( "actionslot4", "none" );
	level.player notify( "chopper_strafe_end" );
	
	wait 1;
	
	flag_clear( "chopper_strafe_end" );
	
	if ( flag( "chopper_give_player_control" ) )
	{
		level.player thread play_vo( level.chopper_strafe_finished_vo[ level.chopper_strafe_finished_vo_index], true );
		
		level.chopper_strafe_finished_vo_index += 1;
		
		if ( level.chopper_strafe_finished_vo_index >= level.chopper_strafe_finished_vo.size )
		{
			level.chopper_strafe_finished_vo_index = 0;
		}
	}
	
	self thread vehicle_paths( level.chopper_strafe_next );
	level.chopper_strafe_next waittill( "trigger" );
	
	self notify( "newpath" );
	
	self SetVehGoalPos( level.chopper_strafe_next.origin, false );
	level.chopper_look_at_ent.origin = level.chopper_strafe_next.origin + ( anglestoforward( level.chopper_strafe_next.angles ) * 1500 );
	self SetLookAtEnt( level.chopper_look_at_ent );
	
	self SetNearGoalNotifyDist( 500 );
	
	self waittill_any( "near_goal", "goal" );
	
	wait 1;
	
	self thread Chopper_Strafe_Idle_Hover();
	
//	self Vehicle_SetSpeed( 10, 5, 5 );
	
	// roughly 60 seconds between chopper runs (about 15 seconds are taken up flying to next destination)
	// Don't set this to be less than 12, that's roughly how long it takes to turn around and be fully in position
	wait 45;  
	
	if ( flag( "chopper_give_player_control" ) && !flag( "chopper_changing_strafe_locations" ) )
	{
		flag_set( "chopper_usable" );
	}
}

Chopper_Abort_Strafing_Run()
{
	if ( !flag( "chopper_strafe_end" ) && flag( "chopper_should_strafe" ) && !flag( "chopper_do_not_abort_strafe" ) )
	{
		flag_clear( "chopper_strafing" );
		flag_clear( "chopper_usable" );
		level.player setWeaponHudIconOverride( "actionslot4", "none" );
		level.player notify( "chopper_use" );
		
		self notify( "end_strafing_run" );
		self notify( "newpath" );
		
		self SetVehGoalPos( level.chopper_strafe_next.origin, true );
		level.chopper_look_at_ent.origin = level.chopper_strafe_next.origin + ( anglestoforward( level.chopper_strafe_next.angles ) * 1500 );
		self SetLookAtEnt( level.chopper_look_at_ent );
		
		self SetNearGoalNotifyDist( 500 );
		
		self waittill_any( "near_goal", "goal" );
		
		wait 1;
		
		flag_set( "chopper_usable" );
	}
}

Chopper_Screen_Shake( time )
{
	level endon( "chopper_exit" );
	
	endTime = GetTime() + time * 1000;
	
	while ( GetTime() < endTime )
	{
		earthquake( 0.5, 0.1, level.chopper.origin, 9999999 );
		wait 0.1;
	}
}

Chopper_Death_Fx()
{	
	PlayFXOnTag( level._effect[ "helicopter_explosion_secondary_small" ], self, "tag_light_belly" );
	wait 0.5;
	self thread Chopper_Death_Fx_Loop();
	wait 2.0;
	PlayFxOnTag( level._effect[ "helicopter_explosion_secondary_small" ], self, "tag_light_belly" );
}

Chopper_Death_Fx_Loop()
{
	while ( IsDefined( self ) )
	{
		PlayFxOnTag( level._effect[ "fire_smoke_trail_L" ], self, "tag_light_belly" );
		wait 0.05;
	}
}

Chopper_Create_Missile_Attractor( attacker )
{
	self endon( "death" );
	
	if ( flag( "chopper_in_use_by_player" ) )
	{
		attractor_ent = Spawn( "script_origin", level.chopper GetTagOrigin( "tag_player" ) + AnglesToRight( level.chopper.angles ) * 20.0 - ( 0, 0, 50 ) );
	}
	else
	{
		attractor_ent = Spawn( "script_origin", self GetTagOrigin( "tag_flare" ) );
	}
	
//	tail_rotor.origin += ( anglestoforward( self.angles ) * 40 ) + ( anglestoright( self.angles ) * 25 ) - ( 0, 0, 60 );
	attractor_ent LinkTo( level.chopper );
	
	if ( IsDefined( level.chopper.repulsor ) )
	{
		Missile_DeleteAttractor( level.chopper.repulsor );
		level.chopper.repulsor = undefined;
	}
	
	if ( IsDefined( attacker ) )
	{
		self.missileAttractor = Missile_CreateAttractorEnt( attractor_ent, 20000, 1000, attacker );
	}
	else
	{
		self.missileAttractor = Missile_CreateAttractorEnt( attractor_ent, 20000, 1000 );
	}
}

Chopper_Death_Handler()
{
	if ( self.classname != "script_model" )
	{
		self waittill( "death" );
	}
	else
	{
		self notify( "death" );
	}
	
	aud_send_msg( "chopper_hit_by_rpg" ); // AUDIO: do stuff and things when chopper is hit by RPG
		
	if ( IsDefined( self.missileAttractor ) )
	{
		Missile_DeleteAttractor( self.missileAttractor );
		self.missileAttractor = undefined;
	}
	
	self setCanDamage( false );
	
	if ( flag( "chopper_in_use_by_player" ) )
	{
		level.player Unlink();
		gunnerPos = self GetTagOrigin( "tag_player" ) + AnglesToRight( level.chopper.angles ) * 20.0 - ( 0, 0, 50 );
		level.player SetOrigin( gunnerPos );
		level.player PlayerLinkToDelta( self, "tag_player", 1.0, 180, 180, 0, 160, false );
		level.player PlayerLinkedOffsetEnable();
		self thread Chopper_Screen_Shake( 3.0 );
		level.player PlayRumbleOnEntity( "heavy_3s" );
		level.player static_overlay( 2.5 );
		wait 0.5;
	}
	else if ( level.player HasWeapon( "remote_chopper_gunner" ) )
	{
		thread AbortLaptopSwitch( level.player );
	}
	
	flag_clear( "chopper_give_player_control" );
}

fire_rpgs_from_ai()
{
	self endon( "death" );
	level endon( "chopper_exit" );
	
	while ( 1 )
	{
		if ( flag( "chopper_final_ride" ) )
		{
			wait RandomFloatRange( 2.0, 4.5 );
		}
		else
		{
			wait RandomFloatRange( 5.0, 9.0 );
		}

		valid_ai = [];
		
		attack_spot = self.origin + ( AnglesToForward( self.angles ) * RandomFloatRange( 750, 1000 ) ) + ( 0, 0, 100 );
		
		foreach( ai in GetAIArray( "axis" ) )
		{
			if ( IsAlive( ai ) && 
			    (!IsDefined(ai.script_noteworthy) || (ai.script_noteworthy != "mortar_guys" && ai.script_noteworthy != "rooftop_mg" && ai.script_noteworthy != "balcony_mg") ) &&
			    BulletTracePassed( ai.origin + ( 0, 0, 100 ), attack_spot, true, undefined ) )
			{
				valid_ai[ valid_ai.size ] = ai;
			}
		}
		
		if ( valid_ai.size )
		{
			ai = valid_ai[ RandomInt( valid_ai.size ) ];
			
			MagicBullet( "rpg", ai.origin + ( 0, 0, 100 ), attack_spot );
		}
	}
}

chopper_init_destructables()
{
	run_thread_on_targetname( "chopper_destructable_woodroof", ::destructable_damaged, "wood_plank2" );
}

destructable_damaged( fx )
{
	level endon( "chopper_exit" );

	self SetCanDamage( true );
	self.health = 99999;
	
	while ( 1 )
	{
		self waittill( "damage", damage, attacker );
		self.health = 99999;
		
		if ( attacker == level.player )
		{
			playfx( getfx( fx ), self.origin );
			self Delete();
			break;
		}
	}
}
