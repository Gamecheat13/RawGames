#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	precacheShader( "gfx_fxt_fx_screen_droplets_02" );
	precacheRumble( "proximity_grenade" );
	
	level._effect["prox_grenade_friendly_default"] = loadfx( "weapon/grenade/fx_prox_grenade_scan_grn" );
	level._effect["prox_grenade_friendly_warning"] = loadfx( "weapon/grenade/fx_prox_grenade_wrn_grn" );
	level._effect["prox_grenade_enemy_default"] = loadfx( "weapon/grenade/fx_prox_grenade_scan_red" );
	level._effect["prox_grenade_enemy_warning"] = loadfx( "weapon/grenade/fx_prox_grenade_wrn_red" );

	level.proximityGrenadeDetectionRadius = weapons_get_dvar_int( "scr_proximityGrenadeDetectionRadius", "150" );
	level.proximityGrenadeGracePeriod = weapons_get_dvar( "scr_proximityGrenadeGracePeriod", "0.7" );
	level.proximityGrenadeDamageRadius = weapons_get_dvar_int( "scr_proximityGrenadeDamageRadius", "200" );
	level.proximityGrenadeDOTDamageAmount = weapons_get_dvar_int( "scr_proximityGrenadeDOTDamageAmount", "15" );
	level.proximityGrenadeDOTDamageAmountHardcore = weapons_get_dvar_int( "scr_proximityGrenadeDOTDamageAmountHardcore", "5" );
	level.proximityGrenadeDOTDamageTime = weapons_get_dvar( "scr_proximityGrenadeDOTDamageTime", "2.1" );
	level.proximityGrenadeDOTDamageInstances = weapons_get_dvar_int( "scr_proximityGrenadeDOTDamageInstances", "2" );
	level.proximityGrenadeMaxInstances = weapons_get_dvar_int( "scr_proximityGrenadeMaxInstances", "2" );
	level.proximityGrenadeEffectDebug = weapons_get_dvar_int( "scr_proximityGrenadeEffectDebug", "0" );

	level.poisonFXDuration = 6;

	/#
	level thread updateDvars();
	#/
	
}

updateDvars()
{
	while(1)
	{
		level.proximityGrenadeDetectionRadius = weapons_get_dvar_int( "scr_proximityGrenadeDetectionRadius", level.proximityGrenadeDetectionRadius );
		level.proximityGrenadeGracePeriod = weapons_get_dvar( "scr_proximityGrenadeGracePeriod", level.proximityGrenadeGracePeriod );
		level.proximityGrenadeDamageRadius = weapons_get_dvar_int( "scr_proximityGrenadeDamageRadius", level.proximityGrenadeDamageRadius );
		level.proximityGrenadeDOTDamageAmount = weapons_get_dvar_int( "scr_proximityGrenadeDOTDamageAmount", level.proximityGrenadeDOTDamageAmount );
		level.proximityGrenadeDOTDamageAmountHardcore = weapons_get_dvar_int( "scr_proximityGrenadeDOTDamageAmountHardcore", level.proximityGrenadeDOTDamageAmountHardcore );
		level.proximityGrenadeDOTDamageTime = weapons_get_dvar( "scr_proximityGrenadeDOTDamageTime", level.proximityGrenadeDOTDamageTime );
		level.proximityGrenadeDOTDamageInstances = weapons_get_dvar_int( "scr_proximityGrenadeDOTDamageInstances", level.proximityGrenadeDOTDamageInstances );
		level.proximityGrenadeMaxInstances = weapons_get_dvar_int( "scr_proximityGrenadeMaxInstances", level.proximityGrenadeMaxInstances );
		level.proximityGrenadeEffectDebug = weapons_get_dvar_int( "scr_proximityGrenadeEffectDebug", level.proximityGrenadeEffectDebug );

		wait(1.0);
	}
}

