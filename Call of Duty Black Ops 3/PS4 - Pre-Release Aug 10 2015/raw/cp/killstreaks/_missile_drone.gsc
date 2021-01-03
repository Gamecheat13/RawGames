#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_challenges;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_airsupport;
#using scripts\cp\killstreaks\_dogs;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_missile_swarm;

                                                                       

#precache( "string", "KILLSTREAK_EARNED_MISSILE_DRONE" );
#precache( "string", "KILLSTREAK_MISSILE_DRONE_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_MISSILE_DRONE_INBOUND" );
#precache( "eventstring", "mpl_killstreak_missile_drone" );
#precache( "fx", "_t6/weapon/missile/fx_missile_drone_light_red" );

#using_animtree ( "mp_missile_drone" );

#namespace missile_drone;

function init()
{	
	clientfield::register( "toplayer", "missile_drone_active", 1, 2, "int" );
	clientfield::register( "missile", "missile_drone_projectile_active", 1, 1, "int" );
	clientfield::register( "missile", "missile_drone_projectile_animate", 1, 1, "int" );
	
	level.missile_drone_flyheight	= 2400;
	level.missile_drone_anim = %o_drone_hunter_launch;

	killstreaks::register( "inventory_missile_drone", "inventory_missile_drone", "killstreak_missile_drone", "missile_drone_used",&missile_drone_killstreak, true );
	killstreaks::register_strings( "inventory_missile_drone", &"KILLSTREAK_EARNED_MISSILE_DRONE", &"KILLSTREAK_MISSILE_DRONE_NOT_AVAILABLE", &"KILLSTREAK_MISSILE_DRONE_INBOUND" );
	killstreaks::register_dialog( "inventory_missile_drone", "mpl_killstreak_missile_drone", "kls_hkdrone_used", "", "kls_hkdrone_enemy", "", "kls_hkdrone_ready" );
	killstreaks::register_dev_dvar( "inventory_missile_drone", "scr_givemissiledrone" );

	killstreaks::register( "missile_drone", "missile_drone", "killstreak_missile_drone", "missile_drone_used",&missile_drone_killstreak, true );
	killstreaks::register_alt_weapon( "missile_drone", "missile_drone_projectile" );
	killstreaks::register_alt_weapon( "inventory_missile_drone", "missile_drone_projectile" );
	killstreaks::register_strings( "missile_drone", &"KILLSTREAK_EARNED_MISSILE_DRONE", &"KILLSTREAK_MISSILE_DRONE_NOT_AVAILABLE", &"KILLSTREAK_MISSILE_DRONE_INBOUND" );
	killstreaks::register_dialog( "missile_drone", "mpl_killstreak_missile_drone", "kls_hkdrone_used", "", "kls_hkdrone_enemy", "", "kls_hkdrone_ready" );
	killstreaks::set_team_kill_penalty_scale( "missile_drone", 0.0 );
}

function missile_drone_killstreak( killstreakType )
{
	assert( killstreakType == "missile_drone" || killstreakType == "inventory_missile_drone" );

	level.missile_drone_origin = level.mapCenter + ( 0, 0, level.missile_drone_flyheight );

	hardpointType = "missile_drone";

	result = useMissileDrone( hardpointType );

	if ( !isdefined(result) || !result )
	{
		return false;
	}

	return result;
}

function useMissileDrone( hardpointType ) 
{
	if ( !self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) )
		return false;
	
	self thread missileDroneWatcher( hardpointType );
	
	missileWeapon = undefined;
	currentWeapon = self GetCurrentWeapon();
	if ( currentWeapon.name == "missile_drone" || currentWeapon.name == "inventory_missile_drone" )
	{
		missileWeapon = currentWeapon;
	}
	
	// we should always have the missile weapon
	assert( isdefined ( missileWeapon ) );
	// for some reason we never had the missileDroneWeapon
	if ( !isdefined( missileWeapon ) )
		return false;

	notifyString = self util::waittill_any_return( "weapon_change", "grenade_fire", "death" );

	if ( notifyString == "weapon_change" ||  notifyString == "death"  ) 
		return false; 

	notifyString = self util::waittill_any_return( "weapon_change", "death" );
	
	if ( notifyString == "death" )
		return true; 
	
	self TakeWeapon( missileWeapon );

	// if we no longer have the missile weapon in our inventory then 
	// it must have been successful
	if ( self HasWeapon( missileWeapon ) || self GetAmmoCount( missileWeapon ) )
		return false;

	return true;
}


