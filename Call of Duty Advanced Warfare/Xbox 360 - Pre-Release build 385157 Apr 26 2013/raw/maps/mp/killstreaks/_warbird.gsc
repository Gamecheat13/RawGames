#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

//how fast the helicopter moves to keep up with the goal
CONST_smooth_heli_speed_mph_forward = 45;
CONST_smooth_heli_accel				= 1.5;
CONST_smooth_heli_decel				= 2;

CONST_smooth_heli_accel_factor_while_hovering = 0.1;
CONST_smooth_heli_hover_radius				  = 24;

// free range mode stuff
CONST_free_range_speed		= 60;
CONST_free_range_yaw_amount = 50;
CONST_free_range_yaw_zone	= 70;

//collision capsule 
CONST_warbird_collision_radius = 100;
CONST_warbird_z_offset		   = 0;

//rocket fire settings
CONST_rocket_reload_time   = 6;
CONST_rocket_fire_interval = 0.05;

//warbird combat tuning
CONST_target_aquire_time	= 2;
CONST_los_recheck_time		= 2;
CONST_warbird_move_time_min = 4;
CONST_warbird_move_time_max = 8;

//warbird cloak tuning
CONST_cloak_duration		  = 10;
CONST_cloak_cooldown_duration = 20;

//hud values
CONST_rocket_hudx = 160;
CONST_rocket_hudy = 220;
CONST_rocket_hud_offset = 20;

CONST_mg_hudx = 380;
CONST_mg_hudy = 280;

CONST_flir_hudx=430;
CONST_flir_hudy=350;

CONST_cloak_hudx=115;
CONST_cloak_hudy=350;

CONST_possess_hudx = 100;
CONST_possess_hudy = 180;
	
init()
{
	PreCacheShader( "overlay_static" );
	PreCacheModel( "tag_player" );
	PreCacheModel( "vehicle_xh9_warbird_cloaked_in_out" );
	PreCacheModel( "vehicle_xh9_warbird_turret_left_stealth" );
	PreCacheModel( "vehicle_xh9_warbird_turret_right_stealth" );
	PreCacheTurret( "warbird_turret_mp" );
	PreCacheItem( "warbird_25mm_mp" );
	PreCacheModel( "vehicle_xh9_warbird_mp" );
	
	precacheshader("jet_hud_overlay_cannon_boresight");
    precacheshader("jet_hud_overlay_cannon_boresight_lockon");
    precacheshader("jet_hud_overlay_cannon_reticle");
    precacheshader("jet_hud_overlay_cannon_reticle_lockon");
    precacheshader("jet_hud_ammo_missile_1");
    precacheshader("jet_hud_overlay_cannon_1");

    
	level.warbirdSetting						  = [];
	level.warbirdSetting[ "Warbird" ]			  = SpawnStruct();
	level.warbirdSetting[ "Warbird" ].vehicle	  = "warbird_player_mp";	 //"osprey_mp";
	level.warbirdSetting[ "Warbird" ].modelBase	  = "vehicle_xh9_warbird_mp";//"vehicle_xh9_warbird";//"vehicle_v22_osprey_body_mp"
	level.warbirdSetting[ "Warbird" ].modelBlades = "";						 //= "vehicle_v22_osprey_blades_mp";
	level.warbirdSetting[ "Warbird" ].prompt	  = "";
	level.warbirdSetting[ "Warbird" ].name		  = "";
	level.warbirdSetting[ "Warbird" ].weaponInfo  = "warbird_turret_mp";//"warbird_player_turret_mp";
	level.warbirdSetting[ "Warbird" ].heliType	  = "warbird";
	level.warbirdSetting[ "Warbird" ].maxHealth	  = level.heli_maxhealth;
	level.warbirdSetting[ "Warbird" ].timeOut	  = 60.0;

	level.killstreakFuncs[ "warbird" ] = ::tryUseWarbird;
}

tryUseWarbird( lifeId, kId )
{
	numIncomingVehicles = 1;
	if ( IsDefined( self.lastStand ) && !self _hasPerk( "specialty_finalstand" ) )
	{
		self IPrintLnBold( &"KILLSTREAKS_UNAVAILABLE_IN_LASTSTAND" );
		return false;
	}
	else if ( IsDefined( level.civilianJetFlyBy ) )
	{
		self IPrintLnBold( &"KILLSTREAKS_CIVILIAN_AIR_TRAFFIC" );
		return false;
	}
	else if ( IsDefined( level.chopper ) )
	{
		self IPrintLnBold( &"KILLSTREAKS_AIR_SPACE_TOO_CROWDED" );
		return false;
	}
	else if ( currentActiveVehicleCount() >= maxVehiclesAllowed() || level.fauxVehicleCount + numIncomingVehicles >= maxVehiclesAllowed() )
	{
		self IPrintLnBold( &"KILLSTREAKS_TOO_MANY_VEHICLES" );
		return false;
	}		
	else if ( self isUsingRemote() )
	{
		return false;
	}		

	/#
		heightEnt = GetEnt( "airstrikeheight", "targetname" );
	AssertEx( IsDefined( heightEnt ), "NO HEIGHT ENT IN LEVEL:  Don't know what this means, ask Ned or Jordan" );

	if ( !IsDefined( heightEnt ) )
		return false;
	#/

	if ( self isAirDenied() )
	{
		return false;
	}

	if ( self isEMPed() )
	{
		return false;
	}

	// increment the faux vehicle count before we spawn the vehicle so no other vehicles try to spawn
	incrementFauxVehicleCount();

	result = self thread SetupWarbirdKillStreak( lifeId );
	
	self maps\mp\_matchdata::logKillstreakEvent( "warbird", self.origin );

	return true;
}

