#include maps\mp\_utility;
#include maps\mp\killstreaks\_harrier;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	precacheLocationSelector( "map_artillery_selector" );
	precacheString( &"KILLSTREAKS_ORBITAL_LASER" );
	precacheItem( "orbital_laser_mp" );
	//PreCacheRumble( "damage_heavy" );
	
	PreCacheShader( "compassping_orbitallaser_friendly" );
	PreCacheShader( "compassping_orbitallaser_hostile" );

	//TODO: Request laser FX from VFX.
	level.orbital_laser_fx = loadfx( "vfx/beam/orbital_laser" );
	//TODO: Request laser SFX from Audio
	level.orbital_laser_sfx = "orbital_laser";
	
	level.dangerMaxRadius["orbital_laser"] = 550;
	level.dangerMinRadius["orbital_laser"] = 300;
	level.dangerForwardPush["orbital_laser"] = 1.5;
	level.dangerOvalScale["orbital_laser"] = 6.0;
	
	level.killStreakFuncs["orbital_laser"] = ::tryUseDefaultOrbitalLaser;
	
	assert( !IsDefined(level._orbital_laser) );
	
	level._orbital_laser = SpawnStruct();
	level._orbital_laser.num_of_location_selections = 3;
	level._orbital_laser.total_move_duration = 10;
	level._orbital_laser.segment_move_durations = [];
	level._orbital_laser.skybox_offset = 300;							// Need to find a more elegant way of setting VFX offset from skybox.
	level._orbital_laser.user_offset = 200;								// Need to find a more elegant way of setting VFX offset from player height.
	level._orbital_laser.fx_height = 1500;
	level._orbital_laser.lasers = [];
	level._orbital_laser.damage_radius = 256;
	level._orbital_laser.friendShader = "compassping_orbitallaser_friendly";
	level._orbital_laser.foeShader = "compassping_orbitallaser_hostile";
	
}

tryUseDefaultOrbitalLaser( lifeId )
{
	return tryUseOrbitalLaser( lifeId, "orbital_laser" );
}

tryUseOrbitalLaser( lifeId, streakName )
{
	if ( ! self validateUseStreak() )
		return false;

	if ( self isUsingRemote() )
	{
		return false;
	}
	
	if( level._orbital_laser.lasers.size > 0 )
	{
		self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
		return false;
	}
	
	result = self selectOrbitalLaserPathLocation( lifeId, streakName );

	if ( !isDefined( result ) || !result )
		return false;
	
	return true;
}


selectOrbitalLaserPathLocation( lifeId, streakname )
{
	targetSize = level.mapSize / 6.46875; // 138 in 720
	if ( level.splitscreen )
		targetSize *= 1.5;
	
	// Setup owner with variables to hold an array of locations and the current direction.
	self._orbital_laser = SpawnStruct();
	self._orbital_laser.locations = [];
	self._orbital_laser.currentdir = 0;
	
	//TODO: setup for Orbital laser vo
	switch( streakName )
	{
		case "precision_airstrike":
			chooseDirection = true;
			self PlayLocalSound( game[ "voice" ][ self.team ] + "KS_hqr_airstrike" );
			break;
		case "stealth_airstrike":
			chooseDirection = true;
			self PlayLocalSound( game[ "voice" ][ self.team ] + "KS_hqr_bomber" );
			break;
	}
	
	self setblurforplayer( 10.3, 0.3 );
	
	//TODO: Need to leave behind already chosen points
	self  maps\mp\_utility::_beginLocationSelection( streakname, "map_artillery_selector", false, targetSize );

	self endon( "stop_location_selection" );
	
	// Gather selection locations and store in level._orbital_laser.locations[]
	for( i=0; i < level._orbital_laser.num_of_location_selections; i++)
	{
		self waittill( "confirm_location", location, directionYaw );
		self._orbital_laser.locations[i] = location;
		self PlaySoundToPlayer( "weap_suitcase_button_press_plr", self );
	}
	
	self setblurforplayer( 0, 0.3 );
	
	//self thread airstrikeMadeSelectionVO( streakName );
	
	self maps\mp\_matchdata::logKillstreakEvent( streakName, self._orbital_laser.locations[0] );
	
	self thread finishOrbitalLaserUsage( lifeId, streakName );
	return true;
}

