#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




	
#precache( "fx", "weapon/fx_betty_exp_destroyed" );
#precache( "fx", "weapon/fx_betty_light_blue" );
#precache( "fx", "weapon/fx_betty_light_orng" );
	
#precache( "model", "wpn_t7_grenade_incendiary_world" );


#using_animtree ( "bouncing_betty" );


#namespace bouncingbetty;

function init_shared()
{
	level.bettyDestroyedFX = "weapon/fx_betty_exp_destroyed";

	level._effect["fx_betty_friendly_light"] = "weapon/fx_betty_light_blue";
	level._effect["fx_betty_enemy_light"] = "weapon/fx_betty_light_orng";

	level.bettyMinDist = 20;
	level.bettyStunTime = 1;
	
	bettyExplodeAnim = %o_spider_mine_detonate;
	bettyDeployAnim = %o_spider_mine_deploy;

	level.bettyRadius = getDvarInt( "betty_detect_radius", 180 );
	level.bettyActivationDelay = getDvarFloat( "betty_activation_delay", 0.1 );
	level.bettyGracePeriod = getDvarFloat( "betty_grace_period", 0.3 );
	level.bettyDamageRadius = getDvarInt( "betty_damage_radius", 180 );
	level.bettyDamageMax = getDvarInt( "betty_damage_max", 180 );
	level.bettyDamageMin = getDvarInt( "betty_damage_min", 70 );
	level.bettyDamageHeight = getDvarInt( "betty_damage_cylinder_height", 200 );

	level.bettyJumpHeight = getDvarInt( "betty_jump_height_onground", 55 );
	level.bettyJumpHeightWall = getDvarInt( "betty_jump_height_wall", 20 );
	level.bettyJumpHeightWallAngle = getDvarInt( "betty_onground_angle_threshold", 30 );
	level.bettyJumpHeightWallAngleCos = cos( level.bettyJumpHeightWallAngle ); 
	level.bettyJumpTime = getDvarFloat( "betty_jump_time", 0.75 );
	
	level.bettyBombletSpawnDistance = 20;
	level.bettyBombletCount = 4;
	
	level thread register();
	/#
		level thread bouncingBettyDvarUpdate();
	#/
	
	callback::add_weapon_watcher( &createBouncingBettyWatcher );
}

function register()
{
	clientfield::register( "missile", "bouncingbetty_state", 1, 2, "int" );
	clientfield::register( "scriptmover", "bouncingbetty_state", 1, 2, "int" );
}

