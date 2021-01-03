#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\_tacticalinsertion;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_emp;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;

#precache( "string", "KILLSTREAK_EARNED_EMP" );
#precache( "string", "KILLSTREAK_EMP_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_EMP_INBOUND" );
#precache( "eventstring", "mpl_killstreak_emp_activate" );
#precache( "fx", "_t6/weapon/emp/fx_emp_explosion" );

#namespace emp;

function init()
{
	level._effect[ "emp_flash" ] = "_t6/weapon/emp/fx_emp_explosion";

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
	
	callback::on_spawned( &on_player_spawned );

	killstreaks::register( "emp", "emp", "killstreak_emp", "emp_used",&EMP_Use );
	killstreaks::register_strings( "emp", &"KILLSTREAK_EARNED_EMP", &"KILLSTREAK_EMP_NOT_AVAILABLE", &"KILLSTREAK_EMP_INBOUND" );
	killstreaks::register_dialog( "emp", "mpl_killstreak_emp_activate", "kls_emp_used", "", "kls_emp_enemy", "", "kls_emp_ready" );
	killstreaks::register_dev_dvar( "emp", "scr_giveemp" );
	
	killstreaks::create_killstreak_timer( "emp" );
	
/#
	util::set_dvar_float_if_unset( "scr_emp_timeout", 40.0 );
	util::set_dvar_int_if_unset( "scr_emp_damage_debug", 0 );
#/
}

function on_player_spawned()
{
	self endon("disconnect");
	
	if( self killstreaks::EMP_IsEMPd() )
	{
		self setEMPJammed( true );
	}
}

function EMP_Use( lifeId )
{
	assert( isdefined( self ) );

	killstreak_id = self killstreakrules::killstreakStart( "emp", self.team, false, true );
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
	self notify( "used_emp" );
	self PlayLocalSound( "mpl_killstreak_emp_activate" );
	self killstreaks::play_killstreak_start_dialog( "emp", self.pers["team"] );
	level.globalKillstreaksCalled++;
	self AddWeaponStat( GetWeapon( "emp" ), "used", 1 );

	return true;
}


function EMP_JamOtherTeams( teamName, killstreak_id )
{
	level endon ( "game_ended" );
	overlays = [];
	
	assert( isdefined( level.teams[teamName] ) );

//	level thread popups::DisplayTeamMessageToAll( &"MP_USED_EMP", self );

	level notify ( "EMP_JamOtherTeams" + teamName );
	level endon ( "EMP_JamOtherTeams" + teamName );
	
	level.empOwners[teamName] = self;
	
	foreach ( player in level.players )
	{
		if ( player.team == teamName )
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
	if( isdefined( level.nukeDetonated ) )
	{
		VisionSetNaked( level.nukeVisionSet, 5.0 );
	}
	else
	{
		VisionSetNaked( GetDvarString( "mapname" ), 5.0 );
	}
	
	level.teamEMPing[teamName] = true;
	level notify ( "emp_update" );
	
	level destroyOtherTeamsActiveVehicles( self, teamName );
	level destroyOtherTeamsEquipment( self, teamName );

/#
	level.empTimeout = GetDvarFloat( "scr_emp_timeout" );
#/
	hostmigration::waitLongDurationWithHostMigrationPauseEMP( level.empTimeout );

	level.teamEMPing[teamName] = false;
	
	killstreakrules::killstreakStop( "emp", teamName, killstreak_id );
	
	level.empOwners[teamName] = undefined;
	
	level notify ( "emp_update" );
	level notify ( "emp_end" + teamName );
}

function EMP_JamPlayers( owner, killstreak_id )
{
	level notify ( "EMP_JamPlayers" );
	level endon ( "EMP_JamPlayers" );
	overlays = [];
	
	assert( isdefined( owner ) );

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
	if( isdefined( level.nukeDetonated ) )
	{
		VisionSetNaked( level.nukeVisionSet, 5.0 );
	}
	else
	{
		VisionSetNaked( GetDvarString( "mapname" ), 5.0 );
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
	hostmigration::waitLongDurationWithHostMigrationPause( level.empTimeout );

	killstreakrules::killstreakStop( "emp", level.empPlayer.team, killstreak_id );
	level.empPlayer = undefined;
	level notify ( "emp_update" );
	level notify ( "emp_ended" );
	//SOUND - Shawn J
	//level util::clientNotify("empx");
}

function empPlayerFFADisconnect()
{
	level endon ( "EMP_JamPlayers" );	
	level endon ( "emp_ended" );
	
	self waittill( "disconnect" );
	level notify ( "emp_update" );
}

function empEffects()
{
	foreach( player in level.players )
	{
		playerForward = anglestoforward( player.angles );
		playerForward = ( playerForward[0], playerForward[1], 0 );
		playerForward = VectorNormalize( playerForward );
	
		empDistance = 20000;

		empEnt = spawn( "script_model", player.origin + ( 0, 0, 8000 ) + ( playerForward * empDistance ) );
		empEnt setModel( "tag_origin" );
		empEnt.angles = empEnt.angles + ( 270, 0, 0 );
		empEnt thread empEffect( player );
	}
}

function empEffect( player )
{
	player endon( "disconnect" );

	self SetInvisibleToAll();
	self SetVisibleToPlayer( player );

	wait( 0.5 );
	PlayFXOnTag( level._effect[ "emp_flash" ], self, "tag_origin" );
	
    self playsound( "wpn_emp_bomb" );

	self util::deleteAfterTime( 11 ); // approx length of fx
}

function EMP_TeamTracker()
{
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		level util::waittill_either ( "joined_team", "emp_update" );
		
		foreach ( player in level.players )
		{
			if ( player.team == "spectator" )
				continue;
				
			emped = player killstreaks::EMP_IsEMPd();
			
			player setEMPJammed( emped );

			if ( emped )
			{
				player notify( "emp_jammed" );
				//SOUND - Shawn J
				//level util::clientNotify("empo");
			}
		}
	}
}

function EMP_PlayerTracker()
{
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		level util::waittill_either ( "joined_team", "emp_update" );
		
		foreach ( player in level.players )
		{
			if ( player.team == "spectator" )
				continue;
				
			if ( isdefined( level.empPlayer ) && level.empPlayer != player )
			{
				player setEMPJammed( true );
				player notify( "emp_jammed" );
				//SOUND - Shawn J
				//level util::clientNotify("empo");
			}
			else
			{
				player setEMPJammed( false );
			}
		}
	}
}

