#include maps\_utility;
#include common_scripts\utility;

/*
TODO:
-track headshots?
*/

init_stats()
{
	// kill
	self.stats[ "kills" ] = 0;
	self.stats[ "kills_melee" ] = 0;
	self.stats[ "kills_explosives" ] = 0;
	self.stats[ "kills_juggernaut" ] = 0;
	self.stats[ "kills_vehicle" ] = 0;
	self.stats[ "kills_sentry" ] = 0;
	self.stats[ "headshots" ] = 0;
	
	// accuracy
	self.stats[ "shots_fired" ] = 0;
	self.stats[ "shots_hit" ] = 0;

	// weapon stats
	self.stats[ "weapon" ] = [];

	self thread shots_fired_recorder();
}

was_headshot()
{
	// Special field set in Survival AI when damage was scaled
	// up enough on a headshot to force a kill
	if ( IsDefined( self.died_of_headshot ) && self.died_of_headshot )
		return true;
		
	if ( !IsDefined( self.damageLocation ) )
		return false;

	return( self.damageLocation == "helmet" || self.damageLocation == "head" || self.damageLocation == "neck" );
}

register_kill( killedEnt, cause, weaponName, killtype )
{
	assertEx( isdefined( cause ), "Tried to register a player stat for a kill that didn't have a method of death" );
	
	player = self;
	if ( isdefined( self.owner ) )
		player = self.owner;
	
	if ( !isplayer( player ) )
	{
		// fix for enemies sometimes blowing themselves up in Spec Ops and then the mission summary
		// says 38/40 kills or whatever, eventhough you had to kill all 40 enemies to win
		if ( isdefined( level.pmc_match ) && level.pmc_match )
			player = level.players[ randomint( level.players.size ) ];
	}
	
	if ( !isplayer( player ) )
		return;
	
	if ( isdefined( level.skip_pilot_kill_count ) && isdefined( killedEnt.drivingvehicle ) && killedEnt.drivingvehicle )
		return;
	
	// overall
	player.stats[ "kills" ]++;
	player career_stat_increment( "kills", 1 );
	
	if ( is_specialop() )
	{
		// ( "specops_player_kill", attacker, victim, weapon )
		level notify( "specops_player_kill", player, killedEnt, weaponName, killtype );
	}
	
	if ( isdefined( killedEnt ) )
	{
		if(	killedEnt was_headshot() )
		{
			player.stats[ "headshots" ]++ ;
			player career_stat_increment( "headshots", 1 );
		}
			
		if ( isdefined( killedEnt.juggernaut ) )
		{
			player.stats[ "kills_juggernaut" ]++ ;
			player career_stat_increment( "kills_juggernaut", 1 );
		}

		if ( isdefined( killedEnt.isSentryGun ) )
			player.stats[ "kills_sentry" ]++ ;

		if ( killedEnt.code_classname == "script_vehicle" )
		{
			player.stats[ "kills_vehicle" ]++ ;

			// give player credit for the kills of the guys inside the vehicle who are now dead also
			if ( isdefined( killedEnt.riders ) )
				foreach ( rider in killedEnt.riders )
					if ( isdefined( rider ) )
						player register_kill( rider, cause, weaponName, killtype );
		}
	}

	if ( cause_is_explosive( cause ) )
		player.stats[ "kills_explosives" ]++ ;
		
	// adding kills done per weapon
	if ( !IsDefined( weaponName ) )
		weaponName = player getCurrentWeapon();
		
	if ( issubstr( tolower( cause ), "melee" ) )
	{
		player.stats[ "kills_melee" ]++ ;

		// return from adding kills as this was a primary and kill wasn't from a shot
		if ( weaponinventorytype( weaponName ) == "primary" )
			return;
	}

	assert( isdefined( weaponName ) );
	if ( player is_new_weapon( weaponName ) )
	{
		player register_new_weapon( weaponName );
	}
	
	player.stats[ "weapon" ][ weaponName ].kills++ ;
}

career_stat_increment( stat, delta )
{
	if ( !is_specialop() )
		return;
	
	new_stat = int( self getplayerdata( "career", stat ) ) + delta;
	self setplayerdata( "career", stat, new_stat );
}

register_shot_hit()
{
	if ( !isPlayer( self ) )
		return;
	assert( isdefined( self.stats ) );

	// Only allow one shot hit per frame, because sometimes we can hit several entities with one shot in one frame ( such as grenade damage or RPG round ).
	// Since a weapon was only fired once we only want to count it as one hit, that way we can't achieve higher than 100% accuracy.
	if ( isdefined( self.registeringShotHit ) )
		return;
	self.registeringShotHit = true;

	// overall
	self.stats[ "shots_hit" ]++ ;
	self career_stat_increment( "bullets_hit", 1 );
	
	// specific
	weaponName = self getCurrentWeapon();
	assert( isdefined( weaponName ) );
	if ( is_new_weapon( weaponName ) )
		register_new_weapon( weaponName );
	self.stats[ "weapon" ][ weaponName ].shots_hit++ ;

	waittillframeend;
	self.registeringShotHit = undefined;
}