finishOrbitalLaserUsage( lifeId, streakName )
{
	self notify( "used" );

	// find underside of top of skybox
	trace = bullettrace( level.mapCenter + (0,0,1000000), level.mapCenter, false, undefined );
	
	// Find height of laser if height of player is used.
	user_height_offset = self.origin[2] + level._orbital_laser.fx_height;
	
	// If height of vfx using player height is above the skybox then use the skybox.  Otherwise, use the player height.
	if( user_height_offset > trace["position"][2] )
	{
		laser_startpoint = trace["position"][2] - level._orbital_laser.skybox_offset;
	} else {
		laser_startpoint = user_height_offset - level._orbital_laser.user_offset;
	}
	
	
	for( i = 0; i < self._orbital_laser.locations.size; i++ )
	{
		self._orbital_laser.locations[ i ] = (self._orbital_laser.locations[i][0], self._orbital_laser.locations[i][1], laser_startpoint);
	}

	thread doOrbitalLaserStrike( lifeId, self, self.pers["team"], streakName );
}


doOrbitalLaserStrike( lifeId, owner, team, streakName )
{
	
	level.orbitalLaserDamagedEnts = [];
	level.orbitalLaserDamagedEntsCount = 0;
	level.orbitalLaserDamagedEntsIndex = 0;
	
	
	// Currently we're assuming that each section is equal...and storing that value in the level._orbital_laser.segement_move_duration[].
	for( i=0; i < level._orbital_laser.num_of_location_selections - 1; i++ )
	{
		level._orbital_laser.segment_move_durations[i] = level._orbital_laser.total_move_duration / ( level._orbital_laser.num_of_location_selections - 1 );
	}

	wait 2;														// waiting 2 seconds before bringing down the laser so the dialog can end and the laptop can go away
	
	laser_base = spawnLaser( owner._orbital_laser.locations[0], owner );
	
	add_laser_to_list( laser_base );
	laser_base thread handleDeath( owner );
	laser_base thread handleEMP( owner );
	
	//thread  orbital_laser_killCam( laser_base, streakName );
	
	// Loop through the number of segments (location selections - 1) and move the laser around.
	for( i=0; i < level._orbital_laser.num_of_location_selections - 1; i++ )
	{
		owner._orbital_laser.currentdir = VectorNormalize( owner._orbital_laser.locations[i+1] - owner._orbital_laser.locations[i] );
		//laser_base notify( "laser_dir_updated" );
		
		laser_base orbital_laser_killCam( streakName, i, owner );
		
		laser_base moveToOnGround( owner._orbital_laser.locations[i+1], level._orbital_laser.segment_move_durations[i] );
	}
	
	remove_laser_from_list( laser_base );
	laser_base notify( "death" );
}

add_laser_to_list( laser )
{
	level._orbital_laser.lasers[ level._orbital_laser.lasers.size ] = laser;
}

remove_laser_from_list( laser )
{

	for( i=0; i < level._orbital_laser.lasers.size; i++ )
	{
		if( IsDefined(level._orbital_laser.lasers[i]) && level._orbital_laser.lasers[i] == laser)
		{
			level._orbital_laser.lasers[i] = undefined;
		}
	}
	
}


spawnLaser( pos, owner )
{
	laser = spawn_tag_origin();
	laser.origin = pos;
	
	laser_ground_pos = drop_to_ground( pos, 0, -15000 );
	laser_ground_point = spawn_tag_origin();
	laser_ground_point.origin = laser_ground_pos;

	thread playSoundInSpace( "fast_artillery_round", laser_ground_point.origin );
	laser_ground_point thread play_loop_sound_on_entity( level.orbital_laser_sfx );
	laser.ground_point = laser_ground_point;
	laser.angles = ( -90, 0, 0 );												//so the vfx points the right direction
	wait( .05 );
	laser show();
	wait( .1 );
	PlayFXOnTag( level.orbital_laser_fx, laser, "tag_origin" );
	laser thread handleDamage( owner );											//start thread to do damage to players in the trigger.
	//laser thread showLaserDebug();
	
	laser thread handleMinimapDisplay( owner );
	
	return laser;
}

