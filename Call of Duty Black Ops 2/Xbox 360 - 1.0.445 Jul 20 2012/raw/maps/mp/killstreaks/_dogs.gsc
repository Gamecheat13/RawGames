#include maps\mp\_utility;
#include common_scripts\utility;

#define DOG_MODEL_FRIENDLY			"german_shepherd_vest"
#define DOG_MODEL_ENEMY				"german_shepherd_vest_black"
#define DOG_SPAWN_TIME_DELAY_MIN	2
#define DOG_SPAWN_TIME_DELAY_MAX	5
#define DOG_MAX_DOG_ATTACKERS		2
#define DOG_HEALTH_REGEN_TIME		5

#define DOG_TIME					60
#define DOG_HEALTH					100
#define DOG_COUNT					8
#define DOG_COUNT_MAX_AT_ONCE		4

#define DOG_DEBUG					0
#define DOG_DEBUG_SOUND				0
#define DOG_DEBUG_ANIMS				0
#define DOG_DEBUG_ANIMS_ENT			0
#define DOG_DEBUG_TURNS				0
#define DOG_DEBUG_ORIENT			0
#define DOG_DEBUG_USAGE				0

init()
{
	PrecacheModel( DOG_MODEL_FRIENDLY );
	PrecacheModel( DOG_MODEL_ENEMY );

	level.dog_targets = [];
	level.dog_targets[ level.dog_targets.size ] = "trigger_radius";
	level.dog_targets[ level.dog_targets.size ] = "trigger_multiple";
	level.dog_targets[ level.dog_targets.size ] = "trigger_use_touch";
	
	/#
		level thread devgui_dog_think();
	#/
}

initKillstreak()
{
	// register the dog hardpoint
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "allowdogs" ) )
	{
		maps\mp\killstreaks\_killstreaks::registerKillstreak("dogs_mp", "dogs_mp", "killstreak_dogs","dogs_used", ::useKillstreakDogs, true);
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("dogs_mp", &"KILLSTREAK_EARNED_DOGS", &"KILLSTREAK_DOGS_NOT_AVAILABLE", &"KILLSTREAK_DOGS_INBOUND" );
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("dogs_mp", "mpl_killstreak_dogs", "kls_dogs_used", "","kls_dogs_enemy", "", "kls_dogs_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("dogs_mp", "scr_givedogs");
	
		maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon("dogs_mp", "dog_bite_mp" );
	}
}

useKillstreakDogs(hardpointType)
{
	if ( !dog_killstreak_init() )
		return false;

	if ( !self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) )
		return false;

	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( "dogs_mp", self.team );

	if ( killstreak_id == -1 )
		return false;
		
	if ( level.teambased )
	{
		foreach( team in level.teams )
		{
			if ( team == self.team )
				continue;
				
			thread maps\mp\gametypes\_battlechatter_mp::onKillstreakUsed( "dogs", team );
		}
	}
	
	self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "dogs_mp", self.team, true );
	//self AddPlayerStat( "DOGS_USED", 1 );
	level.globalKillstreaksCalled++;
	self AddWeaponStat( "dogs_mp", "used", 1 );

	ownerDeathCount = self.deathCount;

	level thread dog_manager_spawn_dogs( self, ownerDeathCount, killstreak_id );
	level notify( "called_in_the_dogs" );
	return true;
}

dog_killstreak_init()
{
	dog_spawner = GetEnt( "dog_spawner", "targetname" );

	if( !IsDefined( dog_spawner ) )
	{
	/#	println( "No dog spawners found in map" );	#/
		return false;
	}

	spawns = GetNodeArray( "spawn", "script_noteworthy" );	

	if ( spawns.size <= 0 )
	{
	/#	println( "No dog spawn nodes found in map" );	#/
		return false;
	}

	exits = GetNodeArray( "exit", "script_noteworthy" );	

	if ( exits.size <= 0 )
	{
	/#	println( "No dog exit nodes found in map" );	#/
		return false;
	}

	return true;
}

