/*	SOUNDS
helicopter_world_edge_warning
helicopter_world_edge_failure

alarm_cobra_altitude,,cobra/alarm_altitude.wav,0.99,0.99,na,,,360,6000,local,,,,,cobrapilot pilotcobra
alarm_cobra_caution,,cobra/alarm_caution.wav,0.99,0.99,na,,,360,6000,local,,,,,cobrapilot pilotcobra
alarm_cobra_pullup,,cobra/alarm_pullup.wav,0.99,0.99,na,,,360,6000,local,,,,,cobrapilot pilotcobra
alarm_cobra_warning,,cobra/alarm_warning.wav,0.99,0.99,na,,,360,6000,local,,,,,cobrapilot pilotcobra

weap_rearming,,cobra/weap_rearming.wav,0.99,0.99,wpnplyr,,,360,6000,auto,,,,,cobrapilot pilotcobra

*/

#include maps\_utility;
#include maps\_helicopter_globals;
#include common_scripts\utility;
#using_animtree( "vehicles" );
init()
{
	/******************************************************/
	/*						DVARS						  */
	/******************************************************/

	// dvar to give player's cobra unlimited ammo
	// 0 - regular
	// 1 - unlimited
	setDvarIfUninitialized( "cobrapilot_unlimited_ammo", "0" );

	// dvar to toggle the mode at which ammo reloading points operate
	// 0 - player manually hovers above the point and ammo and health is regened
	// 1 - players controls are taken away and sequence is started
	setDvarIfUninitialized( "cobrapilot_farp_mode", "0" );

	// dvar to set how the edge of the world acts
	// 0 - nothing happens, player can fly out of bounds without penalty
	// 1 - control is taken away and helicopter is automatically flown in bounds
	// 2 - warning message pops up and player must fly in bounds within the time limit
	setDvarIfUninitialized( "cobrapilot_edge_of_world_type", "2" );

	// turn on/off the gunner in your chopper
	// 0 - off
	// 1 - on
	setDvarIfUninitialized( "cobrapilot_gunner_enabled", "0" );

	// turn on/off the wingman
	// 0 - off
	// 1 - on
	setDvarIfUninitialized( "cobrapilot_wingman_enabled", "0" );

	// difficulty dvar
	// easy, medium, hard, insane
	setdvar( "cobrapilot_difficulty", "easy" );

	// dvar to turn on debug info ( prints, lines, etc )
	setDvarIfUninitialized( "cobrapilot_debug", "0" );


	// turn on/off cockpit sounds
	// 0 - off
	// 1 - on
	setDvarIfUninitialized( "cobrapilot_sounds_enabled", "0" );

	/******************************************************/
	/******************************************************/
	/******************************************************/







	/******************************************************/
	/*					SETUP WEAPON TAGS				  */
	/******************************************************/
	
	/* Old cobra settings
	level.cobra_weapon_tags = [];
	level.cobra_weapon_tags[ "cobra_20mm" ][ 0 ] 		 = "tag_flash";
	level.cobra_weapon_tags[ "cobra_FFAR" ][ 0 ] 		 = "tag_store_r_2";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 0 ]	 = "tag_store_l_1_a";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 1 ]	 = "tag_store_l_1_b";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 2 ]	 = "tag_store_l_1_c";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 3 ]	 = "tag_store_l_1_d";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 4 ]	 = "tag_store_r_1_a";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 5 ]	 = "tag_store_r_1_b";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 6 ]	 = "tag_store_r_1_c";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 7 ]	 = "tag_store_r_1_d";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 8 ]	 = "tag_store_l_2_a";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 9 ]	 = "tag_store_l_2_b";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 10 ]	 = "tag_store_l_2_c";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 11 ] 	 = "tag_store_l_2_d";
	level.cobra_weapon_tags[ "cobra_Sidewinder" ][ 0 ] 	 = "tag_store_l_wing";
	level.cobra_weapon_tags[ "cobra_Sidewinder" ][ 1 ] 	 = "tag_store_r_wing";
	*/
	
	// Little Bird Config
	level.cobra_weapon_tags = [];
	level.cobra_weapon_tags[ "cobra_20mm" ][ 0 ] 		 = "tag_minigun_attach_left";
	level.cobra_weapon_tags[ "cobra_20mm" ][ 1 ] 		 = "tag_minigun_attach_right";
	level.cobra_weapon_tags[ "cobra_FFAR" ][ 0 ] 		 = "tag_missile_left";
	level.cobra_weapon_tags[ "cobra_FFAR" ][ 1 ] 		 = "tag_missile_right";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 0 ]	 = "tag_missile_left";
	level.cobra_weapon_tags[ "cobra_Hellfire" ][ 1 ]	 = "tag_missile_right";
	level.cobra_weapon_tags[ "cobra_Sidewinder" ][ 0 ] 	 = "tag_missile_left";
	level.cobra_weapon_tags[ "cobra_Sidewinder" ][ 1 ] 	 = "tag_missile_right";
	//--------------
	
	level.cobra_missile_models = [];
	level.cobra_missile_models[ "cobra_Hellfire" ] = "projectile_hellfire_missile";
	level.cobra_missile_models[ "cobra_Sidewinder" ] = "projectile_sidewinder_missile";

	/******************************************************/
	/******************************************************/
	/******************************************************/





	/******************************************************/
	/*					SETUP WEAPONS					  */
	/******************************************************/

	// 20mm Chain Gun
	weapon = weaponsSystems_Create_Weapon();
	weapon.v[ "weapon" ]								 = "cobra_20mm";
	// M197 20mm Cannon
	weapon.v[ "realWeaponName" ]						 = &"COBRAPILOT_20MM";
	weapon.v[ "weaponNameLocationX" ]					 = 573;
	weapon.v[ "weaponNameLocationY" ]		 			 = 149;
	weapon.v[ "equipButton" ]							 = "BUTTON_A";
	weapon.v[ "equipShader" ]							 = "cobra_controls_a";
	weapon.v[ "singleShot" ]						 	 = false;
	weapon.v[ "targetType" ]						 	 = "dummy";
	weapon.v[ "requireLock" ]						 	 = false;
	weapon.v[ "maxAmmo" ]								 = 750;
	weapon.v[ "ammoPickupIncrement" ]					 = 50;
	weapon.v[ "tags" ]									 = level.cobra_weapon_tags[ "cobra_20mm" ];
	weaponsSystems_Add_Weapon( weapon );

	// Unguided Rockets
	weapon = weaponsSystems_Create_Weapon();
	weapon.v[ "weapon" ]								 = "cobra_FFAR";
	// LAU-61C/A Unguided Rockets
	weapon.v[ "realWeaponName" ]						 = &"COBRAPILOT_FFAR";
	weapon.v[ "weaponNameLocationX" ]		 		     = 573;
	weapon.v[ "weaponNameLocationY" ]		 			 = 167;
	weapon.v[ "equipButton" ]						  	 = "BUTTON_B";
	weapon.v[ "equipShader" ]						 	 = "cobra_controls_b";
	weapon.v[ "singleShot" ]						 	 = false;
	weapon.v[ "targetType" ]							 = "dummy";
	weapon.v[ "requireLock" ]							 = false;
	weapon.v[ "maxAmmo" ]								 = 38;
	weapon.v[ "ammoPickupIncrement" ]					 = 4;
	weapon.v[ "tags" ]									 = level.cobra_weapon_tags[ "cobra_FFAR" ];
	weaponsSystems_Add_Weapon( weapon );

	// Hellfire
	weapon = weaponsSystems_Create_Weapon();
	weapon.v[ "weapon" ]								 = "cobra_Hellfire";
	// AGM-114 Hellfire Anti-Tank
	weapon.v[ "realWeaponName" ]				 		 = &"COBRAPILOT_HELLFIRE";
	weapon.v[ "weaponNameLocationX" ]		 			 = 573;
	weapon.v[ "weaponNameLocationY" ]		 			 = 185;
	weapon.v[ "equipButton" ]						 	 = "BUTTON_X";
	weapon.v[ "equipShader" ]						 	 = "cobra_controls_x";
	weapon.v[ "hudShader" ]								 = "veh_hud_hellfire";
	weapon.v[ "hudShader_size_x" ]			 			 = 200;
	weapon.v[ "hudShader_size_y" ]			 			 = 200;
	weapon.v[ "singleShot" ]						 	 = true;
	weapon.v[ "targetType" ]						 	 = "ground";
	weapon.v[ "requireLock" ]						 	 = true;
	weapon.v[ "lockonTime" ]						 	 = 1500;
	weapon.v[ "maxAmmo" ]								 = 8;
	weapon.v[ "ammoPickupIncrement" ]		 			 = 1;
	weapon.v[ "tags" ]									 = level.cobra_weapon_tags[ "cobra_Hellfire" ];
	weaponsSystems_Add_Weapon( weapon );

	// Sidewinder
	weapon = weaponsSystems_Create_Weapon();
	weapon.v[ "weapon" ]								 = "cobra_Sidewinder";
	// AIM-9 Sidewinder Air-to-Air
	weapon.v[ "realWeaponName" ]				 		 = &"COBRAPILOT_SIDEWINDER";
	weapon.v[ "sound_armed_loop" ]			 			 = "weap_aim9_growl4";
	weapon.v[ "weaponNameLocationX" ]		 			 = 573;
	weapon.v[ "weaponNameLocationY" ]		 			 = 203;
	weapon.v[ "equipButton" ]						 	 = "BUTTON_Y";
	weapon.v[ "equipShader" ]						 	 = "cobra_controls_y";
	weapon.v[ "hudShader" ]							 	 = "veh_hud_sidewinder";
	weapon.v[ "hudShader_size_x" ]			 			 = 200;
	weapon.v[ "hudShader_size_y" ]			 			 = 200;
	weapon.v[ "singleShot" ]						 	 = true;
	weapon.v[ "targetType" ]						 	 = "air";
	weapon.v[ "requireLock" ]						 	 = true;
	weapon.v[ "lockonTime" ]						 	 = 3000;
	weapon.v[ "maxAmmo" ]								 = 2;
	weapon.v[ "ammoPickupIncrement" ]		 			 = 1;
	weapon.v[ "ammoPickupDelay_Min" ]		 			 = 1.0;
	weapon.v[ "ammoPickupDelay_Max" ]		 			 = 2.0;
	weapon.v[ "tags" ]									 = level.cobra_weapon_tags[ "cobra_Sidewinder" ];
	weaponsSystems_Add_Weapon( weapon );

	/******************************************************/
	/******************************************************/
	/******************************************************/

	// Warning you are leaving the mission area! Turn back!
	precacheString( &"COBRAPILOT_EDGE_OF_WORLD_WARNING" );
	// You left the mission area! Mission Failed!
	precacheString( &"COBRAPILOT_EDGE_OF_WORLD_FAIL" );
	// No Ammo
	precacheString( &"COBRAPILOT_NO_AMMO" );
	// Requires Lock-On
	precacheString( &"COBRAPILOT_NO_LOCK" );
	// Objective indicator marks the ammo reload helipad
	precacheString( &"COBRAPILOT_OBJECTIVE_AMMO_RELOAD_POINT" );

	level.vehicleSpawnCallbackThread = ::vehicle_Spawn_Callback_Thread;

	level.cobraHealth = [];
	level.cobraHealth[ "easy" ] = 9000;
	level.cobraHealth[ "medium" ] = 7000;
	level.cobraHealth[ "hard" ] = 3000;
	level.cobraHealth[ "insane" ] = 1500;

	level.flareButton1 = "BUTTON_LSHLDR";
	level.flareButton2 = "BUTTON_RSHLDR";

	level.stats = [];
	level.stats[ "enemies_killed" ] = 0;
	level.stats[ "damage_taken" ] = 0;
	level.stats[ "cobra_20mm" ] = 0;
	level.stats[ "cobra_FFAR" ] = 0;
	level.stats[ "cobra_Hellfire" ] = 0;
	level.stats[ "cobra_Sidewinder" ] = 0;
	level.stats[ "flares_used" ] = 0;

	level.cosine = [];
	level.cosine[ "45" ] = cos( 45 );
	level.cosine[ "55" ] = cos( 55 );

	level.GunnerTargetRange = 16000;
	level.GunnerTargetFOV = level.cosine[ "55" ];
	level.GunnerWeapon = "cobra_20mm_copilot";
	level.GunnerWeaponPlayerEquiv = "cobra_20mm";
	precacheItem( level.GunnerWeapon );

	level.flare_fx = [];
	level.flare_fx[ "cobra" ] 				 = loadfx( "misc/flares_cobra" );
	level.flare_fx[ "cobra_player" ] 	 = loadfx( "misc/flares_cobra" );
	level.flare_fx[ "hind" ] 					 = loadfx( "misc/flares_cobra" );

	level.player_death_fx = loadfx( "explosions/cobrapilot_vehicle_explosion" );

	level.initialFOV = 65;
	level.weaponZoomFOV = 35;

	precacheShader( "compass_waypoint_farp" );
	precacheShader( "cobra_health" );

	// precache gunner character
	precacheModel( "body_complete_sp_cobra_pilot_desert_zack" );

	// precache materials used for missile hint indicators
	level.missileHintIndicator_Missile = "veh_hud_missile";
	level.missileHintIndicator_Missile_Flash = "veh_hud_missile_flash";
	level.missileHintIndicator_Missile_Offscreen = "veh_hud_missile_offscreen";
	level.missileHintIndicator_Arrow = [];
	level.missileHintIndicator_Arrow[ "left" ] = "veh_hud_missile_arrow_left";
	level.missileHintIndicator_Arrow[ "right" ] = "veh_hud_missile_arrow_right";
	level.missileHintIndicator_Arrow[ "forward" ] = "veh_hud_missile_arrow_forward";
	level.missileHintIndicator_Arrow[ "back" ] = "veh_hud_missile_arrow_back";
	precacheShader( level.missileHintIndicator_Missile );
	precacheShader( level.missileHintIndicator_Missile_Flash );
	precacheShader( level.missileHintIndicator_Missile_Offscreen );
	precacheShader( level.missileHintIndicator_Arrow[ "left" ] );
	precacheShader( level.missileHintIndicator_Arrow[ "right" ] );
	precacheShader( level.missileHintIndicator_Arrow[ "forward" ] );
	precacheShader( level.missileHintIndicator_Arrow[ "back" ] );

	level.cobrapilot_difficulty = getdvar( "cobrapilot_difficulty" );
	assert( isdefined( level.cobraHealth[ level.cobrapilot_difficulty ] ) );
	level.flyablecobra_starting_health = level.cobraHealth[ level.cobrapilot_difficulty ];
	level.flyablecobra_healthWarning_value = 1000;
	level.flyablecobra_healthRegenIncrement = int( level.flyablecobra_starting_health / 6 );
	level.flyablecobra_healthRegenRate = 1.0;
	level.flyablecobra_healthLeakIncrement = 30;
	level.flyablecobra_healthLeakRate = 1.0;

	/*
	if ( getdvar( "cobrapilot_edge_of_world_type") == "1" )
		array_thread( getentarray( "border_outer", "targetname" ), ::borderwall_method1 );
	else if ( getdvar( "cobrapilot_edge_of_world_type") == "2" )
		thread edge_Of_World();
	*/

	//thread ammo_Reload_Station();
	//thread incommingMissile_Think();

	/*
	if ( getdvar( "cobrapilot_gunner_enabled") == "1" )
		chopper thread gunner_spawn();
	*/

	array_thread( getentarray( "cobra", "targetname" ), ::setup_player_usable_vehicle );
	array_thread( getentarray( "flyable_heli", "targetname" ), ::setup_player_usable_vehicle );
}