SetupWarbirdKillStreak( lifeId )
{	
	self endon( "warbirdStreakComplete" );
    
	self NotifyOnPlayerCommand( "SwitchVisionMode"	 , "+actionslot 1" );
	self NotifyOnPlayerCommand( "SwitchWeapon"		 , "weapnext" );
	self NotifyOnPlayerCommand( "ToggleControlState" , "+usereload" );
	self NotifyOnPlayerCommand( "ToggleControlCancel", "-usereload" );
	self NotifyOnPlayerCommand( "StartFire"			 , "+attack" );
	self NotifyOnPlayerCommand( "StopFire"			 , "-attack" );
	self NotifyOnPlayerCommand( "FireRockets"		 , "+speed_throw" );
	self NotifyOnPlayerCommand( "Cloak"				 , "+smoke" );

	if ( !IsDefined( level.TargetEnt ) )
		level.TargetEnt = Spawn( "script_origin", ( 0, 0, 0 ) );
	else
		level.TargetEnt.origin = ( 0, 0, 0 );

	level.PossessWarbird = false;
	
	AttackPoints = BuildValidFlightPaths();
	
	//SpawnPoint = GetEnt( "WarbirdSpawnPoint", "targetname" );
	AttackPoints = get_array_of_closest( self.origin, AttackPoints );
	
	SpawnPoint		  = SpawnStruct();
	SpawnPoint.origin = AttackPoints[ 0 ].origin;
	SpawnPoint.angles = AttackPoints[ 0 ].angles;
	
	SpawnPoint = RotateHeliSpawn( SpawnPoint );
	
	warbird	= SpawnHelicopter( self, SpawnPoint.origin, SpawnPoint.angles, level.warbirdSetting[ "Warbird" ].vehicle, level.warbirdSetting[ "Warbird" ].modelBase );

	//added frame for heli to spawn fully
	waitframe();

	warbird MakeVehicleSolidCapsule( CONST_warbird_collision_radius, CONST_warbird_z_offset, CONST_warbird_collision_radius );
	
	if ( !IsDefined( warbird ) )	
		return undefined;
	
	warbird.warbirdType			 = "Warbird";
	warbird.heli_type			 = level.warbirdSetting[ "Warbird" ].heliType;//level.warbirdSetting[ "Warbird" ].modelBase;
	warbird.heliType			 = level.warbirdSetting[ "Warbird" ].heliType;
	warbird.attractor			 = Missile_CreateAttractorEnt( warbird, level.heli_attract_strength, level.heli_attract_range );
	warbird.lifeId				 = lifeId;
	warbird.team				 = self.pers[ "team" ];
	warbird.pers[ "team" ]		 = self.pers[ "team" ];
	warbird.owner				 = self;
	warbird.maxhealth			 = level.warbirdSetting[ "Warbird" ].maxHealth;
	warbird.zOffset				 = ( 0, 0, 0 );
	warbird.targeting_delay		 = level.heli_targeting_delay;
	warbird.primaryTarget		 = undefined;
	warbird.secondaryTarget		 = undefined;
	warbird.attacker			 = undefined;
	warbird.currentstate		 = "ok";
	warbird.pickNewTarget		 = true;
	warbird.lineOfSight			 = false;
	warbird.overheattime		 = 6;
	warbird.firetime			 = 0;
	warbird.weaponfire			 = false;
	warbird.RocketClip			 = 3;
	warbird.RemainingRocketShots = warbird.RocketClip;
	warbird.RocketHud 			 = [];
	warbird.IsMoving			 = true;

	killCamEnt		   = Spawn( "script_model", warbird GetTagOrigin( "TAG_FLASH1" ) );
	warbird.killCamEnt = killCamEnt;
	warbird.killCamEnt SetScriptMoverKillCam( "explosive" );
	killCamEnt LinkTo( warbird , "TAG_FLASH1");
	
	warbird make_entity_sentient_mp( warbird.team );

	level.chopper = warbird;	
	warbird maps\mp\killstreaks\_helicopter::addToHeliList();
	warbird thread maps\mp\killstreaks\_helicopter::heli_flares_monitor();	
	warbird thread maps\mp\killstreaks\_helicopter::heli_leave_on_disconnect( self );
	warbird thread maps\mp\killstreaks\_helicopter::heli_leave_on_changeTeams( self );
	warbird thread maps\mp\killstreaks\_helicopter::heli_leave_on_gameended( self );
	
	lifeSpan = level.warbirdSetting[ "Warbird" ].timeOut;
	
	warbird thread maps\mp\killstreaks\_helicopter::heli_leave_on_timeout( lifeSpan );
	warbird thread maps\mp\killstreaks\_helicopter::heli_damage_monitor();
	warbird thread maps\mp\killstreaks\_helicopter::heli_health();		
	warbird thread maps\mp\killstreaks\_helicopter::heli_existance();
		
	thread MonitorAIWarbirdDeathorTimeout( warbird );
	thread MonitorPlayerDisconnect( warbird );
	
	SetupWarbirdTurrets( warbird );
	
	self thread WarbirdShootingThink( warbird );
	self thread EnemyWarbirdAttackMovement( warbird );
	
	warbird notify( "warbird_fire" );

	self WarbirdHudSetup( warbird );
	self WarbirdOverheatBarSetup( warbird );
	self thread PlayerControllWarbirdSetup( warbird );
	self thread MonitorPlayerDeath( warbird );

}

////=================================================================================================================//
////												WARBIRD HUD					                                     //
////=================================================================================================================//


WarbirdHudSetup( warbird )
{
	middlex = 320;
	middley = 0;
	
	warbird.HUDItem[ "weaponOverlay" ] = NewClientHudElem(self);
    warbird.HUDItem[ "weaponOverlay" ] Setshader("jet_hud_overlay_cannon_1", 640, 480);
    warbird.HUDItem[ "weaponOverlay" ].x = middlex;
    warbird.HUDItem[ "weaponOverlay" ].y = middley;
    warbird.HUDItem[ "weaponOverlay" ].alignx = "right";
    warbird.HUDItem[ "weaponOverlay" ].aligny = "middle";
    warbird.HUDItem[ "weaponOverlay" ].horzAlign = "center";
 	warbird.HUDItem[ "weaponOverlay" ].vertAlign = "middle";
    warbird.HUDItem[ "weaponOverlay" ].alpha = 0;

    
    warbird.HUDItem[ "weapon_reticle" ] = NewClientHudElem(self);
    warbird.HUDItem[ "weapon_reticle" ] Setshader("jet_hud_overlay_cannon_boresight", 640, 480);
    warbird.HUDItem[ "weapon_reticle" ].x = middlex;
    warbird.HUDItem[ "weapon_reticle" ].y = middley;
    warbird.HUDItem[ "weapon_reticle" ].alignx = "right";
    warbird.HUDItem[ "weapon_reticle" ].aligny = "middle";
    warbird.HUDItem[ "weapon_reticle" ].horzAlign = "center";
 	warbird.HUDItem[ "weapon_reticle" ].vertAlign = "middle";
    warbird.HUDItem[ "weapon_reticle" ].alpha = 0;
    

    warbird.HUDItem[ "Line1" ]			 = NewClientHudElem( self );
	warbird.HUDItem[ "Line1" ].x		 = CONST_possess_hudx;
	warbird.HUDItem[ "Line1" ].y		 = CONST_possess_hudy;
	warbird.HUDItem[ "Line1" ].alignX	 = "right";
	warbird.HUDItem[ "Line1" ].alignY	 = "middle";
	warbird.HUDItem[ "Line1" ].horzAlign = "center";
	warbird.HUDItem[ "Line1" ].vertAlign = "middle";
	warbird.HUDItem[ "Line1" ].fontScale = 1.5;
	warbird.HUDItem[ "Line1" ].alpha	 = 1.0;
	
	warbird.HUDItem[ "Line2" ]			 = NewClientHudElem( self );
	warbird.HUDItem[ "Line2" ].x		 = CONST_mg_hudx+75;
	warbird.HUDItem[ "Line2" ].y		 = CONST_mg_hudy;
	warbird.HUDItem[ "Line2" ].horzAlign = "fullscreen";
	warbird.HUDItem[ "Line2" ].vertAlign = "fullscreen";
	warbird.HUDItem[ "Line2" ].fontScale = 1.5;
	warbird.HUDItem[ "Line2" ].alpha	 = 1.0;
	
	warbird.HUDItem[ "Line3" ]			 = NewClientHudElem( self );
	warbird.HUDItem[ "Line3" ].x		 = CONST_rocket_hudx;
	warbird.HUDItem[ "Line3" ].y		 = CONST_rocket_hudy+(CONST_rocket_hud_offset*warbird.RocketClip);
	warbird.HUDItem[ "Line3" ].horzAlign = "fullscreen";
	warbird.HUDItem[ "Line3" ].vertAlign = "fullscreen";
	warbird.HUDItem[ "Line3" ].fontScale = 1.5;
	warbird.HUDItem[ "Line3" ].alpha	 = 1.0;
	
	warbird.HUDItem[ "Line4" ]			 = NewClientHudElem( self );
	warbird.HUDItem[ "Line4" ].x		 = CONST_flir_hudx;
	warbird.HUDItem[ "Line4" ].y		 = CONST_flir_hudy;
	warbird.HUDItem[ "Line4" ].horzAlign = "fullscreen";
	warbird.HUDItem[ "Line4" ].vertAlign = "fullscreen";
	warbird.HUDItem[ "Line4" ].fontScale = 1.5;
	warbird.HUDItem[ "Line4" ].alpha	 = 1.0;
	
	warbird.HUDItem[ "Line5" ]			 = NewClientHudElem( self );
	warbird.HUDItem[ "Line5" ].x		 = 60;
	warbird.HUDItem[ "Line5" ].y		 = 100;
	warbird.HUDItem[ "Line5" ].x		 = CONST_cloak_hudx;
	warbird.HUDItem[ "Line5" ].y		 = CONST_cloak_hudy;
	warbird.HUDItem[ "Line5" ].horzAlign = "fullscreen";
	warbird.HUDItem[ "Line5" ].vertAlign = "fullscreen";
	warbird.HUDItem[ "Line5" ].fontScale = 1.5;
	warbird.HUDItem[ "Line5" ].alpha	 = 1.0;
    
    self thread MakeMissileAmmoHud( warbird );
}