dog_set_model()
{
	self SetModel( DOG_MODEL_FRIENDLY );
	self SetEnemyModel( DOG_MODEL_ENEMY );
}

init_dog()
{
	assert( IsAi( self ) );

	self.targetname = "attack_dog";
	
	self.animTree = "dog.atr";
	self.type = "dog";
	self.accuracy = 0.2;
	self.health = DOG_HEALTH;
	self.maxhealth = DOG_HEALTH;  // this currently does not hook to code maxhealth
	self.aiweapon = "dog_bite_mp";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeAmmo = 0;
	self.goalradius = 128;
	self.noDodgeMove = true;
	self.ignoreSuppression = true;
	self.suppressionThreshold = 1;
	self.disableArrivals = false;
	self.pathEnemyFightDist = 512;
	self.soundMod = "dog";

	self.meleeAttackDist = 80; 

	self thread dog_health_regen();
	self thread selfDefenseChallenge();
}

get_spawn_node( owner, team )
{
	spawns = GetNodeArray( "spawn", "script_noteworthy" );

	if ( !level.teamBased )
	{
		return getClosest( owner.origin, spawns );
	}

	best_node = spawns[0];
	best_score = -999;

	foreach( spawn in spawns )
	{
		score = get_score_for_spawn( spawn.origin, team );

		if ( score > best_score )
		{
			best_node = spawn;
			best_score = score;
		}
	}

	//bbPrint( "mpdogspawnused", "x %f y %f z %f weight %f num_players %i num_dogs %i dist_all %f dist_allies %f dist_axis %f dist_dogs %f", node.origin, node.weight, node.numPlayersAtLastUpdate, node.numDogsAtLastUpdate, node.distSum["all"], node.distSum["allies"], node.distSum["axis"], node.distSum["dogs"] );
	return best_node;
}

get_score_for_spawn( origin, team )
{
	players = GET_PLAYERS();
	score = 0;

	foreach( player in players )
	{
		if ( !IsDefined( player ) )
		{
			continue;
		}

		if ( !IsAlive( player ) )
		{
			continue;
		}

		if ( player.sessionstate != "playing" )
		{
			continue;
		}

		if ( DistanceSquared( player.origin, origin ) > 2048 * 2048 )
		{
			continue;
		}

		if ( player.team == team )
		{
			score++;
		}
		else
		{
			score--;
		}
	}

	return score;
}

dog_set_owner( owner, team, requiredDeathCount )
{
	self SetEntityOwner( owner );
	self.aiteam = team;

	self.requiredDeathCount = requiredDeathCount;
}

dog_create_spawn_influencer()
{
	self maps\mp\gametypes\_spawning::create_dog_influencers();
}

dog_manager_spawn_dog( owner, team, spawn_node, requiredDeathCount )
{
	dog_spawner = GetEnt( "dog_spawner", "targetname" );
	
	dog = dog_spawner SpawnActor();
	dog ForceTeleport( spawn_node.origin, spawn_node.angles );
	
	dog init_dog();
	dog dog_set_owner( owner, team, requiredDeathCount );
	dog dog_set_model();
	dog dog_create_spawn_influencer();
	
	dog thread dog_owner_kills();
	dog thread dog_notify_level_on_death();
	dog thread dog_patrol();
	dog thread maps\mp\gametypes\_weapons::monitor_dog_special_grenades();

	return dog;
}

dog_manager_spawn_dogs( owner, deathCount, killstreak_id )
{
	requiredDeathCount = deathCount;
	team = owner.team;
	
	level.dog_abort = false;
	owner thread dog_manager_abort();
	level thread dog_manager_game_ended();

	for ( count = 0; count < DOG_COUNT; )
	{
		if ( level.dog_abort )
		{
			break;
		}

		dogs = dog_manager_get_dogs();

		while ( dogs.size < DOG_COUNT_MAX_AT_ONCE && count < DOG_COUNT && !level.dog_abort )
		{
			node = get_spawn_node( owner, team );
			level dog_manager_spawn_dog( owner, team, node, requiredDeathCount );
			count++;

			wait ( randomfloatrange( DOG_SPAWN_TIME_DELAY_MIN, DOG_SPAWN_TIME_DELAY_MAX ) );
			dogs = dog_manager_get_dogs();
		}

		level waittill( "dog_died" );
	}

	for ( ;; )
	{
		dogs = dog_manager_get_dogs();

		if ( dogs.size <= 0 )
		{
			maps\mp\killstreaks\_killstreakrules::killstreakStop( "dogs_mp", team, killstreak_id );
			return;
		}

		level waittill( "dog_died" );
	}
}