setup_player_usable_vehicle()
{
	assert( isdefined( self ) );
	assert( isdefined( self.target ) );
	self.trigger = getent( self.target, "targetname" );
	assert( isdefined( self.trigger ) );

	self.script_targetoffset_z = -100;

	self makeUnusable();

	self thread wait_player_enter();

	self notify( "stop_kicking_up_dust" );
}

wait_player_enter()
{
	for ( ;; )
	{
		self.trigger waittill( "trigger", pilot );
		if ( pilot.classname == "player" )
			break;
		wait 0.05;
	}

	level thread player_enter_chopper( self, pilot );
}

player_enter_chopper( chopper, pilot )
{
	chopper useby( pilot );
	chopper setjitterparams( ( 3, 3, 3 ), 0.5, 1.5 );
	chopper.hudelems = spawnstruct();

	pilot.ignoreme = true;

	chopper.pilot = pilot;
	chopper.pilot.currentWeapon = 0;
	chopper.playercontrolled = true;

	thread player_becomes_pilot_model( chopper );
	chopper thread startRotors();
	chopper thread maps\_vehicle::aircraft_dust_kickup();

	chopper.gunner_use_turret = false;
	if ( level.cobraWeapon[ chopper.pilot.currentWeapon ].v[ "weapon" ] != level.GunnerWeaponPlayerEquiv )
		chopper.gunner_use_turret = true;

	if ( ( isdefined( level.cobraWeapon ) ) && ( level.cobraWeapon.size > 0 ) )
		chopper setVehWeapon( level.cobraWeapon[ chopper.pilot.currentWeapon ].v[ "weapon" ] );

	chopper notify( "nodeath_thread" );
	chopper notify( "no_regen_health" );
	chopper notify( "stop_turret_shoot" );
	chopper notify( "stop_friendlyfire_shield" );
	chopper notify( "stop_vehicle_wait" );

	chopper thread globalThink();
	chopper thread weaponsSystems();

	chopper.pilot freezeControls( true );
	chopper waittill( "takeoff" );
	chopper thread setChopperHealth();
	chopper setGoalYaw( chopper.angles[ 1 ] );
	chopper setVehGoalPos( chopper.origin + ( 0, 0, 40 ), 1 );
	chopper waittill( "goal" );
	chopper returnPlayerControl();
	chopper.pilot freezeControls( false );
}

player_becomes_pilot_model( chopper )
{
	if ( chopper.vehicletype != "cobra_player" )
		return;

	assert( isdefined( chopper.pilot ) );
	chopper.pilot hide();

	chopper.pilotModel = spawn( "script_model", chopper getTagOrigin( "tag_pilot" ) );
	chopper.pilotModel.angles = chopper getTagAngles( "tag_pilot" );
	chopper.pilotModel setmodel( "body_complete_sp_cobra_pilot_desert_zack" );
	chopper.pilotModel linkto( chopper, "tag_pilot", ( 0, 0, -40 ), ( 0, 0, 0 ) );
	chopper.pilotModel useAnimTree( #animtree );

	while ( isdefined( chopper ) )
	{
		chopper.pilotModel setFlaggedAnim( "pilot_idle_anim", %cobra_copilot_idle );
		chopper.pilotModel waittillmatch( "pilot_idle_anim", "end" );
	}
}

startRotors()
{
	self useAnimTree( #animtree );

	startUp = true;
	rate = 0.2;
	rate_inc = 0.2;
	rate_time = 0.2;

	while ( isdefined( self ) )
	{
		self setFlaggedAnim( "rotor_anim", %bh_rotors, 1.0, 0.1, rate );
		if ( startUp )
		{
			wait rate_time;
			rate += rate_inc;
			if ( rate >= 4.0 )
			{
				rate = 1.0;
				startUp = false;
				self notify( "takeoff" );
				if ( self.vehicletype == "cobra_player" )
					self setModel( "vehicle_cobra_helicopter_fly" );
			}
		}
		else
			self waittillmatch( "rotor_anim", "end" );
	}
}

setChopperHealth()
{
	assert( isdefined( self.pilot ) );

	self.health = level.flyablecobra_starting_health;
	self.currenthealth = level.flyablecobra_starting_health;
	self.maxhealth = level.flyablecobra_starting_health;

	self health_indicator_create();
	self thread health_indicator_damageWait();
	self thread health_think();
}

vehicle_Spawn_Callback_Thread( vehicle )
{
	vehicle thread globalThink();

	if ( !isdefined( vehicle.script_cobratarget ) )
		return;

	if ( vehicle.script_cobratarget != 1 )
		return;

	assert( isdefined( vehicle.script_targettype ) );
	if ( !isdefined( vehicle.script_targetoffset_z ) )
		vehicle.script_targetoffset_z = 0;
	offset = ( 0, 0, vehicle.script_targetoffset_z );
	
	cobraTarget_Add( level.player, vehicle, vehicle.script_targettype, offset );
}

weaponsSystems_Create_Weapon()
{
	ent = spawnStruct();
	ent.v = [];

	/*
	weapon:
		name of weapon defined in asset manager
	realWeaponName:
		real name of weapon used for hud/info, should be a localized string name
	sound_armed:
		sound to play when this weapon becomes equipped
	sound_armed_loop (optional):
		sound to loop while this weapon is armed
	weaponNameLocationX / weaponNameLocationY:
		x and y coordinate for realWeaponName text on the HUD
	equipButton:
		button pressed to equip this weapon
	equipShader:
		shader to use when this weapon is equipped
	hudShader (optional):
		shader to use for the HUD when this vehicle is equiped
	hudShader_size_x  (optional) / hudShader_size_y (optional):
		size of the hudShader
	singleShot:
		if true, player must release the fire button before firing another shot
		if false, holding the fire button fires multiple shots sequentially
	targetType:
		dummy - no targeting, just straight projectiles
		ground - targets ground targets only
		air - targets air targets only
	lockonTime (optional):
		number of milliseconds required for lockon to engage
	shader_target:
		shader targets use that are valid, but not locked
	shader_target_offscreen:
		shader valid targets use when they are offscreen
	shader_lock:
		shader targets use when they are fully locked on
	shader_locking:
		when a target is being locked (but isn't fully locked yet) it flashes this shader until full lock is reached
	shader_invalid:
		shader targets use that the current weapon system can't target
	shader_invalid_offscreen:
		shader invalid targets use when they are offscreen
	maxAmmo:
		maxinum number of rounds the helicopter can hold
	ammoPickupIncrement:
		number of rounds picked up each time the helicopter picks up ammo
	ammoPickupDelay_Min / ammoPickupDelay_Max:
		min and max random wait time between weapon pickups
	tags:
		array of tags on the helicopter where projectiles originate from
	*/

	// set some defaults
	ent.v[ "weapon" ]								 = undefined;
	ent.v[ "realWeaponName" ]						 = undefined;
	ent.v[ "sound_armed" ]							 = "cobra_weapon_change";
	ent.v[ "sound_armed_loop" ]					 	 = undefined;
	ent.v[ "weaponNameLocationX" ]			 		 = undefined;
	ent.v[ "weaponNameLocationY" ]			 		 = undefined;
	ent.v[ "equipButton" ]							 = undefined;
	ent.v[ "equipShader" ]							 = undefined;
	ent.v[ "hudShader" ]							 = undefined;
	ent.v[ "hudShader_size_x" ]					 	 = undefined;
	ent.v[ "hudShader_size_y" ]					 	 = undefined;
	ent.v[ "singleShot" ]							 = false;
	ent.v[ "targetType" ]							 = undefined;
	ent.v[ "requireLock" ]							 = false;
	ent.v[ "lockonTime" ]							 = undefined;
	ent.v[ "shader_target" ]						 = "veh_hud_target";
	ent.v[ "shader_target_offscreen" ]				 = "veh_hud_target_offscreen";
	ent.v[ "shader_lock" ]							 = "veh_hud_target_lock";
	ent.v[ "shader_locking" ]						 = "veh_hud_target_locking";
	ent.v[ "shader_invalid" ]						 = "veh_hud_target_invalid";
	ent.v[ "shader_invalid_offscreen" ]				 = "veh_hud_target_invalid_offscreen";
	ent.v[ "maxAmmo" ]								 = undefined;
	ent.v[ "ammoPickupIncrement" ]					 = undefined;
	ent.v[ "ammoPickupDelay_Min" ]					 = 0.5;
	ent.v[ "ammoPickupDelay_Max" ]					 = 1.2;
	ent.v[ "tags" ]										 = undefined;

	return ent;
}

weaponsSystems_Add_Weapon( weapon )
{
	if ( !isdefined( level.cobraWeapon ) )
		level.cobraWeapon = [];

	assert( isdefined( level.cobraWeapon ) );
	assert( isdefined( weapon.v[ "weapon" ] ) );
	assert( isdefined( weapon.v[ "realWeaponName" ] ) );
	assert( isdefined( weapon.v[ "sound_armed" ] ) );
	assert( isdefined( weapon.v[ "weaponNameLocationX" ] ) );
	assert( isdefined( weapon.v[ "weaponNameLocationY" ] ) );
	assert( isdefined( weapon.v[ "equipButton" ] ) );
	assert( isdefined( weapon.v[ "equipShader" ] ) );
	assert( isdefined( weapon.v[ "singleShot" ] ) );
	assert( isdefined( weapon.v[ "targetType" ] ) );
	assert( isdefined( weapon.v[ "shader_target" ] ) );
	assert( isdefined( weapon.v[ "shader_target_offscreen" ] ) );
	assert( isdefined( weapon.v[ "shader_lock" ] ) );
	assert( isdefined( weapon.v[ "shader_locking" ] ) );
	assert( isdefined( weapon.v[ "shader_invalid" ] ) );
	assert( isdefined( weapon.v[ "shader_invalid_offscreen" ] ) );
	assert( isdefined( weapon.v[ "maxAmmo" ] ) );
	assert( isdefined( weapon.v[ "ammoPickupIncrement" ] ) );
	assert( isdefined( weapon.v[ "ammoPickupDelay_Min" ] ) );
	assert( isdefined( weapon.v[ "ammoPickupDelay_Max" ] ) );
	assert( isdefined( weapon.v[ "tags" ] ) );
	assert( weapon.v[ "tags" ].size > 0 );

	index = level.cobraWeapon.size;
	level.cobraWeapon[ index ] = weapon;
	level.cobraWeapon[ index ].v[ "currentAmmo" ] = level.cobraWeapon[ index ].v[ "maxAmmo" ];
	level.cobraWeapon[ index ].v[ "nextTag" ] = 0;

	//precache the weapons localized string name
	precacheString( level.cobraWeapon[ index ].v[ "realWeaponName" ] );

	//precache the weapon
	precacheItem( level.cobraWeapon[ index ].v[ "weapon" ] );

	//precache the shaders
	if ( isdefined( level.cobraWeapon[ index ].v[ "hudShader" ] ) )
		precacheShader( level.cobraWeapon[ index ].v[ "hudShader" ] );
	precacheShader( level.cobraWeapon[ index ].v[ "equipShader" ] );
	precacheShader( level.cobraWeapon[ index ].v[ "shader_target" ] );
	precacheShader( level.cobraWeapon[ index ].v[ "shader_target_offscreen" ] );
	precacheShader( level.cobraWeapon[ index ].v[ "shader_lock" ] );
	precacheShader( level.cobraWeapon[ index ].v[ "shader_locking" ] );
	precacheShader( level.cobraWeapon[ index ].v[ "shader_invalid" ] );
	precacheShader( level.cobraWeapon[ index ].v[ "shader_invalid_offscreen" ] );

	// create the HUD weapon name
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ] = newHudElem();
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ].x = level.cobraWeapon[ index ].v[ "weaponNameLocationX" ];
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ].y = level.cobraWeapon[ index ].v[ "weaponNameLocationY" ];
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ].alignX = "left";
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ].alignY = "middle";
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ].horzAlign = "left";
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ].vertAlign = "middle";
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ].foreground = true;
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ].fontscale = 1.0;
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ].color = ( 0, 1, 0 );
	level.cobraWeapon[ index ].v[ "weaponNameHUD" ] setText( level.cobraWeapon[ index ].v[ "realWeaponName" ] );

	// create the HUD ammo counter
	if ( getdvar( "cobrapilot_unlimited_ammo" ) == "0" )
	{
		level.cobraWeapon[ index ].v[ "ammoCounter" ] = newHudElem();
		level.cobraWeapon[ index ].v[ "ammoCounter" ].x = level.cobraWeapon[ index ].v[ "weaponNameLocationX" ] + 160;
		level.cobraWeapon[ index ].v[ "ammoCounter" ].y = level.cobraWeapon[ index ].v[ "weaponNameLocationY" ];
		level.cobraWeapon[ index ].v[ "ammoCounter" ].alignX = "center";
		level.cobraWeapon[ index ].v[ "ammoCounter" ].alignY = "middle";
		level.cobraWeapon[ index ].v[ "ammoCounter" ].horzAlign = "left";
		level.cobraWeapon[ index ].v[ "ammoCounter" ].vertAlign = "middle";
		level.cobraWeapon[ index ].v[ "ammoCounter" ].foreground = true;
		level.cobraWeapon[ index ].v[ "ammoCounter" ].fontscale = 1.0;
		level.cobraWeapon[ index ].v[ "ammoCounter" ].color = ( 0, 1, 0 );
		level.cobraWeapon[ index ].v[ "ammoCounter" ] setValue( level.cobraWeapon[ index ].v[ "currentAmmo" ] );
	}
}

