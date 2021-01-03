#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "material", "gfx_fxt_fx_screen_droplets_02" );
#precache( "fx", "weapon/fx_prox_grenade_scan_blue" );
#precache( "fx", "weapon/fx_prox_grenade_wrn_grn" );
#precache( "fx", "weapon/fx_prox_grenade_scan_orng" );
#precache( "fx", "weapon/fx_prox_grenade_wrn_red" );
#precache( "fx", "weapon/fx_prox_grenade_impact_player_spwner" );
#precache( "fx", "weapon/fx_prox_grenade_elec_jump" );

#namespace proximity_grenade;

function init_shared()
{
	level._effect["prox_grenade_friendly_default"] = "weapon/fx_prox_grenade_scan_blue";
	level._effect["prox_grenade_friendly_warning"] = "weapon/fx_prox_grenade_wrn_grn";
	level._effect["prox_grenade_enemy_default"] = "weapon/fx_prox_grenade_scan_orng";
	level._effect["prox_grenade_enemy_warning"] = "weapon/fx_prox_grenade_wrn_red";
	level._effect["prox_grenade_player_shock"] = "weapon/fx_prox_grenade_impact_player_spwner";
	level._effect["prox_grenade_chain_bolt"] = "weapon/fx_prox_grenade_elec_jump";

	level.proximityGrenadeDetectionRadius = GetDvarInt( "scr_proximityGrenadeDetectionRadius", 150 );
	level.proximityGrenadeGracePeriod = GetDvarFloat( "scr_proximityGrenadeGracePeriod", 0.35 );
	level.proximityGrenadeDOTDamageAmount = GetDvarInt( "scr_proximityGrenadeDOTDamageAmount", 1 );
	level.proximityGrenadeDOTDamageAmountHardcore = GetDvarInt( "scr_proximityGrenadeDOTDamageAmountHardcore", 1 );
	level.proximityGrenadeDOTDamageTime = GetDvarFloat( "scr_proximityGrenadeDOTDamageTime", 0.15 );
	level.proximityGrenadeDOTDamageInstances = GetDvarInt( "scr_proximityGrenadeDOTDamageInstances", 4 );
	level.proximityGrenadeActivationTime = GetDvarFloat( "scr_proximityGrenadeActivationTime", .1 );
	level.proximityChainDebug = GetDvarInt( "scr_proximityChainDebug", 0 );
	level.proximityChainGracePeriod = GetDvarInt( "scr_proximityChainGracePeriod", 2500 );
	level.proximityChainBoltSpeed = GetDvarFloat( "scr_proximityChainBoltSpeed", 400.0 );
	level.proximityGrenadeProtectedTime = GetDvarFloat( "scr_proximityGrenadeProtectedTime", 0.45 );

	level.poisonFXDuration = 6;
	
	level thread register();
	
	callback::on_spawned( &on_player_spawned );
	
	callback::add_weapon_damage( GetWeapon( "proximity_grenade" ), &on_damage );

	/#
	level thread updateDvars();
	#/
}

//******************************************************************
//                                                                 *s
//                                                                 *
//******************************************************************
function register()
{
	clientfield::register( "toplayer", "tazered", 1, 1, "int" );
}

function updateDvars()
{
	while(1)
	{
		level.proximityGrenadeDetectionRadius = GetDvarInt( "scr_proximityGrenadeDetectionRadius", level.proximityGrenadeDetectionRadius );
		level.proximityGrenadeGracePeriod = GetDvarFloat( "scr_proximityGrenadeGracePeriod", level.proximityGrenadeGracePeriod );
		level.proximityGrenadeDOTDamageAmount = GetDvarInt( "scr_proximityGrenadeDOTDamageAmount", level.proximityGrenadeDOTDamageAmount );
		level.proximityGrenadeDOTDamageAmountHardcore = GetDvarInt( "scr_proximityGrenadeDOTDamageAmountHardcore", level.proximityGrenadeDOTDamageAmountHardcore );
		level.proximityGrenadeDOTDamageTime = GetDvarFloat( "scr_proximityGrenadeDOTDamageTime", level.proximityGrenadeDOTDamageTime );
		level.proximityGrenadeDOTDamageInstances = GetDvarInt( "scr_proximityGrenadeDOTDamageInstances", level.proximityGrenadeDOTDamageInstances );
		level.proximityGrenadeActivationTime = GetDvarFloat( "scr_proximityGrenadeActivationTime", level.proximityGrenadeActivationTime );
		level.proximityChainDebug = GetDvarInt( "scr_proximityChainDebug", level.proximityChainDebug );
		level.proximityChainGracePeriod = GetDvarInt( "scr_proximityChainGracePeriod", level.proximityChainGracePeriod );
		level.proximityChainBoltSpeed = GetDvarFloat( "scr_proximityChainBoltSpeed", level.proximityChainBoltSpeed );
		level.proximityGrenadeProtectedTime = GetDvarFloat( "scr_proximityGrenadeProtectedTime", level.proximityGrenadeProtectedTime );

		wait(1.0);
	}
}