shots_fired_recorder()
{
	self endon( "death" );

	for ( ;; )
	{
		self waittill( "weapon_fired" );

		weaponName = self getcurrentweapon();
		if ( !isdefined( weaponName ) || !isPrimaryWeapon( weaponName ) )
			continue;

		// overall stats
		self.stats[ "shots_fired" ]++ ;
		self career_stat_increment( "bullets_fired", 1 );
		
		// stats for specific weapon
		if ( is_new_weapon( weaponName ) )
			register_new_weapon( weaponName );
		self.stats[ "weapon" ][ weaponName ].shots_fired++ ;
	}
}

is_new_weapon( weaponName )
{
	if ( isdefined( self.stats[ "weapon" ][ weaponName ] ) )
		return false;
	return true;
}

cause_is_explosive( cause )
{
	cause = tolower( cause );
	switch( cause )
	{
		case "mod_grenade":
		case "mod_grenade_splash":
		case "mod_projectile":
		case "mod_projectile_splash":
		case "mod_explosive":
		case "splash":
			return true;
		default:
			return false;
	}
	return false;
}

register_new_weapon( weaponName )
{
	self.stats[ "weapon" ][ weaponName ] = spawnStruct();
	self.stats[ "weapon" ][ weaponName ].name = weaponName;
	self.stats[ "weapon" ][ weaponName ].shots_fired = 0;
	self.stats[ "weapon" ][ weaponName ].shots_hit = 0;
	self.stats[ "weapon" ][ weaponName ].kills = 0;
}

set_stat_dvars()
{
	playerNum = 1;
	foreach ( player in level.players )
	{
		setdvar( "stats_" + playerNum + "_kills_melee", player.stats[ "kills_melee" ] );
		setdvar( "stats_" + playerNum + "_kills_juggernaut", player.stats[ "kills_juggernaut" ] );
		setdvar( "stats_" + playerNum + "_kills_explosives", player.stats[ "kills_explosives" ] );
		setdvar( "stats_" + playerNum + "_kills_vehicle", player.stats[ "kills_vehicle" ] );
		setdvar( "stats_" + playerNum + "_kills_sentry", player.stats[ "kills_sentry" ] );

		// Sort the weapons used from most used to least used based on kills, then calculate accuracy
		weapons = player get_best_weapons( 5 );
		foreach ( weapon in weapons )
		{
			weapon.accuracy = 0;
			if ( weapon.shots_fired > 0 )
				weapon.accuracy = int( ( weapon.shots_hit / weapon.shots_fired ) * 100 );
		}

		// Put detailed weapon info into dvars ( name, kills, shots fired, and accuracy )
		for ( i = 1 ; i < 6 ; i++ )
		{
			setdvar( "stats_" + playerNum + "_weapon" + i + "_name", " " );
			setdvar( "stats_" + playerNum + "_weapon" + i + "_kills", " " );
			setdvar( "stats_" + playerNum + "_weapon" + i + "_shots", " " );
			setdvar( "stats_" + playerNum + "_weapon" + i + "_accuracy", " " );
		}
		for ( i = 0 ; i < weapons.size ; i++ )
		{
			if ( !isdefined( weapons[ i ] ) )
				break;

			setdvar( "stats_" + playerNum + "_weapon" + ( i + 1 ) + "_name", weapons[ i ].name );
			setdvar( "stats_" + playerNum + "_weapon" + ( i + 1 ) + "_kills", weapons[ i ].kills );
			setdvar( "stats_" + playerNum + "_weapon" + ( i + 1 ) + "_shots", weapons[ i ].shots_fired );
			setdvar( "stats_" + playerNum + "_weapon" + ( i + 1 ) + "_accuracy", weapons[ i ].accuracy + "%" );
		}

		playerNum++ ;
	}
}

get_best_weapons( numToGet )
{
	weaponStats = [];

	for ( i = 0 ; i < numToGet ; i++ )
	{
		weaponStats[ i ] = get_weapon_with_most_kills( weaponStats );
	}

	return weaponStats;
}

get_weapon_with_most_kills( excluders )
{
	if ( !isdefined( excluders ) )
		excluders = [];

	highest = undefined;

	foreach ( weapon in self.stats[ "weapon" ] )
	{
		isExcluder = false;
		foreach ( excluder in excluders )
		{
			if ( weapon.name == excluder.name )
			{
				isExcluder = true;
				break;
			}
		}
		if ( isExcluder )
			continue;

		if ( !isdefined( highest ) )
			highest = weapon;
		else if ( weapon.kills > highest.kills )
			highest = weapon;
	}

	return highest;
}