weaponsSystems()
{
	assert( isdefined( self ) );
	assert( isdefined( self.pilot ) );
	assert( self.pilot.classname == "player" );

	if ( !isdefined( level.cobraWeapon ) )
		return;
	if ( level.cobraWeapon.size == 0 )
		return;

	level endon( "cobra_death" );

	self thread weaponsSystems_HUD();
	self thread weaponsSystems_Fire_Missile();
	self thread weaponsSystems_zoom();

	for ( ;; )
	{
		for ( i = 0 ; i < level.cobraWeapon.size ; i++ )
		{
			if ( self.pilot buttonPressed( level.cobraWeapon[ i ].v[ "equipButton" ] ) )
			{
				// stop the equip loop sound of the old weapon if it was playing one
				weaponSystems_EquipLoopSound_Stop();

				// activate the weapon
				if ( self.pilot.currentWeapon == i )
				{
					self.pilot weaponsSystems_buttonRelease_Wait( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "equipButton" ] );
					continue;
				}

				self.pilot.currentWeapon = i;

				if ( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "weapon" ] == level.GunnerWeaponPlayerEquiv )
				{
					self.gunner_use_turret = false;
					self notify( "gunner_stop_firing" );
					self clearTurretTarget();
				}
				else
					self.gunner_use_turret = true;

				self setVehWeapon( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "weapon" ] );

				level notify( "weapon_armed" );

				// stop any lockon sounds that might have started
				if ( ( isdefined( level.cobraTarget ) ) && ( level.cobraTarget.size > 0 ) )
				{
					for ( i = 0 ; i < level.cobraTarget.size ; i++ )
						self thread cobraTarget_holdWait_missileLock_Sound_Stop( level.cobraTarget[ i ] );
				}

				// play weapon equip sound and if the weapon has an armed loop sound play it now
				if ( getdvar( "cobrapilot_sounds_enabled" ) == "1" )
				{
					self.pilot playLocalSound( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "sound_armed" ] );
					self thread weaponSystems_EquipLoopSound_Start();
				}

				cobraTarget_unlockAllTargets();
				cobraTarget_UpdateShaders_All( self.pilot );

				self.pilot weaponsSystems_buttonRelease_Wait( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "equipButton" ] );
			}
		}
		wait 0.05;
	}
}

weaponSystems_EquipLoopSound_Start()
{
	if ( getdvar( "cobrapilot_sounds_enabled" ) != "1" )
		return;

	if ( !isdefined( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "sound_armed_loop" ] ) )
		return;

	if ( isdefined( level.weaponEquipLoopSoundPlaying ) )
		return;

	level.weaponEquipLoopSoundPlaying = true;

	self.pilot thread playLoopSoundForSeeking( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "sound_armed_loop" ] );
}

weaponSystems_EquipLoopSound_Stop()
{
	if ( getdvar( "cobrapilot_sounds_enabled" ) != "1" )
		return;

	level.weaponEquipLoopSoundPlaying = undefined;

	if ( !isdefined( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "sound_armed_loop" ] ) )
		return;
	self.pilot notify( "stop sound" + level.cobraWeapon[ self.pilot.currentWeapon ].v[ "sound_armed_loop" ] );
}

weaponsSystems_buttonRelease_Wait( button )
{
	assert( isdefined( self ) );
	assert( self.classname == "player" );

	level endon( "cobra_death" );

	prof_begin( "cobrapilot_weapons_systems" );
	while ( self buttonPressed( button ) )
		wait 0.05;
	prof_end( "cobrapilot_weapons_systems" );
}

weaponsSystems_HUD()
{
	assert( isdefined( self ) );

	if ( !isdefined( level.cobraWeapon ) )
		return;
	if ( level.cobraWeapon.size == 0 )
		return;

	// weapon selection display
	controller_layout_size_x = 300;
	controller_layout_size_y = 75;
	self.hudelems.controller_layout = newClientHudElem( self.pilot );
	self.hudelems.controller_layout.x = 25;
	self.hudelems.controller_layout.y = 10;
	self.hudelems.controller_layout.alignX = "right";
	self.hudelems.controller_layout.alignY = "bottom";
	self.hudelems.controller_layout.horzAlign = "right";
	self.hudelems.controller_layout.vertAlign = "bottom";
	self.hudelems.controller_layout.foreground = true;

	// weapon HUD
	self.hudelems.weapon_hud = newClientHudElem( self.pilot );
	self.hudelems.weapon_hud.x = 0;
	self.hudelems.weapon_hud.y = 0;
	self.hudelems.weapon_hud.alignX = "center";
	self.hudelems.weapon_hud.alignY = "middle";
	self.hudelems.weapon_hud.horzAlign = "center";
	self.hudelems.weapon_hud.vertAlign = "middle";
	self.hudelems.weapon_hud.foreground = true;
	self.hudelems.weapon_hud.alpha = 0;

	level endon( "cobra_death" );
	for ( ;; )
	{
		prof_begin( "cobrapilot_weapons_systems" );
		assert( isdefined( self.pilot.currentWeapon ) );

		// weapon selection display
		assert( isdefined( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "equipShader" ] ) );
		self.hudelems.controller_layout setshader( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "equipShader" ], controller_layout_size_x, controller_layout_size_y );

		// weapon HUD
		if ( isdefined( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "hudShader" ] ) )
		{
			assert( isdefined( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "hudShader_size_x" ] ) );
			assert( isdefined( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "hudShader_size_y" ] ) );
			self.hudelems.weapon_hud setshader( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "hudShader" ], level.cobraWeapon[ self.pilot.currentWeapon ].v[ "hudShader_size_x" ], level.cobraWeapon[ self.pilot.currentWeapon ].v[ "hudShader_size_y" ] );
			self.hudelems.weapon_hud.alpha = 1;
		}
		else
			self.hudelems.weapon_hud.alpha = 0;

		prof_end( "cobrapilot_weapons_systems" );

		level waittill( "weapon_armed" );
	}
}

weaponsSystems_Fire_Missile()
{
	self endon( "death" );
	level endon( "cobra_death" );

	for ( ;; )
	{
		// code notify that the trigger was pulled
		self waittill( "turret_fire" );

		// make sure the player has ammo
		if ( getdvar( "cobrapilot_unlimited_ammo" ) != "1" )
		{
			if ( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "currentAmmo" ] <= 0 )
			{
				self thread weaponsSystems_noAmmo_Warning();
				continue;
			}
		}

		// get the missile lock target if there is one
		missileTarget = weaponsSystems_Get_Missile_Target();

		// check if the weapon requires lockon, and that the player meets the requirements
		if ( ( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "requireLock" ] == true ) && ( !isdefined( missileTarget ) ) )
		{
			thread weaponsSystems_noLock_Warning();
			continue;
		}

		// fire the weapon from the next tag to be used
		// if there are targets that are locked, fire the missile at those targets
		eMissile = undefined;
		if ( isdefined( missileTarget ) )
		{
			eMissile = self fireWeapon( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "tags" ][ level.cobraWeapon[ self.pilot.currentWeapon ].v[ "nextTag" ] ], missileTarget.targetEntity );
			missileTarget.targetEntity notify( "incomming_missile", eMissile );
			if ( !isdefined( missileTarget.targetEntity.incomming_Missiles ) )
				missileTarget.targetEntity.incomming_Missiles = [];
			missileTarget.targetEntity.incomming_Missiles = array_add( missileTarget.targetEntity.incomming_Missiles, eMissile );
			thread missile_deathWait( eMissile, missileTarget.targetEntity );
		}
		else
			eMissile = self fireWeapon( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "tags" ][ level.cobraWeapon[ self.pilot.currentWeapon ].v[ "nextTag" ] ] );

		assert( isdefined( eMissile ) );

		assert( isdefined( level.stats[ level.cobraWeapon[ self.pilot.currentWeapon ].v[ "weapon" ] ] ) );
		level.stats[ level.cobraWeapon[ self.pilot.currentWeapon ].v[ "weapon" ] ]++ ;

		if ( isdefined( self.hasAttachedWeapons ) )
		{
			if ( ( isdefined( level.cobra_missile_models ) ) && ( isdefined( level.cobra_missile_models[ level.cobraWeapon[ self.pilot.currentWeapon ].v[ "weapon" ] ] ) ) )
			{
				modelname = level.cobra_missile_models[ level.cobraWeapon[ self.pilot.currentWeapon ].v[ "weapon" ] ];
				tagname = level.cobraWeapon[ self.pilot.currentWeapon ].v[ "tags" ][ level.cobraWeapon[ self.pilot.currentWeapon ].v[ "nextTag" ] ];
				self weaponsSystems_Detach_Weapon( modelname, tagname );
			}
		}

		// update what the next tag should be - some weapons only use one tag so it will remain the same
		level.cobraWeapon[ self.pilot.currentWeapon ].v[ "nextTag" ]++ ;
		if ( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "nextTag" ] >= level.cobraWeapon[ self.pilot.currentWeapon ].v[ "tags" ].size )
			level.cobraWeapon[ self.pilot.currentWeapon ].v[ "nextTag" ] = 0;

		// take away ammo and update the ammo counter on the hud
		if ( getdvar( "cobrapilot_unlimited_ammo" ) == "0" )
		{
			level.cobraWeapon[ self.pilot.currentWeapon ].v[ "currentAmmo" ] -- ;
			level.cobraWeapon[ self.pilot.currentWeapon ].v[ "ammoCounter" ] setValue( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "currentAmmo" ] );
		}

		// some weapons require player to release the fire button before a second shot is fired
		if ( level.cobraWeapon[ self.pilot.currentWeapon ].v[ "singleShot" ] )
			self.pilot weaponsSystems_buttonRelease_Wait( "BUTTON_RTRIG" );
	}
}