handleMinimapDisplay( owner )
{

	if( !level.teambased )
	{
		currentObj = maps\mp\gametypes\_gameobjects::getNextObjID();
		objective_add( currentObj, "invisible", (0,0,0) );
		objective_OnEntity( currentObj, self );
		objective_state( currentObj, "active" );
		objective_player( currentObj, owner GetEntityNumber() );
		objective_icon( currentObj, level._orbital_laser.friendshader );
		self.objID01 = currentObj;
			
				
		currentObj = maps\mp\gametypes\_gameobjects::getNextObjID();	
		objective_add( currentObj, "invisible", (0,0,0) );
		objective_OnEntity( currentObj, self );
		objective_state( currentObj, "active" );
		objective_playerenemyteam( currentObj, owner GetEntityNumber() );
		objective_icon( currentObj, level._orbital_laser.foeShader );
		self.objID02 = currentObj;	
		
	} else {
		
		currentObj = maps\mp\gametypes\_gameobjects::getNextObjID();
		objective_add( currentObj, "invisible", (0,0,0) );
		objective_OnEntity( currentObj, self );
		objective_state( currentObj, "active" );
		objective_team( currentObj, owner.team );
		objective_icon( currentObj, level._orbital_laser.friendShader );
		self.objID03 = currentObj;
				
		currentObj = maps\mp\gametypes\_gameobjects::getNextObjID();	
		objective_add( currentObj, "invisible", (0,0,0) );
		objective_OnEntity( currentObj, self );
		objective_state( currentObj, "active" );
		objective_team( currentObj, level.otherTeam[ owner.team ] );
		objective_icon( currentObj, level._orbital_laser.foeShader );
		self.objID04 = currentObj;	
	}


		
}

removeMinimapDisplay()
{
	if( IsDefined( self.objID01 ) )
		_objective_delete( self.objID01 );
	if( IsDefined( self.objID02 ) )
		_objective_delete( self.objID02 );
	if( IsDefined( self.objID03 ) )
		_objective_delete( self.objID03 );
	if( IsDefined( self.objID04 ) )
		_objective_delete( self.objID04 );
}

handleDeath( owner ) // self == laser_base
{
	level endon( "game_ended" );
	self endon( "delete" );

	self waittill( "death" );
	
	// Play ending sound and cleanup VFX
	thread playSoundInSpace( "fast_artillery_round", self.ground_point.origin );
	self notify( "stop_laser_fire" );
	self.ground_point stop_loop_sound_on_entity( level.orbital_laser_sfx );
	StopFXOnTag( level.orbital_laser_fx, self, "tag_origin" );
	
	// Remote from minimap
	self removeMinimapDisplay();
	
	// Reset locations array and direction to defaults.
	owner._orbital_laser.locations = [];
	owner._orbital_laser.currentdir = 0;
	
	// Remove laser from list of active lasers.
	remove_laser_from_list( self );
	
	self delete();	
}

showLaserDebug()
{
	self endon( "stop_laser_fire" );
	while( 1 )
	{
		Line( self.origin, self.origin + ( 0, 0, 512 ), ( 1, 0, 0 ), 1, false, 1 );
		wait .05;
	}
}


moveToOnGround( destination, move_time )
{
	self endon ( "death" );
	
	AssertEx( move_time != 0, "Move time cannot be 0" );
	self moveto( destination, move_time );
	self.ground_point moveto( ( destination[0], destination[1], self.ground_point.origin[2] ), move_time );
	wait move_time;
}

laser_drop_to_ground( pos, check_up, check_down )
{
	dest_on_ground = drop_to_ground( pos, check_up, check_down );
	if( dest_on_ground[2] < -10000 )
	{
		dest_on_ground = ( dest_on_ground[0], dest_on_ground[1], -10000 );								//cap the dest at -10000, if it goes further the ent will go out of the world
		Print( "\nOrbital Laser is possibly firing out of the world, check: " + dest_on_ground );
	}
	return dest_on_ground;	
}