function missileDroneWatcher( hardpointType )
{
	self notify("missileDroneWatcher");
	
	self endon( "missileDroneWatcher" );
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "weapon_change" );
	self endon( "death" );

	team = self.team;

	killstreak_id = killstreakrules::killstreakStart( hardpointType, team, false, false );
	if ( killstreak_id == -1 )
	{
		self killstreaks::switch_to_last_non_killstreak_weapon();
		return;
	}

	self thread checkForEmp();
	
	self thread checkWeaponChange( hardpointType, team, killstreak_id );
	self thread watchOwnerDeath( hardpointType, team, killstreak_id );
	self thread updateTargetting();

	self waittill( "grenade_fire", grenade, weapon );
	origin = grenade.origin;
	self notify( "missile_drone_active" );
	level thread popups::DisplayKillstreakTeamMessageToAll( hardpointType, self );
	self killstreaks::play_killstreak_start_dialog( hardpointType, self.team, true );
	level.globalKillstreaksCalled++;
	self AddWeaponStat( GetWeapon( "missile_drone" ), "used", 1 );
	self clientfield::set_to_player( "missile_drone_active", 0 );
	grenade thread waitThenDelete( 0.05 );
	grenade.origin = grenade.origin + ( 0,0, 1000 );

	self thread doMissileDrone( origin, weapon, killstreak_id, hardpointType, team  );
	self killstreaks::switch_to_last_non_killstreak_weapon();
}


function doMissileDrone( origin, weapon, killstreak_id, hardpointType, team  )
{
	direction = self getPlayerAngles();
	forward = AnglesToForward( direction );
	target = origin + VectorScale( forward, 10000 );

	airsupport::debug_line( origin, target, (0.9,0.1,0.1) );
		
	projectile = missile_swarm::projectile_spawn_utility( self, target, origin, "missile_drone_projectile", "drone_missile", false );
	projectile Missile_DroneSetVisible( true );

	projectile.originalTarget = target;
	projectile thread missile_swarm::projectile_abort_think();
		
	projectile thread drone_target_search( hardpointType );
	projectile thread projectile_death_think();

	projectile thread watchDamage();
	projectile.targetname = "remote_drone";
	
	projectile PlaySound("wpn_hunter_ignite");	
	
	projectile thread killstreak_stop_think( killstreak_id, hardpointType, team  );

	projectile clientfield::set("missile_drone_projectile_animate", 1);
}

function waitThenDelete( waitTime )
{
	self endon( "delete" );
	self endon( "death" );
	
	wait( waitTime );
	
	self delete();
}

function projectile_death_think()
{
	self waittill( "death" );
	self.goal delete();
}

function drone_target_acquired( hardpointType, target ) 
{
	self endon( "death" );
	self notify( "drone_target_acquired" );
	self clientfield::set( "missile_drone_projectile_active", 1 );
	
	self set_drone_target( hardpointType, target );
}

function drone_target_search( hardpointType )
{
	self endon( "death" );

	if ( isdefined( self.droneTarget ) )
	{
		self drone_target_acquired( hardpointType, self.droneTarget );
		self Missile_SetTarget( self.goal );
	}

	self clientfield::set( "missile_drone_projectile_active", 0 );
	
	searchDotProdMinimums = [];
	searchDotProdMinimums[0] = 0.9; // 45
	searchDotProdMinimums[1] = 0.7071; // 60
	searchDotProdMinimums[2] = 0.5; 
	searchDotProdMinimums[3] = 0; 

	wait( 0.1 );
	
	searchCounter = 0;
	for ( ;; )
	{
		if ( !isdefined( self ) )
		{
			self notify( "death" );
		}

		target = self projectile_find_target( self.owner, searchDotProdMinimums[searchCounter] );
		if ( searchCounter < searchDotProdMinimums.size - 1 )
		{
			searchCounter++;
		}
		else
		{
			// could not find good target 
			// shoot upwards
			if ( level.missile_drone_origin[2] != self.goal.origin[2] )
			{
				//searchCounter = 0;
				currentAngles = self.angles;
				direction = VectorNormalize( AnglesToForward( self.angles ) );

				
				direction = vecscale( direction, 1024 );
				self.goal.origin = ( self.origin[0] + direction[0], self.origin[1] + direction[1], level.missile_drone_origin[2] );
/#
				airsupport::debug_line( self.origin, self.goal.origin, ( 1,1,0 ), 5000 );
#/
			}
			else // move to center of map
			{
				//searchCounter = 0;
				currentAngles = self.angles;
				direction = VectorNormalize( AnglesToForward( self.angles ) );
				
				direction = vecscale( direction, 1024 );
				self.goal.origin = ( level.missile_drone_origin[0] + direction[0], level.missile_drone_origin[1] + direction[1], level.missile_drone_origin[2] );					
				
/#
				airsupport::debug_line( self.origin, self.goal.origin, ( 0,1,1 ), 5000 );
#/
			}
			
		}
			
		if ( isdefined( target ) )
		{
			self set_drone_target( hardpointType, target );
			self Missile_SetTarget( self.goal );
			//searchCounter = 0;
		}

		wait( 0.25 );
	}
}