weaponsSystems_Detach_Weapon( modelname, tagname )
{
	if ( getdvar( "cobrapilot_unlimited_ammo" ) == "1" )
		return;

	// build list of all attached models
	attachedModelCount = self getattachsize();
	attachedModels = [];
	for ( i = 0 ; i < attachedModelCount ; i++ )
		attachedModels[ i ] = self getattachmodelname( i );

	// check to see if this model is attached to this model
	// if it is, see if it's on the matching tagname
	qAttached = false;
	for ( i = 0 ; i < attachedModels.size ; i++ )
	{
		if ( attachedModels[ i ] != modelname )
			continue;

		sName = self getattachtagname( i );
		if ( tolower( tagname ) != tolower( sName ) )
			continue;

		qAttached = true;
		break;
	}

	if ( qAttached )
		self detach( modelname, tagname );
	else
		println( "FAILED TO DETACH MODEL: " + modelname + " from tag: " + tagname );
}

weaponsSystems_Attach_Weapon( weapon )
{
	if ( getdvar( "cobrapilot_unlimited_ammo" ) == "1" )
		return;

	// build list of all attached models
	attachedModelCount = self getattachsize();

	//attachedModels = [];
	//for ( i = 0 ; i < attachedModelCount ; i++ )
	//	attachedModels[ i ] = self getattachmodelname( i );

	// find an open tag that this model could get attached to
	if ( !isdefined( level.cobra_missile_models[ weapon ] ) )
		return;
	missileModel = level.cobra_missile_models[ weapon ];
	attachToTag = undefined;
	for ( i = 0 ; i < level.cobra_weapon_tags[ weapon ].size ; i++ )
	{
		tag = level.cobra_weapon_tags[ weapon ][ i ];

		// check if a model is already attached to this tag
		if ( weaponsSystems_Model_Attached_To_Tag( tag ) )
			continue;

		attachToTag = tag;
		break;
	}

	if ( isdefined( attachToTag ) )
		self attach( missileModel, attachToTag );
	//else
		//println( "FAILED TO ATTACH MODEL: " + missileModel );
}

weaponsSystems_Model_Attached_To_Tag( tagname )
{
	// find if a model is attached to this tag
	attachedModelCount = self getattachsize();
	for ( i = 0 ; i < attachedModelCount ; i++ )
	{
		if ( self getattachtagname( i ) == tagname )
			return true;
	}
	return false;
}

weaponsSystems_Get_Missile_Target()
{
	level endon( "cobra_death" );

	missileTarget = undefined;

	if ( !isdefined( level.cobraTarget ) )
		return missileTarget;

	if ( !isdefined( level.cobraTarget.size ) )
		return missileTarget;

	prof_begin( "cobrapilot_weapons_systems" );

	// find the missile with the lowest .locked time
	for ( i = 0 ; i < level.cobraTarget.size ; i++ )
	{
		if ( !isdefined( level.cobraTarget[ i ].locked ) )
			continue;

		if ( !isdefined( missileTarget ) )
			missileTarget = level.cobraTarget[ i ];

		if ( level.cobraTarget[ i ].locked < missileTarget.locked )
			missileTarget = level.cobraTarget[ i ];
	}

	prof_end( "cobrapilot_weapons_systems" );

	if ( isdefined( missileTarget ) )
		missileTarget.locked = getTime();

	return missileTarget;
}

weaponsSystems_noAmmo_Warning()
{
	self notify( "noammo_warning" );
	self endon( "noammo_warning" );

	if ( isdefined( self.hudelems.noammo_warning ) )
		self.hudelems.noammo_warning destroy();

	self.hudelems.noammo_warning = newClientHudElem( self.pilot );
	self.hudelems.noammo_warning.x = 0;
	self.hudelems.noammo_warning.y = 40;
	self.hudelems.noammo_warning.alignX = "center";
	self.hudelems.noammo_warning.alignY = "middle";
	self.hudelems.noammo_warning.horzAlign = "center";
	self.hudelems.noammo_warning.vertAlign = "middle";
	self.hudelems.noammo_warning.foreground = true;
	// No Ammo
	self.hudelems.noammo_warning setText( &"COBRAPILOT_NO_AMMO" );
	self.hudelems.noammo_warning.fontscale = 1.5;

	if ( getdvar( "cobrapilot_sounds_enabled" ) == "1" )
		self.pilot playLocalSound( "cobra_no_ammo" );

	self.hudelems.noammo_warning.alpha = 1;
	wait 0.5;
	self.hudelems.noammo_warning fadeOverTime( 1.0 );
	self.hudelems.noammo_warning.alpha = 0;
	wait 1.0;
	self.hudelems.noammo_warning destroy();
}

weaponsSystems_noLock_Warning()
{
	self notify( "nolock_warning" );
	self endon( "nolock_warning" );

	if ( isdefined( self.hudelems.nolock_warning ) )
		self.hudelems.nolock_warning destroy();

	self.hudelems.nolock_warning = newClientHudElem( self.pilot );
	self.hudelems.nolock_warning.x = 0;
	self.hudelems.nolock_warning.y = 40;
	self.hudelems.nolock_warning.alignX = "center";
	self.hudelems.nolock_warning.alignY = "middle";
	self.hudelems.nolock_warning.horzAlign = "center";
	self.hudelems.nolock_warning.vertAlign = "middle";
	self.hudelems.nolock_warning.foreground = true;
	// Requires Lock-On
	self.hudelems.nolock_warning setText( &"COBRAPILOT_NO_LOCK" );
	self.hudelems.nolock_warning.fontscale = 1.5;

	if ( getdvar( "cobrapilot_sounds_enabled" ) == "1" )
		self.pilot playLocalSound( "cobra_no_ammo" );

	self.hudelems.nolock_warning.alpha = 1;
	wait 0.5;
	self.hudelems.nolock_warning fadeOverTime( 1.0 );
	self.hudelems.nolock_warning.alpha = 0;
	wait 1.0;
	self.hudelems.nolock_warning destroy();
}

weaponsSystems_zoom()
{
	assert( isdefined( self ) );
	assert( isdefined( self.pilot ) );
	assert( self.pilot.classname == "player" );

	level endon( "cobra_death" );
	self.pilot endon( "death" );

	wait 0.05;

	self.pilot reset_fov_for_player();

	for ( ;; )
	{
		while ( !self.pilot buttonPressed( "BUTTON_LSTICK" ) )
			wait 0.05;
		self.pilot change_fov_for_player( level.weaponZoomFOV );

		while ( self.pilot buttonPressed( "BUTTON_LSTICK" ) )
			wait 0.05;
		self.pilot reset_fov_for_player();
	}
}

change_fov_for_player( targetFOV )
{
	targetFOV = int( targetFOV );

	fov = int( getdvar( "cg_fov" ) );
	if ( isdefined( fov ) && fov > 0 )
		level.initialFOV = fov;

	fovFraction = targetFOV / level.initialFOV;
	fovFraction = cap_value( fovFraction, 0.2, 2.0 );
	self change_fov_scale_for_player( fovFraction );
}

reset_fov_for_player()
{
	self change_fov_scale_for_player( 1.0 );
}

change_fov_scale_for_player( scale )
{
	if ( self == level.player )
		setsaveddvar( "cg_playerFovScale0", scale );
	else if ( self == level.player2 )
		setsaveddvar( "cg_playerFovScale1", scale );
	else
		assertMsg( "Flyable helicopters currently only supports single player or coop with 2 players. Playing with more than 2 players is not yet supported" );
}

cobraTarget_Add( player, targetEntity, targetType, targetOffset )
{
	// adds a new entity target to the targets array

	assert( isdefined( player ) );
	assert( player.classname == "player" );
	assert( isdefined( targetEntity ) );
	assert( isdefined( targetType ) );
	assert( targetType == "air" || targetType == "ground" || targetType == "dummy" );

	prof_begin( "cobrapilot_weapons_systems" );

	if ( !isdefined( targetOffset ) )
		targetOffset = ( 0, 0, 0 );

	if ( !isdefined( level.cobraTarget ) )
		level.cobraTarget = [];

	index = level.cobraTarget.size;

	level.cobraTarget[ index ] = spawnstruct();
	level.cobraTarget[ index ].targetEntity = targetEntity;
	level.cobraTarget[ index ].targetType = targetType;
	level.cobraTarget[ index ].targetOffset = targetOffset;
	level.cobraTarget[ index ].playerOwner = player;
	//level.cobraTarget[ index ].hudelem = newClientHudElem( player );
	//level.cobraTarget[ index ].hudelem SetShader( "veh_hud_target", 1, 1 );
	//level.cobraTarget[ index ].hudelem SetWayPoint( true, true, true );
	//level.cobraTarget[ index ].hudelem SetTargetEnt( targetEntity );
	
	target_set( level.cobraTarget[ index ].targetEntity, level.cobraTarget[ index ].targetOffset );
	
	level.cobraTarget[ index ].targetEntity.target_initilized = true;
	thread cobraTarget_Death( level.cobraTarget[ index ] );

	level notify( "targets_updated" );

	prof_end( "cobrapilot_weapons_systems" );

	cobraTarget_UpdateShaders_All( player );
	thread cobraTarget_check_missileLock_All( player );
}

cobraTarget_Death( targetStruct )
{
	targetStruct.targetEntity waittill( "death" );
	cobraTarget_holdWait_missileLock_Sound_Stop( targetStruct );

	// if the sidewinder weapon was targeting this target, clear the target reticle
	if ( isdefined( targetStruct.sideWinder_targeted ) )
		cobraTarget_Sidewinder_ReticleLockOn_Stop( targetStruct );

	level.stats[ "enemies_killed" ]++ ;

	cobraTarget_Remove( targetStruct );
}

cobraTarget_Remove( targetStruct )
{
	prof_begin( "cobrapilot_weapons_systems" );

	//targetStruct.hudelem destroy();
	level.cobraTarget = array_remove( level.cobraTarget, targetStruct );
	target_remove( targetStruct.targetEntity );
	
	level notify( "targets_updated" );

	prof_end( "cobrapilot_weapons_systems" );
}

cobraTarget_UpdateShaders_All( player )
{
	// updates shaders for all targets in the targets array
	// if ground missiles are armed ground targets show "target" shader and air targets show "invalid" shader
	// if air missiles are armed air targets show "target" shader and ground targets show "invalid" shader
	// if dummy missiles are armed all targets show "target" shader

	assert( isdefined( player ) );
	assert( player.classname == "player" );

	// player isn't in a chopper yet
	if ( !isdefined( player.currentWeapon ) )
		return;

	if ( !isdefined( level.cobraTarget ) )
		return;
	if ( !isdefined( level.cobraTarget.size ) )
		return;
	if ( !isdefined( level.cobraWeapon ) )
		return;
	if ( level.cobraWeapon.size == 0 )
		return;

	prof_begin( "cobrapilot_weapons_systems" );

	for ( i = 0 ; i < level.cobraTarget.size ; i++ )
	{
		// if the target type matches the weapon type (ie weapon type is "ground" and target type is also "ground")
		// then make this target have a valid target shader
		// if the weapon type is "dummy" then all targets are valid
		// otherwise give it the invalid target shader

		if ( level.cobraTarget[ i ].playerOwner != player )
			continue;

		if ( level.cobraWeapon[ player.currentWeapon ].v[ "targetType" ] == "dummy" )
			cobraTarget_UpdateShader( player, level.cobraTarget[ i ], "target" );
		else if ( level.cobraTarget[ i ].targetType == level.cobraWeapon[ player.currentWeapon ].v[ "targetType" ] )
			cobraTarget_UpdateShader( player, level.cobraTarget[ i ], "target" );
		else
			cobraTarget_UpdateShader( player, level.cobraTarget[ i ], "invalid" );
	}

	prof_end( "cobrapilot_weapons_systems" );
}