handleDamage( owner )
{
	self endon( "stop_laser_fire" );
	while( 1 )
	{
		damageEnts( self.origin, 10, 2, owner, self, "orbital_laser_mp" );
		wait .05;
	}
}

damageEnts( pos, max, min, owner, eInflictor, sWeapon )
{
	
	ents = getDamageableEnts(pos, false);
	
	glassRadiusDamage( self.ground_point.origin, level._orbital_laser.damage_radius, max, min );
	
	for (i = 0; i < ents.size; i++)
	{
		
		if ( ents[i].isPlayer || ( isDefined( ents[i].isSentry ) && ents[i].isSentry ) )
		{
			// check if there is a path to this entity 130 units above his feet. if not, they're probably indoors
			indoors = !BulletTracePassed( ents[i].entity.origin, ents[i].entity.origin + (0,0,130), false, undefined );
			if ( indoors )
			{
				indoors = !BulletTracePassed( ents[i].entity.origin + (0,0,130), pos + (0,0,130 - 16), false, undefined );
				if ( indoors )
				{
					// give them a distance advantage for being indoors.
					ents[i].dist *= 4;
					if ( ents[i].dist > level._orbital_laser.damage_radius )
						continue;
				}
			}
		}

		ents[i].damage = int(max + (min-max)*ents[i].dist/level._orbital_laser.damage_radius);
		ents[i].pos = pos;
		ents[i].damageOwner = owner;
		ents[i].eInflictor = eInflictor;
		ents[i].radius = level._orbital_laser.damage_radius;
		level.orbitalLaserDamagedEnts[level.orbitalLaserDamagedEntsCount] = ents[i];
		level.orbitalLaserDamagedEntsCount++;
	}
	
	thread damageEntsThread( sWeapon );
}