MakeMissileAmmoHud( warbird )
{
    slot = 5;
    dimX = 20;
    
    for( i = 0; i < warbird.RocketClip; i++ )
    {
        elem = NewClientHudElem( self );
        elem Setshader( "jet_hud_ammo_missile_1", dimX, slot );
        elem.horzAlign = "fullscreen";
        elem.vertAlign = "fullscreen";
        elem.x = CONST_rocket_hudx;
        elem.y = CONST_rocket_hudy + (CONST_rocket_hud_offset *  warbird.RocketHud.size);
        elem.alpha = 0;
        elem.color = (0, .75, 1);
     
        warbird.RocketHud  = array_add(warbird.RocketHud,elem);
    }
}

WarbirdRocketHudUpdate( warbird )
{
	switch(warbird.RemainingRocketShots)
	{
		case 0:
			warbird.RocketHud[0].alpha=0;
			warbird.RocketHud[1].alpha=0;
			warbird.RocketHud[2].alpha=0;
			warbird.HUDItem[ "Line3" ]SetText( "RELOAD" );
			warbird.HUDItem[ "Line3" ].x = CONST_rocket_hudx-15;
			break;
		case 1:
			warbird.RocketHud[0].alpha=0;
			warbird.RocketHud[1].alpha=0;
			warbird.RocketHud[2].alpha=1;
			warbird.HUDItem[ "Line3" ]SetText( "LT" );
				warbird.HUDItem[ "Line3" ].x = CONST_rocket_hudx;
			break;
		case 2:
			warbird.RocketHud[0].alpha=0;
			warbird.RocketHud[1].alpha=1;
			warbird.RocketHud[2].alpha=1;
			warbird.HUDItem[ "Line3" ]SetText( "LT" );
			warbird.HUDItem[ "Line3" ].x = CONST_rocket_hudx;
			break;
		case 3:
			warbird.RocketHud[0].alpha=1;
			warbird.RocketHud[1].alpha=1;
			warbird.RocketHud[2].alpha=1;
			warbird.HUDItem[ "Line3" ]SetText( "LT" );
			warbird.HUDItem[ "Line3" ].x = CONST_rocket_hudx;
			break;
	}
}

SetupPlayerHud( warbird )
{
	warbird.HUDItem[ "Line1" ]SetText( "HOLD X TO PILOT WARBIRD" );
	warbird.HUDItem[ "Line2" ]SetText( "" );
	warbird.HUDItem[ "Line3" ]SetText( "" );
	warbird.HUDItem[ "Line4" ]SetText( "" );
	warbird.HUDItem[ "Line5" ]SetText( "" );
	
	warbird.HUDItem[ "weaponOverlay" ].alpha = 0;
    warbird.HUDItem[ "weapon_reticle" ].alpha = 0;	
    
    foreach(HudElem in warbird.RocketHud)
    {
    	HudElem.alpha = 0;	
    }
}

SetupWarbirdHud( warbird )
{
	warbird.HUDItem[ "Line1" ]SetText( "HOLD X TO EXIT WARBIRD" );
	warbird.HUDItem[ "Line2" ]SetText( "RT" );
	warbird.HUDItem[ "Line3" ]SetText( "LT" );
	warbird.HUDItem[ "Line4" ]SetText( "UP FOR FLIR" );
	warbird.HUDItem[ "Line5" ]SetText( "LB FOR CLOAK" );
	
	
	warbird.HUDItem[ "weaponOverlay" ].alpha = 1;
    warbird.HUDItem[ "weapon_reticle" ].alpha = 1;	
    
    foreach(HudElem in warbird.RocketHud)
    {
    	HudElem.alpha = 1;	
    }
}

DeleteHud( warbird )
{
	warbird.HUDItem[ "Line1" ]Destroy(	);
	warbird.HUDItem[ "Line2" ]Destroy(	);
	warbird.HUDItem[ "Line3" ]Destroy(	);
	warbird.HUDItem[ "Line4" ]Destroy(	);
	warbird.HUDItem[ "Line5" ]Destroy(	);
	
	warbird.HUDItem[ "weaponOverlay" ]Destroy();
	warbird.HUDItem[ "weapon_reticle" ]Destroy();
	
	foreach(HudElem in warbird.RocketHud)
    {
		HudElem Destroy();
    }
}

ClearHud( warbird )
{
	warbird.HUDItem[ "Line1" ]SetText( "" );
	warbird.HUDItem[ "Line2" ]SetText( "RT" );
	warbird.HUDItem[ "Line3" ]SetText( "LT" );
	warbird.HUDItem[ "Line4" ]SetText( "UP FOR FLIR" );
	warbird.HUDItem[ "Line5" ]SetText( "LB FOR CLOAK" );
}


WarbirdOverheatBarSetup( warbird )
{
	warbird.OverheatBar = createBar( (0, .75, 1), 30, 100 );
	warbird.OverheatBar setPoint("center", undefined, CONST_mg_hudx-185, 0 );
	thread WarbirdOverheatBarColorMonitor( warbird );
	WarbirdBarHide( warbird );
}

