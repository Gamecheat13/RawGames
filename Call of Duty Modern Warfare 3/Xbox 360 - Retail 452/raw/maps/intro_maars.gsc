#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\intro_utility;
#include maps\_hud_util;
#include maps\_audio;

///////////////////////////
//---- MAARS CONTROL ----//
///////////////////////////

maars_init()
{
	//  51°30'10.45"N
	//  0° 0'44.32"W

	level.maars_interface_fontscale = 1.25;
	PrecacheShader( "ugv_vertical_meter_left" );
	PrecacheShader( "ugv_vertical_meter_right" );
	PreCacheShader( "ugv_crosshair" );
	PreCacheShader( "ugv_ammo_counter" );
	PreCacheShader( "ugv_screen_overlay" );
	PreCacheShader( "ugv_vignette_overlay_top_left" );
	PreCacheShader( "ugv_vignette_overlay_top_right" );
	PreCacheShader( "ugv_vignette_overlay_bottom_right" );
	PreCacheShader( "ugv_vignette_overlay_bottom_left" );
	PreCacheShader( "hud_weaponbar_line" );
	
	//PreCacheShader( "ugv_logo" );
	
	PrecacheShader( "uav_vehicle_target" );
	PrecacheShader( "veh_hud_friendly" );
	PreCacheShader( "overlay_static" );
	PreCacheShader( "hud_fofbox_hostile" );
	PreCacheShader( "veh_hud_target" );

	PreCacheShader( "ugv_missile_warning" );

	level.maars_m203 = "m203_india";
	PrecacheItem( level.maars_m203 );											//MAARS fake fire

	level.maars_m203_rounds = 24;
	level.incoming_missile = false;

	SetSavedDvar( "thermalBlurFactorNoScope", 50 );

	flag_init( "maars_interface_enabled" );
	flag_init( "maars_thermal_on" );
	flag_init( "maars_fail_on_death" );
	flag_init( "maars_death" );
	flag_init( "maars_end_loading" );
	flag_init( "maars_loaded" );
	flag_init( "maars_interface_boot_complete" );
	
}

show_maars_vehicle()
{
	self Show();
	self.mgturret[0] Show();
}

hide_maars_vehicle()
{
	self Hide();
	self.mgturret[0] Hide();
}

mount_maars( ugv_model, laptop_position_struct )
{
	level.player endon( "death" );
	if ( !IsAlive( level.player ) )
		return;
	
	self.player_return_pos = level.player.origin;
	self.player_return_angles = level.player GetPlayerAngles();
		
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player DisableWeapons();
	level.player FreezeControls( true );
	self.mgturret[0] TurretFireDisable();
	
	maars_zoom_to_controls( laptop_position_struct );
	
	// don't use DOF on turret
	level.level_specific_dof = true;
	
	// show ugv vehicle and hide model
	//   the crate piece on the ground can cause the UGV to be stuck; teleport slightly above it
	vehicle_origin = ( ugv_model.origin[0], ugv_model.origin[1], ugv_model.origin[2] + 2 );
	self Vehicle_Teleport( vehicle_origin, ugv_model.angles );
	ugv_model Hide();
	self show_maars_vehicle();
	
	// spawn a model for yourself
	convert_player_to_drone();

	self attach_player_to_turret();
	self.mgturret[0] MakeTurretSolid();
	self.mgturret[0] SetCanDamage( true );
	self.mgturret[0].animname = "ugv_turret";
	self.mgturret[0] setanimtree();
	self.mgturret[0] thread pass_turret_damage_to_player();
	self.mgturret[0] thread randomize_turret_spread();
	self.mgturret[0] DontCastShadows();
	aud_send_msg("maars_player_control_start", self);
		
	level.player SetPlayerAngles( self.angles );
	level.player enabledeathshield( true );
	level.player thread monitor_player_damage();
	level.player thread health_regen();
	
	thread player_damage_setup();
	self thread maars_fire_m203();
	level.player.disable_breathing_sound = true;
	
	flag_set( "maars_end_loading" );
	flag_wait( "maars_loaded" );
	
	self thread maps\intro_fx::maars_ugv_damagefx(self.mgturret[0]);
	//thread fire_grenade_hint();
	//thread zoom_hint();
	level.player thread controls_hint( ::get_zoom_string, 0, 15 );
	level.player thread controls_hint( ::get_grenade_string, 30, 15 );
	
	//thread unfade_from_black( 1 );
	
	level.friendly_fire_fail_check = ::maars_friendly_fire_check;
	
	wait 0.5;
	level.player PlayerLinkTo( self.mgturret[0], "tag_gunner", 0, 180, 180, 180, 45, false );
	level.player PlayerLinkedTurretAnglesEnable();
	level.player FreezeControls( false );
	level.player EnableWeapons();
	self.mgturret[0] TurretFireEnable();
	
	self thread maars_badplace();
	self thread maars_touch_damage();
	
	aud_send_msg("mus_ugv_start", self);
	aud_send_msg("maars_ugv_start", self);
	level notify( "maars_mounted" );
}

randomize_turret_spread()
{
	level endon( "dismount_maars" );
	
	while ( true )
	{
		// randomize the player spread on turrets to
		//   get more of a random shot
		spread = RandomFloatRange( 0.2, 1 );
		self SetPlayerSpread( spread );
		wait 0.05;
	}
}

maars_zoom_to_controls( laptop_position_struct )
{
	fx_wait_time = 1.5;
	wait_to_fade = 0.6;
	fadetime = 0.25;
	wait_fade_time = fadetime + 0.1;
	
	total_lerp_time = fx_wait_time + wait_to_fade + fadetime + wait_fade_time;
	
	flag_set("fx_maars_hud_up");
	thread lerp_player_view_to_position_and_wait( laptop_position_struct.origin, laptop_position_struct.angles, 2, total_lerp_time, 1, 0, 0, 0, 0 );
	wait fx_wait_time;
	level.hud_org = spawn_tag_origin();
	robotGun = level.ugv_vehicle.mgturret[0];
	level.hud_org linkto(robotGun, "tag_player", (0,0,0), (0,180,0));
	playfxontag(getfx("light_hdr_maars_intro_hud"), level.hud_org, "tag_origin");
	wait wait_to_fade;
	fade_to_black( fadetime );//.1
	wait wait_fade_time;
	level.player thread maars_interface_startup_sequence();
}

maars_zoom_out_to_player( laptop_position_struct )
{
	level.player SetOrigin( laptop_position_struct.origin );
	level.player SetPlayerAngles( laptop_position_struct.angles );
	
	player_exit = getstruct( laptop_position_struct.target, "targetname" );
	
	lerp_player_view_to_position( player_exit.origin, player_exit.angles, 1, 1, 0, 0, 0, 0 );
	wait 1;
}

attach_player_to_turret()
{
	AssertEx( IsAlive( level.player ), "player must be alive to attach to turret" );
	
	// can't "use" things while controls are frozen
	level.player DriveVehicleAndControlTurret( self );
	self.mgturret[0] UseBy( level.player );
	self.mgturret[0] MakeUnusable();

	level.player DisableTurretDismount();
	
	level.player PlayerLinkTo( self.mgturret[0], "tag_gunner", 0, 0, 0, 0, 0, false );
	
	// PlayerLinkTo will automatically unfreeze the controls.
	//   Freeze them again.
	level.player FreezeControls( true );
}

dismount_maars( ugv_model, laptop_position_struct )
{
	level.player notify( "end_monitor_player_damage" );
	
	level.player FreezeControls( true );
	thread fade_to_black( 0.2 );
	wait 0.2;
	
	level.level_specific_dof = false;
	
	// show ugv model and hide vehicle
	ugv_model.origin = self.origin;
	ugv_model.angles = self.angles;
	ugv_model Show();
	self hide_maars_vehicle();
	
	level.player FreezeControls( false );
	level.player DisableWeapons();
	
	self detach_player_from_turret();
	
	thread clean_up_player_drone();
	
	thread maars_zoom_out_to_player( laptop_position_struct );
	
	level.player PainVisionOff();
	level.player ent_flag_clear( "player_has_red_flashing_overlay" );
	level.player.health = level.player.maxhealth;
	
	level notify( "dismount_maars" );
	level.player thread maars_interface_disable_view();
	level.player enabledeathshield( false );
	thread player_damage_setup_restore();
	level.player.disable_breathing_sound = undefined;
	
	level.friendly_fire_fail_check = undefined;
	
	level.player FreezeControls( true );
	thread unfade_from_black( 1 );
	wait 0.5;
	level.player FreezeControls( false );
	level.player EnableWeapons();
	level.player AllowCrouch( true );
	level.player AllowProne( true );
}

detach_player_from_turret()
{
	if ( level.player IsLinked() )
	{
		level.player Unlink();
	}
	
	if ( level.player IsUsingTurret() )
	{
		self.mgturret[0] UseBy( level.player );
		level.player DriveVehicleAndControlTurretOff( self );
	}
}

