#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_killstreaks;

init()
{
	level._effect[ "emp_flash" ] = loadfx( "weapon/emp/fx_emp_explosion" );

	foreach( team in level.teams )
	{
		level.teamEMPing[team] = false;
	}
	level.empPlayer = undefined;
	level.empTimeout = 40.0;
	level.empOwners = [];

	if ( level.teamBased )
		level thread EMP_TeamTracker();
	else
		level thread EMP_PlayerTracker();
	
	level thread onPlayerConnect();

	registerKillstreak( "emp_mp", "emp_mp", "killstreak_emp", "emp_used", ::EMP_Use );
	registerKillstreakStrings( "emp_mp", &"KILLSTREAK_EARNED_EMP", &"KILLSTREAK_EMP_NOT_AVAILABLE", &"KILLSTREAK_EMP_INBOUND" );
	registerKillstreakDialog( "emp_mp", "mpl_killstreak_emp_activate", "kls_emp_used", "", "kls_emp_enemy", "", "kls_emp_ready" );
	registerKillstreakDevDvar( "emp_mp", "scr_giveemp" );
	
	maps\mp\killstreaks\_killstreaks::createKillstreakTimer( "emp_mp" );
	
/#
	set_dvar_float_if_unset( "scr_emp_timeout", 40.0 );
	set_dvar_int_if_unset( "scr_emp_damage_debug", 0 );
#/
}



onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill( "spawned_player" );
		
		if ( (level.teamBased && EMP_IsTeamEMPed(self.team)) || (!level.teamBased && isDefined( level.empPlayer ) && level.empPlayer != self) )
			self setEMPJammed( true );
	}
}

EMP_IsTeamEMPed( check_team )
{
	foreach( team in level.teams )
	{
		if( team == check_team )
			continue;
			
		if ( level.teamEMPing[team] )
			return true;
	}

	return false;
}

EMP_Use( lifeId )
{
	assert( isDefined( self ) );

	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( "emp_mp", self.team, false, true );
	if ( killstreak_id == -1 )
	{
		return false;
	}
	
	myTeam = self.pers["team"];
	
	if ( level.teamBased )
	{
		self thread EMP_JamOtherTeams( myTeam, killstreak_id );
	}
	else
	{
		self thread EMP_JamPlayers( self, killstreak_id );
	}
	self.EMPTime = GetTime();
	//self maps\mp\_matchdata::logKillstreakEvent( "emp", self.origin );
	self notify( "used_emp" );
	self PlayLocalSound( "mpl_killstreak_emp_activate" );
	self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "emp_mp", self.pers["team"] );

	return true;
}


EMP_JamOtherTeams( teamName, killstreak_id )
{
	level endon ( "game_ended" );
	overlays = [];
	
	assert( isdefined( level.teams[teamName] ) );

//	level thread maps\mp\_popups::DisplayTeamMessageToAll( &"MP_USED_EMP", self );

	level notify ( "EMP_JamOtherTeams" + teamName );
	level endon ( "EMP_JamOtherTeams" + teamName );
	
	level.empOwners[teamName] = self;
	
	foreach ( player in level.players )
	{
		if ( player == self )
		{
			continue;
		}
		//Eckert
		player PlayLocalSound( "mpl_killstreak_emp_blast_front" );
	}

	VisionSetNaked( "flash_grenade", 1.5 );
	thread empEffects();
	
	wait ( 0.1 );
	
	// resetting the vision set to the same thing won't normally have an effect.
	// however, if the client receives the previous visionset change in the same packet as this one,
	// this will force them to lerp from the bright one to the normal one.
	VisionSetNaked( "flash_grenade", 0 );
	if( IsDefined( level.nukeDetonated ) )
	{
		VisionSetNaked( level.nukeVisionSet, 5.0 );
	}
	else
	{
		VisionSetNaked( GetDvar( "mapname" ), 5.0 );
	}
	
	level.teamEMPing[teamName] = true;
	level notify ( "emp_update" );
	
	level destroyOtherTeamsActiveVehicles( self, teamName );
	level destroyOtherTeamsEquipment( self, teamName );

/#
	level.empTimeout = GetDvarFloat( "scr_emp_timeout" );
#/
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( level.empTimeout );

	level.teamEMPing[teamName] = false;
	
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "emp_mp", teamName, killstreak_id );
	
	level.empOwners[teamName] = undefined;
	
	level notify ( "emp_update" );
	level notify ( "emp_end" + teamName );
	//SOUND - Shawn J
	//level clientnotify ("empx");
}