createProximityGrenadeWatcher() // self == player
{
	watcher = self maps\mp\gametypes\_weaponobjects::createProximityWeaponObjectWatcher( "proximityGrenade", "proximity_grenade_mp", self.team );
	watcher.watchForFire = true;
	watcher.hackable = false;
	watcher.headIcon = false;
	watcher.reconModel = "t6_wpn_grenade_proximity_world_detect";
	watcher.activateFx = true;
	watcher.ownerGetsAssist = true;
	watcher.ignoreDirection = true;
	watcher.immediateDetonation = true;
	watcher.detectionGracePeriod = level.proximityGrenadeGracePeriod;
	watcher.detonateRadius = level.proximityGrenadeDetectionRadius;
	watcher.stun = maps\mp\gametypes\_weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.detonate = maps\mp\gametypes\_weaponobjects::weaponDetonate;
}

watchProximityGrenadeDetonation( owner ) // self = grenade
{	
	self SetOwner( owner );
	self SetTeam( owner.team );
	self playloopsound ("wpn_pgrenade_idle");
	
	origin = self.origin;
	
	self waittill( "explode", position, surface );
	
	PlaySoundAtPosition( "wpn_pgrenade_burst", origin );

	killCamEnt = spawn( "script_model", position );
	killCamEnt deleteAfterTime( 15.0 );

	players = GET_PLAYERS();

	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]))
			continue;
		
		// if this is not hardcore then don't affect teammates
		if ( level.friendlyfire == 0 )
		{
			if ( players[i] != owner )				
			{
				if ( !isdefined (owner) || !isdefined( owner.team ) )
					continue;
				if ( level.teambased && players[i].team == owner.team )
					continue;
			}
		}

		tracePassed = BulletTracePassed( position, players[i] GetEye(), false, undefined );

		distanceToGrenade = distance( players[i].origin, position );
		
		// check for the gas mask perk
		if ( !( players[i] hasPerk ("specialty_proximityprotection") ) && tracePassed && distanceToGrenade < level.proximityGrenadeDamageRadius )
		{
			players[i] performHudEffects( position, distanceToGrenade );
			
			if ( !level.proximityGrenadeEffectDebug )
			{
				players[i] thread damagePlayerInRadius( position, owner, killCamEnt );
			}
		}
	}
}	

performHudEffects( position, distanceToGrenade )
{
	forwardVec = VectorNormalize( AnglesToForward( self.angles ) );
	rightVec = VectorNormalize( AnglesToRight( self.angles ) );
	explosionVec = VectorNormalize( position - self.origin );
	
	fDot = VectorDot( explosionVec, forwardVec );
	rDot = VectorDot( explosionVec, rightVec );

	fAngle = ACos( fDot );
	rAngle = ACos( rDot );
	
	self LUINotifyEvent( &"prox_grenade_notify", 3, int( fAngle ), int( rAngle ), int( distanceToGrenade ) );
}

damagePlayerInRadius( position, owner, killCamEnt ) // self = player in radius
{
	self notify( "proximityGrenadeDamageStart" );
	self endon( "proximityGrenadeDamageStart" );
	self endon( "disconnect" );
	self endon( "death" );

	self thread watch_death();

	self thread splashfx();

	proximityShockSound = spawn ("script_origin",(0,0,1));
	proximityShockSound thread deleteEntOnOwnerDeath( self );
	proximityShockSound.origin = position;
	proximityShockSound playsound( level.sound_shock_tabun_start );
	proximityShockSound playLoopSound ( level.sound_shock_tabun_loop );

	damage = level.proximityGrenadeDOTDamageAmount;
	//has_shocked_player = false;

	if( level.hardcoreMode )
	{
		damage = level.proximityGrenadeDOTDamageAmountHardcore;
	}

	if ( self mayApplyScreenEffect() )
	{
		shellshock_duration = level.proximityGrenadeDOTDamageTime * level.proximityGrenadeDOTDamageInstances;
		self shellshock("proximity_grenade", shellshock_duration );
	}
	self playrumbleonentity("proximity_grenade");

	self setClientUIVisibilityFlag( "hud_visible", 0 );

	for ( i = 0; i < level.proximityGrenadeDOTDamageInstances; i++ )
	{
		//if ( self mayApplyScreenEffect() )
		//{
			//self setClientUIVisibilityFlag( "hud_visible", 0 );
			//if (has_shocked_player == false)
			//{
			//	self shellshock("proximity_grenade",5);
			//	self playrumbleonentity("proximity_grenade");
			//	has_shocked_player = true;
			//}
		//}

		wait( level.proximityGrenadeDOTDamageTime );
		self DoDamage( damage, position, owner, killCamEnt, "none", "MOD_GAS", 0, "proximity_grenade_mp" );

		//self thread damageblur();
	}

	proximityShockSound StopLoopSound( 0.5 );
    wait( 0.2 );
	thread playSoundinSpace( level.sound_shock_tabun_stop, position );	
	proximityShockSound notify( "deleteSound" );

	self setClientUIVisibilityFlag( "hud_visible", 1 );
}