maars_touch_damage()
{
	level endon( "dismount_maars" );
	
	while ( true )
	{
		self waittill( "touch", touched_entity );
		if ( self.veh_speed > 1 )
		{
			if ( IsDefined( touched_entity ) && IsAlive( touched_entity ) &&
				 ( IsAI( touched_entity ) || ( IsDefined( touched_entity.script_drone ) && touched_entity.script_drone ) ) )
			{
				if ( IsDefined( touched_entity.team ) && touched_entity.team != "allies" )
				{
					// only damage enemies
					touched_entity DoDamage( 99999, self.origin, level.player, self );
				}
			}
		}
	}
}

monitor_player_damage()
{
	level.player endon( "end_monitor_player_damage" );
	
	level.player.death_invulnerable_activated = false;
	
	difficulty_bonus_heath_mult = 1;
	switch( level.gameskill )
	{
		case 2:
			difficulty_bonus_heath_mult = 1.5;
		break;
		case 3:
			difficulty_bonus_heath_mult = 1.5;
		break;
		default:
			difficulty_bonus_heath_mult = 1;
		break;
	}
	
	
	
	level.Player_Ugv_Health = 600 * difficulty_bonus_heath_mult;
	level.player_ugv_health_max_health = 600 * difficulty_bonus_heath_mult;
	
	while ( true )
	{
		level.player waittill( "damage", amount, attacker, direction, point, damage_type );
		
		level.player_ugv_health_hurtAgain = true;
		
		if( !level.player.death_invulnerable_activated )
		{
			level.player_ugv_health -= amount;
		}
	}
}

pass_turret_damage_to_player()
{
	level endon( "dismount_maars" );
	
	self.maxhealth = 20000;
	
	while ( true )
	{
		self.health = self.maxhealth;
		self waittill( "damage", damage, attacker, direction, point, method, modelName, tagName, partName, dFlags, weaponName );
		
		source_pos = point;
		
		// try to find a good source position for the attack
		if ( IsDefined( attacker ) )
		{
			// don't pass damage from allies
			if ( IsDefined( attacker.team ) && attacker.team == level.player.team )
				continue;
			
			distance_to_attack = Distance( self.origin, attacker.origin );
			source_pos = point + ( direction * distance_to_attack * -1 );
		}
		
		level.player DoDamage( damage * 0.25, source_pos, attacker );
	}
}


health_regen()
{
	level.player endon( "end_monitor_player_damage" );
	
	oldratio = 1;
	health_add = 0;

	ugv_health_packets = 3;
	ugv_healthOverlayCutoff = .2;

	veryHurt = false;
	playerJustGotRedFlashing = false;

	lastinvulratio = 1;
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	level.player.death_invulnerable_timeout = gettime();


	for ( ;; )
	{
		wait( 0.05 );
		waittillframeend;// if we're on hard, we need to wait until the bolt damage check before we decide what to do

		//UGV has full health
		if ( level.player_ugv_health == level.player_ugv_health_max_health )
		{
			lastinvulratio = 1;
			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}

		//UGV was hit
		wasVeryHurt = veryHurt;
		ratio = level.player_ugv_health / level.player_ugv_health_max_health;
		
		//if the health ratio is below cutoff get the player to be invulnerable
		if ( ratio <= ugv_healthOverlayCutoff && ugv_health_packets > 1 )
		{
			veryHurt = true;
			if ( !wasVeryHurt )
			{
				hurtTime = GetTime();

				playerJustGotRedFlashing = true;
			}
		}

		//track the last time the ugv was hit
		if ( level.player_ugv_health_hurtAgain )
		{
			hurtTime = GetTime();
			level.player_ugv_health_hurtAgain = false;
		}

		//ugv should regen because he hasn't been hit 
		if ( level.player_ugv_health / level.player_ugv_health_max_health >= oldratio )
		{
			//make sure its regens after the regen delay
			if ( GetTime() - hurttime < self.gs.playerHealth_RegularRegenDelay )
				continue;

			//if the damage taken was over the invulnerable threshold slowly regen health
			if ( veryHurt )
			{
				newHealth = ratio;
				if ( GetTime() > hurtTime + self.gs.longRegenTime )
					newHealth += self.gs.regenRate;
			}
			else
			{
				newHealth = 1;
			}

			if ( newHealth > 1.0 )
				newHealth = 1.0;

			if ( newHealth <= 0 )
			{
				
				// Player is dead
				return;
			}

			level.player_ugv_health = newHealth * level.player_ugv_health_max_health;
			oldRatio = level.player_ugv_health / level.player_ugv_health_max_health;
			continue;
		}
		
		oldratio = lastinvulRatio;
		
		//UGV wasn't trying to regen but was hit
		if ( level.player_ugv_health <= 1 )
		{
			// set the health to 2 so we can at least detect when they're getting hit.
			level.player_ugv_health = 2 / level.player_ugv_health_max_health;	
		}

		oldRatio = level.player_ugv_health / level.player_ugv_health_max_health;
		self notify( "hit_again" );

		hurtTime = GetTime();
		
		if ( level.player.death_invulnerable_activated  )
		{	
			continue;
		}
		else
		{
			level.player.death_invulnerable_activated = true;
			
			// haven't used our invulnerability yet, use it now
			if( level.player.death_invulnerable_timeout < GetTime() )
				level.player.death_invulnerable_timeout = GetTime() + level.player.deathInvulnerableTime + 1000;
		}
		level notify( "ugv_becoming_invulnerable" );// because "player_is_invulnerable" notify happens on both set * and * clear

		check_death = false;
		if ( playerJustGotRedFlashing )
		{
			//invulTime = self.gs.invulTime_onShield;
			invulTime = 4;
			playerJustGotRedFlashing = false;
			check_death = true;//so we don't kill the player if they take a ton of damage during the other shields
		}
		else if ( veryHurt )
		{
			invulTime = self.gs.invulTime_postShield;
			check_death = true;
		}
		else
		{
			invulTime = self.gs.invulTime_preShield;
		}

		lastinvulratio = self.health / self.maxHealth;

		self thread ugvInvul( invulTime, check_death  );
	}
}

ugvInvul( timer, check_death )
{
	if ( timer > 0 )
	{
		level.player.ugvInvulTimeEnd = GetTime() + timer * 1000;
		wait( timer );
	}
	if( check_death )
	{
		if( level.player_ugv_health < 1 )
		{
			if( flag( "maars_fail_on_death" ) )
			{
				// you have failed
				flag_set( "maars_death" );
				level.player FreezeControls( true );
				wait 1;
				thread fade_to_black( 0.2 );
				thread fade_hud( 0.2, 0 );
				wait 0.2;
				
				dead_quote_ui = self createClientFontString( "default", 2 );
				dead_quote_ui.x = 0;//70
				dead_quote_ui.y = -40;//150
				dead_quote_ui.alignX = "center";
				dead_quote_ui.alignY = "middle";
				dead_quote_ui.horzAlign = "center";
				dead_quote_ui.vertAlign = "middle";
				//dead_quote_ui setPoint( "CENTER", undefined, 80, 80 );
				dead_quote_ui settext( &"INTRO_UGV_DEATH_QUOTE" );
				dead_quote_ui.color = (1,1,1);
				dead_quote_ui.sort = 5;
				
				SetDvar( "ui_deadquote", &"INTRO_UGV_DEATH_QUOTE" );
				missionFailedWrapper();
			}
		}
	}

	maps\_gameskill::update_player_attacker_accuracy();

	level.player.death_invulnerable_activated = false;
}

#using_animtree( "generic_human" );
convert_player_to_drone()
{
	yuri_drone_spawner = GetEnt( "yuri_drone_spawner", "targetname" );
	level.player_drone = yuri_drone_spawner spawn_ai( true );
	level.player_drone set_ai_number();
	level.player_drone.animname = "yuri";
	level.player_drone.origin = level.player.origin;
	level.player_drone.angles = level.player.angles;
	
	level.player_drone thread ignore_enemy_damage();
	level.player_drone thread detect_drone_death();
	
	anim_player_controlling_ugv = GetStruct( "maars_control_maars_intro_player_drone", "targetname" );
	anim_player_controlling_ugv thread anim_loop_solo( level.player_drone, "control_ugv" );
	
	//level.player_drone maars_add_target();
}

ignore_enemy_damage()
{
	self endon( "death" );
	
	drone_health = self.health;
	self.damageShield = true;
	
	while ( true )
	{
		self waittill( "damage", amount, attacker, direction, point, damage_type );
		if ( attacker == level.player )
		{
			drone_health = drone_health - amount;
		}
		
		if ( drone_health < 0 )
		{
			self.damageShield = false;
			self.health = 1;
			self notify( "damage", amount, attacker, direction, point, damage_type );
			break;
		}
	}
}