EMP_JamPlayers( owner, killstreak_id )
{
	level notify ( "EMP_JamPlayers" );
	level endon ( "EMP_JamPlayers" );
	overlays = [];
	
	assert( isDefined( owner ) );

	foreach ( player in level.players )
	{
		if ( player == owner )
		{
			continue;
		}
		//Eckert
		player PlayLocalSound( "mpl_killstreak_emp_blast_front" );
	}

	VisionSetNaked( "flash_grenade", 1.5 );
	thread empEffects();

	wait ( 0.1 );
	
	// resetting the vision set to the same thing won't normally have an effect.
	// however, if the client receives the previous visionset change in the same packet as this one,
	// this will force them to lerp from the bright one to the normal one.
	VisionSetNaked( "flash_grenade", 0 );
	if( IsDefined( level.nukeDetonated ) )
	{
		VisionSetNaked( level.nukeVisionSet, 5.0 );
	}
	else
	{
		VisionSetNaked( GetDvar( "mapname" ), 5.0 );
	}
	
	level notify ( "emp_update" );
	
	level.empPlayer = owner;
	level.empPlayer thread empPlayerFFADisconnect();
	level destroyActiveVehicles( owner );
	level destroyEquipment( owner );
	
	level notify ( "emp_update" );
	
/#
	level.empTimeout = GetDvarFloat( "scr_emp_timeout" );
#/
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( level.empTimeout );

	maps\mp\killstreaks\_killstreakrules::killstreakStop( "emp_mp", level.empPlayer.team, killstreak_id );
	level.empPlayer = undefined;
	level notify ( "emp_update" );
	level notify ( "emp_ended" );
	//SOUND - Shawn J
	//level clientnotify ("empx");
}

empPlayerFFADisconnect()
{
	level endon ( "EMP_JamPlayers" );	
	level endon ( "emp_ended" );
	
	self waittill( "disconnect" );
	level notify ( "emp_update" );
}

empEffects()
{
	foreach( player in level.players )
	{
		playerForward = anglestoforward( player.angles );
		playerForward = ( playerForward[0], playerForward[1], 0 );
		playerForward = VectorNormalize( playerForward );
	
		empDistance = 20000;

		empEnt = Spawn( "script_model", player.origin + ( 0, 0, 8000 ) + ( playerForward * empDistance ) );
		empEnt setModel( "tag_origin" );
		empEnt.angles = empEnt.angles + ( 270, 0, 0 );
		empEnt thread empEffect( player );
	}
}

empEffect( player )
{
	player endon( "disconnect" );

	self SetInvisibleToAll();
	self SetVisibleToPlayer( player );

	wait( 0.5 );
	PlayFXOnTag( level._effect[ "emp_flash" ], self, "tag_origin" );
	

    sound_ent = spawn( "script_origin", self.origin );
    sound_ent linkto( self, "tag_origin", (0,0,0), (0,0,0) );
    sound_ent playsound( "wpn_emp_bomb" );

	self deleteAfterTime( 11 ); // approx length of fx
	sound_ent delete ();

}

EMP_TeamTracker()
{
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		level waittill_either ( "joined_team", "emp_update" );
		
		foreach ( player in level.players )
		{
			if ( player.team == "spectator" )
				continue;
				
			emped = EMP_IsTeamEMPed(player.team);
			
			player setEMPJammed( emped );

			if ( emped )
			{
				player notify( "emp_jammed" );
				//SOUND - Shawn J
				//level clientnotify ("empo");
			}
		}
	}
}

EMP_PlayerTracker()
{
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		level waittill_either ( "joined_team", "emp_update" );
		
		foreach ( player in level.players )
		{
			if ( player.team == "spectator" )
				continue;
				
			if ( isDefined( level.empPlayer ) && level.empPlayer != player )
			{
				player setEMPJammed( true );
				player notify( "emp_jammed" );
				//SOUND - Shawn J
				//level clientnotify ("empo");
			}
			else
			{
				player setEMPJammed( false );
			}
		}
	}
}

destroyOtherTeamsEquipment( attacker, teamEMPing )
{
	foreach(team in level.teams)
	{
		if ( team == teamEMPing )
			continue;
			
		destroyEquipment( attacker, team );
	}
}

destroyEquipment( attacker, teamEMPed )
{
	grenades = GetEntArray( "grenade", "classname" );

	for( i = 0; i < grenades.size; i++ )
	{
		item = grenades[i];

		if( !IsDefined( item.name ) )
		{
			continue;
		}

		if( !IsDefined( item.owner ) )
		{
			continue;
		}

		if( IsDefined( teamEMPed ) && item.owner.team != teamEMPed ) 
		{
			continue;
		}
		else if ( item.owner == attacker )
		{
			continue;
		}

		if( !IsWeaponEquipment( item.name ) )
		{
			continue;
		}

		watcher = item.owner getWatcherForWeapon( item.name );

		if( !IsDefined( watcher ) )
		{
			continue;
		}

		watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate( item, 0.0, attacker, "emp_mp" );
	}
}