cobraTarget_UpdateShader( player, targetStruct, shader )
{
	assert( isdefined( player ) );
	assert( player.classname == "player" );
	assert( isdefined( targetStruct ) );
	assert( isdefined( targetStruct.targetEntity ) );
	assert( isdefined( shader ) );
	//assert( isdefined( targetStruct.hudelem ) );

	assertEx( isdefined( targetStruct.targetEntity.target_initilized ), "Script is trying to do setShader on a target that hasn't run target_set. This is supposed to be impossible" );

	switch( shader )
	{
		case "target":
			//targetStruct.hudelem setShader( level.cobraWeapon[ player.currentWeapon ].v[ "shader_target" ] );
			target_setShader( targetStruct.targetEntity, level.cobraWeapon[ player.currentWeapon ].v[ "shader_target" ] );
			target_setOffscreenShader( targetStruct.targetEntity, level.cobraWeapon[ player.currentWeapon ].v[ "shader_target_offscreen" ] );
			break;
		case "lock":
			//targetStruct.hudelem setShader( level.cobraWeapon[ player.currentWeapon ].v[ "shader_lock" ] );
			target_setShader( targetStruct.targetEntity, level.cobraWeapon[ player.currentWeapon ].v[ "shader_lock" ] );
			target_setOffscreenShader( targetStruct.targetEntity, level.cobraWeapon[ player.currentWeapon ].v[ "shader_target_offscreen" ] );
			break;
		case "locking":
			//targetStruct.hudelem setShader( level.cobraWeapon[ player.currentWeapon ].v[ "shader_locking" ] );
			target_setShader( targetStruct.targetEntity, level.cobraWeapon[ player.currentWeapon ].v[ "shader_locking" ] );
			target_setOffscreenShader( targetStruct.targetEntity, level.cobraWeapon[ player.currentWeapon ].v[ "shader_target_offscreen" ] );
			break;
		case "invalid":
			//targetStruct.hudelem setShader( level.cobraWeapon[ player.currentWeapon ].v[ "shader_invalid" ] );
			target_setShader( targetStruct.targetEntity, level.cobraWeapon[ player.currentWeapon ].v[ "shader_invalid" ] );
			target_setOffscreenShader( targetStruct.targetEntity, level.cobraWeapon[ player.currentWeapon ].v[ "shader_invalid_offscreen" ] );
			break;
		default:
			assertMsg( "shader must be target, lock, locking, or invalid" );
			break;
	}
}

cobraTarget_unlockAllTargets()
{
	if ( !isdefined( level.cobraTarget ) )
		return;
	if ( !isdefined( level.cobraTarget.size ) )
		return;

	prof_begin( "cobrapilot_weapons_systems" );

	for ( i = 0 ; i < level.cobraTarget.size ; i++ )
	{
		cobraTarget_Sidewinder_ReticleLockOn_Stop( level.cobraTarget[ i ] );
		level.cobraTarget[ i ].sideWinder_targeted = undefined;
		level.cobraTarget[ i ].locking = undefined;
		level.cobraTarget[ i ].locked = undefined;
	}

	prof_end( "cobrapilot_weapons_systems" );
}

cobraTarget_check_missileLock_All( player )
{
	wait 0.05;
	assert( isdefined( player ) && ( player.classname == "player" ) );
	
	if ( !isdefined( level.cobraWeapon ) )
		return;
	if ( level.cobraWeapon.size == 0 )
		return;
	if ( !isdefined( player.currentWeapon ) )
		return;

	level notify( "checking for missile locks" );
	level endon( "checking for missile locks" );
	level endon( "cobra_death" );

	for ( ;; )
	{
		prof_begin( "cobrapilot_weapons_systems" );

		assert( isdefined( level.cobraTarget ) );

		if ( !isdefined( level.cobraTarget.size ) )
		{
			level waittill( "targets_updated" );
			continue;
		}

		if ( !isdefined( level.cobraTarget.size ) )
			continue;

		if ( level.cobraWeapon[ player.currentWeapon ].v[ "targetType" ] == "ground" )
		{
			boxHalfWidth = ( level.cobraWeapon[ player.currentWeapon ].v[ "hudShader_size_x" ] / 2 ) - 25;
			boxHalfHeight = ( level.cobraWeapon[ player.currentWeapon ].v[ "hudShader_size_y" ] / 2 ) - 25;

			// logic for hellfire missile lockons
			for ( i = 0 ; i < level.cobraTarget.size ; i++ )
			{
				z_type = level.cobraTarget[ i ].targetType;
				z_weap = player.currentWeapon;
				z_weaponmode = level.cobraWeapon[ player.currentWeapon ].v[ "targetType" ];

				if ( level.cobraTarget[ i ].targetType != level.cobraWeapon[ player.currentWeapon ].v[ "targetType" ] )
				{
					prof_end( "cobrapilot_weapons_systems" );
					continue;
				}
				cobraTarget_check_missileLock_Ground( level.cobraTarget[ i ], boxHalfWidth, boxHalfHeight );
			}
		}
		else if ( level.cobraWeapon[ player.currentWeapon ].v[ "targetType" ] == "air" )
		{
			circleRadius = ( level.cobraWeapon[ player.currentWeapon ].v[ "hudShader_size_x" ] / 2 ) - 10;

			for ( i = 0 ; i < level.cobraTarget.size ; i++ )
			{
				if ( level.cobraTarget[ i ].targetType != level.cobraWeapon[ player.currentWeapon ].v[ "targetType" ] )
				{
					prof_end( "cobrapilot_weapons_systems" );
					continue;
				}
				cobraTarget_check_missileLock_Air( level.cobraTarget[ i ], circleRadius );
			}
		}
		else
		{
			prof_end( "cobrapilot_weapons_systems" );
			level waittill( "weapon_armed" );
		}

		prof_end( "cobrapilot_weapons_systems" );
		wait 0.05;
	}
}

cobraTarget_isLockingOn( targetStruct, boxHalfWidth, boxHalfHeight, circleRadius )
{
	assert( isdefined( targetStruct ) );
	assert( isdefined( targetStruct.targetEntity ) );

	if ( isdefined( boxHalfWidth ) )
		assert( isdefined( boxHalfHeight ) );

	if ( ( !isdefined( boxHalfWidth ) ) && ( !isdefined( boxHalfHeight ) ) )
		assert( isdefined( circleRadius ) );

	inReticle = false;
	sightTrace = false;

	prof_begin( "cobrapilot_weapons_systems" );

	inReticle = target_isinrect( targetStruct.targetEntity, level.player, int( getdvar( "cg_fov" ) ), boxHalfWidth, boxHalfHeight );
	if ( inReticle )
		sightTrace = sighttracepassed( level.player getEye() + ( 0, 0, 100 ), targetStruct.targetEntity.origin + targetStruct.targetOffset + ( 0, 0, 100 ), false, undefined );

	prof_end( "cobrapilot_weapons_systems" );

	if ( inReticle && sightTrace )
		return true;

	return false;
}

cobraTarget_check_missileLock_Ground( targetStruct, boxHalfWidth, boxHalfHeight )
{
	level endon( "weapon_armed" );

	assert( isdefined( targetStruct ) );
	assert( isdefined( targetStruct.targetEntity ) );
	assert( isdefined( boxHalfWidth ) );
	assert( isdefined( boxHalfHeight ) );

	if ( cobraTarget_isLockingOn( targetStruct, boxHalfWidth, boxHalfHeight ) )
		thread cobraTarget_holdWait_missileLock_Ground( targetStruct, boxHalfWidth, boxHalfHeight );
	else
		cobraTarget_UpdateShader( level.player, targetStruct, "target" );
}

cobraTarget_holdWait_missileLock_Ground( targetStruct, boxHalfWidth, boxHalfHeight )
{
	level endon( "weapon_armed" );
	level endon( "cobra_death" );

	assert( isdefined( targetStruct ) );
	assert( isdefined( targetStruct.targetEntity ) );
	assert( isdefined( boxHalfWidth ) );
	assert( isdefined( boxHalfHeight ) );

	targetStruct.targetEntity endon( "death" );

	if ( isdefined( targetStruct.locking ) )
		return;
	if ( isdefined( targetStruct.locked ) )
		return;
	targetStruct.locking = getTime();

	lockStartTime = getTime();

	prof_begin( "cobrapilot_weapons_systems" );
	thread cobraTarget_holdWait_missileLock_Sound_Start( targetStruct, "weap_hellfire_seeking" );
	while ( cobraTarget_isLockingOn( targetStruct, boxHalfWidth, boxHalfHeight ) )
	{
		cobraTarget_UpdateShader( level.player, targetStruct, "locking" );
		wait 0.4;
		cobraTarget_UpdateShader( level.player, targetStruct, "target" );
		wait 0.4;

		currentTime = getTime();
		elapsedTime = currentTime - lockStartTime;

		if ( elapsedTime > level.cobraWeapon[ level.player.currentWeapon ].v[ "lockonTime" ] )
		{
			thread cobraTarget_holdLock_missileLock_Ground( targetStruct, boxHalfWidth, boxHalfHeight );
			prof_end( "cobrapilot_weapons_systems" );
			return;
		}
	}
	thread cobraTarget_holdWait_missileLock_Sound_Stop( targetStruct );
	prof_end( "cobrapilot_weapons_systems" );

	targetStruct.locking = undefined;
}

cobraTarget_holdLock_missileLock_Ground( targetStruct, boxHalfWidth, boxHalfHeight )
{
	level endon( "weapon_armed" );
	level endon( "cobra_death" );

	assert( isdefined( targetStruct ) );
	assert( isdefined( targetStruct.targetEntity ) );
	assert( isdefined( boxHalfWidth ) );
	assert( isdefined( boxHalfHeight ) );

	targetStruct.targetEntity endon( "death" );

	cobraTarget_UpdateShader( level.player, targetStruct, "lock" );

	prof_begin( "cobrapilot_weapons_systems" );

	targetStruct.locked = targetStruct.locking;
	targetStruct.locking = undefined;

	thread cobraTarget_holdWait_missileLock_Sound_Stop( targetStruct );
	if ( getdvar( "cobrapilot_sounds_enabled" ) == "1" )
		level.player playLocalSound( "weap_hellfire_lock" );

	while ( cobraTarget_isLockingOn( targetStruct, boxHalfWidth, boxHalfHeight ) )
		wait 0.05;
	targetStruct.locked = undefined;

	prof_end( "cobrapilot_weapons_systems" );
}

cobraTarget_holdWait_missileLock_Sound_Start( targetStruct, alias )
{
	if ( getdvar( "cobrapilot_sounds_enabled" ) != "1" )
		return;

	level endon( "cobra_death" );
	level endon( "stop_cobra_hellfire_locking_sound" );

	assert( isdefined( targetStruct ) );
	assert( isdefined( alias ) );

	if ( isdefined( targetStruct.locking_sound_playing ) )
		return;
	targetStruct.locking_sound_playing = alias;

	targetStruct thread playLoopSoundForSeeking( alias );
}

cobraTarget_holdWait_missileLock_Sound_Stop( targetStruct )
{
	if ( getdvar( "cobrapilot_sounds_enabled" ) != "1" )
		return;

	assert( isdefined( targetStruct ) );

	if ( !isdefined( targetStruct.locking_sound_playing ) )
		return;

	targetStruct notify( "stop sound" + targetStruct.locking_sound_playing );
	targetStruct.locking_sound_playing = undefined;
}

cobraTarget_check_missileLock_Air( targetStruct, circleRadius )
{
	level endon( "weapon_armed" );

	assert( isdefined( targetStruct ) );
	assert( isdefined( targetStruct.targetEntity ) );
	assert( isdefined( circleRadius ) );

	if ( cobraTarget_Sidewinder_Has_Target() )
		return;

	if ( target_isincircle( targetStruct.targetEntity, level.player, int( getdvar( "cg_fov" ) ), circleRadius ) )
	{
		targetStruct.sideWinder_targeted = true;
		thread cobraTarget_holdWait_missileLock_Air( targetStruct, circleRadius );
		return;
	}

	cobraTarget_UpdateShader( level.player, targetStruct, "target" );
}