detect_drone_death()
{
	self endon( "end_detect_drone_death" );
	self waittill( "death" );
	SetDvar( "ui_deadquote", &"INTRO_UGV_YURI_DEATH_QUOTE" );
	missionFailedWrapper();
}

clean_up_player_drone()
{
	level.player_drone notify( "end_detect_drone_death" );
	level.player_drone delete();
}

player_damage_setup()
{
	level.old_health_regen_delay = level.player.gs.playerHealth_RegularRegenDelay;
	level.player.gs.playerHealth_RegularRegenDelay = 4000;
	level.old_health_long_regen_delay = level.player.gs.longregentime;
	level.player.gs.longregentime = 5000;
}

player_damage_setup_restore()
{
	level.player.gs.playerHealth_RegularRegenDelay = level.old_health_regen_delay;
	level.player.gs.longregentime = level.old_health_long_regen_delay;
}

maars_badplace()
{
	self endon( "death" );
	level endon( "dismount_maars" );
	
	duration = 0.5;
	height = 300;
	while ( true )
	{
		// bad place where player is aiming?
		//player_angles = level.player GetPlayerAngles();
		//player_forward = AnglesToForward( player_angles );
		//BadPlace_Arc( self.unique_id + "arc", duration, self.origin, 512, height, player_forward, 17, 17, "axis", "team3" );
		
		// bad place where vehicle is moving towards
		vehicle_velocity = self Vehicle_GetVelocity();
		if ( Length( vehicle_velocity ) > 0.1 )
		{
			vehicle_velocity = VectorNormalize( vehicle_velocity );
			BadPlace_Arc( self.unique_id + "arc", duration, self.origin, 256, height, vehicle_velocity, 17, 17, "axis", "team3" );
		}
		
		BadPlace_Cylinder( self.unique_id + "cyl", duration, self.origin, 128, height, "axis", "team3" );
		
		wait( duration + 0.05 );
	}
}


///////////////////////
//---- MAARS HUD ----//
///////////////////////

maars_interface_startup_sequence()
{
	maars_interface_disable_playerhud();
	self.maars_huds = [];
	//self.maars_huds[ "static_goggles" ] 	= create_hud_static_overlay( "ugv_vignette_overlay", 1, 1 );
	
	self.maars_huds[ "static_goggles" ] = create_hud_vignette_overlay();
	
	unfade_from_black(.25);
	//black_screen = create_hud_static_overlay( "black", 2, 1 );

	//initial text dump with logo
	maars_interface_boot_up();

	//system loading with bar
    text = self createClientFontString( "default", 2 );
    text setPoint( "CENTER", undefined, 0, 45 );
	text settext( "SISTEMA ZAGRUZKI" );
	text thread update_flash_loading();
	
	
	
	//self.maars_huds[ "static_grain" ] 		= create_hud_static_overlay( "ugv_screen_overlay", 0, .2 );
	
	black_screen = "";
	thread unfade_boot_up( black_screen );
	
	bar = self createClientProgressBar( self, 80, "white", "black", 300, 10 );// player, y_offset, shader, bgshader, width, height 
	bar update_loading_bar();
	
	text destroyElem();
	bar destroyElem();
	
	//camera on, just vignette and screen overlay, feedlines appear at the top
	
	
	thread maars_interface_incamera_boot_up();
	
	//hidden stuff
	self.maars_huds[ "damage_overlay" ] 	= create_hud_static_overlay( "overlay_static", 10, 0 );
	self.maars_huds[ "incoming_missile" ] 	= create_hud_incoming_missile();
	
	wait .5;
	self.maars_huds[ "vert_meter_right" ] 		= create_hud_vertical_meter_right();
	self.maars_huds[ "vert_meter_left" ] 		= create_hud_vertical_meter_left();

	wait .5;
	self.maars_huds[ "cross_hair" ] 		= create_hud_crosshair();
	wait .5;
	self.maars_huds[ "m203_ammo" ] 			= create_hud_m203_ammo();
	
	flag_wait( "maars_end_loading" );
	
	

	self thread maars_interface_enable_view();
	flag_set( "maars_loaded" );
}

unfade_boot_up( black_screen )
{
	wait .5;
	flag_set( "maars_control_boot_up_fading" );
	/*black_screen fadeOverTime( .5 );
	black_screen.alpha = 0;
	wait .5;
	black_screen destroy();*/
	stopfxontag(getfx("light_hdr_maars_intro_hud"), level.hud_org, "tag_origin");
	playfxontag(getfx("light_hdr_maars_intro_hud_endlines"), level.hud_org, "tag_origin");
	wait 1.5;
	level.hud_org delete();
	wait 3;
	flag_clear("fx_maars_hud_up");
}

maars_interface_boot_up()
{
	
	level.linefeed_delay = .05;
	level.linefeed_delete_delay = 0;
	level.feedline_height = 12;
	level.feedline_max_line_height = 340;
	font_scale = 1.2;
	color = ( 1.0, 1.0, 1.0 );
	xoffset = 80;
	
	//boot_logo = create_hud_logo( "ugv_logo" );
	
	bottom_text = self createClientFontString( "small", font_scale );
    bottom_text setPoint( "CENTER", undefined, -60, 120 );
	bottom_text settext( "Nazhmite F2, Chtoby vojti SETUP. F12 Dlja setevoj zagruzki. ESC dlja Menju zagruzki            0 0B" );
	
	lines1 = [];
	lines1[ lines1.size ] = "InfinityHammer BIOS 4.0 Reliz 6.0"; 
	lines1[ lines1.size ] = "Avtorskoe pravo 1985-2006 InifityHammer Ltd."; 
	lines1[ lines1.size ] = "Vse Prava Zawiweny"; 
	lines1[ lines1.size ] = "Avtorskoe Pravo 2000-2008 GRware, Inc."; 
	lines1[ lines1.size ] = "GRware BIOS Stroit' 256"; 
	lines1[ lines1.size ] = " "; 
	lines1[ lines1.size ] = "ATAPI CD-ROM: GRware Virtual'nyj IDE CDROM Drive"; 
	lines1[ lines1.size ] = "Mysh' inicializiruetsja"; 
	lines1[ lines1.size ] = "... "; 
	lines1[ lines1.size ] = ".. "; 
	lines1[ lines1.size ] = ". "; 
	
	maars_interface_feedlines( lines1, font_scale, color, 80 );
	
	wait .1;
	maars_interface_feedlines_clear();
	bottom_text destroy();
	
	level.linefeed_delete_delay = .05;
	
	lines2 = [];
	lines2[ lines2.size ] = "GRware BIOS(C)2001 Russian Megawatts, Inc."; 
	lines2[ lines2.size ] = "BIOS Data: 08/19/2006 06:01:09 Versija: 8.00.02"; 
	lines2[ lines2.size ] = " "; 
	lines2[ lines2.size ] = "Nazhmite DEL dlja zapuska Programmy Ustanovki"; 
	lines2[ lines2.size ] = "Kontrol' NVRAM..."; 
	lines2[ lines2.size ] = " "; 
	lines2[ lines2.size ] = "511MB OK"; 
	lines2[ lines2.size ] = "Avtomaticheskoe obnaruzhenie Pri Master ... IDE Hard Disk"; 
	lines2[ lines2.size ] = "Avtomaticheskoe obnaruzhenie Pri Slave ... Ne obnaruzheno"; 
	lines2[ lines2.size ] = "Avtomaticheskoe obnaruzhenie Sec Master ... CD-ROM"; 
	lines2[ lines2.size ] = "Avtomaticheskoe obnaruzhenie Pri Slave ... Ne obnaruzheno"; 
	lines2[ lines2.size ] = "Pri Master: 1. 1 SHGCorpHD"; 
	lines2[ lines2.size ] = " "; 
	lines2[ lines2.size ] = "GRware BIOS(C)2001 Russian Megawatts, Inc."; 
	lines2[ lines2.size ] = "BIOS Data: 08/19/2006 06:01:09 Versija: 8.00.02";  
	lines2[ lines2.size ] = " "; 
	lines2[ lines2.size ] = "Nazhmite DEL dlja zapuska Programmy Ustanovki"; 
	lines2[ lines2.size ] = "Kontrol' NVRAM..."; 
	lines2[ lines2.size ] = " "; 
	lines2[ lines2.size ] = "511MB OK"; 
	lines2[ lines2.size ] = "Avtomaticheskoe obnaruzhenie Pri Master ... IDE Hard Disk"; 
	lines2[ lines2.size ] = "Avtomaticheskoe obnaruzhenie Pri Slave ... Ne obnaruzheno"; 
 	lines2[ lines2.size ] = " "; 
	lines2[ lines2.size ] = "GRware BIOS(C)2001 Russian Megawatts, Inc."; 
	lines2[ lines2.size ] = "BIOS Data: 08/19/2006 06:01:09 Versija: 8.00.02"; 
	lines2[ lines2.size ] = " "; 
	lines2[ lines2.size ] = "Nazhmite DEL dlja zapuska Programmy Ustanovki"; 
	lines2[ lines2.size ] = "Kontrol' NVRAM..."; 
	lines2[ lines2.size ] = " "; 
	lines2[ lines2.size ] = "511MB OK"; 
	lines2[ lines2.size ] = "Avtomaticheskoe obnaruzhenie Pri Master ... IDE Hard Disk"; 
	lines2[ lines2.size ] = "Avtomaticheskoe obnaruzhenie Pri Slave ... Ne obnaruzheno"; 

	
	maars_interface_feedlines( lines2, font_scale, color, xoffset );
	
	wait .1;
	maars_interface_feedlines_clear();
	//boot_logo destroy();
}