function createProximityGrenadeWatcher() // self == player
{
	watcher = self weaponobjects::createProximityWeaponObjectWatcher( "proximity_grenade", self.team );
	watcher.watchForFire = true;
	watcher.hackable = true;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.headIcon = true;
	watcher.reconModel = "t6_wpn_taser_mine_world_detect";
	watcher.activateFx = true;
	watcher.ownerGetsAssist = true;
	watcher.ignoreDirection = true;
	watcher.immediateDetonation = true;
	watcher.detectionGracePeriod = level.proximityGrenadeGracePeriod;
	watcher.detonateRadius = level.proximityGrenadeDetectionRadius;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 1;
	watcher.onDetonateCallback =&proximityDetonate;
	watcher.activationDelay = level.proximityGrenadeActivationTime;
	watcher.activateSound = "wpn_claymore_alert";

	watcher.onSpawn =&onSpawnProximityGrenadeWeaponObject;
}

function createGadgetProximityGrenadeWatcher() // self == player
{
	watcher = self weaponobjects::createProximityWeaponObjectWatcher( "gadget_sticky_proximity", self.team );
	watcher.watchForFire = true;
	watcher.hackable = true;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.headIcon = false;
	watcher.reconModel = "t6_wpn_taser_mine_world_detect";
	watcher.activateFx = true;
	watcher.ownerGetsAssist = true;
	watcher.ignoreDirection = true;
	watcher.immediateDetonation = true;
	watcher.detectionGracePeriod = level.proximityGrenadeGracePeriod;
	watcher.detonateRadius = level.proximityGrenadeDetectionRadius;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 1;
	watcher.onDetonateCallback =&proximityDetonate;
	watcher.activationDelay = level.proximityGrenadeActivationTime;
	watcher.activateSound = "wpn_claymore_alert";

	watcher.onSpawn =&onSpawnProximityGrenadeWeaponObject;
}

function onSpawnProximityGrenadeWeaponObject( watcher, owner ) // self == weapon object
{
	self thread setupKillCamEnt();
	owner AddWeaponStat( self.weapon, "used", 1 );
	
	if ( IsDefined( self.weapon ) && self.weapon.proximityDetonation > 0 )
	{
		watcher.detonateRadius = self.weapon.proximityDetonation;
	}
	
	weaponobjects::onSpawnProximityWeaponObject( watcher, owner );
}

function setupKillCamEnt() // self == grenade
{
	self endon( "death" );

	self util::waitTillNotMoving();

	self.killCamEnt = spawn( "script_model", self.origin + (0,0,8 ) );
	self thread cleanupKillCamEntOnDeath();
}

function cleanupKillCamEntOnDeath() // self == grenade
{
	self waittill( "death" );
	
	self.killCamEnt util::deleteAfterTime( 4 + level.proximityGrenadeDOTDamageTime * level.proximityGrenadeDOTDamageInstances );
}

function proximityDetonate( attacker, weapon )
{
	if ( isdefined( weapon ) && weapon.isValid )
	{
		if ( isdefined( attacker ) )
		{
			if ( self.owner util::IsEnemyPlayer( attacker ) )
			{
				attacker challenges::destroyedExplosive( weapon );
				scoreevents::processScoreEvent( "destroyed_proxy", attacker, self.owner, weapon );
			}
		}
	}
	
	weaponobjects::weaponDetonate( attacker, weapon );
}