function vecscale( vec, scalar )
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}

function set_drone_target( hardpointType, target )
{
	self endon( "target_lost" );
	self thread check_target_lost( target );
	self.swarm_target = target[ "entity" ];
	target[ "entity" ].swarm = self;
	airsupport::debug_line( self.origin, target[ "entity" ].origin, ( 0,0,0 ), 5000 );
	self Missile_SetTarget( target[ "entity" ], target[ "offset" ] );

	self PlaySound( "veh_harpy_drone_swarm_incomming" );
	if ( !isdefined(target[ "entity" ].swarmSound) || target[ "entity" ].swarmSound == false)
		self thread missile_swarm::target_sounds(target[ "entity" ]);
	
	target[ "entity" ] notify( "stinger_fired_at_me", self, hardpointType, self.owner );
	self clientfield::set( "missile_drone_projectile_active", 1 );
	
	target[ "entity" ] util::waittill_any( "death", "disconnect", "joined_team" );
	
	self clientfield::set( "missile_drone_projectile_active", 0 );
	self Missile_SetTarget( self.goal );	
}


function check_target_lost( target )
{
	self endon( "death" );
	target["entity"] endon( "death" );
	target["entity"] endon( "disconnect" );
	target["entity"] endon( "joined_team" );

	failureLimit = 3;
	failureCount = 0;
	for ( ;; )
	{
/#
		airsupport::debug_star( target["entity"].origin, ( 0,1,0 ), 1000 );
		airsupport::debug_star(self.origin,( 0,1,0 ), 1000 );
#/
		if ( BulletTracePassed( self.origin, target["entity"].origin + target[ "offset" ], false, target["entity"] ) )
		{
/#
			airsupport::debug_line(self.origin, target["entity"].origin, ( 0,1,0 ), 1000 );
#/
			failureCount = 0;		
		}
		else
		{
			failureCount++;
			if ( failureCount >= failureLimit )
			{
				self notify( "target_lost" );
				return;
			}
		}
		wait( 0.25 );
	}
}

function projectile_find_target( owner, minCos )
{
	ks = self projectile_find_target_killstreak( owner, minCos );
	player = self projectile_find_target_player( owner, minCos );

	if ( isdefined( ks ) && !isdefined( player ) )
	{
		return ks;
	}
	else if ( !isdefined( ks ) && isdefined( player ) )
	{
		return player;
	}
	else if ( isdefined( ks ) && isdefined( player ) )
	{
		
		if ( player[ "dotprod" ] < ks[ "dotprod" ] )
		{
			return ks;
		}

		return player;
	}

	return undefined;
}