getWatcherForWeapon( weapname )
{
	if ( !IsDefined( self ) )
	{
		return undefined;
	}

	if ( !IsPlayer( self ) )
	{
		return undefined;
	}

	for ( i = 0; i < self.weaponObjectWatcherArray.size; i++ )
	{
		if ( self.weaponObjectWatcherArray[i].weapon != weapname )
		{ 
			continue;
		}

		return ( self.weaponObjectWatcherArray[i] );
	}

	return undefined;
}

destroyOtherTeamsActiveVehicles( attacker, teamEMPing )
{
	foreach(team in level.teams)
	{
		if ( team == teamEMPing )
			continue;
			
		destroyActiveVehicles( attacker, team );
	}
}

destroyActiveVehicles( attacker, teamEMPed )
{
	turrets = GetEntArray( "auto_turret", "classname" );
	destroyEntities( turrets, attacker, teamEMPed );

	targets = Target_GetArray();
	destroyEntities( targets, attacker, teamEMPed );

	rcbombs = GetEntArray( "rcbomb", "targetname" );
	destroyEntities( rcbombs, attacker, teamEMPed );

	remoteMissiles = GetEntArray( "remote_missile", "targetname" );
	destroyEntities( remoteMissiles, attacker, teamEMPed );
	
	remoteDrone = GetEntArray( "remote_drone", "targetname" );
	destroyEntities( remoteDrone, attacker, teamEMPed );
	
	if (isdefined( level.qrdrone[teamEMPed] ) )
	{
		qrdrones = [];
		qrdrones[0] = level.qrdrone[teamEMPed];
		destroyEntities( qrdrones, attacker, teamEMPed );
	}
	

	planeMortars = GetEntArray( "plane_mortar", "targetname" );
	foreach( planeMortar in planeMortars )
	{
		if ( IsDefined( teamEMPed ) && IsDefined( planeMortar.team ) )
		{
			if ( planeMortar.team != teamEMPed )
			{
				continue;
			}
		}
		else if ( planeMortar.owner == attacker )
		{
			continue;
		}

		planeMortar notify( "emp_deployed", attacker );
	}


	satellites = GetEntArray( "satellite", "targetname" );
	foreach( satellite in satellites )
	{
		if ( IsDefined( teamEMPed ) && IsDefined( satellite.team ) )
		{
			if ( satellite.team != teamEMPed )
			{
				continue;
			}
		}
		else if ( satellite.owner == attacker )
		{
			continue;
		}

		satellite notify( "emp_deployed", attacker );
	}

	if ( isdefined ( level.missile_swarm_owner ) ) 
	{
		if ( level.missile_swarm_owner isEnemyPlayer( attacker ) )
		{
			level.missile_swarm_owner notify( "emp_destroyed_missile_swarm", attacker );
		}
	}
}

destroyEntities( entities, attacker, team )
{
	meansOfDeath = "MOD_EXPLOSIVE";
	weapon = "killstreak_emp_mp";

	damage = 5000;
	direction_vec = ( 0, 0, 0 );
	point = ( 0, 0, 0 );
	modelName = "";
	tagName = "";
	partName = "";

	foreach( entity in entities )
	{
		if ( IsDefined( team ) && IsDefined( entity.team ) )
		{
			if ( entity.team != team )
			{
				continue;
			}
		}
		else if ( entity.owner == attacker )
		{
			continue;
		}

		entity notify( "damage", damage, attacker, direction_vec, point, meansOfDeath, tagName, modelName, partName, weapon );
	}
}

/#
drawEMPDamageOrigin( pos, ang, radius )
{
	while( GetDvarInt( "scr_emp_damage_debug" ) )
	{
		Line( pos, pos + ( AnglesToForward( ang ) * radius ), ( 1, 0, 0 ) );
		Line( pos, pos + ( AnglesToRight( ang ) * radius ), ( 0, 1, 0 ) );
		Line( pos, pos + ( AnglesToUp( ang ) * radius ), ( 0, 0, 1 ) );

		Line( pos, pos - ( AnglesToForward( ang ) * radius ), ( 1, 0, 0 ) );
		Line( pos, pos - ( AnglesToRight( ang ) * radius ), ( 0, 1, 0 ) );
		Line( pos, pos - ( AnglesToUp( ang ) * radius ), ( 0, 0, 1 ) );

		wait( 0.05 );
	}
}
#/

isEnemyEMPKillstreakActive()
{
	if ( (level.teamBased && maps\mp\killstreaks\_emp::EMP_IsTeamEMPed(self.team)) || (!level.teamBased && isDefined( level.empPlayer ) && level.empPlayer != self) )
	{
		return true;
	}
	return false;
}


isEmpWeapon( weaponName ) 
{
	if ( isdefined( weaponName ) && ( weaponName == "emp_mp" || weaponName == "emp_grenade_mp"  || weaponName == "emp_grenade_zm" ) )
	{
		return true;
	}
	return false;
}