cobraTarget_holdWait_missileLock_Air( targetStruct, circleRadius )
{
	level endon( "weapon_armed" );
	level endon( "cobra_death" );

	assert( isdefined( targetStruct ) );
	assert( isdefined( targetStruct.targetEntity ) );
	assert( isdefined( targetStruct.sideWinder_targeted ) );
	assert( isdefined( circleRadius ) );

	targetStruct.targetEntity endon( "death" );

	if ( isdefined( targetStruct.locking ) )
		return;
	if ( isdefined( targetStruct.locked ) )
		return;
	targetStruct.locking = getTime();

	lockStartTime = getTime();

	prof_begin( "cobrapilot_weapons_systems" );

	thread cobraTarget_Sidewinder_ReticleLockOn_Start( targetStruct );

	while ( target_isincircle( targetStruct.targetEntity, level.player, int( getdvar( "cg_fov" ) ), circleRadius ) )
	{
		cobraTarget_UpdateShader( level.player, targetStruct, "locking" );
		wait 0.4;
		cobraTarget_UpdateShader( level.player, targetStruct, "target" );
		wait 0.4;

		currentTime = getTime();
		elapsedTime = currentTime - lockStartTime;

		if ( elapsedTime > level.cobraWeapon[ level.player.currentWeapon ].v[ "lockonTime" ] )
		{
			thread cobraTarget_holdLock_missileLock_Air( targetStruct, circleRadius );
			prof_end( "cobrapilot_weapons_systems" );
			return;
		}
	}
	prof_end( "cobrapilot_weapons_systems" );

	cobraTarget_Sidewinder_ReticleLockOn_Stop( targetStruct );
	targetStruct.locking = undefined;
}

cobraTarget_holdLock_missileLock_Air( targetStruct, circleRadius )
{
	level endon( "weapon_armed" );
	level endon( "cobra_death" );

	assert( isdefined( targetStruct ) );
	assert( isdefined( targetStruct.targetEntity ) );
	assert( isdefined( circleRadius ) );

	targetStruct.targetEntity endon( "death" );

	cobraTarget_UpdateShader( level.player, targetStruct, "lock" );

	targetStruct.targetEntity notify( "missile_lock", level.playervehicle );

	prof_begin( "cobrapilot_weapons_systems" );

	targetStruct.locked = targetStruct.locking;
	targetStruct.locking = undefined;

	thread cobraTarget_holdWait_missileLock_Sound_Stop( targetStruct );
	thread cobraTarget_holdWait_missileLock_Sound_Start( targetStruct, "weap_aim9_lock" );

	while ( target_isincircle( targetStruct.targetEntity, level.player, int( getdvar( "cg_fov" ) ), circleRadius ) )
		wait 0.05;

	cobraTarget_Sidewinder_ReticleLockOn_Stop( targetStruct );

	targetStruct.locked = undefined;
	cobraTarget_UpdateShader( level.player, targetStruct, "target" );
	prof_end( "cobrapilot_weapons_systems" );
}

cobraTarget_Sidewinder_Has_Target()
{
	for ( i = 0 ; i < level.cobraTarget.size ; i++ )
	{
		if ( isdefined( level.cobraTarget[ i ].sideWinder_targeted ) )
			return true;
	}
	return false;
}

cobraTarget_Sidewinder_ReticleLockOn_Start( targetStruct )
{
	targetStruct endon( "Sidewinder_ReticleLockOn_Stop" );

	assert( isdefined( targetStruct ) );
	assert( isdefined( targetStruct.targetEntity ) );

	targetStruct.targetEntity endon( "death" );

	weaponSystems_EquipLoopSound_Stop();

	segmentLength = ( level.cobraWeapon[ level.player.currentWeapon ].v[ "lockonTime" ] / 3 );
	lockOnTime = ( level.cobraWeapon[ level.player.currentWeapon ].v[ "lockonTime" ] / 1000 );

	target_startreticlelockon( targetStruct.targetEntity, lockOnTime );

	lockonAliasList = [];
	lockonAliasList[ 0 ] = "weap_aim9_growl1";
	lockonAliasList[ 1 ] = "weap_aim9_growl2";
	lockonAliasList[ 2 ] = "weap_aim9_growl3";

	for ( i = 0 ; i < lockonAliasList.size ; i++ )
	{
		thread cobraTarget_holdWait_missileLock_Sound_Stop( targetStruct );
		thread cobraTarget_holdWait_missileLock_Sound_Start( targetStruct, lockonAliasList[ i ] );

		lastPhaseTime = getTime();

		while ( ( getTime() - lastPhaseTime ) < segmentLength )
			wait 0.05;
	}
}

cobraTarget_Sidewinder_ReticleLockOn_Stop( targetStruct )
{
	target_clearreticlelockon();

	assert( isdefined( targetStruct ) );

	targetStruct.targetEntity notify( "missile_lock_ended", level.playervehicle );

	targetStruct notify( "Sidewinder_ReticleLockOn_Stop" );

	targetStruct.sideWinder_targeted = undefined;
	thread cobraTarget_holdWait_missileLock_Sound_Stop( targetStruct );

	thread weaponSystems_EquipLoopSound_Start();
}

health_indicator_create( pilot )
{
	assert( isdefined( self ) );
	assert( isdefined( self.pilot ) );

	// red screen overlay
	self.hudelems.cobra_health_overlay = newClientHudElem( self.pilot );
	self.hudelems.cobra_health_overlay.x = 0;
	self.hudelems.cobra_health_overlay.y = 0;
	self.hudelems.cobra_health_overlay setshader( "splatter_alt_sp", 640, 480 );
	self.hudelems.cobra_health_overlay.alignX = "left";
	self.hudelems.cobra_health_overlay.alignY = "top";
	self.hudelems.cobra_health_overlay.horzAlign = "fullscreen";
	self.hudelems.cobra_health_overlay.vertAlign = "fullscreen";
	self.hudelems.cobra_health_overlay.alpha = 0;

	// color changing health icon
	self.hudelems.cobra_health_icon = newClientHudElem( self.pilot );
	self.hudelems.cobra_health_icon.x = -10;
	self.hudelems.cobra_health_icon.y = -65;
	self.hudelems.cobra_health_icon.alignX = "right";
	self.hudelems.cobra_health_icon.alignY = "bottom";
	self.hudelems.cobra_health_icon.horzAlign = "right";
	self.hudelems.cobra_health_icon.vertAlign = "bottom";
	self.hudelems.cobra_health_icon.foreground = true;
	self.hudelems.cobra_health_icon setshader( "cobra_health", 128, 48 );
	self.hudelems.cobra_health_icon.alpha = 1;
	self.hudelems.cobra_health_icon.color = ( 0, 1, 0 );
}

health_indicator_damageWait()
{
	level endon( "cobra_death" );
	for ( ;; )
	{
		self waittill( "damage" );

		// flash the red overlay on the screen
		thread health_indicator_redScreenFlash( self.hudelems.cobra_health_overlay );

		newColor = self health_indicator_getColor();
		self.hudelems.cobra_health_icon.color = ( newColor[ 0 ], newColor[ 1 ], newColor[ 2 ] );
	}
}

health_indicator_getColor()
{
	color = ( 1, 0, 0 );

	//define what colors to use
	color_severe = [];
	color_severe[ 0 ] = 1.0;
	color_severe[ 1 ] = 0.0;
	color_severe[ 2 ] = 0.0;
	color_moderate = [];
	color_moderate[ 0 ] = 1.0;
	color_moderate[ 1 ] = 0.5;
	color_moderate[ 2 ] = 0.0;
	color_repaired = [];
	color_repaired[ 0 ] = 0.0;
	color_repaired[ 1 ] = 1.0;
	color_repaired[ 2 ] = 0.0;

	//default color
	SetValue = [];
	SetValue[ 0 ] = color_severe[ 0 ];
	SetValue[ 1 ] = color_severe[ 1 ];
	SetValue[ 2 ] = color_severe[ 2 ];

	//define where the non blend points are
	severe = 0;
	moderate = ( level.flyablecobra_starting_health / 2 );
	repaired = level.flyablecobra_starting_health;

	iPercentage = undefined;
	difference = undefined;
	increment = undefined;

	value = self.health;

	if ( ( value > severe ) && ( value <= moderate ) )
	{
		iPercentage = int( value * ( 100 / moderate ) );
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = ( color_moderate[ colorIndex ] - color_severe[ colorIndex ] );
			increment = ( difference / 100 );
			SetValue[ colorIndex ] = color_severe[ colorIndex ] + ( increment * iPercentage );
		}
	}
	else if ( ( value > moderate ) && ( value <= repaired ) )
	{
		iPercentage = int( ( value - moderate ) * ( 100 / ( repaired - moderate ) ) );
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = ( color_repaired[ colorIndex ] - color_moderate[ colorIndex ] );
			increment = ( difference / 100 );
			SetValue[ colorIndex ] = color_moderate[ colorIndex ] + ( increment * iPercentage );
		}
	}

	return SetValue;
}

health_warningSound_Start()
{
	level endon( "cobra_death" );

	if ( isdefined( level.lowhealth_warning_playing ) )
		return;
	level.lowhealth_warning_playing = true;

	if ( getdvar( "cobrapilot_sounds_enabled" ) == "1" )
		self.pilot thread play_loop_sound_on_entity( "alarm_cobra_death_imminent" );
}

health_warningSound_Stop()
{
	self.pilot notify( "stop sound" + "alarm_cobra_death_imminent" );
	level.lowhealth_warning_playing = undefined;
}

health_leak()
{
	level endon( "cobra_death" );
	self endon( "stop_health_leak" );

	for ( ;; )
	{
		if ( self.health - level.flyablecobra_healthLeakIncrement <= 0 )
		{
			self thread cobra_death();
			return;
		}
		self.health -= level.flyablecobra_healthLeakIncrement;

		level.stats[ "damage_taken" ] += level.flyablecobra_healthLeakIncrement;

		self notify( "damage" );
		wait level.flyablecobra_healthLeakRate;
	}
}

health_indicator_redScreenFlash( overlay )
{
	level notify( "redScreenFlash" );
	level endon( "redScreenFlash" );

	overlay fadeOverTime( 0.1 );
	overlay.alpha = 1;
	wait 0.2;
	overlay fadeOverTime( 0.5 );
	overlay.alpha = 0;
}

health_removeHudElems()
{
	level waittill( "cobra_death" );

	// remove hud elements when player dies
	self.hudelems.controller_layout destroy();
	self.hudelems.weapon_hud destroy();
}

health_Regen_Station()
{
	level endon( "cobra_death" );

	for ( ;; )
	{
		level waittill( "health_regen" );

		if ( self.health >= level.flyablecobra_starting_health )
			continue;

		// add health
		self.health += level.flyablecobra_healthRegenIncrement;
		if ( self.health > level.flyablecobra_starting_health )
			self.health = level.flyablecobra_starting_health;

		if ( self.health > level.flyablecobra_healthWarning_value )
		{
			self thread health_warningSound_Stop();
			self notify( "stop_health_leak" );
		}

		newColor = health_indicator_getColor();
		self.hudelems.cobra_health_icon.color = ( newColor[ 0 ], newColor[ 1 ], newColor[ 2 ] );

		if ( getdvar( "cobrapilot_sounds_enabled" ) == "1" )
			self.pilot playLocalSound( "cobra_health_pickup" );

		wait level.flyablecobra_healthRegenRate;
	}
}

health_think()
{
	self thread health_removeHudElems();
	fatalImpactRate = 1500;
	self thread health_Regen_Station();
	for ( ;; )
	{
		self waittill( "veh_collision", velocity, collisionNormal );

		prof_begin( "cobrapilot_health_system" );

		/*
		Impending Collision Notify
		self waittill( "veh_predictedcollision", velocity, collisionNormal );
		(use dvar g_helicopterLookaheadTime to specify how far ahead to check for impending collisions)
		*/

		impactVelocity = vectordot( velocity, collisionNormal );
		slideVelocity = length( velocity - ( vector_multiply( collisionNormal, impactVelocity ) ) );
		impactVelocity = abs( impactVelocity );

		// reduce damage from slide velocity
		slideVelocity = ( slideVelocity / 2 );

		impactAmount = impactVelocity;
		if ( slideVelocity > impactVelocity )
			impactAmount = slideVelocity;

		// cap the impact rate to not exceed fatalImpactRate since it wont mater at that point anyways
		if ( impactAmount > fatalImpactRate )
			impactAmount = fatalImpactRate;

		damage = int( impactAmount * ( level.flyablecobra_starting_health / fatalImpactRate ) );

		if ( damage <= 200 )
		{
			prof_end( "cobrapilot_health_system" );
			continue;
		}

		directionOfImpact = vector_multiply( collisionNormal, -1 );
		directionOfImpact = self.origin + directionOfImpact;

		prof_end( "cobrapilot_health_system" );

		level.stats[ "damage_taken" ] += damage;

		bDeath = false;
		if ( ( self.health - damage ) <= 0 )
			bDeath = true;
		else
		{
			if ( getdvar( "cobrapilot_sounds_enabled" ) == "1" )
				self.pilot playLocalSound( "helicopter_collide" );

			self.health -= damage;

			if ( self.health <= level.flyablecobra_healthWarning_value )
			{
				self thread health_warningSound_Start();
				self thread health_leak();
			}

			self joltbody( directionOfImpact, ( damage / 1900 ) );
		}

		self notify( "damage" );

		if ( bDeath )
		{
			self cobra_death();
			return;
		}

		wait 0.25;
	}
}