WarbirdBarShow( warbird )
{
	warbird.OverheatBar showElem();
	warbird.OverheatBar updateBar( 0, 0 );
}

WarbirdBarHide( warbird )
{
	warbird.OverheatBar hideElem();
}

WarbirdBarDelete( warbird )
{
	warbird.OverheatBar destroyElem();
}

WarbirdOverheatBarUpdate( warbird )
{
	warbird.OverheatBar updateBar( warbird.firetime / warbird.overheattime, .2 );
}

WarbirdOverheatBarColorMonitor( warbird )
{
	while( true )
	{
		warbird waittill( "overheat" );
			warbird.OverheatBar.bar.color = (1,0,0);
			warbird.HUDItem[ "Line2" ]SetText( "OVERHEAT" );
		warbird waittill( "cooldowncomplete" );	
			warbird.OverheatBar.bar.color = (0, .75, 1);
			warbird.HUDItem[ "Line2" ]SetText( "RT" );
	}
}

CloakHudOn( warbird )
{
//	warbird.HUDItem[ "weapon_reticle" ] Setshader("jet_hud_overlay_cannon_boresight_lockon", 640, 480);
//	warbird.HUDItem[ "weapon_reticle" ] Setshader("jet_hud_overlay_cannon_boresight_lockon", 640, 480);
	
	foreach(HudElem in warbird.HUDItem)
	{
		HudElem.alpha = .25;	
	}
	warbird.OverheatBar.alpha = .25;
	warbird.OverheatBar.bar.alpha= .25;
	
	foreach(HudElem in warbird.RocketHud)
	{
		HudElem.alpha = .25;	
//		HudElem Setshader( "jet_hud_ammo_missile_1", dimX, slot );
	}
}

CloakHudOff( warbird )
{
//	warbird.HUDItem[ "weapon_reticle" ] Setshader("jet_hud_overlay_cannon_boresight", 640, 480);
//	warbird.HUDItem[ "weapon_reticle" ] Setshader("jet_hud_overlay_cannon_boresight", 640, 480);
	
	foreach(HudElem in warbird.HUDItem)
	{
		HudElem.alpha = 1;	
	}
	
	warbird.OverheatBar.alpha = 1;
	warbird.OverheatBar.bar.alpha= 1;
	
	foreach(HudElem in warbird.RocketHud)
	{
		HudElem.alpha = 1;	
//		HudElem Setshader( "jet_hud_ammo_missile_1", dimX, slot );
	}
}


////=================================================================================================================//
////												TURRET SETUP				                                     //
////=================================================================================================================//

SetupWarbirdTurrets( warbird )
{
    wait ( 0.5 );
						 
	warbird thread SpawnTurretModel( "tag_turret_right", "vehicle_xh9_warbird_turret_right_stealth" );
	warbird thread SpawnTurretModel( "tag_turret_left" , "vehicle_xh9_warbird_turret_left_stealth" );

	warbird.tagFlash1 = Spawn( "script_origin", ( 0, 0, 0 ) );
	warbird.tagFlash2 = Spawn( "script_origin", ( 0, 0, 0 ) );
	
	warbird.tagFlash1.origin = ( warbird GetTagOrigin( "TAG_FLASH1" ) );
	warbird.tagFlash2.origin = ( warbird GetTagOrigin( "TAG_FLASH2" ) );
		
	warbird.tagFlash1 LinkTo( warbird, "TAG_FLASH1" );
	warbird.tagFlash2 LinkTo( warbird, "TAG_FLASH2" );
	
}