/*
=============
///ScriptDocBegin
"Name: getDamageableEnts( <pos> , <doLOS> )"
"Summary: returns an array of damageable entities. This differs from _weapons::getDamageableEnts() in that it checks a cylindrical area, not a spherical area (distance2D vs distanceSquared)."
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <pos>: the center of the damage area of effect"
"MandatoryArg: <doLOS>: should this function do a line of sight check?"
"Example: ents = getDamageableEnts(pos, false);"
"SPMP: MP"
///ScriptDocEnd
=============
*/
getDamageableEnts( pos, doLOS )
{
	ents = [];

	if ( !isdefined( doLOS ) )
		doLOS = false;

	// players
	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		if ( !isalive( players[ i ] ) || players[ i ].sessionstate != "playing" )
			continue;
		
		playerpos = get_damageable_player_pos( players[ i ] );
//		distSq = distanceSquared( pos, playerpos );
//		if ( distSq < radiusSq && ( !doLOS || maps\mp\gametypes\_weapons::weaponDamageTracePassed( pos, playerpos, startRadius, players[ i ] ) ) )
//		{
//			ents[ ents.size ] = get_damageable_player( players[ i ], playerpos );
//		}
		//Doing a 2D distance check instead of a 3D distanceSquared check.
		dist2d = Distance2D( pos, playerpos );
		if( dist2d < level._orbital_laser.damage_radius )
		{
			ents[ ents.size ] = get_damageable_player( players[ i ], playerpos );
			ents[ ents.size -1 ].dist = dist2d;
		}
	}

	// grenades
	grenades = getentarray( "grenade", "classname" );
	for ( i = 0; i < grenades.size; i++ )
	{
		entpos = get_damageable_grenade_pos( grenades[ i ] );
//		distSq = distanceSquared( pos, entpos );
//		if ( distSq < radiusSq && ( !doLOS || maps\mp\gametypes\_weapons::weaponDamageTracePassed( pos, entpos, startRadius, grenades[ i ] ) ) )
//		{
//			ents[ ents.size ] = get_damageable_grenade( grenades[ i ], entpos );
//		}
		//Doing a 2D distance check instead of a 3D distanceSquared check.
		dist2d = Distance2D( pos, entpos );
		if( dist2d < level._orbital_laser.damage_radius )
		{
			ents[ ents.size ] = get_damageable_grenade( grenades[ i ], entpos );
			ents[ ents.size -1 ].dist = dist2d;
		}
	}

	destructibles = getentarray( "destructible", "targetname" );
	for ( i = 0; i < destructibles.size; i++ )
	{
		entpos = destructibles[ i ].origin;
//		distSq = distanceSquared( pos, entpos );
//		if ( distSq < radiusSq && ( !doLOS || maps\mp\gametypes\_weapons::weaponDamageTracePassed( pos, entpos, startRadius, destructibles[ i ] ) ) )
//		{
//			newent = spawnstruct();
//			newent.isPlayer = false;
//			newent.isADestructable = false;
//			newent.entity = destructibles[ i ];
//			newent.damageCenter = entpos;
//			ents[ ents.size ] = newent;
//		}
		//Doing a 2D distance check instead of a 3D distanceSquared check.
		dist2d = Distance2D( pos, entpos );
		if( dist2d < level._orbital_laser.damage_radius )
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.entity = destructibles[ i ];
			newent.damageCenter = entpos;
			ents[ ents.size ] = newent;
			ents[ ents.size -1 ].dist = dist2d;
		}
	}

	destructables = getentarray( "destructable", "targetname" );
	for ( i = 0; i < destructables.size; i++ )
	{
		entpos = destructables[ i ].origin;
//		distSq = distanceSquared( pos, entpos );
//		if ( distSq < radiusSq && ( !doLOS || maps\mp\gametypes\_weapons::weaponDamageTracePassed( pos, entpos, startRadius, destructables[ i ] ) ) )
//		{
//			newent = spawnstruct();
//			newent.isPlayer = false;
//			newent.isADestructable = true;
//			newent.entity = destructables[ i ];
//			newent.damageCenter = entpos;
//			ents[ ents.size ] = newent;
//		}
		//Doing a 2D distance check instead of a 3D distanceSquared check.
		dist2d = Distance2D( pos, entpos );
		if( dist2d < level._orbital_laser.damage_radius )
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = true;
			newent.entity = destructables[ i ];
			newent.damageCenter = entpos;
			ents[ ents.size ] = newent;
			ents[ ents.size -1 ].dist = dist2d;
		}
	}
	
	//sentries
	sentries = getentarray( "misc_turret", "classname" );
	foreach ( sentry in sentries )
	{
		entpos = sentry.origin + (0,0,32);
//		distSq = distanceSquared( pos, entpos );
//		if ( distSq < radiusSq && ( !doLOS || maps\mp\gametypes\_weapons::weaponDamageTracePassed( pos, entpos, startRadius, sentry ) ) )
//		{
//			switch( sentry.model )
//			{
//			case "sentry_minigun_weak":
//			case "mp_sam_turret":
//			case "mp_remote_turret":
//			case "vehicle_ugv_talon_gun_mp":
//				ents[ ents.size ] = get_damageable_sentry(sentry, entpos);
//				break;
//			}
//		}
		//Doing a 2D distance check instead of a 3D distanceSquared check.
		dist2d = Distance2D( pos, entpos );
		if( dist2d < level._orbital_laser.damage_radius )
		{
			switch( sentry.model )
			{
			case "sentry_minigun_weak":
			case "mp_sam_turret":
			case "mp_remote_turret":
			case "vehicle_ugv_talon_gun_mp":
				ents[ ents.size ] = get_damageable_sentry(sentry, entpos);
				ents[ ents.size -1 ].dist = dist2d;
				break;
			}
		}
	}

	// mines ( the problem here seems to be the traceline from 1 ground position to another is easily blocked, the origin offset helps but may have it's own issues )
	mines = getentarray( "script_model", "classname" );
	foreach ( mine in mines )
	{
		if ( mine.model != "projectile_bouncing_betty_grenade" && mine.model != "ims_scorpion_body" )
			continue;
		
		entpos = mine.origin + (0,0,32);
//		distSq = distanceSquared( pos, entpos );
//		if ( distSq < radiusSq && ( !doLOS || maps\mp\gametypes\_weapons::weaponDamageTracePassed( pos, entpos, startRadius, mine ) ) )
//			ents[ ents.size ] = get_damageable_mine( mine, entpos );
		
		//Doing a 2D distance check instead of a 3D distanceSquared check.
		dist2d = Distance2D( pos, entpos );
		if( dist2d < level._orbital_laser.damage_radius )
		{
			ents[ ents.size ] = get_damageable_mine( mine, entpos );
			ents[ ents.size -1 ].dist = dist2d;
		}
	}

	return ents;
}