dog_abort()
{
	level.dog_abort = true;

	dogs = dog_manager_get_dogs();

	foreach( dog in dogs )
	{
		dog notify( "abort" );
	}
	
	level notify( "dog_abort" );
}

dog_manager_abort()
{
	level endon( "dog_abort" );
	self wait_endon( DOG_TIME, "disconnect", "joined_team", "joined_specators" );
	dog_abort();
}

dog_manager_game_ended()
{
	level endon( "dog_abort" );

	level waittill( "game_ended" );
	dog_abort();
}

dog_notify_level_on_death()
{
	self waittill( "death" );
	level notify( "dog_died" );
}

dog_leave()
{
	// have them run to an exit node
	self clearentitytarget();
	self.ignoreall = true;
	self.goalradius = 30;
	self setgoalnode( self dog_get_exit_node() );
	
	self wait_endon( 20, "goal", "bad_path" );
	self delete();
}

dog_patrol()
{
	self endon( "death" );
/#
	self endon( "debug_patrol" );
#/

	for ( ;; )
	{
		if ( level.dog_abort )
		{
			self dog_leave();
			return;
		}

		if ( IsDefined( self.enemy ) )
		{
			wait( RandomIntRange( 3, 5 ) );
			continue;
		}

		nodes = [];

		objectives = dog_patrol_near_objective();

		for ( i = 0; i < objectives.size; i++ )
		{
			objective = random( objectives );

			nodes = GetNodesInRadius( objective.origin, 256, 64, 512, "Path", 16 );

			if ( nodes.size )
			{
				break;
			}
		}
		
		if ( !nodes.size )
		{
			player = self dog_patrol_near_enemy();

			if ( IsDefined( player ) )
			{
				nodes = GetNodesInRadius( player.origin, 1024, 0, 128, "Path", 8 );
			}
		}

		if ( !nodes.size && IsDefined( self.script_owner ) )
		{
			if ( IsAlive( self.script_owner ) && self.script_owner.sessionstate == "playing" )
			{
				nodes = GetNodesInRadius( self.script_owner.origin, 512, 256, 512, "Path", 16 );
			}
		}

		if ( !nodes.size )
		{
			nodes = GetNodesInRadius( self.origin, 1024, 512, 512, "Path" );
		}

		if ( nodes.size )
		{
			nodes = array_randomize( nodes );

			foreach( node in nodes )
			{
				if ( IsDefined( node.script_noteworthy ) )
				{
					continue;
				}

				if ( IsDefined( node.dog_claimed ) && IsAlive( node.dog_claimed ) )
				{
					continue;
				}

				self SetGoalNode( node );
				node.dog_claimed = self;

				nodes = [];
				event = self waittill_any_return( "goal", "bad_path", "enemy", "abort" );

				if ( event == "goal" )
				{
					wait_endon( RandomIntRange( 3, 5 ), "damage", "enemy", "abort" );
				}

				node.dog_claimed = undefined;
				break;
			}
		}

		wait( 0.5 );
	}
}