SpawnTurretModel( turret_tag, model_name )
{
	turret_model = Spawn( "script_model", ( 0, 0, 0 ) );
	turret_model SetModel( model_name );
	turret_model LinkTo( self, turret_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	if ( !IsDefined( self.turret_models ) )
	{
		self.turret_models = [];
	}
	self.turret_models[ turret_tag ] = turret_model;
	
	self waittill( "death" );
	turret_model Delete();
}

////=================================================================================================================//
////											WARBIRD SPAWN LOGIC			                               		     //
////=================================================================================================================//

RotateHeliSpawn( SpawnPoint )
{
	MapCenter = GetEnt( "warbird_anchor", "targetname" );
	
	if ( IsDefined( MapCenter ) )
	{
		//Get the spawn forward direction as a vector
		SpawnPointForward = AnglesToForward( SpawnPoint.angles );
			
		//Get a vector from the spawn to the center
		VectorToCenter = MapCenter.origin - SpawnPoint.origin;
		
		//vector to angles
		NewOrientation = VectorToAngles( VectorToCenter );
	
		SpawnPoint.angles = NewOrientation;
	}
	
	return SpawnPoint;	
}

BuildValidFlightPaths( warbird )
{
	self endon( "warbirdStreakComplete" );
	
	HeliStart		 = GetEnt( "heli_loop_start", "targetname" );
	HeliAttackPoints = [];
	
	while ( true )
	{
		AttackPoint = GetEnt( HeliStart.target, "targetname" );
		if ( !IsInArray( HeliAttackPoints, AttackPoint ) )
	   	{
			HeliAttackPoints = array_add( HeliAttackPoints, AttackPoint );	
	   	}
		else
		{
			break;	
		}
		HeliStart = AttackPoint;
	}
	
	WarbirdHeight = GetEnt( "warbird_anchor", "targetname" );
	if ( !IsDefined( WarbirdHeight ) )
	{
		WarbirdHeight					= Spawn( "script_origin", ( -2448, 1128, 2032 ) );
		WarbirdHeight.script_noteworthy = 3500;
		WarbirdHeight.targetname		= "warbird_anchor";
	}
	HeightOrigin = WarbirdHeight.origin;
	AttackPoints = [];
	foreach ( AttackPoint in HeliAttackPoints )
	{
		TempPoint		 = SpawnStruct();
		TempPoint.angles = ( 0, 0, 0 );
		PointOrigin		 = AttackPoint.origin;
		
		UpdatedOrigin	 = ( PointOrigin[ 0 ], PointOrigin[ 1 ], HeightOrigin[ 2 ] );
		TempPoint.origin = UpdatedOrigin;
		
		AttackPoints = array_add( AttackPoints, TempPoint );
	}
	
	return AttackPoints;
}

IsInArray( array, Ent )
{
	if ( IsDefined( array ) )
	{
		foreach ( Index in array )
		{
			if ( Index == Ent )
				return true;
		}
	}
	return false;
}

////=================================================================================================================//
////										WARBIRD DEATH & BOUNDARY			                                     //
////=================================================================================================================//

MonitorPlayerDeath( warbird )
{
	self endon( "warbirdStreakComplete" );
	
	self waittill(	"death" );
	
	ClearHud( warbird );
	
	warbird notify( "WarbirdPlayerKilled" );
}

MonitorWarbirdSafeArea( warbird )
{
	self endon( "warbirdStreakComplete" );
	self endon( "ResumeWarbirdAI" );
	
	WarbirdAnchor		= GetEnt( "warbird_anchor", "targetname" );
	if ( !IsDefined( WarbirdAnchor ) )
	{
		WarbirdAnchor					= Spawn( "script_origin", ( -2448, 1128, 2032 ) );
		WarbirdAnchor.script_noteworthy = 3500;
		WarbirdAnchor.targetname		= "warbird_anchor";
	}
	levelBoundaryRadius = Int( WarbirdAnchor.script_noteworthy );
	
	warbird.StaticOverlay = CreateOverlay( "overlay_static", 0 );
	
	while ( true )
	{
		DistanceFromCenter = Distance( WarbirdAnchor.origin, warbird.origin );
		
		if ( DistanceFromCenter < levelBoundaryRadius )
		{
			warbird.StaticOverlay.alpha = 0;
		}
		else if ( DistanceFromCenter > levelBoundaryRadius && DistanceFromCenter < levelBoundaryRadius + 500 )
	    {
	    	warbird.StaticOverlay.alpha = 0.25;
	    	
	    	if ( IsDefined( level.PlayerAttachPoint ) )
	    		level.PlayerAttachPoint thread play_sound_on_entity( "mp_warbird_outofbounds_warning" );	
	    }
		else if ( DistanceFromCenter > levelBoundaryRadius + 500 && DistanceFromCenter < levelBoundaryRadius + 1000 )
	    {
	    	warbird.StaticOverlay.alpha = 0.5;
	    	
	    	if ( IsDefined( level.PlayerAttachPoint ) )
	    		level.PlayerAttachPoint thread play_sound_on_entity( "mp_warbird_outofbounds_warning" );	
	    }
		else if ( DistanceFromCenter > levelBoundaryRadius + 1000 && DistanceFromCenter < levelBoundaryRadius + 1500 )
	    {
	    	warbird.StaticOverlay.alpha = 0.75;
	    	
	    	if ( IsDefined( level.PlayerAttachPoint ) )
	    		level.PlayerAttachPoint thread play_sound_on_entity( "mp_warbird_outofbounds_warning" );	
	    }
		else
		{
			warbird.StaticOverlay.alpha = 1;
			wait 2;
			
			warbird thread maps\mp\killstreaks\_helicopter::heli_leave();
		}
		
		wait 0.5;
	}
}

CreateOverlay( OverlayName, InitialAlpha )
{
	overlay			  = NewClientHudElem( level.player );
	overlay.x		  = 0;
	overlay.y		  = 0;
	overlay.alignX	  = "left";
	overlay.alignY	  = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay SetShader( OverlayName, 640, 480 );
	overlay.alpha = InitialAlpha;
	overlay.sort  = -3;
	
	return overlay;
}

////=================================================================================================================//
////												AI Movement					                                     //
////=================================================================================================================//

EnemyWarbirdAttackMovement( warbird )
{
	self thread WarbirdLookAtEnemy( warbird );
	self thread WarbirdMoveToAttackPoint( warbird );
}

WarbirdMoveToAttackPoint( warbird )
{		
	self endon( "IHAVEASSUMEDCONTROL" );
	self endon( "warbirdStreakComplete" );

	AttackNodes	= BuildValidFlightPaths();

	baseSpeed = 40;
	warbird Vehicle_SetSpeed( baseSpeed, baseSpeed / 4, baseSpeed / 4 );
	warbird SetNearGoalNotifyDist( 100 );

	while ( true )
	{
		
		RandomNode	= random( AttackNodes );
		SortedNodes = get_array_of_closest( warbird.origin, AttackNodes );
		
		if ( RandomNode != SortedNodes[ 0 ] )
		{	
			warbird SetVehGoalPos( RandomNode.origin, 1 );
			
			warbird.IsMoving = true;
			
			warbird waittill( "near_goal" );
	
			warbird.IsMoving = false;
			
			wait( RandomFloatRange( CONST_warbird_move_time_min, CONST_warbird_move_time_max ) );
		}
		
		waitframe();
		
	}
}

WarbirdLookAtEnemy( warbird )
{
	self endon( "IHAVEASSUMEDCONTROL" );
	self endon( "warbirdStreakComplete" );
	
	while ( 1 )
	{
		if ( IsDefined( warbird.enemy_target ) )
		{
			thread UpdateLookAtEnt( warbird );
			MonitorLookAtEnt( warbird );
		}
		
		waitframe();
	}		
}

UpdateLookAtEnt( warbird )
{
	self endon( "IHAVEASSUMEDCONTROL" );
	self endon( "warbirdStreakComplete" );
	warbird.enemy_target endon ( "death" );
	
	while ( 1 )
	{
		warbird SetLookAtEnt( warbird.enemy_target );
		ForceTurretAimAtEnt( warbird, warbird.enemy_target );
		
		wait 0.05;
	}
}

ForceTurretAimAtEnt( warbird, aimEnt )
{

	warbird SetTurretTargetEnt( aimEnt );
}

MonitorLookAtEnt( warbird )
{
	self endon( "IHAVEASSUMEDCONTROL" );
	self endon( "warbirdStreakComplete" );
	
	warbird.enemy_target waittill( "death" );
	warbird.pickNewTarget = true;
	warbird.lineOfSight	  = false;
}

////=================================================================================================================//
////												AI ATTACK					                                       //
////=================================================================================================================//

WarbirdShootingThink( warbird )
{
	self endon( "IHAVEASSUMEDCONTROL" );
	self endon( "death" );
	self endon( "warbirdStreakComplete" );

	warbird.enemy_target = undefined;

	thread WarbirdFireMonitor( warbird );
	
	while ( true )
	{
		warbird waittill( "warbird_fire" );
		thread WarbirdFire( warbird );
	}
	
}

WarbirdFireMonitor( warbird )
{	
	warbird endon( "death" );
	warbird endon( "warbirdStreakComplete" );
	
	warbird waittill( "warbird_stop_firing" );
}

WarbirdFire( warbird )
{
	self endon( "IHAVEASSUMEDCONTROL" );
	self endon( "warbirdStreakComplete" );
	self endon( "death" );

	thread FireAiMg( warbird );
			
	while ( true )
	{
		if ( warbird.pickNewTarget )
		{
			allGuys		 = level.players;
			enemyTargets = [];
			
			foreach ( guy in allGuys )
			{
				if ( guy.team != self.team )
					enemyTargets = array_add( enemyTargets, guy );
			}
			
			enemyTargets = SortByDistance( enemyTargets, warbird.origin );
			
			enemy_target = undefined;
			
			foreach ( guy in enemyTargets )
			{
				if ( !IsDefined( guy ) )
					continue;
				
				if ( !IsAlive( guy ) )
					continue;
				
				enemy_target		 = guy;
				warbird.enemy_target = enemy_target;
		
				CheckWarbirdTargetLos( warbird );	
				
				break;
			}
		}	
		
		warbird notify( "LostLOS" );
		
		wait( 0.05 );
	}
}

FireAiMg( warbird )
{
	self endon( "IHAVEASSUMEDCONTROL" );
	self endon( "warbirdStreakComplete" );
	
	barrel = 0;
	
	while ( true )
	{
		if ( IsAlive( warbird.enemy_target ) && warbird.lineOfSight == true )
		{		
			warbird FireWeapon(  );	//"tag_missile_left"
		}	
		wait .02;
	}
}

CheckWarbirdTargetLos( warbird )
{
	self endon( "IHAVEASSUMEDCONTROL" );
	self endon( "warbirdStreakComplete" );
	warbird.enemy_target endon( "death" );
	
	//perform an initial check to see if we have a valid target
	turret_flash_pos = warbird GetTagOrigin( "TAG_FLASH1" );
	target_pos		 = warbird.enemy_target GetEye();
	target_dir		 = VectorNormalize( target_pos - turret_flash_pos );
	start_pos		 = turret_flash_pos + ( target_dir * 20 );
			
	if ( !SightTracePassed( start_pos, target_pos, false, warbird.enemy_target, warbird ) && !CheckTargetIsInVision( warbird ) )
	{
		warbird.lineOfSight	  = false;
		warbird.pickNewTarget = true;
		return;
	}
		
	//wait set time before attempting to fire
	wait CONST_target_aquire_time;
	
	//monitor every 2.0 seconds to make sure we still have the target
	//This LOS check being valid is the only place the AI is told to fire
	while ( true )
	{
		// occasionally check if you still have LOS to target
		turret_flash_pos = warbird GetTagOrigin( "TAG_FLASH1" );
		target_pos		 = warbird.enemy_target GetEye();
		target_dir		 = VectorNormalize( target_pos - turret_flash_pos );
		start_pos		 = turret_flash_pos + ( target_dir * 20 );
				
		if ( !SightTracePassed( start_pos, target_pos, false, warbird.enemy_target, warbird ) && !CheckTargetIsInVision( warbird ) )
		{
			warbird.lineOfSight	  = false;
			warbird.pickNewTarget = true;
			return;
		}
	
		warbird.lineOfSight = true;
		
		wait CONST_los_recheck_time;
	}
}

CheckTargetIsInVision( warbird )
{
	WarbirdForward			  = AnglesToForward( warbird.angles );
	WarbirdToEnemyLocation	  = warbird.enemy_target.origin - warbird.origin;
	DotProductToEnemyLocation = VectorDot( WarbirdForward, WarbirdToEnemyLocation );
	return DotProductToEnemyLocation < 0;
}

////=================================================================================================================//
////												PLAYER CONTROL				                                     //
////=================================================================================================================//

PlayerControllWarbirdSetup( warbird )
{
	self endon( "warbirdStreakComplete" );
	warbird endon( "WarbirdPlayerKilled" );
	
	SetupPlayerHud( warbird );
	
	WarbirdBarHide( warbird );
	
	while ( level.PossessWarbird == false )
	{
		self ToggleWarbirdControlState( warbird );
	}
	
	SetupWarbirdHud( warbird );
	
	warbird notify( "warbird_stop_firing" );
	
	waitframe();
	
	self notify( "IHAVEASSUMEDCONTROL" );

	WarbirdBarShow( warbird );
	
	self thread MonitorWarbirdSafeArea( warbird );
	
	self setUsingRemote( "Warbird" );
	result = self maps\mp\killstreaks\_killstreaks::initRideKillstreak( "warbird" );

	if ( result != "success" )
	{
		if ( result != "disconnect" )
			self clearUsingRemote();

		return false;
	}
	
	// with the way we do visionsets we need to wait for the clearRideIntro() is done before we set thermal
	self thread waitSetThermal( 1.0 );
		
	self _giveWeapon( "killstreak_remote_tank_laptop_mp" );
	self SwitchToWeapon( "killstreak_remote_tank_laptop_mp" );

	if ( IsDefined( level.PlayerAttachPoint ) )
		level.PlayerAttachPoint Delete();
	
	level.PlayerAttachPoint = Spawn( "script_model", ( 0, 0, 0 ) );
	level.PlayerAttachPoint SetModel( "tag_player" );
	level.PlayerAttachPoint Hide();
	
	WarbirdPlayerTagOrigin = ( warbird GetTagOrigin( "tag_origin" ) );
	WarbirdPlayerTagAngles = warbird GetTagAngles( "tag_origin" );
	forward				   = AnglesToForward( WarbirdPlayerTagAngles );
	
	WarbirdPlayerTagOrigin = WarbirdPlayerTagOrigin + ( forward * 165 );
	WarbirdPlayerTagOrigin += ( 0, 0, -10 );
	
	level.PlayerAttachPoint.origin = WarbirdPlayerTagOrigin;
	level.PlayerAttachPoint.angles = WarbirdPlayerTagAngles;
	
	level.PlayerAttachPoint LinkTo( warbird, "tag_player" );

	warbird VehicleTurretControlOn( self );

	self Unlink();
	
	//	link camera			
	// NOTE: the arc values don't work here when passed in to PlayerLinkWeaponViewToDelta, set them in the warbird_player_mp gdt entry
	self PlayerLinkWeaponViewToDelta( warbird, "tag_player", 1.0, 0, 0, 0, 0, true );
	self SetPlayerAngles( warbird GetTagAngles( "tag_player" ) );	

	self thread WarbirdFreeRangeMode( warbird );
	self thread WeaponSetup( warbird );
	self thread PlayerCloakMonitor( warbird );
	self MonitorAIWarbirdSwitch( warbird );	
}

ToggleWarbirdControlState( warbird )
{
	warbird endon( "WarbirdPlayerKilled" );
	self endon( "warbirdStreakComplete" );
	
	self waittill( "ToggleControlState" );
	
	self thread CancelPossessButtonPressMonitor();
	level.PossessWarbird = !level.PossessWarbird;
	
	wait 0.5;
	
	self notify( "PossessHoldTimeComplete" );
}

CancelPossessButtonPressMonitor()
{
	self endon( "warbirdStreakComplete" );
	self endon( "PossessHoldTimeComplete" );
	
	self waittill( "ToggleControlCancel" );
	
	level.PossessWarbird = !level.PossessWarbird;
}

waitSetThermal( delay )
{
	self endon( "warbirdStreakComplete" );

	wait( delay	 );

	self VisionSetThermalForPlayer( "paris_ac130_thermal", 0 );
	self ThermalVisionFOFOverlayOn();
	
	self SetBlurForPlayer( 1.1, 0 );
	
	self thread MonitorVisionMode();
}

MonitorVisionMode()
{
	self endon( "warbirdStreakComplete" );
	self endon( "ResumeWarbirdAI" );
	
	self VisionSetThermalForPlayer( "paris_ac130_thermal", 0.25 );
	
	while ( 1 )
	{
		self waittill( "SwitchVisionMode" );
		self ThermalVisionOn();
		
		self waittill( "SwitchVisionMode" );
		self ThermalVisionOff();
	}
}

//=================================================================================================================//
//												PLAYER CLOAK				                                       //
//=================================================================================================================//

PlayerCloakMonitor( warbird )
{
	self endon( "warbirdStreakComplete" );
	self endon( "ResumeWarbirdAI" );
	
	while ( true )
	{
		self thread CloakReadyDialog();
		
		warbird.HUDItem[ "Line5" ] SetText( "LB TO CLOAK" );
		
		self waittill( "Cloak" );
		
		self SwitchToCloakModel( warbird );
	
		self thread CloakActivatedDialog();
		
		warbird.HUDItem[ "Line5" ] SetText( "CLOAKED" );
		
		self thread PlayerCloakWaitForExit( warbird );
		
		self waittill( "UnCloak" );
		
		warbird.HUDItem[ "Line5" ] SetText( "CLOAK COOLDOWN" );
		
		self thread CloakDeactivatedDialog();
		
		wait CONST_cloak_cooldown_duration;
		
		self notify( "CloakCharged" );
	}
}

SwitchToCloakModel( warbird )
{
	warbird SetModel( "vehicle_xh9_warbird_mp" );
	
	thread CloakHudOn( warbird );
	
	Missile_DeleteAttractor( warbird.attractor );
}

SwitchToNormalModel( warbird )
{
	warbird SetModel( "vehicle_xh9_warbird_mp" );
	thread CloakHudOff( warbird );
	
	warbird.attractor = Missile_CreateAttractorEnt( warbird, level.heli_attract_strength, level.heli_attract_range );
}

PlayerCloakWaitForExit( warbird )
{
	self endon( "warbirdStreakComplete" );
		
	self waittill_any_timeout_no_endon_death( CONST_cloak_duration, "ForceUncloak" );
	
	self thread PlayCloakOverheatDialog();
	
	self SwitchToNormalModel( warbird );
	
	self notify( "UnCloak" );
}

CloakDeactivatedDialog()
{
	self endon( "CloakCharged" );
	self endon( "warbirdStreakComplete" );
	self endon( "ResumeWarbirdAI" );
	
	while ( true )
	{
		self waittill( "Cloak" );
		
		level.PlayerAttachPoint play_sound_on_entity( "mp_warbird_overheat_warning" );
	}
}

CloakReadyDialog()
{
	level.PlayerAttachPoint thread play_sound_on_entity( "mp_warbird_overheat_warning" );	
}

CloakActivatedDialog()
{
	level.PlayerAttachPoint thread play_sound_on_entity( "weap_warbirdrocket_reload" );
}

PlayCloakOverheatDialog()
{
	level.PlayerAttachPoint thread play_sound_on_entity( "weap_warbirdrocket_reload" );
}

AiCloakTest( warbird )
{
	self endon( "warbirdStreakComplete" );
	while ( true )
	{
		wait 10;
		
		self SwitchToCloakModel( warbird );
		
		wait 10;	
		
		self SwitchToNormalModel( warbird );
	}
}

//=================================================================================================================//
//												PLAYER MOVEMENT				                                       //
//=================================================================================================================//

// returns a vector for the player's left stick, in world coordinates, magnitude up to 1 (or sqrt(2), not sure)
GetLeftStickWorld( player_to_global_angles )
{
	Assert( IsPlayer( self ) );
	stick				= self GetNormalizedMovement();
	stick				= ( stick[ 0 ], stick[ 1 ] * -1, 0 );
	stick_player_angles = VectorToAngles( stick );
	stick_global_angles = flat_angle( CombineAngles( player_to_global_angles, stick_player_angles ) );
	return AnglesToForward( stick_global_angles ) * Length( stick );
}

WarbirdFreeRangeMode( warbird )
{
	self endon( "ResumeWarbirdAI" );
	self endon( "warbirdStreakComplete" );
	waitframe();

	inches_per_frame = CONST_free_range_speed * 17.6 * 0.05;

	heli   = warbird;
	player = self;

	target_origin = heli.origin;
	target_angles = ( 0, heli.angles[ 1 ], 0 );
	
	heli ClearLookAtEnt();
	
	while ( true )
	{
		// get a global vector for the direction the stick is pressed
		ViewAngle = Player GetPlayerAngles();
		
		FlatViewAngle = flat_angle( ViewAngle );
		left_stick	  = player GetLeftStickWorld( FlatViewAngle );
		
		// figure out where the "carrot" should be
		delta = left_stick * inches_per_frame;
		
		target_origin += delta;

		accel = CONST_smooth_heli_speed_mph_forward * CONST_smooth_heli_accel;
		decel = CONST_smooth_heli_speed_mph_forward * CONST_smooth_heli_decel;
		
		if ( Length( left_stick ) < 0.1 && Distance( target_origin, heli.origin ) < CONST_smooth_heli_hover_radius )
		{
			accel *= CONST_smooth_heli_accel_factor_while_hovering;
			decel *= CONST_smooth_heli_accel_factor_while_hovering;
		}
		
		heli Vehicle_HeliSetAI
		(
			target_origin,                   	 	//goalOrigin
			CONST_smooth_heli_speed_mph_forward,    //speed
			accel,							  		//accel
			decel, 							 		//decel
			false, //setGoalYaw
			false, //angleVehicle
			FlatViewAngle[ 1 ],			  			//yaw
			undefined,                        		//airResistance
			false,                           		//hasDelay
			true,                             		//isStopNode
			false, //isUnload
			false, //hasFlagWait
			false		//isEndOfPath
		 );

		waitframe();
	}
}

////=================================================================================================================//
////												PLAYER ATTACK				                                       //
////=================================================================================================================//
UpdateShootingLocation( warbird )
{
	self endon( "warbirdStreakComplete" );
	level endon( "ResumeWarbirdAI" );
	
	while ( true )
	{
		angles = self GetPlayerAngles();
		
		eye = level.PlayerAttachPoint.origin;
		
		forward	  = AnglesToForward( angles );
		TargetPos = eye + ( forward * 5000 );
		
		level.TargetEnt.origin = TargetPos;
		
		//ForceTurretAimAtEnt( warbird, level.TargetEnt );
		
		wait 0.05;
	}
}

MonitorWeaponSelection( warbird )
{
	self endon( "warbirdStreakComplete" );
	self endon( "ResumeWarbirdAI" );
	while ( 1 )
	{
		self waittill( "SwitchWeapon" );
		thread FireWarbirdRockets( warbird );
		self waittill( "SwitchWeapon" );
		thread MonitorWarbirdMachineGun( warbird );
	}
}

WeaponSetup( warbird )
{
	self thread UpdateShootingLocation( warbird );
	self thread MonitorWarbirdMachineGun( warbird );
	self thread FireWarbirdRockets( warbird );
}

MonitorWarbirdMachineGun( warbird )
{
	self endon( "ResumeWarbirdAI" );
	self endon( "warbirdStreakComplete" );
	warbird endon( "overheat" );
	
	warbird.weaponfire = false;

	warbird ClearTurretTarget();
	thread MachineGunOverheat( warbird );
	
	while ( true )
	{
		self waittill( "StartFire" );	
		warbird.weaponfire = true;			
		FireWarbirdMachineGuns( warbird );
		warbird.weaponfire = false;	

		wait 0.05;
	}
}

FireWarbirdMachineGuns( warbird )
{
	self endon( "StopFire" );
	self endon( "warbirdStreakComplete" );
	warbird endon( "overheat" );
	
	self notify( "ForceUncloak" );
	barrel=0;
	
	//warbird SetVehWeapon("missile_attackheli");
	
	while ( true )
	{
		warbird waittill( "turret_fire" );	
		
		Earthquake ( 0.2, 0.2, warbird.origin, 1000 );
		if(barrel==0)
		{
			barrel=1;
			warbird FireWeapon( );  //"tag_missile_left"
		}
		else if(barrel==1)
		{
			barrel=0;
			warbird FireWeapon( );	//"tag_missile_right"
		}
	}
}

MachineGunOverheat( warbird )
{
	self endon( "ResumeWarbirdAI" );
	self endon( "warbirdStreakComplete" );
	warbird.firetime = 0;

	while ( warbird.firetime < warbird.overheattime )
	{
		if ( warbird.weaponfire == true )
		{
			warbird.firetime += 0.05;
			
			WarbirdOverheatBarUpdate( warbird );
		}
		else
		{
			warbird.firetime -= 0.05;
			if ( warbird.firetime < 0 )
				warbird.firetime = 0;
			
			WarbirdOverheatBarUpdate( warbird );	
		}
		
		wait 0.05;	
	}
		
	warbird notify( "overheat" );
	MachineGunCooldown( warbird );
	
	self thread MonitorWarbirdMachineGun( warbird );
}

MachineGunCooldown( warbird )
{
	thread MachineGunCooldownSound( warbird );
	
	while (	warbird.firetime > 0 )
	{
		warbird.firetime -= 0.05;
		WarbirdOverheatBarUpdate( warbird );	
		wait 0.05;
	}

	warbird notify( "cooldowncomplete" );
}

MachineGunCooldownSound( warbird )
{
	warbird endon( "cooldowncomplete" );
	self endon( "ResumeWarbirdAI" );
	self endon( "warbirdStreakComplete" );
	
	while ( true )
	{
		if ( IsDefined( level.PlayerAttachPoint ) )
		    level.PlayerAttachPoint thread play_sound_on_entity( "mp_warbird_overheat_warning" );
		
		wait 0.5;
	}	
}

FireWarbirdRockets( warbird )
{
	self endon( "ResumeWarbirdAI" );
	self endon( "warbirdStreakComplete" );

	self notify( "EquipRockets" );
	
	warbird.RemainingRocketShots = warbird.RocketClip;
	
	WarbirdRocketHudUpdate( warbird );
	
	while ( true )
	{
		self waittill( "FireRockets" );
		
		Earthquake ( 0.4, 1, warbird.origin, 1000 );
		MagicBullet( "ac130_40mm_mp", warbird.tagFlash1.origin, level.TargetEnt.origin, self );
		MagicBullet( "ac130_40mm_mp", warbird.tagFlash2.origin, level.TargetEnt.origin, self );
		warbird.RemainingRocketShots--;
	
		self notify( "ForceUncloak" );

		WarbirdRocketHudUpdate( warbird );
				
		if ( warbird.RemainingRocketShots == 0 )
		{		
			thread WarbirdRocketReloadSound( warbird );
			wait CONST_rocket_reload_time;
			warbird.RemainingRocketShots = warbird.RocketClip;;
			self notify( "rocketReloadComplete" );
			WarbirdRocketHudUpdate( warbird );
		}
		else
		{
			wait CONST_rocket_fire_interval;
		}
	}
}

WarbirdRocketReloadSound( warbird )
{
	self endon( "rocketReloadComplete" );
	self endon( "ResumeWarbirdAI" );
	self endon( "warbirdStreakComplete" );
	
	while ( true )
	{
		if ( IsDefined( level.PlayerAttachPoint ) )
		    level.PlayerAttachPoint thread play_sound_on_entity( "weap_warbirdrocket_reload" );
		
		wait 0.5;
	}	
}

////=================================================================================================================//
////												RESUME AI FUNC				                                     //
////=================================================================================================================//

MonitorAIWarbirdSwitch( warbird )
{
	self endon( "warbirdStreakComplete" );
	warbird endon( "WarbirdPlayerKilled" );
	
	while ( level.PossessWarbird == true )
	{
		self ToggleWarbirdControlState( warbird );
	}
	
	self notify( "ResumeWarbirdAI" );

	waittillframeend;
	
	self thread WarbirdShootingThink( warbird );
	self thread EnemyWarbirdAttackMovement( warbird );
	warbird notify( "warbird_fire" );
	
	if ( self isUsingRemote() )
	{
		warbird.StaticOverlay Destroy();
		self SetBlurForPlayer( 0, 0 );
		self ThermalVisionOff();	
		self ThermalVisionFOFOverlayOff();
		warbird VehicleTurretControlOff( self );
		self Unlink();
		self clearUsingRemote();		
		//self TakeWeapon( "heli_remote_mp" );
		//self SwitchToWeapon( self getLastWeapon() );
	}

	self notify ( "heliPlayer_removed" );

	waitframe();
	
	self PlayerControllWarbirdSetup( warbird );
}

MonitorAIWarbirdDeathorTimeout( warbird )
{
	self endon( "disconnect" );
	
	warbird waittill_any( "leaving", "death", "crashing" );

	self notify( "warbirdStreakComplete" );

	waittillframeend;

	DeleteHud( warbird );
	WarbirdBarDelete( warbird );
	Missile_DeleteAttractor( warbird.attractor );
	warbird.killCamEnt Delete();
	warbird.tagFlash1 Delete();
	warbird.tagFlash2 Delete();
	warbird.enemy_target = undefined;

	if ( self isUsingRemote() )
	{	
		warbird.StaticOverlay Destroy();
		self SetBlurForPlayer( 0, 0 );
		self ThermalVisionOff();		
		self ThermalVisionFOFOverlayOff();
		warbird VehicleTurretControlOff( self );
		self Unlink();
		self clearUsingRemote();		
		self TakeWeapon( "killstreak_remote_tank_laptop_mp" );
		self SwitchToWeapon( self getLastWeapon() );
	}
	
	self notify ( "heliPlayer_removed" );
	self notify ( "StopWaitForDisconnect" );
	
	waitframe();
}

//I think this will take care of the player leaving mid match.  The warbird should just fly away and all the spawned entities should get deleted.
MonitorPlayerDisconnect( warbird )
{
	self endon ( "StopWaitForDisconnect" );
	
	self waittill( "disconnect" );
	
	self notify( "warbirdStreakComplete" );
	
	warbird thread maps\mp\killstreaks\_helicopter::heli_leave();
	
	DeleteHud( warbird );
	WarbirdBarDelete( warbird );
	
	Missile_DeleteAttractor( warbird.attractor );
	warbird.killCamEnt Delete();
	warbird.tagFlash1 Delete();
	warbird.tagFlash2 Delete();
	warbird.enemy_target = undefined;
	
	self notify ( "heliPlayer_removed" );
}

play_sound_on_entity( alias )
{
	self PlaySound( alias );
}
