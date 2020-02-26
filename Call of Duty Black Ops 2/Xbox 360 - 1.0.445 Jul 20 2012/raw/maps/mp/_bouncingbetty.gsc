#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_weaponobjects;

init()
{
	precacheModel( "t6_wpn_bouncing_betty_world" );

	level.bettyExplosionFX = loadfx( "weapon/bouncing_betty/fx_betty_explosion");
	level.bettyDestroyedFX = loadfx( "weapon/bouncing_betty/fx_betty_destroyed");
	level.bettyLaunchFX = loadfx( "weapon/bouncing_betty/fx_betty_launch_dust");
	
	level._effect["fx_betty_friendly_light"] = loadfx( "weapon/bouncing_betty/fx_betty_light_green" );
	level._effect["fx_betty_enemy_light"] = loadfx( "weapon/bouncing_betty/fx_betty_light_red" );

	level.bettyMinDist = 20;
	level.bettyGracePeriod = .7;
	level.bettyRadius = 192;
	level.bettyStunTime = 5;

	level.bettyDamageRadius = 256;
	level.bettyDamageMax = 210;
	level.bettyDamageMin = 70;

	level.bettyJumpHeight = 70;
	level.bettyJumpTime = 0.65;
	level.bettyRotateVelocity = (0, 750, 32);

	level.bettyActivationDelay = 0.1;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
createBouncingBettyWatcher() // self == player
{
	watcher = self createProximityWeaponObjectWatcher( "bouncingbetty", "bouncingbetty_mp", self.team );
	
	watcher.onSpawn = ::onSpawnBouncingBetty;
	watcher.watchForFire = true;
	watcher.detonate = ::bouncingBettyDetonate;
	//Eckert - playing sound later
	//watcher.activateSound = "fly_betty_exp";
	watcher.activateSound = "wpn_claymore_alert";
	watcher.hackable = true;
	watcher.reconModel = "t6_wpn_bouncing_betty_world_detect";
	watcher.ownerGetsAssist = true;
	watcher.ignoreDirection = true;
	
	watcher.detectionMinDist = level.bettyMinDist;
	watcher.detectionGracePeriod = level.bettyGracePeriod;
	watcher.detonateRadius = level.bettyRadius;
	
	watcher.stun = ::weaponStun;
	watcher.stunTime = level.bettyStunTime;

	watcher.activationDelay = level.bettyActivationDelay;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
onSpawnBouncingBetty( watcher, owner ) // self == betty ent
{
	onSpawnProximityWeaponObject( watcher, owner );
	
	self thread spawnMineMover();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
spawnMineMover() // self == betty ent
{
	self waitTillNotMoving();

	mineMover = Spawn( "script_model", self.origin );
	mineMover.angles = self.angles;
	mineMover SetModel( "tag_origin" );
	mineMover.owner = self.owner;

	self.mineMover = mineMover;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
bouncingBettyDetonate(attacker, weaponName) // self == betty
{
	from_emp = maps\mp\killstreaks\_emp::isEmpWeapon( weaponName );

	if ( IsDefined( weaponName ))
	{
		if ( IsDefined( attacker ) )
		{
			if ( ( level.teambased && attacker.team != self.owner.team ) || ( attacker != self.owner ) ) 
			{
				// tagTMR<TODO>: need betty score event
				attacker maps\mp\_challenges::destroyedExplosive();
				maps\mp\_scoreevents::processScoreEvent( "destroyed_claymore", attacker, self.owner, weaponName );
			}
		}

		self bouncingBettyDestroyed();
	}
	else
	{
		/#assert( IsDefined( self.mineMover ));#/
		self.mineMover SetModel( self.model );
		self.mineMover thread bouncingBettyJumpAndExplode();
		self delete();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
bouncingBettyDestroyed(  ) // self == betty
{
	PlayFX( level.bettyDestroyedFX, self.origin );
	PlaySoundAtPosition ( "dst_equipment_destroy", self.origin );
	
	if ( isDefined( self.trigger ) )
	{
		self.trigger delete();
	}

	if ( isDefined( self.mineMover ))
	{
		self.mineMover delete();
	}

	self delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
bouncingBettyJumpAndExplode() // self == script mover spawned at weaponobject location
{	
	explodePos = self.origin + (0, 0, level.bettyJumpHeight );
	self MoveTo( explodePos, 0.7, 0, level.bettyJumpTime );
	
	//self.killCamEnt MoveTo( explodePos + self.killCamOffset, 0.7, 0, .65 );

	playfx (level.bettyLaunchFX, self.origin);
	self RotateVelocity( level.bettyRotateVelocity, 0.7, 0, level.bettyJumpTime );
	//self thread playSpinnerFX();	
	self playsound ( "fly_betty_jump" );

	wait( level.bettyJumpTime );	

	self thread mineExplode();
}

mineExplode()
{
	if ( !isDefined( self ) || !isDefined(self.owner) )
		return;
	
	self playsound( "fly_betty_explo" );
	//playFXontag( level.mine_explode, self, "tag_fx" );
	
	wait( 0.05 ); // needed or the effect doesn't play
	if ( !isDefined( self ) || !isDefined(self.owner) )
		return;
	
	self hide();
	self RadiusDamage( self.origin, level.bettyDamageRadius, level.bettyDamageMax, level.bettyDamageMin, self.owner, "MOD_EXPLOSIVE", "bouncingbetty_mp" );
	playfx(level.bettyExplosionFX, self.origin);
	
	wait( 0.2 ); 
	if ( !isDefined( self ) || !isDefined(self.owner) )
		return;
	
	if ( isDefined( self.trigger ) )
		self.trigger delete();
	
	//self.killCamEnt delete();
	self delete();
}