dog_patrol_near_objective()
{
	if ( !IsDefined( level.dog_objectives ) )
	{
		level.dog_objectives = [];
		level.dog_objective_next_update = 0;
	}

	if ( level.gameType == "tdm" || level.gameType == "dm" )
	{
		return level.dog_objectives;
	}
	
	if ( GetTime() >= level.dog_objective_next_update )
	{
		level.dog_objectives = [];

		foreach( target in level.dog_targets )
		{
			ents = GetEntArray( target, "classname" );

			foreach( ent in ents )
			{
				if ( level.gameType == "koth" )
				{
					if ( IsDefined( ent.targetname ) && ent.targetname == "radiotrigger" )
					{
						level.dog_objectives[ level.dog_objectives.size ] = ent;
					}

					continue;
				}

				if ( level.gameType == "sd" )
				{
					if ( IsDefined( ent.targetname ) && ent.targetname == "bombzone" )
					{
						level.dog_objectives[ level.dog_objectives.size ] = ent;
					}

					continue;
				}

				if ( !IsDefined( ent.script_gameobjectname ) )
				{
					continue;
				}

				if ( !IsSubStr( ent.script_gameobjectname, level.gameType ) )
				{
					continue;
				}

				level.dog_objectives[ level.dog_objectives.size ] = ent;
			}
		}

		level.dog_objective_next_update = GetTime() + RandomIntRange( 5000, 10000 );
	}

	return level.dog_objectives;
}

dog_patrol_near_enemy()
{
	players = GET_PLAYERS();
	
	closest = undefined;
	distSq = 99999999;
	
	foreach( player in players )
	{
		if ( !IsDefined( player ) )
		{
			continue;
		}

		if ( !IsAlive( player ) )
		{
			continue;
		}

		if ( player.sessionstate != "playing" )
		{
			continue;
		}

		if ( IsDefined( self.script_owner ) && player == self.script_owner )
		{
			continue;
		}

		if ( level.teambased )
		{
			if ( player.team == self.aiteam )
			{
				continue;
			}
		}

		if ( GetTime() - player.lastFireTime > 3000 )
		{
			continue;
		}

		if ( !IsDefined( closest ) )
		{
			closest = player;
			distSq = DistanceSquared( self.origin, player.origin );
			continue;
		}

		d = DistanceSquared( self.origin, player.origin );

		if ( d < distSq )
		{
			closest = player;
			distSq = d;
		}
	}

	return closest;
}

dog_manager_get_dogs()
{
	dogs = GetEntArray( "attack_dog", "targetname" );
	return dogs;
}

dog_owner_kills()
{
	if ( !isdefined( self.script_owner ) )
		return;
		
	self endon("clear_owner");
	self endon("death");
	self.script_owner endon("disconnect");
	
	while(1)
	{
		self waittill("killed", player);
		self.script_owner notify( "dog_handler" );
	}	
}

dog_health_regen()
{
	self endon( "death" );

	interval = 0.5;
	regen_interval = Int( ( self.health / DOG_HEALTH_REGEN_TIME ) * interval );
	regen_start = 2;

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName, iDFlags );
		self trackAttackerDamage( attacker, weaponName );
		
		self thread dog_health_regen_think( regen_start, interval, regen_interval );
	}
}

trackAttackerDamage( attacker, weapon )
{
	if ( !isDefined( attacker ) || !isPlayer( attacker ) || !isdefined( self.script_owner ) )
	{
		return;
	}
	
	if ( ( level.teambased && attacker.team == self.script_owner.team ) || attacker == self ) 
	{
		return;
	}

	if ( !isdefined( self.attackerData ) || !isdefined( self.attackers ) ) 
	{
		self.attackerData = [];
		self.attackers = [];
	}
	if ( !isdefined( self.attackerData[attacker.clientid] ) )
	{
		self.attackerClientID[attacker.clientid] = spawnstruct();
		self.attackers[ self.attackers.size ] = attacker;
	}
}

resetAttackerDamage()
{
	self.attackerData = [];
	self.attackers = [];
}

dog_health_regen_think( delay, interval, regen_interval )
{
	self endon( "death" );
	self endon( "damage" );

	wait( delay );

	for ( step = 0; step <= DOG_HEALTH_REGEN_TIME; step += interval )
	{
		if ( self.health >= DOG_HEALTH )
		{
			break;
		}

		self.health += regen_interval;
		wait( interval );
	}

	self resetAttackerDamage();
	self.health = DOG_HEALTH;
}