function destroyOtherTeamsEquipment( attacker, teamEMPing )
{
	foreach(team in level.teams)
	{
		if ( team == teamEMPing )
			continue;
			
		destroyEquipment( attacker, team );
		destroyTacticalInsertions( attacker, team );
	}
}

function destroyEquipment( attacker, teamEMPed )
{
	for( i = 0; i < level.missileEntities.size; i++ )
	{
		item = level.missileEntities[i];

		if ( !isdefined( item.weapon ) )
		{
			continue;
		}

		if ( !isdefined( item.owner ) )
		{
			continue;
		}

		if ( isdefined( teamEMPed ) && item.owner.team != teamEMPed ) 
		{
			continue;
		}
		else if ( item.owner == attacker )
		{
			continue;
		}

		if ( !item.weapon.isEquipment && item.weapon.name != "proximity_grenade" )
		{
			continue;
		}

		watcher = item.owner weaponobjects::getWatcherForWeapon( item.weapon );

		if ( !isdefined( watcher ) )
		{
			continue;
		}

		watcher thread weaponobjects::waitAndDetonate( item, 0.0, attacker, GetWeapon( "emp" ) );
	}
}

function destroyTacticalInsertions( attacker, victimTeam )
{
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[ i ];

		if ( !isdefined( player.tacticalInsertion ))
		{
			continue;
		}

		if ( level.teamBased && player.team != victimTeam )
		{
			continue;
		}

		if ( attacker == player )
		{
			continue;
		}

		player.tacticalInsertion thread tacticalinsertion::fizzle();
	}
}

function destroyOtherTeamsActiveVehicles( attacker, teamEMPing )
{
	foreach(team in level.teams)
	{
		if ( team == teamEMPing )
			continue;
			
		destroyActiveVehicles( attacker, team );
	}
}

function destroyActiveVehicles( attacker, teamEMPed )
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
	
	planeMortars = GetEntArray( "plane_mortar", "targetname" );
	foreach( planeMortar in planeMortars )
	{
		if ( isdefined( teamEMPed ) && isdefined( planeMortar.team ) )
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
		if ( isdefined( teamEMPed ) && isdefined( satellite.team ) )
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
		if ( level.missile_swarm_owner util::IsEnemyPlayer( attacker ) )
		{
			level.missile_swarm_owner notify( "emp_destroyed_missile_swarm", attacker );
		}
	}
}

function destroyEntities( entities, attacker, team )
{
	meansOfDeath = "MOD_EXPLOSIVE";
	weapon = GetWeapon( "killstreak_emp" );

	damage = 5000;
	direction_vec = ( 0, 0, 0 );
	point = ( 0, 0, 0 );
	modelName = "";
	tagName = "";
	partName = "";

	foreach( entity in entities )
	{
		if ( isdefined( team ) && isdefined( entity.team ) )
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
function drawEMPDamageOrigin( pos, ang, radius )
{
	while( GetDvarInt( "scr_emp_damage_debug" ) )
	{
		Line( pos, pos + ( AnglesToForward( ang ) * radius ), ( 1, 0, 0 ) );
		Line( pos, pos + ( AnglesToRight( ang ) * radius ), ( 0, 1, 0 ) );
		Line( pos, pos + ( AnglesToUp( ang ) * radius ), ( 0, 0, 1 ) );

		Line( pos, pos - ( AnglesToForward( ang ) * radius ), ( 1, 0, 0 ) );
		Line( pos, pos - ( AnglesToRight( ang ) * radius ), ( 0, 1, 0 ) );
		Line( pos, pos - ( AnglesToUp( ang ) * radius ), ( 0, 0, 1 ) );

		{wait(.05);};
	}
}
#/

function isEnemyEMPKillstreakActive()
{
	return ( self killstreaks::EMP_IsEMPd() );
}