maars_interface_incamera_boot_up()
{
	level.linefeed_delay = .07;
	level.linefeed_delete_delay = .05;
	level.feedline_height = 16;
	level.feedline_max_line_height = 240;
	font_scale = 1.6;
	color = ( .8, 1.0, .8 );
	xoffset = 130;
	
	lines = [];
	lines[ lines.size ] = "PROVERKA SISTEMY..."; 
	lines[ lines.size ] = "ONLINE 2506.62"; 
	lines[ lines.size ] = "BOEPRIPASY CK_456_MAX_COM"; 
	lines[ lines.size ] = "OPS_KONTROL_ONLINE"; 
	lines[ lines.size ] = "REG89300491_PYY3"; 
	lines[ lines.size ] = "RWD_08200619"; 
	lines[ lines.size ] = " "; 
	lines[ lines.size ] = "----------------";
	lines[ lines.size ] = " "; 
	lines[ lines.size ] = "3160 AIMHUD_POD_Y36"; 
	lines[ lines.size ] = " "; 
	lines[ lines.size ] = "BOOT(P) GWR549_NPW"; 
	lines[ lines.size ] = " ";
	lines[ lines.size ] = "UGV_M3_3804";


	maars_interface_feedlines( lines, font_scale, color, xoffset );
	
	wait 2;
	maars_interface_feedlines_clear();
}

get_zoom_string()
{
	action_name = undefined;
	if ( level.Xenon )
		action_name = "ugv_zoom_360";
	else
		action_name = "ugv_zoom";
	actionBind = getActionBind( action_name );

	if ( IsDefined( actionBind ) )
	{
		return actionBind.hint;	
	}
	else
	{
		return "";
	}
}

get_grenade_string()
{
	action_name = undefined;
	if ( level.Xenon )
		action_name = "ugv_grenade";
	else
		action_name = "ugv_grenade";
	actionBind = getActionBind( action_name );

	if ( IsDefined( actionBind ) )
	{
		return actionBind.hint;	
	}
	else
	{
		return "";
	}
}

maars_interface_feedlines( lines, font_scale, color, x  )
{
	keys = GetArrayKeys( lines );
	level.displayed_lines = [];
	level.line_offset = 0;

	for ( i = 0; i < keys.size; i++ )
	{
		key = keys[ i ];

		level.line_offset++;
		
		level.displayed_lines[ level.displayed_lines.size ] = cornerLineThread ( lines[ key ], font_scale, color, x  );
		
		lineY = cornerLineThread_height();
		
		if( lineY > level.feedline_max_line_height )
		{
			feedlines_move_lines_up();
			level.line_offset --;
		}
		
		wait level.linefeed_delay;
	}
}

maars_interface_feedlines_clear()
{
	while( level.displayed_lines.size > 0 )
	{
		feedlines_move_lines_up();
		wait level.linefeed_delete_delay;
	}	
}

cornerLineThread( string, font_scale, color, x  )
{
	level notify( "new_introscreen_element" );

	y = cornerLineThread_height();

	hudelem = NewHudElem();
	hudelem.x = x;
	hudelem.y = y;
	hudelem.alignX = "left";
	hudelem.alignY = "top";
	hudelem.horzAlign = "left";
	hudelem.vertAlign = "top";
	hudelem.sort = 5;// force to draw after the background
	hudelem.foreground = true;
	hudelem SetText( string );
	hudelem.alpha = 1;
	hudelem.hidewheninmenu = true;
	hudelem.fontScale = font_scale;// was 1.6 and 2.4, larger font change
	hudelem.color = color;
	hudelem.font = "small";
	
	return hudelem;
}

feedlines_move_lines_up( )
{
	for ( i = 0; i < level.displayed_lines.size; i++ )
	{
		if( i == 0 )
		{
			level.displayed_lines[ i ] destroy();
		}
		
		if( isdefined( level.displayed_lines[ i + 1 ] ) )
		{
			level.displayed_lines[ i ] = level.displayed_lines[ i + 1 ];
			level.displayed_lines[ i ].y -= level.feedline_height; 
		}
	}
	level.displayed_lines[ level.displayed_lines.size - 1 ] = undefined;
}


cornerLineThread_height()
{
	return( ( ( level.line_offset ) * level.feedline_height ) + 30 );// was 19 and 22 larger font change
}

hudelem_destroy( hudelem )
{
	wait( level.linefeed_delay );
	hudelem notify( "destroying" );
	level.line_offset = undefined;
 
	time = .5;
	hudelem FadeOverTime( time );
	hudelem.alpha = 0;
	wait time;
	hudelem notify( "destroy" );
	hudelem Destroy();
}

create_hud_logo( image )
{
	hud = NewHudElem();
	hud.x = 550;
	hud.y = 60;
	hud.sort = 5;
	hud.alignX = "right";
	hud.alignY = "top";
	hud SetShader( image, 128, 128 );

	return hud;
}

update_flash_loading()
{
	level endon( "maars_loading_bar_complete" );
	while( isdefined( self ) )
	{
		if( isdefined( self ) )
		{
			self fadeOverTime( 0.3 );
			self.alpha = 1;
			wait( 0.5 );
		}
		
		if( isdefined( self ) )
		{
			self fadeOverTime( 0.3 );
			self.alpha = .2;
			wait( 0.6 );
		}
	}
}

update_loading_bar()
{
	//level endon( "maars_end_loading" );
	totaltime = 30;
	count = 0;
	
	while( count < totaltime && isdefined( self ) )
	{
		self updatebar( count / totaltime );
		count++;
		wait .05;
	}
	level notify( "maars_loading_bar_complete" );
}

maars_interface_thread()
{
	self endon( "death" );
	level endon("maars_view_disabled");

	rate = 0.2;
//	curr_latitude = " 1°30'10.50"N"
//  curr_longitude = "0° 0'54.17"W"

	curr_latitude = 51.50291666;
	curr_longitude = 0.015047222 / 60;

	while ( 1 )
	{
		if ( flag( "maars_interface_enabled" ))
		{
			/*
			target_loc = (0,0,0);
				
			// Target data
			range = Distance( self.origin, target_loc );//2nd self.origin = targetent
			range = to_meters( range );
			self maars_set_target_hud_data( "brg", AngleClamp( int( ( self.angles[ 1 ] - 90 ) ) * -1 ) ); // 90 is north
			self maars_set_target_hud_data( "rng_m", int( range ) );
			self maars_set_target_hud_data( "rng_nm", round_to( meters_to_nm( range ), 1000 ) );
			self maars_set_target_hud_data( "elv", int( to_feet( target_loc[ 2 ] ) ) );//self.origin = targetent
			*/
			// Camera Arrows
			//self maars_update_hud_arrows( rate );
		}

		wait( rate );
	}
}

maars_update_hud_arrows( rate )
{
	player_angles = self GetPlayerAngles();
	pitch = player_angles[ 0 ];
	yaw = AngleClamp180( player_angles[ 1 ] );// - player_angles[ 1 ] );

	self maars_set_hud_data( "arrow_left", int( pitch ) );
	self maars_set_hud_data( "arrow_up", int( yaw ) );

	// Left Arrow
	hud_vert_meter = self.maars_huds[ "vert_meter_left" ];
	hud_left_arrow = self.maars_huds[ "arrow_left" ];

	pitch = Clamp( pitch, hud_vert_meter.min_value, hud_vert_meter.max_value );
	percent = abs( pitch / hud_vert_meter.range );
	meter_pos = hud_vert_meter.meter_size * percent;
	offset = meter_pos - ( hud_vert_meter.meter_size * 0.5 );
	y = hud_vert_meter.y + offset;

	hud_left_arrow MoveOverTime( 0.2 );
	hud_left_arrow.y = y;
	hud_left_arrow.data_value MoveOverTime( rate );
	hud_left_arrow.data_value.y = y;

	// Up Arrow
	hud_horz_meter = self.maars_huds[ "vert_meter_right" ];
	hud_up_arrow = self.maars_huds[ "arrow_up" ];

	percent = yaw / hud_horz_meter.range;
	meter_pos = hud_horz_meter.meter_size * percent;
	x = hud_horz_meter.x + meter_pos;

	hud_up_arrow MoveOverTime( 0.2 );
	hud_up_arrow.x = x;
	hud_up_arrow.data_value MoveOverTime( rate );
	hud_up_arrow.data_value.x = x;
}

