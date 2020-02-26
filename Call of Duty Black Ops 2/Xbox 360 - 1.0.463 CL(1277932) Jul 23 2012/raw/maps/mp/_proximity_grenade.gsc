#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	precacheShader( "gfx_fxt_fx_screen_droplets_02" );
	precacheRumble( "proximity_grenade" );
	precacheitem("proximity_grenade_aoe_mp");
	
	level._effect["prox_grenade_friendly_default"] = loadfx( "weapon/grenade/fx_prox_grenade_scan_grn" );
	level._effect["prox_grenade_friendly_warning"] = loadfx( "weapon/grenade/fx_prox_grenade_wrn_grn" );
	level._effect["prox_grenade_enemy_default"] = loadfx( "weapon/grenade/fx_prox_grenade_scan_red" );
	level._effect["prox_grenade_enemy_warning"] = loadfx( "weapon/grenade/fx_prox_grenade_wrn_red" );
	level._effect["prox_grenade_player_shock"] = loadfx( "weapon/grenade/fx_prox_grenade_impact_player_spwner" );

	level.proximityGrenadeDetectionRadius = weapons_get_dvar_int( "scr_proximityGrenadeDetectionRadius", "150" );
	level.proximityGrenadeGracePeriod = weapons_get_dvar( "scr_proximityGrenadeGracePeriod", 0.1 );
	level.proximityGrenadeDamageRadius = weapons_get_dvar_int( "scr_proximityGrenadeDamageRadius", "200" );
	level.proximityGrenadeDOTDamageAmount = weapons_get_dvar_int( "scr_proximityGrenadeDOTDamageAmount", "5" );
	level.proximityGrenadeDOTDamageAmountHardcore = weapons_get_dvar_int( "scr_proximityGrenadeDOTDamageAmountHardcore", "1" );
	level.proximityGrenadeDOTDamageTime = weapons_get_dvar( "scr_proximityGrenadeDOTDamageTime", 0.15 );
	level.proximityGrenadeDOTDamageInstances = weapons_get_dvar_int( "scr_proximityGrenadeDOTDamageInstances", "4" );
	level.proximityGrenadeMaxInstances = weapons_get_dvar_int( "scr_proximityGrenadeMaxInstances", "3" );
	level.proximityGrenadeEffectDebug = weapons_get_dvar_int( "scr_proximityGrenadeEffectDebug", "0" );
	level.proximityGrenadeActivationTime = weapons_get_dvar( "scr_proximityGrenadeActivationTime", .1 );

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
		level.proximityGrenadeActivationTime = weapons_get_dvar( "scr_proximityGrenadeActivationTime", level.proximityGrenadeActivationTime );

		wait(1.0);
	}
}

createProximityGrenadeWatcher() // self == player
{
	watcher = self maps\mp\gametypes\_weaponobjects::createProximityWeaponObjectWatcher( "proximity_grenade", "proximity_grenade_mp", self.team );
	watcher.watchForFire = true;
	watcher.hackable = true;
	watcher.headIcon = false;
	watcher.reconModel = "t6_wpn_taser_mine_world_detect";
	watcher.activateFx = true;
	watcher.ownerGetsAssist = true;
	watcher.ignoreDirection = true;
	watcher.immediateDetonation = true;
	watcher.detectionGracePeriod = level.proximityGrenadeGracePeriod;
	watcher.detonateRadius = level.proximityGrenadeDetectionRadius;
	watcher.stun = maps\mp\gametypes\_weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.detonate = ::proximityDetonate;
	watcher.activationDelay = level.proximityGrenadeActivationTime;

	watcher.onSpawn = ::onSpawnProximityWeaponObject;
}

proximityDetonate(attacker, weaponName )
{
	from_emp = maps\mp\killstreaks\_emp::isEmpWeapon( weaponName );
	if ( !IsDefined( from_emp ) || !from_emp )
	{
		self.killCamEnt = spawn( "script_model", self.origin );
		self.killCamEnt deleteAfterTime( 1 + level.proximityGrenadeDOTDamageTime * level.proximityGrenadeDOTDamageInstances);
	}
	
	maps\mp\gametypes\_weaponobjects::weaponDetonate( attacker, weaponName );
}

proximityGrenadeHitPlayer( eAttacker, eInflictor )
{
	// check for the gas mask perk
	if ( !( self hasPerk ("specialty_proximityprotection") ) )
	{
		if ( !level.proximityGrenadeEffectDebug )
		{
			self thread damagePlayerInRadius( eInflictor.origin, eAttacker, eInflictor.killCamEnt );
		}
	}
}

watchProximityGrenadeDetonation( owner ) // self = grenade
{	
	self SetOwner( owner );
	self SetTeam( owner.team );
	
	origin = self.origin;
	
	self waittill( "explode", position, surface );

	killCamEnt = spawn( "script_model", position );
	killCamEnt deleteAfterTime( 15.0 );
}	

watchProximityGrenadeHitPlayer( owner ) // self = grenade
{	
	self endon( "death" );	
	
	self SetOwner( owner );
	self SetTeam( owner.team );

	while( 1 )
	{
		self waittill("grenade_bounce", pos, normal, ent, surface);
	
		if ( isdefined(ent) && isplayer( ent ) && surface != "riotshield" )
		{
			self proximityDetonate(self.owner, undefined);
			return;
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
}

damagePlayerInRadius( position, owner, killCamEnt ) // self = player in radius
{
	self notify( "proximityGrenadeDamageStart" );
	self endon( "proximityGrenadeDamageStart" );
	self endon( "disconnect" );
	self endon( "death" );

	self thread watch_death();

	if ( isDefined( killCamEnt ))
	{
		killCamEnt.soundMod = "taser_spike";
	}
	
	damage = level.proximityGrenadeDOTDamageAmount;
	
	PlayFxOnTag( level._effect["prox_grenade_player_shock"], self, "J_SpineUpper" );

	if( level.hardcoreMode )
	{
		damage = level.proximityGrenadeDOTDamageAmountHardcore;
	}

	if ( self mayApplyScreenEffect() )
	{
		shellshock_duration = 1.5;
		self shellshock("proximity_grenade", shellshock_duration, false );
	}
	self playrumbleonentity("proximity_grenade");
	self PlaySound( "wpn_taser_mine_zap" );

	self setClientUIVisibilityFlag( "hud_visible", 0 );

	for ( i = 0; i < level.proximityGrenadeDOTDamageInstances; i++ )
	{
		wait( level.proximityGrenadeDOTDamageTime );
		assert( isdefined( self ) );
		assert( isdefined( owner ) );
		assert( isdefined( killCamEnt ) );
		self DoDamage( damage, position, owner, killCamEnt, "none", "MOD_GAS", 0, "proximity_grenade_aoe_mp" );
	}

	wait( 0.85 );

	self shellshock("proximity_grenade_exit", 0.6, false );
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
	self StopRumble( "proximity_grenade" );
	self setblur(0,0);
	self setClientUIVisibilityFlag( "hud_visible", 1 );
	//self setEMPJammed( false );
}