/#
function bouncingBettyDvarUpdate()
{
	for(;;)
	{
		level.bettyRadius = getDvarInt( "betty_detect_radius", level.bettyRadius );
		level.bettyActivationDelay = getDvarFloat( "betty_activation_delay", level.bettyActivationDelay );
		level.bettyGracePeriod = getDvarFloat( "betty_grace_period", level.bettyGracePeriod );
		level.bettyDamageRadius = getDvarInt( "betty_damage_radius", level.bettyDamageRadius );
		level.bettyDamageMax = getDvarInt( "betty_damage_max", level.bettyDamageMax );
		level.bettyDamageMin = getDvarInt( "betty_damage_min", level.bettyDamageMin );
		level.bettyDamageHeight = getDvarInt( "betty_damage_cylinder_height", level.bettyDamageHeight );
		level.bettyJumpHeight = getDvarInt( "betty_jump_height_onground", level.bettyJumpHeight );
		level.bettyJumpHeightWall = getDvarInt( "betty_jump_height_wall", level.bettyJumpHeightWall );
		level.bettyJumpHeightWallAngle = getDvarInt( "betty_onground_angle_threshold", level.bettyJumpHeightWallAngle );
		level.bettyJumpHeightWallAngleCos = cos( level.bettyJumpHeightWallAngle );
		level.bettyJumpTime = getDvarFloat( "betty_jump_time", level.bettyJumpTime );
		wait( 3 );
	}
}
#/

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function createBouncingBettyWatcher() // self == player
{
	watcher = self weaponobjects::createProximityWeaponObjectWatcher( "bouncingbetty", self.team );
	
	watcher.onSpawn =&onSpawnBouncingBetty;
	watcher.watchForFire = true;
	watcher.onDetonateCallback =&bouncingBettyDetonate;
	//Eckert - playing sound later
	//watcher.activateSound = "fly_betty_exp";
	watcher.activateSound = "wpn_betty_alert";
	watcher.hackable = true;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.ownerGetsAssist = true;
	watcher.ignoreDirection = true;
	watcher.immediateDetonation = true;
	watcher.immunespecialty = "specialty_immunetriggerbetty";
	
	watcher.detectionMinDist = level.bettyMinDist;
	watcher.detectionGracePeriod = level.bettyGracePeriod;
	watcher.detonateRadius = level.bettyRadius;
	
	watcher.stun =&weaponobjects::weaponStun;
	watcher.stunTime = level.bettyStunTime;

	watcher.activationDelay = level.bettyActivationDelay;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function onSpawnBouncingBetty( watcher, owner ) // self == betty ent
{
	weaponobjects::onSpawnProximityWeaponObject( watcher, owner );
	self thread spawnMineMover();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function spawnMineMover() // self == betty ent
{
	self endon( "death" );
	self util::waitTillNotMoving();
	self clientfield::set( "bouncingbetty_state", 2 );

	self UseAnimTree( #animtree );
	self SetAnim( %o_spider_mine_deploy, 1.0, 0.0, 1.0 );

	mineMover = spawn( "script_model", self.origin );
	mineMover.angles = self.angles;
	mineMover SetModel( "tag_origin" );
	mineMover.owner = self.owner;
	mineMover.killCamOffset = ( 0, 0, GetDvarFloat( "scr_bouncing_betty_killcam_offset", 8.0 ) );
	mineMover.weapon = self.weapon;
	mineMover playsound ("wpn_betty_arm");
	
	killcamEnt = spawn( "script_model", mineMover.origin + mineMover.killCamOffset );
	killcamEnt.angles = ( 0,0,0 );
	killcamEnt SetModel( "tag_origin" );
	killcamEnt SetWeapon( self.weapon );

	mineMover.killcamEnt = killcamEnt;
	
	self.mineMover = mineMover;

	self thread killMineMoverOnPickup();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function killMineMoverOnPickup() // self == betty ent
{
	self.mineMover endon( "death" );

	self util::waittill_any( "picked_up", "hacked" );

	self killMineMover();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function killMineMover() // self == betty ent
{
	if ( isdefined( self.mineMover ))
	{
		if ( isdefined( self.mineMover.killcamEnt ) )
		{
			self.mineMover.killcamEnt delete();
		}
		self.mineMover delete();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function bouncingBettyDetonate( attacker, weapon, target ) // self == betty
{
	if ( IsDefined( weapon ) && weapon.isValid )
	{
		if ( isdefined( attacker ) )
		{
			if ( self.owner util::IsEnemyPlayer( attacker ) )
			{
				attacker challenges::destroyedExplosive( weapon );
				scoreevents::processScoreEvent( "destroyed_bouncingbetty", attacker, self.owner, weapon );
			}
		}

		self bouncingBettyDestroyed();
	}
	else if ( isdefined( self.mineMover ))
	{
		self.mineMover SetModel( self.model );
		self.mineMover thread bouncingBettyJumpAndExplode();
		self delete();
	}
	else
	{
		// tagTMR<NOTE>: special case where betty hasn't settled yet but something has triggered a detonate
		// i.e. the moving platforms doors on drone, etc
		self bouncingBettyDestroyed();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function bouncingBettyDestroyed(  ) // self == betty
{
	PlayFX( level.bettyDestroyedFX, self.origin );
	PlaySoundAtPosition ( "dst_equipment_destroy", self.origin );
	
	if ( isdefined( self.trigger ) )
	{
		self.trigger delete();
	}

	self killMineMover();

	self RadiusDamage( self.origin, 128, 110, 10, self.owner, "MOD_EXPLOSIVE", self.weapon );

	self delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function bouncingBettyJumpAndExplode() // self == script mover spawned at weaponobject location
{	
	jumpDir = VectorNormalize( AnglesToUp( self.angles ) );
	
	if ( jumpDir[2] > level.bettyJumpHeightWallAngleCos )
	{
		jumpHeight = level.bettyJumpHeight;
	}
	else
	{
		jumpHeight = level.bettyJumpHeightWall;
	}
	
	explodePos = self.origin + jumpDir * jumpHeight;
	
	self.killCamEnt MoveTo( explodePos + self.killCamOffset, level.bettyJumpTime, 0, level.bettyJumpTime );

	self clientfield::set( "bouncingbetty_state", 1 );

	wait( level.bettyJumpTime );	

	self thread mineExplode( jumpDir, explodePos );
}


function mineExplode( explosionDir, explodePos )
{
	if ( !isdefined( self ) || !isdefined( self.owner ) )
		return;
	
	self playsound( "wpn_betty_explo" );

	self clientfield::set( "sndRattle", 1 );
	
	{wait(.05);}; // needed or the effect doesn't play
	if ( !isdefined( self ) || !isdefined(self.owner) )
		return;
	
	self CylinderDamage( explosionDir * level.bettyDamageHeight, explodePos, level.bettyDamageRadius, level.bettyDamageRadius, level.bettyDamageMax, level.bettyDamageMin, self.owner, "MOD_EXPLOSIVE", self.weapon );
	self ghost();
	
	wait( 0.1 ); 
	
	
	if ( !isdefined( self ) || !isdefined(self.owner) )
		return;
	
	if ( isdefined( self.trigger ) )
		self.trigger delete();
	
	self.killCamEnt delete();
	self delete();
}