to_feet( val )
{
	if(val == 0)
		return 0;
		
	return val / 12;
}

to_meters( val )
{
	return val * 0.0254;
}

meters_to_nm( val )
{
	return val * 0.000539956803;
}

round_to( val, mult )
{
	val = int( val * mult ) / mult;
	return val;
}

maars_fire_m203()
{
	self endon( "start_ugv_death" );
	count = 0;
	volley_count = level.maars_m203_rounds;
	volley_wait = 2;
	wait_between_rounds = .45;
	grenade_auto_reload = gettime();
	grenade_round_delay = gettime();
	self.m203_rounds_left = level.maars_m203_rounds;

	ugv_fire_grenade_anim = self.mgturret[0] getanim( "ugv_fire_grenade" );
	self.mgturret[0] setanim( ugv_fire_grenade_anim, 1, 0, 0 );
	
	level waittill( "maars_mounted" );
	
	while(1)
	{
		if( level.player fragbuttonpressed() && grenade_round_delay < gettime() && count < volley_count && !level.player attackbuttonpressed() )
		{
			source_pos = level.player GetEye();
			player_angles = level.player GetPlayerAngles();
			forward_vec = AnglesToForward( player_angles );
			to_right = anglestoRight( player_angles );
			target_pos = source_pos + ( forward_vec * 12 * 2000 );
			
			grenade_launcher_loc = self.mgturret[0] GetTagOrigin( "tag_flash2" );
			
			self.mgturret[0] setanimrestart( ugv_fire_grenade_anim, 1, 0, 1 );
			
			maars_grenade = magicbullet( level.maars_m203, grenade_launcher_loc + ( forward_vec * 32 ), target_pos, level.player );
			playfxontag( getfx( "maars_grenade_muzzleflash" ), self.mgturret[0], "tag_flash2"  );
			aud_send_msg("maars_grenade_fired", maars_grenade);
			level.player playrumbleonentity( "damage_light" );
			level.player.maars_huds[ "m203_ammo" ][ count ].alpha = 0;
			level.player.maars_huds[ "m203_ammo" ][ "current" ] setvalue( level.maars_m203_rounds - count - 1 );
			
			self thread maars_m203_hide_viewmodel_ammo( count );
			count++;
			grenade_auto_reload = gettime() + ( volley_wait * 1000 );
			grenade_round_delay = gettime() + ( wait_between_rounds * 1000 );
		}
		else
		if(level.player fragbuttonpressed() && count >= volley_count)
		{
			hint( &"WEAPON_NO_AMMO", 1 );
		}
		else
		{
			wait( .05 );
		}

	}
}

maars_m203_hide_viewmodel_ammo( count )
{
	self.m203_rounds_left = level.maars_m203_rounds - count;
	
	if( self.m203_rounds_left <= 7 )
	{
		i = self.m203_rounds_left + 3;//hides the rounds so we can see all but the chambered round
		self.mgturret[0] hidepart( "ammo" + i );
	}
	
	
}

calculate_target_pos()
{
	min_target_distance = 128;
	max_target_distance = 4000;
	
	direction = level.player getPlayerAngles();
	direction_vec = anglesToForward( direction );
	trace_start_pos = level.player getEye();
	trace_start_pos = trace_start_pos + ( direction_vec * min_target_distance );
	trace_end_pos = trace_start_pos + ( direction_vec * max_target_distance );
	
	trace = BulletTrace( trace_start_pos, trace_end_pos, 0, level.player );
	aim_target = [];
	aim_target["normal"] = (0,0,1);
	aim_target["pos"] = trace_end_pos;
	
	if ( trace[ "fraction" ] < 1 ) //if we hit something
	{
		aim_target["pos"] = trace["position"];
	}

	return aim_target;
}


maars_player_damage()
{
	self endon( "maars_player_damage_disable" );
	
	overlay = self.maars_huds[ "damage_overlay" ];
	damage_alpha = 0.0;
	damage_alpha_max = .25;
	update_time = 0.05;
	distort_intensity = 0;
	
	while ( IsAlive( self ) && !flag( "maars_death" ) )
	{
		ratio = 1.0 - ( level.player_ugv_health / level.player_ugv_health_max_health );
		target_alpha = ( ratio * ratio ) * .75;
		target_alpha = Clamp( target_alpha, 0, 1 );

		// show more damage instantly, show recovery over a lerp
		if ( target_alpha < damage_alpha )
		{
			lerp_rate = 0.1;
			if ( target_alpha > 0.15 )
			{
				lerp_rate = 1;
			}

			damage_alpha -= ( lerp_rate * update_time );
			damage_alpha = Clamp( damage_alpha, 0, 1 );
		}
		else if ( target_alpha > damage_alpha )
		{
			//boost the distortion if hit
			newdistort_intensity = distort_intensity * 1.5;
			newdistort_speed  = (1+2.0-newdistort_intensity*2.0);
			level.player DigitalDistortSetParams( newdistort_intensity, newdistort_speed );//digital distortion intensity should be inversely  proportional to the speed
			wait update_time * 2;
			damage_alpha = target_alpha;
		}

		damage_intensity = damage_alpha;
		if ( damage_intensity > damage_alpha_max )
			damage_intensity = damage_alpha_max;
		
		//distort_intensity = 0;
		if(damage_intensity >.35) distort_intensity = .45;
		else if(damage_intensity >.2) distort_intensity = .2;
		else if(damage_intensity >.1) distort_intensity = .1;
		else distort_intensity = 0;
		level.player DigitalDistortSetParams(distort_intensity,(1+2.0-distort_intensity*2.0));//( damage_intensity, 1.0 );
		
		aud_send_msg("maars_damage_intensity", damage_intensity);		
		
		wait update_time;
	}
	
	// you have died, play static
	level.player DigitalDistortSetParams( .76, 1.48 );
	aud_send_msg("digital_distort_death");
}

maars_setup_damage_overlays()
{
	level.player notify( "noHealthOverlay" );
	level.cover_warnings_disabled = 1;
	level.player ent_flag_clear( "near_death_vision_enabled" );
	level.player ent_flag_set( "player_no_auto_blur" );
	level.player thread maars_player_damage();
	explosive = ::maars_damage_explosive;
	bullet = ::maars_damage_bullet;
	
	level.player.mods_override = [];
	level.player.mods_override[ "MOD_GRENADE" ] = explosive;
	level.player.mods_override[ "MOD_GRENADE_SPLASH" ] = explosive;
	level.player.mods_override[ "MOD_PROJECTILE" ] = explosive;
	level.player.mods_override[ "MOD_PROJECTILE_SPLASH" ] = explosive;
	level.player.mods_override[ "MOD_EXPLOSIVE" ] = explosive;
	
	level.player.mods_override[ "MOD_PISTOL_BULLET" ] = bullet;
	level.player.mods_override[ "MOD_RIFLE_BULLET" ] = bullet;
	level.player.mods_override[ "MOD_EXPLOSIVE_BULLET" ] = bullet;
}

maars_setup_damage_overlays_restore()
{
	level.player.mods_override = undefined;
	level.cover_warnings_disabled = undefined;
	level.player ent_flag_set( "near_death_vision_enabled" );
	level.player ent_flag_clear( "player_no_auto_blur" );
	level.player thread maps\_gameskill::healthOverlay();
	level.player notify( "maars_player_damage_disable" );
}

maars_damage_explosive( position )
{
	aud_send_msg("maars_takes_explosive_dmg");
	//thread hint( "explosive damage", 1 );
}

maars_damage_bullet( position )
{
	aud_send_msg("maars_takes_bullet_dmg");
	//thread hint( "bullet damage", 1 );
}


maars_interface_enable_playerhud()
{
	SetSavedDvar( "compassHideSansObjectivePointer", 0 );	
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "actionSlotsHide", "0" );
}

maars_interface_disable_playerhud()
{
	SetSavedDvar( "compassHideSansObjectivePointer", 1 );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "actionSlotsHide", "1" );
}

maars_interface_enable_view()
{
	// Store some settings
	self.maars_huds[ "vert_meter_left" ].meter_size = 192;
	self.maars_huds[ "vert_meter_left" ].min_value = 10;
	self.maars_huds[ "vert_meter_left" ].max_value = 90;
	self.maars_huds[ "vert_meter_left" ].range = self.maars_huds[ "vert_meter_left" ].max_value - self.maars_huds[ "vert_meter_left" ].min_value;

	self.maars_huds[ "vert_meter_right" ].meter_size = 192;
	self.maars_huds[ "vert_meter_right" ].min_value = 10;
	self.maars_huds[ "vert_meter_right" ].max_value = 90;
	self.maars_huds[ "vert_meter_right" ].range = self.maars_huds[ "vert_meter_right" ].max_value - self.maars_huds[ "vert_meter_right" ].min_value;

	flag_set( "maars_interface_enabled" );
	self thread maars_draw_targets();
	//self thread maars_interface_thread();
	thread maars_setup_damage_overlays();
	//thread maars_setup_thermal();
}