selfDefenseChallenge()
{
	self waittill ("death", attacker);

	if ( isdefined( attacker ) && isPlayer( attacker ) )
	{
		if (isdefined ( self.script_owner ) && self.script_owner == attacker)
			return;
		if ( level.teambased && isdefined ( self.script_owner ) && self.script_owner.team == attacker.team )
			return;

		if ( isdefined( self.attackers ) )
		{
			foreach ( player in self.attackers )
			{
				if ( player != attacker )
				{
					maps\mp\_scoreevents::processScoreEvent( "killed_dog_assist", player );
				}
			}
		}
		attacker notify ("selfdefense_dog");	
	}
		
}

dog_get_exit_node()
{
	exits = GetNodeArray( "exit", "script_noteworthy" );
	return getclosest( self.origin, exits );
}

flash_dogs( area )
{
	self endon("disconnect");

	dogs = dog_manager_get_dogs();

	foreach( dog in dogs )
	{
		if ( !isalive(dog) )
			continue;

		if ( dog istouching(area) )
		{
			do_flash = true;
			if ( isPlayer( self ) )
			{
				if ( level.teamBased && (dog.aiteam == self.team) )
				{
					do_flash = false;
				}
				else if ( !level.teambased && isdefined(dog.script_owner) && self == dog.script_owner )
				{
					do_flash = false;
				}
			}

			if ( isdefined( dog.lastFlashed ) && dog.lastFlashed + 1500 > gettime()  )
			{	
				do_flash = false;
			}

			if ( do_flash )
			{
				dog setFlashBanged( true, 500 );
				dog.lastFlashed = gettime();
			}
		}	
	}
}

/#

devgui_dog_think()
{
	SetDvar( "devgui_dog", "" );

	debug_patrol = false;

	for( ;; )
	{
		cmd = getDvar( "devgui_dog" );

		switch( cmd )
		{
		case "spawn_friendly":	
			player = getHostPlayer();
			devgui_dog_spawn( player.team );
			break;

		case "spawn_enemy":	
			player = getHostPlayer();
			foreach( team in level.teams )
			{
				if ( team == player.team )
					continue;
				
				devgui_dog_spawn( team );
			}
			break;

		case "delete_dogs":
			level dog_abort();
			break;

		case "dog_camera":
			devgui_dog_camera();
			break;

		case "spawn_crate":
			devgui_crate_spawn();
			break;

		case "delete_crates":
			devgui_crate_delete();
			break;

		case "show_spawns":
			devgui_spawn_show();
			break;
		
		case "show_exits":
			devgui_exit_show();
			break;

		case "debug_route":
			devgui_debug_route();
			break;
		}

		if ( cmd != "" )
		{
			SetDvar( "devgui_dog", "" );
		}

		wait( 0.5 );
	}
}

devgui_dog_spawn( team )
{
	player = getHostPlayer();

	dog_spawner = GetEnt( "dog_spawner", "targetname" );
	level.dog_abort = false;
	
	if( !IsDefined( dog_spawner ) )
	{
		iprintln( "No dog spawners found in map" );
		return;
	}

	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );

	nodes = GetNodesInRadius( trace["position"], 256, 0, 128, "Path", 8 ); 

	if ( !nodes.size )
	{
		iprintln( "No nodes found near crosshair position" );
		return;
	}

	iprintln( "Spawning dog at your crosshair position" );
	node = getclosest( trace["position"], nodes );
	
	dog = dog_manager_spawn_dog( player, player.team, node, 5 );

	if ( team != player.team )
	{
		dog.aiteam = team;
		dog ClearEntityOwner();
		dog notify ( "clear_owner" );
	}
}