function proximityGrenadeDamagePlayer( eAttacker, eInflictor, killCamEnt, weapon, meansOfDeath, damage, proximityChain )
{	
	// eAttacker is the owner of the charge
	// eInflictor is originally the charge, and when on a chain, it;s the player that passed on the chain to us
	// killCamEnt is the killCam placed at the charge	
	self thread damagePlayerInRadius( eInflictor.origin, eAttacker, killCamEnt );
	
	if ( weapon.chainEventRadius > 0 && !self hasPerk ("specialty_proximityprotection") )
	{
		self thread proximityGrenadeChain( eAttacker, eInflictor, killCamEnt, weapon, meansOfDeath, damage, proximityChain, 0 );
	}
}

function getProximityChain()
{
	if ( !isdefined( level.proximityChains ) )
	{
		level.proximityChains = [];
	}
	
	// we use level.proximityChains because we need them to survive players and the on_damage callback
	foreach( chain in level.proximityChains )
	{
		if ( !chainIsActive( chain ) )
		{
			return chain;
		}
	}
	
	chain = spawnstruct();
	level.proximityChains[level.proximityChains.size] = chain;
	
	return chain;
}

function chainIsActive( chain )
{
	// a chain is active as long as it is still being used
	if ( isdefined( chain.activeEndTime ) && chain.activeEndTime > GetTime() )
	{
		return true;
	}
	
	return false;
}

function cleanUpProximityChainEnt() // self is a temp entity to keep track of the original chain. it goes away when all chains are finished.
{
	self.cleanUp = true;
	
	any_active = true;
	
	while( any_active )
	{
		wait( 1 );
		
		if ( !isdefined( self ) )
		{
			return;
		}
		
		any_active = false;
		
		foreach( proximityChain in self.chains )
		{			
			if ( proximityChain.activeEndTime > GetTime() )
			{
				any_active = true;
				break;
			}
		}		
	}
	
	if ( isdefined( self ) )
	{
		self delete();
	}	
}

function isInChain( player )
{
	player_num = player GetEntityNumber();
	
	return isdefined( self.chain_players[player_num] );	
}

function addPlayerToChain( player )
{
	player_num = player GetEntityNumber();
	
	self.chain_players[player_num] = player;
}

function proximityGrenadeChain( eAttacker, eInflictor, killCamEnt, weapon, meansOfDeath, damage, proximityChain, delay )
{
	self endon( "disconnect" );
	self endon( "death" );	
	
	eAttacker endon( "disconnect" );	
	
	if ( !isdefined( proximityChain ) )
	{	
		// this is a new chain started at the on_damage callback
		proximityChain = getProximityChain();
		proximityChain.chainEventNum = 0;		
		
		if ( !isdefined( eInflictor.proximityChainEnt ) )
		{
			// this is the first chain from proximity grenade explosion started at the on_damage callback
			eInflictor.proximityChainEnt = spawn( "script_origin", self.origin );
			eInflictor.proximityChainEnt.chains = [];
			eInflictor.proximityChainEnt.chain_players = [];			
		}
		
		proximityChain.proximityChainEnt = eInflictor.proximityChainEnt;
		proximityChain.proximityChainEnt.chains[proximityChain.proximityChainEnt.chains.size] = proximityChain;		
	}
	
	proximityChain.chainEventNum += 1;	
	
	if ( proximityChain.chainEventNum >= weapon.chainEventMax )
	{
		// this chain is maxed
		return;
	}
	
	chainEventRadiusSq = weapon.chainEventRadius * weapon.chainEventRadius;
	
	endTime = GetTime() + weapon.chainEventTime;
	
	proximityChain.proximityChainEnt addPlayerToChain( self );
	proximityChain.activeEndTime = endTime + (delay * 1000) + level.proximityChainGracePeriod; // allow an interval to avoid reusing this proximityChain, in case it's still being used.
	
	if ( delay > 0 )
	{
		// yield after incrementing chainEventNum, and updating the chain active state	
		wait( delay );
	}
	
	if( !isdefined( proximityChain.proximityChainEnt.cleanUp ) )
	{
		proximityChain.proximityChainEnt thread cleanUpProximityChainEnt();
	}
	
	// we just been chain shocked, we will look for other players to continue the chain
	while( 1 )
	{
		currentTime = GetTime();
		
		if ( endTime < currentTime )
		{
			return;
		}
		
		closestPlayers = ArraySort( level.players, self.origin, true );
		
		foreach( player in closestPlayers )
		{
			{wait(.05);};
			
			if ( proximityChain.chainEventNum >= weapon.chainEventMax )
			{
				// this chain is maxed
				return;
			}
			
			if ( !isdefined( player ) || !IsAlive( player ) || player == self )
			{
				continue;
			}
			
			if ( player.sessionstate != "playing" )
			{
				continue;
			}
			
			distanceSq = DistanceSquared( player.origin, self.origin );
			
			if ( distanceSq > chainEventRadiusSq )
			{
				break;
			}
			
			if ( proximityChain.proximityChainEnt isInChain( player ) )
			{
				continue;
			}
			
			if ( level.proximityChainDebug || weaponobjects::friendlyFireCheck( eAttacker, player ) )
			{
				if ( level.proximityChainDebug || !player hasPerk ("specialty_proximityprotection") )
				{
					// found a player to pass the chain to					
					
					self thread chainPlayer( eAttacker, killCamEnt, weapon, meansOfDeath, damage, proximityChain, player, distanceSq );					
				}
			}			
		}
		
		{wait(.05);};
	}
}