create_hud_static_overlay(overlay, sortOrder, alphaValue)
{
	hud = NewHudElem();
	hud.x = 0;
	hud.y = 0;
	hud.sort = sortOrder;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.alpha = alphaValue;
	hud SetShader( overlay, 640, 480 );

	return hud;
}

create_hud_vignette_overlay()
{
	hudelements = [];
	hud = NewHudElem();
	hud.x = -64;
	hud.y = -36;
	hud.sort = 5;
	hud.alignX = "left";
	hud.alignY = "top";
	hud.horzAlign = "left";
	hud.vertAlign = "top";
	hud SetShader( "ugv_vignette_overlay_top_left", 256, 256 );
	hudelements[0] = hud;
	
	hud2 = NewHudElem();
	hud2.x = 64;
	hud2.y = -36;
	hud2.sort = 5;
	hud2.alignX = "right";
	hud2.alignY = "top";
	hud2.horzAlign = "right";
	hud2.vertAlign = "top";
	hud2 SetShader( "ugv_vignette_overlay_top_right", 256, 256 );
	hudelements[1] = hud2;
	
	hud3 = NewHudElem();
	hud3.x = 64;
	hud3.y = 36;
	hud3.sort = 5;
	hud3.alignX = "right";
	hud3.alignY = "bottom";
	hud3.horzAlign = "right";
	hud3.vertAlign = "bottom";
	hud3 SetShader( "ugv_vignette_overlay_bottom_right", 256, 256 );
	hudelements[2] = hud3;
	
	hud4 = NewHudElem();
	hud4.x = -64;
	hud4.y = 36;
	hud4.sort = 5;
	hud4.alignX = "left";
	hud4.alignY = "bottom";
	hud4.horzAlign = "left";
	hud4.vertAlign = "bottom";
	hud4 SetShader( "ugv_vignette_overlay_bottom_left", 256, 256 );
	hudelements[3] = hud4;
	
	return hudelements;
}

create_hud_vertical_meter_right()
{
	hud = NewHudElem();
	hud.x = 550;
	hud.y = 240;
	hud.sort = 5;
	hud.alignX = "left";
	hud.alignY = "middle";
	hud SetShader( "ugv_vertical_meter_right", 32, 192 );

	return hud;
}

create_hud_vertical_meter_left()
{
	hud = NewHudElem();
	hud.x = 90;
	hud.y = 240;
	hud.sort = 5;
	hud.alignX = "right";
	hud.alignY = "middle";
	hud SetShader( "ugv_vertical_meter_left", 32, 192 );

	return hud;
}

create_hud_crosshair()
{
	hud = NewHudElem();
	hud.x = 320;
	hud.y = 240;
	hud.sort = 5;
	hud.alignX = "center";
	hud.alignY = "middle";
	hud SetShader( "ugv_crosshair", 128, 128 );

	return hud;
}

create_hud_m203_ammo()
{
	huds = [];
	x = 385;
	y = 395;
	for( i = 0; i < level.maars_m203_rounds; i++ )
	{
		hud = NewHudElem();
		hud.x = x;
		hud.y = y;
		hud.sort = 5;
		hud.alignX = "center";
		hud.alignY = "bottom";
		hud SetShader( "ugv_ammo_counter", 6, 14 );
	
		huds[ i ] = hud;
		
		x += 6;
		wait .05;
	}
	
	color = ( 1, 1, 1 );
	
	huds[ "text" ] = self createClientFontString( "hudsmall", 1 );
    huds[ "text" ] setPoint( "CENTER", undefined, 210, 130 );
	huds[ "text" ] settext( &"INTRO_UGV_GRENADE" );
	huds[ "text" ].color = color;
	huds[ "text" ].sort = 5;
	
	huds[ "current" ] = self createClientFontString( "hudsmall", 1.4 );
    huds[ "current" ] setPoint( "CENTER", undefined, 240, 147 );
	huds[ "current" ] setvalue( level.maars_m203_rounds );
	huds[ "current" ].color = color;
	huds[ "current" ].sort = 5;
	
	
	hudline = NewHudElem();
	hudline.x = 380;
	hudline.y = 420;
	hudline.sort = 5;
	hudline.alignX = "center";
	hudline.alignY = "bottom";
	hudline SetShader( "hud_weaponbar_line", 392, 84 );
	
	huds[ "hudline" ] = hudline;
	
	
	/*
	huds[ "total" ] = self createClientFontString( "small", 1.4 );
    huds[ "total" ] setPoint( "CENTER", undefined, 140, 190 );
    total_rounds = string( level.maars_m203_rounds );
	huds[ "total" ] settext( "/" + total_rounds );
	huds[ "total" ].color = color;
	huds[ "total" ].sort = 5;
	*/
	
	return huds;
}

create_hud_incoming_missile()
{
	hud = NewHudElem();
	hud.x = 320;
	hud.y = 350;
	hud.sort = 0;
	hud.alignX = "center";
	hud.alignY = "middle";
	hud SetShader( "ugv_missile_warning", 256, 64 );
	hud.alpha = 0;
	return hud;
}

maars_set_target_hud_data( index, value )
{
	self.maars_huds[ "lower_right" ][ index ].data_value SetValue( value );
}

maars_set_hud_data( index, value )
{
	self.maars_huds[ index ].data_value SetValue( value );
}

create_hud_upper_left()
{
	data = [];
	data[ "nar" ]  		= [ "NAR", "none" ];	//
	data[ "white" ]  	= [ "WHT", "none" ];	//
	data[ "rate" ] 		= [ "RATE", "none" ];	//
	data[ "angle" ] 	= [ "ANGLE", "none" ];	//
	data[ "numbers" ] 	= [ "NUM", "none" ];	//
	data[ "temp" ] 		= [ "TEMP", "none" ];	//

	return create_hud_section( data, 10, 80, "left" );
}

create_hud_upper_right()
{
	data = [];
	data[ "acft" ]  	= [ "ACFT", "none" ];	//
	data[ "long" ]  	= [ "N", "none" ];	//
	data[ "lat" ] 		= [ "W", "none" ];	//
	data[ "angle" ] 	= [ "HAT", "none" ];	//

	return create_hud_section( data, 510, 80, "left" );
}

create_hud_lower_right()
{
	data = [];
	data[ "long" ]  	= [ &"N", "none" ];	//
	data[ "lat" ] 		= [ &"W", "none" ];	//

	huds = create_hud_section( data, 500, 335, "left" );

	data = [];
	data[ "brg" ] 		= [ "BRG", "" ];			// Bearing
	data[ "rng_m" ]  	= [ "RNG", "" ];		// Range Meters
	data[ "rng_nm" ] 	= [ "RNG", "" ];	// Range Nautical Miles
	data[ "elv" ] 	 	= [ "ELV", "" ];		// Elevation Feet

	huds2 = create_hud_section( data, 510, 360, "right" );

	foreach ( idx, hud in huds2 )
	{
		huds[ idx ] = hud;
	}

	return huds;
}

create_hud_section( data, x, y, align_x )
{
	huds = [];

	spacing = 10 * level.maars_interface_fontscale;
	foreach ( i, item in data )
	{
		hud = NewHudElem();
		hud.x = x;
		hud.y = y;
		hud.alignX = align_x;
		hud.alignY = "middle";
		hud.sort = 5;
		hud.color = (1,1,1);
		hud.fontscale = level.maars_interface_fontscale;
		hud SetText( item[ 0 ] );

		if ( IsDefined( item[ 1 ] ) )
		{
			if ( !string_is_valid( item[ 1 ], "none" ) )
			{
				hud create_hud_data_value( item[ 1 ] );
			}
		}
		else
		{
			hud create_hud_data_value();
		}

		huds[ i ] = hud;

		y += spacing;
	}

	return huds;
}

string_is_valid( str, test )
{
	if ( IsString( str ) )
	{
		if ( str == test )
		{
			return true;
		}
	}

	return false;
}

create_hud_data_value( suffix )
{
	x_add = 75;

	if ( IsDefined( suffix ) && !string_is_valid( suffix, "" ) )
	{
		data_value_suffix = NewHudElem();
		data_value_suffix.x = self.x + x_add;
		data_value_suffix.y = self.y;
		data_value_suffix.alignX = "right";
		data_value_suffix.alignY = "middle";
		data_value_suffix.fontscale = level.maars_interface_fontscale;
		data_value_suffix SetText( suffix );

		self.data_value_suffix = data_value_suffix;

		size = 1;
		if ( suffix == "UAV_NM" )
		{
			size = 2;
		}

		x_add -= 10 * size;	
	}

	data_value = NewHudElem();
	data_value.x = self.x + x_add;
	data_value.y = self.y;
	data_value.alignX = "right";
	data_value.alignY = "middle";
	data_value.fontscale = level.maars_interface_fontscale;
	data_value SetValue( 0 );

	self.data_value = data_value;
}