cobra_death()
{
	/*
	self.crashing = true;
	self thread maps\_vehicle::kill_fx( self.model );
	self thread maps\_vehicle::helicopter_crash_move();
	
	self waittill( "crash_done" );
	self notify( "stop_looping_death_fx" );
	self notify( "death_finished" );
	
	self useby( self.pilot );
	self.pilot enablehealthshield( false );
	self.pilot kill ( self.pilot.origin );
	self.pilot enablehealthshield( true );
	level notify ( "cobra_death" );
	self freevehicle();
	self delete();
	*/

	if ( getdvar( "cobrapilot_sounds_enabled" ) == "1" )
		self.pilot playLocalSound( "helicopter_crash" );

	self.health = 1;

	self useby( self.pilot );
	self hide();
	self.pilot enablehealthshield( false );

	level notify( "cobra_death" );

	fxOrigin = self.pilot.origin;

	playfx( level.player_death_fx, fxOrigin );
	self.pilot kill( self.pilot.origin );
	self.pilot enablehealthshield( true );
}

incommingMissile_Think()
{
	level endon( "cobra_death" );

	thread missileIndicator_MissileFlashNotifies();

	for ( ;; )
	{
		level.playervehicle waittill( "incomming_missile", eMissile );
		assert( isdefined( eMissile ) );
		thread missileIndicator( eMissile );
		thread incommingMissile_Missile_Death( eMissile );
		thread incommingMissile_Sound_Start();
	}
}

incommingMissile_Missile_Death( eMissile )
{
	level endon( "cobra_death" );

	eMissile waittill( "death" );
	incommingMissile_Sound_Stop();
}

incommingMissile_Sound_Start()
{
	if ( !isdefined( level.missile_launched_warning_playing ) )
		level.missile_launched_warning_playing = 0;

	level.missile_launched_warning_playing++ ;

	if ( level.missile_launched_warning_playing > 1 )
		return;

	if ( getdvar( "cobrapilot_sounds_enabled" ) == "1" )
		level.player thread play_loop_sound_on_entity( "alarm_cobra_enemy_launch" );
}

incommingMissile_Sound_Stop()
{
	level.missile_launched_warning_playing -- ;

	if ( level.missile_launched_warning_playing > 0 )
		return;

	level.player notify( "stop sound" + "alarm_cobra_enemy_launch" );
}

ammo_Reload_Station()
{
	if ( !isdefined( level.cobraWeapon ) )
		return;
	if ( level.cobraWeapon.size == 0 )
		return;

	level endon( "cobra_death" );

	array_thread( getentarray( "ammo_reload", "targetname" ), ::ammo_Reload_Station_Notify, "ammo_reload" );

	if ( getdvar( "cobrapilot_unlimited_ammo" ) == "1" )
		return;

	for ( ;; )
	{
		regenPoint = undefined;
		level waittill( "ammo_reload", regenPoint, trigger );

		if ( getdvar( "cobrapilot_farp_mode" ) == "0" )
		{
			for ( i = 0 ; i < level.cobraWeapon.size ; i++ )
				thread ammo_Reload_Station_Add_Ammo( level.cobraWeapon[ i ] );
			wait 0.05;
		}
		else if ( getdvar( "cobrapilot_farp_mode" ) == "1" )
		{
			thread ammo_Reload_Station_AutoLand_HintPrint( regenPoint, trigger );
			ammo_Reload_Station_Cinematic_Reload( regenPoint, trigger );
		}
	}
}

ammo_Reload_Station_Cinematic_Reload( regenPoint, trigger )
{
	assert( isdefined( regenPoint ) );
	hoverPoint = regenPoint + ( 0, 0, 300 );
	level.player freezeControls( true );
	level.playervehicle	Vehicle_SetSpeed( 30, 5 );
	level.playervehicle setVehGoalPos( hoverPoint, 1 );
	level.playervehicle waittill( "goal" );

	level.player unlink();
	level.playervehicle useby( level.player );
	level.player takeAllWeapons();
	viewingEnt = undefined;
	viewingEnt = trigger ammo_Reload_Station_Get_Viewing_Ent();
	assert( isdefined( viewingEnt ) );
	assert( viewingEnt.classname == "script_model" );
	assert( viewingEnt.model == "tag_origin" );
	level.player playerlinktodelta( viewingEnt, "tag_origin", 1.0 );
	wait 0.05;
	level.player setPlayerAngles( vectorToAngles( ( level.playervehicle.origin - ( 0, 0, 56 ) ) - viewingEnt.origin ) );

	wait 5;

	level.player linkto( level.playervehicle );

	//level.playervehicle makeUsable();
	level.playervehicle useby( level.player );
	//level.playervehicle makeUnusable();

	level.playervehicle returnplayercontrol();
	level.player freezeControls( false );
}

ammo_Reload_Station_Get_Viewing_Ent()
{
	viewingEnt = undefined;
	ents = getentarray( "ammo_viewpoint", "targetname" );
	viewingEnt = getClosest( self.origin, ents );
	assert( isdefined( viewingEnt ) );
	return viewingEnt;
}

ammo_Reload_Station_AutoLand_HintPrint( hoverPoint, trigger )
{
	if ( isdefined( level.playervehicle.farp_autoland_print_on ) )
		return;
	level.playervehicle.farp_autoland_print_on = true;

	// create print
	//iprintlnbold( "in" );

	while ( level.playervehicle isTouching( trigger ) )
		wait 0.05;

	// remove print
	//iprintlnbold( "out" );

	level.playervehicle.farp_autoland_print_on = undefined;
}

ammo_Reload_Station_Notify( notifyString )
{
	assert( isdefined( notifyString ) );
	level endon( "cobra_death" );

	farpicon = newHudElem();
	farpicon setShader( "compass_waypoint_farp", 6, 6 );
	farpicon.x = self.origin[ 0 ];
	farpicon.y = self.origin[ 1 ];
	farpicon.z = self.origin[ 2 ];
	farpicon.alpha = .75;
	farpicon SetWayPoint( true, false );

	trig = undefined;
	if ( getdvar( "cobrapilot_farp_mode" ) == "1" )
	{
		trig = spawn( "trigger_radius", self.origin, 16, 1500, 1000 );
	}

	for ( ;; )
	{
		vehicle = undefined;
		if ( getdvar( "cobrapilot_farp_mode" ) == "0" )
			self waittill( "trigger", vehicle );
		else if ( getdvar( "cobrapilot_farp_mode" ) == "1" )
		{
			assert( isdefined( trig ) );
			trig waittill( "trigger", vehicle );
		}
		if ( !isdefined( vehicle ) )
			continue;

		if ( vehicle != level.playervehicle )
			continue;

		regenPoint = self.origin;
		if ( isdefined( self.target ) )
		{
			ent = getent( self.target, "targetname" );
			if ( isdefined( ent ) )
				regenPoint = ent.origin;
		}

		if ( isdefined( trig ) )
			level notify( notifyString, regenPoint, trig );
		else
			level notify( notifyString, regenPoint, self );
		level notify( "health_regen" );

		if ( getdvar( "cobrapilot_farp_mode" ) == "1" )
		{
			while ( vehicle isTouching( trig ) )
				wait 0.05;
		}
	}
}

ammo_Reload_Station_Add_Ammo( weapon )
{
	level endon( "cobra_death" );

	if ( isdefined( weapon.reloading ) )
		return;

	weapon.reloading = true;

	wait randomFloatRange( weapon.v[ "ammoPickupDelay_Min" ], weapon.v[ "ammoPickupDelay_Max" ] );

	if ( weapon.v[ "currentAmmo" ] >= weapon.v[ "maxAmmo" ] )
	{
		weapon.reloading = undefined;
		return;
	}

	// add ammo and update the ammo counter on the hud
	weapon.v[ "currentAmmo" ] += weapon.v[ "ammoPickupIncrement" ];
	if ( weapon.v[ "currentAmmo" ] > weapon.v[ "maxAmmo" ] )
		weapon.v[ "currentAmmo" ] = weapon.v[ "maxAmmo" ];

	// attach missiles back onto the chopper since they were detached when fired
	for ( i = 0 ; i < weapon.v[ "ammoPickupIncrement" ] ; i++ )
		level.playervehicle weaponsSystems_Attach_Weapon( weapon.v[ "weapon" ] );

	if ( getdvar( "cobrapilot_sounds_enabled" ) == "1" )
		level.player playLocalSound( "cobra_ammo_reload" );

	weapon.v[ "ammoCounter" ] setValue( weapon.v[ "currentAmmo" ] );

	weapon.reloading = undefined;
}
/*
borderwall_method1()
{
	// When the player hits the border wall triggers the helicopter controls are taken over and the chopper
	// is turned around and flown back into the map boundaries
	
	level endon ( "cobra_death" );
	
	target = getent( self.target, "targetname" );
	for(;;)
	{
		self waittill ( "trigger", vehicle );
		if ( vehicle != level.playervehicle )
			continue;
		
		normalvec = vectornormalize( target.origin - level.playervehicle.origin );
		
		movetospot = level.playervehicle.origin + vector_multiply( normalvec, 2000 );
		movetospot = ( movetospot[0], movetospot[1], level.playervehicle.origin[2] );
		
		level.playervehicle	Vehicle_SetSpeed( 60, 25 );
		level.playervehicle	setvehgoalpos( movetospot, 0 );
		level.playervehicle waittill ( "goal" );
		level.playervehicle returnplayercontrol();
	}
}
*/
/*
edge_Of_World()
{
	// When the player leaves the playable area a warning is printed on the screen.
	// The player must re-enter the playable area within a time limit or else the
	//mission is failed
	
	level endon ( "cobra_death" );
	
	array_thread( getentarray( "border_inner", "targetname" ), ::edge_Of_World_Notify, "border_inner" );
	array_thread( getentarray( "border_outer", "targetname" ), ::edge_Of_World_Notify, "border_outer" );
	
	for (;;)
	{
		level waittill( "border_outer" );
		level notify( "player_out_of_bounds" );
		thread edge_Of_World_Warning();
		
		level waittill( "border_inner" );
		level notify( "player_in_bounds" );
		if ( isdefined( level.edge_of_world_warning ) )
			level.edge_of_world_warning destroy();
		if ( isdefined( level.edge_of_world_timer ) )
			level.edge_of_world_timer destroy();
	}
}
*/
/*
edge_Of_World_Notify( notifyString )
{
	assert( isdefined( notifyString ) );
	
	level endon ( "cobra_death" );
	
	for(;;)
	{
		self waittill ( "trigger", vehicle );
		if ( vehicle != level.playervehicle )
			continue;
		
		level notify( notifyString );
	}
}
*/
/*
edge_Of_World_Warning()
{
	level notify( "edge_Of_World_Warning" );
	level endon( "edge_Of_World_Warning" );
	level endon ( "player_in_bounds" );
	
	// max number of seconds player is allowed out of bounds
	// when this time is exceeded the mission is failed
	outOfBoundsMaxTime = 15;
	
	if ( !isdefined( level.edge_of_world_warning ) )
	{
		level.edge_of_world_warning = newHudElem();
		level.edge_of_world_warning.x = 0;
		level.edge_of_world_warning.y = 0;
		level.edge_of_world_warning.alignX = "center";
		level.edge_of_world_warning.alignY = "middle";
		level.edge_of_world_warning.horzAlign = "center";
		level.edge_of_world_warning.vertAlign = "middle";
		level.edge_of_world_warning.foreground = true;
		level.edge_of_world_warning setText( &"COBRAPILOT_EDGE_OF_WORLD_WARNING" );
		level.edge_of_world_warning.fontscale = 2;
		level.edge_of_world_warning.color = ( 1, 0, 0 );
	}
	
	if ( !isdefined( level.edge_of_world_timer ) )
	{
		level.edge_of_world_timer = newHudElem();
		level.edge_of_world_timer.x = 0;
		level.edge_of_world_timer.y = 20;
		level.edge_of_world_timer.alignX = "center";
		level.edge_of_world_timer.alignY = "middle";
		level.edge_of_world_timer.horzAlign = "center";
		level.edge_of_world_timer.vertAlign = "middle";
		level.edge_of_world_timer.foreground = true;
		level.edge_of_world_timer.fontscale = 2;
		level.edge_of_world_timer.color = ( 1, 0, 0 );
	}
	
	level.edge_of_world_timer setTimer( outOfBoundsMaxTime );
	level.edge_of_world_warning.alpha = 1;
	
	outOfBoundsTime = getTime();
	
	wait 0.25;
	while( getTime() - outOfBoundsTime < outOfBoundsMaxTime * 1000 )
	{
		wait 0.6;
		level.edge_of_world_warning fadeOverTime( 0.2 );
		level.edge_of_world_warning.alpha = 0;
		level.edge_of_world_timer fadeOverTime( 0.2 );
		level.edge_of_world_timer.alpha = 0;
		wait 0.2;
		level.edge_of_world_warning fadeOverTime( 0.2 );
		level.edge_of_world_warning.alpha = 1;
		level.edge_of_world_timer fadeOverTime( 0.2 );
		level.edge_of_world_timer.alpha = 1;
		wait 0.2;
	}
	
	edge_Of_World_Fail();
}
*/
/*
edge_Of_World_Fail()
{
	setdvar( "ui_deadquote", "@COBRAPILOT_EDGE_OF_WORLD_FAIL" );
	maps\_utility::missionFailedWrapper();
}
*/
playLoopSoundForSeeking( alias )
{
	org = spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	thread delete_on_death( org );
	org.origin = level.player.origin;
	org.angles = level.player.angles;
	org linkto( level.player );
	org playloopsound( alias );
	self waittill( "stop sound" + alias );
	org stoploopsound( alias );
	org delete();
}