function chainPlayer( eAttacker, killCamEnt, weapon, meansOfDeath, damage, proximityChain, player, distanceSq )
{
	waitTime = 0.25;
	
	speedSq = level.proximityChainBoltSpeed * level.proximityChainBoltSpeed;
	if ( speedSq > 100 && distanceSq > 1 )
	{
		waitTime = distanceSq / speedSq;
	}
	
	player thread proximityGrenadeChain( eAttacker, self, killCamEnt, weapon, meansOfDeath, damage, proximityChain, waitTime );
	
	{wait(.05);};
	
	if ( level.proximityChainDebug )
	{
		/#
			color = (1, 1, 1);
			alpha = 1;
			depth = 0;
			time = 200;
			util::debug_line(self.origin + (0,0,50), player.origin + (0,0,50), color, alpha, depth, time );
		#/						
	}
	
	self tesla_play_arc_fx( player, waitTime );
	
	player thread damagePlayerInRadius( self.origin, eAttacker, killCamEnt );	
}

function tesla_play_arc_fx( target, waitTime )
{
	if ( !IsDefined( self ) || !IsDefined( target ) )
	{	
		return;
	}
	
	tag = "J_SpineUpper";
	target_tag = "J_SpineUpper";
		
	origin = self GetTagOrigin( tag );
	target_origin = target GetTagOrigin( target_tag );
	
	distance_squared = 128 * 128;

	if ( DistanceSquared( origin, target_origin ) < distance_squared )
	{
		//( "TESLA: Not playing arcing FX. Enemies too close." );		
		return;
	}
	
	fxOrg = spawn( "script_model", origin );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( level._effect["prox_grenade_chain_bolt"], fxOrg, "tag_origin" );
	playsoundatposition( "wpn_tesla_bounce", fxOrg.origin );
	
	fxOrg MoveTo( target_origin, waitTime );
	fxOrg waittill( "movedone" );
	fxOrg delete();
}

/#
function debugChainSphere()
{
	util::debug_sphere( self.origin + (0,0,50), 20, (1,1,1), 1, 0 );
}
#/
	
function watchProximityGrenadeHitPlayer( owner ) // self = grenade
{	
	self endon( "death" );
	
	self SetOwner( owner );
	self SetTeam( owner.team );

	while( 1 )
	{
		self waittill("grenade_bounce", pos, normal, ent, surface);
	
		if ( isdefined(ent) && isplayer( ent ) && surface != "riotshield" )
		{
			if ( ( level.teambased && ent.team == self.owner.team )) 
			{
				continue;
			}

			self proximityDetonate(self.owner, self.weapon );
			return;
		}
	}
}	

function performHudEffects( position, distanceToGrenade )
{
	forwardVec = VectorNormalize( AnglesToForward( self.angles ) );
	rightVec = VectorNormalize( AnglesToRight( self.angles ) );
	explosionVec = VectorNormalize( position - self.origin );
	
	fDot = VectorDot( explosionVec, forwardVec );
	rDot = VectorDot( explosionVec, rightVec );

	fAngle = ACos( fDot );
	rAngle = ACos( rDot );
}