create_hud_arrow( dir )
{
	if ( dir == "up" )
	{
		shader = "uav_arrow_up";
		parent_hud = self.maars_huds[ "vert_meter_right" ];
		x = 320;
		y = parent_hud.y + 10;
		x_align = "center";
		y_align = "top";
	}
	else
	{
		shader = "uav_arrow_left";
		parent_hud = self.maars_huds[ "vert_meter_left" ];
		x = parent_hud.x + 10;
		y = 240;
		x_align = "left";
		y_align = "middle";
	}

	hud = NewHudElem();
	hud.x = x;
	hud.y = y;
	hud.alignX = x_align;
	hud.alignY = y_align;
	hud SetShader( shader, 16, 16 );
	hud create_hud_arrow_value( dir );

	return hud;	
}

create_hud_arrow_value( dir )
{
	if ( dir == "up" )
	{
		x = self.x;
		y = self.y + 16;
		x_align = "center";
		y_align = "top";
	}
	else
	{
		x = self.x + 16;
		y = self.y;
		x_align = "left";
		y_align = "middle";
	}

	data_value = NewHudElem();
	data_value.x = x;
	data_value.y = y;
	data_value.alignX = x_align;
	data_value.alignY = y_align;
	data_value SetValue( 0 );

	self.data_value = data_value;
}

maars_interface_disable_death_anim()
{
	//remove hud on ugv animated death
	hud_array = [];
	hud_array[ 0 ] = "vert_meter_right";
	hud_array[ 1 ] = "vert_meter_left";
	hud_array[ 2 ] = "cross_hair";
	hud_array[ 3 ] = "m203_ammo";
				
	foreach ( elem in hud_array )
	{
		if (IsDefined( self.maars_huds[ elem ]) )
		{
			if ( IsArray( self.maars_huds[ elem ] ) )
			{
				foreach ( item in self.maars_huds[ elem ] )
				{
					maars_destroy_hud( item );
				}
	
				self.maars_huds[ elem ] = undefined;
			}
			else
			{
				maars_destroy_hud( self.maars_huds[ elem ] );
			}
		}
	}
}

maars_interface_disable_view()
{
	flag_clear( "maars_interface_enabled" );
	level notify("maars_view_disabled");
	
	maars_hide_targets();
	maars_interface_enable_playerhud();

	if ( IsDefined( self.maars_huds ) )
	{
		foreach ( hud in self.maars_huds )
		{
			if (IsDefined(hud) )
			{
				if ( IsArray( hud ) )
				{
					foreach ( elem in hud )
					{
						maars_destroy_hud( elem );
					}
		
					hud = undefined;
				}
				else
				{
					maars_destroy_hud( hud );
				}
			}
		}
	}

	self maars_interface_enable_weapons();
	maars_setup_damage_overlays_restore();
	
	// turn off any distortion
	level.player DigitalDistortSetParams( 0, 1 );
}

fade_hud( fade_time, fade_alpha )
{
	if ( IsDefined( self.maars_huds ) )
	{
		foreach ( hud in self.maars_huds )
		{
			if (IsDefined(hud) )
			{
				if ( IsArray( hud ) )
				{
					foreach ( elem in hud )
					{
						elem fadeOverTime( fade_time );
						elem.alpha = fade_alpha;
					}
		
					hud = undefined;
				}
				else
				{
					hud fadeOverTime( fade_time );
					hud.alpha = fade_alpha;
				}
			}
		}
	}
}

maars_destroy_hud( hud )
{
	if(!IsDefined(hud))
		return;
		
	if ( IsDefined( hud.data_value ) )
	{
		hud.data_value Destroy();
	}

	if ( IsDefined( hud.data_value_suffix ) )
	{
		hud.data_value_suffix Destroy();
	}

	hud Destroy();
}

maars_interface_enable_weapons()
{
	//self EnableWeapons();
	self EnableOffhandWeapons();
	self FreezeControls( false );
}

maars_interface_thermal_on()
{
	self maps\_load::thermal_EffectsOn();
	self ThermalVisionOn();
	self VisionSetThermalForPlayer( "berlin_a10", 0.25 );
}

maars_interface_thermal_off()
{
	self maps\_load::thermal_EffectsOff();
	self ThermalVisionOff();
}

maars_setup_thermal()
{
	//level.player NotifyOnPlayerCommand( "toggle_thermal_vision", "weapnext" );

	thread monitor_change_thermal();
	
	level waittill( "maars_view_disabled" );
	
	// clean up
	if ( flag( "maars_thermal_on" ) )
	{
		flag_clear( "maars_thermal_on" );
		maars_interface_thermal_off();
	}
}

monitor_change_thermal()
{
	level endon( "maars_view_disabled" );
	
	notify_string = notify_on_action( "toggle_view" );
	thread thermal_view_hint( notify_string );
	
	while ( true )
	{
		level.player waittill( notify_string );
		
		if ( flag( "maars_thermal_on" ) )
		{
			flag_clear( "maars_thermal_on" );
			thread maars_interface_thermal_off();
		}
		else
		{
			flag_set( "maars_thermal_on" );
			thread maars_interface_thermal_on();
		}

		wait 0.1;
	}
}

thermal_view_hint( notify_string )
{
	level.player endon( notify_string );
	flag_wait( "maars_control_smoke_hint" );
	wait 0.5;
	thread hint_for_action( "toggle_view", 10, true, notify_string );
}

fire_grenade_hint()
{
	timeout = 10;
	
	// action names are different for xb and pc/ps3
	action_name = undefined;
	if ( level.Xenon )
		action_name = "ugv_grenade";
	else
		action_name = "ugv_grenade";
	
	// end this if you already did the action without the tutorial
	notify_string = notify_on_action( action_name );
	level.player endon( notify_string );
	//thread fire_grenade_hint_done( notify_string );

	//flag_wait( "maars_control_spawn1_retreat" );

	wait .5;
	
	// hint if you haven't pressed the correct button yet
	thread hint_for_action( action_name, timeout, true, notify_string );
	
	wait timeout;
	level.player notify( notify_string );
}

fire_grenade_hint_done( notify_string )
{
	level.player waittill( notify_string );
}

zoom_hint()
{
	timeout = 10;

	// action names are different for xb and pc/ps3
	action_name = undefined;
	if ( level.Xenon )
		action_name = "ugv_zoom_360";
	else
		action_name = "ugv_zoom";
	
	// end this if you already did the action without the tutorial
	notify_string = notify_on_action( action_name );
	level.player endon( notify_string );
	//thread fire_grenade_hint_done( notify_string );

	flag_wait( "maars_control_player_controlling_maars" );

	wait .5;
	
	// hint if you haven't pressed the correct button yet
	thread hint_for_action( action_name, timeout, true, notify_string );
	
	wait timeout;
	level.player notify( notify_string );
}

maars_target_tracking( ent, diff_override, forward_offset )
{
	self endon( "death" );
	self notify( "stop_maars_target_tracking" );
	self endon( "stop_maars_target_tracking" );

	diff = 0.94;
	time = 0.1;

	if ( IsDefined( diff_override ) )
	{
		diff = diff_override;
	}

//	self.target_ent thread draw_tracking( ent );

	while ( 1 )
	{
		dest = ent.origin + ( 0, 0, 60 );

		if ( IsDefined( forward_offset ) )
		{
			forward = AnglesToForward( ent.angles );
			dest = ent.origin + ( forward * forward_offset );
		}

		origin = ( self.target_ent.origin * diff ) + ( dest * ( 1.0 - diff ) );

		self.target_ent MoveTo( origin, time );
		wait( time );
	}
}

draw_tracking( ent )
{
/#
	self endon( "death" );
	self endon( "stop_maars_target_tracking" );

	while ( 1 )
	{
		Line( ent.origin, self.origin );
		wait( 0.05 );
	}
#/
}

maars_add_target( target_box_model )
{
	if ( !IsDefined( level.maars_targets ) )
	{
		level.maars_targets = [];
	}
	
	level.maars_targets[ self.unique_id ] = self;
	
	if ( IsDefined( target_box_model ) )
	{
		target_box = Spawn( "script_model", (0,0,0) );
		target_box SetModel( target_box_model );
		target_box NotSolid();
		target_box Hide();
		target_box LinkTo( self, "tag_origin", (0,0,0), (0,0,0) );
		level.maars_targets[ self.unique_id ].target_box_model = target_box;
	}

	self thread maars_remove_target_ondeath();
}

maars_clear_targets()
{
	level notify( "stop_draw_maars_targets" );

	foreach ( target in level.maars_targets )
	{
		if ( !IsDefined( target ) )
		{
			continue;
		}

		target maars_remove_target();
	}

	level.maars_targets = undefined;
}

maars_remove_target_ondeath()
{
	id = self.unique_id;
	self waittill( "death" );
	
	self maars_remove_target( id );
	if ( IsDefined( self.target_box_model ) )
	{
		self.target_box_model Delete();
	}
}