function projectile_find_target_killstreak( owner, minCos )
{
	ks = [];
	ks[ "offset" ] = ( 0, 0, -10 );

	targets = Target_GetArray();
	rcbombs = GetEntArray( "rcbomb", "targetname" );
	dogs = dogs::dog_manager_get_dogs();

	targets = ArrayCombine( targets, rcbombs, true, false );
	targets = ArrayCombine( targets, dogs, true, false );

	if ( targets.size <= 0 )
	{
		return undefined;
	}

	targets = get_array_sorted_dot_prod( targets, minCos );

	foreach( target in targets )
	{
		if ( isdefined( target.owner ) && target.owner == owner )
		{
			continue;
		}

		if ( isdefined( target.script_owner ) && target.script_owner == owner )
		{
			continue;
		}
	
		if ( level.teambased && isdefined( target.team ) )
		{
			if ( target.team == self.team )
			{
				continue;
			}
		}

		if ( isdefined( target.vehicletype ) && target.vehicletype == "heli_supplydrop_mp" )
		{
			continue;	
		}

		// can see the origin
		if ( BulletTracePassed( self.origin, target.origin, false, target ) )
		{
			ks[ "entity" ] = target;
			if ( isdefined( target.sortedDotProd ) ) 
			{
				ks[ "dotprod" ] = target.sortedDotProd;
			}
			else
			{
				ks[ "dotprod" ] = -1;
			}
			return ks;
		}
	}

	return undefined;
}








function projectile_find_target_player( owner, minCos )
{
	target = [];
	players = self get_array_sorted_dot_prod( GetPlayers(), minCos );
	if ( isplayer( self ) ) // this target check can be called with the projectile in your hand
	{
		startOffset = self GetPlayerViewHeight();
		startOrigin = ( self.origin[0], self.origin[1], self.origin[2] + startOffset );
		startAngles = self GetPlayerAngles();
/#
		airsupport::debug_star( startOrigin, ( 0,0,1 ), 1000 );	
#/
	}
	else
	{
		startOrigin = self.origin;
		startAngles = self.angles;
	}
	

	bestPlayerRating = -1;

	foreach( player in players )
	{
		if ( !missile_swarm::player_valid_target( player, owner.team, owner ) )
		{
			continue;
		}

		currentPlayerOffset = undefined;
		currentPlayerDotProd = undefined;
		currentPlayerRating = 0;
/#
		airsupport::debug_star( player.origin, ( 1,1,1 ), 1000 );
#/
		// can see the player's origin
		if ( BulletTracePassed( startOrigin, player.origin, false, player ) )
		{
/#
			airsupport::debug_line( startOrigin, player.origin, ( 1,1,1 ), 1000 );
#/
			if ( !isdefined ( currentPlayerOffset ) )
			{
				currentPlayerOffset = ( 0, 0, 0 );
			}
			currentPlayerRating += 4;
		}

		
		verticalOffset = player GetPlayerViewHeight();
		playerHeadOffset = ( 0, 0, verticalOffset );
/#
		airsupport::debug_star( player.origin + playerHeadOffset, ( 1,0,0 ), 1000 );
#/
		// can see the player's head
		if ( BulletTracePassed(startOrigin, player.origin + playerHeadOffset, false, player ) )
		{
/#
			airsupport::debug_line( startOrigin, player.origin + playerHeadOffset, ( 1,0,0 ), 1000 );
#/

			if ( !isdefined ( currentPlayerOffset ) )
			{
				currentPlayerOffset = playerHeadOffset;
			}

			currentPlayerRating += 3;
		}

		// player in building
		end = player.origin + playerHeadOffset + ( 0, 0, 96 );
/#
		airsupport::debug_star( end, ( 1,1,0 ), 1000 );
#/
		if ( BulletTracePassed(player.origin + playerHeadOffset, end, false, player ) )
		{
/#
			airsupport::debug_line(player.origin + playerHeadOffset, end, ( 1,1,0 ), 1000 );
#/
			if ( !isdefined ( currentPlayerOffset ) )
			{
				currentPlayerOffset = ( 0, 0, 30 );
			}
			currentPlayerRating += 2;
		}

		if ( currentPlayerRating > bestPlayerRating )
		{
			bestPlayerRating = currentPlayerRating;
			target[ "entity" ] = player;
			target[ "offset" ] = currentPlayerOffset;
			if ( isdefined( player.sortedDotProd ) ) 
			{
				target[ "dotprod" ] = player.sortedDotProd;
			}
			else
			{
				target[ "dotprod" ] = -1;
			}
			if ( bestPlayerRating >= ( 4 + 2 + 3 ) )
				return target;
		}
	}

	if ( bestPlayerRating >= 3 ) 
	{
		return target;	
	}
	return undefined;
}




function killstreak_stop_think( killstreak_id, hardpointType, team  )
{
	self waittill( "death" );

	killstreakrules::killstreakStop( hardpointType, team, killstreak_id );
}