devgui_dog_camera()
{
	player = getHostPlayer();

	if ( !IsDefined( level.devgui_dog_camera ) )
	{
		level.devgui_dog_camera = 0;
	}

	dog = undefined;
	dogs = dog_manager_get_dogs();

	if ( dogs.size <= 0 )
	{
		level.devgui_dog_camera = undefined;
		player CameraActivate( false );	
		return;
	}
	
	for ( i = 0; i < dogs.size; i++ )
	{
		dog = dogs[i];

		if ( !IsDefined( dog ) || !IsAlive( dog ) )
		{
			dog = undefined;
			continue;
		}

		if ( !IsDefined( dog.cam ) )
		{
			forward = AnglesToForward( dog.angles );
			dog.cam = Spawn( "script_model", dog.origin + ( 0, 0, 50 ) + forward * -100 );
			dog.cam SetModel( "tag_origin" );
			dog.cam LinkTo( dog );
		}

		if ( dog GetEntityNumber() <= level.devgui_dog_camera )
		{
			dog = undefined;
			continue;
		}

		break;
	}
	
	if ( IsDefined( dog ) )
	{
		level.devgui_dog_camera = dog GetEntityNumber();
		
		player CameraSetPosition( dog.cam );
		player CameraSetLookAt( dog );
		player CameraActivate( true );	
	}
	else
	{
		level.devgui_dog_camera = undefined;
		player CameraActivate( false );	
	}
}

devgui_crate_spawn()
{
	player = getHostPlayer();

	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );

	killCamEnt = spawn( "script_model", player.origin );
	level thread maps\mp\killstreaks\_supplydrop::dropCrate( trace[ "position" ] + ( 0, 0, 25 ), direction, "supplydrop_mp", player, player.team, killcamEnt );
}

devgui_crate_delete()
{
	if ( !IsDefined( level.devgui_crates ) )
	{
		return;
	}

	for ( i = 0; i < level.devgui_crates.size; i++ )
	{
		level.devgui_crates[i] delete();
	}

	level.devgui_crates = [];
}

devgui_spawn_show()
{
	if ( !IsDefined( level.dog_spawn_show ) )
	{
		level.dog_spawn_show = true;
	}
	else
	{
		level.dog_spawn_show = !level.dog_spawn_show;
	}

	if ( !level.dog_spawn_show )
	{
		level notify( "hide_dog_spawns" );
		return;
	}

	spawns = GetNodeArray( "spawn", "script_noteworthy" );
	color = ( 0, 1, 0 );

	for ( i = 0; i < spawns.size; i++ )
	{
		maps\mp\gametypes\_dev::showOneSpawnPoint( spawns[i], color, "hide_dog_spawns", 32, "dog_spawn" );
	}
}

devgui_exit_show()
{
	if ( !IsDefined( level.dog_exit_show ) )
	{
		level.dog_exit_show = true;
	}
	else
	{
		level.dog_exit_show = !level.dog_exit_show;
	}

	if ( !level.dog_exit_show )
	{
		level notify( "hide_dog_exits" );
		return;
	}

	exits = GetNodeArray( "exit", "script_noteworthy" );
	color = ( 1, 0, 0 );

	for ( i = 0; i < exits.size; i++ )
	{
		maps\mp\gametypes\_dev::showOneSpawnPoint( exits[i], color, "hide_dog_exits", 32, "dog_exit" );
	}
}

dog_debug_patrol( node1, node2 )
{
	self endon( "death" );
	self endon( "debug_patrol" );

	for( ;; )
	{
		self SetGoalNode( node1 );
		self waittill_any( "goal", "bad_path" );
		wait( 1 );

		self SetGoalNode( node2 );
		self waittill_any( "goal", "bad_path" );
		wait( 1 );
	}
}

devgui_debug_route()
{
	iprintln( "Choose nodes with 'A' or press 'B' to cancel" );
	nodes = maps\mp\gametypes\_dev::dev_get_node_pair();
	
	if ( !IsDefined( nodes ) )
	{
		iprintln( "Route Debug Cancelled" );
		return;
	}

	iprintln( "Sending dog to chosen nodes" );
	dogs = dog_manager_get_dogs();

	if ( IsDefined( dogs[0] ) )
	{
		dogs[0] notify( "debug_patrol" );
		dogs[0] thread dog_debug_patrol( nodes[0], nodes[1] );
	}
}

#/