function damagePlayerInRadius( position, eAttacker, killCamEnt ) // self = player in radius
{
	self notify( "proximityGrenadeDamageStart" );
	self endon( "proximityGrenadeDamageStart" );
	self endon( "disconnect" );
	self endon( "death" );
	eAttacker endon( "disconnect" );	
	
	PlayFxOnTag( level._effect["prox_grenade_player_shock"], self, "J_SpineUpper" );	

	if ( self util::mayApplyScreenEffect() )
	{
		if ( !self hasPerk ("specialty_proximityprotection") )
		{
			shellshock_duration = 1.5;
			self shellshock("proximity_grenade", shellshock_duration, false );
		}
		
		self clientfield::set_to_player( "tazered", 1 );
	}
	
	self playrumbleonentity("proximity_grenade");
	self PlaySound( "wpn_taser_mine_zap" );

	if ( !self hasPerk ("specialty_proximityprotection") )
	{
		self thread watch_death();
		
		if ( !isdefined( killCamEnt )  )
		{
			killCamEnt = spawn( "script_model", position + (0,0,8) );		
		}
		
		killCamEnt.soundMod = "taser_spike";
		killCamEnt util::deleteAfterTime( 3 + level.proximityGrenadeDOTDamageTime * level.proximityGrenadeDOTDamageInstances);	
		self setClientUIVisibilityFlag( "hud_visible", 0 );
		
		damage = level.proximityGrenadeDOTDamageAmount;
		
		if( level.hardcoreMode )
		{
			damage = level.proximityGrenadeDOTDamageAmountHardcore;
		}

		for ( i = 0; i < level.proximityGrenadeDOTDamageInstances; i++ )
		{		
			assert( isdefined( eAttacker ) );
			
			if ( !isdefined( killCamEnt )  )
			{
				killCamEnt = spawn( "script_model", position + (0,0,8) );		
				killCamEnt.soundMod = "taser_spike";
				killCamEnt util::deleteAfterTime( 3 + level.proximityGrenadeDOTDamageTime * ( level.proximityGrenadeDOTDamageInstances - i ) );
			}		
	
			self DoDamage( damage, position, eAttacker, killCamEnt, "none", "MOD_GAS", 0, GetWeapon( "proximity_grenade_aoe" ) );
			
			wait( level.proximityGrenadeDOTDamageTime );
		}
	
		self shellshock("proximity_grenade_exit", 0.6, false );
		self setClientUIVisibilityFlag( "hud_visible", 1 );
	}
	else
	{
		wait( level.proximityGrenadeProtectedTime );
	}
	
	self clientfield::set_to_player( "tazered", 0 );
}

function proximityDeathWait( owner )
{
	self waittill( "death" );
	
	self notify( "deleteSound" );
}

function deleteEntOnOwnerDeath( owner )
{
	self thread deleteEntOnTimeout();
	self thread deleteEntAfterTime();
	self endon( "delete" );
	owner waittill( "death" );
	self notify( "deleteSound" );
}

function deleteEntAfterTime()
{
	self endon( "delete" );
	wait( 10.0 );
	self notify( "deleteSound" );
}

function deleteEntOnTimeout()
{
	self endon( "delete" );
	self waittill( "deleteSound" );
	self delete();
}

function watch_death() // self == player
{	
	self endon( "disconnect" );
	self notify( "proximity_cleanup" );	
	self endon( "proximity_cleanup" );
	
	// fail safe stuff for if the player dies
	self waittill("death");
	self StopRumble( "proximity_grenade" );
	self setblur(0,0);
	self setClientUIVisibilityFlag( "hud_visible", 1 );
	self clientfield::set_to_player( "tazered", 0 );
	//self setEMPJammed( false );
}

function on_player_spawned()
{
	self thread createProximityGrenadeWatcher();
	self thread createGadgetProximityGrenadeWatcher();
	self thread begin_other_grenade_tracking();
}

function begin_other_grenade_tracking()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self notify( "proximityTrackingStart" );	
	self endon( "proximityTrackingStart" );
	
	for (;;)
	{
		self waittill ( "grenade_fire", grenade, weapon, cookTime );

		if ( grenade util::isHacked() )
		{
			continue;
		}
		
		if ( weapon.rootWeapon.name == "proximity_grenade" )
		{
			grenade thread watchProximityGrenadeHitPlayer( self );
		}
	}
}

function on_damage( eAttacker, eInflictor, weapon, meansOfDeath, damage )
{	
	self thread proximityGrenadeDamagePlayer( eAttacker, eInflictor, eInflictor.killCamEnt, weapon, meansOfDeath, damage, undefined );
}