damageEntsThread( sWeapon )
{
	self notify ( "orbitalLaserDamageEntsThread" );
	self endon ( "orbitalLaserDamageEntsThread" );

	for ( ; level.orbitalLaserDamagedEntsIndex < level.orbitalLaserDamagedEntsCount; level.orbitalLaserDamagedEntsIndex++ )
	{
		if ( !isDefined( level.orbitalLaserDamagedEnts[level.orbitalLaserDamagedEntsIndex] ) )
			continue;

		ent = level.orbitalLaserDamagedEnts[level.orbitalLaserDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 
			
		if ( isAlive( ent.entity ) )
		{
			ent maps\mp\gametypes\_weapons::damageEnt(
				ent.eInflictor, // eInflictor = the entity that causes the damage (e.g. a claymore)
				ent.damageOwner, // eAttacker = the player that is attacking
				ent.damage, // iDamage = the amount of damage to do
				"MOD_PROJECTILE_SPLASH", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				sWeapon, // sWeapon = string specifying the weapon used (e.g. "claymore_mp")
				ent.pos, // damagepos = the position damage is coming from
				vectornormalize(ent.damageCenter - ent.pos) // damagedir = the direction damage is moving in
			);			
			
			if ( ent.isPlayer )
			{
				ent.entity PlayRumbleOnEntity( "damage_heavy" );
				ent.entity shellshock( "orbital_laser_mp", 1 );
			}
			
			level.orbitalLaserDamagedEnts[level.orbitalLaserDamagedEntsIndex] = undefined;
		}
		else
		{
			level.orbitalLaserDamagedEnts[level.orbitalLaserDamagedEntsIndex] = undefined;
		}
	}
}

//TODO: make this work with the orbital laser
orbital_laser_killCam( streakName, segment, owner )
{	
	self endon( "delete" );
	
	killCamEnt = undefined;
	
	laserdir = owner._orbital_laser.currentdir;
	killCamEnt = spawn( "script_model", laserdir );
	self.killCamEnt = killCamEnt;
	self.killCamEnt SetScriptMoverKillCam( "airstrike" );
	killCamEnt.startTime = GetTime();
	killCamEnt thread deleteAfterTime(level._orbital_laser.segment_move_durations[segment]);
		
	killCamEnt linkTo( self, "tag_origin", (0,200,0), ( 0,0,0 ));

}

deleteAfterTime( time )
{
	self endon ( "death" );
	wait ( time );
	
	self delete();
}

//TODO: make this work with the orbital laser
handleEMP( owner ) // self == laser_base
{
	self endon ( "death" );

	if ( owner isEMPed() )
	{
		self notify( "death" );
		return;
	}
	
	while ( 1 )
	{
		level waittill ( "emp_update" );
		
		if ( !owner isEMPed() )
			continue;
			
		self notify( "death" );
	}
}
//TODO: make this work with the orbital laser
airstrikeMadeSelectionVO( streakName )
{
	self endon( "death" );
	self endon( "disconnect" );

	switch( streakName )
	{
	case "precision_airstrike":
		self PlayLocalSound( game[ "voice" ][ self.team ] + "KS_ast_inbound" );
		break;
	case "stealth_airstrike":
		self PlayLocalSound( game[ "voice" ][ self.team ] + "KS_bmb_inbound" );
		break;
	}
}