gunner_spawn( chopper )
{
	gunner = spawn( "script_model", level.playervehicle getTagOrigin( "tag_gunner" ) );
	gunner.angles = level.playervehicle getTagAngles( "tag_gunner" );
	gunner linkto( level.playervehicle, "tag_gunner" );
	gunner setModel( "body_complete_sp_cobra_pilot_desert_zack" );

	gunner useAnimTree( #animtree );

	chopper thread gunner_think( gunner );
}

gunner_think( gunner )
{
	level.playervehicle endon( "death" );
	level.player endon( "death" );

	gunner thread gunner_lookAtTarget();

	for ( ;; )
	{
		if ( self.gunner_use_turret == false )
		{
			while ( self.gunner_use_turret == false )
				wait 0.1;
			wait randomfloatrange( 0.5, 1.2 );
			continue;
		}

		eTarget = level.playervehicle getEnemyTarget( level.GunnerTargetRange, level.GunnerTargetFOV, true, true );
		if ( isdefined( eTarget ) )
		{
			gunner thread gunner_lookAtTarget( eTarget );
			level.playervehicle thread shootEnemyTarget_Bullets( eTarget );
		}
		else if ( getdvar( "cobrapilot_debug" ) == "1" )
		{
			iprintln( "no valid targets" );
			gunner thread gunner_lookAtTarget();
		}
		wait 2;
	}
}

gunner_lookAtTarget( eTarget )
{
	level.playervehicle endon( "death" );
	level.player endon( "death" );

	self notify( "stop_looking_at_target" );
	self endon( "stop_looking_at_target" );
	if ( isdefined( eTarget ) )
		eTarget endon( "death" );

	for ( ;; )
	{
		if ( isdefined( self.lookingAtTarget ) && isdefined( eTarget ) )
			blendTime = 0.1;
		else
			blendTime = 1.0;

		self.lookingAtTarget = true;

		blendAmount = self gunner_getBlendNumber( eTarget );

		self setanim( %cobra_copilot_idle_l, blendAmount[ 0 ], blendTime );
		self setanim( %cobra_copilot_idle, 	 blendAmount[ 1 ], blendTime );
		self setanim( %cobra_copilot_idle_r, blendAmount[ 2 ], blendTime );

		if ( !isdefined( eTarget ) )
		{
			self.lookingAtTarget = undefined;
			return;
		}

		wait blendTime;
	}
}

gunner_getBlendNumber( eTarget )
{
	blendAmount = [];
	blendAmount[ 0 ] = 0.0;	// left
	blendAmount[ 1 ] = 1.0;	// forward
	blendAmount[ 2 ] = 0.0;	// right

	if ( !isdefined( eTarget ) )
		return blendAmount;

	//prof_begin( "cobrapilot_ai" );

	forward = anglesToForward( level.playervehicle.angles );
	right = anglesToRight( level.playervehicle.angles );
	t = ( eTarget.origin - level.playervehicle.origin );
	s = vectorDot( t, right );
	f = vectorDot( t, forward );
	assert( f != 0 );
	value = ( s / f );

	if ( value < 0 )
	{
		// turn head to the left
		value = abs( value );
		if ( value > 1.0 )
			value = 1.0;
		blendAmount[ 0 ] = value;		// left
		blendAmount[ 1 ] = 1 - value;	// forward
		blendAmount[ 2 ] = 0.0;		// right

	}
	else if ( value > 0 )
	{
		// turn head to the right
		value = abs( value );
		if ( value > 1.0 )
			value = 1.0;
		blendAmount[ 0 ] = 0.0;		// left
		blendAmount[ 1 ] = 1 - value;	// forward
		blendAmount[ 2 ] = value;		// right
	}

	//prof_end( "cobrapilot_ai" );

	return blendAmount;
}

missileIndicator( eMissile )
{
	missileIndicator = spawnstruct();

	missileIndicator.eMissile = eMissile;
	target_set( missileIndicator.eMissile );
	target_setShader( missileIndicator.eMissile, level.missileHintIndicator_Missile );
	target_setOffscreenShader( missileIndicator.eMissile, level.missileHintIndicator_Missile_Offscreen );

	// LEFT arrow
	missileIndicator.arrowLeft = newHudElem();
	missileIndicator.arrowLeft.x = -160;
	missileIndicator.arrowLeft.y = 0;
	missileIndicator.arrowLeft.alignX = "center";
	missileIndicator.arrowLeft.alignY = "middle";
	missileIndicator.arrowLeft.horzAlign = "center";
	missileIndicator.arrowLeft.vertAlign = "middle";
	missileIndicator.arrowLeft.foreground = true;
	missileIndicator.arrowLeft.alpha = 0;
	missileIndicator.arrowLeft setshader( level.missileHintIndicator_Arrow[ "left" ], 80, 160 );

	// RIGHT arrow
	missileIndicator.arrowRight = newHudElem();
	missileIndicator.arrowRight.x = 160;
	missileIndicator.arrowRight.y = 0;
	missileIndicator.arrowRight.alignX = "center";
	missileIndicator.arrowRight.alignY = "middle";
	missileIndicator.arrowRight.horzAlign = "center";
	missileIndicator.arrowRight.vertAlign = "middle";
	missileIndicator.arrowRight.foreground = true;
	missileIndicator.arrowRight.alpha = 0;
	missileIndicator.arrowRight setshader( level.missileHintIndicator_Arrow[ "right" ], 80, 160 );

	// FORWARD arrow
	missileIndicator.arrowForward = newHudElem();
	missileIndicator.arrowForward.x = 0;
	missileIndicator.arrowForward.y = -160;
	missileIndicator.arrowForward.alignX = "center";
	missileIndicator.arrowForward.alignY = "middle";
	missileIndicator.arrowForward.horzAlign = "center";
	missileIndicator.arrowForward.vertAlign = "middle";
	missileIndicator.arrowForward.foreground = true;
	missileIndicator.arrowForward.alpha = 0;
	missileIndicator.arrowForward setshader( level.missileHintIndicator_Arrow[ "forward" ], 160, 80 );

	// BACK arrow
	missileIndicator.arrowBack = newHudElem();
	missileIndicator.arrowBack.x = 0;
	missileIndicator.arrowBack.y = 160;
	missileIndicator.arrowBack.alignX = "center";
	missileIndicator.arrowBack.alignY = "middle";
	missileIndicator.arrowBack.horzAlign = "center";
	missileIndicator.arrowBack.vertAlign = "middle";
	missileIndicator.arrowBack.foreground = true;
	missileIndicator.arrowBack.alpha = 0;
	missileIndicator.arrowBack setshader( level.missileHintIndicator_Arrow[ "back" ], 160, 80 );

	thread missileIndicator_MissileDeath( missileIndicator );
	thread missileIndicator_MissileFlash( missileIndicator );

	// find where the missile is relative to the player so it can draw the appropriate arrows
	eMissile endon( "death" );
	level.player endon( "death" );
	level.playervehicle endon( "death" );
	for ( ;; )
	{
		// uses level.player angles instead of the cobra's angles so that it works when the player is in freelook

		level waittill( "incomming_missile_blink_on" );

		prof_begin( "cobrapilot_weapons_systems" );

		forwardvec = anglestoforward( level.player.angles );
		backvec = vector_multiply( forwardvec, -1 );
		rightvec = anglestoright( level.player.angles );
		leftvec = vector_multiply( rightVec, -1 );
		vecToMissile = vectorNormalize( missileIndicator.eMissile.origin - ( level.player getOrigin() ) );

		// forward arrow
		missileIndicator.arrowForward.alpha = 0;
		vecdot = vectordot( forwardvec, vecToMissile );
		if ( vecdot > level.cosine[ "45" ] )
			missileIndicator.arrowForward.alpha = 1;

		// back arrow
		missileIndicator.arrowBack.alpha = 0;
		vecdot = vectordot( backvec, vecToMissile );
		if ( vecdot > level.cosine[ "45" ] )
			missileIndicator.arrowBack.alpha = 1;

		// left arrow
		missileIndicator.arrowLeft.alpha = 0;
		vecdot = vectordot( leftvec, vecToMissile );
		if ( vecdot > level.cosine[ "45" ] )
			missileIndicator.arrowLeft.alpha = 1;

		// right arrow
		missileIndicator.arrowRight.alpha = 0;
		vecdot = vectordot( rightvec, vecToMissile );
		if ( vecdot > level.cosine[ "45" ] )
			missileIndicator.arrowRight.alpha = 1;

		prof_end( "cobrapilot_weapons_systems" );

		level waittill( "incomming_missile_blink_off" );

		missileIndicator.arrowForward.alpha = 0;
		missileIndicator.arrowBack.alpha = 0;
		missileIndicator.arrowLeft.alpha = 0;
		missileIndicator.arrowRight.alpha = 0;
	}
}

missileIndicator_MissileFlash( missileIndicator )
{
	level.playervehicle endon( "death" );

	assert( isdefined( missileIndicator.eMissile ) );

	missileIndicator.eMissile endon( "death" );

	for ( ;; )
	{
		level waittill( "incomming_missile_blink_off" );
			target_setShader( missileIndicator.eMissile, level.missileHintIndicator_Missile_Flash );
			target_setOffscreenShader( missileIndicator.eMissile, level.missileHintIndicator_Missile_Flash );

		level waittill( "incomming_missile_blink_on" );
			target_setShader( missileIndicator.eMissile, level.missileHintIndicator_Missile );
			target_setOffscreenShader( missileIndicator.eMissile, level.missileHintIndicator_Missile_Offscreen );
	}
}

missileIndicator_MissileDeath( missileIndicator )
{
	level.playervehicle endon( "death" );

	assert( isdefined( missileIndicator.eMissile ) );

	missileIndicator.eMissile waittill( "death" );

	if ( isdefined( missileIndicator.arrowLeft ) )
		missileIndicator.arrowLeft destroy();
	if ( isdefined( missileIndicator.arrowRight ) )
		missileIndicator.arrowRight destroy();
	if ( isdefined( missileIndicator.arrowForward ) )
		missileIndicator.arrowForward destroy();
	if ( isdefined( missileIndicator.arrowBack ) )
		missileIndicator.arrowBack destroy();
}

missileIndicator_MissileFlashNotifies()
{
	level.playervehicle endon( "death" );
	level.player endon( "death" );

	for ( ;; )
	{
		wait 0.2;
		level notify( "incomming_missile_blink_off" );
		wait 0.1;
		level notify( "incomming_missile_blink_on" );
	}
}