function checkWeaponChange( hardpointType, team, killstreak_id )
{
	self endon( "spawned_player" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "grenade_fire" );
	
	self waittill( "weapon_change" );
	
	self clientfield::set_to_player( "missile_drone_active", 0 );
	killstreakrules::killstreakStop( hardpointType, team, killstreak_id );	
}

function watchOwnerDeath(  hardpointType, team, killstreak_id )
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "weapon_change" );
	self endon( "missile_drone_active" );
	
	self waittill( "death" );

	killstreakrules::killstreakStop( hardpointType, team, killstreak_id );	
}

function checkForEmp()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "weapon_change" );
	self endon( "death" );
	self endon( "grenade_fire" );
	
	self waittill( "emp_jammed" );
	self clientfield::set_to_player( "missile_drone_active", 0 );
	self killstreaks::switch_to_last_non_killstreak_weapon();
}


function watchDamage()
{
	self endon( "death" );
	self SetCanDamage( true );
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	for( ;; )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon  );

		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;

		if( isPlayer( attacker ) && level.teambased && isdefined( attacker.team ) && self.team == attacker.team && level.friendlyfire == 0 )
			continue;

		if ( self.owner util::IsEnemyPlayer( attacker ) )
		{
			attacker challenges::addFlySwatterStat( weapon, self );
		}
		else
		{
			//Destroyed Friendly Killstreak 
		}

		self detonate();
	}
}

function get_array_sorted_dot_prod( array, minCos )
{
	if ( isplayer( self ) ) 
	{
		org = self.origin;
		angles = self GetPlayerAngles();
		assert( isdefined ( angles ) );
	}
	else
	{
		org = self.origin;
		assert( isdefined ( self.angles ) );
		angles = self.angles;
	}
	
	forwardVec = vectornormalize( AnglesToForward( angles ) );

	// return the array, reordered from closest to farthest
	dotProd = []; 
	index = []; 
	
	for( i = 0;i < array.size;i ++ )
	{	
		assert( isdefined( forwardVec ) );
		assert( isdefined( array[ i ] ) );
		assert( isdefined( array[ i ].origin ) );
		assert( isdefined( org ) );

		cosA = vectorDot( forwardVec, vectornormalize( array[ i ].origin - org ) );
		
		assert( isdefined( cosA ) );
		
		if ( isdefined( minCos ) && cosA < minCos )
		{
			continue;	
		}
			
		array[ i ].sortedDotProd = cosA;
		dotProd[ dotProd.size ] = cosA;
		
		index[ index.size ] = i;
	}
	
	for( ;; )
	{
		change = false; 
		for( i = 0;i < dotProd.size - 1;i ++ )
		{
			if( dotProd[ i ] >= dotProd[ i + 1 ] )
				continue; 
			change = true; 
			temp = dotProd[ i ];
			dotProd[ i ] = dotProd[ i + 1 ];
			dotProd[ i + 1 ] = temp;
			temp = index[ i ];
			index[ i ] = index[ i + 1 ];
			index[ i + 1 ] = temp;
		}
		if( !change )
			break; 
	}
	
	newArray = []; 

	for( i = 0;i < dotProd.size;i ++ )
	{
		newArray[ i ] = array[ index[ i ] ];
	}
	return newArray; 
}

function updateTargetting()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "weapon_change" );
	self endon( "death" );
	self endon( "grenade_fire" );

	minCos = GetDvarFloat( "scr_missile_drone_min_cos", 0.9 );
	updateWait = GetDvarFloat( "scr_missile_drone_update_wait", 0.5 );
		
	for( ;; )
	{
		self.droneTarget = self projectile_find_target( self, minCos );
		if ( isdefined( self.droneTarget ) )
		{
			
			self thread clearInvalidDroneTarget();
			self clientfield::set_to_player("missile_drone_active", 2 );
		}
		else
		{
			self clientfield::set_to_player( "missile_drone_active", 1 );
		}
		

		wait( updateWait );
	}
}


function clearInvalidDroneTarget()
{
	self endon( "death" );
	self notify( "clearInvalidDroneTarget" );
	self endon( "clearInvalidDroneTarget" );
	self endon( "drone_target_acquired" );
	
	self.droneTarget[ "entity" ] util::waittill_any( "death", "disconnect", "joined_team" );
	
	self.droneTarget = undefined;
}