maars_remove_target( id )
{
	if ( IsDefined( self ) && IsDefined( self.has_target_shader ) )
	{
		self.has_target_shader = undefined;
		if ( IsDefined( self.target_box_model ) )
		{
			Target_Remove( self.target_box_model );
		}
		else
		{
			Target_Remove( self );
		}
	}

	if ( IsDefined( level.maars_targets ) )
	{
		if ( !IsDefined( id ) )
			id = self.unique_id;
		
		level.maars_targets[ id ] = undefined;
	}
}

maars_draw_targets()
{
	level endon( "stop_draw_maars_targets" );

	if ( !IsDefined( level.maars_targets ) )
	{
		level.maars_targets = [];
	}

	targets_per_frame = 4;
	targets_drawn = 0;
	delay = 0.05;

	while ( 1 )
	{
		foreach ( target in level.maars_targets )
		{
			if ( !IsDefined( target ) )
			{
				continue;
			}

			target draw_target( level.player );
			targets_drawn++;
			if ( targets_drawn >= targets_per_frame )
			{
				targets_drawn = 0;
				wait( delay );
			}
		}

		wait( 0.05 );
	}
}

draw_target( player )
{
	if ( IsDefined( self.has_target_shader ) && self.has_target_shader )
	{
		return;
	}
	
	self.has_target_shader = true;
	
	target_ent = self;
	if ( IsDefined( self.target_box_model ) )
	{
		target_ent = self.target_box_model;
	}
			
	Target_Set( target_ent, ( 0, 0, 0 ) );
	
	if ( IsAI( self ) )
	{
		if ( self.team == "axis" )
		{
			Target_SetScaledRenderMode( target_ent, true );
			Target_SetShader( target_ent, "hud_fofbox_hostile" );
		}
		else
		{
			Target_SetScaledRenderMode( target_ent, true );
			Target_SetShader( target_ent, "veh_hud_friendly" );
		}
	}
	else if ( IsPlayer( self ) ) // Make sure you add the player to the level.remote_missile_targets before use
	{
		Target_SetShader( target_ent, "hud_fofbox_self_sp" );
	}
	else if ( self.code_classname == "script_vehicle" )
	{
		Target_SetScaledRenderMode( target_ent, true );
		//Target_DrawCornersOnly( self, true );
		if( self.script_team == "axis" )
		{
			//Target_SetShader( self, "uav_vehicle_target" );
			Target_SetShader( target_ent, "veh_hud_target" );
		}
		else
		{
			Target_SetShader( target_ent, "veh_hud_friendly" );
		}
	}
	else
	{
		//Target_SetShader( self, "veh_hud_target" );
		Target_SetScaledRenderMode( target_ent, true );
		Target_SetShader( target_ent, "veh_hud_friendly" );
	}
		
	Target_ShowToPlayer( target_ent, player );
}

maars_hide_targets()
{
	level notify( "stop_draw_maars_targets" );
	
	foreach ( target in level.maars_targets )
	{
		if ( !IsDefined( target ) )
		{
			continue;
		}

		target maars_hide_target( );
	}
}

maars_hide_target()
{
	if ( IsDefined( self.has_target_shader ) )
	{
		self.has_target_shader = undefined;
		if ( IsDefined( self.target_box_model ) )
		{
			Target_Remove( self.target_box_model );
		}
		else
		{
			Target_Remove( self );
		}
	}
}

maars_incoming_missile()
{
	if( level.incoming_missile == false && IsDefined( level.player.maars_huds[ "incoming_missile" ] ) )
	{
		level.incoming_missile = true;
		level.player thread play_loop_sound_on_entity( "heli_missile_warning" );
		thread maars_incoming_missile_hud_flash();
		wait 2;
		level.player thread stop_loop_sound_on_entity( "heli_missile_warning" );
		level.incoming_missile = false;
	}
}

maars_incoming_missile_hud_flash()
{
	level endon( "dismount_maars" );
	
	for( i=0; i < 3; i++ )
	{
		level.player.maars_huds[ "incoming_missile" ] fadeovertime( .25 );
		level.player.maars_huds[ "incoming_missile" ].alpha = 1;
		wait .25;
		level.player.maars_huds[ "incoming_missile" ] fadeovertime( .25 );
		level.player.maars_huds[ "incoming_missile" ].alpha = 0;
		wait .25;
	}
}


controls_hint( string_fn, y_offset, timeout )
{
	Assert( IsPlayer( self ) );

	if ( !isalive( self ) )
		return;
	
	self endon( "death" );

	MYFADEINTIME = 1.0;
	MYFLASHTIME = 0.75;
	MYALPHAHIGH = 0.95;
	MYALPHALOW = 0.4;

	Hint = createClientFontString( "default", 2 );
	
	thread maps\_utility_code::destroy_hint_on_friendlyfire( hint );
	thread destroy_hint_on_mission_fail( hint );
	level endon( "friendlyfire_mission_fail" );
	
	//Hint.color = ( 1, 1, .5 ); //remove color so that color highlighting on PC can show up.
	Hint.alpha = 0.9;
	Hint.x = 0;
	Hint.y = -88 + y_offset;
	Hint.alignx = "center";
	Hint.aligny = "middle";
	Hint.horzAlign = "center";
	Hint.vertAlign = "middle";
	Hint.foreground = false;
	Hint.hidewhendead = true;
	Hint.hidewheninmenu = true;

	Hint thread set_control_hint_string( string_fn );

	Hint.alpha = 0;
	Hint FadeOverTime( MYFADEINTIME );
	Hint.alpha = MYALPHAHIGH;
	wait( MYFADEINTIME );
	
	for ( i = 0; i < 1; i++ )
	{
		Hint FadeOverTime( MYFLASHTIME );
		Hint.alpha = MYALPHALOW;
		wait( MYFLASHTIME );

		Hint FadeOverTime( MYFLASHTIME );
		Hint.alpha = MYALPHAHIGH;
		wait( MYFLASHTIME );
	}
	
	wait timeout;
	
	hint notify( "destroying" );
	Hint Destroy();
}

set_control_hint_string( string_fn )
{
	self endon( "death" );
	self endon( "destroying" );
	
	while ( true )
	{
		hint_string = [[ string_fn ]]();
		self SetText( hint_string );
		wait 0.05;
	}
}

destroy_hint_on_mission_fail( hint )
{

	hint endon( "destroying" );
	
	level waittill( "missionfailed" );
	if ( !isdefined( hint ) )
		return;
	
	hint Destroy();
}

hint_timeout( timeout )
{
	wait( timeout );
	self.timed_out = true;
}

maars_friendly_fire_check( entity, damage, attacker, direction, point, method, weaponName )
{
	custom_death_quote = undefined;
	if ( ( IsDefined( attacker.code_classname ) ) && ( attacker.code_classname == "script_vehicle" ) )
	{
		owner = attacker GetVehicleOwner();
		if ( ( IsDefined( owner ) ) && ( IsPlayer( owner ) ) )
		{
			if ( method == "MOD_CRUSH" )
			{
				custom_death_quote = &"INTRO_UGV_KILLTEAM_DEATH_QUOTE";
				level thread maars_friendly_fire_fail( custom_death_quote );
				return;
			}
		}
	}
	
	if ( ( IsDefined( level.failOnFriendlyFire ) ) && ( level.failOnFriendlyFire ) )
	{
		level thread maars_friendly_fire_fail( custom_death_quote );
		return;
	}

	if ( level.friendlyFireDisabledForDestructible == 1 )
		return;

	if ( level.friendlyFireDisabled == 1 )
		return;

	if ( level.player.participation <= ( level.friendlyfire[ "min_participation" ] ) )
		level thread maars_friendly_fire_fail( custom_death_quote );
}

maars_friendly_fire_fail( custom_death_quote )
{
	if ( GetDvar( "friendlyfire_dev_disabled" ) == "1" )
		return;

	level.player endon( "death" );
	level endon( "mine death" );
	level notify( "mission failed" );
	level notify( "friendlyfire_mission_fail" );

	waittillframeend;
	
	if ( IsDefined( level.MissionFailed ) && level.MissionFailed )
		return;

	SetSavedDvar( "hud_missionFailed", 1 );

	if ( IsDefined( level.player.failingMission ) )
		return;

	if ( IsDefined( custom_death_quote ) )
	{
		SetDvar( "ui_deadquote", custom_death_quote );	// Friendly fire will not be tolerated!
	}
	else
	{
		// Friendly fire will not be tolerated!
		SetDvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN" );	// Friendly fire will not be tolerated!
	}

	//logString( "failed mission: Friendly fire" );

//{NOT_IN_SHIP
    ReconSpatialEvent( level.player.origin, "script_friendlyfire: civilian %d", false );
//}NOT_IN_SHIP
	maps\_utility::missionFailedWrapper();
}