deleteEntOnOwnerDeath( owner )
{
	self thread deleteEntOnTimeout();
	self thread deleteEntAfterTime();
	self endon( "delete" );
	owner waittill( "death" );
	self notify( "deleteSound" );
}

deleteEntAfterTime()
{
	self endon( "delete" );
	wait( 10.0 );
	self notify( "deleteSound" );
}

deleteEntOnTimeout()
{
	self endon( "delete" );
	self waittill( "deleteSound" );
	self delete();
}

watch_death() // self == player
{	
	// fail safe stuff for if the player dies
	self waittill("death");
	//visionSetNaked( GetDvar( "mapname" ), 0 );
	self StopRumble( "proximity_grenade" );
	self setblur(0,0);
	self setClientUIVisibilityFlag( "hud_visible", 1 );
}

watchDestroySplashFX() // self == splashFX
{
	self waittill( "destroy_splashFX" );
	self destroy();
}

endSplashFxOnDeath( splashfx ) // self == player
{
	self waittill("death");
	splashfx notify( "destroy_splashFX" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
createSplashFXHudElem() // self == player
{
	splashfx = NewclientHudElem(self);
	splashfx.horzAlign = "fullscreen";
	splashfx.vertAlign = "fullscreen";
	splashfx.foreground = false; 
	splashfx.sort = 0;
	splashfx setShader( "gfx_fxt_fx_screen_droplets_02", 640, 480 );
	splashfx.alpha = 0;
	splashfx FadeOverTime(0.1);
	splashfx.alpha = 1;

	return splashfx;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
rampMovementSpeed( goal, rate ) // self == player
{
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
splashfx() // self == player
{
	self endon( "death" );

	const time_between_splash_poison = 0.3;
	const time_splash_fadeout = 4.0;

	splashfx_hud = self createSplashFXHudElem();
	splashfx_hud thread watchDestroySplashFX();
	self thread endSplashFxOnDeath( splashfx_hud );

	self thread rampMovementSpeed( 0.6, .1 ); // rate is in movement speed percent / second

	wait time_between_splash_poison;

	// self thread ProximityGrenadeStartPoison();
	self playrumbleonentity("damage_heavy");

	splashfx_hud FadeOverTime( time_splash_fadeout );
	splashfx_hud.alpha = 0;

	self thread rampMovementSpeed( 1.0, .1 ); // rate is in movement speed percent / second

	wait time_splash_fadeout;

	splashfx_hud notify( "destroy_splashFX" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
ProximityGrenadeStartPoison()
{
	self startpoisoning();
	wait level.poisonFXDuration;
	self stoppoisoning();
}

start_poison()
{
	self notify ("startpoison");
	self endon ("startpoison");
	self thread stop_poison();
	
	const daze_duration = 6; // much match clientscript in _explode.csc
	
	setdvar("r_poisonFX_debug_amount", "1");
	setdvar("r_poisonFX_dvisionX", "17");
	setdvar("r_poisonFX_dvisionY", "15");
	setdvar("r_poisonFX_pulse", "2");
	setdvar("r_poisonFX_warpX", ".07");
	setdvar("r_poisonFX_warpY", "0.25");
	self startpoisoning();
	
	clientnotify("pg_daze");
	wait 6;
	
	self stoppoisoning();
	self notify ("stop_poison");
}


stop_poison()
{
	self endon ("stop_poison");
	self waittill ("death");
	self stoppoisoning();
}